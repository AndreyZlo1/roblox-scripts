-- Services.InputService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3 = shared.import("require", "signal", "Roact");
local u4 = v1("InputBinds");
local u5 = v1("GameSettings");
local l__UserGameSettings__1 = UserSettings():GetService("UserGameSettings");
local l__UserInputService__2 = game:GetService("UserInputService");
local l__HapticService__3 = game:GetService("HapticService");
local l__GuiService__4 = game:GetService("GuiService");
local l__CurrentCamera__5 = workspace.CurrentCamera;
local u6 = UDim2.fromScale(0.5, 0);
local u7 = UDim2.fromScale(1, 1);
local u8 = {};
u8.__index = u8;
function u8._touch(p9) --[[ Line: 51 ]]
    if not p9.Touch then
        p9.Touch = true;
        p9.TouchInput:Fire(true);
    end;
    if p9.Gamepad then
        p9.Gamepad = false;
        p9.GamepadInput:Fire(false);
    end;
end;
function u8._handle(p10, p11, p12, p13) --[[ Line: 62 ]]
    -- upvalues: u4 (copy)
    if p12.UserInputType.Name:sub(1, 7) == "Gamepad" then
        if p10.Touch then
            p10.Touch = false;
            p10.TouchInput:Fire(false);
        end;
        if not p10.Gamepad then
            p10.Gamepad = p12.UserInputType;
            p10.GamepadInput:Fire(true);
        end;
    elseif p12.UserInputType == Enum.UserInputType.Keyboard then
        if p10.Touch then
            p10.Touch = false;
            p10.TouchInput:Fire(false);
        end;
        if p10.Gamepad then
            p10.Gamepad = false;
            p10.GamepadInput:Fire(false);
        end;
    end;
    local v14 = {};
    for v15, v16 in p10._mounts do
        v14[v15] = v16;
    end;
    for v17, v18 in v14 do
        local v19 = u4[v17];
        if v19 and (not p13 or v19.IgnoreProcessed) then
            local v20 = p10.Overrides[v17] or v19;
            if not p10.RGE or (v19.RGE or not p11) then
                if v20.GamepadButton and (p12.KeyCode == v20.GamepadButton and p12.UserInputType.Name:sub(1, 7) == "Gamepad") then
                    task.spawn(v18, p11, true, false);
                elseif p12.UserInputType == v20.InputType and p12.KeyCode == v20.KeyCode then
                    task.spawn(v18, p11, false, false);
                end;
            end;
        end;
    end;
    if p13 then
    elseif p12.KeyCode == Enum.KeyCode.W then
        p10._inputMovement = Vector2.new(p10._inputMovement.X, p11 and -1 or (p10._inputMovement.Y < 0 and 0 or p10._inputMovement.Y));
    elseif p12.KeyCode == Enum.KeyCode.S then
        p10._inputMovement = Vector2.new(p10._inputMovement.X, p11 and 1 or (p10._inputMovement.Y > 0 and 0 or p10._inputMovement.Y));
    elseif p12.KeyCode == Enum.KeyCode.A then
        p10._inputMovement = Vector2.new(p11 and -1 or (p10._inputMovement.X < 0 and 0 or p10._inputMovement.X), p10._inputMovement.Y);
    else
        if p12.KeyCode == Enum.KeyCode.D then
            p10._inputMovement = Vector2.new(p11 and 1 or (p10._inputMovement.X > 0 and 0 or p10._inputMovement.X), p10._inputMovement.Y);
        end;
    end;
end;
function u8.new() --[[ Line: 121 ]]
    -- upvalues: l__GuiService__4 (copy), l__UserInputService__2 (copy), u3 (copy), u2 (copy), u8 (copy), u5 (copy)
    local v21 = RaycastParams.new();
    v21.IgnoreWater = false;
    local v22 = l__GuiService__4:IsTenFootInterface();
    local l__TouchEnabled__6 = l__UserInputService__2.TouchEnabled;
    local v23, v24 = u3.createBinding(Vector2.new(-100, -100));
    local v25 = {
        _mouseMovement = Vector3.new(0, 0, 0),
        _mouseInputMovementEnabled = false,
        _zoomTouch = 0,
        PauseOpen = false,
        RadialOpen = false,
        TabletOpen = false,
        DebugOpen = false,
        FingersTouching = 0,
        _params = v21,
        _mounts = {},
        _updateVirtualCursor = v24,
        _inputMovement = Vector2.zero,
        _mouseInputMovementSum = Vector2.zero,
        _mouseMovementMultiplier = Vector2.one,
        _cameraTouchExtents = {},
        _cameraTouch = Vector2.zero,
        _movementTouch = Vector2.zero,
        VirtualCursorBinding = v23,
        Touch = l__TouchEnabled__6
    };
    local v26 = v22 and not l__TouchEnabled__6;
    if v26 then
        v26 = Enum.UserInputType.Gamepad1;
    end;
    v25.Gamepad = v26;
    v25.AimAssist = {};
    v25.Overrides = {};
    v25.Binds = {};
    v25.Connected = u2.new();
    v25.Disconnected = u2.new();
    v25.TouchInput = u2.new();
    v25.GamepadInput = u2.new();
    v25.BindingsChanged = u2.new();
    local u27 = setmetatable(v25, u8);
    l__UserInputService__2.TouchPinch:Connect(function(p28, _, p29, _, _) --[[ Line: 170 ]]
        -- upvalues: u27 (copy)
        u27:_touch();
        for v30 = 1, #p28 do
            if not u27:IsTouchInBounds(p28[v30]) then
                return;
            end;
        end;
        u27._zoomTouch = p29 / 5;
    end);
    l__UserInputService__2.TouchTap:Connect(function() --[[ Line: 181 ]]
        -- upvalues: u27 (copy)
        u27:_touch();
    end);
    l__UserInputService__2.TouchStarted:Connect(function(_) --[[ Line: 185 ]]
        -- upvalues: u27 (copy)
        local v31 = u27;
        v31.FingersTouching = v31.FingersTouching + 1;
    end);
    l__UserInputService__2.TouchEnded:Connect(function(p32) --[[ Line: 189 ]]
        -- upvalues: u27 (copy)
        local v33 = u27;
        v33.FingersTouching = v33.FingersTouching - 1;
        u27:_touch();
        if not u27:IsTouchInBounds(p32.Position) then
            u27._movementTouch = Vector2.zero;
            u27._movementStart = nil;
        end;
    end);
    l__UserInputService__2.TouchMoved:Connect(function(p34) --[[ Line: 200 ]]
        -- upvalues: u27 (copy)
        u27:_touch();
        if u27.InventoryOpen or u27.PauseOpen then
        else
            local l__Delta__7 = p34.Delta;
            local l__Position__8 = p34.Position;
            if u27:IsTouchInBounds(l__Position__8) then
                u27._cameraTouch = Vector2.new(l__Delta__7.X, l__Delta__7.Y) / 100;
            else
                if not u27._movementStart then
                    u27._movementStart = Vector2.new(l__Position__8.X, l__Position__8.Y);
                end;
                u27._movementTouch = Vector2.new(l__Position__8.X, l__Position__8.Y);
            end;
        end;
    end);
    l__UserInputService__2.InputBegan:Connect(function(p35, p36) --[[ Line: 228 ]]
        -- upvalues: u27 (copy)
        u27:_handle(true, p35, p36);
    end);
    l__UserInputService__2.InputEnded:Connect(function(p37, p38) --[[ Line: 232 ]]
        -- upvalues: u27 (copy)
        u27:_handle(false, p37, p38);
    end);
    l__UserInputService__2.InputChanged:Connect(function(p39) --[[ Line: 236 ]]
        -- upvalues: u27 (copy), u5 (ref)
        if p39.UserInputType == Enum.UserInputType.MouseMovement then
            u27._mouseMovement = Vector3.new(p39.Delta.X, p39.Delta.Y, u27._mouseMovement.Z);
            if u27.Gamepad then
                u27.Gamepad = false;
                u27.GamepadInput:Fire(false);
            end;
        else
            if p39.UserInputType == Enum.UserInputType.MouseWheel then
                u27._mouseMovement = Vector3.new(u27._mouseMovement.X, u27._mouseMovement.Y, p39.Position.Z);
                return;
            end;
            if p39.UserInputType.Name:sub(1, 7) == "Gamepad" and (p39.KeyCode == Enum.KeyCode.Thumbstick1 or p39.KeyCode == Enum.KeyCode.Thumbstick2) then
                local v40 = u5[p39.KeyCode.Name .. "DeadZone"] or 0.2;
                if (v40 < math.abs(p39.Position.X) or v40 < math.abs(p39.Position.Y)) and not u27.Gamepad then
                    u27.Gamepad = p39.UserInputType;
                    u27.GamepadInput:Fire(true);
                end;
            end;
        end;
    end);
    return u27;
end;
function u8.TouchBind(p41, p42, p43) --[[ Line: 261 ]]
    if p41._mounts[p42] then
        p41._mounts[p42](p43, false, true);
    end;
end;
function u8.IsTouchInBounds(p44, p45) --[[ Line: 267 ]]
    -- upvalues: u6 (copy), u7 (copy), l__CurrentCamera__5 (copy)
    local v46 = p44._cameraTouchExtents[1] or u6;
    local v47 = p44._cameraTouchExtents[2] or u7;
    local l__ViewportSize__9 = l__CurrentCamera__5.ViewportSize;
    local v48 = v46.X.Scale * l__ViewportSize__9.X + v46.X.Offset;
    local v49 = v46.Y.Scale * l__ViewportSize__9.Y + v46.Y.Offset;
    local v50 = v47.X.Scale * l__ViewportSize__9.X + v47.X.Offset;
    local v51 = v47.Y.Scale * l__ViewportSize__9.Y + v47.Y.Offset;
    local v52;
    if v48 <= p45.X and (p45.X <= v50 and v49 <= p45.Y) then
        v52 = p45.Y <= v51;
    else
        v52 = false;
    end;
    return v52;
end;
function u8.SetCameraTouchExtents(p53, p54, p55) --[[ Line: 278 ]]
    p53._cameraTouchExtents = { p54 or false, p55 or false };
end;
function u8.IsMouseInputMovement(p56) --[[ Line: 282 ]]
    return p56._mouseInputMovementEnabled;
end;
function u8.ToggleMouseInputMovement(p57, p58) --[[ Line: 285 ]]
    p57._mouseInputMovementEnabled = p58;
end;
function u8.ResetMouseInputMovement(p59) --[[ Line: 288 ]]
    p59._mouseInputMovementSum = Vector2.zero;
end;
function u8.SetMouseInputMovementMultiplier(p60, p61) --[[ Line: 291 ]]
    p60._mouseMovementMultiplier = p61;
end;
function u8.GetInputMovement(p62) --[[ Line: 295 ]]
    -- upvalues: l__UserInputService__2 (copy), u5 (copy), l__CurrentCamera__5 (copy)
    if p62.Gamepad then
        for _, v63 in l__UserInputService__2:GetGamepadState(p62.Gamepad) do
            if v63.KeyCode == Enum.KeyCode.Thumbstick1 then
                local l__X__10 = v63.Position.X;
                local v64 = -v63.Position.Y;
                local v65 = u5.Thumbstick1DeadZone or 0.2;
                if v65 < math.abs(l__X__10) or v65 < math.abs(v64) then
                    p62._inputMovement = Vector2.new(l__X__10, v64);
                else
                    p62._inputMovement = Vector2.zero;
                end;
            end;
        end;
    end;
    local l___inputMovement__11 = p62._inputMovement;
    if p62.UseVirtualCursor and p62.Gamepad then
        local l__ViewportSize__12 = l__CurrentCamera__5.ViewportSize;
        if not p62.VirtualCursorPosition then
            p62.VirtualCursorPosition = l__ViewportSize__12 / 2;
        end;
        local v66 = p62.VirtualCursorPosition + Vector2.new(l___inputMovement__11.X, l___inputMovement__11.Y) * 10;
        p62.VirtualCursorPosition = Vector2.new(math.clamp(v66.X, 0, l__ViewportSize__12.X), (math.clamp(v66.Y, 0, l__ViewportSize__12.Y)));
        p62._updateVirtualCursor(p62.VirtualCursorPosition);
    elseif p62.VirtualCursorPosition then
        p62.VirtualCursorPosition = nil;
        p62._updateVirtualCursor(Vector2.new(-100, -100));
    end;
    if (p62.PauseOpen or p62.RadialOpen and p62.Gamepad or p62.InventoryOpen and p62.Gamepad) and not p62.RGE then
        return Vector2.zero;
    end;
    local l__zero__13 = Vector2.zero;
    if p62._movementStart then
        l__zero__13 = (p62._movementTouch - p62._movementStart) / 10;
    end;
    if p62._mouseInputMovementEnabled then
        p62._mouseInputMovementSum = Vector2.new(math.clamp(p62._mouseInputMovementSum.X + p62._mouseMovement.X * p62._mouseMovementMultiplier.X, -1, 1), (math.clamp(p62._mouseInputMovementSum.Y + p62._mouseMovement.Y * p62._mouseMovementMultiplier.Y, -1, 1)));
        p62._mouseMovement = Vector3.new(0, 0, p62._mouseMovement.Z);
    else
        p62._mouseInputMovementSum = Vector2.zero;
    end;
    local l___mouseInputMovementSum__14 = p62._mouseInputMovementSum;
    local l__new__15 = Vector2.new;
    local v67 = l___inputMovement__11.X + math.clamp(l__zero__13.X, -1, 1) + l___mouseInputMovementSum__14.X;
    local v68 = math.clamp(v67, -1, 1);
    local v69 = l___inputMovement__11.Y + math.clamp(l__zero__13.Y, -1, 1) + l___mouseInputMovementSum__14.Y;
    return l__new__15(v68, (math.clamp(v69, -1, 1)));
end;
function u8.GetCameraMovement(p70) --[[ Line: 348 ]]
    -- upvalues: l__UserInputService__2 (copy), u5 (copy), l__UserGameSettings__1 (copy), l__CurrentCamera__5 (copy)
    if p70.PauseOpen and not p70.RGE then
        p70._mouseMovement = Vector3.new(0, 0, 0);
        return Vector3.new(0, 0, 0);
    end;
    local l___mouseMovement__16 = p70._mouseMovement;
    if p70.RadialOpen then
        l___mouseMovement__16 = Vector3.new(0, 0, 0);
    elseif p70._mouseInputMovementEnabled then
        l___mouseMovement__16 = Vector3.new(0, 0, l___mouseMovement__16.Z);
        p70._mouseMovement = Vector3.new(p70._mouseMovement.X, p70._mouseMovement.Y, 0);
    else
        p70._mouseMovement = Vector3.new(0, 0, 0);
    end;
    local l__zero__17 = Vector2.zero;
    if p70.Gamepad then
        for _, v71 in l__UserInputService__2:GetGamepadState(p70.Gamepad) do
            if v71.KeyCode == Enum.KeyCode.Thumbstick2 then
                local l__X__18 = v71.Position.X;
                local v72 = -v71.Position.Y;
                local v73 = u5.Thumbstick2DeadZone or 0.2;
                if v73 < math.abs(l__X__18) or v73 < math.abs(v72) then
                    l__zero__17 = Vector2.new(l__X__18, v72);
                end;
            end;
        end;
    end;
    local v74 = (Vector2.new(l___mouseMovement__16.X, l___mouseMovement__16.Y) / 100 * l__UserGameSettings__1.MouseSensitivity + l__zero__17 / 30 * l__UserGameSettings__1.GamepadCameraSensitivity) * (l__CurrentCamera__5.FieldOfView / 70);
    local v75;
    if p70.ADS then
        v75 = v74 * (u5.AimingSensitivity or 1);
    else
        v75 = v74 * (u5.CameraSensitivity or 1);
    end;
    if p70.Gamepad then
        local v76 = l__CurrentCamera__5.ViewportSize / 2;
        local l__Position__19 = l__CurrentCamera__5.CFrame.Position;
        local v77 = false;
        for _, v78 in p70.AimAssist do
            local v79 = l__CurrentCamera__5:WorldToViewportPoint(v78);
            if v79.Z > 0 and ((Vector2.new(v79.X, v79.Y) - v76).Magnitude <= v76.Y * 0.3 and not workspace:Raycast(l__Position__19, v78 - l__Position__19, p70._params)) then
                v77 = true;
                break;
            end;
        end;
        if v77 then
            v75 = v75 * 0.5;
        else
            v75 = v75 * 2;
        end;
    end;
    local l___zoomTouch__20 = p70._zoomTouch;
    local l___cameraTouch__21 = p70._cameraTouch;
    p70._cameraTouch = Vector2.zero;
    p70._zoomTouch = 0;
    local v80 = v75.X + l___cameraTouch__21.X;
    local v81 = v75.Y + l___cameraTouch__21.Y;
    local v82 = math.clamp(l___mouseMovement__16.Z + l___zoomTouch__20, -1, 1);
    return Vector3.new(v80, v81, v82);
end;
function u8.SetHaptic(p83, p84, p85) --[[ Line: 427 ]]
    -- upvalues: l__HapticService__3 (copy)
    local l__Gamepad__22 = p83.Gamepad;
    if l__Gamepad__22 and (l__HapticService__3:IsVibrationSupported(l__Gamepad__22) and l__HapticService__3:IsMotorSupported(l__Gamepad__22, p84)) then
        l__HapticService__3:SetMotor(l__Gamepad__22, p84, (math.clamp(p85 > 0.05 and p85 and p85 or 0, 0, 1)));
    end;
end;
function u8.GetRadialMovement(p86) --[[ Line: 439 ]]
    local l___mouseMovement__23 = p86._mouseMovement;
    local v87 = Vector2.new(l___mouseMovement__23.X, l___mouseMovement__23.Y);
    if p86.Gamepad then
        v87 = v87 + p86._inputMovement * 10;
    end;
    return Vector2.new(v87.X, v87.Y);
end;
function u8.GetBind(p88, p89) --[[ Line: 449 ]]
    -- upvalues: u4 (copy), l__UserInputService__2 (copy)
    local v90 = u4[p89];
    if not v90 then
        return Enum.KeyCode.Unknown, false;
    end;
    local v91 = p88.Overrides[p89] or v90;
    if p88.Gamepad and v90.GamepadButton then
        return {
            Name = l__UserInputService__2:GetStringForKeyCode(v90.GamepadButton),
            Raw = v90.GamepadButton
        }, true;
    end;
    local v92;
    if v91.KeyCode == Enum.KeyCode.Unknown then
        v92 = {
            Name = v91.InputType.Name,
            Raw = v91.InputType
        };
    else
        v92 = {
            Name = v91.KeyCode.Name,
            Raw = v91.KeyCode
        };
    end;
    return v92, false;
end;
function u8.Connect(u93, u94) --[[ Line: 479 ]]
    -- upvalues: u4 (copy)
    local u95 = {};
    for v96, v97 in u94 do
        local v98 = u4[v96];
        if v98 then
            local v99 = u93.Overrides[v96] or v98;
            u95[v96] = {
                Gamepad = v98.GamepadButton,
                Key = v99.KeyCode == Enum.KeyCode.Unknown and v99.InputType or v99.KeyCode,
                Description = v98.Description,
                VisibleOnKeyboard = v98.VisibleOnKeyboard,
                VisibleOnGamepad = v98.VisibleOnGamepad,
                TouchButton = v98.TouchButton
            };
            u93._mounts[v96] = v97;
        end;
    end;
    u93.Binds[u95] = true;
    u93.Connected:Fire(u95);
    return {
        Disconnect = function() --[[ Name: Disconnect, Line 502 ]]
            -- upvalues: u94 (copy), u93 (copy), u95 (copy)
            for v100 in u94 do
                u93._mounts[v100] = nil;
            end;
            u93.Binds[u95] = nil;
            u93.Disconnected:Fire(u95);
        end
    };
end;
return u8.new();