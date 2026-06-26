-- Services.ViewmodelService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _, u2, _, _ = shared.import("require", "asset", "Enum", "React", "ReactRoblox");
local u3 = v1("GameShellProxyService");
local u4 = v1("ViewmodelClass");
local u5 = {};
u5.__index = u5;
function u5.new() --[[ Line: 10 ]]
    -- upvalues: u3 (copy), u2 (copy), u5 (copy)
    local v6 = {
        _ui = u3:CreateProxy(0, u2.ShellPriority.AlwaysVisible, "NVGInterface")
    };
    return setmetatable(v6, u5);
end;
function u5.Update(p7, p8) --[[ Line: 20 ]]
    if p7.Viewmodel then
        p7.Viewmodel:Update(p8);
    end;
end;
function u5.Stepped(p9, p10) --[[ Line: 26 ]]
    if p9.Viewmodel then
        p9.Viewmodel:Stepped(p10);
    end;
end;
function u5.UnregisterViewmodel(p11) --[[ Line: 32 ]]
    if p11.Viewmodel then
        p11.Viewmodel:Destroy();
    end;
    p11.Viewmodel = nil;
end;
function u5.RegisterViewmodel(p12, p13) --[[ Line: 39 ]]
    -- upvalues: u4 (copy)
    p12:UnregisterViewmodel();
    p12.Viewmodel = u4.new(p13, p12._ui);
end;
return u5.new();