-- Services.CameraService.CharacterCamera.CameraShakeInstance
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local l__new__1 = Vector3.new;
local l__noise__2 = math.noise;
local u1 = {};
u1.__index = u1;
u1.CameraShakeState = {
    FadingIn = 0,
    FadingOut = 1,
    Sustained = 2,
    Inactive = 3
};
function u1.new(p2, p3, p4, p5) --[[ Line: 14 ]]
    -- upvalues: l__new__1 (copy), u1 (copy)
    local v6 = p4 == nil and 0 or p4;
    local v7 = p5 == nil and 0 or p5;
    local v8 = {
        DeleteOnInactive = true,
        roughMod = 1,
        magnMod = 1,
        _camShakeInstance = true,
        Magnitude = p2,
        Roughness = p3,
        PositionInfluence = l__new__1(),
        RotationInfluence = l__new__1(),
        fadeOutDuration = v7,
        fadeInDuration = v6,
        sustain = v6 > 0,
        currentFadeTime = v6 > 0 and 0 or 1,
        tick = Random.new():NextNumber(-100, 100)
    };
    return setmetatable(v8, u1);
end;
function u1.UpdateShake(p9, p10) --[[ Line: 39 ]]
    -- upvalues: l__noise__2 (copy), l__new__1 (copy)
    local l__tick__3 = p9.tick;
    local l__currentFadeTime__4 = p9.currentFadeTime;
    local v11 = l__new__1(l__noise__2(l__tick__3, 0) * 0.5, l__noise__2(0, l__tick__3) * 0.5, l__noise__2(l__tick__3, l__tick__3) * 0.5);
    if p9.fadeInDuration > 0 and p9.sustain then
        if l__currentFadeTime__4 < 1 then
            l__currentFadeTime__4 = l__currentFadeTime__4 + p10 / p9.fadeInDuration;
        elseif p9.fadeOutDuration > 0 then
            p9.sustain = false;
        end;
    end;
    if not p9.sustain then
        l__currentFadeTime__4 = l__currentFadeTime__4 - p10 / p9.fadeOutDuration;
    end;
    if p9.sustain then
        p9.tick = l__tick__3 + p10 * p9.Roughness * p9.roughMod;
    else
        p9.tick = l__tick__3 + p10 * p9.Roughness * p9.roughMod * l__currentFadeTime__4;
    end;
    p9.currentFadeTime = l__currentFadeTime__4;
    return v11 * p9.Magnitude * p9.magnMod * l__currentFadeTime__4;
end;
function u1.StartFadeOut(p12, p13) --[[ Line: 71 ]]
    if p13 == 0 then
        p12.currentFadeTime = 0;
    end;
    p12.fadeOutDuration = p13;
    p12.fadeInDuration = 0;
    p12.sustain = false;
end;
function u1.StartFadeIn(p14, p15) --[[ Line: 80 ]]
    if p15 == 0 then
        p14.currentFadeTime = 1;
    end;
    p14.fadeInDuration = p15 or p14.fadeInDuration;
    p14.fadeOutDuration = 0;
    p14.sustain = true;
end;
function u1.GetScaleRoughness(p16) --[[ Line: 89 ]]
    return p16.roughMod;
end;
function u1.SetScaleRoughness(p17, p18) --[[ Line: 93 ]]
    p17.roughMod = p18;
end;
function u1.GetScaleMagnitude(p19) --[[ Line: 97 ]]
    return p19.magnMod;
end;
function u1.SetScaleMagnitude(p20, p21) --[[ Line: 101 ]]
    p20.magnMod = p21;
end;
function u1.GetNormalizedFadeTime(p22) --[[ Line: 105 ]]
    return p22.currentFadeTime;
end;
function u1.IsShaking(p23) --[[ Line: 109 ]]
    return p23.currentFadeTime > 0 and true or p23.sustain;
end;
function u1.IsFadingOut(p24) --[[ Line: 113 ]]
    local v25 = not p24.sustain;
    if v25 then
        v25 = p24.currentFadeTime > 0;
    end;
    return v25;
end;
function u1.IsFadingIn(p26) --[[ Line: 117 ]]
    local v27;
    if p26.currentFadeTime < 1 then
        v27 = p26.sustain;
        if v27 then
            v27 = p26.fadeInDuration > 0;
        end;
    else
        v27 = false;
    end;
    return v27;
end;
function u1.GetState(p28) --[[ Line: 121 ]]
    -- upvalues: u1 (copy)
    if p28:IsFadingIn() then
        return u1.CameraShakeState.FadingIn;
    elseif p28:IsFadingOut() then
        return u1.CameraShakeState.FadingOut;
    elseif p28:IsShaking() then
        return u1.CameraShakeState.Sustained;
    else
        return u1.CameraShakeState.Inactive;
    end;
end;
return u1;