-- Services.InventoryService.FirearmInventory
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4, u5 = shared.import("require", "network", "server", "Enum", "signal");
local u6 = v1("InputService");
local u7 = v1("BulletService");
local u8 = v1("SoundService");
local u9 = v1("NotifyInterface");
local u10 = v1("HUDInterface");
local u11 = v1("BaseComponent");
local u12 = v1("Menu");
local u13 = v1("Calibers");
local u14 = v1("Weapon");
local u15 = v1("Boxes");
local u16 = v1("CursorInterface");
local u17 = v1("AttachmentIcons");
local u18 = v1("GameSettings");
local l__RunService__1 = game:GetService("RunService");
local l__ContentProvider__2 = game:GetService("ContentProvider");
local l__CurrentCamera__3 = workspace.CurrentCamera;
local u19 = {};
u19.__index = u19;
function u19._moveMagnifier(p20, p21) --[[ Line: 32 ]]
    -- upvalues: u4 (copy), u2 (copy)
    local l___magnifier__4 = p20._magnifier;
    if l___magnifier__4 then
        local v22 = false;
        if l___magnifier__4.Active and p21 < 0 then
            l___magnifier__4.Active = false;
            v22 = true;
        elseif not l___magnifier__4.Active and p21 > 0 then
            l___magnifier__4.Active = true;
            v22 = true;
        end;
        if v22 then
            p20._actor:Action(u4.ActionType.Inventory, "Magnifier", l___magnifier__4);
            u2:FireServer("InventoryAction", "Magnifier", l___magnifier__4.Path, l___magnifier__4.Active);
        end;
    end;
end;
function u19._ads(u23, p24) --[[ Line: 51 ]]
    -- upvalues: u6 (copy), u4 (copy), u2 (copy)
    u23.ADS = p24;
    u6.ADS = p24;
    u23:_resetCQB();
    u23._actor:Action(u4.ActionType.Inventory, "ADS", p24, u23._sight);
    u2:FireServer("InventoryAction", "ADS", p24, u23._sight);
    if p24 then
        local l___magnifier__5 = u23._magnifier;
        if l___magnifier__5 and not u23._magnifierControls then
            u23._magnifierControls = u6:Connect({
                Magnifier = function(p25) --[[ Name: Magnifier, Line 63 ]]
                    -- upvalues: u23 (copy), l___magnifier__5 (copy)
                    if p25 then
                        u23:_moveMagnifier(l___magnifier__5.Active and -1 or 1);
                    end;
                end
            });
        end;
    elseif u23._magnifierControls then
        u23._magnifierControls:Disconnect();
        u23._magnifierControls = nil;
    end;
end;
function u19._switchFiremode(p26, p27) --[[ Line: 78 ]]
    -- upvalues: u2 (copy), u4 (copy)
    p26._fireMode = nil;
    local l__MetaData__6 = p26._item.MetaData;
    local l__Mode__7 = l__MetaData__6.Mode;
    local v28 = table.find(p26._firearm.Tune.Firemodes, 0);
    if p27 and v28 then
        if l__Mode__7 == v28 then
            return;
        end;
    else
        local v29;
        if l__Mode__7 == #p26._firearm.Tune.Firemodes then
            v29 = 1;
        else
            v29 = l__Mode__7 + 1;
        end;
        if v29 == v28 then
            if v29 == #p26._firearm.Tune.Firemodes then
                v29 = 1;
                v28 = v29;
            else
                v29 = v29 + 1;
                v28 = v29;
            end;
        else
            v28 = v29;
        end;
    end;
    l__MetaData__6.Mode = v28;
    u2:FireServer("InventoryAction", "Mode", l__MetaData__6.Mode);
    p26:UpdateHUD();
    p26._actor:Action(u4.ActionType.Inventory, "Firemode", p26:_getFiremode());
end;
function u19._discharge(p30, p31) --[[ Line: 111 ]]
    -- upvalues: u3 (copy), u9 (copy), u6 (copy), u4 (copy), u8 (copy), l__RunService__1 (copy)
    p30._active = p31;
    if u3.FREEZE_PLAYERS or u3.NO_SHOOT then
        return;
    end;
    if p31 and (p30:_getFiremode() == 0 and not p30._reloading) then
        u9:Notify({
            { "SAFE", "Press [" .. u6:GetBind("Firemode").Name .. "] to disable safe mode", Color3.new(1, 0, 0) }
        });
    end;
    local l___actor__8 = p30._actor;
    if not l___actor__8 then
        return;
    end;
    if l___actor__8.ProneDelay and tick() < l___actor__8.ProneDelay then
        return;
    end;
    local l___mag__9 = p30._mag;
    local l__MetaData__10 = p30._item.MetaData;
    if (not l___mag__9 or l___mag__9.Capacity <= 0) and not l__MetaData__10.Chamber then
        p30._actor:Action(u4.ActionType.Inventory, "DryFire", p31);
        return;
    end;
    if p30:_getFiremode() > 0 and (p30._active and (not p30._shooting and (not p30._reloading and (os.clock() > p30._next and not (l___actor__8.Sliding or l___actor__8.Sprinting))))) then
        p30._shooting = true;
        local l__Tune__11 = p30._firearm.Tune;
        if l__Tune__11.Speed_Penalty then
            l___actor__8.SpeedPenalty = l__Tune__11.Speed_Penalty;
        end;
        local l__Bolt__12 = l__Tune__11.Bolt;
        local v32 = 60 / l__Tune__11.RPM;
        local v33 = os.clock();
        local v34 = v32;
        local v35 = 0;
        local v36 = false;
        while p30:_getFiremode() > 0 and (p30._active and not p30._reloading) and (l___mag__9 and l___mag__9.Capacity > 0 or l__MetaData__10.Chamber) and (p30.Equipped and (not l___actor__8.Sliding and (not l___actor__8.Sprinting and (not u3.NO_SHOOT and (not l___actor__8.ProneDelay or tick() > l___actor__8.ProneDelay))))) do
            if l__Bolt__12 and not v36 then
                u8:CreateSound("Weapon_Interaction", nil, true, "Weapons", p30._firearm.Name, "Handling", "Bolt").Destroy(5);
                task.wait(l__Bolt__12);
                v33 = os.clock();
                v36 = true;
            end;
            local v37 = os.clock();
            local v38 = v32 + (v37 - v33);
            local v39 = p30:_getFiremode();
            local v40 = math.floor(v38 / v34);
            local v41 = math.min(v40, (l___mag__9 and (l___mag__9.Capacity or 0) or 0) + (l__MetaData__10.Chamber and 1 or 0));
            if v41 > 0 then
                v33 = v37;
                for _ = 1, v41 do
                    p30:Discharge();
                    v35 = v35 + 1;
                    if v39 == 3 and v35 >= 3 then
                        break;
                    end;
                end;
                p30._next = v37 + v34;
            else
                v33 = v37;
            end;
            if v39 == 1 or v39 == 3 and v35 >= 3 then
                break;
            end;
            v32 = v38 - v41 * v34;
            l__RunService__1.RenderStepped:Wait();
        end;
        l___actor__8.SpeedPenalty = nil;
        p30._shooting = false;
    end;
end;
function u19._getFiremode(p42) --[[ Line: 198 ]]
    local l__Mode__13 = p42._item.MetaData.Mode;
    return p42._reloading and table.find(p42._firearm.Tune.Firemodes, 0) and 0 or p42._firearm.Tune.Firemodes[l__Mode__13];
end;
function u19._getMags(p43) --[[ Line: 207 ]]
    -- upvalues: u15 (copy), u14 (copy)
    local l___box__14 = p43._box;
    local v44 = {};
    for _, v45 in p43._inventory.Storages do
        for _, v46 in v45.Sections do
            for _, v47 in v46 do
                if l___box__14 then
                    if v47.Name:sub(1, 7) == "AmmoBox" then
                        local v48 = u15[v47.Name:sub(8)];
                        local l__MetaData__15 = v47.MetaData;
                        if l__MetaData__15.Capacity > 0 and v48.FamilyName == p43._caliber.FamilyName then
                            v44[#v44 + 1] = {
                                UID = l__MetaData__15.UID,
                                Capacity = l__MetaData__15.Capacity,
                                Max = v48.Capacity,
                                Percent = l__MetaData__15.Capacity / v48.Capacity
                            };
                        end;
                    end;
                elseif v47.Name:sub(1, 10) == "FirearmMag" then
                    local l__MetaData__16 = v47.MetaData;
                    if l__MetaData__16.Capacity > 0 and p43._firearm:IsCompatible(l__MetaData__16.Name, "Mag") then
                        v44[#v44 + 1] = {
                            UID = l__MetaData__16.UID,
                            Capacity = l__MetaData__16.Capacity,
                            Max = u14.Mag[l__MetaData__16.Name].Config.Tune.Ammo,
                            Percent = l__MetaData__16.Capacity / u14.Mag[l__MetaData__16.Name].Config.Tune.Ammo
                        };
                    end;
                end;
            end;
        end;
    end;
    table.sort(v44, function(p49, p50) --[[ Line: 242 ]]
        return p49.Capacity > p50.Capacity;
    end);
    return v44;
end;
function u19._resetCQB(p51) --[[ Line: 249 ]]
    -- upvalues: u4 (copy), u2 (copy)
    if p51.CQB then
        p51.CQB = 0;
        p51._actor:Action(u4.ActionType.Inventory, "CQB", 0);
        u2:FireServer("InventoryAction", "CQB", 0);
    end;
end;
function u19._cancelCQB(p52) --[[ Line: 257 ]]
    -- upvalues: u4 (copy), u2 (copy)
    if p52.CQB then
        p52.CQB = nil;
        p52._actor:Action(u4.ActionType.Inventory, "CQB");
        u2:FireServer("InventoryAction", "CQB");
    end;
end;
function u19._reload(p53, p54) --[[ Line: 265 ]]
    -- upvalues: u4 (copy), u2 (copy)
    if p53._reloading then
    else
        local l___box__17 = p53._box;
        local l___mag__18 = p53._mag;
        if l___box__17 and (l___mag__18 and l___mag__18.Capacity >= p53._max) then
        else
            local v55 = p53:_getMags();
            if l___mag__18 or v55[1] ~= nil then
                local v56;
                if v55[1] then
                    v56 = v55[1].UID;
                else
                    v56 = nil;
                end;
                local v57 = not p53._item.MetaData.Chamber;
                if p53._firearm.Tune.NoChamber then
                    v57 = not l___mag__18 or l___mag__18.Capacity == 0;
                end;
                if l___box__17 then
                    if not v55[1] then
                        return;
                    end;
                    v56 = v55[#v55].UID;
                    if p54 and p53._firearm.Tune.EmptyOnReload then
                        local v58 = v55[1];
                        v58.Capacity = v58.Capacity + l___mag__18.Capacity;
                        l___mag__18.Capacity = 0;
                    end;
                elseif l___mag__18 then
                    p53._mag = nil;
                    p53._max = 0;
                end;
                p53._reloading = true;
                local v59 = nil;
                if l___box__17 and (l___mag__18 and (l___mag__18.Capacity + 1 < p53._max and not p53._cancelReload)) then
                    local v60 = 0;
                    for _, v61 in v55 do
                        v60 = v60 + v61.Capacity;
                    end;
                    if v60 > 1 then
                        v59 = true;
                    end;
                end;
                p53._autoReload = v59;
                p53:UpdateHUD();
                p53._actor:Action(u4.ActionType.Inventory, "Reload", v57, p53._autoReload, l___mag__18 and l___mag__18.Capacity + 1 or 0);
                u2:FireServer("InventoryAction", "Reload", v56, p53._autoReload);
            end;
        end;
    end;
end;
function u19.new(p62, p63, p64) --[[ Line: 324 ]]
    -- upvalues: u11 (copy), u4 (copy), u12 (copy), u13 (copy), u19 (copy), l__ContentProvider__2 (copy), u14 (copy), u17 (copy), u2 (copy), u18 (copy)
    local u65 = u11.Deserialize(p63.MetaData.Build);
    local v66 = RaycastParams.new();
    v66.FilterType = u4.RaycastFilterType.Blacklist;
    v66.FilterDescendantsInstances = { p62.Character };
    v66.CollisionGroup = u4.PhysicsGroup.BulletCast;
    v66.IgnoreWater = false;
    local l__Mag__19 = p63.MetaData.Mag;
    local u67 = setmetatable({
        ADS = false,
        _bulletsShot = 0,
        Equipped = false,
        _active = false,
        _shooting = false,
        _max = 0,
        _next = 0,
        _sight = 0,
        Name = u12.Weapon.Receiver[u65.Name].Name,
        _params = v66,
        _mag = l__Mag__19,
        _box = u65.Tune.Box,
        _caliber = u13[u65.Tune.Caliber],
        _attachments = {},
        _firearm = u65,
        _actor = p62,
        _item = p63,
        _inventory = p64
    }, u19);
    task.spawn(function() --[[ Line: 358 ]]
        -- upvalues: u65 (copy), l__ContentProvider__2 (ref)
        local v68 = {};
        for _, v69 in u65.File.Config.Animations.First do
            if typeof(v69) == "number" then
                local v70 = Instance.new("Animation");
                v70.AnimationId = "rbxassetid://" .. v69;
                v68[#v68 + 1] = v70;
            end;
        end;
        l__ContentProvider__2:PreloadAsync(v68);
        for _, v71 in v68 do
            v71:Destroy();
        end;
    end);
    if l__Mag__19 then
        u67._max = u14.Mag[l__Mag__19.Name].Config.Tune.Ammo;
    end;
    local u72 = {};
    local u73 = {};
    local v74 = {};
    for _, v75 in u65:GetDescendants() do
        local l__Attachments__20 = v75.File.Attachments;
        if l__Attachments__20 then
            local v76 = u12;
            for v77 = 1, #v75.Path do
                v76 = v76[v75.Path[v77]];
            end;
            local u78 = nil;
            local u79 = {};
            local u80 = v75.File.Default_State or (l__Attachments__20.Laser and "Laser" or "Flashlight");
            local u81 = table.concat(v75:GetFullName(), ".");
            local function v103(p82, p83, u84) --[[ Line: 396 ]]
                -- upvalues: u81 (copy), u78 (ref), u17 (ref), u80 (ref), u67 (copy), u4 (ref), u2 (ref), u79 (copy)
                local u85 = u81 .. "/" .. u84;
                if #p82 == 1 then
                    u78 = u17[u84] or "";
                    local u88 = {
                        Activated = false,
                        Image = u78,
                        Titleline = p82[1].Name,
                        Subline = { "Turn off " .. p82[1].Name, "Turn on " .. p82[1].Name },
                        Callback = function(p86) --[[ Name: callback, Line 401 ]]
                            -- upvalues: u80 (ref), u84 (copy), u67 (ref), u4 (ref), u85 (copy), u2 (ref)
                            if p86 then
                                u80 = u84;
                            end;
                            local v87 = p86 and 1 or 0;
                            u67._actor:Action(u4.ActionType.Inventory, "Attachment", u85, v87);
                            u2:FireServer("InventoryAction", "Attachment", u85, v87);
                        end
                    };
                    p83[#p83 + 1] = u88;
                    u67._attachments[u88] = false;
                    u79[u84] = function(p89, p90) --[[ Line: 421 ]]
                        -- upvalues: u88 (copy), u80 (ref), u84 (copy), u67 (ref), u4 (ref), u85 (copy), u2 (ref)
                        if p90 then
                            if not p89 then
                                return;
                            end;
                            p89 = not u88.Activated;
                        end;
                        u88.Activated = p89;
                        if p89 then
                            u80 = u84;
                        end;
                        local v91 = p89 and 1 or 0;
                        u67._actor:Action(u4.ActionType.Inventory, "Attachment", u85, v91);
                        u2:FireServer("InventoryAction", "Attachment", u85, v91);
                    end;
                else
                    local u92 = 1;
                    local function v94(p93) --[[ Line: 436 ]]
                        -- upvalues: u80 (ref), u84 (copy), u92 (ref), u67 (ref), u4 (ref), u85 (copy), u2 (ref)
                        if p93 > 0 then
                            u80 = u84;
                            u92 = p93;
                        end;
                        u67._actor:Action(u4.ActionType.Inventory, "Attachment", u85, p93);
                        u2:FireServer("InventoryAction", "Attachment", u85, p93);
                    end;
                    local u95 = u92;
                    local v96 = {};
                    for v97, v98 in p82 do
                        v96[v97] = {
                            Titleline = v98.Name,
                            Subline = "Set " .. v98.Name,
                            Callback = v94,
                            Image = u17.Gear
                        };
                    end;
                    local u99 = {
                        Activated = 0,
                        Image = u17[u84],
                        Titleline = u84,
                        Subline = "Set " .. u84 .. " mode",
                        Callbacks = v96
                    };
                    p83[#p83 + 1] = u99;
                    u67._attachments[u99] = 0;
                    u79[u84] = function(p100, p101) --[[ Line: 465 ]]
                        -- upvalues: u99 (copy), u95 (ref), u80 (ref), u84 (copy), u67 (ref), u4 (ref), u85 (copy), u2 (ref)
                        if p101 then
                            if not p100 then
                                return;
                            end;
                            p100 = u99.Activated == 0;
                        end;
                        local v102 = p100 and u95 or 0;
                        u99.Activated = v102;
                        if v102 > 0 then
                            u80 = u84;
                            u95 = v102;
                        end;
                        u67._actor:Action(u4.ActionType.Inventory, "Attachment", u85, v102);
                        u2:FireServer("InventoryAction", "Attachment", u85, v102);
                    end;
                end;
            end;
            local u104 = u80;
            local v105 = {};
            for v106, v107 in l__Attachments__20 do
                v103(v107, v105, v106);
            end;
            local v108 = v75:GetChild("FunctionFlashlight");
            if v108 then
                local v109 = v108.Name:sub(5, 5);
                if not u73[v109] then
                    u73[v109] = {};
                end;
                u73[v109][#u73[v109] + 1] = u79.Flashlight;
            end;
            local v110 = v75:GetChild("FunctionLaser");
            if v110 then
                local v111 = v110.Name:sub(5, 5);
                if not u73[v111] then
                    u73[v111] = {};
                end;
                u73[v111][#u73[v111] + 1] = u79.Laser;
            end;
            local v112 = v75:GetChild("FunctionSwitch");
            local u113 = v112 and (v112.MetaData and v112.MetaData.Camo or v112.File.DefaultCamo);
            if u113 then
                if not u72[u113] then
                    u72[u113] = {};
                end;
                local u114 = v112 and v112.Name or "Default";
                local v115 = u72[u113];
                v115[#v115 + 1] = function(p116) --[[ Line: 516 ]]
                    -- upvalues: u18 (ref), u113 (copy), u114 (copy), u79 (copy), u104 (ref)
                    local v117 = u18[u113] == 2;
                    if u114 == "Default" then
                        u79[u104](p116, v117);
                    elseif u114 == "Laser" then
                        u79.Laser(p116, v117);
                    elseif u114 == "Flashlight" then
                        u79.Flashlight(p116, v117);
                    else
                        u79.Laser(p116, v117);
                        u79.Flashlight(p116, v117);
                    end;
                end;
            end;
            v74[#v74 + 1] = {
                Image = #v105 == 1 and u78 or u17.Multi,
                Name = v76.Name,
                Functions = v105
            };
        end;
        local function v125(p118) --[[ Line: 539 ]]
            -- upvalues: u72 (copy), u18 (ref), u73 (copy)
            local u119 = p118.Name:sub(5, 5);
            local u120 = p118.MetaData and p118.MetaData.Camo or p118.File.DefaultCamo;
            if u120 then
                if not u72[u120] then
                    u72[u120] = {};
                end;
                local v121 = u72[u120];
                v121[#v121 + 1] = function(p122) --[[ Line: 548 ]]
                    -- upvalues: u18 (ref), u120 (copy), u73 (ref), u119 (copy)
                    local v123 = u18[u120] == 2;
                    if u73[u119] then
                        for _, v124 in u73[u119] do
                            v124(p122, v123);
                        end;
                    end;
                end;
            end;
        end;
        local v126 = v75:GetChild("FunctionLink");
        if v126 then
            v125(v126);
        end;
        local v127 = v75:GetChild("FunctionLink2");
        if v127 then
            v125(v127);
        end;
        local l__Config__21 = v75.File.Config;
        if l__Config__21 then
            if l__Config__21.Magnifier then
                u67._magnifier = {
                    Active = false,
                    Lerp = 0,
                    Flip = l__Config__21.Magnifier.Flip,
                    FOV = l__Config__21.Magnifier.FOV,
                    Path = v75:GetFullName()
                };
            end;
            if l__Config__21.Bipod then
                u67._bipod = {
                    Active = false,
                    Path = v75:GetFullName()
                };
            end;
            if l__Config__21.Sights then
                if l__Config__21.Canted then
                    u67._canted = true;
                elseif l__Config__21.Sights[2] then
                    u67._canted = true;
                end;
            end;
        end;
    end;
    u67._keybinds = u72;
    u67.ActionMenu = v74;
    return u67;
end;
function u19.GetMuzzleCFrame(p128, p129) --[[ Line: 604 ]]
    -- upvalues: l__CurrentCamera__3 (copy)
    local l___actor__22 = p128._actor;
    local l__Position__23 = l__CurrentCamera__3.CFrame.Position;
    local v130 = l__CurrentCamera__3.CFrame.LookVector * 500;
    local v131 = workspace:Raycast(l__Position__23, v130, p128._params);
    local v132 = nil;
    if l___actor__22.Focused then
        v132 = l___actor__22.ViewModel.Muzzle;
    else
        local l__WorldMuzzle__24 = l___actor__22.ViewModel.WorldMuzzle;
        if l__WorldMuzzle__24 then
            local l__WorldPosition__25 = l__WorldMuzzle__24.WorldPosition;
            local l__LookVector__26 = l__WorldMuzzle__24.WorldCFrame.LookVector;
            local v133 = l__Position__23 + v130;
            local v134;
            if v131 then
                v134 = v131.Position;
                if (v134 - l__WorldPosition__25):Dot(l__LookVector__26) <= 0.3 then
                    v134 = v133;
                end;
            else
                v134 = v133;
            end;
            v132 = CFrame.new(l__WorldPosition__25, v134);
        end;
    end;
    local v135;
    if p129 and v132 then
        v135 = workspace:Raycast(v132.Position, v132.LookVector * 500, p128._params);
    else
        v135 = nil;
    end;
    return v132, v135, v131;
end;
function u19.Discharge(p136) --[[ Line: 642 ]]
    -- upvalues: u7 (copy), u5 (copy), u2 (copy), u4 (copy)
    if p136._mag and p136._mag.Capacity > 0 then
        local l___mag__27 = p136._mag;
        l___mag__27.Capacity = l___mag__27.Capacity - 1;
    else
        p136._item.MetaData.Chamber = false;
    end;
    local l___actor__28 = p136._actor;
    if l___actor__28 and l___actor__28.ViewModel then
        local v137 = p136:GetMuzzleCFrame();
        local v138 = {};
        local l__Tune__29 = p136._firearm.Tune;
        local v139 = l__Tune__29.Barrel_Spread or 1;
        local v140 = 0;
        local l__ADS__30 = l___actor__28.ADS;
        if l__ADS__30 then
            l__ADS__30 = l___actor__28.ViewModel.Zero;
        end;
        if l__ADS__30 then
            if typeof(l__ADS__30) == "table" then
                l__ADS__30 = l__ADS__30[4];
            end;
            local v141 = u7:GetInfo(l__Tune__29.Caliber, l__Tune__29.Barrel);
            v140 = math.asin(l__ADS__30 * 32.2 / v141 ^ 2) * 0.5;
        end;
        local v142;
        if p136._caliber.TracerCount then
            v142 = p136._bulletsShot % p136._caliber.TracerCount == 0;
        else
            v142 = false;
        end;
        for v143 = 1, p136._caliber.Bullets or 1 do
            local v144 = v139 * p136._caliber.Spread / 2;
            local v145 = v137 * CFrame.Angles(0, Random.new():NextNumber(-v144, v144) / 1000, 0) * CFrame.Angles(Random.new():NextNumber(-v144, v144) / 1000, 0, 0) * CFrame.Angles(v140, 0, 0);
            local v146 = u7:Discharge(v145, l__Tune__29.Caliber, l__Tune__29.Barrel, nil, true, true, nil, l___actor__28.Character, nil, v142);
            local v147, v148 = v145:ToOrientation();
            v138[v143] = {
                v146,
                v145.X,
                v145.Y,
                v145.Z,
                v147,
                v148
            };
        end;
        local v149;
        if l__Tune__29.Bolt_Action_Pause then
            v149 = u5.new();
            if l__Tune__29.Bolt_Action_NoPause then
                p136._next = os.clock() - l__Tune__29.Bolt_Action_Pause + 60 / l__Tune__29.RPM;
            else
                p136._bolt = v149;
            end;
        else
            v149 = nil;
        end;
        u2:FireServer("InventoryAction", "Discharge", v138, v142);
        l___actor__28:Action(u4.ActionType.Inventory, "Discharge", nil, l__Tune__29.Caliber, l__Tune__29.Barrel, p136._item.MetaData.Chamber == false, v149);
        if l__Tune__29.Bolt_Action_NoPause then
            v149:Fire();
        end;
        p136._bulletsShot = p136._bulletsShot + 1;
        p136:UpdateHUD();
        p136:_resetCQB();
    end;
end;
function u19.UpdateHUD(p150) --[[ Line: 719 ]]
    -- upvalues: u10 (copy)
    local l___mag__31 = p150._mag;
    u10:UpdateWeapon({
        Mode = p150:_getFiremode(),
        Mag = l___mag__31 and l___mag__31.Capacity or 0,
        Max = p150._max,
        Mags = p150:_getMags(),
        Chamber = p150._item.MetaData.Chamber
    });
end;
function u19.Update(p151, _) --[[ Line: 730 ]]
    -- upvalues: u4 (copy), u2 (copy), l__CurrentCamera__3 (copy), u16 (copy)
    local l___actor__32 = p151._actor;
    local l__CQB__33 = l___actor__32.CQB;
    if p151.CQB and p151.CQB ~= l__CQB__33 then
        p151.CQB = l__CQB__33;
        p151._actor:Action(u4.ActionType.Inventory, "CQB", l__CQB__33);
        u2:FireServer("InventoryAction", "CQB", l__CQB__33);
    end;
    if math.abs(l___actor__32.Magnify) > 0 then
        p151:_moveMagnifier(l___actor__32.Magnify);
        l___actor__32.Magnify = 0;
    end;
    if p151._fireMode and tick() - p151._fireMode > 0.5 then
        p151:_switchFiremode(true);
    end;
    local _, v152, v153 = p151:GetMuzzleCFrame(true);
    local v154 = nil;
    if v152 then
        if v153 then
            if (v152.Position - v153.Position).Magnitude > 0.7 then
                v154 = v152.Position;
            else
                local v155 = l__CurrentCamera__3:WorldToViewportPoint(v152.Position);
                if (Vector2.new(v155.X, v155.Y) - l__CurrentCamera__3.ViewportSize / 2).Magnitude / l__CurrentCamera__3.ViewportSize.Y > 0.04 then
                    v154 = v152.Position;
                end;
            end;
        else
            v154 = v152.Position;
        end;
    end;
    u16:SetBlockedPosition(v154);
end;
function u19.Equip(u156) --[[ Line: 771 ]]
    -- upvalues: u6 (copy), u18 (copy), u4 (copy), u2 (copy), u10 (copy)
    u156:UpdateHUD();
    local l__Tune__34 = u156._firearm.Tune;
    u156._next = os.clock() + (l__Tune__34.Equip_Delay or 1);
    local l___actor__35 = u156._actor;
    l___actor__35.Magnify = 0;
    l___actor__35.Weight = l__Tune__34.Weight;
    u156.Equipped = true;
    local v166 = {
        Reload = function(p157, p158) --[[ Name: Reload, Line 784 ]]
            -- upvalues: u6 (ref), u156 (copy)
            if u6.InventoryOpen or u6.RappelOpen then
            elseif p158 and u6.PromptOpen then
            else
                if p157 then
                    u156._cancelReload = nil;
                    u156:_reload(true);
                end;
            end;
        end,
        Firemode = function(p159) --[[ Name: Firemode, Line 796 ]]
            -- upvalues: u156 (copy)
            if p159 then
                u156._fireMode = tick();
            else
                if u156._fireMode then
                    u156:_switchFiremode(false);
                end;
            end;
        end,
        Discharge = function(p160) --[[ Name: Discharge, Line 803 ]]
            -- upvalues: u6 (ref), u156 (copy), l__Tune__34 (copy)
            if u6.RadialOpen or (u6.PauseOpen or u6.InventoryOpen) then
                p160 = false;
            end;
            if u156._autoReload and not u156._cancelReload then
                u156._cancelReload = true;
            end;
            if u156._bolt and not p160 then
                u156._bolt:Fire();
                u156._bolt = nil;
                u156._next = os.clock() - l__Tune__34.Bolt_Action_Pause + 60 / l__Tune__34.RPM;
            end;
            u156:_discharge(p160);
        end,
        Canted = function(p161) --[[ Name: Canted, Line 818 ]]
            -- upvalues: u156 (copy)
            if p161 then
                if u156._canted and u156._sight == 0 then
                    u156._sight = 1;
                    if u156.ADS then
                        u156:_ads(true);
                    end;
                elseif u156._sight == 1 then
                    u156._sight = 0;
                    if u156.ADS then
                        u156:_ads(true);
                    end;
                end;
            end;
        end,
        ADS = function(p162) --[[ Name: ADS, Line 833 ]]
            -- upvalues: u6 (ref), u18 (ref), u156 (copy)
            if p162 and (u6.RadialOpen or (u6.PauseOpen or u6.InventoryOpen)) then
            else
                if u18.AimHold == 2 or u6.Touch then
                    if p162 then
                        u156:_ads(not u156.ADS);
                    end;
                else
                    u156:_ads(p162);
                end;
            end;
        end,
        CQB = function(p163) --[[ Name: CQB, Line 846 ]]
            -- upvalues: u156 (copy), u4 (ref), u2 (ref)
            if p163 then
                if u156.CQB then
                    u156:_cancelCQB();
                    return;
                end;
                u156.CQB = 0;
                u156._actor:Action(u4.ActionType.Inventory, "CQB", 0);
                u2:FireServer("InventoryAction", "CQB", 0);
            end;
        end,
        ZeroUp = function(p164) --[[ Name: ZeroUp, Line 858 ]]
            -- upvalues: l___actor__35 (copy), u10 (ref)
            if p164 then
                local l__Zero__36 = l___actor__35.ViewModel.Zero;
                if typeof(l__Zero__36) == "table" then
                    l__Zero__36[4] = math.clamp(l__Zero__36[4] + l__Zero__36[3], l__Zero__36[1], l__Zero__36[2]);
                    l__Zero__36 = l__Zero__36[4];
                end;
                if l__Zero__36 then
                    u10:UpdateZero(l__Zero__36);
                end;
            end;
        end,
        ZeroDown = function(p165) --[[ Name: ZeroDown, Line 871 ]]
            -- upvalues: l___actor__35 (copy), u10 (ref)
            if p165 then
                local l__Zero__37 = l___actor__35.ViewModel.Zero;
                if typeof(l__Zero__37) == "table" then
                    l__Zero__37[4] = math.clamp(l__Zero__37[4] - l__Zero__37[3], l__Zero__37[1], l__Zero__37[2]);
                    l__Zero__37 = l__Zero__37[4];
                end;
                if l__Zero__37 then
                    u10:UpdateZero(l__Zero__37);
                end;
            end;
        end
    };
    if u156._firearm.File.Config.Animations.First.Inspect then
        function v166.Inspect(p167, p168) --[[ Line: 887 ]]
            -- upvalues: u6 (ref), u156 (copy), u4 (ref), u2 (ref)
            if u6.InventoryOpen or u6.RappelOpen then
            elseif p168 and u6.PromptOpen then
            else
                if p167 then
                    u156._actor:Action(u4.ActionType.Inventory, "Inspect");
                    u2:FireServer("InventoryAction", "Inspect");
                end;
            end;
        end;
    end;
    for v169, u170 in u156._keybinds do
        v166[v169] = function(p171) --[[ Line: 902 ]]
            -- upvalues: u170 (copy)
            for _, v172 in u170 do
                v172(p171);
            end;
        end;
    end;
    u156._controls = u6:Connect(v166);
end;
function u19.Reload(p173, p174) --[[ Line: 912 ]]
    -- upvalues: u14 (copy), u4 (copy)
    if p174 then
        p173._mag = p174;
        p173._max = u14.Mag[p174.Name].Config.Tune.Ammo;
        p173._item.MetaData.Mag = p174;
        if not p173._firearm.Tune.NoChamber then
            p173._item.MetaData.Chamber = true;
        end;
    end;
    p173._reloading = false;
    p173._next = os.clock() + 0.5;
    p173._actor:Action(u4.ActionType.Inventory, "Reloaded", p174);
    p173:UpdateHUD();
    if p173._autoReload then
        p173:_reload();
    end;
end;
function u19.Unequip(p175) --[[ Line: 933 ]]
    -- upvalues: u6 (copy), u10 (copy)
    u6.ADS = nil;
    p175._actor.Weight = 0;
    p175._actor.SpeedPenalty = nil;
    p175.Equipped = false;
    p175._reloading = false;
    p175.ADS = false;
    p175.CQB = nil;
    u10:UpdateWeapon();
    if p175._controls then
        p175._controls:Disconnect();
        p175._controls = nil;
    end;
    if p175._bolt then
        p175._bolt:DisconnectAll();
        p175._bolt = nil;
    end;
    for v176, v177 in p175._attachments do
        v176.Activated = v177;
    end;
end;
function u19.Destroy(_) --[[ Line: 959 ]] end;
return u19;