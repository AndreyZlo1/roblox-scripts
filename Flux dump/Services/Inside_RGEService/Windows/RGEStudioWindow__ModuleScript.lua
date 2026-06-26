-- Services.RGEService.Windows.RGEStudioWindow
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "server");
local l__Players__1 = game:GetService("Players");
local l__CollectionService__2 = game:GetService("CollectionService");
local u3 = v1("InputService");
local l__PlayerGui__3 = l__Players__1.LocalPlayer:WaitForChild("PlayerGui");
local l__CurrentCamera__4 = workspace.CurrentCamera;
local u4 = {
    Name = "Studio Camera",
    UI = false,
    Closeable = true
};
u4.__index = u4;
function u4.new() --[[ Line: 20 ]]
    -- upvalues: l__CurrentCamera__4 (copy), u4 (copy)
    local l__CFrame__5 = l__CurrentCamera__4.CFrame;
    local v5 = {
        Speed = 1.5,
        Zoom = 4,
        _vertical = 0,
        _slow = false,
        _triggers = {},
        _rotation = Vector2.new(l__CFrame__5:ToEulerAnglesYXZ()),
        _position = l__CFrame__5.Position
    };
    return setmetatable(v5, u4);
end;
function u4.Enable(u6) --[[ Line: 36 ]]
    -- upvalues: u2 (copy), l__PlayerGui__3 (copy), l__CollectionService__2 (copy), u3 (copy)
    local function u20(u7) --[[ Line: 37 ]]
        -- upvalues: u2 (ref), u20 (copy), l__PlayerGui__3 (ref), u6 (copy)
        local v8 = u7:GetAttribute("World");
        if not v8 then
            return;
        end;
        local v9 = Color3.new(1, 1, 1);
        local v10 = u2["TRIGGER_GROUP_" .. v8];
        local v11 = nil;
        local u12 = nil;
        local u13 = nil;
        for v14 in u7:GetAttributes() do
            if v14:sub(1, 8) == "Trigger_" then
                for _, v15 in v10 do
                    if v15[1] == v14:sub(9) then
                        v11 = v15;
                        break;
                    end;
                end;
            end;
        end;
        local v16;
        if v11 then
            v9 = Color3.new(v11[2], v11[3], v11[4]);
            local v17 = u7:GetAttributeChangedSignal("Trigger_" .. v11[1]):Connect(function() --[[ Line: 61 ]]
                -- upvalues: u12 (ref), u13 (ref), u20 (ref), u7 (copy)
                u12:Disconnect();
                u13:Destroy();
                u20(u7);
            end);
            v16 = v17;
        else
            local v18 = u7.AttributeChanged:Connect(function() --[[ Line: 67 ]]
                -- upvalues: u12 (ref), u13 (ref), u20 (ref), u7 (copy)
                u12:Disconnect();
                u13:Destroy();
                u20(u7);
            end);
            v16 = v18;
        end;
        local v19;
        if u7.Shape == Enum.PartType.Ball then
            v19 = Instance.new("SelectionSphere");
            v19.Color3 = v9;
            v19.SurfaceColor3 = v9;
            v19.SurfaceTransparency = 0.5;
            v19.Transparency = 1;
        else
            v19 = Instance.new("SelectionBox");
            v19.Color3 = v9:Lerp(Color3.new(1, 1, 1), 0.5);
            v19.LineThickness = 0.01;
            v19.SurfaceColor3 = v9;
            v19.SurfaceTransparency = 0.5;
        end;
        u7.CanQuery = true;
        v19.Adornee = u7;
        v19.Parent = l__PlayerGui__3;
        u6._triggers[u7] = { v19, v16 };
    end;
    u6._triggerRemoved = l__CollectionService__2:GetInstanceRemovedSignal("Trigger"):Connect(function(p21) --[[ Line: 94 ]]
        -- upvalues: u6 (copy)
        local v22 = u6._triggers[p21];
        if v22 then
            p21.CanQuery = false;
            v22[1]:Destroy();
            v22[2]:Disconnect();
            u6._triggers[p21] = nil;
        end;
    end);
    u6._triggerAdded = l__CollectionService__2:GetInstanceAddedSignal("Trigger"):Connect(function(p23) --[[ Line: 103 ]]
        -- upvalues: u20 (copy)
        u20(p23);
    end);
    for _, v24 in l__CollectionService__2:GetTagged("Trigger") do
        u20(v24);
    end;
    u6._serverChanged = u2.Changed:Connect(function() --[[ Line: 110 ]]
        -- upvalues: u6 (copy), l__CollectionService__2 (ref), u20 (copy)
        for v25, v26 in u6._triggers do
            v25.CanQuery = false;
            v26[1]:Destroy();
            v26[2]:Disconnect();
        end;
        for _, v27 in l__CollectionService__2:GetTagged("Trigger") do
            u20(v27);
        end;
    end);
    u6._controls = u3:Connect({
        Up = function(p28) --[[ Name: Up, Line 123 ]]
            -- upvalues: u6 (copy)
            if p28 then
                u6._vertical = 1;
            else
                if u6._vertical == 1 then
                    u6._vertical = 0;
                end;
            end;
        end,
        Down = function(p29) --[[ Name: Down, Line 130 ]]
            -- upvalues: u6 (copy)
            if p29 then
                u6._vertical = -1;
            else
                if u6._vertical == -1 then
                    u6._vertical = 0;
                end;
            end;
        end,
        Slow = function(p30) --[[ Name: Slow, Line 137 ]]
            -- upvalues: u6 (copy)
            u6._slow = p30;
        end
    });
end;
function u4.Jump(p31, p32) --[[ Line: 143 ]]
    p31._position = p32.Position;
end;
function u4.Disable(p33) --[[ Line: 147 ]]
    for v34, v35 in p33._triggers do
        v34.CanQuery = false;
        v35[1]:Destroy();
        v35[2]:Disconnect();
    end;
    p33._triggers = {};
    p33._serverChanged:Disconnect();
    p33._triggerRemoved:Disconnect();
    p33._triggerAdded:Disconnect();
    p33._controls:Disconnect();
end;
function u4.Update(p36, p37, p38, _) --[[ Line: 161 ]]
    -- upvalues: l__CurrentCamera__4 (copy)
    p36._rotation = Vector2.new(math.clamp(p36._rotation.X + -p38.Y, -1.5707963267948966, 1.5707963267948966), p36._rotation.Y - p38.X);
    local v39 = CFrame.Angles(0, p36._rotation.Y, 0) * CFrame.Angles(p36._rotation.X, 0, 0);
    local v40 = CFrame.new(p36._position) * v39;
    p36._position = p36._position + v40:VectorToWorldSpace(Vector3.new(p37.X, p36._vertical, p37.Y) * (p36.Speed / (p36._slow and 7 or 1)));
    p36._position = p36._position + v40.LookVector * p38.Z * p36.Zoom;
    l__CurrentCamera__4.Focus = CFrame.new(p36._position);
    l__CurrentCamera__4.FieldOfView = 70;
    return CFrame.new(p36._position) * v39;
end;
function u4.IsA(_, p41) --[[ Line: 174 ]]
    return p41 == "StudioCamera";
end;
function u4.Destroy(_) --[[ Line: 178 ]] end;
return u4;