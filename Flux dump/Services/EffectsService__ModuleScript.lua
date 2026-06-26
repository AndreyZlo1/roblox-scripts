-- Services.EffectsService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4 = shared.import("require", "Enum", "asset", "network");
local u5 = v1("EnvironmentService");
local u6 = v1("SoundService");
v1("FlagService");
local u7 = v1("BulletService");
local u8 = v1("CameraShakePresets");
local u9 = v1("GameSettings");
local u10 = v1("CasingMaterials");
local u11 = v1("ImpactMaterials");
local u12 = v1("Calibers");
local u13 = v1("WeaponAudioRevamp");
local l__ContentProvider__1 = game:GetService("ContentProvider");
local l__ReplicatedStorage__2 = game:GetService("ReplicatedStorage");
local l__HttpService__3 = game:GetService("HttpService");
game:GetService("GuiService");
local l__Debris__4 = game:GetService("Debris");
local l__TweenService__5 = game:GetService("TweenService");
game:GetService("UserInputService");
local l__Terrain__6 = workspace.Terrain;
local l__Particles__7 = l__ReplicatedStorage__2:WaitForChild("Assets"):WaitForChild("Particles");
local l__Explosion__8 = l__Particles__7:WaitForChild("Explosion");
local l__Flare__9 = l__Particles__7:WaitForChild("Vehicles"):WaitForChild("Helicopter"):WaitForChild("Flare");
local l__Weapon__10 = l__Particles__7:WaitForChild("Weapon");
local l__Shell__11 = l__Weapon__10:WaitForChild("Shell");
local l__Hit__12 = l__Weapon__10:WaitForChild("Hit");
local l__CurrentCamera__13 = workspace.CurrentCamera;
local u14 = {
    [u2.ExplosionType.M320A1] = "Grenade",
    [u2.ExplosionType.Grenade] = "Grenade",
    [u2.ExplosionType.Breach] = "Breach",
    [u2.ExplosionType.Motar] = "Motar",
    [u2.ExplosionType.Flash] = "Flash",
    [u2.ExplosionType.GroundVehicle] = "Vehicle",
    [u2.ExplosionType.HelicopterVehicle] = "Vehicle"
};
local u15 = {
    ["7.62"] = 1.2,
    ["50cal"] = 2,
    ["5.56"] = 1,
    ["9mm"] = 0.4,
    ["12gauge"] = 0.8
};
local u16 = {
    u2.NormalId.Front,
    u2.NormalId.Left,
    u2.NormalId.Right,
    u2.NormalId.Bottom
};
local u17 = {
    Dirt = { 359667702 },
    Grass = { 359667702 },
    Sand = { 359667702 },
    Concrete = {
        8591873843,
        8591886853,
        8591886706,
        8591873349,
        8591873098
    },
    Wood = { 359667702 },
    Rock = { 359667702 },
    Snow = { 359667702 },
    Metal = { 359667702 },
    Fabric = { 359667702 },
    Glass = {
        12801171157,
        12801171336,
        12801171573,
        12801171728
    }
};
local u18 = {
    Dirt = Color3.fromRGB(90, 76, 66),
    Grass = Color3.fromRGB(90, 76, 66),
    Sand = Color3.fromRGB(201, 160, 131),
    Concrete = Color3.fromRGB(114, 114, 114),
    Wood = Color3.fromRGB(121, 101, 88),
    Rock = Color3.fromRGB(53, 53, 53),
    Snow = Color3.fromRGB(255, 255, 255),
    Metal = Color3.fromRGB(122, 122, 122)
};
local u19 = {
    Back = {
        { "X", 1 },
        { "Y", -1 }
    },
    Front = {
        { "X", -1 },
        { "Y", -1 }
    },
    Right = {
        { "Z", -1 },
        { "Y", -1 }
    },
    Left = {
        { "Z", 1 },
        { "Y", -1 }
    },
    Top = {
        { "Z", -1 },
        { "X", 1 }
    },
    Bottom = {
        { "Z", -1 },
        { "X", -1 }
    }
};
local u20 = {};
u20.__index = u20;
local function u26(p21, p22) --[[ Line: 102 ]]
    local v23 = { "", 0 };
    for v24, v25 in {
        Back = Vector3.new(0, 0, p21.Size.Z),
        Front = Vector3.new(0, 0, -p21.Size.Z),
        Right = Vector3.new(p21.Size.X, 0, 0),
        Left = Vector3.new(-p21.Size.X, 0, 0),
        Top = Vector3.new(0, p21.Size.Y, 0),
        Bottom = Vector3.new(0, -p21.Size.Y, 0)
    } do
        local l__Magnitude__14 = (p22 - (p21.Position + p21.CFrame:VectorToWorldSpace(v25))).Magnitude;
        if v23[1] == "" or l__Magnitude__14 < v23[2] then
            v23 = { v24, l__Magnitude__14 };
        end;
    end;
    return v23[1];
end;
local function u34(p27) --[[ Line: 131 ]]
    local v28 = p27 or 3.141592653589793;
    local v29 = math.random() * 2 * 3.141592653589793;
    local v30 = math.random() * (1 - math.cos(v28)) + math.cos(v28);
    local v31 = math.sqrt(1 - v30 * v30);
    local v32 = v31 * math.cos(v29);
    local v33 = v31 * math.sin(v29);
    return Vector3.new(v32, v33, v30);
end;
function u20._firedSound(_, p35, p36, p37, p38, p39, p40, p41) --[[ Line: 140 ]]
    -- upvalues: u6 (copy), u3 (copy), l__Terrain__6 (copy), l__Debris__4 (copy), u5 (copy)
    if p37 then
        local v42 = u6:CreateSound("FPGunshot", nil, false, "WeaponAudioRevamp", p36, "Discharge", p40, p41, "FPShot");
        v42.Destroy(2);
        if u6.IsInterior then
            local v43 = u6:CreateSound("FPGunshotTail", nil, false, "WeaponTails", "InteriorFPTails", u6.InteriorTail or "DefaultRoom", v42.Properties.InteriorTail or "Default_5.56");
            v43.Play();
            v43.Destroy(10);
        else
            local v44 = u6:CreateSound("FPGunshotTail", nil, false, "WeaponAudioRevamp", p36, "Discharge", p40, p41, "FPTail");
            v44.Play();
            v44.Destroy(10);
        end;
        v42.Play();
    else
        local l__Asset__15 = u3:Get("Sound", "WeaponAudioRevamp", p36, "Discharge", p40, p41, "TPClose").Asset;
        local l__Asset__16 = u3:Get("Sound", "WeaponAudioRevamp", p36, "Discharge", p40, p41, "FPShot").Asset;
        local v45;
        if typeof(p35) == "CFrame" then
            v45 = Instance.new("Attachment");
            v45.CFrame = p35;
            v45.Parent = l__Terrain__6;
            l__Debris__4:AddItem(v45, 10);
        elseif p35:IsDescendantOf(workspace) then
            v45 = p35;
        else
            v45 = Instance.new("Attachment");
            v45.CFrame = p35.WorldCFrame;
            v45.Parent = l__Terrain__6;
            l__Debris__4:AddItem(v45, 10);
        end;
        local v46 = p38 <= l__Asset__15.FadeCloseToMedium[1];
        local v47;
        if l__Asset__15.FadeCloseToMedium[2] <= p38 then
            v47 = p38 < l__Asset__15.FadeMediumToFar[1];
        else
            v47 = false;
        end;
        local v48 = u5:GetRoom(v45.WorldPosition);
        if p39 then
            local v49;
            if u6.IsInterior then
                v49 = u6:CreateSound("TPGunshotTail", nil, false, "WeaponTails", "InteriorFPTails", u6.InteriorTail or "DefaultRoom", l__Asset__16.InteriorTail or "Default_5.56");
            else
                v49 = u6:CreateSound("TPGunshotTail", nil, false, "WeaponAudioRevamp", p36, "Discharge", p40, p41, "FPTail");
            end;
            v49.Sound.Volume = v49.Volume * (1 - p38 / 40);
            v49.Play();
            v49.Destroy(10);
            local v50 = u6:CreateSound("TPGunshot", v45, false, "WeaponAudioRevamp", p36, "Discharge", p40, p41, "TPClose");
            v50.Play();
            v50.Destroy(10);
        elseif v48 and v48.IsInterior then
            local v51 = l__Asset__15.InteriorShot or "Default_5.56";
            local v52 = v48.InteriorTail or "DefaultRoom";
            local v53 = u6:CreateSound("TPGunshot", v45, false, "WeaponTails", "InteriorTPShots", v52, v51);
            v53.Destroy(10);
            if u6.IsInterior then
                local v54 = u6:CreateSound("TPGunshotTail", nil, false, "WeaponTails", "InteriorTPTails", v52, l__Asset__16.InteriorTail or "Default_5.56");
                local v55 = v54.Properties.Distance or { 0, 0 };
                if v55[2] < p38 then
                    v54.Destroy();
                else
                    v54.Sound.Volume = math.clamp(1 - (p38 - v55[1]) / (v55[2] - v55[1]), 0, 1);
                    v54.Play();
                    v54.Destroy(10);
                end;
            end;
            v53.Play();
        else
            if v46 or (v47 or l__Asset__15.FadeMediumToFar[2] <= p38) then
                u6:CreateSound("TPGunshot", v45, true, "WeaponAudioRevamp", p36, "Discharge", p40, p41, v46 and "TPClose" or (v47 and "TPMedium" or "TPFar")).Destroy(10);
            else
                local v56 = "TPClose";
                local v57 = "TPMedium";
                local v58;
                if p38 < l__Asset__15.FadeCloseToMedium[2] then
                    v58 = (p38 - l__Asset__15.FadeCloseToMedium[1]) / (l__Asset__15.FadeCloseToMedium[2] - l__Asset__15.FadeCloseToMedium[1]);
                else
                    v58 = (p38 - l__Asset__15.FadeMediumToFar[1]) / (l__Asset__15.FadeMediumToFar[2] - l__Asset__15.FadeMediumToFar[1]);
                    v56 = "TPMedium";
                    v57 = "TPFar";
                end;
                local v59 = u6:CreateSound("TPGunshot", v45, true, "WeaponAudioRevamp", p36, "Discharge", p40, p41, v56);
                v59.Sound.Volume = v59.Volume * (1 - v58);
                v59.Destroy(10);
                local v60 = u6:CreateSound("TPGunshot", v45, true, "WeaponAudioRevamp", p36, "Discharge", p40, p41, v57);
                v60.Sound.Volume = v60.Volume * v58;
                v60.Destroy(10);
            end;
            if not u6.IsInterior then
                local v61 = u6:CreateSound("TPGunshotTail", nil, false, "WeaponTails", "ExteriorTails", u6.ExteriorTail or "DefaultField", l__Asset__15.ExteriorTail or "Default_5.56");
                local l__Distance__17 = v61.Properties.Distance;
                if l__Distance__17[2] < p38 then
                    v61.Destroy();
                    return;
                end;
                v61.Sound.Volume = v61.Sound.Volume * math.clamp(1 - (p38 - l__Distance__17[1]) / (l__Distance__17[2] - l__Distance__17[1]), 0, 1);
                v61.Play(p38);
                v61.Destroy(10);
            end;
        end;
    end;
end;
function u20.new() --[[ Line: 265 ]]
    -- upvalues: u20 (copy), u4 (copy), l__Explosion__8 (copy), l__ContentProvider__1 (copy)
    local u62 = setmetatable({
        _effects = {},
        _flares = {}
    }, u20);
    u4:ConnectEvents({
        EffectsExplosion = function(p63, p64, p65) --[[ Name: EffectsExplosion, Line 272 ]]
            -- upvalues: u62 (copy)
            u62:Explode(p63, p64, p65);
        end,
        EffectsProjectile = function(...) --[[ Name: EffectsProjectile, Line 275 ]]
            -- upvalues: u62 (copy)
            u62:ProjectileFired(...);
        end
    });
    task.spawn(function() --[[ Line: 280 ]]
        -- upvalues: l__Explosion__8 (ref), l__ContentProvider__1 (ref)
        local v66 = {};
        for _, v67 in l__Explosion__8:GetDescendants() do
            if v67:IsA("ParticleEmitter") then
                v66[#v66 + 1] = v67;
            end;
        end;
        l__ContentProvider__1:PreloadAsync(v66);
    end);
    return u62;
end;
function u20.ProjectileFired(p68, p69, p70, p71, p72, p73, p74) --[[ Line: 294 ]]
    -- upvalues: u12 (copy), l__CurrentCamera__13 (copy), u7 (copy)
    p68:_firedSound(p69, u12[p70].Tracer, p73, (l__CurrentCamera__13.CFrame.Position - p69.Position).Magnitude, p72, "Default", "Dry");
    if p74 then
    else
        u7:Discharge(p69, p70, 1, nil, false, p72, nil, p71, nil);
    end;
end;
function u20.GetLevelOfDetail(_, p75) --[[ Line: 306 ]]
    -- upvalues: l__CurrentCamera__13 (copy), u9 (copy)
    if typeof(p75) == "Vector3" then
        p75 = (l__CurrentCamera__13.CFrame.Position - p75).Magnitude;
    end;
    local l__WorldDetail__18 = u9.WorldDetail;
    return l__WorldDetail__18 == 3 and (p75 < 128 and 1 or (p75 < 256 and 2 or (p75 < 512 and 3 or 4))) or (l__WorldDetail__18 == 2 and (p75 < 64 and 1 or (p75 < 128 and 2 or (p75 < 256 and 3 or 4))) or (l__WorldDetail__18 == 1 and (p75 < 32 and 1 or (p75 < 64 and 2 or (p75 < 128 and 3 or 4))) or 1));
end;
function u20.Update(p76, p77) --[[ Line: 322 ]]
    -- upvalues: l__CurrentCamera__13 (copy), u2 (copy)
    local l__Position__19 = l__CurrentCamera__13.CFrame.Position;
    local l__GlobalWind__20 = workspace.GlobalWind;
    for _, v78 in p76._effects do
        local l__Origin__21 = v78.Origin;
        if typeof(l__Origin__21) ~= "Vector3" then
            if l__Origin__21:IsA("Attachment") then
                l__Origin__21 = l__Origin__21.WorldPosition;
            else
                l__Origin__21 = l__Origin__21.Position;
            end;
        end;
        local l__Magnitude__22 = (l__Origin__21 - l__Position__19).Magnitude;
        local v79 = p76:GetLevelOfDetail(l__Magnitude__22);
        v78.Callback(p77, l__Magnitude__22, v79, l__GlobalWind__20);
    end;
    local v80 = tick();
    local v81 = 0;
    local v82 = {};
    local v83 = {};
    for v84, v85 in p76._flares do
        if v85.QueueForDeletion then
            if v85.QueueForDeletion < v80 then
                p76._flares[v84] = nil;
                v84:Destroy();
            end;
        elseif v85.Started + v85.Lifetime < v80 then
            v85.QueueForDeletion = v80 + 6;
            v84.Transparency = 1;
            v85.Top.Enabled = false;
            v85.Fireball.Enabled = false;
            v85.Light.Enabled = false;
            v85.Smoke.Enabled = false;
            v85.Long.Enabled = false;
        else
            if v85.Ignite < v80 then
                v85.Smoke.Enabled = true;
                v85.Long.Enabled = true;
            end;
            local v86 = (v80 - v85.Started) / v85.Lifetime;
            v84.Transparency = v86;
            local v87 = v85.CFrame:PointToWorldSpace(v85.GetPosition(v80));
            local v88 = math.max(0.5, (l__CurrentCamera__13.CFrame.Position - v87).Magnitude / 100 * (1 - v86));
            v84.Size = Vector3.new(v88, v88, v88);
            v81 = v81 + 1;
            v82[v81] = v84;
            v83[v81] = CFrame.new(v87, v85.Last);
            v85.Last = v87;
        end;
    end;
    if v81 > 0 then
        workspace:BulkMoveTo(v82, v83, u2.BulkMoveMode.FireCFrameChanged);
    end;
end;
function u20.HelicopterFlare(p89, p90, p91) --[[ Line: 390 ]]
    -- upvalues: l__Flare__9 (copy)
    local v92 = l__Flare__9:Clone();
    v92.CFrame = CFrame.new(p90.Position);
    v92.Parent = workspace;
    local v93, v94 = p90:ToOrientation();
    local v95 = 100 + math.random(0, 50);
    local v96 = math.cos(v93);
    local u97 = math.tan(v93);
    local u98 = 1 / (v95 ^ 2 * 2 * v96 ^ 2);
    local u99 = v96 * v95;
    v92.Smoke.Enabled = false;
    v92.Long.Enabled = false;
    local u100 = tick();
    p89._flares[v92] = {
        Started = u100,
        Ignite = u100 + 0.1 + math.random(10, 30) / 100,
        Lifetime = p91,
        Last = p90.Position,
        CFrame = CFrame.new(p90.Position) * CFrame.Angles(0, v94, 0),
        Top = v92.Top,
        Fireball = v92.Fireball,
        Light = v92.Light,
        Smoke = v92.Smoke,
        Long = v92.Long,
        GetPosition = function(p101) --[[ Name: GetPosition, Line 420 ]]
            -- upvalues: u99 (copy), u100 (copy), u97 (copy), u98 (copy)
            local v102 = u99 * (p101 - u100);
            return Vector3.new(0, v102 * u97 - v102 ^ 2 * 60 * u98, -v102);
        end
    };
end;
function u20.RegisterEffect(p103, p104, p105) --[[ Line: 428 ]]
    -- upvalues: l__HttpService__3 (copy)
    local v106 = l__HttpService__3:GenerateGUID(false);
    p103._effects[v106] = {
        Callback = p105,
        Origin = p104
    };
    return v106;
end;
function u20.UnregisterEffect(p107, p108, p109) --[[ Line: 438 ]]
    p107._effects[p108] = nil;
    if p109 then
        p109();
    end;
end;
function u20.Explode(p110, u111, p112, p113) --[[ Line: 445 ]]
    -- upvalues: l__Terrain__6 (copy), l__Debris__4 (copy), u14 (copy), l__CurrentCamera__13 (copy), u6 (copy), u5 (copy), u3 (copy), u8 (copy), l__Explosion__8 (copy), l__Weapon__10 (copy), l__TweenService__5 (copy), u2 (copy), u34 (copy)
    local u114 = Instance.new("Attachment");
    u114.WorldPosition = u111;
    u114.Parent = l__Terrain__6;
    l__Debris__4:AddItem(u114, 20);
    local u115 = u14[p112] or "Motar";
    local l__Magnitude__23 = (l__CurrentCamera__13.CFrame.Position - u111).Magnitude;
    if l__Magnitude__23 < 350 then
        u6:CancelMusic();
    end;
    pcall(function() --[[ Line: 458 ]]
        -- upvalues: u6 (ref), u5 (ref), u111 (copy), u3 (ref), u115 (copy), l__Magnitude__23 (copy), u114 (copy)
        local l__IsInterior__24 = u6.IsInterior;
        local v116 = nil;
        local v117 = u5:GetRoom(u111);
        local v118;
        if v117 and v117.IsInterior then
            v118 = true;
            if v117.ExplosionTail and #v117.ExplosionTail > 0 then
                v116 = v117.ExplosionTail;
            end;
        else
            v118 = false;
        end;
        local v119 = v118 and "Interior" or "Exterior";
        local l__Asset__25 = u3:Get("Sound", "Explosions", "Types", u115, v119, "Far").Asset;
        local l__Asset__26 = u3:Get("Sound", "Explosions", "Types", u115, v119, "Close").Asset;
        local l__Fade__27 = l__Asset__25.Fade;
        local v120;
        if l__Magnitude__23 <= l__Fade__27[1] then
            u6:CreateSound("Explosion", u114, true, "Explosions", "Types", u115, v119, "Close").Destroy(10);
            v120 = v116 or l__Asset__26.Tail;
        elseif l__Magnitude__23 >= l__Fade__27[2] then
            u6:CreateSound("Explosion", u114, true, "Explosions", "Types", u115, v119, "Far").Destroy(10);
            v120 = v116 or l__Asset__25.Tail;
        else
            local v121 = math.clamp((l__Magnitude__23 - l__Fade__27[1]) / (l__Fade__27[2] - l__Fade__27[1]), 0, 1) ^ 2;
            local v122 = u6:CreateSound("Explosion", u114, true, "Explosions", "Types", u115, v119, "Close");
            v122.Sound.Volume = v122.Sound.Volume * (1 - v121);
            v122.Destroy(10);
            local v123 = u6:CreateSound("Explosion", u114, true, "Explosions", "Types", u115, v119, "Far");
            v123.Sound.Volume = v123.Sound.Volume * v121;
            v123.Destroy(10);
            v120 = v116 or (v121 > 0.5 and l__Asset__25.Tail or l__Asset__26.Tail);
        end;
        if l__IsInterior__24 == v118 then
            local v124 = u6:CreateSound("Explosion", nil, false, "Explosions", "Types", u115, "Tails", v120);
            local l__Sound__28 = v124.Sound;
            local l__Properties__29 = v124.Properties;
            local l__RollOffMinDistance__30 = l__Properties__29.RollOffMinDistance;
            local l__RollOffMaxDistance__31 = l__Properties__29.RollOffMaxDistance;
            if l__RollOffMaxDistance__31 < l__Magnitude__23 then
                l__Sound__28:Destroy();
                return;
            end;
            local v125 = math.clamp((l__Magnitude__23 - l__RollOffMinDistance__30) / (l__RollOffMaxDistance__31 - l__RollOffMinDistance__30), 0, 1);
            l__Sound__28.Volume = l__Sound__28.Volume * (1 - v125);
            v124.Destroy(20);
            v124.Play(l__Magnitude__23);
        end;
    end);
    if l__Magnitude__23 < 150 and p110.Camera then
        p110.Camera:Shake(u8.Explosion, 1 - l__Magnitude__23 / 150);
    end;
    if l__Magnitude__23 > 2048 or l__Magnitude__23 > 100 and (u111 - l__CurrentCamera__13.CFrame.Position):Dot(l__CurrentCamera__13.CFrame.LookVector) < 0 then
    else
        local v126 = 0;
        local v127 = l__Explosion__8[u115];
        local v128 = l__Weapon__10:GetAttribute("Scaling");
        local v129;
        if v128 then
            v129 = Instance.new("Model");
            v127 = v127:Clone();
            v127.Parent = v129;
            v129:ScaleTo(p113 / v128);
        else
            v129 = nil;
        end;
        for _, v130 in v127:GetChildren() do
            if v130:IsA("ParticleEmitter") then
                local v131 = v130:Clone();
                local v132 = v131:GetAttribute("EmitDelay") or 0;
                l__Debris__4:AddItem(v131, v132 + v131.Lifetime.Max);
                v126 = math.max(v126, v132 + v131.Lifetime.Max);
                v131.Parent = u114;
                task.delay(v132, v131.Emit, v131, v131:GetAttribute("EmitCount") or v131.Rate);
            elseif v130:IsA("Light") then
                local v133 = v130:Clone();
                if v133:GetAttribute("Delay") then
                    l__Debris__4:AddItem(v133, v133:GetAttribute("Delay"));
                else
                    local v134 = v133:GetAttribute("MaxBrightness");
                    l__TweenService__5:Create(v133, TweenInfo.new(0.5, u2.EasingStyle.Sine, u2.EasingDirection.Out, 0, true), {
                        Brightness = v134
                    }):Play();
                end;
                v133.Parent = u114;
            elseif v130:IsA("BasePart") then
                local v135 = v130:GetAttribute("Count");
                local v136 = v130:GetAttribute("Force");
                for _ = 1, math.random(v135.Min, v135.Max) do
                    local v137 = v130:Clone();
                    v137.CFrame = CFrame.new(u111, u111 + u34());
                    v137.Parent = workspace;
                    v137:ApplyImpulse(u34() * (math.random() * (v136.Max - v136.Min) + v136.Min) * (p113 / v128) ^ 3);
                    l__Debris__4:AddItem(v137, 5);
                end;
            end;
        end;
        if v129 then
            v129:Destroy();
        end;
    end;
end;
function u20.BulletClack(_, p138, p139) --[[ Line: 580 ]]
    -- upvalues: u12 (copy), l__Terrain__6 (copy), u5 (copy), u15 (copy), u6 (copy), l__Debris__4 (copy)
    local v140 = u12[p138];
    if v140.Size then
        local v141 = Instance.new("Attachment");
        v141.CFrame = CFrame.new(p139);
        v141.Parent = l__Terrain__6;
        local v142 = u5;
        v142.BulletClack = v142.BulletClack + u15[v140.Size] / 5;
        local v143 = u5;
        local v144 = math.random();
        local v145 = math.random();
        v143.BulletOffset = Vector3.new(v144, v145, math.random()) * 0.05;
        u6:CreateSound("Bullet_Suppression", v141, true, "BulletSuppression", v140.Suppression or v140.Size).Destroy(5);
        l__Debris__4:AddItem(v141, 5);
    end;
end;
function u20.BulletFired(p146, u147, p148, p149, p150, p151, p152) --[[ Line: 598 ]]
    -- upvalues: u12 (copy), l__CurrentCamera__13 (copy), u6 (copy), u13 (copy), u16 (copy), u5 (copy), l__Shell__11 (copy), u2 (copy), l__Weapon__10 (copy), u10 (copy)
    local v153 = u147:FindFirstChild("muzzle");
    local v154 = u147:FindFirstChild("barrel");
    local u155 = v153 and v153:FindFirstChild("tip", true) or (v154 and v154:FindFirstChild("tip", true) or u147:FindFirstChild("tip", true));
    if u155 then
        local l__Tune__32 = p151.Tune;
        local u156 = u12[p148];
        local l__Magnitude__33 = (l__CurrentCamera__13.CFrame.Position - u155.WorldPosition).Magnitude;
        local u157 = p146:GetLevelOfDetail(l__Magnitude__33);
        local v158 = l__Tune__32.Barrel_Sound or "Default";
        local v159 = l__Tune__32.Subsonic and l__Tune__32.Suppressed and "Subsonic" or (l__Tune__32.Suppressed and "Suppressed" or "Dry");
        if l__Magnitude__33 < 350 then
            u6:CancelMusic();
        end;
        p146:_firedSound(u155, not u13[p149] and "M4A1" or p149, p150, l__Magnitude__33, p152, v158, v159);
        local v160 = l__Tune__32.Suppressed or false;
        local v161 = u155:FindFirstChild("VFX");
        if v161 then
            v160 = v161:GetAttribute("HideFlash") and true or v160;
            for _, v162 in v161:GetDescendants() do
                if v162:IsA("ParticleEmitter") and not (p150 and v162:GetAttribute("Local")) then
                    local v163 = v162:GetAttribute("EmitCount");
                    if v163 then
                        if v163 > 1 then
                            v162:Emit(v163);
                        elseif math.random() < v163 then
                            v162:Emit(1);
                        end;
                    end;
                end;
            end;
        end;
        if u157 <= 2 and not v160 then
            local u164 = Instance.new("PointLight");
            u164.Color = Color3.fromRGB(226, 155, 64);
            u164.Brightness = 10;
            u164.Range = 4;
            u164.Enabled = true;
            u164.Parent = u155;
            task.delay(0, function() --[[ Line: 662 ]]
                -- upvalues: u164 (copy)
                u164:Destroy();
            end);
            for _ = 1, 2 do
                local u165 = Instance.new("SpotLight");
                u165.Color = Color3.fromRGB(226, 155, 64);
                u165.Shadows = true;
                u165.Brightness = math.random(10, 50) / 10;
                u165.Range = math.random(4, 10);
                u165.Angle = 180;
                u165.Face = u16[math.random(1, #u16)];
                u165.Enabled = true;
                u165.Parent = u155;
                task.delay(0, function() --[[ Line: 676 ]]
                    -- upvalues: u165 (copy)
                    u165:Destroy();
                end);
            end;
            u5.Flares[u155] = {
                Color = Color3.fromRGB(226, 155, 64),
                Size = math.random(5, 15) / 10,
                Intensity = math.random(4, 8)
            };
            task.delay(0, function() --[[ Line: 686 ]]
                -- upvalues: u5 (ref), u155 (copy)
                task.delay(0, function() --[[ Line: 687 ]]
                    -- upvalues: u5 (ref), u155 (ref)
                    u5.Flares[u155] = nil;
                end);
            end);
        end;
        return function(p166) --[[ Line: 693 ]]
            -- upvalues: u157 (copy), u147 (copy), u156 (copy), l__Shell__11 (ref), u2 (ref), l__Weapon__10 (ref), u6 (ref), u10 (ref)
            if u157 > 1 then
            else
                local v167 = u147:FindFirstChild("eject", true);
                if v167 then
                    for _, v168 in u156.Shells do
                        local l__WorldCFrame__34 = v167.WorldCFrame;
                        local u169 = l__Shell__11[v168]:Clone();
                        u169.Anchored = false;
                        u169.CFrame = l__WorldCFrame__34;
                        u169.CanCollide = true;
                        u169.CollisionGroup = u2.PhysicsGroup.Debris;
                        u169.Parent = workspace;
                        local u170;
                        if p166 then
                            local v171 = Instance.new("Attachment");
                            v171.CFrame = CFrame.new(0, u169.Size.Z / 2, u169.Size.Z / 2);
                            v171.Parent = u169;
                            local v172 = Instance.new("Attachment");
                            v172.CFrame = CFrame.new(0, -u169.Size.Z / 2, -u169.Size.Z / 2);
                            v172.Parent = u169;
                            u170 = l__Weapon__10.Eject.Motion:Clone();
                            u170.Attachment0 = v171;
                            u170.Attachment1 = v172;
                            u170.Color = ColorSequence.new(u169.Color);
                            u170.Parent = u169;
                            u169.Transparency = math.random();
                        else
                            u170 = nil;
                        end;
                        local v173 = u169:GetMass() * 0.01;
                        local v174 = math.random(-150, 150);
                        local v175 = math.random(-150, 0);
                        u169:ApplyAngularImpulse(v173 * Vector3.new(v174, v175, 0));
                        u169:ApplyImpulse(u169:GetMass() * (p166 and 3 or 1.5) * (Vector3.new(0, 5, 0) + l__WorldCFrame__34.RightVector * math.random(5, 15) + l__WorldCFrame__34.LookVector * math.random(-5, 0)));
                        local u176 = nil;
                        u176 = u169.Touched:Connect(function(p177) --[[ Line: 732 ]]
                            -- upvalues: u176 (ref), u170 (ref), u169 (copy), u6 (ref), u156 (ref), u10 (ref)
                            u176:Disconnect();
                            if u170 then
                                u170:Destroy();
                                u169.Transparency = 0;
                            end;
                            u6:CreateSound("Bullet_Interaction", u169, true, "CasingDrops", u156.Size, u10[p177.Material]).Destroy(2);
                        end);
                        task.delay(10, function() --[[ Line: 743 ]]
                            -- upvalues: u169 (copy)
                            u169:Destroy();
                        end);
                    end;
                    if p166 and (v167:FindFirstChild("Wide") and (v167:FindFirstChild("Core") and v167:FindFirstChild("Smoke"))) then
                        v167.Wide:Emit(4);
                        v167.Core:Emit(1);
                        v167.Smoke:Emit(2);
                    end;
                end;
            end;
        end;
    end;
end;
function u20.BulletLand(p178, _, p179, p180, p181, p182, p183, p184) --[[ Line: 759 ]]
    -- upvalues: u12 (copy), l__CurrentCamera__13 (copy), u2 (copy), u11 (copy), u15 (copy), l__Terrain__6 (copy), l__Hit__12 (copy), u6 (copy), u18 (copy), l__Debris__4 (copy), u5 (copy), u26 (copy), u17 (copy), u19 (copy)
    local v185 = u12[p183];
    if v185.AoE then
        if p184 then
            if v185.Arming and (p179 - l__CurrentCamera__13.CFrame.Position).Magnitude < v185.Arming then
                return;
            end;
            p178:Explode(p179, u2.ExplosionType[v185.Tracer], v185.AoE);
        end;
    else
        local v186 = p182 == "Blood";
        local v187 = p180.Reflectance > 0 and "Metal" or u11[p182];
        if p178:GetLevelOfDetail((l__CurrentCamera__13.CFrame.Position - p179).Magnitude) > 1 and not p184 then
        else
            local u188 = Instance.new("Attachment");
            u188.CFrame = p180.CFrame:ToObjectSpace(CFrame.new(p179, p179 + p181));
            u188.Parent = p180;
            task.delay(3, function() --[[ Line: 786 ]]
                -- upvalues: u188 (copy)
                u188:Destroy();
            end);
            local v189 = u15[v185.Size] * 2;
            if v186 then
                local l__WorldCFrame__35 = u188.WorldCFrame;
                u188.Parent = l__Terrain__6;
                u188.CFrame = l__WorldCFrame__35;
                local v190 = Color3.fromRGB(150, 0, 0);
                local v191 = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.016, v189 * 1.8, v189 * 0.8), NumberSequenceKeypoint.new(1, v189 * 3.88, v189 * 2.56) });
                local v192 = l__Hit__12.Smoke:Clone();
                v192.Size = v191;
                v192.Color = ColorSequence.new(v190);
                v192.Parent = u188;
                v192:Emit(1);
                local v193 = l__Hit__12.Smoke:Clone();
                v193.Size = v191;
                v193.Color = ColorSequence.new(v190);
                v193.EmissionDirection = u2.NormalId.Back;
                v193.Parent = u188;
                v193:Emit(1);
                local v194 = l__Hit__12.Core:Clone();
                v194.Size = v191;
                v194.Color = ColorSequence.new(v190);
                v194.Parent = u188;
                v194:Emit(1);
                local v195 = l__Hit__12.Wide:Clone();
                v195.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.027, v189 * 1.75, v189 * 0.812), NumberSequenceKeypoint.new(1, v189 * 1.25, v189 * 1.12) });
                v195.Color = ColorSequence.new(v190);
                v195.Parent = u188;
                v195:Emit(5);
                local v196 = l__Hit__12.Dust:Clone();
                local v197, v198 = v190:ToHSV();
                v196.Size = NumberSequence.new(2);
                v196.Color = ColorSequence.new(Color3.fromHSV(v197, v198, 0.3137254901960784));
                v196.Parent = u188;
                v196:Emit(4);
                local l__Name__36 = p180.Name;
                local v199 = l__Name__36 == "Head" and "Player_Head" or (l__Name__36 == "UpperTorso" and l__Name__36 == "LowerTorso" and "Player_Torso" or "Player_Limb");
                if v185.Sound then
                    u6:CreateSound("Weapon_Interaction", u188, true, "MeleeImpacts", v185.Sound, l__Name__36 == "Head" and "Head" or "Body").Destroy(5);
                end;
                u6:CreateSound("Bullet_Impacts", u188, true, "BulletImpacts", v199).Destroy(5);
            elseif v187 then
                local v200 = p180 == l__Terrain__6 and u18[v187] or p180.Color;
                if v187 == "Metal" then
                    local v201 = l__Hit__12.Metal:Clone();
                    v201.Parent = u188;
                    v201:Emit(10);
                    local v202 = Instance.new("PointLight");
                    v202.Brightness = 2;
                    v202.Color = Color3.new(1, 1, 1);
                    v202.Range = 8;
                    v202.Parent = u188;
                    l__Debris__4:AddItem(v202, 0.05);
                    u5.Temp[u188] = {
                        Intensity = 5,
                        Color = Color3.new(1, 1, 1)
                    };
                elseif v187 ~= "Glass" then
                    if v187 == "Wood" then
                        local v203 = l__Hit__12.Wood:Clone();
                        v203.Color = ColorSequence.new(v200:Lerp(Color3.new(1, 1, 1), 0.4));
                        v203.Parent = u188;
                        v203:Emit((math.floor(v189 * 10)));
                    end;
                    local v204 = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.016, v189 * 1.8, v189 * 0.8), NumberSequenceKeypoint.new(1, v189 * 3.88, v189 * 2.56) });
                    local v205 = l__Hit__12.Smoke:Clone();
                    v205.Size = v204;
                    v205.Color = ColorSequence.new(v200);
                    v205.Parent = u188;
                    v205:Emit(1);
                    local v206 = l__Hit__12.Core:Clone();
                    v206.Size = v204;
                    v206.Color = ColorSequence.new(v200);
                    v206.Parent = u188;
                    v206:Emit(1);
                    local v207 = l__Hit__12.Wide:Clone();
                    v207.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.027, v189 * 1.75, v189 * 0.812), NumberSequenceKeypoint.new(1, v189 * 1.25, v189 * 1.12) });
                    v207.Color = ColorSequence.new(v200);
                    v207.Parent = u188;
                    v207:Emit(5);
                    local v208 = l__Hit__12.Dust:Clone();
                    local v209, v210 = v200:ToHSV();
                    v208.Size = NumberSequence.new(v189 * 3);
                    v208.Color = ColorSequence.new(Color3.fromHSV(v209, v210, 0.3137254901960784));
                    v208.Parent = u188;
                    v208:Emit(4);
                end;
                local v211 = p180:GetAttribute("MetaMaterial");
                local v212;
                if v211 then
                    v212 = "Special_" .. v211 or v187;
                else
                    v212 = v187;
                end;
                if not v211 and (p180.MaterialVariant and (#p180.MaterialVariant > 0 and u11[p180.MaterialVariant])) then
                    v212 = u11[p180.MaterialVariant];
                end;
                u6:CreateSound("Bullet_Impacts", u188, true, "BulletImpacts", v212).Destroy(5);
            end;
            local v213 = u26(p180, p179);
            if p182 ~= u2.Material.Neon then
                if not u17[v187] then
                    return;
                end;
                local v214 = "rbxassetid://" .. (v186 and 513989292 or u17[v187][math.random(1, #u17[v187])]);
                local v215 = 0.3 * (v187 == "Glass" and 6 or 1);
                if p180:IsA("MeshPart") and not v186 or (p180:IsA("UnionOperation") or p180 == l__Terrain__6) then
                    local v216 = CFrame.new(p179, p179 + p181);
                    local v217 = Instance.new("ImageHandleAdornment");
                    local l__CFrame__37 = p180.CFrame;
                    local l__Angles__38 = CFrame.Angles;
                    local v218 = math.random(0, 360);
                    v217.CFrame = l__CFrame__37:ToObjectSpace(v216 * l__Angles__38(0, 0, (math.rad(v218))) + v216.LookVector * 0.01);
                    v217.Size = Vector2.new(v215, v215);
                    v217.Image = v214;
                    v217.Parent = p180;
                    v217.Adornee = p180;
                    l__Debris__4:AddItem(v217, 10);
                    return;
                end;
                local v219 = p180:FindFirstChild("Bullet" .. v213);
                if not v219 then
                    v219 = Instance.new("SurfaceGui");
                    v219.Name = "Bullet" .. v213;
                    v219.Face = u2.NormalId[v213];
                    v219.PixelsPerStud = 100;
                    v219.SizingMode = u2.SurfaceGuiSizingMode.PixelsPerStud;
                    v219.ClipsDescendants = true;
                    v219.LightInfluence = 1;
                    v219.Parent = p180;
                end;
                local v220 = Instance.new("ImageLabel");
                v220.AnchorPoint = Vector2.new(0.5, 0.5);
                v220.Size = UDim2.new(0, v215 * 100, 0, v215 * 100);
                local v221 = p180.CFrame:PointToObjectSpace(p179);
                local v222 = u19[v213];
                local v223 = v222[1];
                local v224 = v222[2];
                v220.Position = UDim2.new(0.5, v221[v223[1]] * v223[2] * 100, 0.5, v221[v224[1]] * v224[2] * 100);
                v220.BackgroundTransparency = 1;
                v220.Image = v214;
                v220.Parent = v219;
                l__Debris__4:AddItem(v220, 10);
            end;
        end;
    end;
end;
return u20.new();