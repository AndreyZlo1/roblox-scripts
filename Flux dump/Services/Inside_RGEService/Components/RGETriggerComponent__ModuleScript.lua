-- Services.RGEService.Components.RGETriggerComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3 = shared.import("require", "Roact", "server");
local l__HttpService__1 = game:GetService("HttpService");
game:GetService("Players");
local u4 = v1("RGEScrollComponent");
local v5 = u2.Component:extend("RGETrigger");
local u6 = {};
u6.__index = u6;
function u6.new(p7, p8) --[[ Line: 18 ]]
    -- upvalues: u6 (copy)
    local v9 = {
        _encodedValue = workspace:WaitForChild("__RGE"):WaitForChild(p7):WaitForChild("Triggers"):WaitForChild(p8),
        Name = p8,
        World = p7
    };
    local v10 = setmetatable(v9, u6);
    v10:Sync();
    return v10;
end;
function u6.Sync(p11) --[[ Line: 32 ]]
    -- upvalues: l__HttpService__1 (copy)
    local l___encodedValue__2 = p11._encodedValue;
    if l___encodedValue__2 then
        local v12 = l__HttpService__1:JSONDecode(l___encodedValue__2.Value);
        p11.Color = Color3.new(v12.Color[1], v12.Color[2], v12.Color[3]);
        p11.Active = v12.Active;
        p11.Executable = v12.Executable;
        p11.Players = v12.Players;
        p11.Bots = v12.Bots;
        p11.Helicopters = v12.Helicopters;
        p11.Ground = v12.Ground;
        p11.IsLooping = v12.IsLooping;
    end;
end;
function u6.IsA(_, p13) --[[ Line: 47 ]]
    return p13 == "Trigger";
end;
function v5.init(u14, u15) --[[ Line: 52 ]]
    -- upvalues: u2 (copy), u3 (copy), u6 (copy)
    local u16 = {};
    u14.count = 0;
    u14.nameRef = u2.createRef();
    local function u25() --[[ Line: 57 ]]
        -- upvalues: u14 (copy), u3 (ref), u15 (copy), u16 (copy), u6 (ref)
        u14.count = 0;
        local v17 = u3["TRIGGER_GROUP_" .. u15.id];
        local v18 = {};
        for v19 in u16 do
            local v20 = false;
            for _, v21 in v17 or {} do
                if v21[1] == v19 then
                    v20 = true;
                    break;
                end;
            end;
            if not v20 then
                u16[v19] = nil;
            end;
        end;
        if v17 then
            u14.count = #v17;
            for _, v22 in v17 do
                local v23 = v22[1];
                local v24 = u16[v23];
                if v24 then
                    v24:Sync();
                else
                    v24 = u6.new(u15.id, v23);
                    u16[v23] = v24;
                end;
                v18[v24] = {
                    Name = v24.Name,
                    Icon = v22[5] and "rbxassetid://95657565543350" or "rbxassetid://96064920474322",
                    Color = v24.Color
                };
            end;
        end;
        u14:setState({
            triggers = v18
        });
    end;
    u3.Changed:Connect(function() --[[ Line: 101 ]]
        -- upvalues: u25 (copy)
        u25();
    end);
    u25();
end;
function v5.willUnmount(_) --[[ Line: 107 ]] end;
function v5.render(u26) --[[ Line: 111 ]]
    -- upvalues: u2 (copy), u4 (copy)
    return u2.createFragment({ u2.createElement("Frame", {
            ZIndex = 2,
            BackgroundColor3 = Color3.fromRGB(24, 24, 24),
            BorderColor3 = Color3.fromRGB(43, 43, 43),
            BorderMode = Enum.BorderMode.Inset,
            Position = UDim2.fromOffset(-1, 0),
            Size = UDim2.new(1, 1, 0, 26)
        }, {
            Name = u2.createElement("TextLabel", {
                BackgroundTransparency = 1,
                Text = "Name",
                TextSize = 14,
                FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
                Position = UDim2.new(0, 10, 0.2, 0),
                Size = UDim2.new(0.5, -20, 0.6, 0),
                TextColor3 = Color3.new(1, 1, 1),
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Value = u2.createElement("TextBox", {
                BackgroundColor3 = Color3.fromRGB(24, 24, 24),
                BorderColor3 = Color3.fromRGB(43, 43, 43),
                ClearTextOnFocus = false,
                ClipsDescendants = true,
                FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
                PlaceholderText = "Trigger" .. u26.count + 1,
                Position = UDim2.fromScale(0.2, 0),
                Size = UDim2.fromScale(0.8, 1),
                Text = "",
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 14,
                [u2.Ref] = u26.nameRef
            })
        }), u2.createElement("TextButton", {
            BackgroundColor3 = Color3.fromRGB(31, 31, 31),
            BorderColor3 = Color3.fromRGB(35, 37, 43),
            BorderMode = Enum.BorderMode.Inset,
            BorderSizePixel = 0,
            Text = "",
            Position = UDim2.fromOffset(0, 25),
            Size = UDim2.new(1, 0, 0, 25),
            [u2.Event.MouseButton1Click] = function() --[[ Line: 156 ]]
                -- upvalues: u26 (copy)
                local v27 = u26.nameRef:getValue();
                local l__Text__3 = v27.Text;
                if #v27.Text == 0 then
                    l__Text__3 = "Trigger" .. u26.count + 1;
                end;
                u26.props.newConsoleLine({
                    "trigger",
                    "create",
                    u26.props.id,
                    l__Text__3
                });
                v27.Text = "";
            end
        }, { u2.createElement("TextLabel", {
                BackgroundTransparency = 1,
                RichText = true,
                Text = "Add",
                TextSize = 14,
                FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
                Position = UDim2.fromScale(0, 0.2),
                Size = UDim2.fromScale(1, 0.6),
                TextColor3 = Color3.new(1, 1, 1),
                TextTruncate = Enum.TextTruncate.AtEnd
            }) }), u2.createElement(u4, {
            Size = UDim2.new(1, 0, 1, -50),
            Position = UDim2.fromOffset(0, 50),
            data = u26.state.triggers,
            selection = u26.props.selection,
            newSelection = u26.props.newSelection
        }) });
end;
return v5;