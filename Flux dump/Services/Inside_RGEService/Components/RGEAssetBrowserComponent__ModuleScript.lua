-- Services.RGEService.Components.RGEAssetBrowserComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4 = shared.import("require", "Roact", "asset", "server");
local l__Players__1 = game:GetService("Players");
game:GetService("HttpService");
local l__RunService__2 = game:GetService("RunService");
local l__TextService__3 = game:GetService("TextService");
local l__Assets__4 = game:GetService("ReplicatedStorage"):WaitForChild("Assets");
local u5 = v1("getMainFromModel");
local u6 = v1("Bots");
local u7 = v1("GameShellProxyButton");
local l__PlayerGui__5 = l__Players__1.LocalPlayer:WaitForChild("PlayerGui");
local u8 = v1("RGEAssetComponent");
local u9 = v1("RGEAssetLoadingComponent");
local v10 = u2.Component:extend("RGEAssetBrowser");
function v10.init(u11) --[[ Line: 34 ]]
    -- upvalues: u2 (copy), u4 (copy), u5 (copy), l__Assets__4 (copy), u6 (copy), u3 (copy), l__RunService__2 (copy), l__PlayerGui__5 (copy)
    u11.scroller = u2.createRef();
    u11.search = u2.createRef();
    local v12 = {};
    local function u31(p13, p14) --[[ Line: 39 ]]
        -- upvalues: u4 (ref), u31 (copy), u5 (ref), u11 (copy)
        if p14.Name:sub(1, 10) == "Deprecated" then
        elseif p14.Name == "Hidden" and not u4.HIDDEN_PROPS then
        else
            local v15 = {
                _type = "Folder",
                Children = {}
            };
            for _, u16 in p14:GetChildren() do
                if u16:IsA("Folder") then
                    u31(v15.Children, u16);
                elseif u16:IsA("Model") then
                    v15.Children[u16.Name] = {
                        _type = "Prefab",
                        Model = u16,
                        Callback = function() --[[ Name: Callback, Line 59 ]]
                            -- upvalues: u16 (copy), u5 (ref), u11 (ref)
                            local v17 = u16:Clone();
                            for _, v18 in v17:GetDescendants() do
                                if v18:IsA("BasePart") then
                                    v18.CanCollide = false;
                                    v18.CanTouch = false;
                                    v18.CanQuery = false;
                                    v18.AudioCanCollide = false;
                                end;
                            end;
                            u5(v17);
                            local v19 = v17:GetChildren();
                            if #v19 == 1 then
                                local v20 = v19[1];
                                v20.PivotOffset = CFrame.new();
                                v17.WorldPivot = v20.CFrame;
                            end;
                            u11.props.setPlace(v17, function(p21) --[[ Line: 78 ]]
                                -- upvalues: u11 (ref), u16 (ref)
                                local v22, v23, v24 = p21:ToOrientation();
                                local l__newConsoleLine__6 = u11.props.newConsoleLine;
                                local v25 = {};
                                local l__id__7 = u11.props.id;
                                local l__Name__8 = u16.Name;
                                local l__X__9 = p21.X;
                                local l__Y__10 = p21.Y;
                                local l__Z__11 = p21.Z;
                                local v26 = math.deg(v22);
                                local v27 = math.floor(v26);
                                local v28 = math.deg(v23);
                                local v29 = math.floor(v28);
                                local v30 = math.deg(v24);
                                v25[1], v25[2], v25[3], v25[4], v25[5], v25[6], v25[7], v25[8], v25[9] = "spawn", l__id__7, l__Name__8, l__X__9, l__Y__10, l__Z__11, v27, v29, math.floor(v30);
                                l__newConsoleLine__6(v25);
                            end);
                        end
                    };
                end;
            end;
            p13[p14.Name] = v15;
        end;
    end;
    u31(v12, l__Assets__4:WaitForChild("Models"):WaitForChild("Prefab"));
    local v32 = {};
    for u33, v34 in u6 do
        if not v34.Hidden then
            local v35 = string.split(u33, "_");
            if not v32[v35[1]] then
                v32[v35[1]] = {
                    _type = "Folder",
                    Children = {}
                };
            end;
            v32[v35[1]].Children[u33] = {
                _type = "Prefab",
                Model = l__Assets__4.Models.Character.Male:Clone(),
                Callback = function() --[[ Name: Callback, Line 109 ]]
                    -- upvalues: u3 (ref), u11 (copy), u33 (copy)
                    local v36 = u3:Get("Shared", "Models", "Character", "Spawner").Asset:Clone();
                    v36.Parent = workspace;
                    u11.props.setPlace(v36, function(p37) --[[ Line: 113 ]]
                        -- upvalues: u11 (ref), u33 (ref)
                        local _, v38 = p37:ToOrientation();
                        local l__newConsoleLine__12 = u11.props.newConsoleLine;
                        local v39 = {};
                        local l__id__13 = u11.props.id;
                        local v40 = u33;
                        local v41 = math.round(p37.X * 1000) / 1000;
                        local v42 = math.round(p37.Y * 1000) / 1000;
                        local v43 = math.round(p37.Z * 1000) / 1000;
                        local v44 = math.deg(v38);
                        v39[1], v39[2], v39[3], v39[4], v39[5], v39[6], v39[7], v39[8] = "bot", "spawn", l__id__13, v40, v41, v42, v43, math.floor(v44);
                        l__newConsoleLine__12(v39);
                    end);
                end
            };
        end;
    end;
    local v46 = {
        [#v46 + 1] = l__RunService__2.Heartbeat:Connect(function() --[[ Line: 122 ]]
            -- upvalues: u11 (copy)
            local v45 = u11.search:getValue();
            if v45 and u11.state.filter ~= v45.Text then
                u11:setState({
                    filter = v45.Text
                });
            end;
        end)
    };
    v12.Bot = {
        _type = "Folder",
        Children = v32
    };
    local u47 = {};
    local u48 = l__PlayerGui__5:FindFirstChild("__RGE");
    if u48 then
        local function u55() --[[ Line: 141 ]]
            -- upvalues: u47 (copy), u48 (copy), u11 (copy)
            for v49 in u47 do
                u47[v49] = nil;
            end;
            for _, u50 in u48:GetChildren() do
                u47[u50.Name] = {
                    _type = "Prefab",
                    Model = u50:Clone(),
                    Callback = function() --[[ Name: Callback, Line 150 ]]
                        -- upvalues: u50 (copy), u11 (ref)
                        local v51 = u50:Clone();
                        for _, v52 in v51:GetChildren() do
                            if v52:IsA("BasePart") then
                                v52.CanCollide = false;
                                v52.CanTouch = false;
                                v52.CanQuery = false;
                            end;
                        end;
                        v51.Parent = workspace;
                        u11.props.setPlace(v51, function(p53) --[[ Line: 161 ]]
                            -- upvalues: u11 (ref), u50 (ref)
                            local _, v54 = p53:ToOrientation();
                            u11.props.newConsoleLine({
                                "file",
                                "insertmodel",
                                u11.props.id,
                                u50.Name,
                                p53.X,
                                p53.Y,
                                p53.Z,
                                (math.deg(v54))
                            });
                        end);
                    end
                };
            end;
            if not u48:GetAttribute("Loaded") then
                u47.__Loading = {
                    _type = "Loading"
                };
            end;
        end;
        local function v56() --[[ Line: 176 ]]
            -- upvalues: u55 (copy), u11 (copy)
            u55();
            local l__address__14 = u11.state.address;
            if l__address__14[1] == "Root" and l__address__14[2] == "Saved" then
                u11:setState({});
            end;
        end;
        v46[#v46 + 1] = u48:GetAttributeChangedSignal("Loaded"):Connect(v56);
        v46[#v46 + 1] = u48.ChildAdded:Connect(v56);
        v46[#v46 + 1] = u48.ChildRemoved:Connect(v56);
        u55();
    end;
    v12.Saved = {
        _type = "Folder",
        Children = u47
    };
    u11.connections = v46;
    u11.list = v12;
    u11:setState({
        filter = "",
        hover = "",
        address = { "Root" }
    });
end;
function v10.willUnmount(p57) --[[ Line: 206 ]]
    for _, v58 in p57.connections do
        v58:Disconnect();
    end;
end;
function v10.render(u59) --[[ Line: 212 ]]
    -- upvalues: u2 (copy), u7 (copy), l__TextService__3 (copy), u9 (copy), u8 (copy)
    local l__address__15 = u59.state.address;
    local l__hover__16 = u59.state.hover;
    local l__list__17 = u59.list;
    local v60 = {
        List = u2.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            Padding = UDim.new(0, 0)
        })
    };
    for v61 = 1, #l__address__15 do
        local v62 = v61 * 2;
        local v63 = v62 - 1;
        local u64 = l__address__15[v61];
        local u65 = {};
        for v66 = 1, v61 do
            u65[v66] = l__address__15[v66];
        end;
        if v61 > 1 then
            l__list__17 = l__list__17[u64].Children;
        end;
        local l__createElement__18 = u2.createElement;
        local v67 = u7;
        local v69 = {
            BackgroundTransparency = 1,
            LayoutOrder = v63,
            Size = UDim2.new(0, l__TextService__3:GetTextSize(u64, 16, Enum.Font.Ubuntu, Vector2.new((1 / 0), (1 / 0))).X + 20, 1, 0),
            MouseDown = function() --[[ Name: MouseDown, Line 243 ]]
                -- upvalues: u59 (copy), u65 (copy)
                u59:setState({
                    address = u65
                });
            end,
            MouseEnter = function() --[[ Name: MouseEnter, Line 248 ]]
                -- upvalues: u59 (copy), u64 (copy)
                u59:setState({
                    hover = u64
                });
            end,
            MouseLeave = function() --[[ Name: MouseLeave, Line 253 ]]
                -- upvalues: u59 (copy), u64 (copy)
                u59:setState(function(p68) --[[ Line: 254 ]]
                    -- upvalues: u64 (ref)
                    return {
                        hover = p68.hover == u64 and "" or p68.hover
                    };
                end);
            end
        };
        local v70 = {};
        local l__createElement__19 = u2.createElement;
        local v71 = "TextLabel";
        local v72 = {
            BackgroundTransparency = 1,
            RichText = true,
            TextSize = 14,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0)
        };
        if l__hover__16 == u64 then
            u64 = "<b>" .. u64 .. "</b>" or u64;
        end;
        v72.Text = u64;
        v72.Font = Enum.Font.Ubuntu;
        v72.TextColor3 = Color3.new(1, 1, 1);
        v70.File = l__createElement__19(v71, v72);
        v60[v63] = l__createElement__18(v67, v69, v70);
        v60[v62] = u2.createElement("TextLabel", {
            BackgroundTransparency = 1,
            Text = "<b>|</b>",
            RichText = true,
            TextSize = 10,
            Size = UDim2.new(0, 20, 1, 0),
            Font = Enum.Font.Ubuntu,
            LayoutOrder = v62,
            TextColor3 = Color3.new(1, 1, 1)
        });
    end;
    v60.Search = u2.createElement("TextBox", {
        Size = UDim2.new(0.1, 0, 1, 0),
        Text = "",
        LayoutOrder = #l__address__15 * 2 + 1,
        BorderMode = Enum.BorderMode.Inset,
        PlaceholderText = "Search assets",
        PlaceholderColor3 = Color3.fromRGB(200, 200, 200),
        BorderColor3 = Color3.fromRGB(60, 60, 60),
        BackgroundColor3 = Color3.fromRGB(49, 49, 49),
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.Ubuntu,
        TextSize = 12,
        [u2.Ref] = u59.search
    });
    local u73 = {
        List = u2.createElement("UIGridLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.Name,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            StartCorner = Enum.StartCorner.TopLeft,
            CellPadding = UDim2.fromOffset(5, 5),
            CellSize = UDim2.new(0, 150, 0, 150)
        })
    };
    local u74 = u59.state.filter:lower();
    local function u81(p75, p76) --[[ Line: 314 ]]
        -- upvalues: u73 (copy), u2 (ref), u9 (ref), u74 (copy), u81 (copy), u8 (ref), u59 (copy)
        local v77 = table.clone(p76);
        for v78, v79 in p75 do
            if v79._type == "Loading" then
                u73.ZZZZZZZZZZZ = u2.createElement(u9, {});
            else
                local u80 = table.clone(v77);
                u80[#u80 + 1] = v78;
                if #u74 > 0 then
                    if v79.Children then
                        u81(v79.Children, u80);
                    end;
                    if v78:lower():find(u74) then
                        u73[table.concat(v77, "_") .. "_" .. v78] = u2.createElement(u8, {
                            Name = v78,
                            Model = v79.Model,
                            Scroller = u59.scroller,
                            Callback = v79.Callback or function() --[[ Line: 339 ]]
                                -- upvalues: u59 (ref), u80 (copy)
                                u59:setState({
                                    filter = "",
                                    address = u80
                                });
                                u59.search:getValue().Text = "";
                            end
                        });
                    end;
                else
                    u73[table.concat(v77, "_") .. "_" .. v78] = u2.createElement(u8, {
                        Name = v78,
                        Model = v79.Model,
                        Scroller = u59.scroller,
                        Callback = v79.Callback or function() --[[ Line: 339 ]]
                            -- upvalues: u59 (ref), u80 (copy)
                            u59:setState({
                                filter = "",
                                address = u80
                            });
                            u59.search:getValue().Text = "";
                        end
                    });
                end;
            end;
        end;
    end;
    u81(l__list__17, u59.state.address);
    return u2.createFragment({
        Directory = u2.createElement("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 0)
        }, {
            Address = u2.createElement("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 20, 0, 0)
            }, v60),
            Dots = u2.createElement("TextLabel", {
                BackgroundTransparency = 1,
                Text = "<b>::</b>",
                RichText = true,
                TextSize = 14,
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.Ubuntu,
                TextColor3 = Color3.new(0.8, 0.8, 0.8)
            })
        }),
        Content = u2.createElement("ScrollingFrame", {
            [u2.Ref] = u59.scroller,
            Selectable = false,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Position = UDim2.new(0, 10, 0, 28),
            Size = UDim2.new(1, -10, 1, -28),
            BackgroundTransparency = 1,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarImageColor3 = Color3.fromRGB(0, 120, 212),
            ScrollBarThickness = 2,
            BottomImage = "rbxassetid://9653737922",
            MidImage = "rbxassetid://9653737922",
            TopImage = "rbxassetid://9653737922",
            BorderSizePixel = 0
        }, u73)
    });
end;
return v10;