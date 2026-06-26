-- Services.RGEService.Windows.RGELocalWindow
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local l__LocalPlayer__1 = game:GetService("Players").LocalPlayer;
local l__CurrentCamera__2 = workspace.CurrentCamera;
local u1 = {
    UI = true,
    Closeable = false,
    Name = l__LocalPlayer__1.Name .. " (Default View)"
};
u1.__index = u1;
function u1.new() --[[ Line: 13 ]]
    -- upvalues: u1 (copy)
    return setmetatable({}, u1);
end;
function u1.Jump(_) --[[ Line: 17 ]] end;
function u1.Enable(_) --[[ Line: 20 ]]
    -- upvalues: l__CurrentCamera__2 (copy)
    l__CurrentCamera__2.FieldOfView = 70;
end;
function u1.Disable(_) --[[ Line: 24 ]] end;
function u1.Update(_, _, _, _) --[[ Line: 27 ]]
    -- upvalues: l__CurrentCamera__2 (copy)
    return l__CurrentCamera__2.CFrame;
end;
function u1.IsA(_, p2) --[[ Line: 31 ]]
    return p2 == "LocalCamera";
end;
function u1.Destroy(_) --[[ Line: 35 ]] end;
return u1;