-- Services.ReplicatorService.ZombieClass
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, _, _, u4 = shared.import("require", "asset", "Enum", "signal", "server", "frc");
local u5 = v1("SoundService");
v1("ChunkService");
local u6 = v1("WorldService");
v1("InputService");
v1("VehicleService");
local u7 = v1("DebugService");
local u8 = v1("Ragdoll");
v1("ClientService");
v1("Animations");
v1("ItemLayout");
local u9 = v1("WaveCalculator");
local u10 = v1("BaseComponent");
local u11 = v1("Menu");
local u12 = v1("Mathf");
local u13 = v1("solveIK");
local u14 = v1("FootstepMaterials");
game:GetService("Debris");
local l__Players__1 = game:GetService("Players");
game:GetService("Lighting");
game:GetService("TextService");
game:GetService("TweenService");
local l__CurrentCamera__2 = workspace.CurrentCamera;
local _ = l__Players__1.LocalPlayer;
local l__InactiveWorld__3 = u6.InactiveWorld;
local u15 = {
    "Crippled",
    "Slow",
    "Normal",
    "Sprinter"
};
local u16 = {
    Shirt = {
        "LeftHand",
        "LeftLowerArm",
        "LeftUpperArm",
        "UpperTorso",
        "RightUpperArm",
        "RightLowerArm",
        "RightHand"
    },
    Pants = {
        "LeftFoot",
        "LeftLowerLeg",
        "LeftUpperLeg",
        "LowerTorso",
        "RightUpperLeg",
        "RightLowerLeg",
        "RightFoot"
    }
};
local u17 = {
    LimitsEnabled = true,
    UpperAngle = 0,
    LowerAngle = -75
};
local u18 = {};
u18.__index = u18;
local function u27(p19, p20, p21, p22) --[[ Line: 70 ]]
    -- upvalues: u3 (copy)
    for _, v23 in p19:GetChildren() do
        if v23:IsA("Motor6D") and v23.Name == p20.Name then
            v23:Destroy();
        end;
    end;
    local v24 = Instance.new(p21 .. "Constraint");
    v24.Attachment0 = p19:FindFirstChild(p20.Name);
    v24.Attachment1 = p20:FindFirstChild(p19.Name);
    if p22 then
        v24.LimitsEnabled = true;
        for v25, v26 in p22 do
            v24[v25] = v26;
        end;
    end;
    p20.CanCollide = true;
    p20.CollisionGroup = u3.PhysicsGroup.LimbRagdoll;
    v24.Parent = p19.Parent;
end;
function u18._changeOutfit(p28, p29, p30) --[[ Line: 92 ]]
    -- upvalues: u2 (copy), u16 (copy)
    local l__Clothes__4 = p28.Clothes;
    local l__Asset__5 = u2:Get("Shared", "Models", "Outfit", p30, p29).Asset;
    for _, v31 in u16[p30] do
        l__Asset__5:Clone().Parent = l__Clothes__4[v31];
    end;
end;
function u18._doFootstep(p32, p33, p34) --[[ Line: 101 ]]
    -- upvalues: u3 (copy), u14 (copy), u6 (copy), u9 (copy), u5 (copy)
    local v35 = "Concrete";
    local v36 = RaycastParams.new();
    v36.FilterType = u3.RaycastFilterType.Exclude;
    v36.FilterDescendantsInstances = { p32.Character };
    local v37 = workspace:Raycast(p32.CFrame.Position, Vector3.new(0, -10, 0), v36);
    if v37 then
        local l__MaterialVariant__6 = v37.Instance.MaterialVariant;
        if #l__MaterialVariant__6 > 0 and u14[l__MaterialVariant__6] then
            v35 = u14[l__MaterialVariant__6];
        elseif u14[v37.Material] then
            v35 = u14[v37.Material];
        end;
    end;
    local l__Swimming__7 = p32.Swimming;
    if not p32.Swimming and u6:InWater(p34.Position) then
        local v38 = u9:GetWaveHeight(p34.Position, true);
        l__Swimming__7 = p34.Position.Y < v38 + u6.World.Water.Height and true or l__Swimming__7;
    end;
    local v39 = p33 == "Sprint" and p33 and p33 or "Jog";
    if p32.Focused then
        p34 = nil;
    end;
    u5:CreateSound("Z_Foley", p34, true, "Footsteps", v39, l__Swimming__7 and "WaterWaist" or v35).Destroy(4);
end;
function u18._updateLOD(p40, p41) --[[ Line: 135 ]]
    p40._lod = p41;
    local v42 = not p41;
    for _, v43 in p40._shadowCasters do
        v43.CastShadow = v42;
    end;
    local v44;
    if p41 then
        v44 = nil;
    else
        v44 = p40.Character or nil;
    end;
    for _, v45 in {
        "Vest",
        "Belt",
        "Eyewear",
        "Earwear",
        "Facewear",
        "Backpack",
        "Wrist"
    } do
        if p40[v45] then
            p40[v45].Parent = v44;
        end;
    end;
end;
function u18._createEquipWeld(p46, p47, p48) --[[ Line: 151 ]]
    local v49 = p48:FindFirstChild("Anchor") or p48:FindFirstChild("anchor");
    local v50 = Instance.new("Weld");
    v50.Part0 = p46.Parts[p47];
    v50.Part1 = p48;
    v50.C1 = v49.CFrame;
    v50.Parent = p48;
    p48.Name = "Part";
    v49:Destroy();
    return v50;
end;
function u18._changeWearable(p51, p52, p53) --[[ Line: 164 ]]
    -- upvalues: u10 (copy)
    if p51[p52] then
        p51[p52]:Destroy();
        p51[p52] = nil;
    end;
    if p53 then
        local l__ParentModel__8 = u10.Deserialize(p53[2].Build).ParentModel;
        p51:_createEquipWeld(p52 == "Wrist" and "LeftLowerArm" or ((p52 == "Vest" or p52 == "Backpack") and "UpperTorso" or (p52 == "Belt" and "LowerTorso" or "Head")), l__ParentModel__8.PrimaryPart);
        local v54;
        if p51._lod then
            v54 = nil;
        else
            v54 = p51.Character or nil;
        end;
        l__ParentModel__8.Parent = v54;
        p51[p52] = l__ParentModel__8;
    end;
end;
function u18.Flinch(p55, p56) --[[ Line: 181 ]]
    -- upvalues: u2 (copy)
    local v57 = (p56 == "UpperTorso" or p56 == "LowerTorso") and "Torso" or ((p56 == "LeftUpperArm" or p56 == "LeftLowerArm") and "LeftArm" or ((p56 == "RightUpperArm" or p56 == "RightLowerArm") and "RightArm" or nil));
    if v57 then
        p55:LoadAnimation(u2:Get("Animation", "ZombieAnimations", "Flinch", v57).ID):Play(0);
    end;
end;
function u18.FallOver(p58, p59) --[[ Line: 198 ]]
    -- upvalues: u2 (copy), u3 (copy)
    local v60 = p58:LoadAnimation(u2:Get("Animation", "ZombieAnimations", "Fall", p59).ID);
    v60.Priority = u3.AnimationPriority.Action;
    v60:Play(0);
end;
function u18._getHead(p61) --[[ Line: 205 ]]
    if not p61.Focused then
        return p61.Parts.Head;
    end;
end;
function u18._changeBoots(p62, _, p63) --[[ Line: 212 ]]
    -- upvalues: u11 (copy), u2 (copy)
    local l___boots__9 = p62._boots;
    if l___boots__9 then
        l___boots__9.L:Destroy();
        l___boots__9.R:Destroy();
        p62._boots = nil;
    end;
    if p63 then
        local v64 = p63[2].Build[1][3];
        local l__Texture__10 = u11.Character.Boots[v64].Camos[p63[2].Build[2].Camo or "Default"].Texture;
        local l__Character__11 = p62.Character;
        local v65 = u2:Get("Shared", "Models", "Character", "Boot", v64, "L").Asset:Clone();
        v65.TextureID = l__Texture__10;
        v65.CanQuery = false;
        v65.AudioCanCollide = false;
        v65.CanCollide = false;
        v65.CanTouch = false;
        v65.Parent = l__Character__11;
        local v66 = u2:Get("Shared", "Models", "Character", "Boot", v64, "R").Asset:Clone();
        v66.TextureID = l__Texture__10;
        v66.CanQuery = false;
        v66.AudioCanCollide = false;
        v66.CanCollide = false;
        v66.CanTouch = false;
        v66.Parent = l__Character__11;
        p62:_createEquipWeld("LeftFoot", v65);
        p62:_createEquipWeld("RightFoot", v66);
        p62._boots = {
            L = v65,
            R = v66
        };
    end;
end;
function u18._changeGloves(p67, _, p68) --[[ Line: 252 ]]
    -- upvalues: u11 (copy), u2 (copy)
    local l___gloves__12 = p67._gloves;
    if l___gloves__12 then
        l___gloves__12.L:Destroy();
        l___gloves__12.R:Destroy();
        p67._gloves = nil;
    end;
    if p68 then
        local v69 = p68[2].Build[1][3];
        local l__Texture__13 = u11.Character.Gloves[v69].Camos[p68[2].Build[2].Camo or "Default"].Texture;
        local l__Character__14 = p67.Character;
        local v70 = u2:Get("Shared", "Models", "Character", "Arm", "Gloves", v69, "TP", "L").Asset:Clone();
        v70.TextureID = l__Texture__13;
        v70.CanQuery = false;
        v70.AudioCanCollide = false;
        v70.CanCollide = false;
        v70.CanTouch = false;
        v70.Parent = l__Character__14;
        local v71 = u2:Get("Shared", "Models", "Character", "Arm", "Gloves", v69, "TP", "R").Asset:Clone();
        v71.TextureID = l__Texture__13;
        v71.CanQuery = false;
        v71.AudioCanCollide = false;
        v71.CanCollide = false;
        v71.CanTouch = false;
        v71.Parent = l__Character__14;
        p67:_createEquipWeld("LeftHand", v70);
        p67:_createEquipWeld("RightHand", v71);
        p67._gloves = {
            L = v70,
            R = v71
        };
    end;
end;
function u18._generateDamageModel(p72, p73, p74) --[[ Line: 291 ]]
    -- upvalues: u2 (copy), u3 (copy)
    local v75 = u2:GetRandom("Shared", "Models", "Character", "DamageVariants", p74).Asset:Clone();
    v75.CanCollide = false;
    v75.CanTouch = false;
    v75.CanQuery = false;
    v75.CastShadow = false;
    v75.AudioCanCollide = false;
    v75.Anchored = false;
    v75.Color = p72.SkinColor;
    v75.Material = u3.Material.SmoothPlastic;
    v75.Name = "Outer";
    p72.Clothes[p73] = v75;
    local l__Anchor__15 = v75:WaitForChild("Anchor");
    local v76 = Instance.new("Weld");
    v76.Part0 = p72.Parts[p73];
    v76.Part1 = v75;
    v76.C1 = l__Anchor__15.CFrame;
    v76.Parent = v75;
    l__Anchor__15:Destroy();
    v75.Parent = p72.Character;
end;
function u18.new(p77, _, p78) --[[ Line: 315 ]]
    -- upvalues: u2 (copy), u3 (copy), u18 (copy), l__InactiveWorld__3 (copy), u7 (copy)
    local v79 = u2:Get("Shared", "Models", "Character", "Zombie");
    local v80 = v79.Asset:Clone();
    local v81 = {};
    local v82 = {};
    local v83 = {};
    for _, v84 in v80:GetChildren() do
        v84.CollisionGroup = u3.PhysicsGroup.CharacterCast;
        v84.CanCollide = false;
        v84.CanTouch = false;
        v84.AudioCanCollide = false;
        if v84 == v80.PrimaryPart then
            v84.CanQuery = false;
        else
            v81[#v81 + 1] = v84;
            v82[v84.Name] = v84;
            v83[v84.Name] = v84;
        end;
    end;
    local v85 = Instance.new("Humanoid");
    v85.DisplayDistanceType = u3.HumanoidDisplayDistanceType.None;
    v85.EvaluateStateMachine = false;
    v85.RequiresNeck = false;
    v85.BreakJointsOnDeath = false;
    v85.RigType = u3.HumanoidRigType.R6;
    v85.Parent = v80;
    local v86 = Instance.new("Animator");
    v86.Parent = v85;
    local v87 = {
        Health = 100,
        Alive = true,
        Zombie = true,
        Replicator = p77,
        Character = v80,
        SkinColor = Color3.fromRGB(171, 168, 158),
        SimulatedPosition = p78.Position,
        Position = p78.Position,
        Orientation = p78.Orientation,
        Direction = Vector2.new(),
        CFrame = CFrame.new(p78.Position),
        ServerPosition = p78.Position,
        RootPart = v80.PrimaryPart,
        Sprinting = false,
        Walking = false,
        Swimming = false,
        HeightState = 0,
        WaterLevel = 0,
        Cycle = 0,
        Zoom = 5,
        Tilt = 0,
        Lean = 0,
        LeanGoal = 0,
        CameraX = p78.Orientation,
        CameraY = 0,
        CurrentState = {},
        Clothes = v82,
        Parts = v83,
        _shadowCasters = v81,
        _death = 0,
        _limbs = {
            LeftArm = true,
            LeftLeg = true,
            RightArm = true,
            RightLeg = true
        },
        _lastCFrame = CFrame.new(p78.Position) * CFrame.Angles(0, p78.Orientation, 0),
        _animator = v86,
        _loadedAnimations = {},
        _loaded = false,
        AnimationKit = "SprinterAlerted",
        _animationState = "Jog",
        _animationCache = {},
        _animationLerp = CFrame.new(),
        _animationCycle = 0,
        _idleWeight = 1,
        _heightDifference = 0
    };
    local u88 = setmetatable(v87, u18);
    u88:_generateDamageModel("Head", "Head");
    u88:_generateDamageModel("UpperTorso", "Torso");
    u88:_generateDamageModel("RightUpperArm", "RightArm");
    u88:_generateDamageModel("LeftUpperArm", "LeftArm");
    u88:_generateDamageModel("RightUpperLeg", "RightLeg");
    u88:_generateDamageModel("LeftUpperLeg", "LeftLeg");
    for _, v89 in {
        "RightLowerArm",
        "LeftLowerArm",
        "RightLowerArm",
        "LeftLowerArm",
        "LowerTorso"
    } do
        v83[v89].Color = u88.SkinColor;
    end;
    u88:_changeOutfit(p78.State.Shirt[1]:sub(6), "Shirt");
    u88:_changeOutfit(p78.State.Pants[1]:sub(6), "Pants");
    v79:Preload(function(_) --[[ Line: 420 ]]
        -- upvalues: u88 (copy)
        u88._loaded = true;
    end);
    u88._isInactive = true;
    v80.Parent = l__InactiveWorld__3;
    for v90, v91 in p78.State do
        u88:State(v90, v91);
    end;
    u7:Print("Spawned zombie (SERVER)", Color3.new(0.435294, 0.694117, 0.635294));
    return u88;
end;
function u18.Reequip(_) --[[ Line: 434 ]] end;
function u18.DoAnimation(p92, ...) --[[ Line: 438 ]]
    -- upvalues: u2 (copy), u3 (copy)
    local v93 = p92:LoadAnimation(u2:Get("Animation", ...).ID);
    v93.Priority = u3.AnimationPriority.Action3;
    v93:Play(0);
end;
function u18.Action(p94, p95, p96, ...) --[[ Line: 445 ]]
    -- upvalues: u3 (copy)
    if p94[p96] then
        if p95 == u3.ActionType.Function then
            p94[p96](p94, ...);
        end;
    else
        warn(p96 .. " function doesn\'t exist.");
    end;
end;
function u18.GetSelf(p97, p98) --[[ Line: 456 ]]
    -- upvalues: u13 (copy)
    return p97.UID, p97, u13(p98);
end;
function u18.IsA(_, p99) --[[ Line: 460 ]]
    return p99 == "Actor";
end;
function u18.State(p100, p101, p102) --[[ Line: 464 ]]
    local l__CurrentState__16 = p100.CurrentState;
    l__CurrentState__16[p101] = p102;
    if p101 == "Backpack" then
        p100:_changeWearable("Backpack", p102);
    elseif p101 == "Vest" then
        p100:_changeWearable("Vest", p102);
    elseif p101 == "Belt" then
        p100:_changeWearable("Belt", p102);
    elseif p101 == "Helmet" then
        p100:_changeWearable("Helmet", p102);
    elseif p101 == "Facewear" then
        p100:_changeWearable("Facewear", p102);
    elseif p101 == "Earwear" then
        p100:_changeWearable("Earwear", p102);
    elseif p101 == "Eyewear" then
        p100:_changeWearable("Eyewear", p102);
    elseif p101 == "Wrist" then
        p100:_changeWearable("Wrist", p102);
    elseif p101 == "Gloves" then
        p100:_changeGloves(l__CurrentState__16[p101], p102);
    else
        if p101 == "Boots" then
            p100:_changeBoots(l__CurrentState__16[p101], p102);
        end;
    end;
end;
function u18.Died(p103) --[[ Line: 491 ]]
    -- upvalues: u8 (copy)
    if p103._currentVoiceLine then
        p103._currentVoiceLine[1].FadeOut(0.2);
        task.cancel(p103._currentVoiceLine[2]);
        p103._currentVoiceLine = nil;
    end;
    p103.RootPart:Destroy();
    pcall(u8, p103.Character);
end;
function u18.LoadAnimation(p104, p105) --[[ Line: 502 ]]
    local v106 = p104._loadedAnimations[p105];
    if v106 then
        return v106;
    end;
    local v107 = Instance.new("Animation");
    v107.AnimationId = "rbxassetid://" .. p105;
    local v108 = p104._animator:LoadAnimation(v107);
    p104._loadedAnimations[p105] = v108;
    return v108;
end;
function u18._killLimb(p109, p110) --[[ Line: 516 ]]
    -- upvalues: u27 (copy), u17 (copy)
    p109._limbs[p110] = false;
    local l__Character__17 = p109.Character;
    if p110 == "LeftArm" then
        u27(l__Character__17.UpperTorso, l__Character__17.LeftUpperArm, "BallSocket");
        u27(l__Character__17.LeftUpperArm, l__Character__17.LeftLowerArm, "BallSocket");
    elseif p110 == "RightArm" then
        u27(l__Character__17.UpperTorso, l__Character__17.RightUpperArm, "BallSocket");
        u27(l__Character__17.RightUpperArm, l__Character__17.RightLowerArm, "BallSocket");
    else
        if p110 == "LeftLeg" then
            u27(l__Character__17.LowerTorso, l__Character__17.LeftUpperLeg, "BallSocket");
            u27(l__Character__17.LeftUpperLeg, l__Character__17.LeftLowerLeg, "Hinge", u17);
            if p109._limbs.RightLeg then
                p109:FallOver("Left");
            end;
        elseif p110 == "RightLeg" then
            u27(l__Character__17.LowerTorso, l__Character__17.RightUpperLeg, "BallSocket");
            u27(l__Character__17.RightUpperLeg, l__Character__17.RightLowerLeg, "Hinge", u17);
            if p109._limbs.LeftLeg then
                p109:FallOver("Right");
            end;
        end;
    end;
end;
function u18.Replicate(p111, p112, p113, p114, p115, p116, p117, p118, p119, p120, p121) --[[ Line: 541 ]]
    -- upvalues: u15 (copy)
    p111.Health = p112;
    p111.Platform = p115;
    p111.Orientation = p114;
    p111.LeanGoal = p120;
    p111.SimulatedPosition = p113;
    p111.ServerPosition = p121;
    p111.Alerted = p116;
    p111.HeightState = p117;
    p111._camera = Vector2.new(p118, p119);
    if p112 then
        local l___limbs__18 = p111._limbs;
        if l___limbs__18.LeftArm and not p112.LeftArm then
            p111:_killLimb("LeftArm");
        elseif l___limbs__18.RightArm and not p112.RightArm then
            p111:_killLimb("RightArm");
        elseif l___limbs__18.LeftLeg and not p112.LeftLeg then
            p111:_killLimb("LeftLeg");
        elseif l___limbs__18.RightLeg and not p112.RightLeg then
            p111:_killLimb("RightLeg");
        end;
    end;
    if p112 and p112.Ability > 0 then
        p111.AnimationKit = u15[p112.Ability] .. (p116 and "Alerted" or "Idle");
    end;
end;
function u18.Update(p122, p123, p124, _, p125) --[[ Line: 571 ]]
    -- upvalues: u12 (copy), u4 (copy), u9 (copy), u6 (copy), u3 (copy), u2 (copy), l__InactiveWorld__3 (copy)
    tick();
    if p122.Alive and not p122.Health then
        p122.Alive = false;
        p122:Died();
    end;
    if p122.Alive then
        local v126 = u4(p125 * 5);
        local l__Magnitude__19 = (p122.CFrame.Position - p124).Magnitude;
        local v127 = l__Magnitude__19 < 64 and 1 or (l__Magnitude__19 < 128 and 2 or (l__Magnitude__19 < 256 and 3 or (l__Magnitude__19 < 512 and 4 or 5)));
        local v128 = l__Magnitude__19 <= 500;
        local v129 = (v127 <= 2 or p122.OnScreen) and true or false;
        local l__ViewportOnScreen__20 = p122.ViewportOnScreen;
        local v130;
        if v127 > 2 and not l__ViewportOnScreen__20 then
            v129 = false;
            v128 = false;
            v130 = false;
        else
            v130 = true;
        end;
        if l__ViewportOnScreen__20 then
            l__ViewportOnScreen__20 = v127 > 2;
        end;
        p122.LOD_OnScreen = l__ViewportOnScreen__20;
        p122.LOD_Distance = l__Magnitude__19;
        local v131 = p123 < 3 and v127 > 1 and true or v127 > 2;
        if v131 and not p122._lod then
            p122:_updateLOD(true);
        elseif not v131 and p122._lod then
            p122:_updateLOD(false);
        end;
        local l___camera__21 = p122._camera;
        if l___camera__21 then
            p122.CameraX = u12.Lerp(p122.CameraX, l___camera__21.X, u4(p125 * 10));
            p122.CameraY = u12.Lerp(p122.CameraY, l___camera__21.Y, u4(p125 * 10));
        end;
        local l___animationCache__22 = p122._animationCache;
        local l__SimulatedPosition__23 = p122.SimulatedPosition;
        local l___lastCFrame__24 = p122._lastCFrame;
        Vector3.new();
        local v132 = l___lastCFrame__24:Lerp(CFrame.new(l__SimulatedPosition__23) * CFrame.Angles(0, p122.Orientation, 0), v126);
        local v133 = v132.Position - l___lastCFrame__24.Position;
        p122._lastCFrame = v132;
        local l__Position__25 = v132.Position;
        p122.Position = l__Position__25;
        p122.Direction = Vector2.new(v133.X, v133.Z);
        local v134 = u9:GetWaveHeight(l__Position__25, true) + u6.World.Water.Height;
        local v135 = u6:InWater(l__Position__25);
        if v135 then
            v135 = l__Position__25.Y - (p122.Swimming and 1.5 or 0) < v134;
        end;
        p122.Swimming = v135;
        p122.WaterLevel = v134;
        if v129 and v128 then
            local v136 = p122.HeightState or 0;
            local v137 = p122.Direction.Magnitude / p125;
            local v138 = p122.Direction.Magnitude > 0.002;
            local l__AnimationKit__26 = p122.AnimationKit;
            p122._isWalking = v138;
            local v139, v140;
            if v136 == u3.CharacterHeightState.Proning then
                v139 = "Prone";
                v140 = "Prone";
            else
                v139 = "Standing";
                v140 = "Walk";
            end;
            p122._lastIdle = v139;
            if v136 == u3.CharacterHeightState.Climbing then
                if p122._heightAnimation then
                    p122._heightAnimation:AdjustSpeed((v132.Position.Y - p122._lastHeight) / p125 / 5);
                else
                    local v141 = p122:LoadAnimation(16218792980);
                    v141.Priority = u3.AnimationPriority.Movement;
                    v141:Play(0);
                    p122._heightAnimation = v141;
                end;
                p122._lastHeight = v132.Position.Y;
            elseif p122._heightAnimation then
                p122._heightAnimation:Stop();
                p122._heightAnimation = nil;
            end;
            if v138 then
                local v142 = p122._animationLerp:Lerp(CFrame.lookAt(Vector3.new(0, 0, 0), v132.LookVector):ToObjectSpace(CFrame.lookAt(Vector3.new(0, 0, 0), (Vector3.new(v133.X, 0, v133.Z)))), p122._animationStill and 1 or math.min(p125 * 5, 1));
                p122._animationLerp = v142;
                p122._animationStill = false;
                if p122._animationState ~= v140 then
                    p122._animationState = v140;
                    p122._animationCycle = 0;
                end;
                local _, v143 = v142:ToOrientation();
                local _, _, _, _, _, v144 = v142:GetComponents();
                local v145 = math.deg(v143);
                local v146 = "N";
                local v147 = "N";
                local v148 = 1;
                if v145 <= 0 and v145 >= -45 then
                    v148 = math.abs(v145) / 45;
                    v147 = "NE";
                    v146 = "N";
                elseif v145 <= -45 and v145 >= -90 then
                    v148 = (math.abs(v145) - 45) / 45;
                    v147 = "E";
                    v146 = "NE";
                elseif v145 <= -90 and v145 >= -135 then
                    v148 = (math.abs(v145) - 90) / 45;
                    v147 = "SE";
                    v146 = "E";
                elseif v145 <= -135 and v145 >= -185 then
                    v148 = (math.abs(v145) - 135) / 45;
                    v147 = "S";
                    v146 = "SE";
                elseif v145 >= 0 and v145 <= 45 then
                    v148 = math.abs(v145) / 45;
                    v147 = "NW";
                    v146 = "N";
                elseif v145 >= 45 and v145 <= 90 then
                    v148 = (v145 - 45) / 45;
                    v147 = "W";
                    v146 = "NW";
                elseif v145 >= 90 and v145 <= 135 then
                    v148 = (v145 - 90) / 45;
                    v147 = "SW";
                    v146 = "W";
                elseif v145 >= 135 and v145 <= 185 then
                    v148 = (v145 - 130) / 45;
                    v147 = "S";
                    v146 = "SW";
                end;
                if v147 == "SE" or (v146 == "SE" or (v147 == "E" or v146 == "E")) then
                    v147 = "NE";
                    v148 = 1;
                    v146 = "N";
                elseif v147 == "SW" or (v146 == "SW" or (v147 == "W" or v146 == "E")) then
                    v147 = "NW";
                    v148 = 1;
                    v146 = "N";
                end;
                local v149 = math.clamp(v148, 0, 1);
                local v150 = string.format("%s_%s_%s", l__AnimationKit__26, v140, v146);
                if not l___animationCache__22[v150] then
                    local v151 = p122:LoadAnimation(u2:Get("Animation", "ZombiePacks", l__AnimationKit__26, v140, v146).ID);
                    v151.Priority = u3.AnimationPriority.Idle;
                    v151.Looped = true;
                    l___animationCache__22[v150] = v151;
                end;
                local v152 = string.format("%s_%s_%s", l__AnimationKit__26, v140, v147);
                if not l___animationCache__22[v152] then
                    local v153 = p122:LoadAnimation(u2:Get("Animation", "ZombiePacks", l__AnimationKit__26, v140, v147).ID);
                    v153.Priority = u3.AnimationPriority.Idle;
                    v153.Looped = true;
                    l___animationCache__22[v152] = v153;
                end;
                local v154 = l___animationCache__22[v150];
                local v155 = l___animationCache__22[v152];
                for _, v156 in l___animationCache__22 do
                    local v157 = (v156 == v154 or v156 == v155) and true or v156 == p122._lastIdleTrack;
                    if v156.IsPlaying and not v157 then
                        v156:AdjustWeight(0);
                        v156:Stop(0);
                    elseif not v156.IsPlaying and v157 then
                        v156:Play(0, 0, 0);
                    end;
                end;
                local l__Asset__27 = u2:Get("Animation", "ZombiePacks", l__AnimationKit__26, v140, "N").Asset;
                local v158 = p122._animationCycle + p125 * (v137 / l__Asset__27.Speed);
                p122._animationCycle = v158;
                p122.Tilt = v144 * (v137 / l__Asset__27.Speed);
                local v159 = v158 % l__Asset__27.Duration;
                v154.TimePosition = v159;
                v155.TimePosition = v159;
                local v160 = v159 / l__Asset__27.Duration;
                local v161 = p122.Health.Ability == 4 and "Sprint" or v140;
                p122.Cycle = v160 * 3.141592653589793 * 4;
                if v127 <= 2 then
                    if v160 > 0.5 then
                        if p122._footStep then
                            p122._footStep = false;
                            p122:_doFootstep(v161, p122.Parts.RightLowerLeg);
                        end;
                    elseif not p122._footStep then
                        p122._footStep = true;
                        p122:_doFootstep(v161, p122.Parts.LeftLowerLeg);
                    end;
                end;
                local v162 = math.clamp(v158, 0, 0.2) * 5;
                v154:AdjustWeight((1 - v149) * v162, 0);
                v155:AdjustWeight(v149 * v162, 0);
                p122._trackFrom = v154;
                p122._trackTo = v155;
                if p122._lastIdleTrack then
                    p122._lastIdleTrack:AdjustWeight(1 - v162, 0);
                end;
            else
                p122._animationCycle = 0;
                p122._animationStill = true;
                local v163 = string.format("%s_%s_%s", l__AnimationKit__26, "Idle", v139);
                local v164 = u2:Get("Animation", "ZombiePacks", l__AnimationKit__26, "Idle", v139);
                local l__Is360__28 = v164.Asset.Is360;
                if not l___animationCache__22[v163] then
                    local v165 = p122:LoadAnimation(v164.ID);
                    v165.Priority = u3.AnimationPriority.Core;
                    v165.Looped = not l__Is360__28;
                    l___animationCache__22[v163] = v165;
                end;
                local v166 = l___animationCache__22[v163];
                for _, v167 in l___animationCache__22 do
                    if v167 ~= p122._trackFrom and v167 ~= p122._trackTo and v167 ~= v166 and v167.IsPlaying then
                        v167:Stop(0);
                    end;
                end;
                if not v166.IsPlaying then
                    v166:Play(0, 0, l__Is360__28 and 0 or 1);
                end;
                v166:AdjustWeight(u12.Lerp(v166.WeightCurrent, 1, u4(p125 * 10)), 0);
                if p122._trackFrom then
                    p122._trackFrom:AdjustWeight(u12.Lerp(p122._trackFrom.WeightCurrent, 0, u4(p125 * 10)), 0);
                end;
                if p122._trackTo then
                    p122._trackTo:AdjustWeight(u12.Lerp(p122._trackTo.WeightCurrent, 0, u4(p125 * 10)), 0);
                end;
                if l__Is360__28 then
                    local l__Length__29 = v164.Asset.Length;
                    local _, v168 = v132:ToOrientation();
                    v166.TimePosition = l__Length__29 - (p122.CameraX - v168) % 6.283185307179586 / 6.283185307179586 * l__Length__29;
                end;
                p122._lastIdleTrack = v166;
            end;
            p122.Walking = v138;
        end;
        local l__Focused__30 = p122.Focused;
        local l___loaded__31 = p122._loaded;
        local v169 = not l__Focused__30;
        if v169 then
            if l___loaded__31 then
                l___loaded__31 = v128;
            end;
        else
            l___loaded__31 = v169;
        end;
        if l___loaded__31 and p122._isInactive then
            p122._isInactive = false;
            p122.Character.Parent = workspace;
        elseif not (l___loaded__31 or p122._isInactive) then
            p122._isInactive = true;
            p122.Character.Parent = l__InactiveWorld__3;
        end;
        p122._heightDifference = u12.Lerp(p122._heightDifference, 0, u4(p125 * 5));
        local v170 = v132 + Vector3.new(0, p122._heightDifference, 0);
        p122.CFrame = v170;
        p122.UseClient = v130 and v128;
        if p122.UseClient then
            return v170, p122.RootPart;
        end;
    else
        if p122._death < 1 then
            local v171 = u12.Lerp(p122._death, 1, p125 * 10);
            p122._death = math.clamp(v171, 0, 1);
            p122.Parts.Eyes.Color = Color3.fromRGB(248, 248, 248):Lerp(Color3.fromRGB(83, 83, 83), p122._death);
        end;
    end;
end;
function u18.Voice(u172, p173, p174) --[[ Line: 892 ]]
    -- upvalues: u5 (copy)
    if u172._isInactive or not (u172.UseClient and u172.Alive) then
    else
        if u172._currentVoiceLine then
            u172._currentVoiceLine[1].FadeOut(0.2);
            task.cancel(u172._currentVoiceLine[2]);
        end;
        local u175 = u5:CreateSound("Z_Chatter", u172:_getHead(), true, "Voicelines", p173, p174);
        u172._currentVoiceLine = { u175, task.delay((u175.Duration or 2) + 0.5, function() --[[ Line: 903 ]]
                -- upvalues: u172 (copy), u175 (copy)
                u172._currentVoiceLine = nil;
                u175.Destroy();
            end) };
    end;
end;
function u18.Render(_) --[[ Line: 909 ]] end;
function u18.Stepped(p176) --[[ Line: 912 ]]
    -- upvalues: l__CurrentCamera__2 (copy)
    local _, v177 = l__CurrentCamera__2:WorldToViewportPoint(p176.ServerPosition);
    p176.ViewportOnScreen = v177;
end;
function u18.Destroy(p178) --[[ Line: 917 ]]
    -- upvalues: u7 (copy)
    p178.Character:Destroy();
    u7:Print("Destroyed zombie (SERVER)", Color3.new(0.435294, 0.694117, 0.635294));
end;
return u18;