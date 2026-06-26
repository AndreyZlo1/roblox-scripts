-- Services.ControllerService.TurretController
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4, u5, u6 = shared.import("require", "network", "Enum", "server", "Roact", "frc");
local u7 = v1("ViewmodelService");
local u8 = v1("VehicleService");
local u9 = v1("PrefabService");
local u10 = v1("InputService");
local u11 = v1("BulletService");
local u12 = v1("SoundService");
local u13 = v1("ClientService");
local u14 = v1("NotifyInterface");
local u15 = v1("InventoryService");
local u16 = v1("EffectsService");
local u17 = v1("EnvironmentService");
local u18 = v1("CameraShakePresets");
local u19 = v1("Calibers");
local u20 = v1("RoactTween");
local u21 = v1("HUDInterface");
local u22 = v1("OverlayInterface");
local u23 = v1({ "CROWSOverlay", "ADMOverlay" });
local u24 = v1("Mathf");
local u25 = v1("Weapon");
local u26 = v1("Turrets");
local u27 = v1("GameSettings");
local l__RunService__1 = game:GetService("RunService");
local u28 = {};
u28.__index = u28;
function u28._ads(p29, p30) --[[ Line: 46 ]]
    -- upvalues: u17 (copy), u22 (copy), u23 (copy)
    p29.ADS = p30;
    u17.FLIR = false;
    if p29._remote then
        if p30 then
            if not p29._overlay then
                p29._overlay = u22:Mount(u23[p29._config.Overlay .. "Overlay"], p29._overlayProps);
            end;
        elseif p29._overlay then
            u22:Mount();
            p29._overlay = nil;
        end;
        p29._localActor.CameraZoom = p30 and p29._zoom or 0;
    end;
end;
function u28._discharge(p31, p32) --[[ Line: 63 ]]
    -- upvalues: u4 (copy), u12 (copy), l__RunService__1 (copy)
    p31._active = p32;
    if u4.FREEZE_PLAYERS or not p32 then
        return;
    end;
    local v33 = true;
    local l___mag__2 = p31._mag;
    if l___mag__2 and l___mag__2.Capacity > 0 then
        if p31:_canShoot() and (p31:_getFiremode() > 0 and (p31._active and (not p31._shooting and (not p31._reloading and tick() > p31._next)))) then
            p31._shooting = true;
            local l__Bolt__3 = p31._config.Bolt;
            local v34 = 60 / p31._config.RPM;
            local v35 = tick();
            local v36 = v34;
            local v37 = 0;
            local v38 = false;
            while p31:_canShoot() and (p31:_getFiremode() > 0 and (v33 or p31._active)) and (not p31._reloading and (l___mag__2 and l___mag__2.Capacity > 0)) do
                if l__Bolt__3 and not v38 then
                    u12:CreateSound("Weapon_Interaction", nil, true, "Weapons", p31._name, "Handling", "Bolt").Destroy(5);
                    task.wait(l__Bolt__3);
                    v35 = tick();
                    v38 = true;
                end;
                local v39 = tick();
                local v40 = v34 + (v39 - v35);
                local v41 = p31:_getFiremode();
                local v42 = math.floor(v40 / v36);
                local v43 = math.min(v42, l___mag__2 and (l___mag__2.Capacity or 0) or 0);
                if v43 > 0 then
                    v35 = v39;
                    for _ = 1, v43 do
                        p31:Discharge();
                        v33 = false;
                        v37 = v37 + 1;
                        if v41 == 3 and v37 >= 3 then
                            break;
                        end;
                    end;
                    p31._next = v39 + v36;
                else
                    v35 = v39;
                end;
                if v41 == 1 or (v41 == 3 and v37 >= 3 or p31._remote and not p31.ADS) then
                    break;
                end;
                v34 = v40 - v43 * v36;
                l__RunService__1.RenderStepped:Wait();
            end;
            p31._shooting = false;
        end;
    elseif p32 then
    end;
end;
function u28._canShoot(p44) --[[ Line: 133 ]]
    -- upvalues: u3 (copy), u14 (copy), u13 (copy)
    if p44._vehicle then
        local l__TurretAccess__4 = p44._vehicle.TurretAccess;
        if l__TurretAccess__4 == u3.TurretAccess.Disabled then
            u14:Notify({
                { "Alert", "The vehicle owner has disabled turrets", Color3.new(1, 0.866666, 0.505882) }
            });
            return false;
        end;
        if l__TurretAccess__4 == u3.TurretAccess.Squad then
            local v45 = u13.Clients[p44._vehicle.Owner];
            local l__LocalClient__5 = u13.LocalClient;
            if v45 and (l__LocalClient__5 and v45.Squad ~= l__LocalClient__5.Squad) then
                u14:Notify({
                    { "Alert", "The vehicle owner has set turrets to squad members only", Color3.new(1, 0.866666, 0.505882) }
                });
                return false;
            end;
        end;
    end;
    return true;
end;
function u28._getFiremode(p46) --[[ Line: 163 ]]
    local l___mode__6 = p46._mode;
    return p46._reloading and table.find(p46._config.Firemodes, 0) and 0 or p46._config.Firemodes[l___mode__6];
end;
function u28._getMags(p47) --[[ Line: 172 ]]
    -- upvalues: u15 (copy), u25 (copy)
    local v48 = {};
    local l__Mags__7 = p47._config.Mags;
    local v49 = u15.Inventories[p47._inventory];
    if not v49 then
        return {};
    end;
    for _, v50 in v49.Storages do
        for _, v51 in v50.Sections do
            for _, v52 in v51 do
                if v52.Name:sub(1, 10) == "FirearmMag" then
                    local l__MetaData__8 = v52.MetaData;
                    if l__MetaData__8.Capacity > 0 and table.find(l__Mags__7, l__MetaData__8.Name) then
                        v48[#v48 + 1] = {
                            UID = l__MetaData__8.UID,
                            Capacity = l__MetaData__8.Capacity,
                            Max = u25.Mag[l__MetaData__8.Name].Config.Tune.Ammo,
                            Percent = l__MetaData__8.Capacity / u25.Mag[l__MetaData__8.Name].Config.Tune.Ammo
                        };
                    end;
                end;
            end;
        end;
    end;
    table.sort(v48, function(p53, p54) --[[ Line: 198 ]]
        return p53.Percent > p54.Percent;
    end);
    return v48;
end;
function u28.new(p55, p56, p57, p58, p59, u60, p61, p62, u63, p64) --[[ Line: 205 ]]
    -- upvalues: u3 (copy), u5 (copy), u26 (copy), u20 (copy), u28 (copy), u25 (copy), u8 (copy), u9 (copy), u10 (copy), u2 (copy), u27 (copy), u17 (copy), u14 (copy), u7 (copy)
    local v65 = RaycastParams.new();
    v65.IgnoreWater = true;
    v65.CollisionGroup = u3.PhysicsGroup.RGESelectable;
    local v66, v67 = u5.createBinding(0);
    local v68, v69 = u5.createBinding(0);
    local v70, v71 = u5.createBinding(0);
    local v72, v73 = u5.createBinding(0);
    local v74, v75 = u5.createBinding(false);
    local v76, v77 = u5.createBinding(false);
    local u78 = u26[p61];
    local v79 = {
        _max = 0,
        _next = 0,
        _zoom = 0,
        _inventory = p64,
        _config = u78,
        _name = p61,
        _uid = p56,
        _mag = u63,
        _mode = p62,
        _remote = u60,
        _params = v65,
        _localActor = p55,
        _overlayProps = {
            FOV = v68,
            Elev = v70,
            Ballistic = v72,
            Armed = v76,
            Compass = v66,
            LowAmmo = v74,
            Blur = u20.new(0)
        },
        _updateBallistic = v73,
        _updateCompass = v67,
        _updateElev = v71,
        _updateFOV = v69,
        _updateLowAmmo = v75,
        _updateArmed = v77
    };
    local u80 = setmetatable(v79, u28);
    p55.HeightState = u3.CharacterHeightState.Sitting;
    if u63 then
        u80._max = u25.Mag[u63.Name].Config.Tune.Ammo;
    end;
    if typeof(p57) == "string" then
        local v81 = u8:GetVehicle(p57);
        u80._turret = v81.Turrets[p58];
        u80._vehicle = v81;
    else
        u80._turret = u9:GetPrefab(p57);
    end;
    u80._limit = p59;
    u80._turret.Focused = true;
    local v89 = {
        Exit = function(p82) --[[ Name: Exit, Line 266 ]]
            -- upvalues: u10 (ref), u2 (ref)
            if p82 and not u10.PauseOpen then
                u2:FireServer("ActivateInteract", "Exit");
            end;
        end,
        ADS = function(p83) --[[ Name: ADS, Line 271 ]]
            -- upvalues: u27 (ref), u80 (copy)
            if u27.AimHold == 2 or u80._remote then
                if p83 then
                    u80:_ads(not u80.ADS);
                end;
            else
                u80:_ads(p83);
            end;
        end,
        Firemode = function(p84) --[[ Name: Firemode, Line 280 ]]
            -- upvalues: u60 (copy), u80 (copy), u78 (copy), u2 (ref)
            if p84 then
                if u60 and not u80.ADS then
                    return;
                end;
                if u80._mode == #u78.Firemodes then
                    u80._mode = 1;
                else
                    local v85 = u80;
                    v85._mode = v85._mode + 1;
                end;
                u2:FireServer("ActivateTurret", u80._uid, "Mode", u80._mode);
                u80:UpdateHUD();
            end;
        end,
        Discharge = function(p86) --[[ Name: Discharge, Line 296 ]]
            -- upvalues: u10 (ref), u60 (copy), u80 (copy)
            if u10.RadialOpen or (u10.PauseOpen or u10.InventoryOpen) then
                p86 = false;
            end;
            if u60 and not u80.ADS then
            else
                u80:_discharge(p86);
            end;
        end,
        Reload = function(p87) --[[ Name: Reload, Line 305 ]]
            -- upvalues: u10 (ref), u80 (copy), u63 (copy), u60 (copy), u2 (ref)
            if u10.InventoryOpen then
            else
                if p87 then
                    if u80._reloading then
                        return;
                    end;
                    local v88 = u80:_getMags();
                    if v88[1] == nil then
                        return;
                    end;
                    u80._reloading = true;
                    local l__UID__9 = v88[1].UID;
                    if u63 then
                        u80._mag = nil;
                        u80._max = 0;
                    end;
                    u80:UpdateHUD();
                    if not u60 then
                        u80._turret.Chain:Reload(u63 and u63.Capacity > 0 and "Reload" or "Reload_Dry");
                    end;
                    u2:FireServer("ActivateTurret", u80._uid, "Reload", l__UID__9);
                end;
            end;
        end
    };
    if u60 then
        function v89.TurretCamera(p90) --[[ Line: 336 ]]
            -- upvalues: u80 (copy), u17 (ref), u10 (ref), u14 (ref)
            if p90 then
                if u80.ADS then
                    u17.FLIR = not u17.FLIR;
                    return;
                end;
                u14:Notify({
                    { "Alert", "Press [" .. u10:GetBind("ADS").Name .. "] to use remote turret", Color3.new(1, 0.866666, 0.505882) }
                });
            end;
        end;
    end;
    u80:UpdateHUD();
    u80._controls = u10:Connect(v89);
    p55.ZoomDirection = 0;
    p55.CameraLerp = 0;
    p55.CameraZoom = 0;
    p55.Camera = u80._turret.Sight;
    u7.Viewmodel.FollowWorldModel = true;
    return u80;
end;
function u28.Discharge(p91) --[[ Line: 364 ]]
    -- upvalues: u19 (copy), u11 (copy), u2 (copy), u10 (copy), u16 (copy), u18 (copy)
    local l___mag__10 = p91._mag;
    l___mag__10.Capacity = l___mag__10.Capacity - 1;
    local l___config__11 = p91._config;
    local v92 = (l___config__11.Barrel_Spread or 1) * u19[l___config__11.Caliber].Spread / 2;
    local v93 = p91._turret.Muzzle.WorldCFrame * CFrame.Angles(0, Random.new():NextNumber(-v92, v92) / 1000, 0) * CFrame.Angles(Random.new():NextNumber(-v92, v92) / 1000, 0, 0);
    local v94 = u11:Discharge(v93, l___config__11.Caliber, l___config__11.Barrel, nil, true, true);
    local v95, v96 = v93:ToOrientation();
    u2:FireServer("ActivateTurret", p91._uid, "Discharge", v94, v93.X, v93.Y, v93.Z, v95, v96);
    p91:UpdateHUD();
    p91._turret.Chain:Discharge(p91._mag.Capacity, l___config__11.RPM, l___config__11.Caliber, true);
    if p91._overlayProps then
        p91._overlayProps.Blur:SetValue(1);
        p91._overlayProps.Blur:SetGoal(0);
    end;
    local v97 = u10.Gamepad and 5 or 1;
    local v98 = math.noise(tick() % 1000000, 0, 0);
    local v99 = math.clamp(v98, -0.5, 0.5) * 2;
    local v100 = math.noise(tick() % 1000000, 0, 0);
    local v101 = math.clamp(v100, -0.5, 0.5) * 2;
    local l__Recoil_Base__12 = l___config__11.Recoil_Base;
    local l__Recoil_Range__13 = l___config__11.Recoil_Range;
    local v102 = (l__Recoil_Base__12 + Vector2.new(l__Recoil_Range__13.X * v99, l__Recoil_Range__13.Y * v101)) / v97;
    p91._localActor.ViewModel.Recoil:Impulse(l___config__11.Recoil_Camera, l___config__11.Recoil_Kick, Vector2.new(v102.X, v102.Y));
    if p91._remote and p91.ADS then
        u16.Camera:Shake(u18.Bump, 0.5);
    end;
end;
function u28.Reload(p103, p104) --[[ Line: 411 ]]
    -- upvalues: u25 (copy)
    p103._mag = p104;
    p103._max = u25.Mag[p104.Name].Config.Tune.Ammo;
    p103._reloading = false;
    p103:UpdateHUD();
end;
function u28.UpdateHUD(p105) --[[ Line: 418 ]]
    -- upvalues: u21 (copy)
    local l___mag__14 = p105._mag;
    u21:UpdateWeapon({
        Chamber = false,
        Mode = p105:_getFiremode(),
        Mag = l___mag__14 and l___mag__14.Capacity or 0,
        Max = p105._max,
        Mags = p105:_getMags()
    });
end;
function u28.Update(p106, _, p107) --[[ Line: 429 ]]
    -- upvalues: u24 (copy), u6 (copy), u2 (copy)
    local l___localActor__15 = p106._localActor;
    l___localActor__15.CameraLerp = u24.Lerp(l___localActor__15.CameraLerp, p106.ADS and 1 or 0, p106._remote and 1 or u6(p107 * 20));
    local l___turret__16 = p106._turret;
    local l__CFrame__17 = l___turret__16.Pivot.CFrame;
    if l___turret__16.Offset then
        l__CFrame__17 = l__CFrame__17:ToWorldSpace(l___turret__16.Offset);
    end;
    local v108 = CFrame.Angles(0, l___localActor__15.OffsetX, 0) * CFrame.Angles(l___localActor__15.OffsetY, 0, 0) * CFrame.Angles(0, 0, l___localActor__15.OffsetZ) * CFrame.Angles(0, l___localActor__15.CameraX, 0) * CFrame.Angles(l___localActor__15.CameraY, 0, 0);
    local v109, v110 = l__CFrame__17:ToObjectSpace(v108):ToOrientation();
    if p106._overlay then
        p106._zoom = math.clamp(p106._zoom + l___localActor__15.ZoomDirection * 5, 0, 50);
        l___localActor__15.CameraZoom = math.lerp(l___localActor__15.CameraZoom, p106._zoom, u6(p107 * 20));
        local l___mag__18 = p106._mag;
        local v111 = (not l___mag__18 or l___mag__18.Capacity <= p106._max * 0.25) and true or false;
        local l__Sight__19 = l___turret__16.Sight;
        local v112 = workspace:Raycast(l__Sight__19.WorldPosition, l__Sight__19.WorldCFrame.LookVector * 2000, p106._params);
        p106._updateBallistic(not v112 and 2000 or (l__Sight__19.WorldPosition - v112.Position).Magnitude);
        p106._updateArmed(not p106._reloading);
        p106._updateLowAmmo(v111);
        p106._updateCompass(-math.deg(v110));
        p106._updateElev((math.deg(v109)));
        p106._updateFOV(70 - p106._zoom);
        l___localActor__15.ZoomDirection = 0;
    end;
    if p106._limit and p106._limit < 360 then
        local l__LookVector__20 = l__CFrame__17.LookVector;
        local l__LookVector__21 = v108.LookVector;
        local l___limit__22 = p106._limit;
        local v113 = l__LookVector__20:Dot(l__LookVector__21) / (l__LookVector__20.Magnitude * l__LookVector__21.Magnitude);
        local v114 = math.acos(v113);
        if math.deg(v114) >= l___limit__22 / 2 then
            return;
        end;
    end;
    if p106._remote and not p106.ADS then
    else
        p106._turret.Facing = Vector2.new(v110, v109);
        u2:FireServer("ReplicateTurret", p106._uid, v110, v109);
    end;
end;
function u28.Destroy(p115) --[[ Line: 480 ]]
    -- upvalues: u17 (copy), u7 (copy), u22 (copy), u21 (copy)
    u17.FLIR = false;
    u7.Viewmodel.FollowWorldModel = false;
    if p115._overlay then
        u22:Mount();
    end;
    if p115._reloading and not p115._remote then
        p115._turret.Chain:Reload();
    end;
    p115._active = false;
    u21:UpdateWeapon();
    p115._localActor.Camera = nil;
    p115._localActor.CameraZoom = nil;
    p115._localActor.CameraLerp = nil;
    p115._turret.Focused = nil;
    p115._controls:Disconnect();
end;
return u28;