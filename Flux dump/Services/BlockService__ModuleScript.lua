-- Services.BlockService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1 = shared.import("require")("WorldService");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u2 = {};
u2.__index = u2;
function u2._unload(p3) --[[ Line: 12 ]]
    for _, v4 in p3._blocks do
        local l__Folder__2 = v4.Folder;
        if v4.FirstLoaded then
            v4.First.Parent = l__Folder__2;
        end;
        if v4.LastLoaded then
            v4.Last.Parent = l__Folder__2;
        end;
    end;
    p3._blocks = {};
    for _, v5 in p3._lods do
        local l__Folder__3 = v5.Folder;
        if v5.Loaded then
            v5.Full.Parent = l__Folder__3;
        else
            v5.Lod.Parert = l__Folder__3;
        end;
    end;
    p3._lods = {};
end;
function u2._load(p6, p7) --[[ Line: 35 ]]
    p6:_unload();
    for _, v8 in p7.LOD:GetChildren() do
        local v9 = v8:FindFirstChild("FULL");
        if v9 then
            local v10 = v8:FindFirstChild("LOD");
            if v10 then
                v10.Parent = workspace;
                local l__WorldPivot__4 = v10.WorldPivot;
                local v11 = Vector2.new(l__WorldPivot__4.X, l__WorldPivot__4.Z);
                p6._lods[#p6._lods + 1] = {
                    Loaded = false,
                    Range = v8:GetAttribute("Range") or 350,
                    Origin = v11,
                    Folder = v8,
                    Full = v9,
                    Lod = v10
                };
            end;
        end;
    end;
    p6._LODindex = 1;
    for _, v12 in p7.Blocks:GetChildren() do
        local v13 = v12:FindFirstChild("First");
        if v13 then
            local v14 = v12:FindFirstChild("Last");
            if v14 then
                local v15 = v12:FindFirstChild("Box");
                if v15 then
                    local l__CFrame__5 = v15.CFrame;
                    local v16 = Vector2.new(l__CFrame__5.X, l__CFrame__5.Z);
                    local v17 = v15.Size / 2;
                    local l__X__6 = v17.X;
                    local l__Y__7 = v17.Y;
                    local l__Z__8 = v17.Z;
                    local v18 = math.sqrt(l__X__6 ^ 2 + l__Z__8 ^ 2) + (v15:GetAttribute("Radius") or 200);
                    p6._blocks[#p6._blocks + 1] = {
                        FirstLoaded = false,
                        LastLoaded = false,
                        Folder = v12,
                        First = v13,
                        Last = v14,
                        Radius = v18,
                        Origin = v16,
                        CFrame = l__CFrame__5,
                        Check = function(p19) --[[ Name: check, Line 86 ]]
                            -- upvalues: l__CFrame__5 (copy), l__X__6 (copy), l__Y__7 (copy), l__Z__8 (copy)
                            local v20 = l__CFrame__5:PointToObjectSpace(p19);
                            local v21;
                            if math.abs(v20.X) <= l__X__6 and math.abs(v20.Y) <= l__Y__7 then
                                v21 = math.abs(v20.Z) <= l__Z__8;
                            else
                                v21 = false;
                            end;
                            return v21;
                        end
                    };
                end;
            end;
        end;
    end;
end;
function u2.new() --[[ Line: 106 ]]
    -- upvalues: u2 (copy), u1 (copy)
    local u22 = setmetatable({
        _index = 1,
        _blocks = {},
        _lods = {}
    }, u2);
    u1.Changed:Connect(function(p23) --[[ Line: 113 ]]
        -- upvalues: u22 (copy)
        u22:_load(p23);
    end);
    if u1.World then
        u22:_load(u1.World);
    end;
    return u22;
end;
function u2.Update(p24) --[[ Line: 123 ]]
    -- upvalues: l__CurrentCamera__1 (copy)
    local l__Position__9 = l__CurrentCamera__1.Focus.Position;
    local v25 = Vector2.new(l__Position__9.X, l__Position__9.Z);
    for _, v26 in p24._blocks do
        local l__Folder__10 = v26.Folder;
        if not (v26.LastLoaded and v26.Check(l__Position__9)) then
            if (v25 - v26.Origin).Magnitude < v26.Radius then
                if not v26.FirstLoaded then
                    v26.FirstLoaded = true;
                    v26.First.Parent = workspace;
                end;
                if v26.Check(l__Position__9) then
                    if not v26.LastLoaded then
                        v26.LastLoaded = true;
                        v26.Last.Parent = workspace;
                    end;
                elseif v26.LastLoaded then
                    v26.LastLoaded = false;
                    v26.Last.Parent = l__Folder__10;
                end;
            else
                if v26.FirstLoaded then
                    v26.FirstLoaded = false;
                    v26.First.Parent = l__Folder__10;
                end;
                if v26.LastLoaded then
                    v26.LastLoaded = false;
                    v26.Last.Parent = l__Folder__10;
                end;
            end;
        end;
    end;
    local v27 = p24._lods[p24._LODindex];
    if v27 then
        if v27.UnloadLODOnNext then
            v27.Lod.Parent = v27.Folder;
            v27.UnloadLODOnNext = false;
        elseif v27.UnloadFullOnNext then
            v27.Full.Parent = v27.Folder;
            v27.UnloadFullOnNext = false;
        else
            local v28 = (v25 - v27.Origin).Magnitude < v27.Range;
            if v28 and not v27.Loaded then
                v27.Full.Parent = workspace;
                v27.UnloadLODOnNext = true;
            elseif not v28 and v27.Loaded then
                v27.Lod.Parent = workspace;
                v27.UnloadFullOnNext = true;
            end;
            v27.Loaded = v28;
        end;
    end;
    if p24._lods[p24._LODindex + 1] then
        p24._LODindex = p24._LODindex + 1;
    else
        p24._LODindex = 1;
    end;
end;
return u2.new();