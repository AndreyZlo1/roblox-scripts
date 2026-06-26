-- Services.ControllerService.HelicopterController
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, v4 = shared.import("require", "network", "Enum", "server");
local u5 = v1("VehicleService");
local u6 = v1("InputService");
local u7 = v1("NumberTween");
local u8 = v1("PID");
local u9 = v1("VehicleSolver");
local u10 = v1("ViewmodelService");
local u11 = v1("ActionInterface");
local u12 = v1("DebugService");
local u13 = v1("GameSettings");
local u14 = v1("VehicleButtonInterface");
local u15 = v1("vector3toTable");
local l__VEHICLE_GRAVITY__1 = v4.VEHICLE_GRAVITY;
local u16 = {};
u16.__index = u16;
function u16._toggleEngine(p17, p18) --[[ Line: 33 ]]
    -- upvalues: u2 (copy)
    local l___vehicle__2 = p17._vehicle;
    if tick() - l___vehicle__2.EngineLast < 35 then
        return;
    end;
    for _, v19 in l___vehicle__2.Rotors do
        if v19.Fried then
            p18 = false;
            break;
        end;
    end;
    p17._solver:ToggleEngines(p18);
    l___vehicle__2:State("Engine", p18);
    u2:FireServer("ActivateVehicle", l___vehicle__2.UID, "Engine", p18);
end;
function u16._toggleParkingBrake(p20, p21) --[[ Line: 51 ]]
    -- upvalues: u2 (copy)
    local l___vehicle__3 = p20._vehicle;
    l___vehicle__3:State("ParkingBrake", p21);
    u2:FireServer("ActivateVehicle", l___vehicle__3.UID, "ParkingBrake", p21);
end;
function u16._toggleSteerMode(p22, p23) --[[ Line: 57 ]]
    -- upvalues: u6 (copy)
    p22._isMouseSteering = p23;
    u6:ToggleMouseInputMovement(p23);
end;
function u16.new(p24, p25, u26) --[[ Line: 62 ]]
    -- upvalues: u5 (copy), u14 (copy), u10 (copy), u9 (copy), u7 (copy), u16 (copy), u8 (copy), u6 (copy), u2 (copy), u15 (copy), u11 (copy), u3 (copy), u12 (copy)
    local u27 = u5:GetVehicle(p25);
    u27.Controlling = true;
    if next(u27.Buttons) then
        u14:Init(p24, u27);
    end;
    u10.Viewmodel.FollowWorldModel = true;
    local v28 = {
        _increaseCollective = 0,
        _decreaseCollective = 0,
        _yawLeft = 0,
        _yawRight = 0,
        _autoHover = false,
        _isMouseSteering = false,
        _vehicle = u27,
        _tune = u26,
        _solver = u9.new(u27, u26),
        _collective = u7.new(0),
        _pitch = u7.new(0),
        _roll = u7.new(0),
        _yaw = u7.new(0),
        _localActor = p24,
        _throttle = u7.new(0),
        _steer = u7.new(0),
        _constrainedSteering = u7.new(0),
        _handbrake = u7.new(0),
        _PIDs = {
            AlwaysOn = {
                Collective = {},
                Pitch = {},
                Roll = {},
                Yaw = {}
            },
            AutoHover = {
                Collective = {},
                Pitch = {},
                Roll = {},
                Yaw = {}
            }
        }
    };
    local u29 = setmetatable(v28, u16);
    for v30, v31 in u26.PIDs do
        for v32, v33 in v31 do
            for v34, v35 in v33 do
                local v36 = u8.new(table.unpack(v35));
                u29._PIDs[v30][v32][v34] = v36;
            end;
        end;
    end;
    local v45 = {
        Exit = function(p37) --[[ Name: Exit, Line 121 ]]
            -- upvalues: u6 (ref), u2 (ref), u15 (ref), u27 (copy)
            if p37 and not u6.PauseOpen then
                u2:FireServer("ActivateInteract", "Exit", u15(u27._derivedVelocity), u15(u27._derivedAngularVelocity));
            end;
        end,
        IncreaseCollective = function(p38) --[[ Name: IncreaseCollective, Line 126 ]]
            -- upvalues: u29 (copy)
            u29._increaseCollective = p38 and 1 or 0;
        end,
        DecreaseCollective = function(p39) --[[ Name: DecreaseCollective, Line 130 ]]
            -- upvalues: u29 (copy)
            u29._decreaseCollective = p39 and 1 or 0;
        end,
        YawLeft = function(p40) --[[ Name: YawLeft, Line 134 ]]
            -- upvalues: u29 (copy)
            u29._yawLeft = p40 and 1 or 0;
        end,
        YawRight = function(p41) --[[ Name: YawRight, Line 138 ]]
            -- upvalues: u29 (copy)
            u29._yawRight = p41 and 1 or 0;
        end,
        AutoHover = function(p42) --[[ Name: AutoHover, Line 142 ]]
            -- upvalues: u29 (copy)
            if p42 then
                u29._autoHover = not u29._autoHover;
            end;
        end,
        PilotZoom = function(p43) --[[ Name: PilotZoom, Line 148 ]]
            -- upvalues: u29 (copy)
            if p43 then
                u29._pilotZoom = not u29._pilotZoom;
            end;
        end,
        HeliMouseSteer = function(p44) --[[ Name: HeliMouseSteer, Line 153 ]]
            -- upvalues: u29 (copy)
            if p44 then
                u29:_toggleSteerMode(not u29._isMouseSteering);
            end;
        end
    };
    if u27.RappelPoints then
        function v45.Rappel(p46) --[[ Line: 161 ]]
            -- upvalues: u6 (ref), u27 (copy), u2 (ref)
            if p46 and not (u6.PauseOpen or (u6.RadialOpen or u6.InventoryOpen)) then
                if u27.LastRappel and tick() - u27.LastRappel < 10 then
                    return;
                end;
                u27:State("Rappels", u27.Rappels == nil);
                u2:FireServer("ActivateVehicle", u27.UID, "Rappels");
            end;
        end;
    end;
    local v49 = {
        Vehicle = u27,
        Toggle = function() --[[ Name: Toggle, Line 175 ]]
            -- upvalues: u29 (copy), u27 (copy)
            u29:_toggleEngine(not u27.EngineOn);
        end,
        ToggleParkingBrake = function() --[[ Name: ToggleParkingBrake, Line 178 ]]
            -- upvalues: u29 (copy), u27 (copy)
            u29:_toggleParkingBrake(not u27.ParkingBrakeOn);
        end,
        LightModes = function(p47, p48) --[[ Name: LightModes, Line 181 ]]
            -- upvalues: u27 (copy), u2 (ref)
            local l__LightModes__4 = u27.LightModes;
            l__LightModes__4[p47] = p48;
            u27:State("LightModes", l__LightModes__4);
            u2:FireServer("ActivateVehicle", u27.UID, "LightModes", p47, p48);
        end
    };
    if u27.Flares then
        function v49.Flares() --[[ Line: 191 ]]
            -- upvalues: u2 (ref), u27 (copy)
            u2:FireServer("ActivateVehicle", u27.UID, "DeployFlares");
        end;
        function v45.Flares(p50) --[[ Line: 194 ]]
            -- upvalues: u6 (ref), u2 (ref), u27 (copy)
            if p50 and not (u6.PauseOpen or (u6.RadialOpen or u6.InventoryOpen)) then
                u2:FireServer("ActivateVehicle", u27.UID, "DeployFlares");
            end;
        end;
    end;
    u29._controls = u6:Connect(v45);
    u11:SetVehicle(v49);
    u29:_toggleSteerMode(false);
    u29._solver:ToggleEngines(u27.EngineOn, tick() - u27.EngineLast);
    u29._solver:SetState(u27.CFrame, u27._derivedVelocity, u27._derivedAngularVelocity, u27.ComponentReplicates);
    p24.HeightState = u3.CharacterHeightState.Sitting;
    u29._callbacks = {};
    local function v59(u51, p52, p53, u54) --[[ Line: 213 ]]
        -- upvalues: u29 (copy), u26 (copy), u12 (ref)
        local v55 = table.concat(u51, ".");
        table.insert(u29._callbacks, v55);
        local u56 = u26;
        for v57 = 1, #u51 - 1 do
            u56 = u56[u51[v57]];
        end;
        if u56[u51[#u51]] then
            u12:Slider(v55, u56[u51[#u51]], p52, p53, nil, function(p58) --[[ Line: 225 ]]
                -- upvalues: u56 (ref), u51 (copy), u54 (copy), u29 (ref)
                u56[u51[#u51]] = p58;
                if u54 then
                    u54(p58);
                end;
                u29._solver:NewTune();
            end);
        end;
    end;
    u12:UnRegisterCallbacks(u29._callbacks);
    v59({ "Acceleration" }, 1, 9);
    v59({ "Speed" }, 50, 750);
    v59({ "YawRate" }, 1, 250);
    v59({ "PitchSensitivity" }, 0.05, 0.5);
    v59({ "MaximumPitch" }, 0, 1);
    v59({ "MaximumRoll" }, 0, 1);
    v59({ "MinimumCollective" }, -1, 0);
    v59({ "MaximumCollective" }, 0, 1);
    v59({ "CollectiveInputSpeed" }, 0.2, 60);
    v59({ "PitchInputSpeed" }, 0.2, 60);
    v59({ "RollInputSpeed" }, 0.2, 60);
    v59({ "YawInputSpeed" }, 0.2, 60);
    v59({ "PIDCollectiveInputSpeed" }, 0.2, 60);
    v59({ "PIDPitchInputSpeed" }, 0.2, 60);
    v59({ "PIDRollInputSpeed" }, 0.2, 60);
    v59({ "PIDYawInputSpeed" }, 0.2, 60);
    v59({ "CollectiveTrimOffset" }, -1, 1);
    v59({ "PitchTrimOffset" }, -1, 1);
    v59({ "RollTrimOffset" }, -1, 1);
    v59({ "YawTrimOffset" }, -1, 1);
    v59({ "SteadyStabilize" }, 0, 1);
    v59({ "AngularVelocityDragMultiplier", "Pitch" }, 0, 10);
    v59({ "AngularVelocityDragMultiplier", "Yaw" }, 0, 10);
    v59({ "AngularVelocityDragMultiplier", "Roll" }, 0, 10);
    v59({ "WeatherVaningDragMultiplier", "Pitch" }, 0, 0.01);
    v59({ "WeatherVaningDragMultiplier", "Yaw" }, 0, 0.01);
    v59({ "WeatherVaningDragMultiplier", "Roll" }, 0, 0.01);
    v59({ "Mass" }, 100, 50000);
    for v60, _ in u26.Blades do
        v59({ "Blades", v60, "VisualSpeedMultiplier" }, 0.01, 10);
        v59({ "Blades", v60, "CounterTorque" }, 0.01, 50);
        v59({ "Blades", v60, "Precession" }, 0.00001, 0.01);
        v59({ "Blades", v60, "AlignVertical" }, 0, 1);
    end;
    for u61, v62 in u26.PIDs do
        for u63, v64 in v62 do
            for u65, _ in v64 do
                v59({
                    "PIDs",
                    u61,
                    u63,
                    u65,
                    1
                }, -20, 20, function(p66) --[[ Line: 276 ]]
                    -- upvalues: u29 (copy), u61 (copy), u63 (copy), u65 (copy)
                    u29._PIDs[u61][u63][u65].Pp = p66;
                end);
                v59({
                    "PIDs",
                    u61,
                    u63,
                    u65,
                    2
                }, -5, 5, function(p67) --[[ Line: 277 ]]
                    -- upvalues: u29 (copy), u61 (copy), u63 (copy), u65 (copy)
                    u29._PIDs[u61][u63][u65].Pi = p67;
                end);
                v59({
                    "PIDs",
                    u61,
                    u63,
                    u65,
                    3
                }, -500, 500, function(p68) --[[ Line: 278 ]]
                    -- upvalues: u29 (copy), u61 (copy), u63 (copy), u65 (copy)
                    u29._PIDs[u61][u63][u65].Pd = p68;
                end);
                v59({
                    "PIDs",
                    u61,
                    u63,
                    u65,
                    4
                }, -20, 20, function(p69) --[[ Line: 279 ]]
                    -- upvalues: u29 (copy), u61 (copy), u63 (copy), u65 (copy)
                    u29._PIDs[u61][u63][u65].Np = p69;
                end);
                v59({
                    "PIDs",
                    u61,
                    u63,
                    u65,
                    5
                }, -5, 5, function(p70) --[[ Line: 280 ]]
                    -- upvalues: u29 (copy), u61 (copy), u63 (copy), u65 (copy)
                    u29._PIDs[u61][u63][u65].Ni = p70;
                end);
                v59({
                    "PIDs",
                    u61,
                    u63,
                    u65,
                    6
                }, -500, 500, function(p71) --[[ Line: 281 ]]
                    -- upvalues: u29 (copy), u61 (copy), u63 (copy), u65 (copy)
                    u29._PIDs[u61][u63][u65].Nd = p71;
                end);
            end;
        end;
    end;
    v59({ "FrontWheels", "NaturalFrequency" }, 0, 5);
    v59({ "FrontWheels", "DamperRatioCompression" }, 0, 1);
    v59({ "FrontWheels", "DamperRatioExtension" }, 0, 1);
    v59({ "RearWheels", "NaturalFrequency" }, 0, 5);
    v59({ "RearWheels", "DamperRatioCompression" }, 0, 1);
    v59({ "RearWheels", "DamperRatioExtension" }, 0, 1);
    v59({ "AccelerationFactor" }, 0.001, 1);
    v59({ "FrontWheels", "Grip" }, 0, 100);
    v59({ "RearWheels", "Grip" }, 0, 100);
    return u29;
end;
local u84 = {
    LateralSpeed = function(p72) --[[ Line: 301 ]]
        -- upvalues: u3 (copy)
        return -p72:GetRelativeVelocity(u3.Axis.X);
    end,
    LongitudinalSpeed = function(p73) --[[ Line: 304 ]]
        -- upvalues: u3 (copy)
        return -p73:GetRelativeVelocity(u3.Axis.Z);
    end,
    VerticalSpeed = function(p74) --[[ Line: 307 ]]
        return p74:GetVelocity().Y;
    end,
    RollOffset = function(p75) --[[ Line: 310 ]]
        local _, _, v76 = p75:GetOrientation();
        return v76;
    end,
    PitchOffset = function(p77) --[[ Line: 314 ]]
        local v78, _, _ = p77:GetOrientation();
        return -v78;
    end,
    RollVelocity = function(p79) --[[ Line: 318 ]]
        return p79:GetRelativeAngularVelocity().Z;
    end,
    PitchVelocity = function(p80) --[[ Line: 321 ]]
        return -p80:GetRelativeAngularVelocity().X;
    end,
    YawVelocity = function(p81) --[[ Line: 324 ]]
        return -p81:GetRelativeAngularVelocity().Y;
    end,
    SuspensionCompression = function(p82) --[[ Line: 327 ]]
        return p82:GetAverageSuspensionCompression();
    end,
    GroundPenetration = function(p83) --[[ Line: 330 ]]
        return p83:GetEstimateGroundPenetration();
    end
};
function u16.GetConstrainedSteering(p85) --[[ Line: 356 ]]
    -- upvalues: l__VEHICLE_GRAVITY__1 (copy)
    local v86;
    if p85._solver:IsDrifting() or p85._solver:GetHorizontalSpeed() < 20 then
        v86 = p85._tune.MaxSteerAngle;
    else
        local v87 = p85._solver:GetSpeed() ^ 2 / l__VEHICLE_GRAVITY__1 / p85._tune.MaxTurnAngleConstant;
        v86 = math.atan(v87) + 1.5707963267948966;
    end;
    return math.clamp(v86, -p85._tune.MaxSteerAngle, p85._tune.MaxSteerAngle);
end;
function u16.Update(p88, p89, p90) --[[ Line: 370 ]]
    -- upvalues: u6 (copy), u13 (copy), u84 (copy), u3 (copy), u12 (copy)
    u6:SetMouseInputMovementMultiplier(Vector2.new(u13.MouseSteerXSensitivity, -u13.MouseSteerYSensitivity * (u13.MouseSteerInvertYAxis == 1 and -1 or 1)));
    u6:ResetMouseInputMovement();
    local l___vehicle__5 = p88._vehicle;
    local l___solver__6 = p88._solver;
    local l___tune__7 = p88._tune;
    local v91 = p88._increaseCollective ~= 0 and true or p88._decreaseCollective ~= 0;
    local v92 = p89.Y ~= 0;
    local v93 = p89.X ~= 0;
    local v94 = p88._yawLeft ~= 0 and true or p88._yawRight ~= 0;
    local l__PIDCollectiveInputSpeed__8 = l___tune__7.PIDCollectiveInputSpeed;
    local l__PIDPitchInputSpeed__9 = l___tune__7.PIDPitchInputSpeed;
    local l__PIDRollInputSpeed__10 = l___tune__7.PIDRollInputSpeed;
    local l__PIDYawInputSpeed__11 = l___tune__7.PIDYawInputSpeed;
    local v95 = 0;
    local v96 = 0;
    local v97 = 0;
    local v98 = 0;
    for v99, v100 in p88._PIDs.AutoHover.Collective do
        local v101 = not v91;
        local l___autoHover__12 = p88._autoHover;
        local v102, v103 = u84[v99](l___solver__6);
        local v104;
        if v102 then
            local v105 = 0;
            if v101 then
                v104 = v100:Update(v102, v103 or 0, 1);
                if not l___autoHover__12 then
                    v104 = v105;
                end;
            else
                v100:Reset();
                v104 = v105;
            end;
        else
            v100:Reset();
            v104 = 0;
        end;
        v95 = v95 + v104;
    end;
    for v106, v107 in p88._PIDs.AutoHover.Pitch do
        local v108 = not v92;
        local l___autoHover__13 = p88._autoHover;
        local v109, v110 = u84[v106](l___solver__6);
        local v111;
        if v109 then
            local v112 = 0;
            if v108 then
                v111 = v107:Update(v109, v110 or 0, 1);
                if not l___autoHover__13 then
                    v111 = v112;
                end;
            else
                v107:Reset();
                v111 = v112;
            end;
        else
            v107:Reset();
            v111 = 0;
        end;
        v96 = v96 + v111;
    end;
    for v113, v114 in p88._PIDs.AutoHover.Roll do
        local v115 = not v93;
        local l___autoHover__14 = p88._autoHover;
        local v116, v117 = u84[v113](l___solver__6);
        local v118;
        if v116 then
            local v119 = 0;
            if v115 then
                v118 = v114:Update(v116, v117 or 0, 1);
                if not l___autoHover__14 then
                    v118 = v119;
                end;
            else
                v114:Reset();
                v118 = v119;
            end;
        else
            v114:Reset();
            v118 = 0;
        end;
        v97 = v97 + v118;
    end;
    for v120, v121 in p88._PIDs.AutoHover.Yaw do
        local v122 = not v94;
        local l___autoHover__15 = p88._autoHover;
        local v123, v124 = u84[v120](l___solver__6);
        local v125;
        if v123 then
            local v126 = 0;
            if v122 then
                v125 = v121:Update(v123, v124 or 0, 1);
                if not l___autoHover__15 then
                    v125 = v126;
                end;
            else
                v121:Reset();
                v125 = v126;
            end;
        else
            v121:Reset();
            v125 = 0;
        end;
        v98 = v98 + v125;
    end;
    for v127, v128 in p88._PIDs.AlwaysOn.Collective do
        local v129 = not v91;
        local v130, v131 = u84[v127](l___solver__6);
        local v132;
        if v130 then
            v132 = 0;
            if v129 then
                v132 = v128:Update(v130, v131 or 0, 1);
            else
                v128:Reset();
            end;
        else
            v128:Reset();
            v132 = 0;
        end;
        v95 = v95 + v132;
    end;
    for v133, v134 in p88._PIDs.AlwaysOn.Pitch do
        local v135 = not v92;
        local v136, v137 = u84[v133](l___solver__6);
        local v138;
        if v136 then
            v138 = 0;
            if v135 then
                v138 = v134:Update(v136, v137 or 0, 1);
            else
                v134:Reset();
            end;
        else
            v134:Reset();
            v138 = 0;
        end;
        v96 = v96 + v138;
    end;
    for v139, v140 in p88._PIDs.AlwaysOn.Roll do
        local v141 = not v93;
        local v142, v143 = u84[v139](l___solver__6);
        local v144;
        if v142 then
            v144 = 0;
            if v141 then
                v144 = v140:Update(v142, v143 or 0, 1);
            else
                v140:Reset();
            end;
        else
            v140:Reset();
            v144 = 0;
        end;
        v97 = v97 + v144;
    end;
    for v145, v146 in p88._PIDs.AlwaysOn.Yaw do
        local v147 = not v94;
        local v148, v149 = u84[v145](l___solver__6);
        local v150;
        if v148 then
            v150 = 0;
            if v147 then
                v150 = v146:Update(v148, v149 or 0, 1);
            else
                v146:Reset();
            end;
        else
            v146:Reset();
            v150 = 0;
        end;
        v98 = v98 + v150;
    end;
    local v151;
    if v91 then
        l__PIDCollectiveInputSpeed__8 = l___tune__7.CollectiveInputSpeed;
        v151 = p88._increaseCollective - p88._decreaseCollective;
    else
        v151 = v95 + l___solver__6:GetCollectiveNegateGravity();
    end;
    p88:_setTarget(p88._collective, math.clamp(v151 + l___tune__7.CollectiveTrimOffset, l___tune__7.MinimumCollective, l___tune__7.MaximumCollective), l__PIDCollectiveInputSpeed__8);
    if v92 then
        l__PIDPitchInputSpeed__9 = l___tune__7.PitchInputSpeed;
        v96 = -p89.Y;
    end;
    p88:_setTarget(p88._pitch, math.clamp(v96 + l___tune__7.PitchTrimOffset, -l___tune__7.MaximumPitch, l___tune__7.MaximumPitch), l__PIDPitchInputSpeed__9);
    if v93 then
        l__PIDRollInputSpeed__10 = l___tune__7.RollInputSpeed;
        v97 = -p89.X;
    end;
    p88:_setTarget(p88._roll, math.clamp(v97 + l___tune__7.RollTrimOffset, -l___tune__7.MaximumRoll, l___tune__7.MaximumRoll), l__PIDRollInputSpeed__10);
    if v94 then
        l__PIDYawInputSpeed__11 = l___tune__7.YawInputSpeed;
        v98 = p88._yawRight - p88._yawLeft;
    end;
    p88:_setTarget(p88._yaw, math.clamp(v98 + l___tune__7.YawTrimOffset, -1, 1), l__PIDYawInputSpeed__11);
    local v152 = p88._collective:GetValue();
    local v153 = p88._pitch:GetValue();
    local v154 = p88._roll:GetValue();
    local v155 = p88._yaw:GetValue();
    p88:_setTarget(p88._throttle, -p89.Y, 7);
    p88:_setTarget(p88._steer, -p89.X, p88._tune.SteerSpeed, p88._tune.SteerStyle[1], p88._tune.SteerStyle[2]);
    p88:_setTarget(p88._constrainedSteering, p88:GetConstrainedSteering(), p88._tune.SteerSpeed, u3.EasingStyle.Linear, u3.EasingDirection.InOut);
    local v156 = p88._throttle:GetValue();
    local v157 = p88._constrainedSteering:GetValue();
    local v158 = p88._steer:GetValue() * v157;
    local v159 = p88._handbrake:GetValue();
    local v160 = p88._vehicle.ParkingBrakeOn and 1 or v159;
    local v161, v162;
    if p88._vehicle.Alive then
        v161, v162 = l___solver__6:Update(p90, {
            RotorThrottle = 1,
            RotorLift = v152,
            RotorPitch = v153,
            RotorRoll = v154,
            RotorYaw = v155,
            RotorSteady = p88._autoHover and l___tune__7.SteadyStabilize or 0,
            Throttle = v156,
            Handbrake = v160,
            WheelSteer = v158
        });
    else
        v161, v162 = p88._solver:Update(p90, {
            Handbrake = v160
        });
    end;
    p88._localActor.CameraZoom = math.lerp(p88._localActor.CameraZoom or 0, p88._pilotZoom and p88._localActor.Focused and 45 or 0, p90 * 10);
    u12:Graph("Altitude", nil, v161.Y, 3, Color3.new(0, 1, 1));
    l___vehicle__5:Replicate(v161, v158, v156, v162);
end;
function u16.Destroy(p163) --[[ Line: 501 ]]
    -- upvalues: u11 (copy), u10 (copy), u14 (copy), u12 (copy), u6 (copy)
    p163._vehicle.Controlling = false;
    p163._controls:Disconnect();
    u11:SetVehicle();
    u10.Viewmodel.FollowWorldModel = false;
    u14:Clear();
    p163._localActor.CameraZoom = nil;
    p163._solver:Destroy();
    p163._collective:Destroy();
    p163._pitch:Destroy();
    p163._roll:Destroy();
    p163._yaw:Destroy();
    u12:UnRegisterCallbacks(p163._callbacks);
    u6:ToggleMouseInputMovement(false);
end;
function u16._setTarget(_, p164, p165, p166, p167, p168) --[[ Line: 518 ]]
    -- upvalues: u3 (copy)
    local v169 = p167 or u3.EasingStyle.Linear;
    local v170 = p168 or u3.EasingDirection.In;
    local v171 = p164:GetValue();
    if p164:GetGoal() == p165 then
    else
        local v172 = math.abs(p165 - v171) / p166;
        p164:SetGoal(p165, TweenInfo.new(v172, v169, v170));
    end;
end;
return u16;