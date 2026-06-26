-- Services.PrefabService.TarpPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local _, _, _ = shared.import("require", "asset", "Enum");
local u1 = {};
u1.__index = u1;
function u1.new(p2) --[[ Line: 6 ]]
    -- upvalues: u1 (copy)
    local v3 = p2:GetAttribute("Front") or Vector3.new(1, 0, 0);
    local l__CFrame__1 = p2.CFrame;
    local v4 = l__CFrame__1:VectorToWorldSpace(v3);
    local l__Position__2 = l__CFrame__1.Position;
    local v5 = {
        _amplitude = p2:GetAttribute("Amplitude") or 4,
        _static = p2:GetAttribute("Static") or false,
        _size = p2.Size,
        _center = l__Position__2,
        _cframe = l__CFrame__1,
        _normal = v3,
        _look = CFrame.lookAlong(l__Position__2, v4),
        _model = p2
    };
    return setmetatable(v5, u1);
end;
function u1.Update(p6, _, p7) --[[ Line: 26 ]]
    local l___center__3 = p6._center;
    if (p7 - l___center__3).Magnitude <= 256 then
        local l___model__4 = p6._model;
        local l___normal__5 = p6._normal;
        local l___static__6 = p6._static;
        local l___look__7 = p6._look;
        local v8 = os.clock() / 2;
        local v9 = (math.noise(l___center__3.X + v8, l___center__3.Y + v8, l___center__3.Z + v8) + 1) * p6._amplitude;
        local l___size__8 = p6._size;
        local v10 = math.abs(l___normal__5.X);
        local v11 = math.abs(l___normal__5.Y);
        local v12 = math.abs(l___normal__5.Z);
        l___model__4.Size = l___size__8 + Vector3.new(v10, v11, v12) * v9 - Vector3.new(0, v9 / 2 * (l___static__6 and 0 or 1), 0);
        return l___model__4, p6._cframe - l___look__7.LookVector * (v9 / 2) + l___look__7.UpVector * (l___static__6 and 0 or v9 / 4);
    end;
end;
function u1.Destroy(_) --[[ Line: 43 ]] end;
return u1;