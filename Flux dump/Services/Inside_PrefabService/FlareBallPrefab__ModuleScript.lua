-- Services.PrefabService.FlareBallPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _, u2 = shared.import("require", "asset", "Enum");
local u3 = v1("SoundService");
local l__TweenService__1 = game:GetService("TweenService");
v1("RoactTween");
local l__CurrentCamera__2 = workspace.CurrentCamera;
local u4 = {};
u4.__index = u4;
function u4.new(p5) --[[ Line: 14 ]]
    -- upvalues: u3 (copy), u4 (copy)
    p5:SetAttribute("LensFlareDistance", 0);
    p5:SetAttribute("LensFlareSize", 0.6);
    p5:SetAttribute("LensFlareStrength", 1);
    p5:SetAttribute("LensFlareColor", Color3.new(1, 0, 0));
    p5:SetAttribute("LensFlareStyle", "SmallWithFlare");
    p5:AddTag("LensFlare");
    u3:CreateSound("World", p5, true, "Foley", "Flare", "Shoot").Destroy(10);
    local v6 = {
        _origin = p5.CFrame,
        _ball = p5,
        _start = tick()
    };
    return setmetatable(v6, u4);
end;
function u4.Update(p7, _) --[[ Line: 34 ]]
    -- upvalues: l__CurrentCamera__2 (copy), l__TweenService__1 (copy), u2 (copy)
    local l___ball__3 = p7._ball;
    local v8 = math.max(2, (l__CurrentCamera__2.CFrame.Position - l___ball__3.Position).Magnitude / 50);
    local v9 = l__TweenService__1;
    local v10 = tick() - p7._start;
    local v11 = v9:GetValue(math.clamp(v10, 0, 4) / 4, u2.EasingStyle.Sine, u2.EasingDirection.Out);
    l___ball__3.Size = Vector3.new(v8, v8, v8);
    l___ball__3.CFrame = p7._origin:Lerp(p7._origin + Vector3.new(0, 2000, 0), v11);
    l___ball__3:SetAttribute("LensFlareStrength", 0.7 + math.random(0, 300) / 1000);
end;
function u4.Destroy(_) --[[ Line: 45 ]] end;
return u4;