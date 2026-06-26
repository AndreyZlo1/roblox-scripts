-- Services.RGEService.Windows.RGECinematicWindow
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1 = shared.import("require");
local u2 = v1("InputService");
local u3 = v1("PostProcessingService");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u4 = Vector2.new(0.75, 1) * 8;
local u5 = {
    Name = "Cinematic Camera",
    UI = false,
    Closeable = true
};
u5.__index = u5;
local u6 = {};
u6.__index = u6;
function u6.new(p7, p8) --[[ Line: 28 ]]
    -- upvalues: u6 (copy)
    local v9 = setmetatable({}, u6);
    v9.f = p7;
    v9.p = p8;
    v9.v = p8 * 0;
    return v9;
end;
function u6.Update(p10, p11, p12) --[[ Line: 36 ]]
    local v13 = p10.f * 2 * 3.141592653589793;
    local l__p__2 = p10.p;
    local l__v__3 = p10.v;
    local v14 = p12 - l__p__2;
    local v15 = math.exp(-v13 * p11);
    local v16 = p12 + (l__v__3 * p11 - v14 * (v13 * p11 + 1)) * v15;
    local v17 = (v13 * p11 * (v14 * v13 - l__v__3) + l__v__3) * v15;
    p10.p = v16;
    p10.v = v17;
    return v16;
end;
function u6.Reset(p18, p19) --[[ Line: 53 ]]
    p18.p = p19;
    p18.v = p19 * 0;
end;
function u5.new() --[[ Line: 59 ]]
    -- upvalues: l__CurrentCamera__1 (copy), u6 (copy), u5 (copy), u3 (copy)
    local l__CFrame__4 = l__CurrentCamera__1.CFrame;
    local v20 = RaycastParams.new();
    v20.FilterDescendantsInstances = {};
    v20.FilterType = Enum.RaycastFilterType.Blacklist;
    v20.IgnoreWater = false;
    local v21 = {
        VelSpeed = 1,
        PanSpeed = 5,
        FovSpeed = 1.2,
        _vertical = 0,
        _slow = false,
        _cameraOrigin = l__CFrame__4,
        _cameraOriginFOV = l__CurrentCamera__1.FieldOfView,
        VelSpring = u6.new(1.5, (Vector3.new())),
        PanSpring = u6.new(1, Vector2.new()),
        FovSpring = u6.new(4, 0),
        _cameraPos = l__CFrame__4.Position,
        _cameraRot = Vector2.new(l__CFrame__4:toEulerAnglesYXZ()),
        _cameraFov = l__CurrentCamera__1.FieldOfView,
        _cameraCFrame = CFrame.new(),
        _params = v20
    };
    local v22 = setmetatable(v21, u5);
    v22.DOFEffect = u3:AddDepthOfField({
        Enabled = false
    }, 5);
    v22.CCEffect = u3:AddColorCorrection({
        Enabled = false
    }, 0);
    return v22;
end;
function u5.SetOrigin(p23) --[[ Line: 98 ]]
    -- upvalues: l__CurrentCamera__1 (copy)
    p23._cameraOrigin = l__CurrentCamera__1.CFrame;
    p23._cameraOriginFOV = l__CurrentCamera__1.FieldOfView;
end;
function u5.GoOrigin(p24) --[[ Line: 103 ]]
    local l___cameraOrigin__5 = p24._cameraOrigin;
    p24._cameraPos = l___cameraOrigin__5.Position;
    p24._cameraRot = Vector2.new(l___cameraOrigin__5:toEulerAnglesYXZ());
    p24._cameraFov = p24._cameraOriginFOV;
end;
function u5.Jump(p25, p26) --[[ Line: 110 ]]
    if not p25._attach then
        p25._cameraPos = p26.Position;
    end;
end;
function u5.Lock(p27) --[[ Line: 117 ]]
    if p27._lock then
        p27._lock = nil;
    else
        local l___cameraCFrame__6 = p27._cameraCFrame;
        local v28 = workspace:Raycast(l___cameraCFrame__6.Position, l___cameraCFrame__6.LookVector * 1000, p27._params);
        local v29 = v28 and v28.Instance;
        if v29 then
            p27._lock = v29;
            p27._loffset = v29.CFrame:PointToObjectSpace(v28.Position);
        end;
    end;
end;
function u5.Attach(p30) --[[ Line: 134 ]]
    local l___cameraCFrame__7 = p30._cameraCFrame;
    if p30._attach then
        local v31, v32 = l___cameraCFrame__7:ToOrientation();
        p30._cameraRot = Vector2.new(v31, v32);
        p30._attach = nil;
    else
        local v33 = workspace:Raycast(l___cameraCFrame__7.Position, l___cameraCFrame__7.LookVector * 1000, p30._params);
        local v34 = v33 and v33.Instance;
        if v34 then
            local v35 = v34.CFrame:ToObjectSpace(l___cameraCFrame__7);
            local v36, v37 = v35:ToOrientation();
            p30._attach = v34;
            p30._aoffset = v35.Position;
            p30._cameraRot = Vector2.new(v36, v37);
        end;
    end;
end;
function u5.Enable(u38) --[[ Line: 156 ]]
    -- upvalues: u2 (copy)
    u38.VelSpring:Reset((Vector3.new()));
    u38.PanSpring:Reset(Vector2.new());
    u38.FovSpring:Reset(0);
    u38._controls = u2:Connect({
        Up = function(p39) --[[ Name: Up, Line 162 ]]
            -- upvalues: u38 (copy)
            if p39 then
                u38._vertical = 1;
            else
                if u38._vertical == 1 then
                    u38._vertical = 0;
                end;
            end;
        end,
        Down = function(p40) --[[ Name: Down, Line 169 ]]
            -- upvalues: u38 (copy)
            if p40 then
                u38._vertical = -1;
            else
                if u38._vertical == -1 then
                    u38._vertical = 0;
                end;
            end;
        end,
        Slow = function(p41) --[[ Name: Slow, Line 176 ]]
            -- upvalues: u38 (copy)
            u38._slow = p41;
        end
    });
    u38.DOFEffect.Enabled = true;
    u38.CCEffect.Enabled = true;
end;
function u5.Disable(p42) --[[ Line: 185 ]]
    p42.DOFEffect.Enabled = false;
    p42.CCEffect.Enabled = false;
    p42._controls:Disconnect();
end;
function u5.Update(p43, p44, p45, p46) --[[ Line: 191 ]]
    -- upvalues: u4 (copy), l__CurrentCamera__1 (copy)
    local v47 = p43.VelSpring:Update(p46, Vector3.new(p44.X, p43._vertical, p44.Y) * (p43.VelSpeed * (p43._slow and 0.2 or 1)));
    local v48 = p43.PanSpring:Update(p46, Vector2.new(-p45.Y, -p45.X) * p43.PanSpeed);
    local v49 = p43.FovSpring:Update(p46, -p45.Z * p43.FovSpeed);
    local v50 = math.rad(p43._cameraFov / 2);
    local v51 = 0.7002075382097097 / math.tan(v50);
    local v52 = math.sqrt(v51);
    p43._cameraFov = math.clamp(p43._cameraFov + v49 * 300 * (p46 / v52), 1, 120);
    p43._cameraRot = p43._cameraRot + v48 * u4 * (p46 / v52);
    p43._cameraRot = Vector2.new(math.clamp(p43._cameraRot.X, -1.5707963267948966, 1.5707963267948966), p43._cameraRot.Y % 6.283185307179586);
    local l___attach__8 = p43._attach;
    local v53;
    if l___attach__8 and l___attach__8:IsDescendantOf(workspace) then
        v53 = (l___attach__8.CFrame - l___attach__8.Position + l___attach__8.CFrame:PointToWorldSpace(p43._aoffset)) * CFrame.fromOrientation(p43._cameraRot.X, p43._cameraRot.Y, 0);
    else
        v53 = CFrame.new(p43._cameraPos) * CFrame.fromOrientation(p43._cameraRot.X, p43._cameraRot.Y, 0) * CFrame.new(v47 * Vector3.new(64, 64, 64) * p46);
        p43._attach = nil;
    end;
    local l___lock__9 = p43._lock;
    if l___lock__9 then
        if l___lock__9:IsDescendantOf(workspace) then
            v53 = CFrame.new(v53.Position, l___lock__9.CFrame:PointToWorldSpace(p43._loffset));
            local v54, v55 = v53:ToOrientation();
            p43._cameraRot = Vector2.new(v54, v55);
        else
            p43._lock = nil;
        end;
    end;
    p43._cameraPos = v53.Position;
    p43._cameraCFrame = v53;
    l__CurrentCamera__1.Focus = v53;
    l__CurrentCamera__1.FieldOfView = p43._cameraFov;
    return v53;
end;
function u5.IsA(_, p56) --[[ Line: 231 ]]
    return p56 == "CinematicCamera";
end;
function u5.Destroy(p57) --[[ Line: 235 ]]
    p57.DOFEffect.Destroy();
    p57.CCEffect.Destroy();
end;
return u5;