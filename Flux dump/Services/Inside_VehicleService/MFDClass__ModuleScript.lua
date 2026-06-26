-- Services.VehicleService.MFDClass
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1 = shared.import("require")("MFDs");
local u2 = { Color3.fromRGB(60, 255, 0), Color3.fromRGB(244, 255, 17), Color3.fromRGB(228, 4, 4) };
local u3 = {};
u3.__index = u3;
function u3._pageMeetsCondition(p4, p5) --[[ Line: 14 ]]
    return p4._config.Pages[p5].Condition(p4._vehicle);
end;
function u3._initPage(u6, p7) --[[ Line: 18 ]]
    -- upvalues: u2 (copy)
    u6._page = p7;
    u6._hooks = {};
    local l___vehicle__1 = u6._vehicle;
    local l___frame__2 = u6._frame;
    l___frame__2:ClearAllChildren();
    u6.Variables = {};
    local v8 = u6._config.Pages[p7];
    u6.Page = v8;
    if v8.Variables then
        for v9, v10 in v8.Variables do
            u6.Variables[v9] = v10;
        end;
    end;
    local function u305(p11, p12, p13) --[[ Line: 36 ]]
        -- upvalues: u6 (copy), l___vehicle__1 (copy), u2 (ref), u305 (copy)
        for _, v14 in p12 do
            local u15 = {};
            local u16 = {};
            local v17 = v14[1];
            local v18 = table.clone(v14[2]);
            local v19 = nil;
            if v17 == "Text" then
                local l__TextColor3__3 = v18.TextColor3;
                v18.TextColor3 = nil;
                v19 = Instance.new("TextLabel");
                v19.BackgroundTransparency = 1;
                v19.TextScaled = true;
                v19.FontFace = Font.new("rbxasset://fonts/families/RobotoCondensed.json");
                v19.TextColor3 = l__TextColor3__3 or Color3.new(0, 1, 0);
            elseif v17 == "Frame" then
                v19 = Instance.new("Frame");
            elseif v17 == "Demo" then
                v19 = Instance.new("Frame");
                v19.AnchorPoint = Vector2.new(1, 0.5);
                v19.Position = UDim2.fromScale(0.95, 0.55);
                v19.Size = UDim2.fromScale(0.3, 0.2);
                v19.BackgroundColor3 = Color3.new(1, 1, 0);
                v19.BorderSizePixel = 0;
                local v20 = Instance.new("TextLabel");
                v20.Text = "THIS PAGE IS INCOMPLETE\nALL HELICOPTERS WILL RECEIVE MFDs (SCREENS) SOON";
                v20.Position = UDim2.fromScale(0.05, 0.05);
                v20.Size = UDim2.fromScale(0.9, 0.9);
                v20.BackgroundTransparency = 1;
                v20.TextScaled = true;
                v20.FontFace = Font.new("rbxasset://fonts/families/RobotoCondensed.json");
                v20.TextXAlignment = Enum.TextXAlignment.Center;
                v20.TextColor3 = Color3.new(0, 0, 0);
                v20.Parent = v19;
            elseif v17 == "Gyro" then
                v19 = Instance.new("Frame");
                v19.AnchorPoint = Vector2.new(0.5, 0.5);
                v19.BackgroundColor3 = Color3.new(0, 0, 0);
                v19.BorderSizePixel = 0;
                v19.SizeConstraint = Enum.SizeConstraint.RelativeYY;
                local v21 = Instance.new("Frame");
                v21.ZIndex = 2;
                v21.BackgroundColor3 = Color3.new(0, 0, 0);
                v21.Size = UDim2.fromScale(0.15, 1);
                v21.BorderSizePixel = 0;
                v21.Parent = v19;
                local v22 = Instance.new("Frame");
                v22.BackgroundColor3 = Color3.new(1, 1, 1);
                v22.Position = UDim2.fromScale(1, 0.5);
                v22.AnchorPoint = Vector2.new(0, 0.5);
                v22.Size = UDim2.fromScale(0.025, 0.655);
                v22.BorderSizePixel = 0;
                v22.Parent = v21;
                local v23 = Instance.new("Frame");
                v23.ZIndex = 2;
                v23.BackgroundColor3 = Color3.new(0, 0, 0);
                v23.Position = UDim2.fromScale(0.85, 0);
                v23.Size = UDim2.fromScale(0.15, 1);
                v23.BorderSizePixel = 0;
                v23.Parent = v19;
                local v24 = Instance.new("Frame");
                v24.BackgroundColor3 = Color3.new(1, 1, 1);
                v24.Position = UDim2.fromScale(0, 0.5);
                v24.AnchorPoint = Vector2.new(1, 0.5);
                v24.Size = UDim2.fromScale(0.025, 0.655);
                v24.BorderSizePixel = 0;
                v24.Parent = v23;
                local v25 = Instance.new("Frame");
                v25.BorderSizePixel = 0;
                v25.BackgroundColor3 = Color3.new(1, 1, 1);
                v25.Size = UDim2.fromScale(0.95, 0.95);
                v25.Position = UDim2.fromScale(0.5, 0.5);
                v25.AnchorPoint = Vector2.new(0.5, 0.5);
                v25.Parent = v19;
                local v26 = Instance.new("UICorner");
                v26.CornerRadius = UDim.new(0.5, 0);
                v26.Parent = v25;
                local v27 = Instance.new("UIStroke");
                v27.Color = Color3.new(1, 1, 1);
                v27.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize;
                v27.Thickness = 0.005;
                v27.Parent = v25;
                local u28 = Instance.new("UIGradient");
                u28.Rotation = 90;
                u28.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 60, 213)),
                    ColorSequenceKeypoint.new(0.498, Color3.fromRGB(0, 60, 213)),
                    ColorSequenceKeypoint.new(0.501, Color3.fromRGB(76, 16, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(76, 16, 0))
                });
                u28.Parent = v25;
                u6._hooks[#u6._hooks + 1] = {
                    Update = function(_) --[[ Name: Update, Line 141 ]]
                        -- upvalues: l___vehicle__1 (ref), u28 (copy)
                        local v29, _, v30 = l___vehicle__1.CFrame:ToOrientation();
                        local v31 = u28;
                        local l__new__4 = Vector2.new;
                        local v32 = math.deg(v29) / 45;
                        v31.Offset = l__new__4(0, (math.clamp(v32, -1, 1)));
                        u28.Rotation = math.deg(v30) + 90;
                    end
                };
            elseif v17 == "EICAS_Warn" then
                local u33 = Instance.new("Frame");
                u33.BackgroundTransparency = 1;
                local v34 = Instance.new("UIListLayout");
                v34.SortOrder = Enum.SortOrder.LayoutOrder;
                v34.Parent = u33;
                local l__Logs__5 = v18.Logs;
                v18.Logs = nil;
                local u35 = 0;
                local u36 = {};
                u6._hooks[#u6._hooks + 1] = {
                    Update = function(_) --[[ Name: Update, Line 161 ]]
                        -- upvalues: l__Logs__5 (copy), l___vehicle__1 (ref), u36 (copy), u2 (ref), u35 (ref), u33 (ref)
                        local v37 = {};
                        for _, v38 in l__Logs__5 do
                            if l___vehicle__1.Warnings[v38] then
                                v37[v38] = true;
                                if not u36[v38] then
                                    local v39 = Instance.new("TextLabel");
                                    v39.Size = UDim2.fromScale(1, 0.15);
                                    v39.BorderSizePixel = 0;
                                    v39.TextXAlignment = Enum.TextXAlignment.Left;
                                    v39.Text = v38;
                                    v39.BackgroundColor3 = Color3.new();
                                    v39.TextColor3 = u2[2];
                                    v39.LayoutOrder = u35;
                                    v39.TextScaled = true;
                                    v39.FontFace = Font.new("rbxasset://fonts/families/RobotoCondensed.json");
                                    v39.Parent = u33;
                                    u35 = u35 + 1;
                                    u36[v38] = {
                                        Text = v39,
                                        Started = tick() + math.random(0, 100) / 100
                                    };
                                end;
                            end;
                        end;
                        for v40, v41 in u36 do
                            if v37[v40] then
                                local v42 = (tick() - v41.Started) % 1 < 0.5;
                                v41.Text.TextColor3 = v42 and Color3.new() or u2[2];
                                v41.Text.BackgroundColor3 = v42 and u2[2] or Color3.new();
                            else
                                v41.Text:Destroy();
                                u36[v40] = nil;
                            end;
                        end;
                    end
                };
                v19 = u33;
            elseif v17 == "EICAS_Log" then
                v19 = Instance.new("Frame");
                v19.BackgroundColor3 = Color3.new();
                v19.BorderSizePixel = 5;
                v19.BorderColor3 = Color3.new(1, 1, 1);
                local v43 = Instance.new("ImageLabel");
                v43.BackgroundTransparency = 1;
                v43.Image = "rbxassetid://137191725617352";
                v43.Position = UDim2.fromScale(0, -0.055);
                v43.Size = UDim2.fromScale(0.2, 0.1);
                v43.AnchorPoint = Vector2.new(0, 1);
                v43.Parent = v19;
                local v44 = Instance.new("ImageLabel");
                v44.BackgroundTransparency = 1;
                v44.Image = "rbxassetid://137191725617352";
                v44.Position = UDim2.fromScale(0, 1.055);
                v44.Size = UDim2.fromScale(0.2, 0.1);
                v44.Rotation = 180;
                v44.Parent = v19;
                local v45 = Instance.new("TextLabel");
                v45.Text = "P\nA\nG\nE";
                v45.Position = UDim2.fromScale(-0.05, 0.15);
                v45.Size = UDim2.fromScale(0.07, 0.5);
                v45.AnchorPoint = Vector2.new(1, 0);
                v45.BackgroundColor3 = Color3.new();
                v45.BorderSizePixel = 5;
                v45.BorderColor3 = Color3.new(1, 1, 1);
                v45.TextScaled = true;
                v45.FontFace = Font.new("rbxasset://fonts/families/RobotoCondensed.json");
                v45.TextXAlignment = Enum.TextXAlignment.Center;
                v45.TextColor3 = Color3.new(1, 1, 1);
                v45.Parent = v19;
                local v46 = Instance.new("ImageLabel");
                v46.BackgroundTransparency = 1;
                v46.Image = "rbxassetid://137191725617352";
                v46.Position = UDim2.new(0, 0, 0, -10);
                v46.Size = UDim2.fromScale(1, 0.2);
                v46.AnchorPoint = Vector2.new(0, 1);
                v46.Parent = v45;
                local v47 = Instance.new("ImageLabel");
                v47.BackgroundTransparency = 1;
                v47.Image = "rbxassetid://137191725617352";
                v47.Position = UDim2.new(0, 0, 1, 10);
                v47.Size = UDim2.fromScale(1, 0.2);
                v47.AnchorPoint = Vector2.new(0, 0);
                v47.Rotation = 180;
                v47.Parent = v45;
                local u48 = Instance.new("TextLabel");
                u48.Text = "PAGE 1 OF 1";
                u48.Position = UDim2.new(0, 0, 1.03, 5);
                u48.Size = UDim2.fromScale(1, 0.12);
                u48.BackgroundTransparency = 1;
                u48.TextScaled = true;
                u48.FontFace = Font.new("rbxasset://fonts/families/RobotoCondensed.json");
                u48.TextXAlignment = Enum.TextXAlignment.Center;
                u48.TextColor3 = Color3.new(1, 1, 1);
                u48.Parent = v19;
                local u49 = {};
                for v50 = 1, 7 do
                    local v51 = Instance.new("TextLabel");
                    v51.Size = UDim2.fromScale(1, 0.15);
                    v51.Position = UDim2.fromScale(0, (v50 - 1) * 0.15);
                    v51.TextXAlignment = Enum.TextXAlignment.Left;
                    v51.BackgroundColor3 = Color3.new();
                    v51.BorderSizePixel = 0;
                    v51.TextColor3 = Color3.new(1, 1, 1);
                    v51.TextScaled = true;
                    v51.FontFace = Font.new("rbxasset://fonts/families/RobotoCondensed.json");
                    v51.Visible = false;
                    v51.Parent = v19;
                    u49[v50] = v51;
                end;
                local u52 = {};
                local u53 = 1;
                function u6.Variables.EICAS_LOG_CHANGE_PAGE(p54) --[[ Line: 284 ]]
                    -- upvalues: u52 (copy), u53 (ref)
                    local v55 = math.ceil(#u52 / 7);
                    local v56 = math.max(1, v55);
                    u53 = math.clamp(u53 + p54, 1, v56);
                end;
                u6._hooks[#u6._hooks + 1] = {
                    Update = function(_) --[[ Name: Update, Line 290 ]]
                        -- upvalues: u52 (copy), u53 (ref), u49 (copy), u48 (copy)
                        local v57 = math.ceil(#u52 / 7);
                        local v58 = math.max(1, v57);
                        if v58 < u53 then
                            u53 = v58;
                        end;
                        for v59 = 1, 7 do
                            local v60 = v59 + (u53 - 1) * 7;
                            if u52[v60] then
                                u49[v59].Visible = true;
                                u49[v59].Text = u52[v60];
                            else
                                u49[v59].Visible = false;
                            end;
                        end;
                        u48.Text = "PAGE " .. u53 .. " OF " .. v58;
                    end
                };
            elseif v17 == "EICAS_Block" then
                v19 = Instance.new("Frame");
                v19.BackgroundTransparency = 1;
                v19.AnchorPoint = Vector2.new(0.5, 0);
                local l__Big__6 = v18.Big;
                v18.Big = nil;
                local u61;
                if v18.Label then
                    u61 = Instance.new("TextLabel");
                    u61.Text = v18.Label;
                    u61.Position = UDim2.fromScale(v18.LabelX, 0.85);
                    u61.Size = UDim2.fromScale(1, 0.11);
                    u61.AnchorPoint = Vector2.new(0.5, 0);
                    u61.BackgroundTransparency = 1;
                    u61.TextScaled = true;
                    u61.FontFace = Font.new("rbxasset://fonts/families/RobotoCondensed.json");
                    u61.TextColor3 = u2[1];
                    u61.Parent = v19;
                    v18.Label = nil;
                    v18.LabelX = nil;
                else
                    u61 = nil;
                end;
                local u62 = Instance.new("ImageLabel");
                u62.ImageColor3 = u2[1];
                u62.BackgroundTransparency = 1;
                u62.Size = UDim2.fromScale(1, l__Big__6 and 1 or 0.95);
                u62.Position = UDim2.fromScale(0, l__Big__6 and 0 or 0.05);
                u62.Image = "rbxassetid://115152014998696";
                u62.ScaleType = Enum.ScaleType.Slice;
                u62.SliceCenter = Rect.new(32, 32, 33, 33);
                u62.Parent = v19;
                u6._hooks[#u6._hooks + 1] = {
                    Update = function(_) --[[ Name: Update, Line 343 ]]
                        -- upvalues: u15 (copy), u2 (ref), u62 (copy), u61 (ref)
                        local v63 = 1;
                        for _, v64 in u15 do
                            if v64.EICAS_Level then
                                v63 = math.max(v63, v64.EICAS_Level);
                            end;
                        end;
                        local v65 = u2[v63];
                        u62.ImageColor3 = v65;
                        if u61 then
                            u61.TextColor3 = v65;
                        end;
                    end
                };
            elseif v17 == "EICAS_Bar" then
                v19 = Instance.new("Frame");
                v19.BackgroundTransparency = 0;
                v19.BackgroundColor3 = Color3.new(0, 0, 0);
                v19.BorderSizePixel = 5;
                v19.BorderColor3 = Color3.new(1, 1, 1);
                v19.AnchorPoint = Vector2.new(0.5, 0);
                v19.SizeConstraint = Enum.SizeConstraint.RelativeYY;
                v19.Size = UDim2.fromScale(0.09, 0.65);
                local u66 = Instance.new("Frame");
                u66.BorderSizePixel = 0;
                u66.Position = UDim2.fromScale(0, 1);
                u66.AnchorPoint = Vector2.new(0, 1);
                u66.Parent = v19;
                local l__Value__7 = v18.Value;
                local l__Name__8 = v18.Name;
                local l__Big__9 = v18.Big;
                local l__Side__10 = v18.Side;
                local l__Fuel__11 = v18.Fuel;
                v18.Name = nil;
                v18.Value = nil;
                v18.Big = nil;
                v18.Side = nil;
                v18.Fuel = nil;
                local v67 = l___vehicle__1.VehicleModule.Values[l__Value__7];
                local l__Cont__12 = v67.Cont;
                local l__Danger__13 = v67.Danger;
                local l__Range__14 = v67.Range;
                local u68 = l__Range__14[1];
                local u69 = l__Range__14[2];
                local v70 = typeof(l__Cont__12) ~= "number";
                local v71 = Instance.new("Frame");
                v71.BorderSizePixel = 0;
                v71.BackgroundColor3 = u2[2];
                v71.ZIndex = 2;
                local l__fromScale__15 = UDim2.fromScale;
                local v72 = 0.5;
                local v73;
                if v70 then
                    v73 = l__Cont__12[1] or l__Cont__12;
                else
                    v73 = l__Cont__12;
                end;
                v71.Position = l__fromScale__15(v72, 1 - (v73 - u68) / (u69 - u68));
                v71.Size = UDim2.new(l__Fuel__11 and 1 or 2, 5, 0, 5);
                v71.AnchorPoint = Vector2.new(0.5, 0.5);
                v71.Parent = v19;
                if v70 then
                    local v74 = Instance.new("Frame");
                    v74.BorderSizePixel = 0;
                    v74.BackgroundColor3 = u2[2];
                    v74.ZIndex = 2;
                    v74.Position = UDim2.fromScale(0.5, 1 - (l__Cont__12[2] - u68) / (u69 - u68));
                    v74.Size = UDim2.new(1, 5, 0, 5);
                    v74.AnchorPoint = Vector2.new(0.5, 0.5);
                    v74.Parent = v19;
                end;
                if l__Danger__13 then
                    local v75 = typeof(l__Danger__13) ~= "number";
                    local v76 = Instance.new("Frame");
                    v76.BorderSizePixel = 0;
                    v76.BackgroundColor3 = u2[3];
                    v76.ZIndex = 2;
                    local l__fromScale__16 = UDim2.fromScale;
                    local v77 = 0.5;
                    local v78;
                    if v75 then
                        v78 = l__Danger__13[1] or l__Danger__13;
                    else
                        v78 = l__Danger__13;
                    end;
                    v76.Position = l__fromScale__16(v77, 1 - (v78 - u68) / (u69 - u68));
                    v76.Size = UDim2.new(1, 5, 0, 5);
                    v76.AnchorPoint = Vector2.new(0.5, 0.5);
                    v76.Parent = v19;
                    if v75 then
                        local v79 = Instance.new("Frame");
                        v79.BorderSizePixel = 0;
                        v79.BackgroundColor3 = u2[3];
                        v79.ZIndex = 2;
                        v79.Position = UDim2.fromScale(0.5, 1 - (l__Danger__13[2] - u68) / (u69 - u68));
                        v79.Size = UDim2.new(1, 5, 0, 5);
                        v79.AnchorPoint = Vector2.new(0.5, 0.5);
                        v79.Parent = v19;
                    end;
                end;
                local v80 = Instance.new("TextLabel");
                v80.Text = l__Name__8;
                v80.Position = UDim2.fromScale(l__Side__10 and (l__Side__10 * 2.5 + 0.5 or 0.5) or 0.5, l__Fuel__11 and 0.15 or (l__Side__10 and 0.2 or (l__Big__9 and -0.3 or -0.22)));
                v80.Size = UDim2.fromScale(10, l__Side__10 and 0.2 or 0.1);
                v80.AnchorPoint = Vector2.new(0.5, 1);
                v80.BackgroundTransparency = 1;
                v80.TextScaled = true;
                v80.FontFace = Font.new("rbxasset://fonts/families/RobotoCondensed.json");
                v80.TextColor3 = Color3.new(1, 1, 1);
                v80.Parent = v19;
                local u81 = Instance.new("TextLabel");
                u81.Text = 0;
                u81.Position = UDim2.fromScale(l__Side__10 and (l__Side__10 * 2.5 + 0.5 or 0.5) or 0.5, l__Fuel__11 and 1.4 or (l__Side__10 and 0.5 or (l__Big__9 and -0.05 or -0.03)));
                u81.Size = UDim2.fromScale(10, (l__Side__10 or l__Fuel__11) and 0.3 or (l__Big__9 and 0.25 or 0.2));
                u81.AnchorPoint = Vector2.new(0.5, 1);
                u81.BackgroundTransparency = 1;
                u81.TextScaled = true;
                u81.FontFace = Font.new("rbxasset://fonts/families/RobotoCondensed.json");
                u81.TextColor3 = u2[1];
                u81.Parent = v19;
                table.insert(u6._hooks, 1, {
                    Update = function(_) --[[ Name: Update, Line 457 ]]
                        -- upvalues: l___vehicle__1 (ref), l__Value__7 (copy), u68 (copy), u69 (copy), l__Cont__12 (copy), l__Fuel__11 (copy), l__Danger__13 (copy), u2 (ref), u66 (copy), u81 (copy), u16 (copy)
                        local v82 = l___vehicle__1.Values[l__Value__7];
                        if v82 then
                            local v83 = 1;
                            local v84 = math.clamp((v82 - u68) / (u69 - u68), 0, 1);
                            local v85;
                            if typeof(l__Cont__12) == "number" then
                                v85 = l__Fuel__11 and v82 < l__Cont__12 and 2 or (not l__Fuel__11 and l__Cont__12 < v82 and 2 or v83);
                            else
                                v85 = (v82 < l__Cont__12[1] or l__Cont__12[2] < v82) and 2 or v83;
                            end;
                            if l__Danger__13 then
                                if typeof(l__Danger__13) == "number" then
                                    v85 = l__Danger__13 < v82 and 3 or v85;
                                else
                                    v85 = (v82 < l__Danger__13[1] or l__Danger__13[2] < v82) and 3 or v85;
                                end;
                            end;
                            local v86 = u2[v85];
                            u66.BackgroundColor3 = v86;
                            u66.Size = UDim2.fromScale(1, v84);
                            u81.Text = math.floor(v82);
                            u81.TextColor3 = v86;
                            u16.EICAS_Level = v85;
                        end;
                    end
                });
            elseif v17 == "CM_Compass" then
                v19 = Instance.new("Frame");
                v19.AnchorPoint = Vector2.new(0.5, 0.5);
                v19.BackgroundTransparency = 1;
                v19.SizeConstraint = Enum.SizeConstraint.RelativeYY;
                local v87 = Instance.new("UICorner");
                v87.CornerRadius = UDim.new(0.5, 0);
                v87.Parent = v19;
                for v88 = 1, 3 do
                    local v89 = Instance.new("Frame");
                    v89.AnchorPoint = Vector2.new(0.5, 0.5);
                    v89.BackgroundTransparency = 1;
                    v89.Position = UDim2.fromScale(0.5, 0.5);
                    v89.Size = UDim2.new(1, 0, 0, 5);
                    v89.Rotation = v88 == 2 and 45 or (v88 == 3 and -45 or 0);
                    v89.Parent = v19;
                    local v90 = Instance.new("ImageLabel");
                    v90.AnchorPoint = Vector2.new(0.5, 0);
                    v90.BackgroundTransparency = 1;
                    v90.Position = UDim2.fromScale(-0.02, -2);
                    v90.Rotation = 90;
                    v90.Size = UDim2.fromOffset(25, 25);
                    v90.Image = "rbxassetid://130707049263300";
                    v90.ImageColor3 = Color3.fromRGB(255, 255, 255);
                    v90.ScaleType = Enum.ScaleType.Stretch;
                    v90.Parent = v89;
                    local v91 = Instance.new("ImageLabel");
                    v91.AnchorPoint = Vector2.new(0.5, 0);
                    v91.BackgroundTransparency = 1;
                    v91.Position = UDim2.fromScale(1.02, -2);
                    v91.Rotation = -90;
                    v91.Size = UDim2.fromOffset(25, 25);
                    v91.Image = "rbxassetid://130707049263300";
                    v91.ImageColor3 = Color3.fromRGB(255, 255, 255);
                    v91.ScaleType = Enum.ScaleType.Stretch;
                    v91.Parent = v89;
                end;
                local v92 = Instance.new("Frame");
                v92.AnchorPoint = Vector2.new(0.5, 0);
                v92.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v92.BorderColor3 = Color3.fromRGB(255, 255, 255);
                v92.BorderSizePixel = 5;
                v92.Position = UDim2.fromScale(0.5, -0.1);
                v92.Size = UDim2.fromScale(0.1, 0.04);
                v92.Parent = v19;
                local v93 = Instance.new("ImageLabel");
                v93.AnchorPoint = Vector2.new(0.5, 1);
                v93.BackgroundTransparency = 1;
                v93.Position = UDim2.fromScale(0.5, 1.8);
                v93.Rotation = -180;
                v93.Size = UDim2.fromScale(0.5, 0.8);
                v93.Image = "rbxassetid://130707049263300";
                v93.ImageColor3 = Color3.fromRGB(255, 255, 255);
                v93.ScaleType = Enum.ScaleType.Stretch;
                v93.Parent = v92;
                local v94 = Instance.new("ImageLabel");
                v94.AnchorPoint = Vector2.new(0.5, 0.5);
                v94.BackgroundTransparency = 1;
                v94.Position = UDim2.fromScale(0.5, 0.7);
                v94.Size = UDim2.fromScale(0.9, 0.9);
                v94.Image = "rbxassetid://130707049263300";
                v94.ImageColor3 = Color3.fromRGB(0, 0, 0);
                v94.ScaleType = Enum.ScaleType.Stretch;
                v94.Parent = v93;
                local v95 = Instance.new("TextLabel");
                v95.BackgroundTransparency = 1;
                v95.Size = UDim2.fromScale(1, 1);
                v95.Font = Enum.Font.RobotoCondensed;
                v95.Text = "140";
                v95.TextColor3 = Color3.fromRGB(255, 255, 255);
                v95.TextScaled = true;
                v95.Parent = v92;
                local v96 = Instance.new("Frame");
                v96.AnchorPoint = Vector2.new(0.5, 0.5);
                v96.BackgroundTransparency = 1;
                v96.Position = UDim2.fromScale(0.5, 0.5);
                v96.Size = UDim2.fromScale(0.1, 0.1);
                v96.Parent = v19;
                for v97 = 1, 3 do
                    local v98 = Instance.new("Frame");
                    v98.AnchorPoint = Vector2.new(0.5, 0);
                    v98.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    v98.BorderSizePixel = 0;
                    if v97 == 1 then
                        v98.Position = UDim2.fromScale(0.5, 0);
                        v98.Size = UDim2.new(0, 5, 1, 0);
                    elseif v97 == 2 then
                        v98.Position = UDim2.new(0.5, 0, 0, 10);
                        v98.Size = UDim2.new(1, 0, 0, 5);
                    else
                        v98.Position = UDim2.fromScale(0.5, 0.8);
                        v98.Size = UDim2.new(0.3, 0, 0, 5);
                    end;
                    v98.Parent = v96;
                end;
                local v99 = Instance.new("Frame");
                v99.BackgroundTransparency = 1;
                v99.Size = UDim2.fromScale(1, 1);
                v99.Parent = v19;
                local v100 = false;
                local function v104(p101, p102) --[[ Line: 605 ]]
                    local v103 = Instance.new("TextLabel");
                    v103.AnchorPoint = Vector2.new(1, 0.5);
                    v103.BackgroundTransparency = 1;
                    v103.Position = UDim2.fromScale(0.5, 0);
                    v103.Rotation = 90;
                    v103.Size = UDim2.fromScale(3, 15);
                    v103.Font = Enum.Font.RobotoCondensed;
                    v103.Text = p101;
                    v103.TextColor3 = Color3.fromRGB(255, 255, 255);
                    v103.TextScaled = true;
                    v103.Parent = p102;
                end;
                local v105 = {
                    [0] = "N",
                    [9] = "E",
                    [18] = "S",
                    [27] = "W"
                };
                for v106 = 0, 355, 5 do
                    local v107 = Instance.new("Frame");
                    v107.AnchorPoint = Vector2.new(0.5, 0.5);
                    v107.BackgroundTransparency = 1;
                    v107.Position = UDim2.fromScale(0.5, 0.5);
                    v107.Size = UDim2.new(1, 0, 0, 5);
                    v107.Rotation = v106;
                    v107.Parent = v99;
                    local v108 = Instance.new("Frame");
                    v108.AnchorPoint = Vector2.new(1, 1);
                    v108.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    v108.BorderSizePixel = 0;
                    v108.Position = UDim2.fromScale(1, 0);
                    v108.Size = UDim2.fromScale(v100 and 0.025 or 0.05, 1);
                    v100 = not v100;
                    if v106 % 30 == 0 then
                        local v109 = (v106 + 90) / 10 % 36;
                        local v110 = tostring(v109);
                        if v105[v109] then
                            v110 = v105[v109];
                        end;
                        v104(v110, v108);
                    end;
                    v108.Parent = v107;
                end;
            elseif v17 == "CM_Gauge_Small" then
                v19 = Instance.new("Frame");
                v19.AnchorPoint = Vector2.new(0.5, 0.5);
                v19.BackgroundTransparency = 1;
                v19.SizeConstraint = Enum.SizeConstraint.RelativeYY;
                local v111 = Instance.new("UICorner");
                v111.CornerRadius = UDim.new(0.5, 0);
                v111.Parent = v19;
                local v112 = Instance.new("UIStroke");
                v112.Color = Color3.fromRGB(255, 255, 255);
                v112.Thickness = 5;
                v112.Parent = v19;
                local l__Style__17 = v18.Style;
                v18.Style = nil;
                if l__Style__17 == "Semi" then
                    local v113 = Instance.new("Frame");
                    v113.AnchorPoint = Vector2.new(0, 0.5);
                    v113.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                    v113.Position = UDim2.fromScale(0.62, 1);
                    v113.Rotation = -45;
                    v113.Size = UDim2.fromScale(0.3, 0.5);
                    v113.Parent = v19;
                    local v114 = Instance.new("UICorner");
                    v114.CornerRadius = UDim.new(0.5, 0);
                    v114.Parent = v113;
                    local v115 = Instance.new("Frame");
                    v115.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                    v115.BorderSizePixel = 0;
                    v115.Rotation = -45;
                    v115.Size = UDim2.fromScale(0.5, 0.5);
                    v115.Parent = v113;
                end;
                local v116 = {
                    [0] = "0",
                    [90] = "50",
                    [180] = "1",
                    [210] = "2",
                    [240] = "3",
                    [270] = "4",
                    [315] = "10"
                };
                for _, v120 in {
                    {
                        0,
                        180,
                        18,
                        function(p117) --[[ Line: 697 ]]
                            return p117 % 90 == 0;
                        end
                    },
                    {
                        195,
                        270,
                        15,
                        function(p118) --[[ Line: 698 ]]
                            return (p118 - 195) / 15 % 2 ~= 0;
                        end
                    },
                    {
                        277.5,
                        315,
                        7.5,
                        function(p119) --[[ Line: 699 ]]
                            return p119 % 45 == 0;
                        end
                    }
                } do
                    local v121, v122, v123, v124 = unpack(v120);
                    for v125 = v121, v122, v123 do
                        local v126 = Instance.new("Frame");
                        v126.AnchorPoint = Vector2.new(0.5, 0.5);
                        v126.BackgroundTransparency = 1;
                        v126.Position = UDim2.fromScale(0.5, 0.5);
                        v126.Size = UDim2.new(0, 5, 1, 0);
                        v126.Rotation = v125;
                        v126.Parent = v19;
                        local v127 = Instance.new("Frame");
                        v127.AnchorPoint = Vector2.new(0, 1);
                        v127.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        v127.BorderSizePixel = 0;
                        v127.Position = UDim2.fromScale(0, 1);
                        local v128 = v124(v125);
                        v127.Size = UDim2.fromScale(1, v128 and 0.1 or 0.05);
                        v127.Parent = v126;
                        if v116[v125] then
                            local v129 = Instance.new("TextLabel");
                            v129.AnchorPoint = Vector2.new(0.5, 1);
                            v129.BackgroundTransparency = 1;
                            v129.Position = UDim2.fromScale(0.3, 0);
                            v129.Size = UDim2.fromScale(5, 1.5);
                            v129.Text = v116[v125];
                            v129.TextScaled = true;
                            v129.TextColor3 = Color3.fromRGB(255, 255, 255);
                            v129.Rotation = -v125;
                            v129.Parent = v127;
                        end;
                    end;
                end;
                local v130 = Instance.new("Frame");
                v130.AnchorPoint = Vector2.new(0.5, 0.5);
                v130.BackgroundTransparency = 1;
                v130.Position = UDim2.fromScale(0.5, 0.5);
                v130.Size = UDim2.fromScale(0.4, 0.4);
                v130.Parent = v19;
                local v131 = Instance.new("TextLabel");
                v131.BackgroundTransparency = 1;
                v131.Size = UDim2.fromScale(1, 0.5);
                v131.Font = Enum.Font.RobotoCondensed;
                v131.Text = "0006";
                v131.TextColor3 = Color3.fromRGB(255, 255, 255);
                v131.TextScaled = true;
                v131.Parent = v130;
                local v132 = Instance.new("TextLabel");
                v132.BackgroundTransparency = 1;
                v132.Position = UDim2.fromScale(0, 0.5);
                v132.Size = UDim2.fromScale(1, 0.5);
                v132.Font = Enum.Font.RobotoCondensed;
                v132.Text = "RA";
                v132.TextColor3 = Color3.fromRGB(255, 255, 255);
                v132.TextScaled = true;
                v132.Parent = v130;
                local v133 = Instance.new("Frame");
                v133.AnchorPoint = Vector2.new(0.5, 0.5);
                v133.BackgroundTransparency = 1;
                v133.Position = UDim2.fromScale(0.5, 0.5);
                v133.Rotation = -140;
                v133.Size = UDim2.fromScale(0.03, 1);
                v133.Parent = v19;
                local v134 = Instance.new("Frame");
                v134.AnchorPoint = Vector2.new(0.5, 0);
                v134.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                v134.BorderSizePixel = 0;
                v134.Position = UDim2.fromScale(0.5, 0.08);
                v134.Size = UDim2.fromScale(0.5, 0.08);
                v134.Parent = v133;
                local v135 = Instance.new("Frame");
                v135.AnchorPoint = Vector2.new(0.5, 0);
                v135.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                v135.BorderSizePixel = 0;
                v135.Position = UDim2.fromScale(0.5, 1);
                v135.Size = UDim2.fromScale(2, 1);
                v135.Parent = v134;
            elseif v17 == "CM_Log" then
                v19 = Instance.new("Frame");
                v19.BackgroundColor3 = Color3.fromRGB(248, 248, 0);
                v19.BorderSizePixel = 0;
                v19.Size = UDim2.fromScale(0.3, 0.2);
                local v136 = Instance.new("Frame");
                v136.BackgroundTransparency = 1;
                v136.Position = UDim2.fromScale(0.01, 0.01);
                v136.Size = UDim2.fromScale(0.98, 0.78);
                v136.Parent = v19;
                local v137 = Instance.new("UIListLayout");
                v137.Padding = UDim.new(0.15, 0);
                v137.FillDirection = Enum.FillDirection.Vertical;
                v137.SortOrder = Enum.SortOrder.LayoutOrder;
                v137.HorizontalAlignment = Enum.HorizontalAlignment.Center;
                v137.VerticalAlignment = Enum.VerticalAlignment.Top;
                v137.Parent = v136;
                local v138 = Instance.new("Frame");
                v138.AnchorPoint = Vector2.new(0, 1);
                v138.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v138.BorderSizePixel = 0;
                v138.Position = UDim2.fromScale(0.01, 0.99);
                v138.Size = UDim2.fromScale(0.98, 0.2);
                v138.Parent = v19;
                local v139 = Instance.new("ImageLabel");
                v139.AnchorPoint = Vector2.new(1, 1);
                v139.BackgroundTransparency = 1;
                v139.Position = UDim2.fromScale(1, 0);
                v139.Size = UDim2.fromScale(0.2, 0.1);
                v139.Image = "rbxassetid://130707049263300";
                v139.ImageColor3 = Color3.fromRGB(248, 248, 0);
                v139.ScaleType = Enum.ScaleType.Stretch;
                v139.Parent = v19;
                local v140 = Instance.new("ImageLabel");
                v140.AnchorPoint = Vector2.new(1, 0);
                v140.BackgroundTransparency = 1;
                v140.Position = UDim2.fromScale(1, 1);
                v140.Rotation = 180;
                v140.Size = UDim2.fromScale(0.2, 0.1);
                v140.Image = "rbxassetid://130707049263300";
                v140.ImageColor3 = Color3.fromRGB(248, 248, 0);
                v140.ScaleType = Enum.ScaleType.Stretch;
                v140.Parent = v19;
                local v141 = Instance.new("Frame");
                v141.AnchorPoint = Vector2.new(0, 1);
                v141.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v141.BorderColor3 = Color3.fromRGB(255, 255, 255);
                v141.BorderSizePixel = 5;
                v141.Position = UDim2.new(1, 0, 1, -5);
                v141.Size = UDim2.fromScale(0.1, 0.7);
                v141.Parent = v19;
                local v142 = Instance.new("Frame");
                v142.AnchorPoint = Vector2.new(1, 1);
                v142.BackgroundColor3 = Color3.fromRGB(248, 248, 0);
                v142.BorderColor3 = Color3.fromRGB(248, 248, 0);
                v142.Position = UDim2.fromScale(0, 1.025);
                v142.Size = UDim2.fromScale(0.1, 1.3);
                v142.Parent = v141;
                local v143 = Instance.new("Frame");
                v143.BackgroundTransparency = 1;
                v143.Size = UDim2.fromScale(1, 1);
                v143.Parent = v141;
                local v144 = Instance.new("UIListLayout");
                v144.SortOrder = Enum.SortOrder.LayoutOrder;
                v144.VerticalAlignment = Enum.VerticalAlignment.Top;
                v144.VerticalFlex = Enum.UIFlexAlignment.Fill;
                v144.Parent = v143;
                for _, v145 in {
                    "P",
                    "A",
                    "G",
                    "E",
                    "S"
                } do
                    local v146 = Instance.new("TextLabel");
                    v146.BackgroundTransparency = 1;
                    v146.Size = UDim2.fromScale(1, 1);
                    v146.Text = v145;
                    v146.TextColor3 = Color3.fromRGB(255, 255, 255);
                    v146.TextScaled = true;
                    v146.Parent = v143;
                end;
                for v147, v148 in { "LEFT STN HANG", "HULL INTEGRITY CRIT", "WOW" } do
                    local v149 = Instance.new("Frame");
                    v149.BackgroundTransparency = 1;
                    v149.Size = UDim2.fromScale(1, 0.25);
                    v149.LayoutOrder = v147;
                    v149.Parent = v136;
                    local v150 = Instance.new("Frame");
                    v150.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                    v150.BorderSizePixel = 0;
                    v150.Size = UDim2.fromScale(1, 0.1);
                    v150.Parent = v149;
                    local v151 = Instance.new("Frame");
                    v151.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                    v151.BorderSizePixel = 0;
                    v151.Position = UDim2.fromScale(0, 1);
                    v151.Size = UDim2.fromScale(1, 0.1);
                    v151.Parent = v149;
                    local v152 = Instance.new("TextLabel");
                    v152.AnchorPoint = Vector2.new(0, 0.5);
                    v152.BackgroundTransparency = 1;
                    v152.Position = UDim2.fromScale(0.05, 0.5);
                    v152.Size = UDim2.fromScale(0.9, 0.8);
                    v152.Font = Enum.Font.RobotoCondensed;
                    v152.Text = v148;
                    v152.TextColor3 = Color3.fromRGB(0, 0, 0);
                    v152.TextScaled = true;
                    v152.TextXAlignment = Enum.TextXAlignment.Left;
                    v152.Parent = v149;
                end;
            elseif v17 == "PFD_Gauge_Right" then
                v19 = Instance.new("Frame");
                v19.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v19.BorderColor3 = Color3.fromRGB(0, 0, 0);
                v19.Size = UDim2.fromScale(0.3, 0.3);
                v19.SizeConstraint = Enum.SizeConstraint.RelativeYY;
                local v153 = Instance.new("UICorner");
                v153.CornerRadius = UDim.new(0.5, 0);
                v153.Parent = v19;
                local v154 = Instance.new("UIStroke");
                v154.Color = Color3.fromRGB(255, 255, 255);
                v154.Thickness = 5;
                v154.Parent = v19;
                local v155 = {
                    [36] = "6",
                    [72] = "7",
                    [108] = "8",
                    [144] = "9",
                    [180] = "0",
                    [216] = "1",
                    [252] = "2",
                    [288] = "3",
                    [324] = "4",
                    [360] = "5"
                };
                for v156 = 1, 50 do
                    local v157 = v156 * 7.2;
                    local v158 = Instance.new("Frame");
                    v158.AnchorPoint = Vector2.new(0.5, 0.5);
                    v158.BackgroundTransparency = 1;
                    v158.Position = UDim2.fromScale(0.5, 0.5);
                    v158.Size = UDim2.new(0, 5, 1, 0);
                    v158.Rotation = v157;
                    v158.Parent = v19;
                    local v159 = Instance.new("Frame");
                    v159.AnchorPoint = Vector2.new(0, 1);
                    v159.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    v159.BorderSizePixel = 0;
                    v159.Position = UDim2.fromScale(0, 1);
                    v159.Size = UDim2.fromScale(1, v156 % 5 == 0 and 0.1 or 0.05);
                    v159.Parent = v158;
                    if v155[v157] then
                        local v160 = Instance.new("TextLabel");
                        v160.AnchorPoint = Vector2.new(0.5, 1);
                        v160.BackgroundTransparency = 1;
                        v160.Position = UDim2.fromScale(0.3, 0);
                        v160.Size = UDim2.fromScale(4, 1.5);
                        v160.Text = v155[v157];
                        v160.TextScaled = true;
                        v160.TextColor3 = Color3.fromRGB(255, 255, 255);
                        v160.Rotation = -v157;
                        v160.Parent = v159;
                    end;
                end;
                local v161 = Instance.new("Frame");
                v161.AnchorPoint = Vector2.new(0.5, 0.5);
                v161.BackgroundTransparency = 1;
                v161.Position = UDim2.fromScale(0.5, 0.5);
                v161.Size = UDim2.fromScale(0.3, 0.3);
                v161.Parent = v19;
                local v162 = Instance.new("Frame");
                v162.AnchorPoint = Vector2.new(0, 0.5);
                v162.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v162.BorderColor3 = Color3.fromRGB(255, 255, 255);
                v162.BorderSizePixel = 5;
                v162.Position = UDim2.fromScale(0, 0.5);
                v162.Size = UDim2.fromScale(0.8, 0.8);
                v162.Parent = v161;
                local v163 = Instance.new("TextLabel");
                v163.AnchorPoint = Vector2.new(1, 0.5);
                v163.BackgroundTransparency = 1;
                v163.Position = UDim2.fromScale(0.7, 0.5);
                v163.Size = UDim2.fromScale(0.5, 0.5);
                v163.Font = Enum.Font.RobotoCondensed;
                v163.Text = "29";
                v163.TextColor3 = Color3.fromRGB(255, 255, 255);
                v163.TextScaled = true;
                v163.Parent = v162;
                local v164 = Instance.new("TextLabel");
                v164.AnchorPoint = Vector2.new(0, 1);
                v164.BackgroundTransparency = 1;
                v164.Size = UDim2.fromScale(0.6, 0.4);
                v164.Font = Enum.Font.RobotoCondensed;
                v164.Text = "FEET";
                v164.TextColor3 = Color3.fromRGB(255, 255, 255);
                v164.TextScaled = true;
                v164.TextYAlignment = Enum.TextYAlignment.Bottom;
                v164.Parent = v162;
                local v165 = Instance.new("Frame");
                v165.AnchorPoint = Vector2.new(1, 0);
                v165.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v165.BorderColor3 = Color3.fromRGB(255, 255, 255);
                v165.BorderSizePixel = 5;
                v165.Position = UDim2.fromScale(1, 0);
                v165.Size = UDim2.fromScale(0.4, 1);
                v165.Parent = v161;
                local v166 = Instance.new("Frame");
                v166.AnchorPoint = Vector2.new(0, 0.5);
                v166.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v166.BorderColor3 = Color3.fromRGB(0, 0, 0);
                v166.BorderSizePixel = 5;
                v166.Position = UDim2.fromScale(0, 0.5);
                v166.Size = UDim2.fromScale(0.1, 0.72);
                v166.Parent = v165;
                local v167 = Instance.new("Frame");
                v167.BackgroundTransparency = 1;
                v167.Size = UDim2.fromScale(1, 1);
                v167.Parent = v165;
                local v168 = Instance.new("UIListLayout");
                v168.FillDirection = Enum.FillDirection.Vertical;
                v168.SortOrder = Enum.SortOrder.LayoutOrder;
                v168.VerticalFlex = Enum.UIFlexAlignment.Fill;
                v168.Parent = v167;
                for _, v169 in { "20", "00", "80" } do
                    local v170 = Instance.new("TextLabel");
                    v170.BackgroundTransparency = 1;
                    v170.Size = UDim2.fromScale(1, 1);
                    v170.Font = Enum.Font.RobotoCondensed;
                    v170.TextColor3 = Color3.fromRGB(255, 255, 255);
                    v170.TextScaled = true;
                    v170.Text = v169;
                    v170.Parent = v167;
                end;
            elseif v17 == "PFD_NR_Bar" then
                local u171 = Instance.new("Frame");
                u171.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                u171.BorderColor3 = Color3.fromRGB(255, 255, 255);
                u171.BorderSizePixel = 5;
                u171.SizeConstraint = Enum.SizeConstraint.RelativeYY;
                local v172 = Instance.new("Frame");
                v172.AnchorPoint = Vector2.new(0.5, 1);
                v172.BackgroundColor3 = u2[1];
                v172.BorderSizePixel = 0;
                v172.Position = UDim2.fromScale(0.5, 1);
                v172.Size = UDim2.fromScale(0.4, 1);
                v172.Parent = u171;
                local v173 = Instance.new("TextLabel");
                v173.AnchorPoint = Vector2.new(0.5, 0.5);
                v173.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v173.BorderSizePixel = 0;
                v173.Position = UDim2.fromScale(0.5, 0);
                v173.Size = UDim2.fromScale(0.5, 0.1);
                v173.Font = Enum.Font.RobotoCondensed;
                v173.Text = "120";
                v173.TextColor3 = Color3.fromRGB(255, 255, 255);
                v173.TextScaled = true;
                v173.Parent = u171;
                local v174 = Instance.new("TextLabel");
                v174.AnchorPoint = Vector2.new(0.5, 1);
                v174.BackgroundTransparency = 1;
                v174.Position = UDim2.fromScale(0.5, -0.03);
                v174.Size = UDim2.fromScale(0.6, 0.1);
                v174.Font = Enum.Font.RobotoCondensed;
                v174.Text = "100";
                v174.TextColor3 = u2[1];
                v174.TextScaled = true;
                v174.Parent = u171;
                local v175 = Instance.new("TextLabel");
                v175.AnchorPoint = Vector2.new(0.5, 1);
                v175.BackgroundTransparency = 1;
                v175.Position = UDim2.fromScale(0.5, -0.1);
                v175.Size = UDim2.fromScale(0.3, 0.1);
                v175.Font = Enum.Font.RobotoCondensed;
                v175.Text = "NR";
                v175.TextColor3 = Color3.fromRGB(255, 255, 255);
                v175.TextScaled = true;
                v175.Parent = u171;
                local v176 = Instance.new("TextLabel");
                v176.AnchorPoint = Vector2.new(0.5, 0.5);
                v176.BackgroundTransparency = 1;
                v176.Position = UDim2.fromScale(0.5, 1);
                v176.Size = UDim2.fromScale(0.3, 0.1);
                v176.ZIndex = 2;
                v176.Font = Enum.Font.RobotoCondensed;
                v176.Text = "20";
                v176.TextColor3 = Color3.fromRGB(255, 255, 255);
                v176.TextScaled = true;
                v176.TextStrokeTransparency = 0;
                v176.Parent = u171;
                local v177 = Instance.new("Frame");
                v177.AnchorPoint = Vector2.new(0.5, 0);
                v177.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v177.BorderSizePixel = 0;
                v177.Position = UDim2.fromScale(0.5, 1);
                v177.Size = UDim2.fromScale(0.3, 0.01);
                v177.Parent = u171;
                local function v184(p178, p179, p180) --[[ Line: 1137 ]]
                    -- upvalues: u171 (ref)
                    local v181 = Instance.new("Frame");
                    v181.BackgroundTransparency = 1;
                    v181.Position = p178;
                    v181.Size = UDim2.new(1, 0, 0, 5);
                    v181.Parent = u171;
                    local v182 = Instance.new("Frame");
                    v182.BackgroundColor3 = p180;
                    v182.BorderSizePixel = 0;
                    v182.Size = p179;
                    v182.Parent = v181;
                    local v183 = Instance.new("Frame");
                    v183.AnchorPoint = Vector2.new(1, 0);
                    v183.BackgroundColor3 = p180;
                    v183.Position = UDim2.fromScale(1, 0);
                    v183.Size = p179;
                    v183.Parent = v181;
                    return v181;
                end;
                v184(UDim2.fromScale(0, 0.09), UDim2.fromScale(0.2, 1), Color3.fromRGB(255, 255, 255));
                v19 = u171;
                local function v187(p185) --[[ Line: 1160 ]]
                    local v186 = Instance.new("Frame");
                    v186.AnchorPoint = Vector2.new(0.5, 0);
                    v186.BackgroundColor3 = p185;
                    v186.Position = UDim2.fromScale(0.5, 0);
                    v186.Size = UDim2.fromScale(0.5, 1);
                    v186.ZIndex = 2;
                    return v186;
                end;
                local function v190(p188) --[[ Line: 1171 ]]
                    local v189 = Instance.new("TextLabel");
                    v189.AnchorPoint = Vector2.new(0.5, 0.5);
                    v189.BackgroundTransparency = 1;
                    v189.Position = UDim2.fromScale(0.5, 0.5);
                    v189.Size = UDim2.fromScale(0.5, 0.5);
                    v189.Font = Enum.Font.RobotoCondensed;
                    v189.Text = p188;
                    v189.TextColor3 = Color3.fromRGB(255, 255, 255);
                    v189.TextScaled = true;
                    v189.TextStrokeTransparency = 0;
                    return v189;
                end;
                for v191 = 1, 21 do
                    local v192 = UDim2.fromScale(0, v191 == 1 and 0.17 or (v191 - 1) * 0.03 + 0.17);
                    local v193 = UDim2.fromScale((v191 - 1) % 5 == 0 and 0.2 or 0.1, 1);
                    local v194 = Color3.fromRGB(255, 255, 255);
                    if v191 == 6 then
                        v194 = Color3.fromRGB(228, 4, 4);
                    end;
                    local v195 = v184(v192, v193, v194);
                    if v191 == 1 then
                        v187(u2[3]).Parent = v195;
                        local v196 = v190("110");
                        v196.Size = UDim2.fromScale(0.5, 7);
                        v196.Parent = v195;
                    elseif v191 == 11 then
                        v187(u2[1]).Parent = v195;
                        local v197 = v190("100");
                        v197.Size = UDim2.fromScale(0.5, 7);
                        v197.Parent = v195;
                    elseif v191 == 15 then
                        local v198 = v187(u2[2]);
                        v198.Size = UDim2.fromScale(1, 1);
                        v198.Parent = v195;
                    elseif v191 == 20 then
                        local v199 = v187(u2[3]);
                        v199.Size = UDim2.fromScale(1, 1);
                        v199.Parent = v195;
                    elseif v191 == 21 then
                        local v200 = v190("90");
                        v200.Size = UDim2.fromScale(0.5, 7);
                        v200.Parent = v195;
                    end;
                end;
            elseif v17 == "PFD_Fuel_Bar" then
                v19 = Instance.new("Frame");
                v19.BackgroundTransparency = 1;
                v19.Size = UDim2.fromScale(0.05, 0.2);
                local l__Value__18 = v18.Value;
                v18.Value = nil;
                local v201 = Instance.new("Frame");
                v201.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                v201.BorderSizePixel = 0;
                v201.Position = UDim2.fromScale(0, 1);
                v201.Size = UDim2.new(1, 0, 0, 5);
                v201.Parent = v19;
                local v202 = Instance.new("TextLabel");
                v202.AnchorPoint = Vector2.new(0.5, 0);
                v202.BackgroundTransparency = 1;
                v202.Position = UDim2.fromScale(0.5, 1);
                v202.Size = UDim2.fromScale(1.5, 10);
                v202.Font = Enum.Font.RobotoCondensed;
                v202.Text = l__Value__18;
                v202.TextColor3 = u2[1];
                v202.TextScaled = true;
                v202.Parent = v201;
                local v203 = Instance.new("Frame");
                v203.AnchorPoint = Vector2.new(0.5, 0);
                v203.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                v203.BorderSizePixel = 0;
                v203.Position = UDim2.fromScale(0.5, 0.1);
                v203.Size = UDim2.new(0.7, 0, 0, 5);
                v203.Parent = v19;
                local v204 = Instance.new("TextLabel");
                v204.AnchorPoint = Vector2.new(0.5, 1);
                v204.BackgroundTransparency = 1;
                v204.Position = UDim2.fromScale(0.5, 0);
                v204.Size = UDim2.fromScale(1.2, 5);
                v204.Font = Enum.Font.RobotoCondensed;
                v204.Text = "FUEL";
                v204.TextColor3 = Color3.fromRGB(255, 255, 255);
                v204.TextScaled = true;
                v204.Parent = v203;
                local v205 = Instance.new("Frame");
                v205.AnchorPoint = Vector2.new(0.5, 1);
                v205.BackgroundColor3 = u2[1];
                v205.BorderSizePixel = 0;
                v205.Position = UDim2.fromScale(0.3, 1);
                v205.Size = UDim2.fromScale(0.2, 0.81);
                v205.Parent = v19;
                local v206 = Instance.new("ImageLabel");
                v206.AnchorPoint = Vector2.new(1, 0);
                v206.BackgroundTransparency = 1;
                v206.Position = UDim2.fromScale(0, -0.015);
                v206.Rotation = -90;
                v206.Size = UDim2.fromScale(1, 0.1);
                v206.Image = "rbxassetid://130707049263300";
                v206.ImageColor3 = u2[1];
                v206.Parent = v205;
                local v207 = Instance.new("Frame");
                v207.AnchorPoint = Vector2.new(0.5, 1);
                v207.BackgroundColor3 = u2[1];
                v207.BorderSizePixel = 0;
                v207.Position = UDim2.fromScale(0.2, 0.8);
                v207.Size = UDim2.fromScale(0.2, 0.8);
                v207.Parent = v19;
                local v208 = Instance.new("ImageLabel");
                v208.BackgroundTransparency = 1;
                v208.Position = UDim2.fromScale(1.2, -0.015);
                v208.Rotation = 90;
                v208.Size = UDim2.fromScale(1, 0.1);
                v208.Image = "rbxassetid://130707049263300";
                v208.ImageColor3 = u2[1];
                v208.Parent = v207;
            elseif v17 == "PFD_Gauge_Left" then
                v19 = Instance.new("Frame");
                v19.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v19.BorderColor3 = Color3.fromRGB(0, 0, 0);
                v19.SizeConstraint = Enum.SizeConstraint.RelativeYY;
                local v209 = Instance.new("UICorner");
                v209.CornerRadius = UDim.new(0.5, 0);
                v209.Parent = v19;
                local v210 = Instance.new("UIStroke");
                v210.Color = Color3.fromRGB(255, 255, 255);
                v210.Thickness = 5;
                v210.Parent = v19;
                local v211 = Instance.new("Frame");
                v211.AnchorPoint = Vector2.new(0, 0.5);
                v211.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v211.BorderColor3 = Color3.fromRGB(0, 0, 0);
                v211.Position = UDim2.fromScale(0.615, 1);
                v211.Rotation = -45;
                v211.Size = UDim2.fromScale(0.36, 0.5);
                v211.Parent = v19;
                local v212 = Instance.new("UICorner");
                v212.CornerRadius = UDim.new(0.5, 0);
                v212.Parent = v211;
                local v213 = Instance.new("Frame");
                v213.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v213.BorderSizePixel = 0;
                v213.Position = UDim2.fromScale(-0.05, 0);
                v213.Rotation = -45;
                v213.Size = UDim2.fromScale(0.5, 0.5);
                v213.Parent = v211;
                local v214 = {
                    [0] = "0",
                    [20] = "20",
                    [40] = "40",
                    [76] = "60",
                    [110] = "80",
                    [145] = "100",
                    [180] = "120",
                    [216] = "140",
                    [250] = "160",
                    [285] = "180",
                    [320] = "200"
                };
                for _, v215 in {
                    {
                        1,
                        9,
                        0,
                        5,
                        false
                    },
                    {
                        1,
                        14,
                        50,
                        10,
                        true
                    },
                    {
                        1,
                        16,
                        190,
                        8,
                        true
                    }
                } do
                    local v216, v217, v218, v219, v220 = unpack(v215);
                    for v221 = v216, v217 do
                        local v222 = v219 * (v221 - 1) + v218;
                        local v223 = Instance.new("Frame");
                        v223.AnchorPoint = Vector2.new(0.5, 0.5);
                        v223.BackgroundTransparency = 1;
                        v223.Position = UDim2.fromScale(0.5, 0.5);
                        v223.Size = UDim2.new(0, 5, 1, 0);
                        v223.Rotation = math.floor(v222);
                        v223.Parent = v19;
                        local v224 = Instance.new("Frame");
                        v224.AnchorPoint = Vector2.new(0, 1);
                        v224.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                        v224.BorderSizePixel = 0;
                        v224.Position = UDim2.fromScale(0, 1);
                        local v225;
                        if v220 then
                            v225 = v221 % 2 == 0 and 0.1 or 0.05;
                        else
                            v225 = v221 % 2 == 0 and 0.05 or 0.1;
                        end;
                        v224.Size = UDim2.fromScale(1, v225);
                        v224.Parent = v223;
                        if v214[v222] then
                            local v226 = Instance.new("TextLabel");
                            v226.AnchorPoint = Vector2.new(0.5, 1);
                            v226.BackgroundTransparency = 1;
                            v226.Position = UDim2.fromScale(0.3, 0);
                            v226.Size = UDim2.fromScale(7, 1.5);
                            v226.Font = Enum.Font.RobotoCondensed;
                            v226.Text = v214[v222];
                            v226.TextScaled = true;
                            v226.TextColor3 = Color3.fromRGB(255, 255, 255);
                            v226.Rotation = -v222;
                            v226.Parent = v224;
                        end;
                    end;
                end;
                local v227 = Instance.new("Frame");
                v227.AnchorPoint = Vector2.new(0.5, 0.5);
                v227.BackgroundTransparency = 1;
                v227.Position = UDim2.fromScale(0.5, 0.5);
                v227.Size = UDim2.fromScale(0.3, 0.3);
                v227.Parent = v19;
                local v228 = Instance.new("Frame");
                v228.AnchorPoint = Vector2.new(0, 0.5);
                v228.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v228.BorderColor3 = Color3.fromRGB(255, 255, 255);
                v228.BorderSizePixel = 5;
                v228.Position = UDim2.fromScale(0.1, 0.5);
                v228.Size = UDim2.fromScale(0.5, 0.8);
                v228.Parent = v227;
                local v229 = Instance.new("TextLabel");
                v229.AnchorPoint = Vector2.new(1, 0.5);
                v229.BackgroundTransparency = 1;
                v229.Position = UDim2.fromScale(1, 0.5);
                v229.Size = UDim2.fromScale(0.9, 0.7);
                v229.Font = Enum.Font.RobotoCondensed;
                v229.Text = "11";
                v229.TextColor3 = Color3.fromRGB(255, 255, 255);
                v229.TextScaled = true;
                v229.Parent = v228;
                local v230 = Instance.new("TextLabel");
                v230.AnchorPoint = Vector2.new(0, 1);
                v230.BackgroundTransparency = 1;
                v230.Position = UDim2.fromScale(-0.3, 0);
                v230.Size = UDim2.fromScale(1.1, 0.5);
                v230.Font = Enum.Font.RobotoCondensed;
                v230.Text = "KTS";
                v230.TextColor3 = Color3.fromRGB(255, 255, 255);
                v230.TextScaled = true;
                v230.TextYAlignment = Enum.TextYAlignment.Bottom;
                v230.Parent = v228;
                local v231 = Instance.new("Frame");
                v231.AnchorPoint = Vector2.new(1, 0);
                v231.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v231.BorderColor3 = Color3.fromRGB(255, 255, 255);
                v231.BorderSizePixel = 5;
                v231.Position = UDim2.fromScale(0.9, 0);
                v231.Size = UDim2.fromScale(0.3, 1);
                v231.Parent = v227;
                local v232 = Instance.new("Frame");
                v232.AnchorPoint = Vector2.new(0, 0.5);
                v232.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v232.BorderColor3 = Color3.fromRGB(0, 0, 0);
                v232.BorderSizePixel = 5;
                v232.Position = UDim2.fromScale(0, 0.5);
                v232.Size = UDim2.fromScale(0.1, 0.72);
                v232.Parent = v231;
                local v233 = Instance.new("Frame");
                v233.BackgroundTransparency = 1;
                v233.Size = UDim2.fromScale(1, 1);
                v233.Parent = v231;
                local v234 = Instance.new("UIListLayout");
                v234.FillDirection = Enum.FillDirection.Vertical;
                v234.SortOrder = Enum.SortOrder.LayoutOrder;
                v234.HorizontalAlignment = Enum.HorizontalAlignment.Left;
                v234.VerticalAlignment = Enum.VerticalAlignment.Top;
                v234.VerticalFlex = Enum.UIFlexAlignment.Fill;
                v234.Parent = v233;
                for _, v235 in { "4", "3", "2" } do
                    local v236 = Instance.new("TextLabel");
                    v236.BackgroundTransparency = 1;
                    v236.Size = UDim2.fromScale(1, 1);
                    v236.Font = Enum.Font.RobotoCondensed;
                    v236.Text = v235;
                    v236.TextColor3 = Color3.fromRGB(255, 255, 255);
                    v236.TextScaled = true;
                    v236.Parent = v233;
                end;
                local v237 = Instance.new("Frame");
                v237.AnchorPoint = Vector2.new(0.5, 0.5);
                v237.BackgroundTransparency = 1;
                v237.Position = UDim2.fromScale(0.5, 0.5);
                v237.Rotation = -140;
                v237.Size = UDim2.fromScale(0.03, 1);
                v237.Parent = v19;
                local v238 = Instance.new("Frame");
                v238.AnchorPoint = Vector2.new(0.5, 0);
                v238.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                v238.BorderSizePixel = 0;
                v238.Position = UDim2.fromScale(0.5, 0.08);
                v238.Size = UDim2.fromScale(0.5, 0.08);
                v238.Parent = v237;
                local v239 = Instance.new("Frame");
                v239.AnchorPoint = Vector2.new(0.5, 0);
                v239.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                v239.BorderSizePixel = 0;
                v239.Position = UDim2.fromScale(0.5, 1);
                v239.Size = UDim2.fromScale(2, 1);
                v239.Parent = v238;
            elseif v17 == "PFD_HSI" then
                v19 = Instance.new("Frame");
                v19.BackgroundTransparency = 1;
                v19.Size = UDim2.fromScale(0.45, 0.45);
                local v240 = Instance.new("Frame");
                v240.AnchorPoint = Vector2.new(0.5, 0.5);
                v240.BackgroundTransparency = 1;
                v240.Position = UDim2.fromScale(0.5, 0.8);
                v240.Size = UDim2.fromScale(0.15, 0.15);
                v240.ZIndex = 2;
                v240.Parent = v19;
                local v241 = Instance.new("Frame");
                v241.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                v241.BorderSizePixel = 0;
                v241.Position = UDim2.fromScale(0.5, 0);
                v241.Size = UDim2.new(0, 5, 1, 0);
                v241.Parent = v240;
                local v242 = Instance.new("Frame");
                v242.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                v242.BorderSizePixel = 0;
                v242.Size = UDim2.new(1, 0, 0, 5);
                v242.Parent = v240;
                local v243 = Instance.new("Frame");
                v243.AnchorPoint = Vector2.new(0.5, 0);
                v243.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                v243.BorderSizePixel = 0;
                v243.Position = UDim2.fromScale(0.5, 0.8);
                v243.Size = UDim2.new(0.3, 0, 0, 5);
                v243.Parent = v240;
                local v244 = Instance.new("Frame");
                v244.AnchorPoint = Vector2.new(0.5, 0.5);
                v244.BackgroundTransparency = 1;
                v244.Position = UDim2.fromScale(0.5, 0.4);
                v244.Size = UDim2.fromScale(1, 1);
                v244.ZIndex = 0;
                v244.Parent = v19;
                local v245 = {
                    [-48.75] = "24",
                    [48.75] = "30"
                };
                for v246 = 1, 17 do
                    local v247 = -65 + (v246 - 1) * 8.125;
                    local v248 = Instance.new("Frame");
                    v248.AnchorPoint = Vector2.new(0.5, 0.5);
                    v248.BackgroundTransparency = 1;
                    v248.Position = UDim2.fromScale(0.5, 0.5);
                    v248.Rotation = v247;
                    v248.Size = UDim2.new(0, 5, 1, 0);
                    v248.ZIndex = 2;
                    v248.Parent = v244;
                    local v249 = Instance.new("Frame");
                    v249.AnchorPoint = Vector2.new(0, 1);
                    v249.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    v249.BorderSizePixel = 0;
                    v249.Size = UDim2.fromScale(1, v246 % 2 == 0 and 0.03 or 0.05);
                    v249.Parent = v248;
                    if v245[v247] then
                        local v250 = Instance.new("TextLabel");
                        v250.AnchorPoint = Vector2.new(0.5, 1);
                        v250.BackgroundTransparency = 1;
                        v250.Size = UDim2.fromScale(10, 1.5);
                        v250.ZIndex = 2;
                        v250.Font = Enum.Font.RobotoCondensed;
                        v250.Text = v245[v247];
                        v250.TextColor3 = Color3.fromRGB(255, 255, 255);
                        v250.TextScaled = true;
                        v250.Parent = v249;
                    end;
                end;
                local v251 = Instance.new("TextLabel");
                v251.BackgroundTransparency = 1;
                v251.BorderSizePixel = 0;
                v251.Position = UDim2.fromScale(0.93, 0.3);
                v251.Size = UDim2.fromScale(0.1, 0.1);
                v251.ZIndex = 2;
                v251.Font = Enum.Font.RobotoCondensed;
                v251.Text = "80";
                v251.TextColor3 = Color3.fromRGB(255, 255, 255);
                v251.TextScaled = true;
                v251.Parent = v244;
                local v252 = Instance.new("TextLabel");
                v252.BackgroundTransparency = 1;
                v252.BorderSizePixel = 0;
                v252.Position = UDim2.fromScale(0.73, 0.28);
                v252.Size = UDim2.fromScale(0.2, 0.1);
                v252.ZIndex = 2;
                v252.Font = Enum.Font.RobotoCondensed;
                v252.Text = "VOR1";
                v252.TextColor3 = Color3.fromRGB(0, 85, 255);
                v252.TextScaled = true;
                v252.Parent = v244;
                local v253 = Instance.new("ImageLabel");
                v253.BackgroundTransparency = 1;
                v253.Position = UDim2.fromScale(-0.4, -0.7);
                v253.Size = UDim2.fromScale(0.4, 0.8);
                v253.Image = "rbxassetid://105032160262811";
                v253.ScaleType = Enum.ScaleType.Stretch;
                v253.Parent = v252;
                local v254 = Instance.new("TextLabel");
                v254.BackgroundTransparency = 1;
                v254.BorderSizePixel = 0;
                v254.Position = UDim2.fromScale(0.4, 0.24);
                v254.Size = UDim2.fromScale(0.2, 0.1);
                v254.ZIndex = 2;
                v254.Font = Enum.Font.RobotoCondensed;
                v254.Text = "MA35L";
                v254.TextColor3 = Color3.fromRGB(255, 255, 255);
                v254.TextScaled = true;
                v254.Parent = v244;
                local v255 = Instance.new("ImageLabel");
                v255.BackgroundTransparency = 1;
                v255.Position = UDim2.fromScale(-0.4, -0.3);
                v255.Size = UDim2.fromScale(0.4, 0.8);
                v255.Image = "rbxassetid://75036926514756";
                v255.ScaleType = Enum.ScaleType.Stretch;
                v255.Parent = v254;
                local v256 = Instance.new("TextLabel");
                v256.BackgroundTransparency = 1;
                v256.Position = UDim2.fromScale(0.1, 0.4);
                v256.Size = UDim2.fromScale(0.2, 0.1);
                v256.ZIndex = 2;
                v256.Font = Enum.Font.RobotoCondensed;
                v256.Text = "TAC1";
                v256.TextColor3 = Color3.fromRGB(0, 85, 255);
                v256.TextScaled = true;
                v256.Parent = v244;
                local v257 = v255:Clone();
                v257.ImageColor3 = Color3.fromRGB(0, 85, 255);
                v257.Parent = v256;
                local v258 = Instance.new("Frame");
                v258.AnchorPoint = Vector2.new(0.5, 0.5);
                v258.BackgroundTransparency = 1;
                v258.Position = UDim2.fromScale(0.5, 0.7);
                v258.Size = UDim2.fromScale(0.75, 0.75);
                v258.SizeConstraint = Enum.SizeConstraint.RelativeYY;
                v258.Parent = v19;
                local v259 = Instance.new("UICorner");
                v259.CornerRadius = UDim.new(0.5, 0);
                v259.Parent = v258;
                local v260 = Instance.new("UIStroke");
                v260.Color = Color3.fromRGB(255, 255, 255);
                v260.Thickness = 5;
                v260.Parent = v258;
                local v261 = Instance.new("Frame");
                v261.AnchorPoint = Vector2.new(0.5, 0);
                v261.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v261.Position = UDim2.fromScale(0.5, 0.3);
                v261.Size = UDim2.fromScale(1.5, 0.73);
                v261.ZIndex = 1;
                v261.Parent = v258;
                local v262 = Instance.new("TextLabel");
                v262.AnchorPoint = Vector2.new(0.5, 0);
                v262.BackgroundTransparency = 1;
                v262.Position = UDim2.fromScale(0.85, -0.03);
                v262.Size = UDim2.fromScale(0.3, 0.15);
                v262.Font = Enum.Font.RobotoCondensed;
                v262.Text = "CV35L";
                v262.TextColor3 = Color3.fromRGB(255, 255, 255);
                v262.TextScaled = true;
                v262.Parent = v258;
                local v263 = Instance.new("TextLabel");
                v263.AnchorPoint = Vector2.new(0.5, 0);
                v263.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v263.BorderSizePixel = 0;
                v263.Position = UDim2.fromScale(0.9, 0.1);
                v263.Size = UDim2.fromScale(0.15, 0.15);
                v263.Font = Enum.Font.RobotoCondensed;
                v263.Text = "40";
                v263.TextColor3 = Color3.fromRGB(255, 255, 255);
                v263.TextScaled = true;
                v263.Parent = v258;
                local v264 = Instance.new("TextLabel");
                v264.BackgroundTransparency = 1;
                v264.Position = UDim2.fromScale(0.1, 0.4);
                v264.Size = UDim2.fromScale(0.2, 0.1);
                v264.ZIndex = 2;
                v264.Font = Enum.Font.RobotoCondensed;
                v264.Text = "NDB1";
                v264.TextColor3 = Color3.fromRGB(0, 85, 255);
                v264.TextScaled = true;
                v264.Parent = v258;
                local v265 = Instance.new("Frame");
                v265.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v265.Position = UDim2.fromScale(-0.5, -0.5);
                v265.Size = UDim2.fromScale(0.4, 0.8);
                v265.Parent = v264;
                local v266 = Instance.new("UICorner");
                v266.CornerRadius = UDim.new(1, 0);
                v266.Parent = v265;
                local v267 = Instance.new("UIStroke");
                v267.Color = Color3.fromRGB(0, 85, 255);
                v267.Thickness = 3;
                v267.Parent = v265;
                local v268 = Instance.new("Frame");
                v268.AnchorPoint = Vector2.new(0.5, 0.5);
                v268.BackgroundColor3 = Color3.fromRGB(0, 85, 255);
                v268.Position = UDim2.fromScale(0.5, 0.5);
                v268.Size = UDim2.fromScale(0.7, 0.7);
                v268.Parent = v265;
                local v269 = Instance.new("TextLabel");
                v269.BackgroundTransparency = 1;
                v269.Position = UDim2.fromScale(0.576, 0.46);
                v269.Size = UDim2.fromScale(0.2, 0.1);
                v269.ZIndex = 2;
                v269.Font = Enum.Font.RobotoCondensed;
                v269.Text = "FOXX1";
                v269.TextColor3 = Color3.fromRGB(176, 4, 162);
                v269.TextScaled = true;
                v269.Parent = v258;
                local v270 = v255:Clone();
                v270.ImageColor3 = Color3.fromRGB(176, 4, 162);
                v270.Parent = v269;
                local v271 = Instance.new("TextLabel");
                v271.BackgroundTransparency = 1;
                v271.Position = UDim2.fromScale(0.91, 0.4);
                v271.Size = UDim2.fromScale(0.2, 0.1);
                v271.ZIndex = 2;
                v271.Font = Enum.Font.RobotoCondensed;
                v271.Text = "VORTAC";
                v271.TextColor3 = Color3.fromRGB(0, 85, 255);
                v271.TextScaled = true;
                v271.Parent = v258;
                local v272 = Instance.new("Frame");
                v272.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v272.Position = UDim2.fromScale(-0.5, -0.5);
                v272.Size = UDim2.fromScale(0.4, 0.8);
                v272.Parent = v271;
                local v273 = Instance.new("UICorner");
                v273.CornerRadius = UDim.new(1, 0);
                v273.Parent = v272;
                local v274 = Instance.new("UIStroke");
                v274.Color = Color3.fromRGB(0, 85, 255);
                v274.Thickness = 3;
                v274.Parent = v272;
                local v275 = Instance.new("Frame");
                v275.AnchorPoint = Vector2.new(0.5, 0);
                v275.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v275.BorderColor3 = Color3.fromRGB(0, 85, 255);
                v275.BorderSizePixel = 3;
                v275.Position = UDim2.fromScale(-0.1, 0);
                v275.Rotation = -55;
                v275.Size = UDim2.fromScale(0.5, 0.3);
                v275.Parent = v272;
                local v276 = Instance.new("Frame");
                v276.AnchorPoint = Vector2.new(0.5, 0);
                v276.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v276.BorderColor3 = Color3.fromRGB(0, 85, 255);
                v276.BorderSizePixel = 3;
                v276.Position = UDim2.fromScale(1.1, 0);
                v276.Rotation = 55;
                v276.Size = UDim2.fromScale(0.5, 0.3);
                v276.Parent = v272;
                local v277 = Instance.new("Frame");
                v277.AnchorPoint = Vector2.new(0.5, 0);
                v277.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v277.BorderColor3 = Color3.fromRGB(0, 85, 255);
                v277.BorderSizePixel = 3;
                v277.Position = UDim2.fromScale(0.5, 1);
                v277.Size = UDim2.fromScale(0.5, 0.3);
                v277.Parent = v272;
                local v278 = Instance.new("Frame");
                v278.AnchorPoint = Vector2.new(0.5, 0);
                v278.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v278.BorderColor3 = Color3.fromRGB(255, 255, 255);
                v278.BorderSizePixel = 5;
                v278.Position = UDim2.fromScale(0.5, -0.3);
                v278.Size = UDim2.fromScale(0.2, 0.1);
                v278.Parent = v19;
                local v279 = Instance.new("ImageLabel");
                v279.AnchorPoint = Vector2.new(0.5, 1);
                v279.BackgroundTransparency = 1;
                v279.Position = UDim2.fromScale(0.5, 1.5);
                v279.Rotation = -180;
                v279.Size = UDim2.fromScale(0.5, 0.5);
                v279.Image = "rbxassetid://130707049263300";
                v279.ImageColor3 = Color3.fromRGB(255, 255, 255);
                v279.ScaleType = Enum.ScaleType.Stretch;
                v279.Parent = v278;
                local v280 = Instance.new("ImageLabel");
                v280.AnchorPoint = Vector2.new(0.5, 0.5);
                v280.BackgroundTransparency = 1;
                v280.Position = UDim2.fromScale(0.5, 0.7);
                v280.Size = UDim2.fromScale(0.9, 0.9);
                v280.Image = "rbxassetid://130707049263300";
                v280.ImageColor3 = Color3.fromRGB(0, 0, 0);
                v280.ScaleType = Enum.ScaleType.Stretch;
                v280.Parent = v279;
                local v281 = Instance.new("TextLabel");
                v281.BackgroundTransparency = 1;
                v281.Size = UDim2.fromScale(1, 1);
                v281.Font = Enum.Font.RobotoCondensed;
                v281.Text = "270";
                v281.TextColor3 = Color3.fromRGB(255, 255, 255);
                v281.TextScaled = true;
                v281.Parent = v278;
            elseif v17 == "WCA_Caution" then
                v19 = Instance.new("Frame");
                v19.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v19.BorderColor3 = u2[2];
                v19.BorderMode = Enum.BorderMode.Middle;
                v19.BorderSizePixel = 5;
                v19.Size = UDim2.fromScale(0.4, 0.7);
                local v282 = Instance.new("Frame");
                v282.BackgroundTransparency = 1;
                v282.Size = UDim2.fromScale(1, 1);
                v282.Parent = v19;
                local v283 = Instance.new("UIListLayout");
                v283.FillDirection = Enum.FillDirection.Vertical;
                v283.HorizontalAlignment = Enum.HorizontalAlignment.Center;
                v283.VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly;
                for _ = 1, 24 do
                    local v284 = Instance.new("Frame");
                    v284.BackgroundColor3 = u2[2];
                    v284.Size = UDim2.fromScale(0.95, 0.03);
                    v284.Parent = v282;
                    local v285 = Instance.new("TextLabel");
                    v285.BackgroundTransparency = 1;
                    v285.Size = UDim2.fromScale(1, 1);
                    v285.Font = Enum.Font.RobotoCondensed;
                    v285.Text = "XXXXXXXXXXXXXXXXXXXXXXXX";
                    v285.TextColor3 = Color3.fromRGB(0, 0, 0);
                    v285.TextScaled = true;
                    v285.Parent = v284;
                end;
                local v286 = Instance.new("ImageLabel");
                v286.AnchorPoint = Vector2.new(0, 1);
                v286.BackgroundTransparency = 1;
                v286.Position = UDim2.fromScale(0.03, -0.02);
                v286.Size = UDim2.fromScale(0.1, 0.03);
                v286.Image = "rbxassetid://119464251098961";
                v286.ImageColor3 = u2[2];
                v286.Parent = v19;
                local v287 = Instance.new("TextLabel");
                v287.AnchorPoint = Vector2.new(0, 1);
                v287.BackgroundTransparency = 1;
                v287.Position = UDim2.fromScale(0.2, -0.01);
                v287.Size = UDim2.fromScale(0.7, 0.05);
                v287.Font = Enum.Font.RobotoCondensed;
                v287.Text = "CAUTION SUMMARY";
                v287.TextColor3 = u2[2];
                v287.TextScaled = true;
                v287.Parent = v19;
                local v288 = Instance.new("TextLabel");
                v288.AnchorPoint = Vector2.new(0.5, 0);
                v288.BackgroundTransparency = 1;
                v288.Position = UDim2.fromScale(0.5, 1);
                v288.Size = UDim2.fromScale(0.5, 0.05);
                v288.Font = Enum.Font.RobotoCondensed;
                v288.Text = "PAGE X OF Y";
                v288.TextColor3 = u2[2];
                v288.TextScaled = true;
                v288.Parent = v19;
                local v289 = Instance.new("ImageLabel");
                v289.BackgroundTransparency = 1;
                v289.Position = UDim2.fromScale(0.03, 1.01);
                v289.Rotation = 180;
                v289.Size = UDim2.fromScale(0.1, 0.03);
                v289.Image = "rbxassetid://119464251098961";
                v289.ImageColor3 = u2[2];
                v289.Parent = v19;
            elseif v17 == "WCA_Advisory" then
                v19 = Instance.new("Frame");
                v19.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                v19.BorderColor3 = Color3.fromRGB(255, 255, 255);
                v19.BorderMode = Enum.BorderMode.Middle;
                v19.BorderSizePixel = 5;
                v19.Size = UDim2.fromScale(0.4, 0.7);
                local v290 = Instance.new("Frame");
                v290.BackgroundTransparency = 1;
                v290.Size = UDim2.fromScale(1, 1);
                v290.Parent = v19;
                local v291 = Instance.new("UIListLayout");
                v291.FillDirection = Enum.FillDirection.Vertical;
                v291.HorizontalAlignment = Enum.HorizontalAlignment.Center;
                v291.VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly;
                for _ = 1, 24 do
                    local v292 = Instance.new("Frame");
                    v292.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    v292.Size = UDim2.fromScale(0.95, 0.03);
                    v292.Parent = v290;
                    local v293 = Instance.new("TextLabel");
                    v293.BackgroundTransparency = 1;
                    v293.Size = UDim2.fromScale(1, 1);
                    v293.Font = Enum.Font.RobotoCondensed;
                    v293.Text = "XXXXXXXXXXXXXXXXXXXXXXXX";
                    v293.TextColor3 = Color3.fromRGB(0, 0, 0);
                    v293.TextScaled = true;
                    v293.Parent = v292;
                end;
                local v294 = Instance.new("ImageLabel");
                v294.AnchorPoint = Vector2.new(0, 1);
                v294.BackgroundTransparency = 1;
                v294.Position = UDim2.fromScale(0.87, -0.02);
                v294.Size = UDim2.fromScale(0.1, 0.03);
                v294.Image = "rbxassetid://119464251098961";
                v294.ImageColor3 = Color3.fromRGB(255, 255, 255);
                v294.Parent = v19;
                local v295 = Instance.new("TextLabel");
                v295.AnchorPoint = Vector2.new(0, 1);
                v295.BackgroundTransparency = 1;
                v295.Position = UDim2.fromScale(0.2, -0.01);
                v295.Size = UDim2.fromScale(0.7, 0.05);
                v295.Font = Enum.Font.RobotoCondensed;
                v295.Text = "ADVISORY SUMMARY";
                v295.TextColor3 = Color3.fromRGB(255, 255, 255);
                v295.TextScaled = true;
                v295.Parent = v19;
                local v296 = Instance.new("TextLabel");
                v296.AnchorPoint = Vector2.new(0.5, 0);
                v296.BackgroundTransparency = 1;
                v296.Position = UDim2.fromScale(0.5, 1);
                v296.Size = UDim2.fromScale(0.5, 0.05);
                v296.Font = Enum.Font.RobotoCondensed;
                v296.Text = "PAGE X OF Y";
                v296.TextColor3 = Color3.fromRGB(255, 255, 255);
                v296.TextScaled = true;
                v296.Parent = v19;
                local v297 = Instance.new("ImageLabel");
                v297.BackgroundTransparency = 1;
                v297.Position = UDim2.fromScale(0.87, 1.01);
                v297.Rotation = 180;
                v297.Size = UDim2.fromScale(0.1, 0.03);
                v297.Image = "rbxassetid://119464251098961";
                v297.ImageColor3 = Color3.fromRGB(255, 255, 255);
                v297.Parent = v19;
            elseif v17 == "WCA_Text" then
                v19 = Instance.new("TextLabel");
                v19.BackgroundTransparency = 1;
                v19.Font = Enum.Font.RobotoCondensed;
                local l__Value__19 = v18.Value;
                v18.Value = nil;
                local l__TrailIcon__20 = v18.TrailIcon;
                v18.TrailIcon = nil;
                v19.Text = l__Value__19;
                v19.TextColor3 = Color3.fromRGB(255, 255, 255);
                v19.TextScaled = true;
                local v298 = Instance.new("ImageLabel");
                v298.AnchorPoint = Vector2.new(l__TrailIcon__20 and 0 or 1, 0.5);
                v298.BackgroundTransparency = 1;
                v298.Rotation = 180;
                v298.Position = UDim2.fromScale(l__TrailIcon__20 and 1.05 or -0.05, 0.5);
                v298.Size = UDim2.fromScale(0.1, 0.35);
                v298.Image = "rbxassetid://119464251098961";
                v298.ImageColor3 = Color3.fromRGB(255, 255, 255);
                v298.Parent = v19;
            elseif v17 == "UH60_Buttons" then
                v19 = Instance.new("Frame");
                v19.BackgroundTransparency = 1;
                v19.Size = UDim2.fromScale(1, 1);
                local v299 = Instance.new("TextLabel");
                v299.BackgroundTransparency = 1;
                v299.Position = UDim2.fromScale(0, 0.95);
                v299.Size = UDim2.fromScale(0.1, 0.05);
                v299.Text = "PFD";
                v299.TextColor3 = Color3.fromRGB(255, 255, 255);
                v299.TextScaled = true;
                v299.Parent = v19;
                local v300 = Instance.new("TextLabel");
                v300.BackgroundTransparency = 1;
                v300.Position = UDim2.fromScale(0.1, 0.95);
                v300.Size = UDim2.fromScale(0.05, 0.05);
                v300.Text = "ND";
                v300.TextColor3 = Color3.fromRGB(255, 255, 255);
                v300.TextScaled = true;
                v300.Parent = v19;
                local v301 = Instance.new("TextLabel");
                v301.BackgroundTransparency = 1;
                v301.Position = UDim2.fromScale(0.17, 0.95);
                v301.Size = UDim2.fromScale(0.1, 0.05);
                v301.Text = "EICAS";
                v301.TextColor3 = Color3.fromRGB(255, 255, 255);
                v301.TextScaled = true;
                v301.Parent = v19;
            end;
            if v19 then
                if p13 then
                    p13[v19] = u16;
                end;
                for v302, v303 in v18 do
                    if typeof(v303) == "function" then
                        local v304 = v303(l___vehicle__1, u6);
                        u6._hooks[#u6._hooks + 1] = {
                            Object = v19,
                            PropertyName = v302,
                            Value = v303
                        };
                        v19[v302] = v304;
                    else
                        v19[v302] = v303;
                    end;
                end;
                if v14[3] then
                    u305(v19, v14[3], u15);
                end;
                v19.Parent = p11;
            end;
        end;
    end;
    u305(l___frame__2, v8.Content);
end;
function u3.new(p306, p307, p308, p309) --[[ Line: 2085 ]]
    -- upvalues: u1 (copy), u3 (copy)
    p307.ClipsDescendants = true;
    p307.BackgroundColor3 = Color3.new();
    p307.BorderSizePixel = 0;
    local v310 = setmetatable({
        _page = 0,
        _frame = p307,
        _vehicle = p306,
        _defaultPage = p309,
        _config = u1[p308],
        _hooks = {}
    }, u3);
    v310:_initPage(1);
    return v310;
end;
function u3.ChangePage(p311, p312) --[[ Line: 2104 ]]
    if p311:_pageMeetsCondition(p312) then
        p311:_initPage(p312);
    end;
end;
function u3.Update(p313, p314) --[[ Line: 2112 ]]
    local l___config__21 = p313._config;
    local l___vehicle__22 = p313._vehicle;
    if not p313:_pageMeetsCondition(p313._page) then
        local v315 = 0;
        if p313._defaultPage and p313:_pageMeetsCondition(p313._defaultPage) then
            v315 = p313._defaultPage;
        else
            for v316 = 1, #l___config__21.Pages do
                if p313:_pageMeetsCondition(v316) then
                    v315 = v316;
                    break;
                end;
            end;
        end;
        if v315 > 0 then
            p313:_initPage(v315);
        end;
    end;
    for _, v317 in p313._hooks do
        if v317.Update then
            v317.Update(p314);
        else
            v317.Object[v317.PropertyName] = v317.Value(l___vehicle__22, p313, p314);
        end;
    end;
end;
return u3;