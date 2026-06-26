-- Services.ReplicatorService.AttachmentReplicators.LaserAttachmentReplicator
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1, v2, _ = shared.import("Enum", "require", "frc");
local u3 = v2("SoundService");
local u4 = v2("ViewmodelService");
local _ = workspace.CurrentCamera;
local l__PlayerGui__1 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");
local u5 = {};
u5.__index = u5;
function u5.new(p6, p7, p8, p9, p10) --[[ Line: 16 ]]
    -- upvalues: u5 (copy), u1 (copy), l__PlayerGui__1 (copy)
    local v11 = Instance.new("Attachment");
    local v12 = Instance.new("Attachment");
    v12.Parent = v11;
    local v13 = Instance.new("Attachment");
    v13.Parent = v11;
    local v14 = setmetatable({
        _state = 0,
        _config = p7,
        _hitAttachment = v11,
        _leftAttachment = v12,
        _rightAttachment = v13
    }, u5);
    local v15 = RaycastParams.new();
    v15.CollisionGroup = u1.PhysicsGroup.BulletCast;
    v15.FilterType = u1.RaycastFilterType.Exclude;
    local v16 = {};
    if p6 then
        p6 = p6.Character;
    end;
    v16[1], v16[2] = p6, p9.ParentModel;
    v15.FilterDescendantsInstances = v16;
    local v17 = Instance.new("Beam");
    v17.FaceCamera = true;
    v17.Segments = 1;
    v17.Brightness = 2;
    v17.Texture = "rbxassetid://12655626597";
    v17.TextureSpeed = 18;
    v17.Parent = v11;
    v17.Attachment1 = v11;
    v14._laser = v17;
    local v18 = Instance.new("ImageHandleAdornment");
    v18.AlwaysOnTop = true;
    v18.Image = "rbxassetid://123553282029805";
    v18.Parent = l__PlayerGui__1;
    v14._laserDot = v18;
    local v19 = Instance.new("Trail");
    v19.MaxLength = 0.5;
    v19.MinLength = 0;
    v19.Lifetime = 0.04;
    v19.Brightness = 1;
    v19.Transparency = NumberSequence.new(0.95, 1);
    v19.WidthScale = NumberSequence.new(1, 0);
    v19.Attachment1 = v11;
    v19.Parent = v11;
    v14._blur = v19;
    local v20 = Instance.new("Trail");
    v20.MaxLength = 0.5;
    v20.MinLength = 0;
    v20.Lifetime = 0.1;
    v20.Brightness = 1;
    v20.Transparency = NumberSequence.new(0, 1);
    v20.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.5, 0.6),
        NumberSequenceKeypoint.new(0.8, 0.5),
        NumberSequenceKeypoint.new(1, 0)
    });
    v20.Attachment0 = v12;
    v20.Attachment1 = v13;
    v20.Parent = v11;
    v14._trail = v20;
    local v21 = Instance.new("PointLight");
    v21.Shadows = true;
    v21.Parent = v11;
    v14._laserLight = v21;
    if p8 or not p9 then
        p9 = p9:GetChild(unpack(p8));
    end;
    v14._model = p9.ParentModel.PrimaryPart;
    if p10 then
        local v22;
        if p8 or not p10 then
            v22 = p10:GetChild(unpack(p8));
        else
            v22 = p10;
        end;
        v14._fpModel = v22.ParentModel.PrimaryPart;
        v15:AddToFilter(p10.ParentModel);
    end;
    v14._params = v15;
    return v14;
end;
function u5.SetState(p23, p24) --[[ Line: 99 ]]
    -- upvalues: u3 (copy)
    local v25 = p23._config[p24] or p23._config[p23._state];
    local l___activeModel__2 = p23._activeModel;
    if v25 and l___activeModel__2 then
        u3:CreateSound("Weapon_Interaction", l___activeModel__2, true, "Foley", "Weapon", "Button", v25.Button or "Soft", p24 == 0 and "Off" or "On").Destroy(2);
    end;
    p23._state = p24;
end;
function u5.GetVPFModels(p26) --[[ Line: 110 ]]
    -- upvalues: u1 (copy)
    local l___laser__3 = p26._laser;
    local _ = p26._config[p26._state];
    local v27 = l___laser__3.Width0 / 35;
    if not (l___laser__3.Attachment0 and l___laser__3.Attachment1) then
        return {};
    end;
    local l__Position__4 = l___laser__3.Attachment0.WorldCFrame.Position;
    local l__Position__5 = l___laser__3.Attachment1.WorldCFrame.Position;
    local l__Value__6 = l___laser__3.Color.Keypoints[1].Value;
    local l__Value__7 = l___laser__3.Transparency.Keypoints[1].Value;
    local v28 = Instance.new("Part");
    v28.Color = l__Value__6;
    v28.Material = u1.Material.Neon;
    v28.CFrame = CFrame.new((l__Position__4 + l__Position__5) / 2, l__Position__4) * CFrame.Angles(0, 1.5707963267948966, 0);
    v28.Shape = u1.PartType.Cylinder;
    v28.Size = Vector3.new((l__Position__4 - l__Position__5).Magnitude, v27, v27);
    v28.Transparency = l__Value__7;
    v28.Anchored = true;
    return { v28 };
end;
function u5.Update(p29, _, p30, p31) --[[ Line: 136 ]]
    -- upvalues: u4 (copy)
    local l___laser__8 = p29._laser;
    local l___laserLight__9 = p29._laserLight;
    local l___laserDot__10 = p29._laserDot;
    local v32 = p29._config[p29._state];
    local v33 = p30 and p29._fpModel or p29._model;
    if v33.Parent == nil then
    else
        p29._activeModel = v33;
        local l___blur__11 = p29._blur;
        local l___trail__12 = p29._trail;
        local l__Viewmodel__13 = u4.Viewmodel;
        if l__Viewmodel__13 then
            l__Viewmodel__13 = u4.Viewmodel.NVG;
        end;
        if p29._state == 0 or not p31 and (v32.IsIR and not l__Viewmodel__13) then
            l___laser__8.Enabled = false;
            l___blur__11.Enabled = false;
            l___trail__12.Enabled = false;
            l___laserLight__9.Enabled = false;
            l___laserDot__10.Visible = false;
        else
            local v34 = v33[v32.Cast or "cast"];
            local l__WorldCFrame__14 = v34.WorldCFrame;
            local v35 = nil;
            local l__Range__15 = v32.Range;
            local v36 = workspace:Raycast(l__WorldCFrame__14.Position, l__WorldCFrame__14.LookVector * l__Range__15, p29._params);
            if v36 then
                local l__Position__16 = v36.Position;
                l__Range__15 = (l__WorldCFrame__14.Position - l__Position__16).Magnitude;
                local v37 = CFrame.new(l__Position__16, l__Position__16 + v36.Normal);
                local v38 = CFrame.lookAt(l__Position__16, p29._position or l__Position__16, v36.Normal);
                v35 = v38 + v38.UpVector * 0.02;
                local l__Instance__17 = v36.Instance;
                l___laserDot__10.CFrame = l__Instance__17.CFrame:ToObjectSpace(v37 + v37.LookVector * 0.05);
                l___laserDot__10.Adornee = l__Instance__17;
                l___laserDot__10.Visible = true;
                l___laserLight__9.Enabled = true;
                p29._position = l__Position__16;
            else
                l___trail__12.Enabled = false;
                l___laserDot__10.Visible = false;
                l___laserLight__9.Enabled = false;
                p29._position = nil;
            end;
            l___laser__8.Width0 = v32.BeamSize;
            l___laser__8.Width1 = v32.BeamSize;
            l___laser__8.Color = ColorSequence.new(v32.Color);
            l___laser__8.Transparency = NumberSequence.new(v32.BeamTransparency);
            l___laser__8.LightEmission = v32.LightEmission or 1;
            l___laser__8.LightInfluence = v32.LightInfluence or 0;
            l___laserDot__10.Size = Vector2.new(v32.DotSize, v32.DotSize);
            l___laserDot__10.Transparency = v32.DotTransparency;
            l___laserDot__10.Color3 = v32.Color;
            l___laserLight__9.Color = v32.Color;
            l___laserLight__9.Range = v32.SpillSize;
            l___laserLight__9.Brightness = v32.SpillBrightness;
            l___trail__12.Color = ColorSequence.new(v32.Color);
            l___trail__12.LightEmission = v32.LightEmission or 1;
            l___blur__11.Color = ColorSequence.new(v32.Color);
            l___blur__11.LightEmission = v32.LightEmission or 1;
            l___blur__11.Attachment0 = v34;
            l___blur__11.Enabled = true;
            local v39 = l__WorldCFrame__14.Position + l__WorldCFrame__14.LookVector * l__Range__15;
            l___laser__8.Attachment0 = v34;
            l___laser__8.TextureLength = (l__WorldCFrame__14.Position - v39).Magnitude / 500;
            l___laser__8.Enabled = true;
            p29._leftAttachment.CFrame = CFrame.new(v32.DotSize / 2, 0, 0);
            p29._rightAttachment.CFrame = CFrame.new(-v32.DotSize / 2, 0, 0);
            local l___hitAttachment__18 = p29._hitAttachment;
            l___hitAttachment__18.Parent = v34.Parent;
            local v40;
            if p31 or not v35 then
                v40 = CFrame.new(v39);
            else
                v40 = v35;
            end;
            l___hitAttachment__18.WorldCFrame = v40;
            l___trail__12.Enabled = v35 and not l__Viewmodel__13 and true or false;
        end;
    end;
end;
function u5.Destroy(p41) --[[ Line: 225 ]]
    p41._laserDot:Destroy();
    p41._hitAttachment:Destroy();
    p41._leftAttachment = nil;
    p41._rightAttachment = nil;
    p41._trail = nil;
end;
return u5;