-- Services.CameraService.LockPickCamera
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1 = shared.import("require")("NumberTween");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u2 = {};
u2.__index = u2;
function u2.new(p3, p4) --[[ Line: 10 ]]
    -- upvalues: u1 (copy), u2 (copy)
    local v5 = u1.new(0, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0));
    local v6 = setmetatable({
        _cameraCFrame = p4,
        _cameraTween = v5,
        _localActor = p3
    }, u2);
    v5:SetGoal(1);
    return v6;
end;
function u2.Update(p7, _, _) --[[ Line: 23 ]]
    -- upvalues: l__CurrentCamera__1 (copy)
    local l___localActor__2 = p7._localActor;
    local v8 = p7._cameraCFrame:ToWorldSpace(CFrame.new(0.2, 2, 0):Lerp(CFrame.new(0.2, 2, -1), p7._cameraTween:GetValue()));
    l__CurrentCamera__1.Focus = v8;
    l__CurrentCamera__1.CFrame = v8;
    local _, v9, v10 = v8:ToOrientation();
    l___localActor__2.CameraX = v9;
    l___localActor__2.CameraY = v10;
end;
function u2.Shake(_) --[[ Line: 34 ]] end;
function u2.Destroy(_) --[[ Line: 37 ]] end;
return u2;