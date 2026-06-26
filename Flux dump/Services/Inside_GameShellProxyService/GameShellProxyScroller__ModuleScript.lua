-- Services.GameShellProxyService.GameShellProxyScroller
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local u3 = v1("InputService");
local u4 = v1("RoactTween");
v1("Mathf");
game:GetService("ProximityPromptService");
local l__UserInputService__1 = game:GetService("UserInputService");
local l__RunService__2 = game:GetService("RunService");
local l__GuiService__3 = game:GetService("GuiService");
local l__CurrentCamera__4 = workspace.CurrentCamera;
local u5 = v1("GameShellProxyButton");
local u6 = v1("GameShellProxyService");
local v7 = u2.Component:extend("Scroller");
function v7.init(u8, p9) --[[ Line: 18 ]]
    -- upvalues: u4 (copy), u2 (copy), l__CurrentCamera__4 (copy), l__RunService__2 (copy), l__UserInputService__1 (copy), l__GuiService__3 (copy), u3 (copy), u6 (copy)
    local l__RequiresFocus__5 = p9.RequiresFocus;
    u8.Hover = u4.new(0);
    local u10, u11 = u2.createBinding(0);
    u8.Scroll = u10;
    u8.Ref = p9.Ref or u2.createRef();
    u8.ContentRef = u2.createRef();
    u8.MouseDownPosition = Vector2.new();
    u8.MouseDown = false;
    u8.CanvasSize = 0;
    u8.Fade = 0.08;
    local l__Callback__6 = p9.Callback;
    local u12 = 0;
    local u13 = 0;
    function u8.GoBackToTop() --[[ Line: 52 ]]
        -- upvalues: u13 (ref)
        u13 = 0;
    end;
    u8.Connection = l__RunService__2.RenderStepped:Connect(function(p14) --[[ Line: 56 ]]
        -- upvalues: l__UserInputService__1 (ref), u8 (copy), l__GuiService__3 (ref), u13 (ref), u12 (ref), u3 (ref), l__CurrentCamera__4 (ref), u10 (copy), u11 (copy), l__Callback__6 (copy)
        local v15 = l__UserInputService__1:GetMouseLocation();
        local v16 = u8.Ref:getValue();
        local l__AbsoluteSize__7 = v16.AbsoluteSize;
        local v17 = v16.AbsolutePosition + l__GuiService__3:GetGuiInset();
        local v18 = math.max(1, u8.CanvasSize);
        local v19 = v18 - 1;
        if u8.MouseDown then
            u13 = math.clamp(u13 + (v15.Y - u8.MouseDownPosition.Y) / l__AbsoluteSize__7.Y * (v18 - 1), 0, v19);
            u8.MouseDownPosition = v15;
        end;
        local v20 = u12;
        local l__VirtualCursorPosition__8 = u3.VirtualCursorPosition;
        if l__VirtualCursorPosition__8 and (l__VirtualCursorPosition__8.X > v17.X and (l__VirtualCursorPosition__8.X < v17.X + l__AbsoluteSize__7.X and (l__VirtualCursorPosition__8.Y > v17.Y and l__VirtualCursorPosition__8.Y < v17.Y + l__AbsoluteSize__7.Y))) then
            v20 = l__VirtualCursorPosition__8.Y > v17.Y + l__AbsoluteSize__7.Y - l__AbsoluteSize__7.Y / 10 and 2 or (l__VirtualCursorPosition__8.Y < v17.Y + l__AbsoluteSize__7.Y / 10 and -2 or v20);
        end;
        if v19 < u13 then
            u13 = v19;
        end;
        if math.abs(v20) > 0 then
            local v21 = v20 * p14;
            local v22 = u8.Ref:getValue();
            if v22 then
                local l__AbsoluteSize__9 = v22.AbsoluteSize;
                local v23 = math.max(1, u8.CanvasSize) - 1;
                u13 = math.clamp(u13 + v21 * (l__AbsoluteSize__9.Y / l__CurrentCamera__4.ViewportSize.Y / 2), 0, v23);
            end;
        end;
        local v24 = u10:getValue();
        local v25 = math.lerp(v24, u13, p14 * 15);
        u11(v25);
        if l__Callback__6 then
            l__Callback__6(v25);
        end;
    end);
    u8.Input = l__UserInputService__1.InputChanged:Connect(function(p26) --[[ Line: 101 ]]
        -- upvalues: l__RequiresFocus__5 (copy), u8 (copy), u12 (ref), l__CurrentCamera__4 (ref), u13 (ref)
        if l__RequiresFocus__5 and not u8.Focused then
            u12 = 0;
        else
            if p26.UserInputType == Enum.UserInputType.MouseWheel then
                if not u8.ContentRef:getValue() then
                    return;
                end;
                local v27 = -p26.Position.Z;
                if v27 > 0 then
                    local v28 = 1;
                    local v29 = u8.Ref:getValue();
                    if v29 then
                        local l__AbsoluteSize__10 = v29.AbsoluteSize;
                        local v30 = math.max(1, u8.CanvasSize) - 1;
                        u13 = math.clamp(u13 + v28 * (l__AbsoluteSize__10.Y / l__CurrentCamera__4.ViewportSize.Y / 2), 0, v30);
                        return;
                    else
                        return;
                    end;
                end;
                if v27 < 0 then
                    local v31 = -1;
                    local v32 = u8.Ref:getValue();
                    if v32 then
                        local l__AbsoluteSize__11 = v32.AbsoluteSize;
                        local v33 = math.max(1, u8.CanvasSize) - 1;
                        u13 = math.clamp(u13 + v31 * (l__AbsoluteSize__11.Y / l__CurrentCamera__4.ViewportSize.Y / 2), 0, v33);
                    end;
                end;
            elseif p26.UserInputType.Name:sub(1, 7) == "Gamepad" and p26.KeyCode == Enum.KeyCode.Thumbstick2 then
                local l__Y__12 = p26.Position.Y;
                if math.abs(l__Y__12) > 0.2 then
                    u12 = -l__Y__12 * 2;
                    return;
                end;
                u12 = 0;
            end;
        end;
    end);
    u8.Touch = l__UserInputService__1.TouchMoved:Connect(function(p34) --[[ Line: 131 ]]
        -- upvalues: l__RequiresFocus__5 (copy), u8 (copy), l__CurrentCamera__4 (ref), u13 (ref)
        if l__RequiresFocus__5 and not u8.Focused then
        else
            local v35 = -p34.Delta.Y / 4;
            local v36 = u8.Ref:getValue();
            if v36 then
                local l__AbsoluteSize__13 = v36.AbsoluteSize;
                local v37 = math.max(1, u8.CanvasSize) - 1;
                u13 = math.clamp(u13 + v35 * (l__AbsoluteSize__13.Y / l__CurrentCamera__4.ViewportSize.Y / 2), 0, v37);
            end;
        end;
    end);
    u8.Mouse = l__UserInputService__1.InputEnded:Connect(function(p38) --[[ Line: 139 ]]
        -- upvalues: u8 (copy)
        if p38.UserInputType == Enum.UserInputType.MouseButton1 then
            u8.MouseDown = false;
        end;
    end);
    u6:RegisterScroller(u8);
end;
function v7.willUnmount(p39) --[[ Line: 148 ]]
    -- upvalues: u6 (copy)
    p39.Connection:Disconnect();
    p39.Touch:Disconnect();
    p39.Input:Disconnect();
    p39.Mouse:Disconnect();
    u6:UnregisterScroller(p39);
end;
function v7.render(u40) --[[ Line: 156 ]]
    -- upvalues: u2 (copy), u5 (copy), l__UserInputService__1 (copy)
    local l__props__14 = u40.props;
    if l__props__14.BackToTop then
        u40.GoBackToTop();
    end;
    local l__Content__15 = l__props__14.Content;
    local v41 = l__props__14.CanvasSize or 1;
    local u42 = l__props__14.ScrollingSize or (v41 > 1 and 0.01 or 0);
    local u43 = l__props__14.ScrollingColor or Color3.fromRGB(255, 148, 17);
    local l__RequiresFocus__16 = l__props__14.RequiresFocus;
    local l__OffsetBinding__17 = l__props__14.OffsetBinding;
    local l__NoGradient__18 = l__props__14.NoGradient;
    local v44 = l__props__14.Children or {};
    local l__Ignore__19 = l__props__14.Ignore;
    l__props__14.Callback = nil;
    l__props__14.ScrollingColor = nil;
    l__props__14.ScrollingSize = nil;
    l__props__14.OffsetBinding = nil;
    l__props__14.CanvasSize = nil;
    l__props__14.Content = nil;
    l__props__14.Children = nil;
    l__props__14.NoGradient = nil;
    l__props__14.Ignore = true;
    l__props__14.Ref = nil;
    l__props__14.BackToTop = nil;
    l__props__14.RequiresFocus = nil;
    u40.Fade = l__props__14.Fade or u40.Fade;
    l__props__14.Fade = nil;
    local v45 = type(v41) == "table";
    if v45 then
        u40.CanvasSize = v41:getValue();
    else
        u40.CanvasSize = v41;
    end;
    if l__RequiresFocus__16 then
        l__props__14.Selectable = true;
        l__props__14[u2.Event.SelectionGained] = function() --[[ Line: 203 ]]
            -- upvalues: u40 (copy)
            u40.Focused = true;
        end;
        l__props__14[u2.Event.SelectionLost] = function() --[[ Line: 206 ]]
            -- upvalues: u40 (copy)
            u40.Focused = false;
        end;
        l__props__14[u2.Event.MouseEnter] = function() --[[ Line: 209 ]]
            -- upvalues: u40 (copy)
            u40.Focused = true;
        end;
        l__props__14[u2.Event.MouseLeave] = function() --[[ Line: 212 ]]
            -- upvalues: u40 (copy)
            u40.Focused = false;
        end;
    else
        u40.Focused = true;
        l__props__14.Selectable = false;
    end;
    l__props__14.Ref = u40.Ref;
    local l__createElement__20 = u2.createElement;
    local v46 = u5;
    local v47 = {};
    local l__createElement__21 = u2.createElement;
    local v48 = l__NoGradient__18 and "Frame" or "CanvasGroup";
    local v49 = {
        BackgroundTransparency = 1,
        ZIndex = 2,
        ClipsDescendants = true,
        Size = UDim2.new(1, 0, 1, 0)
    };
    local v50 = {};
    local v51 = not l__NoGradient__18;
    if v51 then
        v51 = u2.createElement("UIGradient", {
            Rotation = 90,
            Transparency = u40.Scroll:map(function(p52) --[[ Line: 231 ]]
                -- upvalues: u40 (copy)
                local v53 = u40.ContentRef:getValue();
                local v54 = u40.Ref:getValue();
                if not (v54 and v53) then
                    return NumberSequence.new(0);
                end;
                local v55 = v54.AbsoluteSize.Y / v53.AbsoluteSize.Y;
                local v56 = u40.Fade * v55;
                if p52 < 0.0001 then
                    return NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1 - u40.Fade, 0), NumberSequenceKeypoint.new(1, 1) });
                end;
                if p52 > 0.9999 then
                    return NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(u40.Fade, 0), NumberSequenceKeypoint.new(1, 0) });
                end;
                local v57 = math.min(v56, p52) / v55;
                local v58 = 1 - math.min(v56, 1 - p52) / v55;
                local v59 = v57 ~= v57 and 0.1 or v57;
                local v60 = v58 ~= v58 and 0.9 or v58;
                return NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(v59, 0),
                    NumberSequenceKeypoint.new(v60, 0),
                    NumberSequenceKeypoint.new(1, 1)
                });
            end)
        });
    end;
    v50[1] = v51;
    v50.Content = u2.createElement("Frame", {
        [u2.Ref] = u40.ContentRef,
        BackgroundTransparency = 1,
        Size = v45 and v41:map(function(p61) --[[ Line: 278 ]]
            return UDim2.fromScale(1, p61);
        end) or UDim2.fromScale(1, v41),
        Position = u40.Scroll:map(function(p62) --[[ Line: 281 ]]
            return UDim2.fromScale(0, -p62);
        end)
    }, l__Content__15);
    v47[1] = l__createElement__21(v48, v49, v50);
    v47.Bar = u2.createElement(u5, {
        BorderSizePixel = 0,
        ZIndex = 100,
        Offset = l__OffsetBinding__17,
        Visible = v45 and v41:map(function(p63) --[[ Line: 291 ]]
            return p63 > 1;
        end) or v41 > 1,
        Size = v45 and v41:map(function(p64) --[[ Line: 294 ]]
            -- upvalues: u40 (copy), u42 (copy)
            u40.CanvasSize = p64;
            return UDim2.fromScale(u42, 1 / p64);
        end) or UDim2.fromScale(u42, 1 / v41),
        Position = u40.Scroll:map(function(p65) --[[ Line: 298 ]]
            -- upvalues: u42 (copy), u40 (copy)
            return UDim2.fromScale(1 - u42, p65 / (u40.CanvasSize - 1));
        end),
        AnchorPoint = u40.Scroll:map(function(p66) --[[ Line: 301 ]]
            -- upvalues: u40 (copy)
            return Vector2.new(0, p66 / (u40.CanvasSize - 1));
        end),
        BackgroundColor3 = u40.Hover:Map(function(p67) --[[ Line: 304 ]]
            -- upvalues: u43 (copy)
            return Color3.new(1, 1, 1):Lerp(u43, p67);
        end),
        Ignore = l__Ignore__19 or u42 == 0,
        MouseEnter = function() --[[ Name: MouseEnter, Line 311 ]]
            -- upvalues: u40 (copy)
            u40.Hover:SetGoal(1);
        end,
        MouseLeave = function() --[[ Name: MouseLeave, Line 314 ]]
            -- upvalues: u40 (copy)
            u40.Hover:SetGoal(0);
        end,
        MouseDown = function() --[[ Name: MouseDown, Line 317 ]]
            -- upvalues: u40 (copy), l__UserInputService__1 (ref)
            u40.MouseDownPosition = l__UserInputService__1:GetMouseLocation();
            u40.MouseDown = true;
        end,
        MouseUp = function() --[[ Name: MouseUp, Line 321 ]]
            -- upvalues: u40 (copy)
            u40.MouseDown = false;
        end
    });
    v47[2] = u2.createFragment(v44);
    return l__createElement__20(v46, l__props__14, v47);
end;
return v7;