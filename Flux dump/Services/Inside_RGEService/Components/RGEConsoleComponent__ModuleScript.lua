-- Services.RGEService.Components.RGEConsoleComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local u3 = v1("Commands");
local u4 = v1("InputService");
local v5 = u2.Component:extend("RGEConsole");
function v5.willUnmount(p6) --[[ Line: 12 ]]
    p6.controls:Disconnect();
end;
function v5.init(u7, _) --[[ Line: 16 ]]
    -- upvalues: u2 (copy), u4 (copy)
    u7.line = u2.createRef();
    u7.output = u2.createRef();
    u7.prefill = "";
    u7.memory = {};
    u7.last = 0;
    u7.at = 0;
    local function u10(p8) --[[ Line: 24 ]]
        -- upvalues: u7 (copy)
        local l__memory__1 = u7.memory;
        if #l__memory__1 == 0 then
        else
            u7.at = math.clamp(u7.at + p8, 1, #l__memory__1);
            u7:setState({
                arguments = u7.memory[u7.at]
            });
            local v9 = u7.line:getValue();
            v9.CursorPosition = #v9.Text + 1;
        end;
    end;
    u7.controls = u4:Connect({
        PrevCommand = function(p11) --[[ Name: PrevCommand, Line 40 ]]
            -- upvalues: u10 (copy)
            if p11 then
                u10(1);
            end;
        end,
        NextCommand = function(p12) --[[ Name: NextCommand, Line 45 ]]
            -- upvalues: u10 (copy)
            if p12 then
                u10(-1);
            end;
        end
    });
    function u7.changed(p13) --[[ Line: 51 ]]
        -- upvalues: u7 (copy)
        local l__Text__2 = p13.Text;
        local l__prefill__3 = u7.prefill;
        local v14 = false;
        local v15 = {};
        local v16 = #l__Text__2;
        if v16 > 0 then
            local v17 = 0;
            local v18 = 1;
            local v19 = 0;
            while v17 < v16 do
                v17 = v17 + 1;
                local v20 = v17 == v16;
                local v21 = l__Text__2:sub(v17, v17);
                if v20 then
                    local v22 = v21 == " ";
                    local v23 = false;
                    if v21 == "\t" then
                        if #l__prefill__3 > 0 then
                            v15[#v15 + 1] = l__prefill__3;
                            v23 = true;
                            v14 = true;
                        else
                            v22 = true;
                        end;
                    end;
                    if not v23 then
                        v15[#v15 + 1] = l__Text__2:sub(v18, v17 - (v22 and 1 or 0));
                        if v22 then
                            v15[#v15 + 1] = "";
                        end;
                    end;
                elseif v21 == " " then
                    if v19 == 0 then
                        v15[#v15 + 1] = l__Text__2:sub(v18, v17 - 1);
                        v18 = v17 + 1;
                    end;
                elseif v21 == "[" then
                    v19 = v19 + 1;
                elseif v21 == "]" then
                    v19 = v19 - 1;
                end;
            end;
        end;
        u7:setState({
            arguments = v15
        });
        if v14 then
            local v24 = u7.line:getValue();
            v24.CursorPosition = #v24.Text + 1;
        end;
    end;
    function u7.send(p25, p26) --[[ Line: 108 ]]
        -- upvalues: u7 (copy)
        if p26 then
            local l__arguments__4 = u7.state.arguments;
            if os.clock() - u7.last > 0.05 then
                u7.props.newConsoleLine(l__arguments__4);
            end;
            u7.last = os.clock();
            u7.at = 0;
            table.insert(u7.memory, 1, l__arguments__4);
            p25.Text = "";
            task.wait();
            u7.line:getValue():CaptureFocus();
        end;
    end;
    u7:setState({
        arguments = {}
    });
end;
function v5.render(p27) --[[ Line: 131 ]]
    -- upvalues: u3 (copy), u2 (copy)
    local l__arguments__5 = p27.state.arguments;
    local v28 = table.concat(l__arguments__5, " ");
    local v29 = 0;
    local v30 = u3;
    if #l__arguments__5 > 0 then
        v29 = v29 + 15;
        for v31 = 1, #l__arguments__5 - 1 do
            local v32 = l__arguments__5[v31];
            local v33 = 0;
            if v30 then
                for v34 = 1, #v30 do
                    local l__Name__6 = v30[v34].Name;
                    if l__Name__6 == v32 or l__Name__6:sub(1, 1) == "[" then
                        v33 = v34;
                        break;
                    end;
                end;
                v30 = v33 > 0 and v30[v33].Arguments or nil;
            end;
            v29 = v29 + (#v32 + 1) * 8;
        end;
    end;
    local l__console__7 = p27.props.console;
    local v35 = {
        List = u2.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        })
    };
    for v36 = 1, #l__console__7 do
        local v37 = l__console__7[v36];
        local v38 = os.date("*t", v37[1]);
        local u39 = ("[%02d:%02d:%02d] %s"):format(v38.hour, v38.min, v38.sec, v37[2]);
        v35[v36] = u2.createElement("TextBox", {
            Text = u39,
            BackgroundTransparency = 1,
            TextColor3 = v37[3],
            TextScaled = false,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            Font = Enum.Font.Code,
            TextSize = 15,
            Size = UDim2.new(1, 0, 0, 15),
            [u2.Change.Text] = function(p40) --[[ Line: 179 ]]
                -- upvalues: u39 (copy)
                p40.Text = u39;
            end
        });
    end;
    local v41 = {
        List = u2.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        })
    };
    local v42 = "";
    local v43 = -100;
    if v30 and #l__arguments__5 > 0 then
        for v44 = 1, #v30 do
            local v45 = v30[v44];
            local l__Name__8 = v45.Name;
            local v46, v47, v48 = pcall(l__Name__8.find, l__Name__8, l__arguments__5[#l__arguments__5]);
            if v46 then
                local v49 = #l__Name__8 * 8;
                local v50, v51;
                if v47 and (v48 and l__Name__8:sub(1, 1) ~= "[") then
                    v50 = v48 - v47 + 1 - v47 - 1;
                    l__Name__8 = l__Name__8:sub(0, v47 - 1) .. "<b>" .. l__Name__8:sub(v47, v48) .. "</b>" .. l__Name__8:sub(v48 + 1);
                    v51 = true;
                else
                    v51 = false;
                    v50 = -100;
                end;
                if v43 < v50 or #v42 == 0 and v51 then
                    p27.prefill = v45.Name;
                    v42 = v45.Description;
                    v43 = v50;
                end;
                v41[v44] = u2.createElement("TextLabel", {
                    TextScaled = false,
                    RichText = true,
                    TextSize = 15,
                    BorderSizePixel = 0,
                    Text = l__Name__8,
                    Size = UDim2.new(0, v49, 0, 15),
                    Font = Enum.Font.Code,
                    LayoutOrder = v50 + 100,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                });
            end;
        end;
    end;
    local l__createFragment__9 = u2.createFragment;
    local v52 = {
        Output = u2.createElement("ScrollingFrame", {
            Selectable = false,
            Size = UDim2.new(1, 0, 1, -30),
            BackgroundColor3 = Color3.new(),
            CanvasSize = UDim2.new(0, 0, 0, #l__console__7 * 15),
            ScrollBarImageColor3 = Color3.fromRGB(0, 120, 212),
            ScrollBarThickness = 2,
            BottomImage = "rbxassetid://9653737922",
            MidImage = "rbxassetid://9653737922",
            TopImage = "rbxassetid://9653737922",
            BorderSizePixel = 0,
            [u2.Ref] = p27.output
        }, v35)
    };
    local l__createElement__10 = u2.createElement;
    local v53 = "Frame";
    local v54 = {
        BorderSizePixel = 0,
        ZIndex = 2,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 1, -30),
        BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    };
    local v55 = {};
    local v56;
    if #v42 > 0 then
        v56 = u2.createElement("TextLabel", {
            TextScaled = false,
            RichText = true,
            TextSize = 15,
            BorderSizePixel = 0,
            Text = v42,
            Size = UDim2.new(0, #v42 * 8, 0, 15),
            Font = Enum.Font.Code,
            TextColor3 = Color3.new(1, 1, 1),
            Position = UDim2.new(1, -15, 0, 0),
            AnchorPoint = Vector2.new(1, 1),
            TextXAlignment = Enum.TextXAlignment.Right,
            BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        });
    else
        v56 = false;
    end;
    v55.Description = v56;
    local v57;
    if v29 > 0 then
        v57 = u2.createElement("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, v29, 0, 0),
            AnchorPoint = Vector2.new(0, 1)
        }, v41);
    else
        v57 = false;
    end;
    v55.Autocomplete = v57;
    v55.Line = u2.createElement("TextBox", {
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.Code,
        TextColor3 = Color3.new(1, 1, 1),
        TextScaled = false,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = v28,
        PlaceholderText = "Run a command",
        [u2.Ref] = p27.line,
        [u2.Change.Text] = p27.changed,
        [u2.Event.FocusLost] = p27.send
    });
    v52.Command = l__createElement__10(v53, v54, v55);
    return l__createFragment__9(v52);
end;
function v5.didUpdate(p58) --[[ Line: 292 ]]
    local v59 = p58.output:getValue();
    v59.CanvasPosition = Vector2.new(0, v59.CanvasSize.Y.Offset);
end;
return v5;