-- Services.ReplicatorService.InventoryReplicators.DroneInventoryReplicator
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, _ = shared.import("require", "asset", "Enum", "frc");
local u4 = v1("SoundService");
local u5 = v1("ClientService");
local u6 = v1("DroneClass");
local u7 = {};
u7.__index = u7;
function u7._makeModel(p8, p9) --[[ Line: 12 ]]
    -- upvalues: u2 (copy), u4 (copy), u3 (copy)
    if p8._tpModel then
        p8._tpModel:Destroy();
        p8._tpModel = nil;
    end;
    p8._droneEquipped = p9;
    local l___actor__1 = p8._actor;
    local l___build__2 = p8._build;
    local v10 = p9 and "Drone" or "Controller";
    local v11 = u2:Get("Shared", "Models", "Gear", l___build__2 .. v10).Asset:Clone();
    for _, v12 in v11:GetDescendants() do
        if v12:IsA("BasePart") then
            v12.Anchored = false;
            v12.CanCollide = false;
            v12.CanTouch = false;
            v12.CanQuery = false;
        end;
    end;
    local v13 = Instance.new("Motor6D");
    v13.Part1 = v11.PrimaryPart;
    v13.Part0 = l___actor__1.Parts.RightHand;
    v13.Parent = v11;
    if not p9 then
        v13.C1 = v11.PrimaryPart.Anchor.CFrame;
    end;
    v11.Parent = l___actor__1.Character;
    p8._tpModel = v11;
    local l__PrimaryPart__3 = v11.PrimaryPart;
    local l__ViewModel__4 = l___actor__1.ViewModel;
    if l__ViewModel__4 then
        local l__ID__5 = u2:Get("Animation", "GearAnimations", l___build__2, "FP", v10 .. "Sprint").ID;
        l__ViewModel__4:SetModel(v11, u2:Get("Animation", "GearAnimations", l___build__2, "FP", v10 .. "Idle").ID, u2:Get("Animation", "GearAnimations", l___build__2, "FP", v10 .. "Equip").ID);
        l__ViewModel__4.SprintID = l__ID__5;
        if l__ViewModel__4.Active then
            l__PrimaryPart__3 = nil;
        end;
    end;
    if p8._equipSound then
        p8._equipSound.Destroy();
        p8._equipSound = nil;
    end;
    if p9 then
        local v14 = u4:CreateSound("Weapon_Interaction", l__PrimaryPart__3, false, "GearSounds", l___build__2, "Equip");
        v14.Play();
        v14.Destroy(10);
        p8._equipSound = v14;
    end;
    if p8._idle then
        p8._idle:Stop(0);
    end;
    if p8._equip then
        p8._equip:Stop(0);
    end;
    p8._equip = l___actor__1:LoadAnimation(u2:Get("Animation", "GearAnimations", l___build__2, "TP", v10 .. "Equip").ID);
    p8._equip.Priority = u3.AnimationPriority.Action;
    p8._equip:Play(0);
    p8._idle = l___actor__1:LoadAnimation(u2:Get("Animation", "GearAnimations", l___build__2, "TP", v10 .. "Idle").ID);
    p8._idle.Priority = u3.AnimationPriority.Movement;
    p8._idle.Looped = true;
    p8._idle:Play(0);
end;
function u7.new(p15, p16) --[[ Line: 86 ]]
    -- upvalues: u5 (copy), u7 (copy)
    return setmetatable({
        _client = u5.Clients[p15.Owner],
        _build = p16.Layout.Build,
        _item = p16,
        _actor = p15
    }, u7);
end;
function u7.Deploy(p17, p18, _) --[[ Line: 98 ]]
    -- upvalues: u6 (copy)
    if p17.Drone then
    else
        p17.Drone = p18 or u6.new(p17._build, p17._actor.CFrame:ToWorldSpace(CFrame.new(0, 2, -4)));
    end;
end;
function u7.Spot(p19, p20) --[[ Line: 109 ]]
    -- upvalues: u5 (copy)
    local l___client__6 = p19._client;
    local l__LocalClient__7 = u5.LocalClient;
    if l__LocalClient__7 ~= p19._client then
        if l__LocalClient__7.Squad == nil then
            return;
        end;
        if l___client__6.Squad ~= l__LocalClient__7.Squad then
            return;
        end;
    end;
    local v21 = p19._actor.Replicator.Actors[p20];
    if v21 then
        v21:Spotted(p19._item.MetaData.UID, 10);
    end;
end;
function u7.Unspot(p22, p23) --[[ Line: 127 ]]
    local v24 = p22._actor.Replicator.Actors[p23];
    if v24 then
        v24:Unspotted(p22._item.MetaData.UID);
    end;
end;
function u7.Broken(p25) --[[ Line: 134 ]]
    if p25._broken then
    else
        p25._broken = true;
        if p25.Drone then
            p25.Drone:Broken();
        end;
    end;
end;
function u7.Retrieve(p26) --[[ Line: 145 ]]
    if p26.Drone then
        p26.Drone:Destroy();
    end;
    p26.Drone = nil;
end;
function u7.Sync(p27, p28) --[[ Line: 152 ]]
    if not p27.Drone then
        p27:Deploy(nil, true);
    end;
    p27.Drone:Sync(p28);
end;
function u7.Equip(p29) --[[ Line: 160 ]]
    p29._equipped = true;
end;
function u7.Unequip(p30) --[[ Line: 164 ]]
    p30._equipped = false;
    local l__ViewModel__8 = p30._actor.ViewModel;
    if l__ViewModel__8 then
        l__ViewModel__8.SprintID = nil;
        l__ViewModel__8:SetModel();
    end;
    if p30._tpModel then
        p30._tpModel:Destroy();
        p30._tpModel = nil;
    end;
    if p30._idle then
        p30._idle:Stop(0);
        p30._idle = nil;
    end;
    if p30._equip then
        p30._equip:Stop(0);
        p30._equip = nil;
    end;
    if p30._equipSound then
        p30._equipSound.Destroy();
        p30._equipSound = nil;
    end;
    p30._droneEquipped = nil;
end;
function u7.Update(p31, _, _, _) --[[ Line: 192 ]]
    if p31._equipped then
        if p31.Drone then
            if p31._droneEquipped or not p31._tpModel then
                p31:_makeModel(false);
            end;
        elseif not (p31._droneEquipped and p31._tpModel) then
            p31:_makeModel(true);
        end;
    end;
end;
function u7.Destroy(p32) --[[ Line: 208 ]]
    if p32._tpModel then
        p32._tpModel:Destroy();
        p32._tpModel = nil;
    end;
    if p32.Drone then
        p32.Drone:Destroy();
        p32.Drone = nil;
    end;
    p32._equipped = false;
end;
return u7;