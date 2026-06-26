-- Services.AnimationService.RoactTween
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local u3 = v1("Tween");
local u4 = setmetatable({}, u3);
u4.__index = u4;
function u4.new(p5, p6) --[[ Line: 18 ]]
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local v7, v8 = u2.createBinding(p5);
    local v9 = u3.new(p5, p6);
    local v10 = setmetatable(v9, u4);
    v10.Binding = v7;
    v10._updateBinding = v8;
    return v10;
end;
function u4.Map(p11, p12) --[[ Line: 27 ]]
    return p11.Binding:map(p12);
end;
function u4.Update(p13) --[[ Line: 31 ]]
    local v14 = p13:_update();
    if v14 then
        p13._updateBinding(v14);
    end;
end;
function u4.SetValue(p15, p16) --[[ Line: 38 ]]
    p15._value = p16;
    p15._goal = p16;
    p15._updateBinding(p16);
end;
return u4;