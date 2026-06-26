-- Services.AnimationService.NumberTween
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _ = shared.import("require", "Roact");
local u2 = v1("Tween");
local u3 = setmetatable({}, u2);
u3.__index = u3;
function u3.new(p4, p5) --[[ Line: 18 ]]
    -- upvalues: u2 (copy), u3 (copy)
    local v6 = u2.new(p4, p5);
    return setmetatable(v6, u3);
end;
function u3.Update(p7) --[[ Line: 23 ]]
    p7:_update();
end;
return u3;