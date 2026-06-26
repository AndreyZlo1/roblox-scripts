-- Services.PrefabService.FlarePrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _, _ = shared.import("require", "asset", "Enum");
local u2 = v1("EnvironmentService");
local u3 = v1("EffectsService");
local u4 = {};
u4.__index = u4;
function u4.new(p5) --[[ Line: 9 ]]
    -- upvalues: u3 (copy), u2 (copy), u4 (copy)
    local l__Tip__1 = p5:WaitForChild("Body"):WaitForChild("Tip");
    local l__Light__2 = l__Tip__1.Light;
    local l__Fast__3 = l__Tip__1.Fast;
    local l__Core__4 = l__Tip__1.Core;
    local l__Fire__5 = l__Tip__1.Fire;
    local l__Flare__6 = l__Tip__1.Flare;
    local l__Sparks__7 = l__Tip__1.Sparks;
    l__Light__2.Enabled = true;
    l__Light__2.Brightness = 1;
    l__Flare__6.Enabled = true;
    local v12 = {
        _light = l__Light__2,
        _fast = l__Fast__3,
        _flare = l__Flare__6,
        _fire = l__Fire__5,
        _core = l__Core__4,
        _sparks = l__Sparks__7,
        _tip = l__Tip__1,
        _uid = u3:RegisterEffect(l__Tip__1, function(_, p6, p7, p8) --[[ Line: 22 ]]
            -- upvalues: l__Fast__3 (copy), l__Fire__5 (copy), l__Sparks__7 (copy), l__Core__4 (copy), l__Light__2 (copy), l__Flare__6 (copy), u2 (ref), l__Tip__1 (copy)
            local v9 = p7 == 1;
            local v10 = math.noise(tick() % 2, 0, 0);
            local v11 = math.abs(v10) + 0.5;
            l__Fast__3.Enabled = v9;
            l__Fire__5.Enabled = v9;
            l__Sparks__7.Enabled = v9;
            l__Core__4.Enabled = p7 <= 2;
            l__Light__2.Range = v11 * 15;
            l__Flare__6.Acceleration = Vector3.new(p8.X, 10, p8.Z);
            if p6 < 256 then
                u2.Flares[l__Tip__1] = {
                    Light = l__Light__2,
                    Color = Color3.new(1, 0, 0),
                    Intensity = v11 * 5
                };
            else
                u2.Flares[l__Tip__1] = nil;
            end;
        end)
    };
    return setmetatable(v12, u4);
end;
function u4.Destroy(u13) --[[ Line: 60 ]]
    -- upvalues: u3 (copy), u2 (copy)
    u3:UnregisterEffect(u13._uid, function() --[[ Line: 61 ]]
        -- upvalues: u13 (copy), u2 (ref)
        u13._light.Enabled = false;
        u13._fast.Enabled = false;
        u13._flare.Enabled = false;
        u13._fire.Enabled = false;
        u13._core.Enabled = false;
        u13._sparks.Enabled = false;
        u2.Flares[u13._tip] = nil;
    end);
end;
return u4;