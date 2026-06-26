-- Services.ChunkService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, v2 = shared.import("require", "asset");
local u3 = v1("SoundService");
local u4 = v1("WorldService");
local u5 = v1("EnvironmentService");
local u6 = v1("WaveCalculator");
local u7 = v1("GameSettings");
local u8 = v1("ChunkParser");
local u9 = v1("Octree");
local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__CollectionService__2 = game:GetService("CollectionService");
local l__Debris__3 = game:GetService("Debris");
local l__Lighting__4 = game:GetService("Lighting");
local l__UserGameSettings__5 = UserSettings():GetService("UserGameSettings");
local l__CurrentCamera__6 = workspace.CurrentCamera;
local l__Asset__7 = v2:Get("Shared", "Models", "Environment", "Ocean").Asset;
local l__Asset__8 = v2:Get("Shared", "Models", "Environment", "Fake").Asset;
local l__Prefab__9 = l__ReplicatedStorage__1:WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("Prefab");
local l__Asset__10 = v2:Get("Shared", "Particles", "Foliage", "LeafSplatter").Asset;
local u10 = Instance.new("Folder");
u10.Parent = workspace;
local u11 = {};
u11.__index = u11;
function u11._loadWorld(p12, p13) --[[ Line: 41 ]]
    -- upvalues: u10 (copy), l__Asset__7 (copy), l__Asset__8 (copy), u8 (copy)
    local l__Water__11 = p13.Water;
    if l__Water__11.Enabled then
        p12._waterHeight = l__Water__11.Height or 10;
        p12._waterDepth = l__Water__11.Depth or -50;
        p12._waterIgnore = l__Water__11.Ignore or {};
        if not p12._waterContainer then
            local v14 = Instance.new("Model");
            v14.Parent = u10;
            local v15 = {};
            for v16 = 1, 9 do
                local v17 = l__Asset__7:Clone();
                local v18 = {};
                for _, v19 in v17:GetChildren() do
                    if v19:IsA("Bone") then
                        v18[tonumber(v19.Name)] = {
                            Bone = v19
                        };
                    end;
                end;
                v17.Parent = v14;
                v15[v16] = {
                    Loaded = true,
                    Ocean = v17,
                    Chunk = { v16 + 100, 0 },
                    Bones = v18
                };
            end;
            local v20 = Instance.new("Part");
            v20.Anchored = true;
            v20.Material = Enum.Material.CrackedLava;
            v20.Color = Color3.new(1, 1, 1);
            v20.Parent = v14;
            v20.Size = Vector3.new(1024, 1, 1024);
            if l__Water__11._ALLOW_FREE_FALL then
                v20.CanCollide = false;
                v20.CanTouch = false;
                v20.CanQuery = false;
            end;
            local v21 = l__Asset__8:Clone();
            v21.Parent = v14;
            p12._waterFake = v21;
            p12._waterFloor = v20;
            p12._waterTemplates = v15;
            p12._waterContainer = v14;
        end;
    elseif p12._waterContainer then
        p12._waterContainer:Destroy();
        p12._waterContainer = nil;
        p12._waterFake = nil;
        p12._waterTemplates = nil;
    end;
    p12._waterEnabled = l__Water__11.Enabled;
    p12._chunkData = u8(p13.Chunk);
    p12._chunk = nil;
end;
function u11.Update(p22, p23) --[[ Line: 107 ]]
    -- upvalues: l__CurrentCamera__6 (copy), u7 (copy), l__UserGameSettings__5 (copy), u5 (copy), l__Asset__10 (copy), l__Debris__3 (copy), u3 (copy), u6 (copy), l__CollectionService__2 (copy), u10 (copy)
    debug.profilebegin("Chunk");
    local l__CFrame__12 = l__CurrentCamera__6.CFrame;
    local l__Position__13 = l__CurrentCamera__6.Focus.Position;
    local v24 = math.floor(l__Position__13.X / 512);
    local v25 = math.floor(l__Position__13.Z / 512);
    local l__RenderDistance__14 = u7.RenderDistance;
    local v26;
    if l__RenderDistance__14 == 1 then
        local l__Value__15 = l__UserGameSettings__5.SavedQualityLevel.Value;
        v26 = l__Value__15 == 10 and 3 or (l__Value__15 >= 8 and 2 or 1);
    else
        v26 = l__RenderDistance__14 == 4 and 3 or (l__RenderDistance__14 == 3 and 2 or 1);
    end;
    local v27 = v26 ~= p22._renderDistanceLast;
    p22._renderDistanceLast = v26;
    local v28 = v24 .. "," .. v25;
    local v29 = v28 ~= p22._chunk;
    p22._chunk = v28;
    local v30 = 0;
    local v31 = {};
    local v32 = {};
    local v33 = 0;
    local v34 = {};
    local v35 = {};
    local l__UnderWater__16 = u5.UnderWater;
    if (v29 or p22._wasUnderWater ~= l__UnderWater__16) and (p22._waterTemplates and p22._waterFake) then
        v30 = v30 + 1;
        v31[v30] = p22._waterFake;
        v32[v30] = CFrame.new(v24 * 512 + 256 + 0, l__UnderWater__16 and -1000 or p22._waterHeight, v25 * 512 + 256 + 0);
        for _, v36 in p22._waterTemplates do
            if v36.Loaded and v36.CFrame then
                v30 = v30 + 1;
                v31[v30] = v36.Ocean;
                v32[v30] = v36.CFrame + Vector3.new(0, l__UnderWater__16 and -1000, 0);
            end;
        end;
    end;
    local _ = p22._wasUnderWater;
    if v29 or v27 then
        debug.profilebegin("Water");
        if p22._waterEnabled then
            local v37 = v30 + 1;
            v31[v37] = p22._waterFake;
            v32[v37] = CFrame.new(v24 * 512 + 256, p22._waterHeight, v25 * 512 + 256);
            v30 = v37 + 1;
            v31[v30] = p22._waterFloor;
            v32[v30] = CFrame.new(v24 * 512 + 256, p22._waterDepth, v25 * 512 + 256);
            local v38 = {
                { v24 - 1, v25 - 1 },
                { v24 - 1, v25 },
                { v24 - 1, v25 + 1 },
                { v24, v25 - 1 },
                { v24, v25 },
                { v24, v25 + 1 },
                { v24 + 1, v25 - 1 },
                { v24 + 1, v25 },
                { v24 + 1, v25 + 1 }
            };
            local v39 = {};
            for _, v40 in p22._waterTemplates do
                local l__Chunk__17 = v40.Chunk;
                local v41 = nil;
                for v42 = 1, #v38 do
                    local v43 = v38[v42];
                    if v43[1] == l__Chunk__17[1] and v43[2] == l__Chunk__17[2] then
                        v41 = v42;
                        break;
                    end;
                end;
                if v41 then
                    table.remove(v38, v41);
                else
                    v39[#v39 + 1] = v40;
                end;
            end;
            local l___waterContainer__18 = p22._waterContainer;
            for v44, v45 in v38 do
                local v46 = v39[v44];
                local v47 = v45[1];
                local v48 = v45[2];
                v46.Chunk = { v47, v48 };
                local v49 = CFrame.new(v47 * 512 + 256, p22._waterHeight, v48 * 512 + 256);
                local v50 = table.find(p22._waterIgnore, v47 .. "," .. v48);
                if v50 then
                    v46.Ocean.Parent = nil;
                    v46.Loaded = false;
                else
                    v30 = v30 + 1;
                    v31[v30] = v46.Ocean;
                    v32[v30] = v49;
                    if not v46.Loaded then
                        v46.Loaded = true;
                        v46.Ocean.Parent = l___waterContainer__18;
                    end;
                end;
                v46.CFrame = v49;
                for _, v51 in v46.Bones do
                    if v51.Node then
                        v51.Node:Destroy();
                        v51.Node = nil;
                    end;
                    if v50 == nil then
                        v51.Bone.Transform = CFrame.new();
                        local v52 = v49.Position + v51.Bone.Position;
                        v51.Node = p22._waterBones:CreateNode(v52, {
                            Position = Vector3.new(v52.X, 0, v52.Z),
                            X = math.noise(v52.X, v52.Z, 1),
                            Z = math.noise(v52.X, v52.Z, 0),
                            Bone = v51.Bone
                        });
                    end;
                end;
            end;
        end;
        debug.profileend();
        debug.profilebegin("Props");
        local l___chunkData__19 = p22._chunkData;
        local l___chunkLoaded__20 = p22._chunkLoaded;
        local v53 = {};
        local v54 = {};
        local v55 = {};
        for v56 = v24 - v26, v24 + v26 do
            if l___chunkData__19[tostring(v56)] then
                for v57 = v25 - v26, v25 + v26 do
                    local v58 = l___chunkData__19[tostring(v56)][tostring(v57)];
                    local v59;
                    if math.abs(v56 - v24) <= 1 then
                        v59 = math.abs(v57 - v25) <= 1;
                    else
                        v59 = false;
                    end;
                    if v58 then
                        for v60 = 1, #v58 do
                            local v61 = v58[v60];
                            if v61[1]:find("Tree") ~= nil or v59 ~= false then
                                if v61[4] then
                                    v53[v61[5]] = v61;
                                    l___chunkLoaded__20[v61[5]] = nil;
                                else
                                    local v62 = v61[1];
                                    if not v54[v62] then
                                        v54[v62] = {};
                                    end;
                                    v54[v62][#v54[v62] + 1] = v61;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        for v63, v64 in l___chunkLoaded__20 do
            local v65 = v64[1];
            if not v55[v65] then
                v55[v65] = {};
            end;
            if not v54[v65] then
                v54[v65] = {};
            end;
            v64[4] = false;
            v64[5] = nil;
            for _, v66 in v63:GetChildren() do
                if p22._shakeObjects[v66] then
                    p22._shakeObjects[v66].Node:Destroy();
                    p22._shakeObjects[v66] = nil;
                end;
            end;
            if v63:GetAttribute("Waste") or l__CollectionService__2:HasTag(v63, "DamageActive") then
                v63:Destroy();
            else
                v55[v65][#v55[v65] + 1] = v63;
            end;
        end;
        for v67, v68 in v54 do
            if not v55[v67] then
                v55[v67] = {};
            end;
            local v69 = v55[v67];
            local v70 = p22._prefabs[v67];
            if v70 then
                if #v69 > #v68 then
                    for v71 = #v69, #v68 + 1, -1 do
                        local v72 = v69[v71];
                        if p22._queueForWorkspace[v72] then
                            p22._queueForWorkspace[v72] = nil;
                        else
                            p22._queueForRemoval[v72] = true;
                        end;
                        v69[v71] = nil;
                    end;
                elseif #v69 < #v68 then
                    for v73 = #v69 + 1, #v68 do
                        local v74 = v70.Model:Clone();
                        p22._queueForWorkspace[v74] = true;
                        v69[v73] = v74;
                    end;
                end;
                for v75 = 1, #v69 do
                    local v76 = v68[v75];
                    local v77 = v69[v75];
                    local v78 = v76[6];
                    if not v78 then
                        local v79 = v76[2];
                        local v80 = v76[3];
                        v78 = CFrame.new(tonumber(v79[1]), tonumber(v79[2]), (tonumber(v79[3]))) * CFrame.fromOrientation(tonumber(v80[1]), tonumber(v80[2]), (tonumber(v80[3])));
                        v76[6] = v78;
                    end;
                    local v81 = false;
                    for v82, v83 in v70.Offsets do
                        v30 = v30 + 1;
                        v31[v30] = v77[v82];
                        v32[v30] = v78:ToWorldSpace(v83);
                        if not v81 and v82:sub(1, 6) == "Leaves" then
                            local v84 = v77[v82];
                            local v85 = v78:ToWorldSpace(v83);
                            local v86 = v84.Size.Y / 2;
                            local l__Main__21 = v77.Main;
                            if l__Main__21 and l__Main__21:IsA("MeshPart") then
                                v86 = l__Main__21.Size.Y / 2;
                                v85 = v78:ToWorldSpace(CFrame.new(0, -v86, 0));
                            else
                                l__Main__21 = nil;
                            end;
                            if not v77:FindFirstChildWhichIsA("Humanoid") then
                                local v87 = Instance.new("Humanoid");
                                v87.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None;
                                v87.EvaluateStateMachine = false;
                                v87.RequiresNeck = false;
                                v87.BreakJointsOnDeath = false;
                                v87.RigType = Enum.HumanoidRigType.R6;
                                v87.Parent = v77;
                            end;
                            p22._shakeObjects[v84] = {
                                Touched = false,
                                Node = p22._shakeOctree:CreateNode(v85.Position, v84),
                                Size = math.max(v84.Size.Z / 2, v84.Size.X / 2),
                                Main = l__Main__21,
                                Pivot = v86,
                                Origin = v85,
                                Offset = v83,
                                Seed = math.random(1000) * 0.1,
                                Shrub = v84.Massless
                            };
                            v81 = true;
                        end;
                    end;
                    v76[4] = true;
                    v76[5] = v77;
                    v53[v77] = v76;
                end;
            else
                warn(v67);
            end;
        end;
        p22._chunkLoaded = v53;
        debug.profileend();
    else
        debug.profilebegin("Shaking");
        if u7.TreeShaking == 1 then
            v31 = p22._shakeOctree:RadiusSearch(l__CFrame__12.Position + l__CFrame__12.LookVector * 115, 120);
            v30 = #v31;
            v32 = table.create(v30);
            local l___rotors__22 = p22._rotors;
            local l___blocks__23 = p22._blocks;
            local v88 = os.time();
            local v89 = math.rad(p22._windDirection);
            local v90 = (p22._windStrength - 100) ^ 1.15 / 50;
            local v91 = p22._windNoise + v90 * p23 / 20;
            p22._windNoise = v91;
            for v92 = 1, v30 do
                local v93 = v31[v92];
                local v94 = p22._shakeObjects[v93];
                local l__Origin__24 = v94.Origin;
                local v95 = v94.CFrame or l__Origin__24;
                CFrame.new();
                local v96 = CFrame.Angles(0, v89, 0);
                local l__Position__25 = l__Origin__24.Position;
                local v97 = 1;
                for v98 = 1, #l___rotors__22 do
                    local v99 = l___rotors__22[v98];
                    local v100 = v99[1];
                    local l__Magnitude__26 = (l__Position__25 - v100).Magnitude;
                    if l__Magnitude__26 < 100 then
                        local v101 = (1 - l__Magnitude__26 / 100) * v99[2];
                        local v102 = v101 * 10;
                        if v97 < v102 then
                            local _, v103 = CFrame.new(v100, l__Position__25):ToOrientation();
                            v96 = v96:Lerp(CFrame.Angles(0, v103, 0), v101);
                            v97 = v102;
                        end;
                    end;
                end;
                local l__Seed__27 = v94.Seed;
                local v104 = v88 * 0.1 * v97;
                local _, v105 = l__Origin__24:ToOrientation();
                local v106 = math.noise(v104, v91, l__Seed__27) / 10;
                local v107 = math.max(v90 / 2, v97 * 1.5);
                local v108 = v106 - math.rad(v107);
                if v94.Shrub then
                    local l__Size__28 = v94.Size;
                    local v109 = 0;
                    for v110, v111 in l___blocks__23 do
                        local l__Position__29 = v110.CFrame.Position;
                        local l__Magnitude__30 = (l__Position__25 - l__Position__29).Magnitude;
                        if l__Size__28 >= l__Magnitude__30 - v111 then
                            local l__Magnitude__31 = (l__Position__25 - (l__Position__29 + CFrame.new(l__Position__29, l__Position__25).LookVector * math.min(l__Magnitude__30, v111))).Magnitude;
                            if l__Size__28 > l__Magnitude__31 then
                                local v112 = 1 - l__Magnitude__31 / l__Size__28;
                                if v109 < v112 then
                                    local _, v113 = CFrame.new(l__Position__29, l__Position__25):ToOrientation();
                                    v96 = CFrame.Angles(0, v113, 0);
                                    v109 = v112;
                                end;
                            end;
                        end;
                    end;
                    if v109 > 0 then
                        v108 = -math.rad(v109 * 20);
                        if not v94.Touched then
                            local v114 = l__Asset__10:Clone();
                            v114.Parent = v93;
                            v114:Emit(10);
                            l__Debris__3:AddItem(v114, 1.5);
                            l__Debris__3:AddItem(u3:CreateSound("Foliage", v93, true, "Foliage", "Shrub").Sound, 2);
                        end;
                        v94.Touched = true;
                    else
                        v94.Touched = false;
                    end;
                end;
                local l__Pivot__32 = v94.Pivot;
                local v115;
                if v94.Main then
                    local v116 = (l__Origin__24 * (CFrame.Angles(0, v105, 0):Inverse() * v96) * CFrame.Angles(v108, 0, 0) * (v96:Inverse() * CFrame.Angles(0, v105, 0))):ToWorldSpace(CFrame.new(0, v94.Pivot, 0));
                    v115 = v116:ToWorldSpace(v94.Offset * CFrame.new(0, math.noise(v104, v91, -l__Seed__27), 0) * CFrame.Angles(0, math.noise(v104, v91, -l__Seed__27) / 5, 0));
                    v30 = v30 + 1;
                    v31[v30] = v94.Main;
                    v32[v30] = v116;
                    v94.CFrame = v115;
                else
                    v115 = v95:Lerp(l__Origin__24 * CFrame.new(0, -l__Pivot__32, 0) * CFrame.Angles(0, v105, 0):Inverse() * v96 * CFrame.Angles(v108, math.noise(v104, v91, -l__Seed__27) / 10, 0) * v96:Inverse() * CFrame.Angles(0, v105, 0) * CFrame.new(0, l__Pivot__32, 0), v94.CFrame and (p23 * 8 or 1) or 1);
                    v94.CFrame = v115;
                end;
                v32[v92] = v115;
            end;
        end;
        debug.profileend();
        debug.profilebegin("Water");
        if p22._waterEnabled then
            local v117 = l__CurrentCamera__6.CFrame:PointToWorldSpace(Vector3.new(0, 0, -128));
            local v118 = u7.WorldDetail == 3 and 512 or 256;
            debug.profilebegin("Search");
            local v119 = u7.WaterMovement ~= 1 and {} or p22._waterBones:RadiusSearch(Vector3.new(v117.X, 0, v117.Z), v118);
            debug.profileend();
            local l___waterRange__33 = p22._waterRange;
            for _, v120 in v119 do
                v120.InNew = true;
                local v121, v122 = u6:GetWaveHeight(v120.Position, true, true);
                if v122 > 0 then
                    if v122 < 0.5 and v120.Processed then
                        v120.Processed = false;
                    else
                        v120.Processed = true;
                        v33 = v33 + 1;
                        v34[v33] = v120.Bone;
                        v35[v33] = CFrame.new(0, v121, 0);
                    end;
                end;
            end;
            for v123 = 1, #l___waterRange__33 do
                local v124 = l___waterRange__33[v123];
                if v124.InNew then
                    v124.InNew = nil;
                else
                    v33 = v33 + 1;
                    v34[v33] = v124.Bone;
                    v35[v33] = CFrame.identity;
                end;
            end;
            p22._waterRange = v119;
        end;
        debug.profileend();
    end;
    debug.profilebegin("Operations");
    local v125 = math.floor(p23 * 1000);
    local v126 = math.clamp(v125, 2, 50);
    local l___queueForWorkspace__34 = p22._queueForWorkspace;
    local v127 = 0;
    for v128 in l___queueForWorkspace__34 do
        v127 = v127 + 1;
        l___queueForWorkspace__34[v128] = nil;
        v128.Parent = u10;
        if v126 <= v127 then
            break;
        end;
    end;
    local l___queueForRemoval__35 = p22._queueForRemoval;
    local v129 = 0;
    for v130 in l___queueForRemoval__35 do
        v129 = v129 + 1;
        l___queueForRemoval__35[v130] = nil;
        v130:Destroy();
        if v126 <= v129 then
            break;
        end;
    end;
    if v30 > 0 then
        workspace:BulkMoveTo(v31, v32, Enum.BulkMoveMode.FireCFrameChanged);
    end;
    if v33 > 0 then
        debug.profilebegin("Bones");
        for v131 = 1, v33 do
            v34[v131].Transform = v35[v131];
        end;
        debug.profileend();
    end;
    debug.profileend();
    debug.profileend();
end;
function u11.new() --[[ Line: 654 ]]
    -- upvalues: l__Prefab__9 (copy), u9 (copy), l__Lighting__4 (copy), u11 (copy), u4 (copy)
    local v132 = {};
    for _, v133 in l__Prefab__9:GetChildren() do
        if v133.Name ~= "Hidden" and v133.Name:sub(1, 10) ~= "Deprecated" then
            for _, v134 in v133:GetDescendants() do
                if v134:IsA("Model") then
                    local v135 = v134:FindFirstChild("Main");
                    if v135 then
                        local l__CFrame__36 = v135.CFrame;
                        local v136 = {};
                        for _, v137 in v134:GetChildren() do
                            v136[v137.Name] = l__CFrame__36:ToObjectSpace(v137.CFrame);
                            if v137.Name:sub(1, 6) == "Leaves" then
                                v137.CanCollide = false;
                                v137.CanTouch = false;
                                v137.CanQuery = false;
                                v137.AudioCanCollide = false;
                            end;
                        end;
                        v132[v134.Name] = {
                            Model = v134,
                            Offsets = v136
                        };
                    end;
                end;
            end;
        end;
    end;
    local v138 = {
        _windNoise = 0,
        _rotors = {},
        _blocks = {},
        _chunkLoaded = {},
        _shakeOctree = u9.new(),
        _shakeObjects = {},
        _waterBones = u9.new(),
        _waterRange = {},
        _queueForWorkspace = {},
        _queueForRemoval = {},
        _prefabs = v132,
        _windDirection = l__Lighting__4:GetAttribute("WindDirection"),
        _windStrength = l__Lighting__4:GetAttribute("WindStrength")
    };
    local u139 = setmetatable(v138, u11);
    l__Lighting__4:GetAttributeChangedSignal("WindDirection"):Connect(function() --[[ Line: 712 ]]
        -- upvalues: u139 (copy), l__Lighting__4 (ref)
        u139._windDirection = l__Lighting__4:GetAttribute("WindDirection");
    end);
    l__Lighting__4:GetAttributeChangedSignal("WindStrength"):Connect(function() --[[ Line: 716 ]]
        -- upvalues: u139 (copy), l__Lighting__4 (ref)
        u139._windStrength = l__Lighting__4:GetAttribute("WindStrength");
    end);
    u4.Changed:Connect(function(p140) --[[ Line: 720 ]]
        -- upvalues: u139 (copy)
        u139:_loadWorld(p140);
    end);
    if u4.World then
        u139:_loadWorld(u4.World);
    end;
    return u139;
end;
function u11.Restore(p141) --[[ Line: 730 ]]
    local l___chunkLoaded__37 = p141._chunkLoaded;
    for v142, v143 in l___chunkLoaded__37 do
        if v142:GetAttribute("Waste") ~= nil then
            v143[4] = false;
            v143[5] = nil;
            for _, v144 in v142:GetChildren() do
                if p141._shakeObjects[v144] then
                    p141._shakeObjects[v144].Node:Destroy();
                    p141._shakeObjects[v144] = nil;
                end;
            end;
            v142:Destroy();
            l___chunkLoaded__37[v142] = nil;
        end;
    end;
    p141._chunk = nil;
end;
function u11.RegisterRotor(p145, p146) --[[ Line: 753 ]]
    table.insert(p145._rotors, p146);
end;
function u11.UnregisterRotor(p147, p148) --[[ Line: 757 ]]
    local l___rotors__38 = p147._rotors;
    local v149 = table.find(l___rotors__38, p148);
    if v149 then
        table.remove(l___rotors__38, v149);
    end;
end;
function u11.RegisterBlock(p150, p151, p152) --[[ Line: 765 ]]
    p150._blocks[p151] = p152;
end;
function u11.UnregisterBlock(p153, p154) --[[ Line: 769 ]]
    p153._blocks[p154] = nil;
end;
return u11.new();