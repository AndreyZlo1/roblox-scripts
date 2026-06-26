-- Services.AnimationService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local _, _ = shared.import("require", "Roact");
local u1 = {};
u1.__index = u1;
function u1.new() --[[ Line: 17 ]]
    -- upvalues: u1 (copy)
    return setmetatable({
        _queue = {}
    }, u1);
end;
function u1.Register(p2, p3) --[[ Line: 25 ]]
    p2._queue[p3] = true;
end;
function u1.Unregister(p4, p5) --[[ Line: 29 ]]
    if p4._queue[p5] then
        p4._queue[p5] = nil;
    end;
end;
function u1.Update(p6) --[[ Line: 35 ]]
    for v7 in p6._queue do
        pcall(v7.Update, v7);
    end;
end;
return u1.new();