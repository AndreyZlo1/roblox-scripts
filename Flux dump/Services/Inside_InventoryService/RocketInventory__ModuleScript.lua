-- Services.InventoryService.RocketInventory
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, _, u3, _ = shared.import("require", "network", "server", "Enum", "signal");
local u4 = v1("InputService");
local u5 = v1("HUDInterface");
local u6 = v1("Rockets");
local u7 = v1("RocketAmmunition");
local u8 = v1("GameSettings");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u9 = {};
u9.__index = u9;
function u9.new(p10, p11, p12) --[[ Line: 18 ]]
    -- upvalues: u3 (copy), u6 (copy), u9 (copy)
    local v13 = RaycastParams.new();
    v13.FilterType = u3.RaycastFilterType.Blacklist;
    v13.FilterDescendantsInstances = { p10.Character };
    v13.CollisionGroup = u3.PhysicsGroup.BulletCast;
    v13.IgnoreWater = false;
    local v14 = u6[p11.Layout.Model];
    local v15 = setmetatable({
        Name = p11.Layout.Name,
        _config = v14,
        _params = v13,
        _actor = p10,
        _item = p11,
        _inventory = p12
    }, u9);
    if v14.Tune.Zero then
        v15._zero = table.clone(v14.Tune.Zero);
        v15._zero[4] = v15._zero[1];
    end;
    return v15;
end;
function u9._ads(p16, p17) --[[ Line: 44 ]]
    -- upvalues: u4 (copy), u3 (copy), u2 (copy)
    p16.ADS = p17;
    u4.ADS = p17;
    local v18 = not p16._zero and 1 or math.ceil(p16._zero[4] / p16._zero[3]);
    p16._actor:Action(u3.ActionType.Inventory, "ADS", p17, v18);
    u2:FireServer("InventoryAction", "ADS", p17);
end;
function u9._discharge(p19) --[[ Line: 57 ]]
    -- upvalues: l__CurrentCamera__1 (copy), u7 (copy), u2 (copy), u3 (copy)
    if p19._reloading then
    else
        local l__Mag__2 = p19._item.MetaData.Mag;
        if l__Mag__2 then
            p19._item.MetaData.Mag = nil;
            local l___actor__3 = p19._actor;
            local l__Tune__4 = p19._config.Tune;
            local v20;
            if l___actor__3.Focused then
                v20 = l___actor__3.ViewModel.Muzzle;
                local l___zero__5 = p19._zero;
                local l__MaxZeroAdjustment__6 = l__Tune__4.MaxZeroAdjustment;
                if p19.ADS and (l___zero__5 and l__MaxZeroAdjustment__6) then
                    v20 = (l__CurrentCamera__1.CFrame - l__CurrentCamera__1.CFrame.Position + v20.Position) * CFrame.Angles(math.lerp(l__Tune__4.MinZeroAdjustment or 0, l__MaxZeroAdjustment__6, (l___zero__5[4] - l___zero__5[1]) / (l___zero__5[2] - l___zero__5[1])), 0, 0);
                end;
            else
                local l__Position__7 = l__CurrentCamera__1.CFrame.Position;
                local v21 = l__CurrentCamera__1.CFrame.LookVector * 500;
                local v22 = workspace:Raycast(l__Position__7, v21, p19._params);
                v20 = CFrame.new(l___actor__3.ViewModel.WorldMuzzle.WorldPosition, v22 and v22.Position or l__Position__7 + v21);
            end;
            local l__Caliber__8 = u7[l__Mag__2].Caliber;
            local v23, v24 = v20:ToOrientation();
            u2:FireServer("InventoryAction", "Discharge", v20.X, v20.Y, v20.Z, v23, v24);
            l___actor__3:Action(u3.ActionType.Inventory, "Discharge", v20, l__Caliber__8);
            p19:UpdateHUD();
        end;
    end;
end;
function u9._reload(p25, p26) --[[ Line: 95 ]]
    -- upvalues: u3 (copy), u2 (copy)
    if p25._reloading then
        return;
    end;
    local v27 = p25:_getMags();
    if #v27 == 0 then
        return;
    end;
    local v28 = p26 or v27[1].UID;
    local v29 = nil;
    for _, v30 in p25._inventory.Storages do
        for _, v31 in v30.Sections do
            for _, v32 in v31 do
                if v32.MetaData.UID == v28 then
                    v29 = v32;
                    break;
                end;
            end;
        end;
    end;
    if v29 then
        p25._item.MetaData.Mag = nil;
        p25._reloading = true;
        p25._actor:Action(u3.ActionType.Inventory, "Reload", v29.Name:sub(5));
        u2:FireServer("InventoryAction", "Reload", v28);
        p25:UpdateHUD();
    end;
end;
function u9._getMags(p33) --[[ Line: 129 ]]
    local l__Ammunition__9 = p33._config.Tune.Ammunition;
    local v34 = {};
    for _, v35 in p33._inventory.Storages do
        for _, v36 in v35.Sections do
            for _, v37 in v36 do
                if table.find(l__Ammunition__9, v37.Name:sub(5)) then
                    v34[#v34 + 1] = {
                        Capacity = 1,
                        Max = 1,
                        Percent = 1,
                        UID = v37.MetaData.UID
                    };
                end;
            end;
        end;
    end;
    return v34;
end;
function u9.UpdateHUD(p38) --[[ Line: 150 ]]
    -- upvalues: u5 (copy)
    u5:UpdateWeapon({
        Mode = 1,
        Max = 1,
        Chamber = false,
        Mag = p38._item.MetaData.Mag and 1 or 0,
        Mags = p38:_getMags()
    });
end;
function u9.Update(_, _) --[[ Line: 160 ]] end;
function u9.Equip(u39) --[[ Line: 164 ]]
    -- upvalues: u4 (copy), u8 (copy), u3 (copy), u5 (copy)
    u39:UpdateHUD();
    local l__Tune__10 = u39._config.Tune;
    local v40 = {};
    for _, v41 in l__Tune__10.Ammunition do
        v40[#v40 + 1] = "Junk" .. v41;
    end;
    u4.CompatibleItems = v40;
    u39._ready = tick() + (l__Tune__10.DrawTime or 0);
    u39._equipped = true;
    u39._controls = u4:Connect({
        Reload = function(p42) --[[ Name: Reload, Line 177 ]]
            -- upvalues: u39 (copy), u4 (ref)
            if tick() < u39._ready then
            elseif p42 then
                if u4.InventoryOpen then
                    if u4.HoverItem then
                        u39:_reload(u4.HoverItem);
                    end;
                else
                    u39:_reload();
                end;
            end;
        end,
        Discharge = function(p43) --[[ Name: Discharge, Line 193 ]]
            -- upvalues: u39 (copy), u4 (ref)
            if tick() < u39._ready then
            elseif u39._actor.Sprinting then
            else
                if u4.RadialOpen or (u4.PauseOpen or u4.InventoryOpen) then
                    p43 = false;
                end;
                if p43 then
                    u39:_discharge();
                end;
            end;
        end,
        ADS = function(p44) --[[ Name: ADS, Line 207 ]]
            -- upvalues: u4 (ref), u8 (ref), u39 (copy)
            if p44 and (u4.RadialOpen or (u4.PauseOpen or u4.InventoryOpen)) then
            else
                if u8.AimHold == 2 or u4.Touch then
                    if p44 then
                        u39:_ads(not u39.ADS);
                    end;
                else
                    u39:_ads(p44);
                end;
            end;
        end,
        ZeroUp = function(p45) --[[ Name: ZeroUp, Line 220 ]]
            -- upvalues: u39 (copy), u3 (ref), u5 (ref)
            if p45 then
                local l___zero__11 = u39._zero;
                if not l___zero__11 then
                    return;
                end;
                l___zero__11[4] = math.clamp(l___zero__11[4] + l___zero__11[3], l___zero__11[1], l___zero__11[2]);
                if u39.ADS then
                    u39._actor:Action(u3.ActionType.Inventory, "ADS", true, (math.ceil(l___zero__11[4] / l___zero__11[3])));
                end;
                if l___zero__11 then
                    u5:UpdateZero(l___zero__11[4]);
                end;
            end;
        end,
        ZeroDown = function(p46) --[[ Name: ZeroDown, Line 237 ]]
            -- upvalues: u39 (copy), u3 (ref), u5 (ref)
            if p46 then
                local l___zero__12 = u39._zero;
                if not l___zero__12 then
                    return;
                end;
                l___zero__12[4] = math.clamp(l___zero__12[4] - l___zero__12[3], l___zero__12[1], l___zero__12[2]);
                if u39.ADS then
                    u39._actor:Action(u3.ActionType.Inventory, "ADS", true, (math.ceil(l___zero__12[4] / l___zero__12[3])));
                end;
                if l___zero__12 then
                    u5:UpdateZero(l___zero__12[4]);
                end;
            end;
        end
    });
end;
function u9.Reload(p47, p48) --[[ Line: 257 ]]
    -- upvalues: u3 (copy)
    p47._reloading = false;
    if p48 then
        p47._item.MetaData.Mag = p48;
    end;
    p47._actor:Action(u3.ActionType.Inventory, "Reloaded");
    p47:UpdateHUD();
    p47._ready = tick() + p47._config.Tune.Reload_Ready;
end;
function u9.Unequip(p49) --[[ Line: 268 ]]
    -- upvalues: u4 (copy), u5 (copy)
    u4.CompatibleItems = nil;
    p49._equipped = false;
    p49._reloading = false;
    p49.ADS = false;
    u5:UpdateWeapon();
    if p49._controls then
        p49._controls:Disconnect();
        p49._controls = nil;
    end;
end;
function u9.Destroy(_) --[[ Line: 282 ]] end;
return u9;