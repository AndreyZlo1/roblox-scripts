-- Services.PrefabService.POIPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _, _ = shared.import("require", "asset", "Enum");
local u2 = v1("POI");
local _ = workspace.CurrentCamera;
local u3 = {};
u3.__index = u3;
function u3.new(u4) --[[ Line: 10 ]]
    -- upvalues: u2 (copy), u3 (copy)
    local u5 = {
        Title = u4:GetAttribute("Title"),
        Range = u4:GetAttribute("Range")
    };
    u2[u4] = u5;
    local v6 = setmetatable({
        _attachment = u4
    }, u3);
    v6._conn = u4:GetAttributeChangedSignal("Title"):Connect(function() --[[ Line: 21 ]]
        -- upvalues: u5 (copy), u4 (copy)
        u5.Title = u4:GetAttribute("Title");
    end);
    return v6;
end;
function u3.Destroy(p7) --[[ Line: 28 ]]
    -- upvalues: u2 (copy)
    p7._conn:Disconnect();
    u2[p7._attachment] = nil;
end;
return u3;