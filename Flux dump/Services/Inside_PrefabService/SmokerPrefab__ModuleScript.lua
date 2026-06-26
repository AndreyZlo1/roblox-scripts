-- Services.PrefabService.SmokerPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _, _ = shared.import("require", "asset", "Enum");
local u2 = v1("EnvironmentService");
local u3 = {};
u3.__index = u3;
function u3.new(p4) --[[ Line: 8 ]]
    -- upvalues: u3 (copy), u2 (copy)
    local v5 = {
        Model = p4,
        Range = p4.Size.Y / 2,
        Danger = p4:GetAttribute("Danger"),
        Damage = p4:GetAttribute("Damage")
    };
    local v6 = setmetatable(v5, u3);
    p4.Transparency = 1;
    u2.Smokers[v6] = true;
    return v6;
end;
function u3.Destroy(p7) --[[ Line: 21 ]]
    -- upvalues: u2 (copy)
    u2.Smokers[p7] = nil;
end;
return u3;