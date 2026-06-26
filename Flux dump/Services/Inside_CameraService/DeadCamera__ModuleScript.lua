-- Services.CameraService.DeadCamera
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4 = shared.import("require", "Enum", "server", "Roact");
local u5 = v1("ViewmodelService");
local u6 = v1("GameShellProxyService");
local u7 = v1("HUDInterface");
local u8 = v1("DeadComponent");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u9 = {};
u9.__index = u9;
function u9.new(p10) --[[ Line: 14 ]]
    -- upvalues: l__CurrentCamera__1 (copy), u9 (copy), u3 (copy), u6 (copy), u2 (copy), u4 (copy), u8 (copy), u7 (copy), u5 (copy)
    local v11 = setmetatable({
        _localActor = p10,
        _upperTorso = p10.Character.UpperTorso,
        _fov = l__CurrentCamera__1.FieldOfView
    }, u9);
    if u3.FAST_DEATH then
        local v12, _, v13 = u6:CreateProxy(10, u2.ShellPriority.AlwaysVisible, "DeathCamera");
        v11._destroyUI = v13;
        v11._handle = u4.mount(u4.createElement(u8, {}), v12);
        v11._cframe = l__CurrentCamera__1.CFrame;
    end;
    u7:SetPlayerInfoVisible(false);
    u5:UnregisterViewmodel();
    v11._cameraOffset = CFrame.new(v11._upperTorso.Position):ToObjectSpace(l__CurrentCamera__1.CFrame);
    return v11;
end;
function u9.Update(p14, _, p15) --[[ Line: 35 ]]
    -- upvalues: u3 (copy), l__CurrentCamera__1 (copy)
    p14._fov = math.lerp(p14._fov, u3.IS_PVP and 60 or 70, p15);
    if p14._cframe then
        l__CurrentCamera__1.CFrame = p14._cframe;
    else
        l__CurrentCamera__1.CFrame = CFrame.new(p14._upperTorso.Position):ToWorldSpace(p14._cameraOffset);
    end;
    l__CurrentCamera__1.FieldOfView = p14._fov;
end;
function u9.Shake(_) --[[ Line: 46 ]] end;
function u9.Destroy(p16) --[[ Line: 49 ]]
    -- upvalues: u4 (copy), u7 (copy)
    if p16._handle then
        u4.unmount(p16._handle);
    end;
    if p16._destroyUI then
        p16._destroyUI();
    end;
    u7:SetPlayerInfoVisible(true);
end;
return u9;