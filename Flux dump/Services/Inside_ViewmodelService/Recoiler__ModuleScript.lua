-- Services.ViewmodelService.Recoiler
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _, _ = shared.import("require", "asset", "Enum");
local u2 = v1("Spring");
local u3 = v1("DebugService");
local u4 = {};
u4.__index = u4;
function u4.new(p5) --[[ Line: 13 ]]
    -- upvalues: u2 (copy), u4 (copy), u3 (copy)
    local v6 = {
        Drag = 1,
        Kick = 1,
        Spring = u2.new(Vector2.zero),
        _debugName = p5
    };
    local u7 = setmetatable(v6, u4);
    u7.Spring.Speed = 20;
    u7.Spring.Damper = 0.8;
    if p5 then
        u3:Slider(p5 .. ".Speed", u7.Spring.Speed, 0, 100, nil, function(p8) --[[ Line: 26 ]]
            -- upvalues: u7 (copy)
            u7.Spring.Speed = p8;
        end);
        u3:Slider(p5 .. ".Damper", u7.Spring.Damper, 0, 1, nil, function(p9) --[[ Line: 30 ]]
            -- upvalues: u7 (copy)
            u7.Spring.Damper = p9;
        end);
    end;
    return u7;
end;
function u4.Destroy(p10) --[[ Line: 38 ]]
    -- upvalues: u3 (copy)
    if p10._debugName then
        u3:UnRegisterCallback(p10._debugName .. ".Speed");
        u3:UnRegisterCallback(p10._debugName .. ".Damper");
    end;
end;
function u4.TimeSkip(p11, p12) --[[ Line: 45 ]]
    p11.Spring:TimeSkip(p12);
end;
function u4.Impulse(p13, p14, p15, p16) --[[ Line: 49 ]]
    p13.Drag = p14;
    p13.Kick = p15;
    p13.Spring:Impulse(p16);
end;
function u4.GetViewmodelAdjustment(p17, _, _) --[[ Line: 55 ]]
    local l__Position__1 = p17.Spring.Position;
    return CFrame.new(0, 0, l__Position__1.Y * 3 * p17.Kick) * CFrame.Angles(l__Position__1.Y / 6, l__Position__1.X / 6, 0);
end;
function u4.GetCameraAdjustment(p18, p19, _) --[[ Line: 62 ]]
    local l__Position__2 = p18.Spring.Position;
    local l__Drag__3 = p18.Drag;
    return CFrame.Angles(l__Position__2.Y / 3 * l__Drag__3 * 1, l__Position__2.X / 3 * l__Drag__3 * 1, 0), l__Position__2.Y * 2 * p19 * 1;
end;
return u4;