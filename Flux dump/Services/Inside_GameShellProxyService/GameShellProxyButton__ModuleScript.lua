-- Services.GameShellProxyService.GameShellProxyButton
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local l__HttpService__1 = game:GetService("HttpService");
game:GetService("Debris");
local u3 = v1("SoundService");
local u4 = v1("GameShellProxyService");
local v5 = u2.Component:extend("Button");
function v5.init(p6, p7) --[[ Line: 11 ]]
    -- upvalues: l__HttpService__1 (copy), u2 (copy), u4 (copy)
    p6._uid = l__HttpService__1:GenerateGUID(false);
    p6._ref = p7.Ref or u2.createRef();
    p6._offset = p7.Offset;
    u4:RegisterButton(p6._uid, {
        Offset = p6._offset,
        Ref = p6._ref
    });
end;
function v5.willUnmount(p8) --[[ Line: 21 ]]
    -- upvalues: u4 (copy)
    u4:UnregisterButton(p8._uid);
end;
function v5.render(p9) --[[ Line: 25 ]]
    -- upvalues: u2 (copy), u4 (copy), u3 (copy)
    local l__props__2 = p9.props;
    local u10 = nil;
    local u11 = nil;
    local v12 = nil;
    local u13 = nil;
    local v14 = nil;
    local v15 = nil;
    local v16 = nil;
    local v17 = nil;
    local v18;
    if l__props__2.HoverLock then
        v18 = l__props__2.HoverLock;
    else
        v18 = nil;
    end;
    if l__props__2.Ignore then
        v15 = l__props__2.Ignore;
    end;
    if l__props__2.Offset then
        p9._offset = l__props__2.Offset;
    end;
    if l__props__2.Ref then
        p9._ref = l__props__2.Ref;
    end;
    if l__props__2.MouseDown then
        u11 = l__props__2.MouseDown;
    end;
    if l__props__2.MouseUp then
        v12 = l__props__2.MouseUp;
    end;
    if l__props__2.MouseEnter then
        u13 = l__props__2.MouseEnter;
    end;
    if l__props__2.MouseLeave then
        v14 = l__props__2.MouseLeave;
    end;
    if l__props__2.SoundKit then
        u10 = l__props__2.SoundKit;
    end;
    if l__props__2.Scroller then
        v16 = l__props__2.Scroller;
    end;
    local v19 = l__props__2.Center and true or v17;
    l__props__2.HoverLock = nil;
    l__props__2.SoundKit = nil;
    l__props__2.Ignore = nil;
    l__props__2.Offset = nil;
    l__props__2.Ref = nil;
    l__props__2.MouseDown = nil;
    l__props__2.MouseUp = nil;
    l__props__2.MouseEnter = nil;
    l__props__2.MouseLeave = nil;
    l__props__2.Scroller = nil;
    l__props__2.Center = nil;
    l__props__2.Image = l__props__2.Image or "";
    l__props__2[u2.Ref] = p9._ref;
    u4:RegisterButton(p9._uid, {
        Offset = p9._offset,
        Ref = p9._ref,
        Scroller = v16,
        Center = v19,
        HoverLock = v18,
        MouseDown = function(...) --[[ Name: MouseDown, Line 90 ]]
            -- upvalues: u10 (ref), u3 (ref), u11 (ref)
            if u10 then
                u3:CreateSound("Button", nil, true, "UIButtons", u10, "Click").Destroy(4);
            end;
            if u11 then
                u11(...);
            end;
        end,
        MouseUp = v12,
        MouseEnter = function(...) --[[ Name: MouseEnter, Line 100 ]]
            -- upvalues: u10 (ref), u3 (ref), u13 (ref)
            if u10 then
                u3:CreateSound("Button", nil, true, "UIButtons", u10, "Hover").Destroy(1);
            end;
            if u13 then
                u13(...);
            end;
        end,
        MouseLeave = v14,
        Ignore = v15
    });
    return u2.createElement("ImageLabel", l__props__2);
end;
return v5;