-- Services.RGEService.Windows.RGETopdownWindow
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1 = shared.import("require")("InputService");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local l__Terrain__2 = workspace.Terrain;
local u2 = {
    Name = "Topdown Camera",
    UI = false,
    Closeable = true
};
u2.__index = u2;
function u2.new() --[[ Line: 15 ]]
    -- upvalues: l__CurrentCamera__1 (copy), l__Terrain__2 (copy), u2 (copy)
    local l__CFrame__3 = l__CurrentCamera__1.CFrame;
    local v3 = RaycastParams.new();
    v3.FilterDescendantsInstances = { l__Terrain__2 };
    v3.FilterType = Enum.RaycastFilterType.Whitelist;
    v3.IgnoreWater = false;
    local v4 = {
        Speed = 1,
        Zoom = 10,
        _look = 0,
        _zoom = 100,
        _fast = false,
        _params = v3,
        _cameraPos = Vector2.new(l__CFrame__3.X, l__CFrame__3.Z),
        _cameraCFrame = CFrame.new()
    };
    return setmetatable(v4, u2);
end;
function u2.Enable(u5) --[[ Line: 36 ]]
    -- upvalues: u1 (copy)
    u5._controls = u1:Connect({
        Slow = function(p6) --[[ Name: Slow, Line 38 ]]
            -- upvalues: u5 (copy)
            u5._fast = p6;
        end
    });
end;
function u2.Jump(p7, p8) --[[ Line: 44 ]]
    p7._cameraPos = Vector2.new(p8.X, p8.Z);
end;
function u2.Disable(p9) --[[ Line: 48 ]]
    p9._controls:Disconnect();
end;
function u2.Update(p10, p11, p12, p13) --[[ Line: 52 ]]
    -- upvalues: l__CurrentCamera__1 (copy)
    p10._look = p10._look - p12.X * math.min(p13, 1) * 200;
    p10._zoom = math.clamp(p10._zoom - p12.Z * p10.Zoom, 10, 200);
    local l___zoom__4 = p10._zoom;
    local l___look__5 = p10._look;
    local v14 = p10.Speed * (p10._fast and 3 or 1);
    local v15 = l___zoom__4 / 50;
    local l___cameraPos__6 = p10._cameraPos;
    local v16 = math.sin(l___look__5);
    local v17 = math.cos(l___look__5);
    local v18 = Vector3.new(v16, 0, v17) * l___zoom__4;
    local v19 = CFrame.new(Vector3.new(), v18):PointToWorldSpace(Vector3.new(-p11.X, 0, -p11.Y) * v15 * v14);
    local v20 = l___cameraPos__6 + Vector2.new(v19.X, v19.Z);
    local v21 = workspace:Raycast(Vector3.new(v20.X, 1000, v20.Y), Vector3.new(0, -1000, 0), p10._params);
    local v22 = Vector3.new(v20.X, v21 and v21.Position.Y or 0, v20.Y);
    local v23 = CFrame.new(v22 + v18 + Vector3.new(0, l___zoom__4 / 1.5, 0), v22);
    p10._cameraPos = v20;
    p10._cameraCFrame = v23;
    l__CurrentCamera__1.Focus = v23;
    l__CurrentCamera__1.FieldOfView = 70;
    return v23;
end;
function u2.IsA(_, p24) --[[ Line: 76 ]]
    return p24 == "TopdownCamera";
end;
function u2.Destroy(_) --[[ Line: 80 ]] end;
return u2;