-- Services.InventoryService.DroneInventory
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

game:GetService("StarterPlayer");
local v1, u2, u3, _, _, u4 = shared.import("require", "network", "Enum", "asset", "frc", "Roact");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u5 = v1("Drones");
local u6 = v1("WorldService");
local u7 = v1("CameraService", true);
local u8 = v1("NotifyInterface");
local u9 = v1("DroneClass");
local u10 = v1("InputService");
local u11 = v1("OverlayInterface");
local u12 = v1({ "Ravic2Overlay" });
local u13 = {};
u13.__index = u13;
function u13.new(p14, p15, p16) --[[ Line: 32 ]]
    -- upvalues: u4 (copy), u5 (copy), u13 (copy)
    local l__Build__2 = p15.Layout.Build;
    local v17, v18 = u4.createBinding(1);
    local v19, v20 = u4.createBinding(0);
    local v21, v22 = u4.createBinding(0);
    local v23 = setmetatable({
        _lastEquip = 0,
        _lastDeploy = 0,
        _lastSend = 0,
        _isInCamera = false,
        Name = p15.Layout.Name,
        _spottingBinding = v21,
        _updateBattery = v18,
        _batteryBinding = v17,
        _updateSpotting = v22,
        _updateRange = v20,
        _rangeBinding = v19,
        _spotted = {},
        _config = u5[l__Build__2],
        _build = l__Build__2,
        _actor = p14,
        _item = p15,
        _inventory = p16
    }, u13);
    if p15.MetaData.Durability and p15.MetaData.Durability <= 0 then
        v23._broken = true;
    end;
    return v23;
end;
function u13._exitCamera(p24) --[[ Line: 69 ]]
    -- upvalues: u2 (copy), u10 (copy), u7 (copy), u11 (copy)
    p24._isInCamera = false;
    p24._actor.Frozen = false;
    u2:FireServer("InventoryAction", "Camera", false);
    u10.OverlayOpen = nil;
    u7.Lazy:RegisterCamera("Character");
    if p24._overlay then
        p24._overlay = nil;
        u11:Mount();
    end;
end;
function u13._getCurrentItem(p25) --[[ Line: 81 ]]
    for _, v26 in p25._inventory.Storages do
        for _, v27 in v26.Sections do
            for _, v28 in v27 do
                if v28.MetaData.UID == p25._item.MetaData.UID then
                    return v28;
                end;
            end;
        end;
    end;
end;
function u13.Broken(p29) --[[ Line: 93 ]]
    -- upvalues: u3 (copy)
    if p29._broken then
    else
        p29._broken = true;
        if p29._isInCamera then
            p29:_exitCamera();
        end;
        p29:BindControls();
        p29._actor:Action(u3.ActionType.Inventory, "Broken");
    end;
end;
function u13.Retrieve(p30) --[[ Line: 106 ]]
    -- upvalues: u3 (copy)
    if p30._isInCamera then
        p30:_exitCamera();
    end;
    p30._drone = nil;
    p30._actor:Action(u3.ActionType.Inventory, "Retrieve");
    p30:BindControls();
end;
function u13.Update(p31, p32) --[[ Line: 115 ]]
    -- upvalues: u2 (copy), u3 (copy), u6 (copy), l__CurrentCamera__1 (copy), u8 (copy)
    if p31._broken then
    else
        local l___drone__3 = p31._drone;
        if l___drone__3 then
            if p31._isInCamera then
                local v33 = tick();
                if v33 - p31._lastSend > 0.05 then
                    local l__CFrame__4 = l___drone__3.CFrame;
                    local _, v34 = l__CFrame__4:ToOrientation();
                    u2:FireServer("InventoryAction", "Sync", l__CFrame__4.X, l__CFrame__4.Y, l__CFrame__4.Z, v34);
                    p31._lastSend = v33;
                end;
                if p31._spotting then
                    if p31._spottingElapsed then
                        p31._spottingElapsed = p31._spottingElapsed + p32;
                    else
                        p31._spottingElapsed = 0;
                    end;
                    if p31._spottingElapsed >= l___drone__3.Config.SpotTime then
                        p31._spotting = false;
                        local v35 = RaycastParams.new();
                        v35.CollisionGroup = u3.PhysicsGroup.BulletCast;
                        v35.FilterType = u3.RaycastFilterType.Exclude;
                        v35.FilterDescendantsInstances = { l___drone__3.Model, u6.ActiveWorld };
                        v35.IgnoreWater = true;
                        local l__CFrame__5 = l__CurrentCamera__1.CFrame;
                        local v36 = {};
                        for v37, v38 in p31._actor.Replicator.Actors do
                            if not v38.Owner and (v38.ViewportOnScreen and (v38.LOD_Distance <= l___drone__3.Config.SpotDistance and not workspace:Raycast(l__CFrame__5.Position, v38.Position - l__CFrame__5.Position, v35))) then
                                v36[#v36 + 1] = { v37, v38.LOD_Distance };
                            end;
                        end;
                        if #v36 > 0 then
                            table.sort(v36, function(p39, p40) --[[ Line: 169 ]]
                                return p39[2] < p40[2];
                            end);
                            for v41 = 1, math.min(#v36, l___drone__3.Config.SpotMax) do
                                u2:FireServer("InventoryAction", "Spot", v36[v41][1]);
                            end;
                            if #v36 > l___drone__3.Config.SpotMax then
                                u8:Notify({
                                    { "Alert", "You can only spot " .. l___drone__3.Config.SpotMax .. " enemies at a time", Color3.new(1, 0.866666, 0.505882) }
                                });
                            end;
                        end;
                    end;
                    p31._updateSpotting(p31._spottingElapsed / l___drone__3.Config.SpotTime);
                else
                    p31._spottingElapsed = nil;
                    p31._updateSpotting(0);
                end;
            else
                p31._spottingElapsed = nil;
            end;
            local v42 = p31:_getCurrentItem();
            if v42 and v42.MetaData.Durability then
                p31._updateBattery(v42.MetaData.Durability / v42.MetaData.DurabilityMax);
            end;
            p31._updateRange(1 - (l___drone__3.CFrame.Position - p31._actor.CFrame.Position).Magnitude / l___drone__3.Config.Range);
        end;
    end;
end;
function u13.BindControls(u43) --[[ Line: 204 ]]
    -- upvalues: u10 (copy), u11 (copy), u12 (copy), u7 (copy), u2 (copy), u9 (copy), u3 (copy)
    if u43._controls then
        u43._controls:Disconnect();
        u43._controls = nil;
    end;
    u43._spotting = nil;
    if u43._broken then
    else
        local l___actor__6 = u43._actor;
        local v44 = {};
        if u43._drone then
            if u43._isInCamera then
                function v44.Discharge(p45) --[[ Line: 218 ]]
                    -- upvalues: u43 (copy)
                    u43._spotting = p45;
                end;
            end;
            function v44.Drone(p46) --[[ Line: 222 ]]
                -- upvalues: u10 (ref), u43 (copy), u11 (ref), u12 (ref), u7 (ref), u2 (ref)
                if p46 and not (u10.PauseOpen or (u10.RadialOpen or u10.InventoryOpen)) then
                    if u43._broken then
                    else
                        u43._isInCamera = not u43._isInCamera;
                        if u43._isInCamera then
                            u43._actor.Frozen = true;
                            if not u43._overlay then
                                u43._overlay = u11:Mount(u12[u43._drone.Config.Overlay .. "Overlay"], {
                                    Spotting = u43._spottingBinding,
                                    Battery = u43._batteryBinding,
                                    Range = u43._rangeBinding
                                });
                            end;
                            u7.Lazy:RegisterCamera("Drone", u43._drone);
                            u2:FireServer("InventoryAction", "Camera", true);
                            u10.OverlayOpen = true;
                        else
                            u43:_exitCamera();
                        end;
                        u43:BindControls();
                    end;
                end;
            end;
        else
            function v44.Discharge(p47) --[[ Line: 249 ]]
                -- upvalues: u10 (ref), u43 (copy), u9 (ref), l___actor__6 (copy), u3 (ref), u2 (ref)
                if p47 and not (u10.RadialOpen or (u10.PauseOpen or u10.InventoryOpen)) then
                    if u43._drone then
                    else
                        local v48 = tick();
                        if v48 - u43._lastEquip < u43._config.Equip then
                        elseif v48 - u43._lastDeploy < 1 then
                        else
                            u43._lastDeploy = v48;
                            local v49 = u9.new(u43._build, l___actor__6.CFrame:ToWorldSpace(CFrame.new(0, 2, -4)));
                            u43._drone = v49;
                            v49:ShowRetrieve(true);
                            l___actor__6:Action(u3.ActionType.Inventory, "Deploy", v49);
                            u2:FireServer("InventoryAction", "Deploy");
                            u43:BindControls();
                        end;
                    end;
                end;
            end;
        end;
        u43._controls = u10:Connect(v44);
    end;
end;
function u13.Equip(p50) --[[ Line: 279 ]]
    p50._equipped = true;
    p50._lastEquip = tick();
    p50:BindControls();
    if p50._drone then
        p50._drone:ShowRetrieve(true);
    end;
end;
function u13.Unequip(p51) --[[ Line: 289 ]]
    p51._equipped = false;
    if p51._drone then
        p51._drone:ShowRetrieve(false);
    end;
    if p51._isInCamera then
        p51:_exitCamera();
    end;
    if p51._controls then
        p51._controls:Disconnect();
        p51._controls = nil;
    end;
end;
function u13.Destroy(p52) --[[ Line: 305 ]]
    if p52._isInCamera then
        p52:_exitCamera();
    end;
    if p52._drone then
        p52._drone:Destroy();
        p52._drone = nil;
    end;
end;
return u13;