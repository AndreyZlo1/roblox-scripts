-- Services.PrefabService.DoorPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3 = shared.import("require", "asset", "Enum");
local u4 = v1("SoundService");
local u5 = v1("Mathf");
local l__Debris__1 = game:GetService("Debris");
local u6 = {};
u6.__index = u6;
function u6._discoverLock(p7, p8) --[[ Line: 14 ]]
    -- upvalues: u4 (copy), l__Debris__1 (copy)
    local v9 = p7._door:GetAttribute("Locked");
    if not v9 and (p7._locked and tick() - p7._kicked > 1.5) then
        l__Debris__1:AddItem(u4:CreateSound("Character", p7._handle, true, "LockPick", "Complete").Sound, 2);
    end;
    p7._locked = v9;
    p7._breach = p7._locked and p8;
end;
function u6.new(u10) --[[ Line: 25 ]]
    -- upvalues: u3 (copy), u6 (copy), u2 (copy), u4 (copy)
    local v11 = Instance.new("Part");
    v11.Anchored = true;
    v11.CanCollide = true;
    v11.CanQuery = true;
    v11.AudioCanCollide = true;
    v11.CanTouch = true;
    v11.Material = u10.Material;
    v11.MaterialVariant = u10.MaterialVariant;
    v11.Size = u10.Size;
    v11.Color = u10.Color;
    v11.CFrame = u10.CFrame;
    u10.Transparency = 1;
    u10.CanCollide = false;
    u10.CanTouch = false;
    u10.CanQuery = false;
    u10.AudioCanCollide = false;
    local u12 = u10.Material == u3.Material.Wood and true or u10.Material == u3.Material.WoodPlanks;
    local v13 = u10.Size.X / 2;
    local v14 = {
        _kicked = 0,
        _lastHandle = 0,
        _lastChange = 0,
        _discoveredLocked = false,
        _door = u10,
        _dynamic = v11,
        _size = v13,
        _target = u10:GetAttribute("Target"),
        _hinge = u10:GetAttribute("Hinge")
    };
    local u15 = setmetatable(v14, u6);
    local v16 = u10:GetAttribute("Model") or "Basic";
    local v17 = v16 == "Deadlock" and "Deadbolt" or v16;
    local v18 = CFrame.new(v13 - 0.5, 0, 0);
    if v17 ~= "None" then
        local v19 = u2:Get("Shared", "Models", "Door", "Handle", v17).Asset:Clone();
        v19.Parent = v11;
        local l__PrimaryPart__2 = v19.PrimaryPart;
        local l__PivotOffset__3 = l__PrimaryPart__2.PivotOffset;
        for _, v20 in v19:GetChildren() do
            v20.CanCollide = false;
            v20.CanTouch = false;
            v20.CanQuery = false;
            v20.AudioCanCollide = false;
            if v20 ~= l__PrimaryPart__2 then
                local v21 = Instance.new("Weld");
                v21.Part0 = v11;
                v21.Part1 = v20;
                v21.C0 = v18 * l__PivotOffset__3:Inverse();
                v21.C1 = l__PrimaryPart__2.CFrame:ToObjectSpace(v20.CFrame):Inverse();
                v21.Parent = v11;
            end;
        end;
        local l__Anchor__4 = l__PrimaryPart__2:WaitForChild("Anchor");
        local v22 = Instance.new("Weld");
        v22.Part0 = v11;
        v22.Part1 = l__PrimaryPart__2;
        v22.C0 = v18 * l__PivotOffset__3:Inverse() * l__Anchor__4.CFrame;
        v22.Parent = v11;
        u15._weld = v22;
        u15._anchor = l__Anchor__4.CFrame;
    end;
    local u23 = Instance.new("Attachment");
    u23.Parent = v11;
    u23.CFrame = v18;
    u15._handle = u23;
    local v24 = Instance.new("Attachment");
    v24.Parent = v11;
    v24.CFrame = CFrame.new(0, 0, 0);
    local v25 = Instance.new("ProximityPrompt");
    v25.ClickablePrompt = false;
    v25.Style = u3.ProximityPromptStyle.Custom;
    v25.Exclusivity = u3.ProximityPromptExclusivity.OneGlobally;
    v25.MaxActivationDistance = 6;
    v25.RequiresLineOfSight = false;
    v25.GamepadKeyCode = u3.KeyCode.World0;
    v25.KeyboardKeyCode = u3.KeyCode.World0;
    v25.Enabled = false;
    local v26 = u10:GetAttribute("Breach");
    local v27 = v25:Clone();
    v27.Name = u10:GetAttribute("Handle");
    v27.ActionText = "Open Door";
    v27:SetAttribute("Timer", 4);
    v27:SetAttribute("Analogue", true);
    v27:SetAttribute("BreachTool", v26);
    v27.Parent = u23;
    u15._handlePrompt = v27;
    local v28 = u10:GetAttribute("Pick");
    if v28 then
        local v29 = v25:Clone();
        v29.Name = v28;
        v29.ActionText = "Pick Lock";
        v29:SetAttribute("BreachTool", v26);
        v29.Parent = u23;
        u15._pickPrompt = v29;
    end;
    if u10:GetAttribute("Kick") then
        local v30 = v25:Clone();
        v30.Name = u10:GetAttribute("Kick");
        v30.ActionText = "Kick Door";
        v30.Parent = v24;
        u15._kickPrompt = v30;
    end;
    u15._angle = u15._target;
    u15._connectionTarget = u10:GetAttributeChangedSignal("Target"):Connect(function() --[[ Line: 151 ]]
        -- upvalues: u15 (copy), u10 (copy), u4 (ref), u23 (copy), u12 (copy)
        local l___target__5 = u15._target;
        u15._target = u10:GetAttribute("Target");
        u15._lastChange = tick();
        local v31 = u15;
        local v32;
        if math.abs(u15._target - l___target__5) < 45 then
            v32 = u15._target ~= 0;
        else
            v32 = false;
        end;
        v31._slowOpen = v32;
        if u15._slowOpen then
        elseif tick() - u15._kicked < 1.5 then
        else
            local u33 = math.abs(u15._target) > 0;
            task.delay(u33 and 0 or 0.2, function() --[[ Line: 164 ]]
                -- upvalues: u4 (ref), u23 (ref), u12 (ref), u33 (copy)
                u4:CreateSound("Character", u23, true, "Doors", u12 and "Wood" or "Metal", u33 and "Open" or "Close").Destroy(2);
            end);
        end;
    end);
    u15._connectionLocked = u10:GetAttributeChangedSignal("Locked"):Connect(function() --[[ Line: 170 ]]
        -- upvalues: u15 (copy)
        u15:_discoverLock(false);
    end);
    u15:_discoverLock(false);
    v11.Parent = workspace;
    return u15;
end;
function u6.Handle(p34) --[[ Line: 180 ]]
    -- upvalues: u4 (copy)
    p34._lastHandle = tick();
    if p34._locked then
        u4:CreateSound("Character", p34._handle, true, "Doors", "Locked").Destroy(2);
    end;
end;
function u6.Kick(u35, p36, p37) --[[ Line: 189 ]]
    -- upvalues: u4 (copy), u2 (copy), u3 (copy)
    if not p37 then
        u4:CreateSound("Character", u35._dynamic, true, "Doors", "Kick", u35._wood and "Wood" or "Metal", p36 and "Success" or "Fail").Destroy(3);
    end;
    u35._kicked = tick() + (p37 and 0 or 0.5);
    task.delay(p37 and 0 or 0.5, function() --[[ Line: 196 ]]
        -- upvalues: u35 (copy), u2 (ref), u3 (ref)
        if not u35._smoke then
            local v38 = u2:Get("Shared", "Particles", "Door", "Smoke").Asset:Clone();
            v38.Parent = u35._dynamic;
            u35._smoke = v38;
            local l__Material__6 = u35._dynamic.Material;
            if l__Material__6 == u3.Material.Wood or l__Material__6 == u3.Material.WoodPlanks then
                local v39 = u2:Get("Shared", "Particles", "Door", "Wood").Asset:Clone();
                v39.Parent = u35._dynamic;
                u35._wood = v39;
            end;
        end;
        u35._smoke:Emit(10);
        if u35._wood then
            u35._wood:Emit(50);
        end;
    end);
end;
function u6.DiscoverLock(p40) --[[ Line: 217 ]]
    p40:_discoverLock(true);
end;
function u6.Destroy(p41) --[[ Line: 221 ]]
    p41._dynamic:Destroy();
    p41._connectionTarget:Disconnect();
    p41._connectionLocked:Disconnect();
end;
function u6.Update(p42, _, p43) --[[ Line: 227 ]]
    -- upvalues: u5 (copy), u3 (copy)
    if (p43 - p42._hinge.Position).Magnitude <= 256 then
        local v44 = tick() - p42._kicked;
        local v45 = 1 - math.clamp(v44, 0, 1);
        local v46 = math.sin(v45 * 3.141592653589793 * 10) * v45 * 2;
        local v47 = tick() - p42._kicked < 1.5;
        local l__Lerp__7 = u5.Lerp;
        local l___angle__8 = p42._angle;
        local l___target__9 = p42._target;
        local v48 = tick() - p42._lastChange;
        local v49 = l__Lerp__7(l___angle__8, l___target__9, (math.clamp(v48 * ((p42._slowOpen or v47) and 6 or 1), 0, 1)));
        local l___dynamic__10 = p42._dynamic;
        l___dynamic__10.CollisionGroup = math.abs(v49 - p42._target) < 0.01 and "Default" or u3.PhysicsGroup.CharacterCast;
        p42._angle = v49;
        local l___breach__11 = p42._breach;
        if l___breach__11 then
            l___breach__11 = p42._target == 0;
        end;
        if p42._kickPrompt then
            p42._kickPrompt.Enabled = l___breach__11;
        end;
        if p42._pickPrompt then
            p42._pickPrompt.Enabled = l___breach__11;
        end;
        p42._handlePrompt.Enabled = not l___breach__11;
        if p42._weld then
            local v50 = tick() - p42._lastHandle;
            local v51 = math.clamp(v50, 0, p42._locked and 0.4 or 0.2) * 5 * 3.141592653589793;
            local v52 = math.sin(v51);
            local v53 = math.abs(v52);
            p42._weld.C1 = p42._anchor * CFrame.Angles(math.rad(v53) * (l___breach__11 and 10 or 45), 0, 0);
        end;
        for _, v54 in p42._door:GetDescendants() do
            if v54:IsA("ProximityPrompt") then
                v54.Enabled = false;
            end;
        end;
        return l___dynamic__10, (p42._hinge * CFrame.Angles(0, math.rad(v49 + v46), 0)):ToWorldSpace(CFrame.new(p42._size, 0, 0));
    end;
end;
return u6;