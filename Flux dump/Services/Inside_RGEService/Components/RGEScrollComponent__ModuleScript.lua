-- Services.RGEService.Components.RGEScrollComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3 = shared.import("require", "Roact", "server");
v1("GameShellProxyButton");
local v4 = u2.Component:extend("RGEScroll");
local u5 = v1("RGEScrollButtonComponent");
function v4.init(p6) --[[ Line: 17 ]]
    -- upvalues: u2 (copy)
    p6.scroller = u2.createRef();
end;
function v4.render(u7) --[[ Line: 21 ]]
    -- upvalues: u3 (copy), u2 (copy), u5 (copy)
    local l__selection__1 = u7.props.selection;
    local l__newSelection__2 = u7.props.newSelection;
    local u8 = -25;
    local u9 = {};
    local u10 = true;
    local u11 = nil;
    if u7.props.instanceCount then
        local v12 = next(u7.props.data);
        if v12 then
            u11 = 0;
            for v13 in u7.props.data[v12] do
                if v13:IsA("Model") and not v13:GetAttribute("PropName") then
                    u11 = u11 + #v13:GetChildren();
                else
                    u11 = u11 + 1;
                end;
            end;
        end;
    end;
    local u14;
    if u7.props.botsDebug then
        u14 = "#: " .. tostring(u3.BOT_TOTAL) .. " (C: " .. tostring(u3.BOT_CLOSE) .. " M: " .. tostring(u3.BOT_MID) .. " F: " .. tostring(u3.BOT_FAR) .. ")";
    else
        u14 = nil;
    end;
    local function u22(p15) --[[ Line: 48 ]]
        -- upvalues: u8 (ref), u10 (ref), u9 (copy), u11 (ref), u14 (ref), u2 (ref), u22 (copy), l__selection__1 (copy), u5 (ref), u7 (copy), l__newSelection__2 (copy)
        for v16, v17 in pairs(p15) do
            u8 = u8 + 25;
            u10 = not u10;
            local v18 = type(v16);
            local v19 = #u9 + 1;
            if v18 == "number" or v18 == "string" then
                local v20 = "<b>" .. tostring(v16):upper() .. "</b>";
                if u11 then
                    v20 = v20 .. " <i>(Part Count: " .. tostring(u11) .. ")</i>";
                end;
                if u14 then
                    v20 = u14;
                end;
                u9[v19] = u2.createElement("Frame", {
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(24, 24, 24),
                    Position = UDim2.new(0, 0, 0, u8),
                    Size = UDim2.new(1, 0, 0, 25)
                }, { u2.createElement("TextLabel", {
                        BackgroundTransparency = 1,
                        RichText = true,
                        TextSize = 14,
                        Position = UDim2.new(0, 10, 0.2, 0),
                        Size = UDim2.new(1, 0, 0.6, 0),
                        Text = v20,
                        TextColor3 = Color3.new(1, 1, 1),
                        Font = Enum.Font.Ubuntu,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }) });
                u22(v17);
            else
                local v21 = table.find(l__selection__1, v16);
                u9[v19] = u2.createElement(u5, {
                    CellSize = 25,
                    Scroller = u7.scroller,
                    Size = u8,
                    Selected = v21,
                    Value = v17,
                    Key = v16,
                    Selection = l__selection__1,
                    NewSelection = l__newSelection__2,
                    Even = u10
                });
            end;
        end;
    end;
    u22(u7.props.data);
    return u2.createElement("ScrollingFrame", {
        [u2.Ref] = u7.scroller,
        Selectable = false,
        Size = u7.props.Size or UDim2.new(1, 0, 1, 0),
        Position = u7.props.Position,
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, u8 + 25),
        ScrollBarImageColor3 = Color3.fromRGB(0, 120, 212),
        ScrollBarThickness = 2,
        BottomImage = "rbxassetid://9653737922",
        MidImage = "rbxassetid://9653737922",
        TopImage = "rbxassetid://9653737922",
        BorderSizePixel = 0
    }, u9);
end;
return v4;