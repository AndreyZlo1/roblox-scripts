-- Services.AnimationService.Tween
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1 = shared.import("require");
local l__TweenService__1 = game:GetService("TweenService");
local u2 = v1("AnimationService");
local u3 = {};
u3.__index = u3;
function u3.new(p4, p5) --[[ Line: 20 ]]
    -- upvalues: u3 (copy)
    local v6 = p5 or TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0);
    local v7 = {
        _destroyed = false,
        _repeats = 0,
        _start = tick(),
        _value = p4,
        _from = p4,
        _goal = p4,
        _tweenInfo = v6
    };
    return setmetatable(v7, u3);
end;
function u3._update(p8) --[[ Line: 37 ]]
    -- upvalues: l__TweenService__1 (copy), u2 (copy)
    local l___tweenInfo__2 = p8._tweenInfo;
    local l___from__3 = p8._from;
    local l___goal__4 = p8._goal;
    local l___start__5 = p8._start;
    local v9 = tick();
    local l__Time__6 = l___tweenInfo__2.Time;
    local l__Reverses__7 = l___tweenInfo__2.Reverses;
    local v10 = v9 - l___start__5;
    if v9 < l___start__5 then
    else
        local v11;
        if l___tweenInfo__2.RepeatCount >= 0 then
            v11 = l__Time__6 * (1 + l___tweenInfo__2.RepeatCount) * (l__Reverses__7 and 2 or 1);
        else
            v11 = nil;
        end;
        local v12;
        if v11 == nil or v10 < v11 then
            if l__Reverses__7 then
                local v13 = v10 % (l__Time__6 * 2) / (l__Time__6 * 2);
                v12 = v13 > 0.5 and (1 - v13) * 2 or v13 * 2;
            else
                v12 = v10 % l__Time__6 / l__Time__6;
            end;
        else
            v12 = l__Reverses__7 and 0 or 1;
        end;
        local v14 = l__TweenService__1:GetValue(v12, l___tweenInfo__2.EasingStyle, l___tweenInfo__2.EasingDirection);
        local v15 = l___from__3 + (l___goal__4 - l___from__3) * v14;
        if p8._value ~= v15 then
            p8._value = v15;
            return v15;
        end;
        u2:Unregister(p8);
    end;
end;
function u3.Destroy(p16) --[[ Line: 77 ]]
    -- upvalues: u2 (copy)
    if p16._destroyed then
    else
        p16._destroyed = true;
        u2:Unregister(p16);
    end;
end;
function u3.SetValue(p17, p18) --[[ Line: 85 ]]
    p17._value = p18;
    p17._goal = p18;
end;
function u3.GetValue(p19) --[[ Line: 90 ]]
    return p19._value;
end;
function u3.IsGoal(p20, p21) --[[ Line: 94 ]]
    return p20._goal == p21;
end;
function u3.GetGoal(p22) --[[ Line: 98 ]]
    return p22._goal;
end;
function u3.SetGoal(p23, p24, p25) --[[ Line: 102 ]]
    -- upvalues: u2 (copy)
    if p23._destroyed then
    else
        if p25 then
            p23._tweenInfo = p25;
        end;
        p23._start = tick() + p23._tweenInfo.DelayTime;
        p23._from = p23._value;
        p23._goal = p24;
        p23._repeats = 0;
        u2:Register(p23);
    end;
end;
function u3.TimeSkip(p26, p27) --[[ Line: 117 ]]
    p26._start = p26._start - p27;
end;
return u3;