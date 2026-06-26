-- Services.RGEService.Components.RGEScrollButtonComponent
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
    local l__Selected__2 = l__props__1.Selected;
    local l__Size__3 = l__props__1.Size;
    local l__Key__4 = l__props__1.Key;
    local l__Value__5 = l__props__1.Value;
    local l__Selection__6 = l__props__1.Selection;
    local l__NewSelection__7 = l__props__1.NewSelection;
    local v7 = l__props__1.Even and Color3.fromRGB(31, 31, 31) or Color3.fromRGB(24, 24, 24);
    local l__createElement__8 = u2.createElement;
    local v8 = u3;
    local v9 = {
        BorderSizePixel = 1,
        Scroller = l__props__1.Scroller
    };
    local v10 = l__Selected__2 and Color3.fromRGB(4, 57, 94);
    if not v10 then
        if u6.state.Hovering then
            v10 = Color3.fromRGB(100, 100, 100) or v7;
        else
            v10 = v7;
        end;
    end;
    v9.BackgroundColor3 = v10;
    if l__Selected__2 then
        v7 = Color3.fromRGB(0, 120, 212) or v7;
    end;
    v9.BorderColor3 = v7;
    v9.Position = UDim2.new(0, 0, 0, l__Size__3);
    v9.Size = UDim2.new(1, 0, 0, l__props__1.CellSize);
    v9.BorderMode = Enum.BorderMode.Inset;
    function v9.MouseEnter() --[[ Line: 39 ]]
        -- upvalues: u6 (copy)
        u6:setState({
            Hovering = true
        });
    end;
    function v9.MouseLeave() --[[ Line: 44 ]]
        -- upvalues: u6 (copy)
        u6:setState({
            Hovering = false
        });
    end;
    function v9.MouseDown() --[[ Line: 49 ]]
        -- upvalues: l__NewSelection__7 (copy), l__Key__4 (copy)
        l__NewSelection__7(l__Key__4);
    end;
    local v11 = {};
    local v12 = u2.createElement("ImageLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        ImageColor3 = l__Value__5.Color or Color3.new(1, 1, 1),
        Image = l__Value__5.Icon
    });
    local v13 = u2.createElement("TextLabel", {
        BackgroundTransparency = 1,
        RichText = true,
        TextSize = 14,
        Position = UDim2.new(0, 36, 0.2, 0),
        Size = UDim2.new(1, -46, 0.6, 0),
        Text = l__Value__5.Name,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.Ubuntu,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left
    });
    if l__Selected__2 then
        if #l__Selection__6 > 1 then
            l__Selected__2 = u2.createElement("TextLabel", {
                BackgroundTransparency = 1,
                Text = "•",
                RichText = true,
                TextSize = 14,
                Position = UDim2.new(0, 0, 0.2, 0),
                Size = UDim2.new(1, -10, 0.6, 0),
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.Ubuntu,
                TextXAlignment = Enum.TextXAlignment.Right
            });
        else
            l__Selected__2 = false;
        end;
    end;
    v11[1], v11[2], v11[3] = v12, v13, l__Selected__2;
    return l__createElement__8(v8, v9, v11);
end;
return v4;