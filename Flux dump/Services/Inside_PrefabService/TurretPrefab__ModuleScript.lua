-- Services.PrefabService.TurretPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _, _ = shared.import("require", "asset", "Enum");
local u2 = v1("BulletService");
local u3 = v1("ChainClass");
local u4 = {};
u4.__index = u4;
function u4.new(p5) --[[ Line: 10 ]]
    -- upvalues: u4 (copy), u3 (copy)
    local l__Lower__1 = p5:WaitForChild("Lower");
    local l__Upper__2 = p5:WaitForChild("Upper");
    local l__Main__3 = l__Lower__1:WaitForChild("Main");
    local l__Main__4 = l__Upper__2:WaitForChild("Main");
    local l__Main__5 = p5:WaitForChild("Base"):WaitForChild("Main");
    local v6 = p5:GetAttribute("Type");
    local v7 = {
        Model = p5,
        Sight = l__Main__4:WaitForChild("Sight"),
        Muzzle = l__Main__4:WaitForChild("tip"),
        Pivot = l__Main__5,
        Facing = Vector2.new(),
        Current = Vector2.new()
    };
    local v8 = setmetatable(v7, u4);
    local l__WorldCFrame__6 = l__Main__3:WaitForChild("Pivot").WorldCFrame;
    local v9 = l__WorldCFrame__6:ToObjectSpace(l__Main__5.CFrame):Inverse();
    v8.LowerC0 = v9;
    for _, v10 in l__Lower__1:GetChildren() do
        local v11 = Instance.new("Weld");
        if v10 == l__Main__3 then
            v11.Part0 = l__Main__5;
            v11.Part1 = v10;
            v11.C0 = v9;
            v11.C1 = v10.CFrame:ToObjectSpace(l__WorldCFrame__6);
            v8.Lower = v11;
        else
            v11.Part0 = l__Main__3;
            v11.Part1 = v10;
            v11.C0 = v10.CFrame:ToObjectSpace(l__Main__3.CFrame):Inverse();
        end;
        v11.Parent = v10;
        v10.Anchored = false;
        v10.Massless = true;
        v10.CanCollide = false;
        v10.CanTouch = false;
        v10.CanQuery = false;
        v10.AudioCanCollide = false;
    end;
    local l__WorldCFrame__7 = l__Main__4:WaitForChild("Pivot").WorldCFrame;
    local v12 = l__WorldCFrame__7:ToObjectSpace(l__Main__3.CFrame):Inverse();
    v8.UpperC0 = v12;
    local v13 = Instance.new("Weld");
    v13.Part0 = l__Main__3;
    v13.Part1 = l__Main__4;
    v13.C0 = v12;
    v13.C1 = l__Main__4.CFrame:ToObjectSpace(l__WorldCFrame__7);
    v13.Parent = l__Main__4;
    v8.Upper = v13;
    l__Main__4.Anchored = false;
    l__Main__4.Massless = true;
    l__Main__4.CanCollide = false;
    l__Main__4.CanTouch = false;
    l__Main__4.CanQuery = false;
    l__Main__4.AudioCanCollide = false;
    for _, v14 in l__Upper__2:GetChildren() do
        if v14 ~= l__Main__4 then
            local v15 = Instance.new("Motor6D");
            v15.Part0 = l__Main__4;
            v15.Part1 = v14;
            local v16 = v14:FindFirstChild("Anchor");
            if v16 then
                v15.C0 = v16.WorldCFrame:ToObjectSpace(l__Main__4.CFrame):Inverse();
                v15.C1 = v16.CFrame;
            else
                v15.C0 = v14.CFrame:ToObjectSpace(l__Main__4.CFrame):Inverse();
            end;
            v15.Parent = v14;
            v14.Anchored = false;
            v14.Massless = true;
            v14.CanCollide = false;
            v14.CanTouch = false;
            v14.CanQuery = false;
            v14.AudioCanCollide = false;
        end;
    end;
    local v17 = {};
    for _, v18 in {
        "Left",
        "Right",
        "Chain1",
        "Chain2",
        "Chain3",
        "Chain4",
        "Chain5",
        "Chain6",
        "Chain7"
    } do
        local v19 = l__Main__4:FindFirstChild(v18);
        if v19 then
            local v20 = Instance.new("Part");
            v20.Transparency = 1;
            v20.Name = v18;
            v20.Anchored = false;
            v20.Massless = true;
            v20.CanCollide = false;
            v20.CanTouch = false;
            v20.AudioCanCollide = false;
            v20.CanQuery = false;
            v20.Size = Vector3.new(0.2, 0.2, 0.2);
            v20.Parent = l__Upper__2;
            if v18:sub(1, 5) == "Chain" then
                v17[#v17 + 1] = v20;
            end;
            local v21 = Instance.new("Motor6D");
            v21.Part0 = l__Main__4;
            v21.Part1 = v20;
            v21.C0 = v19.WorldCFrame:ToObjectSpace(l__Main__4.CFrame):Inverse();
            v21.Parent = v20;
        end;
    end;
    v8.Chain = u3.new(v6, l__Main__4, l__Main__4:WaitForChild("Pivot"), v17, l__Upper__2);
    return v8;
end;
function u4.Replicate(p22, p23) --[[ Line: 139 ]]
    if p22.Focused then
    else
        p22.Facing = p23;
    end;
end;
function u4.Discharge(p24, p25, p26, p27, p28, p29) --[[ Line: 146 ]]
    -- upvalues: u2 (copy)
    if p24.Focused then
    else
        if p25 then
            u2:Discharge(p25, p26, p27, nil, false, nil, nil, p24.Model);
        end;
        p24.Chain:Discharge(p29, p28, p26, false);
    end;
end;
function u4.Reload(p30, p31) --[[ Line: 156 ]]
    if p30.Focused then
    else
        p30.Chain:Reload(p31);
    end;
end;
function u4.Capacity(p32, p33) --[[ Line: 163 ]]
    p32.Chain.Length = p33;
end;
function u4.Update(p34, p35) --[[ Line: 167 ]]
    local l__Facing__8 = p34.Facing;
    local l__Current__9 = p34.Current;
    local l__X__10 = l__Current__9.X;
    local l__X__11 = l__Facing__8.X;
    local v36 = math.sin(l__X__11 - l__X__10);
    local v37 = math.cos(l__X__10 - l__X__11);
    local v38 = math.atan2(v36, v37);
    local v39 = math.abs(v38);
    if v39 > 0.001 then
        local v40;
        v40, l__X__10 = CFrame.Angles(0, l__X__10, 0):Lerp(CFrame.Angles(0, l__X__11, 0), (math.min(1, p35 / v39 * 1.5))):ToOrientation();
        _ = v40;
        p34.Lower.C0 = p34.LowerC0 * CFrame.Angles(0, l__X__10, 0);
    end;
    local l__Y__12 = l__Current__9.Y;
    local l__Y__13 = l__Facing__8.Y;
    local v41 = math.sin(l__Y__13 - l__Y__12);
    local v42 = math.cos(l__Y__12 - l__Y__13);
    local v43 = math.atan2(v41, v42);
    local v44 = math.abs(v43);
    if v44 > 0.001 then
        local v45;
        v45, l__Y__12 = CFrame.Angles(0, l__Y__12, 0):Lerp(CFrame.Angles(0, l__Y__13, 0), (math.min(1, p35 / v44 * 1.5))):ToOrientation();
        _ = v45;
        p34.Upper.C0 = p34.UpperC0 * CFrame.Angles(l__Y__12, 0, 0);
    end;
    p34.Current = Vector2.new(l__X__10, l__Y__12);
end;
function u4.Destroy(p46) --[[ Line: 190 ]]
    p46.Chain:Destroy();
end;
return u4;