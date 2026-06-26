-- Services.GameShellProxyService.GameShellProxyInput
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local u3 = v1("GameShellProxyButton");
local v4 = u2.Component:extend("Input");
local function u6(p5) --[[ Line: 16 ]]
    local l__props__1 = p5.props;
    local l__ClearTextOnFocus__2 = l__props__1.ClearTextOnFocus;
    if p5.props.Disabled then
    else
        if not p5.state.Editing then
            p5:setState({
                Editing = true
            });
            if l__ClearTextOnFocus__2 then
                l__props__1.TextBindUpdate("");
            end;
        end;
        p5.TextBox:getValue():CaptureFocus();
    end;
end;
function v4.init(p7, p8) --[[ Line: 38 ]]
    -- upvalues: u2 (copy)
    p7.TextBox = u2.createRef();
    p8.TextBindUpdate(p8.FreezeText and p8.PlaceholderText or "");
    local v9 = {
        Hovering = false
    };
    local l__InstantFocus__3 = p7.props.InstantFocus;
    if l__InstantFocus__3 then
        l__InstantFocus__3 = not p7.props.Disabled;
    end;
    v9.Editing = l__InstantFocus__3;
    p7:setState(v9);
end;
function v4.willUnmount(_) --[[ Line: 48 ]] end;
function v4.didMount(p10) --[[ Line: 52 ]]
    -- upvalues: u6 (copy)
    if p10.props.InstantFocus then
        u6(p10);
    end;
end;
function v4.didUpdate(p11) --[[ Line: 58 ]]
    -- upvalues: u6 (copy)
    if p11.state.Editing then
        u6(p11);
    end;
end;
function v4.render(u12) --[[ Line: 64 ]]
    -- upvalues: u2 (copy), u3 (copy), u6 (copy)
    local l__Editing__4 = u12.state.Editing;
    local l__props__5 = u12.props;
    local l__FontFace__6 = l__props__5.FontFace;
    local l__TextXAlignment__7 = l__props__5.TextXAlignment;
    local l__PlaceholderText__8 = l__props__5.PlaceholderText;
    local l__createElement__9 = u2.createElement;
    local v13 = u3;
    local v14 = {
        BorderSizePixel = 0,
        AnchorPoint = l__props__5.AnchorPoint,
        Position = l__props__5.Position,
        Size = l__props__5.Size,
        BackgroundTransparency = l__props__5.BackgroundTransparency,
        BackgroundColor3 = l__props__5.BackgroundColor3,
        LayoutOrder = l__props__5.LayoutOrder,
        Ignore = l__props__5.Ignore,
        MouseUp = function() --[[ Name: MouseUp, Line 81 ]]
            -- upvalues: u6 (ref), u12 (copy)
            u6(u12);
        end,
        MouseEnter = function() --[[ Name: MouseEnter, Line 84 ]]
            -- upvalues: u12 (copy)
            u12:setState({
                Hovering = true
            });
        end,
        MouseLeave = function() --[[ Name: MouseLeave, Line 89 ]]
            -- upvalues: u12 (copy)
            u12:setState({
                Hovering = false
            });
        end
    };
    local v15 = {};
    local v16 = u2.createFragment(l__props__5.Content);
    local v19 = l__Editing__4 and u2.createElement("TextBox", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(0.8, 0.4),
        Position = UDim2.fromScale(0.1, 0.3),
        Text = l__props__5.TextBind,
        TextColor3 = Color3.new(1, 1, 1),
        TextScaled = true,
        FontFace = l__FontFace__6,
        ClearTextOnFocus = false,
        MultiLine = false,
        AutoLocalize = false,
        TextXAlignment = l__TextXAlignment__7,
        [u2.Ref] = u12.TextBox,
        [u2.Change.Text] = function(p17) --[[ Line: 110 ]]
            -- upvalues: l__props__5 (copy), l__PlaceholderText__8 (copy)
            if l__props__5.FreezeText then
                l__props__5.TextBindUpdate(l__PlaceholderText__8);
            else
                l__props__5.TextBindUpdate(p17.Text);
            end;
        end,
        [u2.Event.FocusLost] = function(_, p18) --[[ Line: 117 ]]
            -- upvalues: u12 (copy), l__props__5 (copy)
            u12:setState({
                Editing = false
            });
            if p18 and l__props__5.EnterPressed then
                l__props__5.EnterPressed();
            end;
        end
    });
    if not v19 then
        local l__createElement__10 = u2.createElement;
        local v20 = "TextLabel";
        local v21 = {
            BackgroundTransparency = 1,
            TextScaled = true,
            AutoLocalize = false,
            Size = UDim2.fromScale(0.8, 0.4),
            Position = UDim2.fromScale(0.1, 0.3)
        };
        if #l__props__5.TextBind:getValue() > 0 then
            l__PlaceholderText__8 = l__props__5.TextBind or l__PlaceholderText__8;
        end;
        v21.Text = l__PlaceholderText__8;
        v21.TextColor3 = u12.state.Hovering and Color3.fromRGB(255, 194, 89) or Color3.new(0.368627, 0.368627, 0.368627);
        v21.FontFace = l__FontFace__6;
        v21.TextXAlignment = l__TextXAlignment__7;
        v19 = l__createElement__10(v20, v21);
    end;
    v15[1], v15[2] = v16, v19;
    return l__createElement__9(v13, v14, v15);
end;
return v4;