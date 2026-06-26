-- Services.ReplicatorService.InventoryReplicators.MeleeInventoryReplicator
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3 = shared.import("require", "asset", "Enum");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u4 = v1("EffectsService");
local u5 = v1("SoundService");
local u6 = v1("ItemLayout");
local u7 = v1("Mathf");
local u8 = v1("Spring");
local u9 = {};
u9.__index = u9;
function u9.new(p10, p11, p12) --[[ Line: 15 ]]
    -- upvalues: u3 (copy), l__CurrentCamera__1 (copy), u6 (copy), u2 (copy), u8 (copy), u9 (copy)
    local v13 = RaycastParams.new();
    v13.FilterType = u3.RaycastFilterType.Blacklist;
    v13.FilterDescendantsInstances = { l__CurrentCamera__1, p10.Character };
    v13.IgnoreWater = false;
    v13.CollisionGroup = u3.PhysicsGroup.BulletCast;
    local _ = u6[p11.Name];
    local l__Build__2 = p11.Layout.Build;
    local v14 = {
        _lerp = 1,
        Replicator = p12,
        _equip = p10:LoadAnimation(u2:Get("Animation", "MeleeAnimations", l__Build__2, "TP", "Equip").ID),
        _idle = p10:LoadAnimation(u2:Get("Animation", "MeleeAnimations", l__Build__2, "TP", "Idle").ID),
        _params = v13,
        _build = l__Build__2,
        _actor = p10,
        _sway = u8.new(Vector2.zero)
    };
    local v15 = setmetatable(v14, u9);
    v15._sway.Speed = 10;
    v15._sway.Damper = 0.2;
    local v16 = u2:Get("Shared", "Models", "Weapon", "Melee", l__Build__2).Asset:Clone();
    local l__PrimaryPart__3 = v16.PrimaryPart;
    local v17 = Instance.new("Motor6D");
    v17.Part1 = l__PrimaryPart__3;
    v17.Parent = v16;
    local l__anchor__4 = l__PrimaryPart__3:WaitForChild("anchor");
    local v18 = nil;
    for _, v19 in l__PrimaryPart__3:GetChildren() do
        if v19:IsA("Attachment") and v19 ~= l__anchor__4 then
            v18 = v19;
            break;
        end;
    end;
    v15._C0 = v18.CFrame:Inverse();
    v15._belt = p10.Parts[v18.Name];
    v15._hand = p10.Parts.RightHand;
    for _, v20 in v16:GetChildren() do
        if v20:IsA("BasePart") then
            v20.CanCollide = false;
            v20.AudioCanCollide = false;
            v20.CanQuery = false;
            v20.CanTouch = false;
        end;
    end;
    v15._handOffset = l__anchor__4.CFrame;
    v15._C1 = CFrame.new();
    v15._primary = l__PrimaryPart__3;
    v15._model = v16;
    v15._weld = v17;
    v15._toBelt = true;
    v17.C0 = v15._C0;
    v17.C1 = v15._C1;
    v17.Part0 = v15._belt;
    v16.Parent = p10.Character;
    return v15;
end;
function u9.Slash(p21, p22) --[[ Line: 81 ]]
    -- upvalues: u2 (copy), u3 (copy), u5 (copy)
    local l___primary__5 = p21._primary;
    p21._slashTP = p21._actor:LoadAnimation(u2:Get("Animation", "MeleeAnimations", p21._build, "TP", "Hit" .. p22).ID);
    p21._slashTP:Play(0);
    local l__ViewModel__6 = p21._actor.ViewModel;
    if l__ViewModel__6 then
        if l__ViewModel__6.Active then
            l___primary__5 = nil;
        end;
        p21._slash = l__ViewModel__6:LoadAnimation(u2:Get("Animation", "MeleeAnimations", p21._build, "FP", "Hit" .. p22).ID);
        p21._slash.Priority = u3.AnimationPriority.Action3;
        p21._slash:Play(0);
    end;
    u5:CreateSound("Weapon_Interaction", l___primary__5, true, "MeleeSounds", p21._build, "Hit" .. p22).Destroy(4);
end;
function u9.Breach(p23, p24, p25) --[[ Line: 99 ]]
    -- upvalues: u2 (copy), u5 (copy)
    local l___actor__7 = p23._actor;
    local l__NoLean__8 = p23._actor.NoLean;
    local v26 = tick() + 2;
    l___actor__7.NoLean = math.max(l__NoLean__8, v26);
    p23._actor:LoadAnimation(u2:Get("Animation", "MeleeAnimations", p23._build, "TP", "Breach" .. p24).ID):Play(0);
    local l___primary__9 = p23._primary;
    local l__ViewModel__10 = p23._actor.ViewModel;
    if l__ViewModel__10 and l__ViewModel__10.Active then
        l___primary__9 = nil;
    end;
    u5:CreateSound("Weapon_Interaction", l___primary__9, true, "Doors", "Breachtool", p25 and "Wood" or "Metal").Destroy(10);
    if p23._slashTP and p23._slashTP.IsPlaying then
        p23._slashTP:Stop(0);
    end;
    if p23._slash and p23._slash.IsPlaying then
        p23._slash:Stop(0);
    end;
end;
function u9.Impact(p27, p28) --[[ Line: 118 ]]
    -- upvalues: u4 (copy)
    local v29 = p27._actor.CFrame:PointToWorldSpace(Vector3.new(0, 2.5, 0));
    local v30 = workspace:Raycast(v29, p28, p27._params) or workspace:Spherecast(v29, 1, p28, p27._params);
    if v30 and v30.Instance then
        local v31, v32 = p27.Replicator:GetFromBodyPart(v30.Instance);
        if not p27.Replicator:ShatterGlass(v30.Instance, v30.Position) then
            u4:BulletLand(v29, v30.Position, v30.Instance, v30.Normal, v31 and "Blood" or v30.Material, "melee_" .. p27._build);
        end;
        if v32 and v32.Zombie then
            v32:Flinch(v30.Instance.Name);
        end;
        return v30.Position, v31, v30.Instance.Name;
    end;
end;
function u9.Equip(p33) --[[ Line: 138 ]]
    -- upvalues: u2 (copy), u5 (copy)
    p33._equip:Play(0);
    p33._idle:Play();
    p33._toHand = true;
    p33._lerp = 0;
    p33._offset = nil;
    p33._toBelt = nil;
    local l___primary__11 = p33._primary;
    local l__ViewModel__12 = p33._actor.ViewModel;
    if l__ViewModel__12 then
        local l__ID__13 = u2:Get("Animation", "MeleeAnimations", p33._build, "FP", "Idle").ID;
        local l__ID__14 = u2:Get("Animation", "MeleeAnimations", p33._build, "FP", "Equip").ID;
        l__ViewModel__12:SetModel(p33._model, l__ID__13, l__ID__14);
        l__ViewModel__12.SprintID = u2:Get("Animation", "MeleeAnimations", p33._build, "FP", "Sprint").ID;
        if l__ViewModel__12.Active then
            l___primary__11 = nil;
        end;
    end;
    u5:CreateSound("Weapon_Interaction", l___primary__11, false, "MeleeSounds", p33._build, "Equip").Play();
end;
function u9.Unequip(p34) --[[ Line: 163 ]]
    p34._idle:Stop();
    p34._toBelt = true;
    p34._lerp = 0;
    p34._offset = nil;
    p34._toHand = nil;
    if p34._slash then
        p34._slash:Stop(0);
        p34._slash = nil;
    end;
    local l__ViewModel__15 = p34._actor.ViewModel;
    if l__ViewModel__15 then
        l__ViewModel__15.SprintID = nil;
        l__ViewModel__15:SetModel();
    end;
end;
function u9.Update(p35, p36, p37, p38) --[[ Line: 183 ]]
    -- upvalues: u3 (copy), u7 (copy)
    local l___toBelt__16 = p35._toBelt;
    local l___toHand__17 = p35._toHand;
    if l___toHand__17 or l___toBelt__16 then
        local l___weld__18 = p35._weld;
        local v39;
        if p36 == 3 then
            v39 = p37 == 1;
        else
            v39 = false;
        end;
        local v40 = v39 and (p35._lerp or 1) or 1;
        if v40 > 0.5 then
            local v41 = (v40 - 0.5) * 2;
            if l___toBelt__16 then
                if not p35._offset then
                    p35._offset = p35._primary.CFrame:ToObjectSpace(p35._belt.CFrame):Inverse();
                end;
                local l__zero__19 = Vector2.zero;
                if v39 and (p35._actor.HeightState ~= u3.CharacterHeightState.Proning and not p35._actor.Downed) then
                    local v42, _, v43 = l___weld__18.Part0.CFrame:ToOrientation();
                    p35._sway:Impulse(Vector2.new(v43, (math.max(v42, 0))));
                    p35._sway.Target = Vector2.new(v43 / 2, math.max(v42, 0) / 2);
                    l__zero__19 = p35._sway.Position;
                end;
                l___weld__18.C0 = p35._offset:Lerp(p35._C0 * CFrame.Angles(-l__zero__19.Y, 0, 0) * CFrame.Angles(0, 0, -l__zero__19.X), v41);
                l___weld__18.C1 = CFrame.new():Lerp(p35._C1, v41);
                l___weld__18.Part0 = p35._belt;
            elseif l___toHand__17 then
                if not p35._offset then
                    p35._offset = p35._primary.CFrame:ToObjectSpace(p35._hand.CFrame):Inverse();
                end;
                l___weld__18.C0 = p35._offset:Lerp(CFrame.new(), v41);
                l___weld__18.C1 = CFrame.new():Lerp(p35._handOffset, v41);
                l___weld__18.Part0 = p35._hand;
            end;
        end;
        if p35._lerp > 0.99 then
            p35._lerp = 1;
            if not v39 then
                p35._offset = nil;
                p35._toBelt = nil;
                p35._toHand = nil;
            end;
        else
            p35._lerp = u7.Lerp(v40, 1, p38 * 7.5);
        end;
    end;
end;
function u9.Destroy(p44) --[[ Line: 231 ]]
    if p44._model then
        p44._model:Destroy();
        p44._model = nil;
    end;
end;
return u9;