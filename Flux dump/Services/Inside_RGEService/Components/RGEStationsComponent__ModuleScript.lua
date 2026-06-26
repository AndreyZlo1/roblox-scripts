-- Services.RGEService.Components.RGEStationsComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local l__TextService__1 = game:GetService("TextService");
local u3 = v1("GameShellProxyButton");
local u4 = Font.fromId(11702779240, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
local v5 = u2.Component:extend("RGEStations");
function v5.render(u6) --[[ Line: 17 ]]
    -- upvalues: u2 (copy), l__TextService__1 (copy), u3 (copy), u4 (copy)
    local l__windows__2 = u6.props.windows;
    local l__window__3 = u6.props.window;
    local v7 = {
        List = u2.createElement("UIListLayout", {
            Padding = UDim.new(0, 0),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        })
    };
    local v8 = 0;
    for u9 = 1, #l__windows__2 do
        local v10 = l__windows__2[u9];
        local l__Name__4 = v10.Name;
        local l__Closeable__5 = v10.Closeable;
        local v11 = l__TextService__1:GetTextSize(l__Name__4, 14, Enum.Font.Ubuntu, Vector2.new(10000, 1000)).X + 30 + (l__Closeable__5 and 20 or 0);
        local l__createElement__6 = u2.createElement;
        local v12 = u3;
        local v13 = {
            BorderSizePixel = 1,
            BackgroundColor3 = l__window__3 == u9 and Color3.fromRGB(31, 31, 31) or Color3.fromRGB(24, 24, 24),
            BorderColor3 = Color3.fromRGB(43, 43, 43),
            LayoutOrder = u9,
            Size = UDim2.new(0, v11, 1, 0),
            MouseDown = function() --[[ Name: MouseDown, Line 46 ]]
                -- upvalues: u6 (copy), u9 (copy)
                u6.props.changeWindow(u9);
            end
        };
        local v14 = {
            Title = u2.createElement("TextLabel", {
                BackgroundTransparency = 1,
                TextSize = 14,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, l__Closeable__5 and -20 or 0, 1, 0),
                Text = l__Name__4,
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.Ubuntu,
                TextXAlignment = Enum.TextXAlignment.Center
            })
        };
        if l__Closeable__5 then
            l__Closeable__5 = u2.createElement(u3, {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 30, 1, 2),
                Position = UDim2.new(1, -30, 0, 0),
                MouseDown = function() --[[ Name: MouseDown, Line 65 ]]
                    -- upvalues: u6 (copy), u9 (copy)
                    u6.props.closeWindow(u9);
                end
            }, { u2.createElement("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = "X",
                    TextSize = 14,
                    Size = UDim2.new(1, 0, 1, 0),
                    TextColor3 = Color3.new(1, 1, 1),
                    FontFace = u4,
                    TextXAlignment = Enum.TextXAlignment.Center
                }) });
        end;
        v14.Close = l__Closeable__5;
        local v15;
        if l__window__3 == u9 then
            v15 = u2.createElement("Frame", {
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(0, 120, 212),
                Size = UDim2.new(1, 0, 0, 2)
            });
        else
            v15 = false;
        end;
        v14[1] = v15;
        v7[u9] = l__createElement__6(v12, v13, v14);
        v8 = v8 + v11;
    end;
    return u2.createElement("ScrollingFrame", {
        Selectable = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 1,
        ScrollBarImageTransparency = 0,
        Size = UDim2.new(1, 0, 1, 0),
        ScrollBarImageColor3 = Color3.new(1, 1, 1),
        ScrollingDirection = Enum.ScrollingDirection.X,
        CanvasSize = UDim2.new(0, v8, 0, 0)
    }, v7);
end;
return v5;