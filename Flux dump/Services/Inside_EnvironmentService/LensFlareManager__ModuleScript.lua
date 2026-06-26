-- Services.EnvironmentService.LensFlareManager
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1 = shared.import("require");
local l__CollectionService__1 = game:GetService("CollectionService");
game:GetService("Lighting");
local l__Players__2 = game:GetService("Players");
game:GetService("ReplicatedStorage");
game:GetService("RunService");
game:GetService("TweenService");
local u2 = v1("GameSettings");
local u3 = v1("LensFlareClass");
local v4 = v1("LensFlareConfiguration");
local l__CurrentCamera__3 = workspace.CurrentCamera;
local _ = l__Players__2.LocalPlayer;
local _ = v4.SUN_EXPOSURE_ADJUSTMENT;
local _ = v4.SUN_EXPOSURE_TIME;
local _ = v4.SUN_BRIGHTNESS_THRESHOLD;
local _ = v4.SUN_ANGLE_THRESHOLD;
local u5 = {};
u5.__index = u5;
function u5.new() --[[ Line: 39 ]]
    -- upvalues: l__CollectionService__1 (copy), u3 (copy), l__CurrentCamera__3 (copy), u2 (copy), u5 (copy)
    local u6 = {};
    for _, v7 in l__CollectionService__1:GetTagged("LensFlare") do
        if v7:IsDescendantOf(workspace) and (v7:IsA("BasePart") or v7:IsA("Attachment") and not u6[v7]) then
            u6[v7] = u3.new(l__CurrentCamera__3, v7:GetAttribute("LensFlareStyle"), v7);
        end;
    end;
    l__CollectionService__1:GetInstanceAddedSignal("LensFlare"):Connect(function(p8) --[[ Line: 100 ]]
        -- upvalues: u6 (copy), u3 (ref), l__CurrentCamera__3 (ref)
        if p8:IsDescendantOf(workspace) then
            if p8:IsA("BasePart") or p8:IsA("Attachment") and not u6[p8] then
                u6[p8] = u3.new(l__CurrentCamera__3, p8:GetAttribute("LensFlareStyle"), p8);
            end;
        end;
    end);
    l__CollectionService__1:GetInstanceRemovedSignal("LensFlare"):Connect(function(p9) --[[ Line: 111 ]]
        -- upvalues: u6 (copy)
        if u6[p9] then
            u6[p9]:Destroy();
            u6[p9] = nil;
        end;
    end);
    return setmetatable({
        _parts = u6,
        _flaresEnabled = u2.CinematicLights == 1
    }, u5);
end;
function u5.Update(p10, p11) --[[ Line: 124 ]]
    -- upvalues: u2 (copy), l__CurrentCamera__3 (copy)
    local v12 = u2.CinematicLights == 1;
    if v12 ~= p10._flaresEnabled then
        for _, v13 in p10._parts do
            for _, v14 in v13.Attachments do
                v14.Parent = v12 and l__CurrentCamera__3 or nil;
            end;
        end;
        p10._flaresEnabled = v12;
    end;
    if u2.CinematicLights == 1 then
        for _, v15 in p10._parts do
            if v15.Enabled then
                v15:Update(p11);
            end;
        end;
    end;
end;
function u5.Compute(p16, p17) --[[ Line: 147 ]]
    -- upvalues: u2 (copy)
    if u2.CinematicLights == 1 then
        for _, v18 in p16._parts do
            if v18.Enabled then
                v18:Compute(p17);
            end;
        end;
    end;
end;
return u5.new();