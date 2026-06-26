-- Services.CameraService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, _, _ = shared.import("require", "network", "server", "asset");
local u3 = v1("EffectsService");
local u4 = v1("ReplicatorService");
local u5 = v1("GameShellProxyService");
local u6 = v1({
    "DeadCamera",
    "CharacterCamera",
    "TabletCamera",
    "LockPickCamera",
    "SpectateCamera",
    "HQManagerCamera",
    "DroneCamera"
});
local u7 = {};
u7.__index = u7;
function u7.new() --[[ Line: 31 ]]
    -- upvalues: u7 (copy), u2 (copy), u3 (copy)
    local u8 = setmetatable({
        Camera = nil
    }, u7);
    u2:ConnectEvents({
        RegisterCamera = function(p9, ...) --[[ Name: RegisterCamera, Line 38 ]]
            -- upvalues: u8 (copy)
            u8:RegisterCamera(p9, ...);
        end,
        UnregisterCamera = function() --[[ Name: UnregisterCamera, Line 41 ]]
            -- upvalues: u8 (copy), u3 (ref)
            if u8.Camera then
                u8.Camera:Destroy();
            end;
            u8.Camera = nil;
            u3.Camera = nil;
        end,
        ActivateCamera = function(p10, ...) --[[ Name: ActivateCamera, Line 48 ]]
            -- upvalues: u8 (copy)
            if u8.Camera then
                if u8.Camera[p10] then
                    u8.Camera[p10](u8.Camera, ...);
                end;
            end;
        end
    });
    return u8;
end;
function u7.RegisterCamera(p11, p12, ...) --[[ Line: 64 ]]
    -- upvalues: u4 (copy), u6 (copy), u3 (copy)
    if p11.Camera then
        p11.Camera:Destroy();
    end;
    local l__LocalActor__1 = u4.LocalActor;
    local v13 = u6[string.format("%sCamera", p12)].new(l__LocalActor__1, ...);
    p11.Camera = v13;
    u3.Camera = v13;
end;
function u7.Update(p14, p15, p16) --[[ Line: 75 ]]
    -- upvalues: u5 (copy)
    if p14.Camera then
        if u5:IsScrollBarActive() then
            p15 = Vector3.new(p15.X, p15.Y, 0);
        end;
        p14.Camera:Update(p15, p16);
    end;
end;
function u7.Render(p17, p18, p19) --[[ Line: 85 ]]
    if p17.Camera and p17.Camera.Render then
        p17.Camera:Render(p18, p19);
    end;
end;
return u7.new();