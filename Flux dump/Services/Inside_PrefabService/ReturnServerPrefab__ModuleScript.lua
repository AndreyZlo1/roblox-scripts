-- Services.PrefabService.ReturnServerPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local _, _, _ = shared.import("require", "asset", "Enum");
local u1 = {};
u1.__index = u1;
function u1.new(p2) --[[ Line: 6 ]]
    -- upvalues: u1 (copy)
    local l__teleportData__1 = shared.teleportData;
    if not (l__teleportData__1 and l__teleportData__1.ServerCode) then
        p2.Parent = nil;
    end;
    return setmetatable({}, u1);
end;
function u1.Destroy(_) --[[ Line: 19 ]] end;
return u1;