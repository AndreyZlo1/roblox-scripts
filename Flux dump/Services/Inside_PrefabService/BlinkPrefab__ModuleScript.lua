-- Services.PrefabService.BlinkPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

game:GetService("Debris");
local _, _, u1 = shared.import("require", "asset", "Enum");
local _ = workspace.CurrentCamera;
local u2 = {};
u2.__index = u2;
function u2.new(p3) --[[ Line: 9 ]]
    -- upvalues: u2 (copy)
    local v4 = {};
    local v5 = {};
    for _, v6 in p3:GetChildren() do
        v4[#v4 + 1] = v6;
        v6:SetAttribute("Size", 2);
        v6:AddTag("LightActive");
        local v7 = v6:FindFirstChildWhichIsA("Light");
        if v7 then
            v5[#v5 + 1] = v7;
        end;
    end;
    local l__Position__1 = v4[1].Position;
    return setmetatable({
        _origin = l__Position__1,
        _lights = v5,
        _parts = v4,
        _timeOffset = l__Position__1.Magnitude
    }, u2);
end;
function u2.Update(p8, _, p9) --[[ Line: 35 ]]
    -- upvalues: u1 (copy)
    if (p9 - p8._origin).Magnitude > 512 then
    else
        local v10 = (os.clock() + p8._timeOffset) % 2 < 1;
        if v10 == p8._on then
        else
            for _, v11 in p8._parts do
                v11.Material = v10 and u1.Material.Neon or u1.Material.Granite;
            end;
            for _, v12 in p8._lights do
                v12.Enabled = v10;
            end;
            p8._on = v10;
        end;
    end;
end;
function u2.Destroy(_) --[[ Line: 54 ]] end;
return u2;