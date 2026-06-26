-- Services.GameShellProxyService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3 = shared.import("require", "Enum", "server");
local l__ContentProvider__1 = game:GetService("ContentProvider");
game:GetService("CollectionService");
local l__GuiService__2 = game:GetService("GuiService");
local l__Players__3 = game:GetService("Players");
local l__UserInputService__4 = game:GetService("UserInputService");
local l__PlayerGui__5 = l__Players__3.LocalPlayer:WaitForChild("PlayerGui");
local u4 = v1("Appearance");
local u5 = v1("InputService");
local u6 = v1("GameShellProxyGlobals");
local u7 = v1("GameShellProxyWorldToScreenPosition");
local l__CurrentCamera__6 = workspace.CurrentCamera;
local u8 = {};
u8.__index = u8;
local function u12(p9, p10) --[[ Line: 69 ]]
    -- upvalues: u5 (copy), l__GuiService__2 (copy)
    local l__Ignore__7 = p9.Ignore;
    if type(l__Ignore__7) == "table" then
        l__Ignore__7 = l__Ignore__7:getValue();
    end;
    if l__Ignore__7 then
        return true;
    end;
    local v11 = p9.Scroller and p9.Scroller:getValue();
    if v11 then
        local l__AbsolutePosition__8 = v11.AbsolutePosition;
        if not u5.Touch then
            l__AbsolutePosition__8 = l__AbsolutePosition__8 + l__GuiService__2:GetGuiInset();
        end;
        local l__AbsoluteSize__9 = v11.AbsoluteSize;
        if p10 and (p10.X < l__AbsolutePosition__8.X or (p10.X > l__AbsolutePosition__8.X + l__AbsoluteSize__9.X or (p10.Y < l__AbsolutePosition__8.Y or p10.Y > l__AbsolutePosition__8.Y + l__AbsoluteSize__9.Y))) then
            return true;
        end;
    end;
    local l__Ref__10 = p9.Ref;
    if l__Ref__10 then
        l__Ref__10 = p9.Ref:getValue();
    end;
    return not l__Ref__10 and true or l__Ref__10.Visible == false;
end;
function u8.new() --[[ Line: 106 ]]
    -- upvalues: l__CurrentCamera__6 (copy), u8 (copy), u5 (copy), u3 (copy), l__UserInputService__4 (copy), u2 (copy), u12 (copy), l__GuiService__2 (copy)
    local u13 = setmetatable({
        Hovering = false,
        UIVisible = true,
        ExtractionUI = false,
        _nextBaseComponent = 0,
        _enabled = true,
        ViewportSize = l__CurrentCamera__6.ViewportSize,
        FrameList = {},
        _scrollbars = {},
        _buttons = {},
        _baseComponentQueue = {}
    }, u8);
    u5:Connect({
        HideHUD = function(p14) --[[ Name: HideHUD, Line 123 ]]
            -- upvalues: u3 (ref), u13 (copy)
            if u3.HUD_DISABLED then
            else
                if p14 then
                    u13.UIVisible = not u13.UIVisible;
                end;
            end;
        end
    });
    l__UserInputService__4.InputBegan:Connect(function(p15, _) --[[ Line: 137 ]]
        -- upvalues: u2 (ref), u13 (copy), u5 (ref), l__UserInputService__4 (ref), u12 (ref), l__GuiService__2 (ref)
        if p15.UserInputType == u2.UserInputType.MouseButton1 or p15.UserInputType.Name:sub(1, 7) == "Gamepad" and p15.KeyCode == u2.KeyCode.ButtonA then
            for _, v16 in u13._buttons do
                if v16.Hovering then
                    local v17 = v16.Props.Ref:getValue();
                    if v17 then
                        v16.MouseDown = true;
                        local l__zero__11 = Vector2.zero;
                        if v16.Props.Offset then
                            l__zero__11 = l__zero__11 + v16.Props.Offset:getValue();
                        end;
                        local v18 = u5.VirtualCursorPosition or l__UserInputService__4:GetMouseLocation();
                        local l__AbsoluteSize__12 = v17.AbsoluteSize;
                        local v19 = v17.AbsolutePosition + l__zero__11;
                        if v16.Props.MouseDown then
                            v16.Props.MouseDown(v17, Vector2.new((v18.X - v19.X) / l__AbsoluteSize__12.X, (v18.Y - v19.Y) / l__AbsoluteSize__12.Y));
                        end;
                    end;
                end;
            end;
        elseif p15.UserInputType == u2.UserInputType.Touch then
            local l__Position__13 = p15.Position;
            for _, v20 in u13._buttons do
                if not u12(v20.Props, l__Position__13) then
                    local v21 = v20.Props.Ref:getValue();
                    if v21 then
                        local l__zero__14 = Vector2.zero;
                        if v20.Props.Offset then
                            l__zero__14 = l__zero__14 + v20.Props.Offset:getValue();
                        end;
                        local l__AbsoluteSize__15 = v21.AbsoluteSize;
                        local v22 = v21.AbsolutePosition + l__zero__14;
                        if l__Position__13.X > v22.X and (l__Position__13.X < v22.X + l__AbsoluteSize__15.X and (l__Position__13.Y > v22.Y and l__Position__13.Y < v22.Y + l__AbsoluteSize__15.Y)) then
                            v20.MouseDown = true;
                            if v20.Props.MouseDown then
                                v20.Props.MouseDown(v21, Vector2.new((l__Position__13.X - v22.X) / l__AbsoluteSize__15.X, (l__Position__13.Y - v22.Y) / l__AbsoluteSize__15.Y));
                            end;
                        end;
                    end;
                end;
            end;
        else
            if p15.UserInputType.Name:sub(1, 7) == "Gamepad" then
                if u5.VirtualCursorPosition then
                    return;
                end;
                local v23 = nil;
                if p15.KeyCode == u2.KeyCode.DPadLeft then
                    v23 = Vector2.new(-1, 0);
                elseif p15.KeyCode == u2.KeyCode.DPadRight then
                    v23 = Vector2.new(1, 0);
                elseif p15.KeyCode == u2.KeyCode.DPadUp then
                    v23 = Vector2.new(0, -1);
                elseif p15.KeyCode == u2.KeyCode.DPadDown then
                    v23 = Vector2.new(0, 1);
                end;
                if v23 then
                    local v24 = u13.ViewportSize / 2;
                    local l___currentButton__16 = u13._currentButton;
                    if l___currentButton__16 then
                        local v25 = l___currentButton__16.Props.Ref:getValue();
                        if v25 then
                            local v26 = l__GuiService__2:GetGuiInset();
                            if l___currentButton__16.Props.Offset then
                                v26 = v26 + l___currentButton__16.Props.Offset:getValue();
                            end;
                            local l__AbsoluteSize__17 = v25.AbsoluteSize;
                            v24 = v25.AbsolutePosition + v26 + l__AbsoluteSize__17 / 2;
                            if not l___currentButton__16.Props.Center then
                                v24 = v24 + l__AbsoluteSize__17 / 4 * v23;
                            end;
                        end;
                    end;
                    local v27 = nil;
                    local v28 = nil;
                    for _, v29 in u13._buttons do
                        if v29 ~= l___currentButton__16 then
                            local v30 = v29.Props.Ref:getValue();
                            if v30 then
                                local v31 = l__GuiService__2:GetGuiInset();
                                if v29.Props.Offset then
                                    v31 = v31 + v29.Props.Offset:getValue();
                                end;
                                local v32 = v30.AbsolutePosition + v31;
                                local l__AbsoluteSize__18 = v30.AbsoluteSize;
                                local v33 = v32 + l__AbsoluteSize__18 / 2;
                                local l__Props__19 = v29.Props;
                                local l__Ignore__20 = l__Props__19.Ignore;
                                if type(l__Ignore__20) == "table" then
                                    l__Ignore__20 = l__Ignore__20:getValue();
                                end;
                                local v34;
                                if l__Ignore__20 then
                                    v34 = true;
                                else
                                    local v35 = l__Props__19.Scroller and l__Props__19.Scroller:getValue();
                                    if v35 then
                                        local l__AbsolutePosition__21 = v35.AbsolutePosition;
                                        if not u5.Touch then
                                            local _ = l__AbsolutePosition__21 + l__GuiService__2:GetGuiInset();
                                        end;
                                        local _ = v35.AbsoluteSize;
                                    end;
                                    local l__Ref__22 = l__Props__19.Ref;
                                    if l__Ref__22 then
                                        l__Ref__22 = l__Props__19.Ref:getValue();
                                    end;
                                    v34 = not l__Ref__22 and true or l__Ref__22.Visible == false;
                                end;
                                if not v34 then
                                    if not v29.Props.Center then
                                        v33 = v33 - l__AbsoluteSize__18 / 4 * v23;
                                    end;
                                    if (v23.X ~= 1 or v33.X >= v24.X + 5) and ((v23.X ~= -1 or v33.X <= v24.X - 5) and ((v23.Y ~= 1 or v33.Y >= v24.Y + 5) and (v23.Y ~= -1 or v33.Y <= v24.Y - 5))) then
                                        local l__Magnitude__23 = (v33 - v24).Magnitude;
                                        if v27 == nil or l__Magnitude__23 < v28 then
                                            v28 = l__Magnitude__23;
                                            v27 = v29;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                    if v27 then
                        local v36 = nil;
                        for _, v37 in u13._buttons do
                            local v38 = v37.Props.Ref:getValue();
                            if v38 then
                                if v37 == v27 then
                                    if not v37.Hovering then
                                        v36 = v38;
                                    end;
                                elseif v37.Hovering then
                                    v37.Hovering = false;
                                    v37.MouseDown = false;
                                    if v37.Props.MouseLeave then
                                        v37.Props.MouseLeave(v38);
                                    end;
                                end;
                            end;
                        end;
                        if v36 then
                            v27.Hovering = true;
                            if v27.Props.MouseEnter then
                                v27.Props.MouseEnter(v36);
                            end;
                        end;
                        u13._currentButton = v27;
                    end;
                end;
            end;
        end;
    end);
    l__UserInputService__4.InputEnded:Connect(function(p39, _) --[[ Line: 311 ]]
        -- upvalues: u2 (ref), u13 (copy), u12 (ref)
        if p39.UserInputType == u2.UserInputType.MouseButton1 or p39.UserInputType.Name:sub(1, 7) == "Gamepad" and p39.KeyCode == u2.KeyCode.ButtonA then
            for _, v40 in u13._buttons do
                if v40.Hovering and (v40.MouseDown and v40.Props.MouseUp) then
                    v40.Props.MouseUp(v40.Props.Ref:getValue());
                end;
                v40.MouseDown = false;
            end;
        else
            if p39.UserInputType == u2.UserInputType.Touch then
                local l__Position__24 = p39.Position;
                for _, v41 in u13._buttons do
                    if not u12(v41.Props, l__Position__24) then
                        local v42 = v41.Props.Ref:getValue();
                        if v42 and v41.Hovering then
                            v41.Hovering = false;
                            v41.MouseDown = false;
                            if v41.Props.MouseUp then
                                v41.Props.MouseUp(v42);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end);
    return u13;
end;
function u8.QueueBaseComponent(p43, p44, p45, p46) --[[ Line: 345 ]]
    p43._baseComponentQueue[#p43._baseComponentQueue + 1] = {
        Environment = p44,
        GetComponent = p45,
        Process = p46
    };
end;
function u8.RegisterButton(p47, p48, p49) --[[ Line: 358 ]]
    if p47._buttons[p48] then
        p47._buttons[p48].Props = p49;
    else
        p47._buttons[p48] = {
            Hovering = false,
            MouseDown = false,
            Props = p49
        };
    end;
end;
function u8.UnregisterButton(p50, p51) --[[ Line: 372 ]]
    p50._buttons[p51] = nil;
end;
function u8.IsScrollBarActive(p52) --[[ Line: 377 ]]
    for _, v53 in p52._scrollbars do
        if v53.Focused then
            return true;
        end;
    end;
    return false;
end;
function u8.RegisterScroller(p54, p55) --[[ Line: 386 ]]
    table.insert(p54._scrollbars, p55);
end;
function u8.UnregisterScroller(p56, p57) --[[ Line: 390 ]]
    table.remove(p56._scrollbars, table.find(p56._scrollbars, p57));
end;
function u8.UpdateStage2(_, _) --[[ Line: 394 ]]
    -- upvalues: u7 (copy)
    u7.Update();
end;
function u8.UpdateStage1(p58, _) --[[ Line: 398 ]]
    -- upvalues: u5 (copy), l__UserInputService__4 (copy), l__CurrentCamera__6 (copy), u3 (copy), u6 (copy), l__GuiService__2 (copy), u12 (copy)
    local v59 = u5.VirtualCursorPosition or l__UserInputService__4:GetMouseLocation();
    local l__ViewportSize__25 = l__CurrentCamera__6.ViewportSize;
    p58.ViewportSize = l__ViewportSize__25;
    if u3.HUD_DISABLED then
        p58.UIVisible = false;
    end;
    local l__Y__26 = l__ViewportSize__25.Y;
    u6.Sizes.LineThickness = math.floor(l__Y__26 * 0.003);
    u6.Sizes.TagTextSize = math.floor(l__Y__26 * 0.02);
    if u5.Gamepad and not u5.VirtualCursorPosition then
        local v60 = nil;
        local v61 = nil;
        local v62 = false;
        for _, v63 in p58._buttons do
            local v64 = v63.Props.Ref:getValue();
            if v64 then
                local v65 = l__GuiService__2:GetGuiInset();
                if v63.Props.Offset then
                    v65 = v65 + v63.Props.Offset:getValue();
                end;
                v62 = v63 == p58._currentButton and true or v62;
                local v66 = v64.AbsolutePosition + v65 + v64.AbsoluteSize / 2;
                local l__Props__27 = v63.Props;
                local l__Ignore__28 = l__Props__27.Ignore;
                if type(l__Ignore__28) == "table" then
                    l__Ignore__28 = l__Ignore__28:getValue();
                end;
                local v67;
                if l__Ignore__28 then
                    v67 = true;
                else
                    local v68 = l__Props__27.Scroller and l__Props__27.Scroller:getValue();
                    if v68 then
                        local l__AbsolutePosition__29 = v68.AbsolutePosition;
                        if not u5.Touch then
                            local _ = l__AbsolutePosition__29 + l__GuiService__2:GetGuiInset();
                        end;
                        local _ = v68.AbsoluteSize;
                    end;
                    local l__Ref__30 = l__Props__27.Ref;
                    if l__Ref__30 then
                        l__Ref__30 = l__Props__27.Ref:getValue();
                    end;
                    v67 = not l__Ref__30 and true or l__Ref__30.Visible == false;
                end;
                if not v67 then
                    local l__Magnitude__31 = (v66 - p58.ViewportSize / 2).Magnitude;
                    if v61 == nil or l__Magnitude__31 < v60 then
                        v61 = v63;
                        v60 = l__Magnitude__31;
                    end;
                end;
            end;
        end;
        if v61 then
            if not v62 then
                for _, v69 in p58._buttons do
                    local v70 = v69.Props.Ref:getValue();
                    if v70 then
                        if v69 == v61 then
                            if not v69.Hovering then
                                v69.Hovering = true;
                                if v69.Props.MouseEnter then
                                    v69.Props.MouseEnter(v70);
                                end;
                            end;
                        elseif v69.Hovering then
                            v69.Hovering = false;
                            v69.MouseDown = false;
                            if v69.Props.MouseLeave then
                                v69.Props.MouseLeave(v70);
                            end;
                        end;
                    end;
                end;
                p58._currentButton = v61;
            end;
        else
            p58._currentButton = nil;
        end;
    else
        local v71 = nil;
        local v72 = nil;
        local v73 = {};
        local v74 = nil;
        local v75 = false;
        local v76 = nil;
        for _, v77 in p58._buttons do
            local v78 = v77.Props.Ref:getValue();
            if v78 then
                local v79 = l__GuiService__2:GetGuiInset();
                if v77.Props.Offset then
                    v79 = v79 + v77.Props.Offset:getValue();
                end;
                local l__AbsoluteSize__32 = v78.AbsoluteSize;
                local v80 = v78.AbsolutePosition + v79;
                local v81;
                if v59.X > v80.X and (v59.X < v80.X + l__AbsoluteSize__32.X and v59.Y > v80.Y) then
                    v81 = v59.Y < v80.Y + l__AbsoluteSize__32.Y;
                else
                    v81 = false;
                end;
                if u12(v77.Props, v59) or not v81 then
                    if v77.Hovering and not (v77.Props.HoverLock and v77.Props.HoverLock:getValue()) then
                        v77.Hovering = false;
                        v77.MouseDown = false;
                        if v77.Props.MouseLeave then
                            v77.Props.MouseLeave(v78);
                        end;
                    end;
                else
                    local l__ZIndex__33 = v78.ZIndex;
                    local l__Magnitude__34 = (v59 - (v80 + l__AbsoluteSize__32 / 2)).Magnitude;
                    if v74 and (l__Magnitude__34 >= v71 or v72 > l__ZIndex__33) and v72 >= l__ZIndex__33 then
                        l__ZIndex__33 = v72;
                        l__Magnitude__34 = v71;
                    else
                        v76 = v78;
                        v74 = v77;
                    end;
                    v73[#v73 + 1] = {
                        ZIndex = v78.ZIndex,
                        State = v77,
                        Frame = v78
                    };
                    v72 = l__ZIndex__33;
                    v71 = l__Magnitude__34;
                    v75 = true;
                end;
            end;
        end;
        if v74 then
            if not v74.Hovering then
                v74.Hovering = true;
                if v74.Props.MouseEnter then
                    v74.Props.MouseEnter(v76);
                end;
            end;
            for _, v82 in v73 do
                local l__State__35 = v82.State;
                if l__State__35 ~= v74 and (l__State__35.Hovering and not (l__State__35.Props.HoverLock and l__State__35.Props.HoverLock:getValue())) then
                    l__State__35.Hovering = false;
                    l__State__35.MouseDown = false;
                    if l__State__35.Props.MouseLeave then
                        l__State__35.Props.MouseLeave(v82.Frame);
                    end;
                end;
            end;
        end;
        p58._currentButton = nil;
        p58.Hovering = v75;
    end;
    local v83 = os.clock();
    local l___baseComponentQueue__36 = p58._baseComponentQueue;
    if #l___baseComponentQueue__36 > 0 and p58._nextBaseComponent < v83 then
        local v84 = nil;
        while not v84 do
            for v85, v86 in l___baseComponentQueue__36 do
                if v86.Environment.Destroyed then
                    table.remove(l___baseComponentQueue__36, v85);
                    break;
                end;
                if v86.Environment.Ready then
                    table.remove(l___baseComponentQueue__36, v85);
                    v84 = v86;
                    break;
                end;
            end;
            if #l___baseComponentQueue__36 == 0 then
                break;
            end;
        end;
        if v84 then
            p58:_executeBaseComponent(v84);
            p58._nextBaseComponent = v83 + 0.1;
        end;
    end;
end;
function u8._executeBaseComponent(_, p87) --[[ Line: 593 ]]
    -- upvalues: u4 (copy), l__ContentProvider__1 (copy)
    local l__Environment__37 = p87.Environment;
    local v88 = l__Environment__37.ViewPort:getValue();
    if v88 then
        local v89 = p87.GetComponent();
        if v89 then
            local l__PrimaryPart__38 = v89.ParentModel.PrimaryPart;
            if l__PrimaryPart__38 then
                l__PrimaryPart__38.Anchored = true;
            end;
            local v90, v91, v92 = p87.Process(v89);
            if v90 then
                local v93 = nil;
                local v94 = v89.Path[2];
                local v95 = CFrame.Angles(0, -2.356194490192345, 0) * CFrame.Angles(-0.3141592653589793, 0, -0.3141592653589793);
                if v94 == "Shirt" or v94 == "Pants" then
                    v95 = CFrame.Angles(0, 3.141592653589793, 0);
                    v93 = CFrame.new(0, 0, -6);
                elseif u4.Default[v94] then
                    v95 = CFrame.Angles(0, 3.141592653589793, 0);
                    v93 = CFrame.new(0, 0, -3);
                elseif v92 then
                    v95 = CFrame.Angles(0, -1.5707963267948966, 0);
                elseif v94 == "Receiver" then
                    v95 = CFrame.Angles(0, -1.5707963267948966, 0);
                    v93 = CFrame.new(0, 0, -4);
                end;
                if not v91 then
                    local v96, v97 = v89:GetMenuConfig();
                    if v96 and v97.ModelCFrame then
                        v95 = v97.ModelCFrame;
                    end;
                end;
                v90.Parent = v88;
                if v91 == true then
                    l__Environment__37.Camera.CFrame = CFrame.new(10, -2495, 10) * CFrame.Angles(0, 0.7853981633974483, 0) * CFrame.Angles(-0.3490658503988659, 0, 0);
                    l__Environment__37.Camera.FieldOfView = 50;
                elseif v91 then
                    v90:PivotTo(v91);
                elseif v93 then
                    local v98 = v93 * v95;
                    local v99 = v90:GetBoundingBox();
                    local v100 = v90:GetPivot();
                    v90:PivotTo(v98 * (v99:Inverse() * v100));
                else
                    local l__new__39 = CFrame.new;
                    local l__FieldOfView__40 = l__Environment__37.Camera.FieldOfView;
                    local v101 = v95:VectorToObjectSpace(v90:GetExtentsSize());
                    local v102 = math.sqrt(v101.X ^ 2 + v101.Y ^ 2 + v101.Z ^ 2);
                    local v103 = math.rad(l__FieldOfView__40) / 2;
                    local v104 = math.tan(v103);
                    local v105 = l__new__39(0, 0, -(v102 * 0.5 / v104 * 1.05)) * v95;
                    local v106 = v90:GetBoundingBox();
                    local v107 = v90:GetPivot();
                    v90:PivotTo(v105 * (v106:Inverse() * v107));
                end;
                local u108 = {};
                for _, v109 in v90:GetDescendants() do
                    if v109:IsA("MeshPart") then
                        u108[#u108 + 1] = v109;
                    end;
                end;
                task.spawn(function() --[[ Line: 660 ]]
                    -- upvalues: l__ContentProvider__1 (ref), u108 (copy), l__Environment__37 (copy)
                    l__ContentProvider__1:PreloadAsync(u108);
                    if l__Environment__37.Destroyed then
                    else
                        l__Environment__37.Loading:SetGoal(0);
                    end;
                end);
                v89:Destroy();
            else
                v89:Destroy();
            end;
        else
            l__Environment__37.Loading:SetGoal(0);
        end;
    end;
end;
function u8.CreateProxy(u110, p111, p112, p113) --[[ Line: 678 ]]
    -- upvalues: u2 (copy), l__PlayerGui__5 (copy)
    local u114 = Instance.new("ScreenGui");
    u114.DisplayOrder = p111;
    u114.IgnoreGuiInset = true;
    u114.ResetOnSpawn = false;
    u114.Name = p113 or tostring(p111);
    u114.ZIndexBehavior = u2.ZIndexBehavior.Sibling;
    local u115 = Instance.new("Frame");
    u115.Size = UDim2.fromScale(1, 1);
    u115.Position = UDim2.fromScale(0, 0);
    u115.BackgroundTransparency = 1;
    u115.Parent = u114;
    u110.FrameList[u115] = p112;
    u114.Parent = l__PlayerGui__5;
    return u115, u114, function() --[[ Line: 694 ]]
        -- upvalues: u110 (copy), u115 (copy), u114 (copy)
        u110.FrameList[u115] = nil;
        u114:Destroy();
    end;
end;
return u8.new();