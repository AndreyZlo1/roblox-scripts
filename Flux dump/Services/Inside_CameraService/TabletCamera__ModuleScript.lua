-- Services.CameraService.TabletCamera
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1 = shared.import("require")("NumberTween");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u2 = {};
u2.__index = u2;
function u2.new(_, p3) --[[ Line: 10 ]]
    -- upvalues: u1 (copy), u2 (copy)
    local v4 = u1.new(0, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, 0, false, 0));
    local v5 = setmetatable({
        _cameraCFrame = p3,
        _cameraTween = v4
    }, u2);
    v4:SetGoal(1);
    return v5;
end;
function u2.Update(p6, _, _) --[[ Line: 22 ]]
    -- upvalues: l__CurrentCamera__1 (copy)
    local l___cameraCFrame__2 = p6._cameraCFrame;
    l__CurrentCamera__1.Focus = l___cameraCFrame__2;
    l__CurrentCamera__1.CFrame = l___cameraCFrame__2:ToWorldSpace(CFrame.new(0, 0, 2)):Lerp(l___cameraCFrame__2:ToWorldSpace(CFrame.new(0, 0, 1)), p6._cameraTween:GetValue());
    l__CurrentCamera__1.FieldOfView = l__CurrentCamera__1.ViewportSize.Y < 500 and 40 or 60;
end;
function u2.Shake(_) --[[ Line: 32 ]] end;
function u2.Destroy(_) --[[ Line: 35 ]] end;
return u2;