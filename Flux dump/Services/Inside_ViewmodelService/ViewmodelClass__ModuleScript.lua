-- Services.ViewmodelService.ViewmodelClass
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4, u5, u6 = shared.import("require", "asset", "Enum", "React", "ReactRoblox", "frc");
local u7 = v1("PostProcessingService");
local v8 = v1("WorldService");
local u9 = v1("ReticleService");
local u10 = v1("SoundService");
local u11 = v1("InputService");
local u12 = v1("QuaternionBetter");
local u13 = v1("SpringQuaternion");
local u14 = v1("OverlayInterface");
local u15 = v1("NVGComponent");
local u16 = v1("Menu");
local u17 = v1("Mathf");
local u18 = v1("Spring");
local u19 = v1("Recoiler");
local l__InactiveWorld__1 = v8.InactiveWorld;
local l__CurrentCamera__2 = workspace.CurrentCamera;
local u20 = CFrame.new(-0.05, 0, 0);
local u21 = CFrame.new(0, 0, 5);
local u22 = {};
u22.__index = u22;
function u22._updateFlash(p23, p24) --[[ Line: 30 ]]
    -- upvalues: u10 (copy)
    local l___flashTrack__3 = p23._flashTrack;
    if p24 > 0.9 then
        if not l___flashTrack__3.IsPlaying then
            l___flashTrack__3:Play(0.2);
        end;
    elseif l___flashTrack__3.IsPlaying then
        l___flashTrack__3:Stop(0.5);
    end;
    local l___flashBloom__4 = p23._flashBloom;
    l___flashBloom__4.Intensity = p24 * 2;
    l___flashBloom__4.Size = p24 * 20;
    l___flashBloom__4.Threshold = 4 - p24 * 4;
    p23._flashBlur.Size = p24 * 40;
    u10:SetEffectMix("Flash", p24);
end;
function u22._setLUT(p25, p26, p27) --[[ Line: 48 ]]
    -- upvalues: u7 (copy), u4 (copy), u15 (copy)
    if p25._vfx then
        for _, v28 in p25._vfx do
            v28.Destroy();
        end;
        p25._vfx = nil;
    end;
    if p26 then
        local v29 = p26.Presets[p27];
        local v30 = {};
        local l__Bloom__5 = v29.Bloom;
        if l__Bloom__5 then
            v30.Bloom = u7:AddBloom({
                Intensity = l__Bloom__5.Intensity,
                Size = l__Bloom__5.Size,
                Threshold = l__Bloom__5.Threshold
            }, nil, true);
        end;
        local l__Brightness__6 = v29.Brightness;
        if l__Brightness__6 then
            v30.Brightness = u7:AddBrightness({
                Size = l__Brightness__6
            }, nil, true);
        end;
        local l__Exposure__7 = v29.Exposure;
        if l__Exposure__7 then
            v30.Exposure = u7:AddExposure({
                Size = l__Exposure__7
            }, nil, true);
        end;
        local l__ColorCorrection__8 = v29.ColorCorrection;
        if l__ColorCorrection__8 then
            v30.ColorCorrection = u7:AddColorCorrection({
                Brightness = l__ColorCorrection__8.Brightness,
                Contrast = l__ColorCorrection__8.Contrast,
                Saturation = l__ColorCorrection__8.Saturation,
                TintColor = l__ColorCorrection__8.TintColor
            }, -1, true);
        end;
        local l__DepthOfField__9 = v29.DepthOfField;
        if l__DepthOfField__9 then
            v30.DepthOfField = u7:AddDepthOfField({
                FarIntensity = l__DepthOfField__9.FarIntensity,
                FocusDistance = l__DepthOfField__9.FocusDistance,
                InFocusRadius = l__DepthOfField__9.InFocusRadius,
                NearIntensity = l__DepthOfField__9.NearIntensity,
                AutoFocus = l__DepthOfField__9.AutoFocus
            }, 2, true);
        end;
        local l__Blur__10 = v29.Blur;
        if l__Blur__10 then
            v30.Blur = u7:AddBlur({
                Size = l__Blur__10
            }, nil, true);
        end;
        p25.NVGFOV = v29.FOV or 0;
        p25._vfx = v30;
        u7.Ambient = v29.Ambient;
        p25._uiRoot:render(u4.createElement(u15, {
            Cover = p25._nvgCover,
            Config = p26,
            Preset = v29
        }));
    else
        p25.NVGFOV = nil;
        u7.Ambient = nil;
        p25._uiRoot:render(u4.createElement(u15, {
            Cover = p25._nvgCover
        }));
    end;
end;
function u22._setUniform(p31, p32) --[[ Line: 137 ]]
    -- upvalues: u2 (copy), u16 (copy)
    if p31._leftSleeve then
        p31._leftSleeve:Destroy();
        p31._leftSleeve = nil;
    end;
    if p31._rightSleeve then
        p31._rightSleeve:Destroy();
        p31._rightSleeve = nil;
    end;
    p31._currentShirt = p32;
    if p32 then
        local l__Asset__11 = u2:Get("Shared", "Models", "Outfit", "ShirtTransparent", p32).Asset;
        local l__SleeveL__12 = u16.Character.Shirt[p32].SleeveL;
        if l__SleeveL__12 then
            local v33 = u2:Get("Shared", "Models", "Character", "Arm", "Sleeve", l__SleeveL__12, "L").Asset:Clone();
            v33.CastShadow = false;
            v33.Color = Color3.new(0, 0, 0);
            local l__Anchor__13 = v33:WaitForChild("Anchor");
            local v34 = Instance.new("Weld");
            v34.Part0 = p31._leftArm;
            v34.Part1 = v33;
            v34.C1 = l__Anchor__13.CFrame;
            v34.Parent = v33;
            l__Asset__11:Clone().Parent = v33;
            v33.Parent = p31._container;
            p31._leftSleeve = v33;
        end;
        p31._leftSleeveName = l__SleeveL__12;
        local l__SleeveR__14 = u16.Character.Shirt[p32].SleeveR;
        if l__SleeveR__14 then
            local v35 = u2:Get("Shared", "Models", "Character", "Arm", "Sleeve", l__SleeveR__14, "R").Asset:Clone();
            v35.CastShadow = false;
            v35.Color = Color3.new(0, 0, 0);
            local l__Anchor__15 = v35:WaitForChild("Anchor");
            local v36 = Instance.new("Weld");
            v36.Part0 = p31._rightArm;
            v36.Part1 = v35;
            v36.C1 = l__Anchor__15.CFrame;
            v36.Parent = v35;
            l__Asset__11:Clone().Parent = v35;
            v35.Parent = p31._container;
            p31._rightSleeve = v35;
        end;
        p31:_setWrist(p31._currentWrist);
    end;
end;
function u22._setGloves(p37, p38) --[[ Line: 190 ]]
    -- upvalues: u16 (copy), u2 (copy)
    p37._currentGloves = p38;
    if p37._leftGlove then
        p37._leftGlove:Destroy();
        p37._leftGlove = nil;
    end;
    if p37._rightGlove then
        p37._rightGlove:Destroy();
        p37._rightGlove = nil;
    end;
    if p38 then
        local v39 = p38[2].Build[1][3];
        local l__Texture__16 = u16.Character.Gloves[v39].Camos[p38[2].Build[2].Camo or "Default"].Texture;
        local v40 = u2:Get("Shared", "Models", "Character", "Arm", "Gloves", v39, "FP", "L").Asset:Clone();
        v40.CastShadow = false;
        v40.Color = Color3.new(0, 0, 0);
        v40.TextureID = l__Texture__16;
        local l__Anchor__17 = v40:WaitForChild("Anchor");
        local v41 = Instance.new("Weld");
        v41.Part0 = p37._leftArm;
        v41.Part1 = v40;
        v41.C1 = l__Anchor__17.CFrame;
        v41.Parent = v40;
        v40.Parent = p37._container;
        p37._leftGlove = v40;
        local v42 = u2:Get("Shared", "Models", "Character", "Arm", "Gloves", v39, "FP", "R").Asset:Clone();
        v42.CastShadow = false;
        v42.Color = Color3.new(0, 0, 0);
        v42.TextureID = l__Texture__16;
        local l__Anchor__18 = v42:WaitForChild("Anchor");
        local v43 = Instance.new("Weld");
        v43.Part0 = p37._rightArm;
        v43.Part1 = v42;
        v43.C1 = l__Anchor__18.CFrame;
        v43.Parent = v42;
        v42.Parent = p37._container;
        p37._rightGlove = v42;
    end;
end;
function u22._setWrist(p44, p45) --[[ Line: 234 ]]
    -- upvalues: u16 (copy), u2 (copy)
    p44._currentWrist = p45;
    if p44._wrist then
        p44._wrist:Destroy();
    end;
    if p45 then
        local v46 = p45[2].Build[1][4];
        local l__Texture__19 = u16.Character.Wrist.Wrist[v46].Camos[p45[2].Build[2].Camo or "Default"].Texture;
        local v47 = u2:Get("Shared", "Models", "Character", "Arm", "Wrist", v46, "FP").Asset:Clone();
        v47.CastShadow = false;
        v47.TextureID = l__Texture__19;
        local l__anchor__20 = v47:WaitForChild("anchor");
        local v48 = Instance.new("Weld");
        v48.Part0 = p44._leftArm;
        v48.Part1 = v47;
        v48.C1 = l__anchor__20.CFrame;
        v48.Parent = v47;
        v47.Parent = p44._container;
        p44._wrist = v47;
    end;
end;
function u22._setSprint(p49, p50) --[[ Line: 260 ]]
    -- upvalues: u3 (copy)
    if p49._sprintTrack then
        p49._sprintTrack.Animation:Stop();
        p49._sprintTrack = nil;
    end;
    local v51 = p50 or 95297548199770;
    p49._sprintID = v51;
    if v51 then
        local v52 = p49:LoadAnimation(v51);
        v52.Priority = u3.AnimationPriority.Action2;
        v52:Play(0, 0, 0);
        p49._sprintTrack = {
            Duration = 0.6666666666666666,
            Animation = v52
        };
    end;
end;
function u22._setCompass(p53, p54) --[[ Line: 281 ]]
    -- upvalues: u2 (copy), u3 (copy)
    p53._currentCompass = p54;
    if p54 then
        local v55 = u2:Get("Shared", "Models", "Junk", "Compass").Asset:Clone();
        v55.Parent = p53._container;
        local v56 = Instance.new("Weld");
        v56.Part0 = p53._leftArm;
        v56.Part1 = v55.PrimaryPart;
        v56.C1 = v55.PrimaryPart.FPAnchor.CFrame;
        v56.Parent = v55;
        p53._compassModel = v55;
        p53._compassRotate = v55.PrimaryPart.Spin;
        local v57 = p53:LoadAnimation(86519942990745);
        v57.Priority = u3.AnimationPriority.Action3;
        v57:Play(0.3);
        p53._compassAnimation = v57;
    else
        if p53._compassModel then
            if p53._compassAnimation then
                p53._compassAnimation:Stop(0.3);
                p53._compassAnimation = nil;
            end;
            if p53._compassModel then
                p53._compassModel:Destroy();
                p53._compassModel = nil;
            end;
            p53._compassRotate = nil;
        end;
    end;
end;
function u22.new(p58, p59) --[[ Line: 314 ]]
    -- upvalues: u2 (copy), u3 (copy), u7 (copy), u4 (copy), u5 (copy), u19 (copy), u18 (copy), l__CurrentCamera__2 (copy), u13 (copy), u12 (copy), u22 (copy), l__InactiveWorld__1 (copy)
    local l__Asset__21 = u2:Get("Shared", "Models", "Character", "Arm", "Base").Asset;
    local v60 = Instance.new("WorldModel");
    local l__SkinColor__22 = p58.SkinColor;
    local v61 = Instance.new("Humanoid");
    v61.DisplayDistanceType = u3.HumanoidDisplayDistanceType.None;
    v61.EvaluateStateMachine = false;
    v61.RequiresNeck = false;
    v61.BreakJointsOnDeath = false;
    v61.Parent = v60;
    local v62 = Instance.new("Model");
    local v63 = Instance.new("Part");
    v63.Name = "Root";
    v63.Transparency = 1;
    v63.Size = Vector3.new(1, 1, 1);
    v63.Anchored = true;
    v63.CanCollide = false;
    v63.Parent = v62;
    v60.PrimaryPart = v63;
    local v64 = l__Asset__21:Clone();
    v64.Name = "Left";
    v64.CastShadow = false;
    v64.Color = l__SkinColor__22;
    v64.Parent = v62;
    local v65 = Instance.new("Motor6D");
    v65.Name = "LA";
    v65.Part0 = v63;
    v65.Part1 = v64;
    v65.C1 = CFrame.new(-0.05, 0, 0.05);
    v65.C0 = CFrame.new(-1, -1, 1);
    v65.Parent = v64;
    local v66 = l__Asset__21:Clone();
    v66.Name = "Right";
    v66.CastShadow = false;
    v66.Color = l__SkinColor__22;
    v66.Parent = v62;
    local v67 = Instance.new("Motor6D");
    v67.Name = "RA";
    v67.Part0 = v63;
    v67.Part1 = v66;
    v67.C1 = CFrame.new(0.05, 0, 0.05);
    v67.C0 = CFrame.new(1, -1, 1);
    v67.Parent = v66;
    local v68 = Instance.new("Part");
    v68.Name = "Cam";
    v68.Transparency = 1;
    v68.Size = Vector3.new(0.5, 0.5, 0.5);
    v68.Anchored = false;
    v68.CanCollide = false;
    v68.Parent = v62;
    local v69 = Instance.new("Motor6D");
    v69.Name = "CAM";
    v69.Part0 = v63;
    v69.Part1 = v68;
    v69.Parent = v68;
    local v70 = Instance.new("AnimationController");
    v70.Parent = v62;
    local v71 = Instance.new("Animator");
    v71.Parent = v70;
    v62.Parent = v60;
    local v72 = RaycastParams.new();
    v72.CollisionGroup = u3.PhysicsGroup.BulletCast;
    v72.IgnoreWater = true;
    local v73 = u7:AddBlur({
        Size = 0
    }, nil, true);
    local v74 = u7:AddBloom({
        Intensity = 0,
        Size = 0,
        Threshold = 4
    }, nil, true);
    local v75, v76 = u4.createBinding(1);
    local v77 = u5.createRoot(p59);
    local v78 = {
        FollowWorldModel = false,
        Offset = v69,
        Root = v63,
        Recoil = u19.new("VM"),
        Reloading = false,
        CQB = 0,
        Actor = p58,
        Active = false,
        Jump = u18.new(0),
        ADSLerp = 0,
        SprintLerp = 0,
        Kick = u18.new(Vector3.new(0, 0, 0)),
        _aiming = false,
        _nvgCover = v75,
        _nvgSetCover = v76,
        _flashLerp = 0,
        _flashBlur = v73,
        _flashBloom = v74,
        _last = l__CurrentCamera__2.CFrame,
        _offset = l__Asset__21.Size.Y / 2,
        _params = v72,
        _adsLast = CFrame.new(),
        _walkLerp = 0,
        _tiltLerp = 0,
        _swayLerp = CFrame.new(),
        _cqbLerp = CFrame.new(),
        _firearmTiltLerp = CFrame.new(),
        _uiRoot = v77,
        _reticles = {},
        _cutaways = {},
        _leftArmGoal = 0,
        _animationKit = "",
        _swaySpring = u13.new(u12.fromCFrame(CFrame.new()), 0.8, 10),
        _leftArm = v64,
        _leftArmMotor = v65,
        _rightArm = v66,
        _rightArmMotor = v67,
        _container = v62,
        WorldModel = v60,
        _animator = v71,
        _loadedAnimations = {},
        _followWorldModel = false
    };
    local v79 = setmetatable(v78, u22);
    v79.Kick.Speed = 30;
    v79.Kick.Damper = 0.5;
    v79.Jump.Speed = 10;
    v79.Jump.Damper = 1;
    p58.ViewModel = v79;
    v79:_setLUT();
    v79:_setUniform(p58.CurrentState.Shirt);
    v79:_setGloves(p58.CurrentState.Gloves);
    v60.Parent = l__InactiveWorld__1;
    v79:_setSprint();
    local v80 = v79:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Flashed", "FP").ID);
    v80.Priority = u3.AnimationPriority.Action;
    v79._flashTrack = v80;
    return v79;
end;
function u22.SetModel(p81, p82, p83, p84, p85) --[[ Line: 482 ]]
    -- upvalues: u9 (copy), u21 (copy), u3 (copy)
    if p81.CurrentModel then
        p81.CurrentModel:Destroy();
        p81.CurrentModel = nil;
        p81._tpModel = nil;
        p81._currentMotor = nil;
        p81._useAnchor = nil;
        for _, v86 in p81._reticles do
            u9:UnregisterReticle(v86);
        end;
        p81._cutaways = {};
        p81._reticles = {};
    end;
    if p81._idleTrack then
        p81._idleTrack:Stop(0);
        p81._idleTrack = nil;
    end;
    if p81._equipTrack then
        p81._equipTrack:Stop(0);
        p81._equipTrack = nil;
    end;
    if p82 then
        local v87;
        if typeof(p82) == "table" then
            v87 = p82[1];
            p81._tpModel = p82[2];
        else
            v87 = p82:Clone();
            p81._tpModel = p82;
        end;
        local v88 = Instance.new("Motor6D");
        v88.Name = "WEP";
        v88.Part0 = p81.Root;
        v88.Part1 = v87.PrimaryPart;
        v88.C0 = u21;
        if p85 then
            v88.C1 = p85;
            p81._useAnchor = p85;
        end;
        for _, v89 in v87:GetDescendants() do
            if v89:IsA("BasePart") then
                v89.CastShadow = false;
                v89.CanCollide = false;
                v89.AudioCanCollide = false;
                v89.CanQuery = false;
                v89.CanTouch = false;
                v89.Anchored = false;
            end;
        end;
        v88.Parent = v87;
        v87.Parent = p81._container;
        p81.CurrentModel = v87;
        p81._currentMotor = v88;
        p81._needsSet = true;
        if p83 then
            local v90 = p81:LoadAnimation(p83);
            v90.Looped = true;
            v90.Priority = u3.AnimationPriority.Core;
            v90:Play(0);
            p81._idleTrack = v90;
        end;
        if p84 then
            local v91 = p81:LoadAnimation(p84);
            v91.Looped = false;
            v91.Priority = u3.AnimationPriority.Idle;
            v91:Play(0);
            p81._equipTrack = v91;
        end;
        return p81._idleTrack, v87, p81._equipTrack;
    end;
end;
function u22.AddCutaway(p92, p93, p94, p95, p96, p97) --[[ Line: 561 ]]
    local v98 = {};
    for _, v99 in p94 do
        local v100 = p93:FindFirstChild(v99);
        if v100 then
            v98[v100] = v100.Transparency;
        end;
    end;
    local v101 = {};
    for _, v102 in p95 do
        local v103 = p93:FindFirstChild(v102);
        if v103 then
            v101[v103] = true;
        end;
    end;
    p92._cutaways[#p92._cutaways + 1] = {
        Magnifier = p96,
        Inverted = p97,
        CutawaysInverted = v101,
        Cutaways = v98
    };
end;
function u22.AddReticle(p104, p105, p106, p107) --[[ Line: 590 ]]
    -- upvalues: u9 (copy)
    p104._reticles[#p104._reticles + 1] = u9:RegisterReticle(p105, p106, p107);
end;
function u22.AddModel(p108, p109, p110) --[[ Line: 594 ]]
    local v111 = p109:IsA("BasePart") and p109 and p109 or p109.PrimaryPart;
    local v112 = Instance.new("Motor6D");
    v112.Name = "WEP";
    v112.Part0 = p108.Root;
    v112.Part1 = v111;
    v112.C0 = p110 or CFrame.new(0, 0, 5);
    v112.Parent = p109;
    p109.Parent = p108._container;
end;
function u22.LoadAnimation(u113, p114) --[[ Line: 605 ]]
    local v115 = u113._loadedAnimations[p114];
    if v115 then
        return v115;
    end;
    local v116 = Instance.new("Animation");
    v116.AnimationId = "rbxassetid://" .. p114;
    local v117 = u113._animator:LoadAnimation(v116);
    v117:GetMarkerReachedSignal("MagFake"):Connect(function(p118) --[[ Line: 615 ]]
        -- upvalues: u113 (copy)
        if p118 == "0" then
            if u113._fakeMag then
                u113._fakeMag:Destroy();
                u113._fakeMag = nil;
            end;
        elseif not u113._fakeMag then
            local l__CurrentModel__23 = u113.CurrentModel;
            if not l__CurrentModel__23 then
                return;
            end;
            local v119 = l__CurrentModel__23:FindFirstChild("Mag");
            if not v119 then
                return;
            end;
            local v120 = v119:Clone();
            for _, v121 in v120:GetDescendants() do
                v121.Name = v121.Name .. "fake";
            end;
            v120.Parent = l__CurrentModel__23;
            u113._fakeMag = v120;
        end;
    end);
    u113._loadedAnimations[p114] = v117;
    return v117;
end;
function u22.Update(p122, p123) --[[ Line: 646 ]]
    -- upvalues: l__CurrentCamera__2 (copy), u14 (copy), u17 (copy), u6 (copy), u20 (copy), u21 (copy), u10 (copy), u12 (copy), u3 (copy), u11 (copy), l__InactiveWorld__1 (copy), u9 (copy)
    local l__Actor__24 = p122.Actor;
    if p122._currentShirt ~= l__Actor__24.CurrentState.Shirt then
        p122:_setUniform(l__Actor__24.CurrentState.Shirt);
    end;
    if p122._currentGloves ~= l__Actor__24.CurrentState.Gloves then
        p122:_setGloves(l__Actor__24.CurrentState.Gloves);
    end;
    if p122._currentWrist ~= l__Actor__24.CurrentState.Wrist then
        p122:_setWrist(l__Actor__24.CurrentState.Wrist);
    end;
    if p122._currentCompass ~= l__Actor__24.CurrentState.Compass then
        p122:_setCompass(l__Actor__24.CurrentState.Compass);
    end;
    if p122.SprintID ~= p122._sprintID then
        p122:_setSprint(p122.SprintID);
    end;
    local l__CFrame__25 = l__CurrentCamera__2.CFrame;
    local v124 = p122.FollowWorldModel or (l__Actor__24.LockPicking or l__Actor__24.Rappelling or (l__Actor__24.Locked or l__Actor__24.CurrentState.Dragging));
    p122._followWorldModel = v124;
    local v125 = tick();
    local v126 = not u14.Handle;
    if v126 then
        v126 = l__Actor__24.Helmet;
    end;
    local l___nvgLUT__26 = p122._nvgLUT;
    local l___nvgTube__27 = p122._nvgTube;
    local v127;
    if v126 then
        if v126.NVGCover > 0.99 then
            v127 = v126.NVGActive;
        else
            v127 = false;
        end;
    else
        v127 = v126;
    end;
    if v127 then
        if not p122._nvgTimer then
            p122._nvgTimer = v125;
            p122._nvgFade = 1;
        end;
        if v125 - p122._nvgTimer > 0.1 then
            p122._nvgFade = u17.Lerp(p122._nvgFade, 0, u6(p123 * v126.NVGFade));
        end;
        l___nvgLUT__26 = v126.Tube;
        l___nvgTube__27 = v126.TubePreset;
    else
        if p122._nvgFade then
            v127 = true;
            p122._nvgFade = u17.Lerp(p122._nvgFade, 1, u6(p123 * 15));
            if p122._nvgFade > 0.98 then
                p122._nvgFade = nil;
            end;
        else
            l___nvgLUT__26 = nil;
            l___nvgTube__27 = nil;
        end;
        p122._nvgTimer = nil;
    end;
    p122.NVG = v127;
    if p122._nvgLUT ~= l___nvgLUT__26 or p122._nvgTube ~= l___nvgTube__27 then
        local v128;
        if v126 then
            v128 = v126.TubePreset;
        else
            v128 = v126;
        end;
        p122:_setLUT(l___nvgLUT__26, v128);
        p122._nvgLUT = l___nvgLUT__26;
        p122._nvgTube = l___nvgTube__27;
    end;
    p122._nvgSetCover(1 - (p122._nvgFade or (v126 and v126.NVGCover or 0)));
    local l___vfx__28 = p122._vfx;
    if l___vfx__28 then
        l___vfx__28 = p122._vfx.DepthOfField;
    end;
    local v129 = l___vfx__28 and l___vfx__28.AutoFocus;
    if v129 then
        local l__Max__29 = v129.Max;
        local l__Position__30 = l__CurrentCamera__2.CFrame.Position;
        local v130 = workspace:Raycast(l__Position__30, l__CurrentCamera__2.CFrame.LookVector * l__Max__29, p122._params);
        if v130 then
            l__Max__29 = math.clamp((v130.Position - l__Position__30).Magnitude, v129.Min, l__Max__29);
        end;
        l___vfx__28.FocusDistance = u17.Lerp(l___vfx__28.FocusDistance, l__Max__29, u6(p123 * v129.Speed));
    end;
    if l__Actor__24.LastFlash and v125 < l__Actor__24.LastFlash then
        p122._flashLerp = 1;
        p122:_updateFlash(1);
    elseif p122._flashLerp > 0 then
        local v131 = math.max(0, p122._flashLerp - p123 / 4);
        p122._flashLerp = v131;
        p122:_updateFlash(v131);
    end;
    if v124 then
        local l__CFrame__31 = l__Actor__24.Parts.Head.CFrame;
        local l___offset__32 = p122._offset;
        local l__CFrame__33 = l__Actor__24.Parts.UpperTorso.CFrame;
        local l__Position__34 = l__CFrame__33:ToWorldSpace(CFrame.new(1, -0.5, 0)).Position;
        local v132 = l__Actor__24.Parts.RightHand.CFrame:PointToWorldSpace(Vector3.new(-0.25, -0.25, 0));
        local v133 = (l__Position__34 - v132).Magnitude - l___offset__32;
        local v134 = CFrame.new(l__Position__34, v132);
        local l__Position__35 = l__CFrame__33:ToWorldSpace(CFrame.new(-1, -0.5, 0)).Position;
        local v135 = l__Actor__24.Parts.LeftHand.CFrame:PointToWorldSpace(Vector3.new(0.25, -0.25, 0));
        local v136 = (l__Position__35 - v135).Magnitude - l___offset__32;
        local v137 = CFrame.new(l__Position__35, v135);
        p122._rightArmMotor.C0 = l__CFrame__31:ToObjectSpace(v134 + v134.LookVector * v133) * CFrame.Angles(1.5707963267948966, 0, 0);
        p122._leftArmMotor.C0 = l__CFrame__31:ToObjectSpace(v137 + v137.LookVector * v136) * CFrame.Angles(1.5707963267948966, 0, 0);
        local l___currentMotor__36 = p122._currentMotor;
        if l___currentMotor__36 and p122._tpModel then
            p122._needsSet = true;
            l___currentMotor__36.C0 = p122._tpModel.PrimaryPart.CFrame:ToObjectSpace(l__CFrame__31):Inverse();
            l___currentMotor__36.C1 = CFrame.new();
        end;
        p122.Root.CFrame = l__CFrame__31;
    else
        local v138 = l__CFrame__25 * u20;
        local l__CurrentModel__37 = p122.CurrentModel;
        local l__HeightState__38 = l__Actor__24.HeightState;
        local l___currentMotor__39 = p122._currentMotor;
        if l___currentMotor__39 and p122._needsSet then
            p122._needsSet = nil;
            l___currentMotor__39.C0 = u21;
            l___currentMotor__39.C1 = p122._useAnchor or CFrame.new();
        end;
        local l__Walking__40 = l__Actor__24.Walking;
        local l__Sprinting__41 = l__Actor__24.Sprinting;
        local l__ADS__42 = l__Actor__24.ADS;
        local l__CQB__43 = l__Actor__24.CQB;
        if l__ADS__42 then
            if p122.ADSOffset then
                p122._adsLast = p122.Root.CFrame:ToObjectSpace((p122.Root.CFrame * u21 * p122.ADSOffset):ToWorldSpace(l__ADS__42)):Inverse();
            else
                p122._adsLast = p122.Root.CFrame:ToObjectSpace(l__CurrentModel__37.PrimaryPart.CFrame:ToWorldSpace(l__ADS__42)):Inverse();
            end;
        end;
        local v139 = l__ADS__42 and not p122.Reloading;
        if v139 then
            v139 = not l__Actor__24.Sliding;
        end;
        p122.ADSLerp = u17.Lerp(p122.ADSLerp, v139 and 1 or 0, u6(p123 * (250 / (p122.Weight or 1)) * 100 * (p122.ADSSpeed or 1)));
        p122._tiltLerp = u17.Lerp(p122._tiltLerp, math.clamp((not l__Walking__40 or l__ADS__42) and 0 or l__Actor__24.Tilt * 10, -10, 10), u6(p123 * 5));
        p122.CQB = u17.Lerp(p122.CQB, l__Actor__24.CQB and 1 or 0, u6(p123 * 5));
        local v140;
        if v139 then
            v140 = not p122._aiming;
        else
            v140 = v139;
        end;
        local v141 = not v139;
        if v141 then
            v141 = p122._aiming;
        end;
        if v140 or v141 then
            local v142 = u10;
            local v143 = "Weapon_Interaction";
            local v144 = not l__Actor__24.Focused;
            if v144 then
                v144 = l__Actor__24.Parts.Head;
            end;
            v142:CreateSound(v143, v144, true, "Foley", "Weapon", "ADS", v140 and "In" or "Out").Destroy(1);
        end;
        p122._aiming = v139;
        local v145 = p122.Recoil:GetViewmodelAdjustment(p123, p122.ADSLerp);
        p122._swaySpring.Target = u12.fromCFrame(l__CFrame__25:ToObjectSpace(p122._last));
        local v146, v147 = p122._swaySpring.Position:ToCFrame():ToOrientation();
        local l__Angles__44 = CFrame.Angles;
        local v148 = math.clamp(-v146, -1, 1);
        local v149 = math.rad(v148 * (l__ADS__42 and 50 or 70));
        local v150 = math.clamp(-v147, -1, 1);
        local v151 = v138 * l__Angles__44(v149, math.rad(v150 * (l__ADS__42 and 50 or 70)), 0) * v145 * CFrame.new():Lerp(CFrame.new(-0.1, 0, 0.2), p122.CQB * (1 - p122.ADSLerp)) * CFrame.new():Lerp(u20:Inverse() * p122._adsLast, p122.ADSLerp) * CFrame.Angles(0, 0, (math.rad(p122._tiltLerp)));
        local v152 = -p122.Kick.Position;
        if not v139 then
            v152 = v152 * 1.5;
        end;
        local v153 = v152 * (l__CurrentCamera__2.FieldOfView / 70);
        local v154 = v151 * (CFrame.new(0, -v153.X * 2, 0) * CFrame.Angles(0, 0, v153.Y));
        local v155 = l__CQB__43 and p122.Reloading and 0 or l__CQB__43;
        p122._cqbLerp = p122._cqbLerp:Lerp(v155 == 1 and CFrame.new(0.2, -1.5, 0) * CFrame.Angles(0.5235987755982988, 0.4363323129985824, 1.0471975511965976) or (v155 == 2 and CFrame.new(0.3, -1.7, 0) * CFrame.Angles(1.2217304763960306, 0, 0) or v155 == -1 and CFrame.new(0, 0.1, 0) * CFrame.Angles(-0.4363323129985824, 0, 0) or ((p122._blocked or v155 == -2) and CFrame.new(-0.1, -0.5, 0) * CFrame.Angles(-0.3490658503988659, 0.4363323129985824, 1.0471975511965976) or CFrame.new())), u6(p123 * 10));
        local v156 = v154 * p122._cqbLerp;
        local l__ProneDelay__45 = l__Actor__24.ProneDelay;
        if l__ProneDelay__45 then
            l__ProneDelay__45 = v125 < l__Actor__24.ProneDelay;
        end;
        local v157 = l__Sprinting__41 and (not l__ADS__42 and (not v155 or v155 == 0)) and not p122.Reloading or (l__Actor__24.Sliding or l__ProneDelay__45);
        p122._walkLerp = u17.Lerp(p122._walkLerp, l__Walking__40 and not v157 and 0 or 1, u6(p123 * 10));
        p122.SprintLerp = u17.Lerp(p122.SprintLerp, v157 and 0 or 1, u6(p123 * 6));
        local l__Cycle__46 = l__Actor__24.Cycle;
        local l___sprintTrack__47 = p122._sprintTrack;
        if l___sprintTrack__47 then
            l___sprintTrack__47.Animation.TimePosition = l__Cycle__46 / 12.566370614359172 * l___sprintTrack__47.Duration;
            l___sprintTrack__47.Animation:AdjustWeight(math.clamp(1 - p122.SprintLerp, 0.01, 1), 0);
        end;
        local v158 = CFrame.new(math.sin(l__Cycle__46 / 2) / 30 * (l__ADS__42 and 0.3 or 1), math.cos(l__Cycle__46) / 50 * (l__ADS__42 and 0.3 or 1), 0);
        local l__Angles__48 = CFrame.Angles;
        local v159 = math.sin(l__Cycle__46);
        local v160 = math.rad(v159) * (l__ADS__42 and 0.3 or 1);
        local v161 = math.cos(l__Cycle__46 / 2);
        local v162 = v156 * (v158 * l__Angles__48(v160, math.rad(v161) * (l__ADS__42 and 0.3 or 1), 0)):Lerp(CFrame.new(math.sin(v125 / 2) / 30, math.cos(v125) / 40, 0):Lerp(CFrame.new(), (v157 or l__ADS__42) and 1 or 0), p122._walkLerp);
        local v163 = l__HeightState__38 == u3.CharacterHeightState.Crouching and true or l__HeightState__38 == u3.CharacterHeightState.Proning;
        p122._firearmTiltLerp = p122._firearmTiltLerp:Lerp((not l__ADS__42 and l__Actor__24.Firearm and true or false) and CFrame.new(0, v163 and -0.08 or -0.05, v163 and 0.1 or -0.1) * CFrame.Angles(0, 0, (math.rad(v163 and 10 or 4))) or CFrame.new(), u6(p123 * 10));
        local v164 = v162 * p122._firearmTiltLerp * CFrame.new(0, p122.Jump.Position, 0);
        local l__Bipod__49 = p122.Bipod;
        if l__Bipod__49 and l__Bipod__49.Active then
            local v165 = l__CurrentCamera__2.CFrame:VectorToWorldSpace(v145.Position);
            local v166 = Vector3.new(v165.X, 0, v165.Z) * 2;
            local v167 = p122.Root.CFrame:Lerp(CFrame.new(l__Bipod__49.Position + v166) * CFrame.Angles(0, l__Actor__24.CameraX, 0) * CFrame.Angles(l__Actor__24.CameraY, 0, 0) * p122.Root.CFrame:ToObjectSpace(l__Bipod__49.First.CFrame:ToWorldSpace(CFrame.new(0, -l__Bipod__49.Height, 0))):Inverse(), l__Bipod__49.Lerp);
            p122.Root.CFrame = v167;
            p122._bipodCFrame = v167;
            p122._bipodLast = v125;
            local v168 = v167:ToWorldSpace(p122._adsLast:Inverse());
            if l__Actor__24.Camera then
                l__Bipod__49.ADS.WorldCFrame = l__Bipod__49.ADS.WorldCFrame:Lerp(v168, u6(p123 * 20));
            else
                l__Bipod__49.ADS.WorldCFrame = v168;
            end;
            l__Actor__24.Camera = l__Bipod__49.ADS;
            l__Actor__24.CameraLerp = p122.Active and (p122.ADSLerp or 0) or 0;
        elseif p122._bipodLast and v125 - p122._bipodLast < 0.1 then
            local v169 = (v125 - p122._bipodLast) * 10;
            p122.Root.CFrame = p122._bipodCFrame:Lerp(v164, v169);
            l__Actor__24.CameraLerp = (1 - v169) * p122.ADSLerp;
        else
            p122.Root.CFrame = v164;
            p122._bipodLast = nil;
            l__Actor__24.Camera = nil;
            l__Actor__24.CameraLerp = nil;
        end;
        local v170 = p122.Canted and (1 - p122.Canted or 1) or 1;
        for _, v171 in p122._cutaways do
            local l__ADSLerp__50 = p122.ADSLerp;
            local v172;
            if v171.Inverted then
                v172 = l__ADSLerp__50 * (1 - v170);
            else
                v172 = l__ADSLerp__50 * v170;
            end;
            if v171.Magnifier then
                v172 = v172 * v171.Magnifier.Lerp;
            end;
            local v173 = math.clamp(v172 - 0.5, 0, 0.5) * 2;
            local v174 = math.sqrt(v173);
            for v175, v176 in v171.Cutaways do
                v175.Transparency = u17.Lerp(v176, 1, u6(v174));
            end;
            for v177 in v171.CutawaysInverted do
                v177.Transparency = v174 < 0.01 and 1 or 0;
            end;
        end;
        p122._rightArmMotor.C0 = CFrame.new(1, -1, 1);
        p122._leftArmMotor.C0 = CFrame.new(-1, -1, 1);
        local v178 = false;
        if l__CurrentModel__37 and not l__Sprinting__41 then
            local v179 = l__CurrentModel__37:FindFirstChild("Muzzle", true);
            local v180;
            if v179 then
                v180 = v179:FindFirstChild("tip", true);
            else
                v180 = nil;
            end;
            if not v180 then
                local v181 = l__CurrentModel__37:FindFirstChild("Barrel", true);
                if v181 then
                    v180 = v181:FindFirstChild("tip", true);
                end;
                v180 = v180 or l__CurrentModel__37.PrimaryPart:FindFirstChild("tip");
            end;
            if v180 then
                local v182 = p122.WorldModel.PrimaryPart.CFrame:ToObjectSpace(v180.WorldCFrame);
                local l__Z__51 = v182.Z;
                local v183 = (l__CFrame__25 * u20 * CFrame.new():Lerp(u20:Inverse() * p122._adsLast, p122.ADSLerp)):ToWorldSpace(v182 + Vector3.new(0, 0, -l__Z__51));
                local l__Position__52 = v183.Position;
                local v184 = v183.LookVector * -l__Z__51;
                local v185 = workspace:Raycast(l__Position__52, v184, p122._params);
                local v186 = not v185 and 0 or (l__Position__52 + v184 - v185.Position).Magnitude;
                v178 = v186 > 0.5 and true or v178;
                if not l__Bipod__49 then
                    local l__Root__53 = p122.Root;
                    l__Root__53.CFrame = l__Root__53.CFrame * CFrame.new(0, 0, (math.min(v186, 0.5)));
                end;
                p122.Muzzle = v180.WorldCFrame:ToWorldSpace(CFrame.new(0, 0, v186));
            end;
        end;
        p122._blocked = v178;
    end;
    if p122._compassRotate then
        local _, v187 = l__CFrame__25:ToOrientation();
        p122._compassRotate.C1 = p122._compassRotate.C1:Lerp(CFrame.Angles(0, v187, 0), u6(p123 * 10));
    end;
    local l__Focused__54 = l__Actor__24.Focused;
    if l__Focused__54 then
        l__Focused__54 = not p122.Disabled;
    end;
    p122._last = l__CFrame__25;
    p122.WorldModel.Parent = l__Focused__54 and not u11.TabletOpen and l__CurrentCamera__2 or l__InactiveWorld__1;
    p122.Active = l__Focused__54;
    u9.Active = l__Focused__54;
end;
function u22.Stepped(p188) --[[ Line: 990 ]]
    if p188._followWorldModel then
        p188._rightArmMotor.Transform = CFrame.new();
        p188._leftArmMotor.Transform = CFrame.new();
        local l___currentMotor__55 = p188._currentMotor;
        if l___currentMotor__55 and p188._tpModel then
            l___currentMotor__55.Transform = CFrame.new();
        end;
    end;
end;
function u22.Destroy(p189) --[[ Line: 1002 ]]
    -- upvalues: u9 (copy), u10 (copy)
    for _, v190 in p189._reticles do
        u9:UnregisterReticle(v190);
    end;
    p189:_setLUT();
    p189._uiRoot:render(nil);
    p189._flashBlur.Destroy();
    p189._flashBloom.Destroy();
    u10:SetEffectMix("Flash", 0);
    p189.Recoil:Destroy();
    p189.Actor.ViewModel = nil;
    p189.WorldModel:Destroy();
end;
return u22;