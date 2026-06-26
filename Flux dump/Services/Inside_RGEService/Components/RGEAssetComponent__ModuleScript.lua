-- Services.RGEService.Components.RGEAssetComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local v3 = u2.Component:extend("RGEAsset");
local u4 = v1("isTintable");
local u5 = v1("GameShellProxyButton");
function v3.init(p6, p7) --[[ Line: 14 ]]
    -- upvalues: u2 (copy), u4 (copy)
    p6.cameraRef = u2.createRef();
    p6.viewportRef = u2.createRef();
    local l__Model__1 = p7.Model;
    if l__Model__1 then
        l__Model__1 = p7.Model:Clone();
    end;
    local v8;
    if l__Model__1 then
        if u4(l__Model__1) then
            p6.ColorWheel = true;
        end;
        l__Model__1:PivotTo(CFrame.new());
        local _, v9 = l__Model__1:GetBoundingBox();
        v8 = math.max(v9.X, v9.Y, v9.Z) + 1;
    else
        v8 = 0;
    end;
    p6:setState({
        Hovering = false,
        Distance = v8,
        Model = l__Model__1,
        Name = p7.Name
    });
end;
function v3.render(u10) --[[ Line: 39 ]]
    -- upvalues: u2 (copy), u5 (copy)
    local l__createElement__2 = u2.createElement;
    local v11 = u5;
    local v12 = {
        ClipsDescendants = true,
        BorderSizePixel = 0,
        BackgroundColor3 = u10.state.Hovering and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(31, 31, 31),
        Scroller = u10.props.Scroller,
        MouseEnter = function() --[[ Name: MouseEnter, Line 46 ]]
            -- upvalues: u10 (copy)
            u10:setState({
                Hovering = true
            });
        end,
        MouseLeave = function() --[[ Name: MouseLeave, Line 51 ]]
            -- upvalues: u10 (copy)
            u10:setState({
                Hovering = false
            });
        end,
        MouseDown = function() --[[ Name: MouseDown, Line 56 ]]
            -- upvalues: u10 (copy)
            u10.props.Callback();
        end
    };
    local v13 = {
        Name = u2.createElement("TextLabel", {
            BackgroundTransparency = 1,
            RichText = true,
            TextWrapped = true,
            TextSize = 12,
            ZIndex = 2,
            Position = UDim2.new(0, 10, 1, -10),
            AnchorPoint = Vector2.new(0, 1),
            Size = UDim2.new(1, -20, 1, -20),
            Text = u10.state.Name,
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.Ubuntu,
            TextYAlignment = Enum.TextYAlignment.Bottom,
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        Icon = u10.props.Model and u2.createElement("ViewportFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 130, 0, 130),
            Position = UDim2.fromOffset(10, 10),
            CurrentCamera = u10.cameraRef,
            [u2.Ref] = u10.viewportRef
        }, {
            Camera = u2.createElement("Camera", {
                CFrame = CFrame.new(Vector3.new(-1, 1, -1) * u10.state.Distance, Vector3.new(0, 0, 0)),
                FieldOfView = 40,
                [u2.Ref] = u10.cameraRef
            })
        }) or u2.createElement("ImageLabel", {
            BackgroundTransparency = 1,
            Image = "rbxassetid://9756346853",
            Size = UDim2.new(0, 70, 0, 70),
            Position = UDim2.new(0.5, -35, 0.5, -35)
        })
    };
    local l__ColorWheel__3 = u10.ColorWheel;
    if l__ColorWheel__3 then
        l__ColorWheel__3 = u2.createElement("ImageLabel", {
            BackgroundTransparency = 1,
            Image = "rbxassetid://100027525306524",
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -15, 0, 15),
            Size = UDim2.fromOffset(24, 24)
        });
    end;
    v13[1] = l__ColorWheel__3;
    return l__createElement__2(v11, v12, v13);
end;
function v3.willUnmount(p14) --[[ Line: 103 ]]
    local l__Model__4 = p14.state.Model;
    if l__Model__4 then
        l__Model__4.Parent = nil;
    end;
end;
function v3.didMount(p15) --[[ Line: 110 ]]
    local l__Model__5 = p15.state.Model;
    if l__Model__5 then
        l__Model__5.Parent = p15.viewportRef:getValue();
    end;
end;
return v3;