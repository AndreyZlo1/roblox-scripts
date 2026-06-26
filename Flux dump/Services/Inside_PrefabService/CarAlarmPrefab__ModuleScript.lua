-- Services.PrefabService.CarAlarmPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _, u2 = shared.import("require", "asset", "Enum");
local u3 = v1("SoundService");
local u4 = {
    Rear = {
        Color = Color3.new(1, 0.411764, 0.411764),
        Face = u2.NormalId.Back
    },
    Front = {
        Color = Color3.new(1, 1, 1),
        Face = u2.NormalId.Front
    },
    All = {
        Color = Color3.new(1, 0.631372, 0.211764),
        Face = u2.NormalId.Top
    },
    Third = {
        Color = Color3.new(1, 1, 1),
        Face = u2.NormalId.Back
    },
    Emergency1 = {
        Color = Color3.new(1, 0.411764, 0.411764),
        Face = u2.NormalId.Top
    },
    Emergency2 = {
        Color = Color3.new(1, 1, 1),
        Face = u2.NormalId.Top
    }
};
local u5 = {};
u5.__index = u5;
function u5.new(p6) --[[ Line: 35 ]]
    -- upvalues: u4 (copy), u3 (copy), u5 (copy)
    local v7 = Vector3.new();
    local v8 = {};
    for _, v9 in p6:GetChildren() do
        local v10 = u4[v9.Name] or u4.All;
        local v11 = Instance.new("SurfaceLight");
        v11.Color = v10.Color;
        v11.Enabled = false;
        v11.Brightness = 5;
        v11.Face = v10.Face;
        v11.Parent = v9;
        v8[#v8 + 1] = {
            Part = v9,
            Texture = v9.TextureID,
            Material = v9.Material,
            Color = v9.Color,
            Type = v9.Name,
            Light = v11
        };
        v7 = v7 + v9.Position;
    end;
    local v12 = v7 / #v8;
    local v13 = Instance.new("Attachment");
    v13.Parent = p6;
    v13.WorldCFrame = CFrame.new(v12);
    local v14 = {
        _index = 1,
        _sound = u3:CreateSound("Foliage", v13, true, "Foley", "CarAlarms", p6:GetAttribute("Sound") or "Civilian"),
        _attachment = v13,
        _last = tick(),
        _origin = v12,
        _parts = v8
    };
    return setmetatable(v14, u5);
end;
function u5.Update(p15, _, p16) --[[ Line: 77 ]]
    -- upvalues: u4 (copy), u2 (copy)
    if (p16 - p15._origin).Magnitude > 512 then
    else
        local v17 = tick();
        if v17 - p15._last < 0.1 then
        else
            p15._last = v17;
            local l___index__1 = p15._index;
            for v18, v19 in p15._parts do
                local v20 = v18 == l___index__1;
                local l__Part__2 = v19.Part;
                local v21 = u4[v19.Type] or u4.All;
                v19.Light.Enabled = v20;
                l__Part__2.TextureID = v20 and "" or v19.Texture;
                l__Part__2.Material = v20 and u2.Material.Neon or v19.Material;
                l__Part__2.Color = v20 and v21.Color or v19.Color;
            end;
            if p15._index == #p15._parts then
                p15._index = 1;
            else
                p15._index = p15._index + 1;
            end;
        end;
    end;
end;
function u5.Destroy(p22) --[[ Line: 107 ]]
    p22._sound.Destroy();
    p22._attachment:Destroy();
    for _, v23 in p22._parts do
        local l__Part__3 = v23.Part;
        l__Part__3.TextureID = v23.Texture;
        l__Part__3.Material = v23.Material;
        l__Part__3.Color = v23.Color;
        v23.Light:Destroy();
    end;
end;
return u5;