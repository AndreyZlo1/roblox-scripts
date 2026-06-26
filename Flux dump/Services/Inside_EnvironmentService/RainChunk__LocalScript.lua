-- Services.EnvironmentService.RainChunk
-- LocalScript | dc

-- Decompiled with Potassium's decompiler.

local l__RunService__1 = game:GetService("RunService");
local l__Lighting__2 = game:GetService("Lighting");
local l__FallenPartsDestroyHeight__3 = workspace.FallenPartsDestroyHeight;
local l__UserGameSettings__4 = UserSettings():GetService("UserGameSettings");
local l__CurrentCamera__5 = workspace.CurrentCamera;
local l__Terrain__6 = workspace.Terrain;
local u1 = CFrame.new();
local u2 = Vector3.new();
local l__Value__7 = l__UserGameSettings__4.SavedQualityLevel.Value;
local u3 = l__Lighting__2:GetAttribute("WindStrength");
local u4 = RaycastParams.new();
u4.CollisionGroup = 9;
u4.FilterDescendantsInstances = {};
u4.IgnoreWater = false;
local u5 = {};
local u6 = {};
local u7 = false;
local u8 = 200;
local u9 = true;
for v10 = 1, 200 do
    local v11 = Instance.new("LineHandleAdornment");
    v11.Transparency = 0.5;
    v11.Thickness = 1;
    v11.Color3 = Color3.new(0.5, 0.5, 0.5);
    v11.Length = 6;
    v11.Parent = l__Terrain__6;
    v11.Adornee = l__Terrain__6;
    local v12 = Instance.new("LineHandleAdornment");
    v12.Transparency = 0.5;
    v12.Thickness = 1;
    v12.Color3 = Color3.new(0.5, 0.5, 0.5);
    v12.Length = 6;
    v12.Parent = l__Terrain__6;
    v12.Adornee = l__Terrain__6;
    u5[v10] = { v11, v12 };
    local v13 = Instance.new("ImageHandleAdornment");
    v13.Image = "rbxassetid://12657776373";
    v13.Parent = l__Terrain__6;
    v13.Adornee = l__Terrain__6;
    u6[v10] = { v13 };
end;
local function v23() --[[ Line: 64 ]]
    -- upvalues: l__Lighting__2 (copy), u7 (ref), u5 (copy)
    local v14 = l__Lighting__2:GetAttribute("IsSnowing");
    if v14 == u7 then
    else
        u7 = v14;
        local v15 = v14 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
        local v16 = v14 and 5 or 3;
        local v17 = v14 and 0 or 0.2;
        local v18 = v14 and 0.5 or 6;
        for v19 = 1, #u5 do
            local v20 = u5[v19];
            local v21 = v20[1];
            local v22 = v20[2];
            v21.Color3 = v15;
            v21.Thickness = v16;
            v21.Transparency = v17;
            v21.Length = v18;
            v22.Color3 = v15;
            v22.Thickness = v16;
            v22.Transparency = v17;
            v22.Length = v18;
        end;
    end;
end;
local function v30() --[[ Line: 91 ]]
    -- upvalues: l__Lighting__2 (copy), u2 (ref), u1 (ref)
    l__Lighting__2:GetAttribute("WindDirection");
    local v24 = CFrame.new(Vector3.new(0, 500, 0), Vector3.new(0, 0, 0)) - Vector3.new(0, 500, 0);
    local v25, v26 = v24:ToOrientation();
    local v27 = 500 / math.tan(v25);
    local v28 = math.sin(v26) * v27;
    local v29 = math.cos(v26) * v27;
    u2 = Vector3.new(v28, 0, v29);
    u1 = v24;
end;
script:GetAttributeChangedSignal("Enabled"):Connect(function(_) --[[ Line: 102 ]]
    -- upvalues: u9 (ref)
    u9 = script:GetAttribute("Enabled");
end);
l__UserGameSettings__4.Changed:Connect(function() --[[ Line: 106 ]]
    -- upvalues: l__Value__7 (ref), l__UserGameSettings__4 (copy)
    l__Value__7 = l__UserGameSettings__4.SavedQualityLevel.Value;
end);
l__Lighting__2:GetAttributeChangedSignal("WindStrength"):Connect(function() --[[ Line: 110 ]]
    -- upvalues: u3 (ref), l__Lighting__2 (copy)
    u3 = l__Lighting__2:GetAttribute("WindStrength");
end);
l__Lighting__2:GetAttributeChangedSignal("IsSnowing"):Connect(v23);
v23();
l__Lighting__2:GetAttributeChangedSignal("WindDirection"):Connect(v30);
v30();
l__RunService__1.Heartbeat:ConnectParallel(function(p31) --[[ Line: 120 ]]
    -- upvalues: l__CurrentCamera__5 (copy), u2 (ref), u1 (ref), l__Value__7 (ref), u5 (copy), u7 (ref), u6 (copy), u3 (ref), u4 (copy), l__FallenPartsDestroyHeight__3 (copy), u9 (ref), u8 (ref)
    local v32 = l__CurrentCamera__5.CFrame.Position - u2;
    local v33 = u1.LookVector * p31;
    local v34 = l__Value__7 <= 5 and 64 or 128;
    local v35 = {};
    local v36 = {};
    local v37 = {};
    local v38 = {};
    local v39 = {};
    local v40 = {};
    for v41 = 1, 200 do
        local v42 = u5[v41];
        local v43 = v42[1];
        local v44 = v42[2];
        if v43 ~= nil then
            if u7 and not v42[5] then
                local v45 = (math.random() - 0.5) * 1;
                local v46 = (math.random() - 0.5) * 1;
                v42[5] = Vector3.new(v45, 0, v46);
            elseif not u7 then
                v42[5] = nil;
            end;
            local v47 = u6[v41];
            local v48 = v42[3];
            if v48 == nil then
                local v49 = math.random(-v34, v34);
                v48 = v32 + Vector3.new(v49, v41 / 200 * 500 + 500, math.random(-v34, v34));
                v42[3] = v48;
                v42[4] = math.random(-10, 10);
            end;
            local v50 = v33 * u3 * (u7 and 0.5 or 1) + (v42[5] or Vector3.new(0, 0, 0));
            local v51 = workspace:Raycast(v48, v50, u4);
            local v52, v53, v54, v55, v56;
            if not v51 and v48.Y >= l__FallenPartsDestroyHeight__3 then
                v42[3] = v42[3] + v50;
                if v47[3] and v47[3] < 1 then
                    v47[2] = v47[2] + Vector2.new(2, 2) * p31;
                    v47[3] = v47[3] + p31;
                    v52 = #v38 + 1;
                    v39[v52] = v47[2];
                    v35[v52] = v47[3];
                    v38[v52] = v47[1];
                end;
                v53 = #v40 + 1;
                v54 = #v40 + 2;
                v55 = CFrame.new(v42[3]) * u1;
                v56 = CFrame.new(v42[3] + v42[3].Unit * v42[4] - v50 * 5) * u1;
                if u7 then
                    v55 = v55 * CFrame.Angles(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5);
                    v56 = v56 * CFrame.Angles(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5);
                end;
                v37[v53] = v55;
                v40[v53] = v43;
                v37[v54] = v56;
                v40[v54] = v44;
            end;
            if u9 then
                if v51 and not u7 then
                    local v57 = #v40 + 1;
                    v37[v57] = CFrame.new(v51.Position + Vector3.new(0, 0.05, 0), v51.Position + v51.Normal);
                    v40[v57] = v47[1];
                    local v58 = #v38 + 1;
                    v39[v58] = Vector2.new(1, 1);
                    v35[v58] = 0;
                    v38[v58] = v47[1];
                    v47[2] = Vector2.new(0.2, 0.2);
                    v47[3] = 0;
                end;
                local v59 = math.random(-v34, v34);
                local v60 = 500 + math.random(-250, 250);
                v42[3] = v32 + Vector3.new(v59, v60, math.random(-v34, v34));
                v42[4] = math.random(-10, 10);
                if v47[3] and v47[3] < 1 then
                    v47[2] = v47[2] + Vector2.new(2, 2) * p31;
                    v47[3] = v47[3] + p31;
                    v52 = #v38 + 1;
                    v39[v52] = v47[2];
                    v35[v52] = v47[3];
                    v38[v52] = v47[1];
                end;
                v53 = #v40 + 1;
                v54 = #v40 + 2;
                v55 = CFrame.new(v42[3]) * u1;
                v56 = CFrame.new(v42[3] + v42[3].Unit * v42[4] - v50 * 5) * u1;
                if u7 then
                    v55 = v55 * CFrame.Angles(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5);
                    v56 = v56 * CFrame.Angles(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5);
                end;
                v37[v53] = v55;
                v40[v53] = v43;
                v37[v54] = v56;
                v40[v54] = v44;
            else
                u8 = u8 - 1;
                v36[#v36 + 1] = v43;
                v36[#v36 + 1] = v44;
                v36[#v36 + 1] = v47[1];
                v42[1] = nil;
            end;
        end;
    end;
    task.synchronize();
    for v61 = 1, #v36 do
        v36[v61]:Destroy();
    end;
    for v62 = 1, #v40 do
        v40[v62].CFrame = v37[v62];
    end;
    for v63 = 1, #v38 do
        local v64 = v38[v63];
        v64.Transparency = v35[v63];
        v64.Size = v39[v63];
    end;
    if u8 == 0 then
        script.Parent:Destroy();
    end;
end);