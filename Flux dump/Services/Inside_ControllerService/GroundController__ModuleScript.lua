-- Services.ControllerService.GroundController
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, _, v4 = shared.import("require", "network", "Enum", "asset", "server");
local u5 = v1("ActionInterface");
local u6 = v1("ViewmodelService");
local u7 = v1("VehicleService");
local u8 = v1("InputService");
local u9 = v1("NumberTween");
local u10 = v1("VehicleSolver");
local u11 = v1("DebugService");
local u12 = v1("GameSettings");
local u13 = v1("VehicleButtonInterface");
local u14 = v1("vector3toTable");
v1("PID");
local l__UserInputService__1 = game:GetService("UserInputService");
local u15 = {};
u15.__index = u15;
local l__VEHICLE_GRAVITY__2 = v4.VEHICLE_GRAVITY;
function u15._toggleEngine(p16, p17) --[[ Line: 38 ]]
    -- upvalues: u2 (copy)
    local l___vehicle__3 = p16._vehicle;
    if tick() - l___vehicle__3.EngineLast < 5 then
    else
        p16._solver:ToggleEngines(p17);
        l___vehicle__3:State("Engine", p17);
        u2:FireServer("ActivateVehicle", l___vehicle__3.UID, "Engine", p17);
    end;
end;
function u15._toggleLights(p18, p19) --[[ Line: 49 ]]
    -- upvalues: u2 (copy)
    local l___vehicle__4 = p18._vehicle;
    l___vehicle__4:State("Lights", p19);
    u2:FireServer("ActivateVehicle", l___vehicle__4.UID, "Lights", p19);
end;
function u15._toggleParkingBrake(p20, p21) --[[ Line: 55 ]]
    -- upvalues: u2 (copy)
    local l___vehicle__5 = p20._vehicle;
    l___vehicle__5:State("ParkingBrake", p21);
    u2:FireServer("ActivateVehicle", l___vehicle__5.UID, "ParkingBrake", p21);
end;
function u15._toggleIndicator(p22, p23) --[[ Line: 61 ]]
    -- upvalues: u2 (copy)
    local l___vehicle__6 = p22._vehicle;
    local v24 = l___vehicle__6.IndicatorMode == p23 and 0 or p23;
    l___vehicle__6:State("Indicators", v24);
    u2:FireServer("ActivateVehicle", l___vehicle__6.UID, "Indicators", v24);
end;
function u15._toggleSteerMode(p25, p26) --[[ Line: 71 ]]
    -- upvalues: u8 (copy)
    p25._isMouseSteering = p26;
    u8:ToggleMouseInputMovement(p26);
end;
function u15.new(p27, p28, u29) --[[ Line: 76 ]]
    -- upvalues: u7 (copy), u13 (copy), u6 (copy), u10 (copy), u9 (copy), u15 (copy), u8 (copy), u2 (copy), u14 (copy), u5 (copy), u3 (copy), u11 (copy)
    local u30 = u7:GetVehicle(p28);
    u30.Controlling = true;
    if next(u30.Buttons) then
        u13:Init(p27, u30);
    end;
    u6.Viewmodel.FollowWorldModel = true;
    local v31 = {
        _gamepadThrottle = 0,
        _isMouseSteering = false,
        _solver = u10.new(u30, u29),
        _throttle = u9.new(0),
        _handbrake = u9.new(0),
        _steer = u9.new(0),
        _constrainedSteering = u9.new(0),
        _tune = u29,
        _localActor = p27,
        _vehicle = u30
    };
    local u32 = setmetatable(v31, u15);
    u32._controls = u8:Connect({
        Exit = function(p33) --[[ Name: Exit, Line 101 ]]
            -- upvalues: u8 (ref), u2 (ref), u14 (ref), u30 (copy)
            if p33 and not u8.PauseOpen then
                u2:FireServer("ActivateInteract", "Exit", u14(u30._derivedVelocity), u14(u30._derivedAngularVelocity));
            end;
        end,
        Handbrake = function(p34) --[[ Name: Handbrake, Line 107 ]]
            -- upvalues: u32 (copy)
            u32:_setTarget(u32._handbrake, p34 and 1 or 0, 7);
        end,
        ParkingBrake = function(p35, _) --[[ Name: ParkingBrake, Line 111 ]]
            -- upvalues: u32 (copy)
            u32:_setTarget(u32._handbrake, p35 and 1 or 0, 7);
        end,
        IndicateLeft = function(p36) --[[ Name: IndicateLeft, Line 115 ]]
            -- upvalues: u32 (copy)
            if p36 then
                u32:_toggleIndicator(1);
            end;
        end,
        IndicateRight = function(p37) --[[ Name: IndicateRight, Line 120 ]]
            -- upvalues: u32 (copy)
            if p37 then
                u32:_toggleIndicator(2);
            end;
        end,
        IndicateHazard = function(p38) --[[ Name: IndicateHazard, Line 125 ]]
            -- upvalues: u32 (copy)
            if p38 then
                u32:_toggleIndicator(3);
            end;
        end,
        Horn = function(p39) --[[ Name: Horn, Line 130 ]]
            -- upvalues: u30 (copy), u2 (ref)
            u30:State("Horn", p39);
            u2:FireServer("ActivateVehicle", u30.UID, "Horn", p39);
        end,
        MouseSteer = function(p40) --[[ Name: MouseSteer, Line 134 ]]
            -- upvalues: u32 (copy)
            if p40 then
                u32:_toggleSteerMode(not u32._isMouseSteering);
            end;
        end
    });
    u5:SetVehicle({
        Vehicle = u30,
        Toggle = function() --[[ Name: Toggle, Line 143 ]]
            -- upvalues: u32 (copy), u30 (copy)
            u32:_toggleEngine(not u30.EngineOn);
        end,
        ToggleParkingBrake = function() --[[ Name: ToggleParkingBrake, Line 146 ]]
            -- upvalues: u32 (copy), u30 (copy)
            u32:_toggleParkingBrake(not u30.ParkingBrakeOn);
        end,
        Lights = function() --[[ Name: Lights, Line 149 ]]
            -- upvalues: u32 (copy), u30 (copy)
            u32:_toggleLights(not u30.LightsOn);
        end,
        Indicators = function(p41) --[[ Name: Indicators, Line 152 ]]
            -- upvalues: u32 (copy)
            u32:_toggleIndicator(p41);
        end
    });
    u32:_toggleSteerMode(false);
    u32._solver:ToggleEngines(u30.EngineOn, tick() - u30.EngineLast);
    u32._solver:SetState(u30.CFrame, u30._derivedVelocity, u30._derivedAngularVelocity, u30.ComponentReplicates);
    p27.HeightState = u3.CharacterHeightState.Sitting;
    u32._callbacks = {};
    local function v49(u42, p43, p44) --[[ Line: 173 ]]
        -- upvalues: u32 (copy), u29 (copy), u11 (ref)
        local v45 = table.concat(u42, ".");
        table.insert(u32._callbacks, v45);
        local u46 = u29;
        for v47 = 1, #u42 - 1 do
            u46 = u46[u42[v47]];
        end;
        u11:Slider(v45, u46[u42[#u42]], p43, p44, nil, function(p48) --[[ Line: 181 ]]
            -- upvalues: u46 (ref), u42 (copy), u32 (ref)
            u46[u42[#u42]] = p48;
            u32._solver:NewTune();
        end);
    end;
    u11:UnRegisterCallbacks(u32._callbacks);
    v49({ "FrontWheels", "NaturalFrequency" }, 0, 5);
    v49({ "FrontWheels", "DamperRatioCompression" }, 0, 1);
    v49({ "FrontWheels", "DamperRatioExtension" }, 0, 1);
    v49({ "RearWheels", "NaturalFrequency" }, 0, 5);
    v49({ "RearWheels", "DamperRatioCompression" }, 0, 1);
    v49({ "RearWheels", "DamperRatioExtension" }, 0, 1);
    v49({ "Mass" }, 100, 20000);
    v49({ "AccelerationFactor" }, 0.001, 1);
    v49({ "MaxTurnAngleConstant" }, 0.001, 100);
    v49({ "FrontWheels", "RollingFriction" }, 0, 2);
    v49({ "FrontWheels", "Grip" }, 0, 100);
    v49({ "FrontWheels", "DriftGrip" }, 0, 100);
    v49({ "FrontWheels", "TurningZForceMultiplier" }, 0.4, 1);
    v49({ "RearWheels", "RollingFriction" }, 0, 2);
    v49({ "RearWheels", "Grip" }, 0, 100);
    v49({ "RearWheels", "DriftGrip" }, 0, 100);
    v49({ "RearWheels", "TurningZForceMultiplier" }, 0.4, 1);
    return u32;
end;
function u15.GetConstrainedSteering(p50) --[[ Line: 214 ]]
    -- upvalues: l__VEHICLE_GRAVITY__2 (copy)
    local v51;
    if p50._solver:IsDrifting() or p50._solver:GetHorizontalSpeed() < 20 then
        v51 = p50._tune.MaxSteerAngle;
    else
        local v52 = p50._solver:GetSpeed() ^ 2 / l__VEHICLE_GRAVITY__2 / p50._tune.MaxTurnAngleConstant;
        v51 = math.atan(v52) + 1.5707963267948966;
    end;
    return math.clamp(v51, -p50._tune.MaxSteerAngle, p50._tune.MaxSteerAngle);
end;
function u15.Update(p53, p54, p55, _) --[[ Line: 228 ]]
    -- upvalues: u8 (copy), u12 (copy), l__UserInputService__1 (copy), u3 (copy)
    u8:SetMouseInputMovementMultiplier(Vector2.new(u12.MouseSteerXSensitivity, 0));
    if u8.Gamepad then
        local v56 = 0;
        for _, v57 in l__UserInputService__1:GetGamepadState(u3.UserInputType.Gamepad1) do
            if v57.KeyCode == u3.KeyCode.ButtonR2 then
                if v56 >= 0 then
                    v56 = v57.Position.Z;
                end;
            elseif v57.KeyCode == u3.KeyCode.ButtonL2 and v57.Position.Z >= 0 then
                v56 = -v57.Position.Z;
            end;
        end;
        p54 = Vector2.new(p54.X, -v56);
    end;
    if p54.Magnitude > 0 and not (p53._vehicle.EngineOn or (p53._vehicle.EngineHasBeenStarted or p53._vehicle.EngineOn)) then
        p53:_toggleEngine(true);
    end;
    p53:_setTarget(p53._throttle, -p54.Y, 7);
    p53:_setTarget(p53._steer, -p54.X, p53._tune.SteerSpeed, p53._tune.SteerStyle[1], p53._tune.SteerStyle[2]);
    p53:_setTarget(p53._constrainedSteering, p53:GetConstrainedSteering(), p53._tune.SteerSpeed, u3.EasingStyle.Linear, u3.EasingDirection.InOut);
    local v58 = p53._throttle:GetValue();
    local v59 = p53._constrainedSteering:GetValue();
    local v60 = p53._steer:GetValue() * v59;
    local v61 = p53._handbrake:GetValue();
    local v62 = p53._vehicle.ParkingBrakeOn and 1 or v61;
    local _ = p53._solver._state.CFrame;
    local v63 = p53._vehicle:GetHealth("Engine") == 0 and 0 or v58;
    local v64, v65;
    if p53._vehicle.Alive then
        v64, v65 = p53._solver:Update(p55, {
            Throttle = v63,
            WheelSteer = v60,
            Handbrake = v62
        });
    else
        v64, v65 = p53._solver:Update(p55, {
            Handbrake = v62
        });
    end;
    p53._vehicle:Replicate(v64, v60, v63, v65);
end;
function u15.Destroy(p66) --[[ Line: 293 ]]
    -- upvalues: u5 (copy), u6 (copy), u13 (copy), u11 (copy), u8 (copy)
    p66._vehicle.Controlling = false;
    p66._controls:Disconnect();
    u5:SetVehicle();
    u6.Viewmodel.FollowWorldModel = false;
    u13:Clear();
    p66._solver:Destroy();
    p66._throttle:Destroy();
    p66._handbrake:Destroy();
    p66._steer:Destroy();
    u11:UnRegisterCallbacks(p66._callbacks);
    u8:ToggleMouseInputMovement(false);
end;
function u15._setTarget(_, p67, p68, p69, p70, p71) --[[ Line: 308 ]]
    -- upvalues: u3 (copy)
    local v72 = p70 or u3.EasingStyle.Linear;
    local v73 = p71 or u3.EasingDirection.In;
    local v74 = p67:GetValue();
    if p67:GetGoal() == p68 then
    else
        local v75 = math.abs(p68 - v74) / p69;
        p67:SetGoal(p68, TweenInfo.new(v75, v72, v73));
    end;
end;
return u15;