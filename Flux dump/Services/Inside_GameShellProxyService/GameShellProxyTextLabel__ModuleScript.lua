-- Services.GameShellProxyService.GameShellProxyTextLabel
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local l__TextService__1 = game:GetService("TextService");
local u3 = v1("RoactTween");
local v4 = u2.Component:extend("GSPTextLabel");
local function u13(u5) --[[ Line: 24 ]]
    -- upvalues: l__TextService__1 (copy)
    local u6 = u5.Ref:getValue();
    local l__Parent__2 = u6.Parent.Parent;
    local l__Parent__3 = u6.Parent;
    local l__AbsoluteSize__4 = l__Parent__2.AbsoluteSize;
    if u6 and (l__AbsoluteSize__4.X ~= 0 and l__AbsoluteSize__4.Y ~= 0) then
        if u5.LastText ~= u6.ContentText then
            u5.LocationTween:SetValue(0);
        end;
        u5.LastText = u6.ContentText;
        local v7 = Instance.new("GetTextBoundsParams");
        v7.Text = u6.ContentText;
        v7.Font = u6.FontFace;
        local v8 = Instance.new("Frame");
        v8.BackgroundTransparency = 1;
        v8.Size = u5.Size;
        v8.SizeConstraint = u5.SizeConstraint;
        v8.Parent = l__Parent__2;
        local l__AbsoluteSize__5 = v8.AbsoluteSize;
        v8:Destroy();
        v7.Size = l__AbsoluteSize__5.Y;
        if u5.AutomaticSize == Enum.AutomaticSize.Y then
            v7.Width = l__AbsoluteSize__5.X;
        else
            v7.Width = (1 / 0);
        end;
        local v9 = l__TextService__1:GetTextBoundsAsync(v7) + Vector2.new(1, 0);
        local u10 = false;
        local _ = l__Parent__3.AbsoluteSize;
        if u5.AutomaticSize == Enum.AutomaticSize.Y then
            local v11;
            if v9.Y > l__AbsoluteSize__4.Y and l__Parent__2.AutomaticSize ~= Enum.AutomaticSize.Y then
                v11 = l__Parent__2.AutomaticSize ~= Enum.AutomaticSize.XY;
            else
                v11 = false;
            end;
            if v11 or not u5.OnlySizeIfOverExtend then
                if u5.SizeConstraint == Enum.SizeConstraint.RelativeXX then
                    l__Parent__3.Size = UDim2.new(l__Parent__3.Size.X.Scale, l__Parent__3.Size.X.Offset, v9.Y / l__AbsoluteSize__4.X, 0);
                else
                    l__Parent__3.Size = UDim2.new(l__Parent__3.Size.X.Scale, l__Parent__3.Size.X.Offset, v9.Y / l__AbsoluteSize__4.Y, 0);
                end;
            else
                l__Parent__3.Size = u5.Size;
            end;
            if v11 then
                u5.OverExtendRatio = v9.Y / l__AbsoluteSize__4.Y - 1;
                u5.PositionRatioDiv = l__Parent__3.AbsoluteSize.Y / l__AbsoluteSize__4.Y;
                u10 = u5.OverExtendRatio * 3.5;
                l__Parent__3.Position = UDim2.new(l__Parent__3.Position.X.Scale, l__Parent__3.Position.X.Offset, 0, l__Parent__3.Position.Y.Offset);
                l__Parent__3.AnchorPoint = l__Parent__3.AnchorPoint * Vector2.new(1, 0);
            else
                u5.PositionRatioDiv = 1;
                u5.OverExtendRatio = 0;
            end;
            if u5.UpdSizeBinding then
                u5.UpdSizeBinding(l__Parent__3.Size.Y.Scale);
            end;
        else
            local v12;
            if v9.X > l__AbsoluteSize__4.X and l__Parent__2.AutomaticSize ~= Enum.AutomaticSize.X then
                v12 = l__Parent__2.AutomaticSize ~= Enum.AutomaticSize.XY;
            else
                v12 = false;
            end;
            if v12 or not u5.OnlySizeIfOverExtend then
                if u5.SizeConstraint == Enum.SizeConstraint.RelativeYY then
                    l__Parent__3.Size = UDim2.new(v9.X / l__AbsoluteSize__4.Y, 0, l__Parent__3.Size.Y.Scale, l__Parent__3.Size.Y.Offset);
                else
                    l__Parent__3.Size = UDim2.new(v9.X / l__AbsoluteSize__4.X, 0, l__Parent__3.Size.Y.Scale, l__Parent__3.Size.Y.Offset);
                end;
            else
                l__Parent__3.Size = u5.Size;
            end;
            if v12 then
                u5.OverExtendRatio = v9.X / l__AbsoluteSize__4.X - 1;
                u5.PositionRatioDiv = l__Parent__3.AbsoluteSize.X / l__AbsoluteSize__4.X;
                u10 = u5.OverExtendRatio * 3.5;
                l__Parent__3.Position = UDim2.new(0, l__Parent__3.Position.X.Offset, l__Parent__3.Position.Y.Scale, l__Parent__3.Position.Y.Offset);
                l__Parent__3.AnchorPoint = l__Parent__3.AnchorPoint * Vector2.new(0, 1);
            else
                u5.PositionRatioDiv = 1;
                u5.OverExtendRatio = 0;
            end;
            if u5.UpdSizeBinding then
                u5.UpdSizeBinding(l__Parent__3.Size.X.Scale);
            end;
        end;
        if u5.Task and coroutine.status(u5.Task) ~= "dead" then
            task.cancel(u5.Task);
            u5.Task = nil;
        end;
        if u10 then
            u5.Task = task.spawn(function() --[[ Line: 133 ]]
                -- upvalues: u6 (copy), u5 (copy), u10 (ref)
                while u6.Parent do
                    u5.LocationTween:SetGoal(1, TweenInfo.new(u10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out));
                    task.wait(u10 + 1);
                    if not u6.Parent then
                        break;
                    end;
                    u5.LocationTween:SetGoal(0, TweenInfo.new(u10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out));
                    task.wait(u10 + 1);
                end;
            end);
        end;
    end;
end;
function v4.init(u14, p15) --[[ Line: 149 ]]
    -- upvalues: u2 (copy), u3 (copy), u13 (copy)
    u14.Ref = p15[u2.Ref] or u2.createRef();
    u14.LocationTween = u3.new(0);
    u14.OverExtendRatio = 0;
    u14.PositionRatioDiv = 1;
    u14.LastText = nil;
    u14.DidMount = p15.DidMount;
    if not u14.DidMount then
        error("Need DidMount table for GameShellProxyTextLabel");
    end;
    u14.DidMount[u14] = function() --[[ Line: 160 ]]
        -- upvalues: u13 (ref), u14 (copy)
        u13(u14);
    end;
end;
function v4.willUnmount(p16) --[[ Line: 165 ]]
    p16.DidMount[p16] = nil;
    p16.LocationTween:Destroy();
    if p16.Task and coroutine.status(p16.Task) ~= "dead" then
        task.cancel(p16.Task);
        p16.Task = nil;
    end;
end;
function v4.render(u17) --[[ Line: 174 ]]
    -- upvalues: u2 (copy), u13 (copy)
    local l__props__6 = u17.props;
    local l__AutomaticSize__7 = l__props__6.AutomaticSize;
    local l__Size__8 = l__props__6.Size;
    local v18 = l__props__6.SizeConstraint or Enum.SizeConstraint.RelativeXY;
    local l__Position__9 = l__props__6.Position;
    local l__AnchorPoint__10 = l__props__6.AnchorPoint;
    local l__LayoutOrder__11 = l__props__6.LayoutOrder;
    local l__OnlySizeIfOverExtend__12 = l__props__6.OnlySizeIfOverExtend;
    local l__UpdSizeBinding__13 = l__props__6.UpdSizeBinding;
    u17.AutomaticSize = l__AutomaticSize__7;
    u17.Size = l__Size__8;
    u17.SizeConstraint = v18;
    u17.OnlySizeIfOverExtend = l__OnlySizeIfOverExtend__12;
    u17.UpdSizeBinding = l__UpdSizeBinding__13;
    assert(l__AutomaticSize__7 ~= Enum.AutomaticSize.XY, "Cannot AutomaticSize X and Y with TextScaled");
    l__props__6.UpdSizeBinding = nil;
    l__props__6.OnlySizeIfOverExtend = nil;
    l__props__6[u2.Ref] = u17.Ref;
    l__props__6.DidMount = nil;
    l__props__6.TextScaled = true;
    l__props__6.AutomaticSize = nil;
    l__props__6.Size = UDim2.fromScale(1, 1);
    l__props__6.SizeConstraint = Enum.SizeConstraint.RelativeXY;
    l__props__6.Position = u17.LocationTween:Map(function(p19) --[[ Line: 202 ]]
        -- upvalues: l__AutomaticSize__7 (copy), u17 (copy)
        if p19 == p19 then
            if l__AutomaticSize__7 == Enum.AutomaticSize.Y then
                return UDim2.fromScale(0, -p19 * u17.OverExtendRatio / u17.PositionRatioDiv);
            else
                return UDim2.fromScale(-p19 * u17.OverExtendRatio / u17.PositionRatioDiv, 0);
            end;
        else
            return UDim2.fromScale(0, 0);
        end;
    end);
    l__props__6.AnchorPoint = Vector2.zero;
    l__props__6[u2.Change.Text] = function() --[[ Line: 215 ]]
        -- upvalues: u13 (ref), u17 (copy)
        u13(u17);
    end;
    l__props__6[u2.Children] = l__props__6[u2.Children] or {};
    l__props__6[u2.Children].GSPGradient = u2.createElement("UIGradient", {
        Transparency = u17.LocationTween:Map(function(p20) --[[ Line: 221 ]]
            -- upvalues: u17 (copy)
            local l__OverExtendRatio__14 = u17.OverExtendRatio;
            if p20 ~= p20 then
                return NumberSequence.new(0);
            end;
            if l__OverExtendRatio__14 == 0 then
                return NumberSequence.new(0);
            end;
            local v21 = l__OverExtendRatio__14 / (l__OverExtendRatio__14 + 1);
            local v22 = 1 - v21;
            local v23 = math.min(0.08, l__OverExtendRatio__14);
            if p20 >= 1 then
                return NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(v21, 1),
                    NumberSequenceKeypoint.new(v21 + v23, 0),
                    NumberSequenceKeypoint.new(1, 0)
                });
            end;
            if p20 <= 0 then
                return NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(v22 - v23, 0),
                    NumberSequenceKeypoint.new(v22, 1),
                    NumberSequenceKeypoint.new(1, 1)
                });
            end;
            local v24 = math.min(v23, p20);
            local v25 = math.min(v23, 1 - p20);
            local v26 = {
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(v21 * p20, 1),
                NumberSequenceKeypoint.new(v21 * p20 + v24, 0),
                NumberSequenceKeypoint.new(1 - v21 * (1 - p20) - v25, 0),
                NumberSequenceKeypoint.new(1 - v21 * (1 - p20), 1),
                NumberSequenceKeypoint.new(1, 1)
            };
            for v27 = 2, #v26 do
                if v26[v27].Time < v26[v27 - 1].Time then
                    return NumberSequence.new(0);
                end;
            end;
            return NumberSequence.new(v26);
        end),
        Rotation = l__AutomaticSize__7 == Enum.AutomaticSize.Y and 90 or 0
    });
    return u2.createElement("Frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = l__Size__8,
        SizeConstraint = v18,
        Position = l__Position__9,
        AnchorPoint = l__AnchorPoint__10,
        LayoutOrder = l__LayoutOrder__11
    }, { u2.createElement("TextLabel", l__props__6) });
end;
return v4;