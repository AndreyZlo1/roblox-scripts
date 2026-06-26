-- Services.VehicleService.VehicleClass
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4, u5, _ = shared.import("require", "Enum", "asset", "network", "server", "frc");
local u6 = v1("ChunkService");
local u7 = v1("BulletService");
v1("DebugService");
local u8 = v1("ReplicatorService", true);
local u9 = v1("SoundService");
local u10 = v1("EffectsService");
local u11 = v1("POI");
local u12 = v1("Vehicle");
local u13 = v1("MFDClass");
local u14 = v1("ChainClass");
local l__Debris__1 = game:GetService("Debris");
local l__TweenService__2 = game:GetService("TweenService");
local l__ReplicatedStorage__3 = game:GetService("ReplicatedStorage");
local u15 = v1("GameSettings");
local l__UserGameSettings__4 = UserSettings():GetService("UserGameSettings");
local l__Hull__5 = l__ReplicatedStorage__3:WaitForChild("Assets"):WaitForChild("Particles"):WaitForChild("Vehicles"):WaitForChild("Hull");
local u16 = {
    [u2.VehicleType.Ground] = "Ground",
    [u2.VehicleType.Helicopter] = "Helicopter"
};
local u17 = { 128, 256, 512 };
local u18 = {};
u18.__index = u18;
local function u24(p19, p20, p21) --[[ Line: 47 ]]
    p19.Part = p20;
    for _, v22 in p20:GetChildren() do
        local v23 = Instance.new("SpotLight");
        v23.Angle = p21.Angle;
        v23.Brightness = p21.Brightness;
        v23.Color = p21.Color;
        v23.Range = p21.Range;
        v23.Face = p21.Face;
        v23.Enabled = false;
        v23.Parent = v22;
        p19.Attachments[v22] = {
            Light = v23,
            Color = p21.Color,
            Intensity = p21.Intensity,
            Style = p21.Style
        };
    end;
end;
function u18._cleanUp(p25) --[[ Line: 68 ]]
    if p25._soundEnded then
        p25._soundEnded:Disconnect();
    end;
    if p25._idleSounds then
        for _, v26 in p25._idleSounds do
            for _, v27 in v26 do
                v27.Destroy();
            end;
        end;
    end;
    if p25._extSound then
        p25._extSound.Destroy();
    end;
    if p25._intSound then
        p25._intSound.Destroy();
    end;
    if p25._hornBody then
        p25._hornBody:Destroy();
    end;
    if p25._hornEnd then
        p25._hornEnd:Destroy();
    end;
    if p25._lockedOnSound then
        p25._lockedOnSound.Destroy();
    end;
    if p25.Rotors then
        for _, v28 in p25.Rotors do
            if v28.GroundSmoke then
                v28.GroundSmoke.Attachment:Destroy();
                v28.GroundSmoke = nil;
            end;
        end;
    end;
end;
function u18._state(p29, p30, p31) --[[ Line: 104 ]]
    if p30 == "TurretDoor" then
        local v32 = p29.TurretDoors[p31.Name];
        if v32.IsOpen == p31.IsOpen then
        else
            local v33 = v32.Start + v32.Timer - tick();
            local v34 = math.clamp(v33, 0, v32.Timer);
            v32.IsOpen = p31.IsOpen;
            v32.Start = tick() - v34;
            v32.End = tick() + v32.Timer - v34;
        end;
    elseif p30 == "TurretAccess" then
        p29.TurretAccess = p31;
    else
        if p30 == "NoCollide" then
            for _, v35 in p29._hitbox do
                v35.CanCollide = not p31;
                v35.CanTouch = not p31;
                v35.CanQuery = not p31;
            end;
        end;
    end;
end;
function u18._update(p36, p37, p38) --[[ Line: 126 ]]
    -- upvalues: l__TweenService__2 (copy), u2 (copy), u15 (copy), l__UserGameSettings__4 (copy), u17 (copy)
    local v39 = tick();
    local v40 = 0;
    for _, v41 in p36.Doors do
        local l__CurrentAngle__6 = v41.CurrentAngle;
        if v41.LastUsed then
            local v42 = (v39 - v41.LastUsed) / 0.3;
            if v42 > 1 then
                v41.LastUsed = nil;
                v42 = 1;
            end;
            l__CurrentAngle__6 = math.lerp(v41.From, v41.Open and (v41.TargetAngle or 0) or 0, l__TweenService__2:GetValue(v42, u2.EasingStyle.Sine, u2.EasingDirection.InOut));
        end;
        v40 = math.max(v40, l__CurrentAngle__6 / v41.TargetAngle);
        if v41.CurrentAngle ~= l__CurrentAngle__6 then
            local v43 = v41.C0 * CFrame.Angles(0, math.rad(l__CurrentAngle__6), 0);
            v41.CurrentAngle = l__CurrentAngle__6;
            for _, v44 in v41.Welds do
                v44.C0 = v43;
            end;
        end;
    end;
    p36.DoorOpen = v40;
    for v45, v46 in p36.Turrets do
        local l__Facing__7 = v46.Facing;
        local l__Current__8 = v46.Current;
        local l__X__9 = l__Current__8.X;
        local l__X__10 = l__Facing__7.X;
        local v47 = math.sin(l__X__10 - l__X__9);
        local v48 = math.cos(l__X__9 - l__X__10);
        local v49 = math.atan2(v47, v48);
        local v50 = math.abs(v49);
        if v50 > 0.001 then
            local v51;
            v51, l__X__9 = CFrame.Angles(0, l__X__9, 0):Lerp(CFrame.Angles(0, l__X__10, 0), (math.min(1, p38 / v50 * 1.5))):ToOrientation();
            _ = v51;
            v46.Lower.C0 = v46.LowerC0 * CFrame.Angles(0, l__X__9, 0);
        end;
        local l__Y__11 = l__Current__8.Y;
        local l__Y__12 = l__Facing__7.Y;
        local v52 = math.sin(l__Y__12 - l__Y__11);
        local v53 = math.cos(l__Y__11 - l__Y__12);
        local v54 = math.atan2(v52, v53);
        local v55 = math.abs(v54);
        if v55 > 0.001 and v46.Upper then
            local v56;
            v56, l__Y__11 = CFrame.Angles(0, l__Y__11, 0):Lerp(CFrame.Angles(0, l__Y__12, 0), (math.min(1, p38 / v55 * 1.5))):ToOrientation();
            _ = v56;
            v46.Upper.C0 = v46.UpperC0 * CFrame.Angles(l__Y__11, 0, 0);
        end;
        v46.Current = Vector2.new(l__X__9, l__Y__11);
        local v57 = p36.TurretDoors[v45];
        local v58;
        if v57 then
            local v59 = (tick() - v57.Start) / (v57.End - v57.Start);
            v58 = math.clamp(v59, 0, 1);
            if not v57.IsOpen then
                v58 = 1 - v58;
            end;
        else
            v58 = 0;
        end;
        for _, v60 in v46.Doors do
            v60.Weld.C0 = v60.Base:Lerp(v60.Base * v60.Goal or v60.Base, v58);
        end;
    end;
    local l__RenderDistance__13 = u15.RenderDistance;
    local v61;
    if l__RenderDistance__13 == 1 then
        local l__Value__14 = l__UserGameSettings__4.SavedQualityLevel.Value;
        v61 = l__Value__14 == 10 and 3 or (l__Value__14 >= 8 and 2 or 1);
    else
        v61 = l__RenderDistance__13 == 4 and 3 or (l__RenderDistance__13 == 3 and 2 or 1);
    end;
    if u17[v61] < p37 then
        if not p36._lodActive then
            p36._lodActive = true;
            for _, v62 in p36._windows do
                v62.Transparency = 0;
            end;
            for _, v63 in p36._interior do
                v63.Parent = nil;
            end;
        end;
    elseif p36._lodActive then
        p36._lodActive = false;
        for _, v64 in p36._windows do
            v64.Transparency = p36.VehicleTint;
        end;
        for _, v65 in p36._interior do
            v65.Parent = p36.Model;
        end;
    end;
    if not p36._lodActive and p37 < 50 then
        if p36.VehicleModule.Warnings then
            local l__Warnings__15 = p36.Warnings;
            for v66, v67 in p36.VehicleModule.Warnings do
                local v68 = false;
                local v69;
                if typeof(v67) == "string" then
                    local l__Cont__16 = p36.VehicleModule.Values[v67].Cont;
                    local v70 = p36.Values[v67];
                    if typeof(l__Cont__16) == "number" then
                        v69 = l__Cont__16 <= v70 and true or v68;
                    else
                        v69 = (l__Cont__16[2] <= v70 or v70 <= l__Cont__16[1]) and true or v68;
                    end;
                else
                    v69 = v67(p36) and true or v68;
                end;
                l__Warnings__15[v66] = v69;
            end;
        end;
        for _, v71 in p36.MFDS do
            v71:Update(p38);
        end;
    end;
end;
function u18.new(p72, p73, p74) --[[ Line: 249 ]]
    -- upvalues: u16 (copy), u3 (copy), u12 (copy), u2 (copy), u18 (copy), u11 (copy), u6 (copy)
    local v75 = u16[p74.Type];
    local l__Asset__17 = u3:Get("Shared", "Models", "Vehicle", v75, p74.Name).Asset;
    local v76 = u12[v75][p74.Name];
    local l__Default__18 = v76.Default;
    local l__Body__19 = l__Asset__17:WaitForChild("Body");
    local l__Main__20 = l__Body__19:WaitForChild("Main");
    local l__CFrame__21 = l__Main__20.CFrame;
    local v77 = Instance.new("Model");
    local v78 = l__Main__20:Clone();
    local l__CFrame__22 = v78:WaitForChild("Camera").CFrame;
    for _, v79 in v78:GetChildren() do
        if v79.Name:sub(1, 6) ~= "Rappel" and v79.Name:sub(1, 5) ~= "Flare" then
            v79:Destroy();
        end;
    end;
    v78.Parent = v77;
    local v80 = u2.PhysicsGroup[v75 .. "Vehicle"];
    local v81 = {
        Alive = true,
        Owner = p73,
        UID = p72,
        Healths = p74.Healths,
        KilledComponents = {},
        Model = v77,
        CFrame = p74.CFrame,
        Hitbox = v78,
        Doors = {},
        Turrets = {},
        Values = {},
        Warnings = {},
        Buttons = {},
        Seats = {},
        Steering = 0,
        Throttle = 0,
        ComponentReplicates = nil,
        ComponentReplicatesLastReplicated = nil,
        ComponentReplicatesLastSentTime = 0,
        ComponentLastAppliedEffects = nil,
        _derivedVelocity = Vector3.new(0, 0, 0),
        _derivedAngularVelocity = Vector3.new(0, 0, 0),
        CameraOffset = l__CFrame__22,
        VehicleModule = v76,
        VehicleModuleModel = v76.Model,
        VehicleOrigin = l__CFrame__21,
        VehicleModel = l__Asset__17,
        VehicleBody = l__Body__19,
        VehicleMain = l__Main__20,
        VehicleTurrets = p74.Modifications.Turrets,
        VehicleTurret = l__Default__18.Turrets,
        VehicleArmor = p74.Modifications.Armor or l__Default__18.Armor,
        VehicleCamo = p74.Modifications.Camo or l__Default__18.Camo,
        VehicleTint = 0.8,
        VehicleType = v75,
        TurretAccess = p74.TurretAccess,
        _throttle = 0,
        _steering = 0,
        Spawned = tick(),
        _sounds = {},
        _interior = {},
        _windows = {},
        _parts = {},
        _hitbox = {},
        MFDS = {},
        _mfdsToInit = {},
        _vehicleName = p74.Name,
        _physicsGroup = v80,
        _targetCFrame = p74.CFrame
    };
    local v82 = setmetatable(v81, u18);
    if v76.Values then
        for v83, v84 in v76.Values do
            v82.Values[v83] = v84.Normal[1];
        end;
    end;
    local l__Steal__23 = p74.Steal;
    if p74.Seats then
        for v85, v86 in p74.Seats do
            local v87 = Instance.new("Attachment");
            v87.CFrame = v86.Offset;
            v87.Parent = v78;
            local v88 = Instance.new("Attachment");
            v88.CFrame = v86.Prompt;
            v88.Parent = v87;
            local v89 = Instance.new("ProximityPrompt");
            v89.Name = v86.UID;
            v89.ActionText = v86.Action;
            v89.ObjectText = v86.Driver and "rbxassetid://15216812708" or "rbxassetid://15216793106";
            v89.ClickablePrompt = false;
            v89.Style = u2.ProximityPromptStyle.Custom;
            v89.Exclusivity = u2.ProximityPromptExclusivity.OneGlobally;
            v89.MaxActivationDistance = 6;
            v89.RequiresLineOfSight = false;
            v89.GamepadKeyCode = u2.KeyCode.World0;
            v89.KeyboardKeyCode = u2.KeyCode.World0;
            v89.Parent = v88;
            if v86.Animation then
                u3:Get("Animation", "VehicleSeat", v86.Animation, "Enter"):Preload();
                u3:Get("Sound", "VehicleSeat", v86.Animation, "Enter"):Preload();
            end;
            if v86.Driver then
                v82.DriverSeat = v85;
                if l__Steal__23 then
                    v82._stealAttchment = v87;
                    u11[v87] = {
                        Title = "Steal Vehicle",
                        Range = 250
                    };
                end;
            end;
            v82.Seats[v85] = {
                Prompt = v89,
                Exterior = v86.Exterior,
                Attachment = v87
            };
        end;
        local l__Size__24 = v78.Size;
        u6:RegisterBlock(v82, math.max(l__Size__24.X, l__Size__24.Y, l__Size__24.Z) / 2);
    end;
    if p74.Inventories then
        for _, v90 in p74.Inventories do
            local v91 = Instance.new("Attachment");
            v91.CFrame = v90.Offset;
            v91.Parent = v78;
            local v92 = Instance.new("ProximityPrompt");
            v92.Name = v90.UID;
            v92.ActionText = v90.Action;
            v92.ClickablePrompt = false;
            v92.Style = u2.ProximityPromptStyle.Custom;
            v92.Exclusivity = u2.ProximityPromptExclusivity.OneGlobally;
            v92.MaxActivationDistance = 6;
            v92.RequiresLineOfSight = false;
            v92.GamepadKeyCode = u2.KeyCode.World0;
            v92.KeyboardKeyCode = u2.KeyCode.World0;
            v92.Parent = v91;
        end;
    end;
    local v93 = {};
    if p74.TurretDoors then
        for v94, v95 in p74.TurretDoors do
            local v96, v97;
            if v95.UID then
                v96 = Instance.new("Attachment");
                local v98 = Instance.new("ProximityPrompt");
                v98.Name = v95.UID;
                v98.ActionText = "Use Door";
                v98.ClickablePrompt = false;
                v98.Style = u2.ProximityPromptStyle.Custom;
                v98.Exclusivity = u2.ProximityPromptExclusivity.OneGlobally;
                v98.MaxActivationDistance = 6;
                v98.RequiresLineOfSight = false;
                v98.GamepadKeyCode = u2.KeyCode.World0;
                v98.KeyboardKeyCode = u2.KeyCode.World0;
                v98.Parent = v96;
                v97 = v95.CFrame;
            else
                v96 = nil;
                v97 = nil;
            end;
            v93[v94] = {
                Timer = v95.Timer,
                IsOpen = v95.IsOpen,
                Start = tick() - 1,
                End = tick(),
                Name = v95.Name,
                Part = v95.Part,
                Attachment = v96,
                CFrame = v97
            };
        end;
    end;
    v82.TurretDoors = v93;
    local v99, v100 = pcall(v82.RegenerateModel, v82);
    if not v99 then
        print("Failed " .. p74.Name .. " : MODEL GENERATION");
        warn(v100);
    end;
    local v101, v102 = pcall(v82.RegenerateHitbox, v82);
    if not v101 then
        print("Failed " .. p74.Name .. " : HITBOX GENERATION");
        warn(v102);
    end;
    v78.Anchored = true;
    v78.CFrame = p74.CFrame;
    return v82;
end;
function u18.ChangeCamo(p103, p104) --[[ Line: 460 ]]
    p103.VehicleCamo = p104;
end;
function u18.ChangeArmor(p105, p106) --[[ Line: 464 ]]
    p105.VehicleArmor = p106;
    p105:ChangeTurret();
end;
function u18.ChangeTurret(p107, p108, p109) --[[ Line: 469 ]]
    local v110 = {};
    local l__VehicleArmor__25 = p107.VehicleArmor;
    if p107.VehicleTurrets then
        for v111, v112 in p107.VehicleTurrets do
            if table.find(p107.VehicleModule.Turrets[v111][v112].Whitelist, l__VehicleArmor__25) then
                v110[v111] = v112;
            else
                v110[v111] = p107.VehicleTurret[v111][v112];
            end;
        end;
    end;
    if p108 then
        v110[p108] = p109;
    end;
    p107.VehicleTurrets = v110;
end;
function u18.RegenerateModel(u113) --[[ Line: 489 ]]
    -- upvalues: u2 (copy), u24 (copy), u14 (copy)
    if u113.Turrets then
        for _, v114 in u113.Turrets do
            if v114.Chain then
                v114.Chain:Destroy();
            end;
        end;
        u113.Turrets = nil;
    end;
    for _, v115 in u113._parts do
        v115:Destroy();
    end;
    u113._parts = {};
    u113._interior = {};
    u113._windows = {};
    u113._lights = {
        Front = {
            Attachments = {}
        },
        Rear = {
            Attachments = {}
        },
        Operational = {
            Attachments = {}
        },
        Indicator = {
            Left = {
                Attachments = {}
            },
            Right = {
                Attachments = {}
            }
        }
    };
    u113._lightModes = {};
    local l__Model__26 = u113.Model;
    local l__Hitbox__27 = u113.Hitbox;
    local l__VehicleModule__28 = u113.VehicleModule;
    local l__VehicleModuleModel__29 = u113.VehicleModuleModel;
    local l__VehicleArmor__30 = u113.VehicleArmor;
    local l__VehicleCamo__31 = u113.VehicleCamo;
    local l__VehicleTint__32 = u113.VehicleTint;
    local l__VehicleTurrets__33 = u113.VehicleTurrets;
    local l__VehicleTurret__34 = u113.VehicleTurret;
    local l__VehicleMain__35 = u113.VehicleMain;
    local l__VehicleModel__36 = u113.VehicleModel;
    local l__VehicleBody__37 = u113.VehicleBody;
    local l__VehicleOrigin__38 = u113.VehicleOrigin;
    local l___physicsGroup__39 = u113._physicsGroup;
    local u116 = {};
    for v117, v118 in l__VehicleModule__28.LightModes or {} do
        u116[v118[1]] = v117;
    end;
    local u119 = os.clock();
    local function u131(p120, p121) --[[ Line: 552 ]]
        -- upvalues: u116 (copy), u113 (copy), u119 (copy)
        local l__Light__40 = p121.Light;
        if l__Light__40 then
            for v122, v123 in l__Light__40 do
                local v124 = v122 == "Default";
                local v125 = v124 and p120 and p120 or p120:FindFirstChild(v122);
                if v125 then
                    for v126, v127 in v123 do
                        local v128 = u116[v126];
                        local v129 = u113._lightModes[v128];
                        if not v129 then
                            v129 = {};
                            u113._lightModes[v128] = v129;
                        end;
                        local v130 = {
                            Spawned = u119,
                            Modes = table.clone(v127)
                        };
                        if v124 then
                            v130.OriginalMaterial = v125.Material;
                            v130.OriginalTransparency = v125.Transparency;
                            v130.OriginalColor = v125.Color;
                        end;
                        v130.Origin = v125;
                        v129[#v129 + 1] = v130;
                    end;
                end;
            end;
        end;
    end;
    local u132 = {};
    local u133 = {};
    local u134 = {};
    local u135 = {};
    local u136 = {};
    local l___lights__41 = u113._lights;
    local function u155(p137, u138, p139) --[[ Line: 596 ]]
        -- upvalues: l___physicsGroup__39 (copy), u133 (copy), u132 (copy), u135 (copy), u2 (ref), l__VehicleTint__32 (copy), u134 (copy), u136 (copy), u113 (copy), l__VehicleCamo__31 (copy), u131 (copy)
        if not p139 then
            p137.Name = "Part";
        end;
        p137.Massless = true;
        p137.CanCollide = false;
        p137.CanTouch = false;
        p137.CanQuery = u138.Glass;
        p137.AudioCanCollide = u138.Glass;
        p137.CollisionGroup = l___physicsGroup__39;
        if u138.IsInterior then
            u133[#u133 + 1] = p137;
        end;
        if u138.Rappels then
            for v140 in u138.Rappels do
                u132[v140] = p137["Rappel_" .. v140];
            end;
        end;
        if u138.Flares then
            for v141, v142 in u138.Flares do
                u135[#u135 + 1] = {
                    Attachment = p137["Flare_" .. v141],
                    Data = v142
                };
            end;
        end;
        if u138.Glass then
            p137.Material = u2.Material.SmoothPlastic;
            p137.Color = Color3.new(0.2, 0.2, 0.2);
            p137.Transparency = l__VehicleTint__32;
            u134[#u134 + 1] = p137;
        end;
        if u138.MFD then
            local l__MFD__42 = p137:WaitForChild("MFD");
            l__MFD__42.Adornee = p137;
            l__MFD__42.MaxDistance = 50;
            l__MFD__42.PixelsPerStud = 1500;
            for v143, v144 in u138.MFD do
                local v145, v146;
                if typeof(v144) == "table" then
                    v145 = v144[1];
                    v146 = v144[2];
                else
                    v145 = v144;
                    v146 = nil;
                end;
                u136[v143] = {
                    Frame = l__MFD__42[v143],
                    Preset = v145,
                    DefaultPage = v146
                };
            end;
        end;
        if u138.Buttons then
            local function u154(p147, p148) --[[ Line: 656 ]]
                -- upvalues: u138 (copy), u113 (ref), u154 (copy)
                for _, v149 in p147:GetChildren() do
                    if v149:IsA("Attachment") then
                        local l__Name__43 = v149.Name;
                        local v150 = l__Name__43:sub(1, 7) == "Button_";
                        if #p148 ~= 0 or v150 then
                            local v151 = table.clone(p148);
                            if v150 then
                                l__Name__43 = l__Name__43:sub(8) or l__Name__43;
                            end;
                            v151[#v151 + 1] = l__Name__43;
                            local v152 = table.concat(v151, "_");
                            local v153 = u138.Buttons[v152];
                            if v153 then
                                u113.Buttons[v152] = {
                                    Attachment = v149,
                                    Seats = v153.Seats,
                                    Permission = v153.Permission or 0,
                                    Function = v153.Function,
                                    Screen = v153.Screen,
                                    Bind = v153.Bind
                                };
                            elseif #v151 == 2 then
                                u113.Buttons[v152] = {
                                    Permission = 0,
                                    Function = "PageBind",
                                    Attachment = v149,
                                    Seats = { u113.DriverSeat },
                                    Screen = v151[1],
                                    Bind = v151[2]
                                };
                            end;
                            u154(v149, v151);
                        end;
                    end;
                end;
            end;
            u154(p137, {});
        end;
        if u138.Camo then
            if typeof(u138.Camo) == "string" then
                p137.TextureID = u138.Camo;
            else
                p137.TextureID = u138.Camo[l__VehicleCamo__31];
            end;
        elseif p137:IsA("MeshPart") then
            p137.TextureID = "";
        end;
        u131(p137, u138);
    end;
    for v156, v157 in l__VehicleModuleModel__29.Body do
        if (not v157.Armor or table.find(v157.Armor, l__VehicleArmor__30)) and (not v157.IsCamo or not l__VehicleCamo__31 ~= v157.IsCamo) then
            local v158 = v156 == "Main";
            local v159;
            if v158 then
                v159 = l__Hitbox__27;
            else
                v159 = l__VehicleBody__37:WaitForChild(v156):Clone();
                u113._parts[#u113._parts + 1] = v159;
                local v160 = Instance.new("Weld");
                v160.Part0 = l__Hitbox__27;
                v160.Part1 = v159;
                v160.C0 = v159.CFrame:ToObjectSpace(l__VehicleOrigin__38):Inverse();
                if v157.SpeedType then
                    local l__Gui__44 = v159:WaitForChild("Gui");
                    u113.Speedo = {
                        Type = v157.SpeedType,
                        Gui = l__Gui__44,
                        Needle = l__Gui__44:WaitForChild("Needle"),
                        Background = l__Gui__44:WaitForChild("Background")
                    };
                elseif v156 == "Steering" then
                    u113.SteeringWheel = {
                        Right = v159:WaitForChild("Right"),
                        Left = v159:WaitForChild("Left"),
                        Turn = v159:WaitForChild("Turn"),
                        Horn = v159:WaitForChild("Horn"),
                        Weld = v160
                    };
                    v160.C0 = l__VehicleOrigin__38:Inverse() * u113.SteeringWheel.Turn.WorldCFrame;
                elseif v156 == "JoyR" then
                    u113.SteeringWheel = {
                        Right = v159:WaitForChild("Right"),
                        Left = v159:WaitForChild("Right")
                    };
                    if not u113.JoySticks then
                        u113.JoySticks = {};
                    end;
                    local l__Pivot__45 = v159:WaitForChild("Pivot");
                    u113.JoySticks[#u113.JoySticks + 1] = {
                        Pivot = l__Pivot__45.CFrame,
                        Weld = v160
                    };
                    v160.C1 = l__Pivot__45.CFrame;
                    v160.C0 = l__VehicleOrigin__38:Inverse() * l__Pivot__45.WorldCFrame;
                elseif v156 == "JoyL" then
                    if not u113.JoySticks then
                        u113.JoySticks = {};
                    end;
                    local l__Pivot__46 = v159:WaitForChild("Pivot");
                    u113.JoySticks[#u113.JoySticks + 1] = {
                        Pivot = l__Pivot__46.CFrame,
                        Weld = v160
                    };
                    v160.C1 = l__Pivot__46.CFrame;
                    v160.C0 = l__VehicleOrigin__38:Inverse() * l__Pivot__46.WorldCFrame;
                elseif v156:find("LightsFront") then
                    u24(l___lights__41.Front, v159, {
                        Style = "Small",
                        Angle = 90,
                        Brightness = 5,
                        Range = 60,
                        Intensity = 5,
                        Color = Color3.new(0.905882, 0.796078, 0.62745),
                        Face = u2.NormalId.Front
                    });
                elseif v156:find("LightsOperational") then
                    u24(l___lights__41.Operational, v159, {
                        Style = "SmallLight",
                        Angle = 120,
                        Brightness = 1,
                        Range = 10,
                        Intensity = 1,
                        Color = Color3.new(0.945098, 0.643137, 0.188235),
                        Face = u2.NormalId.Front
                    });
                elseif v156:find("LightsRear") then
                    u24(l___lights__41.Rear, v159, {
                        Style = "Small",
                        Angle = 80,
                        Brightness = 5,
                        Range = 30,
                        Intensity = 4,
                        Color = Color3.new(0.945098, 0.188235, 0.188235),
                        Face = u2.NormalId.Back
                    });
                elseif v156:find("LightsTLeft") then
                    u24(l___lights__41.Indicator.Left, v159, {
                        Angle = 80,
                        Brightness = 3,
                        Range = 15,
                        Intensity = 2,
                        Color = Color3.new(0.945098, 0.643137, 0.188235),
                        Face = u2.NormalId.Left
                    });
                elseif v156:find("LightsTRight") then
                    u24(l___lights__41.Indicator.Right, v159, {
                        Angle = 80,
                        Brightness = 3,
                        Range = 15,
                        Intensity = 2,
                        Color = Color3.new(0.945098, 0.643137, 0.188235),
                        Face = u2.NormalId.Right
                    });
                end;
                v160.Parent = v159;
            end;
            v159.Anchored = v158;
            u155(v159, v157);
            if v156 == "Lights" then
                v159.Material = u2.Material.Ice;
            end;
            v159.Parent = l__Model__26;
        end;
    end;
    u113._interior = u133;
    local l__Doors__47 = l__VehicleModel__36:WaitForChild("Doors");
    local v161 = {};
    for v162, v163 in l__VehicleModuleModel__29.Doors do
        local v164 = l__Doors__47:WaitForChild(v162);
        local l__WorldCFrame__48 = l__VehicleMain__35:WaitForChild("Seat_" .. v162):WaitForChild("Door").WorldCFrame;
        local v165 = l__WorldCFrame__48:ToObjectSpace(l__VehicleOrigin__38):Inverse();
        local v166 = {
            Open = false,
            CurrentAngle = 0,
            TargetAngle = l__VehicleModule__28.Seats[v162].Angle or 0,
            C0 = v165,
            Welds = {}
        };
        for v167, v168 in v163 do
            if (not v168.Armor or table.find(v168.Armor, l__VehicleArmor__30)) and (not v168.IsCamo or not l__VehicleCamo__31 ~= v168.IsCamo) then
                local v169 = v164:WaitForChild(v167):Clone();
                local v170 = Instance.new("Weld");
                v170.Part0 = l__Hitbox__27;
                v170.Part1 = v169;
                v170.C0 = v165;
                v170.C1 = v169.CFrame:ToObjectSpace(l__WorldCFrame__48);
                v170.Parent = v169;
                v166.Welds[#v166.Welds + 1] = v170;
                u113._parts[#u113._parts + 1] = v169;
                v169.Anchored = false;
                u155(v169, v168);
                v169.Parent = l__Model__26;
            end;
        end;
        v161[v162] = v166;
    end;
    u113.Doors = v161;
    local l__Turrets__49 = l__VehicleModel__36:WaitForChild("Turrets");
    local v171 = {};
    for u172, v173 in l__VehicleModule__28.Turrets do
        local v175;
        if l__VehicleTurrets__33 and l__VehicleTurrets__33[u172] then
            local v175;
            local v176 = 0;
            while true do
                if v176 == 0 then
                    v176 = -1;
                    v175 = l__VehicleTurrets__33[u172];
                    v176 = 1;
                    continue;
                elseif v176 == 1 then
                    v176 = -1;
                    local v177 = v173[v175];
                    local v178 = l__Turrets__49[u172]:WaitForChild(v175);
                    local v179 = l__VehicleMain__35:WaitForChild("Turret_" .. u172):WaitForChild(v175);
                    local v180 = CFrame.new();
                    local v181;
                    if v177.Turret then
                        v181 = v178:WaitForChild("Turret"):WaitForChild("Lower"):WaitForChild("Main"):WaitForChild("Pivot");
                        v180 = v181.WorldCFrame:ToObjectSpace(v179.WorldCFrame);
                    else
                        v181 = v179;
                    end;
                    local l__WorldCFrame__50 = v181.WorldCFrame;
                    local u182 = l__WorldCFrame__50:ToObjectSpace(l__VehicleOrigin__38):Inverse();
                    local u183 = {
                        Name = v175,
                        Pivot = l__Hitbox__27,
                        CFrame = l__WorldCFrame__50,
                        Offset = l__VehicleOrigin__38:ToObjectSpace(l__WorldCFrame__50),
                        Seat = v180,
                        Static = v177.Static,
                        Doors = {},
                        LowerC0 = u182,
                        Facing = Vector2.new(),
                        Current = Vector2.new()
                    };
                    local u184 = nil;
                    local u185 = nil;
                    local u186 = {};
                    local function v203(p187, p188, p189, p190, p191, p192) --[[ Line: 928 ]]
                        -- upvalues: u183 (copy), l__Hitbox__27 (copy), u182 (copy), l__WorldCFrame__50 (copy), u184 (ref), u185 (ref), u186 (copy), l__VehicleOrigin__38 (copy), u113 (copy), u172 (copy), u155 (copy), l__Model__26 (copy)
                        local v193 = p187:WaitForChild(p188):Clone();
                        local v194 = Instance.new(p190 and p188 ~= "Main" and "Motor6D" or "Weld");
                        if p191 then
                            if p188 == "Main" then
                                u183.LowerCFrame = v193.CFrame;
                                v194.Part0 = l__Hitbox__27;
                                v194.Part1 = v193;
                                v194.C0 = u182;
                                v194.C1 = v193.CFrame:ToObjectSpace(l__WorldCFrame__50);
                                u183.Lower = v194;
                                u184 = v193;
                                u183.Base = v193;
                            else
                                v194.Part0 = u184;
                                v194.Part1 = v193;
                                v194.C0 = v193.CFrame:ToObjectSpace(u183.LowerCFrame):Inverse();
                            end;
                        elseif p190 then
                            if p188 == "Main" then
                                local l__WorldCFrame__51 = v193:WaitForChild("Pivot").WorldCFrame;
                                local v195 = l__WorldCFrame__51:ToObjectSpace(u183.LowerCFrame):Inverse();
                                u183.UpperCFrame = v193.CFrame;
                                v194.Part0 = u184;
                                v194.Part1 = v193;
                                v194.C0 = v195;
                                v194.C1 = v193.CFrame:ToObjectSpace(l__WorldCFrame__51);
                                u183.UpperC0 = v195;
                                u183.Upper = v194;
                                u185 = v193;
                                for _, v196 in {
                                    "Left",
                                    "Right",
                                    "Chain1",
                                    "Chain2",
                                    "Chain3",
                                    "Chain4",
                                    "Chain5",
                                    "Chain6",
                                    "Chain7"
                                } do
                                    local v197 = v193:FindFirstChild(v196);
                                    if v197 then
                                        local v198 = Instance.new("Part");
                                        v198.Transparency = 1;
                                        v198.Name = v196;
                                        v198.Anchored = false;
                                        v198.Massless = true;
                                        v198.CanCollide = false;
                                        v198.CanTouch = false;
                                        v198.CanQuery = false;
                                        v198.AudioCanCollide = p189.Glass;
                                        v198.Size = Vector3.new(0.2, 0.2, 0.2);
                                        v198.Parent = u183.UpperModel;
                                        if v196 == "Left" then
                                            u183.Left = v198;
                                        elseif v196 == "Right" then
                                            u183.Right = v198;
                                        elseif v196:sub(1, 5) == "Chain" then
                                            u186[#u186 + 1] = v198;
                                        end;
                                        local v199 = Instance.new("Motor6D");
                                        v199.Part0 = v193;
                                        v199.Part1 = v198;
                                        v199.C0 = v197.WorldCFrame:ToObjectSpace(v193.CFrame):Inverse();
                                        v199.Parent = v198;
                                    end;
                                end;
                                u183.Sight = v193:FindFirstChild("Sight");
                                u183.Muzzle = v193:FindFirstChild("tip");
                            else
                                v194.Part0 = u185;
                                v194.Part1 = v193;
                                local v200 = v193:FindFirstChild("Anchor");
                                if v200 then
                                    v194.C0 = v200.WorldCFrame:ToObjectSpace(u183.UpperCFrame):Inverse();
                                    v194.C1 = v200.CFrame;
                                else
                                    v194.C0 = v193.CFrame:ToObjectSpace(u183.UpperCFrame):Inverse();
                                end;
                            end;
                        elseif p192 then
                            local v201 = v193:FindFirstChild("Pivot");
                            v194.Part0 = l__Hitbox__27;
                            v194.Part1 = v193;
                            v194.C0 = v201.WorldCFrame:ToObjectSpace(l__VehicleOrigin__38):Inverse();
                            v194.C1 = v201.CFrame;
                            local v202 = u113.TurretDoors[u172];
                            if v202 and (v202.Part == p188 and v202.Attachment) then
                                v202.Attachment.Parent = v193;
                                v202.Attachment.WorldCFrame = l__VehicleOrigin__38:ToWorldSpace(v202.CFrame);
                            end;
                            u183.Doors[p188] = {
                                IsOpen = false,
                                CFrame = v193.CFrame,
                                Base = v201.WorldCFrame:ToObjectSpace(l__VehicleOrigin__38):Inverse(),
                                Goal = v201.Goal.CFrame,
                                Part = v193,
                                Weld = v194
                            };
                        else
                            v194.Part0 = l__Hitbox__27;
                            v194.Part1 = v193;
                            v194.C0 = v193.CFrame:ToObjectSpace(l__VehicleOrigin__38):Inverse();
                        end;
                        v194.Parent = v193;
                        u113._parts[#u113._parts + 1] = v193;
                        if not p190 then
                            v193.Name = "Part";
                        end;
                        v193.Anchored = false;
                        u155(v193, p189, true);
                        v193.Parent = p190 and u183.UpperModel or l__Model__26;
                    end;
                    local v204 = u185;
                    for _, v205 in {
                        "Parts",
                        "Door",
                        "Turret_Lower",
                        "Turret_Upper"
                    } do
                        local v206 = v205:split("_");
                        if v177[v206[1]] then
                            local v207 = v178:FindFirstChild(v206[1]);
                            if v207 then
                                local v208 = v177[v206[1]];
                                if v206[2] then
                                    v207 = v207:FindFirstChild(v206[2]);
                                    v208 = v208[v206[2]];
                                    if v207 then
                                        goto l0;
                                    end;
                                else
                                    local v209 = v206[2] == "Upper";
                                    local v210 = v206[2] == "Lower";
                                    local v211 = v206[1] == "Door";
                                    if v209 then
                                        local v212 = Instance.new("Model");
                                        v212.Parent = l__Model__26;
                                        u183.UpperModel = v212;
                                        u113._parts[#u113._parts + 1] = v212;
                                    end;
                                    if v208.Main and (v209 or v210) then
                                        v203(v207, "Main", v208.Main, v209, v210);
                                    end;
                                    for v213, v214 in v208 do
                                        if (not v214.Armor or table.find(v214.Armor, l__VehicleArmor__30)) and ((not v214.IsCamo or not l__VehicleCamo__31 ~= v214.IsCamo) and v213 ~= "Main") then
                                            v203(v207, v213, v214, v209, v210, v211);
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                    if v204 then
                        u183.Chain = u14.new(v177.Type, v204, v204:WaitForChild("Pivot"), u186, u183.UpperModel);
                    end;
                    v171[u172] = u183;
                    break;
                else
                    break;
                end;
            end;
        elseif l__VehicleTurret__34[u172] then
            v175 = l__VehicleTurret__34[u172];
            goto l1;
        end;
    end;
    u113.Turrets = v171;
    if next(u132) then
        u113.RappelPoints = u132;
    else
        u113.RappelPoints = nil;
    end;
    if #u135 > 0 then
        u113.Flares = u135;
    else
        u113.Flares = nil;
    end;
    u113._windows = u134;
    u113._mfdsToInit = u136;
end;
function u18.RegenerateHitbox(p215) --[[ Line: 1129 ]]
    -- upvalues: u2 (copy)
    for _, v216 in p215._hitbox do
        v216:Destroy();
    end;
    p215._hitbox = {};
    local l___physicsGroup__52 = p215._physicsGroup;
    local l__Hitbox__53 = p215.Hitbox;
    local l__Model__54 = p215.Model;
    local l__VehicleOrigin__55 = p215.VehicleOrigin;
    local l__Hitbox__56 = p215.VehicleModuleModel.Hitbox;
    for _, v217 in p215.VehicleModel:WaitForChild("Hitbox"):GetChildren() do
        if l__Hitbox__56[v217.Name] then
            if table.find(l__Hitbox__56[v217.Name], p215.VehicleArmor) then
                local v218 = v217.Name:split("_");
                local v219;
                if v218[1] ~= "Turret" then
                    v219 = v217:Clone();
                    local v220 = Instance.new("Weld");
                    v220.Part0 = l__Hitbox__53;
                    v220.Part1 = v219;
                    v220.C0 = v219.CFrame:ToObjectSpace(l__VehicleOrigin__55):Inverse();
                    v220.Parent = v219;
                    v219.Transparency = 1;
                    v219.Name = "Hitbox";
                    v219.Anchored = false;
                    v219.Massless = true;
                    v219.CanCollide = true;
                    v219.CanTouch = true;
                    v219.CanQuery = true;
                    v219.AudioCanCollide = true;
                    v219.Material = u2.Material.Metal;
                    v219.CollisionGroup = l___physicsGroup__52;
                    v219.Parent = l__Model__54;
                    p215._hitbox[#p215._hitbox + 1] = v219;
                end;
                local v221 = p215.Turrets[v218[2]];
                if v221 and v221.Name == v218[3] then
                    v219 = v217:Clone();
                    local v222 = Instance.new("Weld");
                    if v218[4] == "Turret" then
                        v222.Part0 = v221.Base;
                        v222.Part1 = v219;
                        v222.C0 = v219.CFrame:ToObjectSpace(v221.Base.CFrame):Inverse();
                    elseif v218[4] == "Door" then
                        local v223 = v221.Doors[v218[5]];
                        v222.Part0 = v223.Part;
                        v222.Part1 = v219;
                        v222.C0 = v219.CFrame:ToObjectSpace(v223.Part.CFrame):Inverse();
                    end;
                    v222.Parent = v219;
                    v219.Transparency = 1;
                    v219.Name = "Hitbox";
                    v219.Anchored = false;
                    v219.Massless = true;
                    v219.CanCollide = true;
                    v219.CanTouch = true;
                    v219.CanQuery = true;
                    v219.AudioCanCollide = true;
                    v219.Material = u2.Material.Metal;
                    v219.CollisionGroup = l___physicsGroup__52;
                    v219.Parent = l__Model__54;
                    p215._hitbox[#p215._hitbox + 1] = v219;
                end;
            end;
        else
            print(p215._vehicleName .. " missing hitbox " .. v217.Name);
        end;
    end;
end;
function u18.DisconnectComponent(p224, p225, p226) --[[ Line: 1198 ]]
    -- upvalues: u2 (copy), l__Debris__1 (copy)
    local l__Wheels__57 = p224.Wheels;
    if l__Wheels__57 then
        l__Wheels__57 = p224.Wheels.F[p225] or p224.Wheels.R[p225];
    end;
    local l__Rotors__58 = p224.Rotors;
    if l__Rotors__58 then
        l__Rotors__58 = p224.Rotors[p225];
    end;
    local v227 = nil;
    if l__Wheels__57 then
        l__Wheels__57.Disconnected = true;
        if p226 then
            v227 = l__Wheels__57.Wheel:Clone();
            v227.AssemblyAngularVelocity = v227.CFrame:VectorToWorldSpace((Vector3.new(p224.ComponentReplicates and (p224.ComponentReplicates.Wheels[l__Wheels__57.Name][3] or 0) or 0, 0, 0)));
        end;
        l__Wheels__57.Wheel.Parent = nil;
        v227.Weld:Destroy();
        v227.AssemblyLinearVelocity = p224._derivedVelocity;
        v227.CanCollide = true;
        v227.CollisionGroup = u2.PhysicsGroup.Debris;
        v227.Parent = p224.Model;
        l__Debris__1:AddItem(v227, 200);
    else
        if l__Rotors__58 then
            l__Rotors__58.Disconnected = true;
            l__Rotors__58.Fried = true;
            if l__Rotors__58.Bones then
                for _, v228 in l__Rotors__58.Bones do
                    for v229, v230 in v228 do
                        if v229 == 1 then
                            v230[1].CFrame = v230[2] * CFrame.Angles(0, 0, -0.5235987755982988);
                        else
                            local v231 = v230[1];
                            local v232 = v230[2];
                            local l__Angles__59 = CFrame.Angles;
                            local v233 = math.random(-100, 100) / 5;
                            local v234 = math.rad(v233);
                            local v235 = math.random(-100, 100) / 5;
                            local v236 = math.rad(v235);
                            local v237 = math.random(-100, 100) / 10;
                            v231.CFrame = v232 * l__Angles__59(v234, v236, (math.rad(v237)));
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
function u18.KillComponent(p238, p239) --[[ Line: 1243 ]]
    -- upvalues: u2 (copy), l__Hull__5 (copy), l__TweenService__2 (copy), l__Debris__1 (copy), u3 (copy)
    if p238.KilledComponents[p239] then
    else
        p238.KilledComponents[p239] = true;
        local l__Wheels__60 = p238.Wheels;
        if l__Wheels__60 then
            l__Wheels__60 = p238.Wheels.F[p239] or p238.Wheels.R[p239];
        end;
        local l__Rotors__61 = p238.Rotors;
        if l__Rotors__61 then
            l__Rotors__61 = p238.Rotors[p239];
        end;
        if p239 == "Hull" then
            p238.Alive = false;
            for _, v240 in p238.Model:GetDescendants() do
                if v240:IsA("MeshPart") then
                    v240.Material = u2.Material.Metal;
                    v240.MaterialVariant = "metal_dented";
                    v240.TextureID = "";
                    v240.Color = Color3.new(0.2, 0.2, 0.2);
                end;
            end;
            if p238.Wheels then
                for _, v241 in p238.Wheels do
                    for v242, _ in v241 do
                        p238:DisconnectComponent(v242, true);
                    end;
                end;
            end;
            if p238.Rotors then
                for v243, _ in p238.Rotors do
                    p238:DisconnectComponent(v243, true);
                end;
            end;
            for _, v244 in p238.Seats do
                v244.Prompt.Enabled = false;
            end;
            for _, v245 in l__Hull__5:GetChildren() do
                local v246 = v245:Clone();
                v246.Parent = p238.Hitbox;
                l__TweenService__2:Create(v246, TweenInfo.new(15, u2.EasingStyle.Sine, u2.EasingDirection.Out, 0, false), {
                    Rate = 0
                }):Play();
                l__Debris__1:AddItem(v246, 15);
            end;
            p238:_cleanUp();
        else
            if p239 == "Engine" then
                local v247 = p238.Engines and p238.Engines.Front or p238.Hitbox;
                local v248 = u3:Get("Shared", "Particles", "Vehicles", "Damage", "Fire").Asset:Clone();
                local v249 = u3:Get("Shared", "Particles", "Vehicles", "Damage", "FireSparks").Asset:Clone();
                local v250 = u3:Get("Shared", "Particles", "Vehicles", "Damage", "FireSmoke").Asset:Clone();
                v248.Parent = v247;
                v249.Parent = v247;
                v250.Parent = v247;
                local v251 = v247:FindFirstChild("DamagedSmoke");
                local v252 = v247:FindFirstChild("DamagedSparks");
                if v251 then
                    v251.Enabled = false;
                    l__Debris__1:AddItem(v251, v251.Lifetime.Max);
                end;
                if v252 then
                    v252.Enabled = false;
                    l__Debris__1:AddItem(v252, v252.Lifetime.Max);
                end;
            else
                if l__Wheels__60 then
                    l__Wheels__60.Flat = true;
                    return;
                end;
                if l__Rotors__61 then
                    l__Rotors__61.Fried = true;
                    if l__Rotors__61.Bones then
                        for _, v253 in l__Rotors__61.Bones do
                            local v254 = u3:Get("Shared", "Particles", "Vehicles", "Damage", "DamagedSparks").Asset:Clone();
                            v254.Rate = 0;
                            v254.Parent = v253[1][1];
                            v253[1][4] = v254;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
function u18.SyncHealthEffects(p255) --[[ Line: 1323 ]]
    -- upvalues: u5 (copy), u3 (copy)
    local l__Engine__62 = p255.Healths.Engine;
    local v256 = p255.VehicleArmor and (p255.VehicleModule.Armor and p255.VehicleModule.Armor[p255.VehicleArmor]) and p255.VehicleModule.Armor[p255.VehicleArmor].EngineHealth or u5.ENGINE_HEALTH;
    if l__Engine__62 == 0 then
        p255:KillComponent("Engine");
    elseif l__Engine__62 then
        local v257 = p255.Engines and p255.Engines.Front or p255.Hitbox;
        local v258 = v257:FindFirstChild("DamagedSmoke");
        local v259 = v257:FindFirstChild("DamagedSparks");
        local v260 = l__Engine__62 / v256;
        if v260 < 0.8 then
            local v261 = v258 or u3:Get("Shared", "Particles", "Vehicles", "Damage", "DamagedSmoke").Asset:Clone();
            v261.Enabled = true;
            v261.Parent = v257;
        elseif v258 and v258.Enabled then
            v258.Enabled = false;
        end;
        if v260 < 0.3 then
            local v262 = v259 or u3:Get("Shared", "Particles", "Vehicles", "Damage", "DamagedSparks").Asset:Clone();
            v262.Enabled = true;
            v262.Parent = v257;
        elseif v259 and v259.Enabled then
            v259.Enabled = false;
        end;
    end;
    if p255.Healths.Hull == 0 then
        p255:KillComponent("Hull");
    end;
    if p255.Wheels then
        for v263, _ in p255.Wheels.F do
            if p255.Healths[v263] == 0 then
                p255:KillComponent(v263);
            end;
        end;
        for v264, _ in p255.Wheels.R do
            if p255.Healths[v264] == 0 then
                p255:KillComponent(v264);
            end;
        end;
    end;
    if p255.Rotors then
        for v265, _ in p255.Rotors do
            if p255.Healths[v265] == 0 then
                p255:KillComponent(v265);
            end;
        end;
    end;
end;
function u18.GetHealth(p266, p267) --[[ Line: 1380 ]]
    return p266.Healths[p267];
end;
function u18.RequestTakeDamage(p268, p269, p270) --[[ Line: 1384 ]]
    -- upvalues: u4 (copy)
    u4:FireServer("CollisionDamage", p268.UID, p269, p270);
end;
function u18.CollisionCallback(p271, p272, _, p273, _, p274) --[[ Line: 1388 ]]
    -- upvalues: u8 (copy), u4 (copy), u2 (copy), u3 (copy), u9 (copy), l__Debris__1 (copy)
    if p272.Actor then
        local v275 = u8.Lazy.Actors[p272.Actor];
        if v275 and not (v275.IsLocalPlayer or v275.Seat) then
            u4:FireServer("ActivateVehicle", p271.UID, "Hit", p272.Actor);
        end;
    else
        local v276 = tick();
        local l__Magnitude__63 = p273.Magnitude;
        if p271._lastDamage and (v276 - p271._lastDamage.Time < 0.1 and p271._lastDamage.Magnitude < l__Magnitude__63) then
        elseif p272.Part and tostring(p272.Part.CollisionGroup) == tostring(u2.PhysicsGroup.HelicopterVehicle) then
        else
            p271._lastDamage = {
                Time = v276,
                Magnitude = l__Magnitude__63
            };
            local v277 = p272.Hitbox and (p272.Hitbox.DamageComponent or "Hull") or "Hull";
            local l__Magnitude__64 = p273.Magnitude;
            local l__Magnitude__65 = p274.Magnitude;
            if string.find(string.lower(v277), "primary") then
                if not p271.ComponentReplicates or p272.PolledRotorCollision then
                    return;
                end;
                p272.PolledRotorCollision = true;
                if math.abs(p271.ComponentReplicates.Rotors[v277][2]) <= 10 then
                    return;
                end;
                l__Magnitude__64 = math.random() ^ 8 * 35;
                l__Magnitude__65 = math.random() ^ 8 * 0.8;
            end;
            local v278 = math.floor((l__Magnitude__65 - 0.2) / 4.8 * 9 + 1);
            local v279 = math.min(v278, 10);
            if v279 <= 0 then
            else
                local v280 = math.floor(l__Magnitude__64 ^ 2 * (1 - (p272.Hitbox and (p272.Hitbox.DamageResistance or 0) or 0)));
                if v280 >= 1 then
                    if p271.VehicleType == "Ground" then
                        v280 = v280 * 0.8;
                    end;
                    p271:RequestTakeDamage(v280, v277);
                end;
                local v281 = u3:Get("Shared", "Particles", "Vehicles", "Damage", "CollisionSparks").Asset:Clone();
                local l__Position__66 = p272.Position;
                local v282 = Instance.new("Attachment");
                v282.Parent = p271.Hitbox;
                v282.WorldCFrame = CFrame.new(l__Position__66, l__Position__66 + p274);
                v281.Parent = v282;
                v281:Emit(v279);
                local v283 = u9:CreateSound("Ground", v282, true, "VehicleSFX", "Damage", v279 > 4 and "Hard" or "Soft");
                local v284 = math.max(v281.Lifetime.Max, 3);
                v283.Destroy(v284);
                l__Debris__1:AddItem(v282, v284 + 1);
            end;
        end;
    end;
end;
function u18.Button(p285, p286, p287) --[[ Line: 1457 ]]
    -- upvalues: u4 (copy)
    local v288 = p285.Buttons[p286];
    if v288 then
        if v288.Function == "PageBind" then
            p285:ReplicateScreen(p286, p287);
        end;
        u4:FireServer("ButtonVehicle", p285.UID, p286, p287);
    end;
end;
function u18.ReplicateScreen(p289, p290, p291) --[[ Line: 1470 ]]
    local v292 = p289.Buttons[p290];
    if v292 then
        local v293 = p289.MFDS[v292.Screen];
        if v293 then
            if v293.Page and (v293.Page.Binds and v293.Page.Binds[v292.Bind]) then
                v293.Page.Binds[v292.Bind].Callback(p291, v293);
            end;
        end;
    end;
end;
function u18.Replicate(p294, p295, p296, p297, p298) --[[ Line: 1486 ]]
    p294._targetCFrame = p295;
    p294.Steering = p296;
    p294.Throttle = p297;
    p294.ComponentReplicates = p298 or p294.ComponentReplicates;
end;
function u18.ReplicateTurrets(p299, p300) --[[ Line: 1493 ]]
    for v301, v302 in p300 do
        if p299.Turrets[v301] and not p299.Turrets[v301].Focused then
            p299.Turrets[v301].Facing = v302;
        end;
    end;
end;
function u18.Discharge(p303, p304, p305, p306, p307, p308, p309) --[[ Line: 1502 ]]
    -- upvalues: u7 (copy)
    local v310 = p303.Turrets[p304];
    if v310.Focused then
    else
        if p305 then
            u7:Discharge(p305, p306, p307, nil, false, nil, nil, p303.Model);
        end;
        v310.Chain:Discharge(p309, p308, p306, false);
    end;
end;
function u18.Reload(p311, p312, p313) --[[ Line: 1513 ]]
    local v314 = p311.Turrets[p312];
    if v314.Focused then
    else
        v314.Chain:Reload(p313);
    end;
end;
function u18.Capacity(p315, p316, p317) --[[ Line: 1521 ]]
    p315.Turrets[p316].Chain.Length = p317;
end;
function u18.DeployFlares(p318) --[[ Line: 1526 ]]
    -- upvalues: u9 (copy), u10 (copy)
    p318._lastFlare = tick();
    for _, u319 in p318.Flares do
        local l__Data__67 = u319.Data;
        local u320 = l__Data__67.Spread or 10;
        local u321 = l__Data__67.Timer or 10;
        task.spawn(function() --[[ Line: 1533 ]]
            -- upvalues: l__Data__67 (copy), u9 (ref), u319 (copy), u10 (ref), u320 (copy), u321 (copy)
            for _ = 1, l__Data__67.Total do
                for _ = 1, l__Data__67.Count do
                    u9:CreateSound("Vehicle_Interaction", u319.Attachment, true, "VehicleSFX", "Flares", "Deploy").Destroy(2);
                    local v322 = u10;
                    local l__WorldCFrame__68 = u319.Attachment.WorldCFrame;
                    local l__Angles__69 = CFrame.Angles;
                    local v323 = Random.new():NextNumber(-u320, u320);
                    local v324 = l__WorldCFrame__68 * l__Angles__69(0, math.rad(v323), 0);
                    local l__Angles__70 = CFrame.Angles;
                    local v325 = Random.new():NextNumber(-u320, u320);
                    v322:HelicopterFlare(v324 * l__Angles__70(math.rad(v325), 0, 0), u321);
                end;
                task.wait(l__Data__67.Delay);
            end;
        end);
    end;
end;
function u18.IsA(_, p326) --[[ Line: 1555 ]]
    return p326 == "Vehicle";
end;
function u18.InitMFDs(p327) --[[ Line: 1559 ]]
    -- upvalues: u13 (copy)
    for v328, v329 in p327._mfdsToInit do
        p327.MFDS[v328] = u13.new(p327, v329.Frame, v329.Preset, v329.DefaultPage);
    end;
    p327._mfdsToInit = {};
end;
function u18.Destroy(p330) --[[ Line: 1566 ]]
    -- upvalues: u11 (copy), u6 (copy)
    if p330._stealAttchment then
        u11[p330._stealAttchment] = nil;
    end;
    if p330.Turrets then
        for _, v331 in p330.Turrets do
            if v331.Chain then
                v331.Chain:Destroy();
            end;
        end;
    end;
    if p330.Rappels then
        for _, v332 in p330.Rappels do
            v332:Destroy();
        end;
    end;
    p330:_cleanUp();
    p330.Model:Destroy();
    u6:UnregisterBlock(p330);
end;
return u18;