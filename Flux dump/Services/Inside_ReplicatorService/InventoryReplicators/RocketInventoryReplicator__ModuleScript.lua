-- Services.ReplicatorService.InventoryReplicators.RocketInventoryReplicator
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, _, u4 = shared.import("require", "asset", "Enum", "network", "frc");
local u5 = v1("EffectsService");
local u6 = v1("SoundService");
local u7 = v1("Rockets");
local u8 = v1("Calibers");
local u9 = v1("Spring");
local u10 = v1("Mathf");
local u11 = {};
u11.__index = u11;
function u11._updateModels(p12, p13) --[[ Line: 15 ]]
    p13(p12._heroModel);
    local l__ViewModel__1 = p12._actor.ViewModel;
    if l__ViewModel__1 and l__ViewModel__1.CurrentModel then
        p13(l__ViewModel__1.CurrentModel);
    end;
end;
function u11._updateModel(p14, u15, u16) --[[ Line: 24 ]]
    -- upvalues: u2 (copy)
    local l__MetaData__2 = p14._item.MetaData;
    if p14._config.Tune.Shells then
        p14:_updateModels(function(p17) --[[ Line: 28 ]]
            -- upvalues: l__MetaData__2 (copy), u15 (copy), u16 (copy), u2 (ref)
            local v18 = p17:FindFirstChild("mag");
            if v18 then
                local v19 = v18:FindFirstChild("bullet");
                local v20 = v18:FindFirstChild("mag");
                if v19 and v20 then
                    local v21 = l__MetaData__2.Mag == nil and not u15 and 1 or 0;
                    if u16 then
                        local l__Asset__3 = u2:Get("Shared", "Models", "Junk", u16).Asset;
                        v19.TextureID = l__Asset__3.Bullet.TextureID;
                        v20.TextureID = l__Asset__3.Base.TextureID;
                    else
                        v21 = 1;
                    end;
                    v19.Transparency = v21;
                    v20.Transparency = u16 and 0 or 1;
                end;
            end;
        end);
    else
        p14:_updateModels(function(p22) --[[ Line: 53 ]]
            -- upvalues: l__MetaData__2 (copy), u15 (copy)
            local v23 = l__MetaData__2.Mag == nil and not u15 and 1 or 0;
            local v24 = p22:FindFirstChild("rocket", true);
            if v24 then
                v24.Transparency = v23;
            end;
        end);
    end;
end;
function u11.new(p25, p26) --[[ Line: 63 ]]
    -- upvalues: u2 (copy), u3 (copy), u7 (copy), u9 (copy), u11 (copy)
    local l__Model__4 = p26.Layout.Model;
    local v27 = u2:Get("Shared", "Models", "Rocket", l__Model__4).Asset:Clone();
    for _, v28 in v27:GetDescendants() do
        if v28:IsA("BasePart") then
            v28.CanCollide = false;
            v28.CanQuery = false;
            v28.AudioCanCollide = false;
            v28.CanTouch = false;
            v28.Anchored = false;
        end;
    end;
    local v29 = RaycastParams.new();
    v29.FilterType = u3.RaycastFilterType.Blacklist;
    v29.FilterDescendantsInstances = { p25.Character };
    v29.CollisionGroup = u3.PhysicsGroup.BulletCast;
    v29.IgnoreWater = false;
    local v30 = u7[l__Model__4];
    local l__ID__5 = u2:Get("Animation", "GenericWeapon", "Draw").ID;
    if v30.Animations.Third then
        l__ID__5 = v30.Animations.Third.Draw;
    end;
    local v31 = v27:FindFirstChild("tip", true);
    local v32 = {
        _animationKit = "LongGun",
        _lerp = 1,
        _equip = p25:LoadAnimation(l__ID__5),
        _item = p26,
        _actor = p25,
        _tip = v31,
        _config = v30,
        _heroModel = v27,
        _modelName = l__Model__4,
        _sway = u9.new(Vector2.zero)
    };
    local v33 = setmetatable(v32, u11);
    v33._sway.Speed = 10;
    v33._sway.Damper = 0.2;
    v33._beltC0 = CFrame.new();
    v33._beltC1 = v27.PrimaryPart.UpperTorso.CFrame;
    v33._belt = p25.Parts.UpperTorso;
    if p26.MetaData.Mag then
        v33._lastLoaded = p26.MetaData.Mag;
    else
        v33._fired = true;
    end;
    v33._handC0 = CFrame.new(-0.3, 0, -0.5) * CFrame.Angles(1.5707963267948966, 3.141592653589793, 3.141592653589793);
    v33._handC1 = v27.PrimaryPart.anchor.CFrame;
    v33._hand = p25.Parts.RightHand;
    v33._primary = v27.PrimaryPart;
    v33._toBelt = true;
    local v34 = Instance.new("Motor6D");
    v34.Part0 = v33._belt;
    v34.Part1 = v27.PrimaryPart;
    v34.C0 = v33._beltC0;
    v34.C1 = v33._beltC1;
    v34.Parent = v27;
    v33._weld = v34;
    v27.Parent = v33._actor.Character;
    v33:_updateModel(false, v33._lastLoaded);
    return v33;
end;
function u11.ADS(p35, p36, p37) --[[ Line: 140 ]]
    p35._ads = p36;
    p35._actor.AnimationKit = p36 and p35._animationKit .. "Aiming" or p35._animationKit;
    local l__ViewModel__6 = p35._actor.ViewModel;
    if l__ViewModel__6 then
        l__ViewModel__6.ADSFOV = nil;
        local l___actor__7 = p35._actor;
        if p36 then
            local l__CFrame__8 = p35._primary.sight.CFrame;
            if p37 and p35._config.Tune.Zeros then
                p35._adsGoal = p35._config.Tune.Zeros[p37];
            end;
            l___actor__7.ADS = l___actor__7.ADS or l__CFrame__8;
        else
            l___actor__7.ADS = nil;
        end;
    end;
end;
function u11.Reload(u38, p39) --[[ Line: 163 ]]
    -- upvalues: u3 (copy), u6 (copy), u8 (copy)
    local l___actor__9 = u38._actor;
    local l___config__10 = u38._config;
    if l___config__10.Animations.Third then
        local v40 = l___actor__9:LoadAnimation(l___config__10.Animations.Third.Reload);
        v40:Play(0);
        u38._reload_tp = v40;
    end;
    local l___primary__11 = u38._primary;
    local l__ViewModel__12 = l___actor__9.ViewModel;
    if l__ViewModel__12 then
        if l__ViewModel__12.Active then
            l___primary__11 = nil;
        end;
        u38._reload = l__ViewModel__12:LoadAnimation(l___config__10.Animations.First.Reload);
        u38._reload.Priority = u3.AnimationPriority.Action;
        u38._reload:Play(0);
    end;
    if u38._reloadSound then
        u38._reloadSound.Sound:Stop();
        u38._reloadSound = nil;
    end;
    local v41 = u6:CreateSound("Weapon_Interaction", l___primary__11, true, "WeaponAudioRevamp", u8[l___config__10.Tune.Caliber].Tracer, "Handling", "Empty");
    u38._reloadSound = v41;
    v41.Destroy(20);
    u38:_updateModel(l___config__10.Tune.Shells and not u38._fired and true or false, u38._lastLoaded);
    u38._lastLoaded = p39;
    if u38._reloadShell then
        task.cancel(u38._reloadShell);
        u38._reloadShell = nil;
    end;
    u38._reloadShell = task.delay(l___config__10.Tune.ShellDelay or 1, function() --[[ Line: 207 ]]
        -- upvalues: u38 (copy)
        u38._reloadShell = nil;
        u38:_updateModel(true, u38._lastLoaded);
    end);
end;
function u11.Reloaded(p42) --[[ Line: 213 ]]
    p42._fired = false;
    p42:_updateModel(false, p42._lastLoaded);
end;
function u11.Equip(p43) --[[ Line: 218 ]]
    -- upvalues: u3 (copy), u6 (copy), u8 (copy)
    p43._equip:Play(0);
    local l___actor__13 = p43._actor;
    l___actor__13.AnimationKit = p43._animationKit;
    l___actor__13.Firearm = true;
    p43._toHand = true;
    p43._lerp = 0;
    p43._offset = nil;
    p43._toBelt = nil;
    p43._equipped = true;
    local l___config__14 = p43._config;
    local l___primary__15 = p43._primary;
    local l__ViewModel__16 = p43._actor.ViewModel;
    if l__ViewModel__16 then
        if l__ViewModel__16.Active then
            l___primary__15 = nil;
        end;
        local l__First__17 = l___config__14.Animations.First;
        l__ViewModel__16.Weight = l___config__14.Tune.Weight;
        l__ViewModel__16.SprintID = l__First__17.Sprint;
        l__ViewModel__16.WorldMuzzle = p43._tip;
        local _, v44, v45 = l__ViewModel__16:SetModel(p43._heroModel, l__First__17.Idle, l__First__17.Draw);
        if v45 then
            v45.Priority = u3.AnimationPriority.Action3;
        end;
        p43._fpHeroModel = v44;
        p43:_updateModel(false, p43._lastLoaded);
    end;
    local v46 = u6:CreateSound("Weapon_Interaction", l___primary__15, true, "WeaponAudioRevamp", u8[l___config__14.Tune.Caliber].Tracer, "Handling", "Equip");
    p43._reloadSound = v46;
    v46.Destroy(20);
end;
function u11.Unequip(p47) --[[ Line: 257 ]]
    p47._equip:Stop(0);
    local l___actor__18 = p47._actor;
    l___actor__18.AnimationKit = "Unequipped";
    l___actor__18.ADS = nil;
    l___actor__18.Firearm = nil;
    l___actor__18.ADSZoom = nil;
    p47._ads = false;
    p47._toBelt = true;
    p47._lerp = 0;
    p47._offset = nil;
    p47._toHand = nil;
    p47._equipped = false;
    p47._fpHeroModel = nil;
    if p47._reloadSound then
        p47._reloadSound.Sound:Stop();
        p47._reloadSound = nil;
    end;
    if p47._reloadShell then
        task.cancel(p47._reloadShell);
        p47._reloadShell = nil;
    end;
    if p47._reload then
        p47._reload:Stop(0);
        p47._reload = nil;
    end;
    if p47._reload_tp then
        p47._reload_tp:Stop(0);
        p47._reload_tp = nil;
    end;
    local l__ViewModel__19 = p47._actor.ViewModel;
    if l__ViewModel__19 then
        l__ViewModel__19.Weight = nil;
        l__ViewModel__19.SprintID = nil;
        l__ViewModel__19.WorldMuzzle = nil;
        l__ViewModel__19.Reloading = false;
        l__ViewModel__19:SetModel();
    end;
end;
function u11.Discharge(p48, p49, p50) --[[ Line: 305 ]]
    -- upvalues: u3 (copy), u5 (copy)
    local l___config__20 = p48._config;
    local l___actor__21 = p48._actor;
    local l__ViewModel__22 = l___actor__21.ViewModel;
    if l__ViewModel__22 then
        p48._discharge = l__ViewModel__22:LoadAnimation(l___config__20.Animations.First.Discharge);
        p48._discharge.Priority = u3.AnimationPriority.Action;
        p48._discharge:Play(0);
    end;
    local v51;
    if l__ViewModel__22 then
        v51 = l__ViewModel__22.Active;
    else
        v51 = l__ViewModel__22;
    end;
    u5:ProjectileFired(p49, p50, v51 and l__ViewModel__22.WorldModel or l___actor__21.Character, l___actor__21.IsLocalPlayer, v51);
    p48._fired = true;
    p48:_updateModel(false, p48._lastLoaded);
end;
function u11.Update(p52, p53, p54, p55) --[[ Line: 325 ]]
    -- upvalues: u10 (copy), u4 (copy)
    local l___toBelt__23 = p52._toBelt;
    local l___toHand__24 = p52._toHand;
    if l___toHand__24 or l___toBelt__23 then
        local l___weld__25 = p52._weld;
        local v56;
        if p53 == 3 then
            v56 = p54 == 1;
        else
            v56 = false;
        end;
        local v57 = v56 and (p52._lerp or 1) or 1;
        if v57 > 0.5 then
            local v58 = (v57 - 0.5) * 2;
            if l___toBelt__23 then
                local l__zero__26 = Vector2.zero;
                if v56 then
                    local v59, _, v60 = l___weld__25.Part0.CFrame:ToOrientation();
                    p52._sway:Impulse(Vector2.new(v60, (math.max(v59, 0))));
                    p52._sway.Target = Vector2.new(v60 / 2, math.max(v59, 0) / 2);
                    l__zero__26 = p52._sway.Position;
                end;
                l___weld__25.C0 = p52._beltC0 * CFrame.Angles(-l__zero__26.Y, 0, 0) * CFrame.Angles(0, 0, -l__zero__26.X);
                l___weld__25.C1 = p52._beltC1;
                l___weld__25.Part0 = p52._belt;
                v57 = 1;
            elseif l___toHand__24 then
                if not p52._offset then
                    p52._offset = p52._primary.CFrame:ToObjectSpace(p52._hand.CFrame):Inverse();
                end;
                l___weld__25.C0 = p52._offset:Lerp(p52._handC0, v58);
                l___weld__25.C1 = CFrame.new():Lerp(p52._handC1, v58);
                l___weld__25.Part0 = p52._hand;
            end;
        end;
        if p52._lerp > 0.99 then
            p52._lerp = 1;
            if not v56 then
                p52._offset = nil;
                p52._toBelt = nil;
                p52._toHand = nil;
            end;
        else
            p52._lerp = u10.Lerp(v57, 1, u4(p55 * 7.5));
        end;
    end;
    if p54 <= 2 and p52._equipped then
        local l___actor__27 = p52._actor;
        local v61 = l___actor__27.ViewModel and (p52._ads and (l___actor__27.ADS and p52._adsGoal));
        if v61 then
            if v61:FuzzyEq(l___actor__27.ADS) then
                p52._adsGoal = nil;
                return;
            end;
            l___actor__27.ADS = l___actor__27.ADS:Lerp(v61, u4(p55 * 15));
        end;
    end;
end;
function u11.Destroy(p62) --[[ Line: 387 ]]
    if p62._equipped then
        p62._actor.ADS = nil;
        p62._actor.Firearm = nil;
    end;
    p62._heroModel:Destroy();
end;
return u11;