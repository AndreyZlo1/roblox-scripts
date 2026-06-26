-- Services.RGEService.Components.RGEMaterialsComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local l__MaterialService__1 = game:GetService("MaterialService");
local l__RunService__2 = game:GetService("RunService");
local u3 = v1("RGEMaterialButtonComponent");
local v4 = u2.Component:extend("RGEMaterials");
function v4.init(u5) --[[ Line: 18 ]]
    -- upvalues: u2 (copy), l__RunService__2 (copy)
    u5.scroller = u2.createRef();
    local v6, v7 = u2.createBinding(0);
    u5.contentSize = v6;
    u5.updateContentSize = v7;
    u5.gridLayout = u2.createRef();
    u5.search = u2.createRef();
    u5._conn = l__RunService__2.Heartbeat:Connect(function() --[[ Line: 24 ]]
        -- upvalues: u5 (copy)
        local v8 = u5.gridLayout:getValue();
        if v8 then
            u5.updateContentSize(v8.AbsoluteContentSize.Y);
        end;
        local v9 = u5.search:getValue();
        if v9 and u5.state.Filter ~= v9.Text then
            u5:setState({
                Filter = v9.Text
            });
        end;
    end);
    u5:setState({
        Filter = ""
    });
end;
function v4.willUnmount(p10) --[[ Line: 45 ]]
    p10._conn:Disconnect();
end;
function v4.render(p11) --[[ Line: 49 ]]
    -- upvalues: l__MaterialService__1 (copy), u2 (copy), u3 (copy)
    local l__newConsoleLine__3 = p11.props.newConsoleLine;
    local l__addChange__4 = p11.props.addChange;
    local _ = p11.props.newSelection;
    local l__selection__5 = p11.props.selection;
    local v12 = {};
    for _, v13 in Enum.Material:GetEnumItems() do
        v12[#v12 + 1] = {
            BaseMaterial = v13
        };
    end;
    for _, v14 in l__MaterialService__1:GetDescendants() do
        if v14:IsA("MaterialVariant") then
            v12[#v12 + 1] = {
                BaseMaterial = v14.BaseMaterial,
                MaterialVariant = v14.Name
            };
        end;
    end;
    local l__Filter__6 = p11.state.Filter;
    local v15 = {};
    for v16, u17 in v12 do
        local u18 = u17.MaterialVariant and "BRM5/" .. u17.MaterialVariant or "RBLX/" .. u17.BaseMaterial.Name;
        if #l__Filter__6 <= 0 or u18:lower():find(l__Filter__6:lower()) then
            v15[v16] = u2.createElement(u3, {
                Name = u18,
                Scroller = p11.scroller,
                BaseMaterial = u17.BaseMaterial,
                MaterialVariant = u17.MaterialVariant,
                Callback = function() --[[ Name: Callback, Line 84 ]]
                    -- upvalues: l__selection__5 (copy), l__addChange__4 (copy), u17 (copy), l__newConsoleLine__3 (copy), u18 (copy)
                    local u19 = {};
                    for _, v20 in l__selection__5 do
                        if v20:IsA("BasePart") then
                            u19[#u19 + 1] = {
                                OldName = #v20.MaterialVariant > 0 and "BRM5/" .. v20.MaterialVariant or "RBLX/" .. v20.Material.Name,
                                OldMaterial = v20.Material,
                                OldVariant = v20.MaterialVariant,
                                Object = v20,
                                World = v20:GetAttribute("World"),
                                UID = v20:GetAttribute("UID")
                            };
                        end;
                    end;
                    l__addChange__4("Material", function(p21) --[[ Line: 102 ]]
                        -- upvalues: u19 (copy), u17 (ref), l__newConsoleLine__3 (ref), u18 (ref)
                        for _, v22 in u19 do
                            local v23 = p21(v22.Object, v22.World, v22.UID);
                            if v23 then
                                v23.Material = u17.BaseMaterial;
                                v23.MaterialVariant = u17.MaterialVariant or "";
                                l__newConsoleLine__3({
                                    "material",
                                    v22.World,
                                    v22.UID,
                                    u18
                                });
                            end;
                        end;
                    end, function(p24) --[[ Line: 114 ]]
                        -- upvalues: u19 (copy), l__newConsoleLine__3 (ref)
                        for _, v25 in u19 do
                            local v26 = p24(v25.Object, v25.World, v25.UID);
                            if v26 then
                                v26.Material = v25.OldMaterial;
                                v26.MaterialVariant = v25.OldVariant or "";
                                l__newConsoleLine__3({
                                    "material",
                                    v25.World,
                                    v25.UID,
                                    v25.OldName
                                });
                            end;
                        end;
                    end);
                end
            });
        end;
    end;
    return u2.createFragment({ u2.createElement("TextBox", {
            Position = UDim2.fromOffset(10, 10),
            Size = UDim2.new(1, -20, 0, 20),
            Text = "",
            BorderMode = Enum.BorderMode.Inset,
            PlaceholderText = "Search materials",
            PlaceholderColor3 = Color3.fromRGB(200, 200, 200),
            BorderColor3 = Color3.fromRGB(60, 60, 60),
            BackgroundColor3 = Color3.fromRGB(49, 49, 49),
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.Ubuntu,
            TextSize = 12,
            [u2.Ref] = p11.search
        }), u2.createElement("ScrollingFrame", {
            [u2.Ref] = p11.scroller,
            Selectable = false,
            Position = UDim2.fromOffset(0, 40),
            Size = UDim2.new(1, 0, 1, -40),
            BackgroundTransparency = 1,
            CanvasSize = p11.contentSize:map(function(p27) --[[ Line: 155 ]]
                return UDim2.fromOffset(0, p27);
            end),
            ScrollBarImageColor3 = Color3.fromRGB(0, 120, 212),
            ScrollBarThickness = 2,
            BottomImage = "rbxassetid://9653737922",
            MidImage = "rbxassetid://9653737922",
            TopImage = "rbxassetid://9653737922",
            BorderSizePixel = 0
        }, { u2.createFragment(v15), u2.createElement("UIGridLayout", {
                CellPadding = UDim2.fromOffset(5, 5),
                CellSize = UDim2.fromOffset(150, 150),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                [u2.Ref] = p11.gridLayout
            }) }) });
end;
return v4;