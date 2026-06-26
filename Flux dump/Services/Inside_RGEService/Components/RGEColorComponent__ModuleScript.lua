-- Services.RGEService.Components.RGEColorComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local l__GuiService__1 = game:GetService("GuiService");
local l__RunService__2 = game:GetService("RunService");
local l__UserInputService__3 = game:GetService("UserInputService");
local u3 = v1("isTintable");
local u4 = v1("GameShellProxyButton");
local v5 = u2.Component:extend("RGEColor");
function v5.init(u6) --[[ Line: 17 ]]
    -- upvalues: u2 (copy), u3 (copy), l__RunService__2 (copy), l__UserInputService__3 (copy), l__GuiService__1 (copy)
    local v7 = Color3.new(1, 1, 1);
    local u8 = u6.props.selection[1];
    if u8 and u8:IsA("BasePart") then
        v7 = u8.Color;
    end;
    local l__addChange__4 = u6.props.addChange;
    local l__newConsoleLine__5 = u6.props.newConsoleLine;
    local v9, v10 = u2.createBinding(v7);
    u6.color = v9;
    u6.updateColor = v10;
    function u6.setColor(p11) --[[ Line: 28 ]]
        -- upvalues: u6 (copy), u3 (ref), l__addChange__4 (copy), l__newConsoleLine__5 (copy)
        u6.updateColor(p11);
        local u12 = p11.R * 255;
        local u13 = p11.G * 255;
        local u14 = p11.B * 255;
        local u15 = {};
        for _, v16 in u6.props.selection do
            if v16:IsA("BasePart") then
                u15[#u15 + 1] = {
                    OldColor = v16.Color,
                    Object = v16,
                    Tint = v16,
                    World = v16:GetAttribute("World"),
                    UID = v16:GetAttribute("UID")
                };
            elseif v16:IsA("Trigger") then
                u15[#u15 + 1] = {
                    OldColor = v16.Color,
                    Object = v16,
                    Tint = v16,
                    World = v16.World,
                    Trigger = v16.Name
                };
            else
                local v17 = u3(v16);
                if v17 then
                    u15[#u15 + 1] = {
                        OldColor = v17.Color,
                        Object = v16,
                        Tint = v17,
                        World = v16:GetAttribute("World"),
                        UID = v16:GetAttribute("UID")
                    };
                end;
            end;
        end;
        l__addChange__4("Color", function(p18) --[[ Line: 66 ]]
            -- upvalues: u15 (copy), l__newConsoleLine__5 (ref), u12 (copy), u13 (copy), u14 (copy)
            for _, v19 in u15 do
                if v19.Trigger then
                    l__newConsoleLine__5({
                        "trigger",
                        "color",
                        v19.World,
                        v19.Trigger,
                        u12,
                        u13,
                        u14
                    });
                elseif p18(v19.Object, v19.World, v19.UID) then
                    v19.Tint.Color = Color3.fromRGB(u12, u13, u14);
                    l__newConsoleLine__5({
                        "color",
                        v19.World,
                        v19.UID,
                        u12,
                        u13,
                        u14
                    });
                end;
            end;
        end, function(p20) --[[ Line: 82 ]]
            -- upvalues: u15 (copy), l__newConsoleLine__5 (ref)
            for _, v21 in u15 do
                local l__OldColor__6 = v21.OldColor;
                if v21.Trigger then
                    l__newConsoleLine__5({
                        "trigger",
                        "color",
                        v21.World,
                        v21.Trigger,
                        l__OldColor__6.R * 255,
                        l__OldColor__6.G * 255,
                        l__OldColor__6.B * 255
                    });
                elseif p20(v21.Object, v21.World, v21.UID) then
                    v21.Tint.Color = l__OldColor__6;
                    l__newConsoleLine__5({
                        "color",
                        v21.World,
                        v21.UID,
                        l__OldColor__6.R * 255,
                        l__OldColor__6.G * 255,
                        l__OldColor__6.B * 255
                    });
                end;
            end;
        end);
    end;
    u6._conn = l__RunService__2.Heartbeat:Connect(function(_) --[[ Line: 102 ]]
        -- upvalues: u6 (copy), u8 (ref), l__UserInputService__3 (ref), l__GuiService__1 (ref)
        local v22 = u6.props.selection[1];
        if v22 and (v22:IsA("BasePart") and u8 ~= v22) then
            u8 = v22;
            u6.updateColor(v22.Color);
        end;
        local v23 = l__UserInputService__3:GetMouseLocation() - l__GuiService__1:GetGuiInset();
        local l___startColorPick__7 = u6._startColorPick;
        if l___startColorPick__7 then
            local v24 = (v23 - l___startColorPick__7.AbsolutePosition) / l___startColorPick__7.AbsoluteSize;
            if v24.X < 0 or (v24.X > 1 or (v24.Y < 0 or v24.Y > 1)) then
                u6._startColorPick = nil;
                v24 = Vector2.new(math.clamp(v24.X, 0, 1), (math.clamp(v24.Y, 0, 1)));
            end;
            local _, _, v25 = u6.color:getValue():ToHSV();
            u6.updateColor(Color3.fromHSV(1 - v24.X, 1 - v24.Y, v25));
            u6._wasColorPick = true;
        elseif u6._wasColorPick then
            u6._wasColorPick = nil;
            u6.setColor(u6.color:getValue());
        end;
        local l___startValuePick__8 = u6._startValuePick;
        if l___startValuePick__8 then
            local v26 = (v23 - l___startValuePick__8.AbsolutePosition) / l___startValuePick__8.AbsoluteSize;
            if v26.X < 0 or (v26.X > 1 or (v26.Y < 0 or v26.Y > 1)) then
                u6._startValuePick = nil;
                v26 = Vector2.new(math.clamp(v26.X, 0, 1), (math.clamp(v26.Y, 0, 1)));
            end;
            local v27, v28 = u6.color:getValue():ToHSV();
            u6.updateColor(Color3.fromHSV(v27, v28, 1 - v26.Y));
            u6._wasValuePick = true;
        else
            if u6._wasValuePick then
                u6._wasValuePick = nil;
                u6.setColor(u6.color:getValue());
            end;
        end;
    end);
end;
function v5.willUnmount(p29) --[[ Line: 145 ]]
    p29._conn:Disconnect();
end;
function v5.render(u30) --[[ Line: 149 ]]
    -- upvalues: u2 (copy), u4 (copy)
    return u2.createElement("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(10, 10),
        Size = UDim2.new(1, -20, 1, -20)
    }, { u2.createElement("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0),
            Size = UDim2.fromOffset(0, 300)
        }, {
            u2.createElement("UIAspectRatioConstraint", {
                AspectRatio = 1.24,
                AspectType = Enum.AspectType.ScaleWithParentSize,
                DominantAxis = Enum.DominantAxis.Height
            }),
            u2.createElement("Frame", {
                BorderSizePixel = 0,
                ClipsDescendants = true,
                BackgroundColor3 = Color3.new(1, 1, 1),
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY
            }, { u2.createElement(u4, {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                    MouseDown = function(p31) --[[ Name: MouseDown, Line 176 ]]
                        -- upvalues: u30 (copy)
                        u30._startColorPick = p31;
                    end,
                    MouseUp = function() --[[ Name: MouseUp, Line 179 ]]
                        -- upvalues: u30 (copy)
                        u30._startColorPick = nil;
                    end
                }), u2.createElement("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
                        ColorSequenceKeypoint.new(0.167, Color3.new(1, 0, 1)),
                        ColorSequenceKeypoint.new(0.333, Color3.new(0, 0, 1)),
                        ColorSequenceKeypoint.new(0.5, Color3.new(0, 1, 1)),
                        ColorSequenceKeypoint.new(0.667, Color3.new(0, 1, 0)),
                        ColorSequenceKeypoint.new(0.833, Color3.new(1, 1, 0)),
                        ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0))
                    })
                }), u2.createElement("Frame", {
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Size = UDim2.fromScale(1, 1)
                }, { u2.createElement("UIGradient", {
                        Rotation = 90,
                        Transparency = NumberSequence.new(1, 0)
                    }), u2.createElement("Frame", {
                        BackgroundTransparency = 1,
                        Size = UDim2.fromScale(0.01, 0.01),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = u30.color:map(function(p32) --[[ Line: 207 ]]
                            local v33, v34 = p32:ToHSV();
                            return UDim2.fromScale(1 - v33, 1 - v34);
                        end)
                    }, { u2.createElement("Frame", {
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.new(0, 0, 0),
                            Size = UDim2.fromScale(10, 1),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.fromScale(0.5, 0.5)
                        }), u2.createElement("Frame", {
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.new(0, 0, 0),
                            Size = UDim2.fromScale(1, 10),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.fromScale(0.5, 0.5)
                        }) }) }) }),
            u2.createElement("Frame", {
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.fromScale(1, 0),
                Size = UDim2.fromScale(0.2, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                BackgroundColor3 = Color3.new(1, 1, 1)
            }, { u2.createElement(u4, {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                    MouseDown = function(p35) --[[ Name: MouseDown, Line 240 ]]
                        -- upvalues: u30 (copy)
                        u30._startValuePick = p35;
                    end,
                    MouseUp = function() --[[ Name: MouseUp, Line 243 ]]
                        -- upvalues: u30 (copy)
                        u30._startValuePick = nil;
                    end
                }), u2.createElement("UIGradient", {
                    Rotation = 90,
                    Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0, 0, 0))
                }), u2.createElement("Frame", {
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    Size = UDim2.fromScale(1, 0.01),
                    BackgroundColor3 = Color3.fromRGB(0, 120, 212),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = u30.color:map(function(p36) --[[ Line: 257 ]]
                        local _, _, v37 = p36:ToHSV();
                        return UDim2.fromScale(0, 1 - v37);
                    end)
                }) }),
            u2.createElement("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0, 1.1),
                AnchorPoint = Vector2.new(0, 0),
                Size = UDim2.fromScale(1, 0.5)
            }, {
                u2.createElement("Frame", {
                    BorderSizePixel = 1,
                    Size = UDim2.fromScale(0.2, 1),
                    BackgroundColor3 = u30.color,
                    BorderColor3 = Color3.fromRGB(60, 60, 60)
                }),
                u2.createElement("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = "Red:",
                    RichText = true,
                    TextScaled = true,
                    Position = UDim2.new(0.2, 10, 0, 0),
                    Size = UDim2.new(0.4, 0, 0.1, 0),
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.Ubuntu,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                u2.createElement("TextBox", {
                    Position = UDim2.new(0.35, 20, 0, 0),
                    Size = UDim2.new(0.12, 0, 0.1, 0),
                    Text = "",
                    PlaceholderText = u30.color:map(function(p38) --[[ Line: 290 ]]
                        return math.floor(p38.R * 255);
                    end),
                    PlaceholderColor3 = Color3.fromRGB(200, 200, 200),
                    BorderColor3 = Color3.fromRGB(60, 60, 60),
                    BackgroundColor3 = Color3.fromRGB(49, 49, 49),
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.Ubuntu,
                    TextScaled = true,
                    [u2.Event.FocusLost] = function(p39, p40) --[[ Line: 301 ]]
                        -- upvalues: u30 (copy)
                        local v41 = tonumber(p39.Text);
                        if p40 and v41 then
                            local v42 = u30.color:getValue();
                            u30.setColor(Color3.new(v41 / 255, v42.G, v42.B));
                        end;
                        p39.Text = "";
                    end
                }),
                u2.createElement("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = "Hue:",
                    RichText = true,
                    TextScaled = true,
                    Position = UDim2.new(0.55, 10, 0, 0),
                    Size = UDim2.new(0.4, 0, 0.1, 0),
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.Ubuntu,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                u2.createElement("TextBox", {
                    Position = UDim2.new(0.7, 20, 0, 0),
                    Size = UDim2.new(0.12, 0, 0.1, 0),
                    Text = "",
                    PlaceholderText = u30.color:map(function(p43) --[[ Line: 325 ]]
                        local v44, _, _ = p43:ToHSV();
                        return math.floor(v44 * 255);
                    end),
                    PlaceholderColor3 = Color3.fromRGB(200, 200, 200),
                    BorderColor3 = Color3.fromRGB(60, 60, 60),
                    BackgroundColor3 = Color3.fromRGB(49, 49, 49),
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.Ubuntu,
                    TextScaled = true,
                    [u2.Event.FocusLost] = function(p45, p46) --[[ Line: 337 ]]
                        -- upvalues: u30 (copy)
                        local v47 = tonumber(p45.Text);
                        if p46 and v47 then
                            local _, v48, v49 = u30.color:getValue():ToHSV();
                            u30.setColor(Color3.fromHSV(v47 / 255, v48, v49));
                        end;
                        p45.Text = "";
                    end
                }),
                u2.createElement("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = "Green:",
                    RichText = true,
                    TextScaled = true,
                    Position = UDim2.new(0.2, 10, 0.1, 10),
                    Size = UDim2.new(0.4, 0, 0.1, 0),
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.Ubuntu,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                u2.createElement("TextBox", {
                    Position = UDim2.new(0.35, 20, 0.1, 10),
                    Size = UDim2.new(0.12, 0, 0.1, 0),
                    Text = "",
                    PlaceholderText = u30.color:map(function(p50) --[[ Line: 361 ]]
                        return math.floor(p50.G * 255);
                    end),
                    PlaceholderColor3 = Color3.fromRGB(200, 200, 200),
                    BorderColor3 = Color3.fromRGB(60, 60, 60),
                    BackgroundColor3 = Color3.fromRGB(49, 49, 49),
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.Ubuntu,
                    TextScaled = true,
                    [u2.Event.FocusLost] = function(p51, p52) --[[ Line: 372 ]]
                        -- upvalues: u30 (copy)
                        local v53 = tonumber(p51.Text);
                        if p52 and v53 then
                            local v54 = u30.color:getValue();
                            u30.setColor(Color3.new(v54.R, v53 / 255, v54.B));
                        end;
                        p51.Text = "";
                    end
                }),
                u2.createElement("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = "Sat:",
                    RichText = true,
                    TextScaled = true,
                    Position = UDim2.new(0.55, 10, 0.1, 10),
                    Size = UDim2.new(0.4, 0, 0.1, 0),
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.Ubuntu,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                u2.createElement("TextBox", {
                    Position = UDim2.new(0.7, 20, 0.1, 10),
                    Size = UDim2.new(0.12, 0, 0.1, 0),
                    Text = "",
                    PlaceholderText = u30.color:map(function(p55) --[[ Line: 396 ]]
                        local _, v56, _ = p55:ToHSV();
                        return math.floor(v56 * 255);
                    end),
                    PlaceholderColor3 = Color3.fromRGB(200, 200, 200),
                    BorderColor3 = Color3.fromRGB(60, 60, 60),
                    BackgroundColor3 = Color3.fromRGB(49, 49, 49),
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.Ubuntu,
                    TextScaled = true,
                    [u2.Event.FocusLost] = function(p57, p58) --[[ Line: 408 ]]
                        -- upvalues: u30 (copy)
                        local v59 = tonumber(p57.Text);
                        if p58 and v59 then
                            local v60, _, v61 = u30.color:getValue():ToHSV();
                            u30.setColor(Color3.fromHSV(v60, v59 / 255, v61));
                        end;
                        p57.Text = "";
                    end
                }),
                u2.createElement("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = "Blue:",
                    RichText = true,
                    TextScaled = true,
                    Position = UDim2.new(0.2, 10, 0.2, 20),
                    Size = UDim2.new(0.4, 0, 0.1, 0),
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.Ubuntu,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                u2.createElement("TextBox", {
                    Position = UDim2.new(0.35, 20, 0.2, 20),
                    Size = UDim2.new(0.12, 0, 0.1, 0),
                    Text = "",
                    PlaceholderText = u30.color:map(function(p62) --[[ Line: 432 ]]
                        return math.floor(p62.B * 255);
                    end),
                    PlaceholderColor3 = Color3.fromRGB(200, 200, 200),
                    BorderColor3 = Color3.fromRGB(60, 60, 60),
                    BackgroundColor3 = Color3.fromRGB(49, 49, 49),
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.Ubuntu,
                    TextScaled = true,
                    [u2.Event.FocusLost] = function(p63, p64) --[[ Line: 443 ]]
                        -- upvalues: u30 (copy)
                        local v65 = tonumber(p63.Text);
                        if p64 and v65 then
                            local v66 = u30.color:getValue();
                            u30.setColor(Color3.new(v66.R, v66.G, v65 / 255));
                        end;
                        p63.Text = "";
                    end
                }),
                u2.createElement("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = "Val:",
                    RichText = true,
                    TextScaled = true,
                    Position = UDim2.new(0.55, 10, 0.2, 20),
                    Size = UDim2.new(0.4, 0, 0.1, 0),
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.Ubuntu,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                u2.createElement("TextBox", {
                    Position = UDim2.new(0.7, 20, 0.2, 20),
                    Size = UDim2.new(0.12, 0, 0.1, 0),
                    Text = "",
                    PlaceholderText = u30.color:map(function(p67) --[[ Line: 467 ]]
                        local _, _, v68 = p67:ToHSV();
                        return math.floor(v68 * 255);
                    end),
                    PlaceholderColor3 = Color3.fromRGB(200, 200, 200),
                    BorderColor3 = Color3.fromRGB(60, 60, 60),
                    BackgroundColor3 = Color3.fromRGB(49, 49, 49),
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.Ubuntu,
                    TextScaled = true,
                    [u2.Event.FocusLost] = function(p69, p70) --[[ Line: 479 ]]
                        -- upvalues: u30 (copy)
                        local v71 = tonumber(p69.Text);
                        if p70 and v71 then
                            local v72, v73 = u30.color:getValue():ToHSV();
                            u30.setColor(Color3.fromHSV(v72, v73, v71 / 255));
                        end;
                        p69.Text = "";
                    end
                }),
                u2.createElement("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = "Hex:",
                    RichText = true,
                    TextScaled = true,
                    Position = UDim2.new(0.2, 10, 0.4, 40),
                    Size = UDim2.new(0.4, 0, 0.1, 0),
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.Ubuntu,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                u2.createElement("TextBox", {
                    Position = UDim2.new(0.35, 20, 0.4, 40),
                    Size = UDim2.new(0.4, 0, 0.1, 0),
                    Text = "",
                    PlaceholderText = u30.color:map(function(p74) --[[ Line: 504 ]]
                        return p74:ToHex();
                    end),
                    PlaceholderColor3 = Color3.fromRGB(200, 200, 200),
                    BorderColor3 = Color3.fromRGB(60, 60, 60),
                    BackgroundColor3 = Color3.fromRGB(49, 49, 49),
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.Ubuntu,
                    TextScaled = true,
                    [u2.Event.FocusLost] = function(u75, p76) --[[ Line: 515 ]]
                        -- upvalues: u30 (copy)
                        local u77 = nil;
                        pcall(function() --[[ Line: 517 ]]
                            -- upvalues: u77 (ref), u75 (copy)
                            u77 = Color3.fromHex(u75.Text);
                        end);
                        if p76 and u77 then
                            u30.setColor(u77);
                        end;
                        u75.Text = "";
                    end
                })
            })
        }) });
end;
return v5;