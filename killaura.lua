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
    KillAuraImpactDelay         = 0.25,
    KillAuraSwingCooldown       = 0.55,
    KillAuraFOV                 = 360,
    KillAuraPreferPlayers       = true,
    KillAuraBloodEffects        = true,
    KillAuraClientHitFx         = true,
    KillAuraForceHit            = true,
    KillAuraTickInterval        = 0.2,
    KillAuraPickInterval        = 0.25,
    KillAuraCtxCacheSec         = 1.5,
    KillAuraWarmupGc            = true,
    KillAuraModifyEnabled       = true,
    KillAuraApplySilentModify   = true,
    KillAuraModifyReachMult     = 1.4,
    KillAuraModifyDelayMult     = 0.7,
    KillAuraModifyCooldownMult  = 0.75,
    KillAuraModifyPresets = {
        ExtraReach  = true,
        FastImpact  = true,
        FastSwing   = true,
        LightWeight = true,
    },
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

    -- Вариант 3: getgc — ищем таблицу ReplicatorService с полем LocalActor
    if not found and type(getgc) == "function" then
        for _, v in pairs(getgc(false)) do
            if type(v) == "table" then
                local la = rawget(v, "LocalActor")
                if type(la) == "table"
                    and rawget(la, "Alive")  ~= nil
                    and rawget(la, "Health") ~= nil
                    and rawget(la, "Owner")  ~= nil
                then
                    found = la
                    break
                end
            end
        end
    end

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
        if (pos - losOrigin).Magnitude <= maxDist then
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
        if d <= kaDist() and (best == nil or d < bestDist) then
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
    if (pos - kaLosOrigin(actor)).Magnitude > kaDist() + 1 then clearKaTarget() return false end
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
    if type(getgc) == "function" and CONFIG.KillAuraWarmupGc ~= false then
        local build = rep and rawget(rep, "_build")
        local best, bestScore = nil, 0
        for _, obj in getgc(true) do
            if not isMeleeSvcTable(obj) then continue end
            local score = 1
            if build and rawget(obj, "_build") == build          then score += 10 end
            if actorsMatch(rawget(obj, "_actor"), actor)          then score += 20 end
            local item = rawget(obj, "_item")
            if eqUid and type(item) == "table" then
                local meta = rawget(item, "MetaData")
                local uid  = meta and normalizeEqUid(rawget(meta, "UID")) or nil
                if uid == eqUid then score += 25 end
            end
            if score > bestScore then bestScore = score; best = obj end
        end
        if best then
            State.kaSvcSrc = "getgc"
            return best
        end
    end
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

local function getMeleeBuildCfg(build)
    if not build then return nil end
    if kaSharedMeleeCfg == nil then
        local ok, mods = pcall(Bridge.loadSharedModules)
        kaSharedMeleeCfg = ok and type(mods) == "table" and mods.Melee or false
    end
    if type(kaSharedMeleeCfg) ~= "table" then return nil end
    return kaSharedMeleeCfg[build]
end

local function applyMeleeMods(svc, ctx, eqUid)
    if CONFIG.KillAuraModifyEnabled == false or type(svc) ~= "table" then return end
    eqUid = eqUid or "?"
    State.kaMeleeModBackup = State.kaMeleeModBackup or {}
    if not State.kaMeleeModBackup[eqUid] then
        State.kaMeleeModBackup[eqUid] = {
            distance = rawget(svc, "_distance"),
            delay    = rawget(svc, "_delay"),
            timer    = rawget(svc, "_timer"),
        }
    end
    local bak = State.kaMeleeModBackup[eqUid]
    local presets   = CONFIG.KillAuraModifyPresets or {}
    local baseReach = (type(bak.distance) == "number" and bak.distance > 0) and bak.distance or 5
    local baseDelay = (type(bak.delay)    == "number" and bak.delay    > 0) and bak.delay    or (CONFIG.KillAuraImpactDelay   or 0.25)
    local baseTimer = (type(bak.timer)    == "number" and bak.timer    > 0) and bak.timer    or (CONFIG.KillAuraSwingCooldown or 0.55)
    if presets.ExtraReach  then rawset(svc, "_distance", baseReach * (CONFIG.KillAuraModifyReachMult     or 1.4)) end
    if presets.FastImpact  then rawset(svc, "_delay",    baseDelay * (CONFIG.KillAuraModifyDelayMult     or 0.7)) end
    if presets.FastSwing   then rawset(svc, "_timer",    baseTimer * (CONFIG.KillAuraModifyCooldownMult  or 0.75)) end
    if presets.LightWeight then
        local item = ctx and ctx.item
        local meta = type(item) == "table" and rawget(item, "MetaData") or nil
        if meta and type(rawget(meta, "Weight")) == "number" then
            rawset(meta, "Weight", math.max(1, math.floor(rawget(meta, "Weight") * 0.2)))
        end
    end
end

local function meleeSvcReady(eqUid)
    eqUid = normalizeEqUid(eqUid)
    local boot = normalizeEqUid(State.kaBootEq)
    return State.kaMeleeSvc ~= nil and boot ~= nil and boot == eqUid
        and getHandlerMethod(State.kaMeleeSvc, "_use") ~= nil
end

local function finishSvcBootstrap(actor, rep, eqUid, ctx)
    if not State.kaMeleeSvc then return end
    if State.kaModsAppliedEq ~= eqUid then
        pcall(applyMeleeMods, State.kaMeleeSvc, ctx, eqUid)
        State.kaModsAppliedEq = eqUid
    end
    pcall(extractUseEnv, State.kaMeleeSvc)
    getActionTypeInv()
    State.kaWarmupEq   = eqUid
    State.kaWarmupDone = true
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

local function getMeleeTiming(ctx)
    local reach = 5
    local delay = CONFIG.KillAuraImpactDelay or 0.25
    if State.kaUseEnv then
        if type(State.kaUseEnv.distance) == "number" and State.kaUseEnv.distance > 0 then
            reach = State.kaUseEnv.distance
        end
        if type(State.kaUseEnv.delay) == "number" and State.kaUseEnv.delay > 0 then
            delay = State.kaUseEnv.delay
        end
        return reach, delay
    end
    local handler = ctx and ctx.handler
    local build   = type(handler) == "table" and rawget(handler, "_build") or nil
    local cfg = getMeleeBuildCfg(build)
    if type(cfg) == "table" then
        if type(cfg.Reach) == "number"  and cfg.Reach > 0  then reach = cfg.Reach  end
        if type(cfg.Delay) == "number"  and cfg.Delay > 0  then delay = cfg.Delay  end
    end
    return reach, delay
end

local function swingCooldown(ctx)
    local cd = CONFIG.KillAuraSwingCooldown or 0.55
    if State.kaMeleeSvc and type(rawget(State.kaMeleeSvc, "_timer")) == "number"
        and rawget(State.kaMeleeSvc, "_timer") > 0 then
        cd = rawget(State.kaMeleeSvc, "_timer")
    else
        local handler = ctx and ctx.handler
        local build   = type(handler) == "table" and rawget(handler, "_build") or nil
        local cfg = getMeleeBuildCfg(build)
        if type(cfg) == "table" and type(cfg.Cooldown) == "number" and cfg.Cooldown > 0 then
            cd = cfg.Cooldown
        end
    end
    return cd
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
    if type(actor) == "table" then
        local cf = rawget(actor, "CFrame")
        if typeof(cf) == "CFrame" then
            local origin = cf:PointToWorldSpace(Vector3.new(0, 2.5, 0))
            local to = aimPoint - origin
            if to.Magnitude > 0.05 then return to.Unit * reach end
        end
    end
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
    if aimPart and aimPart:IsA("BasePart") and aimPart.Parent then return aimPart end
    if type(targetData) == "table" and targetData.model and targetData.model.Parent then
        local p = targetData.model:FindFirstChild("Head")
            or targetData.model:FindFirstChild("UpperTorso")
            or targetData.model:FindFirstChild("HumanoidRootPart")
            or targetData.root
        if p and p:IsA("BasePart") then return p end
    end
    return aimPart
end

local function syntheticImpact(aimPart, targetUid, targetData)
    local hitPos = State.kaAimPoint
    if typeof(hitPos) ~= "Vector3" then hitPos = aimPart and aimPart.Position end
    if typeof(hitPos) ~= "Vector3" then return nil end
    local part = resolveHitPart(aimPart, targetData)
    local uid  = resolveHitUid(targetUid, part or aimPart)
    if uid == nil then return nil end
    return hitPos, uid, (part and part.Name) or "Head"
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
        return hitPos, uid, bone
    end
    local sPos, sUid, sBone = syntheticImpact(aimPart, targetUid, targetData)
    if sPos then return sPos, sUid, sBone end
    return origImpact(self, dir)
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

local function triggerGameMeleeUse(svc)
    local useFn = getHandlerMethod(svc, "_use")
    if type(useFn) ~= "function" then return false, "no_use" end
    if State.kaUseThreadActive then
        local since = State.kaUseThreadSince or 0
        if since > 0 and now() - since < 0.75 then return false, "use_busy" end
        State.kaUseThreadActive = false
    end
    local delay = rawget(svc, "_delay")
    if type(delay) ~= "number" or delay <= 0 then delay = CONFIG.KillAuraImpactDelay or 0.25 end
    local timer = rawget(svc, "_timer")
    if type(timer) ~= "number" or timer <= 0 then timer = CONFIG.KillAuraSwingCooldown or 0.55 end
    State.kaUseThreadActive = true
    State.kaUseThreadSince  = now()
    task.spawn(function()
        local ok = pcall(function() useFn(svc, true) end)
        if not ok then
            State.kaUseThreadActive = false
            State.kaUseThreadSince  = 0
        end
    end)
    task.delay(math.max(0.05, delay + 0.1), function()
        pcall(function() useFn(svc, false) end)
        State.kaUseThreadActive = false
        State.kaUseThreadSince  = 0
    end)
    task.delay(1.0, function()
        if State.kaUseThreadActive and now() - (State.kaUseThreadSince or 0) >= 0.95 then
            State.kaUseThreadActive = false
            State.kaUseThreadSince  = 0
        end
    end)
    return true, delay + timer
end

local function fallbackMeleeSwing(actor, ctx, aimPart, targetUid, delay)
    local actionFn = getHandlerMethod(actor, "Action")
    if type(actionFn) ~= "function" then return false, "no_action" end
    local at = getActionTypeInv()
    if not at then return false, "no_enum" end
    local reach = select(1, getMeleeTiming(ctx))
    local slashVar = math.random(1, 3)
    pcall(function() actionFn(actor, at, "Slash", slashVar) end)
    if Bridge.networkFireServer then pcall(Bridge.networkFireServer, "InventoryAction", "Slash", slashVar) end
    task.delay(delay, function()
        local dir = impactDir(actor, aimPart, reach)
        State.kaImpactSteer = true
        State.kaImpactPart  = aimPart
        State.kaImpactUid   = targetUid
        local ok, hitPos, uid, bone = pcall(function() return actionFn(actor, at, "Impact", dir) end)
        State.kaImpactSteer = false
        State.kaImpactPart  = nil
        State.kaImpactUid   = nil
        if ok and typeof(hitPos) == "Vector3" and uid ~= nil and bone
            and Bridge.networkFireServer and Bridge.vector3ToTable then
            local t = Bridge.vector3ToTable(hitPos)
            if t then pcall(Bridge.networkFireServer, "InventoryAction", "Impact", t, uid, bone) end
        end
    end)
    return true, "fallback.Action"
end

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
    local cd = swingCooldown(ctx)
    if not resetCd and now() - (State.kaLastSwing or 0) < cd then return false, "cooldown" end
    local tpos = kaRefPos(targetData) or (aimPart and aimPart.Position) or aimPoint
    if typeof(tpos) == "Vector3" and (tpos - kaLosOrigin(actor)).Magnitude > kaDist() + 1 then
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
        local okUse, useInfo = triggerGameMeleeUse(svc)
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
    local delay = select(2, getMeleeTiming(ctx))
    local okFb, reason = fallbackMeleeSwing(actor, ctx, aimPart, targetData and targetData.uid or nil, delay)
    if not okFb then
        releaseSwingState()
        return false, reason or "fallback_fail"
    end
    markSwingSuccess()
    State.kaLastSlashNet   = "fallback.Action"
    State.kaLastImpactMode = "fallback.Action"
    State.kaLastImpactNet  = "fallback.Action"
    endSwingState(math.max(cd, delay))
    return true, "fallback.Action"
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
function _M.setDistance(n) CONFIG.KillAuraDistance = n end
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
