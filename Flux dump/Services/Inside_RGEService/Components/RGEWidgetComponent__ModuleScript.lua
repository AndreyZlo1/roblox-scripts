-- Services.RGEService.Components.RGEWidgetComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local l__TextService__1 = game:GetService("TextService");
local u3 = v1("GameShellProxyButton");
local v4 = u2.Component:extend("RGEWidget");
function v4.render(p5) --[[ Line: 14 ]]
    -- upvalues: u2 (copy), l__TextService__1 (copy), u3 (copy)
    local l__selected__2 = p5.props.selected;
    local l__tabs__3 = p5.props.tabs;
    local l__switch__4 = p5.props.switch;
    local l__top__5 = p5.props.top;
    local v6 = {
        List = u2.createElement("UIListLayout", {
            Padding = UDim.new(0, 0),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        })
    };
    local v7 = 0;
    for v8 = 1, #l__tabs__3 do
        local u9 = l__tabs__3[v8];
        local v10 = l__TextService__1:GetTextSize(u9, 14, Enum.Font.Ubuntu, Vector2.new(10000, 1000)).X + 30;
        local l__createElement__6 = u2.createElement;
        local v11 = u3;
        local v12 = {
            BorderSizePixel = 1,
            BackgroundColor3 = l__selected__2 == u9 and Color3.fromRGB(24, 24, 24) or Color3.fromRGB(31, 31, 31),
            BorderColor3 = Color3.fromRGB(43, 43, 43),
            LayoutOrder = v8,
            Size = UDim2.new(0, v10, 1, -1),
            MouseDown = function() --[[ Name: MouseDown, Line 43 ]]
                -- upvalues: l__switch__4 (copy), u9 (copy)
                l__switch__4(u9);
            end
        };
        local v13 = {
            Title = u2.createElement("TextLabel", {
                BackgroundTransparency = 1,
                TextSize = 14,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 1, 0),
                Text = u9,
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.Ubuntu,
                TextXAlignment = Enum.TextXAlignment.Center
            })
        };
        local v14;
        if l__selected__2 == u9 then
            v14 = u2.createElement("Frame", {
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(0, 120, 212),
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, l__top__5 and 0 or 1, l__top__5 and 1 or -2)
            });
        else
            v14 = false;
        end;
        local v15;
        if l__selected__2 == u9 then
            v15 = u2.createElement("Frame", {
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(24, 24, 24),
                Size = UDim2.new(1, 0, 0, 2),
                Position = UDim2.new(0, 0, l__top__5 and 1 or 0, l__top__5 and 2 or -1)
            });
        else
            v15 = false;
        end;
        v13[1], v13[2] = v14, v15;
        v6[v8] = l__createElement__6(v11, v12, v13);
        v7 = v7 + v10;
    end;
    local l__createFragment__7 = u2.createFragment;
    local v16 = {};
    local v17 = not l__top__5;
    if v17 then
        v17 = u2.createElement("Frame", {
            BorderSizePixel = 0,
            ZIndex = 2,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Color3.fromRGB(24, 24, 24),
            BorderColor3 = Color3.fromRGB(43, 43, 43)
        }, {
            Title = u2.createElement("TextLabel", {
                BackgroundTransparency = 1,
                RichText = true,
                TextSize = 12,
                Position = UDim2.new(0, 10, 0.2, 0),
                Size = UDim2.new(1, 0, 0.6, 0),
                Text = l__selected__2:upper(),
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.Ubuntu,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        });
    end;
    v16.Header = v17;
    v16.Content = u2.createElement("Frame", {
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Position = UDim2.new(0, 0, 0, l__top__5 and 32 or 35),
        Size = UDim2.new(1, 0, 1, -32 - (l__top__5 and 0 or 35))
    }, p5.props.content);
    v16.Footer = u2.createElement("Frame", {
        BorderSizePixel = 1,
        ZIndex = 2,
        Size = UDim2.new(1, 0, 0, 32),
        Position = UDim2.new(0, 0, l__top__5 and 0 or 1, 0),
        AnchorPoint = Vector2.new(0, l__top__5 and 0 or 1),
        BackgroundColor3 = Color3.fromRGB(31, 31, 31),
        BorderColor3 = Color3.fromRGB(43, 43, 43)
    }, u2.createElement("ScrollingFrame", {
        Selectable = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 1,
        ScrollBarImageTransparency = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, -1),
        BorderMode = Enum.BorderMode.Inset,
        ScrollBarImageColor3 = Color3.new(1, 1, 1),
        ScrollingDirection = Enum.ScrollingDirection.X,
        CanvasSize = UDim2.new(0, v7, 0, 0)
    }, v6));
    return l__createFragment__7(v16);
end;
return v4;