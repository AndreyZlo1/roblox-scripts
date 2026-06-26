-- Services.VehicleService.HelicopterVehicle
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local l__Lighting__1 = game:GetService("Lighting");
local v1, u2, u3 = shared.import("require", "Enum", "asset");
local u4 = v1("VehicleClass");
local u5 = v1("VehicleSolver");
local u6 = v1("RopeClass");
local u7 = v1("WorldService");
local u8 = v1("SoundService");
local u9 = v1("ViewmodelService");
local l__CurrentCamera__2 = workspace.CurrentCamera;
local u10 = {};
u10.__index = u10;
setmetatable(u10, u4);
function u10._updateLight(p11, p12, p13) --[[ Line: 21 ]]
    -- upvalues: u2 (copy)
    local l__Origin__3 = p12.Origin;
    if l__Origin__3:IsA("BasePart") then
        l__Origin__3.Material = p13 and u2.Material.Neon or p12.OriginalMaterial;
        l__Origin__3.Transparency = p13 and 0 or p12.OriginalTransparency;
        l__Origin__3.Color = p13 and p13.Color or p12.OriginalColor;
    end;
    local l___lightPayload__4 = p11._lightPayload;
    if p13 and p13.Brightness then
        local l__PointLight__5 = p12.PointLight;
        if not l__PointLight__5 then
            l__PointLight__5 = Instance.new(p13.Angle and "SpotLight" or "PointLight");
            if p13.Angle then
                l__PointLight__5.Face = u2.NormalId.Right;
            end;
            l__PointLight__5.Shadows = true;
            l__PointLight__5.Parent = l__Origin__3;
            p12.PointLight = l__PointLight__5;
        end;
        if p13.Angle then
            l__PointLight__5.Angle = p13.Angle;
        end;
        l__PointLight__5.Brightness = p13.Brightness or 1;
        l__PointLight__5.Range = p13.Range or 30;
        l__PointLight__5.Color = p13.Color or Color3.new(1, 1, 1);
        l___lightPayload__4[l__Origin__3] = {
            Color = p13.Color,
            Intensity = p13.Brightness + 5
        };
    else
        if p12.PointLight then
            p12.PointLight:Destroy();
            p12.PointLight = nil;
            l___lightPayload__4[l__Origin__3] = nil;
        end;
    end;
end;
function u10._generateIdleSounds(p14) --[[ Line: 62 ]]
    -- upvalues: u8 (copy)
    p14._idleSounds = {
        Interior = {},
        Exterior = {}
    };
    p14._dopplers = {};
    local v15 = u8:CreateSound("Helicopter", p14.Hitbox, false, "VehicleSound", "Helicopter", p14._vehicleName, "Ext", "Idle");
    local v16 = u8:CreateSound("Helicopter", nil, false, "VehicleSound", "Helicopter", p14._vehicleName, "Int", "Idle");
    v16.Sound.Volume = 0;
    v15.Sound:Play();
    v16.Sound:Play();
    p14._dopplers[#p14._dopplers + 1] = v15.ApplyEffect("Helicopter");
    p14._idleSounds.Interior[#p14._idleSounds.Interior + 1] = v16;
    p14._idleSounds.Exterior[#p14._idleSounds.Exterior + 1] = v15;
end;
function u10._doRappels(p17, p18) --[[ Line: 81 ]]
    -- upvalues: u8 (copy), u6 (copy)
    p17.LastRappel = tick();
    if p18 and p17.RappelPoints then
        local v19 = {};
        for v20, v21 in p17.RappelPoints do
            u8:CreateSound("Vehicle_Interaction", v21, true, "Foley", "Fastrope", "Deploy").Destroy(2);
            v19[v20] = u6.new(v21, 5, 20);
        end;
        p17.Rappels = v19;
    else
        if p17.Rappels then
            for _, v22 in p17.Rappels do
                u8:CreateSound("Vehicle_Interaction", v22.Host, true, "Foley", "Fastrope", "Drop").Destroy(2);
                v22:Despawn();
            end;
            p17.Rappels = nil;
        end;
    end;
end;
function u10._updateLightModes(p23, p24) --[[ Line: 106 ]]
    -- upvalues: l__Lighting__1 (copy)
    if p24 then
        p23.LightModes = p24;
    end;
    if p23.LightModes and p23.VehicleModule.LightModes then
        for v25, v26 in p23.VehicleModule.LightModes do
            local v27 = p23._lightModes[v25];
            if v27 then
                local v28 = p23.LightModes[v25];
                if p23.InRestrictedAirspace then
                    local v29 = v26[1];
                    if v29 == "Position" then
                        v28 = 2;
                    elseif v29 == "Anti-Collision" then
                        local _ = l__Lighting__1.ClockTime;
                        v28 = 3;
                    end;
                end;
                local v30 = v26[2][v28];
                local l__Mode__6 = v30.Mode;
                for _, v31 in v27 do
                    local v32 = v31.Modes[l__Mode__6];
                    local v33 = false;
                    local v34 = false;
                    if v32 then
                        if l__Mode__6 == 2 or v30.StrobeSpeed then
                            v34 = {
                                Mode = l__Mode__6,
                                StrobeSpeed = v30.StrobeSpeed,
                                StrobeBlink = v30.StrobeBlink
                            };
                        else
                            v33 = true;
                        end;
                    end;
                    if v34 then
                        p23._lightActive[v31] = v34;
                    elseif p23._lightActive[v31] then
                        p23._lightActive[v31] = nil;
                    end;
                    p23:_updateLight(v31, v33 and v32);
                end;
            end;
        end;
    end;
end;
function u10.new(p35, p36, p37) --[[ Line: 159 ]]
    -- upvalues: u4 (copy), u10 (copy)
    local v38 = u4.new(p35, p36, p37);
    setmetatable(v38, u10);
    v38._dopplers = {};
    v38._lightActive = {};
    v38._lightPayload = {};
    v38._lastBladeUpdate = 0;
    v38.InRestrictedAirspace = false;
    v38.EngineLast = 0;
    v38.ParkingBrakeOn = p37.ParkingBrakeOn;
    v38.EngineOn = p37.EngineOn;
    v38:_updateLightModes(p37.LightModes);
    local l__VehicleModel__7 = v38.VehicleModel;
    local l__VehicleOrigin__8 = v38.VehicleOrigin;
    local l__VehicleModule__9 = v38.VehicleModule;
    local l__Model__10 = v38.Model;
    local l__Hitbox__11 = v38.Hitbox;
    local l__Rotors__12 = l__VehicleModule__9.Model.Rotors;
    local v39 = {};
    for _, v40 in l__VehicleModel__7:WaitForChild("Rotors"):GetChildren() do
        local v41 = v40:Clone();
        local v42;
        if v41:IsA("Model") then
            v42 = v41:FindFirstChild("Blades") or v41:FindFirstChild("Rotor");
        else
            local v43 = Instance.new("Model");
            v43.Name = v41.Name;
            v41.Name = "Rotor";
            v41.Parent = v43;
            v42 = v41;
            v41 = v43;
        end;
        local u44 = nil;
        local function v50(p45) --[[ Line: 199 ]]
            -- upvalues: u44 (ref)
            if p45 then
                if not u44 then
                    u44 = {};
                end;
                for _, v46 in p45:GetChildren() do
                    local v47 = {
                        { v46, v46.CFrame, 0 }
                    };
                    for v48, v49 in v46:GetDescendants() do
                        v47[v48 + 1] = { v49, v49.CFrame, (v49.WorldCFrame.Position - v46.WorldCFrame.Position).Magnitude };
                    end;
                    u44[#u44 + 1] = v47;
                end;
            end;
        end;
        v50(v42:FindFirstChildWhichIsA("Bone"));
        local v51 = v41:FindFirstChild("Blur");
        if v51 then
            v51.Transparency = 1;
            v50(v51:FindFirstChildWhichIsA("Bone"));
        end;
        local v52 = u44;
        for _, v53 in v41:GetChildren() do
            if v53 ~= v42 then
                local v54 = Instance.new("Weld");
                v54.Part0 = v42;
                v54.Part1 = v53;
                v54.C0 = v42.CFrame:ToObjectSpace(v53.CFrame);
                v54.Parent = v42;
            end;
            v53.Name = "Part";
            v53.Anchored = false;
            v53.Massless = true;
            v53.CanCollide = false;
            v53.CanTouch = false;
            v53.CanQuery = false;
            v53.AudioCanCollide = false;
            v53.TextureID = l__Rotors__12;
        end;
        local l__Rotate__13 = v42:WaitForChild("Rotate");
        local v55 = Instance.new("Weld");
        v55.Part0 = l__Hitbox__11;
        v55.Part1 = v42;
        v55.C1 = l__Rotate__13.CFrame;
        v55.C0 = l__VehicleOrigin__8:ToObjectSpace(l__Rotate__13.WorldCFrame);
        v55.Parent = v42;
        v41.Parent = l__Model__10;
        local v56 = nil;
        if v42 then
            if v51 then
                v56 = v42;
            end;
        end;
        v39[v40.Name] = {
            Blur = v51,
            Bones = v52,
            Rotor = v41,
            DamageResistance = v40:GetAttribute("DamageResistance") or 0,
            Weld = v55,
            Name = v40.Name,
            BladeActual = v56,
            Radius = v40:GetAttribute("Radius") or math.max(v42.Size.X, v42.Size.Y, v42.Size.Z) / 2,
            Offset = v55.C0,
            OriginCF = l__Rotate__13.CFrame
        };
        v41:SetAttribute("Component", v40.Name);
    end;
    if p37.Rappels then
        v38:_doRappels(true);
    end;
    v38.Rotors = v39;
    local v57 = nil;
    local v58 = v38.VehicleModel:FindFirstChild("Collisions");
    local v59;
    if v58 then
        for _, v60 in v58:GetChildren() do
            local l__CFrame__14 = v60.CFrame;
            local v61 = v60.Size / 2;
            local v62 = l__CFrame__14.RightVector * -math.sign(l__CFrame__14.RightVector.Y) * v61.X;
            local v63 = l__CFrame__14.UpVector * -math.sign(l__CFrame__14.UpVector.Y) * v61.Y;
            local v64 = l__CFrame__14.LookVector * -math.sign(l__CFrame__14.LookVector.Y) * v61.Z;
            local l__Position__15 = (l__CFrame__14 + v62 + v63 + v64).Position;
            if not v57 or l__Position__15.Y < v57 then
                v57 = l__Position__15.Y;
            end;
        end;
        v59 = v57 - v38.VehicleMain.Position.Y;
    else
        v59 = -v38.VehicleMain.Size.Y / 2;
    end;
    v38.BottomOfCollisions = v59;
    local v65 = l__VehicleModel__7:FindFirstChild("Wheels");
    if v65 then
        local v66 = {
            F = {},
            R = {}
        };
        for _, v67 in v65:GetChildren() do
            local l__Name__16 = v67.Name;
            local v68 = v66[l__Name__16];
            for _, v69 in v67:GetChildren() do
                local v70 = v69:Clone();
                v70.Name = "Part";
                v70.Anchored = false;
                v70.Massless = true;
                v70.CanCollide = false;
                v70.CanTouch = false;
                v70.CanQuery = false;
                v70.AudioCanCollide = false;
                local v71 = Instance.new("Weld");
                v71.Part0 = l__Hitbox__11;
                v71.Part1 = v70;
                v71.C0 = l__VehicleOrigin__8:ToObjectSpace(v70.CFrame);
                v71.Parent = v70;
                v70.TextureID = l__VehicleModule__9.Model.Wheels[l__Name__16][v69.Name].Camo;
                v70.Parent = l__Model__10;
                local v72 = v70.Size.Y / 2;
                local l__X__17 = v70.Size.X;
                local v73 = CFrame.new(v71.C0.X, v59 + v72, v71.C0.Z);
                local l__Rotation__18 = v71.C0.Rotation;
                local v74 = math.abs(v73.Y - v71.C0.Y);
                local v75 = string.format("%s%.1f%.1f", l__Name__16, v73.X, v73.Z);
                v70:SetAttribute("Component", v75);
                v68[v75] = {
                    Name = v75,
                    Sort = l__Name__16,
                    Wheel = v70,
                    Weld = v71,
                    Radius = v72,
                    Width = l__X__17,
                    RideHeight = v74,
                    OrientationOffset = l__Rotation__18,
                    BottomedOutOffset = v73
                };
            end;
        end;
        v38.Wheels = v66;
    end;
    return v38;
end;
function u10.State(u76, p77, p78) --[[ Line: 376 ]]
    -- upvalues: u3 (copy), u8 (copy)
    if p77 == "Engine" then
        if u76.EngineOn == p78 then
            return;
        end;
        u76.EngineLast = tick();
        u76.EngineOn = p78;
        if p78 then
            u76._idleSounds = {
                Interior = {},
                Exterior = {}
            };
            if u3:Get("Sound", "VehicleSound", "Helicopter", u76._vehicleName, "Ext", "Startup").ID == 0 then
                u76:_generateIdleSounds();
            else
                local v79 = u8:CreateSound("Helicopter", u76.Hitbox, true, "VehicleSound", "Helicopter", u76._vehicleName, "Ext", "Startup");
                local v80 = u8:CreateSound("Helicopter", nil, true, "VehicleSound", "Helicopter", u76._vehicleName, "Int", "Startup");
                v80.Sound.Volume = 0;
                u3:Get("Sound", "VehicleSound", "Helicopter", u76._vehicleName, "Ext", "Idle"):Preload();
                u3:Get("Sound", "VehicleSound", "Helicopter", u76._vehicleName, "Int", "Idle"):Preload();
                if u76._intSound then
                    u76._intSound.Destroy();
                end;
                u76._intSound = v80;
                u76._extSound = v79;
                u76._soundEnded = v79.Sound.Ended:Connect(function() --[[ Line: 407 ]]
                    -- upvalues: u76 (copy)
                    u76._soundEnded:Disconnect();
                    u76._soundEnded = nil;
                    u76:_generateIdleSounds();
                    if u76._intSound then
                        u76._intSound.Destroy();
                        u76._intSound = nil;
                    end;
                    if u76._extSound then
                        u76._extSound.Destroy();
                        u76._extSound = nil;
                    end;
                end);
            end;
        end;
    else
        if p77 == "ParkingBrake" then
            u76.ParkingBrakeOn = p78;
            return;
        end;
        if p77 == "Rappels" then
            u76:_doRappels(p78);
            return;
        end;
        if p77 == "LightModes" then
            u76:_updateLightModes(p78);
            return;
        end;
        u76:_state(p77, p78);
    end;
end;
function u10.Update(p81, p82) --[[ Line: 434 ]]
    -- upvalues: u5 (copy), l__CurrentCamera__2 (copy), u8 (copy), u7 (copy), u9 (copy)
    local v83 = p81.Controlling and 1 or p82 * 5;
    local v84 = p81.CFrame:Lerp(p81._targetCFrame, v83);
    local l__CFrame__19 = p81.CFrame;
    p81.CFrame = v84;
    u5.ApplyEffects(p81, p81.ComponentReplicates, v83, nil, p82);
    p81._derivedVelocity = (p81.CFrame.Position - l__CFrame__19.Position) / p82;
    local v85 = l__CFrame__19.Rotation:ToObjectSpace(p81.CFrame.Rotation);
    p81._derivedAngularVelocity = Vector3.new(v85:ToOrientation()) / p82;
    local l__Magnitude__20 = (l__CurrentCamera__2.CFrame.Position - v84.Position).Magnitude;
    local v86 = math.max(0, l__Magnitude__20 - 25) / 1475;
    for _, v87 in p81._dopplers do
        v87((math.clamp(v86, 0, 1)));
    end;
    local v88 = false;
    for _, v89 in p81.Rotors do
        if v89.Fried then
            v88 = true;
            break;
        end;
    end;
    if p81.Alive and (p81.Values and (p81.Values.LOCKED_ON and p81.Values.LOCKED_ON > 0)) then
        if not p81._lockedOnSound then
            p81._lockedOnSound = u8:CreateSound("Ground", p81.Hitbox, true, "VehicleSFX", "Flares", "LockOn");
        end;
    elseif p81._lockedOnSound then
        p81._lockedOnSound.Destroy();
        p81._lockedOnSound = nil;
    end;
    local v90 = p81.Inside and 0 or 1;
    if p81.EngineOn and (p81.Alive and not v88) then
        if p81._idleSounds then
            for _, v91 in p81._idleSounds.Exterior do
                v91.Sound.Volume = v90 * v91.Volume;
            end;
            for _, v92 in p81._idleSounds.Interior do
                v92.Sound.Volume = (1 - v90) * v92.Volume;
            end;
        else
            p81:_generateIdleSounds();
        end;
    elseif p81._idleSounds then
        if p81.Alive then
            local v93 = u8:CreateSound("Helicopter", p81.Hitbox, true, "VehicleSound", "Helicopter", p81._vehicleName, "Ext", "Shutdown");
            local v94 = u8:CreateSound("Helicopter", nil, true, "VehicleSound", "Helicopter", p81._vehicleName, "Int", "Shutdown");
            v94.Sound.Volume = 0;
            if p81._soundEnded then
                p81._soundEnded:Disconnect();
                p81._soundEnded = nil;
            end;
            if p81._intSound then
                p81._intSound.Destroy();
            end;
            if p81._extSound then
                p81._extSound.Destroy();
            end;
            p81._intSound = v94;
            p81._extSound = v93;
            v93.Destroy(70);
            v94.Destroy(70);
        end;
        for _, v95 in p81._idleSounds do
            for _, v96 in v95 do
                v96.Destroy();
            end;
        end;
        p81._idleSounds = nil;
    end;
    if p81._intSound then
        p81._intSound.Sound.Volume = (1 - v90) * p81._intSound.Volume;
    end;
    if p81._extSound then
        p81._extSound.Sound.Volume = v90 * p81._extSound.Volume;
    end;
    p81:_update(l__Magnitude__20, p82);
    if p81.Rappels then
        for _, v97 in p81.Rappels do
            v97:Update(p82);
        end;
    end;
    if not p81._lodActive then
        local v98 = math.lerp(p81._steering, p81.Steering, v83);
        local v99 = math.lerp(p81._throttle, p81.Throttle, v83);
        if p81.JoySticks then
            for _, v100 in p81.JoySticks do
                v100.Weld.C1 = v100.Pivot * CFrame.Angles(math.rad(v99 * 20), 0, (math.rad(-v98 * 25)));
            end;
        end;
        p81._steering = v98;
        p81._throttle = v99;
    end;
    local v101 = tick();
    local v102 = l__Magnitude__20 < 450;
    if not v102 and v101 - p81._lastBladeUpdate > 1 then
        p81._lastBladeUpdate = v101;
        v102 = true;
    end;
    if v102 then
        local l__Tune__21 = p81.VehicleModule.Tune;
        local v103 = l__Tune__21.IdleVelocity or 30;
        local v104 = l__Tune__21.BladeAngle or { -2, 0 };
        for v105, v106 in p81.Rotors do
            local v107 = not (p81.ComponentReplicates and (p81.ComponentReplicates.Rotors and p81.ComponentReplicates.Rotors[v105])) and 0 or math.abs(p81.ComponentReplicates.Rotors[v105][2]);
            if v106.Blur then
                if v106.Disconnected then
                    v106.Blur.Transparency = 1;
                    local _ = v106.BladeActual;
                else
                    local v108 = math.max(0, v107 - 10) / (v103 - 10);
                    math.clamp(v108, 0, 1);
                    local l__Blur__22 = v106.Blur;
                    local v109 = math.max(0, v107 - 10) / (v103 - 10);
                    l__Blur__22.Transparency = 0.99 - math.clamp(v109, 0, 1) * 0.8;
                    local _ = v106.BladeActual;
                end;
            end;
            if v106.Fried or v106.Disconnected then
                if v106.Bones then
                    if v106.Disconnected then
                        for _, v110 in v106.Bones do
                            if v110[1][4] then
                                v110[1][4].Rate = 0;
                            end;
                        end;
                    else
                        local v111 = math.clamp(v107 / 10, 0, 1);
                        for v112, v113 in v106.Bones do
                            if v111 > 0.1 then
                                local v114 = v113[#v113][3];
                                local v115 = (tick() + 3.141592653589793 * v112) * 5;
                                local v116 = math.sin(v115) * 5 * (v111 + 0.2);
                                for _, v117 in v113 do
                                    local v118 = v117[1];
                                    local v119 = v117[2];
                                    local l__Angles__23 = CFrame.Angles;
                                    local v120 = math.rad(v116);
                                    v118.CFrame = v119 * l__Angles__23(0, 0, (math.lerp(v120, 0, v117[3] / v114)));
                                end;
                            end;
                            if v113[1][4] then
                                v113[1][4].Rate = v111 > 0.2 and (v111 * 10 or 0) or 0;
                            end;
                        end;
                    end;
                end;
            elseif v106.Bones then
                local v121 = math.lerp(v104[1], v104[2], v107 / v103);
                for _, v122 in v106.Bones do
                    local v123 = v122[#v122][3];
                    for _, v124 in v122 do
                        local v125 = v124[1];
                        local v126 = v124[2];
                        local l__Angles__24 = CFrame.Angles;
                        local v127 = math.rad(v121);
                        v125.CFrame = v126 * l__Angles__24(0, 0, (math.lerp(v127, 0, v124[3] / v123)));
                    end;
                end;
            end;
        end;
    end;
    if l__Magnitude__20 < 2000 then
        local v128 = false;
        for _, v129 in u7.World.RestrictedAirspace do
            if (v129[1] - v84.Position).Magnitude < v129[2] then
                v128 = true;
                break;
            end;
        end;
        if v128 ~= p81.InRestrictedAirspace then
            p81.InRestrictedAirspace = v128;
            p81:_updateLightModes();
        end;
        for v130, v131 in p81._lightActive do
            local v132;
            if v131.Mode == 2 then
                v132 = u9.Viewmodel;
                if v132 then
                    v132 = u9.Viewmodel.NVG;
                end;
            else
                v132 = true;
            end;
            if v132 and (v131.StrobeSpeed and (os.clock() - v130.Spawned) % v131.StrobeSpeed > (v131.StrobeBlink or 0.05)) then
                v132 = false;
            end;
            if v132 then
                v132 = v130.Modes[v131.Mode];
            end;
            p81:_updateLight(v130, v132);
        end;
    end;
    return v84, p81.Hitbox, p81._lightPayload;
end;
function u10.Lights(_) --[[ Line: 646 ]] end;
return u10;