-- killaura v6 | instant-impact | predict | no-fallback | no-wall-check | no-freeze | clean
--[[
    BRM5KillAura — v3 (Flux rewrite)

    Fixes vs v2:
    1) isLocalAlive() теперь читает ReplicatorService.LocalActor.Alive / .Health
       вместо Humanoid.Health — устранён вечный dead-phase в Flux-играх.
    2) Bridge.isActorDead() пропатчен: Flux хранит Actor.Alive (заглавная),
       library.lua проверяет data.alive (строчная) — case mismatch исправлен.
    3) getFluxLocalActor() — надёжный резолв LocalActor через Bridge + getgc.
    4) Все остальные механики (svc bootstrap, swing, fallback, viz) сохранены.
]]
return function(Lib)
local Bridge = Lib.Bridge
local CONFIG  = Lib.CONFIG
local State   = Lib.State

-- ══════════════════════════════════════════════════════════════
-- [FLUX FIX #1] Bridge.isActorDead: library проверяет data.alive (lower),
-- Flux ActorClass хранит data.Alive (upper) → всё инвертировано.
-- Патчим сразу после получения Bridge, до любого использования.
-- ══════════════════════════════════════════════════════════════
do
    local _origDead = Bridge.isActorDead
    Bridge.isActorDead = function(data)
        if type(data) ~= "table" then
            return _origDead and _origDead(data) or false
        end
        -- Flux ActorClass: прямые поля (заглавные)
        local fluxAlive  = rawget(data, "Alive")
        local fluxHealth = rawget(data, "Health")
        if fluxAlive == false then return true end
        if type(fluxHealth) == "number" and fluxHealth <= 0 then return true end
        -- actorData вложенный (library-трекер)
        local ad = rawget(data, "actorData") or rawget(data, "_actorData")
        if type(ad) == "table" then
            if rawget(ad, "Alive") == false    then return true end
            if rawget(ad, "Dead")  == true     then return true end
            local hp = rawget(ad, "Health")
            if type(hp) == "number" and hp <= 0 then return true end
        end
        -- фолбэк на оригинал (проверит data.alive строчную, model, etc.)
        return _origDead and _origDead(data) or false
    end
end

local UIS       = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Players   = game:GetService("Players")
local RunService  = Bridge._RunService
local getCamera   = Bridge._getCamera
local log         = Bridge._log

local newcclosure = newcclosure
local hookfunction = hookfunction
local getgc = getgc

local KA_CONFIG = {
    KillAura                    = true,
    KillAuraAuto                = true,
    KillAuraDistance            = 30,
    KillAuraFOV                 = 360,
    KillAuraPreferPlayers       = true,
    KillAuraBloodEffects        = true,
    KillAuraClientHitFx         = true,
    KillAuraForceHit            = true,
    -- [v5] Bypass client-side distance check
    KillAuraBypassDistance      = true,   -- растягивать reach до реальной дистанции до цели
    KillAuraBypassDistanceMax   = 999,    -- максимальный override reach (юнитов)
    -- [v5] Hitbox target bone — форсировать конкретную часть тела
    KillAuraForceBone           = "Head", -- "Head" / "UpperTorso" / "LowerTorso" / nil (авто)
    KillAuraForceHeadshot       = true,   -- всегда бить в голову (клиент + сервер)
    KillAuraTickInterval        = 0.2,
    KillAuraPickInterval        = 0.25,
    KillAuraCtxCacheSec         = 1.5,
    -- v5: не зависим от оружейных характеристик — жёсткие константы
    KillAuraReach               = 999,   -- bypass distance: reach при отправке Impact вектора
    KillAuraSwingCd             = 0.35,  -- cooldown между ударами (наш, не из оружия)
    -- v5: predict — смещение позиции цели вперёд по velocity
    KillAuraPredictMs           = 80,    -- упреждение в мс (0 = выкл)
    -- v5: bypass wall check — отключить LOS проверку
    KillAuraNoWallCheck         = true,
    KillAuraDebugKey = Enum.KeyCode.H,
    KillAuraViz      = true,
}
for k, v in pairs(KA_CONFIG) do CONFIG[k] = v end

local KA_CHAR_GRACE = 0.3
local kaConn, kaVizConn, kaInputConn, kaCharConn
local kaVizLine, kaVizCircle, kaVizLabel
local kaCharGraceUntil = 0
local kaLastPickT, kaLastDiagT, kaLastPrepT, kaLastFullCtxT = 0, 0, 0, 0
local kaActionTypeInv, kaSharedMeleeCfg

-- кэш LocalActor для getFluxLocalActor
local _fluxActorCache      = nil
local _fluxActorCacheTime  = 0
local FLUX_ACTOR_CACHE_TTL = 0.5  -- секунд

local function now() return os.clock() end

local function setPhase(phase, skip)
    State.kaLastPhase = phase
    if skip ~= nil then State.kaLastSkip = skip end
end

local function clearKaTarget()
    State.kaTarget     = nil
    State.kaTargetUid  = nil
    State.kaAimPart    = nil
    State.kaAimPoint   = nil
    State.kaTargetTime = 0
end

local function releaseSwingState()
    State.kaSwingBusy   = false
    State.kaImpactSteer = false
    State.kaImpactPart  = nil
    State.kaImpactUid   = nil
end

local function clearMeleeBoot()
    State.kaCtx            = nil
    State.kaCtxEq          = nil
    State.kaCtxTime        = 0
    State.kaMeleeSvc       = nil
    State.kaBootEq         = nil
    State.kaUseEnv         = nil
    State.kaSvcSrc         = nil
    State.kaWarmupDone     = false
    State.kaWarmupEq       = nil
    State.kaWarmupBusy     = false
    State.kaModsAppliedEq  = nil
    State.kaGcScanEq       = nil
    State.kaUseThreadActive = false
    State.kaUseThreadSince  = 0
    -- сбрасываем кэш LocalActor при смене оружия / рестарте
    _fluxActorCache     = nil
    _fluxActorCacheTime = 0
end

local function getHandlerMethod(handler, name)
    if type(handler) ~= "table" or type(name) ~= "string" then return nil end
    local direct = rawget(handler, name)
    if type(direct) == "function" then return direct end
    local mt = getmetatable(handler)
    if type(mt) == "table" then
        local fn = rawget(mt, name)
        if type(fn) == "function" then return fn end
        local idx = rawget(mt, "__index")
        if type(idx) == "table" then
            local fn2 = rawget(idx, name)
            if type(fn2) == "function" then return fn2 end
        end
    end
    local ok, fn = pcall(function() return handler[name] end)
    if ok and type(fn) == "function" then return fn end
    return nil
end

local function actorUidOf(actor)
    if type(actor) ~= "table" then return nil end
    return rawget(actor, "UID") or rawget(actor, "_uid")
end

local function normalizeEqUid(eq)
    if eq == nil then return nil end
    return tostring(eq)
end

-- ══════════════════════════════════════════════════════════════
-- [FLUX FIX #2] getFluxLocalActor — резолвит LocalActor из
-- ReplicatorService. Именно здесь хранятся Alive и Health.
-- Humanoid в Flux-играх НЕ является источником истины.
-- ══════════════════════════════════════════════════════════════
local function getFluxLocalActor()
    local t = now()
    if _fluxActorCache ~= nil and t - _fluxActorCacheTime < FLUX_ACTOR_CACHE_TTL then
        return _fluxActorCache
    end

    local found = nil

    -- Вариант 1: через Bridge.resolveLocalActor (самый надёжный)
    if Bridge.resolveLocalActor then
        local ok, _, a = pcall(Bridge.resolveLocalActor, false)
        if ok and type(a) == "table" and rawget(a, "Alive") ~= nil then
            found = a
        end
    end

    -- Вариант 2: через State.localClient -> getActorTable
    if not found then
        local client = State.localClient
        if client and Bridge.getActorTable then
            local a = Bridge.getActorTable(client)
            if type(a) == "table" and rawget(a, "Alive") ~= nil then
                found = a
            end
        end
    end

    -- Вариант 3: getgc УДАЛЁН — вызывал lag spike при экипировке оружия (итерация всего gc heap)

    _fluxActorCache     = found
    _fluxActorCacheTime = t
    return found
end

-- ══════════════════════════════════════════════════════════════
-- [FLUX FIX #3] isLocalAlive: читаем Actor.Alive / Actor.Health
-- вместо Humanoid.Health
-- ══════════════════════════════════════════════════════════════
local function isLocalAlive()
    if now() < kaCharGraceUntil then return true end

    -- Приоритет 1: Flux ActorClass
    local fluxActor = getFluxLocalActor()
    if fluxActor ~= nil then
        local alive  = rawget(fluxActor, "Alive")
        local health = rawget(fluxActor, "Health")
        -- alive == false → точно мёртв
        if alive == false then return false end
        -- health <= 0 → мёртв (ActorClass.Update ставит Alive=false при health<=0,
        -- но между репликациями может быть рассинхрон)
        if type(health) == "number" and health <= 0 then return false end
        -- alive == true → живой (не трогаем Humanoid)
        if alive == true then return true end
        -- alive == nil: ещё не реплицировалось — продолжаем на фолбэк
    end

    -- Фолбэк: Humanoid (для игр без Flux, или до первой репликации)
    local lp   = Players.LocalPlayer
    local char = lp and lp.Character
    if not char or not char.Parent then return false end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    if hum then return hum.Health > 0 end
    return true
end

local function onLifeState()
    if not isLocalAlive() then
        if not State.kaWasDead then
            State.kaWasDead = true
            clearKaTarget()
            releaseSwingState()
            clearMeleeBoot()
        end
        return false
    end
    if State.kaWasDead then
        State.kaWasDead = false
        clearMeleeBoot()
        releaseSwingState()
        pcall(function()
            if Bridge.resolveLocalActor then Bridge.resolveLocalActor(true) end
        end)
    end
    return true
end

local function kaLosOrigin(actor)
    if type(actor) == "table" then
        local cf = rawget(actor, "CFrame")
        if typeof(cf) == "CFrame" then return cf.Position end
    end
    local cam = getCamera()
    if cam then return cam.CFrame.Position end
    if Bridge.getAimLosOrigin then return Bridge.getAimLosOrigin() end
    return Vector3.zero
end

local function kaDist()
    local d = CONFIG.KillAuraDistance
    return (type(d) == "number" and d > 0) and d or 30
end

local function actorsMatch(a, b)
    if a == b then return true end
    if type(a) ~= "table" or type(b) ~= "table" then return false end
    local ua, ub = actorUidOf(a), actorUidOf(b)
    if ua ~= nil and ub ~= nil then return tostring(ua) == tostring(ub) end
    return false
end

local function getEquippedRep(actor)
    if type(actor) ~= "table" then return nil end
    local eq  = rawget(actor, "_equipped")
    local inv = rawget(actor, "_inventory")
    if not eq or type(inv) ~= "table" then return nil end
    local function hasImpact(v)
        return getHandlerMethod(v, "Impact") ~= nil
    end
    local h = inv[eq] or inv[tonumber(eq)]
    if hasImpact(h) then return h end
    for _, v in pairs(inv) do
        if hasImpact(v) then return v end
    end
    return nil
end

local function peekLocalActorLight()
    if not isLocalAlive() then return nil, nil end
    local client = State.localClient
    if client and Bridge.getActorTable then
        local actor = Bridge.getActorTable(client)
        if type(actor) == "table" then return client, actor end
    end
    if Bridge.resolveLocalActor then return Bridge.resolveLocalActor(false) end
    return nil, nil
end

local function resolveActor(ctx)
    if ctx and type(ctx.actor) == "table" and getEquippedRep(ctx.actor) then
        return ctx.actor
    end
    local _, a = peekLocalActorLight()
    if a and getEquippedRep(a) then return a end
    if Bridge.resolveLocalActor then
        local _, a2 = Bridge.resolveLocalActor(false)
        if a2 then return a2 end
    end
    return ctx and ctx.actor or nil
end

local function refreshTeamAndRep(force)
    local t = now()
    if not force and t - kaLastPrepT < 0.35 then return end
    kaLastPrepT = t
    if Bridge.refreshLocalTeamKey then pcall(Bridge.refreshLocalTeamKey) end
    if Bridge.tickRepSyncBatch then pcall(Bridge.tickRepSyncBatch, force and 18 or 10) end
end

local function kaRefPos(data)
    if not data then return nil end
    if data.inInactiveWorld and typeof(data.adPos) == "Vector3" then return data.adPos end
    local ad = data.actorData
    if type(ad) == "table" then
        local p = rawget(ad, "SimulatedPosition") or rawget(ad, "ServerPosition") or rawget(ad, "Position")
        if typeof(p) == "Vector3" then return p end
    end
    -- Flux ActorClass прямые поля позиции
    local sp = rawget(data, "SimulatedPosition") or rawget(data, "ServerPosition") or rawget(data, "Position")
    if typeof(sp) == "Vector3" then return sp end
    local root = data.root
    if root and root.Parent and root:IsA("BasePart") then return root.Position end
    if data.model and data.model.Parent then
        local p = data.model:FindFirstChild("HumanoidRootPart")
            or data.model:FindFirstChild("UpperTorso")
            or data.model:FindFirstChild("Head")
        if p and p:IsA("BasePart") then return p.Position end
    end
    return nil
end

local function resolveAim(data)
    if not data then return nil, nil end
    local point = kaRefPos(data)
    local part  = (Bridge.getSilentAimPart and Bridge.getSilentAimPart(data)) or data.root
    if part and part:IsA("BasePart") and part.Parent and typeof(point) == "Vector3" then
        return part, point
    end
    if typeof(point) == "Vector3" and data.model and data.model.Parent then
        local p = data.model:FindFirstChild("Head")
            or data.model:FindFirstChild("UpperTorso")
            or data.model:FindFirstChild("HumanoidRootPart")
            or data.root
        if p and p:IsA("BasePart") then return p, point end
    end
    if typeof(point) == "Vector3" then return part, point end
    return nil, nil
end

local function buildTargetPool(actor)
    local losOrigin = kaLosOrigin(actor)
    local maxDist   = kaDist()
    local pool = {}
    if Bridge.collectAimActorCandidates and getCamera() then
        local ok, result = pcall(Bridge.collectAimActorCandidates, getCamera(), losOrigin, maxDist,
            math.min((CONFIG.KillAuraFOV or 360) * 0.5, 179))
        if ok and type(result) == "table" and #result > 0 then
            return result, "ka.aim"
        end
    end
    for _, data in pairs(State.actors or {}) do
        if Bridge.isEnemyActor and not Bridge.isEnemyActor(data) then continue end
        if Bridge.isActorDead   and Bridge.isActorDead(data)     then continue end
        local pos = kaRefPos(data)
        if typeof(pos) ~= "Vector3" then continue end
        -- v5: BypassDistance — добавляем всех живых врагов без ограничения дистанции
        if CONFIG.KillAuraBypassDistance then
            pool[#pool + 1] = data
        elseif (pos - losOrigin).Magnitude <= maxDist then
            pool[#pool + 1] = data
        end
    end
    return pool, (#pool > 0 and "ka.state" or "ka.empty")
end

local function commitPick(best, part, point, source)
    State.kaTarget       = best
    State.kaTargetUid    = best and best.uid or nil
    State.kaAimPart      = part
    State.kaAimPoint     = point
    State.kaTargetTime   = now()
    State.kaLastPickSource = source
    kaLastPickT = now()
    return best, part, point
end

local function pickTarget(force, actor)
    local iv = CONFIG.KillAuraPickInterval or 0.25
    if not force and State.kaTarget and typeof(State.kaAimPoint) == "Vector3"
        and now() - kaLastPickT < iv then
        return State.kaTarget, State.kaAimPart, State.kaAimPoint
    end
    refreshTeamAndRep(force)
    clearKaTarget()
    local pool, source = buildTargetPool(actor)
    if #pool == 0 then
        State.kaLastPickSource = source
        return nil, nil, nil
    end
    local losOrigin = kaLosOrigin(actor)
    local best, bestPart, bestPoint, bestDist
    for _, data in ipairs(pool) do
        local part, point = resolveAim(data)
        if typeof(point) ~= "Vector3" then continue end
        local d = (point - losOrigin).Magnitude
        -- v5: bypass distance — не фильтруем по kaDist()
        local inRange = CONFIG.KillAuraBypassDistance or d <= kaDist()
        if inRange and (best == nil or d < bestDist) then
            best, bestPart, bestPoint, bestDist = data, part, point, d
        end
    end
    if not best then
        State.kaLastPickSource = source .. ":filtered"
        return nil, nil, nil
    end
    return commitPick(best, bestPart, bestPoint, source)
end

local function validateTarget(actor)
    local target = State.kaTarget
    if not target then return false end
    if Bridge.isEnemyActor and not Bridge.isEnemyActor(target) then clearKaTarget() return false end
    if Bridge.isActorDead   and Bridge.isActorDead(target)     then clearKaTarget() return false end
    local pos = kaRefPos(target) or (State.kaAimPart and State.kaAimPart.Position) or State.kaAimPoint
    if typeof(pos) ~= "Vector3" then clearKaTarget() return false end
    -- v5: bypass distance
    if not CONFIG.KillAuraBypassDistance and (pos - kaLosOrigin(actor)).Magnitude > kaDist() + 1 then
        clearKaTarget() return false
    end
    local part, point = resolveAim(target)
    State.kaAimPart  = part  or State.kaAimPart
    State.kaAimPoint = point or pos
    return true
end

local function resolveMeleeContext(force)
    if not isLocalAlive() and force ~= true then return nil end
    local _, actor
    if force and Bridge.resolveLocalActor then
        _, actor = Bridge.resolveLocalActor(true)
    else
        _, actor = peekLocalActorLight()
    end
    if not actor then
        clearMeleeBoot()
        return nil
    end
    local eqStr = normalizeEqUid(rawget(actor, "_equipped")) or ""
    if not force and State.kaCtx and State.kaCtxEq == eqStr
        and now() - (State.kaCtxTime or 0) < (CONFIG.KillAuraCtxCacheSec or 1.5) then
        return State.kaCtx
    end
    local rep = getEquippedRep(actor)
    if not rep then
        if State.kaCtxEq ~= eqStr then clearMeleeBoot() end
        State.kaCtxEq   = eqStr
        State.kaCtxTime = now()
        return nil
    end
    local item = (Bridge.itemFromActorInventory
        and Bridge.itemFromActorInventory(actor, rawget(actor, "_equipped")))
        or rawget(rep, "_item")
    local ctx = {
        actor   = actor,
        handler = rep,
        item    = item,
        isMelee = true,
        info = {
            caliber = "melee",
            name    = rawget(rep, "_build") or "melee",
            slot    = "Melee",
        },
    }
    if force and Bridge.loadSharedModules and Bridge.buildWeaponContext and item then
        local ok, mods = pcall(Bridge.loadSharedModules)
        if ok then
            local ok2, built = pcall(Bridge.buildWeaponContext, actor, item, "Melee", mods)
            if ok2 and type(built) == "table" then
                built.isMelee = true
                built.handler = rep
                ctx = built
            end
        end
    end
    State.kaCtx    = ctx
    State.kaCtxEq  = eqStr
    State.kaCtxTime = now()
    State.kaMeleeRep = rep
    return ctx
end

local function isMeleeSvcTable(obj)
    if type(obj) ~= "table" then return false end
    if getHandlerMethod(obj, "_use")    == nil then return false end
    if getHandlerMethod(obj, "Impact") ~= nil  then return false end
    return true
end

local function scanMeleeSvc(actor, rep, eqUid)
    if type(shared) == "table" and type(shared.import) == "function" then
        local ok, invSvc = pcall(shared.import, "InventoryService")
        if ok and type(invSvc) == "table" then
            local inventories = rawget(invSvc, "_inventories")
            if type(inventories) == "table" then
                for _, group in pairs(inventories) do
                    if type(group) ~= "table" then continue end
                    for _, slot in ipairs(group) do
                        if type(slot) ~= "table" then continue end
                        local h = rawget(slot, "Handler")
                        if isMeleeSvcTable(h) then
                            local uid = normalizeEqUid(rawget(slot, "UID"))
                            if eqUid == nil or uid == eqUid then
                                State.kaSvcSrc = "invSvc._inventories"
                                return h
                            end
                        end
                    end
                end
                for _, group in pairs(inventories) do
                    if type(group) ~= "table" then continue end
                    for _, slot in ipairs(group) do
                        local h = type(slot) == "table" and rawget(slot, "Handler") or nil
                        if isMeleeSvcTable(h) then
                            State.kaSvcSrc = "invSvc._inventories.any"
                            return h
                        end
                    end
                end
            end
        end
    end
    if type(rep) == "table" then
        for _, key in ipairs({"_inventoryService", "_service", "_svc", "_parent"}) do
            local v = rawget(rep, key)
            if isMeleeSvcTable(v) then
                State.kaSvcSrc = "actor.scan"
                return v
            end
        end
    end
    -- v5: getgc удалён — был причиной freeze при экипировке оружия
    warn("[KA] scanMeleeSvc: svc не найден через InventoryService/rep scan — getgc отключён")
    return nil
end

local function extractUseEnv(svc)
    if not svc then return nil end
    if State.kaUseEnv and State.kaUseEnv.svc == svc then return State.kaUseEnv end
    local env = {
        svc      = svc,
        delay    = rawget(svc, "_delay"),
        distance = rawget(svc, "_distance"),
        v3       = Bridge.vector3ToTable,
    }
    local useFn = getHandlerMethod(svc, "_use")
    if type(useFn) == "function" and type(debug) == "table" and type(debug.getupvalue) == "function" then
        for i = 1, 32 do
            local ok, _, val = pcall(debug.getupvalue, useFn, i)
            if not ok then break end
            if not env.net and type(val) == "table"
                and type(rawget(val, "FireServer")) == "function" then
                env.net = val
            elseif type(val) == "table" and rawget(val, "ActionType") then
                env.enum = val
            end
        end
    end
    if type(shared) == "table" and type(shared.import) == "function" then
        local ok, v3 = pcall(shared.import, "vector3toTable")
        if ok and type(v3) == "function" then env.v3 = v3 end
    end
    State.kaUseEnv = env
    return env
end

local function getActionTypeInv()
    if kaActionTypeInv then return kaActionTypeInv end
    if State.kaUseEnv and State.kaUseEnv.enum and State.kaUseEnv.enum.ActionType then
        kaActionTypeInv = State.kaUseEnv.enum.ActionType.Inventory
        return kaActionTypeInv
    end
    if type(shared) == "table" and type(shared.import) == "function" then
        local ok, e = pcall(shared.import, "Enum")
        if ok and type(e) == "table" and e.ActionType then
            kaActionTypeInv = e.ActionType.Inventory
            return kaActionTypeInv
        end
    end
    return nil
end

-- v5: weapon-cfg независимые тайминги — всё из CONFIG
local function getKaTimings()
    local reach = CONFIG.KillAuraReach or 999
    local cd    = CONFIG.KillAuraSwingCd or 0.35
    return reach, cd
end


local function ensureMeleeSvc(actor, ctx)
    if not actor or not ctx then return nil, nil end
    local rep   = ctx.handler or getEquippedRep(actor)
    local eqUid = normalizeEqUid(rawget(actor, "_equipped"))
    if rep == nil or eqUid == nil then return nil, nil end
    if meleeSvcReady(eqUid) then
        finishSvcBootstrap(actor, rep, eqUid, ctx)
        return State.kaMeleeSvc, State.kaUseEnv
    end
    local svc = scanMeleeSvc(actor, rep, eqUid)
    if svc then
        State.kaMeleeSvc = svc
        State.kaBootEq   = eqUid
        finishSvcBootstrap(actor, rep, eqUid, ctx)
        return svc, State.kaUseEnv
    end
    State.kaWarmupDone = false
    State.kaWarmupEq   = nil
    return nil, nil
end

local function getRepHandler(actor, ctx)
    return getEquippedRep(actor) or (ctx and ctx.handler) or nil
end



local function impactDir(actor, aimPart, reach)
    local aimPoint = State.kaAimPoint
    if typeof(aimPoint) ~= "Vector3" and aimPart and aimPart.Parent then
        aimPoint = aimPart.Position
    end
    local cam = Workspace.CurrentCamera
    if typeof(aimPoint) ~= "Vector3" then
        return (cam and cam.CFrame.LookVector or Vector3.new(0, 0, -1)) * reach
    end
    local origin
    if type(actor) == "table" then
        local cf = rawget(actor, "CFrame")
        if typeof(cf) == "CFrame" then
            origin = cf:PointToWorldSpace(Vector3.new(0, 2.5, 0))
        end
    end
    if not origin then origin = cam and cam.CFrame.Position or Vector3.new() end
    local to = aimPoint - origin
    local realDist = to.Magnitude
    -- [v5] BypassDistance: растягиваем reach до реальной дистанции до цели
    -- MeleeInventoryReplicator.Impact делает Raycast с вектором p28 — его длина = reach.
    -- Если цель дальше reach, рейкаст промахнётся. Переопределяем reach = realDist + небольшой запас.
    if CONFIG.KillAuraBypassDistance and realDist > 0.05 then
        local maxReach = CONFIG.KillAuraBypassDistanceMax or 999
        reach = math.min(realDist + 2.0, maxReach)  -- +2 юнита запас на движение
    end
    if realDist > 0.05 then return to.Unit * reach end
    return (cam and (aimPoint - cam.CFrame.Position).Unit or Vector3.new(0, 0, -1)) * reach
end

local function resolveHitUid(targetUid, aimPart)
    if targetUid ~= nil then
        return Bridge.normalizeActorUid and Bridge.normalizeActorUid(targetUid) or tostring(targetUid)
    end
    if aimPart and aimPart.GetAttribute then
        local a = aimPart:GetAttribute("ActorUID")
        if a ~= nil then return tostring(a) end
    end
    return nil
end

local function resolveHitPart(aimPart, targetData)
    -- [v5] ForceHeadshot / ForceBone — всегда возвращаем нужную кость из model
    local forceBone = CONFIG.KillAuraForceBone
    if not forceBone and CONFIG.KillAuraForceHeadshot then forceBone = "Head" end
    if forceBone and type(targetData) == "table" and targetData.model and targetData.model.Parent then
        local forced = targetData.model:FindFirstChild(forceBone)
        if forced and forced:IsA("BasePart") then return forced end
    end
    -- v6: если ForceBone не нашёл кость — это ошибка модели цели, сообщаем
    if aimPart and aimPart:IsA("BasePart") and aimPart.Parent then return aimPart end
    local fb = CONFIG.KillAuraForceBone or (CONFIG.KillAuraForceHeadshot and "Head") or "Head"
    warn("[KA] resolveHitPart: кость '", tostring(fb), "' не найдена в model. aimPart=", tostring(aimPart),
         "model=", type(targetData) == "table" and tostring(targetData.model) or "nil")
    return nil
end

local function syntheticImpact(aimPart, targetUid, targetData)
    local hitPos = State.kaAimPoint
    if typeof(hitPos) ~= "Vector3" then hitPos = aimPart and aimPart.Position end
    if typeof(hitPos) ~= "Vector3" then return nil end
    local part = resolveHitPart(aimPart, targetData)
    local uid  = resolveHitUid(targetUid, part or aimPart)
    if uid == nil then return nil end
    -- [v5] форсируем bone name по конфигу
    local boneName = (CONFIG.KillAuraForceBone)
        or (CONFIG.KillAuraForceHeadshot and "Head")
        or (part and part.Name)
        or "Head"
    return hitPos, uid, boneName
end

local function findImpactFn(actor, ctx)
    local rep = getRepHandler(actor, ctx)
    return rep and getHandlerMethod(rep, "Impact") or nil
end

local function steeredImpact(self, dir, origImpact)
    if type(origImpact) ~= "function" then return nil end
    local aimPart   = State.kaImpactPart
    local targetUid = State.kaImpactUid
    local targetData = State.kaTarget
    if not aimPart and typeof(State.kaAimPoint) ~= "Vector3" then
        return origImpact(self, dir)
    end
    local reach = typeof(dir) == "Vector3" and dir.Magnitude or rawget(self, "_distance") or 5
    if type(reach) ~= "number" or reach <= 0 then reach = 5 end
    local actor = type(self) == "table" and rawget(self, "_actor")
    local steerDir = impactDir(actor, aimPart, reach)
    local ok, hitPos, uid, bone = pcall(function() return origImpact(self, steerDir) end)
    if ok and typeof(hitPos) == "Vector3" and uid ~= nil and bone then
        -- [v5] override bone если ForceHeadshot/ForceBone включён
        local fb = CONFIG.KillAuraForceBone or (CONFIG.KillAuraForceHeadshot and "Head")
        return hitPos, uid, fb or bone
    end
    -- v6: no fallback — если origImpact не попал и synthetic не дал uid, это ошибка
    local sPos, sUid, sBone = syntheticImpact(aimPart, targetUid, targetData)
    if sPos then return sPos, sUid, sBone end
    warn("[KA] steeredImpact: origImpact промахнулся и synthetic не разрешил uid. aimPart=",
        tostring(aimPart), "targetUid=", tostring(targetUid))
    return nil
end

local function ensureRepImpactHook(actor, ctx)
    if type(hookfunction) ~= "function" then return false end
    local impactFn = findImpactFn(actor, ctx)
    if type(impactFn) ~= "function" then return false end
    State.kaImpactHookedFns = State.kaImpactHookedFns or {}
    if State.kaImpactHookedFns[impactFn] then return true end
    local origImpact
    local wrap = (type(newcclosure) == "function" and newcclosure or function(f) return f end)
    origImpact = hookfunction(impactFn, wrap(function(self, dir, ...)
        if State.kaImpactSteer and (State.kaImpactPart or typeof(State.kaAimPoint) == "Vector3") then
            return steeredImpact(self, dir, origImpact)
        end
        return origImpact(self, dir, ...)
    end))
    State.kaImpactHookedFns[impactFn] = origImpact
    State.kaImpactFnHooked = true
    return true
end

local function triggerGameMeleeUse(svc, actor, ctx, aimPart, targetData)
    -- v5: INSTANT IMPACT — не ждём _delay из оружия, шлём Impact сразу после Slash
    local useFn = getHandlerMethod(svc, "_use")
    if type(useFn) ~= "function" then
        warn("[KA] triggerGameMeleeUse: нет _use в svc —", tostring(svc))
        return false, "no_use"
    end
    if State.kaUseThreadActive then
        local since = State.kaUseThreadSince or 0
        if since > 0 and now() - since < 0.5 then return false, "use_busy" end
        State.kaUseThreadActive = false
    end
    local _, cd = getKaTimings()
    State.kaUseThreadActive = true
    State.kaUseThreadSince  = now()
    -- Slash анимация/звук через _use(svc, true) — но Impact шлём сами немедленно
    task.spawn(function()
        local ok, err = pcall(useFn, svc, true)
        if not ok then
            State.kaUseThreadActive = false
            warn("[KA] _use(true) error:", tostring(err))
        end
    end)
    -- v5: немедленная отправка Impact серверу — не ждём _delay
    -- Сервер принимает: hitPos (Vector3Table), uid (string), bone (string)
    do
        local net    = State.kaUseEnv and State.kaUseEnv.net
        local v3fn   = Bridge.vector3ToTable
        local at     = getActionTypeInv()
        local actFn  = actor and getHandlerMethod(actor, "Action")
        local slashN = math.random(1, 3)
        -- Slash сетевой пакет
        if net and net.FireServer then
            pcall(net.FireServer, net, "InventoryAction", "Slash", slashN)
        elseif Bridge.networkFireServer then
            pcall(Bridge.networkFireServer, "InventoryAction", "Slash", slashN)
        end
        -- Impact — сразу, без delay
        local reach  = CONFIG.KillAuraReach or 999
        local dir    = impactDir(actor, aimPart, reach)
        -- v5: predict — смещаем hitPos по velocity цели
        local predictMs = CONFIG.KillAuraPredictMs or 0
        local aimPt = State.kaAimPoint
        if predictMs > 0 and type(targetData) == "table" and targetData.model then
            local root = targetData.model:FindFirstChild("HumanoidRootPart") or targetData.root
            if root and root:IsA("BasePart") then
                local vel = root.AssemblyLinearVelocity
                if vel.Magnitude > 0.5 then
                    local dt = predictMs / 1000
                    aimPt = (typeof(aimPt) == "Vector3" and aimPt or root.Position) + vel * dt
                end
            end
        end
        -- v5: bypass wall — форсируем synthetic impact без raycast
        -- (MeleeInventoryReplicator.Impact делает Raycast на клиенте для эффектов,
        --  но сервер принимает hitPos/uid/bone напрямую — стены не мешают серверу)
        local hitPos, uid, bone
        if CONFIG.KillAuraNoWallCheck then
            -- обходим raycast полностью — подаём данные напрямую
            local part = resolveHitPart(aimPart, targetData)
            uid  = resolveHitUid(targetData and targetData.uid, part or aimPart)
            bone = (CONFIG.KillAuraForceBone) or (CONFIG.KillAuraForceHeadshot and "Head") or
                   (part and part.Name) or "Head"
            hitPos = typeof(aimPt) == "Vector3" and aimPt or (part and part.Position)
            if not hitPos or uid == nil then
                warn("[KA] NoWallCheck: нет hitPos или uid — part:", tostring(part), "uid:", tostring(uid))
            end
        else
            -- обычный путь через ActorClass.Action
            if at and actFn then
                State.kaImpactSteer = true
                State.kaImpactPart  = aimPart
                State.kaImpactUid   = targetData and targetData.uid or nil
                local ok2, hp, u, b = pcall(actFn, actor, at, "Impact", dir)
                State.kaImpactSteer = false
                State.kaImpactPart  = nil
                State.kaImpactUid   = nil
                if ok2 then hitPos, uid, bone = hp, u, b end
                local fb = CONFIG.KillAuraForceBone or (CONFIG.KillAuraForceHeadshot and "Head")
                if fb then bone = fb end
            end
        end
        if typeof(hitPos) == "Vector3" and uid ~= nil and bone and v3fn then
            local t = v3fn(hitPos)
            if t then
                local netFire = (net and net.FireServer and function(...) pcall(net.FireServer, net, ...) end)
                    or Bridge.networkFireServer
                if netFire then
                    netFire("InventoryAction", "Impact", t, uid, bone)
                else
                    warn("[KA] Impact: нет сетевого FireServer — Bridge.networkFireServer=", tostring(Bridge.networkFireServer))
                end
            else
                warn("[KA] Impact: vector3ToTable вернул nil для", tostring(hitPos))
            end
        else
            warn("[KA] Impact пакет не отправлен: hitPos=", tostring(hitPos),
                 "uid=", tostring(uid), "bone=", tostring(bone), "v3fn=", tostring(v3fn))
        end
    end
    -- Останавливаем _use через cd
    task.delay(math.max(0.05, cd - 0.05), function()
        pcall(useFn, svc, false)
        State.kaUseThreadActive = false
        State.kaUseThreadSince  = 0
    end)
    return true, cd
end

-- fallbackMeleeSwing удалён полностью (v6)

local function kaHasValidAim(aimPart, aimPoint, targetData)
    if typeof(aimPoint) == "Vector3" then return true end
    if aimPart and aimPart.Parent then return true end
    if type(targetData) == "table" and targetData.inInactiveWorld then return true end
    return false
end

local function beginSwingState(aimPart, aimPoint, targetData)
    State.kaImpactSteer = true
    State.kaImpactPart  = aimPart
    State.kaImpactUid   = targetData and targetData.uid or nil
    State.kaSwingBusy   = true
end

local function endSwingState(cd)
    task.delay(cd or 0.55, function()
        State.kaSwingBusy   = false
        State.kaImpactSteer = false
        State.kaImpactPart  = nil
        State.kaImpactUid   = nil
    end)
end

local function markSwingSuccess()
    State.kaLastSwing  = now()
    State.kaSwingCount = (State.kaSwingCount or 0) + 1
end

local function clearSwingBusyIfStale()
    if not State.kaSwingBusy then return end
    if (State.kaLastSwing or 0) > 0 and now() - (State.kaLastSwing or 0) > 1.25 then
        releaseSwingState()
    end
end

local function performSwing(actor, ctx, aimPart, aimPoint, targetData, resetCd)
    if State.kaSwingBusy then return false, "busy" end
    if type(actor) ~= "table" then return false, "no_actor" end
    if not kaHasValidAim(aimPart, aimPoint, targetData) then return false, "no_aim" end
    local _, cd = getKaTimings()
    if not resetCd and now() - (State.kaLastSwing or 0) < cd then return false, "cooldown" end
    local tpos = kaRefPos(targetData) or (aimPart and aimPart.Position) or aimPoint
    -- [v5] BypassDistance: если включён bypass, не проверяем дальность через kaDist()
    if not CONFIG.KillAuraBypassDistance and typeof(tpos) == "Vector3" and (tpos - kaLosOrigin(actor)).Magnitude > kaDist() + 1 then
        return false, "out_of_reach"
    end
    local eqUid = normalizeEqUid(rawget(actor, "_equipped"))
    local svc   = select(1, ensureMeleeSvc(actor, ctx))
    pcall(ensureRepImpactHook, actor, ctx)
    beginSwingState(aimPart, aimPoint, targetData)
    if svc and meleeSvcReady(eqUid) then
        local act = rawget(svc, "_actor")
        if type(act) == "table" and rawget(act, "Locked") then
            releaseSwingState()
            return false, "actor_locked"
        end
        local okUse, useInfo = triggerGameMeleeUse(svc, actor, ctx, aimPart, targetData)
        if okUse then
            markSwingSuccess()
            State.kaLastSlashNet   = "game._use"
            State.kaLastImpactMode = "game._use"
            State.kaLastImpactNet  = "game._use"
            endSwingState(type(useInfo) == "number" and useInfo or cd)
            return true, "game._use"
        end
        releaseSwingState()
    end
    -- v5: svc не найден — это ошибка, не молчим
    warn("[KA] performSwing: svc=nil после ensureMeleeSvc. equipped=",
        tostring(rawget(actor, "_equipped")), "actor=", tostring(actor))
    releaseSwingState()
    return false, "no_svc"
end

local function countEnemies()
    local n, e = 0, 0
    for _, d in pairs(State.actors or {}) do
        n = n + 1
        if not Bridge.isEnemyActor or Bridge.isEnemyActor(d) then e = e + 1 end
    end
    return n, e
end

local function ensureViz()
    if kaVizLine then return end
    if type(Drawing) ~= "table" or type(Drawing.new) ~= "function" then return end
    kaVizLine           = Drawing.new("Line")
    kaVizLine.Thickness = 2
    kaVizLine.Color     = Color3.fromRGB(255, 55, 55)
    kaVizLine.Visible   = false
    kaVizCircle          = Drawing.new("Circle")
    kaVizCircle.Filled   = false
    kaVizCircle.NumSides = 24
    kaVizCircle.Radius   = 12
    kaVizCircle.Thickness = 2
    kaVizCircle.Color    = Color3.fromRGB(255, 55, 55)
    kaVizCircle.Visible  = false
    kaVizLabel             = Drawing.new("Text")
    kaVizLabel.Size        = 13
    kaVizLabel.Color       = Color3.fromRGB(255, 220, 50)
    kaVizLabel.Outline     = true
    kaVizLabel.OutlineColor = Color3.fromRGB(0, 0, 0)
    kaVizLabel.Position    = Vector2.new(8, 8)
    kaVizLabel.Visible     = false
    kaVizLabel.Font        = 2
end

local function hideViz()
    if kaVizLine   then kaVizLine.Visible   = false end
    if kaVizCircle then kaVizCircle.Visible = false end
    if kaVizLabel  then kaVizLabel.Visible  = false end
end

local function updateViz(actor)
    if not CONFIG.KillAura or CONFIG.KillAuraViz == false then hideViz() return end
    ensureViz()
    if not kaVizLabel then return end
    local target = State.kaTarget
    local pt     = State.kaAimPoint
    -- [FLUX FIX] Показываем Alive/Health из ActorClass в лейбле для отладки
    local fluxActor = getFluxLocalActor()
    local fluxInfo  = fluxActor and string.format("FA:%.0f/%s",
        rawget(fluxActor, "Health") or -1,
        tostring(rawget(fluxActor, "Alive"))) or "FA:nil"
    kaVizLabel.Text = string.format("KA | %s | tgt:%s | svc:%s | %s",
        tostring(State.kaLastPhase or "?"),
        target and tostring(target.label or target.uid or "?") or "none",
        State.kaMeleeSvc and "yes" or "no",
        fluxInfo)
    kaVizLabel.Visible = true
    if not target or typeof(pt) ~= "Vector3" then
        if kaVizLine   then kaVizLine.Visible   = false end
        if kaVizCircle then kaVizCircle.Visible = false end
        return
    end
    local cam = getCamera()
    if not cam then return end
    local origin = kaLosOrigin(actor)
    local oScr, oVis = cam:WorldToViewportPoint(origin)
    local pScr, pVis = cam:WorldToViewportPoint(pt)
    if not pVis then hideViz() return end
    if kaVizCircle then
        kaVizCircle.Position = Vector2.new(pScr.X, pScr.Y)
        kaVizCircle.Visible  = true
    end
    if kaVizLine then
        if oVis then
            kaVizLine.From    = Vector2.new(oScr.X, oScr.Y)
            kaVizLine.To      = Vector2.new(pScr.X, pScr.Y)
            kaVizLine.Visible = true
        else
            kaVizLine.Visible = false
        end
    end
end

local function kaTickCombat(actor, ctx, autoSwing)
    clearSwingBusyIfStale()
    if autoSwing then
        if not validateTarget(actor) or now() - kaLastPickT >= (CONFIG.KillAuraPickInterval or 0.25) then
            pickTarget(true, actor)
        end
    else
        if not validateTarget(actor) then pickTarget(false, actor) end
    end
    local target, aimPart, aimPoint = State.kaTarget, State.kaAimPart, State.kaAimPoint
    updateViz(actor)
    if not target or typeof(aimPoint) ~= "Vector3" then
        setPhase("no_target")
        return
    end
    setPhase(autoSwing and "active" or "manual", target.label or target.uid)
    if autoSwing and now() - kaLastDiagT >= 4 then
        kaLastDiagT = now()
        local _, en = countEnemies()
        log("KA", "auto", State.kaLastPhase, State.kaLastPickSource or "-",
            State.kaLastSkip or "-", "actors", State.trackedActorCount or 0,
            "enemies", en, "svc", State.kaMeleeSvc ~= nil, "tgt", target.label or target.uid)
    end
    if autoSwing and not State.kaSwingBusy then
        local ok, reason = performSwing(actor, ctx, aimPart, aimPoint, target, false)
        if not ok then setPhase("skip", reason) end
    end
end

local function tickManualAssist()
    if not onLifeState() then setPhase("dead") return end
    local ctx = resolveMeleeContext(false)
    if not ctx then setPhase("no_melee") return end
    local actor = resolveActor(ctx)
    if not actor then setPhase("no_actor") return end
    ctx.actor = actor
    ensureMeleeSvc(actor, ctx)
    kaTickCombat(actor, ctx, false)
end

local function tick()
    if not CONFIG.KillAura then clearKaTarget() return end
    if not onLifeState() then setPhase("dead") return end
    if CONFIG.KillAuraAuto ~= true then return tickManualAssist() end
    local ctx
    if now() - kaLastFullCtxT >= 0.8 then
        kaLastFullCtxT = now()
        ctx = resolveMeleeContext(true)
    else
        ctx = resolveMeleeContext(false)
    end
    if not ctx then ctx = resolveMeleeContext(true) end
    if not ctx then
        clearKaTarget()
        setPhase("no_melee")
        return
    end
    local actor = resolveActor(ctx)
    if not actor then setPhase("no_actor") return end
    ctx.actor = actor
    ensureMeleeSvc(actor, ctx)
    kaTickCombat(actor, ctx, true)
end

local function dumpDebug(testSwing)
    refreshTeamAndRep(true)
    -- [FLUX FIX] Дамп состояния Flux LocalActor
    local fluxActor = getFluxLocalActor()
    print("====== KillAura v3 DEBUG (H) ======")
    if fluxActor then
        print(string.format("[FluxActor] Alive=%s Health=%s Downed=%s",
            tostring(rawget(fluxActor, "Alive")),
            tostring(rawget(fluxActor, "Health")),
            tostring(rawget(fluxActor, "Downed"))))
    else
        print("[FluxActor] NOT FOUND — getFluxLocalActor() returned nil")
    end
    print("isLocalAlive():", isLocalAlive())
    local ctx   = resolveMeleeContext(true)
    local actor = ctx and resolveActor(ctx) or nil
    local rep   = actor and getRepHandler(actor, ctx) or nil
    local eq    = actor and rawget(actor, "_equipped") or nil
    local svc   = State.kaMeleeSvc
    print("melee:", ctx ~= nil, "equipped:", tostring(eq), "rep:", rep ~= nil,
        "build:", rep and rawget(rep, "_build"))
    print("svc:", svc ~= nil,
        "useFn:", svc and getHandlerMethod(svc, "_use") ~= nil,
        "svcSrc:", State.kaSvcSrc or "nil",
        "bootEq:", tostring(State.kaBootEq),
        "ctxEq:", tostring(State.kaCtxEq))
    print("warmup:", State.kaWarmupDone == true,
        "swingBusy:", State.kaSwingBusy == true,
        "useThread:", State.kaUseThreadActive == true)
    local t, p, pt = pickTarget(true, actor)
    print("picked:", t and (t.label or t.uid) or "NONE",
        "part:", p and p.Name or "nil",
        "point:", pt)
    if testSwing and actor and typeof(pt) == "Vector3" then
        State.kaLastSwing = 0
        releaseSwingState()
        print("test swing:", performSwing(actor, ctx, p, pt, t, true))
    end
    print("===================================")
end

local _M = {}
_M.CONFIG = KA_CONFIG

function _M.start()
    if kaConn then return end
    for k, v in pairs(KA_CONFIG) do CONFIG[k] = v end
    State.running = true
    pcall(function()
        if type(shared) == "table" and type(shared.import) == "function" then
            local ok, net = pcall(shared.import, "network")
            if ok then
                State.networkModule       = net
                State.networkModuleSource = "shared.import"
            end
        end
    end)
    if kaInputConn then kaInputConn:Disconnect() end
    kaInputConn = UIS.InputBegan:Connect(function(input, processed)
        if processed or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if input.KeyCode ~= (CONFIG.KillAuraDebugKey or Enum.KeyCode.H) then return end
        task.spawn(function() dumpDebug(true) end)
    end)
    local lp = Players.LocalPlayer
    if kaCharConn then kaCharConn:Disconnect() end
    if lp then
        kaCharConn = lp.CharacterAdded:Connect(function()
            kaCharGraceUntil    = now() + KA_CHAR_GRACE
            State.kaWasDead     = false
            _fluxActorCache     = nil
            _fluxActorCacheTime = 0
            clearKaTarget()
            releaseSwingState()
            clearMeleeBoot()
            task.defer(function()
                pcall(function()
                    if Bridge.resolveLocalActor then Bridge.resolveLocalActor(true) end
                end)
            end)
        end)
    end
    local acc = 0
    kaConn = RunService.Heartbeat:Connect(function(dt)
        if not State.running or not CONFIG.KillAura then return end
        acc = acc + dt
        if acc < (CONFIG.KillAuraTickInterval or 0.2) then return end
        acc = 0
        pcall(tick)
    end)
    kaVizConn = RunService.RenderStepped:Connect(function()
        if not State.running or not CONFIG.KillAura then hideViz() return end
        local actor = State.kaCtx and resolveActor(State.kaCtx) or nil
        pcall(updateViz, actor)
    end)
    task.defer(function()
        if not State.running or not CONFIG.KillAura then return end
        refreshTeamAndRep(true)
        local ctx   = resolveMeleeContext(true)
        local actor = ctx and resolveActor(ctx) or nil
        if actor and ctx then ensureMeleeSvc(actor, ctx) end
    end)
    log("KA", "v3 started | dist=", kaDist())
end

function _M.stop()
    if kaConn     then kaConn:Disconnect()     kaConn     = nil end
    if kaVizConn  then kaVizConn:Disconnect()  kaVizConn  = nil end
    if kaInputConn then kaInputConn:Disconnect() kaInputConn = nil end
    if kaCharConn  then kaCharConn:Disconnect() kaCharConn  = nil end
    hideViz()
    clearKaTarget()
    releaseSwingState()
end

function _M.toggle()
    CONFIG.KillAura = not CONFIG.KillAura
    if CONFIG.KillAura and not kaConn then _M.start() end
    if not CONFIG.KillAura then clearKaTarget() releaseSwingState() end
    return CONFIG.KillAura
end

function _M.dumpStatus()  dumpDebug(false) end
function _M.debugDump()   dumpDebug(true)  end
end
end
function _M.swingOnce()
    local ctx   = resolveMeleeContext(true)
    local actor = ctx and resolveActor(ctx) or nil
    local target, part, pt = pickTarget(true, actor)
    if not actor or typeof(pt) ~= "Vector3" then return false, "no_target" end
    State.kaLastSwing = 0
    releaseSwingState()
    return performSwing(actor, ctx, part, pt, target, true)
end

_M.Bridge            = Bridge
Bridge._killAuraModule = _M
return _M
end
