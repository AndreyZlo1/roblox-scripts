-- Services.RGEService.Components.RGEPropertiesButtonComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local u3 = v1("GameShellProxyButton");
local v4 = u2.Component:extend("RGEScroll");
function v4.init(p5) --[[ Line: 14 ]]
    p5:setState({
        Hovering = false
    });
end;
function v4.render(u6) --[[ Line: 20 ]]
    -- upvalues: u2 (copy), u3 (copy)
    local l__props__1 = u6.props;
    return u2.createElement(u3, {
        BorderSizePixel = 0,
        BackgroundColor3 = u6.state.Hovering and Color3.fromRGB(100, 100, 100) or l__props__1.BackgroundColor3,
        BorderColor3 = Color3.fromRGB(35, 37, 43),
        BorderMode = Enum.BorderMode.Inset,
        Position = l__props__1.Position,
        Size = l__props__1.Size,
        MouseEnter = function() --[[ Name: MouseEnter, Line 31 ]]
            -- upvalues: u6 (copy)
            u6:setState({
                Hovering = true
            });
        end,
        MouseLeave = function() --[[ Name: MouseLeave, Line 36 ]]
            -- upvalues: u6 (copy)
            u6:setState({
                Hovering = false
            });
        end,
        MouseDown = function() --[[ Name: MouseDown, Line 41 ]]
            -- upvalues: l__props__1 (copy)
            l__props__1.Callback();
        end
    }, { u2.createElement("TextLabel", {
            BackgroundTransparency = 1,
            RichText = true,
            TextSize = 14,
            Position = UDim2.new(0, 0, 0.2, 0),
            Size = UDim2.new(1, 0, 0.6, 0),
            Text = l__props__1.Text,
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.Ubuntu,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Center
        }) });
end;
return v4;