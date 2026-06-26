-- Services.ReplicatorService.InventoryReplicators.BreachInventoryReplicator
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

game:GetService("Lighting");
local v1, u2, u3, _ = shared.import("require", "asset", "Enum", "frc");
local u4 = v1("SoundService");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u5 = {};
u5.__index = u5;
function u5.new(p6, p7) --[[ Line: 16 ]]
    -- upvalues: u5 (copy)
    return setmetatable({
        _build = p7.Layout.Build,
        _buildIgnitor = p7.Layout.Ignitor,
        _item = p7,
        _actor = p6
    }, u5);
end;
function u5.Use(p8) --[[ Line: 28 ]]
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local l__PrimaryPart__2 = p8._ignitorModel.PrimaryPart;
    local l__ViewModel__3 = p8._actor.ViewModel;
    if l__ViewModel__3 then
        local v9 = l__ViewModel__3:LoadAnimation(u2:Get("Animation", "GearAnimations", p8._buildIgnitor, "FP", "Use").ID);
        v9.Priority = u3.AnimationPriority.Action3;
        v9:Play(0);
        if l__ViewModel__3.Active then
            l__PrimaryPart__2 = nil;
        end;
    end;
    local v10 = u4:CreateSound("Weapon_Interaction", l__PrimaryPart__2, false, "GearSounds", p8._buildIgnitor, "Use");
    v10.Play();
    v10.Destroy(5);
    local v11 = p8._actor:LoadAnimation(u2:Get("Animation", "GearAnimations", p8._buildIgnitor, "TP", "Use").ID);
    v11.Priority = u3.AnimationPriority.Action3;
    v11:Play(0);
end;
function u5.Place(u12, p13) --[[ Line: 50 ]]
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    u12._placed = true;
    local v14 = u12._actor:LoadAnimation(u2:Get("Animation", "GearAnimations", u12._build, "TP", "Place").ID);
    v14.Priority = u3.AnimationPriority.Action2;
    local u15 = u2:Get("Shared", "Models", "Gear", u12._build).Asset:Clone();
    local l__PrimaryPart__4 = u15.PrimaryPart;
    for _, v16 in u15:GetChildren() do
        v16.Transparency = 1;
        v16.Anchored = false;
        v16.CanCollide = false;
        v16.CanTouch = false;
        v16.CanQuery = false;
    end;
    local v17 = RaycastParams.new();
    v17.CollisionGroup = u3.PhysicsGroup.BotCast;
    v17.IgnoreWater = true;
    local v18 = workspace:Raycast(p13.Position, p13.LookVector * -1, v17);
    if v18 and v18.Instance then
        local v19 = Instance.new("Weld");
        v19.Part0 = v18.Instance;
        v19.Part1 = l__PrimaryPart__4;
        v19.C0 = p13:ToObjectSpace(v18.Instance.CFrame):Inverse();
        v19.Parent = l__PrimaryPart__4;
    else
        l__PrimaryPart__4.Anchored = true;
        l__PrimaryPart__4.CFrame = p13;
    end;
    u15.Parent = workspace;
    u12._placedModel = u15;
    local function u21() --[[ Line: 84 ]]
        -- upvalues: u12 (copy), u15 (copy)
        if u12._breachMotor then
            u12._breachMotor:Destroy();
            u12._breachMotor = nil;
        end;
        if u12._breachModel then
            u12._breachModel:Destroy();
            u12._breachModel = nil;
        end;
        for _, v20 in u15:GetChildren() do
            v20.Transparency = 0;
        end;
        local l__ViewModel__5 = u12._actor.ViewModel;
        if l__ViewModel__5 then
            l__ViewModel__5.SprintID = nil;
            l__ViewModel__5:SetModel();
        end;
        if u12._idle then
            u12._idle:Stop(0);
            u12._idle = nil;
        end;
        if u12._equip then
            u12._equip:Stop(0);
            u12._equip = nil;
        end;
    end;
    local u22 = nil;
    u22 = v14:GetMarkerReachedSignal("Place"):Connect(function(_) --[[ Line: 113 ]]
        -- upvalues: u22 (ref), u21 (copy)
        u22:Disconnect();
        u22 = nil;
        u21();
    end);
    local l__PrimaryPart__6 = u12._breachModel.PrimaryPart;
    local l__ViewModel__7 = u12._actor.ViewModel;
    if l__ViewModel__7 and l__ViewModel__7.Active then
        l__PrimaryPart__6 = nil;
    end;
    local v23 = u4:CreateSound("Weapon_Interaction", l__PrimaryPart__6, false, "GearSounds", u12._build, "Use");
    v23.Play();
    v23.Destroy(5);
    v14:Play(0);
    task.delay(2.1, function() --[[ Line: 131 ]]
        -- upvalues: u22 (ref), u21 (copy), u12 (copy)
        if u22 then
            u22:Disconnect();
            u22 = nil;
            u21();
        end;
        u12._ignitor = true;
    end);
end;
function u5.Equip(p24) --[[ Line: 142 ]]
    -- upvalues: u2 (copy), u4 (copy), u3 (copy)
    p24._equipped = true;
    local l___actor__8 = p24._actor;
    if not p24._placed then
        local v25 = u2:Get("Shared", "Models", "Gear", p24._build).Asset:Clone();
        local l__PrimaryPart__9 = v25.PrimaryPart;
        for _, v26 in v25:GetChildren() do
            v26.Anchored = false;
            v26.CanCollide = false;
            v26.CanTouch = false;
            v26.CanQuery = false;
        end;
        local v27 = Instance.new("Motor6D");
        v27.Part0 = l___actor__8.Parts.RightHand;
        v27.Part1 = l__PrimaryPart__9;
        v27.C1 = l__PrimaryPart__9.Anchor.CFrame;
        v27.Parent = l__PrimaryPart__9;
        v25.Parent = l___actor__8.Character;
        p24._breachMotor = v27;
        p24._breachModel = v25;
        local l__ViewModel__10 = p24._actor.ViewModel;
        if l__ViewModel__10 then
            local l__ID__11 = u2:Get("Animation", "GearAnimations", p24._build, "FP", "Sprint").ID;
            l__ViewModel__10:SetModel(v25, u2:Get("Animation", "GearAnimations", p24._build, "FP", "Idle").ID, u2:Get("Animation", "GearAnimations", p24._build, "FP", "Equip").ID);
            l__ViewModel__10.SprintID = l__ID__11;
            if l__ViewModel__10.Active then
                l__PrimaryPart__9 = nil;
            end;
        end;
        local v28 = u4:CreateSound("Weapon_Interaction", l__PrimaryPart__9, false, "GearSounds", p24._build, "Equip");
        v28.Play();
        v28.Destroy(5);
        p24._equip = p24._actor:LoadAnimation(u2:Get("Animation", "GearAnimations", p24._build, "TP", "Equip").ID);
        p24._equip.Priority = u3.AnimationPriority.Action;
        p24._equip:Play(0);
        p24._idle = p24._actor:LoadAnimation(u2:Get("Animation", "GearAnimations", p24._build, "TP", "Idle").ID);
        p24._idle.Priority = u3.AnimationPriority.Movement;
        p24._idle.Looped = true;
        p24._idle:Play(0);
    end;
end;
function u5.Unequip(p29) --[[ Line: 195 ]]
    p29._equipped = false;
    local l__ViewModel__12 = p29._actor.ViewModel;
    if l__ViewModel__12 then
        l__ViewModel__12.SprintID = nil;
        l__ViewModel__12:SetModel();
    end;
    p29._actor.BreachChargeInDistance = nil;
    if p29._idle then
        p29._idle:Stop(0);
        p29._idle = nil;
    end;
    if p29._equip then
        p29._equip:Stop(0);
        p29._equip = nil;
    end;
    p29._fpModel = nil;
    if p29._wire then
        p29._wire:Destroy();
        p29._wire = nil;
    end;
    if p29._wireAttachment then
        p29._wireAttachment:Destroy();
        p29._wireAttachment = nil;
    end;
    if p29._ignitorModel then
        p29._ignitorModel:Destroy();
        p29._ignitorModel = nil;
    end;
    if p29._breachMotor then
        p29._breachMotor:Destroy();
        p29._breachMotor = nil;
    end;
    if p29._breachModel then
        p29._breachModel:Destroy();
        p29._breachModel = nil;
    end;
end;
function u5.Update(p30, _, p31, _) --[[ Line: 237 ]]
    -- upvalues: l__CurrentCamera__1 (copy), u3 (copy), u2 (copy), u4 (copy)
    if p30._equipped and p31 <= 1 then
        if p30._ignitor then
            local l___actor__13 = p30._actor;
            local l__PrimaryPart__14 = p30._placedModel.PrimaryPart;
            if (l__PrimaryPart__14 and ((l___actor__13.Position - l__PrimaryPart__14.Position).Magnitude or 21) or 21) > 20 then
                l___actor__13.BreachChargeInDistance = nil;
                if p30._ignitorModel then
                    local l__ViewModel__15 = l___actor__13.ViewModel;
                    if l__ViewModel__15 then
                        l__ViewModel__15.SprintID = nil;
                        l__ViewModel__15:SetModel();
                    end;
                    if p30._idle then
                        p30._idle:Stop(0);
                        p30._idle = nil;
                    end;
                    if p30._equip then
                        p30._equip:Stop(0);
                        p30._equip = nil;
                    end;
                    if p30._wire then
                        p30._wire:Destroy();
                        p30._wire = nil;
                    end;
                    p30._ignitorModel:Destroy();
                    p30._ignitorModel = nil;
                end;
            else
                l___actor__13.BreachChargeInDistance = true;
                local v32 = tick();
                if p30._wire and p30._wireLast then
                    local v33 = math.clamp((v32 - 0.5 - p30._wireLast) / 0.3, 0, 1);
                    if v33 >= 1 then
                        p30._wireLast = nil;
                    end;
                    for _, v34 in p30._wire:GetChildren() do
                        v34.Transparency = 1 - v33;
                    end;
                end;
                local l__ViewModel__16 = p30._actor.ViewModel;
                if p30._ignitorModel then
                    local l__Position__17 = l__PrimaryPart__14.Position;
                    if p30._placedModel and (l__CurrentCamera__1.CFrame.Position - l__Position__17).Magnitude < 150 then
                        local l___wireAttachment__18 = p30._wireAttachment;
                        if not l___wireAttachment__18 then
                            l___wireAttachment__18 = Instance.new("Attachment");
                            l___wireAttachment__18.Parent = workspace.Terrain;
                            p30._wireAttachment = l___wireAttachment__18;
                        end;
                        local l__WorldCFrame__19 = p30._ignitorModel.PrimaryPart.Wire.WorldCFrame;
                        if l__ViewModel__16 and (l__ViewModel__16.Active and p30._fpModel) then
                            l__WorldCFrame__19 = p30._fpModel.PrimaryPart.Wire.WorldCFrame;
                        end;
                        l___wireAttachment__18.CFrame = l__WorldCFrame__19;
                        if not p30._wire then
                            local v35 = Instance.new("Model");
                            v35.Parent = workspace;
                            local l__Position__20 = l___actor__13.Position;
                            local v36 = (l__Position__17 - l__Position__20).Magnitude < 4;
                            for v37 = 1, 15 do
                                local v38 = Instance.new("Part");
                                v38.Shape = u3.PartType.Cylinder;
                                v38.Color = Color3.new(0.1, 0.1, 0.1);
                                v38.Material = u3.Material.Fabric;
                                v38.Size = Vector3.new(1.5, 0.05, 0.05);
                                v38.CollisionGroup = u3.PhysicsGroup.Debris;
                                v38.CastShadow = false;
                                v38.Transparency = 1;
                                v38.Anchored = false;
                                v38.CFrame = v36 and CFrame.new(l__Position__20) or CFrame.new(l__Position__20:Lerp(l__Position__17, v37 / 15 * 0.9));
                                v38.Parent = v35;
                                local v39 = Instance.new("Attachment");
                                v39.CFrame = CFrame.new(0.75, 0, 0);
                                v39.Parent = v38;
                                local v40 = Instance.new("Attachment");
                                v40.CFrame = CFrame.new(-0.75, 0, 0);
                                v40.Parent = v38;
                                if l___wireAttachment__18 then
                                    local v41 = Instance.new("BallSocketConstraint");
                                    v41.Attachment0 = l___wireAttachment__18;
                                    v41.Attachment1 = v40;
                                    v41.Parent = v38;
                                end;
                                if v37 == 15 then
                                    v38.Color = Color3.new(0.858823, 0.70196, 0);
                                    local v42 = Instance.new("BallSocketConstraint");
                                    v42.Attachment0 = v39;
                                    v42.Attachment1 = l__PrimaryPart__14.Wire;
                                    v42.Parent = v38;
                                end;
                                l___wireAttachment__18 = v39;
                            end;
                            p30._wireLast = v32;
                            p30._wire = v35;
                        end;
                    elseif p30._wire then
                        p30._wire:Destroy();
                        p30._wire = nil;
                    end;
                else
                    local v43 = u2:Get("Shared", "Models", "Gear", p30._buildIgnitor).Asset:Clone();
                    local l__PrimaryPart__21 = v43.PrimaryPart;
                    for _, v44 in v43:GetChildren() do
                        v44.Anchored = false;
                        v44.CanCollide = false;
                        v44.CanTouch = false;
                        v44.CanQuery = false;
                    end;
                    p30._wireHand = l__PrimaryPart__21.Wire.CFrame;
                    local v45 = Instance.new("Motor6D");
                    v45.Part0 = l___actor__13.Parts.RightHand;
                    v45.Part1 = l__PrimaryPart__21;
                    v45.C1 = l__PrimaryPart__21.Anchor.CFrame;
                    v45.Parent = l__PrimaryPart__21;
                    v43.Parent = l___actor__13.Character;
                    p30._ignitorModel = v43;
                    if not p30._equip then
                        p30._equip = p30._actor:LoadAnimation(u2:Get("Animation", "GearAnimations", p30._buildIgnitor, "TP", "Equip").ID);
                        p30._equip.Priority = u3.AnimationPriority.Action;
                        p30._equip:Play(0);
                    end;
                    if not p30._idle then
                        p30._idle = p30._actor:LoadAnimation(u2:Get("Animation", "GearAnimations", p30._buildIgnitor, "TP", "Idle").ID);
                        p30._idle.Priority = u3.AnimationPriority.Movement;
                        p30._idle.Looped = true;
                        p30._idle:Play(0);
                    end;
                    if l__ViewModel__16 then
                        local _, v46 = l__ViewModel__16:SetModel(v43, u2:Get("Animation", "GearAnimations", p30._buildIgnitor, "FP", "Idle").ID, u2:Get("Animation", "GearAnimations", p30._buildIgnitor, "FP", "Equip").ID);
                        p30._fpModel = v46;
                        l__ViewModel__16.SprintID = 0;
                        if l__ViewModel__16.Active then
                            l__PrimaryPart__21 = nil;
                        end;
                    end;
                    local v47 = u4:CreateSound("Weapon_Interaction", l__PrimaryPart__21, false, "GearSounds", p30._buildIgnitor, "Equip");
                    v47.Play();
                    v47.Destroy(5);
                end;
            end;
        end;
    end;
end;
function u5.Destroy(p48) --[[ Line: 412 ]]
    if p48._wire then
        p48._wire:Destroy();
        p48._wire = nil;
    end;
    if p48._wireAttachment then
        p48._wireAttachment:Destroy();
        p48._wireAttachment = nil;
    end;
    if p48._ignitorModel then
        p48._ignitorModel:Destroy();
        p48._ignitorModel = nil;
    end;
    if p48._breachMotor then
        p48._breachMotor:Destroy();
        p48._breachMotor = nil;
    end;
    if p48._breachModel then
        p48._breachModel:Destroy();
        p48._breachModel = nil;
    end;
    if p48._placedModel then
        p48._placedModel:Destroy();
        p48._placedModel = nil;
    end;
    p48._fpModel = nil;
    p48._equipped = false;
end;
return u5;