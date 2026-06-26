-- Services.CameraService.CharacterCamera
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4 = shared.import("require", "Enum", "server", "frc");
local u5 = v1("VehicleService");
local u6 = v1("InventoryInterface");
local u7 = v1("ActionInterface");
local u8 = v1("GameShellProxyService");
local u9 = v1("PostProcessingService");
local u10 = v1("EnvironmentService");
local u11 = v1("ReplicatorService");
local u12 = v1("ClientService");
local u13 = v1("SoundService");
local u14 = v1("InputService");
local u15 = v1("GameSettings");
local v16 = v1("DebugService");
local u17 = v1("Mathf");
local u18 = v1("PID");
local l__CameraShakeState__1 = v1("CameraShakeInstance").CameraShakeState;
local l__CurrentCamera__2 = workspace.CurrentCamera;
local u19 = {};
u19.__index = u19;
function u19.new(u20) --[[ Line: 30 ]]
    -- upvalues: u9 (copy), u2 (copy), u18 (copy), u19 (copy), u14 (copy), u15 (copy), u6 (copy), u7 (copy)
    local v21 = u9:AddDepthOfField({
        FarIntensity = 0.75,
        FocusDistance = 0,
        InFocusRadius = 10,
        NearIntensity = 0.75,
        AutoFocus = false
    }, 3, true);
    v21.Enabled = false;
    local v22 = RaycastParams.new();
    v22.CollisionGroup = u2.PhysicsGroup.Debris;
    v22.FilterType = u2.RaycastFilterType.Exclude;
    v22.IgnoreWater = true;
    local v23 = {
        _force = 0,
        _walking = 0,
        _lean = 0,
        _camera = 0,
        _zoomLimit = 25,
        _shoulder = 1,
        _shoulderGoal = 1,
        _shoulderCamera = false,
        _shoulderOffset = 0,
        _shoulderLerp = 0,
        _seatOffset = false,
        _seatLerp = 0,
        _interiorMix = 0,
        _adsThirdPerson = 0,
        _yLimitDown = -1.3962634015954636,
        _yLimitUp = 1.3962634015954636,
        _vehicleSpeedFOV = 0,
        _localActor = u20,
        _params = v22,
        _x = u20.CameraX,
        _y = u20.CameraY,
        _downedBlur = v21,
        _lastWalkAngle = u20.Orientation,
        _walkPID = u18.new(10, 0, 0),
        _zoomLerp = u20.Zoom,
        _seatLast = CFrame.new(),
        _downedOffset = Vector3.new(),
        _shakes = {},
        _dead = {},
        _vehicleSpeedFOVs = {}
    };
    local u24 = setmetatable(v23, u19);
    u24._blur = u9:AddBlur({
        Size = 0
    }, nil, true);
    u24._walkPID:SetIsAngle(true);
    u24._controls = u14:Connect({
        LeanLeft = function(p25) --[[ Name: LeanLeft, Line 95 ]]
            -- upvalues: u15 (ref), u14 (ref), u24 (copy)
            if u15.LeanHold == 2 or u14.Touch then
                if not p25 then
                    return;
                end;
                p25 = u24._lean ~= -1;
            end;
            if p25 then
                u24._shoulderGoal = -1;
            end;
            u24._lean = p25 and -1 or (u24._lean == -1 and 0 or u24._lean);
        end,
        LeanRight = function(p26) --[[ Name: LeanRight, Line 108 ]]
            -- upvalues: u15 (ref), u14 (ref), u24 (copy)
            if u15.LeanHold == 2 or u14.Touch then
                if not p26 then
                    return;
                end;
                p26 = u24._lean ~= 1;
            end;
            if p26 then
                u24._shoulderGoal = 1;
            end;
            u24._lean = p26 and 1 or (u24._lean == 1 and 0 or u24._lean);
        end,
        POV = function(p27) --[[ Name: POV, Line 121 ]]
            -- upvalues: u20 (copy)
            if p27 then
                if u20.Zoom > 0 then
                    u20.Zoom = 0;
                    return;
                end;
                u20.Zoom = 5;
            end;
        end
    });
    u6:Enable();
    u7:Enable();
    return u24;
end;
function u19.Update(p28, p29, p30) --[[ Line: 146 ]]
    -- upvalues: u3 (copy), u12 (copy), u8 (copy), u14 (copy), u17 (copy), u4 (copy), u2 (copy), u11 (copy)
    local l___localActor__3 = p28._localActor;
    local v31 = u3.FREEZE_CAMERA and Vector3.new(0, 0, 0) or p29;
    local v32 = (u3.FIRST_PERSON == true or u3.FIRST_PERSON == 2 and u12.LocalClient.Survivor) and true or false;
    if v32 or p28._lockedFP then
        l___localActor__3.Zoom = 0;
    end;
    if u8.ExtractionUI then
        l___localActor__3.Zoom = math.clamp(l___localActor__3.Zoom, 2, p28._zoomLimit);
    end;
    p28._downedBlur.Enabled = l___localActor__3.Downed;
    local l__Z__4 = v31.Z;
    local v33 = l__Z__4 > 0 and 1 or (l__Z__4 < 0 and -1 or 0);
    if l___localActor__3.CQB and not l___localActor__3.ADS then
        l___localActor__3.CQB = math.clamp(l___localActor__3.CQB + v33, -2, 2);
    elseif l___localActor__3.UsingBinoculars then
        l___localActor__3.Zoom = 0;
        l___localActor__3.BinoZoom = v33;
    elseif l___localActor__3.ADS and l___localActor__3.Zoom <= 0 then
        l___localActor__3.Magnify = v33;
        local l__ADSZoom__5 = l___localActor__3.ADSZoom;
        if l__ADSZoom__5 then
            l__ADSZoom__5[5] = math.clamp(l__ADSZoom__5[5] + v33 * ((l__ADSZoom__5[2] - l__ADSZoom__5[1]) / l__ADSZoom__5[3]), l__ADSZoom__5[1], l__ADSZoom__5[2]);
        end;
    elseif not (v32 or (p28._lockedFP or u14.InventoryOpen)) then
        l___localActor__3.Zoom = math.clamp(l___localActor__3.Zoom - v33, 0, p28._zoomLimit);
    end;
    l___localActor__3.ZoomDirection = v33;
    local l__Zoom__6 = l___localActor__3.Zoom;
    p28._zoomLerp = u17.Lerp(p28._zoomLerp, l__Zoom__6, u4(p30 * 20));
    local l__Direction__7 = l___localActor__3.Direction;
    local v34 = l__Direction__7.Magnitude > 0.01;
    p28._walking = l__Direction__7;
    local v35 = l___localActor__3.HeightState == u2.CharacterHeightState.Skydiving;
    local v36 = l__Zoom__6 > 0;
    if not v36 then
        v31 = v31 * (1 - p28._force);
    end;
    if not p28._watch then
        p28._x = p28._x - v31.X;
        p28._y = math.clamp(p28._y - v31.Y, p28._yLimitDown, p28._yLimitUp);
    end;
    local v37;
    if l___localActor__3.Sprinting then
        v37 = v35;
    else
        v37 = l___localActor__3.Equipped or v35;
    end;
    p28._shoulderCamera = v37;
    p28._shoulder = u17.Lerp(p28._shoulder, p28._shoulderGoal, u4(p30 * 10));
    local v38 = l___localActor__3.HeightState == u2.CharacterHeightState.Proning;
    local v39 = l___localActor__3.HeightState == u2.CharacterHeightState.Vaulting;
    local v40 = l___localActor__3.HeightState == u2.CharacterHeightState.Climbing;
    local v41 = nil;
    local v42 = false;
    if l___localActor__3.CurrentState.Dragging then
        local v43 = u11.Actors[l___localActor__3.CurrentState.Dragging];
        if v43 then
            local v44;
            v44, v41 = CFrame.new(l___localActor__3.Position, v43.Position):ToOrientation();
        end;
    elseif not (l___localActor__3.Forced or l___localActor__3.Downed) then
        if l___localActor__3.Turret then
            local v45;
            v45, v41 = l___localActor__3.Turret.CFrame:ToOrientation();
        elseif not l___localActor__3.Bipod then
            if v36 and not v37 or (v39 or (v40 or v38 and not v34)) then
                if not v39 and (not v40 and v34) then
                    v41 = p28._lastWalkAngle + p28._walkPID:Update(p28._lastWalkAngle, l___localActor__3.GoalOrientation or math.atan2(-l__Direction__7.X, -l__Direction__7.Y), u4(p30));
                end;
            else
                local v46;
                v46, v41 = CFrame.Angles(0, l___localActor__3.Orientation, 0):Lerp(CFrame.Angles(0, p28._x, 0), p28._shoulderLerp):ToOrientation();
                v42 = true;
            end;
        end;
    end;
    if v35 then
        p28._shoulderLerp = u4(p30 * 2);
    else
        p28._shoulderLerp = u17.Lerp(p28._shoulderLerp, v42 and 1 or 0, u4(p30 * 2));
    end;
    if v41 and v41 == v41 then
        p28._lastWalkAngle = v41;
        l___localActor__3.Orientation = v41;
    end;
    l___localActor__3.CameraX = p28._x;
    l___localActor__3.CameraY = p28._y;
    l___localActor__3.Focused = not v36;
    l___localActor__3.LeanGoal = l___localActor__3.HeightState == u2.CharacterHeightState.Sitting and 0 or p28._lean;
end;
function u19.Render(p47, p48, p49) --[[ Line: 267 ]]
    -- upvalues: u5 (copy), u17 (copy), u4 (copy), u14 (copy), l__CurrentCamera__2 (copy), u2 (copy), u13 (copy), u10 (copy), l__CameraShakeState__1 (copy)
    local l___localActor__8 = p47._localActor;
    local v50 = tick();
    local l__Zoom__9 = l___localActor__8.Zoom;
    local l___zoomLerp__10 = p47._zoomLerp;
    local v51 = l__Zoom__9 > 0;
    local l__Seat__11 = l___localActor__8.Seat;
    local v52;
    if l__Seat__11 then
        v52 = u5:GetVehicle(l__Seat__11.UID);
    else
        v52 = nil;
    end;
    local l___shoulderCamera__12 = p47._shoulderCamera;
    if l___shoulderCamera__12 then
        l___shoulderCamera__12 = not l__Seat__11;
    end;
    p47._shoulderOffset = u17.Lerp(p47._shoulderOffset, l___shoulderCamera__12 and 1 or 0, u4(p48 * 5));
    local v53 = l___localActor__8.Forced or l___localActor__8.Rappelling;
    local l__Position__13 = l___localActor__8.Position;
    local l__OldSeat__14 = l___localActor__8.OldSeat;
    if l__OldSeat__14 then
        local v54;
        if v52 then
            v54 = v52.VehicleModule.Seats[l__Seat__11.Seat];
        else
            v54 = v52;
        end;
        l__Position__13 = l___localActor__8.Parts.LowerTorso.CFrame:PointToWorldSpace((Vector3.new(0, v54 and (v54.HeightFPOffset or 2.8) or 2.8, v54 and v54.SlideFPOffset or -0.5)));
        v53 = l__OldSeat__14.Track and l__OldSeat__14.Track.IsPlaying;
        if v53 then
            v53 = v50 < l__OldSeat__14.Finish;
        end;
    end;
    local v55 = u17.Lerp(p47._force, v53 and 1 or 0, u4(p48 * 5));
    local l__CFrame__15 = l___localActor__8.Parts.Head.CFrame;
    if u14:IsMouseInputMovement() then
        p47._x = u17.Lerp(p47._x, p47._seatX or 0, u4(p48 * 6));
        p47._y = u17.Lerp(p47._y, (p47._seatY or 0) - 0.23, u4(p48 * 6));
    end;
    local l__Sprinting__16 = l___localActor__8.Sprinting;
    if l__Sprinting__16 then
        l__Sprinting__16 = not v51;
    end;
    local l__Cycle__17 = l___localActor__8.Cycle;
    local v56 = CFrame.new(0, -math.sin(l__Cycle__17) / (l__Sprinting__16 and 5 or 10), 0) * CFrame.Angles(0, 0, math.cos(l__Cycle__17 / 2) / (l__Sprinting__16 and 150 or 200));
    if l___localActor__8.Downed then
        p47._downedOffset = p47._downedOffset:Lerp(l___localActor__8.CFrame:VectorToWorldSpace(Vector3.new(0, -2, 3.3)), u4(p48 * 2));
    else
        p47._downedOffset = p47._downedOffset:Lerp(Vector3.new(), u4(p48 * 5));
    end;
    local v57 = 0;
    local v58 = 0;
    local v59 = 0;
    local v60;
    if l__OldSeat__14 then
        v60 = CFrame.new(l__Position__13 + p47._downedOffset);
    else
        v60 = CFrame.new(l__Position__13 + Vector3.new(0, 2.35, 0) + p47._downedOffset);
    end;
    local v61 = false;
    if l__Seat__11 and v52 then
        p47._vehicle = v52;
        local l__CFrame__18 = p47._vehicle.CFrame;
        local l__Focused__19 = l___localActor__8.Focused;
        if l__Focused__19 then
            l__Focused__19 = not l__Seat__11.Exterior;
        end;
        v52.Inside = l__Focused__19;
        local v62, v63, v64 = l__CFrame__18:ToEulerAnglesYXZ();
        local v65 = (p47._lastVehicleLagCFrame or CFrame.Angles(0, v63, 0)):Lerp(CFrame.Angles(0, v63, 0), v51 and (u4(p48 * 5) or 1) or 1);
        local v66;
        v66, v57 = v65:ToOrientation();
        if v51 and v52.Controlling then
            if not v52.IsGroundVehicle then
                v57 = v63;
            end;
        else
            v57 = v63;
        end;
        p47._seatLast = CFrame.new(l__CFrame__18.Position);
        if not p47._seatOffset then
            p47._seatOffset = true;
            p47._x = p47._x - v57;
            p47._y = p47._y - v62;
        end;
        if v51 then
            v62 = v58;
            v64 = v59;
        end;
        p47._lastVehicleLagCFrame = v65;
        v58 = v62;
        v59 = v64;
    else
        if p47._vehicle then
            p47._vehicle.Inside = false;
        end;
        if p47._seatOffset then
            p47._seatOffset = false;
            local v67, v68 = l__CurrentCamera__2.CFrame:ToOrientation();
            p47._x = v68;
            p47._y = v67;
        end;
        if p47._seatLerp < 0.1 then
            p47._vehicle = nil;
        end;
        p47._lastVehicleLagCFrame = nil;
    end;
    local v69 = l___localActor__8.Turret and true or v61;
    p47._seatLerp = u17.Lerp(p47._seatLerp, l__Seat__11 and 1 or 0, u4(p49 * 2));
    if p47._seatLerp >= 0.99999 then
        p47._seatLerp = 1;
    end;
    p47._lockedFP = v69;
    p47._yLimitDown = v69 and -0.5235987755982988 or -1.3962634015954636;
    p47._yLimitUp = v69 and 1.0471975511965976 or 1.3962634015954636;
    local v70 = l___localActor__8.HeightState == u2.CharacterHeightState.Vaulting;
    if v70 then
        if not p47._doVaultCamera then
            p47._doVaultCamera = v50;
        end;
    else
        p47._lastOrigin = v60;
        p47._doVaultCamera = nil;
    end;
    local v71 = l___localActor__8.HeightState == u2.CharacterHeightState.Proning;
    if v51 then
        if v70 then
            v60 = p47._lastOrigin:Lerp(v60, (math.clamp(v50 - p47._doVaultCamera, 0, 1)));
        else
            v60 = v60:Lerp(p47._seatLast, p47._seatLerp);
        end;
        v55 = 0;
    elseif v71 or (v70 or l___localActor__8.Downed) then
        local l__Position__20 = l___localActor__8.Parts.Head.CFrame.Position;
        local v72 = l___localActor__8.Position - Vector3.new(0, 0.5, 0);
        v60 = CFrame.new(l__Position__20);
        if v71 then
            local v73 = workspace:Spherecast(v72, 1, l__Position__20 - v72, p47._params);
            if v73 then
                v60 = CFrame.new(v73.Position - (l__Position__20 - v72).Unit);
            end;
            v60 = v60 + Vector3.new(0, -v60.Y + l___localActor__8.Position.Y, 0);
        end;
        v56 = CFrame.new();
    end;
    local v74 = not v51 and (l__Seat__11 and not l__Seat__11.Exterior);
    if v74 then
        v74 = not l__Seat__11.Finish or l__Seat__11.Finish - 1 < v50;
    end;
    p47._interiorMix = math.lerp(p47._interiorMix, v74 and 1 or 0, u4(p48 * 5));
    if not v51 and (v52 and v52.DoorOpen) then
        p47._interiorMix = p47._interiorMix * (1 - v52.DoorOpen);
    end;
    u13:SetEffectMix("Interior", p47._interiorMix);
    local l___watch__21 = p47._watch;
    if l___watch__21 then
        local v75 = 1 - (v50 - l___watch__21.Start) / (l___watch__21.Finish - l___watch__21.Start);
        if v75 <= 0 then
            p47._watch = nil;
        else
            local v76, v77 = (CFrame.Angles(0, p47._x, 0) * CFrame.Angles(p47._y, 0, 0)):Lerp(CFrame.Angles(0, l___watch__21.TargetX, 0) * CFrame.Angles(l___watch__21.TargetY, 0, 0), (math.min(1, p48 * l___watch__21.Intensity * v75))):ToOrientation();
            p47._x = v77;
            p47._y = v76;
        end;
    end;
    local l__ViewModel__22 = l___localActor__8.ViewModel;
    local v78 = v51 and CFrame.new(p47._shoulderOffset * 2 * p47._shoulder, 0, 1.5 + l___zoomLerp__10 * (p47._seatLerp * 3 + 1)) or CFrame.new(0, 0, 0);
    local v79 = v60 * CFrame.Angles(0, v57, 0) * CFrame.Angles(v58, 0, 0) * CFrame.Angles(0, 0, v59) * CFrame.Angles(0, p47._x, 0) * CFrame.Angles(p47._y, 0, 0);
    local v80 = (v79 * v56):ToWorldSpace(v78 + Vector3.new(l___localActor__8.Lean * 0.75, 0, 0)) * l__ViewModel__22.Offset.Transform:Lerp(CFrame.new(), 0.35);
    local v81 = 0;
    local l__Magnifier__23 = l__ViewModel__22.Magnifier;
    local v82 = Vector3.new();
    local v83;
    if v51 then
        local v84 = { l__CurrentCamera__2, l___localActor__8.Character };
        if p47._vehicle and p47._vehicle.Model then
            v84[#v84 + 1] = p47._vehicle.Model;
        end;
        local l___params__24 = p47._params;
        l___params__24.FilterDescendantsInstances = v84;
        local v85 = v51 and CFrame.new(p47._shoulderOffset * 2 * p47._shoulder, 0, 1.5) or CFrame.new(0, 0, 0);
        v83 = v80 + p47:ComputeObstructions((v79 * v56):ToWorldSpace(v85 + Vector3.new(l___localActor__8.Lean * 0.75, 0, 0)).Position, v80, l___params__24);
        if l___localActor__8.HeightState == u2.CharacterHeightState.Skydiving then
            local v86 = math.random();
            local v87 = math.random();
            v82 = v82 + Vector3.new(v86, v87, math.random()) * 0.05;
        end;
    else
        v83 = v80 * CFrame.Angles(0, 0, (math.rad(l___localActor__8.Lean * -20)));
        if l__Magnifier__23 then
            v81 = v81 + l__Magnifier__23.FOV * l__Magnifier__23.Lerp * l__ViewModel__22.ADSLerp * (l__ViewModel__22.Canted and (1 - l__ViewModel__22.Canted or 1) or 1);
        end;
        if l__ViewModel__22.ADSFOV then
            v81 = v81 + l__ViewModel__22.ADSFOV * l__ViewModel__22.ADSLerp;
        end;
    end;
    local v88, v89 = l___localActor__8.ViewModel.Recoil:GetCameraAdjustment(p48, l__CurrentCamera__2.FieldOfView);
    if u14.Touch then
        v89 = 0;
    else
        v83 = v83 * v88;
    end;
    local l__BulletOffset__25 = u10.BulletOffset;
    if l___localActor__8.Bipod then
        v89 = v89 * 0.5;
    elseif not l___localActor__8.Camera then
        v82 = v82 + l__BulletOffset__25;
    end;
    u14:SetHaptic(u2.VibrationMotor.Small, l__BulletOffset__25.Magnitude);
    local v90 = Vector3.new();
    local v91 = Vector3.new();
    local l___shakes__26 = p47._shakes;
    for v92 = 1, #l___shakes__26 do
        local v93 = l___shakes__26[v92];
        local v94 = v93:GetState();
        if v94 == l__CameraShakeState__1.Inactive and v93.DeleteOnInactive then
            p47._dead[#p47._dead + 1] = v92;
        elseif v94 ~= l__CameraShakeState__1.Inactive then
            local v95 = v93:UpdateShake(p48);
            v90 = v90 + v95 * v93.PositionInfluence;
            v91 = v91 + v95 * v93.RotationInfluence;
        end;
    end;
    for v96 = #p47._dead, 1, -1 do
        table.remove(l___shakes__26, p47._dead[v96]);
        p47._dead[v96] = nil;
    end;
    if v55 >= 0.99 then
        local v97, v98;
        if l__Seat__11 then
            v97 = 0;
            v98 = 0;
        else
            v97, v98 = l__CFrame__15:ToOrientation();
        end;
        p47._x = v98;
        p47._y = v97;
        v55 = 1;
    end;
    local l__Magnitude__27 = v90.Magnitude;
    u14:SetHaptic(u2.VibrationMotor.Large, l__Magnitude__27);
    p47._blur.Size = l__Magnitude__27 * 100;
    p47._y = math.clamp(p47._y + v89, p47._yLimitDown, p47._yLimitUp);
    p47._adsThirdPerson = u17.Lerp(p47._adsThirdPerson, l___localActor__8.ADS and 1 or 0, u4(p48 * 10));
    local v99 = v51 and (p47._adsThirdPerson * 20 or 0) or 0;
    local v100 = CFrame.new(v90) * CFrame.Angles(0, math.rad(v91.Y), 0) * CFrame.Angles(math.rad(v91.X), 0, (math.rad(v91.Z)));
    l__CurrentCamera__2.CFrame = (v83:Lerp(l__CFrame__15, v55):Lerp(l___localActor__8.Camera and l___localActor__8.Camera.WorldCFrame or CFrame.new(), l___localActor__8.CameraLerp or 0) + v82) * v100;
    l__CurrentCamera__2.Focus = CFrame.new(l__Position__13);
    l__CurrentCamera__2.FieldOfView = 70 + l__ViewModel__22.CQB * 10 * (1 - l__ViewModel__22.ADSLerp) - v99 - v81 + (l__ViewModel__22.NVGFOV or 0) + ((1 - l__ViewModel__22.SprintLerp) * 10 or 0) + p47._vehicleSpeedFOV - (l___localActor__8.CameraZoom or 0);
    l___localActor__8.OffsetX = v57;
    l___localActor__8.OffsetY = v58;
    l___localActor__8.OffsetZ = v59;
    p47._force = v55;
end;
function u19.Watch(p101, p102, p103, p104, p105) --[[ Line: 541 ]]
    local v106 = tick();
    p101._watch = {
        TargetX = p102,
        TargetY = p103,
        Intensity = p104,
        Finish = v106 + p105,
        Start = v106
    };
end;
function u19.Shake(p107, p108, p109) --[[ Line: 552 ]]
    if p109 then
        p108.PositionInfluence = p108.PositionInfluence * p109;
        p108.RotationInfluence = p108.RotationInfluence * p109;
    end;
    p107._shakes[#p107._shakes + 1] = p108;
    return p108;
end;
local u110 = 1.5;
v16:Slider("FOCUS_WIDTH", u110, 0, 4, 0.001, function(p111) --[[ Line: 562 ]]
    -- upvalues: u110 (ref)
    u110 = p111;
end);
function u19.ComputeObstructions(_, p112, p113, p114) --[[ Line: 565 ]]
    -- upvalues: u110 (ref)
    local l__Position__28 = p113.Position;
    local v115 = workspace:Spherecast(p112, u110, l__Position__28 - p112, p114);
    return not v115 and Vector3.new(0, 0, 0) or -l__Position__28 + (p112 - p113.LookVector * v115.Distance);
end;
function u19.Destroy(p116) --[[ Line: 577 ]]
    -- upvalues: u14 (copy), u2 (copy), u6 (copy), u7 (copy)
    if p116._vehicle then
        p116._vehicle.Inside = false;
    end;
    p116._blur.Destroy();
    u14:SetHaptic(u2.VibrationMotor.Large, 0);
    u14:SetHaptic(u2.VibrationMotor.Small, 0);
    u6:Disable();
    u7:Disable();
    p116._downedBlur.Destroy();
    p116._controls:Disconnect();
end;
return u19;