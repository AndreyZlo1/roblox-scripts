-- Services.RGEService.Components.RGEMaterialButtonComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local u3 = v1("GameShellProxyButton");
local v4 = u2.Component:extend("RGETopButton");
function v4.init(p5) --[[ Line: 13 ]]
    -- upvalues: u2 (copy)
    local v6 = Instance.new("Camera");
    v6.CFrame = CFrame.new(0, 0, 8);
    p5.viewPort = u2.createRef();
    p5.camera = v6;
    p5.material = p5.props.BaseMaterial;
    p5.variant = p5.props.MaterialVariant;
    p5:setState({
        Hovering = false
    });
end;
function v4.didMount(p7) --[[ Line: 28 ]]
    local v8 = Instance.new("Part");
    v8.Shape = Enum.PartType.Ball;
    v8.Material = p7.material;
    if p7.variant then
        v8.MaterialVariant = p7.variant;
    end;
    v8.Size = Vector3.new(6, 6, 6);
    v8.CFrame = CFrame.new();
    v8.Parent = p7.viewPort:getValue();
end;
function v4.render(u9) --[[ Line: 40 ]]
    -- upvalues: u2 (copy), u3 (copy)
    local l__props__1 = u9.props;
    return u2.createElement(u3, {
        BorderSizePixel = 0,
        BackgroundColor3 = u9.state.Hovering and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(31, 31, 31),
        Scroller = l__props__1.Scroller,
        MouseEnter = function() --[[ Name: MouseEnter, Line 48 ]]
            -- upvalues: u9 (copy)
            u9:setState({
                Hovering = true
            });
        end,
        MouseLeave = function() --[[ Name: MouseLeave, Line 53 ]]
            -- upvalues: u9 (copy)
            u9:setState({
                Hovering = false
            });
        end,
        MouseDown = function() --[[ Name: MouseDown, Line 58 ]]
            -- upvalues: u9 (copy)
            u9.props.Callback();
        end
    }, { u2.createElement("ViewportFrame", {
            Ambient = Color3.fromRGB(135, 135, 135),
            LightColor = Color3.new(1, 1, 1),
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            CurrentCamera = u9.camera,
            [u2.Ref] = u9.viewPort
        }), u2.createElement("TextLabel", {
            BackgroundTransparency = 1,
            RichText = true,
            TextWrapped = true,
            TextSize = 12,
            Position = UDim2.new(0, 10, 1, -10),
            AnchorPoint = Vector2.new(0, 1),
            Size = UDim2.new(1, -20, 1, -20),
            Text = l__props__1.Name,
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.Ubuntu,
            TextYAlignment = Enum.TextYAlignment.Bottom,
            TextXAlignment = Enum.TextXAlignment.Left
        }) });
end;
return v4;