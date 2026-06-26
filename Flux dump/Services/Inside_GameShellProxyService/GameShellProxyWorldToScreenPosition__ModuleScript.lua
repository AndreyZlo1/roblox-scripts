-- Services.GameShellProxyService.GameShellProxyWorldToScreenPosition
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local _, u1 = shared.import("require", "Roact");
local l__Players__1 = game:GetService("Players");
local v2 = u1.Component:extend("GameShellProxyWorldToScreenPosition");
local l__CurrentCamera__2 = workspace.CurrentCamera;
local function u14(p3) --[[ Line: 26 ]]
    -- upvalues: l__CurrentCamera__2 (copy)
    local l__CFrame__3 = l__CurrentCamera__2.CFrame;
    local l__WorldPosition__4 = p3.WorldPosition;
    local v4 = p3.Extents / 2;
    local l__ExtentsOffset__5 = p3.props.ExtentsOffset;
    if type(l__ExtentsOffset__5) == "table" then
        l__ExtentsOffset__5 = l__ExtentsOffset__5:getValue();
    end;
    local v5 = l__ExtentsOffset__5 or Vector3.new(0, 0, 0);
    local v6 = Vector3.new(v4.X * v5.X, v4.Y * v5.Y, v4.Z * v5.Z);
    local v7 = l__WorldPosition__4 + l__CFrame__3.Rotation:VectorToWorldSpace(v6);
    local l__ExtentsOffsetWorldSpace__6 = p3.props.ExtentsOffsetWorldSpace;
    if type(l__ExtentsOffsetWorldSpace__6) == "table" then
        l__ExtentsOffsetWorldSpace__6 = l__ExtentsOffsetWorldSpace__6:getValue();
    end;
    local v8 = l__ExtentsOffsetWorldSpace__6 or Vector3.new(0, 0, 0);
    local v9 = v7 + Vector3.new(v4.X * v8.X, v4.Y * v8.Y, v4.Z * v8.Z);
    local l__StudsOffset__7 = p3.props.StudsOffset;
    if type(l__StudsOffset__7) == "table" then
        l__StudsOffset__7 = l__StudsOffset__7:getValue();
    end;
    local v10 = v9 + l__CFrame__3.Rotation:VectorToWorldSpace(l__StudsOffset__7 or Vector3.new(0, 0, 0));
    local l__StudsOffsetWorldSpace__8 = p3.props.StudsOffsetWorldSpace;
    if type(l__StudsOffsetWorldSpace__8) == "table" then
        l__StudsOffsetWorldSpace__8 = l__StudsOffsetWorldSpace__8:getValue();
    end;
    local v11 = l__CurrentCamera__2:WorldToViewportPoint(v10 + (l__StudsOffsetWorldSpace__8 or Vector3.new(0, 0, 0)));
    local l__FrameRef__9 = p3.FrameRef;
    if l__FrameRef__9 then
        l__FrameRef__9 = p3.FrameRef:getValue();
    end;
    local v12 = l__FrameRef__9 and l__FrameRef__9.AbsoluteSize or Vector2.zero;
    local l__SizeOffset__10 = p3.props.SizeOffset;
    if type(l__SizeOffset__10) == "table" then
        l__SizeOffset__10 = l__SizeOffset__10:getValue();
    end;
    local v13 = l__SizeOffset__10 or Vector2.zero;
    return UDim2.fromOffset(v11.X + v12.X * v13.X, v11.Y + v12.Y * v13.Y);
end;
local function u17(p15) --[[ Line: 58 ]]
    local l__Size__11 = p15.props.Size;
    if type(l__Size__11) == "table" then
        l__Size__11 = l__Size__11:getValue();
    end;
    local l__BGUIref__12 = p15.BGUIref;
    if l__BGUIref__12 then
        l__BGUIref__12 = p15.BGUIref:getValue();
    end;
    if l__BGUIref__12 then
        l__BGUIref__12 = l__BGUIref__12.AbsoluteSize;
    end;
    local v16;
    if l__BGUIref__12 then
        v16 = UDim2.fromOffset(l__BGUIref__12.X, l__BGUIref__12.Y);
    else
        v16 = UDim2.fromOffset(0, 0);
    end;
    return l__Size__11 + v16;
end;
local function u24(p18) --[[ Line: 72 ]]
    -- upvalues: l__CurrentCamera__2 (copy)
    local l__Adornee__13 = p18.props.Adornee;
    if type(l__Adornee__13) == "table" then
        l__Adornee__13 = l__Adornee__13:getValue();
    end;
    local l__MaxDistance__14 = p18.props.MaxDistance;
    if type(l__MaxDistance__14) == "table" then
        l__MaxDistance__14 = l__MaxDistance__14:getValue();
    end;
    local v19 = l__MaxDistance__14 or (1 / 0);
    local v20 = nil;
    local v21 = nil;
    if l__Adornee__13:IsA("Model") then
        local v22;
        v22, v21 = l__Adornee__13:GetBoundingBox();
        v20 = v22.Position;
    elseif l__Adornee__13:IsA("BasePart") then
        v20 = l__Adornee__13.Position;
        v21 = l__Adornee__13.Size;
    elseif l__Adornee__13:IsA("Attachment") then
        v20 = l__Adornee__13.WorldPosition;
        v21 = Vector3.new(0, 0, 0);
    end;
    p18.WorldPosition = v20;
    p18.Extents = v21;
    local l__Z__15 = l__CurrentCamera__2.CFrame:PointToObjectSpace(v20).Z;
    local v23 = math.abs(l__Z__15);
    p18.Distance = v23;
    return v23 < v19;
end;
local u25 = {};
function v2.init(p26, _) --[[ Line: 111 ]]
    -- upvalues: u1 (copy)
    local v27, v28 = u1.createBinding(false);
    p26._visible = v27;
    p26._updVisible = v28;
    local v29, v30 = u1.createBinding(UDim2.fromOffset(0, 0));
    p26._size = v29;
    p26._updSize = v30;
    local v31, v32 = u1.createBinding(UDim2.fromOffset(0, 0));
    p26._position = v31;
    p26._updPosition = v32;
    p26.BGUIref = u1.createRef();
    p26.FrameRef = u1.createRef();
end;
function v2.didMount(p33) --[[ Line: 120 ]]
    -- upvalues: u25 (copy)
    p33.JustInserted = true;
    table.insert(u25, p33);
end;
function v2.willUnmount(p34) --[[ Line: 125 ]]
    -- upvalues: u25 (copy)
    local v35 = table.find(u25, p34);
    if v35 then
        table.remove(u25, v35);
    end;
end;
function v2.render(p36) --[[ Line: 132 ]]
    -- upvalues: u1 (copy), l__Players__1 (copy)
    local l__props__16 = p36.props;
    local l__StudsSize__17 = l__props__16.StudsSize;
    local v37 = { u1.createElement("Frame", {
            Position = p36._position,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = p36._size,
            Visible = p36._visible,
            [u1.Ref] = p36.FrameRef,
            [u1.Children] = l__props__16[u1.Children]
        }) };
    if l__StudsSize__17 then
        local l__createElement__18 = u1.createElement;
        local l__Portal__19 = u1.Portal;
        local v38 = {
            target = l__Players__1.LocalPlayer.PlayerGui
        };
        local v39 = {
            ProxyBGUI = u1.createElement("BillboardGui", {
                MaxDistance = l__props__16.MaxDistance,
                Adornee = l__props__16.Adornee,
                Size = l__StudsSize__17,
                ExtentsOffset = l__props__16.ExtentsOffset,
                ExtentsOffsetWorldSpace = l__props__16.ExtentsOffsetWorldSpace,
                StudsOffset = l__props__16.StudsOffset,
                StudsOffsetWorldSpace = l__props__16.StudsOffsetWorldSpace,
                SizeOffset = l__props__16.SizeOffset,
                [u1.Ref] = p36.BGUIref
            })
        };
        table.insert(v37, l__createElement__18(l__Portal__19, v38, v39));
    end;
    return u1.createFragment(v37);
end;
function v2.Update() --[[ Line: 173 ]]
    -- upvalues: u25 (copy), u24 (copy), u14 (copy), u17 (copy)
    local v40 = 100;
    local v41 = 0.7;
    for _, v42 in u25 do
        if v42.JustInserted then
            v42.JustInserted = false;
        else
            if v42.Distance then
                v40 = math.min(v40, v42.Distance);
                v41 = math.max(v41, v42.Distance);
            end;
            local v43 = u24(v42);
            if v43 then
                v42._updPosition((u14(v42)));
                v42._updSize((u17(v42)));
            end;
            v42._updVisible(v43);
        end;
    end;
    local v44 = #u25 > 1;
    for _, v45 in u25 do
        if v45.Distance then
            v45.props.AffectDistance(v44 and (math.clamp((v45.Distance - v40) / (v41 - v40), 0, 0.9) or 0) or 0);
        end;
    end;
end;
return v2;