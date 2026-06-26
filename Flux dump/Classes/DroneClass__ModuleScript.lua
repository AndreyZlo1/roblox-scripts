-- Classes.DroneClass
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4 = shared.import("require", "asset", "Enum", "frc");
local u5 = v1("SoundService");
local u6 = v1("Drones");
local u7 = {};
u7.__index = u7;
function u7.new(p8, p9) --[[ Line: 10 ]]
    -- upvalues: u6 (copy), u7 (copy), u2 (copy), u5 (copy)
    local v10 = {
        Y = 0,
        CFrame = p9,
        Config = u6[p8],
        _build = p8,
        _blades = {},
        _velocity = CFrame.new(),
        _cframe = p9
    };
    local v11 = setmetatable(v10, u7);
    local v12 = u2:Get("Shared", "Models", "Gear", p8 .. "Drone").Asset:Clone();
    local l__Body__1 = v12:WaitForChild("Body");
    l__Body__1.Anchored = true;
    local v13 = Instance.new("Attachment");
    v13.Parent = l__Body__1;
    for _, v14 in v12:GetDescendants() do
        if v14:IsA("Motor6D") then
            if v14.Name == "Blade" then
                v11._blades[#v11._blades + 1] = v14;
            end;
        elseif v14:IsA("BasePart") then
            v14.CanCollide = false;
            v14.CanTouch = false;
            v14.CanQuery = false;
        end;
    end;
    l__Body__1.CFrame = p9;
    v12.Parent = workspace;
    u5:CreateSound("Weapon_Interaction", l__Body__1, true, "GearSounds", p8, "Start").Destroy(4);
    v11._flySound = u5:CreateSound("Weapon_Interaction", l__Body__1, true, "GearSounds", p8, "Idle");
    v11.Model = v12;
    v11._primary = l__Body__1;
    v11._attachment = v13;
    return v11;
end;
function u7.Sync(p15, p16) --[[ Line: 51 ]]
    p15.CFrame = p16;
end;
function u7.Broken(p17) --[[ Line: 55 ]]
    if p17._broken then
    else
        p17._broken = true;
        if p17._flySound then
            p17._flySound.Destroy();
            p17._flySound = nil;
        end;
        for _, v18 in p17.Model:GetDescendants() do
            if v18:IsA("BasePart") then
                v18.Anchored = false;
                v18.CanCollide = true;
                v18.CanTouch = true;
                v18.CanQuery = true;
            end;
        end;
    end;
end;
function u7.SetFocus(p19, p20) --[[ Line: 76 ]]
    -- upvalues: u5 (copy)
    if p19._flySound then
        p19._flySound.Destroy();
        p19._flySound = nil;
    end;
    if p19.Destroyed then
    else
        p19._focused = p20;
        local l__Model__2 = p19.Model;
        local v21;
        if p20 then
            v21 = nil;
        else
            v21 = workspace or nil;
        end;
        l__Model__2.Parent = v21;
        if p20 then
            p19._flySound = u5:CreateSound("Weapon_Interaction", nil, true, "GearSounds", p19._build, "Idle");
        else
            p19._flySound = u5:CreateSound("Weapon_Interaction", p19._primary, true, "GearSounds", p19._build, "Idle");
        end;
    end;
end;
function u7.ShowRetrieve(p22, p23) --[[ Line: 94 ]]
    -- upvalues: u3 (copy)
    if p23 then
        if p22._prompt then
        else
            local v24 = Instance.new("ProximityPrompt");
            v24.Name = "Drone";
            v24.ActionText = "Retrieve Drone";
            v24.ClickablePrompt = false;
            v24.Style = u3.ProximityPromptStyle.Custom;
            v24.Exclusivity = u3.ProximityPromptExclusivity.OneGlobally;
            v24.MaxActivationDistance = 6;
            v24.RequiresLineOfSight = false;
            v24.GamepadKeyCode = u3.KeyCode.World0;
            v24.KeyboardKeyCode = u3.KeyCode.World0;
            v24.Parent = p22._attachment;
            p22._prompt = v24;
        end;
    else
        if p22._prompt then
            p22._prompt:Destroy();
            p22._prompt = nil;
        end;
    end;
end;
function u7.Update(p25, p26) --[[ Line: 121 ]]
    -- upvalues: u4 (copy)
    if p25._broken then
    else
        local l___cframe__3 = p25._cframe;
        p25._cframe = l___cframe__3:Lerp(p25.CFrame, u4(p26 * 10));
        local v27 = l___cframe__3:ToObjectSpace(p25._cframe);
        local v28 = p25._velocity:Lerp(v27, u4(p26 * 4));
        p25._velocity = v28;
        if p25._flySound then
            p25._flySound.Sound.PlaybackSpeed = 1 + v28.Position.Magnitude / p26 / p25.Config.Speed / 2;
        end;
        local l__new__4 = CFrame.new;
        local v29 = tick();
        local v30 = math.cos(v29) / 10;
        local v31 = tick();
        local v32 = math.sin(v31) / 10;
        local v33 = -tick();
        local v34 = l__new__4(v30, v32, math.cos(v33) / 10);
        p25._primary.CFrame = p25._cframe * p25.Config.Offset * v34 * CFrame.Angles(math.clamp(-(v28.Z / p26), -30, 30) / 30 * 0.5235987755982988, 0, math.clamp(v28.X / p26, -30, 30) / 30 * 0.5235987755982988);
        for _, v35 in p25._blades do
            v35.C1 = v35.C1 * CFrame.Angles(0, p26 * 150, 0);
        end;
    end;
end;
function u7.Destroy(p36) --[[ Line: 145 ]]
    if p36.Destroyed then
    else
        p36.Destroyed = true;
        if p36._flySound then
            p36._flySound.Destroy();
            p36._flySound = nil;
        end;
        p36.Model:Destroy();
    end;
end;
return u7;