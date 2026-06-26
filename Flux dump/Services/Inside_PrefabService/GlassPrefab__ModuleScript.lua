-- Services.PrefabService.GlassPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local l__Debris__1 = game:GetService("Debris");
local v1, _, u2 = shared.import("require", "asset", "Enum");
local u3 = v1("SoundService");
local _ = workspace.CurrentCamera;
local u4 = {};
u4.__index = u4;
local function u30(p5, p6, p7, p8, p9) --[[ Line: 13 ]]
    local v10 = p6 - p5;
    local v11 = p7 - p5;
    local v12 = p7 - p6;
    local v13 = v10:Dot(v10);
    local v14 = v11:Dot(v11);
    local v15 = v12:Dot(v12);
    if v14 < v13 and v15 < v13 then
        local v16 = p7;
        p7 = p5;
        p5 = p6;
        p6 = v16;
    elseif v15 < v14 then
        if v13 >= v14 then
            local v17 = p6;
            p6 = p5;
            p5 = v17;
        end;
    else
        local v18 = p6;
        p6 = p5;
        p5 = v18;
    end;
    local v19 = p5 - p6;
    local v20 = p7 - p6;
    local v21 = p7 - p5;
    local l__Unit__2 = v20:Cross(v19).Unit;
    local l__Unit__3 = v21:Cross(l__Unit__2).Unit;
    local l__Unit__4 = v21.Unit;
    local v22 = v19:Dot(l__Unit__3);
    local v23 = math.abs(v22);
    local v24 = p9:Clone();
    local v25 = v19:Dot(l__Unit__4);
    local v26 = math.abs(v25);
    v24.Size = Vector3.new(0, v23, v26);
    v24.CFrame = CFrame.fromMatrix((p6 + p5) / 2, l__Unit__2, l__Unit__3, l__Unit__4);
    v24.Parent = p8;
    local v27 = p9:Clone();
    local v28 = v20:Dot(l__Unit__4);
    local v29 = math.abs(v28);
    v27.Size = Vector3.new(0, v23, v29);
    v27.CFrame = CFrame.fromMatrix((p6 + p7) / 2, -l__Unit__2, l__Unit__3, -l__Unit__4);
    v27.Parent = p8;
    return v24, v27;
end;
function u4.new(p31) --[[ Line: 44 ]]
    -- upvalues: u2 (copy), u4 (copy)
    local v32 = Instance.new("WedgePart");
    v32.Anchored = true;
    v32.TopSurface = u2.SurfaceType.Smooth;
    v32.BottomSurface = u2.SurfaceType.Smooth;
    v32.CollisionGroup = u2.PhysicsGroup.Debris;
    v32.Material = u2.Material.Glass;
    v32.Transparency = p31.Transparency;
    v32.Color = p31.Color;
    return setmetatable({
        _shattered = false,
        _transparency = p31.Transparency,
        _glass = p31,
        _wedge = v32
    }, u4);
end;
function u4.Shatter(u33, p34) --[[ Line: 64 ]]
    -- upvalues: u3 (copy), u30 (copy), l__Debris__1 (copy), u2 (copy)
    if u33._shattered then
    else
        u33._shattered = true;
        local l___glass__5 = u33._glass;
        local l__Size__6 = l___glass__5.Size;
        local l__CFrame__7 = l___glass__5.CFrame;
        u3:CreateSound("Bullet_Impacts", l___glass__5, true, "BulletImpacts", "GlassShatter").Destroy(10);
        local v35;
        if l__Size__6.Z > l__Size__6.X then
            v35 = {
                l__CFrame__7 * CFrame.new(0, l__Size__6.Y * 0.5, l__Size__6.Z * 0.5),
                l__CFrame__7 * CFrame.new(0, l__Size__6.Y * 0.5, 0),
                l__CFrame__7 * CFrame.new(0, l__Size__6.Y * 0.5, -l__Size__6.Z * 0.5),
                l__CFrame__7 * CFrame.new(0, 0, -l__Size__6.Z * 0.5),
                l__CFrame__7 * CFrame.new(0, -l__Size__6.Y * 0.5, -l__Size__6.Z * 0.5),
                l__CFrame__7 * CFrame.new(0, -l__Size__6.Y * 0.5, 0),
                l__CFrame__7 * CFrame.new(0, -l__Size__6.Y * 0.5, l__Size__6.Z * 0.5),
                l__CFrame__7 * CFrame.new(0, 0, l__Size__6.Z * 0.5)
            };
        else
            v35 = {
                l__CFrame__7 * CFrame.new(l__Size__6.X * 0.5, l__Size__6.Y * 0.5, 0),
                l__CFrame__7 * CFrame.new(0, l__Size__6.Y * 0.5, 0),
                l__CFrame__7 * CFrame.new(-l__Size__6.X * 0.5, l__Size__6.Y * 0.5, 0),
                l__CFrame__7 * CFrame.new(-l__Size__6.X * 0.5, 0, 0),
                l__CFrame__7 * CFrame.new(-l__Size__6.X * 0.5, -l__Size__6.Y * 0.5, 0),
                l__CFrame__7 * CFrame.new(0, -l__Size__6.Y * 0.5, 0),
                l__CFrame__7 * CFrame.new(l__Size__6.X * 0.5, -l__Size__6.Y * 0.5, 0),
                l__CFrame__7 * CFrame.new(l__Size__6.X * 0.5, 0, 0)
            };
        end;
        for v36, v37 in v35 do
            local v38 = v35[v36 + 1];
            if v38 == nil then
                v38 = v35[1];
            end;
            local v39, v40 = u30(v37.p, v38.p, p34, workspace, u33._wedge);
            v39.Anchored = false;
            v40.Anchored = false;
            v39:ApplyImpulse(l___glass__5.CFrame:PointToObjectSpace(p34) * v39:GetMass() * 50);
            v40:ApplyImpulse(l___glass__5.CFrame:PointToObjectSpace(p34) * v40:GetMass() * 50);
            l__Debris__1:AddItem(v39, 2);
            l__Debris__1:AddItem(v40, 2);
        end;
        l___glass__5.CollisionGroup = u2.PhysicsGroup.Debris;
        l___glass__5.Transparency = 1;
        local v41 = {};
        for _, v42 in l___glass__5:GetChildren() do
            if not (v42:IsA("AudioEmitter") or (v42:IsA("AudioPlayer") or v42:IsA("Attachment"))) then
                v41[#v41 + 1] = v42;
                v42.Parent = nil;
            end;
        end;
        u33._children = v41;
        u33._regen = task.delay(300, function() --[[ Line: 132 ]]
            -- upvalues: u33 (copy)
            u33._regen = nil;
            u33:Regen();
        end);
    end;
end;
function u4.Regen(p43) --[[ Line: 138 ]]
    -- upvalues: u2 (copy)
    if p43._shattered then
        local l___glass__8 = p43._glass;
        l___glass__8.CollisionGroup = u2.PhysicsGroup.Glass;
        l___glass__8.Transparency = p43._transparency;
        for _, u44 in p43._children do
            pcall(function() --[[ Line: 148 ]]
                -- upvalues: u44 (copy), l___glass__8 (copy)
                u44.Parent = l___glass__8;
            end);
        end;
        p43._children = nil;
        if p43._regen then
            task.cancel(p43._regen);
            p43._regen = nil;
        end;
        p43._shattered = false;
    end;
end;
function u4.Update(_, _) --[[ Line: 161 ]] end;
function u4.Destroy(p45) --[[ Line: 165 ]]
    p45._wedge:Destroy();
    if p45._regen then
        task.cancel(p45._regen);
    end;
end;
return u4;