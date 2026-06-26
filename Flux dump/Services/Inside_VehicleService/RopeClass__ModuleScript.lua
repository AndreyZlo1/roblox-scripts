-- Services.VehicleService.RopeClass
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1 = shared.import("Enum");
local l__Terrain__1 = workspace.Terrain;
local u2 = {};
u2.__index = u2;
function u2.new(p3, p4, p5) --[[ Line: 8 ]]
    -- upvalues: u2 (copy)
    local v6 = setmetatable({
        _current = 0,
        Bin = {},
        Host = p3,
        _length = p4,
        _segments = p5
    }, u2);
    v6:Spawn();
    return v6;
end;
function u2.Spawn(p7) --[[ Line: 22 ]]
    -- upvalues: l__Terrain__1 (copy), u1 (copy)
    local l___segments__2 = p7._segments;
    local l__Host__3 = p7.Host;
    local v8 = Instance.new("Attachment");
    v8.WorldCFrame = l__Host__3.WorldCFrame;
    v8.Parent = l__Terrain__1;
    local v9 = {};
    for v10 = 1, l___segments__2 do
        local v11 = Instance.new("Part");
        v11.Shape = u1.PartType.Ball;
        v11.Size = Vector3.new(0.5, 0.5, 0.5);
        v11.Transparency = 1;
        v11.CastShadow = false;
        v11.RootPriority = -v10;
        v11.CFrame = l__Host__3.WorldCFrame;
        v11.CustomPhysicalProperties = PhysicalProperties.new(20, 1, 0, 1, 0);
        v11.CollisionGroup = u1.PhysicsGroup.Debris;
        v11.Parent = workspace;
        local v12 = Instance.new("Attachment");
        v12.Parent = v11;
        local v13 = Instance.new("AlignOrientation");
        v13.Mode = u1.OrientationAlignmentMode.OneAttachment;
        v13.RigidityEnabled = true;
        v13.Attachment0 = v12;
        v13.Parent = v11;
        local v14 = v9[v10 - 1];
        local v15 = Instance.new("Beam");
        v15.Color = ColorSequence.new(Color3.fromRGB(59, 59, 59));
        v15.Texture = "rbxassetid://9417538320";
        v15.Attachment0 = v10 == 1 and l__Host__3 and l__Host__3 or v14;
        v15.Attachment1 = v12;
        v15.LightInfluence = 1;
        v15.FaceCamera = true;
        v15.Width0 = 0.3;
        v15.Width1 = 0.3;
        v15.Segments = 1;
        v15.TextureSpeed = 0;
        v15.Transparency = NumberSequence.new(0);
        v15.Parent = v11;
        local v16 = Instance.new("RopeConstraint");
        v16.Length = p7._length;
        v16.Attachment0 = v10 == 1 and v8 and v8 or v14;
        v16.Attachment1 = v12;
        v16.Parent = v11;
        v9[v10] = v12;
        p7.Bin[v10] = v11;
        if v10 == 1 then
            p7._start = v11;
        end;
    end;
    for v17 = 1, l___segments__2 do
        local v18 = p7.Bin[v17];
        local v19 = math.random(-1, 1) * 5;
        local v20 = math.random(-1, 1) * 5;
        v18:ApplyImpulse((Vector3.new(v19, 0, v20)));
    end;
    p7._mimic = v8;
    p7._current = p7._length;
end;
function u2.Despawn(u21) --[[ Line: 86 ]]
    if u21._mimic then
        u21._mimic:Destroy();
        u21._mimic = nil;
        u21._start:Destroy();
        u21._destroy = task.delay(5, function() --[[ Line: 96 ]]
            -- upvalues: u21 (copy)
            u21._destroy = nil;
            u21:Destroy();
        end);
    end;
end;
function u2.Update(p22, _) --[[ Line: 102 ]]
    local l___mimic__4 = p22._mimic;
    if l___mimic__4 then
        l___mimic__4.WorldCFrame = p22.Host.WorldCFrame;
    end;
end;
function u2.Destroy(p23) --[[ Line: 109 ]]
    if p23._destroy then
        task.cancel(p23._destroy);
        p23._destroy = nil;
    end;
    for _, v24 in p23.Bin do
        v24:Destroy();
    end;
    if p23._mimic then
        p23._mimic:Destroy();
        p23._mimic = nil;
    end;
end;
return u2;