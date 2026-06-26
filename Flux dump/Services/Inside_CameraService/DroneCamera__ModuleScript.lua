-- Services.CameraService.DroneCamera
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4 = shared.import("require", "network", "Enum", "frc");
local u5 = v1("InputService");
local u6 = v1("SoundService");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u7 = {};
u7.__index = u7;
function u7.new(p8, p9) --[[ Line: 11 ]]
    -- upvalues: u3 (copy), l__CurrentCamera__1 (copy), u7 (copy), u5 (copy), u6 (copy)
    local v10 = RaycastParams.new();
    v10.CollisionGroup = u3.PhysicsGroup.BotCast;
    v10.FilterType = u3.RaycastFilterType.Exclude;
    v10.FilterDescendantsInstances = { p9.Model, l__CurrentCamera__1 };
    v10.IgnoreWater = true;
    local _, v11 = p9.CFrame:ToOrientation();
    local u12 = setmetatable({
        _xA = 0,
        _upDown = 0,
        _velocity = Vector3.new(0, 0, 0),
        _drone = p9,
        _x = v11,
        _y = p9.Y,
        _params = v10
    }, u7);
    u12._controls = u5:Connect({
        DroneUp = function(p13) --[[ Name: DroneUp, Line 30 ]]
            -- upvalues: u12 (copy)
            if p13 then
                u12._upDown = 1;
            else
                if u12._upDown == 1 then
                    u12._upDown = 0;
                end;
            end;
        end,
        DroneDown = function(p14) --[[ Name: DroneDown, Line 37 ]]
            -- upvalues: u12 (copy)
            if p14 then
                u12._upDown = -1;
            else
                if u12._upDown == -1 then
                    u12._upDown = 0;
                end;
            end;
        end
    });
    u6:SetEffectMix("Interior", 1);
    p8.Focused = false;
    p9:SetFocus(true);
    return u12;
end;
function u7.Update(p15, p16, p17) --[[ Line: 53 ]]
    -- upvalues: l__CurrentCamera__1 (copy), u5 (copy), u4 (copy), u2 (copy)
    if p15._broken then
        local v18 = l__CurrentCamera__1;
        v18.CFrame = v18.CFrame * CFrame.Angles(0, 0, p17 * 100);
    else
        local l___drone__2 = p15._drone;
        local l__Config__3 = l___drone__2.Config;
        local l__Position__4 = l___drone__2.CFrame.Position;
        p15._x = p15._x - p16.X;
        p15._y = math.clamp(p15._y - p16.Y, -1.5707963267948966, 0.17453292519943295);
        local v19 = u5:GetInputMovement();
        local v20 = ((CFrame.new(l__Position__4) * CFrame.Angles(0, p15._x, 0)):VectorToWorldSpace((Vector3.new(v19.X, 0, v19.Y))) + Vector3.new(0, p15._upDown, 0)) * (p17 * l__Config__3.Speed);
        local v21 = p15._velocity:Lerp(v20, u4(p17 * 4));
        p15._velocity = v21;
        if workspace:Spherecast(l__Position__4, l___drone__2.Config.Hitbox, v21, p15._params) then
            u2:FireServer("InventoryAction", "Broken");
            p15._broken = true;
        else
            local v22 = CFrame.new(l__Position__4 + v21) * CFrame.Angles(0, p15._x, 0);
            l___drone__2:Sync(v22);
            l___drone__2.Y = p15._y;
            local l___xA__5 = p15._xA;
            local v23 = v22:VectorToObjectSpace(v21).X / p17 / l__Config__3.Speed;
            p15._xA = math.lerp(l___xA__5, v23, u4(p17 * 5));
            l__CurrentCamera__1.CFrame = v22 * CFrame.Angles(p15._y, 0, 0) * CFrame.Angles(0, 0, p15._xA * -0.17453292519943295);
            l__CurrentCamera__1.Focus = l__CurrentCamera__1.CFrame;
        end;
    end;
end;
function u7.Destroy(p24) --[[ Line: 90 ]]
    -- upvalues: u6 (copy)
    u6:SetEffectMix("Interior", 0);
    if p24._controls then
        p24._controls:Disconnect();
        p24._controls = nil;
    end;
    p24._drone:SetFocus(false);
end;
return u7;