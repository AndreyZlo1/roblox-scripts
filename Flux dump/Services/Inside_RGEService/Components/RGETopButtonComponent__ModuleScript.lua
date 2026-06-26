-- Services.RGEService.Components.RGETopButtonComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local u3 = v1("GameShellProxyButton");
local v4 = u2.Component:extend("RGETopButton");
function v4.init(p5) --[[ Line: 13 ]]
    -- upvalues: u2 (copy)
    p5.input = u2.createRef();
    p5:setState({
        Hovering = false
    });
end;
function v4.didUpdate(p6) --[[ Line: 20 ]]
    if p6.input:getValue() then
        p6.input:getValue():CaptureFocus();
    end;
end;
function v4.render(u7) --[[ Line: 26 ]]
    -- upvalues: u2 (copy), u3 (copy)
    local l__props__1 = u7.props;
    local l__Selected__2 = l__props__1.Option.Selected;
    local l__createElement__3 = u2.createElement;
    local v8 = u3;
    local v9 = {
        BackgroundColor3 = l__Selected__2 and Color3.fromRGB(4, 57, 94) or (u7.state.Hovering and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(31, 31, 31)),
        BorderColor3 = Color3.fromRGB(0, 120, 212),
        BorderSizePixel = l__Selected__2 and 1 or 0,
        Position = UDim2.new(0, l__props__1.Position, 0, 1),
        Size = UDim2.new(0, l__props__1.Option.Size, 0.8, -1),
        BorderMode = Enum.BorderMode.Inset,
        MouseEnter = function() --[[ Name: MouseEnter, Line 38 ]]
            -- upvalues: u7 (copy)
            u7:setState({
                Hovering = true
            });
        end,
        MouseLeave = function() --[[ Name: MouseLeave, Line 43 ]]
            -- upvalues: u7 (copy)
            u7:setState({
                Hovering = false
            });
        end,
        MouseDown = function() --[[ Name: MouseDown, Line 48 ]]
            -- upvalues: l__props__1 (copy), u7 (copy)
            if l__props__1.Option.Input then
                u7:setState({
                    Input = true
                });
            else
                l__props__1.Option.Callback();
            end;
        end
    };
    local v10 = {};
    local v11 = u2.createElement("ImageLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.4, 0, 0.4, 0),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        Position = UDim2.new(0.5, 0, 0.1, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        ImageColor3 = (l__Selected__2 or u7.state.Hovering) and Color3.new(1, 1, 1) or Color3.fromRGB(200, 200, 200),
        Image = l__props__1.Option.Image
    });
    local v12 = u2.createElement("TextLabel", {
        BackgroundTransparency = 1,
        RichText = true,
        TextWrapped = true,
        TextSize = 12,
        Position = UDim2.new(0, 0, 0.6, 0),
        Size = UDim2.new(1, 1, 0.4, 0),
        Text = l__props__1.Option.Name,
        TextColor3 = (l__Selected__2 or u7.state.Hovering) and Color3.new(1, 1, 1) or Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.Ubuntu,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextXAlignment = Enum.TextXAlignment.Center
    });
    local l__Input__4 = u7.state.Input;
    if l__Input__4 then
        l__Input__4 = u2.createElement("TextBox", {
            Position = UDim2.new(0, 0, 0.75, 0),
            Size = UDim2.new(1, 0, 0.25, 0),
            ZIndex = 2,
            BackgroundColor3 = Color3.fromRGB(4, 57, 94),
            BorderColor3 = Color3.fromRGB(0, 120, 212),
            BorderMode = Enum.BorderMode.Inset,
            TextColor3 = Color3.new(1, 1, 1),
            Text = l__props__1.Option.Name,
            TextSize = 12,
            Font = Enum.Font.Ubuntu,
            [u2.Ref] = u7.input,
            [u2.Event.FocusLost] = function(p13, p14) --[[ Line: 94 ]]
                -- upvalues: l__props__1 (copy), u7 (copy)
                if p14 then
                    l__props__1.Option.Callback(p13.Text);
                end;
                u7:setState({
                    Input = false
                });
            end
        });
    end;
    v10[1], v10[2], v10[3] = v11, v12, l__Input__4;
    return l__createElement__3(v8, v9, v10);
end;
return v4;