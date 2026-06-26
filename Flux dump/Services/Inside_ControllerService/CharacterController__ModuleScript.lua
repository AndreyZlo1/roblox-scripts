-- Services.ControllerService.CharacterController
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4 = shared.import("require", "Enum", "network", "server");
local u5 = v1("InputService");
local u6 = v1("HUDInterface");
local u7 = v1("NotifyInterface");
local u8 = v1("InventoryService");
local u9 = v1("VehicleService");
local u10 = v1("InteractionInterface");
local u11 = v1("ReplicatorService");
local u12 = v1("Mathf");
local u13 = v1("WorldService");
local u14 = v1("DebugService");
local u15 = v1("ClientService");
local u16 = v1("GameSettings");
local u17 = v1("Animations");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local l__Gravity__2 = workspace.Gravity;
local u18 = {
    [u2.CharacterHeightState.Standing] = {
        HEIGHT = 6,
        SPEED_MULT = 1
    },
    [u2.CharacterHeightState.Falling] = {
        HEIGHT = 6,
        SPEED_MULT = 1,
        NO_SPECIAL = true
    },
    [u2.CharacterHeightState.Skydiving] = {
        HEIGHT = 3,
        SPEED_MULT = 10,
        ACCELERATION = 25,
        DECELERATION = 25,
        NO_SPECIAL = true
    },
    [u2.CharacterHeightState.Parachuting] = {
        HEIGHT = 6,
        SPEED_MULT = 4,
        NO_SPECIAL = true
    },
    [u2.CharacterHeightState.Vaulting] = {
        HEIGHT = 6,
        SPEED_MULT = 0,
        NO_SPECIAL = true
    },
    [u2.CharacterHeightState.Swimming] = {
        HEIGHT = 6,
        SPEED_MULT = 0.8
    },
    [u2.CharacterHeightState.Crouching] = {
        HEIGHT = 4,
        SPEED_MULT = 0.6
    },
    [u2.CharacterHeightState.Proning] = {
        HEIGHT = 3,
        SPEED_MULT = 0.3
    },
    [u2.CharacterHeightState.Climbing] = {
        HEIGHT = 6,
        SPEED_MULT = 0,
        NO_SPECIAL = true
    }
};
local u19 = {};
u19.__index = u19;
function u19._makeDownedControls(u20) --[[ Line: 137 ]]
    -- upvalues: u5 (copy), u3 (copy), u6 (copy)
    u20._downedControls = u5:Connect({
        Bleed = function(p21) --[[ Name: Bleed, Line 139 ]]
            -- upvalues: u20 (copy), u3 (ref), u6 (ref)
            if u20._localActor.Downed then
                u3:FireServer("HoldBleed", p21);
                u6.UpdateBleeding(p21);
            else
                u6.UpdateBleeding(false);
            end;
        end
    });
end;
function u19._makeParachuteControls(u22) --[[ Line: 150 ]]
    -- upvalues: u5 (copy), u2 (copy), u7 (copy)
    u22._parachuteControls = u5:Connect({
        Parachute = function(p23) --[[ Name: Parachute, Line 152 ]]
            -- upvalues: u22 (copy), u2 (ref)
            if p23 then
                u22._parachuteControls:Disconnect();
                u22._parachuteControls = nil;
                u22.HeightState = u2.CharacterHeightState.Parachuting;
                u22._localActor.HeightState = u2.CharacterHeightState.Parachuting;
            end;
        end
    });
    u7:Notify({
        { "Alert", "Press [" .. u5:GetBind("Parachute").Name .. "] to use parachute", Color3.new(1, 0.866666, 0.505882) }
    });
end;
function u19._exhaust(p24, p25) --[[ Line: 173 ]]
    local v26 = tick();
    if p24._exhausted >= v26 then
        return false;
    end;
    p24._exhaustStart = v26;
    p24._exhausted = v26 + p25;
    return true;
end;
function u19.new(u27, p28) --[[ Line: 183 ]]
    -- upvalues: u2 (copy), l__CurrentCamera__1 (copy), u18 (copy), u19 (copy), u8 (copy), u5 (copy), u4 (copy), u16 (copy), u10 (copy)
    local v29 = RaycastParams.new();
    v29.CollisionGroup = u2.PhysicsGroup.CharacterCast;
    v29.FilterType = u2.RaycastFilterType.Exclude;
    v29.FilterDescendantsInstances = { l__CurrentCamera__1 };
    v29.IgnoreWater = true;
    local v30 = Instance.new("Part");
    v30.Shape = u2.PartType.Cylinder;
    v30.CanCollide = false;
    v30.CanQuery = false;
    v30.CanTouch = false;
    v30.Anchored = true;
    if u27.HeightState ~= u2.CharacterHeightState.Crouching and u27.HeightState ~= u2.CharacterHeightState.Proning then
        u27.HeightState = u2.CharacterHeightState.Standing;
    end;
    local u31 = setmetatable({
        VelocityGravity = 0,
        SlopeNormal = Vector3.new(0, 1, 0),
        IsGrounded = false,
        IsSprinting = false,
        TrySprinting = false,
        MoveSpeed = 0,
        _exhaustStart = 0,
        _exhausted = 0,
        _lean = 0,
        _up = false,
        _swimDirection = 0,
        _swimLevel = 0,
        _shiftKeyDown = false,
        _emoting = false,
        _weightMulti = 0,
        _groundedInputDirection = Vector3.new(0, 0, 0),
        _holdingForProne = nil,
        HeightState = u27.HeightState,
        _lastMovement = Vector2.zero,
        _cylinder = v30,
        _params = v29,
        _localActor = u27,
        _position = u27.Position,
        _lastSafePosition = u27.Position,
        _hullHeight = u18[u27.HeightState].HEIGHT
    }, u19);
    if p28 then
        u31._startPhysics = tick() + 5;
    end;
    local function v39() --[[ Line: 239 ]]
        -- upvalues: u8 (ref), u31 (copy)
        local v32 = 0;
        local v33 = u8.Inventories[u8.Primary];
        if v33 then
            for _, v34 in v33.Storages do
                for _, v35 in v34.Sections do
                    for _, v36 in v35 do
                        v32 = v32 + v36:GetWeight();
                    end;
                end;
            end;
        end;
        local v37 = u31;
        local v38 = math.max(v32 - 15000) / 10000;
        v37._weightMulti = 1 - math.clamp(v38, 0, 1) * 0.3;
    end;
    u31._inventory = u8.OnInterfaceStateChanged:Connect(v39);
    u31._controls = u5:Connect({
        Jump = function(p40, p41) --[[ Name: Jump, Line 257 ]]
            -- upvalues: u31 (copy), u27 (copy), u5 (ref), u4 (ref), u18 (ref)
            u31._up = p40;
            if u27.Frozen then
            elseif u31.IsGrounded and not (u31.IsSwimming or (u31._emoting or (u5.PauseOpen or u5.RadialOpen and p41))) and not (u5.InventoryOpen or (u31.Goal or u4.SLOW_WALKING)) then
                if u18[u31.HeightState].NO_SPECIAL or u27.Downed then
                else
                    if p40 and u31:_exhaust(0.5) then
                        u31:Jump();
                    end;
                end;
            end;
        end,
        Crouch = function(p42, p43) --[[ Name: Crouch, Line 273 ]]
            -- upvalues: u31 (copy), u5 (ref), u18 (ref), u27 (copy), u2 (ref)
            if u31.IsGrounded and not (u31.IsSwimming or (u31._emoting or (u5.PauseOpen or u5.RadialOpen and p43))) and not (u5.InventoryOpen or u31.Goal) then
                if u18[u31.HeightState].NO_SPECIAL or u27.Downed then
                elseif u31.HeightState == u2.CharacterHeightState.Crouching and u27.CurrentState.Dragging then
                else
                    if p43 then
                        if p42 then
                            u31._holdingForProne = tick();
                            return;
                        end;
                        if u31.HeightState == u2.CharacterHeightState.Crouching then
                            u31._holdingForProne = nil;
                            u31:SetHeightState(u2.CharacterHeightState.Standing);
                            return;
                        end;
                        if u31.HeightState == u2.CharacterHeightState.Standing then
                            u31._holdingForProne = nil;
                            u31:SetHeightState(u2.CharacterHeightState.Crouching);
                            return;
                        end;
                        if u31._holdingForProne then
                            u31._holdingForProne = nil;
                            u31:SetHeightState(u2.CharacterHeightState.Crouching);
                        end;
                    elseif p42 then
                        if u31.HeightState == u2.CharacterHeightState.Crouching then
                            u31:SetHeightState(u2.CharacterHeightState.Standing);
                            return;
                        end;
                        u31:SetHeightState(u2.CharacterHeightState.Crouching);
                    end;
                end;
            end;
        end,
        Prone = function(p44, p45) --[[ Name: Prone, Line 305 ]]
            -- upvalues: u31 (copy), u5 (ref), u18 (ref), u27 (copy), u2 (ref)
            if u31.IsGrounded and not (u31.IsSwimming or (u31._emoting or (u5.PauseOpen or u5.RadialOpen and p45))) and not (u5.InventoryOpen or u31.Goal) then
                if u18[u31.HeightState].NO_SPECIAL or u27.Downed then
                elseif u31.HeightState == u2.CharacterHeightState.Proning and u27.CurrentState.Dragging then
                else
                    if p44 then
                        if u31.HeightState == u2.CharacterHeightState.Proning then
                            u31:SetHeightState(u2.CharacterHeightState.Standing);
                            return;
                        end;
                        u31:SetHeightState(u2.CharacterHeightState.Proning);
                    end;
                end;
            end;
        end,
        Sprint = function(p46, p47) --[[ Name: Sprint, Line 324 ]]
            -- upvalues: u27 (copy), u4 (ref), u31 (copy), u16 (ref), u5 (ref), u18 (ref), u2 (ref)
            if u27.Frozen then
            elseif u4.NO_SPRINT then
                u31._shiftKeyDown = false;
                u31.TrySprinting = false;
            else
                if u16.SprintHold == 2 or u5.Touch then
                    if not p46 then
                        return;
                    end;
                    p46 = not u31._shiftKeyDown;
                end;
                u31._shiftKeyDown = p46;
                if p46 then
                    if not u31.IsGrounded or (u31.IsSwimming or (u31._emoting or (u5.PauseOpen or u5.RadialOpen and p47))) or (u5.InventoryOpen or u31.Goal) then
                        return;
                    end;
                    if u18[u31.HeightState].NO_SPECIAL or u27.Downed then
                        return;
                    end;
                    u31:SetHeightState(u2.CharacterHeightState.Standing);
                    if u31.HeightState == u2.CharacterHeightState.Standing then
                        u31.TrySprinting = p46;
                    end;
                else
                    u31.TrySprinting = p46;
                end;
            end;
        end
    });
    u5:ToggleMouseInputMovement(false);
    u5.RappelOpen = false;
    u10:Enable();
    v39();
    return u31;
end;
function u19.SetVehicleGoal(p48, p49, p50, p51) --[[ Line: 375 ]]
    -- upvalues: u9 (copy), u3 (copy), u2 (copy), u10 (copy)
    local v52 = u9:GetSeatAttachment(p49, p50);
    if v52 then
        p48.Goal = {
            SetOrientation = true,
            Goal = v52,
            Offset = p51,
            Timeout = tick() + 1.5,
            Failed = function() --[[ Name: Failed, Line 389 ]]
                -- upvalues: u3 (ref)
                u3:FireServer("ActivateInteract", "Goal");
            end,
            Callback = function() --[[ Name: Callback, Line 395 ]]
                -- upvalues: u3 (ref)
                u3:FireServer("ActivateInteract", "Goal");
            end
        };
        p48:SetHeightState(u2.CharacterHeightState.Standing);
        u10:Disable();
    else
        u3:FireServer("ActivateInteract", "Cancel");
    end;
end;
function u19.SetGoal(u53, p54) --[[ Line: 408 ]]
    -- upvalues: u3 (copy), u10 (copy), u2 (copy)
    u53.Goal = {
        Goal = nil,
        Offset = p54,
        Timeout = tick() + 3,
        Failed = function() --[[ Name: Failed, Line 413 ]]
            -- upvalues: u3 (ref), u10 (ref), u53 (copy)
            u3:FireServer("ActivateInteract", "Cancel");
            u10:Enable();
            u53.Goal = nil;
        end,
        Callback = function() --[[ Name: Callback, Line 418 ]]
            -- upvalues: u3 (ref)
            u3:FireServer("ActivateInteract", "Goal");
        end
    };
    u53:SetHeightState(u2.CharacterHeightState.Standing);
    u10:Disable();
end;
function u19.SetCFrame(p55, p56, p57, p58) --[[ Line: 429 ]]
    -- upvalues: u10 (copy), u2 (copy)
    if p56 then
        u10:Disable();
        p55._localActor.Forced = true;
    else
        u10:Enable();
        p55._localActor.Forced = false;
    end;
    p55._localActor.Locked = p57;
    if not p58 then
        p55:SetHeightState(u2.CharacterHeightState.Standing);
    end;
    p55._forceCFrame = p56;
end;
function u19.Jump(u59) --[[ Line: 445 ]]
    -- upvalues: u2 (copy), u4 (copy), l__CurrentCamera__1 (copy), u3 (copy)
    if u59.IsGrounded and u59.HeightState == u2.CharacterHeightState.Standing then
        local l___localActor__3 = u59._localActor;
        local l___position__4 = u59._position;
        local v60 = true;
        if not u4.NO_VAULT then
            local l__LookVector__5 = l___localActor__3.CFrame.LookVector;
            local l__Unit__6 = Vector3.new(l__LookVector__5.X, 0, l__LookVector__5.Z).Unit;
            local u61 = workspace:Raycast(l___position__4, l__Unit__6 * 2.5, u59._params);
            if u61 == nil then
                local l__LookVector__7 = l__CurrentCamera__1.CFrame.LookVector;
                l__Unit__6 = Vector3.new(l__LookVector__7.X, 0, l__LookVector__7.Z).Unit;
                u61 = workspace:Raycast(l___position__4, l__Unit__6 * 2.5, u59._params);
            end;
            if u61 and u61.Instance then
                local v62 = workspace:Spherecast(l___position__4, 0.5, Vector3.new(0, 8, 0), u59._params);
                local v63 = l___position__4 + Vector3.new(0, 8, 0);
                if v62 and v62.Position then
                    v63 = v62.Position - Vector3.new(0, 0.1, 0);
                end;
                local v64 = l__Unit__6 * ((u61.Position - l___position__4).Magnitude + 1);
                if workspace:Raycast(v63, v64, u59._params) == nil then
                    local u65 = workspace:Spherecast(v63 + v64 + Vector3.new(0, 1.5, 0), 1.5, Vector3.new(0, -8, 0), u59._params);
                    if u65 then
                        local v66 = RaycastParams.new();
                        v66.CollisionGroup = u2.PhysicsGroup.CharacterCast;
                        v66.FilterType = u2.RaycastFilterType.Exclude;
                        v66.FilterDescendantsInstances = { l__CurrentCamera__1, u65.Instance };
                        v66.IgnoreWater = true;
                        if workspace:Spherecast(u65.Position - Vector3.new(0, 1.5, 0), 1.5, Vector3.new(0, 6, 0), v66) == nil then
                            local v67 = u65.Position.Y - (u59._position.Y - 3.075);
                            if v67 >= 3.5 then
                                local v69 = l___localActor__3:Vault(v67, function() --[[ Line: 493 ]]
                                    -- upvalues: u59 (copy), u2 (ref), u65 (copy), u61 (ref), l___localActor__3 (copy)
                                    u59:SetHeightState(u2.CharacterHeightState.Vaulting);
                                    u59._position = u65.Position + Vector3.new(0, 3, 0);
                                    local _, v68 = CFrame.lookAt(Vector3.new(), -u61.Normal):ToOrientation();
                                    l___localActor__3.SimulatedPosition = u59._position;
                                    if v68 == v68 then
                                        l___localActor__3.Orientation = v68;
                                    end;
                                end);
                                task.delay(v69, function() --[[ Line: 505 ]]
                                    -- upvalues: u59 (copy), u2 (ref)
                                    u59:SetHeightState(u2.CharacterHeightState.Standing);
                                end);
                                v60 = false;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        if v60 then
            l___localActor__3:Jump();
            u3:FireServer("DoJump");
            u59.VelocityGravity = 25;
        end;
    end;
end;
function u19.Slide(p70) --[[ Line: 522 ]]
    if p70.IsGrounded and (p70.IsSprinting and p70.MoveSpeed > 13) then
        p70.MoveSpeed = p70.MoveSpeed * 1.55;
        p70.IsSliding = true;
        p70._localActor:Slide();
    end;
end;
function u19.SetHeightState(p71, p72) --[[ Line: 531 ]]
    -- upvalues: u18 (copy), u2 (copy)
    local l__HeightState__8 = p71.HeightState;
    local v73 = u18[l__HeightState__8];
    local v74 = u18[p72];
    if p71.IsSliding then
    elseif v74.HEIGHT > v73.HEIGHT and not p71:CanStand(v74.HEIGHT) then
    else
        if p72 == u2.CharacterHeightState.Proning or l__HeightState__8 == u2.CharacterHeightState.Proning then
            p71._localActor.ProneDelay = tick() + 0.3;
        end;
        if p72 == u2.CharacterHeightState.Crouching and l__HeightState__8 == u2.CharacterHeightState.Standing then
            p71:Slide();
        end;
        if p72 == u2.CharacterHeightState.Standing then
            if p71._shiftKeyDown then
                p71.IsSprinting = true;
            end;
        else
            p71.IsSprinting = false;
        end;
        p71.HeightState = p72;
        p71._localActor.HeightState = p72;
    end;
end;
function u19.CanStand(p75, p76) --[[ Line: 563 ]]
    local v77 = Vector3.new(0, (p76 - p75._hullHeight) / 2, 0);
    local _, v78 = p75:_getCeilingCollisions(p75._position + v77, p76);
    return not v78;
end;
function u19._getCollisions(p79, p80, p81) --[[ Line: 574 ]]
    local v82 = p81 or p79._position;
    local l___hullHeight__9 = p79._hullHeight;
    local v83 = math.max(l___hullHeight__9 / 2, 1.5);
    local v84 = 0;
    local v85 = nil;
    local v86 = nil;
    local v87 = (l___hullHeight__9 - 3) / 1;
    local v88 = v86;
    local v89 = v85;
    local v90 = v84;
    for v91 = 1, 2 do
        local v92 = p80.Y + (v83 - 1.5 - (v91 - 1) * v87);
        local v93 = Vector3.new(v82.X, v92, v82.Z);
        local v94 = Vector3.new(p80.X, v92, p80.Z) - v93;
        local l__Unit__10 = v94.Unit;
        local l__Magnitude__11 = v94.Magnitude;
        if l__Magnitude__11 ~= 0 and l__Magnitude__11 == l__Magnitude__11 then
            local v95 = math.min(0.05 + l__Magnitude__11, 1023);
            local v96 = l__Unit__10 * v95;
            local v97 = workspace:Spherecast(v93, 1.5, v96, p79._params);
            if v97 then
                local v98 = v95 - v97.Distance;
                local v99 = -l__Unit__10 * v98;
                if v90 < v98 then
                    v84 = v98;
                    v85 = v99;
                    v86 = v97;
                    v88 = v86;
                    v89 = v85;
                    v90 = v84;
                end;
            end;
            local v100 = CFrame.new(Vector3.new(0, 0, 0), v96);
            local l__LookVector__12 = (v100 * CFrame.Angles(0, -0.13962634015954636, 0)).LookVector;
            local l__LookVector__13 = (v100 * CFrame.Angles(0, 0.13962634015954636, 0)).LookVector;
            local v101 = l__LookVector__12 * v95;
            local v102 = l__LookVector__13 * v95;
            local v103 = workspace:Spherecast(v93, 1.5, v101, p79._params);
            local v104 = workspace:Spherecast(v93, 1.5, v102, p79._params);
            if v103 then
                local v105 = v95 - v103.Distance;
                local v106 = -l__LookVector__12 * v105;
                if v90 < v105 then
                    v84 = v105;
                    v85 = v106;
                    v86 = v103;
                    v88 = v86;
                    v89 = v85;
                    v90 = v84;
                end;
            end;
            if v104 then
                local v107 = v95 - v104.Distance;
                local v108 = -l__LookVector__13 * v107;
                if v90 < v107 then
                    v84 = v107;
                    v85 = v108;
                    v86 = v104;
                    v88 = v86;
                    v89 = v85;
                    v90 = v84;
                end;
            end;
        end;
    end;
    local v109 = Vector3.new(v82.X, p80.Y, v82.Z);
    local v110 = p80 - v109;
    local l__Unit__14 = v110.Unit;
    local l__Magnitude__15 = v110.Magnitude;
    if l__Magnitude__15 ~= 0 and l__Magnitude__15 == l__Magnitude__15 then
        local l___cylinder__16 = p79._cylinder;
        l___cylinder__16.CFrame = CFrame.new(v109, v109 + Vector3.new(0, 1, 0)) * CFrame.Angles(0, 1.5707963267948966, 0);
        l___cylinder__16.Size = Vector3.new(l___hullHeight__9 - 3, 3, 3);
        local v111 = math.min(0.05 + l__Magnitude__15, 1023);
        local v112 = l__Unit__14 * v111;
        local v113 = workspace:Shapecast(l___cylinder__16, v112, p79._params);
        if v113 then
            local v114 = v111 - v113.Distance;
            local v115 = -l__Unit__14 * v114;
            if v90 < v114 then
                v84 = v114;
                v85 = v115;
                v86 = v113;
                v88 = v86;
                v89 = v85;
                v90 = v84;
            end;
        end;
        local v116 = CFrame.new(Vector3.new(0, 0, 0), v112);
        local l__LookVector__17 = (v116 * CFrame.Angles(0, -0.13962634015954636, 0)).LookVector;
        local l__LookVector__18 = (v116 * CFrame.Angles(0, 0.13962634015954636, 0)).LookVector;
        local v117 = l__LookVector__17 * v111;
        local v118 = l__LookVector__18 * v111;
        local v119 = workspace:Shapecast(l___cylinder__16, v117, p79._params);
        local v120 = workspace:Shapecast(l___cylinder__16, v118, p79._params);
        if v119 then
            local v121 = v111 - v119.Distance;
            local v122 = -l__LookVector__17 * v121;
            if v90 < v121 then
                v84 = v121;
                v85 = v122;
                v86 = v119;
                v88 = v86;
                v89 = v85;
                v90 = v84;
            end;
        end;
        if v120 then
            local v123 = v111 - v120.Distance;
            local v124 = -l__LookVector__18 * v123;
            if v90 < v123 then
                v84 = v123;
                v85 = v124;
                v86 = v120;
                v88 = v86;
                v89 = v85;
            end;
        end;
    end;
    return v89, v88;
end;
function u19._keepPointOnRadiusChange(_, p125, p126) --[[ Line: 705 ]]
    local v127 = math.sqrt(p125.X * p125.X + p125.Z * p125.Z) / p126;
    local v128 = math.acos(v127);
    return math.sin(v128) * p126 - p125.Y;
end;
function u19._inclusiveSpherecast(_, p129, p130, p131, p132, p133, p134) --[[ Line: 712 ]]
    -- upvalues: u14 (copy)
    local l__Unit__19 = p131.Unit;
    local v135 = p129 + p131;
    local v136 = p129 - l__Unit__19 * p130;
    local v137 = 0;
    while true do
        local v138 = workspace:Spherecast(v136, p130, v135 - v136, p132);
        if p134 then
            u14:MarkLocation(v136, v138 and Color3.new(0, 1, 0) or Color3.new(1, 0, 0), p130 * 2, 0.9, 0.008333333333333333);
            u14:MarkLocation(v135, v138 and Color3.new(0, 0.5, 0) or Color3.new(0.5, 0, 0), p130 * 2, 0.9, 0.008333333333333333);
        end;
        if not v138 then
            return v138;
        end;
        local l__Position__20 = v138.Position;
        local v139 = v135 - p129;
        local v140 = l__Position__20 - p129;
        local l__Magnitude__21 = v139.Magnitude;
        local l__Unit__22 = v139.Unit;
        local v141 = v140:Dot(l__Unit__22);
        local v142;
        if v141 <= 0 then
            v142 = p129;
        elseif l__Magnitude__21 <= v141 then
            v142 = v135;
        else
            v142 = p129 + l__Unit__22 * v141;
        end;
        local v143 = (l__Position__20 - v142).Magnitude <= p130;
        if p133 then
            if v143 then
                local l__Position__23 = v138.Position;
                v143 = (l__Position__23 - p129):Cross(l__Position__23 - v135).Magnitude / (v135 - p129).Magnitude <= p130 + p133;
            end;
        end;
        if p134 then
            u14:MarkLocation(v138.Position, v143 and Color3.new(0, 1, 0) or Color3.new(1, 0, 0), nil, 0.9, 0.008333333333333333);
        end;
        local v144 = v137 + v138.Distance;
        if v143 then
            return setmetatable({
                Distance = v144
            }, {
                __index = v138
            });
        end;
        v137 = v144 + 0.001;
        v136 = v136 + (v138.Distance + 0.001) * l__Unit__19;
    end;
end;
function u19._getFeetCollisions(p145, p146, p147, p148) --[[ Line: 765 ]]
    local v149 = 1.55 + (p147 or 0);
    local v150 = math.max(p145._hullHeight / 2, v149);
    local v151 = p146 + Vector3.new(0, v150 - v149, 0);
    local v152 = p146 + Vector3.new(0, -v150 + v149 - 0.15, 0) - v151;
    local v153 = p145:_inclusiveSpherecast(v151, v149, v152, p145._params, nil, p148);
    local v154;
    if v153 then
        v154 = -v152.Unit * math.max(v152.Magnitude + v149 - 0.15 - v153.Distance, 0);
    else
        v154 = nil;
    end;
    return v154, v153;
end;
function u19._getCeilingCollisions(p155, p156, p157) --[[ Line: 790 ]]
    local v158 = math.max((p157 or p155._hullHeight) / 2, 1.55);
    local v159 = p156 + Vector3.new(0, -v158 + 1.55, 0);
    local v160 = p156 + Vector3.new(0, v158 - 1.55 + 0.15, 0) - v159;
    local v161 = p155:_inclusiveSpherecast(v159, 1.55, v160, p155._params, -0.09);
    local v162;
    if v161 then
        v162 = -v160.Unit * math.max(v160.Magnitude + 1.55 - v161.Distance, 0);
    else
        v162 = nil;
    end;
    return v162, v161;
end;
function u19._isThickEnoughToClimb(p163, p164, p165) --[[ Line: 814 ]]
    local v166 = p163._hullHeight / 2;
    local v167 = math.max(v166, 1.55) - 1.55;
    local v168 = p164 + Vector3.new(0, v167, 0) + Vector3.new(0, -p165.Distance + 1.55, 0);
    local v169 = p163:_keepPointOnRadiusChange(p165.Position - v168, 2.05) + 0.1;
    local v170 = v168 - Vector3.new(0, v169, 0);
    local v171 = math.max(v166, 1.46) - 1.46 + 0.15;
    local v172 = p164 + Vector3.new(0, v171, 0) - v170;
    return not workspace:Spherecast(v170, 2.05, v172, p163._params);
end;
function u19._lerpHull(p173, p174) --[[ Line: 845 ]]
    -- upvalues: u18 (copy)
    local l__HEIGHT__24 = u18[p173.HeightState].HEIGHT;
    local l___hullHeight__25 = p173._hullHeight;
    local v175 = math.sign(l__HEIGHT__24 - l___hullHeight__25);
    local v176 = l___hullHeight__25 + v175 * p174 * 10;
    if v175 > 0 then
        l___hullHeight__25 = math.min(v176, l__HEIGHT__24);
    elseif v175 < 0 then
        l___hullHeight__25 = math.max(v176, l__HEIGHT__24);
    end;
    local v177 = l___hullHeight__25 - p173._hullHeight;
    p173._hullHeight = l___hullHeight__25;
    return v177;
end;
function u19._processNewPosition(p178, p179) --[[ Line: 866 ]]
    -- upvalues: u9 (copy)
    local v180, v181 = p178:_getFeetCollisions(p179, nil, false);
    local v182;
    if v181 and v180.Magnitude <= 1.5 then
        local v183 = math.acos(v181.Normal.Y);
        if math.deg(v183 ~= v183 and 1 or v183) <= 60 then
            v182 = p179 + v180;
            local l__Position__26 = v181.Position;
            local v184 = p179 - Vector3.new(0, 1, 0);
            local v185 = p179 + Vector3.new(0, 1, 0);
            local v186 = (l__Position__26 - v184):Cross(l__Position__26 - v185).Magnitude / (v185 - v184).Magnitude;
            local v187 = math.acos(v186 / 1.55);
            local v188 = 1 - math.sin(v187);
            local v189 = Vector3.new(0, v188, 0);
            local l__Unit__27 = ((v181.Position - p179) * Vector3.new(1, 0, 1)).Unit;
            local v190 = v182 + v189 - l__Unit__27 * (1.55 - v186);
            local _, v191 = p178:_getCollisions(v190 + l__Unit__27 * 1.55, v190 - l__Unit__27 * ((p178._position - p179) * Vector3.new(1, 0, 1)).Magnitude);
            if v191 then
                local v192 = math.asin((v191.Position - v181.Position).Unit.Y);
                if math.deg(v192) > 60 then
                    v182 = v182 - v180;
                end;
            end;
        else
            v182 = p179;
        end;
    else
        v182 = p179;
    end;
    local v193 = false;
    for v194 = 1, 10 do
        local v195, v196 = p178:_getCollisions(v182);
        if not v196 then
            v193 = v194 == 1 and true or v193;
            break;
        end;
        if v194 == 10 then
            v182 = p178._position;
        else
            local l__Normal__28 = v196.Normal;
            local v197 = math.acos(l__Normal__28.Y);
            if math.deg(v197 ~= v197 and 1 or v197) > 60 or l__Normal__28.Y < 0 then
                v182 = v182 + Vector3.new(0, v195.Y, 0);
                l__Normal__28 = Vector3.new(l__Normal__28.X, 0, l__Normal__28.Z).Unit;
            end;
            local v198 = v195:Dot(l__Normal__28);
            if v194 <= 5 then
                v182 = v182 + math.abs(v198) * l__Normal__28;
            else
                v182 = v182 + v195;
            end;
        end;
    end;
    local v199, v200 = p178:_getCeilingCollisions(v182);
    if v200 then
        local l__Normal__29 = v200.Normal;
        v182 = v182 + v199:Dot(l__Normal__29) * l__Normal__29;
        p178.VelocityGravity = math.min(p178.VelocityGravity, 0);
    end;
    local v201 = false;
    local v202 = Vector3.new(0, 1, 0);
    local v203 = nil;
    for _ = 1, 2 do
        local v204, v205 = p178:_getFeetCollisions(v182, -0.05, false);
        if not v205 then
            break;
        end;
        v202 = v205.Normal;
        local v206 = math.acos(v202.Y);
        local v207 = math.deg(v206 ~= v206 and 1 or v206);
        v203 = u9:QueryHitbox(v205.Instance);
        v182 = v182 + v204:Dot(v202) * v202;
        if v207 <= 60 then
            v201 = true;
            break;
        end;
        v202 = Vector3.new(0, 1, 0);
    end;
    local l___cylinder__30 = p178._cylinder;
    l___cylinder__30.CFrame = CFrame.new(p178._position, p178._position + Vector3.new(0, 1, 0)) * CFrame.Angles(0, 1.5707963267948966, 0);
    l___cylinder__30.Size = Vector3.new(p178._hullHeight - 3, 3, 3);
    if workspace:Shapecast(l___cylinder__30, v182 - p178._position, p178._params) then
        return p178._lastSafePosition, true, Vector3.new(0, 1, 0);
    end;
    if v201 and v193 then
        p178._lastSafePosition = v182;
    end;
    return v182, v201, v202, v203;
end;
function u19._decelerate(p208, p209) --[[ Line: 1006 ]]
    -- upvalues: u18 (copy)
    p208.MoveSpeed = math.max(p208.MoveSpeed - (p208.IsSliding and 3.5 or (u18[p208.HeightState].DECELERATION or 60)) * p208.MoveSpeed * p209, 0);
end;
function u19._accelerate(p210, p211, p212) --[[ Line: 1015 ]]
    -- upvalues: u4 (copy), u15 (copy), u18 (copy)
    local v213 = p210.IsSprinting and 1.4 or 1;
    local l___localActor__31 = p210._localActor;
    local v214 = l___localActor__31.CQB and 0.7 or 1;
    if u4.SLOW_WALKING then
        v214 = v214 * 0.45;
    end;
    local v215 = 1;
    local l__LocalClient__32 = u15.LocalClient;
    if l__LocalClient__32 then
        if l__LocalClient__32.Thirst:getValue() <= 0 then
            v215 = v215 * 0.8;
        end;
        if l__LocalClient__32.Hunger:getValue() <= 0 then
            v215 = v215 * 0.8;
        end;
    end;
    local v216 = 1;
    if l___localActor__31.HitSlowness then
        if tick() < l___localActor__31.HitSlowness then
            v216 = 0.5;
        else
            l___localActor__31.HitSlowness = nil;
        end;
    end;
    local v217 = math.max(l___localActor__31.Weight - 5500) / 10000;
    local v218 = 1 - math.clamp(v217, 0, 1) * 0.2;
    local v219 = 12 * v213 * (u18[p210.HeightState].SPEED_MULT * v214 * p210._weightMulti * v218 * v215) * ((l___localActor__31.Downed and 0 or 1) * (l___localActor__31.CurrentState.Dragging and 0.75 or 1)) * v216;
    if l___localActor__31.SpeedPenalty then
        v219 = v219 * l___localActor__31.SpeedPenalty;
    end;
    local v220 = v219 * math.min(p212, 1);
    if v220 == 0 then
        p210.MoveSpeed = 0;
    else
        local v221 = math.clamp((v220 - p210.MoveSpeed) / v220, 0, 1);
        p210.MoveSpeed = math.min(p210.MoveSpeed + (u18[p210.HeightState].ACCELERATION or 50) * v221 * p211, v220);
    end;
end;
function u19._processMovementInput(p222, p223, p224) --[[ Line: 1070 ]]
    -- upvalues: l__CurrentCamera__1 (copy), u2 (copy)
    local l__LookVector__33 = l__CurrentCamera__1.CFrame.LookVector;
    local v225 = math.atan2(-l__LookVector__33.X, -l__LookVector__33.Z);
    local l__Magnitude__34 = p223.Magnitude;
    local v226;
    if p222.IsSwimming or p222.IsGrounded and not p222.IsSliding or (p222.HeightState == u2.CharacterHeightState.Skydiving or p222.HeightState == u2.CharacterHeightState.Parachuting) then
        p222._groundedInputDirection = p223;
        local l__Goal__35 = p222.Goal;
        if not l__Goal__35 then
            if l__Magnitude__34 == 0 then
                p222:_decelerate(p224);
                return Vector3.new(0, 0, 0);
            end;
            local l__Unit__36 = Vector3.new(p223.X, 0, p223.Y).Unit;
            if p222.HeightState == u2.CharacterHeightState.Parachuting then
                p222.ParachuteDirection = p222.ParachuteDirection or Vector2.new(-l__LookVector__33.X, -l__LookVector__33.Z);
                v225 = math.atan2(p222.ParachuteDirection.X, p222.ParachuteDirection.Y);
            else
                p222.ParachuteDirection = nil;
            end;
            local l__LookVector__37 = (CFrame.lookAt(Vector3.new(0, 0, 0), l__Unit__36, Vector3.new(0, 1, 0)) * CFrame.Angles(0, v225, 0)).LookVector;
            local l__Unit__38 = (l__LookVector__37 - l__LookVector__37:Dot(p222.SlopeNormal) * p222.SlopeNormal).Unit;
            p222:_accelerate(p224, l__Magnitude__34);
            return l__Unit__38;
        end;
        local v227 = l__Goal__35.Goal and l__Goal__35.Goal.WorldCFrame:ToWorldSpace(l__Goal__35.Offset) or l__Goal__35.Offset;
        local v228 = v227.Position - p222._localActor.CFrame.Position;
        local v229 = Vector3.new(v228.X, 0, v228.Z);
        v226 = v229.Unit;
        if l__Goal__35.SetOrientation and v228.Magnitude < 3 then
            local _, v230 = v227:ToOrientation();
            p222._localActor.GoalOrientation = v230;
        end;
        if v229.Magnitude > 0.2 then
            p222:_accelerate(p224, (math.min(1, v229.Magnitude)));
        else
            if not l__Goal__35.Reached then
                l__Goal__35.Reached = true;
                l__Goal__35.Callback();
            end;
            p222:_decelerate(p224);
            v226 = Vector3.new(0, 0, 0);
        end;
        if tick() > l__Goal__35.Timeout and not l__Goal__35.Reached then
            l__Goal__35.Reached = true;
            l__Goal__35.Failed();
            return v226;
        end;
    else
        local l___groundedInputDirection__39 = p222._groundedInputDirection;
        if l___groundedInputDirection__39.Magnitude == 0 then
            p222._groundedInputDirection = p223;
            l___groundedInputDirection__39 = p223;
        end;
        if l___groundedInputDirection__39.Magnitude == 0 then
            return Vector3.new(0, 0, 0);
        end;
        local l__Unit__40 = Vector3.new(l___groundedInputDirection__39.X, 0, l___groundedInputDirection__39.Y).Unit;
        local l__LookVector__41 = (CFrame.lookAt(Vector3.new(0, 0, 0), l__Unit__40, Vector3.new(0, 1, 0)) * CFrame.Angles(0, v225, 0)).LookVector;
        v226 = (l__LookVector__41 - l__LookVector__41:Dot(p222.SlopeNormal) * p222.SlopeNormal).Unit;
        if l__Magnitude__34 > 0 then
            local v231 = Vector3.new(p223.X, 0, p223.Y).Unit * math.min(1, l__Magnitude__34);
            local l__LookVector__42 = (CFrame.lookAt(Vector3.new(0, 0, 0), v231, Vector3.new(0, 1, 0)) * CFrame.Angles(0, v225, 0)).LookVector;
            local v232 = v226:Cross(Vector3.new(0, 1, 0));
            local v233 = (l__LookVector__42 - l__LookVector__42:Dot(v232) * v232):Dot(v226);
            if p222.IsSliding then
                p222:_decelerate(p224 * (v226.Y + 1) * math.max(-v233 + 1, 1) * 0.35);
                return v226;
            end;
            if v233 < 0 then
                p222:_decelerate(p224 * math.abs(v233));
                return v226;
            end;
            if v233 > 0 then
                p222:_accelerate(p224 * v233, 1);
                return v226;
            end;
        elseif p222.IsSliding then
            p222:_decelerate(p224 * (v226.Y + 1) * 0.35);
        end;
    end;
    return v226;
end;
function u19.Teleport(p234, p235) --[[ Line: 1178 ]]
    local l___localActor__43 = p234._localActor;
    local _, v236 = p235:ToOrientation();
    p234._position = p235.Position;
    p234._groundHitbox = nil;
    l___localActor__43.ForceNextPosition = p235.Position;
    l___localActor__43.SimulatedPosition = p235.Position;
    l___localActor__43.Orientation = v236;
    l___localActor__43.Platform = nil;
    p234.VelocityGravity = 0;
    p234.MoveSpeed = 0;
end;
function u19.Update(p237, p238, p239) --[[ Line: 1193 ]]
    -- upvalues: u6 (copy), u4 (copy), u11 (copy), u2 (copy), u3 (copy), u17 (copy), u18 (copy), u16 (copy), u12 (copy), u13 (copy), l__Gravity__2 (copy)
    local v240 = tick();
    u6.UpdateStamina((math.clamp((v240 - p237._exhaustStart) / (p237._exhausted - p237._exhaustStart), 0, 1)));
    if p237._startPhysics then
        if workspace:Raycast(p237._position, Vector3.new(0, -4, 0), p237._params) or p237._startPhysics < v240 then
            p237._startPhysics = nil;
        end;
    elseif u4.FREEZE_PLAYERS then
    else
        local l___localActor__44 = p237._localActor;
        if l___localActor__44.CurrentState.Dragged then
            local v241 = u11.Actors[l___localActor__44.CurrentState.Dragged];
            if v241 then
                local l__Position__45 = v241.Position;
                if not p237._lastDrag or (l__Position__45 - p237._lastDrag).Magnitude > 0.1 then
                    p237._lastDrag = l__Position__45;
                    local v242 = Vector3.new(p237._position.X, l__Position__45.Y, p237._position.Z);
                    local v243 = CFrame.new(l__Position__45, v242);
                    local v244 = v243.Position + v243.LookVector * 6;
                    local v245 = workspace:Raycast(v244, Vector3.new(0, -6, 0), p237._params);
                    if v245 then
                        v244 = v244 + Vector3.new(0, -v244.Y + v245.Position.Y + 3, 0);
                    end;
                    local _, v246 = v243:ToOrientation();
                    p237._position = v244;
                    l___localActor__44.SimulatedPosition = v244;
                    l___localActor__44.Orientation = v246;
                end;
            end;
        else
            p237._lastDrag = nil;
            if l___localActor__44.Rappelling then
                p237._position = l___localActor__44.Position;
            elseif p237._forceCFrame then
                local v247 = l___localActor__44.CFrame:Lerp(p237._forceCFrame, p239 * 5);
                local _, v248 = v247:ToOrientation();
                p237._position = v247.Position;
                l___localActor__44.SimulatedPosition = v247.Position;
                l___localActor__44.Orientation = v248;
            else
                if l___localActor__44.Frozen then
                    p238 = Vector2.new();
                end;
                local l__Ladder__46 = l___localActor__44.Ladder;
                if l__Ladder__46 and (l__Ladder__46:IsDescendantOf(workspace) and not l___localActor__44.Downed) then
                    if p237.HeightState ~= u2.CharacterHeightState.Climbing then
                        local v249 = u3;
                        local v250 = "ClimbLadder";
                        local v251 = true;
                        local v252;
                        if l__Ladder__46.Material == u2.Material.Wood then
                            v252 = false;
                        else
                            v252 = l__Ladder__46.Material ~= u2.Material.WoodPlanks;
                        end;
                        v249:FireServer(v250, v251, v252);
                        p237:SetHeightState(u2.CharacterHeightState.Climbing);
                    end;
                    local l__CFrame__47 = l__Ladder__46.CFrame;
                    local v253 = l__Ladder__46.Size.Y / 2;
                    if not p237._ladder then
                        p237._ladder = (l__CFrame__47:PointToWorldSpace((Vector3.new(0, -v253, -1.5))) - p237._position).Magnitude / (v253 * 2);
                        p237._ladderTimer = v240;
                    end;
                    local v254 = -p238.Y * p239 / v253 * 2.5;
                    local v255 = v254 / (v253 * 2);
                    if v254 > 0 then
                        v254 = workspace:Raycast(p237._position, Vector3.new(0, v255 + 3, 0), p237._params) and 0 or v254;
                        if p237._ladder == 1 then
                            l___localActor__44.Ladder = nil;
                            l___localActor__44:Vault(3);
                            task.delay(1, p237.SetHeightState, p237, u2.CharacterHeightState.Standing);
                            p237._ladderNextFrame = l__CFrame__47:PointToWorldSpace((Vector3.new(0, v253, 0.5))) + Vector3.new(0, 3, 0);
                            p237._ladderTimer = 0;
                        end;
                    elseif v254 < 0 and workspace:Raycast(p237._position, Vector3.new(0, -(v255 + 3), 0), p237._params) then
                        l___localActor__44.Ladder = nil;
                        v254 = 0;
                    end;
                    p237._ladder = math.clamp(p237._ladder + v254, 0, 1);
                    p237._position = p237._position:Lerp(l__CFrame__47:PointToWorldSpace((Vector3.new(0, -v253, -1.5))):Lerp(l__CFrame__47:PointToWorldSpace((Vector3.new(0, v253, -1.5))), p237._ladder), (math.clamp(v240 - p237._ladderTimer, 0, 1)));
                    local _, v256 = CFrame.lookAt(p237._position, l__CFrame__47.Position):ToOrientation();
                    l___localActor__44.SimulatedPosition = p237._position;
                    l___localActor__44.Orientation = v256;
                    p237._lastSafePosition = p237._position;
                    p237.VelocityGravity = 0;
                    p237.IsSliding = false;
                    p237._groundHitbox = nil;
                    l___localActor__44.Platform = nil;
                    l___localActor__44.Sprinting = false;
                else
                    if p237._ladder then
                        if p237._ladderNextFrame then
                            p237:SetHeightState(u2.CharacterHeightState.Vaulting);
                            p237._position = p237._ladderNextFrame;
                            l___localActor__44.SimulatedPosition = p237._position;
                            p237._lastSafePosition = p237._position;
                            p237._ladderNextFrame = nil;
                        else
                            p237:SetHeightState(u2.CharacterHeightState.Standing);
                        end;
                        l___localActor__44.Ladder = nil;
                        u3:FireServer("ClimbLadder", false);
                        p237._ladderTimer = nil;
                        p237._ladder = nil;
                    end;
                    local v257 = -100;
                    if p237.HeightState == u2.CharacterHeightState.Parachuting then
                        p238 = Vector2.new(p238.X, -1);
                        if p237.ParachuteDirection then
                            p237.ParachuteDirection = p237.ParachuteDirection:Lerp(Vector2.new(-l___localActor__44.CFrame.LookVector.X, -l___localActor__44.CFrame.LookVector.Z), p239);
                        end;
                        v257 = math.abs(p237._lastMovement.X) * 20 + -50;
                    elseif p237.HeightState == u2.CharacterHeightState.Skydiving then
                        v257 = v257 * (p237._lastMovement.Magnitude * 0.3 + 1);
                    end;
                    if p237._holdingForProne and p237._holdingForProne + 0.6 < v240 then
                        p237._holdingForProne = nil;
                        p237:SetHeightState(u2.CharacterHeightState.Proning);
                    end;
                    local v258 = p237._lastMovement:Lerp(p238, (math.clamp(p239 * (l___localActor__44.Sprinting and 3 or (p237.HeightState == u2.CharacterHeightState.Skydiving and 1 or (p237.HeightState == u2.CharacterHeightState.Parachuting and 0.4 or 10))), 0, 1)));
                    local l__Emote__48 = l___localActor__44.CurrentState.Emote;
                    if l__Emote__48 and u17.Emotes[l__Emote__48].Idle then
                        p237._emoting = true;
                        v258 = Vector2.new();
                    else
                        p237._emoting = false;
                    end;
                    local l__TrySprinting__49 = p237.TrySprinting;
                    local l__Dragging__50 = l___localActor__44.CurrentState.Dragging;
                    if v258.Y > -0.5 and l___localActor__44.Focused or (l___localActor__44.ADS or l__Dragging__50) then
                        l__TrySprinting__49 = false;
                    end;
                    p237.IsSprinting = l__TrySprinting__49;
                    if l__Dragging__50 and (p237.HeightState ~= u2.CharacterHeightState.Crouching and p237.HeightState ~= u2.CharacterHeightState.Proning) then
                        p237:SetHeightState(u2.CharacterHeightState.Crouching);
                    end;
                    local v259 = p237:_processMovementInput(v258, p239);
                    local v260 = p237.MoveSpeed * p239 * v259;
                    if p237.IsSliding and p237.MoveSpeed <= u18[u2.CharacterHeightState.Crouching].SPEED_MULT * 12 then
                        p237.IsSliding = false;
                        if p237.IsSprinting and u16.StandAfterSlide == 2 then
                            p237:SetHeightState(u2.CharacterHeightState.Standing);
                        end;
                    end;
                    local l__Swimming__51 = l___localActor__44.Swimming;
                    local v261 = u12.Lerp(p237._swimDirection, p237._shiftKeyDown and -1 or (p237._up and 1 or 0), p239);
                    if l__Swimming__51 then
                        local l__Water__52 = u13.World.Water;
                        local v262 = l__Water__52.Depth - l__Water__52.Height + 4;
                        local v263 = workspace:Raycast(p237._position, Vector3.new(0, l__Water__52.Depth, 0), p237._params);
                        if v263 then
                            v262 = -(p237._position - v263.Position).Magnitude - math.max(0, l__Water__52.Height - p237._position.Y) + 4;
                        end;
                        p237._swimLevel = p237._position.Y - l___localActor__44.WaterLevel;
                        if p237._shiftKeyDown or p237._up then
                            p237._releaseSwimLevel = nil;
                        else
                            p237._releaseSwimLevel = p237._releaseSwimLevel or p237._swimLevel;
                        end;
                        if p237._swimLevel < v262 then
                            local v264 = math.clamp((v262 - p237._swimLevel) * 2, 0, 1);
                            v261 = math.max(v264, v261);
                        elseif p237._swimLevel > 0 then
                            local v265 = math.clamp(-p237._swimLevel * 2, -1, 1);
                            v261 = math.min(v265, v261);
                        elseif p237._swimLevel > -3 and p237._releaseSwimLevel then
                            v261 = math.clamp((p237._releaseSwimLevel - p237._swimLevel) * 2, -1, 1);
                        end;
                        p237.IsSliding = false;
                        p237.IsSprinting = false;
                        p237.TrySprinting = false;
                        p237.VelocityGravity = u12.Lerp(p237.VelocityGravity, v261 * 5, (math.min(p239 * 15, 1)));
                        if p237.HeightState ~= u2.CharacterHeightState.Swimming then
                            p237:SetHeightState(u2.CharacterHeightState.Swimming);
                        end;
                    elseif p237.HeightState == u2.CharacterHeightState.Swimming then
                        p237:SetHeightState(u2.CharacterHeightState.Standing);
                    end;
                    p237._swimDirection = v261;
                    local v266 = p237:_lerpHull(p239);
                    local v267 = Vector3.new(v260.X, p237.VelocityGravity * p239 + v260.Y + v266 / 2, v260.Z);
                    local l___groundHitbox__53 = p237._groundHitbox;
                    if l___groundHitbox__53 then
                        p237._position = l___groundHitbox__53.CFrame:PointToWorldSpace(p237._position);
                    end;
                    local v268 = p237._position + v267;
                    local v269, v270, v271, v272 = p237:_processNewPosition(v268);
                    if l__Swimming__51 then
                        if v270 and l___localActor__44.WaterLevel < v269.Y + 0.2 then
                            l___localActor__44.Swimming = false;
                        end;
                    else
                        if v270 or p237.HeightState == u2.CharacterHeightState.Vaulting then
                            p237.VelocityGravity = 0;
                            if p237.HeightState == u2.CharacterHeightState.Falling or (p237.HeightState == u2.CharacterHeightState.Skydiving or p237.HeightState == u2.CharacterHeightState.Parachuting) then
                                p237.HeightState = u2.CharacterHeightState.Standing;
                                l___localActor__44.HeightState = u2.CharacterHeightState.Standing;
                            end;
                        else
                            local l__VelocityGravity__54 = p237.VelocityGravity;
                            local v273;
                            if l__VelocityGravity__54 < v257 then
                                v273 = u12.Lerp(l__VelocityGravity__54, v257, p239 * 2);
                            else
                                v273 = math.max(l__VelocityGravity__54 - l__Gravity__2 * p239, v257);
                            end;
                            p237.VelocityGravity = v273;
                            p237.IsSliding = false;
                            if not l___localActor__44.Downed and (p237.HeightState ~= u2.CharacterHeightState.Parachuting or v269 ~= v268) then
                                if p237.VelocityGravity < -80 and u4.CAN_PARACHUTE then
                                    p237.HeightState = u2.CharacterHeightState.Skydiving;
                                    l___localActor__44.HeightState = u2.CharacterHeightState.Skydiving;
                                    if l___localActor__44.CurrentState.Emote then
                                        u3:FireServer("SetEmote", nil);
                                    end;
                                elseif p237.VelocityGravity < -10 then
                                    p237.HeightState = u2.CharacterHeightState.Falling;
                                    l___localActor__44.HeightState = u2.CharacterHeightState.Falling;
                                end;
                            end;
                        end;
                        p237._swimLevel = 0;
                    end;
                    if l___localActor__44.Downed then
                        p237.HeightState = u2.CharacterHeightState.Standing;
                        l___localActor__44.HeightState = u2.CharacterHeightState.Standing;
                    end;
                    p237.SlopeNormal = v271;
                    p237.IsGrounded = v270;
                    p237.IsSwimming = l__Swimming__51;
                    if p237.HeightState == u2.CharacterHeightState.Skydiving then
                        if not p237._parachuteControls and u4.CAN_PARACHUTE then
                            p237:_makeParachuteControls();
                        end;
                    elseif p237._parachuteControls then
                        p237._parachuteControls:Disconnect();
                        p237._parachuteControls = nil;
                    end;
                    if l___localActor__44.Downed then
                        if not p237._downedControls then
                            p237:_makeDownedControls();
                        end;
                    elseif p237._downedControls then
                        p237._downedControls:Disconnect();
                        p237._downedControls = nil;
                    end;
                    if v272 then
                        p237._position = v272.CFrame:PointToObjectSpace(v269);
                        p237._correctedPosition = v269;
                        p237._groundHitbox = v272;
                        l___localActor__44.Platform = v272.UID;
                    else
                        p237._position = v269;
                        p237._groundHitbox = nil;
                        l___localActor__44.Platform = nil;
                    end;
                    l___localActor__44.Grounded = p237.IsGrounded;
                    l___localActor__44.Sliding = p237.IsSliding;
                    l___localActor__44.Sprinting = p237.IsSprinting;
                    l___localActor__44.SimulatedPosition = p237._position;
                    p237._lastMovement = v258;
                end;
            end;
        end;
    end;
end;
function u19.Destroy(p274) --[[ Line: 1511 ]]
    -- upvalues: u6 (copy), u10 (copy), u2 (copy), u3 (copy)
    u6.UpdateStamina(0);
    u6.UpdateBleeding(false);
    u10:Disable();
    p274._controls:Disconnect();
    if p274._parachuteControls then
        p274._parachuteControls:Disconnect();
    end;
    if p274._downedControls then
        p274._downedControls:Disconnect();
    end;
    p274._inventory:Disconnect();
    p274._cylinder:Destroy();
    local l___localActor__55 = p274._localActor;
    l___localActor__55.LastHeightState = l___localActor__55.HeightState;
    l___localActor__55.HeightState = u2.CharacterHeightState.Standing;
    l___localActor__55.Sprinting = false;
    l___localActor__55.Forced = false;
    l___localActor__55.Grounded = true;
    l___localActor__55.GoalOrientation = nil;
    if p274._ladder then
        u3:FireServer("ClimbLadder", false);
        p274._ladder = nil;
    end;
    if l___localActor__55.Platform then
        l___localActor__55.Platform = nil;
        l___localActor__55.SimulatedPosition = p274._correctedPosition;
    end;
end;
return u19;