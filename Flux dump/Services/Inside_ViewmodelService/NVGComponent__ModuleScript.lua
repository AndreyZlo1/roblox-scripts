-- Services.ViewmodelService.NVGComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local l__RunService__1 = game:GetService("RunService");
local _, u1 = shared.import("require", "React");
local v2 = u1.Component:extend("NVG");
function v2.init(p3, _) --[[ Line: 6 ]]
    -- upvalues: u1 (copy), l__RunService__1 (copy)
    local v4, u5 = u1.createBinding(Vector2.new());
    p3.offset = v4;
    p3.update = l__RunService__1.Heartbeat:Connect(function() --[[ Line: 9 ]]
        -- upvalues: u5 (copy)
        u5(Vector2.new(math.random(), math.random()));
    end);
end;
function v2.componentWillUnmount(p6) --[[ Line: 14 ]]
    p6.update:Disconnect();
end;
function v2.render(p7) --[[ Line: 18 ]]
    -- upvalues: u1 (copy)
    local l__props__2 = p7.props;
    local l__Config__3 = l__props__2.Config;
    local v8 = { u1.createElement("Frame", {
            ZIndex = 3,
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(),
            BackgroundTransparency = l__props__2.Cover
        }) };
    if l__Config__3 then
        local l__Overlay__4 = l__props__2.Preset.Overlay;
        local l__Static__5 = l__props__2.Preset.Static;
        local l__Images__6 = l__Overlay__4.Images;
        local v9 = {};
        for v10, v11 in l__Images__6 do
            v9[v10] = u1.createElement("ImageLabel", {
                BackgroundTransparency = 1,
                Image = v11,
                Position = UDim2.fromScale((v10 - 1) / #l__Images__6),
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY
            });
        end;
        v8.Overlay = u1.createElement("Frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            Size = UDim2.fromScale(#l__Images__6, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0)
        }, { u1.createElement(u1.Fragment, nil, v9), u1.createElement("Frame", {
                BorderSizePixel = 0,
                Size = UDim2.fromScale(10, 1),
                Position = UDim2.fromScale(1, 0),
                BackgroundTransparency = l__Overlay__4.Transparency,
                BackgroundColor3 = Color3.new()
            }), u1.createElement("Frame", {
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(1, 0),
                Size = UDim2.fromScale(10, 1),
                Position = UDim2.fromScale(0, 0),
                BackgroundTransparency = l__Overlay__4.Transparency,
                BackgroundColor3 = Color3.new()
            }) });
        v8.Static = u1.createElement("ImageLabel", {
            BackgroundTransparency = 1,
            Image = l__Static__5.Image,
            ImageTransparency = l__Static__5.Transparency,
            ScaleType = Enum.ScaleType.Tile,
            TileSize = UDim2.fromOffset(1024 * l__Static__5.Scale, 1024 * l__Static__5.Scale),
            Size = UDim2.fromScale(10, 10),
            Position = p7.offset:map(function(p12) --[[ Line: 78 ]]
                return UDim2.fromScale(p12.X * 5, p12.Y * 5);
            end),
            AnchorPoint = p7.offset:map(function(p13) --[[ Line: 81 ]]
                return p13;
            end)
        });
    end;
    return u1.createElement(u1.Fragment, nil, v8);
end;
return v2;