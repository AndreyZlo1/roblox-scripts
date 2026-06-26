-- Services.EnvironmentService.LensFlareManager.LensFlareClass
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Enum");
game:GetService("CollectionService");
local l__HttpService__1 = game:GetService("HttpService");
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local l__LensFlare__3 = l__ReplicatedStorage__2:WaitForChild("Assets"):WaitForChild("Particles"):WaitForChild("LensFlare");
local v3 = v1("LensFlareConfiguration");
local u4 = v1("GameSettings");
local l__NUMBER_OF_RAYCASTS__4 = v3.NUMBER_OF_RAYCASTS;
local l__RAYCAST_RADIUS__5 = v3.RAYCAST_RADIUS;
local _ = v3.TRANSPARENCY_THRESHOLD;
local u5 = Vector2.new(1920, 1080);
local u6 = {
    LensFlareStrength = 1,
    LensFlareDistance = 100,
    LensFlareColor = Color3.new(1, 1, 1)
};
local u7 = {
    ColorBlend = 0,
    Position = Vector3.new(1, 1, 1),
    PositionMult = 1,
    Rotates = false,
    SizeFade = NumberSequence.new(1),
    SquashFade = NumberSequence.new(0),
    TransparencyFade = NumberSequence.new(0)
};
local l__CurrentCamera__6 = workspace.CurrentCamera;
local u8 = table.create(l__NUMBER_OF_RAYCASTS__4);
local u9 = {
    "Size",
    "Squash",
    "Transparency",
    "LocalTransparencyModifier",
    "Color",
    "Rotation",
    "ZOffset",
    "Lifetime"
};
for v10 = 1, l__NUMBER_OF_RAYCASTS__4 do
    local v11 = 6.283185307179586 * ((v10 - 1) / l__NUMBER_OF_RAYCASTS__4);
    u8[v10] = { math.cos(v11) * l__RAYCAST_RADIUS__5, math.sin(v11) * l__RAYCAST_RADIUS__5 };
end;
local v12 = Instance.new("ParticleEmitter");
local l__Emit__7 = v12.Emit;
local l__Clear__8 = v12.Clear;
local u13 = {};
u13.__index = u13;
local function u19(p14, p15) --[[ Line: 98 ]]
    if p15 == 0 then
        return p14.Keypoints[1].Value;
    end;
    if p15 == 1 then
        return p14.Keypoints[#p14.Keypoints].Value;
    end;
    for v16 = 1, #p14.Keypoints - 1 do
        local v17 = p14.Keypoints[v16];
        local v18 = p14.Keypoints[v16 + 1];
        if v17.Time <= p15 and p15 < v18.Time then
            return v17.Value + (v18.Value - v17.Value) * ((p15 - v17.Time) / (v18.Time - v17.Time));
        end;
    end;
end;
local function u25(p20, p21) --[[ Line: 119 ]]
    local v22 = {};
    for v23, v24 in p20.Keypoints do
        v22[v23] = NumberSequenceKeypoint.new(v24.Time, v24.Value * p21, v24.Envelope);
    end;
    return NumberSequence.new(v22);
end;
function u13.new(p26, p27, u28) --[[ Line: 131 ]]
    -- upvalues: l__LensFlare__3 (copy), u13 (copy), l__HttpService__1 (copy), l__NUMBER_OF_RAYCASTS__4 (copy), u6 (copy), u4 (copy), u25 (copy), u7 (copy), u9 (copy), u2 (copy), l__CurrentCamera__6 (copy)
    local v29 = l__LensFlare__3:FindFirstChild(p27);
    local v30 = `LensFlare: No lens flare folder called {p27} under LensFlare.Assets`;
    assert(v29, v30);
    local v31 = v29:GetChildren();
    local u32 = setmetatable({}, u13);
    u32._id = l__HttpService__1:GenerateGUID(false);
    u32.Enabled = true;
    u32.NumRaysHit = l__NUMBER_OF_RAYCASTS__4;
    u32.Camera = p26;
    u32.Part = u28;
    u32.Attachments = table.create(#v31);
    u32.FlareEmitters = table.create(#v31);
    u32.Alpha = 0;
    u32._forceRecompute = false;
    local v33 = u28:GetAttribute("LensFlareSize");
    local u34 = {};
    local v35 = {};
    local v36 = {};
    local v37 = 1;
    local v38 = {};
    for u39, u40 in u6 do
        u34[u39] = u28:GetAttribute(u39) or u40;
        local v41 = u28:GetAttributeChangedSignal(u39):Connect(function() --[[ Line: 167 ]]
            -- upvalues: u28 (copy), u39 (copy), u40 (copy), u34 (copy), u32 (copy)
            u34[u39] = u28:GetAttribute(u39) or u40;
            u32._forceRecompute = true;
        end);
        table.insert(v35, v41);
    end;
    v36[u28] = u34;
    local v42 = u28:GetAttribute("LensFlareColor") or (u28:IsA("BasePart") and u28.Color or u34.LensFlareColor);
    for _, v43 in v31 do
        if v43:IsA("ParticleEmitter") then
            local v44 = Instance.new("Attachment");
            v44.Name = `LensFlare_{p27}_{v43.Name}`;
            if u4.CinematicLights == 1 then
                v44.Parent = p26;
            end;
            u32.Attachments[v37] = v44;
            v38[v44] = { v44.Position };
            local u45 = Instance.fromExisting(v43);
            if v33 then
                u45.Size = u25(u45.Size, v33);
                if u45:GetAttribute("SizeFade") then
                    u45:SetAttribute("SizeFade", u25(u45:GetAttribute("SizeFade"), v33));
                end;
            end;
            u45.ZOffset = 0;
            u45.Enabled = false;
            u45.Parent = v44;
            u32.FlareEmitters[v37] = u45;
            local u46, v47 = v42:ToHSV();
            local u48 = {};
            for u49, u50 in u7 do
                u48[u49] = u45:GetAttribute(u49) or u50;
                local v52 = u45:GetAttributeChangedSignal(u49):Connect(function() --[[ Line: 216 ]]
                    -- upvalues: u45 (copy), u49 (copy), u50 (copy), u48 (copy), u32 (copy), u46 (copy)
                    local v51 = u45:GetAttribute(u49) or u50;
                    u48[u49] = v51;
                    u32._forceRecompute = true;
                    if u49 == "ColorBlend" then
                        u48._color = ColorSequence.new(Color3.fromHSV(u46, v51, 1));
                    end;
                end);
                table.insert(v35, v52);
            end;
            if u48.ColorBlend and u48.ColorBlend > 0 then
                u48._color = ColorSequence.new(Color3.fromHSV(u46, v47 * u48.ColorBlend, 1));
                if u28:IsA("BasePart") then
                    local v53 = u28:GetPropertyChangedSignal("Color");
                    table.insert(v35, v53:Connect(function() --[[ Line: 238 ]]
                        -- upvalues: u28 (copy), u48 (copy), u32 (copy)
                        local v54, v55 = u28.Color:ToHSV();
                        u48._color = ColorSequence.new(Color3.fromHSV(v54, v55 * u48.ColorBlend, 1));
                        u32._forceRecompute = true;
                    end));
                end;
            end;
            local v56 = {};
            for _, v57 in u9 do
                v56[v57] = u45[v57];
            end;
            v36[u45] = u48;
            v38[u45] = v56;
            v37 = v37 + 1;
        end;
    end;
    u32._attributeCache = v36;
    u32._attributeConns = v35;
    u32._propertyCache = v38;
    local v58 = RaycastParams.new();
    v58.FilterType = u2.RaycastFilterType.Blacklist;
    v58.FilterDescendantsInstances = { l__CurrentCamera__6 };
    v58.CollisionGroup = u2.PhysicsGroup.BulletCast;
    v58.IgnoreWater = false;
    u32.RaycastParams = v58;
    return u32;
end;
function u13.Destroy(p59) --[[ Line: 281 ]]
    for _, v60 in p59._attributeConns do
        v60:Disconnect();
    end;
    for _, v61 in p59.FlareEmitters do
        v61:Destroy();
    end;
    for _, v62 in p59.Attachments do
        v62:Destroy();
    end;
    table.clear(p59);
    setmetatable(p59, nil);
end;
function u13.Compute(p63, _) --[[ Line: 300 ]]
    -- upvalues: u5 (copy), u8 (copy)
    local l__Camera__9 = p63.Camera;
    local l__Magnitude__10 = (l__Camera__9.ViewportSize / u5).Magnitude;
    local l__ScreenPos__11 = p63.ScreenPos;
    local l__Dist__12 = p63.Dist;
    if l__ScreenPos__11 and l__Dist__12 then
        local l__Part__13 = p63.Part;
        local v64 = l__Part__13:IsA("Attachment") and l__Part__13.WorldPosition or l__Part__13.Position;
        local l__RaycastParams__14 = p63.RaycastParams;
        local v65 = 0;
        for _, v66 in u8 do
            local v67 = l__Camera__9:ViewportPointToRay(l__ScreenPos__11.X + v66[1] * l__Magnitude__10, l__ScreenPos__11.Y + v66[2] * l__Magnitude__10, 1);
            local v68 = workspace:Raycast(v67.Origin, v67.Direction * l__Dist__12, l__RaycastParams__14);
            if v68 and (v68.Instance ~= l__Part__13 and (v68.Position - v64).Magnitude > 2) then
                v65 = v65 + 1;
            end;
        end;
        p63.NumRaysHit = v65;
    end;
end;
function u13.Update(p69, p70) --[[ Line: 334 ]]
    -- upvalues: l__NUMBER_OF_RAYCASTS__4 (copy), l__Clear__8 (copy), l__Emit__7 (copy), u19 (copy)
    p69.ScreenPos = nil;
    p69.Dist = nil;
    local l__Camera__15 = p69.Camera;
    local l__Part__16 = p69.Part;
    local v71 = l__Part__16:IsA("Attachment") and l__Part__16.WorldPosition or l__Part__16.Position;
    local v72 = v71 - l__Camera__15.CFrame.Position;
    local v73 = vector.magnitude(v72);
    local l___attributeCache__17 = p69._attributeCache;
    local l___propertyCache__18 = p69._propertyCache;
    local v74 = l___attributeCache__17[l__Part__16];
    local l__LensFlareDistance__19 = v74.LensFlareDistance;
    local l__LensFlareStrength__20 = v74.LensFlareStrength;
    if l__LensFlareStrength__20 and l__LensFlareStrength__20 <= 0 then
    elseif l__LensFlareDistance__19 and (l__LensFlareDistance__19 > 0 and l__LensFlareDistance__19 < v73) then
    else
        local v75 = vector.angle(l__Camera__15.CFrame.LookVector, v72) / math.rad(l__Camera__15.DiagonalFieldOfView) * 2;
        local v76 = math.clamp(v75, 0, 1);
        if l__LensFlareDistance__19 and l__LensFlareDistance__19 > 0 then
            v76 = v76 + v73 / l__LensFlareDistance__19;
        end;
        if v76 >= 1 then
        else
            local v77 = l__Camera__15:WorldToViewportPoint(v71);
            local l__Origin__21 = l__Camera__15:ViewportPointToRay(v77.X, v77.Y, 1).Origin;
            p69.ScreenPos = v77;
            p69.Dist = v73;
            local l__Position__22 = l__Camera__15.CFrame:ToObjectSpace(CFrame.new(l__Origin__21)).Position;
            local v78 = p69.NumRaysHit / l__NUMBER_OF_RAYCASTS__4;
            local l__Attachments__23 = p69.Attachments;
            local l__FlareEmitters__24 = p69.FlareEmitters;
            local v79 = l__LensFlareStrength__20 * (1 - v76) * (1 - v78);
            local l__Alpha__25 = p69.Alpha;
            if v78 < 1 and v76 < 1 then
                if v79 == l__Alpha__25 and not p69._forceRecompute then
                    for _, v80 in l__FlareEmitters__24 do
                        l__Clear__8(v80);
                        local v81 = l___propertyCache__18[v80];
                        local l__Lifetime__26 = v81.Lifetime;
                        local v82 = NumberRange.new(p70 * 3);
                        if l__Lifetime__26 ~= v82 then
                            v80.Lifetime = v82;
                            v81.Lifetime = v82;
                        end;
                        l__Emit__7(v80, 1);
                    end;
                    return;
                end;
                for v83 = 1, #l__FlareEmitters__24 do
                    local v84 = l__Attachments__23[v83];
                    local v85 = l__FlareEmitters__24[v83];
                    l__Clear__8(v85);
                    local v86 = l___attributeCache__17[v85];
                    local v87 = l___propertyCache__18[v85];
                    local _ = v86.ColorBlend;
                    local l___color__27 = v86._color;
                    local l__Position__28 = v86.Position;
                    local l__PositionMult__29 = v86.PositionMult;
                    local l__Rotates__30 = v86.Rotates;
                    local l__SizeFade__31 = v86.SizeFade;
                    local l__SquashFade__32 = v86.SquashFade;
                    local l__TransparencyFade__33 = v86.TransparencyFade;
                    local v88 = l__Position__22.X * l__Position__28.x * l__PositionMult__29;
                    local v89 = l__Position__22.Y * l__Position__28.y * l__PositionMult__29;
                    vector.create(v88, v89, l__Position__22.Z);
                    v84.Position = vector.create(v88, v89, l__Position__22.Z);
                    local v90 = NumberSequence.new(u19(l__SizeFade__31, v76));
                    local v91 = NumberSequence.new(u19(l__SquashFade__32, v76));
                    local l__new__34 = NumberSequence.new;
                    local v92 = u19(l__TransparencyFade__33, v76);
                    local v93 = l__new__34((math.lerp(v92, 1, v78)));
                    local v94 = 1 - l__LensFlareStrength__20;
                    if v90 ~= v87.Size then
                        v85.Size = v90;
                        v87.Size = v90;
                    end;
                    if v91 ~= v87.Squash then
                        v85.Squash = v91;
                        v87.Squash = v91;
                    end;
                    if v93 ~= v87.Transparency then
                        v85.Transparency = v93;
                        v87.Transparency = v93;
                    end;
                    if v94 ~= v87.LocalTransparencyModifier then
                        v85.LocalTransparencyModifier = 1 - l__LensFlareStrength__20;
                        v87.LocalTransparencyModifier = v94;
                    end;
                    if l___color__27 and l___color__27 ~= v87.Color then
                        v85.Color = l___color__27;
                        v87.Color = l___color__27;
                    end;
                    if l__Rotates__30 then
                        local l__new__35 = NumberRange.new;
                        local v95 = math.atan2(l__Position__22.Y, l__Position__22.X);
                        local v96 = l__new__35((math.deg(v95)));
                        if v96 ~= v87.Rotation then
                            v85.Rotation = v96;
                            v87.Rotation = v96;
                        end;
                    end;
                    local v97 = math.min(-v84.Position.Z * 0.8, 0);
                    if v97 ~= v87.ZOffset then
                        v85.ZOffset = v97;
                        v87.ZOffset = v97;
                    end;
                    local l__Lifetime__36 = v87.Lifetime;
                    local v98 = NumberRange.new(p70 * 3);
                    if l__Lifetime__36 ~= v98 then
                        v85.Lifetime = v98;
                        v87.Lifetime = v98;
                    end;
                    l__Emit__7(v85, 1);
                end;
            end;
            p69.Alpha = v79;
        end;
    end;
end;
return u13;