-- Services.ReplicatorService.InventoryReplicators.FirearmInventoryReplicator
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4, u5, u6 = shared.import("require", "asset", "Enum", "network", "frc", "server");
local u7 = v1("BulletService");
local u8 = v1("EffectsService");
local u9 = v1("InputService");
local u10 = v1("SoundService");
local u11 = v1("DebugService");
local u12 = v1("WeaponAudioRevamp");
local u13 = v1({ "FlashlightAttachmentReplicator", "LaserAttachmentReplicator", "StrobeAttachmentReplicator" });
local u14 = v1("ChainClass");
local u15 = v1("Mathf");
local u16 = v1("BaseComponent");
local u17 = v1("Spring");
local u18 = v1("Calibers");
local u19 = v1("PostProcessingService");
local l__Weapon__1 = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Particles"):WaitForChild("Weapon");
local l__Muzzles__2 = l__Weapon__1:WaitForChild("Muzzles");
local l__Eject__3 = l__Weapon__1:WaitForChild("Eject");
local u20 = {};
u20.__index = u20;
function u20.getADSSpeed(p21, p22) --[[ Line: 47 ]]
    local v23 = (p21.Speed or 1) * (p22.ADS_Speed or 1);
    return 250 / p22.Weight * 100 * v23, v23;
end;
function u20.getADSOffsets(p24) --[[ Line: 52 ]]
    local u25 = {};
    local function v30(p26) --[[ Line: 54 ]]
        -- upvalues: u25 (copy)
        local l__Config__4 = p26.File.Config;
        if l__Config__4 then
            if l__Config__4.Sights then
                if l__Config__4.Canted then
                    if u25[1] == nil or u25[1].IronSight then
                        local v27 = l__Config__4.Sights[1];
                        u25[1] = {
                            Height = 0,
                            FOV = v27.FOV,
                            IronSight = v27.IronSight,
                            Zero = v27.Zero,
                            Static = v27.Static,
                            Speed = v27.Speed,
                            Adjustment = v27.Adjustment,
                            Attachment = p26.Model:FindFirstChild("sight", true)
                        };
                    end;
                else
                    if u25[0] == nil or u25[0].IronSight then
                        local v28 = l__Config__4.Sights[1];
                        u25[0] = {
                            Height = 0,
                            FOV = v28.FOV,
                            IronSight = v28.IronSight,
                            Zero = v28.Zero,
                            Static = v28.Static,
                            Speed = v28.Speed,
                            Adjustment = v28.Adjustment,
                            Attachment = p26.Model:FindFirstChild("sight", true)
                        };
                    end;
                    if l__Config__4.Sights[2] and (u25[1] == nil or u25[1].IronSight) then
                        local v29 = l__Config__4.Sights[2];
                        u25[1] = {
                            Height = 0,
                            FOV = v29.FOV,
                            IronSight = v29.IronSight,
                            Zero = v29.Zero,
                            Static = v29.Static,
                            Speed = v29.Speed,
                            Adjustment = v29.Adjustment,
                            Attachment = p26.Model:FindFirstChild("sight2", true)
                        };
                    end;
                end;
            end;
        end;
    end;
    for _, v31 in p24:GetDescendants() do
        v30(v31);
    end;
    v30(p24);
    local l__Model__5 = p24.Model;
    local l__PrimaryPart__6 = l__Model__5.PrimaryPart;
    local v32 = l__PrimaryPart__6:FindFirstChild("sight");
    if v32 then
        local l__CFrame__7 = v32.CFrame;
        local v33 = l__Model__5:FindFirstChild("cheek", true) or l__Model__5:FindFirstChild("stock", true);
        local v34;
        if v33 then
            v34 = l__PrimaryPart__6.CFrame:ToObjectSpace(v33.WorldCFrame);
        else
            v34 = nil;
        end;
        for v35 = 0, 1 do
            local v36 = u25[v35];
            if v36 then
                local v37 = l__PrimaryPart__6.CFrame:ToObjectSpace(v36.Attachment.WorldCFrame);
                local _, _, v38 = v37:ToOrientation();
                v36.Offset = CFrame.new(v37.X, v37.Y, 0) * CFrame.Angles(0, 0, v38);
                local l__Static__8 = v36.Static;
                local v39;
                if l__Static__8 then
                    v39 = v37 * CFrame.new(0, 0, l__Static__8);
                else
                    v39 = l__CFrame__7;
                end;
                local l__FOV__9 = v36.FOV;
                if typeof(l__FOV__9) == "table" then
                    l__FOV__9 = l__FOV__9[2];
                end;
                v36.Origin = v39.Z;
                v36.Distance = v37.Z;
                local v40 = v39.Z - v37.Z;
                local v41 = math.rad(l__FOV__9 * 0.5);
                v36.Angle = v40 * math.tan(v41);
                if v34 then
                    v36.Height = l__CFrame__7.Y - v34.Y;
                end;
            end;
        end;
        return u25;
    end;
end;
function u20.getMoment(p42) --[[ Line: 158 ]]
    local l__Model__10 = p42.Model;
    local l__PrimaryPart__11 = l__Model__10.PrimaryPart;
    local v43 = l__PrimaryPart__11:FindFirstChild("action") or l__PrimaryPart__11:FindFirstChild("eject");
    local v44 = l__Model__10:FindFirstChild("moment", true) or l__PrimaryPart__11:FindFirstChild("anchor");
    local v45 = l__PrimaryPart__11.CFrame:ToObjectSpace(v44.WorldCFrame);
    return Vector2.new(v45.Z - v43.CFrame.Z + 0.3, v43.CFrame.Y - v45.Y);
end;
function u20.getRecoil(p46, p47, p48, p49, p50, p51) --[[ Line: 176 ]]
    -- upvalues: u9 (copy), u18 (copy), u3 (copy)
    local l__Weight__12 = p46.Weight;
    local v52 = math.atan2(p47.Y, p47.X);
    local v53 = math.sqrt(p47.Y ^ 2 + p47.X ^ 2);
    local v54 = u9.Gamepad and 5 or 1;
    local l__RecoilForce__13 = u18[p46.Caliber].RecoilForce;
    local v55 = l__RecoilForce__13 * p46.RecoilForce_Tap / l__Weight__12;
    local v56 = v55 * math.sin(v52) * v53;
    local v57 = v56 * p46.Recoil_X;
    local v58 = v55 * math.cos(v52);
    local v59;
    if p49 then
        v59 = 1;
    else
        local v60 = math.noise(tick() % 1000000, 0, 0);
        v59 = math.clamp(v60, -0.5, 0.5) * 2;
    end;
    local v61;
    if p49 then
        v61 = 1;
    else
        local v62 = math.noise(tick() % 1000000, 0, 0);
        v61 = math.clamp(v62, -0.5, 0.5) * 2;
    end;
    local v63 = p46.Recoil_Range * Vector2.new(v56, v56);
    local v64 = v57 + v63.X * v59;
    local v65 = v56 + v63.Y * v61;
    local v66 = p46.Muzzle_Effect_Y or 0;
    local v67 = p46.Muzzle_Effect_X or 0;
    local v68 = l__RecoilForce__13 * (p46.RecoilForce_Out or 0) / l__Weight__12;
    local v69 = v68 * v66;
    local v70 = v68 * v67;
    local v71 = v68 * (1 - v66 - v67);
    local v72 = Vector3.new(1, 1, 1);
    if p46.RecoilAccelDamp_Grip then
        v72 = v72 * p46.RecoilAccelDamp_Grip;
    end;
    if p48 and p46.RecoilAccelDamp_Stock then
        v72 = v72 * (math.clamp((p48 / 0.127 - 0) / 1, 0, 1) * p46.RecoilAccelDamp_Stock);
    end;
    if p50 == u3.CharacterHeightState.Crouching then
        if p46.RecoilAccelDamp_Crouch then
            v72 = v72 * p46.RecoilAccelDamp_Crouch;
        end;
    elseif p50 == u3.CharacterHeightState.Proning and p46.RecoilAccelDamp_Prone then
        v72 = v72 * p46.RecoilAccelDamp_Prone;
    end;
    local v73 = (Vector3.new(v64, v65, v58) + Vector3.new(v70, v69, v71)) * v72 / v54 / (p51 and 1.2 or 1) * 1000;
    return p46.Recoil_Camera, v73.Z * p46.Recoil_Z / 50 * (p51 and 1 or (p46.Recoil_KickBack or 3)), Vector2.new(v73.X, v73.Y);
end;
function u20._updateShells(p74, p75) --[[ Line: 237 ]]
    local v76 = p74._firearm.File.Config.Animations.First.Reload_One_2 and true or false;
    if v76 then
        local v77 = p75 or p74._bulletsLoaded;
        local l__ViewModel__14 = p74._actor.ViewModel;
        local l___fpFirearm__15 = p74._fpFirearm;
        local v78 = l___fpFirearm__15 and (l__ViewModel__14 and l___fpFirearm__15:GetChild("Mag"));
        if v78 then
            for _, v79 in v78.ParentModel:GetDescendants() do
                if v79:IsA("BasePart") then
                    v79.CastShadow = false;
                    local l__Name__16 = v79.Name;
                    if v76 and (l__Name__16:sub(1, 6) == "bullet" or l__Name__16:sub(1, 6) == "casing") then
                        local v80 = tonumber(l__Name__16:sub(7));
                        if v80 then
                            v79.Transparency = v80 <= v77 and 0 or 1;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
function u20._updateModel(p81) --[[ Line: 269 ]]
    -- upvalues: u14 (copy)
    local l___firearm__17 = p81._firearm;
    local l___item__18 = p81._item;
    l___firearm__17:Remove("Mag");
    if p81._tpChain then
        p81._tpChain:Destroy();
        p81._tpChain = nil;
    end;
    if p81._fpChain then
        p81._fpChain:Destroy();
        p81._fpChain = nil;
    end;
    local v82 = l___item__18.MetaData.Mag and l___firearm__17:AddChild({ "Mag", l___item__18.MetaData.Mag.Name }, {}, "Mag");
    if v82 then
        local l__ParentModel__19 = v82.ParentModel;
        local v83 = l__ParentModel__19:FindFirstChild("bullets", true);
        if p81._shotLast and v83 then
            v83.Transparency = 1;
        end;
        local l__Link__20 = v82.File.Config.Link;
        if l__Link__20 then
            local l__PrimaryPart__21 = l__ParentModel__19.PrimaryPart;
            p81._tpChain = u14.new(nil, l__ParentModel__19, l__PrimaryPart__21, l__PrimaryPart__21, nil, l__Link__20, not p81._item.MetaData.Mag and 0 or p81._item.MetaData.Mag.Capacity);
        end;
    end;
    local v84 = l___firearm__17.Model:FindFirstChild("bullet", true);
    if v84 then
        v84.Transparency = p81._shotLast and 1 or 0;
    end;
    local l___magnifier__22 = p81._magnifier;
    if l___magnifier__22 and not l___magnifier__22.TPFlips then
        local l__Model__23 = l___firearm__17:GetChild(unpack(l___magnifier__22.Path)).Model;
        local v85 = {
            Flips = {},
            Flip = l__Model__23.PrimaryPart.flip.CFrame
        };
        for _, v86 in l___magnifier__22.Flip do
            local v87 = l__Model__23:FindFirstChild(v86);
            if v87 then
                local v88 = v87:FindFirstChildWhichIsA("Weld");
                if v88 then
                    v85.Flips[v88] = v88.C0;
                end;
            end;
        end;
        l___magnifier__22.TPFlips = v85;
    end;
    local l___bipod__24 = p81._bipod;
    if l___bipod__24 and not l___bipod__24.Third then
        local l__Model__25 = l___firearm__17:GetChild(unpack(l___bipod__24.Path)).Model;
        local l__PrimaryPart__26 = l__Model__25.PrimaryPart;
        local v89 = {};
        for _, v90 in l__PrimaryPart__26:GetChildren() do
            if v90.Name:sub(1, 4) == "flip" then
                local v91 = l__Model__25:FindFirstChild((v90.Name:sub(5)));
                if v91 then
                    local v92 = v91:FindFirstChildWhichIsA("Weld");
                    if v92 then
                        v89[v92] = {
                            Origin = v92.C0,
                            Flip = v90.CFrame
                        };
                    end;
                end;
            end;
        end;
        l___bipod__24.TPFlips = v89;
        l___bipod__24.Third = l__PrimaryPart__26;
    end;
    local l__ViewModel__27 = p81._actor.ViewModel;
    local l___fpFirearm__28 = p81._fpFirearm;
    if l___fpFirearm__28 and l__ViewModel__27 then
        l___fpFirearm__28:Remove("Mag");
        local v93 = l___item__18.MetaData.Mag and l___fpFirearm__28:AddChild({ "Mag", l___item__18.MetaData.Mag.Name }, {}, "Mag");
        if v93 then
            local l__ParentModel__29 = v93.ParentModel;
            local v94 = l__ParentModel__29:FindFirstChild("bullets", true);
            if p81._shotLast and v94 then
                v94.Transparency = 1;
            end;
            local l__Link__30 = v93.File.Config.Link;
            if l__Link__30 then
                local l__PrimaryPart__31 = l__ParentModel__29.PrimaryPart;
                p81._fpChain = u14.new(nil, l__ParentModel__29, l__PrimaryPart__31, l__PrimaryPart__31, nil, l__Link__30, not p81._item.MetaData.Mag and 0 or p81._item.MetaData.Mag.Capacity);
            end;
        end;
        local v95 = l___fpFirearm__28.Model:FindFirstChild("bullet", true);
        if v95 then
            v95.Transparency = p81._shotLast and 1 or 0;
        end;
        if l___magnifier__22 and not l___magnifier__22.FPFlips then
            local v96 = l___fpFirearm__28:GetChild(unpack(l___magnifier__22.Path));
            local l__Model__32 = v96.Model;
            local l__Magnifier__33 = v96.File.Config.Magnifier;
            if l__Magnifier__33.Cutaway then
                l__ViewModel__27:AddCutaway(l__Model__32, l__Magnifier__33.Cutaway, l__Magnifier__33.CutawayInverted or {}, l___magnifier__22, false);
            end;
            local v97 = {
                Flips = {},
                Flip = l__Model__32.PrimaryPart.flip.CFrame
            };
            for _, v98 in l___magnifier__22.Flip do
                local v99 = l__Model__32:FindFirstChild(v98);
                if v99 then
                    local v100 = v99:FindFirstChildWhichIsA("Weld");
                    if v100 then
                        v97.Flips[v100] = v100.C0;
                    end;
                end;
            end;
            l___magnifier__22.FPFlips = v97;
            l___magnifier__22.FPModel = l__Model__32.PrimaryPart;
        end;
        if l___bipod__24 and not l___bipod__24.First then
            local l__Model__34 = l___fpFirearm__28:GetChild(unpack(l___bipod__24.Path)).Model;
            local l__PrimaryPart__35 = l__Model__34.PrimaryPart;
            local v101 = {};
            for _, v102 in l__PrimaryPart__35:GetChildren() do
                if v102.Name:sub(1, 4) == "flip" then
                    local v103 = l__Model__34:FindFirstChild((v102.Name:sub(5)));
                    if v103 then
                        local v104 = v103:FindFirstChildWhichIsA("Weld");
                        if v104 then
                            v101[v104] = {
                                Origin = v104.C0,
                                Flip = v102.CFrame
                            };
                        end;
                    end;
                end;
            end;
            l___bipod__24.ADS.Parent = workspace.Terrain;
            l___bipod__24.FPFlips = v101;
            l___bipod__24.First = l__PrimaryPart__35;
        end;
    end;
    p81:_updateShells();
end;
function u20._updateLOD(p105, p106) --[[ Line: 459 ]]
    local l___heroModel__36 = p105._heroModel;
    if p106 then
        l___heroModel__36.Parent = nil;
        p105._lodModel.Parent = nil;
        p105._lodModelLoaded = nil;
    else
        l___heroModel__36.Parent = p105._actor.Character;
        p105._lodModel.Parent = nil;
    end;
    p105._lod = p106;
    if p105._equipSound then
        p105._equipSound.Destroy();
        p105._equipSound = nil;
    end;
end;
function u20._updateHolster(p107) --[[ Line: 477 ]]
    -- upvalues: u2 (copy)
    local l___item__37 = p107._item;
    local l___actor__38 = p107._actor;
    local l___heroModel__39 = p107._heroModel;
    local v108 = false;
    local v109 = true;
    local v110 = false;
    if l___item__37.Layout.Secondary then
        local v111, v112;
        if l___actor__38.Vest then
            v111 = l___actor__38.Vest:FindFirstChild("_holster", true);
            v112 = "UpperTorso";
        else
            v111 = nil;
            v112 = nil;
        end;
        if not v111 and l___actor__38.Belt then
            v111 = l___actor__38.Belt:FindFirstChild("_holster", true);
            v112 = "LowerTorso";
        end;
        local l__CFrame__40 = l___heroModel__39.PrimaryPart.anchor.CFrame;
        if l___heroModel__39.PrimaryPart:FindFirstChild("_holsterin") then
            l__CFrame__40 = l___heroModel__39.PrimaryPart._holsterin.CFrame;
        end;
        if v111 then
            p107._beltC0 = l___actor__38.Parts[v112].CFrame:ToObjectSpace(v111.WorldCFrame);
            p107._beltC1 = l__CFrame__40;
            p107._belt = l___actor__38.Parts[v112];
            v108 = true;
            v109 = false;
            v110 = true;
        else
            p107._beltC0 = CFrame.Angles(0, 1.5707963267948966, 0);
            p107._beltC1 = l__CFrame__40;
            p107._belt = l___actor__38.Parts.UpperTorso;
            v108 = true;
            v109 = false;
            v110 = true;
        end;
    elseif p107._firearm.Tune.ForwardSling then
        local l__CFrame__41 = l___heroModel__39.PrimaryPart.UpperTorso.CFrame;
        p107._beltC0 = CFrame.new(0.3, 0, -0.2) * CFrame.Angles(0, 3.141592653589793, 0.3141592653589793);
        p107._beltC1 = l__CFrame__41;
        p107._belt = l___actor__38.Parts.UpperTorso;
        v108 = true;
    end;
    if not v108 then
        p107._beltC0 = CFrame.new();
        p107._beltC1 = l___heroModel__39.PrimaryPart.UpperTorso.CFrame;
        p107._belt = l___actor__38.Parts.UpperTorso;
    end;
    p107._doSway = v109;
    p107._equip = l___actor__38:LoadAnimation(u2:Get("Animation", "GenericWeapon", v110 and "Draw_Low" or "Draw").ID);
end;
function u20.new(p113, p114) --[[ Line: 534 ]]
    -- upvalues: u16 (copy), u20 (copy), u6 (copy), u3 (copy), u2 (copy), u17 (copy), l__Muzzles__2 (copy), l__Eject__3 (copy)
    local v115 = u16.Deserialize(p114.MetaData.Build);
    local l__ParentModel__42 = v115.ParentModel;
    l__ParentModel__42.Parent = p113.Character;
    local v116 = u20.getADSOffsets(v115);
    local v117 = false;
    v115:Remove("Mag");
    if p114.MetaData.Mag then
        v117 = not p114.Layout.Secondary and u6.IS_PVP and true or v117;
        v115:AddChild({ "Mag", p114.MetaData.Mag.Name }, {}, "Mag");
    end;
    local l__Kit__43 = v115.File.Config.Animations.Kit;
    local v118 = RaycastParams.new();
    v118.FilterType = u3.RaycastFilterType.Blacklist;
    v118.FilterDescendantsInstances = { p113.Character };
    v118.CollisionGroup = u3.PhysicsGroup.BulletCast;
    v118.IgnoreWater = false;
    local v119, v120 = pcall(u2.Get, u2, "Shared", "Models", "LOD", "Weapon", v115.Name);
    local v121;
    if v119 then
        v121 = v120.Asset:Clone();
    else
        print("no firearm lod: " .. v115.Name);
        v121 = u2:Get("Shared", "Models", "LOD", "Weapon", "UMP45").Asset:Clone();
    end;
    local v122 = {
        _lod = false,
        _bulletsLoaded = 0,
        _sightLerp = 1,
        _lerp = 1,
        _doFirstEquip = v117,
        _animationKit = l__Kit__43,
        _item = p114,
        _firearm = v115,
        _actor = p113,
        _build = p114.MetaData.Build,
        _attachmentCache = {},
        _attachments = {},
        _sights = v116,
        _params = v118,
        _moment = Vector2.zero,
        _heroModel = l__ParentModel__42,
        _lodModel = v121,
        _sway = u17.new(Vector2.zero)
    };
    local u123 = setmetatable(v122, u20);
    if p114.MetaData.Mag then
        u123._bulletsLoaded = p114.MetaData.Mag.Capacity;
    end;
    u123._moment = u20.getMoment(v115);
    u123._sway.Speed = 15;
    u123._sway.Damper = 0.5;
    u123:_updateHolster();
    u123._conn = p113.GearChanged:Connect(function() --[[ Line: 602 ]]
        -- upvalues: u123 (copy)
        u123:_updateHolster();
    end);
    u123._handC0 = CFrame.new(-0.3, 0, -0.5) * CFrame.Angles(1.5707963267948966, 3.141592653589793, 3.141592653589793);
    u123._handC1 = l__ParentModel__42.PrimaryPart.anchor.CFrame;
    u123._hand = p113.Parts.RightHand;
    u123._primary = l__ParentModel__42.PrimaryPart;
    u123._toBelt = true;
    local v124 = Instance.new("Motor6D");
    v124.Part0 = u123._belt;
    v124.Part1 = l__ParentModel__42.PrimaryPart;
    v124.C0 = u123._beltC0;
    v124.C1 = u123._beltC1;
    v124.Parent = l__ParentModel__42;
    u123._weld = v124;
    local v125 = Instance.new("Motor6D");
    v125.Part0 = u123._hand;
    v125.Part1 = v121;
    v125.C0 = u123._handC0;
    v125.C1 = v121.anchor.CFrame;
    v125.Parent = v121;
    local v126 = l__ParentModel__42:FindFirstChild("muzzle");
    local v127 = l__ParentModel__42:FindFirstChild("barrel");
    local v128 = v126 and v126:FindFirstChild("tip", true) or (v127 and v127:FindFirstChild("tip", true) or l__ParentModel__42:FindFirstChild("tip", true));
    local v129 = l__Muzzles__2[v115.Tune.MuzzleVFX or "bare"]:Clone();
    v129.Name = "VFX";
    v129.Parent = v128;
    local v130 = l__ParentModel__42:FindFirstChild("eject", true);
    if v130 then
        for _, v131 in l__Eject__3:GetChildren() do
            v131:Clone().Parent = v130;
        end;
    end;
    u123._tip = v128;
    for _, v132 in v115:GetDescendants() do
        local l__Attachments__44 = v132.File.Attachments;
        if l__Attachments__44 then
            local v133 = v132:GetFullName();
            for v134, v135 in l__Attachments__44 do
                u123._attachmentCache[table.concat(v133, ".") .. "/" .. v134] = { v134, v135, v133 };
            end;
        end;
        local l__Config__45 = v132.File.Config;
        if l__Config__45 and (l__Config__45.Bipod and not u6.IS_PVP) then
            local l__anchor__46 = l__ParentModel__42.PrimaryPart.anchor;
            local v136 = {
                Lerp = 0,
                Active = false,
                Recoil = u17.new(0),
                Height = l__Config__45.Bipod,
                Path = v132:GetFullName(),
                ADS = Instance.new("Attachment"),
                Right = l__anchor__46,
                Left = l__ParentModel__42:FindFirstChild("bipodleft", true) or l__anchor__46
            };
            v136.Recoil.Speed = 20;
            v136.Recoil.Damper = 1;
            if p113.IsLocalPlayer then
                local v137 = Instance.new("Attachment");
                local v138 = Instance.new("ProximityPrompt");
                v138.Name = "Bipod";
                v138.ActionText = "Bipod";
                v138.ClickablePrompt = false;
                v138.Style = u3.ProximityPromptStyle.Custom;
                v138.Exclusivity = u3.ProximityPromptExclusivity.OneGlobally;
                v138.MaxActivationDistance = 50;
                v138.RequiresLineOfSight = false;
                v138.GamepadKeyCode = u3.KeyCode.World0;
                v138.KeyboardKeyCode = u3.KeyCode.World0;
                v138.Parent = v137;
                v136.Attachment = v137;
                v136.Prompt = v138;
            end;
            u123._bipod = v136;
        end;
    end;
    return u123;
end;
function u20.Firemode(p139, p140) --[[ Line: 699 ]]
    -- upvalues: u10 (copy)
    local l__PrimaryPart__47 = p139._firearm.ParentModel.PrimaryPart;
    if p139._actor.ViewModel.Active then
        l__PrimaryPart__47 = p139._fpFirearm.ParentModel.PrimaryPart;
    end;
    u10:CreateSound("Weapon_Interaction", l__PrimaryPart__47, true, "WeaponAudioRevamp", p139._firearm.Name, "Handling", p140 == 0 and "Safe" or (p140 == 2 and "Full" or (p140 == 3 and "Semi" or "Semi"))).Destroy(2);
end;
function u20.Attachment(p141, p142, p143) --[[ Line: 718 ]]
    local v144 = p141._attachments[p142];
    if v144 then
        v144:SetState(p143);
    end;
end;
function u20.Bipod(p145, p146) --[[ Line: 727 ]]
    if p145._bipod then
        p145._bipod.Active = p146.Active;
        p145._bipod.Position = p146.Position;
    else
        p145._bipod = p146;
    end;
    local l___actor__48 = p145._actor;
    local l__Active__49 = p145._bipod.Active;
    if l__Active__49 then
        l__Active__49 = p145._bipod;
    end;
    l___actor__48.Bipod = l__Active__49;
    if not p146.Active then
        p145._toHand = true;
    end;
    p145:_updateModel();
end;
function u20.BipodUse(p147) --[[ Line: 743 ]]
    -- upvalues: u4 (copy)
    local l___bipod__50 = p147._bipod;
    local l___actor__51 = p147._actor;
    local v148 = nil;
    if l___bipod__50.Active or not l___bipod__50.Position then
        l___bipod__50.Active = false;
    else
        l___bipod__50.Camera = l___actor__51.Orientation;
        l___bipod__50.CFrame = l___actor__51.CFrame;
        l___bipod__50.HeightState = l___actor__51.HeightState;
        l___bipod__50.Active = true;
        local l__Position__52 = l___bipod__50.Position;
        v148 = { l__Position__52.X, l__Position__52.Y, l__Position__52.Z };
    end;
    u4:FireServer("InventoryAction", "Bipod", l___bipod__50.Active, v148);
    p147:Bipod(l___bipod__50);
end;
function u20.Magnifier(p149, p150) --[[ Line: 763 ]]
    -- upvalues: u10 (copy)
    if p149._magnifier then
        p149._magnifier.Active = p150.Active;
    else
        p149._magnifier = p150;
    end;
    if p150.FPModel then
        u10:CreateSound("Weapon_Interaction", p149._magnifier.FPModel, true, "Foley", "Weapon", "Magnifier", p149._magnifier.Active and "On" or "Off").Destroy(2);
    end;
    p149._magnifier.Last = tick() + 1;
    p149:_updateModel();
    local l__ViewModel__53 = p149._actor.ViewModel;
    if l__ViewModel__53 then
        l__ViewModel__53.Magnifier = p150;
    end;
end;
function u20.CQB(p151, p152) --[[ Line: 784 ]]
    -- upvalues: u2 (copy), u3 (copy), u8 (copy), u10 (copy)
    local v153 = false;
    if p152 then
        if p151._cqbAnimation then
            v153 = p151._cqb ~= p152 and true or v153;
        else
            p151._cqbAnimation = p151._actor:LoadAnimation(u2:Get("Animation", "CharacterPacks", p151._animationKit, "Idle", "CQB").ID);
            p151._cqbAnimation.Priority = u3.AnimationPriority.Action;
            p151._cqbAnimation:Play(0, 1, 0);
            p151._cqbAnimation.TimePosition = 0.07;
        end;
    elseif p151._cqbAnimation then
        v153 = math.abs(p151._cqb) > 0 and true or v153;
        p151._cqbAnimation:Stop();
        p151._cqbAnimation = nil;
    end;
    local l__PrimaryPart__54 = p151._firearm.ParentModel.PrimaryPart;
    if v153 and u8:GetLevelOfDetail(l__PrimaryPart__54.Position) == 1 then
        local l__ViewModel__55 = p151._actor.ViewModel;
        if l__ViewModel__55 and l__ViewModel__55.Active then
            l__PrimaryPart__54 = nil;
        end;
        u10:CreateSound("Weapon_Interaction", l__PrimaryPart__54, true, "Foley", "Weapon", "CQB", "Stance").Destroy(2);
    end;
    p151._cqb = p152;
    p151._actor.CQB = p152;
end;
function u20.ADS(p154, p155, p156) --[[ Line: 822 ]]
    p154._ads = p155;
    p154._actor.AnimationKit = p155 and p154._animationKit .. "Aiming" or p154._animationKit;
    local l__ViewModel__56 = p154._actor.ViewModel;
    if l__ViewModel__56 then
        local l___actor__57 = p154._actor;
        if p155 then
            local v157 = p154._sights[p156];
            if v157 then
                p154._sightGoal = p156;
                if typeof(v157.Zero) == "table" and not v157.Zero[4] then
                    v157.Zero[4] = v157.Zero[1];
                end;
                l__ViewModel__56.Zero = v157.Zero;
            end;
        else
            p154._sightGoal = nil;
            l___actor__57.ADS = nil;
            l__ViewModel__56.Zero = nil;
        end;
    end;
end;
function u20.Equip(p158, p159) --[[ Line: 851 ]]
    -- upvalues: u11 (copy), u18 (copy), u16 (copy), u19 (copy), l__Muzzles__2 (copy), l__Eject__3 (copy), u10 (copy), u3 (copy), u12 (copy), u13 (copy)
    p158._equip:Play(0);
    p158._actor.AnimationKit = p158._animationKit;
    p158._actor.Firearm = true;
    p158._toHand = true;
    p158._lerp = 0;
    p158._offset = nil;
    p158._toBelt = nil;
    p158._equipped = true;
    local v160 = true;
    local l__ViewModel__58 = p158._actor.ViewModel;
    if l__ViewModel__58 then
        local l__Tune__59 = p158._firearm.Tune;
        local l__OverrideTune__60 = p158._firearm.OverrideTune;
        u11:Slider("Weapon.Recoil_X", l__Tune__59.Recoil_X, -100, 100, nil, function(p161) --[[ Line: 868 ]]
            -- upvalues: l__Tune__59 (copy), l__OverrideTune__60 (copy)
            l__Tune__59.Recoil_X = p161;
            l__OverrideTune__60.Recoil_X = p161;
        end);
        u11:Slider("Weapon.Recoil_Z", l__Tune__59.Recoil_Z, -100, 100, nil, function(p162) --[[ Line: 872 ]]
            -- upvalues: l__Tune__59 (copy), l__OverrideTune__60 (copy)
            l__Tune__59.Recoil_Z = p162;
            l__OverrideTune__60.Recoil_Z = p162;
        end);
        u11:Slider("Weapon.RecoilForce_Tap", l__Tune__59.RecoilForce_Tap, 0, 100, nil, function(p163) --[[ Line: 876 ]]
            -- upvalues: l__Tune__59 (copy), l__OverrideTune__60 (copy)
            l__Tune__59.RecoilForce_Tap = p163;
            l__OverrideTune__60.RecoilForce_Tap = p163;
        end);
        u11:Slider("Weapon.RecoilForce_Impulse", l__Tune__59.RecoilForce_Impulse, 0, 100, nil, function(p164) --[[ Line: 880 ]]
            -- upvalues: l__Tune__59 (copy), l__OverrideTune__60 (copy)
            l__Tune__59.RecoilForce_Impulse = p164;
            l__OverrideTune__60.RecoilForce_Impulse = p164;
        end);
        u11:Slider("Weapon.Recoil_Camera", l__Tune__59.Recoil_Camera, 0, 100, nil, function(p165) --[[ Line: 884 ]]
            -- upvalues: l__Tune__59 (copy), l__OverrideTune__60 (copy)
            l__Tune__59.Recoil_Camera = p165;
            l__OverrideTune__60.Recoil_Camera = p165;
        end);
        u11:Slider("Weapon.Recoil_Range.X", l__Tune__59.Recoil_Range.X, -100, 100, nil, function(p166) --[[ Line: 888 ]]
            -- upvalues: l__Tune__59 (copy), l__OverrideTune__60 (copy)
            l__Tune__59.Recoil_Range = Vector2.new(p166, l__OverrideTune__60.Recoil_Range and l__OverrideTune__60.Recoil_Range.Y or l__Tune__59.Recoil_Range.Y);
            l__OverrideTune__60.Recoil_Range = Vector2.new(p166, l__OverrideTune__60.Recoil_Range and l__OverrideTune__60.Recoil_Range.Y or l__Tune__59.Recoil_Range.Y);
        end);
        u11:Slider("Weapon.Recoil_Range.Y", l__Tune__59.Recoil_Range.Y, -100, 100, nil, function(p167) --[[ Line: 892 ]]
            -- upvalues: l__Tune__59 (copy), l__OverrideTune__60 (copy)
            l__Tune__59.Recoil_Range = Vector2.new(l__OverrideTune__60.Recoil_Range and l__OverrideTune__60.Recoil_Range.X or l__Tune__59.Recoil_Range.X, p167);
            l__OverrideTune__60.Recoil_Range = Vector2.new(l__OverrideTune__60.Recoil_Range and l__OverrideTune__60.Recoil_Range.X or l__Tune__59.Recoil_Range.X, p167);
        end);
        u11:Slider("Weapon.Weight", l__Tune__59.Weight, 0, 5000, nil, function(p168) --[[ Line: 896 ]]
            -- upvalues: l__Tune__59 (copy), l__OverrideTune__60 (copy)
            l__Tune__59.Weight = p168;
            l__OverrideTune__60.Weight = p168;
        end);
        local u169 = u18[l__Tune__59.Caliber];
        u11:Slider("Caliber.RecoilForce", u169.RecoilForce, 0, 1000, nil, function(p170) --[[ Line: 902 ]]
            -- upvalues: u169 (copy)
            u169.RecoilForce = p170;
        end);
        local v171 = u16.Deserialize(p158._build);
        p158._fpFirearm = v171;
        if p158._magnifier then
            p158._magnifier.FPFlips = nil;
            l__ViewModel__58.Magnifier = p158._magnifier;
        end;
        if p158._bipod then
            p158._bipod.First = nil;
        end;
        if p158._actor.IsLocalPlayer then
            p158._dop = u19:AddDepthOfField({
                FarIntensity = 0,
                FocusDistance = 0,
                InFocusRadius = 0,
                NearIntensity = 0,
                AutoFocus = false
            }, 1, true);
        end;
        local l__ParentModel__61 = v171.ParentModel;
        local v172 = l__ParentModel__61:FindFirstChild("muzzle");
        local v173 = l__ParentModel__61:FindFirstChild("barrel");
        local v174 = v172 and v172:FindFirstChild("tip", true) or (v173 and v173:FindFirstChild("tip", true) or l__ParentModel__61:FindFirstChild("tip", true));
        local v175 = l__Muzzles__2[l__Tune__59.MuzzleVFX or "bare"]:Clone();
        v175.Name = "VFX";
        v175.Parent = v174;
        local v176 = l__ParentModel__61:FindFirstChild("eject", true);
        if v176 then
            for _, v177 in l__Eject__3:GetChildren() do
                v177:Clone().Parent = v176;
            end;
        end;
        local l__First__62 = p158._firearm.File.Config.Animations.First;
        local l___doFirstEquip__63 = p158._doFirstEquip;
        if l___doFirstEquip__63 then
            l___doFirstEquip__63 = l__First__62.Draw_First;
        end;
        if l___doFirstEquip__63 then
            local v178 = u10:CreateSound("Weapon_Interaction", nil, true, "WeaponAudioRevamp", p158._firearm.Name, "Handling", "Draw");
            p158._drawSound = v178;
            v178.Destroy(10);
            v160 = false;
        end;
        l__ViewModel__58.Weight = l__Tune__59.Weight;
        l__ViewModel__58.SprintID = l__First__62.Sprint;
        l__ViewModel__58.WorldMuzzle = p158._tip;
        local v179 = l___doFirstEquip__63 or l__First__62.Draw;
        if p159 then
            v179 = nil;
            v160 = false;
        end;
        local v180, _, v181 = l__ViewModel__58:SetModel({ l__ParentModel__61, p158._heroModel }, l__First__62.Idle, v179);
        p158._idle_fp = v180;
        if l___doFirstEquip__63 and v181 then
            v181.Priority = u3.AnimationPriority.Action3;
        end;
        if l__First__62.Idle_Aim then
            p158._idle_aim_fp = l__ViewModel__58:LoadAnimation(l__First__62.Idle_Aim);
            p158._idle_aim_fp.Priority = u3.AnimationPriority.Core;
            p158._idle_aim_fp:Play(0, 1, 0);
            l__ViewModel__58.ADSOffset = l__First__62.Idle_Aim_Offset;
        end;
        if p158._idle_dry_fp then
            p158._idle_dry_fp:Play(0);
        end;
        for _, v182 in v171:GetDescendants() do
            local l__Config__64 = v182.File.Config;
            if l__Config__64 then
                if l__Config__64.Reticles then
                    local l__Model__65 = v182.Model;
                    for v183, v184 in l__Config__64.Reticles do
                        local v185 = l__Model__65:FindFirstChild(v184.Glass or "glass");
                        if v185 then
                            l__ViewModel__58:AddReticle(v185, v184, v183);
                        else
                            warn("Attempted to register reticle but no glass part in the model");
                        end;
                    end;
                end;
                if l__Config__64.Sights then
                    for v186, v187 in l__Config__64.Sights do
                        if v187.Cutaway then
                            l__ViewModel__58:AddCutaway(v182.Model, v187.Cutaway, v187.CutawayInverted or {}, nil, v186 == 2 and true or l__Config__64.Canted);
                        end;
                    end;
                end;
            end;
        end;
    end;
    p158:_updateModel();
    if v160 and not p158._lod then
        local l__PrimaryPart__66 = p158._firearm.ParentModel.PrimaryPart;
        if l__ViewModel__58 and l__ViewModel__58.Active then
            l__PrimaryPart__66 = nil;
        end;
        local v188 = u12[p158._firearm.Name];
        local v189;
        if v188 and (v188.Handling and v188.Handling.DrawCustom) then
            v189 = u10:CreateSound("Weapon_Interaction", l__PrimaryPart__66, true, "WeaponAudioRevamp", p158._firearm.Name, "Handling", "DrawCustom");
        else
            v189 = u10:CreateSound("Weapon_Interaction", l__PrimaryPart__66, true, "Foley", "Weapon", "Equip", p158._animationKit);
        end;
        p158._equipSound = v189;
        v189.Destroy(5);
    end;
    for v190, v191 in p158._attachmentCache do
        p158._attachments[v190] = u13[v191[1] .. "AttachmentReplicator"].new(p158._actor, v191[2], v191[3], p158._firearm, p158._fpFirearm);
    end;
    p158._doFirstEquip = false;
end;
function u20.Unequip(p192) --[[ Line: 1033 ]]
    -- upvalues: u11 (copy)
    p192._equip:Stop(0);
    local l___actor__67 = p192._actor;
    l___actor__67.AnimationKit = "Unequipped";
    l___actor__67.ADS = nil;
    l___actor__67.CQB = nil;
    l___actor__67.Firearm = nil;
    l___actor__67.Bipod = nil;
    l___actor__67.ADSZoom = nil;
    p192._ads = false;
    p192._cqb = nil;
    p192._toBelt = true;
    p192._lerp = 0;
    p192._offset = nil;
    p192._toHand = nil;
    p192._sightGoal = nil;
    p192:_updateModel();
    p192._equipped = false;
    p192._tiltedReload = nil;
    if p192._dop then
        p192._dop.Destroy();
        p192._dop = nil;
    end;
    if p192._bolt then
        p192._bolt:Disconnect();
        p192._bolt = nil;
    end;
    if p192._reload_fp_watcher then
        p192._reload_fp_watcher:Disconnect();
        p192._reload_fp_watcher = nil;
    end;
    if p192._reload_watcher then
        p192._reload_watcher:Disconnect();
        p192._reload_watcher = nil;
    end;
    if p192._reload_fp then
        p192._reload_fp:Stop(0);
    end;
    if p192._reload then
        p192._reload:Stop(0);
    end;
    if p192._reload_thread then
        task.cancel(p192._reload_thread);
        p192._reload_thread = nil;
    end;
    if p192._cqbAnimation then
        p192._cqbAnimation:Stop();
        p192._cqbAnimation = nil;
    end;
    if p192._inspect_fp then
        if p192._inspect_sound then
            p192._inspect_sound.Destroy();
            p192._inspect_sound = nil;
        end;
        p192._inspect_fp:Stop(0);
        p192._inspect_fp = nil;
    end;
    if p192._drawSound then
        p192._drawSound.Sound:Stop();
        p192._drawSound = nil;
    end;
    if p192._reloadSound then
        p192._reloadSound.Sound:Stop();
        p192._reloadSound = nil;
    end;
    if p192._discharge_tp and p192._discharge_tp.IsPlaying then
        p192._discharge_tp:Stop(0);
    end;
    for _, v193 in p192._attachments do
        v193:SetState(0);
        v193:Destroy();
    end;
    p192._attachments = {};
    local l___bipod__68 = p192._bipod;
    if l___bipod__68 then
        l___bipod__68.Active = false;
        l___bipod__68.Reloading = false;
        l___bipod__68.ADS.Parent = nil;
        if l___bipod__68.Prompt then
            l___bipod__68.Prompt.Enabled = false;
            l___bipod__68.Attachment.Parent = p192._heroModel.PrimaryPart;
        end;
    end;
    local l__ViewModel__69 = p192._actor.ViewModel;
    if l__ViewModel__69 then
        u11:UnRegisterCallback("Weapon.Recoil_X");
        u11:UnRegisterCallback("Weapon.Recoil_Z");
        u11:UnRegisterCallback("Weapon.RecoilForce_Tap");
        u11:UnRegisterCallback("Weapon.RecoilForce_Impulse");
        u11:UnRegisterCallback("Weapon.Recoil_Camera");
        u11:UnRegisterCallback("Weapon.Recoil_Range.X");
        u11:UnRegisterCallback("Weapon.Recoil_Range.Y");
        u11:UnRegisterCallback("Weapon.Weight");
        u11:UnRegisterCallback("Caliber.RecoilForce");
        if p192._idle_dry_fp then
            p192._idle_dry_fp:Stop(0);
        end;
        if p192._idle_aim_fp then
            p192._idle_aim_fp:Stop(0);
            p192._idle_aim_fp = nil;
        end;
        if p192._discharge_aim_fp then
            p192._discharge_aim_fp:Stop(0);
            p192._discharge_aim_fp = nil;
        end;
        if p192._discharge_fp then
            p192._discharge_fp:Stop(0);
            p192._discharge_fp = nil;
        end;
        l__ViewModel__69.Weight = nil;
        l__ViewModel__69.ADSOffset = nil;
        l__ViewModel__69.SprintID = nil;
        l__ViewModel__69.WorldMuzzle = nil;
        l__ViewModel__69.Bipod = nil;
        l__ViewModel__69.Magnifier = nil;
        l__ViewModel__69.Reloading = false;
        l__ViewModel__69:SetModel();
    end;
    p192._fpFirearm = nil;
end;
function u20.DryFire(p194, p195) --[[ Line: 1169 ]]
    -- upvalues: u2 (copy), u10 (copy)
    local v196;
    if p195 then
        if p194._hammerDown then
            v196 = "TriggerIn";
        else
            v196 = pcall(u2.Get, u2, "Sound", "WeaponAudioRevamp", p194._firearm.Name, "Handling", "Dry") and "Dry" or "TriggerIn";
            p194._hammerDown = true;
        end;
    else
        v196 = "TriggerOut";
    end;
    u10:CreateSound("Weapon_Interaction", p194._actor:_getHead(), true, "WeaponAudioRevamp", p194._firearm.Name, "Handling", v196).Destroy(1);
end;
function u20.Discharge(u197, p198, p199, p200, p201, p202, p203) --[[ Line: 1189 ]]
    -- upvalues: u3 (copy), u7 (copy), u8 (copy), u12 (copy), u10 (copy), u20 (copy)
    local l__Animations__70 = u197._firearm.File.Config.Animations;
    local l___actor__71 = u197._actor;
    if u197._inspect_fp and u197._inspect_fp.IsPlaying then
        if u197._inspect_sound then
            u197._inspect_sound.Destroy();
            u197._inspect_sound = nil;
        end;
        u197._inspect_fp:Stop(0);
    end;
    if l___actor__71.HeightState ~= u3.CharacterHeightState.Proning then
        local v204 = l___actor__71:LoadAnimation(l__Animations__70.Third.Discharge);
        v204.Priority = u3.AnimationPriority.Core;
        v204:Play(0);
        u197._discharge_tp = v204;
    end;
    local l__Mag__72 = u197._item.MetaData.Mag;
    if l__Mag__72 then
        local l__Capacity__73 = l__Mag__72.Capacity;
        local l__RPM__74 = u197._firearm.Tune.RPM;
        if u197._fpChain then
            u197._fpChain:Discharge(l__Capacity__73, l__RPM__74);
        end;
        if u197._tpChain then
            u197._tpChain:Discharge(l__Capacity__73, l__RPM__74);
        end;
    end;
    if p198 then
        for _, v205 in p198 do
            u7:Discharge(v205, p199, p200, nil, false, nil, nil, l___actor__71.Character, nil, p203);
        end;
    end;
    if u197._bipod and u197._bipod.Active then
        u197._bipod.Recoil:Impulse(10);
    end;
    local l__ViewModel__75 = l___actor__71.ViewModel;
    local v206;
    if l__ViewModel__75 then
        v206 = l___actor__71.Zoom == 0;
    else
        v206 = l__ViewModel__75;
    end;
    local v207 = u8:BulletFired(v206 and l__ViewModel__75.CurrentModel or (u197._lod and u197._lodModel or u197._heroModel), p199, u197._firearm.Name, v206, u197._firearm, l__ViewModel__75 and true or false);
    if u197._bolt then
        u197._bolt:Disconnect();
        u197._bolt = nil;
    end;
    if p202 then
        u197._bolt = p202:Connect(function() --[[ Line: 1239 ]]
            -- upvalues: u197 (copy)
            u197._bolt:Disconnect();
            u197._bolt = nil;
        end);
        u197._spawnShell = v207;
    else
        if v207 then
            v207(true);
        end;
        local v208 = u12[u197._firearm.Name];
        if not u197._lod and (v208 and (v208.Handling and v208.Handling.BoltAction)) then
            u10:CreateSound("Weapon_Interaction", v206 and u197._fpFirearm.ParentModel.PrimaryPart or u197._heroModel.PrimaryPart, true, "WeaponAudioRevamp", u197._firearm.Name, "Handling", "BoltAction").Destroy(5);
        end;
    end;
    if l__ViewModel__75 then
        if u197._ads and l__Animations__70.First.Discharge_Aim then
            u197._discharge_aim_fp = l__ViewModel__75:LoadAnimation(p201 and l__Animations__70.First.Discharge_Last_Aim or l__Animations__70.First.Discharge_Aim);
            u197._discharge_aim_fp.Priority = u3.AnimationPriority.Action;
            u197._discharge_aim_fp:Play(0);
        end;
        u197._discharge_fp = l__ViewModel__75:LoadAnimation(p201 and l__Animations__70.First.Discharge_Last or l__Animations__70.First.Discharge);
        u197._discharge_fp.Priority = u3.AnimationPriority.Action;
        u197._discharge_fp:Play(0);
        if p202 then
            if u197._boltAction then
                u197._boltAction:Destroy();
            end;
            u197._boltAction = u10:CreateSound("Weapon_Interaction", u197._fpFirearm.ParentModel.PrimaryPart, true, "WeaponAudioRevamp", u197._firearm.Name, "Handling", "BoltAction").Sound;
        end;
        if p201 and l__Animations__70.First.Idle_Dry then
            u197._idle_dry_fp = l__ViewModel__75:LoadAnimation(l__Animations__70.First.Idle_Dry);
            u197._idle_dry_fp.Looped = true;
            u197._idle_dry_fp.Priority = u3.AnimationPriority.Movement;
            u197._idle_dry_fp:Play(0);
        end;
        local v209;
        if u197._sightGoal then
            v209 = u197._sights[u197._sightGoal].Height;
        else
            v209 = nil;
        end;
        local v210, v211, v212 = u20.getRecoil(u197._firearm.Tune, u197._moment, v209, nil, u197._actor.HeightState, u197._ads);
        l__ViewModel__75.Recoil:Impulse(v210 * 0.8, v211 * 0.8, v212 * 0.8);
        local l__Kick__76 = l__ViewModel__75.Kick;
        local v213 = math.random(-12, 12) / 10;
        l__Kick__76:Impulse((Vector3.new(-0.8, v213, 0)));
    end;
    u197._shotLast = p201;
end;
function u20.Inspect(p214) --[[ Line: 1298 ]]
    -- upvalues: u3 (copy), u10 (copy)
    local l__ViewModel__77 = p214._actor.ViewModel;
    if l__ViewModel__77 then
        if l__ViewModel__77.Reloading or not l__ViewModel__77.Active then
            return;
        end;
        local l__Inspect__78 = p214._firearm.File.Config.Animations.First.Inspect;
        if not l__Inspect__78 then
            return;
        end;
        if p214._inspect_fp then
            if p214._inspect_fp.IsPlaying then
                return;
            end;
        else
            p214._inspect_fp = l__ViewModel__77:LoadAnimation(l__Inspect__78);
            p214._inspect_fp.Priority = u3.AnimationPriority.Action3;
        end;
        local v215 = u10:CreateSound("Weapon_Interaction", nil, true, "WeaponAudioRevamp", p214._firearm.Name, "Handling", "Inspect");
        p214._inspect_sound = v215;
        v215.Destroy(20);
        p214._inspect_fp:Play(0);
    end;
end;
function u20.Reload(u216, p217, u218, u219) --[[ Line: 1326 ]]
    -- upvalues: u3 (copy), u10 (copy)
    u216._shotLast = false;
    if u216._bolt then
        u216._bolt:Disconnect();
        u216._bolt = nil;
    end;
    local l___actor__79 = u216._actor;
    local l__ViewModel__80 = u216._actor.ViewModel;
    local v220;
    if l__ViewModel__80 then
        v220 = l___actor__79.Zoom == 0;
    else
        v220 = l__ViewModel__80;
    end;
    local u221 = u216._lod and u216._lodModel;
    if not u221 then
        if v220 then
            u221 = nil;
        else
            u221 = u216._heroModel.PrimaryPart or nil;
        end;
    end;
    local l__Tune__81 = u216._firearm.Tune;
    local l__Animations__82 = u216._firearm.File.Config.Animations;
    if u216._reload_thread then
        task.cancel(u216._reload_thread);
        u216._reload_thread = nil;
    end;
    if u216._idle_dry_fp then
        u216._idle_dry_fp:Stop(0);
        u216._idle_dry_fp = nil;
    end;
    if u216._discharge_fp then
        u216._discharge_fp:Stop(0);
        u216._discharge_fp = nil;
    end;
    if u216._discharge_aim_fp then
        u216._discharge_aim_fp:Stop(0);
        u216._discharge_aim_fp = nil;
    end;
    if u216._inspect_fp and u216._inspect_fp.IsPlaying then
        if u216._inspect_sound then
            u216._inspect_sound.Destroy();
            u216._inspect_sound = nil;
        end;
        u216._inspect_fp:Stop(0);
    end;
    if u216._bipod then
        u216._bipod.Reloading = true;
    end;
    if l__ViewModel__80 then
        l__ViewModel__80.Reloading = true;
    end;
    if l__Animations__82.First.Reload_One then
        local v222 = 0;
        if not u216._tiltedReload then
            u216._tiltedReload = true;
            if u219 == 1 then
                u216._bulletsLoaded = 0;
            end;
            local v223 = u10:CreateSound("Weapon_Interaction", u221, true, "WeaponAudioRevamp", u216._firearm.Name, "Handling", p217 and "Empty" or "Partial");
            u216._reloadSound = v223;
            v223.Destroy(20);
            local u224 = u216._actor:LoadAnimation(p217 and l__Animations__82.Third.Reload_Dry or l__Animations__82.Third.Reload);
            u224.Priority = u3.AnimationPriority.Action;
            u224:Play(0);
            u216._reload = u224;
            u216._reload_watcher = u224.Stopped:Once(function() --[[ Line: 1412 ]]
                -- upvalues: u216 (copy), u224 (copy)
                u216._reload_watcher:Disconnect();
                u216._reload_watcher = nil;
                u224:Play(0, 1, 0);
                u224.TimePosition = u224.Length - 1e-6;
            end);
            if l__ViewModel__80 then
                local u225 = l__ViewModel__80:LoadAnimation(p217 and l__Animations__82.First.Reload_Dry or l__Animations__82.First.Reload);
                u225.Priority = u3.AnimationPriority.Action;
                u225:Play(0);
                u216._reload_fp = u225;
                u216._reload_fp_watcher = u225.Stopped:Once(function() --[[ Line: 1426 ]]
                    -- upvalues: u216 (copy), u225 (copy)
                    u216._reload_fp_watcher:Disconnect();
                    u216._reload_fp_watcher = nil;
                    u225:Play(0, 1, 0);
                    u225.TimePosition = u225.Length - 1e-6;
                end);
            end;
            if p217 and not (l__Tune__81.ChamberNeedsBulletInsert or l__Tune__81.NoChamber) then
                return;
            end;
            v222 = v222 + (p217 and l__Tune__81.Reload_Empty_Chamber or l__Tune__81.Reload_Empty_Start);
        end;
        u216._reload_thread = task.delay(v222, function() --[[ Line: 1441 ]]
            -- upvalues: u216 (copy), u219 (copy), u10 (ref), u221 (copy), l__Animations__82 (copy), u3 (ref), l__ViewModel__80 (copy), u218 (copy), l__Tune__81 (copy)
            u216._reload_thread = nil;
            u216:_updateShells(u219 or 0);
            if u216._reload_fp_watcher then
                u216._reload_fp_watcher:Disconnect();
                u216._reload_fp_watcher = nil;
            end;
            if u216._reload_watcher then
                u216._reload_watcher:Disconnect();
                u216._reload_watcher = nil;
            end;
            if u216._reload_fp then
                u216._reload_fp:Stop();
            end;
            if u216._reload then
                u216._reload:Stop();
            end;
            local v226 = u10:CreateSound("Weapon_Interaction", u221, true, "WeaponAudioRevamp", u216._firearm.Name, "Handling", "LoadBullet");
            u216._reloadSound = v226;
            v226.Destroy(10);
            local v227 = not l__Animations__82.First["Reload_One_" .. tostring(u219 or 1)] and "Reload_One" or "Reload_One_" .. tostring(u219 or 1);
            local u228 = u216._actor:LoadAnimation(l__Animations__82.Third[v227]);
            u228.Priority = u3.AnimationPriority.Action;
            u228:Play();
            u216._reload = u228;
            u216._reload_watcher = u228.Stopped:Once(function() --[[ Line: 1476 ]]
                -- upvalues: u216 (ref), u228 (copy)
                u216._reload_watcher:Disconnect();
                u216._reload_watcher = nil;
                u228:Play(0, 1, 0);
                u228.TimePosition = u228.Length - 1e-6;
            end);
            if l__ViewModel__80 then
                local u229 = l__ViewModel__80:LoadAnimation(l__Animations__82.First[v227]);
                u229.Priority = u3.AnimationPriority.Action;
                u229:Play();
                u216._reload_fp = u229;
                u216._reload_fp_watcher = u229.Stopped:Once(function() --[[ Line: 1490 ]]
                    -- upvalues: u216 (ref), u229 (copy)
                    u216._reload_fp_watcher:Disconnect();
                    u216._reload_fp_watcher = nil;
                    u229:Play(0, 1, 0);
                    u229.TimePosition = u229.Length - 1e-6;
                end);
            end;
            if not u218 then
                u216._tiltedReload = nil;
                u216._reload_thread = task.delay(l__Tune__81.Reload_Empty_Tube, function() --[[ Line: 1502 ]]
                    -- upvalues: u216 (ref), u10 (ref), u221 (ref), l__Animations__82 (ref), u3 (ref), l__ViewModel__80 (ref)
                    u216._reload_thread = nil;
                    if u216._reload_fp_watcher then
                        u216._reload_fp_watcher:Disconnect();
                        u216._reload_fp_watcher = nil;
                    end;
                    if u216._reload_watcher then
                        u216._reload_watcher:Disconnect();
                        u216._reload_watcher = nil;
                    end;
                    if u216._reload_fp then
                        u216._reload_fp:Stop(0);
                    end;
                    if u216._reload then
                        u216._reload:Stop(0);
                    end;
                    local v230 = u10:CreateSound("Weapon_Interaction", u221, true, "WeaponAudioRevamp", u216._firearm.Name, "Handling", "ReloadEnd");
                    u216._reloadSound = v230;
                    v230.Destroy(10);
                    local v231 = u216._actor:LoadAnimation(l__Animations__82.Third.Reload_End);
                    v231.Priority = u3.AnimationPriority.Action;
                    v231:Play(0);
                    u216._reload = v231;
                    if l__ViewModel__80 then
                        local v232 = l__ViewModel__80:LoadAnimation(l__Animations__82.First.Reload_End);
                        v232.Priority = u3.AnimationPriority.Action;
                        v232:Play(0);
                        u216._reload_fp = v232;
                    end;
                end);
            end;
        end);
    else
        u216:_updateModel();
        u216._reload = u216._actor:LoadAnimation(p217 and l__Animations__82.Third.Reload_Dry or l__Animations__82.Third.Reload);
        u216._reload.Priority = u3.AnimationPriority.Action;
        u216._reload:Play();
        local v233 = u10:CreateSound("Weapon_Interaction", u221, true, "WeaponAudioRevamp", u216._firearm.Name, "Handling", p217 and "Empty" or "Partial");
        u216._reloadSound = v233;
        v233.Destroy(20);
        if l__ViewModel__80 then
            u216._reload_fp = l__ViewModel__80:LoadAnimation(p217 and l__Animations__82.First.Reload_Dry or l__Animations__82.First.Reload);
            u216._reload_fp.Priority = u3.AnimationPriority.Action;
            u216._reload_fp:Play(0);
        end;
        u216._item.MetaData.Mag = nil;
    end;
end;
function u20.Reloaded(p234, p235) --[[ Line: 1542 ]]
    if p235 then
        p234._item.MetaData.Mag = p235;
        p234._bulletsLoaded = p235.Capacity;
    end;
    p234._hammerDown = nil;
    p234:_updateModel();
    local l__ViewModel__83 = p234._actor.ViewModel;
    if l__ViewModel__83 then
        l__ViewModel__83.Reloading = false;
    end;
    if p234._bipod then
        p234._bipod.Reloading = false;
    end;
end;
function u20.Update(p236, p237, p238, p239) --[[ Line: 1559 ]]
    -- upvalues: u3 (copy), u15 (copy), u5 (copy), u20 (copy)
    local l___toBelt__84 = p236._toBelt;
    local l___toHand__85 = p236._toHand;
    local l___bipod__86 = p236._bipod;
    local l___actor__87 = p236._actor;
    if (l___toHand__85 or l___toBelt__84) and (not l___bipod__86 or (not l___bipod__86.Active or l___bipod__86.Reloading)) then
        local l___weld__88 = p236._weld;
        local v240;
        if p237 == 3 then
            v240 = p238 == 1;
        else
            v240 = false;
        end;
        local v241 = v240 and (p236._lerp or 1) or 1;
        if v241 > 0.5 then
            local v242 = (v241 - 0.5) * 2;
            if l___toBelt__84 then
                local l__zero__89 = Vector2.zero;
                if v240 and (p236._doSway and (l___actor__87.HeightState ~= u3.CharacterHeightState.Proning and not l___actor__87.Downed)) then
                    local v243, _, v244 = l___weld__88.Part0.CFrame:ToOrientation();
                    p236._sway:Impulse(Vector2.new(v244, (math.max(v243, 0))));
                    p236._sway.Target = Vector2.new(v244 / 2, math.max(v243, 0) / 2);
                    l__zero__89 = p236._sway.Position;
                end;
                l___weld__88.C0 = p236._beltC0 * CFrame.Angles(-l__zero__89.Y, 0, 0) * CFrame.Angles(0, 0, -l__zero__89.X);
                l___weld__88.C1 = p236._beltC1;
                l___weld__88.Part0 = p236._belt;
                v241 = 1;
            elseif l___toHand__85 then
                if not p236._offset then
                    p236._offset = p236._primary.CFrame:ToObjectSpace(p236._hand.CFrame):Inverse();
                end;
                l___weld__88.C0 = p236._offset:Lerp(p236._handC0, v242);
                l___weld__88.C1 = CFrame.new():Lerp(p236._handC1, v242);
                l___weld__88.Part0 = p236._hand;
            end;
        end;
        if p236._lerp > 0.99 then
            p236._lerp = 1;
            if not (v240 and p236._doSway) then
                p236._offset = nil;
                p236._toBelt = nil;
                p236._toHand = nil;
            end;
        else
            p236._lerp = u15.Lerp(v241, 1, u5(p239 * 7.5));
        end;
    end;
    local v245 = p238 > 1;
    if v245 and not p236._lod then
        p236:_updateLOD(true);
    elseif not v245 and p236._lod then
        p236:_updateLOD(false);
    end;
    if p238 > 2 or not p236._equipped then
        if p236._lod then
            if p236._equipped then
                if not p236._lodModelLoaded then
                    p236._lodModelLoaded = true;
                    p236._lodModel.Parent = p236._actor.Character;
                    return;
                end;
            elseif p236._lodModelLoaded then
                p236._lodModelLoaded = nil;
                p236._lodModel.Parent = nil;
            end;
        end;
        return;
    end;
    local l__ViewModel__90 = l___actor__87.ViewModel;
    local v246, v247, v248, v249, v250, v251, v252, v253, v254, v255, v256;
    if not l__ViewModel__90 then
        for v314, v315 in p236._attachments do
            if v315.Update then
                if l__ViewModel__90 then
                    v246 = l__ViewModel__90.Active;
                else
                    v246 = l__ViewModel__90;
                end;
                v315:Update(p239, v246);
            end;
        end;
        v247 = p236._cqbAnimation;
        if v247 then
            v248 = math.abs(p236._cqb);
            v247:AdjustWeight(math.clamp(v248, 0, 1), 0.1);
            v247.TimePosition = u15.Lerp(v247.TimePosition, 0.06666666666666667 - p236._cqb / 30, u5(p239 * 10));
        end;
        v249 = p236._magnifier;
        if v249 then
            v249.Lerp = u15.Lerp(v249.Lerp, v249.Active and 1 or 0, u5(p239 * 20));
            v250 = v249.Lerp;
            v251 = v249.FPFlips;
            if v251 then
                for v316, v317 in v251.Flips do
                    v316.C0 = v317:Lerp(v251.Flip, v250);
                end;
            end;
            v252 = v249.TPFlips;
            for v318, v319 in v252.Flips do
                v318.C0 = v319:Lerp(v252.Flip, v250);
            end;
        end;
        if l___bipod__86 then
            l___bipod__86.Lerp = u15.Lerp(l___bipod__86.Lerp, l___bipod__86.Active and 1 or 0, u5(p239 * 10));
            v253 = l___bipod__86.Lerp;
            v254 = l___bipod__86.FPFlips;
            if v254 then
                for v320, v321 in v254 do
                    v320.C0 = v321.Origin:Lerp(v321.Flip, v253);
                end;
            end;
            for v322, v323 in l___bipod__86.TPFlips do
                v322.C0 = v323.Origin:Lerp(v323.Flip, v253);
            end;
            if l___bipod__86.Active then
                v255 = p236._weld;
                if l___bipod__86.Reloading then
                    v255.C0 = p236._handC0;
                    v255.C1 = p236._handC1;
                    v255.Part0 = p236._hand;
                else
                    v256 = CFrame.Angles(0, l___actor__87.CameraX, 0):VectorToWorldSpace((Vector3.new(0, 0, l___bipod__86.Recoil.Position)));
                    v255.C1 = p236._heroModel.PrimaryPart.CFrame:ToObjectSpace(l___bipod__86.Third.CFrame:ToWorldSpace(CFrame.new(0, -l___bipod__86.Height, 0)));
                    v255.C0 = l___actor__87.RootPart.CFrame:ToObjectSpace(CFrame.new(l___bipod__86.Position + Vector3.new(v256.X, 0, v256.Z)) * CFrame.Angles(0, l___actor__87.CameraX, 0) * CFrame.Angles(l___actor__87.CameraY, 0, 0));
                    v255.Part0 = l___actor__87.RootPart;
                end;
            end;
        end;
        if p236._lod then
            if p236._equipped then
                if not p236._lodModelLoaded then
                    p236._lodModelLoaded = true;
                    p236._lodModel.Parent = p236._actor.Character;
                    return;
                end;
            elseif p236._lodModelLoaded then
                p236._lodModelLoaded = nil;
                p236._lodModel.Parent = nil;
            end;
        end;
        return;
    end;
    local l___sights__91 = p236._sights;
    if p236._sightGoal then
        local v267 = l___sights__91[p236._sightGoal];
        local l__FOV__92 = v267.FOV;
        if typeof(l__FOV__92) == "table" then
            l___actor__87.ADSZoom = l__FOV__92;
        else
            l___actor__87.ADSZoom = nil;
        end;
        local v268, v269 = u20.getADSSpeed(v267, p236._firearm.Tune);
        l__ViewModel__90.ADSSpeed = v269;
        if l___actor__87.ADS then
            p236._sightLerp = u15.Lerp(p236._sightLerp, p236._sightGoal, u5(p239 * v268));
        else
            p236._sightLerp = p236._sightGoal;
        end;
        local v270 = 0;
        local v271 = l___sights__91[0];
        local v272 = v271 and v271.FOV or 70;
        local v273;
        if typeof(v272) == "table" then
            if not v272[5] then
                v272[5] = v272[1];
                v272[6] = v272[1];
            end;
            v272[6] = u15.Lerp(v272[6], v272[5], u5(p239 * (v272[4] or 10)));
            v272 = v272[6];
            local l__Angle__93 = l___sights__91[0].Angle;
            local v274 = math.rad((70 - v272) * 0.5);
            v273 = l__Angle__93 / math.tan(v274) + l___sights__91[0].Distance;
        else
            v273 = v270 + v267.Origin;
        end;
        local v275 = l___sights__91[1];
        if v275 then
            v275 = l___sights__91[1].FOV;
        end;
        if typeof(v275) == "table" then
            if not v275[5] then
                v275[5] = v275[1];
            end;
            v275 = v275[5];
        end;
        l__ViewModel__90.Canted = p236._sightLerp;
        l__ViewModel__90.ADSFOV = u15.Lerp(v272, v275 or 0, p236._sightLerp);
        l___actor__87.ADS = (l___sights__91[0].Offset * CFrame.new(0, 0, v273)):Lerp(l___sights__91[1] and l___sights__91[1].Offset * CFrame.new(0, 0, l___sights__91[1].Origin) or CFrame.new(), p236._sightLerp);
    end;
    if p236._idle_aim_fp then
        p236._idle_aim_fp:AdjustWeight(l__ViewModel__90.ADSLerp);
        p236._idle_fp:AdjustWeight(1 - l__ViewModel__90.ADSLerp);
        if p236._discharge_aim_fp and p236._discharge_aim_fp.IsPlaying then
            p236._discharge_aim_fp:AdjustWeight(l__ViewModel__90.ADSLerp);
        end;
        if p236._discharge_fp and p236._discharge_fp.IsPlaying then
            p236._discharge_fp:AdjustWeight(1 - l__ViewModel__90.ADSLerp);
        end;
    end;
    local l___discharge_fp__94 = p236._discharge_fp;
    if l___discharge_fp__94 and l___discharge_fp__94.IsPlaying then
        local l__Tune__95 = p236._firearm.Tune;
        local l___boltAction__96 = p236._boltAction;
        if p236._bolt and l___discharge_fp__94.TimePosition >= l__Tune__95.Bolt_Action_Pause then
            l___discharge_fp__94:AdjustSpeed(0);
            p236._boltNeedsResume = true;
            if l___boltAction__96 and l___boltAction__96.IsPlaying then
                l___boltAction__96:Stop();
            end;
        elseif p236._boltNeedsResume then
            l___discharge_fp__94:AdjustSpeed(1);
            if l___boltAction__96 and not l___boltAction__96.IsPlaying then
                l___boltAction__96:Play();
            end;
            p236._boltNeedsResume = nil;
        end;
        if p236._spawnShell and l___discharge_fp__94.TimePosition >= l__Tune__95.Bolt_Action_Shell then
            p236._spawnShell(false);
            p236._spawnShell = nil;
        end;
    end;
    local v276, v277;
    if not l___bipod__86 then
        v276 = p236._dop;
        if v276 then
            v277 = math.abs(l__ViewModel__90.Recoil.Spring.Position.Y * 15);
            v276.FocusDistance = v277;
            v276.NearIntensity = math.min(0.2, v277);
        end;
        for v314, v315 in p236._attachments do
            if v315.Update then
                if l__ViewModel__90 then
                    v246 = l__ViewModel__90.Active;
                else
                    v246 = l__ViewModel__90;
                end;
                v315:Update(p239, v246);
            end;
        end;
        v247 = p236._cqbAnimation;
        if v247 then
            v248 = math.abs(p236._cqb);
            v247:AdjustWeight(math.clamp(v248, 0, 1), 0.1);
            v247.TimePosition = u15.Lerp(v247.TimePosition, 0.06666666666666667 - p236._cqb / 30, u5(p239 * 10));
        end;
        v249 = p236._magnifier;
        if v249 then
            v249.Lerp = u15.Lerp(v249.Lerp, v249.Active and 1 or 0, u5(p239 * 20));
            v250 = v249.Lerp;
            v251 = v249.FPFlips;
            if v251 then
                for v316, v317 in v251.Flips do
                    v316.C0 = v317:Lerp(v251.Flip, v250);
                end;
            end;
            v252 = v249.TPFlips;
            for v318, v319 in v252.Flips do
                v318.C0 = v319:Lerp(v252.Flip, v250);
            end;
        end;
        if l___bipod__86 then
            l___bipod__86.Lerp = u15.Lerp(l___bipod__86.Lerp, l___bipod__86.Active and 1 or 0, u5(p239 * 10));
            v253 = l___bipod__86.Lerp;
            v254 = l___bipod__86.FPFlips;
            if v254 then
                for v320, v321 in v254 do
                    v320.C0 = v321.Origin:Lerp(v321.Flip, v253);
                end;
            end;
            for v322, v323 in l___bipod__86.TPFlips do
                v322.C0 = v323.Origin:Lerp(v323.Flip, v253);
            end;
            if l___bipod__86.Active then
                v255 = p236._weld;
                if l___bipod__86.Reloading then
                    v255.C0 = p236._handC0;
                    v255.C1 = p236._handC1;
                    v255.Part0 = p236._hand;
                else
                    v256 = CFrame.Angles(0, l___actor__87.CameraX, 0):VectorToWorldSpace((Vector3.new(0, 0, l___bipod__86.Recoil.Position)));
                    v255.C1 = p236._heroModel.PrimaryPart.CFrame:ToObjectSpace(l___bipod__86.Third.CFrame:ToWorldSpace(CFrame.new(0, -l___bipod__86.Height, 0)));
                    v255.C0 = l___actor__87.RootPart.CFrame:ToObjectSpace(CFrame.new(l___bipod__86.Position + Vector3.new(v256.X, 0, v256.Z)) * CFrame.Angles(0, l___actor__87.CameraX, 0) * CFrame.Angles(l___actor__87.CameraY, 0, 0));
                    v255.Part0 = l___actor__87.RootPart;
                end;
            end;
        end;
        if p236._lod then
            if p236._equipped then
                if not p236._lodModelLoaded then
                    p236._lodModelLoaded = true;
                    p236._lodModel.Parent = p236._actor.Character;
                    return;
                end;
            elseif p236._lodModelLoaded then
                p236._lodModelLoaded = nil;
                p236._lodModel.Parent = nil;
            end;
        end;
        return;
    end;
    if l___actor__87.IsLocalPlayer then
        local v288 = l__ViewModel__90.Active and l___bipod__86.First or l___bipod__86.Third;
        l___bipod__86.Attachment.Parent = v288;
        if l___bipod__86.Active then
            l___bipod__86.Prompt.Enabled = true;
            l___bipod__86.Attachment.WorldPosition = l___bipod__86.Position;
            local l__Camera__97 = l___bipod__86.Camera;
            local l__CameraX__98 = l___actor__87.CameraX;
            local v289 = math.deg(l__Camera__97) % 360 - math.deg(l__CameraX__98) % 360;
            local v290 = math.abs(v289) - 180;
            if 180 - math.abs(v290) > 30 or (math.abs(l___actor__87.CameraY) > 0.5235987755982988 or ((l___actor__87.CFrame.Position - l___bipod__86.CFrame.Position).Magnitude > 0.1 or l___actor__87.HeightState ~= l___bipod__86.HeightState)) then
                p236:BipodUse();
            end;
        elseif v288 then
            local v291 = workspace:Raycast(l___bipod__86.Third.Position, Vector3.new(0, -l___bipod__86.Height, 0), p236._params);
            if v291 then
                local l__Orientation__99 = l___actor__87.Orientation;
                local l__CameraX__100 = l___actor__87.CameraX;
                local v292 = math.deg(l__Orientation__99) % 360 - math.deg(l__CameraX__100) % 360;
                local v293 = math.abs(v292) - 180;
                if 180 - math.abs(v293) < 30 and math.abs(l___actor__87.CameraY) < 0.5235987755982988 then
                    l___bipod__86.Attachment.WorldPosition = v291.Position;
                    l___bipod__86.Prompt.Enabled = true;
                    l___bipod__86.Position = v291.Position;
                    if l___bipod__86.Active then
                        l__ViewModel__90.Bipod = l___bipod__86;
                    else
                        l__ViewModel__90.Bipod = nil;
                    end;
                    v276 = p236._dop;
                    if v276 then
                        v277 = math.abs(l__ViewModel__90.Recoil.Spring.Position.Y * 15);
                        v276.FocusDistance = v277;
                        v276.NearIntensity = math.min(0.2, v277);
                    end;
                    for v314, v315 in p236._attachments do
                        if v315.Update then
                            if l__ViewModel__90 then
                                v246 = l__ViewModel__90.Active;
                            else
                                v246 = l__ViewModel__90;
                            end;
                            v315:Update(p239, v246);
                        end;
                    end;
                    v247 = p236._cqbAnimation;
                    if v247 then
                        v248 = math.abs(p236._cqb);
                        v247:AdjustWeight(math.clamp(v248, 0, 1), 0.1);
                        v247.TimePosition = u15.Lerp(v247.TimePosition, 0.06666666666666667 - p236._cqb / 30, u5(p239 * 10));
                    end;
                    v249 = p236._magnifier;
                    if v249 then
                        v249.Lerp = u15.Lerp(v249.Lerp, v249.Active and 1 or 0, u5(p239 * 20));
                        v250 = v249.Lerp;
                        v251 = v249.FPFlips;
                        if v251 then
                            for v316, v317 in v251.Flips do
                                v316.C0 = v317:Lerp(v251.Flip, v250);
                            end;
                        end;
                        v252 = v249.TPFlips;
                        for v318, v319 in v252.Flips do
                            v318.C0 = v319:Lerp(v252.Flip, v250);
                        end;
                    end;
                    if l___bipod__86 then
                        l___bipod__86.Lerp = u15.Lerp(l___bipod__86.Lerp, l___bipod__86.Active and 1 or 0, u5(p239 * 10));
                        v253 = l___bipod__86.Lerp;
                        v254 = l___bipod__86.FPFlips;
                        if v254 then
                            for v320, v321 in v254 do
                                v320.C0 = v321.Origin:Lerp(v321.Flip, v253);
                            end;
                        end;
                        for v322, v323 in l___bipod__86.TPFlips do
                            v322.C0 = v323.Origin:Lerp(v323.Flip, v253);
                        end;
                        if l___bipod__86.Active then
                            v255 = p236._weld;
                            if l___bipod__86.Reloading then
                                v255.C0 = p236._handC0;
                                v255.C1 = p236._handC1;
                                v255.Part0 = p236._hand;
                            else
                                v256 = CFrame.Angles(0, l___actor__87.CameraX, 0):VectorToWorldSpace((Vector3.new(0, 0, l___bipod__86.Recoil.Position)));
                                v255.C1 = p236._heroModel.PrimaryPart.CFrame:ToObjectSpace(l___bipod__86.Third.CFrame:ToWorldSpace(CFrame.new(0, -l___bipod__86.Height, 0)));
                                v255.C0 = l___actor__87.RootPart.CFrame:ToObjectSpace(CFrame.new(l___bipod__86.Position + Vector3.new(v256.X, 0, v256.Z)) * CFrame.Angles(0, l___actor__87.CameraX, 0) * CFrame.Angles(l___actor__87.CameraY, 0, 0));
                                v255.Part0 = l___actor__87.RootPart;
                            end;
                        end;
                    end;
                    if p236._lod then
                        if p236._equipped then
                            if not p236._lodModelLoaded then
                                p236._lodModelLoaded = true;
                                p236._lodModel.Parent = p236._actor.Character;
                                return;
                            end;
                        elseif p236._lodModelLoaded then
                            p236._lodModelLoaded = nil;
                            p236._lodModel.Parent = nil;
                        end;
                    end;
                    return;
                end;
            end;
            l___bipod__86.Prompt.Enabled = false;
            l___bipod__86.Position = nil;
            if l___bipod__86.Active then
                l__ViewModel__90.Bipod = l___bipod__86;
            else
                l__ViewModel__90.Bipod = nil;
            end;
            v276 = p236._dop;
            if v276 then
                v277 = math.abs(l__ViewModel__90.Recoil.Spring.Position.Y * 15);
                v276.FocusDistance = v277;
                v276.NearIntensity = math.min(0.2, v277);
            end;
            for v314, v315 in p236._attachments do
                if v315.Update then
                    if l__ViewModel__90 then
                        v246 = l__ViewModel__90.Active;
                    else
                        v246 = l__ViewModel__90;
                    end;
                    v315:Update(p239, v246);
                end;
            end;
            v247 = p236._cqbAnimation;
            if v247 then
                v248 = math.abs(p236._cqb);
                v247:AdjustWeight(math.clamp(v248, 0, 1), 0.1);
                v247.TimePosition = u15.Lerp(v247.TimePosition, 0.06666666666666667 - p236._cqb / 30, u5(p239 * 10));
            end;
            v249 = p236._magnifier;
            if v249 then
                v249.Lerp = u15.Lerp(v249.Lerp, v249.Active and 1 or 0, u5(p239 * 20));
                v250 = v249.Lerp;
                v251 = v249.FPFlips;
                if v251 then
                    for v316, v317 in v251.Flips do
                        v316.C0 = v317:Lerp(v251.Flip, v250);
                    end;
                end;
                v252 = v249.TPFlips;
                for v318, v319 in v252.Flips do
                    v318.C0 = v319:Lerp(v252.Flip, v250);
                end;
            end;
            if l___bipod__86 then
                l___bipod__86.Lerp = u15.Lerp(l___bipod__86.Lerp, l___bipod__86.Active and 1 or 0, u5(p239 * 10));
                v253 = l___bipod__86.Lerp;
                v254 = l___bipod__86.FPFlips;
                if v254 then
                    for v320, v321 in v254 do
                        v320.C0 = v321.Origin:Lerp(v321.Flip, v253);
                    end;
                end;
                for v322, v323 in l___bipod__86.TPFlips do
                    v322.C0 = v323.Origin:Lerp(v323.Flip, v253);
                end;
                if l___bipod__86.Active then
                    v255 = p236._weld;
                    if l___bipod__86.Reloading then
                        v255.C0 = p236._handC0;
                        v255.C1 = p236._handC1;
                        v255.Part0 = p236._hand;
                    else
                        v256 = CFrame.Angles(0, l___actor__87.CameraX, 0):VectorToWorldSpace((Vector3.new(0, 0, l___bipod__86.Recoil.Position)));
                        v255.C1 = p236._heroModel.PrimaryPart.CFrame:ToObjectSpace(l___bipod__86.Third.CFrame:ToWorldSpace(CFrame.new(0, -l___bipod__86.Height, 0)));
                        v255.C0 = l___actor__87.RootPart.CFrame:ToObjectSpace(CFrame.new(l___bipod__86.Position + Vector3.new(v256.X, 0, v256.Z)) * CFrame.Angles(0, l___actor__87.CameraX, 0) * CFrame.Angles(l___actor__87.CameraY, 0, 0));
                        v255.Part0 = l___actor__87.RootPart;
                    end;
                end;
            end;
            if p236._lod then
                if p236._equipped then
                    if not p236._lodModelLoaded then
                        p236._lodModelLoaded = true;
                        p236._lodModel.Parent = p236._actor.Character;
                        return;
                    end;
                elseif p236._lodModelLoaded then
                    p236._lodModelLoaded = nil;
                    p236._lodModel.Parent = nil;
                end;
            end;
            return;
        end;
    end;
    if l___bipod__86.Active then
        l__ViewModel__90.Bipod = l___bipod__86;
    else
        l__ViewModel__90.Bipod = nil;
    end;
    v276 = p236._dop;
    if v276 then
        v277 = math.abs(l__ViewModel__90.Recoil.Spring.Position.Y * 15);
        v276.FocusDistance = v277;
        v276.NearIntensity = math.min(0.2, v277);
    end;
    for v314, v315 in p236._attachments do
        if v315.Update then
            if l__ViewModel__90 then
                v246 = l__ViewModel__90.Active;
            else
                v246 = l__ViewModel__90;
            end;
            v315:Update(p239, v246);
        end;
    end;
    v247 = p236._cqbAnimation;
    if v247 then
        v248 = math.abs(p236._cqb);
        v247:AdjustWeight(math.clamp(v248, 0, 1), 0.1);
        v247.TimePosition = u15.Lerp(v247.TimePosition, 0.06666666666666667 - p236._cqb / 30, u5(p239 * 10));
    end;
    v249 = p236._magnifier;
    if v249 then
        v249.Lerp = u15.Lerp(v249.Lerp, v249.Active and 1 or 0, u5(p239 * 20));
        v250 = v249.Lerp;
        v251 = v249.FPFlips;
        if v251 then
            for v316, v317 in v251.Flips do
                v316.C0 = v317:Lerp(v251.Flip, v250);
            end;
        end;
        v252 = v249.TPFlips;
        for v318, v319 in v252.Flips do
            v318.C0 = v319:Lerp(v252.Flip, v250);
        end;
    end;
    if l___bipod__86 then
        l___bipod__86.Lerp = u15.Lerp(l___bipod__86.Lerp, l___bipod__86.Active and 1 or 0, u5(p239 * 10));
        v253 = l___bipod__86.Lerp;
        v254 = l___bipod__86.FPFlips;
        if v254 then
            for v320, v321 in v254 do
                v320.C0 = v321.Origin:Lerp(v321.Flip, v253);
            end;
        end;
        for v322, v323 in l___bipod__86.TPFlips do
            v322.C0 = v323.Origin:Lerp(v323.Flip, v253);
        end;
        if l___bipod__86.Active then
            v255 = p236._weld;
            if l___bipod__86.Reloading then
                v255.C0 = p236._handC0;
                v255.C1 = p236._handC1;
                v255.Part0 = p236._hand;
            else
                v256 = CFrame.Angles(0, l___actor__87.CameraX, 0):VectorToWorldSpace((Vector3.new(0, 0, l___bipod__86.Recoil.Position)));
                v255.C1 = p236._heroModel.PrimaryPart.CFrame:ToObjectSpace(l___bipod__86.Third.CFrame:ToWorldSpace(CFrame.new(0, -l___bipod__86.Height, 0)));
                v255.C0 = l___actor__87.RootPart.CFrame:ToObjectSpace(CFrame.new(l___bipod__86.Position + Vector3.new(v256.X, 0, v256.Z)) * CFrame.Angles(0, l___actor__87.CameraX, 0) * CFrame.Angles(l___actor__87.CameraY, 0, 0));
                v255.Part0 = l___actor__87.RootPart;
            end;
        end;
    end;
    if p236._lod then
        if p236._equipped then
            if not p236._lodModelLoaded then
                p236._lodModelLoaded = true;
                p236._lodModel.Parent = p236._actor.Character;
            end;
        elseif p236._lodModelLoaded then
            p236._lodModelLoaded = nil;
            p236._lodModel.Parent = nil;
        end;
    end;
end;
function u20.Destroy(p324) --[[ Line: 1828 ]]
    p324._conn:Disconnect();
    if p324._equipped then
        p324._actor.ADS = nil;
        p324._actor.CQB = nil;
        p324._actor.Firearm = nil;
    end;
    if p324._tpChain then
        p324._tpChain:Destroy();
    end;
    if p324._fpChain then
        p324._fpChain:Destroy();
    end;
    if p324._dop then
        p324._dop.Destroy();
        p324._dop = nil;
    end;
    p324._equipSound = nil;
    p324._lodModel:Destroy();
    p324._heroModel:Destroy();
    for _, v325 in p324._attachments do
        v325:Destroy();
    end;
end;
return u20;