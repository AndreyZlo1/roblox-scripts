--[[
	BRM5ESP_v9 — CHANGELOG от v8:

	FIX FPS (мало NPC, 4-15 шт):
	  Масштабирование enrich/render по npcCount; skeleton/chams только для игроков.
	  Динамический EspBoxMaxActors при росте числа NPC.

	BRM5ESP_v8 — CHANGELOG от v7:

	FIX FPS (NPC-карты 100+):
	  Адаптивный enrich/render interval — при большом trackedActorCount снижаем частоту ESP.

	BRM5ESP_v7 — CHANGELOG от v6:

	FIX ZMP PLAYERS NOT VISIBLE (ESP рендер):
	  FIX #1: computeEspBoundsBox — HRP существовал в InactiveWorld (on=false),
	    tryPos бралось как hrp.Position → WorldToViewportPoint on=false → return nil.
	    Теперь: пробуем hrp, если on=false — берём actorData.SimulatedPosition (adPos).
	  FIX #2: updateESP ranked dist — root.Position=0,0,0 для InactiveWorld акторов
	    → dist считался от 0,0,0 → неверный rank. Теперь использует data.adPos.
	  FIX #3: computeEspBoundsBox adPos приоритет SimulatedPosition > ServerPosition > Position.
]]
--[[
	BRM5ESP_v2 — ESP module
	Использование:
	  local Lib = loadstring(readfile("BRM5Lib.lua"))()
	  local ESP = loadstring(readfile("BRM5ESP.lua"))()(Lib)
	  ESP.start()
--]]
return function(Lib)
local Bridge = Lib.Bridge
local CONFIG  = Lib.CONFIG
local State   = Lib.State

local ESP_CONFIG = {
	ESP                   = true,
	EspBox                = true,
	EspSkeleton           = true,
	EspChams              = false,
	EspHpBar              = true,
	EspWeaponInfo         = true,
	EspActorStatus        = true,
	EspShowSecondary      = true,
	EspShowStance         = true,
	EspShowInventory      = true,
	EspSmooth             = false,
	EspSmoothAlpha        = 1.0,
	EspRenderInterval     = 0.0167,  -- FIX v8: 60 fps (было 0.15 ~7fps)
	EspRescanInterval     = 4.0,    -- FIX v8: ресканирование каждые 4s (было 8)
	EspFullRescanInterval = 30.0,   -- FIX v8: полный ресканирование 30s (было 45)
	EspVisibleCheck       = true,
	EspVisibleStrict      = true,
	EspVisibleInterval    = 0.35,
	EspVisibleCheckNpc    = false,
	EspScanWorldModels    = false,
	EspShowDistance       = true,
	EspNpcNameOnly        = true,
	EspBoxMaxActors       = 20,
	EspSkeletonMaxActors  = 24,       -- FIX v9: было 10
	EspSkeletonMaxDist    = 800,      -- FIX v9: скелет до 800 studs
	EspBoxMaxActors       = 64,       -- FIX v9: было 30
	EspBatchSize          = 4,
	ActorSyncBatchSize    = 8,           -- v18 PATCH: синхронизировано с silentaim
	ActorEnrichBatchSize  = 2,
	EspChamsMaxActors     = 10,
	EspBoundsParts        = 4,
	EspWeaponPlayersOnly  = false,
	EspIgnoreTeam         = true,
	EspShowPlayers        = true,
	EspShowPlayersInPve   = true,  -- FIX v8: показывать игроков в PVE-зонах (ZME/CM_/OW_/HQ_)
	ForceShowAllPlayers   = true,  -- FIX v8: показывать ВСЕХ игроков независимо от режима
	EspShowFriendly       = true,
	EspShowHostile        = true,
	EspShowZombie         = true,
	EspShowNpc            = true,
	EspNpcStatus          = true,
	EspVisibleBones       = { "Head", "UpperTorso", "LowerTorso" },
	EspVisibleMinBones    = 1,
	EspBatchSize          = 6,
	ActorScanBatchSize    = 3,
	ActorEnrichBatchSize  = 4,
	DrawingHighTransparencyMeansVisible = true,
}
for k,v in pairs(ESP_CONFIG) do CONFIG[k] = v end

local SKELETON_R15 = {
	{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
	{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
	{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
	{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
	{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
}
local SKELETON_R6 = {
	{"Head","Torso"},{"Torso","Right Arm"},{"Torso","Left Arm"},
	{"Torso","Right Leg"},{"Torso","Left Leg"},
}
local ESP_COLORS = {
	team     = Color3.fromRGB(100, 200, 255),
	visible  = Color3.fromRGB(70,  255,  90),
	hidden   = Color3.fromRGB(255,  55,  55),
	teammate = Color3.fromRGB(170, 255, 170),
	dead     = Color3.fromRGB(220,  45,  45),
	self     = Color3.fromRGB(80,  220, 255),
	npc      = Color3.fromRGB(255, 200,  60),
	zombie   = Color3.fromRGB(180, 255,  80),
	-- FIX v4: hostile=красный, friendly=зелёный (логичная цветовая схема)
	hostile  = Color3.fromRGB(255,  50,  50),
	friendly = Color3.fromRGB(80,  220,  80),
	unknown  = Color3.fromRGB(180, 180, 180),
}

State.drawings        = State.drawings        or {}
State.espHighlights   = State.espHighlights   or {}
State.espVisibleCache = State.espVisibleCache or {}
State.espRanked       = nil
State.espVisibleBatchIndex = 0
State.lastEspUpdate   = 0
State.espRankedTime   = 0
State.espLastActorCount = -1

local espConn = nil
local tableField     = Bridge._tableField
local ESP_BOX_PARTS  = {
	"Head", "UpperTorso", "LowerTorso",
	"LeftFoot", "RightFoot",
	"LeftHand", "RightHand",
}
local ESP_WEAPON_TEXT = Color3.fromRGB(255, 255, 230)
local ESP_SECONDARY_TEXT = Color3.fromRGB(255, 110, 110)
local ESP_STANCE_CROUCH = Color3.fromRGB(255, 210, 100)
local ESP_STANCE_LYING = Color3.fromRGB(255, 165, 80)
local ESP_INVENTORY_TEXT = Color3.fromRGB(210, 220, 240)
local ESP_STATUS_TEXT = Color3.fromRGB(235, 235, 245)
local ESP_LABEL_SIZE = 14
local ESP_LINE_STEP = 0.52
local ESP_STACK_GAP = 3
local ESP_STATUS_CHIP_MAX = 6
local ESP_STATUS_CHIP_GAP = 2
local ESP_STATUS_KIND_COLORS = {
	weapon = Color3.fromRGB(255, 70, 70),
	combat = Color3.fromRGB(255, 70, 70),
	reload = Color3.fromRGB(255, 160, 45),
	move = Color3.fromRGB(90, 200, 255),
	stance = Color3.fromRGB(190, 170, 255),
	interact = Color3.fromRGB(255, 210, 90),
	gear = Color3.fromRGB(170, 255, 150),
}
local ESP_STATUS_ABBR = {
	Sprinting = "Sprint",
	Aiming = "Aim",
	ADS = "Aim",
	Firing = "Fire",
	Reloading = "Reload",
	Sliding = "Slide",
	Swimming = "Swim",
	Looting = "Loot",
	Dragging = "Drag",
	Dragged = "Dragged",
	Climbing = "Climb",
	Downed = "Down",
	Medical = "Med",
	Lockpick = "Lock",
	Hostage = "Host",
	Takedown = "Take",
	CQB = "CQB",
	Crouching = "Crouch",
	Prone = "Prone",
	Lying = "Lie",
}


function Bridge.isTeammateActor(data)
	if not data or data.class == "self" then return false end
	if not CONFIG.TeamCheck and not CONFIG.EspIgnoreTeam then return false end
	if data.class == "npc_friendly" then return true end
	return not Bridge.isEnemyActor(data)
end

function Bridge.shouldEspShowActor(data)
	if not data or data.class == "self" or data.class == "dead" then return false end
	if data.class == "player" then
		return CONFIG.EspShowPlayers ~= false
	end
	-- FIX v4: дистанционный фильтр для NPC — zombie 200м, остальные NPC 1000м
	if data.class == "npc_friendly" or data.class == "npc_hostile"
		or data.class == "npc_zombie" or data.class == "npc" then
		local root = data.root
		if root and root.Parent then
			local cam = workspace and workspace.CurrentCamera
			local camPos = cam and cam.CFrame.Position
			if camPos then
				local p = root.Position
				local distSq = (p.X-camPos.X)^2 + (p.Y-camPos.Y)^2 + (p.Z-camPos.Z)^2
				local maxSq = (data.class == "npc_zombie") and (200*200) or (1000*1000)
				if distSq > maxSq then return false end
			end
		end
		if data.class == "npc_friendly" then return CONFIG.EspShowFriendly ~= false end
		if data.class == "npc_hostile" then return CONFIG.EspShowHostile ~= false end
		if data.class == "npc_zombie" then return CONFIG.EspShowZombie ~= false end
		if data.class == "npc" then return CONFIG.EspShowNpc ~= false end
	end
	return true
end

function Bridge.shouldEspHideAsTeammate(data)
	if not CONFIG.EspIgnoreTeam then return false end
	if not data or data.class == "self" or data.class == "dead" then return false end
	if Bridge.isEnemyActor(data) then return false end
	if CONFIG.IgnoreTeammates ~= false then return true end
	if CONFIG.TeamCheck and State.localSquad == nil then return false end
	return Bridge.isTeammateActor(data)
end

function Bridge.getEspColor(data, visible)
	if Bridge.isActorDead(data) or data.class == "dead" then
		return ESP_COLORS.dead
	end
	if data.class == "self" then
		return ESP_COLORS.self
	end
	if Bridge.isTeammateActor(data) then
		return ESP_COLORS.teammate
	end
	-- FIX v4: NPC используют class-based цвета НЕЗАВИСИМО от EspVisibleCheck
	-- hostile = красный, friendly = зелёный, zombie = желто-зелёный
	if data.class == "npc_hostile" then
		return ESP_COLORS.hostile
	end
	if data.class == "npc_zombie" then
		return ESP_COLORS.zombie
	end
	if data.class == "npc_friendly" then
		return ESP_COLORS.friendly
	end
	if data.class == "npc" then
		return ESP_COLORS.npc
	end
	-- Для игроков: visible check работает как раньше
	if CONFIG.EspVisibleCheck then
		return visible and ESP_COLORS.visible or ESP_COLORS.hidden
	end
	if data.class == "player" then
		return ESP_COLORS.hidden
	end
	return ESP_COLORS.unknown
end

function Bridge.resolveActorHealth(data)
	if not data then return nil, nil end
	-- v17: кэш здоровья на 0.2s — не дёргаем дампы каждый кадр ESP
	local now = os.clock()
	if data._healthCache and now - (data._healthCacheT or 0) < 0.2 then
		return data._healthCache[1], data._healthCache[2]
	end
	local actorData = data.actorData
	if not actorData and data.uid then
		actorData = Bridge.getReplicatorActorData(data.uid)
		if actorData then
			data.actorData = actorData
		end
	end
	local function cacheAndReturn(hp, maxHp)
		data._healthCache = {hp, maxHp or 100}
		data._healthCacheT = now
		return hp, maxHp or 100
	end
	if type(actorData) == "table" then
		local hp = tableField(actorData, "Health")
		local maxHp = tableField(actorData, "MaxHealth") or tableField(actorData, "MaxHP")
		if type(hp) == "number" then
			return cacheAndReturn(hp, (type(maxHp) == "number" and maxHp > 0) and maxHp or 100)
		end
	end
	if type(data.health) == "number" then
		local maxHp = data.maxHealth
		if data.class == "npc_zombie" and (type(maxHp) ~= "number" or maxHp <= 0) then
			maxHp = 100
		end
		return cacheAndReturn(data.health, maxHp or 100)
	end
	local model = data.model
	if model then
		local hum = model:FindFirstChildOfClass("Humanoid")
		if hum then
			return cacheAndReturn(hum.Health, hum.MaxHealth)
		end
	end
	return nil, nil
end

function Bridge.parseWeaponFromCharacterModel(model)
	if not model or not model.Parent then return nil end
	local wm = model:FindFirstChild("WorldModel")
	local roots = wm and wm:GetChildren() or model:GetChildren()
	for _, child in ipairs(roots) do
		if child:IsA("Model") then
			local n = child.Name
			if type(n) == "string" and string.match(n, "^Firearm") then
				local display = string.gsub(n, "^FirearmPrimary", ""):gsub("^FirearmSecondary", "")
				return { name = display, cur = nil, max = nil }
			end
		end
	end
	return nil
end

function Bridge.getSkeletonPairs(model)
	if not model then return SKELETON_R15 end
	if model:FindFirstChild("UpperTorso") then return SKELETON_R15 end
	if model:FindFirstChild("Torso") then return SKELETON_R6 end
	return SKELETON_R15
end

function Bridge.hideEspEntry(entry, reason, detail)
	Bridge.logVizHide("ESP", reason or "entry", detail)
	if not entry then return end
	if entry.boxLines then
		for _, line in ipairs(entry.boxLines) do line.Visible = false end
	end
	if entry.skelLines then
		for _, line in ipairs(entry.skelLines) do line.Visible = false end
	end
	if entry.skelShoulderLine then entry.skelShoulderLine.Visible = false end
	if entry.skelHeadCircle then entry.skelHeadCircle.Visible = false end
	if entry.hpBg     then entry.hpBg.Visible      = false end
	if entry.hpFill   then entry.hpFill.Visible     = false end
	if entry.hpOutline then entry.hpOutline.Visible = false end
	if entry.weaponText then entry.weaponText.Visible = false end
	if entry.weaponBg then entry.weaponBg.Visible = false end
	Bridge.hideEspExtraTexts(entry)
	if entry.statusText then entry.statusText.Visible = false end
	if entry.statusBg then entry.statusBg.Visible = false end
	if entry.statusChips then
		for _, chip in ipairs(entry.statusChips) do
			chip.Visible = false
		end
	end
	if entry.text      then entry.text.Visible       = false end
	entry.smoothRect = nil
end

function Bridge.ensureEspDrawing(uid)
	local entry = State.drawings[uid]
	if entry then
		if not entry.hpOutline then
			entry.hpOutline = Drawing.new("Square")
			entry.hpOutline.Filled = false
			entry.hpOutline.Thickness = 1
			entry.hpOutline.Visible = false
			entry.hpOutline.ZIndex = 17
		end
		if not entry.weaponText then
			entry.weaponText = Drawing.new("Text")
			entry.weaponText.Size = ESP_LABEL_SIZE
			entry.weaponText.Outline = true
			entry.weaponText.Center = true
			entry.weaponText.Visible = false
			entry.weaponText.ZIndex = 24
		end
		if not entry.weaponBg then
			entry.weaponBg = Drawing.new("Square")
			entry.weaponBg.Filled = true
			entry.weaponBg.Visible = false
			entry.weaponBg.ZIndex = 22
		end
		if not entry.statusText then
			entry.statusText = Drawing.new("Text")
			entry.statusText.Size = ESP_LABEL_SIZE
			entry.statusText.Outline = true
			entry.statusText.Center = true
			entry.statusText.Visible = false
			entry.statusText.ZIndex = 24
		end
		if not entry.statusBg then
			entry.statusBg = Drawing.new("Square")
			entry.statusBg.Filled = true
			entry.statusBg.Visible = false
			entry.statusBg.ZIndex = 22
		end
		if not entry.skelHeadCircle then
			entry.skelHeadCircle = Drawing.new("Circle")
			entry.skelHeadCircle.Filled = false
			entry.skelHeadCircle.Thickness = 1.4
			entry.skelHeadCircle.NumSides = 16
			entry.skelHeadCircle.Visible = false
			entry.skelHeadCircle.ZIndex = 19
		end
		if not entry.skelShoulderLine then
			entry.skelShoulderLine = Drawing.new("Line")
			entry.skelShoulderLine.Thickness = 1.35
			entry.skelShoulderLine.Visible = false
			entry.skelShoulderLine.ZIndex = 19
		end
		return entry
	end
	entry = {
		boxLines = {},
		skelLines = {},
		skelShoulderLine = Drawing.new("Line"),
		skelHeadCircle = Drawing.new("Circle"),
		text = Drawing.new("Text"),
		statusText = Drawing.new("Text"),
		weaponText = Drawing.new("Text"),
		weaponBg = Drawing.new("Square"),
		statusBg = Drawing.new("Square"),
		hpBg = Drawing.new("Square"),
		hpFill = Drawing.new("Square"),
		hpOutline = Drawing.new("Square"),
	}
	for i = 1, 4 do
		local line = Drawing.new("Line")
		line.Thickness = 1.8
		line.Visible = false
		line.ZIndex = 20
		entry.boxLines[i] = line
	end
	for i = 1, #SKELETON_R15 do
		local line = Drawing.new("Line")
		line.Thickness = 1.4
		line.Visible = false
		line.ZIndex = 19
		entry.skelLines[i] = line
	end
	entry.skelHeadCircle.Filled = false
	entry.skelHeadCircle.Thickness = 1.4
	entry.skelHeadCircle.NumSides = 16
	entry.skelHeadCircle.Visible = false
	entry.skelHeadCircle.ZIndex = 19
	entry.skelShoulderLine.Thickness = 1.35
	entry.skelShoulderLine.Visible = false
	entry.skelShoulderLine.ZIndex = 19
	entry.text.Size = ESP_LABEL_SIZE + 1
	entry.text.Outline = true
	entry.text.Center = true
	entry.text.Visible = false
	entry.text.ZIndex = 22
	entry.statusText.Size = ESP_LABEL_SIZE
	entry.statusText.Outline = true
	entry.statusText.Center = true
	entry.statusText.Visible = false
	entry.statusText.ZIndex = 23
	entry.weaponText.Size = ESP_LABEL_SIZE
	entry.weaponText.Outline = true
	entry.weaponText.Center = true
	entry.weaponText.Visible = false
	entry.weaponText.ZIndex = 23
	entry.hpBg.Filled = true
	entry.hpBg.Visible = false
	entry.hpBg.ZIndex = 18
	entry.hpFill.Filled = true
	entry.hpFill.Visible = false
	entry.hpFill.ZIndex = 19
	entry.hpOutline.Filled = false
	entry.hpOutline.Thickness = 1
	entry.hpOutline.Visible = false
	entry.hpOutline.ZIndex = 17
	State.drawings[uid] = entry
	return entry
end

local function espStripFirearmName(name)
	if type(name) ~= "string" then return "?" end
	name = string.gsub(name, "^FirearmPrimary", "")
	name = string.gsub(name, "^FirearmSecondary", "")
	name = string.gsub(name, "^Melee", "")
	if #name > 18 then
		name = string.sub(name, 1, 16) .. ".."
	end
	return name
end

local function espGetEquippedUid(actor)
	if type(actor) ~= "table" then return nil end
	local eq = tableField(actor, "_equipped")
	if type(eq) ~= "string" or eq == "" then
		local state = tableField(actor, "CurrentState")
		eq = state and tableField(state, "Equip")
	end
	if type(eq) == "string" and eq ~= "" then return eq end
	return nil
end

local function espFindHandlerForUid(actor, uid)
	if type(actor) ~= "table" or type(uid) ~= "string" or uid == "" then return nil end
	local inv = tableField(actor, "_inventory")
	if type(inv) == "table" and type(inv[uid]) == "table" then
		return inv[uid]
	end
	if Bridge.findFirearmHandler then
		return Bridge.findFirearmHandler(actor, uid)
	end
	return nil
end

local function espCollectHotbarWeapons(actor, uid)
	local now = os.clock()
	local cache = State._espHotbarCache
	if uid and cache and cache.uid == uid and cache.t and now - cache.t < 2.0 then
		return cache.rows, cache.eqUid
	end
	local eqUid = espGetEquippedUid(actor)
	local rows = {}
	local mods = State.sharedModules
	if not mods and Bridge.loadSharedModules then
		mods = Bridge.loadSharedModules()
	end

	if Bridge.readSlotsFromActorState then
		local slots = Bridge.readSlotsFromActorState(actor, mods) or {}
		for _, slot in ipairs({ "Primary", "Secondary", "Melee" }) do
			local item = slots[slot]
			if type(item) == "table" then
				local uid = Bridge.itemUid(item)
				local name = Bridge.firearmDisplayName and Bridge.firearmDisplayName(item) or rawget(item, "Name")
				rows[#rows + 1] = {
					slot = slot,
					uid = uid,
					name = espStripFirearmName(name or "?"),
					item = item,
					handler = espFindHandlerForUid(actor, uid),
					equipped = (uid and uid == eqUid) or false,
				}
			end
		end
	end

	if #rows == 0 then
		local inv = tableField(actor, "_inventory")
		if type(inv) == "table" then
			for invUid, handler in pairs(inv) do
				if type(handler) ~= "table" then continue end
				local item = rawget(handler, "_item")
				local name = type(item) == "table" and rawget(item, "Name") or nil
				if type(name) ~= "string" or not string.match(name, "^Firearm") then continue end
				local slot = Bridge.slotLabelFromItem and Bridge.slotLabelFromItem(item, mods) or "Primary"
				rows[#rows + 1] = {
					slot = slot,
					uid = invUid,
					name = espStripFirearmName(name),
					item = item,
					handler = handler,
					equipped = (invUid == eqUid) or rawget(handler, "_equipped") == true,
				}
			end
		end
	end

	if uid then
		State._espHotbarCache = { uid = uid, rows = rows, eqUid = eqUid, t = now }
	end
	return rows, eqUid
end

local function espResolveMagMax(handler, item)
	local mods = State.sharedModules
	if not mods and Bridge.loadSharedModules then
		mods = Bridge.loadSharedModules()
	end
	if type(handler) == "table" then
		local mag = rawget(handler, "_mag")
		if type(mag) == "table" then
			local maxC = rawget(mag, "Max") or rawget(mag, "MaxCapacity") or rawget(mag, "Capacity")
			if type(maxC) == "number" and maxC > 0 then return maxC end
		end
	end
	if Bridge.resolveMagMax then
		local maxMag = Bridge.resolveMagMax(handler, item, mods)
		if type(maxMag) == "number" and maxMag > 0 then return maxMag end
	end
	if type(item) == "table" then
		local meta = rawget(item, "MetaData")
		if type(meta) == "table" then
			local magMeta = rawget(meta, "Mag")
			if type(magMeta) == "table" and type(rawget(magMeta, "Capacity")) == "number" then
				return magMeta.Capacity
			end
		end
		local firearm = rawget(item, "File")
		local tune = type(firearm) == "table" and rawget(firearm, "Tune")
		if type(tune) == "table" and type(tune.Ammo) == "number" then
			return tune.Ammo
		end
	end
	return nil
end

local function espParseActorWeaponInfo(data)
	if not data or data.dead then return nil end
	if not data.actorData and data.uid then
		data.actorData = Bridge.getReplicatorActorData(data.uid)
	end
	local actor = data.actorData
	if type(actor) ~= "table" then return nil end

	local rows, eqUid = espCollectHotbarWeapons(actor, data.uid)
	local primary, secondaryRow
	for _, row in ipairs(rows) do
		if row.equipped then
			primary = row
		elseif row.slot == "Secondary" and not secondaryRow then
			secondaryRow = row
		end
	end
	if not primary then
		for _, row in ipairs(rows) do
			if row.slot == "Primary" then
				primary = row
				break
			end
		end
	end
	if not primary and rows[1] then
		primary = rows[1]
	end
	if not primary then return nil end

	if secondaryRow and (secondaryRow.uid == primary.uid or secondaryRow.name == primary.name) then
		secondaryRow = nil
	end
	if secondaryRow and secondaryRow.equipped then
		secondaryRow = nil
	end

	data.espSecondaryName = secondaryRow and secondaryRow.name or nil
	data.espSecondarySlot = secondaryRow and secondaryRow.slot or nil

	local invNames = {}
	if CONFIG.EspShowInventory then
		local seen = { [primary.name] = true }
		if secondaryRow then seen[secondaryRow.name] = true end
		local stateInv = Bridge.actorCurrentInventory and Bridge.actorCurrentInventory(actor)
		if type(stateInv) == "table" then
			for uid, entry in pairs(stateInv) do
				if type(uid) ~= "string" or uid == eqUid then continue end
				if type(entry) ~= "table" then continue end
				local n = rawget(entry, "Name")
				if type(n) ~= "string" then continue end
				if string.match(n, "^Firearm") then continue end
				local dn = espStripFirearmName(n)
				if not seen[dn] then
					invNames[#invNames + 1] = dn
					seen[dn] = true
				end
			end
		end
	end
	data.espInventoryNames = invNames

	local handler = primary.handler or espFindHandlerForUid(actor, primary.uid)
	local item = primary.item or (handler and rawget(handler, "_item"))
	local maxMag = espResolveMagMax(handler, item)

	return {
		name = primary.name,
		max = maxMag,
	}
end

function Bridge.refreshActorWeaponInfo(data)
	if not data or data.dead then return end
	if Bridge.isNpcActorClass(data.class) then return end
	local now = os.clock()
	local ttl = CONFIG.EspWeaponInfoTtl or 2.5
	if data.weaponInfo and now - (data._weaponInfoT or 0) < ttl then return end
	local info = espParseActorWeaponInfo(data)
	if info then
		data.weaponInfo = info
		data._weaponInfoT = now
	end
end

local function espGetStanceChip(actor)
	if type(actor) ~= "table" then return nil end
	local hs = tableField(actor, "HeightState")
	if type(hs) ~= "number" then return nil end
	if hs == 2 then
		return { text = "Lying", color = ESP_STANCE_LYING }
	end
	if hs == 1 then
		return { text = "Crouching", color = ESP_STANCE_CROUCH }
	end
	return nil
end

local function espAdaptiveLabelSize(lineCount)
	lineCount = lineCount or 1
	if lineCount >= 5 then return ESP_LABEL_SIZE - 2 end
	if lineCount >= 3 then return ESP_LABEL_SIZE - 1 end
	return ESP_LABEL_SIZE
end

function Bridge.ensureEspLayoutRect(entry, cam, model, vpCache)
	if not model or not cam then
		entry._boxRect = nil
		return nil
	end
	local raw = Bridge.computeEspHeadFeetBox(model, cam, vpCache)
	if not raw then
		entry._boxRect = nil
		return nil
	end
	local rect = Bridge.smoothEspRect(entry, raw)
	entry._boxRect = rect
	return rect
end

function Bridge.ensureEspStatusChips(entry)
	entry.statusChips = entry.statusChips or {}
	for i = 1, ESP_STATUS_CHIP_MAX do
		if not entry.statusChips[i] then
			local chip = Drawing.new("Text")
			chip.Size = ESP_LABEL_SIZE
			chip.Outline = true
			chip.Center = true
			chip.Visible = false
			chip.ZIndex = 23
			entry.statusChips[i] = chip
		end
	end
	return entry.statusChips
end

local function espStatusColor(entry)
	return ESP_STATUS_KIND_COLORS[entry.kind] or ESP_STATUS_TEXT
end

local function espStatusLabel(text)
	return ESP_STATUS_ABBR[text] or text
end

local function espMeasureChipWidth(text, size)
	size = size or ESP_LABEL_SIZE
	return math.max(12, #tostring(text) * size * 0.5 + 2)
end

function Bridge.formatEspStatusLine(entries)
	if type(entries) ~= "table" then return nil end
	local parts = {}
	for _, e in ipairs(entries) do
		if e.text and e.text ~= "Armed" then
			parts[#parts + 1] = espStatusLabel(e.text)
		end
	end
	if #parts == 0 then return nil end
	return table.concat(parts, "·")
end

function Bridge.drawEspPlainText(textObj, cx, y, line, color, textSize)
	if not textObj or not line or line == "" then
		if textObj then textObj.Visible = false end
		return y
	end
	textSize = textSize or ESP_LABEL_SIZE
	textObj.Text = line
	textObj.Size = textSize
	textObj.Center = true
	textObj.Outline = true
	textObj.Color = color
	textObj.Position = Vector2.new(cx, y)
	Bridge.setDrawingAlpha(textObj, 1)
	textObj.Visible = true
	return y + textSize * ESP_LINE_STEP + ESP_STACK_GAP
end

function Bridge.hideEspStatusBar(entry)
	if not entry then return end
	if entry.statusText then entry.statusText.Visible = false end
	if entry.statusBg then entry.statusBg.Visible = false end
	if entry.statusChips then
		for _, chip in ipairs(entry.statusChips) do
			chip.Visible = false
		end
	end
end

function Bridge.removeEspChams(uid)
	local hl = State.espHighlights[uid]
	if hl then
		pcall(function() hl:Destroy() end)
		State.espHighlights[uid] = nil
	end
end

function Bridge.updateEspChams(uid, model, color)
	if not CONFIG.EspChams or not model or not model.Parent then
		Bridge.removeEspChams(uid)
		return
	end
	local hl = State.espHighlights[uid]
	if not hl or not hl.Parent then
		hl = Instance.new("Highlight")
		hl.Name = "BRM5_ESP"
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		hl.FillTransparency = 0.72
		hl.OutlineTransparency = 0.15
		hl.Parent = model
		State.espHighlights[uid] = hl
	end
	hl.Adornee = model
	hl.FillColor = color
	hl.OutlineColor = color
	if hl.Enabled ~= true then
		hl.Enabled = true
	end
end

function Bridge.computeEspBoundsBox(model, cam, vpCache)
	if not model or not cam then return nil end
	local minX, maxX, minY, maxY = math.huge, -math.huge, math.huge, -math.huge
	local footY, any = nil, false
	for _, name in ipairs(ESP_BOX_PARTS) do
		local p = model:FindFirstChild(name)
		if p and p:IsA("BasePart") then
			local sp, on
			if vpCache then
				local cached = vpCache[p]
				if cached then
					sp, on = cached[1], cached[2]
				else
					sp, on = cam:WorldToViewportPoint(p.Position)
					vpCache[p] = { sp, on }
				end
			else
				sp, on = cam:WorldToViewportPoint(p.Position)
			end
			if on and sp.Z > 0.01 then
				any = true
				local pad = math.clamp(p.Size.Magnitude * 2.5, 3, 10)
				minX = math.min(minX, sp.X - pad)
				maxX = math.max(maxX, sp.X + pad)
				minY = math.min(minY, sp.Y - pad)
				maxY = math.max(maxY, sp.Y + pad)
				if name == "LeftFoot" or name == "RightFoot" then
					footY = math.max(footY or sp.Y, sp.Y)
				end
			end
		end
	end
	if not any or minX == math.huge then
		-- FIX v7 ZMP: HRP может существовать в InactiveWorld (Parent!=nil, но on=false)
		-- Пробуем HRP сначала, при on=false — берём actorData позицию как fallback
		local hrp = model:FindFirstChild("HumanoidRootPart")
			or model:FindFirstChild("UpperTorso")
			or model:FindFirstChild("Head")
			or model:FindFirstChildWhichIsA("BasePart")
		local tryPos = nil
		if hrp then
			local sp, on = cam:WorldToViewportPoint(hrp.Position)
			if on and sp.Z > 0.01 then
				tryPos = hrp.Position
			end
		end
		-- Если HRP on=false (InactiveWorld) или нет HRP — берём actorData позицию
		if not tryPos then
			local rawUid = model:GetAttribute("ActorUID")
			local suid = rawUid and tostring(rawUid)
			local actorEntry = suid and State.actors and State.actors[suid]
			if actorEntry then
				local adPos = actorEntry.adPos
				if not adPos then
					local ad = actorEntry.actorData
					if type(ad) == "table" then
						local p = rawget(ad, "SimulatedPosition") or rawget(ad, "ServerPosition") or rawget(ad, "Position")
						if typeof(p) == "Vector3" then adPos = p end
					end
				end
				if typeof(adPos) == "Vector3" then tryPos = adPos end
			end
		end
		if tryPos then
			local sp, on = cam:WorldToViewportPoint(tryPos)
			if on and sp.Z > 0.01 then
				local pad = 28
				return {
					minX = sp.X - pad, maxX = sp.X + pad,
					minY = sp.Y - pad * 2, maxY = sp.Y + pad,
					topY = sp.Y - pad * 2,
					footY = sp.Y + pad,
					centerX = sp.X,
				}
			end
		end
		return nil
	end
	local height = math.max(maxY - minY, 10)
	local minWidth = height * (CONFIG.EspBoxAspect or 0.42)
	local width = math.max(maxX - minX, minWidth)
	local centerX = (minX + maxX) * 0.5
	minX = centerX - width * 0.5
	maxX = centerX + width * 0.5
	return {
		minX = minX, maxX = maxX,
		minY = minY, maxY = maxY,
		topY = minY,
		footY = footY or maxY,
		centerX = centerX,
	}
end

function Bridge.computeEspHeadFeetBox(model, cam, vpCache)
	return Bridge.computeEspBoundsBox(model, cam, vpCache)
end

function Bridge.smoothEspRect(entry, rect)
	if not rect then return nil end
	if CONFIG.EspSmooth == false or (CONFIG.EspSmoothAlpha or 1) >= 0.99 then
		entry.smoothRect = {
			minX = rect.minX, maxX = rect.maxX,
			minY = rect.minY, maxY = rect.maxY,
			footY = rect.footY or rect.maxY,
			centerX = rect.centerX or (rect.minX + rect.maxX) * 0.5,
		}
		return entry.smoothRect
	end
	local alpha = CONFIG.EspSmoothAlpha or 0.42
	local s = entry.smoothRect
	if not s then
		entry.smoothRect = {
			minX = rect.minX, maxX = rect.maxX,
			minY = rect.minY, maxY = rect.maxY,
			footY = rect.footY or rect.maxY,
			centerX = rect.centerX or (rect.minX + rect.maxX) * 0.5,
		}
		return entry.smoothRect
	end
	s.minX += (rect.minX - s.minX) * alpha
	s.maxX += (rect.maxX - s.maxX) * alpha
	s.minY += (rect.minY - s.minY) * alpha
	s.maxY += (rect.maxY - s.maxY) * alpha
	if rect.footY then
		s.footY = (s.footY or rect.footY) + (rect.footY - (s.footY or rect.footY)) * alpha
	end
	if rect.centerX then
		s.centerX = (s.centerX or rect.centerX) + (rect.centerX - (s.centerX or rect.centerX)) * alpha
	end
	return s
end

function Bridge.drawEspBox(entry, cam, model, color, vpCache)
	if not CONFIG.EspBox then
		for _, line in ipairs(entry.boxLines) do
			line.Visible = false
		end
		return Bridge.ensureEspLayoutRect(entry, cam, model, vpCache)
	end
	local raw = Bridge.computeEspHeadFeetBox(model, cam, vpCache)
	if not raw then
		for _, line in ipairs(entry.boxLines) do
			line.Visible = false
		end
		entry._boxRect = nil
		entry.smoothRect = nil
		return
	end
	local rect = Bridge.smoothEspRect(entry, raw)
	entry._boxRect = rect
	local tl = Vector2.new(rect.minX, rect.minY)
	local tr = Vector2.new(rect.maxX, rect.minY)
	local br = Vector2.new(rect.maxX, rect.maxY)
	local bl = Vector2.new(rect.minX, rect.maxY)
	entry.boxLines[1].From, entry.boxLines[1].To = tl, tr
	entry.boxLines[2].From, entry.boxLines[2].To = tr, br
	entry.boxLines[3].From, entry.boxLines[3].To = br, bl
	entry.boxLines[4].From, entry.boxLines[4].To = bl, tl
	for _, line in ipairs(entry.boxLines) do
		line.Color = color
		Bridge.showDrawing(line, 1)
	end
	entry._boxTop = Vector2.new((rect.minX + rect.maxX) * 0.5, rect.minY)
end

function Bridge.drawEspHpBar(entry, rect, hp, maxHp, color)
	if not CONFIG.EspHpBar or not entry.hpBg or not entry.hpFill or not rect then
		if entry.hpBg then entry.hpBg.Visible = false end
		if entry.hpFill then entry.hpFill.Visible = false end
		if entry.hpOutline then entry.hpOutline.Visible = false end
		return
	end
	local pct = 1
	if type(hp) == "number" and type(maxHp) == "number" and maxHp > 0 then
		pct = math.clamp(hp / maxHp, 0, 1)
	elseif type(hp) == "number" then
		pct = math.clamp(hp / 100, 0, 1)
	end
	local boxH = math.max(rect.maxY - rect.minY, 8)
	local barW = 4
	local x = rect.minX - barW - 3
	local y = rect.minY
	if entry.hpOutline then
		entry.hpOutline.Size = Vector2.new(barW + 2, boxH + 2)
		entry.hpOutline.Position = Vector2.new(x - 1, y - 1)
		entry.hpOutline.Color = Color3.fromRGB(8, 8, 8)
		Bridge.showDrawing(entry.hpOutline, 0.85)
	end
	entry.hpBg.Size = Vector2.new(barW, boxH)
	entry.hpBg.Position = Vector2.new(x, y)
	entry.hpBg.Color = Color3.fromRGB(22, 22, 22)
	Bridge.showDrawing(entry.hpBg, 0.7)
	local fillH = math.max(boxH * pct, 1)
	entry.hpFill.Size = Vector2.new(barW, fillH)
	entry.hpFill.Position = Vector2.new(x, y + boxH - fillH)
	entry.hpFill.Color = Color3.fromRGB(
		math.floor(255 * (1 - pct) + 55 * pct),
		math.floor(70 + 185 * pct),
		50
	)
	Bridge.showDrawing(entry.hpFill, 0.98)
end

function Bridge.formatEspWeaponLine(weaponInfo)
	if not weaponInfo then return nil end
	local name = espStripFirearmName(weaponInfo.name or "?")
	if type(weaponInfo.max) == "number" then
		return string.format("[%s] %d", name, weaponInfo.max)
	end
	return "[" .. name .. "]"
end

function Bridge.ensureEspExtraTexts(entry)
	entry.extraTexts = entry.extraTexts or {}
	for i = 1, 3 do
		if not entry.extraTexts[i] then
			local t = Drawing.new("Text")
			t.Size = ESP_LABEL_SIZE
			t.Outline = true
			t.Center = true
			t.Visible = false
			t.ZIndex = 23
			entry.extraTexts[i] = t
		end
	end
	return entry.extraTexts
end

function Bridge.hideEspExtraTexts(entry)
	if not entry or not entry.extraTexts then return end
	for _, t in ipairs(entry.extraTexts) do
		t.Visible = false
	end
end

function Bridge.drawEspExtraLines(entry, rect, data, startY, labelSize)
	if not entry or not rect then return startY end
	local texts = Bridge.ensureEspExtraTexts(entry)
	local lines = {}
	local colors = {}
	labelSize = labelSize or ESP_LABEL_SIZE

	if CONFIG.EspShowSecondary and data and data.espSecondaryName then
		lines[#lines + 1] = data.espSecondaryName
		colors[#colors + 1] = ESP_SECONDARY_TEXT
	end
	if CONFIG.EspShowInventory and data and type(data.espInventoryNames) == "table" and #data.espInventoryNames > 0 then
		local invLine = table.concat(data.espInventoryNames, ", ")
		if #invLine > 42 then invLine = string.sub(invLine, 1, 40) .. ".." end
		lines[#lines + 1] = invLine
		colors[#colors + 1] = ESP_INVENTORY_TEXT
	end

	local y = startY
	for i = 1, #texts do
		local t = texts[i]
		local line = lines[i]
		if line and line ~= "" then
			y = Bridge.drawEspPlainText(t, rect.centerX or (rect.minX + rect.maxX) * 0.5, y, line, colors[i], labelSize)
		else
			t.Visible = false
		end
	end
	return y
end

function Bridge.drawEspWeaponText(entry, rect, weaponInfo, labelSize)
	if not CONFIG.EspWeaponInfo or not entry.weaponText or not rect then
		if entry.weaponText then entry.weaponText.Visible = false end
		if entry.weaponBg then entry.weaponBg.Visible = false end
		return rect and (rect.maxY + ESP_STACK_GAP) or 0
	end
	local line = Bridge.formatEspWeaponLine(weaponInfo)
	if not line then
		entry.weaponText.Visible = false
		if entry.weaponBg then entry.weaponBg.Visible = false end
		return rect.maxY + ESP_STACK_GAP
	end
	local cx = rect.centerX or (rect.minX + rect.maxX) * 0.5
	if entry.weaponBg then entry.weaponBg.Visible = false end
	return Bridge.drawEspPlainText(entry.weaponText, cx, rect.maxY + ESP_STACK_GAP, line, ESP_WEAPON_TEXT, labelSize or ESP_LABEL_SIZE)
end

function Bridge.drawEspStatusBar(entry, rect, data, afterY, labelSize)
	if not CONFIG.EspActorStatus or not rect then
		Bridge.hideEspStatusBar(entry)
		return
	end
	local isNpc = Bridge.isNpcActorClass(data and data.class)
	if isNpc and CONFIG.EspNpcStatus == false then
		Bridge.hideEspStatusBar(entry)
		return
	end
	local getEntries = Bridge.getActorStatusEntriesCached or Bridge.getActorStatusEntries
	local entries = {}
	for _, e in ipairs(getEntries(data)) do
		if not e.text or e.text == "Armed" then continue end
		if e.kind == "stance" and CONFIG.EspShowStance == false then
			continue
		end
		entries[#entries + 1] = e
	end
	if #entries == 0 then
		Bridge.hideEspStatusBar(entry)
		return
	end

	local chips = Bridge.ensureEspStatusChips(entry)
	local shown = math.min(#entries, ESP_STATUS_CHIP_MAX)
	local x = rect.maxX + 6
	local chipSize = labelSize or ESP_LABEL_SIZE
	local vGap = chipSize + ESP_STATUS_CHIP_GAP
	-- Same bottom anchor as weapon/extra lines: rect.maxY (not footY — it desyncs at range)
	local bottomY = rect.maxY

	for i = 1, shown do
		local chip = chips[i]
		local e = entries[i]
		chip.Text = espStatusLabel(e.text)
		chip.Color = espStatusColor(e)
		chip.Size = chipSize
		chip.Center = false
		chip.Outline = true
		chip.Position = Vector2.new(x, bottomY - chipSize - (i - 1) * vGap)
		Bridge.setDrawingAlpha(chip, 1)
		chip.Visible = true
	end
	for i = shown + 1, #chips do
		chips[i].Visible = false
	end
	if entry.statusText then entry.statusText.Visible = false end
	if entry.statusBg then entry.statusBg.Visible = false end
end

function Bridge.drawEspStatusChips(entry, rect, data)
	Bridge.drawEspStatusBar(entry, rect, data, nil)
end

function Bridge.drawEspStatusText(entry, rect, data)
	Bridge.drawEspStatusBar(entry, rect, data, nil)
end

local function skelShoulderWorldPos(torso, sign)
	if not torso or not torso:IsA("BasePart") then return nil end
	return torso.CFrame:PointToWorldSpace(
		Vector3.new(sign * torso.Size.X * 0.42, torso.Size.Y * 0.46, 0)
	)
end

local function skelBoneWorldPos(part, fromName, toName, torsoPart)
	if not part or not part:IsA("BasePart") then return nil end
	if torsoPart and fromName == "UpperTorso" and (toName == "RightUpperArm" or toName == "LeftUpperArm") then
		local sign = toName == "RightUpperArm" and 1 or -1
		return skelShoulderWorldPos(torsoPart, sign)
	end
	return part.Position
end

local function espHeadScreenRadius(head, cam)
	if not head or not cam then return 4 end
	local camPos = cam.CFrame.Position
	local dist = (head.Position - camPos).Magnitude
	if dist < 1 then dist = 1 end
	local worldR = math.max(head.Size.X, head.Size.Z) * 0.38
	local fovRad = math.rad(cam.FieldOfView)
	local viewScale = (cam.ViewportSize.Y * 0.5) / math.tan(fovRad * 0.5)
	local radius = worldR * viewScale / dist
	if dist > 80 then
		radius *= 1 - math.min((dist - 80) / 400, 0.12)
	end
	return math.clamp(radius, 2, 11)
end

function Bridge.drawEspSkeleton(entry, cam, model, color, vpCache)
	if not CONFIG.EspSkeleton then
		for _, line in ipairs(entry.skelLines) do
			line.Visible = false
		end
		if entry.skelHeadCircle then entry.skelHeadCircle.Visible = false end
		if entry.skelShoulderLine then entry.skelShoulderLine.Visible = false end
		return
	end
	local pairs = Bridge.getSkeletonPairs(model)
	local idx = 0
	local torso = model:FindFirstChild("UpperTorso") or model:FindFirstChild("Torso")
	for _, pair in ipairs(pairs) do
		idx += 1
		local line = entry.skelLines[idx]
		if not line then break end
		local a = model:FindFirstChild(pair[1])
		local b = model:FindFirstChild(pair[2])
		if a and b and a:IsA("BasePart") and b:IsA("BasePart") then
			local wp1 = skelBoneWorldPos(a, pair[1], pair[2], torso) or a.Position
			local wp2 = b.Position
			local sp1, on1, sp2, on2
			if vpCache then
				local c1 = vpCache[a]
				if c1 and pair[1] ~= "UpperTorso" then sp1, on1 = c1[1], c1[2] else
					sp1, on1 = cam:WorldToViewportPoint(wp1)
					if pair[1] ~= "UpperTorso" then vpCache[a] = { sp1, on1 } end
				end
				local c2 = vpCache[b]
				if c2 then sp2, on2 = c2[1], c2[2] else
					sp2, on2 = cam:WorldToViewportPoint(wp2)
					vpCache[b] = { sp2, on2 }
				end
			else
				sp1, on1 = cam:WorldToViewportPoint(wp1)
				sp2, on2 = cam:WorldToViewportPoint(wp2)
			end
			if (on1 or on2) and sp1.Z > 0.01 and sp2.Z > 0.01 then
				line.From = Vector2.new(sp1.X, sp1.Y)
				line.To = Vector2.new(sp2.X, sp2.Y)
				line.Color = color
				line.Visible = true
			else
				line.Visible = false
			end
		else
			line.Visible = false
		end
	end
	for i = idx + 1, #entry.skelLines do
		entry.skelLines[i].Visible = false
	end
	local sl = entry.skelShoulderLine
	if sl and torso and torso:IsA("BasePart") then
		local wpL = skelShoulderWorldPos(torso, -1)
		local wpR = skelShoulderWorldPos(torso, 1)
		if wpL and wpR then
			local spL, onL = cam:WorldToViewportPoint(wpL)
			local spR, onR = cam:WorldToViewportPoint(wpR)
			if onL and onR and spL.Z > 0.01 and spR.Z > 0.01 then
				sl.From = Vector2.new(spL.X, spL.Y)
				sl.To = Vector2.new(spR.X, spR.Y)
				sl.Color = color
				sl.Thickness = 1.35
				Bridge.setDrawingAlpha(sl, 1)
				sl.Visible = true
			else
				sl.Visible = false
			end
		else
			sl.Visible = false
		end
	elseif sl then
		sl.Visible = false
	end
	local head = model:FindFirstChild("Head")
	local hc = entry.skelHeadCircle
	if hc and head and head:IsA("BasePart") then
		local sp, onScreen
		if vpCache then
			local cached = vpCache[head]
			if cached then sp, onScreen = cached[1], cached[2] else
				sp, onScreen = cam:WorldToViewportPoint(head.Position)
				vpCache[head] = { sp, onScreen }
			end
		else
			sp, onScreen = cam:WorldToViewportPoint(head.Position)
		end
		if onScreen and sp.Z > 0.01 then
			hc.Position = Vector2.new(sp.X, sp.Y)
			hc.Radius = espHeadScreenRadius(head, cam)
			hc.Color = color
			Bridge.setDrawingAlpha(hc, 1)
			hc.Visible = true
		else
			hc.Visible = false
		end
	elseif hc then
		hc.Visible = false
	end
end

function Bridge.clearESP()
	for _, entry in pairs(State.drawings) do
		if entry.boxLines then
			for _, line in ipairs(entry.boxLines) do
				pcall(function() line:Remove() end)
			end
		end
		if entry.skelLines then
			for _, line in ipairs(entry.skelLines) do
				pcall(function() line:Remove() end)
			end
		end
		if entry.skelHeadCircle then pcall(function() entry.skelHeadCircle:Remove() end) end
		if entry.skelShoulderLine then pcall(function() entry.skelShoulderLine:Remove() end) end
		if entry.circle then pcall(function() entry.circle:Remove() end) end
		if entry.text then pcall(function() entry.text:Remove() end) end
		if entry.weaponText then pcall(function() entry.weaponText:Remove() end) end
		if entry.weaponBg then pcall(function() entry.weaponBg:Remove() end) end
		if entry.statusText then pcall(function() entry.statusText:Remove() end) end
		if entry.statusBg then pcall(function() entry.statusBg:Remove() end) end
		if entry.statusChips then
			for _, chip in ipairs(entry.statusChips) do
				pcall(function() chip:Remove() end)
			end
		end
		if entry.hpBg then pcall(function() entry.hpBg:Remove() end) end
		if entry.hpFill then pcall(function() entry.hpFill:Remove() end) end
		if entry.hpOutline then pcall(function() entry.hpOutline:Remove() end) end
	end
	table.clear(State.drawings)
	for uid in pairs(State.espHighlights) do
		Bridge.removeEspChams(uid)
	end
end

function Bridge.destroyEspEntry(entry)
	if not entry then return end
	local function rm(obj)
		if obj then pcall(function() obj:Remove() end) end
	end
	if entry.boxLines then
		for _, line in ipairs(entry.boxLines) do rm(line) end
	end
	if entry.skelLines then
		for _, line in ipairs(entry.skelLines) do rm(line) end
	end
	rm(entry.skelShoulderLine)
	rm(entry.skelHeadCircle)
	rm(entry.text)
	rm(entry.statusText)
	rm(entry.weaponText)
	rm(entry.weaponBg)
	rm(entry.statusBg)
	rm(entry.hpBg)
	rm(entry.hpFill)
	rm(entry.hpOutline)
	if entry.statusChips then
		for _, chip in ipairs(entry.statusChips) do rm(chip) end
	end
	if entry.extraTexts then
		for _, t in ipairs(entry.extraTexts) do rm(t) end
	end
end

function Bridge.cleanupEspCache()
	if not State.drawings then return end
	local actors = State.actors
	local toRemove = {}
	for uid in pairs(State.drawings) do
		if not actors or not actors[uid] then
			toRemove[#toRemove + 1] = uid
		end
	end
	for _, uid in ipairs(toRemove) do
		local entry = State.drawings[uid]
		if entry then
			Bridge.hideEspEntry(entry, "cleanup_not_in_actors", uid)
			Bridge.destroyEspEntry(entry)
		end
		Bridge.removeEspChams(uid)
		State.drawings[uid] = nil
	end
	if State.espVisibleCache and actors then
		for uid in pairs(State.espVisibleCache) do
			if not actors[uid] then State.espVisibleCache[uid] = nil end
		end
	end
end

function Bridge.clearAllEspDrawings()
	if not State.drawings then return end
	for uid, entry in pairs(State.drawings) do
		Bridge.hideEspEntry(entry, "clear_all")
		Bridge.destroyEspEntry(entry)
		Bridge.removeEspChams(uid)
	end
	State.drawings     = {}
	State.espRanked    = nil
	State.espVisibleBatchIndex = 0
end

function Bridge.hideAllEspDrawings(reason)
	for uid, entry in pairs(State.drawings) do
		Bridge.hideEspEntry(entry, reason or "hide_all", uid)
		Bridge.removeEspChams(uid)
	end
end

local function cachedNpcCount()
	local now = os.clock()
	if State._espNpcCount ~= nil and now - (State._espNpcCountT or 0) < 1.0 then
		return State._espNpcCount
	end
	local n = 0
	for _, data in pairs(State.actors or {}) do
		if data and Bridge.isNpcActorClass(data.class) then
			n += 1
		end
	end
	State._espNpcCount = n
	State._espNpcCountT = now
	return n
end

function Bridge.updateESP(dt)
	if not CONFIG.ESP then
		Bridge.hideAllEspDrawings("esp_disabled")
		return
	end
	if not Drawing then return end
	if not State.actors then
		Bridge.hideAllEspDrawings("no_actors_table")
		return
	end
	local now = os.clock()
	local actorCount = State.trackedActorCount or 0
	if actorCount <= 0 then
		for _ in pairs(State.actors) do actorCount += 1 end
		State.trackedActorCount = actorCount
	end
	local npcCount = cachedNpcCount()
	local renderInterval = CONFIG.EspRenderInterval or 0.0167
	if npcCount >= 15 or actorCount > 200 then
		renderInterval = 0.033
	elseif npcCount >= 8 or actorCount > 100 then
		renderInterval = 0.025
	elseif npcCount >= 4 then
		renderInterval = 0.02
	end
	if now - (State.lastEspUpdate or 0) < renderInterval then return end
	State.lastEspUpdate = now

	local cam = workspace.CurrentCamera
	if not cam then return end
	local camPos = cam.CFrame.Position

	-- Rebuild ranked list every 0.4s or when actor count changes
	if actorCount == 0 then
		Bridge.logVizHide("ESP", "actor_count_zero", "hasActors=" .. tostring(State.actors ~= nil))
		Bridge.hideAllEspDrawings("actor_count_zero")
		return
	end

	-- FIX v11: интервал пересборки ranked 0.2s→1.0s — pairs() по 300+ NPC каждые 200ms жрал FPS
	-- При ресете State.actors пустой → pairs() дешёвый → FPS возвращался. Теперь 1.0s.
	if (actorCount ~= (State.espLastActorCount or -1)) or (now - (State.espRankedTime or 0) > 1.5) then
		local rankT = Bridge.perfBegin and Bridge.perfBegin() or nil
		local ranked = {}
		for uid, data in pairs(State.actors) do
			if data.class == "self" then continue end
			if Bridge.shouldSkipActorCollect(
				data.class, data.player, data.squad, data.teamKey, data.uid
			) then continue end
			if not Bridge.shouldEspShowActor(data) then continue end
			if CONFIG.EspIgnoreTeam and Bridge.shouldEspHideAsTeammate(data) then continue end
			local root = data.root
			if not root or not root.Parent then continue end
			-- FIX v7: InactiveWorld actors — использовать adPos для корректной дистанции
			local distPos
			if data.inInactiveWorld and data.adPos and typeof(data.adPos) == "Vector3" then
				distPos = data.adPos
			else
				distPos = root.Position
			end
			ranked[#ranked+1] = { uid=uid, data=data, dist=(distPos-camPos).Magnitude }
			-- FIX v11: cap без *2 — точный лимит предотвращает лишний sort на 128 элементах
			if #ranked >= (CONFIG.EspBoxMaxActors or 64) then break end
		end
		table.sort(ranked, function(a,b) return a.dist < b.dist end)
		State.espRanked         = ranked
		State.espRankedTime     = now
		State.espLastActorCount = actorCount
		if Bridge.perfEnd then
			Bridge.perfEnd("esp.rank", rankT, "#" .. tostring(#ranked))
		end
	end

	local ranked = State.espRanked
	if not ranked or #ranked == 0 then
		Bridge.logVizHide("ESP", "ranked_empty", "tracked=" .. tostring(actorCount))
		Bridge.hideAllEspDrawings("ranked_empty")
		return
	end

	-- FIX v6: VisibleCheck round-robin — строгий курсор, нет пропусков
	-- Каждый актор проверяется ровно раз за ceil(#ranked/batchSize) кадров
	if CONFIG.EspVisibleCheck then
		local visT = Bridge.perfBegin and Bridge.perfBegin() or nil
		local visN = 0
		local batchSize = CONFIG.EspBatchSize or 4
		local n = #ranked
		local playerNear = 0
		for _, row in ipairs(ranked) do
			if row.data and not Bridge.isNpcActorClass(row.data.class) then
				local d = row.dist or 0
				if d < (CONFIG.EspVisiblePlayerDist or 500) then
					playerNear += 1
				end
			end
		end
		if playerNear >= 8 then
			batchSize = 1
		elseif playerNear >= 4 then
			batchSize = math.max(1, math.floor(batchSize * 0.5))
		end
		if CONFIG.EspVisibleFast ~= false then
			batchSize = math.min(batchSize, CONFIG.EspVisibleMaxRaysPerFrame or 8)
		else
			batchSize = math.min(batchSize, math.max(1, math.floor((CONFIG.EspVisibleMaxRaysPerFrame or 8) / 6)))
		end
		if n > 0 then
			State.espVisibleCursor = State.espVisibleCursor or 1
			local cursor = State.espVisibleCursor
			local baseInterval = CONFIG.EspVisibleInterval or 0.35
			for i = 0, batchSize - 1 do
				local idx = (cursor - 1 + i) % n + 1
				local row = ranked[idx]
				if row and row.data then
					if Bridge.isNpcActorClass(row.data.class) then
						visN += 1
						local uid = row.uid
						if uid and uid ~= "" then
							State.espVisibleCache = State.espVisibleCache or {}
							State.espVisibleCache[uid] = { v = true, t = now }
						end
					else
						local dist = row.dist or 0
						local interval = baseInterval
						if dist > 400 then
							interval = interval * 2.0
						elseif dist > 250 then
							interval = interval * 1.5
						end
						visN += 1
						Bridge.isActorVisibleForEsp(row.data, cam, interval)
					end
				end
			end
			State.espVisibleCursor = (cursor - 1 + batchSize) % n + 1
		end
		if Bridge.perfEnd then
			Bridge.perfEnd("esp.visibleBatch", visT, "n=" .. tostring(visN))
		end
	end

	local live = {}
	local maxActors = CONFIG.EspBoxMaxActors or 64
	if npcCount >= 12 then
		maxActors = math.min(maxActors, 28)
	elseif npcCount >= 6 then
		maxActors = math.min(maxActors, 40)
	end
	local vpCache = {}
	local drawT = Bridge.perfBegin and Bridge.perfBegin() or nil
	local drawnN = 0

	for i, row in ipairs(ranked) do
		if i > maxActors then continue end
		local uid  = row.uid
		local data = row.data
		if not data or not data.root or not data.root.Parent then continue end
		if not Bridge.shouldEspShowActor(data) then
			local hidden = State.drawings[uid]
			if hidden then Bridge.hideEspEntry(hidden, "npc_filter", uid) end
			Bridge.removeEspChams(uid)
			continue
		end
		if CONFIG.EspIgnoreTeam and Bridge.shouldEspHideAsTeammate(data) then
			local entry = State.drawings[uid]
			if entry then Bridge.hideEspEntry(entry, "teammate", uid) end
			Bridge.removeEspChams(uid)
			continue
		end

		local entry = Bridge.ensureEspDrawing(uid)
		live[uid] = true
		drawnN += 1

		-- Труп: class=="dead" — показываем метку Dead, не прячем
		if data.class == "dead" then
			local model = data.model
			Bridge.drawEspBox(entry, cam, model, ESP_COLORS.dead, nil)
			local dRect = entry._boxRect
			if dRect then
				entry.text.Text     = "Dead"
				entry.text.Color    = ESP_COLORS.dead
				entry.text.Position = Vector2.new(
					dRect.minX + (dRect.maxX - dRect.minX) * 0.5,
					dRect.minY - 14
				)
				entry.text.Visible  = true
			else
				Bridge.hideEspEntry(entry, "dead_no_rect")
			end
			if entry.hpBg      then entry.hpBg.Visible      = false end
			if entry.hpFill    then entry.hpFill.Visible    = false end
			if entry.hpOutline then entry.hpOutline.Visible = false end
			if entry.weaponText then entry.weaponText.Visible = false end
			if entry.weaponBg then entry.weaponBg.Visible = false end
			Bridge.hideEspStatusBar(entry)
			Bridge.removeEspChams(uid)
			live[uid] = true
			continue
		end
		-- живой но dead=true/alive=false — прячем
		local dead = data.dead == true or data.alive == false
		if dead then
			Bridge.hideEspEntry(entry, "dead_flag")
			Bridge.removeEspChams(uid)
			continue
		end

		local model = data.model
		if not model or not model.Parent then
			Bridge.hideEspEntry(entry, "no_model")
			continue
		end

		local npcNameOnly = Bridge.isNpcActorClass(data.class) and CONFIG.EspNpcNameOnly == true
		if npcNameOnly then
			for _, line in ipairs(entry.boxLines) do line.Visible = false end
			if entry.skelLines then
				for _, ln in ipairs(entry.skelLines) do ln.Visible = false end
			end
			if entry.skelHeadCircle then entry.skelHeadCircle.Visible = false end
			if entry.hpBg then entry.hpBg.Visible = false end
			if entry.hpFill then entry.hpFill.Visible = false end
			if entry.hpOutline then entry.hpOutline.Visible = false end
			Bridge.hideEspStatusBar(entry)
			if entry.weaponText then entry.weaponText.Visible = false end
			Bridge.hideEspExtraTexts(entry)
			Bridge.removeEspChams(uid)
			Bridge.ensureEspLayoutRect(entry, cam, model, vpCache)
			local nRect = entry._boxRect
			if not nRect or nRect.maxX < 0 or nRect.minX > cam.ViewportSize.X
				or nRect.maxY < 0 or nRect.minY > cam.ViewportSize.Y then
				Bridge.hideEspEntry(entry, "offscreen")
				Bridge.removeEspChams(uid)
				continue
			end
			local boxColor = Bridge.getEspColor(data, Bridge.getEspActorVisible(uid))
			entry.text.Text = Bridge.formatEspLabelWithDistance(data, camPos)
			entry.text.Color = boxColor
			entry.text.Size = ESP_LABEL_SIZE + 1
			Bridge.showDrawing(entry.text, 1)
			entry.text.Position = Vector2.new(
				nRect.centerX or (nRect.minX + nRect.maxX) * 0.5,
				nRect.minY - (ESP_LABEL_SIZE + 3)
			)
			continue
		end

		local visible  = Bridge.getEspActorVisible(uid)
		local boxColor = Bridge.getEspColor(data, visible)

		-- Box / layout rect
		local boxT = Bridge.perfBegin and Bridge.perfBegin() or nil
		if CONFIG.EspBox then
			Bridge.drawEspBox(entry, cam, model, boxColor, vpCache)
		else
			for _, line in ipairs(entry.boxLines) do
				line.Visible = false
			end
			Bridge.ensureEspLayoutRect(entry, cam, model, vpCache)
		end
		if Bridge.perfEnd then Bridge.perfEnd("esp.box", boxT) end

		local rect = entry._boxRect
		-- hide если off-screen или вне экрана
		if not rect or rect.maxX < 0 or rect.minX > cam.ViewportSize.X
			or rect.maxY < 0 or rect.minY > cam.ViewportSize.Y then
			Bridge.hideEspEntry(entry, "offscreen")
			Bridge.removeEspChams(uid)
			continue
		end

		-- HP Bar
		local hpT = Bridge.perfBegin and Bridge.perfBegin() or nil
		if CONFIG.EspHpBar and rect and not npcNameOnly then
			local hp, maxHp = Bridge.resolveActorHealth(data)
			Bridge.drawEspHpBar(entry, rect, hp, maxHp, boxColor)
		else
			if entry.hpBg      then entry.hpBg.Visible      = false end
			if entry.hpFill    then entry.hpFill.Visible    = false end
			if entry.hpOutline then entry.hpOutline.Visible = false end
		end
		if Bridge.perfEnd then Bridge.perfEnd("esp.hp", hpT) end

		-- Skeleton (batch limited by rank) — NPC: только name-only, без скелета
		local skelMaxDist = CONFIG.EspSkeletonMaxDist or 800
		local skelT = Bridge.perfBegin and Bridge.perfBegin() or nil
		if CONFIG.EspSkeleton and not Bridge.isNpcActorClass(data.class)
			and i <= (CONFIG.EspSkeletonMaxActors or 24) and row.dist <= skelMaxDist then
			Bridge.drawEspSkeleton(entry, cam, model, boxColor, vpCache)
		elseif entry.skelLines then
			for _, ln in ipairs(entry.skelLines) do ln.Visible = false end
			if entry.skelHeadCircle then entry.skelHeadCircle.Visible = false end
		end
		if Bridge.perfEnd then Bridge.perfEnd("esp.skel", skelT) end

		-- Chams (batch limited by rank) — NPC пропускаем
		local chamsT = Bridge.perfBegin and Bridge.perfBegin() or nil
		if CONFIG.EspChams and not Bridge.isNpcActorClass(data.class)
			and i <= (CONFIG.EspChamsMaxActors or 14) then
			if Bridge.perfCount then Bridge.perfCount("chamsUpdate") end
			Bridge.updateEspChams(uid, model, boxColor)
		else
			Bridge.removeEspChams(uid)
		end
		if Bridge.perfEnd then Bridge.perfEnd("esp.chams", chamsT) end

		-- Weapon + stance/secondary/inventory + status (независимо от EspBox)
		local metaT = Bridge.perfBegin and Bridge.perfBegin() or nil
		local stackY = rect.maxY + ESP_STACK_GAP
		local lineCount = 1
		local showPlayerMeta = CONFIG.EspWeaponInfo and not Bridge.isNpcActorClass(data.class)
		if showPlayerMeta then
			if data.weaponInfo then lineCount += 1 end
			if CONFIG.EspShowStance and espGetStanceChip(data.actorData) then lineCount += 1 end
			if CONFIG.EspShowSecondary and data.espSecondaryName then lineCount += 1 end
			if CONFIG.EspShowInventory and data.espInventoryNames and #data.espInventoryNames > 0 then
				lineCount += 1
			end
		end
		local labelSize = espAdaptiveLabelSize(lineCount)

		if showPlayerMeta then
			stackY = Bridge.drawEspWeaponText(entry, rect, data.weaponInfo, labelSize)
			stackY = Bridge.drawEspExtraLines(entry, rect, data, stackY, labelSize)
		else
			if entry.weaponText then entry.weaponText.Visible = false end
			if entry.weaponBg then entry.weaponBg.Visible = false end
			Bridge.hideEspExtraTexts(entry)
		end

		local label = Bridge.formatEspLabelWithDistance(data, camPos)
		entry.text.Text = label
		entry.text.Color = boxColor
		entry.text.Size = labelSize + 1
		Bridge.showDrawing(entry.text, 1)
		entry.text.Position = Vector2.new(
			rect.minX + (rect.maxX - rect.minX) * 0.5,
			rect.minY - (labelSize + 3)
		)
		if CONFIG.EspActorStatus then
			Bridge.drawEspStatusBar(entry, rect, data, stackY, labelSize)
		else
			Bridge.hideEspStatusBar(entry)
		end
		if Bridge.perfEnd then Bridge.perfEnd("esp.meta", metaT) end
	end

	-- Hide vanished actors
	local hiddenN = 0
	for uid, entry in pairs(State.drawings) do
		if not live[uid] then
			hiddenN += 1
			Bridge.hideEspEntry(entry)
			Bridge.removeEspChams(uid)
		end
	end
	if Bridge.perfSet then
		Bridge.perfSet("drawActors", drawnN)
		Bridge.perfSet("hiddenActors", hiddenN)
	end
	if Bridge.perfEnd then
		Bridge.perfEnd("esp.drawLoop", drawT, "draw=" .. tostring(drawnN))
	end
end


local _M = {
	start = function()
		if espConn then return end
		-- v20 PATCH: не перезаписывать CONFIG ключи которые уже были установлены
		-- (Silent/Library могут выставить свои значения до вызова start())
		for k,v in pairs(ESP_CONFIG) do
			if CONFIG[k] == nil then CONFIG[k] = v end
		end
		if type(Bridge.tickRepSyncBatch) == "function" then
			task.defer(function()
				Bridge.tickRepSyncBatch(16)
			end)
		end
		local tFull = 0; local tGc = 0; local tEnrich = 0
		espConn = game:GetService("RunService").Heartbeat:Connect(function(dt)
			local t = os.clock()
			if not CONFIG.ESP then return end
			local actorN = State.trackedActorCount or 0
			local npcN = cachedNpcCount()
			local enrichInterval = 0.15
			if npcN >= 15 or actorN > 200 then
				enrichInterval = 0.35
			elseif npcN >= 8 or actorN > 100 then
				enrichInterval = 0.28
			elseif npcN >= 4 then
				enrichInterval = 0.22
			end
			if t - tEnrich >= enrichInterval and type(Bridge._refreshActorsForEsp) == "function" then
				tEnrich = t
				local refreshT = Bridge.perfBegin and Bridge.perfBegin() or nil
				Bridge._refreshActorsForEsp()
				if Bridge.perfEnd then Bridge.perfEnd("esp.refresh.call", refreshT) end
			end
			local updateT = Bridge.perfBegin and Bridge.perfBegin() or nil
			Bridge.updateESP(dt)
			if Bridge.perfEnd then Bridge.perfEnd("esp.update", updateT) end
			if Bridge.updatePerfHud then Bridge.updatePerfHud(dt) end
			if t - tGc >= 5 then
				tGc = t
				Bridge.cleanupEspCache()
			end
		end)
	end,
	stop = function()
		if espConn then espConn:Disconnect(); espConn = nil end
		Bridge.clearESP()
	end,
	toggle = function()
		if espConn then
			espConn:Disconnect(); espConn = nil; Bridge.clearESP()
		else _M.start() end
	end,
	isRunning = function() return espConn ~= nil end,
}
Bridge._espModule = _M
return _M
end
