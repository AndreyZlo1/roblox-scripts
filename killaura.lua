--[[
	BRM5KillAura — v1 (patched)

	FIX 1 — phase:dead:
	  kaIsLocalAlive() = false на respawn-фрейме → kaWasDead=true → tick блокировался.
	  Решение: grace 0.3s после CharacterAdded + сброс kaImpactSteer.

	FIX 2 — svc:no (warmup race):
	  kaWarmupEq ставился внутри task.defer → дублирующий warmup каждые 0.2s.
	  Решение: kaWarmupEq = eqStr до task.defer.

	FIX 3 — actor_busy Sprinting:
	  rawget(act,"Sprinting") почти всегда true в Flux → каждый swing = false.
	  Решение: убрана проверка Sprinting, оставлена только Locked.
]]
--[[
	BRM5KillAura
	  Primary: game._use + Impact hook (ForceHit).
	  Fallback: Action + network (пока svc не готов).
	  Warmup: hook/mods/env/getgc — только фон, не в performSwing.
	Debug: H
]]
return function(Lib)
local Bridge = Lib.Bridge
local CONFIG = Lib.CONFIG
local State  = Lib.State

local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local newcclosure = newcclosure
local hookfunction = hookfunction
local getgc = getgc
local getCamera = Bridge._getCamera
local log = Bridge._log
local RunService = Bridge._RunService

local KA_CONFIG = {
	KillAura = true,
	KillAuraAuto = true,
	KillAuraDistance = 30,
	KillAuraImpactDelay = 0.25,
	KillAuraSwingCooldown = 0.55,
	KillAuraFOV = 360,
	KillAuraPreferPlayers = true,
	KillAuraBloodEffects = true,
	KillAuraClientHitFx = true,
	KillAuraForceHit = true,
	KillAuraTickInterval = 0.2,
	KillAuraPickInterval = 0.35,
	KillAuraEspRefreshInterval = 0,
	KillAuraCtxCacheSec = 3,
	KillAuraWarmupGc = true,
	KillAuraModifyEnabled = true,
	KillAuraApplySilentModify = true,
	KillAuraModifyReachMult = 1.4,
	KillAuraModifyDelayMult = 0.7,
	KillAuraModifyCooldownMult = 0.75,
	KillAuraModifyPresets = {
		ExtraReach = true,
		FastImpact = true,
		FastSwing = true,
		LightWeight = true,
	},
	KillAuraDebugKey = Enum.KeyCode.H,
	KillAuraViz = true,
}
for k, v in pairs(KA_CONFIG) do CONFIG[k] = v end

local kaConn, kaVizConn, kaInputConn, kaCharConn = nil, nil, nil, nil
local kaLastPickT, kaLastTeamRefreshT, kaLastDiagT, kaLastActorPrepT, kaLastFullCtxT = 0, 0, 0, 0, 0
local kaVizLine, kaVizCircle, kaVizLabel = nil, nil, nil
local kaEnsureMeleeSvc, ensureRepImpactHook
local kaSharedMeleeCfg, kaActionTypeInv

-- FIX 1: grace-период после CharacterAdded
local kaCharGraceUntil = 0
local KA_CHAR_GRACE = 0.3

local function kaIsLocalAlive()
	-- FIX 1: grace-период сразу после respawn
	if os.clock() < kaCharGraceUntil then return true end
	local lp = Players.LocalPlayer
	local char = lp and lp.Character
	if not char or not char.Parent then return false end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		return hum.Health > 0
	end
	return char.Parent ~= nil
end

local function kaOnLifeState()
	if not kaIsLocalAlive() then
		if not State.kaWasDead then
			State.kaWasDead = true
			clearKaTarget()
			State.kaSwingBusy = false
			State.kaImpactSteer = false
		end
		return false
	end
	if State.kaWasDead then
		State.kaWasDead = false
		clearMeleeBoot()
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
	return Bridge.getAimLosOrigin and Bridge.getAimLosOrigin() or Vector3.zero
end

local function kaRefreshTeamKey(force)
	local now = os.clock()
	if not force and now - kaLastTeamRefreshT < 1.0 then return end
	kaLastTeamRefreshT = now
	if Bridge.refreshLocalTeamKey then pcall(Bridge.refreshLocalTeamKey) end
end

-- Тот же prep что на H до pickTarget: team + rep batch СИНХРОННО (не defer)
local function kaPrepActorsForPick(force)
	local now = os.clock()
	if not force and now - kaLastActorPrepT < 0.4 then return end
	kaLastActorPrepT = now
	kaRefreshTeamKey(true)
	if Bridge.tickRepSyncBatch then
		pcall(Bridge.tickRepSyncBatch, force and 18 or 12)
	end
end

local function kaEnsureViz()
	if kaVizLine then return end
	if type(Drawing) ~= "table" or type(Drawing.new) ~= "function" then return end
	kaVizLine = Drawing.new("Line")
	kaVizLine.Thickness = 2
	kaVizLine.Color = Color3.fromRGB(255, 55, 55)
	kaVizLine.Visible = false
	kaVizCircle = Drawing.new("Circle")
	kaVizCircle.Filled = false
	kaVizCircle.Radius = 12
	kaVizCircle.NumSides = 24
	kaVizCircle.Thickness = 2
	kaVizCircle.Color = Color3.fromRGB(255, 55, 55)
	kaVizCircle.Visible = false
	kaVizLabel = Drawing.new("Text")
	kaVizLabel.Size = 13
	kaVizLabel.Color = Color3.fromRGB(255, 220, 50)
	kaVizLabel.Outline = true
	kaVizLabel.OutlineColor = Color3.fromRGB(0, 0, 0)
	kaVizLabel.Position = Vector2.new(8, 8)
	kaVizLabel.Visible = false
	kaVizLabel.Font = 2
end

local function kaHideViz()
	if kaVizLine then kaVizLine.Visible = false end
	if kaVizCircle then kaVizCircle.Visible = false end
	if kaVizLabel then kaVizLabel.Visible = false end
end

local function kaUpdateViz(actor)
	if CONFIG.KillAuraViz == false or not CONFIG.KillAura then
		kaHideViz()
		return
	end
	kaEnsureViz()
	if not kaVizLine or not kaVizCircle then return end
	local pt = State.kaAimPoint
	local target = State.kaTarget
	-- Статус-лейбл показываем всегда
	if kaVizLabel then
		local svcRdy = State.kaMeleeSvc ~= nil
		local tgtStr = target and tostring(target.label or target.uid or "?") or "none"
		local phase = State.kaLastPhase or "?"
		kaVizLabel.Text = string.format("KA | %s | tgt:%s | svc:%s", phase, tgtStr, svcRdy and "yes" or "no")
		kaVizLabel.Visible = true
	end
	if not target or typeof(pt) ~= "Vector3" then
		if kaVizLine then kaVizLine.Visible = false end
		if kaVizCircle then kaVizCircle.Visible = false end
		return
	end
	local cam = getCamera()
	if not cam then return end
	local origin = kaLosOrigin(actor)
	local oScr, oVis = cam:WorldToViewportPoint(origin)
	local pScr, pVis = cam:WorldToViewportPoint(pt)
	if not pVis then
		kaHideViz()
		return
	end
	kaVizCircle.Position = Vector2.new(pScr.X, pScr.Y)
	kaVizCircle.Visible = true
	if oVis then
		kaVizLine.From = Vector2.new(oScr.X, oScr.Y)
		kaVizLine.To = Vector2.new(pScr.X, pScr.Y)
		kaVizLine.Visible = true
	else
		kaVizLine.Visible = false
	end
end

local function kaResolveActor(ctx)
	if ctx and type(ctx.actor) == "table" and getEquippedRep(ctx.actor) then
		return ctx.actor
	end
	local _, a = peekLocalActorLight()
	if a and getEquippedRep(a) then return a end
	if Bridge.resolveLocalActor then
		local _, a2 = Bridge.resolveLocalActor(false)
		if a2 then return a2 end
	end
	return ctx and ctx.actor
end

local function kaClearSwingBusyIfStale()
	if not State.kaSwingBusy then return end
	local t0 = State.kaLastSwing or 0
	if t0 > 0 and os.clock() - t0 > 3.5 then
		State.kaSwingBusy = false
		State.kaImpactSteer = false
		State.kaImpactPart = nil
		State.kaImpactUid = nil
	end
end

local function kaDist()
	local d = CONFIG.KillAuraDistance
	return (type(d) == "number" and d > 0) and d or 50
end

local function clearKaTarget()
	State.kaTarget = nil
	State.kaAimPart = nil
	State.kaAimPoint = nil
	State.kaTargetUid = nil
	State.kaTargetTime = 0
end

local function setPhase(p, skip)
	State.kaLastPhase = p
	if skip then State.kaLastSkip = skip end
end

-- Позиция цели: esp adPos → actorData → root/model (как esp ranked + InactiveWorld)
local function kaRefPos(data)
	if not data then return nil end
	if data.inInactiveWorld and data.adPos and typeof(data.adPos) == "Vector3" then
		return data.adPos
	end
	local ad = data.actorData
	if type(ad) == "table" then
		local p = rawget(ad, "SimulatedPosition") or rawget(ad, "ServerPosition") or rawget(ad, "Position")
		if typeof(p) == "Vector3" and (p.Magnitude > 0.5 or not data.inInactiveWorld) then
			return p
		end
	end
	local root = data.root
	if root and root.Parent and root:IsA("BasePart") then
		local p = root.Position
		if p.Magnitude > 0.5 or not data.inInactiveWorld then return p end
	end
	if data.model and data.model.Parent then
		local p = data.model:FindFirstChild("HumanoidRootPart")
			or data.model:FindFirstChild("UpperTorso")
			or data.model:FindFirstChild("Head")
		if p and p:IsA("BasePart") then return p.Position end
	end
	return nil
end

local function getEspActorPos(data)
	return kaRefPos(data)
end

local function resolveKaAim(data, losOrigin, cam, maxAngle)
	if not data then return nil, nil end
	local point = getEspActorPos(data)
	local part = Bridge.getSilentAimPart and Bridge.getSilentAimPart(data) or data.root
	if part and part:IsA("BasePart") and part.Parent and typeof(point) == "Vector3" then
		return part, point
	end
	if typeof(point) == "Vector3" and data.model and data.model.Parent then
		part = data.model:FindFirstChild("Head")
			or data.model:FindFirstChild("UpperTorso")
			or data.model:FindFirstChild("HumanoidRootPart")
			or data.root
		if part and part:IsA("BasePart") then
			return part, point
		end
	end
	if typeof(point) == "Vector3" and data.inInactiveWorld then
		if not part or not part.Parent then
			part = (data.model and data.model.Parent) and (
				data.model:FindFirstChild("Head")
				or data.model:FindFirstChild("UpperTorso")
				or data.model:FindFirstChild("HumanoidRootPart")
			) or data.root
		end
		return part, point
	end
	if part and part:IsA("BasePart") and part.Parent then
		point = part.Position
		if typeof(point) == "Vector3" then return part, point end
	end
	return nil, nil
end

-- Pool: State.actors + collectAimActorCandidates (как SilentAim)
local function buildTargetPool(cam, losOrigin, maxDist, maxAngle)
	maxAngle = maxAngle or 179
	if cam and Bridge.collectAimActorCandidates then
		local fromAim = Bridge.collectAimActorCandidates(cam, losOrigin, maxDist, maxAngle)
		if #fromAim > 0 then
			return fromAim, "ka.aim"
		end
	end

	local pool = {}
	local maxScan = CONFIG.KillAuraMaxScan or 18
	local distSqMax = maxDist * maxDist
	for _, data in pairs(State.actors or {}) do
		if not Bridge.isEnemyActor(data) then continue end
		if Bridge.isActorDead and Bridge.isActorDead(data) then continue end
		local pos = kaRefPos(data)
		if not pos then continue end
		local dx, dy, dz = pos.X - losOrigin.X, pos.Y - losOrigin.Y, pos.Z - losOrigin.Z
		if dx * dx + dy * dy + dz * dz > distSqMax then continue end
		pool[#pool + 1] = { data = data, d2 = dx * dx + dy * dy + dz * dz }
	end
	if #pool == 0 then return {}, "ka.empty" end
	table.sort(pool, function(a, b) return a.d2 < b.d2 end)
	local out = {}
	for i = 1, math.min(#pool, maxScan) do
		out[i] = pool[i].data
	end
	return out, "ka.near"
end

local function kaTrySharedAimTarget(actor, cam, maxDist, maxAngle)
	local uid = State.aimTargetUid
	if not uid or not State.actors then return nil end
	local data = State.actors[uid] or State.actors[tonumber(uid)]
	if not data or not Bridge.isEnemyActor(data) then return nil end
	if Bridge.isActorDead and Bridge.isActorDead(data) then return nil end
	local losOrigin = kaLosOrigin(actor)
	local part, point = resolveKaAim(data, losOrigin, cam, maxAngle)
	if typeof(point) ~= "Vector3" then return nil end
	if (point - losOrigin).Magnitude > maxDist + 0.5 then return nil end
	return data, part, point
end

local function kaCommitPick(best, bestPart, bestPoint, source)
	State.kaTarget = best
	State.kaTargetUid = best.uid
	State.kaAimPart = bestPart
	State.kaAimPoint = bestPoint
	State.kaTargetTime = os.clock()
	State.kaLastPickSource = source
	kaLastPickT = os.clock()
	return best, bestPart, bestPoint
end

local function pickTarget(force, actor)
	local iv = CONFIG.KillAuraPickInterval or 0.35
	if not force then
		if State.kaTarget and typeof(State.kaAimPoint) == "Vector3" and os.clock() - kaLastPickT < iv then
			return State.kaTarget, State.kaAimPart, State.kaAimPoint
		end
	else
		kaPrepActorsForPick(true)
	end

	clearKaTarget()

	local cam = getCamera()
	if not cam then return nil, nil, nil end

	local maxDist = kaDist()
	local maxAngle = math.min((CONFIG.KillAuraFOV or 360) * 0.5, 179)
	local losOrigin = kaLosOrigin(actor)

	local sharedData, sharedPart, sharedPoint = kaTrySharedAimTarget(actor, cam, maxDist, maxAngle)
	if sharedData then
		return kaCommitPick(sharedData, sharedPart, sharedPoint, "ka.shared")
	end

	local pool, source = buildTargetPool(cam, losOrigin, maxDist, maxAngle)
	if #pool == 0 then
		State.kaLastPickSource = source .. ":empty"
		return nil, nil, nil
	end

	local best, bestDist, bestPart, bestPoint = nil, math.huge, nil, nil
	for _, data in ipairs(pool) do
		if not Bridge.isEnemyActor(data) then continue end
		if Bridge.isActorDead and Bridge.isActorDead(data) then continue end

		local pos = getEspActorPos(data)
		if not pos then continue end
		local d = (pos - losOrigin).Magnitude
		if d > maxDist then continue end

		local part, point = resolveKaAim(data, losOrigin, cam, maxAngle)
		if typeof(point) ~= "Vector3" then continue end
		if not part and not data.inInactiveWorld then continue end

		if CONFIG.KillAuraPreferPlayers ~= false
			and Bridge.isPlayerActorClass
			and Bridge.isPlayerActorClass(data.class)
			and best and not Bridge.isPlayerActorClass(best.class) then
			best, bestDist, bestPart, bestPoint = data, d, part, point
			continue
		end
		if d < bestDist then
			best, bestDist, bestPart, bestPoint = data, d, part, point
		end
	end

	if not best then
		State.kaLastPickSource = source .. ":filtered"
		return nil, nil, nil
	end

	return kaCommitPick(best, bestPart, bestPoint, source)
end

local function validateTarget(actor)
	if not State.kaTarget then return false end
	if typeof(State.kaAimPoint) ~= "Vector3" and not State.kaAimPart then return false end
	if not Bridge.isEnemyActor(State.kaTarget) then clearKaTarget() return false end
	if Bridge.isActorDead and Bridge.isActorDead(State.kaTarget) then clearKaTarget() return false end
	if State.kaAimPart and not State.kaAimPart.Parent and not State.kaTarget.inInactiveWorld then
		clearKaTarget()
		return false
	end

	local losOrigin = kaLosOrigin(actor)
	local pos = getEspActorPos(State.kaTarget)
		or (State.kaAimPart and State.kaAimPart.Position)
		or State.kaAimPoint
	if typeof(pos) ~= "Vector3" then clearKaTarget() return false end
	if (pos - losOrigin).Magnitude > kaDist() + 1 then clearKaTarget() return false end

	State.kaAimPoint = pos
	return true
end

local function getHandlerMethod(handler, name)
	if type(handler) ~= "table" or type(name) ~= "string" then return nil end
	local direct = rawget(handler, name)
	if type(direct) == "function" then return direct end
	local mt = getmetatable(handler)
	if type(mt) == "table" then
		local fromMt = rawget(mt, name)
		if type(fromMt) == "function" then return fromMt end
	end
	local ok, fn = pcall(function() return handler[name] end)
	if ok and type(fn) == "function" then return fn end
	return nil
end

local function handlerHasImpact(handler)
	return getHandlerMethod(handler, "Impact") ~= nil
end

local function getEquippedRep(actor)
	if type(actor) ~= "table" then return nil end
	local eq = rawget(actor, "_equipped")
	local inv = rawget(actor, "_inventory")
	if not eq or type(inv) ~= "table" then return nil end
	local h = inv[eq] or inv[tonumber(eq)]
	if handlerHasImpact(h) then return h end
	-- Fallback: в Flux actor._inventory хранит MeleeInventoryREPLICATOR
	-- Если он не прошёл handlerHasImpact, попробуем найти через перебор inventory
	for _, v in pairs(inv) do
		if handlerHasImpact(v) then return v end
	end
	return nil
end

local function clearMeleeBoot()
	State.kaCtx = nil
	State.kaCtxEq = nil
	State.kaCtxTime = 0
	State.kaMeleeSvc = nil
	State.kaBootEq = nil
	State.kaUseEnv = nil
	State.kaSvcSrc = nil
	State.kaWarmupDone = false
	State.kaWarmupEq = nil
	State.kaWarmupBusy = false
	State.kaModsAppliedEq = nil
	State.kaGcScanEq = nil
end

local function peekLocalActorLight()
	if not kaIsLocalAlive() then return nil, nil end
	local client = State.localClient
	if client and Bridge.getActorTable then
		local actor = Bridge.getActorTable(client)
		if type(actor) == "table" then return client, actor end
	end
	return Bridge.resolveLocalActor(false)
end

local function resolveMeleeContext(force)
	if not kaIsLocalAlive() and force ~= true then
		return nil
	end
	local _, actor
	if force == true then
		_, actor = Bridge.resolveLocalActor(true)
		if not actor then
			_, actor = Bridge.resolveLocalActor(true)
		end
	else
		_, actor = peekLocalActorLight()
	end
	if not actor then
		if State.kaCtx ~= nil and kaIsLocalAlive() then clearMeleeBoot() end
		return nil
	end

	local eq = rawget(actor, "_equipped")
	local eqStr = eq and tostring(eq) or ""
	local cacheSec = CONFIG.KillAuraCtxCacheSec or 3

	if force ~= true and State.kaCtx and State.kaCtxEq == eqStr
		and os.clock() - (State.kaCtxTime or 0) < cacheSec then
		return State.kaCtx
	end

	local rep = getEquippedRep(actor)
	if not rep then
		if State.kaCtxEq ~= eqStr then
			if State.kaCtx ~= nil then clearMeleeBoot() end
			State.kaCtxEq = eqStr
			State.kaCtx = nil
			State.kaCtxTime = os.clock()
		end
		return nil
	end

	local item = (Bridge.itemFromActorInventory and Bridge.itemFromActorInventory(actor, eq))
		or rawget(rep, "_item")
	local ctx = {
		actor = actor,
		handler = rep,
		item = item,
		isMelee = true,
		info = {
			caliber = "melee",
			name = rawget(rep, "_build") or "melee",
			slot = "Melee",
		},
	}
	if force == true then
		local mods = Bridge.loadSharedModules()
		local built = item and Bridge.buildWeaponContext(actor, item, "Melee", mods)
		if built then
			built.isMelee = true
			built.handler = rep
			ctx = built
		end
	end

	State.kaMeleeRep = rep
	if State.kaCtxEq ~= eqStr then
		State.kaWarmupDone = false
		State.kaWarmupEq = nil
		State.kaWarmupBusy = false
		State.kaModsAppliedEq = nil
		State.kaMeleeSvc = nil
		State.kaBootEq = nil
		State.kaUseEnv = nil
		State.kaGcScanEq = nil
	end
	State.kaCtx = ctx
	State.kaCtxEq = eqStr
	State.kaCtxTime = os.clock()
	return ctx
end

-- ── Melee net + Impact (определяется ниже, forward decl) ──

local function getActorRef(ctx)
	if ctx and type(ctx.actor) == "table" then return ctx.actor end
	if ctx and type(ctx.handler) == "table" and type(rawget(ctx.handler, "_actor")) == "table" then
		return rawget(ctx.handler, "_actor")
	end
	local _, a = Bridge.resolveLocalActor(false)
	return a
end

-- ── MeleeInventory svc (InventoryService, не replicator) ──

local function actorUidOf(actor)
	if type(actor) ~= "table" then return nil end
	return rawget(actor, "UID") or rawget(actor, "_uid")
end

local function actorsMatch(a, b)
	if a == b then return true end
	if type(a) ~= "table" or type(b) ~= "table" then return false end
	local ua, ub = actorUidOf(a), actorUidOf(b)
	if ua ~= nil and ub ~= nil then return tostring(ua) == tostring(ub) end
	return false
end

local function isLocalActorTable(act)
	if type(act) ~= "table" then return false end
	if rawget(act, "IsLocalPlayer") == true then return true end
	local char = rawget(act, "Character")
	local lp = Players.LocalPlayer
	if lp and char and char == lp.Character then return true end
	local _, la = Bridge.resolveLocalActor(false)
	return actorsMatch(act, la) or actorsMatch(act, State.localClient)
end

local function kaIsReadyNet(net)
	if type(net) ~= "table" then return false end
	if type(rawget(net, "FireServer")) ~= "function" then return false end
	if rawget(net, "_code") == nil then return false end
	local key = rawget(net, "_key")
	return type(key) == "table" and type(key[1]) == "number" and type(key[5]) == "number"
end

local function isMeleeSvcTable(obj)
	if type(obj) ~= "table" then return false end
	if type(getHandlerMethod(obj, "_use")) ~= "function" then return false end
	if handlerHasImpact(obj) then return false end
	return true
end

local function kaScanActorTablesForSvc(actor, rep)
	if type(actor) ~= "table" then return nil end
	for _, key in ipairs({ "_inventoryService", "_service", "_svc", "_parent" }) do
		if type(rep) == "table" then
			local v = rawget(rep, key)
			if isMeleeSvcTable(v) then return v end
		end
	end
	local inv = rawget(actor, "_inventory")
	local eq = rawget(actor, "_equipped")
	if type(inv) == "table" and eq then
		local h = inv[eq] or inv[tonumber(eq)]
		if isMeleeSvcTable(h) then return h end
	end
	return nil
end

local function kaScanMeleeSvcGc(actor, rep, eqUid, buildHint)
	if type(getgc) ~= "function" then return nil end
	local build = (rep and rawget(rep, "_build")) or buildHint
	local bestSvc, bestScore = nil, 0
	for _, obj in getgc(true) do
		if not isMeleeSvcTable(obj) then continue end
		local score = 2
		if build and rawget(obj, "_build") == build then score += 10 end
		if actorsMatch(rawget(obj, "_actor"), actor) then score += 20 end
		if isLocalActorTable(rawget(obj, "_actor")) then score += 15 end
		local item = rawget(obj, "_item")
		if eqUid and type(item) == "table" then
			local meta = rawget(item, "MetaData")
			local iuid = meta and rawget(meta, "UID")
			if iuid and tostring(iuid) == tostring(eqUid) then score += 25 end
		end
		if score > bestScore then
			bestSvc, bestScore = obj, score
		end
	end
	if bestSvc then State.kaSvcSrc = "getgc.async" end
	return bestSvc
end

local function kaScanMeleeSvc(actor, rep, eqUid, buildHint)
	-- Путь 1: shared.import("InventoryService")._inventories
	-- В Flux: InventoryService._inventories[group][i] = {UID, Handler=MeleeInventory}
	-- MeleeInventory имеет _use (нужен нам), а actor._inventory хранит MeleeInventoryREPLICATOR (нет _use)
	if type(shared) == "table" and type(shared.import) == "function" then
		local ok, invSvc = pcall(shared.import, "InventoryService")
		if ok and type(invSvc) == "table" then
			local inventories = rawget(invSvc, "_inventories")
			if type(inventories) == "table" then
				for _, group in pairs(inventories) do
					if type(group) ~= "table" then continue end
					for _, slot in ipairs(group) do
						if type(slot) ~= "table" then continue end
						local handler = rawget(slot, "Handler")
						if not isMeleeSvcTable(handler) then continue end
						local slotUid = rawget(slot, "UID")
						if not eqUid or (slotUid ~= nil and tostring(slotUid) == tostring(eqUid)) then
							State.kaSvcSrc = "invSvc._inventories"
							return handler
						end
					end
				end
			end
			-- Если eqUid не совпал ни с чем — берём первый melee handler без фильтра uid
			if eqUid then
				for _, group in pairs(inventories) do
					if type(group) ~= "table" then continue end
					for _, slot in ipairs(group) do
						if type(slot) ~= "table" then continue end
						local handler = rawget(slot, "Handler")
						if isMeleeSvcTable(handler) then
							State.kaSvcSrc = "invSvc._inventories.any"
							return handler
						end
					end
				end
			end
		end
	end
	-- Путь 2: fallback через actor tables
	local fromActor = kaScanActorTablesForSvc(actor, rep)
	if fromActor then
		State.kaSvcSrc = "actor.scan"
		return fromActor
	end
	return nil
end

local function kaExtractUseEnv(svc)
	if not svc then return nil end
	if State.kaUseEnv and State.kaUseEnv.svc == svc then return State.kaUseEnv end
	local useFn = getHandlerMethod(svc, "_use")
	if type(useFn) ~= "function" or type(debug) ~= "table" then return nil end
	local getup = debug.getupvalue
	if type(getup) ~= "function" then return nil end

	local env = {
		svc = svc,
		net = nil,
		enum = nil,
		v3 = Bridge.vector3ToTable,
		delay = rawget(svc, "_delay"),
		distance = rawget(svc, "_distance"),
		src = "melee._use",
	}
	for i = 1, 32 do
		local ok, _, val = pcall(getup, useFn, i)
		if not ok then break end
		if not env.net and kaIsReadyNet(val) then env.net = val
		elseif type(val) == "table" and rawget(val, "ActionType") then env.enum = val
		end
	end
	if type(shared) == "table" and type(shared.import) == "function" then
		local ok, v3 = pcall(shared.import, "vector3toTable")
		if ok and type(v3) == "function" then env.v3 = v3 end
	end
	if kaIsReadyNet(env.net) then
		State.kaNetSrc = env.src
	end
	State.kaUseEnv = env
	return env
end

local function kaApplyMeleeMods(svc, ctx, eqUid)
	if CONFIG.KillAuraModifyEnabled == false or type(svc) ~= "table" then return end
	eqUid = eqUid and tostring(eqUid) or "?"
	State.kaMeleeModBackup = State.kaMeleeModBackup or {}
	if not State.kaMeleeModBackup[eqUid] then
		State.kaMeleeModBackup[eqUid] = {
			distance = rawget(svc, "_distance"),
			delay = rawget(svc, "_delay"),
			timer = rawget(svc, "_timer"),
		}
	end
	local bak = State.kaMeleeModBackup[eqUid]
	local presets = CONFIG.KillAuraModifyPresets or {}
	local baseReach = type(bak.distance) == "number" and bak.distance > 0 and bak.distance or 5
	local baseDelay = type(bak.delay) == "number" and bak.delay > 0 and bak.delay
		or (CONFIG.KillAuraImpactDelay or 0.25)
	local baseTimer = type(bak.timer) == "number" and bak.timer > 0 and bak.timer
		or (CONFIG.KillAuraSwingCooldown or 0.55)
	if presets.ExtraReach then
		rawset(svc, "_distance", baseReach * (CONFIG.KillAuraModifyReachMult or 1.4))
	end
	if presets.FastImpact then
		rawset(svc, "_delay", baseDelay * (CONFIG.KillAuraModifyDelayMult or 0.7))
	end
	if presets.FastSwing then
		rawset(svc, "_timer", baseTimer * (CONFIG.KillAuraModifyCooldownMult or 0.75))
	end
	if presets.LightWeight and ctx and type(ctx.item) == "table" then
		local meta = rawget(ctx.item, "MetaData")
		if type(meta) == "table" and type(rawget(meta, "Weight")) == "number" then
			rawset(meta, "Weight", math.max(math.floor(rawget(meta, "Weight") * 0.2), 1))
		end
	end
end

local function kaGetActionTypeInv()
	if kaActionTypeInv then return kaActionTypeInv end
	if State.kaUseEnv and State.kaUseEnv.enum and State.kaUseEnv.enum.ActionType then
		kaActionTypeInv = State.kaUseEnv.enum.ActionType.Inventory
		return kaActionTypeInv
	end
	if type(shared) == "table" and type(shared.import) == "function" then
		local ok, e = pcall(shared.import, "Enum")
		if ok and e and e.ActionType then
			kaActionTypeInv = e.ActionType.Inventory
			return kaActionTypeInv
		end
	end
	return nil
end

local function kaGetMeleeBuildCfg(build)
	if not build then return nil end
	if not kaSharedMeleeCfg then
		local ok, mods = pcall(Bridge.loadSharedModules)
		kaSharedMeleeCfg = ok and type(mods) == "table" and mods.Melee or false
	end
	if type(kaSharedMeleeCfg) ~= "table" then return nil end
	return kaSharedMeleeCfg[build]
end

local function kaFinishWarmupSvc(actor, rep, eqUid, ctx)
	local svc = State.kaMeleeSvc
	if not svc then return end
	if State.kaModsAppliedEq ~= eqUid then
		pcall(kaApplyMeleeMods, svc, ctx, eqUid)
		State.kaModsAppliedEq = eqUid
	end
	if not State.kaUseEnv or State.kaUseEnv.svc ~= svc then
		pcall(kaExtractUseEnv, svc)
	end
	kaGetActionTypeInv()
end

local function kaMeleeSvcReady(eqUid)
	eqUid = eqUid and tostring(eqUid) or nil
	return State.kaMeleeSvc ~= nil
		and State.kaBootEq == eqUid
		and type(getHandlerMethod(State.kaMeleeSvc, "_use")) == "function"
end

local function kaBootMeleeSync(actor, ctx, allowGc)
	if not actor or not ctx then return false end
	local rep = ctx.handler or getEquippedRep(actor)
	local eq = rawget(actor, "_equipped")
	local eqUid = eq and tostring(eq) or nil
	if not rep or not eqUid then return false end

	if kaMeleeSvcReady(eqUid) then
		kaFinishWarmupSvc(actor, rep, eqUid, ctx)
		return true
	end

	local svc = kaScanMeleeSvc(actor, rep, eqUid, rep and rawget(rep, "_build"))
	if not svc and allowGc == true and CONFIG.KillAuraWarmupGc ~= false and type(getgc) == "function" then
		svc = kaScanMeleeSvcGc(actor, rep, eqUid, rep and rawget(rep, "_build"))
		if svc then State.kaGcScanEq = eqUid end
	end
	if not svc then return false end

	State.kaMeleeSvc = svc
	State.kaBootEq = eqUid
	State.kaSvcSrc = State.kaSvcSrc or (allowGc == true and "boot.sync.gc" or "boot.sync")
	kaFinishWarmupSvc(actor, rep, eqUid, ctx)
	if State.kaCtxEq then
		State.kaWarmupEq = State.kaCtxEq
		State.kaWarmupDone = true
	end
	return true
end

local function kaWarmupMeleeGc(actor, rep, eqUid, ctx)
	if CONFIG.KillAuraWarmupGc == false or type(getgc) ~= "function" then return end
	if State.kaGcScanEq == eqUid then return end
	if State.kaMeleeSvc and State.kaBootEq == eqUid then return end
	State.kaGcScanEq = eqUid
	task.spawn(function()
		if not State.running or not CONFIG.KillAura then return end
		if State.kaBootEq and State.kaBootEq ~= eqUid then return end
		local gcSvc = kaScanMeleeSvcGc(actor, rep, eqUid, rep and rawget(rep, "_build"))
		if not gcSvc then return end
		if State.kaMeleeSvc and State.kaBootEq ~= eqUid then return end
		State.kaMeleeSvc = gcSvc
		State.kaBootEq = eqUid
		kaFinishWarmupSvc(actor, rep, eqUid, ctx)
	end)
end

local function kaWarmupMelee(actor, ctx)
	local eqStr = State.kaCtxEq
	if not eqStr or not actor or not ctx then return end
	if State.kaWarmupEq == eqStr and State.kaWarmupDone then return end
	if State.kaWarmupBusy then return end
	State.kaWarmupBusy = true
	-- FIX 2: помечаем eqStr ДО defer — предотвращаем дублирующий warmup
	State.kaWarmupEq = eqStr
	task.defer(function()
		if not State.running or not CONFIG.KillAura then
			State.kaWarmupBusy = false
			return
		end
		local rep = ctx.handler or getEquippedRep(actor)
		local eq = rawget(actor, "_equipped")
		local eqUid = eq and tostring(eq) or nil
		pcall(ensureRepImpactHook, actor, ctx)
		if not State.kaMeleeSvc or State.kaBootEq ~= eqUid then
			local svc = kaScanMeleeSvc(actor, rep, eqUid, rep and rawget(rep, "_build"))
			if svc then
				State.kaMeleeSvc = svc
				State.kaBootEq = eqUid
				State.kaSvcSrc = State.kaSvcSrc or "warmup.scan"
			end
		end
		local svc = State.kaMeleeSvc
		if svc then
			kaFinishWarmupSvc(actor, rep, eqUid, ctx)
		else
			kaWarmupMeleeGc(actor, rep, eqUid, ctx)
		end
		State.kaWarmupEq = eqStr
		State.kaWarmupDone = true
		State.kaWarmupBusy = false
	end)
end

local function kaApplySilentWeaponModify(ctx)
	if CONFIG.KillAuraApplySilentModify == false then return end
	if CONFIG.ModifyEnabled == false then return end
	if type(Bridge.applyWeaponModify) ~= "function" then return end
	if ctx and ctx.isMelee and not ctx.tune then return end
	pcall(Bridge.applyWeaponModify, false)
end

kaEnsureMeleeSvc = function(actor, rep, eqUid, buildHint, ctx)
	eqUid = eqUid and tostring(eqUid) or nil
	rep = rep or (actor and getEquippedRep(actor))
	ctx = ctx or State.kaCtx
	if kaBootMeleeSync(actor, ctx, false) then
		return State.kaMeleeSvc, State.kaUseEnv
	end
	if actor and ctx then
		kaWarmupMelee(actor, ctx)
	end
	return State.kaMeleeSvc, State.kaUseEnv
end

local function kaTriggerGameMeleeUse(svc)
	local useFn = getHandlerMethod(svc, "_use")
	if type(useFn) ~= "function" then return false, "no_use" end
	if State.kaUseThreadActive then
		local since = State.kaUseThreadSince or 0
		if since > 0 and os.clock() - since < 1.5 then
			return false, "use_busy"
		end
		State.kaUseThreadActive = false
	end

	local delay = rawget(svc, "_delay")
	if type(delay) ~= "number" or delay <= 0 then
		delay = CONFIG.KillAuraImpactDelay or 0.25
	end
	local timer = rawget(svc, "_timer")
	if type(timer) ~= "number" or timer <= 0 then
		timer = CONFIG.KillAuraSwingCooldown or 0.55
	end

	State.kaUseThreadActive = true
	State.kaUseThreadSince = os.clock()
	task.spawn(function()
		pcall(function() useFn(svc, true) end)
		State.kaUseThreadActive = false
	end)
	task.delay(delay + 0.1, function()
		pcall(function() useFn(svc, false) end)
	end)
	return true, delay + timer
end

local function getMeleeTiming(ctx, actor)
	local reach, delay = 5, CONFIG.KillAuraImpactDelay or 0.25
	local env = State.kaUseEnv
	if env then
		if type(env.distance) == "number" and env.distance > 0 then reach = env.distance end
		if type(env.delay) == "number" and env.delay > 0 then delay = env.delay end
		return reach, delay
	end
	local handler = ctx and ctx.handler
	if type(handler) == "table" then
		local build = rawget(handler, "_build")
		if type(build) == "string" then
			local cfg = kaGetMeleeBuildCfg(build)
			if type(cfg) == "table" then
				if type(cfg.Reach) == "number" and cfg.Reach > 0 then reach = cfg.Reach end
				if type(cfg.Delay) == "number" and cfg.Delay > 0 then delay = cfg.Delay end
			end
		end
	end
	return reach, delay
end

local function kaImpactDir(actor, aimPart, reach)
	local aimPoint = State.kaAimPoint
	local cam = Workspace.CurrentCamera
	if typeof(aimPoint) ~= "Vector3" and aimPart and aimPart.Parent then
		aimPoint = aimPart.Position
	end
	if typeof(aimPoint) ~= "Vector3" then
		return cam and cam.CFrame.LookVector * reach or Vector3.new(0, 0, -reach)
	end
	if type(actor) == "table" then
		local cf = rawget(actor, "CFrame")
		if typeof(cf) == "CFrame" then
			local origin = cf:PointToWorldSpace(Vector3.new(0, 2.5, 0))
			local to = aimPoint - origin
			if to.Magnitude > 0.05 then return to.Unit * reach end
		end
	end
	return cam and (aimPoint - cam.CFrame.Position).Unit * reach or Vector3.new(0, 0, -reach)
end

local function kaFallbackMeleeSwing(actor, ctx, aimPart, targetUid, delay)
	if type(actor.Action) ~= "function" then return false, "no_action" end
	local at = kaGetActionTypeInv()
	if not at then return false, "no_enum" end
	local reach = 5
	if State.kaUseEnv and type(State.kaUseEnv.distance) == "number" then
		reach = State.kaUseEnv.distance
	else
		reach = select(1, getMeleeTiming(ctx, actor))
	end
	local slashVar = math.random(1, 3)
	pcall(function() actor:Action(at, "Slash", slashVar) end)
	if Bridge.networkFireServer then
		pcall(Bridge.networkFireServer, "InventoryAction", "Slash", slashVar)
	end
	task.delay(delay, function()
		local dir = kaImpactDir(actor, aimPart, reach)
		State.kaImpactSteer = true
		State.kaImpactPart = aimPart
		State.kaImpactUid = targetUid
		State.kaMeleeForceRaycast = CONFIG.KillAuraForceHit ~= false
		local rep = getEquippedRep(actor)
		local hitPos, uid, bone = actor:Action(at, "Impact", dir)
		State.kaMeleeForceRaycast = false
		if CONFIG.KillAuraForceHit ~= false and rep and (typeof(hitPos) ~= "Vector3" or uid == nil) then
			hitPos, uid, bone = kaForceMeleeClientImpact(rep, aimPart, targetUid, State.kaTarget)
		end
		State.kaImpactSteer = false
		State.kaImpactPart = nil
		State.kaImpactUid = nil
		if typeof(hitPos) == "Vector3" and uid ~= nil and bone and Bridge.networkFireServer then
			local t = Bridge.vector3ToTable and Bridge.vector3ToTable(hitPos)
			if t then
				pcall(Bridge.networkFireServer, "InventoryAction", "Impact", t, uid, bone)
			end
		end
	end)
	State.kaLastSlashNet = "fallback.Action"
	State.kaLastImpactMode = "fallback.Action"
	State.kaLastImpactNet = "fallback.Action"
	return true, "fallback.Action"
end

local function kaTryBulletLand(self, origin, hitPos, part)
	if CONFIG.KillAuraClientHitFx == false and CONFIG.KillAuraBloodEffects ~= true then return end
	local build = type(self) == "table" and rawget(self, "_build") or "knife"
	if not State.kaFxService and type(shared) == "table" and type(shared.import) == "function" then
		local ok, fx = pcall(shared.import, "EffectsService")
		if ok then State.kaFxService = fx end
	end
	local fx = State.kaFxService
	if fx and type(fx.BulletLand) == "function" then
		pcall(fx.BulletLand, fx, origin, hitPos, part, Vector3.new(0, 1, 0), "Blood", "melee_" .. tostring(build))
	end
end

local function kaResolveMeleeHitPart(aimPart, targetData)
	if aimPart and aimPart:IsA("BasePart") and aimPart.Parent then return aimPart end
	local td = targetData or State.kaTarget
	if type(td) == "table" and td.model and td.model.Parent then
		local p = td.model:FindFirstChild("Head")
			or td.model:FindFirstChild("UpperTorso")
			or td.model:FindFirstChild("HumanoidRootPart")
			or td.root
		if p and p:IsA("BasePart") then return p end
	end
	if aimPart and aimPart:IsA("BasePart") then return aimPart end
	return nil
end

local function kaHasValidAim(aimPart, aimPoint, targetData)
	if typeof(aimPoint) ~= "Vector3" then return false end
	if aimPart and aimPart.Parent then return true end
	if type(targetData) == "table" and targetData.inInactiveWorld then return true end
	if kaResolveMeleeHitPart(aimPart, targetData) then return true end
	return typeof(aimPoint) == "Vector3"
end

local function kaResolveHitUid(targetUid, aimPart)
	if targetUid ~= nil then
		if Bridge.normalizeActorUid then return Bridge.normalizeActorUid(targetUid) end
		return tostring(targetUid)
	end
	if aimPart then
		local a = aimPart:GetAttribute("ActorUID")
		if a ~= nil then return tostring(a) end
	end
	return nil
end

local function kaApplyClientMeleeFx(self, aimPart, hitPos)
	if CONFIG.KillAuraClientHitFx == false and CONFIG.KillAuraBloodEffects ~= true then return end
	if typeof(hitPos) ~= "Vector3" then return end
	local fxPart = kaResolveMeleeHitPart(aimPart, State.kaTarget) or aimPart
	local act = type(self) == "table" and rawget(self, "_actor")
	local cf = act and rawget(act, "CFrame")
	local origin = typeof(cf) == "CFrame" and cf:PointToWorldSpace(Vector3.new(0, 2.5, 0)) or hitPos
	kaTryBulletLand(self, origin, hitPos, fxPart)
end

local function kaForceMeleeClientImpact(self, aimPart, targetUid, targetData)
	local part = kaResolveMeleeHitPart(aimPart, targetData)
	local hitPos = State.kaAimPoint
	if typeof(hitPos) ~= "Vector3" then
		hitPos = part and part.Position
	end
	if typeof(hitPos) ~= "Vector3" then return nil end

	local uid = kaResolveHitUid(targetUid, part or aimPart)
	local bone = (part and part.Name) or "Head"

	local rep = type(self) == "table" and rawget(self, "Replicator")
	if rep and type(rep.GetFromBodyPart) == "function" and part then
		local gotUid, actorObj = rep:GetFromBodyPart(part)
		if gotUid ~= nil then
			uid = Bridge.normalizeActorUid and Bridge.normalizeActorUid(gotUid) or tostring(gotUid)
		end
		if type(actorObj) == "table" and actorObj.Zombie and type(actorObj.Flinch) == "function" then
			pcall(actorObj.Flinch, actorObj, bone)
		end
	end

	if uid == nil then return nil end
	if CONFIG.KillAuraClientHitFx ~= false then
		kaApplyClientMeleeFx(self, part or aimPart, hitPos)
	end
	return hitPos, uid, bone
end

local function kaSyntheticImpact(self, aimPart, targetUid, targetData)
	local hitPos = State.kaAimPoint
	if typeof(hitPos) ~= "Vector3" then
		hitPos = aimPart and aimPart.Position
	end
	if typeof(hitPos) ~= "Vector3" then return nil end
	local part = kaResolveMeleeHitPart(aimPart, targetData)
	local uid = kaResolveHitUid(targetUid, part or aimPart)
	if uid == nil then return nil end
	return hitPos, uid, (part and part.Name) or (aimPart and aimPart.Name) or "Head"
end

local function kaSteeredImpact(self, dir, origImpact)
	if type(origImpact) ~= "function" then return nil end

	local aimPart = State.kaImpactPart
	local targetUid = State.kaImpactUid
	local targetData = State.kaTarget
	local hasAim = aimPart or typeof(State.kaAimPoint) == "Vector3"
	if not hasAim then
		return origImpact(self, dir)
	end

	if CONFIG.KillAuraForceHit ~= false then
		local reach = typeof(dir) == "Vector3" and dir.Magnitude or 0
		if reach <= 0.05 then
			reach = rawget(self, "_distance")
		end
		if type(reach) ~= "number" or reach <= 0 then
			reach = 5
		end
		local actor = type(self) == "table" and rawget(self, "_actor")
		local steerDir = kaImpactDir(actor, aimPart, reach)

		State.kaMeleeForceRaycast = true
		local ok, hitPos, uid, bone = pcall(function()
			return origImpact(self, steerDir)
		end)
		State.kaMeleeForceRaycast = false

		if ok and typeof(hitPos) == "Vector3" and uid ~= nil and bone then
			return hitPos, uid, bone
		end

		local forcePos, forceUid, forceBone = kaForceMeleeClientImpact(self, aimPart, targetUid, targetData)
		if forcePos then
			return forcePos, forceUid, forceBone
		end
	end

	if not aimPart or not aimPart.Parent then
		return origImpact(self, dir)
	end

	local reach = typeof(dir) == "Vector3" and dir.Magnitude or 0
	if reach <= 0.05 then
		reach = rawget(self, "_distance")
	end
	if type(reach) ~= "number" or reach <= 0 then
		reach = 5
	end

	local actor = type(self) == "table" and rawget(self, "_actor")
	local steerDir = kaImpactDir(actor, aimPart, reach)
	local synPos, synUid, synBone = kaSyntheticImpact(self, aimPart, targetUid, targetData)
	if not synPos then
		return origImpact(self, dir)
	end
	if CONFIG.KillAuraClientHitFx ~= false then
		kaApplyClientMeleeFx(self, aimPart, synPos)
	end
	return synPos, synUid, synBone
end

local function getRepHandler(actor, ctx)
	local rep = getEquippedRep(actor)
	if rep then return rep end
	if ctx and ctx.handler and handlerHasImpact(ctx.handler) then
		return ctx.handler
	end
	return nil
end

local function findImpactFn(actor, ctx)
	local rep = getRepHandler(actor, ctx)
	return rep and getHandlerMethod(rep, "Impact")
end

ensureRepImpactHook = function(actor, ctx)
	if type(hookfunction) ~= "function" then return false end
	local impactFn = findImpactFn(actor, ctx)
	if type(impactFn) ~= "function" then return false end

	State.kaImpactHookedFns = State.kaImpactHookedFns or {}
	if State.kaImpactHookedFns[impactFn] then return true end

	local origImpact
	origImpact = hookfunction(impactFn, (type(newcclosure) == "function" and newcclosure or function(f) return f end)(function(self, dir, ...)
		if State.kaImpactSteer and (State.kaImpactPart or typeof(State.kaAimPoint) == "Vector3") then
			return kaSteeredImpact(self, dir, origImpact)
		end
		return origImpact(self, dir, ...)
	end, "MeleeImpact"))

	State.kaImpactHookedFns[impactFn] = origImpact
	State.kaImpactFnHooked = true
	State.kaOrigImpact = origImpact
	return true
end

local function kaSwingCooldown(ctx, actor)
	local cd = CONFIG.KillAuraSwingCooldown or 0.55
	if State.kaMeleeSvc then
		local t = rawget(State.kaMeleeSvc, "_timer")
		if type(t) == "number" and t > 0 then cd = t end
	elseif ctx and ctx.handler then
		local cfg = kaGetMeleeBuildCfg(rawget(ctx.handler, "_build"))
		if cfg and type(cfg.Cooldown) == "number" and cfg.Cooldown > 0 then
			cd = cfg.Cooldown
		end
	end
	return cd
end

local function kaSwingDelay(ctx, actor)
	local _, delay = getMeleeTiming(ctx, actor)
	if State.kaMeleeSvc then
		local d = rawget(State.kaMeleeSvc, "_delay")
		if type(d) == "number" and d > 0 then delay = d end
	end
	return delay
end

local function kaBeginSwingState(aimPart, aimPoint, targetData)
	State.kaImpactSteer = true
	State.kaImpactPart = aimPart
	State.kaImpactUid = targetData and targetData.uid
	if typeof(aimPoint) == "Vector3" then
		State.kaAimPoint = aimPoint
	end
	State.kaSwingBusy = true
end

local function kaMarkSwingSuccess()
	State.kaLastSwing = os.clock()
	State.kaSwingCount = (State.kaSwingCount or 0) + 1
end

local function kaEndSwingState(delaySec)
	task.delay(delaySec + 0.05, function()
		State.kaImpactSteer = false
		State.kaImpactPart = nil
		State.kaImpactUid = nil
		State.kaSwingBusy = false
	end)
end

local function performSwing(actor, ctx, aimPart, aimPoint, targetData, resetCd)
	if State.kaSwingBusy then return false, "busy" end
	if type(actor) ~= "table" then return false, "no_actor" end
	if not kaHasValidAim(aimPart, aimPoint, targetData) then return false, "no_part" end

	local cd = kaSwingCooldown(ctx, actor)
	if not resetCd and os.clock() - (State.kaLastSwing or 0) < cd then return false, "cooldown" end

	local losOrigin = kaLosOrigin(actor)
	local tpos = getEspActorPos(targetData) or (aimPart and aimPart.Position) or aimPoint
	local swingMax = kaDist() + 1
	if typeof(tpos) == "Vector3" and (tpos - losOrigin).Magnitude > swingMax then
		return false, "out_of_reach"
	end

	local eq = rawget(actor, "_equipped")
	local eqStr = eq and tostring(eq) or nil
	local rep = getRepHandler(actor, ctx)
	if not kaMeleeSvcReady(eqStr) then
		kaBootMeleeSync(actor, ctx, true)
		kaWarmupMelee(actor, ctx)
	end
	local svc = kaMeleeSvcReady(eqStr) and State.kaMeleeSvc
		or select(1, kaEnsureMeleeSvc(actor, rep, eq, rep and rawget(rep, "_build"), ctx))

	if type(ensureRepImpactHook) == "function" then
		pcall(ensureRepImpactHook, actor, ctx)
	end

	kaBeginSwingState(aimPart, aimPoint, targetData)

	if svc and type(getHandlerMethod(svc, "_use")) == "function" then
		local act = rawget(svc, "_actor")
		-- FIX 3: убрана проверка Sprinting — блокировала KA у двигающихся
		if type(act) == "table" and rawget(act, "Locked") then
			State.kaSwingBusy = false
			State.kaImpactSteer = false
			return false, "actor_locked"
		end
		local useOk, useInfo = kaTriggerGameMeleeUse(svc)
		if useOk then
			kaMarkSwingSuccess()
			State.kaLastSlashNet = "game._use"
			State.kaLastImpactMode = "game._use"
			State.kaLastImpactNet = "game._use"
			local settle = (type(useInfo) == "number" and useInfo > 0) and useInfo or cd
			kaEndSwingState(settle)
			return true, "game._use"
		end
		State.kaSwingBusy = false
		State.kaImpactSteer = false
		State.kaImpactPart = nil
		State.kaImpactUid = nil
	end

	local delay = kaSwingDelay(ctx, actor)
	local fbOk, fbReason = kaFallbackMeleeSwing(actor, ctx, aimPart, targetData and targetData.uid, delay)
	if not fbOk then
		State.kaImpactSteer = false
		State.kaImpactPart = nil
		State.kaImpactUid = nil
		State.kaSwingBusy = false
		return false, fbReason or "swing_fail"
	end

	kaMarkSwingSuccess()
	State.kaLastSlashNet = "fallback.Action"
	State.kaLastImpactMode = "fallback.Action"
	State.kaLastImpactNet = "fallback.Action"
	kaEndSwingState(math.max(cd, delay))
	return true, "fallback.Action"
end

local function countEnemies()
	local n, e = 0, 0
	for _, d in pairs(State.actors or {}) do
		n += 1
		if Bridge.isEnemyActor(d) then e += 1 end
	end
	return n, e
end

local function kaTickCombat(actor, ctx, autoSwing)
	kaClearSwingBusyIfStale()

	if autoSwing then
		kaPrepActorsForPick(false)
		if not validateTarget(actor) then
			pickTarget(true, actor)
		elseif os.clock() - kaLastPickT >= (CONFIG.KillAuraPickInterval or 0.35) then
			pickTarget(true, actor)
		end
	else
		if not validateTarget(actor) then
			pickTarget(false, actor)
		end
		kaWarmupMelee(actor, ctx)
	end

	local target, aimPart, aimPoint = State.kaTarget, State.kaAimPart, State.kaAimPoint
	kaUpdateViz(actor)

	if not target or typeof(aimPoint) ~= "Vector3" then
		setPhase("no_target")
		return
	end

	setPhase("active", target.label or target.uid)

	if autoSwing and os.clock() - kaLastDiagT >= 4 then
		kaLastDiagT = os.clock()
		local _, en = countEnemies()
		log(
			"KA", "auto",
			State.kaLastPhase,
			State.kaLastPickSource or "-",
			State.kaLastSkip or "-",
			"actors", State.trackedActorCount or 0,
			"enemies", en,
			"svc", State.kaMeleeSvc ~= nil,
			"tgt", target.label or target.uid
		)
	end

	if autoSwing and not State.kaSwingBusy then
		if not State.kaMeleeSvc then
			kaWarmupMelee(actor, ctx)
		end
		local ok, reason = performSwing(actor, ctx, aimPart, aimPoint, target, false)
		if not ok then setPhase("skip", reason) end
	end
end

local function tickManualAssist()
	if not kaOnLifeState() then
		setPhase("dead")
		return
	end
	local ctx = resolveMeleeContext(false)
	if not ctx then
		setPhase("no_melee")
		return
	end
	local actor = kaResolveActor(ctx)
	if not actor then return end
	ctx.actor = actor
	kaTickCombat(actor, ctx, false)
	if State.kaTarget then
		setPhase("manual", State.kaTarget.label or State.kaTarget.uid)
	elseif State.kaLastPhase ~= "no_target" then
		setPhase("manual_idle")
	end
end

local function tick()
	if not CONFIG.KillAura then
		clearKaTarget()
		return
	end
	if not kaOnLifeState() then
		setPhase("dead")
		return
	end

	if CONFIG.KillAuraAuto ~= true then
		tickManualAssist()
		return
	end

	local ctx
	local now = os.clock()
	if now - kaLastFullCtxT >= 0.8 then
		kaLastFullCtxT = now
		ctx = resolveMeleeContext(true)
	else
		ctx = resolveMeleeContext(false)
	end
	if not ctx then
		ctx = resolveMeleeContext(true)
	end
	if not ctx then
		clearKaTarget()
		State.kaMeleeWasActive = false
		setPhase("no_melee")
		return
	end

	local actor = kaResolveActor(ctx)
	if not actor then setPhase("no_actor") return end
	ctx.actor = actor
	State.kaMeleeWasActive = true
	-- Каждый тик пытаемся найти svc если ещё не найден (через InventoryService)
	local eqStr = rawget(actor, "_equipped") and tostring(rawget(actor, "_equipped")) or nil
	if not kaMeleeSvcReady(eqStr) then
		kaBootMeleeSync(actor, ctx, true)
	end
	kaTickCombat(actor, ctx, true)
end

local function dumpDebug(testSwing)
	kaPrepActorsForPick(true)
	if Bridge._refreshActorsForEsp then pcall(Bridge._refreshActorsForEsp) end

	local cam = getCamera()
	local maxDist = kaDist()
	local maxAngle = math.min((CONFIG.KillAuraFOV or 360) * 0.5, 179)
	local ctx = resolveMeleeContext(true)
	local actor = ctx and getActorRef(ctx)
	local losOrigin = kaLosOrigin(actor)
	local rep = actor and getRepHandler(actor, ctx)
	local eq = actor and rawget(actor, "_equipped")

	print("========== KillAura DEBUG (H) ==========")
	print("melee:", ctx ~= nil, "equipped:", tostring(eq), "rep:", rep ~= nil, "build:", rep and rawget(rep, "_build"))
	local svc = State.kaMeleeSvc
	local hookN = 0
	if State.kaImpactHookedFns then
		for _ in pairs(State.kaImpactHookedFns) do hookN += 1 end
	end
	print(
		"svc:", svc ~= nil,
		"useFn:", svc and type(getHandlerMethod(svc, "_use")) == "function",
		"impactHook:", State.kaImpactFnHooked == true,
		"impactHooks:", hookN,
		"forceHit:", CONFIG.KillAuraForceHit ~= false,
		"useThread:", State.kaUseThreadActive == true,
		"svcSrc:", State.kaSvcSrc or "nil",
		"reach:", svc and rawget(svc, "_distance"),
		"delay:", svc and rawget(svc, "_delay"),
		"timer:", svc and rawget(svc, "_timer")
	)
	print("warmup:", State.kaWarmupDone == true, "warmupEq:", State.kaWarmupEq or "nil")
	print("Phase:", State.kaLastPhase, "skip:", State.kaLastSkip or "-", "losOrigin:", losOrigin, "maxDist:", maxDist)

	local tn, en = countEnemies()
	print("State.actors:", tn, "isEnemyActor:", en)

	local pool, src = buildTargetPool(cam, losOrigin, maxDist, maxAngle)
	print("Pool:", #pool, "source:", src)

	print("--- enemies (kaRefPos) ---")
	local posOk, posNil = 0, 0
	for _, data in pairs(State.actors or {}) do
		if not Bridge.isEnemyActor(data) then continue end
		local pos = kaRefPos(data)
		if pos then posOk += 1 else posNil += 1 end
		local d = (typeof(pos) == "Vector3" and typeof(losOrigin) == "Vector3") and (pos - losOrigin).Magnitude or -1
		if d >= 0 and d <= maxDist + 5 then
			print(string.format(
				"  %s class=%s dist=%.1f pos=%s inactive=%s adPos=%s actorData=%s",
				tostring(data.label or data.uid), tostring(data.class), d,
				tostring(pos),
				tostring(data.inInactiveWorld),
				tostring(data.adPos),
				tostring(data.actorData ~= nil)
			))
		end
	end
	print("enemy pos ok:", posOk, "nil:", posNil)

	clearKaTarget()
	local t, part, pt = pickTarget(true, actor)
	print("PICKED:", t and (t.label or t.uid) or "NONE", "src:", State.kaLastPickSource)
	if t and pt then
		print("  dist:", (pt - losOrigin).Magnitude, "part:", part and part.Name)
	end

	if testSwing and actor and typeof(pt) == "Vector3" then
		State.kaLastSwing = 0
		State.kaSwingBusy = false
		kaBootMeleeSync(actor, ctx, true)
		local reach, delay = getMeleeTiming(ctx, actor)
		print("Melee reach:", reach, "delay:", delay)
		print("Test swing:", performSwing(actor, ctx, part, pt, t, true))
		print("Slash net:", State.kaLastSlashNet, "Impact:", State.kaLastImpactMode, State.kaLastImpactNet or "")
	end
	print("=========================================")
end

local _M = {
	CONFIG = KA_CONFIG,
	start = function()
		if kaConn then return end
		for k, v in pairs(KA_CONFIG) do CONFIG[k] = v end
		State.running = true
		pcall(function()
			if type(shared) == "table" and type(shared.import) == "function" then
				local ok, net = pcall(shared.import, "network")
				if ok and kaIsReadyNet(net) then
					State.networkModule = net
					State.networkModuleSource = "shared.import"
				end
			end
		end)
		if Bridge._refreshActorsForEsp then pcall(Bridge._refreshActorsForEsp) end
		if kaInputConn then kaInputConn:Disconnect() end
		kaInputConn = UIS.InputBegan:Connect(function(input, processed)
			if processed or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
			if input.KeyCode ~= (CONFIG.KillAuraDebugKey or Enum.KeyCode.H) then return end
			task.spawn(function() dumpDebug(true) end)
		end)
		kaGetActionTypeInv()
		local lp = Players.LocalPlayer
		if kaCharConn then kaCharConn:Disconnect() end
		if lp then
			kaCharConn = lp.CharacterAdded:Connect(function()
				-- FIX 1: grace + сброс
				kaCharGraceUntil = os.clock() + KA_CHAR_GRACE
				State.kaWasDead = false
				clearMeleeBoot()
				clearKaTarget()
				State.kaSwingBusy = false
				State.kaImpactSteer = false
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
			acc += dt
			if acc < (CONFIG.KillAuraTickInterval or 0.2) then return end
			acc = 0
			pcall(tick)
		end)
		kaVizConn = RunService.RenderStepped:Connect(function()
			if not State.running or not CONFIG.KillAura then
				kaHideViz()
				return
			end
			local actor = State.kaCtx and getActorRef(State.kaCtx)
			pcall(kaUpdateViz, actor)
		end)
		log("KA", "started | dist=", kaDist())
		task.defer(function()
			if State.running and CONFIG.KillAura then
				kaPrepActorsForPick(true)
				-- Ранний boot: пытаемся найти MeleeInventory handler через InventoryService
				local ctx = resolveMeleeContext(true)
				local actor = ctx and getActorRef(ctx)
				if actor and ctx then
					kaBootMeleeSync(actor, ctx, true)
				end
			end
		end)
	end,
	stop = function()
		if kaConn then kaConn:Disconnect() kaConn = nil end
		if kaVizConn then kaVizConn:Disconnect() kaVizConn = nil end
		kaHideViz()
		if kaInputConn then kaInputConn:Disconnect() kaInputConn = nil end
		if kaCharConn then kaCharConn:Disconnect() kaCharConn = nil end
		clearKaTarget()
		State.kaSwingBusy = false
	end,
	toggle = function()
		CONFIG.KillAura = not CONFIG.KillAura
		if CONFIG.KillAura and not kaConn then _M.start() end
		if not CONFIG.KillAura then clearKaTarget() end
		return CONFIG.KillAura
	end,
	dumpStatus = function() dumpDebug(false) end,
	debugDump = function() dumpDebug(true) end,
	setDistance = function(n) CONFIG.KillAuraDistance = n end,
	swingOnce = function()
		local ctx = resolveMeleeContext(true)
		local actor = ctx and getActorRef(ctx)
		local target, part, pt = pickTarget(true, actor)
		if not actor or typeof(pt) ~= "Vector3" then return false, "no_target" end
		State.kaLastSwing = 0
		return performSwing(actor, ctx, part, pt, target, true)
	end,
	Bridge = Bridge,
}

Bridge._killAuraModule = _M
return _M
end
