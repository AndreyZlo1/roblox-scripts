-- Services.ReplicatorService.ActorClass
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4, u5, u6 = shared.import("require", "asset", "Enum", "signal", "server", "frc");
local u7 = v1("SoundService");
local u8 = v1("ChunkService");
local u9 = v1("WorldService");
local u10 = v1("VehicleService");
local u11 = v1("EnvironmentService");
local u12 = v1("DebugService");
local u13 = v1("Ragdoll");
local u14 = v1("ClientService");
local u15 = v1("Animations");
local u16 = v1("ItemLayout");
local u17 = v1("InputService");
local u18 = v1("VoicelineInterface");
local u19 = v1("WaveCalculator");
local u20 = v1("BaseComponent");
local u21 = v1("Menu");
local u22 = v1("Mathf");
local u23 = v1("solveIK");
local u24 = v1("FootstepMaterials");
local l__Debris__1 = game:GetService("Debris");
local l__Lighting__2 = game:GetService("Lighting");
local l__Players__3 = game:GetService("Players");
local l__RunService__4 = game:GetService("RunService");
local l__TextService__5 = game:GetService("TextService");
local l__TweenService__6 = game:GetService("TweenService");
local u25 = v1({ "HelmetGearReplicator" });
local u26 = v1({
    "GrenadeInventoryReplicator",
    "FirearmInventoryReplicator",
    "MeleeInventoryReplicator",
    "RocketInventoryReplicator",
    "ConsumableInventoryReplicator",
    "GearInventoryReplicator",
    "BreachInventoryReplicator",
    "DroneInventoryReplicator"
});
local l__CurrentCamera__7 = workspace.CurrentCamera;
local l__LocalPlayer__8 = l__Players__3.LocalPlayer;
local l__PlayerGui__9 = l__LocalPlayer__8:WaitForChild("PlayerGui");
local l__InactiveWorld__10 = u9.InactiveWorld;
local l__ActiveWorld__11 = u9.ActiveWorld;
local u27 = {
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
local u28 = Font.fromId(12187375422, u3.FontWeight.Bold, u3.FontStyle.Normal);
local u29 = {};
u29.__index = u29;
local function u38(p30, p31) --[[ Line: 105 ]]
    local v32 = p30:PointToObjectSpace(p31);
    local l__Unit__12 = v32.Unit;
    local l__Magnitude__13 = v32.Magnitude;
    local v33 = (Vector3.new(-0, -0, -1)):Cross(-l__Unit__12);
    local v34 = math.acos(-l__Unit__12.Z);
    local v35 = p30 * CFrame.fromAxisAngle(v33, v34):Inverse();
    if l__Magnitude__13 < 0.18900000000000006 then
        return v35 * CFrame.new(0, 0, 0.18900000000000006 - l__Magnitude__13), -1.5707963267948966, 3.141592653589793;
    end;
    if l__Magnitude__13 > 2.203 then
        return v35, 1.5707963267948966, 0;
    end;
    local v36 = math.acos((l__Magnitude__13 * l__Magnitude__13 + 0.41636700000000015) / (l__Magnitude__13 * 2.392));
    local v37 = -math.acos((l__Magnitude__13 * l__Magnitude__13 + -0.41636700000000015) / (l__Magnitude__13 * 2.014));
    return v35, 1.5707963267948966 - v36, -(v37 - v36);
end;
function u29._updateLOD(p39, p40) --[[ Line: 134 ]]
    p39._lod = p40;
    local v41;
    if p40 then
        v41 = nil;
    else
        v41 = p39.Character or nil;
    end;
    for _, v42 in {
        "Vest",
        "Belt",
        "Eyewear",
        "Earwear",
        "Facewear",
        "Backpack",
        "Wrist"
    } do
        if p39[v42] then
            p39[v42].Parent = v41;
        end;
    end;
end;
function u29.DoAnimation(u43, ...) --[[ Line: 145 ]]
    -- upvalues: u2 (copy), u3 (copy), u7 (copy), l__RunService__4 (copy)
    local u44 = u2:Get("Animation", ...);
    local u45 = u43:LoadAnimation(u44.ID);
    u45.Priority = u3.AnimationPriority.Action3;
    u45:Play(0);
    if u43._audioSyncWatchdog then
        u43._audioSyncWatchdog:Disconnect();
        u43._audioSyncWatchdog = nil;
    end;
    local l__AudioSync__14 = u44.Asset.AudioSync;
    if l__AudioSync__14 then
        local u46 = u7:CreateSound("Footsteps", u43.Parts.LowerTorso, true, "AnimationSync", l__AudioSync__14);
        u46.Destroy(u44.Asset.Duration);
        local u47 = tick();
        u43._audioSyncWatchdog = l__RunService__4.Heartbeat:Connect(function() --[[ Line: 165 ]]
            -- upvalues: u47 (copy), u44 (copy), u43 (copy), u45 (copy), u46 (copy)
            if tick() - u47 > u44.Asset.Duration then
                if u43._audioSyncWatchdog then
                    u43._audioSyncWatchdog:Disconnect();
                    u43._audioSyncWatchdog = nil;
                end;
            else
                if u45.IsPlaying and (u46.Sound.IsPlaying and math.abs(u45.TimePosition - u46.Sound.TimePosition) > 0.1) then
                    u46.Sound.TimePosition = u45.TimePosition;
                    if u43._audioSyncWatchdog then
                        u43._audioSyncWatchdog:Disconnect();
                        u43._audioSyncWatchdog = nil;
                    end;
                end;
            end;
        end);
    end;
end;
function u29.WeldManhole(u48) --[[ Line: 181 ]]
    -- upvalues: u2 (copy), u3 (copy), u7 (copy), l__Debris__1 (copy), l__RunService__4 (copy), l__TweenService__6 (copy)
    local v49 = u48:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "WeldManhole", "TP").ID);
    v49.Priority = u3.AnimationPriority.Action3;
    v49:Play(0);
    local u50 = u2:Get("Shared", "Models", "Tool", "WeldTorch").Asset:Clone();
    u50.Name = "Model";
    u50.Parent = u48.Character;
    local l__tip__15 = u50.tip;
    local u51 = u2:Get("Shared", "Models", "Tool", "WeldingStation").Asset:Clone();
    u51.Name = "Station";
    u51.CFrame = CFrame.new(u48.Position + Vector3.new(0, -2.1, 4));
    u51.Parent = u48.Character;
    local u52 = Instance.new("RopeConstraint");
    u52.Attachment0 = u50.torch;
    u52.Attachment1 = u51.torch;
    u52.Visible = true;
    u52.Color = BrickColor.Black();
    u52.Thickness = 0.1;
    u52.Parent = u51;
    local v53 = Instance.new("Motor6D");
    v53.Part0 = u48.Parts.RightHand;
    v53.Part1 = u50;
    v53.Parent = u50;
    local u54 = false;
    local u55 = u7:CreateSound("Footsteps", u48:_getHead(), false, "Foley", "Welding", "Loop");
    local u58 = v49:GetMarkerReachedSignal("Welding"):Connect(function(p56) --[[ Line: 213 ]]
        -- upvalues: u54 (ref), l__tip__15 (copy), u55 (copy)
        local v57 = p56 == "start";
        u54 = v57;
        l__tip__15.flash.Enabled = v57;
        l__tip__15.sparks.Enabled = v57;
        l__tip__15.light.Enabled = v57;
        if v57 then
            u55.Play();
        else
            u55.Stop();
        end;
    end);
    local u59 = Instance.new("Model");
    u59.Parent = workspace;
    l__Debris__1:AddItem(u59, 30);
    local u60 = 0;
    local u61 = tick();
    local u62 = nil;
    u62 = l__RunService__4.RenderStepped:Connect(function(_) --[[ Line: 233 ]]
        -- upvalues: u61 (copy), u62 (ref), u58 (copy), u54 (ref), u60 (ref), l__tip__15 (copy), u3 (ref), u48 (copy), u59 (copy), l__TweenService__6 (ref), u52 (copy), u50 (copy), u51 (copy)
        local v63 = tick();
        if v63 - u61 > 12.5 then
            u62:Disconnect();
            u58:Disconnect();
        else
            if u54 then
                if v63 - u60 > 0.1 then
                    u60 = v63;
                    local l__WorldPosition__16 = l__tip__15.WorldPosition;
                    local v64 = Instance.new("Part");
                    v64.Size = Vector3.new(0.2, 0.2, 0.2);
                    v64.Anchored = true;
                    v64.Material = u3.Material.Neon;
                    v64.Color = Color3.fromRGB(255, 137, 73);
                    v64.CanCollide = false;
                    v64.CanQuery = false;
                    v64.CanTouch = false;
                    v64.Shape = u3.PartType.Ball;
                    v64.CFrame = CFrame.new(l__WorldPosition__16.X, u48.Position.Y - 3.1, l__WorldPosition__16.Z);
                    v64.Parent = u59;
                    l__TweenService__6:Create(v64, TweenInfo.new(5), {
                        Color = Color3.fromRGB(48, 46, 45)
                    }):Play();
                end;
                l__tip__15.light.Brightness = 0.5 + math.random(0, 10) / 10;
                l__tip__15.light.Range = 4 + math.random(-10, 10) / 10;
            end;
            u52.Length = (u50.torch.WorldPosition - u51.torch.WorldPosition).Magnitude * 1.05;
        end;
    end);
    local l__NoLean__17 = u48.NoLean;
    local v65 = tick() + 12.5;
    u48.NoLean = math.max(l__NoLean__17, v65);
    u55.Destroy(13);
    l__Debris__1:AddItem(u50, 13);
    l__Debris__1:AddItem(u51, 13);
end;
function u29.TakePicture(p66) --[[ Line: 273 ]]
    -- upvalues: u2 (copy), u3 (copy), u7 (copy), l__Debris__1 (copy)
    local v67 = p66:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "TakePicture", "TP").ID);
    v67.Priority = u3.AnimationPriority.Action3;
    v67:Play(0);
    local v68 = u2:Get("Shared", "Models", "Tool", "DSLR").Asset:Clone();
    v68.Name = "Model";
    v68.Parent = p66.Character;
    local l__ViewModel__18 = p66.ViewModel;
    if l__ViewModel__18 then
        task.delay(0.1, l__ViewModel__18.SetModel, l__ViewModel__18, v68);
        task.delay(4, l__ViewModel__18.SetModel, l__ViewModel__18);
    end;
    local v69 = Instance.new("Motor6D");
    v69.Part0 = p66.Parts.RightHand;
    v69.Part1 = v68.PrimaryPart;
    v69.Parent = v68;
    u7:CreateSound("Footsteps", p66:_getHead(), true, "Foley", "TakePicture", "Start").Destroy(6);
    l__Debris__1:AddItem(v68, 4.5);
    local l__NoLean__19 = p66.NoLean;
    local v70 = tick() + 4.5;
    p66.NoLean = math.max(l__NoLean__19, v70);
end;
function u29.UseGeiger(p71, p72) --[[ Line: 300 ]]
    -- upvalues: u2 (copy), u3 (copy), u7 (copy), l__Debris__1 (copy)
    local v73 = p71:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "UseGeiger", "TP").ID);
    v73.Priority = u3.AnimationPriority.Action3;
    v73:Play(0);
    local v74 = u2:Get("Shared", "Models", "Tool", "Geiger").Asset:Clone();
    v74.Name = "Model";
    v74.Parent = p71.Character;
    local l__ViewModel__20 = p71.ViewModel;
    if l__ViewModel__20 then
        task.delay(0.1, l__ViewModel__20.SetModel, l__ViewModel__20, v74);
        task.delay(5, l__ViewModel__20.SetModel, l__ViewModel__20);
    end;
    local v75 = Instance.new("Motor6D");
    v75.Part0 = p71.Parts.RightHand;
    v75.Part1 = v74.PrimaryPart;
    v75.Parent = v74;
    u7:CreateSound("Footsteps", p71:_getHead(), true, "Foley", "UseGeiger", p72 and "MakeSound" or "NoSound").Destroy(7);
    l__Debris__1:AddItem(v74, 5);
    local l__NoLean__21 = p71.NoLean;
    local v76 = tick() + 5;
    p71.NoLean = math.max(l__NoLean__21, v76);
end;
function u29._setDragging(_, _) --[[ Line: 328 ]] end;
function u29._setDragged(p77, p78) --[[ Line: 332 ]]
    local l___downedPrompt__22 = p77._downedPrompt;
    if l___downedPrompt__22 then
        local l__LocalActor__23 = p77.Replicator.LocalActor;
        if l__LocalActor__23 and l__LocalActor__23.UID == p78 then
        elseif p78 then
            l___downedPrompt__22.Enabled = false;
        else
            l___downedPrompt__22.Enabled = true;
        end;
    end;
end;
function u29._setDowned(p79, p80) --[[ Line: 350 ]]
    -- upvalues: u3 (copy)
    p79.Downed = p80;
    if p80 and not p79.IsLocalPlayer then
        if p79._downedAttachment then
        else
            local v81 = Instance.new("Attachment");
            v81.CFrame = CFrame.new(0, 0, 0);
            p79._downedAttachment = v81;
            local v82 = Instance.new("ProximityPrompt");
            v82.Name = "DragDowned";
            v82.ActionText = "Drag Body";
            v82.ClickablePrompt = false;
            v82.Style = u3.ProximityPromptStyle.Custom;
            v82.Exclusivity = u3.ProximityPromptExclusivity.OneGlobally;
            v82.MaxActivationDistance = 7;
            v82.RequiresLineOfSight = false;
            v82.GamepadKeyCode = u3.KeyCode.World0;
            v82.KeyboardKeyCode = u3.KeyCode.World0;
            v82:SetAttribute("Body", p79.UID);
            v82.Parent = v81;
            p79._downedPrompt = v82;
            v81.Parent = p79.Parts.UpperTorso;
        end;
    else
        if p79._downedAttachment then
            p79._downedAttachment:Destroy();
            p79._downedAttachment = nil;
            p79._downedPrompt = nil;
        end;
    end;
end;
function u29._setTakeDown(p83, p84, p85) --[[ Line: 384 ]]
    -- upvalues: u3 (copy)
    if p84 == p85 then
    elseif p85 then
        if p83._takeDown then
        else
            local v86 = Instance.new("Attachment");
            v86.CFrame = CFrame.new(0, 0, 0);
            p83._takeDown = v86;
            local v87 = Instance.new("ProximityPrompt");
            v87.Name = "TakeDown";
            v87.ActionText = "Take Down";
            v87.ClickablePrompt = false;
            v87.Style = u3.ProximityPromptStyle.Custom;
            v87.Exclusivity = u3.ProximityPromptExclusivity.OneGlobally;
            v87.MaxActivationDistance = 6;
            v87.RequiresLineOfSight = false;
            v87.GamepadKeyCode = u3.KeyCode.World0;
            v87.KeyboardKeyCode = u3.KeyCode.World0;
            v87:SetAttribute("Body", p83.UID);
            v87.Parent = v86;
            v86.Parent = p83.Parts.UpperTorso;
        end;
    else
        if p83._takeDown then
            p83._takeDown:Destroy();
            p83._takeDown = nil;
        end;
    end;
end;
function u29._addBodyBagPrompt(p88) --[[ Line: 418 ]]
    -- upvalues: u3 (copy)
    local v89 = Instance.new("Attachment");
    v89.Parent = p88.Parts.UpperTorso;
    v89.CFrame = CFrame.new(0, 0, 0);
    local v90 = Instance.new("ProximityPrompt");
    v90.Name = "BodyBag";
    v90.ActionText = "Hide Body";
    v90.ClickablePrompt = false;
    v90.Style = u3.ProximityPromptStyle.Custom;
    v90.Exclusivity = u3.ProximityPromptExclusivity.OneGlobally;
    v90.MaxActivationDistance = 6;
    v90.RequiresLineOfSight = false;
    v90.GamepadKeyCode = u3.KeyCode.World0;
    v90.KeyboardKeyCode = u3.KeyCode.World0;
    v90:SetAttribute("Body", p88.UID);
    v90:SetAttribute("Timer", 3);
    v90.Parent = v89;
end;
function u29._setHostage(p91, p92) --[[ Line: 438 ]]
    -- upvalues: u3 (copy)
    if p91._hostageAttachment then
        p91._hostageAttachment:Destroy();
        p91._hostageAttachment = nil;
    end;
    if p92 then
        local v93 = Instance.new("Attachment");
        v93.Parent = p91.RootPart;
        v93.CFrame = CFrame.new(0, 0, 0);
        local v94 = Instance.new("ProximityPrompt");
        v94.ClickablePrompt = false;
        v94.Style = u3.ProximityPromptStyle.Custom;
        v94.Exclusivity = u3.ProximityPromptExclusivity.OneGlobally;
        v94.MaxActivationDistance = 6;
        v94.RequiresLineOfSight = false;
        v94.GamepadKeyCode = u3.KeyCode.World0;
        v94.KeyboardKeyCode = u3.KeyCode.World0;
        v94.Enabled = true;
        v94.Name = p92;
        v94.ActionText = "GUIDE HOSTAGE";
        v94.Parent = v93;
        p91._hostageAttachment = v93;
    end;
end;
function u29._getMaterial(p95, p96) --[[ Line: 465 ]]
    -- upvalues: u3 (copy), u24 (copy)
    local v97 = RaycastParams.new();
    v97.FilterType = u3.RaycastFilterType.Exclude;
    v97.FilterDescendantsInstances = { p95.Character };
    local v98 = workspace:Raycast(p95.CFrame.Position, Vector3.new(0, p96 and -10 or -3.5, 0), v97);
    if v98 then
        local l__MaterialVariant__24 = v98.Instance.MaterialVariant;
        return (#l__MaterialVariant__24 <= 0 or not u24[l__MaterialVariant__24]) and (u24[v98.Material] or "Concrete") or u24[l__MaterialVariant__24];
    end;
end;
function u29._doJump(p99, p100) --[[ Line: 481 ]]
    -- upvalues: u7 (copy)
    local v101 = p99:_getMaterial(true);
    u7:CreateSound("Footsteps", p99:_getHead(), true, "Footsteps", "Jump", p100 and "Start" or "Land", v101).Destroy(10);
end;
function u29._doFootstep(p102, p103, p104) --[[ Line: 487 ]]
    -- upvalues: u9 (copy), u19 (copy), u7 (copy)
    local v105 = p102:_getMaterial();
    if v105 then
        local l__Swimming__25 = p102.Swimming;
        if not p102.Swimming and u9:InWater(p104.Position) then
            local v106 = u19:GetWaveHeight(p104.Position, true);
            l__Swimming__25 = p104.Position.Y < v106 + u9.World.Water.Height and true or l__Swimming__25;
        end;
        local v107 = (p103 == "Sprint" or p103 == "Crouch") and p103 and p103 or "Jog";
        if p102.Focused then
            p104 = nil;
        end;
        u7:CreateSound("Footsteps", p104, true, "Footsteps", v107, l__Swimming__25 and "WaterWaist" or v105).Destroy(4);
    end;
end;
function u29._doLadderStep(p108, p109, p110) --[[ Line: 511 ]]
    -- upvalues: u7 (copy)
    u7:CreateSound("Footsteps", p108:_getHead(), true, "Foley", "Ladder", p110 and "Metal" or "Wood", p109).Destroy(4);
end;
function u29._getHead(p111) --[[ Line: 516 ]]
    if not p111.Focused then
        return p111.Parts.Head;
    end;
end;
function u29._cleanUp(p112) --[[ Line: 523 ]]
    -- upvalues: u10 (copy), u11 (copy), l__Debris__1 (copy)
    if p112._spottedHighlight then
        p112._spottedHighlight:Destroy();
        p112._spottedHighlight = nil;
    end;
    local l__OldSeat__26 = p112.OldSeat;
    if l__OldSeat__26 then
        u10:SetSeat(l__OldSeat__26.UID, l__OldSeat__26.Seat, nil);
        u10:SetDoorPosition(l__OldSeat__26.UID, l__OldSeat__26.Seat, false);
        p112.OldSeat = nil;
    end;
    if p112._audioSyncWatchdog then
        p112._audioSyncWatchdog:Disconnect();
        p112._audioSyncWatchdog = nil;
    end;
    local l___smokerGrenade__27 = p112._smokerGrenade;
    if l___smokerGrenade__27 then
        local v113 = workspace:Raycast(p112.Position, Vector3.new(0, -10, 0), p112._clipParams);
        local l__Model__28 = l___smokerGrenade__27.Model;
        l__Model__28.Anchored = true;
        if v113 then
            l__Model__28.CFrame = CFrame.new(v113.Position + Vector3.new(0, 0.175, 0)) * CFrame.Angles(1.5707963267948966, 0, 0);
        end;
        l__Model__28.Parent = workspace;
        task.delay(20, function() --[[ Line: 549 ]]
            -- upvalues: l___smokerGrenade__27 (copy), u11 (ref)
            l___smokerGrenade__27.Particle.Enabled = false;
            u11.Smokers[l___smokerGrenade__27] = nil;
        end);
        l__Debris__1:AddItem(l__Model__28, 21);
        l___smokerGrenade__27.Weld:Destroy();
        p112._smokerGrenade = nil;
    end;
    if p112._radioHighlight then
        p112._radioHighlight:Destroy();
        p112._radioHighlight = nil;
    end;
    if p112._outline then
        p112._outline:Destroy();
        p112._outline = nil;
    end;
    if p112._flashEnd then
        task.cancel(p112._flashEnd);
        p112._flashEnd = nil;
    end;
end;
function u29._createEquipWeld(p114, p115, p116) --[[ Line: 572 ]]
    if not p116 then
        return Instance.new("Weld");
    end;
    local v117 = p116:FindFirstChild("Anchor") or p116:FindFirstChild("anchor");
    local v118 = Instance.new("Weld");
    v118.Part0 = p114.Parts[p115];
    v118.Part1 = p116;
    v118.C1 = v117.CFrame;
    v118.Parent = p116;
    p116.Name = "Part";
    v117:Destroy();
    return v118;
end;
function u29._toggleATAK(p119, p120) --[[ Line: 589 ]]
    -- upvalues: u2 (copy)
    if p120 then
        if p119._atakModel then
        else
            local v121 = u2:Get("Shared", "Models", "Character", "Arm", "ATAK").Asset:Clone();
            p119:_createEquipWeld("LeftHand", v121);
            v121.Name = "Model";
            v121.Parent = p119.Character;
            p119._atakModel = v121;
            local v122 = p119:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "ATAK", "TP").ID);
            v122:Play(0.3);
            p119._atakAnimation = v122;
        end;
    else
        if p119._atakModel then
            p119._atakModel:Destroy();
            p119._atakModel = nil;
        end;
        if p119._atakAnimation then
            p119._atakAnimation:Stop(0.3);
            p119._atakAnimation = nil;
        end;
    end;
end;
function u29._togglePTT(p123, p124) --[[ Line: 617 ]]
    -- upvalues: u2 (copy), u3 (copy)
    if p124 then
        if not p123._pttAnimation then
            local v125 = p123:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "PTT", "TP").ID);
            v125.Priority = u3.AnimationPriority.Action3;
            v125:Play(0.2);
            p123._pttAnimation = v125;
        end;
    elseif p123._pttAnimation then
        p123._pttAnimation:Stop(0.2);
        p123._pttAnimation = nil;
    end;
end;
function u29._toggleCompass(p126, p127) --[[ Line: 634 ]]
    -- upvalues: u2 (copy)
    if p127 then
        if p126._compassModel then
        else
            local v128 = u2:Get("Shared", "Models", "Junk", "Compass").Asset:Clone();
            p126:_createEquipWeld("LeftHand", v128.PrimaryPart);
            v128.Name = "Model";
            v128.Parent = p126.Character;
            p126._compassModel = v128;
            p126._compassRotate = v128.PrimaryPart.Spin;
            local v129 = p126:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "ATAK", "TP").ID);
            v129:Play(0.3);
            p126._compassAnimation = v129;
        end;
    else
        if p126._compassModel then
            p126._compassModel:Destroy();
            p126._compassModel = nil;
        end;
        if p126._compassAnimation then
            p126._compassAnimation:Stop(0.3);
            p126._compassAnimation = nil;
        end;
        p126._compassRotate = nil;
    end;
end;
function u29.KickDoor(p130, p131) --[[ Line: 664 ]]
    -- upvalues: u2 (copy)
    p130:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "KickDoor", "TP", p131 and "Success" or "Fail").ID):Play(0.2);
end;
function u29.OpenDoor(p132) --[[ Line: 670 ]]
    -- upvalues: u2 (copy)
    p132:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "OpenDoor", "TP").ID):Play(0);
    local l__ViewModel__29 = p132.ViewModel;
    if l__ViewModel__29 then
        l__ViewModel__29:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "OpenDoor", "FP").ID):Play(0.2);
    end;
end;
function u29.KnockBack(p133, p134) --[[ Line: 683 ]]
    -- upvalues: u2 (copy)
    p133:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "KnockBack", p134).ID):Play(0);
end;
function u29._toggleLockPick(p135, p136) --[[ Line: 689 ]]
    -- upvalues: u7 (copy), u2 (copy)
    if p136 then
        if p135._lockPickAnimation then
            return;
        end;
        local v137 = u7:CreateSound("Character", p135:_getHead(), true, "LockPick", "Loop");
        local v138 = p135:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "LockPick", "TP").ID);
        v138:Play(0.3);
        p135._lockPickAnimation = v138;
        p135._lockPickSound = v137.Sound;
    else
        if p135._lockPickAnimation then
            p135._lockPickAnimation:Stop(0.3);
            p135._lockPickAnimation = nil;
        end;
        if p135._lockPickSound then
            p135._lockPickSound:Destroy();
            p135._lockPickSound = nil;
        end;
        u7:CreateSound("Character", p135:_getHead(), true, "LockPick", "Cancel").Destroy(2);
    end;
    p135.LockPicking = p136;
end;
function u29._changeGloves(p139, _, p140) --[[ Line: 715 ]]
    -- upvalues: u21 (copy), u2 (copy)
    local l___gloves__30 = p139._gloves;
    if l___gloves__30 then
        l___gloves__30.L:Destroy();
        l___gloves__30.R:Destroy();
        p139._gloves = nil;
    end;
    if p140 then
        local v141 = p140[2].Build[1][3];
        local v142 = u21.Character.Gloves[v141].Camos[p140[2].Build[2].Camo or "Default"];
        if not v142 then
            warn("GLOVE TEXTURE FAILED: " .. tostring(v141) .. " | " .. tostring(p140[2].Build[2].Camo));
            return;
        end;
        local l__Character__31 = p139.Character;
        local v143 = u2:Get("Shared", "Models", "Character", "Arm", "Gloves", v141, "TP", "L").Asset:Clone();
        v143.TextureID = v142.Texture;
        v143.CanQuery = false;
        v143.AudioCanCollide = false;
        v143.CanCollide = false;
        v143.CanTouch = false;
        v143.Parent = l__Character__31;
        local v144 = u2:Get("Shared", "Models", "Character", "Arm", "Gloves", v141, "TP", "R").Asset:Clone();
        v144.TextureID = v142.Texture;
        v144.CanQuery = false;
        v144.AudioCanCollide = false;
        v144.CanCollide = false;
        v144.CanTouch = false;
        v144.Parent = l__Character__31;
        p139:_createEquipWeld("LeftHand", v143);
        p139:_createEquipWeld("RightHand", v144);
        p139._gloves = {
            L = v143,
            R = v144
        };
    end;
end;
function u29._changeBoots(p145, _, p146) --[[ Line: 759 ]]
    -- upvalues: u21 (copy), u2 (copy)
    local l___boots__32 = p145._boots;
    if l___boots__32 then
        l___boots__32.L:Destroy();
        l___boots__32.R:Destroy();
        p145._boots = nil;
    end;
    if p146 then
        local v147 = p146[2].Build[1][3];
        local l__Texture__33 = u21.Character.Boots[v147].Camos[p146[2].Build[2].Camo or "Default"].Texture;
        local l__Character__34 = p145.Character;
        local v148 = u2:Get("Shared", "Models", "Character", "Boot", v147, "L").Asset:Clone();
        v148.TextureID = l__Texture__33;
        v148.CanQuery = false;
        v148.AudioCanCollide = false;
        v148.CanCollide = false;
        v148.CanTouch = false;
        v148.Parent = l__Character__34;
        local v149 = u2:Get("Shared", "Models", "Character", "Boot", v147, "R").Asset:Clone();
        v149.TextureID = l__Texture__33;
        v149.CanQuery = false;
        v149.AudioCanCollide = false;
        v149.CanCollide = false;
        v149.CanTouch = false;
        v149.Parent = l__Character__34;
        p145:_createEquipWeld("LeftFoot", v148);
        p145:_createEquipWeld("RightFoot", v149);
        p145._boots = {
            L = v148,
            R = v149
        };
    end;
end;
function u29._changeWearable(p150, p151, p152) --[[ Line: 799 ]]
    -- upvalues: u20 (copy), u25 (copy)
    if p150[p151] then
        p150[p151]:Destroy();
        p150[p151] = nil;
        p150._hairCancels[p151] = nil;
        p150._faceCancels[p151] = nil;
        p150._mouthCancels[p151] = nil;
        p150._balaclavaColor[p151] = nil;
        p150.GasMask[p151] = nil;
    end;
    if p152 then
        local v153 = u20.Deserialize(p152[2].Build);
        if v153.Tune.NoHair then
            p150._hairCancels[p151] = true;
        end;
        if v153.Tune.NoFace then
            p150._faceCancels[p151] = true;
        end;
        if v153.Tune.NoMouth then
            p150._mouthCancels[p151] = true;
        end;
        if v153.Tune.GasMask then
            p150.GasMask[p151] = true;
        end;
        if v153.Tune.BalaclavaColors then
            local v154 = "Default";
            for v155 in v153.CamoConfigs do
                v154 = v155;
                break;
            end;
            p150._balaclavaColor[p151] = v153.Tune.BalaclavaColors[v154];
        end;
        local l__ParentModel__35 = v153.ParentModel;
        p150:_createEquipWeld(p151 == "Wrist" and "LeftLowerArm" or ((p151 == "Vest" or p151 == "Backpack") and "UpperTorso" or (p151 == "Belt" and "LowerTorso" or "Head")), l__ParentModel__35.PrimaryPart);
        if u25[p151 .. "GearReplicator"] then
            l__ParentModel__35.Parent = p150.Character;
            p150[p151] = u25[p151 .. "GearReplicator"].new(v153, p150, p150.IsLocalPlayer);
        else
            local v156;
            if p150._lod then
                v156 = nil;
            else
                v156 = p150.Character or nil;
            end;
            l__ParentModel__35.Parent = v156;
            p150[p151] = l__ParentModel__35;
        end;
    end;
    p150.GearChanged:Fire();
    p150:_updateHair();
    p150:_updateFace();
    p150:_updateSkin();
end;
function u29._updateSkin(p157) --[[ Line: 853 ]]
    -- upvalues: u21 (copy)
    local l__SkinColor__36 = p157.SkinColor;
    local l__Shirt__37 = p157._outfit.Shirt;
    if l__Shirt__37 and #l__Shirt__37 > 0 then
        for _, v158 in p157._balaclavaColor do
            l__SkinColor__36 = v158;
            break;
        end;
    else
        local v159 = u21.Character.Hair[p157._hair];
        if v159 and v159.Female then
            l__SkinColor__36 = Color3.new();
        end;
    end;
    p157.Parts.UpperTorso.Color = l__SkinColor__36;
end;
function u29._updateFace(p160) --[[ Line: 871 ]]
    local v161 = false;
    for _ in p160._faceCancels do
        v161 = true;
        break;
    end;
    local v162 = false;
    for _ in p160._mouthCancels do
        v162 = true;
        break;
    end;
    p160._mouthCancel = v162;
    p160._mouth.Transparency = v161 and 1 or 0;
end;
function u29._updateHair(p163) --[[ Line: 888 ]]
    -- upvalues: u2 (copy)
    local v164 = p163._hairColor or Color3.new(0, 0, 0);
    local v165 = false;
    for _ in p163._hairCancels do
        v165 = true;
        break;
    end;
    if v165 and p163._hairModel then
        p163._hairModel:Destroy();
        p163._hairModel = nil;
    elseif not v165 and (not p163._hairModel and p163._hair) then
        local v166 = u2:Get("Shared", "Models", "Appearance", "Hair", p163._hair).Asset:Clone();
        v166.Mesh.VertexColor = Vector3.new(v164.R, v164.G, v164.B);
        v166.CanCollide = false;
        v166.CanTouch = false;
        v166.AudioCanCollide = false;
        v166.CanQuery = false;
        v166.Parent = p163.Character;
        local v167 = Instance.new("Weld");
        v167.Part0 = p163.Parts.Head;
        v167.Part1 = v166;
        v167.C1 = v166.anchor.CFrame;
        v167.Parent = v166;
        p163._hairModel = v166;
    end;
    local v168 = false;
    for _ in p163._faceCancels do
        v168 = true;
        break;
    end;
    if v168 and p163._faceModel then
        p163._faceModel:Destroy();
        p163._faceModel = nil;
    else
        if not v168 and (not p163._faceModel and p163._facialHair) then
            local v169 = u2:Get("Shared", "Models", "Appearance", "FacialHair", p163._facialHair).Asset:Clone();
            v169.Mesh.VertexColor = Vector3.new(v164.R, v164.G, v164.B);
            v169.CanCollide = false;
            v169.CanTouch = false;
            v169.AudioCanCollide = false;
            v169.CanQuery = false;
            v169.Parent = p163.Character;
            local v170 = Instance.new("Weld");
            v170.Part0 = p163.Parts.Head;
            v170.Part1 = v169;
            v170.C1 = v169.anchor.CFrame;
            v170.Parent = v169;
            p163._faceModel = v169;
        end;
    end;
end;
function u29._changeOutfit(p171, p172, p173, p174) --[[ Line: 950 ]]
    -- upvalues: u2 (copy), u27 (copy)
    if p172 == p173 then
    else
        for _, v175 in p171._outfit[p174] do
            v175:Destroy();
        end;
        p171._outfit[p174] = {};
        if p173 then
            local l__Parts__38 = p171.Parts;
            local l__Asset__39 = u2:Get("Shared", "Models", "Outfit", p174, p173).Asset;
            local v176 = {};
            for _, v177 in u27[p174] do
                local v178 = l__Asset__39:Clone();
                v176[#v176 + 1] = v178;
                v178.Parent = l__Parts__38[v177];
            end;
            p171._outfit[p174] = v176;
        end;
        p171:_updateSkin();
    end;
end;
function u29._setEmote(p179, p180, p181) --[[ Line: 976 ]]
    -- upvalues: u15 (copy), u2 (copy), u3 (copy)
    if p180 then
        local v182 = u15.Emotes[p180];
        if v182 and v182.End then
            p179:LoadAnimation(u2:Get("Animation", "Emotes", p180, "End", "TP").ID):Play(0);
        end;
    end;
    if p179._emoteTrack then
        p179._emoteTrack:Stop(0);
        p179._emoteTrack = nil;
    end;
    if p181 then
        local v183 = u15.Emotes[p181];
        if not v183 then
            warn("Attempted to play emote DOES NOT EXIST: " .. p181);
            return;
        end;
        if v183.End then
            u2:Get("Animation", "Emotes", p181, "End", "TP"):Preload();
        end;
        local v184 = false;
        local v185 = u2:Get("Animation", "Emotes", p181, "Start", "TP");
        if v185.Asset.Last and p180 ~= v185.Asset.Last then
            v184 = true;
        else
            local v186 = p179:LoadAnimation(v185.ID);
            v186.Priority = u3.AnimationPriority.Action2;
            v186:Play(0);
        end;
        if v183.Idle then
            local v187 = p179:LoadAnimation(u2:Get("Animation", "Emotes", p181, "Idle", "TP").ID);
            v187.Priority = u3.AnimationPriority.Action;
            v187:Play(v184 and 1 or 0);
            p179._emoteTrack = v187;
        end;
        local v188 = v185.Asset.FirstPerson and p179.ViewModel;
        if v188 then
            v188:LoadAnimation(u2:Get("Animation", "Emotes", p181, "Start", "FP").ID):Play();
        end;
    end;
end;
function u29._setSmoker(p189, p190) --[[ Line: 1033 ]]
    -- upvalues: l__Debris__1 (copy), u11 (copy), u2 (copy), u3 (copy)
    local l___smokerGrenade__40 = p189._smokerGrenade;
    if l___smokerGrenade__40 then
        local l__Model__41 = l___smokerGrenade__40.Model;
        l__Model__41.Transparency = 1;
        l__Model__41.Anchored = true;
        l__Debris__1:AddItem(l__Model__41, 10);
        l___smokerGrenade__40.Weld:Destroy();
        l___smokerGrenade__40.Particle.Enabled = false;
        l___smokerGrenade__40.Animation:Stop();
        p189._smokerGrenade = nil;
        u11.Smokers[l___smokerGrenade__40] = nil;
    end;
    if p190 then
        local v191 = u2:Get("Shared", "Models", "Tool", "Smoker").Asset:Clone();
        v191.CanCollide = false;
        v191.CanQuery = false;
        v191.AudioCanCollide = false;
        v191.CanTouch = false;
        v191.Name = "Model";
        v191.Parent = p189.Character;
        local v192 = Instance.new("Weld");
        v192.Part0 = p189.Parts.LeftHand;
        v192.Part1 = v191;
        v192.C0 = CFrame.new(0.4, -0.2, -0.2) * CFrame.Angles(1.5707963267948966, 0, 3.141592653589793);
        v192.Parent = v191;
        local v193 = p189:LoadAnimation(u2:Get("Animation", "GenericWeapon", "Smoker").ID);
        v193.Priority = u3.AnimationPriority.Action3;
        v193:Play();
        p189._smokerGrenade = {
            Range = 20,
            Model = v191,
            Weld = v192,
            Animation = v193,
            Particle = v191:FindFirstChildWhichIsA("ParticleEmitter", true)
        };
        u11.Smokers[p189._smokerGrenade] = true;
    end;
end;
function u29._setTool(p194, p195) --[[ Line: 1080 ]]
    -- upvalues: u3 (copy), l__Debris__1 (copy), u2 (copy)
    local l___toolModel__42 = p194._toolModel;
    if l___toolModel__42 then
        p194._toolWeld:Destroy();
        l___toolModel__42.CanCollide = true;
        l___toolModel__42.CanQuery = true;
        l___toolModel__42.AudioCanCollide = true;
        l___toolModel__42.CanTouch = true;
        l___toolModel__42.CollisionGroup = u3.PhysicsGroup.Debris;
        l__Debris__1:AddItem(l___toolModel__42, 10);
        p194._toolModel = nil;
        p194._toolWeld = nil;
    end;
    if p195 then
        local v196 = u2:Get("Shared", "Models", "Tool", p195).Asset:Clone();
        local v197 = v196:FindFirstChildWhichIsA("Attachment");
        local l__Name__43 = v197.Name;
        v197.Name = "anchor";
        p194._toolWeld = p194:_createEquipWeld(l__Name__43, v196);
        v196.Name = "Model";
        v196.Parent = p194.Character;
        p194._toolModel = v196;
    end;
end;
function u29._setLoopAnimation(p198, p199, p200) --[[ Line: 1107 ]]
    -- upvalues: u7 (copy), u2 (copy), u3 (copy)
    if p199 == p200 then
    else
        if p200 then
            if p198.UseClient then
                p198._loopSound = u7:CreateSound("Character", p198:_getHead(), true, "InteractionSounds", p200);
            end;
            local v201 = p198:LoadAnimation(u2:Get("Animation", "CharacterAnimations", p200, "TP").ID);
            v201.Priority = u3.AnimationPriority.Action2;
            v201:Play(0);
            p198._loopAnimation = v201;
            local l__ViewModel__44 = p198.ViewModel;
            if l__ViewModel__44 then
                local v202 = l__ViewModel__44:LoadAnimation(u2:Get("Animation", "CharacterAnimations", p200, "FP").ID);
                v202:Play(0);
                p198._loopAnimationFP = v202;
            end;
        else
            if p198._loopSound then
                p198._loopSound.Destroy();
                p198._loopSound = nil;
            end;
            if p198._loopAnimation then
                p198._loopAnimation:Stop(0);
                p198._loopAnimation = nil;
            end;
            if p198._loopAnimationFP then
                p198._loopAnimationFP:Stop(0);
                p198._loopAnimationFP = nil;
            end;
        end;
    end;
end;
function u29._setOutline(p203) --[[ Line: 1146 ]]
    -- upvalues: l__PlayerGui__9 (copy), u3 (copy)
    if p203._outline then
    else
        local v204 = Instance.new("Highlight");
        v204.OutlineColor = Color3.new(1, 0, 0);
        v204.FillTransparency = 1;
        v204.OutlineTransparency = 0.5;
        v204.Parent = l__PlayerGui__9;
        v204.Adornee = p203.Character;
        v204.DepthMode = u3.HighlightDepthMode.Occluded;
        p203._outline = v204;
    end;
end;
function u29._setRadio(p205, p206, p207) --[[ Line: 1161 ]]
    -- upvalues: l__CurrentCamera__7 (copy), u2 (copy), u3 (copy), l__PlayerGui__9 (copy)
    if (p205.Position - l__CurrentCamera__7.CFrame.Position).Magnitude > 1500 then
        p207 = false;
    end;
    if p206 == p207 then
    else
        if p207 or not p205._radioIdle then
            if p207 and not p205._radioIdle then
                local v208 = u2:Get("Shared", "Models", "Character", "Radio").Asset:Clone();
                local v209 = Instance.new("Weld");
                v209.C1 = v208.Anchor.CFrame;
                v209.Part0 = p205.Parts.LeftHand;
                v209.Part1 = v208;
                v209.Parent = v208;
                v208.Parent = p205.Character;
                local v210 = p205:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Radio", "Idle").ID);
                v210.Priority = u3.AnimationPriority.Action2;
                v210:Play(0);
                local v211 = Instance.new("Highlight");
                v211.OutlineColor = Color3.new(1, 0, 0);
                v211.FillTransparency = 1;
                v211.OutlineTransparency = 0;
                v211.Parent = l__PlayerGui__9;
                v211.Adornee = p205.Character;
                v211.DepthMode = u3.HighlightDepthMode.AlwaysOnTop;
                p205._radioModel = v208;
                p205._radioIdle = v210;
                p205._radioHighlight = v211;
            end;
        else
            p205._radioIdle:Stop(0);
            p205._radioIdle = nil;
            p205._radioModel:Destroy();
            p205._radioModel = nil;
            p205._radioHighlight:Destroy();
            p205._radioHighlight = nil;
        end;
        p205.Radioing = p207;
        local v212 = p205:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Radio", p207 and "Start" or "End").ID);
        v212.Priority = u3.AnimationPriority.Action3;
        v212:Play(0);
    end;
end;
function u29._setMedical(p213, p214) --[[ Line: 1211 ]]
    -- upvalues: u2 (copy), u3 (copy), u7 (copy), l__Debris__1 (copy)
    if p214 then
        local v215 = u2:Get("Animation", "CharacterAnimations", "Medical", "TP", p214);
        local v216 = p213:LoadAnimation(v215.ID);
        v216.Priority = u3.AnimationPriority.Action2;
        v216:Play(0);
        local u217 = u2:Get("Shared", "Models", "Medical", p214).Asset:Clone();
        local v218 = u217:IsA("BasePart") and u217 and u217 or u217.PrimaryPart;
        local l__Time__45 = v215.Asset.Time;
        local l__ViewModel__46 = p213.ViewModel;
        if l__ViewModel__46 then
            local v219 = l__ViewModel__46:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Medical", "FP", p214).ID);
            v219.Priority = u3.AnimationPriority.Action3;
            v219:Play(0);
            local u220 = u217:Clone();
            l__ViewModel__46:AddModel(u220, CFrame.new(0, 0, 3));
            task.delay(l__Time__45, function() --[[ Line: 1235 ]]
                -- upvalues: u220 (copy)
                u220:Destroy();
            end);
            local v221 = tick();
            p213.MedicalStart = v221;
            p213.MedicalEnd = v221 + l__Time__45;
        end;
        local v222 = Instance.new("Motor6D");
        v222.Part0 = p213.Parts[v215.Asset.Part];
        v222.Part1 = v218;
        v222.Parent = v218;
        u217.Parent = p213.Character;
        l__Debris__1:AddItem(u7:CreateSound("Character", p213:_getHead(), true, "Medical", p214).Sound, l__Time__45 + 2);
        task.delay(l__Time__45, function() --[[ Line: 1253 ]]
            -- upvalues: u217 (copy)
            u217:Destroy();
        end);
    end;
end;
function u29.new(p223, p224, p225, p226) --[[ Line: 1258 ]]
    -- upvalues: l__LocalPlayer__8 (copy), u2 (copy), u3 (copy), l__CurrentCamera__7 (copy), u4 (copy), u29 (copy), u21 (copy), u5 (copy), u14 (copy), l__InactiveWorld__10 (copy), u8 (copy), u12 (copy)
    local v227 = l__LocalPlayer__8 == p224;
    local v228 = u2:Get("Shared", "Models", "Character", "Male");
    local v229 = v228.Asset:Clone();
    local l__Skin__47 = p225.Skin;
    local v230 = {};
    local v231 = {};
    for _, v232 in v229:GetChildren() do
        v232.CollisionGroup = u3.PhysicsGroup.CharacterCast;
        v232.CanCollide = false;
        v232.CanTouch = false;
        v232.AudioCanCollide = false;
        v232:SetAttribute("ActorUID", p226);
        for _, v233 in v232:GetChildren() do
            if v233:IsA("Motor6D") then
                v230[v233.Name] = v233;
            end;
        end;
        if v232 == v229.PrimaryPart then
            v232.CanQuery = false;
        else
            if v232.Name == "LowerTorso" or (v232.Name == "LeftUpperLeg" or v232.Name == "RightUpperLeg") then
                v232.Color = Color3.new();
            else
                v232.Color = l__Skin__47;
            end;
            v231[v232.Name] = v232;
        end;
    end;
    local l__Head__48 = v231.Head;
    if p225.EyeColor then
        l__Head__48.Pupil.Color3 = p225.EyeColor;
    end;
    if p225.Mouth then
        l__Head__48.Mouth.Texture = p225.Mouth;
    end;
    if p225.Eyebrows then
        l__Head__48.Eyebrows.Texture = p225.Eyebrows;
    end;
    local v234 = Instance.new("Humanoid");
    v234.DisplayDistanceType = u3.HumanoidDisplayDistanceType.None;
    v234.EvaluateStateMachine = false;
    v234.RequiresNeck = false;
    v234.BreakJointsOnDeath = false;
    v234.RigType = u3.HumanoidRigType.R6;
    v234.Parent = v229;
    local l__Asset__49 = u2:Get("Shared", "Particles", "Character", "Splash").Asset;
    l__Asset__49:Clone().Parent = v231.LeftFoot;
    l__Asset__49:Clone().Parent = v231.RightFoot;
    local v235 = RaycastParams.new();
    v235.CollisionGroup = u3.PhysicsGroup.BotSightBlocker;
    v235.FilterType = u3.RaycastFilterType.Exclude;
    v235.FilterDescendantsInstances = { l__CurrentCamera__7 };
    v235.IgnoreWater = true;
    local v236 = RaycastParams.new();
    v236.CollisionGroup = u3.PhysicsGroup.CharacterCast;
    v236.FilterType = u3.RaycastFilterType.Exclude;
    v236.FilterDescendantsInstances = { l__CurrentCamera__7 };
    v236.IgnoreWater = true;
    local v237 = {
        Health = 100,
        Alive = true,
        Owner = p224,
        OwnerName = p224 and (p224.Name or "???") or "???",
        Focused = false,
        Replicator = p223,
        Character = v229,
        SkinColor = l__Skin__47,
        SimulatedPosition = p225.Position,
        Position = p225.Position,
        Orientation = p225.Orientation,
        Direction = Vector2.new(),
        CFrame = CFrame.new(p225.Position),
        ServerPosition = p225.Position,
        RootPart = v229.PrimaryPart,
        Sprinting = false,
        Walking = false,
        Swimming = false,
        HeightState = 0,
        WaterLevel = 0,
        Cycle = 0,
        Zoom = 5,
        Weight = 0,
        Tilt = 0,
        NoLean = 0,
        Lean = 0,
        LeanGoal = 0,
        CameraX = p225.Orientation,
        CameraY = 0,
        GasMask = {},
        CurrentState = {},
        Parts = v231,
        Seat = p225.Seat,
        OldSeat = p225.Seat,
        GearChanged = u4.new(),
        _lastCFrame = CFrame.new(p225.Position) * CFrame.Angles(0, p225.Orientation, 0),
        IsLocalPlayer = v227,
        _animator = v234,
        _loadedAnimations = {},
        _loaded = false,
        _spotted = {},
        _motors = v230,
        _leftArmLerp = 0,
        _rightArmLerp = 0,
        _targetLeftUpper = CFrame.new(),
        _targetLeftLower = CFrame.new(),
        _targetRightUpper = CFrame.new(),
        _targetRightLower = CFrame.new(),
        _leftUpperC0 = v230.LeftUpperArm.C0,
        _leftLowerC0 = v230.LeftLowerArm.C0,
        _rightUpperC0 = v230.RightUpperArm.C0,
        _rightLowerC0 = v230.RightLowerArm.C0,
        AnimationKit = "Unequipped",
        _animationState = "Jog",
        _animationCache = {},
        _animationLerp = CFrame.new(),
        _animationCycle = 0,
        _nextBlink = tick() + 5,
        _nextBreath = tick() + 2,
        _snow = l__Head__48:WaitForChild("mouthEmitter"):WaitForChild("Snow"),
        _speedSmoothing = 0,
        _twist = 0,
        _tilt = 0,
        _noLean = 0,
        _spit = 0,
        _idleWeight = 1,
        _heightDifference = 0,
        _skydiveLerp = 0,
        _clipParams = v235,
        _landParams = v236,
        _chatOrder = 1,
        _lastTalk = 0,
        _nextCough = 0,
        _inventory = {},
        _hairCancels = {},
        _faceCancels = {},
        _mouthCancels = {},
        _balaclavaColor = {},
        _hair = p225.Hair,
        _facialHair = p225.FacialHair,
        _hairColor = p225.HairColor,
        _outfit = {
            Shirt = {},
            Pants = {}
        }
    };
    local u238 = setmetatable(v237, u29);
    v228:Preload(function(_) --[[ Line: 1441 ]]
        -- upvalues: u238 (copy)
        u238._loaded = true;
    end);
    local v239 = l__Head__48:Clone();
    v239.Name = "FakeHead";
    v239.CanCollide = false;
    v239.CanTouch = false;
    v239.CanQuery = false;
    v239.Parent = v229;
    u238._mouthTexture = p225.Mouth;
    u238._mouth = v239:WaitForChild("Mouth");
    u238._pupil = v239:WaitForChild("Pupil");
    u238._white = v239:WaitForChild("White");
    local v240 = u21.Character.Hair[u238._hair];
    if v240 and v240.Female then
        u238._female = true;
    end;
    u238._whiteTexture = u238._female and "rbxassetid://97882603752358" or "rbxassetid://78764527649263";
    u238._white.Texture = u238._whiteTexture;
    l__Head__48.Transparency = 1;
    l__Head__48.Pupil:Destroy();
    l__Head__48.Mouth:Destroy();
    l__Head__48.White:Destroy();
    l__Head__48.Eyebrows:Destroy();
    local v241 = Instance.new("Weld");
    v241.Part0 = l__Head__48;
    v241.Part1 = v239;
    v241.Parent = v239;
    local v242 = Instance.new("AudioAnalyzer");
    v242.SpectrumEnabled = false;
    v242.Parent = l__Head__48;
    u238._audioAnalyzer = v242;
    if p224 then
        local v243 = p224:FindFirstChildWhichIsA("AudioDeviceInput");
        if v243 then
            local v244 = Instance.new("Wire");
            v244.SourceInstance = v243;
            v244.TargetInstance = v242;
            v244.Parent = v242;
            if not v227 then
                local v245 = Instance.new("AudioEmitter");
                v245.AudioInteractionGroup = "Talk";
                v245:SetDistanceAttenuation({
                    [10] = 1,
                    [50] = 0.5,
                    [100] = 0
                });
                v245.Parent = l__Head__48;
                local v246 = Instance.new("AudioFader");
                v246.Parent = v245;
                v246.Volume = 3;
                local v247 = Instance.new("Wire");
                v247.SourceInstance = v243;
                v247.TargetInstance = v246;
                v247.Parent = v246;
                local v248 = Instance.new("Wire");
                v248.SourceInstance = v246;
                if not u5.IS_PVP then
                    v248.TargetInstance = v245;
                end;
                v248.Parent = v246;
                local v249 = Instance.new("Wire");
                v249.SourceInstance = v246;
                v249.Parent = v246;
                u238._voiceClient = u14.Clients[p224];
                u238._voiceEmitter = v245;
                u238._emitterWire = v248;
                u238._radioWire = v249;
            end;
        end;
        if not u5.IS_PVP then
            local v250 = Instance.new("BillboardGui");
            v250.Adornee = u238.Parts.Head;
            v250.Parent = u238.Character;
            v250.LightInfluence = 0.5;
            v250.MaxDistance = 40;
            v250.Size = UDim2.fromScale(10, 20);
            v250.StudsOffsetWorldSpace = Vector3.new(0, 1.5, 0);
            local v251 = Instance.new("Frame");
            v251.Size = UDim2.fromScale(1, 0.5);
            v251.BackgroundTransparency = 1;
            v251.Parent = v250;
            u238._chatsFrame = v251;
            local v252 = Instance.new("UIListLayout");
            v252.Padding = UDim.new(0.01, 0);
            v252.SortOrder = u3.SortOrder.LayoutOrder;
            v252.HorizontalAlignment = u3.HorizontalAlignment.Center;
            v252.VerticalAlignment = u3.VerticalAlignment.Bottom;
            v252.Parent = v251;
            u238._billboardGui = v250;
        end;
    end;
    u238:_updateHair();
    u238:_updateFace();
    u238:_updateSkin();
    u238._isInactive = true;
    v229.Parent = l__InactiveWorld__10;
    u8:RegisterBlock(u238, 1);
    for v253, v254 in p225.State do
        u238:State(v253, v254);
    end;
    u12:Print("Spawned actor (" .. (p224 and p224.Name or "SERVER") .. ")", Color3.new(0.5, 0, 1));
    return u238;
end;
function u29.Reequip(p255) --[[ Line: 1567 ]]
    local v256 = p255._equipped and p255._inventory[p255._equipped];
    if v256 then
        v256:Equip(true);
    end;
end;
function u29.Jump(p257) --[[ Line: 1576 ]]
    p257:_doJump(true);
    if p257.ViewModel then
        p257.ViewModel.Jump:Impulse(1);
    end;
end;
function u29.Action(p258, p259, p260, ...) --[[ Line: 1583 ]]
    -- upvalues: u3 (copy)
    if p259 == u3.ActionType.Inventory or p259 == u3.ActionType.InventoryIncludeClient then
        if p258._equipped then
            local v261 = p258._inventory[p258._equipped];
            if v261 and v261[p260] then
                return v261[p260](v261, ...);
            end;
        end;
    else
        if p259 == u3.ActionType.Helmet then
            if p258.Helmet then
                p258.Helmet[p260](p258.Helmet, ...);
            end;
        elseif p259 == u3.ActionType.Function or p259 == u3.ActionType.FunctionIgnoreClient then
            p258[p260](p258, ...);
        end;
    end;
end;
function u29.HitByVehicle(p262, p263) --[[ Line: 1604 ]]
    -- upvalues: u7 (copy)
    u7:CreateSound("Character", p262:_getHead(), true, "VehicleSFX", "SuspensionHit", "Player").Destroy(5);
    p262._impulseOnDeath = CFrame.new(p263, p262.Parts.LowerTorso.Position).LookVector;
end;
function u29.GetSelf(p264, p265) --[[ Line: 1611 ]]
    -- upvalues: u23 (copy)
    return p264.UID, p264, u23(p265);
end;
function u29.Cough(p266, p267) --[[ Line: 1615 ]]
    -- upvalues: u7 (copy), u2 (copy), u3 (copy)
    u7:CreateSound("BotVoices", p266:_getHead(), true, "Foley", "GasMask", p267 and "CoughMask" or "Cough").Destroy(10);
    local v268 = p266:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Cough", p267 and "TP_Mask" or "TP").ID);
    v268.Looped = false;
    v268.Priority = u3.AnimationPriority.Action3;
    v268:Play(0.2, 1, 0.7);
    local l__ViewModel__50 = p266.ViewModel;
    if l__ViewModel__50 then
        l__ViewModel__50:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Cough", "FP").ID):Play(0, 1, 0.7);
    end;
    p266._nextCough = tick() + 2;
end;
function u29.Flashed(p269, p270) --[[ Line: 1634 ]]
    -- upvalues: u2 (copy), u3 (copy)
    if p269.Alive then
        if p269._flashEnd then
            task.cancel(p269._flashEnd);
            p269._flashEnd = nil;
        end;
        local v271 = p269:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Flashed", "TP").ID);
        v271.Priority = u3.AnimationPriority.Action3;
        v271:Play(0.2);
        if not p269.LastFlash then
            p269.LastFlash = 0;
        end;
        local l__LastFlash__51 = p269.LastFlash;
        local v272 = tick() + p270;
        p269.LastFlash = math.max(l__LastFlash__51, v272);
        p269._flashEnd = task.delay(p270, v271.Stop, v271, 0.2);
    end;
end;
function u29._cancelVoice(p273) --[[ Line: 1656 ]]
    local l___currentVoiceLine__52 = p273._currentVoiceLine;
    if l___currentVoiceLine__52 then
        l___currentVoiceLine__52.Voice.Destroy();
        if l___currentVoiceLine__52.Caption then
            l___currentVoiceLine__52.Caption();
        end;
        if l___currentVoiceLine__52.Task then
            task.cancel(l___currentVoiceLine__52.Task);
            l___currentVoiceLine__52.Task = nil;
        end;
        p273._currentVoiceLine = nil;
    end;
end;
function u29.Voice(u274, u275, u276, u277, u278) --[[ Line: 1673 ]]
    -- upvalues: u7 (copy), l__CurrentCamera__7 (copy), u18 (copy), u2 (copy)
    local function v288() --[[ Line: 1674 ]]
        -- upvalues: u274 (copy), u7 (ref), u275 (copy), u276 (copy), l__CurrentCamera__7 (ref), u18 (ref), u277 (copy), u278 (copy)
        if u274._isInactive or not (u274.UseClient and u274.Alive) then
        else
            u274:_cancelVoice();
            local v279 = u7:CreateSound("BotVoices", u274:_getHead(), true, "Voicelines", u275, u276);
            if v279.Loaded then
                local v280 = Instance.new("Wire");
                v280.SourceInstance = v279.Sound;
                v280.TargetInstance = u274._audioAnalyzer;
                v280.Parent = v279.Sound;
                local l__Properties__53 = v279.Properties;
                local u281 = (v279.Duration or 2) + 0.5;
                local u282 = {
                    Duration = u281,
                    Voice = v279
                };
                if (l__CurrentCamera__7.CFrame.Position - u274.Position).Magnitude < v279.MaxDistance / 1.5 then
                    local u283 = l__Properties__53._lines[v279.Region];
                    if typeof(u283) == "string" then
                        u282.Caption = u18:DoLine(u283, u277, u278, u281);
                        u282.Task = task.delay(u281, function() --[[ Line: 1702 ]]
                            -- upvalues: u282 (copy), u274 (ref)
                            u282.Task = nil;
                            u274:_cancelVoice();
                        end);
                    else
                        local u284 = 1;
                        u282.NextVoiceLine = u283[1][1];
                        function u282.DoVoiceLine() --[[ Line: 1709 ]]
                            -- upvalues: u283 (copy), u284 (ref), u274 (ref), u281 (copy), u282 (copy), u18 (ref), u277 (ref), u278 (ref)
                            local v285 = u283[u284];
                            if v285 then
                                local v286 = v285[3];
                                local v287 = u283[u284 + 1];
                                if not v286 then
                                    if v287 then
                                        v286 = v287[1] - v285[1];
                                    else
                                        v286 = u281 - v285[1];
                                    end;
                                end;
                                u282.NextVoiceLine = v287 and v287[1] or u281;
                                u282.Caption = u18:DoLine(v285[2], u277, u278, v286);
                                u284 = u284 + 1;
                            else
                                u274:_cancelVoice();
                            end;
                        end;
                    end;
                end;
                u274._currentVoiceLine = u282;
            end;
        end;
    end;
    u2:Get("Sound", "Voicelines", u275, u276):Preload(v288);
end;
function u29.Rappel(p289, p290, p291) --[[ Line: 1738 ]]
    -- upvalues: u10 (copy), u2 (copy), u3 (copy), u7 (copy)
    if p289._isInactive and not p289.IsLocalPlayer then
    else
        local v292 = u10:GetVehicle(p290);
        if v292 then
            local v293 = v292.Rappels[p291];
            if v293 then
                local v294 = p289:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Rappel", "Start").ID);
                v294.Priority = u3.AnimationPriority.Action;
                v294:Play(0);
                local v295 = p289:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Rappel", "Loop").ID);
                v295.Priority = u3.AnimationPriority.Movement;
                v295:Play(0);
                u7:CreateSound("Vehicle_Interaction", p289:_getHead(), true, "Foley", "Fastrope", "Start").Destroy(2);
                local v296 = u7:CreateSound("Vehicle_Interaction", p289:_getHead(), true, "Foley", "Fastrope", "Slide");
                p289.Rappelling = v293;
                p289._rappelLoop = v295;
                p289._rappelLoopSound = v296;
                p289._rappelStart = tick();
            end;
        end;
    end;
end;
function u29.IsA(_, p297) --[[ Line: 1774 ]]
    return p297 == "Actor";
end;
function u29.State(p298, p299, p300) --[[ Line: 1778 ]]
    -- upvalues: u16 (copy), u26 (copy)
    local l__CurrentState__54 = p298.CurrentState;
    if p299 == "Backpack" then
        p298:_changeWearable("Backpack", p300);
    elseif p299 == "Vest" then
        p298:_changeWearable("Vest", p300);
    elseif p299 == "Belt" then
        p298:_changeWearable("Belt", p300);
    elseif p299 == "Helmet" then
        p298:_changeWearable("Helmet", p300);
    elseif p299 == "Facewear" then
        p298:_changeWearable("Facewear", p300);
    elseif p299 == "Earwear" then
        p298:_changeWearable("Earwear", p300);
    elseif p299 == "Eyewear" then
        p298:_changeWearable("Eyewear", p300);
    elseif p299 == "Wrist" then
        p298:_changeWearable("Wrist", p300);
    elseif p299 == "Gloves" then
        p298:_changeGloves(l__CurrentState__54[p299], p300);
    elseif p299 == "Boots" then
        p298:_changeBoots(l__CurrentState__54[p299], p300);
    elseif p299 == "Shirt" then
        if p300 then
            p300 = p300[1]:sub(6);
        end;
        p298:_changeOutfit(l__CurrentState__54[p299], p300, "Shirt");
    elseif p299 == "Pants" then
        if p300 then
            p300 = p300[1]:sub(6);
        end;
        p298:_changeOutfit(l__CurrentState__54[p299], p300, "Pants");
    elseif p299 == "Emote" then
        p298:_setEmote(l__CurrentState__54[p299], p300);
    elseif p299 == "Radio" then
        p298:_setRadio(l__CurrentState__54[p299], p300);
    elseif p299 == "Outline" then
        p298:_setOutline();
    elseif p299 == "TakeDown" then
        p298:_setTakeDown(l__CurrentState__54[p299], p300);
    elseif p299 == "PauseMenu" then
        p298:_toggleATAK(p300);
    elseif p299 == "Compass" then
        p298:_toggleCompass(p300);
    elseif p299 == "LockPick" then
        p298:_toggleLockPick(p300);
    elseif p299 == "Medical" then
        p298:_setMedical(p300);
    elseif p299 == "Hostage" then
        p298:_setHostage(p300);
    elseif p299 == "Tool" then
        p298:_setTool(p300);
    elseif p299 == "Smoker" then
        p298:_setSmoker(p300);
    elseif p299 == "Dragging" then
        p298:_setDragging(p300);
    elseif p299 == "Dragged" then
        p298:_setDragged(p300);
    elseif p299 == "Downed" then
        p298:_setDowned(p300);
    elseif p299 == "Turret" then
        p298._fixedTurret = p300;
    elseif p299 == "Known" then
        p298.Known = p300;
    elseif p299 == "BodyBag" then
        p298:_addBodyBagPrompt();
    elseif p299 == "LootInventory" then
        if p300 then
            p300.Parent = p298.Parts.LowerTorso;
            p300.CFrame = CFrame.new(0, 2, 0);
        end;
    elseif p299 == "LoopAnimation" then
        p298:_setLoopAnimation(l__CurrentState__54[p299], p300);
    elseif p299 == "Inventory" then
        for v301, v302 in p298._inventory do
            if not p300[v301] then
                if p298._equipped == v301 then
                    v302:Unequip();
                    p298._equipped = nil;
                end;
                v302:Destroy();
                p298._inventory[v301] = nil;
            end;
        end;
        for v303, v304 in p300 do
            if not p298._inventory[v303] and u16[v304.Name] then
                p298._inventory[v303] = u26[u16[v304.Name].Handler .. "InventoryReplicator"].new(p298, v304, p298.Replicator);
                if v303 == p298._equipped then
                    p298._inventory[v303]:Equip();
                end;
            end;
        end;
    elseif p299 == "Equip" then
        local l___equipped__55 = p298._equipped;
        if l___equipped__55 then
            if p298._inventory[l___equipped__55] then
                p298._inventory[l___equipped__55]:Unequip();
            end;
            p298._equipped = nil;
        end;
        if p300 then
            if p298._inventory[p300] then
                p298._inventory[p300]:Equip();
            end;
            p298._equipped = p300;
        end;
    elseif p299 == "Climbing" then
        if typeof(p300) == "boolean" then
            p298:_doLadderStep("Enter", p300);
        else
            p298:_doLadderStep("Exit", true);
        end;
    elseif p299 == "Dead" then
        p298._diedPosition = p300;
        p298.Health = 0;
    end;
    l__CurrentState__54[p299] = p300;
end;
function u29.Died(u305) --[[ Line: 1905 ]]
    -- upvalues: u5 (copy), u13 (copy)
    if u305._voiceEmitter then
        u305._voiceEmitter:Destroy();
    end;
    u305:_cancelVoice();
    if u305._downedAttachment then
        u305._downedAttachment:Destroy();
        u305._downedAttachment = nil;
        u305._downedPrompt = nil;
    end;
    u305.RootPart:Destroy();
    u305:_cleanUp();
    if u305._equipped then
        local v306 = u305._inventory[u305._equipped];
        if v306 then
            v306:Unequip();
        end;
        u305._equipped = nil;
    end;
    if u305._isInactive and u5.LOOTABLE_BODIES then
        u305.Character.Parent = workspace;
        u305._isInactive = false;
    end;
    u305._lastDeadCFrame = u305.Parts.LowerTorso.CFrame;
    if not u305._isInactive then
        pcall(u13, u305.Character);
        if u305._impulseOnDeath then
            u305.Parts.LowerTorso:ApplyImpulse((u305._impulseOnDeath + Vector3.new(0, 2, 0)).Unit * 1000);
        end;
        u305._anchor = task.delay(10, function() --[[ Line: 1938 ]]
            -- upvalues: u305 (copy)
            u305._anchor = nil;
            for _, v307 in u305.Parts do
                v307.Anchored = true;
            end;
        end);
    end;
end;
function u29.LoadAnimation(p308, p309) --[[ Line: 1947 ]]
    local v310 = p308._loadedAnimations[p309];
    if v310 then
        return v310;
    end;
    local v311 = Instance.new("Animation");
    v311.AnimationId = "rbxassetid://" .. p309;
    local v312 = p308._animator:LoadAnimation(v311);
    p308._loadedAnimations[p309] = v312;
    return v312;
end;
function u29.Replicate(p313, p314, p315, p316, p317, p318, p319, p320, p321, p322, p323) --[[ Line: 1961 ]]
    -- upvalues: u3 (copy)
    p313.Health = p314;
    p313.Platform = p317;
    p313.Orientation = p316;
    p313.LeanGoal = p322;
    if p313.HeightState ~= u3.CharacterHeightState.Vaulting and p319 == u3.CharacterHeightState.Vaulting then
        p313:Vault(p315.Y - p313.SimulatedPosition.Y);
    end;
    p313.SimulatedPosition = p315;
    if p313.HeightState == u3.CharacterHeightState.Standing and (p319 == u3.CharacterHeightState.Crouching and (p313.Sprinting and p313._isWalking)) then
        p313:Slide();
    end;
    p313.ServerPosition = p323;
    p313.Sprinting = p318;
    p313.HeightState = p319;
    p313._camera = Vector2.new(p320, p321);
end;
function u29.Slide(p324) --[[ Line: 1981 ]]
    -- upvalues: u2 (copy), u3 (copy), u7 (copy)
    local v325 = p324:LoadAnimation(u2:Get("Animation", "CharacterPacks", p324.AnimationKit, "Idle", "Slide").ID);
    v325.Priority = u3.AnimationPriority.Action;
    v325:Play();
    u7:CreateSound("Character", p324:_getHead(), true, "Foley", "Slide").Destroy(5);
    p324._sliding = tick();
    task.delay(1, v325.Stop, v325, 0.5);
end;
function u29.Vault(u326, u327, u328) --[[ Line: 1994 ]]
    -- upvalues: u7 (copy), u2 (copy), u3 (copy)
    local v329 = u327 > 5.5 and "Mid" or (u327 > 7 and "High" or "Low");
    u7:CreateSound("Character", u326:_getHead(), true, "Foley", "Vault", v329).Destroy(5);
    local u330 = u2:Get("Animation", "CharacterAnimations", "Vault", v329);
    local v331 = u326:LoadAnimation(u330.ID);
    v331.Priority = u3.AnimationPriority.Action;
    v331:Play(0);
    task.delay(0, function() --[[ Line: 2010 ]]
        -- upvalues: u326 (copy), u330 (copy), u327 (copy), u328 (copy)
        u326._heightDifference = u330.Asset.Height - u327;
        if u328 then
            u328();
        end;
    end);
    return u330.Asset.Timer;
end;
function u29.Update(p332, p333, p334, _, p335) --[[ Line: 2020 ]]
    -- upvalues: u5 (copy), u6 (copy), u3 (copy), l__PlayerGui__9 (copy), u22 (copy), l__TweenService__6 (copy), u2 (copy), u7 (copy), u10 (copy), u19 (copy), u9 (copy), u14 (copy), u17 (copy), l__ActiveWorld__11 (copy), l__InactiveWorld__10 (copy), u38 (copy), l__Lighting__2 (copy)
    local v336 = tick();
    if p332.Alive and p332.Health <= 0 then
        p332.Alive = false;
        p332:Died();
    end;
    if p332.Alive then
        local v337 = true;
        local v338 = true;
        local v339 = true;
        local v340 = 5;
        local v341 = u6(p335 * 10);
        local v342;
        if p332.IsLocalPlayer then
            v341 = 1;
            v342 = 1;
        else
            local l__Magnitude__56 = (p332.CFrame.Position - p334).Magnitude;
            v342 = l__Magnitude__56 < 64 and 1 or (l__Magnitude__56 < 128 and 2 or (l__Magnitude__56 < 256 and 3 or (l__Magnitude__56 < 512 and 4 or v340)));
            if l__Magnitude__56 > 3000 then
                v339 = false;
            end;
            if v342 > 2 and not (u5.IS_PVP or p332.OnScreen) then
                v338 = false;
            end;
            local l__ViewportOnScreen__57 = p332.ViewportOnScreen;
            if v342 > 2 and not l__ViewportOnScreen__57 then
                v339 = false;
                v338 = false;
                v337 = false;
            end;
            if l__ViewportOnScreen__57 then
                l__ViewportOnScreen__57 = v342 > 2;
            end;
            p332.LOD_OnScreen = l__ViewportOnScreen__57;
            p332.LOD_Distance = l__Magnitude__56;
            local l___spotted__58 = p332._spotted;
            local l__ServerPosition__59 = p332.ServerPosition;
            local v343 = 0;
            for v344, v345 in l___spotted__58 do
                if v345[1] <= 0 or (v345[2] - l__ServerPosition__59).Magnitude > 5 then
                    l___spotted__58[v344] = nil;
                else
                    v345[1] = v345[1] - p335;
                    v343 = math.max(v345[1], v343);
                end;
            end;
            if l__Magnitude__56 < 350 and v343 > 0 then
                if not p332._spottedHighlight then
                    local v346 = Instance.new("Highlight");
                    v346.FillTransparency = 1;
                    v346.OutlineColor = Color3.new(1, 0.5, 0);
                    v346.Adornee = p332.Character;
                    v346.DepthMode = u3.HighlightDepthMode.AlwaysOnTop;
                    v346.Enabled = true;
                    v346.Parent = l__PlayerGui__9;
                    p332._spottedHighlight = v346;
                end;
                p332._spottedHighlight.OutlineTransparency = 1 - math.clamp(v343, 0, 5) / 5;
            elseif p332._spottedHighlight then
                p332._spottedHighlight:Destroy();
                p332._spottedHighlight = nil;
            end;
        end;
        p332.Lean = u22.Lerp(p332.Lean, p332.LeanGoal, u6(p335 * 10));
        local v347 = p333 < 3 and v342 > 1 and true or v342 > 2;
        if v347 and not p332._lod then
            p332:_updateLOD(true);
        elseif not v347 and p332._lod then
            p332:_updateLOD(false);
        end;
        local v348 = p332.HeightState == u3.CharacterHeightState.Parachuting;
        local v349 = p332.HeightState == u3.CharacterHeightState.Vaulting and 1 or v341;
        local l___camera__60 = p332._camera;
        if l___camera__60 then
            if p332.Owner then
                p332.CameraX = u22.Lerp(p332.CameraX, l___camera__60.X, u6(p335 * 10));
                p332.CameraY = u22.Lerp(p332.CameraY, l___camera__60.Y, u6(p335 * 10));
            else
                p332.CameraX = l___camera__60.X;
                p332.CameraY = l___camera__60.Y;
            end;
        end;
        p332.Turret = nil;
        local v350 = nil;
        local v351 = nil;
        local v352 = nil;
        local v353 = true;
        local l__Rappelling__61 = p332.Rappelling;
        if l__Rappelling__61 then
            p332.Seat = nil;
            local l__OldSeat__62 = p332.OldSeat;
            if l__OldSeat__62 and l__OldSeat__62.Sit then
                l__OldSeat__62.Sit:Stop();
            end;
            p332.OldSeat = nil;
            local v354 = true;
            local v355 = tick() / 4 - p332._rappelStart / 4;
            local v356 = workspace:Raycast(p332.Position, Vector3.new(0, -3, 0), p332._clipParams);
            if v355 < 1 and not v356 then
                local l__Bin__63 = l__Rappelling__61.Bin;
                local v357 = #l__Bin__63 - 1;
                local v358 = l__TweenService__6:GetValue(v355, u3.EasingStyle.Sine, u3.EasingDirection.In) + 0;
                local v359 = v357 * math.clamp(v358, 0, 1) + 1;
                local v360 = math.floor(v359);
                local v361 = l__Bin__63[v360];
                local v362 = l__Bin__63[v360 + 1];
                local v363 = v361.Position:Lerp(v362.Position, v359 - v360);
                if v362.Position.Y < v361.Position.Y then
                    local v364 = CFrame.new(v363, v363 - l__Rappelling__61.Host.WorldCFrame.LookVector);
                    v352 = v364 * CFrame.Angles(0, 3.141592653589793, 0) - v364.Position + v363 + v364.LookVector * 1.5;
                    local v365 = v355 - 0.01;
                    local v366 = #l__Bin__63 - 1;
                    local v367 = l__TweenService__6:GetValue(v365, u3.EasingStyle.Sine, u3.EasingDirection.In) + 0;
                    local v368 = v366 * math.clamp(v367, 0, 1) + 1;
                    local v369 = math.floor(v368);
                    v350 = l__Bin__63[v369].Position:Lerp(l__Bin__63[v369 + 1].Position, v368 - v369);
                    local v370 = v355 - 0.02;
                    local v371 = #l__Bin__63 - 1;
                    local v372 = l__TweenService__6:GetValue(v370, u3.EasingStyle.Sine, u3.EasingDirection.In) + 0;
                    local v373 = v371 * math.clamp(v372, 0, 1) + 1;
                    local v374 = math.floor(v373);
                    v351 = l__Bin__63[v374].Position:Lerp(l__Bin__63[v374 + 1].Position, v373 - v374);
                    v353 = false;
                    v354 = false;
                end;
            end;
            if v354 then
                p332._rappelLoop:Stop(0);
                p332._rappelLoop = nil;
                p332._rappelLoopSound.Destroy();
                p332._rappelLoopSound = nil;
                local v375 = p332:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Rappel", "End").ID);
                v375.Priority = u3.AnimationPriority.Action;
                v375:Play(0);
                u7:CreateSound("Vehicle_Interaction", p332:_getHead(), true, "Foley", "Fastrope", "Land").Destroy(5);
                p332.Rappelling = nil;
            end;
        end;
        if p332.CurrentState.Dragging then
            local v376 = p332.Replicator.Actors[p332.CurrentState.Dragging];
            if v376 then
                local l__CFrame__64 = v376.Parts.UpperTorso.CFrame;
                v351 = l__CFrame__64:PointToWorldSpace(Vector3.new(0.25, 1, 0));
                v350 = l__CFrame__64:PointToWorldSpace(Vector3.new(-0.25, 1, 0));
            end;
        end;
        local l__Seat__65 = p332.Seat;
        local l__OldSeat__66 = p332.OldSeat;
        local v377 = l__OldSeat__66 or l__Seat__65;
        if v377 then
            v353 = false;
            v352 = u10:GetSeatCFrame(v377.UID, v377.Seat);
            if l__Seat__65 then
                if not l__OldSeat__66 then
                    p332.OldSeat = l__Seat__65;
                    local v378 = u2:Get("Animation", "VehicleSeat", l__Seat__65.Animations, "Enter");
                    local v379 = p332:LoadAnimation(v378.ID);
                    v379.Priority = u3.AnimationPriority.Action;
                    v379:Play(0);
                    local v380 = p332:LoadAnimation(u2:Get("Animation", "VehicleSeat", l__Seat__65.Animations, "Sit").ID);
                    v380.Priority = u3.AnimationPriority.Idle;
                    v380:Play(0);
                    u7:CreateSound("Vehicle_Interaction", p332:_getHead(), true, "VehicleSeat", l__Seat__65.Animations, "Enter").Destroy(5);
                    l__Seat__65.Sit = v380;
                    l__Seat__65.Track = v379;
                    l__Seat__65.Offset = v378.Asset.Offset;
                    l__Seat__65.Door = v378.Asset.Door;
                    l__Seat__65.Finish = v336 + v378.Asset.Time;
                    u2:Get("Animation", "VehicleSeat", l__Seat__65.Animations, "Exit"):Preload();
                    u2:Get("Sound", "VehicleSeat", l__Seat__65.Animations, "Exit"):Preload();
                    v353 = true;
                end;
                local l__Door__67 = v377.Door;
                if l__Door__67 then
                    local l__TimePosition__68 = v377.Track.TimePosition;
                    local v381;
                    if l__Door__67[1] <= l__TimePosition__68 then
                        v381 = l__TimePosition__68 <= l__Door__67[2];
                    else
                        v381 = false;
                    end;
                    u10:SetDoorPosition(v377.UID, v377.Seat, v381);
                end;
                u10:SetSeat(v377.UID, v377.Seat, p332);
                if v377.Track and (not v377.Track.IsPlaying or v377.Finish < v336) then
                    local v382 = u10:GetVehicle(v377.UID);
                    if v382 then
                        local l__SteeringWheel__69 = v382.SteeringWheel;
                        local v383 = v382.Turrets[v377.Seat];
                        if v382.DriverSeat == v377.Seat and l__SteeringWheel__69 then
                            if l__SteeringWheel__69.Left then
                                if l__SteeringWheel__69.Horn then
                                    v350 = l__SteeringWheel__69.Left.WorldPosition:Lerp(l__SteeringWheel__69.Horn.WorldPosition, v382.HornLerp);
                                else
                                    v350 = l__SteeringWheel__69.Left.WorldPosition;
                                end;
                            end;
                            v351 = l__SteeringWheel__69.Right.WorldPosition;
                        elseif v383 then
                            p332.Turret = v383;
                            if v383.Left then
                                v350 = v383.Left.Position;
                            end;
                            if v383.Right then
                                v351 = v383.Right.Position;
                            end;
                        end;
                    else
                        p332.Seat = nil;
                    end;
                end;
            elseif l__OldSeat__66 then
                if not l__OldSeat__66.Exited then
                    local v384 = u2:Get("Animation", "VehicleSeat", l__OldSeat__66.Animations, "Exit");
                    local v385 = p332:LoadAnimation(v384.ID);
                    v385.Priority = u3.AnimationPriority.Action;
                    v385:Play(0);
                    u7:CreateSound("Vehicle_Interaction", p332:_getHead(), true, "VehicleSeat", l__OldSeat__66.Animations, "Exit").Destroy(5);
                    l__OldSeat__66.Track = v385;
                    l__OldSeat__66.Door = v384.Asset.Door;
                    l__OldSeat__66.Exited = v336 + v384.Asset.Time;
                    l__OldSeat__66.Finish = v336 + v384.Asset.Time;
                    if l__OldSeat__66.Sit then
                        l__OldSeat__66.Sit:Stop();
                    end;
                end;
                local v386;
                if l__OldSeat__66.Exited < v336 then
                    p332.OldSeat = nil;
                    u10:SetSeat(l__OldSeat__66.UID, l__OldSeat__66.Seat, nil);
                    v386 = true;
                else
                    v386 = false;
                end;
                if l__OldSeat__66.SkipFrame and v352 then
                    v352 = v352:ToWorldSpace(l__OldSeat__66.Offset or CFrame.new());
                    local v387;
                    if p332.IsLocalPlayer and workspace:Raycast(v352.Position, v352.Position - v352.Position, p332._clipParams) then
                        local v388 = workspace:Raycast(v352.Position + Vector3.new(0, 25, 0), Vector3.new(0, -30, 0), p332._landParams);
                        if v388 then
                            v387 = v388.Position + Vector3.new(0, 3.5, 0);
                        else
                            v387 = v352.Position;
                        end;
                    else
                        v387 = nil;
                    end;
                    if v387 then
                        v352 = CFrame.new(v387);
                    end;
                end;
                l__OldSeat__66.SkipFrame = true;
                local l__Door__70 = l__OldSeat__66.Door;
                if l__Door__70 then
                    local l__TimePosition__71 = l__OldSeat__66.Track.TimePosition;
                    local v389;
                    if l__Door__70[1] <= l__TimePosition__71 and l__TimePosition__71 <= l__Door__70[2] then
                        v389 = not v386;
                    else
                        v389 = false;
                    end;
                    u10:SetDoorPosition(l__OldSeat__66.UID, l__OldSeat__66.Seat, v389);
                end;
            end;
        end;
        if not v353 then
            v352 = v352 or p332.CFrame;
            local _, v390 = v352:ToOrientation();
            p332._lastCFrame = v352;
            p332.Position = v352.Position;
            p332.SimulatedPosition = v352.Position;
            p332.Orientation = v390;
            p332.Direction = Vector3.new();
        end;
        local l___animationCache__72 = p332._animationCache;
        if v353 then
            local l__SimulatedPosition__73 = p332.SimulatedPosition;
            local l___lastCFrame__74 = p332._lastCFrame;
            Vector3.new();
            local v391 = p332._oldDirection or Vector3.new(0, 0, 0);
            local l___fixedTurret__75 = p332._fixedTurret;
            if l___fixedTurret__75 then
                p332.Turret = l___fixedTurret__75;
                if l___fixedTurret__75.Rig then
                    local v392 = l___fixedTurret__75.Rig:FindFirstChild("Left");
                    if v392 then
                        v350 = v392.Position;
                    end;
                    local v393 = l___fixedTurret__75.Rig:FindFirstChild("Right");
                    if v393 then
                        v351 = v393.Position;
                    end;
                end;
            end;
            local v394;
            if p332.Platform then
                local v395 = u10:GetHitboxCFrame(p332.Platform);
                if not p332._wasPlatform then
                    l___lastCFrame__74 = l___lastCFrame__74 - l___lastCFrame__74.Position + v395:PointToObjectSpace(l___lastCFrame__74.Position);
                end;
                local v396 = l___lastCFrame__74:Lerp(CFrame.new(l__SimulatedPosition__73) * CFrame.Angles(0, p332.Orientation, 0), v349);
                v394 = v395:ToWorldSpace(v396).Position - v395:ToWorldSpace(l___lastCFrame__74).Position;
                local l__Position__76 = v396.Position;
                v352 = v396 - l__Position__76 + v395:PointToWorldSpace(l__Position__76);
                p332._lastCFrame = v396;
                p332._wasPlatform = p332.Platform;
            else
                if p332._wasPlatform then
                    local v397 = u10:GetHitboxCFrame(p332._wasPlatform);
                    l___lastCFrame__74 = l___lastCFrame__74 - l___lastCFrame__74.Position + v397:PointToWorldSpace(l___lastCFrame__74.Position);
                end;
                v352 = l___lastCFrame__74:Lerp(CFrame.new(l__SimulatedPosition__73) * CFrame.Angles(0, p332.Orientation, 0), v349);
                v394 = v352.Position - l___lastCFrame__74.Position;
                p332._lastCFrame = v352;
                p332._wasPlatform = nil;
            end;
            local l__Position__77 = v352.Position;
            p332.Position = l__Position__77;
            p332.Direction = Vector2.new(v394.X, v394.Z);
            p332._oldDirection = v394;
            local v398 = u19:GetWaveHeight(l__Position__77, true) + u9.World.Water.Height;
            local v399 = u9:InWater(l__Position__77);
            if v399 then
                v399 = l__Position__77.Y - (p332.Swimming and 1.5 or 0) < v398;
            end;
            p332.Swimming = v399;
            p332.WaterLevel = v398;
            if p332._downedAnimation and not p332.Downed then
                p332._downedAnimation:Stop();
                p332._downedAnimation = nil;
            end;
            local v400 = p332.HeightState == u3.CharacterHeightState.Skydiving;
            if not v400 then
                p332._skydiveLerp = 0;
            end;
            if p332.HeightState == u3.CharacterHeightState.Standing and p332._lastHeightState == u3.CharacterHeightState.Falling then
                p332:_doJump(false);
                if p332.ViewModel then
                    p332.ViewModel.Jump:Impulse(-1);
                end;
            end;
            p332._lastHeightState = p332.HeightState;
            if v348 then
                if not l___animationCache__72.Parachute_Idle then
                    local v401 = p332:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Parachute", "Idle").ID);
                    v401.Priority = u3.AnimationPriority.Core;
                    l___animationCache__72.Parachute_Idle = v401;
                end;
                if not l___animationCache__72.Parachute_Right then
                    local v402 = p332:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Parachute", "Right").ID);
                    v402.Priority = u3.AnimationPriority.Movement;
                    l___animationCache__72.Parachute_Right = v402;
                end;
                if not l___animationCache__72.Parachute_Left then
                    local v403 = p332:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Parachute", "Left").ID);
                    v403.Priority = u3.AnimationPriority.Movement;
                    l___animationCache__72.Parachute_Left = v403;
                end;
                for v404, v405 in l___animationCache__72 do
                    if v404 == "Parachute_Idle" or (v404 == "Parachute_Right" or v404 == "Parachute_Left") then
                        if not v405.IsPlaying then
                            v405:Play(0);
                        end;
                    elseif v405.IsPlaying then
                        v405:Stop(0);
                    end;
                end;
                local v406 = v352:VectorToObjectSpace(v394);
                l___animationCache__72.Parachute_Left:AdjustWeight(math.clamp(-v406.X, 0.01, 0.1) / 0.1);
                l___animationCache__72.Parachute_Right:AdjustWeight(math.clamp(v406.X, 0.01, 0.1) / 0.1);
                local v407 = math.abs(v406.X);
                local v408 = math.sqrt(v407) / 0.1 * math.sign(v406.X);
                p332._parachuteLeanLerp = u22.Lerp(p332._parachuteLeanLerp or 0, v408, u6(p335 * 2));
                if not p332._parachuteModel then
                    local v409 = u2:Get("Shared", "Models", "Parachute", "Default").Asset:Clone();
                    v409.Name = "Model";
                    v409.Parent = p332.Character;
                    p332:_createEquipWeld("UpperTorso", v409.Harness);
                    p332:_createEquipWeld("UpperTorso", v409.Parachute);
                    p332:_createEquipWeld("RightHand", v409.R);
                    p332:_createEquipWeld("LeftHand", v409.L);
                    p332._parachuteModel = v409;
                end;
            elseif v400 then
                for _, v410 in l___animationCache__72 do
                    if v410.IsPlaying then
                        v410:Stop(0);
                    end;
                end;
                local l__Unit__78 = (v394 - v391).Unit;
                local v411 = l__Unit__78 ~= l__Unit__78 and Vector3.new(0, 0, 0) or l__Unit__78;
                local v412 = v352:VectorToObjectSpace(v394) + v352:VectorToObjectSpace(v411);
                local v413 = u22.Lerp(p332._spit, math.noise(tick() % 1000000, tick() % 1000000, 0), u6(p335 * 10));
                p332._twist = u22.Lerp(p332._twist, math.clamp(v412.X, -0.4, 0.4), u6(p335 * 5));
                p332._tilt = u22.Lerp(p332._tilt, math.clamp(v412.Z, -0.4, 0.4), u6(p335 * 5));
                p332._spit = v413;
                p332._motorGoals = {
                    Head = CFrame.new(0, 0, 0) * CFrame.Angles(p332._tilt, -p332._twist, 0),
                    RightUpperArm = CFrame.new(-0.1, -0.25, -0.5) * CFrame.Angles(1.5707963267948966 + p332._tilt + v413 / 3, p332._tilt * 1.5, p332._twist / 1.5 + 1.5707963267948966),
                    LeftUpperArm = CFrame.new(0.1, -0.25, -0.5) * CFrame.Angles(1.5707963267948966 + p332._tilt + v413 / 3, -p332._tilt * 1.5, p332._twist / 1.5 - 1.5707963267948966),
                    RightLowerArm = CFrame.new(0, 0, 0) * CFrame.Angles(p332._tilt + 1.0471975511965976, 0, 0),
                    LeftLowerArm = CFrame.new(0, 0, 0) * CFrame.Angles(p332._tilt + 1.0471975511965976, 0, 0),
                    RightUpperLeg = CFrame.new(0, 0, 0) * CFrame.Angles(-0.5235987755982988, 0, 0.3141592653589793 + v413 / 3),
                    LeftUpperLeg = CFrame.new(0, 0, 0) * CFrame.Angles(-0.5235987755982988, 0, -0.3141592653589793 - v413 / 3),
                    RightLowerLeg = CFrame.new(0, 0, 0) * CFrame.Angles(-0.7853981633974483 + -p332._tilt * 1.5 + v413 / 6, 0, 0),
                    LeftLowerLeg = CFrame.new(0, 0, 0) * CFrame.Angles(-0.7853981633974483 + -p332._tilt * 1.5 + v413 / 6, 0, 0)
                };
                p332._skydiveLerp = u22.Lerp(p332._skydiveLerp, 1, u6(p335 * 5));
                p332._motorGoal = p332._skydiveLerp;
                v352 = v352 * CFrame.new():Lerp(CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.Angles(0, p332._twist + v413 / 3, 0) * CFrame.Angles(p332._tilt + v413 / 3, 0, 0), p332._skydiveLerp);
            elseif p332.Downed then
                for _, v414 in l___animationCache__72 do
                    if v414.IsPlaying then
                        v414:Stop(0);
                    end;
                end;
                if not p332._downedAnimation then
                    local v415 = p332:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Downed", "Start").ID);
                    v415.Looped = false;
                    v415.Priority = u3.AnimationPriority.Movement;
                    v415:Play(0);
                    local v416 = p332:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Downed", "Loop").ID);
                    v416.Looped = true;
                    v416.Priority = u3.AnimationPriority.Idle;
                    v416:Play();
                    p332._downedAnimation = v416;
                end;
            elseif v338 and v339 then
                local v417 = p332.HeightState or 0;
                local v418 = p332.Direction.Magnitude / p335;
                if v418 == v418 then
                    p332._speedSmoothing = u22.Lerp(p332._speedSmoothing, v418, p335 * 20);
                end;
                local l___speedSmoothing__79 = p332._speedSmoothing;
                local v419;
                if l___speedSmoothing__79 > 1 and (v417 ~= u3.CharacterHeightState.Vaulting and v417 ~= u3.CharacterHeightState.Skydiving) then
                    v419 = v417 ~= u3.CharacterHeightState.Parachuting;
                else
                    v419 = false;
                end;
                local l__AnimationKit__80 = p332.AnimationKit;
                p332._isWalking = v419;
                local v420 = "Jog";
                local v421 = "Standing";
                if v417 == u3.CharacterHeightState.Crouching then
                    v420 = "Crouch";
                    v421 = "Crouch";
                elseif v417 == u3.CharacterHeightState.Proning then
                    v420 = "Prone";
                    v421 = "Prone";
                elseif p332.Sprinting then
                    v420 = "Sprint";
                end;
                local v422 = nil;
                local v423 = nil;
                if p332._lastIdle == "Standing" and v421 == "Prone" then
                    v423 = "IdleToProne";
                    v422 = "IdleToProne";
                elseif p332._lastIdle == "Crouch" and v421 == "Prone" then
                    v423 = "CrouchToProne";
                    v422 = "IdleToProne";
                elseif p332._lastIdle == "Prone" and v421 == "Standing" then
                    v423 = "ProneToIdle";
                    v422 = "ProneToIdle";
                elseif p332._lastIdle == "Prone" and v421 == "Crouch" then
                    v423 = "ProneToCrouch";
                    v422 = "ProneToIdle";
                elseif p332._lastIdle == "Standing" and v421 == "Crouch" then
                    v422 = "IdleToCrouch";
                elseif p332._lastIdle == "Crouch" and v421 == "Standing" then
                    v422 = "CrouchToIdle";
                end;
                if v422 then
                    u7:CreateSound("Footsteps", p332:_getHead(), true, "Foley", "HeightState", v422).Destroy(10);
                end;
                if v423 then
                    local v424 = p332:LoadAnimation(u2:Get("Animation", "CharacterPacks", l__AnimationKit__80, "Idle", v423).ID);
                    v424.Priority = u3.AnimationPriority.Movement;
                    v424:Play(0);
                end;
                p332._lastIdle = v421;
                if v417 == u3.CharacterHeightState.Climbing then
                    local v425 = u2:Get("Animation", "CharacterAnimations", "Climb", "TP");
                    local l___heightAnimation__81 = p332._heightAnimation;
                    if l___heightAnimation__81 then
                        l___heightAnimation__81:AdjustSpeed((v352.Position.Y - p332._lastHeight) / p335 / 5);
                        if l___heightAnimation__81.TimePosition >= v425.Asset.Length / 2 then
                            if not p332._ladderHalf then
                                p332._ladderHalf = true;
                                p332:_doLadderStep("Step", p332.CurrentState.Climbing);
                            end;
                        elseif p332._ladderHalf then
                            p332._ladderHalf = false;
                            p332:_doLadderStep("Step", p332.CurrentState.Climbing);
                        end;
                    else
                        local v426 = p332:LoadAnimation(v425.ID);
                        v426.Priority = u3.AnimationPriority.Movement;
                        v426:Play(0);
                        p332._heightAnimation = v426;
                    end;
                    p332._lastHeight = v352.Position.Y;
                elseif p332._heightAnimation then
                    p332._heightAnimation:Stop();
                    p332._heightAnimation = nil;
                end;
                if v419 then
                    local v427 = p332._animationLerp:Lerp(CFrame.lookAt(Vector3.new(0, 0, 0), v352.LookVector):ToObjectSpace(CFrame.lookAt(Vector3.new(0, 0, 0), (Vector3.new(v394.X, 0, v394.Z)))), p332._animationStill and 1 or u6(p335 * 5));
                    p332._animationStill = false;
                    if p332._animationState ~= v420 then
                        p332._animationState = v420;
                        p332._animationCycle = 0;
                    end;
                    local _, v428 = v427:ToOrientation();
                    if v428 == v428 then
                        p332._animationLerp = v427;
                    else
                        v427 = p332._animationLerp;
                        local v429;
                        v429, v428 = v427:ToOrientation();
                    end;
                    local _, _, _, _, _, v430 = v427:GetComponents();
                    local v431 = math.deg(v428);
                    local v432 = "N";
                    local v433 = "N";
                    local v434 = 1;
                    if v431 <= 0 and v431 >= -45 then
                        v434 = math.abs(v431) / 45;
                        v433 = "NE";
                        v432 = "N";
                    elseif v431 <= -45 and v431 >= -90 then
                        v434 = (math.abs(v431) - 45) / 45;
                        v433 = "E";
                        v432 = "NE";
                    elseif v431 <= -90 and v431 >= -135 then
                        v434 = (math.abs(v431) - 90) / 45;
                        v433 = "SE";
                        v432 = "E";
                    elseif v431 <= -135 and v431 >= -185 then
                        v434 = (math.abs(v431) - 135) / 45;
                        v433 = "S";
                        v432 = "SE";
                    elseif v431 >= 0 and v431 <= 45 then
                        v434 = math.abs(v431) / 45;
                        v433 = "NW";
                        v432 = "N";
                    elseif v431 >= 45 and v431 <= 90 then
                        v434 = (v431 - 45) / 45;
                        v433 = "W";
                        v432 = "NW";
                    elseif v431 >= 90 and v431 <= 135 then
                        v434 = (v431 - 90) / 45;
                        v433 = "SW";
                        v432 = "W";
                    elseif v431 >= 135 and v431 <= 185 then
                        v434 = (v431 - 130) / 45;
                        v433 = "S";
                        v432 = "SW";
                    end;
                    if v420 == "Sprint" then
                        if v433 == "SE" or (v432 == "SE" or (v433 == "E" or v432 == "E")) then
                            v433 = "NE";
                            v434 = 1;
                            v432 = "N";
                        elseif v433 == "SW" or (v432 == "SW" or (v433 == "W" or v432 == "W")) then
                            v433 = "NW";
                            v434 = 1;
                            v432 = "N";
                        end;
                    end;
                    local v435 = math.clamp(v434, 0, 1);
                    local v436 = string.format("%s_%s_%s", l__AnimationKit__80, v420, v432);
                    if not l___animationCache__72[v436] then
                        local v437 = p332:LoadAnimation(u2:Get("Animation", "CharacterPacks", l__AnimationKit__80, v420, v432).ID);
                        v437.Priority = u3.AnimationPriority.Idle;
                        v437.Looped = true;
                        l___animationCache__72[v436] = v437;
                    end;
                    local v438 = string.format("%s_%s_%s", l__AnimationKit__80, v420, v433);
                    if not l___animationCache__72[v438] then
                        local v439 = p332:LoadAnimation(u2:Get("Animation", "CharacterPacks", l__AnimationKit__80, v420, v433).ID);
                        v439.Priority = u3.AnimationPriority.Idle;
                        v439.Looped = true;
                        l___animationCache__72[v438] = v439;
                    end;
                    local v440 = l___animationCache__72[v436];
                    local v441 = l___animationCache__72[v438];
                    for _, v442 in l___animationCache__72 do
                        local v443 = (v442 == v440 or v442 == v441) and true or v442 == p332._lastIdleTrack;
                        if v442.IsPlaying and not v443 then
                            v442:Stop(0.2);
                        elseif not v442.IsPlaying and v443 then
                            v442:Play(0, 0, 0);
                        end;
                    end;
                    local l___sliding__82 = p332._sliding;
                    if l___sliding__82 then
                        l___sliding__82 = tick() - p332._sliding < 1;
                    end;
                    local v444 = l___sliding__82 and 0 or l___speedSmoothing__79;
                    local l__Asset__83 = u2:Get("Animation", "CharacterPacks", l__AnimationKit__80, v420, "N").Asset;
                    local v445 = p332._animationCycle + p335 * (v444 / l__Asset__83.Speed);
                    p332._animationCycle = v445;
                    p332.Tilt = v430 * (v444 / l__Asset__83.Speed);
                    local v446 = v445 % l__Asset__83.Duration;
                    v440.TimePosition = v446;
                    v441.TimePosition = v446;
                    local v447 = v446 / l__Asset__83.Duration;
                    p332.Cycle = v447 * 3.141592653589793 * 4;
                    if v342 <= 2 and not l___sliding__82 then
                        if v447 > 0.5 then
                            if p332._footStep then
                                p332._footStep = false;
                                p332:_doFootstep(v420, p332.Parts.RightFoot);
                            end;
                        elseif not p332._footStep then
                            p332._footStep = true;
                            p332:_doFootstep(v420, p332.Parts.LeftFoot);
                        end;
                    end;
                    if p332._wasSprinting and not p332.Sprinting then
                        p332:_doFootstep(v420, p332.Parts.LeftFoot);
                        if v336 - p332._lastSprinting > 2 then
                            p332._sprintBreath = v336 + 10;
                        end;
                    elseif not p332._wasSprinting and p332.Sprinting then
                        p332._lastSprinting = v336;
                    end;
                    p332._wasSprinting = p332.Sprinting;
                    if not p332._lastWalkTime then
                        p332._lastWalkTime = tick();
                    end;
                    local v448 = math.clamp(v336 - p332._lastWalkTime, 0, 0.2) * 5;
                    v440:AdjustWeight((1 - v435) * v448, 0);
                    v441:AdjustWeight(v435 * v448, 0);
                    p332._trackFrom = v440;
                    p332._trackTo = v441;
                    if p332._lastIdleTrack then
                        p332._lastIdleTrack:AdjustWeight(1 - v448, 0);
                    end;
                else
                    p332._lastWalkTime = nil;
                    p332._animationCycle = 0;
                    p332._animationStill = true;
                    local v449 = string.format("%s_%s_%s", l__AnimationKit__80, "Idle", v421);
                    local v450 = u2:Get("Animation", "CharacterPacks", l__AnimationKit__80, "Idle", v421);
                    local l__Is360__84 = v450.Asset.Is360;
                    if not l___animationCache__72[v449] then
                        local v451 = p332:LoadAnimation(v450.ID);
                        v451.Priority = u3.AnimationPriority.Core;
                        v451.Looped = not l__Is360__84;
                        l___animationCache__72[v449] = v451;
                    end;
                    local v452 = l___animationCache__72[v449];
                    for _, v453 in l___animationCache__72 do
                        if v453 ~= p332._trackFrom and v453 ~= p332._trackTo and v453 ~= v452 and v453.IsPlaying then
                            v453:Stop(0.2);
                        end;
                    end;
                    if not v452.IsPlaying then
                        v452:Play(0, 0, l__Is360__84 and 0 or 1);
                    end;
                    v452:AdjustWeight(1, 0);
                    if p332._trackFrom then
                        p332._trackFrom:AdjustWeight(u22.Lerp(p332._trackFrom.WeightCurrent, 0, u6(p335 * 10)), 0);
                    end;
                    if p332._trackTo then
                        p332._trackTo:AdjustWeight(u22.Lerp(p332._trackTo.WeightCurrent, 0, u6(p335 * 10)), 0);
                    end;
                    if l__Is360__84 then
                        local l__Length__85 = v450.Asset.Length;
                        local _, v454 = v352:ToOrientation();
                        v452.TimePosition = math.clamp(l__Length__85 - (p332.CameraX - v454) % 6.283185307179586 / 6.283185307179586 * l__Length__85, 0.01, 0.99);
                    end;
                    p332._lastIdleTrack = v452;
                end;
                p332.Walking = v419;
            end;
        else
            p332._animationCycle = 0;
            p332._animationStill = true;
            p332._lastWalkTime = nil;
            p332.Walking = false;
            for _, v455 in l___animationCache__72 do
                if v455.IsPlaying then
                    v455:Stop();
                end;
            end;
        end;
        if not v348 and p332._parachuteModel then
            p332._parachuteModel:Destroy();
            p332._parachuteModel = nil;
        end;
        local l___voiceClient__86 = p332._voiceClient;
        local l__LocalClient__87 = u14.LocalClient;
        if l___voiceClient__86 then
            local v456 = (not u5.IS_PVP or l__LocalClient__87.Squad == l___voiceClient__86.Squad) and true or false;
            if l___voiceClient__86.Transmitting then
                if v456 and (l__LocalClient__87.Channel == l___voiceClient__86.Channel and (l__LocalClient__87.Actor and (l__LocalClient__87.Actor.Alive and (not u5.RADIO_STRICT or l__LocalClient__87.HasRadio)))) then
                    p332._radioWire.TargetInstance = u7.Channels.Radio;
                else
                    p332._radioWire.TargetInstance = nil;
                end;
                p332:_togglePTT(true);
                p332._transmitting = true;
            elseif p332._transmitting then
                p332._radioWire.TargetInstance = nil;
                p332:_togglePTT(false);
                p332._transmitting = nil;
            end;
        elseif p332.IsLocalPlayer then
            p332:_togglePTT(l__LocalClient__87.ClientTransmitting);
        end;
        local l__Focused__88 = p332.Focused;
        local l___loaded__89 = p332._loaded;
        local v457 = not l__Focused__88;
        if v457 then
            if l___loaded__89 then
                if v339 then
                    l___loaded__89 = not u17.TabletOpen;
                else
                    l___loaded__89 = v339;
                end;
            end;
        else
            l___loaded__89 = v457;
        end;
        if l___loaded__89 and p332._isInactive then
            p332._isInactive = false;
            p332.Character.Parent = l__ActiveWorld__11;
            if p332._emitterWire and not u5.IS_PVP then
                p332._emitterWire.TargetInstance = p332._voiceEmitter;
            end;
        elseif not (l___loaded__89 or p332._isInactive) then
            p332._isInactive = true;
            p332.Character.Parent = l__InactiveWorld__10;
            if p332._emitterWire then
                p332._emitterWire.TargetInstance = nil;
            end;
        end;
        local v458 = not (p332.IgnoreIK and p332.IgnoreIK.IsPlaying) and v342 ~= 5 and true or false;
        local l__Bipod__90 = p332.Bipod;
        if l__Bipod__90 and not l__Bipod__90.Reloading then
            v350 = l__Bipod__90.Left.WorldCFrame:ToWorldSpace(CFrame.new(0, -0.5, 0)).Position;
            v351 = l__Bipod__90.Right.WorldCFrame:ToWorldSpace(CFrame.new(0, -0.5, 0));
        end;
        if v338 and v339 then
            local l___motors__91 = p332._motors;
            local v459 = v352:ToWorldSpace(p332.RootPart.CFrame:ToObjectSpace(p332.Parts.UpperTorso.CFrame));
            local v460;
            if v350 and (v458 and not (p332._atakAnimation or (p332._compassAnimation or p332._pttAnimation))) then
                local v461, v462, v463 = u38(v459 * p332._leftUpperC0, v350);
                p332._targetLeftUpper = v459:ToObjectSpace(v461) * CFrame.Angles(v462, 0, 0);
                p332._targetLeftLower = p332._leftLowerC0 * CFrame.Angles(v463, 0, 0);
                v460 = 1;
            else
                v460 = 0;
            end;
            local l___leftArmLerp__92 = p332._leftArmLerp;
            l___motors__91.LeftUpperArm.C0 = p332._leftUpperC0:Lerp(p332._targetLeftUpper, l___leftArmLerp__92);
            l___motors__91.LeftLowerArm.C0 = p332._leftLowerC0:Lerp(p332._targetLeftLower, l___leftArmLerp__92);
            p332._leftArmLerp = u22.Lerp(l___leftArmLerp__92, v460, u6(p335 * 2));
            local v464;
            if v351 and v458 then
                local v465 = u38;
                local v466 = v459 * p332._rightUpperC0;
                local v467;
                if typeof(v351) == "CFrame" then
                    v467 = v351.Position or v351;
                else
                    v467 = v351;
                end;
                local v468, v469, v470 = v465(v466, v467);
                p332._targetRightUpper = v459:ToObjectSpace(v468) * CFrame.Angles(v469, 0, 0);
                p332._targetRightLower = p332._rightLowerC0 * CFrame.Angles(v470, 0, 0);
                v464 = 1;
            else
                v464 = 0;
            end;
            local l___rightArmLerp__93 = p332._rightArmLerp;
            l___motors__91.RightUpperArm.C0 = p332._rightUpperC0:Lerp(p332._targetRightUpper, l___rightArmLerp__93);
            l___motors__91.RightLowerArm.C0 = p332._rightLowerC0:Lerp(p332._targetRightLower, l___rightArmLerp__93);
            p332._rightArmLerp = u22.Lerp(l___rightArmLerp__93, v464, u6(p335 * 2));
            if typeof(v351) == "CFrame" then
                l___motors__91.RightHand.C0 = p332.Parts.RightLowerArm.CFrame:ToObjectSpace(v351);
                l___motors__91.RightHand.C1 = CFrame.new(-0.5, 0, 0) * CFrame.Angles(-1.5707963267948966, 0, 0);
            else
                l___motors__91.RightHand.C0 = CFrame.new(0, -0.5, 0);
                l___motors__91.RightHand.C1 = CFrame.new(0, 0.15, 0);
            end;
            if l__Bipod__90 and not l__Bipod__90.Reloading then
                p332._leftArmLerp = 1;
                p332._rightArmLerp = 1;
                p332._wasBipod = true;
            elseif p332._wasBipod then
                p332._leftArmLerp = 0;
                p332._rightArmLerp = 0;
                p332._wasBipod = nil;
            end;
            if p332._compassRotate then
                local _, v471 = p332._compassModel.PrimaryPart.CFrame:ToOrientation();
                p332._compassRotate.C1 = p332._compassRotate.C1:Lerp(CFrame.Angles(0, v471, 0), u6(p335 * 10));
            end;
            p332._doStepped = true;
            if v342 == 1 or p332._nextClose then
                if p332._nextBlink and p332._nextBlink < v336 or v336 < p332._nextCough then
                    p332._white.Texture = "rbxassetid://111680152894536";
                    p332._pupil.Transparency = 1;
                    p332._nextBlink = nil;
                    p332._nextOpen = v336 + 0.1;
                elseif p332._nextOpen and p332._nextOpen < v336 then
                    p332._white.Texture = p332._whiteTexture;
                    p332._pupil.Transparency = 0;
                    p332._nextOpen = nil;
                    p332._nextBlink = v336 + Random.new():NextNumber(5, 15);
                end;
                if l__Lighting__2:GetAttribute("IsSnowing") or p332._nextClose then
                    local l___snow__94 = p332._snow;
                    local l___sprintBreath__95 = p332._sprintBreath;
                    if l___sprintBreath__95 then
                        l___sprintBreath__95 = v336 < p332._sprintBreath;
                    end;
                    if p332._nextBreath and (p332._nextBreath < v336 and (p332._lastTalk + 2 < v336 and p332._nextCough < v336)) then
                        p332._mouthOpen = true;
                        l___snow__94.Enabled = not p332._mouthCancel or false;
                        p332._nextBreath = nil;
                        p332._nextClose = v336 + (l___sprintBreath__95 and 0.5 or 1);
                    elseif p332._nextClose and p332._nextClose < v336 then
                        p332._mouthOpen = false;
                        l___snow__94.Enabled = false;
                        p332._nextClose = nil;
                        p332._nextBreath = v336 + (l___sprintBreath__95 and 0.5 or 4);
                    end;
                end;
                if p332._audioAnalyzer.RmsLevel > 0.05 then
                    p332._lastTalk = tick();
                end;
                p332._mouth.Texture = (p332._mouthOpen or (v336 < p332._lastTalk + 0.2 or v336 < p332._nextCough)) and "rbxassetid://11449704810" or p332._mouthTexture;
            end;
        else
            p332._rightArmLerp = v351 and v458 and 1 or 0;
            p332._leftArmLerp = v350 and (v458 and not (p332._atakAnimation or (p332._compassAnimation or p332._pttAnimation))) and 1 or 0;
        end;
        p332._heightDifference = u22.Lerp(p332._heightDifference, 0, u6(p335 * 5));
        local v472 = v352 + Vector3.new(0, p332._heightDifference, 0);
        p332.CFrame = v472;
        local l___noLean__96 = p332._noLean;
        local v473 = (p332.HeightState == u3.CharacterHeightState.Climbing or (tick() < p332.NoLean or p332.Forced)) and 1 or 0;
        p332._noLean = math.lerp(l___noLean__96, v473, u6(p335 * 5));
        p332.UseClient = v337 and v339;
        if p332.UseClient then
            p332._queueItemRender = { p333, v342 };
            return v472, p332.RootPart;
        end;
    elseif p332._stuckTorso or not u5.LOOTABLE_BODIES then
    else
        local l__LowerTorso__97 = p332.Parts.LowerTorso;
        local l__CFrame__98 = l__LowerTorso__97.CFrame;
        if p332._diedPosition then
            if (p332._diedPosition - l__CFrame__98.Position).Magnitude >= 10 then
                p332._stuckTorso = true;
                l__LowerTorso__97.Anchored = true;
                if not p332._lastDeadCFrame or (p332._lastDeadCFrame.Position - p332._diedPosition).Magnitude > 10 then
                    p332._lastDeadCFrame = CFrame.new(p332._diedPosition);
                end;
                l__LowerTorso__97.CFrame = p332._lastDeadCFrame;
            else
                p332._lastDeadCFrame = l__CFrame__98;
            end;
        end;
    end;
end;
function u29.AddMessage(p474, p475, p476) --[[ Line: 2995 ]]
    -- upvalues: u28 (copy), l__TextService__5 (copy), l__Debris__1 (copy)
    local l___billboardGui__99 = p474._billboardGui;
    if p474._billboardGui then
        local l__AbsoluteSize__100 = l___billboardGui__99.AbsoluteSize;
        local v477 = Instance.new("GetTextBoundsParams");
        v477.Text = p476;
        v477.Font = u28;
        v477.Size = l__AbsoluteSize__100.Y * 0.02;
        v477.Width = l__AbsoluteSize__100.X;
        local v478 = l__TextService__5:GetTextBoundsAsync(v477);
        local v479 = p474._chatsFrame:FindFirstChild(p475);
        if not v479 then
            v479 = Instance.new("TextLabel");
            v479.Name = p475;
            v479.FontFace = u28;
            v479.TextScaled = true;
            v479.BorderSizePixel = 0;
            v479.BackgroundColor3 = Color3.fromRGB(25, 25, 25);
            v479.TextColor3 = Color3.new(1, 1, 1);
            v479.LayoutOrder = p474._chatOrder;
            p474._chatOrder = p474._chatOrder + 1;
            l__Debris__1:AddItem(v479, 10);
        end;
        v479.Text = p476;
        v479.Size = UDim2.fromScale(v478.X / l__AbsoluteSize__100.X, v478.Y / l__AbsoluteSize__100.X);
        v479.Parent = p474._chatsFrame;
    end;
end;
function u29.Render(p480, p481) --[[ Line: 3029 ]]
    for _, v482 in p480._inventory do
        if v482.Drone then
            v482.Drone:Update(p481);
        end;
    end;
    local l___queueItemRender__101 = p480._queueItemRender;
    if l___queueItemRender__101 and p480.Alive then
        for _, v483 in p480._inventory do
            v483:Update(l___queueItemRender__101[1], l___queueItemRender__101[2], p481);
        end;
        local l__Helmet__102 = p480.Helmet;
        if l__Helmet__102 then
            l__Helmet__102:Update(p481);
        end;
        p480._queueItemRender = nil;
    end;
end;
function u29.Unspotted(p484, p485) --[[ Line: 3051 ]]
    p484._spotted[p485] = nil;
end;
function u29.Spotted(p486, p487, p488) --[[ Line: 3055 ]]
    p486._spotted[p487] = { p488, p486.ServerPosition };
end;
function u29.Stepped(p489) --[[ Line: 3059 ]]
    -- upvalues: l__CurrentCamera__7 (copy), u10 (copy)
    local l___currentVoiceLine__103 = p489._currentVoiceLine;
    if l___currentVoiceLine__103 and (l___currentVoiceLine__103.NextVoiceLine and l___currentVoiceLine__103.Voice.Sound.TimePosition >= l___currentVoiceLine__103.NextVoiceLine) then
        l___currentVoiceLine__103.NextVoiceLine = nil;
        l___currentVoiceLine__103.DoVoiceLine();
    end;
    local _, v490 = l__CurrentCamera__7:WorldToViewportPoint(p489.ServerPosition);
    p489.ViewportOnScreen = v490;
    if not p489._doStepped then
        return;
    end;
    p489._doStepped = false;
    local l___motors__104 = p489._motors;
    local v491 = p489.CameraY * 0.8;
    local l__Lean__105 = p489.Lean;
    local l__Bipod__106 = p489.Bipod;
    local l__Turret__107 = p489.Turret;
    local v492 = math.lerp(v491, 0, p489._noLean);
    local l__UpperTorso__108 = l___motors__104.UpperTorso;
    local l__RightUpperArm__109 = l___motors__104.RightUpperArm;
    local l__LeftUpperArm__110 = l___motors__104.LeftUpperArm;
    local v493 = l___motors__104.LowerTorso.Transform * l__UpperTorso__108.Transform;
    local _, v494 = v493:ToOrientation();
    local _, v495 = (v493 * l__RightUpperArm__109.Transform):ToOrientation();
    local _, v496 = (v493 * l__LeftUpperArm__110.Transform):ToOrientation();
    local v497 = false;
    for _, v498 in p489._loadedAnimations do
        if v498.IsPlaying then
            v497 = true;
            break;
        end;
    end;
    if not v497 then
        for _, v499 in p489._motors do
            v499.Transform = CFrame.new();
        end;
    end;
    if p489._motorGoals then
        local l___motorGoal__111 = p489._motorGoal;
        for v500, v501 in p489._motorGoals do
            local v502 = l___motors__104[v500];
            v502.Transform = v502.Transform * CFrame.new():Lerp(v501, l___motorGoal__111);
        end;
        p489._motorGoals = nil;
    end;
    if (not v497 or p489._parachuteModel) and p489._parachuteModel then
        local v503 = p489._parachuteLeanLerp or 0;
        local l__Transform__112 = l__UpperTorso__108.Transform;
        local v504 = CFrame.Angles(0, 0, (math.rad(v503 * 10)));
        local l__Angles__113 = CFrame.Angles;
        local v505 = math.abs(v503) * 5 + 1;
        l__UpperTorso__108.Transform = l__Transform__112 * (v504 * l__Angles__113(math.rad(v505), 0, 0));
    end;
    if not p489.Focused then
        local v506 = CFrame.Angles(0, p489.CameraX, 0) * CFrame.Angles(p489.CameraY, 0, 0);
        if p489.Seat then
            local v507 = u10:GetVehicle(p489.Seat.UID);
            if v507 then
                local _, v508 = v507.CFrame:ToOrientation();
                v506 = v506 * CFrame.Angles(0, v508, 0);
            end;
        end;
        if v506 == v506 and p489.CFrame == p489.CFrame then
            local l__Head__114 = l___motors__104.Head;
            l__Head__114.Transform = l__Head__114.Transform * CFrame.Angles(v492 / (l__Turret__107 and v492 > 0 and 1 or (l__Bipod__106 and 0.5 or 2)), -v506.LookVector:Cross(p489.CFrame.LookVector).Y, 0);
        end;
    end;
    local v509 = l__Bipod__106 and 0 or v492;
    if p489.CurrentState.Dragged then
        l__UpperTorso__108.Transform = CFrame.Angles(-0.6981317007977318, 0, 0);
    else
        l__UpperTorso__108.Transform = l__UpperTorso__108.Transform * (CFrame.Angles(0, -v494, -math.rad(l__Lean__105 * 25)) * CFrame.Angles(l__Turret__107 and -math.abs(v509 / 2) or v509 / 2, v494, 0));
    end;
    l__LeftUpperArm__110.Transform = (l__LeftUpperArm__110.Transform * CFrame.Angles(0, -v496 * 0.6, 0) * CFrame.Angles(v509 / 2, v496 * 0.6, 0)):Lerp(CFrame.new(), p489._leftArmLerp);
    l__RightUpperArm__109.Transform = (l__RightUpperArm__109.Transform * CFrame.Angles(0, -v495, 0) * CFrame.Angles(v509 / 1.5, v495, 0)):Lerp(CFrame.new(), p489._rightArmLerp);
    l___motors__104.LeftHand.Transform = l___motors__104.LeftHand.Transform:Lerp(CFrame.new(), p489._leftArmLerp);
    l___motors__104.LeftLowerArm.Transform = l___motors__104.LeftLowerArm.Transform:Lerp(CFrame.new(), p489._leftArmLerp);
    l___motors__104.LeftUpperArm.Transform = l___motors__104.LeftUpperArm.Transform:Lerp(CFrame.new(), p489._leftArmLerp);
    l___motors__104.RightHand.Transform = l___motors__104.RightHand.Transform:Lerp(CFrame.new(), p489._rightArmLerp);
    l___motors__104.RightLowerArm.Transform = l___motors__104.RightLowerArm.Transform:Lerp(CFrame.new(), p489._rightArmLerp);
    l___motors__104.RightUpperArm.Transform = l___motors__104.RightUpperArm.Transform:Lerp(CFrame.new(), p489._rightArmLerp);
end;
function u29.Destroy(p510) --[[ Line: 3157 ]]
    -- upvalues: u8 (copy), u12 (copy)
    p510:_cleanUp();
    if p510._anchor then
        task.cancel(p510._anchor);
        p510._anchor = nil;
    end;
    for _, v511 in {
        "Vest",
        "Belt",
        "Eyewear",
        "Earwear",
        "Backpack",
        "Wrist",
        "Helmet"
    } do
        if p510[v511] then
            p510[v511]:Destroy();
        end;
    end;
    for _, v512 in p510._inventory do
        v512:Destroy();
    end;
    p510.Character:Destroy();
    u8:UnregisterBlock(p510);
    u12:Print("Destroyed actor (" .. (p510.Owner and p510.Owner.Name or "SERVER") .. ")", Color3.new(0.5, 0, 1));
end;
return u29;