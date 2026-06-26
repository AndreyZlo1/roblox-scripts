-- Services.VehicleService.GroundVehicle
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3 = shared.import("require", "asset", "Enum");
local u4 = v1("VehicleClass");
local u5 = v1("SoundService");
local u6 = v1("VehicleSolver");
v1("DebugService");
local u7 = v1("Mathf");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u8 = {};
u8.__index = u8;
setmetatable(u8, u4);
function u8._generateIdleSounds(p9) --[[ Line: 16 ]]
    -- upvalues: u5 (copy)
    p9._idleSounds = {
        Idle = {},
        Running = {}
    };
    for v10, v11 in p9.Engines do
        local v12 = u5:CreateSound("Ground", v11, true, "VehicleSound", "Ground", p9._engineSound, "Engine", v10, "Idle");
        local v13 = u5:CreateSound("Ground", v11, true, "VehicleSound", "Ground", p9._engineSound, "Engine", v10, "Running");
        v13.Sound.Volume = 0;
        p9._idleSounds.Idle[#p9._idleSounds.Idle + 1] = v12;
        p9._idleSounds.Running[#p9._idleSounds.Running + 1] = v13;
    end;
end;
function u8.new(p14, p15, p16) --[[ Line: 31 ]]
    -- upvalues: u4 (copy), u8 (copy), u2 (copy), u5 (copy)
    local u17 = u4.new(p14, p15, p16);
    setmetatable(u17, u8);
    u17._exhausts = {};
    u17.IsGroundVehicle = true;
    u17.Engines = {};
    u17.EngineLast = 0;
    u17.EngineOn = p16.EngineOn;
    u17.ParkingBrakeOn = p16.ParkingBrakeOn;
    u17.EngineHasBeenStarted = p16.EngineHasBeenStarted;
    u17.LightsOn = p16.LightsOn;
    u17.IndicatorMode = p16.IndicatorMode;
    u17._indicatorStart = 0;
    u17.Horn = false;
    u17.HornLerp = 0;
    local v18 = {
        F = {},
        R = {}
    };
    local l__VehicleModel__2 = u17.VehicleModel;
    local l__VehicleOrigin__3 = u17.VehicleOrigin;
    local l__VehicleCamo__4 = u17.VehicleCamo;
    local l__VehicleModule__5 = u17.VehicleModule;
    u17._engineSound = l__VehicleModule__5.Engine or "Default";
    local l__Model__6 = u17.Model;
    local l__Hitbox__7 = u17.Hitbox;
    local l__Wheels__8 = l__VehicleModule__5.Model.Wheels;
    if typeof(l__Wheels__8) ~= "string" then
        l__Wheels__8 = l__Wheels__8[l__VehicleCamo__4];
    end;
    local v19 = nil;
    local v20 = u17.VehicleModel:FindFirstChild("Collisions");
    local v21;
    if v20 then
        for _, v22 in v20:GetChildren() do
            local l__CFrame__9 = v22.CFrame;
            local v23 = v22.Size / 2;
            local v24 = l__CFrame__9.RightVector * -math.sign(l__CFrame__9.RightVector.Y) * v23.X;
            local v25 = l__CFrame__9.UpVector * -math.sign(l__CFrame__9.UpVector.Y) * v23.Y;
            local v26 = l__CFrame__9.LookVector * -math.sign(l__CFrame__9.LookVector.Y) * v23.Z;
            local l__Position__10 = (l__CFrame__9 + v24 + v25 + v26).Position;
            if not v19 or l__Position__10.Y < v19 then
                v19 = l__Position__10.Y;
            end;
        end;
        v21 = v19 - u17.VehicleMain.Position.Y;
    else
        v21 = -u17.VehicleMain.Size.Y / 2;
    end;
    for _, v27 in l__VehicleModel__2:WaitForChild("Wheels"):GetChildren() do
        local l__Name__11 = v27.Name;
        local v28 = v18[l__Name__11];
        for _, v29 in v27:GetChildren() do
            local v30 = v29:Clone();
            v30.Name = "Part";
            v30.Anchored = false;
            v30.Massless = true;
            v30.CanCollide = false;
            v30.CanTouch = false;
            v30.CanQuery = false;
            v30.AudioCanCollide = false;
            local v31 = Instance.new("Weld");
            v31.Part0 = l__Hitbox__7;
            v31.Part1 = v30;
            v31.C0 = l__VehicleOrigin__3:ToObjectSpace(v30.CFrame);
            v31.Parent = v30;
            v30.TextureID = l__Wheels__8;
            v30.Parent = l__Model__6;
            local v32 = v30.Size.Y / 2;
            local l__X__12 = v30.Size.X;
            local v33 = CFrame.new(v31.C0.X, v21 + v32, v31.C0.Z);
            local l__Rotation__13 = v31.C0.Rotation;
            local v34 = math.abs(v33.Y - v31.C0.Y);
            local v35 = string.format("%s%.1f%.1f", l__Name__11, v33.X, v33.Z);
            v30:SetAttribute("Component", v35);
            v28[v35] = {
                Name = v35,
                Sort = l__Name__11,
                Wheel = v30,
                Weld = v31,
                Radius = v32,
                Width = l__X__12,
                RideHeight = v34,
                OrientationOffset = l__Rotation__13,
                BottomedOutOffset = v33
            };
        end;
    end;
    if p16.Seats then
        local u36 = nil;
        for _, v37 in l__VehicleModel__2:WaitForChild("Engines"):GetChildren() do
            local v38 = v37:Clone();
            local l__Name__14 = v38.Name;
            v38.Name = "Part";
            v38.Anchored = false;
            v38.Massless = true;
            v38.CanCollide = false;
            v38.CanTouch = false;
            v38.CanQuery = false;
            v38.AudioCanCollide = false;
            if l__Name__14 == "Front" then
                u36 = v38;
            elseif l__Name__14 == "Exhaust" then
                local v39 = u2:Get("Shared", "Particles", "Vehicles", "Ground", "ColdStart").Asset:Clone();
                v39.Parent = v38;
                u17._exhausts[#u17._exhausts + 1] = v39;
            end;
            local v40 = Instance.new("Weld");
            v40.Part0 = l__Hitbox__7;
            v40.Part1 = v38;
            v40.C0 = l__VehicleOrigin__3:ToObjectSpace(v38.CFrame);
            v40.Parent = v38;
            v38.Parent = l__Model__6;
            u17.Engines[l__Name__14] = v38;
        end;
        if u36 then
            task.defer(function() --[[ Line: 173 ]]
                -- upvalues: u17 (copy), u5 (ref), u36 (ref)
                u17._hornBody = u5:CreateSound("Ground", u36, false, "VehicleSound", "Ground", u17._engineSound, "Horn", "Body").Sound;
                u17._hornEnd = u5:CreateSound("Ground", u36, false, "VehicleSound", "Ground", u17._engineSound, "Horn", "End").Sound;
            end);
        end;
    end;
    u17.Wheels = v18;
    return u17;
end;
function u8.SetRPM(p41, p42) --[[ Line: 184 ]]
    local v43 = math.clamp((p42 - 0.3) / 0.7, 0, 1);
    local l___idleSounds__15 = p41._idleSounds;
    if l___idleSounds__15 then
        for _, v44 in l___idleSounds__15.Running do
            v44.Sound.Volume = v43;
            v44.Sound.PlaybackSpeed = v43 / 2 + 0.5;
        end;
        for _, v45 in l___idleSounds__15.Idle do
            v45.Sound.Volume = 1 - v43;
            v45.Sound.PlaybackSpeed = v43 / 2 + 1;
        end;
    end;
end;
function u8.State(u46, p47, p48) --[[ Line: 199 ]]
    -- upvalues: u5 (copy), u2 (copy)
    if p47 == "Engine" then
        if u46.EngineOn == p48 then
            return;
        end;
        u46.EngineLast = tick();
        u46.EngineHasBeenStarted = true;
        u46.EngineOn = p48;
        if p48 then
            u46._idleSounds = {
                Idle = {},
                Running = {}
            };
            task.delay(0.5, function() --[[ Line: 214 ]]
                -- upvalues: u46 (copy)
                u46:_generateIdleSounds();
            end);
            for v49, v50 in u46.Engines do
                u5:CreateSound("Ground", v50, true, "VehicleSound", "Ground", u46._engineSound, "Engine", v49, "Startup").Destroy(5);
            end;
        else
            for v51, v52 in u46.Engines do
                u5:CreateSound("Ground", v52, true, "VehicleSound", "Ground", u46._engineSound, "Engine", v51, "Shutdown").Destroy(5);
            end;
        end;
        local l__Occupant__16 = u46.Seats[u46.DriverSeat].Occupant;
        if l__Occupant__16 then
            local v53 = l__Occupant__16:LoadAnimation(u2:Get("Animation", "VehicleAnimation", "Ground", "Humvee", "Startup").ID);
            l__Occupant__16.IgnoreIK = v53;
            v53:Play(0);
        end;
    else
        if p47 == "Lights" then
            u46.LightsOn = p48;
            return;
        end;
        if p47 == "Indicators" then
            u46.IndicatorMode = p48;
            u46._indicatorStart = tick();
            return;
        end;
        if p47 == "Horn" then
            u46.Horn = p48;
            if p48 then
                u46._hornBegin = tick();
            end;
        else
            if p47 == "ParkingBrake" then
                u46.ParkingBrakeOn = p48;
                return;
            end;
            u46:_state(p47, p48);
        end;
    end;
end;
function u8.Update(p54, p55) --[[ Line: 253 ]]
    -- upvalues: u7 (copy), u6 (copy), l__CurrentCamera__1 (copy), u3 (copy)
    local v56 = p54.Controlling and 1 or p55 * 5;
    local v57 = p54.CFrame:Lerp(p54._targetCFrame, v56);
    local l__CFrame__17 = p54.CFrame;
    p54.CFrame = v57;
    local v58 = u7.Lerp(p54._steering, p54.Steering, v56);
    p54.SteeringWheel.Weld.C1 = p54.SteeringWheel.Turn.CFrame * CFrame.Angles(0, 0, (math.rad(-v58 * 160)));
    p54._steering = v58;
    u6.ApplyEffects(p54, p54.ComponentReplicates, v56, nil, p55);
    p54._derivedVelocity = (p54.CFrame.Position - l__CFrame__17.Position) / p55;
    local v59 = l__CFrame__17.Rotation:ToObjectSpace(p54.CFrame.Rotation);
    p54._derivedAngularVelocity = Vector3.new(v59:ToOrientation()) / p55;
    local l__Magnitude__18 = (l__CurrentCamera__1.CFrame.Position - v57.Position).Magnitude;
    local l__LightsOn__19 = p54.LightsOn;
    local l___lights__20 = p54._lights;
    local v60 = u3.Material[l__LightsOn__19 and "Neon" or "Plastic"];
    local v61 = {};
    for v62, v63 in l___lights__20.Front.Attachments do
        if l__LightsOn__19 then
            v61[v62] = v63;
        end;
        v63.Light.Enabled = l__LightsOn__19;
    end;
    if l___lights__20.Front.Part then
        l___lights__20.Front.Part.Material = v60;
    end;
    for v64, v65 in l___lights__20.Rear.Attachments do
        if l__LightsOn__19 then
            v61[v64] = v65;
        end;
        v65.Light.Enabled = l__LightsOn__19;
    end;
    if l___lights__20.Rear.Part then
        l___lights__20.Rear.Part.Material = v60;
    end;
    for v66, v67 in l___lights__20.Operational.Attachments do
        if l__LightsOn__19 then
            v61[v66] = v67;
        end;
        v67.Light.Enabled = l__LightsOn__19;
    end;
    if l___lights__20.Operational.Part then
        l___lights__20.Operational.Part.Material = v60;
    end;
    local l__IndicatorMode__21 = p54.IndicatorMode;
    local v68;
    if l__IndicatorMode__21 >= 0 then
        local v69 = (tick() - p54._indicatorStart) * 7;
        v68 = math.sin(v69) > 0;
    else
        v68 = false;
    end;
    local v70;
    if l__IndicatorMode__21 == 1 or l__IndicatorMode__21 == 3 then
        v70 = v68;
    else
        v70 = false;
    end;
    for v71, v72 in l___lights__20.Indicator.Left.Attachments do
        if v70 then
            v61[v71] = v72;
        end;
        v72.Light.Enabled = v70;
    end;
    if l___lights__20.Indicator.Left.Part then
        l___lights__20.Indicator.Left.Part.Material = u3.Material[v70 and "Neon" or "Plastic"];
    end;
    if l__IndicatorMode__21 ~= 2 and l__IndicatorMode__21 ~= 3 then
        v68 = false;
    end;
    for v73, v74 in l___lights__20.Indicator.Right.Attachments do
        if v68 then
            v61[v73] = v74;
        end;
        v74.Light.Enabled = v68;
    end;
    if l___lights__20.Indicator.Right.Part then
        l___lights__20.Indicator.Right.Part.Material = u3.Material[v68 and "Neon" or "Plastic"];
    end;
    local l__Horn__22 = p54.Horn;
    if l__Horn__22 then
        l__Horn__22 = tick() - p54._hornBegin < 3;
    end;
    if p54._hornBody then
        if l__Horn__22 then
            if not p54._hornBody.IsPlaying then
                p54._hornBody:Play();
            end;
        elseif p54._hornBody.IsPlaying then
            p54._hornBody:Stop();
            p54._hornEnd:Play();
        end;
    end;
    p54.HornLerp = u7.Lerp(p54.HornLerp, l__Horn__22 and 1 or 0, p55 * 25);
    local v75 = tick() - p54.EngineLast;
    local l__EngineOn__23 = p54.EngineOn;
    if l__EngineOn__23 then
        if v75 > 0.5 then
            l__EngineOn__23 = v75 < 5;
        else
            l__EngineOn__23 = false;
        end;
    end;
    for _, v76 in p54._exhausts do
        v76.Enabled = l__EngineOn__23;
    end;
    if p54.EngineOn and p54.Alive then
        if not p54._idleSounds then
            p54:_generateIdleSounds();
        end;
    elseif p54._idleSounds then
        for _, v77 in p54._idleSounds do
            for _, v78 in v77 do
                v78.Destroy();
            end;
        end;
        p54._idleSounds = nil;
    end;
    local l__Speedo__24 = p54.Speedo;
    if l__Speedo__24 then
        local v79 = l__LightsOn__19 and Color3.fromRGB(255, 85, 0) or Color3.new(1, 1, 1);
        l__Speedo__24.Background.ImageColor3 = v79;
        l__Speedo__24.Needle.Visual.BackgroundColor3 = v79;
        l__Speedo__24.Gui.Brightness = 5;
        l__Speedo__24.Gui.LightInfluence = l__LightsOn__19 and 0.5 or 1;
    end;
    p54:_update(l__Magnitude__18, p55);
    return v57, p54.Hitbox, v61;
end;
return u8;