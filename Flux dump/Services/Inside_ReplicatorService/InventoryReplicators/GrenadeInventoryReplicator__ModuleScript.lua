-- Services.ReplicatorService.InventoryReplicators.GrenadeInventoryReplicator
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3 = shared.import("require", "asset", "Enum");
local u4 = v1("EffectsService");
local u5 = v1("TrajectoryService");
local u6 = v1("EnvironmentService");
local u7 = v1("SoundService");
local u8 = v1("ItemLayout");
local u9 = v1("Grenades");
local u10 = v1("Mathf");
local u11 = v1("Spring");
local l__Debris__1 = game:GetService("Debris");
local u12 = {};
u12.__index = u12;
function u12.new(p13, p14) --[[ Line: 18 ]]
    -- upvalues: u8 (copy), u2 (copy), u9 (copy), u11 (copy), u12 (copy)
    local v15 = u8[p14.Name];
    local v16 = {
        _lerp = 1,
        _equip = p13:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Grenade", "TP", "Equip").ID),
        _fuze = v15.Fuze,
        _type = v15.GrenadeType,
        _actor = p13,
        _soundKit = u9[p14.Name].Sounds or "M67",
        _sway = u11.new(Vector2.zero)
    };
    local v17 = setmetatable(v16, u12);
    v17._sway.Speed = 10;
    v17._sway.Damper = 0.2;
    if not p13.Grenades then
        p13.Grenades = {};
    end;
    local l__Grenades__2 = p13.Grenades;
    if l__Grenades__2[1] == nil then
        v17._slot = 1;
    elseif l__Grenades__2[2] == nil then
        v17._slot = 2;
    elseif l__Grenades__2[3] == nil then
        v17._slot = 3;
    end;
    l__Grenades__2[v17._slot] = true;
    v17._C0 = p13.Parts.LowerTorso["Grenade" .. tostring(v17._slot)].CFrame;
    v17._belt = p13.Parts.LowerTorso;
    v17._hand = p13.Parts.RightHand;
    local v18 = u2:Get("Shared", "Models", "Grenade", v15.Model).Asset:Clone();
    local l__PrimaryPart__3 = v18.PrimaryPart;
    local v19 = Instance.new("Weld");
    v19.Part1 = l__PrimaryPart__3;
    v19.Parent = v18;
    for _, v20 in v18:GetChildren() do
        if v20:IsA("BasePart") then
            v20.CanCollide = false;
            v20.CanQuery = false;
            v20.AudioCanCollide = false;
            v20.CanTouch = false;
        end;
    end;
    v17._handOffset = l__PrimaryPart__3.Hand.CFrame;
    v17._C1 = l__PrimaryPart__3.Anchor.CFrame;
    v17._primary = l__PrimaryPart__3;
    v17._model = v18;
    v17._weld = v19;
    v17._toBelt = true;
    v19.C0 = v17._C0;
    v19.C1 = v17._C1;
    v19.Part0 = v17._belt;
    v18.Parent = p13.Character;
    return v17;
end;
function u12.Equip(p21) --[[ Line: 80 ]]
    -- upvalues: u2 (copy), u7 (copy)
    p21._equip:Play(0);
    p21._toHand = true;
    p21._lerp = 0;
    p21._offset = nil;
    p21._toBelt = nil;
    p21._idle = p21._actor:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Grenade", "TP", "Idle").ID);
    p21._idle:Play();
    local l___primary__4 = p21._primary;
    local l__ViewModel__5 = p21._actor.ViewModel;
    if l__ViewModel__5 then
        local l__ID__6 = u2:Get("Animation", "CharacterAnimations", "Grenade", "FP", "Idle").ID;
        local l__ID__7 = u2:Get("Animation", "CharacterAnimations", "Grenade", "FP", "Equip").ID;
        l__ViewModel__5:SetModel(p21._model, l__ID__6, l__ID__7);
        l__ViewModel__5.SprintID = 0;
        if l__ViewModel__5.Active then
            l___primary__4 = nil;
        end;
    end;
    u7:CreateSound("Weapon_Interaction", l___primary__4, false, "GrenadeSounds", p21._soundKit, "Equip").Play();
end;
function u12.Unequip(p22) --[[ Line: 106 ]]
    p22._equip:Play(0);
    p22._toBelt = true;
    p22._lerp = 0;
    p22._offset = nil;
    p22._toHand = nil;
    p22._idle:Stop();
    if p22._prepare then
        p22._prepare:Stop();
    end;
    local l__ViewModel__8 = p22._actor.ViewModel;
    if l__ViewModel__8 then
        if p22._prepare_fp then
            p22._prepare_fp:Stop();
        end;
        if p22._idle_fp then
            p22._idle_fp:Stop();
        end;
        l__ViewModel__8.SprintID = nil;
        l__ViewModel__8:SetModel();
    end;
end;
function u12.PullPin(p23, p24) --[[ Line: 132 ]]
    -- upvalues: u2 (copy), u3 (copy), u7 (copy)
    p23._prefix = p24 and "High" or "Low";
    p23._idle:Stop();
    p23._idle = p23._actor:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Grenade", "TP", p23._prefix .. "_Idle").ID);
    p23._idle.Priority = u3.AnimationPriority.Action;
    p23._prepare = p23._actor:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Grenade", "TP", p23._prefix .. "_Prepare").ID);
    p23._prepare.Priority = u3.AnimationPriority.Action2;
    p23._idle:Play(0);
    p23._prepare:Play(0);
    local l___primary__9 = p23._primary;
    local l__ViewModel__10 = p23._actor.ViewModel;
    if l__ViewModel__10 then
        p23._idle_fp = l__ViewModel__10:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Grenade", "FP", p23._prefix .. "_Idle").ID);
        p23._idle_fp.Priority = u3.AnimationPriority.Action;
        p23._prepare_fp = l__ViewModel__10:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Grenade", "FP", p23._prefix .. "_Prepare").ID);
        p23._prepare_fp.Priority = u3.AnimationPriority.Action2;
        p23._idle_fp:Play(0);
        p23._prepare_fp:Play(0);
        if l__ViewModel__10.Active then
            l___primary__9 = nil;
        end;
    end;
    u7:CreateSound("Weapon_Interaction", l___primary__9, false, "GrenadeSounds", p23._soundKit, "Prepare").Play();
end;
function u12.Throw(p25, p26) --[[ Line: 162 ]]
    -- upvalues: u3 (copy), u4 (copy), l__Debris__1 (copy), u6 (copy), u10 (copy), u5 (copy), u7 (copy), u2 (copy)
    if p26 then
        local l___model__11 = p25._model;
        if not l___model__11 then
            return;
        end;
        l___model__11.Parent = workspace;
        p25._weld:Destroy();
        p25._model = nil;
        local l___primary__12 = p25._primary;
        l___primary__12.Anchored = true;
        local v27 = l___primary__12:FindFirstChild("Pin");
        if v27 then
            v27.Part1.CollisionGroup = u3.PhysicsGroup.Debris;
            v27.Part1.CanCollide = true;
            v27:Destroy();
        end;
        local v28 = l___primary__12:FindFirstChild("Spoon");
        if v28 then
            v28.Part1.CollisionGroup = u3.PhysicsGroup.Debris;
            v28.Part1.CanCollide = true;
            v28:Destroy();
        end;
        local l___type__13 = p25._type;
        if l___type__13 == u3.GrenadeType.Smoke then
            local l__Tip__14 = l___primary__12.Tip;
            local l__Smoke__15 = l__Tip__14.Smoke;
            local l__Smaller__16 = l__Tip__14.Smaller;
            local l__Fire__17 = l__Tip__14.Fire;
            local l__Core__18 = l__Tip__14.Core;
            local l__Sparks__19 = l__Tip__14.Sparks;
            l__Smoke__15.Enabled = true;
            local v31 = u4:RegisterEffect(l__Tip__14, function(_, _, p29, _) --[[ Line: 201 ]]
                -- upvalues: l__Smaller__16 (copy), l__Fire__17 (copy), l__Core__18 (copy), l__Sparks__19 (copy), l__Smoke__15 (copy)
                local v30 = p29 == 1;
                l__Smaller__16.Enabled = v30;
                l__Fire__17.Enabled = v30;
                l__Core__18.Enabled = v30;
                l__Sparks__19.Enabled = v30;
                l__Smoke__15.Acceleration = Vector3.new();
                l__Smoke__15.Speed = NumberRange.new(40);
            end);
            task.delay(50, u4.UnregisterEffect, u4, v31, function() --[[ Line: 212 ]]
                -- upvalues: l__Smoke__15 (copy), l__Smaller__16 (copy), l__Fire__17 (copy), l__Core__18 (copy), l__Sparks__19 (copy)
                l__Smoke__15.Enabled = false;
                l__Smaller__16.Enabled = false;
                l__Fire__17.Enabled = false;
                l__Core__18.Enabled = false;
                l__Sparks__19.Enabled = false;
            end);
            l__Debris__1:AddItem(l___model__11, 60);
        elseif l___type__13 == u3.GrenadeType.Flare then
            local l__Tip__20 = l___primary__12.Tip;
            local l__Light__21 = l__Tip__20.Light;
            local l__Fast__22 = l__Tip__20.Fast;
            local l__Core__23 = l__Tip__20.Core;
            local l__Fire__24 = l__Tip__20.Fire;
            local l__Flare__25 = l__Tip__20.Flare;
            local l__Sparks__26 = l__Tip__20.Sparks;
            l__Light__21.Enabled = true;
            l__Light__21.Brightness = 1;
            l__Flare__25.Enabled = true;
            local v38 = u4:RegisterEffect(l__Tip__20, function(_, p32, p33, p34) --[[ Line: 232 ]]
                -- upvalues: l__Fast__22 (copy), l__Fire__24 (copy), l__Sparks__26 (copy), l__Core__23 (copy), l__Light__21 (copy), l__Flare__25 (copy), u6 (ref), l__Tip__20 (copy)
                local v35 = p33 == 1;
                local v36 = math.noise(tick() % 2, 0, 0);
                local v37 = math.abs(v36) + 0.5;
                l__Fast__22.Enabled = v35;
                l__Fire__24.Enabled = v35;
                l__Sparks__26.Enabled = v35;
                l__Core__23.Enabled = p33 <= 2;
                l__Light__21.Range = v37 * 15;
                l__Flare__25.Acceleration = Vector3.new(p34.X, 10, p34.Z);
                if p32 < 256 then
                    u6.Flares[l__Tip__20] = {
                        Light = l__Light__21,
                        Color = Color3.new(1, 0, 0),
                        Intensity = v37 * 5
                    };
                else
                    u6.Flares[l__Tip__20] = nil;
                end;
            end);
            task.delay(50, u4.UnregisterEffect, u4, v38, function() --[[ Line: 255 ]]
                -- upvalues: l__Light__21 (copy), l__Fast__22 (copy), l__Flare__25 (copy), l__Fire__24 (copy), l__Core__23 (copy), l__Sparks__26 (copy), u6 (ref), l__Tip__20 (copy)
                l__Light__21.Enabled = false;
                l__Fast__22.Enabled = false;
                l__Flare__25.Enabled = false;
                l__Fire__24.Enabled = false;
                l__Core__23.Enabled = false;
                l__Sparks__26.Enabled = false;
                u6.Flares[l__Tip__20] = nil;
            end);
            l__Debris__1:AddItem(l___model__11, 60);
        elseif l___type__13 == u3.GrenadeType.Glowstick then
            local l__Tip__27 = l___primary__12.Tip;
            local u39, u40, u41 = l___primary__12.Color:ToHSV();
            local l__Glow__28 = l___model__11.Glow;
            l__Glow__28.Material = u3.Material.Neon;
            local u42 = Instance.new("PointLight");
            u42.Color = Color3.fromHSV(u39, u40, 1);
            u42.Brightness = 1;
            u42.Range = 15;
            u42.Parent = l__Tip__27;
            local u43 = tick();
            local v48 = u4:RegisterEffect(l__Tip__27, function(_, p44, _, _) --[[ Line: 279 ]]
                -- upvalues: u43 (copy), u42 (copy), l___primary__12 (copy), u39 (copy), u40 (copy), u10 (ref), u41 (copy), l__Glow__28 (copy), u3 (ref), u6 (ref), l__Tip__27 (copy)
                local v45 = (tick() - u43) / 45;
                local v46 = 1 - math.clamp(v45, 0, 1);
                u42.Brightness = math.clamp(v46 - 0.25, 0, 0.75) / 0.75;
                l___primary__12.Transparency = v46 * 0.25 + 0.25;
                local v47 = Color3.fromHSV(u39, u40, u10.Lerp(u41, 1, v46));
                l___primary__12.Color = v47;
                l__Glow__28.Color = Color3.fromRGB(27, 42, 53):Lerp(v47, v46);
                l___primary__12.Material = v46 > 0.25 and u3.Material.Neon or u3.Material.Plastic;
                if p44 < 256 and v46 > 0.25 then
                    u6.Flares[l__Tip__27] = {
                        Light = u42,
                        Color = v47,
                        Intensity = v46
                    };
                else
                    u6.Flares[l__Tip__27] = nil;
                end;
            end);
            task.delay(45, u4.UnregisterEffect, u4, v48, function() --[[ Line: 300 ]]
                -- upvalues: l___primary__12 (copy), u3 (ref), u6 (ref), l__Tip__27 (copy)
                l___primary__12.Material = u3.Material.Plastic;
                u6.Flares[l__Tip__27] = nil;
            end);
            l__Debris__1:AddItem(l___model__11, 55);
        elseif l___type__13 == u3.GrenadeType.Explosive or l___type__13 == u3.GrenadeType.Flash then
            l__Debris__1:AddItem(l___model__11, p25._fuze);
        elseif l___type__13 == u3.GrenadeType.Dummy then
            l__Debris__1:AddItem(l___model__11, 30);
        end;
        u5:Travel(l___primary__12, p26, function(_, p49) --[[ Line: 311 ]]
            -- upvalues: u7 (ref), l___primary__12 (copy)
            u7:CreateSound("Footsteps", l___primary__12, true, "GrenadeBounces", p49 < 15 and "Rest" or "Short").Destroy(10);
        end);
    end;
    if p25._prefix then
        p25._prepare:Stop(0);
        p25._idle:Stop(0);
        p25._actor:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Grenade", "TP", p25._prefix .. "_Throw").ID):Play(0);
        local l___primary__29 = p25._primary;
        local l__ViewModel__30 = p25._actor.ViewModel;
        if l__ViewModel__30 then
            if p25._prepare_fp then
                p25._prepare_fp:Stop(0);
            end;
            if p25._idle_fp then
                p25._idle_fp:Stop(0);
            end;
            l__ViewModel__30:LoadAnimation(u2:Get("Animation", "CharacterAnimations", "Grenade", "FP", p25._prefix .. "_Throw").ID):Play(0);
            if l__ViewModel__30.Active then
                l___primary__29 = nil;
            end;
        end;
        u7:CreateSound("Weapon_Interaction", l___primary__29, false, "GrenadeSounds", p25._soundKit, p25._prefix .. "_Throw").Play();
    end;
end;
function u12.Update(p50, p51, p52, p53) --[[ Line: 342 ]]
    -- upvalues: u10 (copy)
    local l___toBelt__31 = p50._toBelt;
    local l___toHand__32 = p50._toHand;
    if l___toHand__32 or l___toBelt__31 then
        local l___weld__33 = p50._weld;
        local v54;
        if p51 == 3 then
            v54 = p52 == 1;
        else
            v54 = false;
        end;
        local v55 = v54 and (p50._lerp or 1) or 1;
        if v55 > 0.5 then
            local v56 = (v55 - 0.5) * 2;
            if l___toBelt__31 then
                if not p50._offset then
                    p50._offset = p50._primary.CFrame:ToObjectSpace(p50._belt.CFrame):Inverse();
                end;
                local l__zero__34 = Vector2.zero;
                if v54 then
                    local v57, _, v58 = l___weld__33.Part0.CFrame:ToOrientation();
                    p50._sway:Impulse(Vector2.new(v58, (math.max(v57, 0))));
                    p50._sway.Target = Vector2.new(v58 / 2, math.max(v57, 0) / 2);
                    l__zero__34 = p50._sway.Position;
                end;
                l___weld__33.C0 = p50._offset:Lerp(p50._C0 * CFrame.Angles(-l__zero__34.Y, 0, 0) * CFrame.Angles(0, 0, -l__zero__34.X), v56);
                l___weld__33.C1 = CFrame.new():Lerp(p50._C1, v56);
                l___weld__33.Part0 = p50._belt;
            elseif l___toHand__32 then
                if not p50._offset then
                    p50._offset = p50._primary.CFrame:ToObjectSpace(p50._hand.CFrame):Inverse();
                end;
                l___weld__33.C0 = p50._offset:Lerp(CFrame.new(), v56);
                l___weld__33.C1 = CFrame.new():Lerp(p50._handOffset, v56);
                l___weld__33.Part0 = p50._hand;
            end;
        end;
        if p50._lerp > 0.99 then
            p50._lerp = 1;
            if not v54 then
                p50._offset = nil;
                p50._toBelt = nil;
                p50._toHand = nil;
            end;
        else
            p50._lerp = u10.Lerp(v55, 1, p53 * 7.5);
        end;
    end;
end;
function u12.Destroy(p59) --[[ Line: 390 ]]
    if p59._model then
        p59._model:Destroy();
        p59._model = nil;
    end;
    p59._actor.Grenades[p59._slot] = nil;
end;
return u12;