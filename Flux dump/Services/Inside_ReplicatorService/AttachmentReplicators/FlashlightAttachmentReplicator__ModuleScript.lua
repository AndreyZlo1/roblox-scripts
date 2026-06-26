-- Services.ReplicatorService.AttachmentReplicators.FlashlightAttachmentReplicator
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1, v2, v3 = shared.import("Enum", "require", "asset");
local u4 = v2("SoundService");
local u5 = v2("ViewmodelService");
local u6 = v2("EnvironmentService");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local _ = workspace.Terrain;
local u7 = v3:Get("Shared", "Models", "Weapon", "Cone");
local u8 = {};
u8.__index = u8;
function u8._updateModels(p9) --[[ Line: 17 ]]
    -- upvalues: u1 (copy)
    local l___model__2 = p9._model;
    local l___state__3 = p9._state;
    local v10 = {};
    for _, v11 in p9._config do
        local v12 = v11.Light or "light";
        if not table.find(v10, v12) then
            v10[#v10 + 1] = v12;
        end;
    end;
    local v13 = p9._config[l___state__3];
    local v14 = {};
    for _, v15 in v10 do
        local v16;
        if l___state__3 > 0 then
            v16 = v15 == (v13.Light or "light");
        else
            v16 = false;
        end;
        local v17 = v16 and (v13.Color or Color3.new(1, 1, 1)) or p9._colors[v15];
        local v18 = v16 and 0 or p9._transparencies[v15];
        local v19 = u1.Material[v16 and "Neon" or "SmoothPlastic"];
        local v20 = l___model__2[v15];
        v20.Material = v19;
        v20.Transparency = v18;
        v20.Color = v17;
        table.insert(v14, v20);
    end;
    local l___fpModel__4 = p9._fpModel;
    if l___fpModel__4 then
        if l___fpModel__4:IsDescendantOf(workspace) then
            for _, v21 in v10 do
                local v22;
                if l___state__3 > 0 then
                    v22 = v21 == (v13.Light or "light");
                else
                    v22 = false;
                end;
                local v23 = v22 and (v13.Color or Color3.new(1, 1, 1)) or p9._colors[v21];
                local v24 = v22 and 0 or p9._transparencies[v21];
                local v25 = u1.Material[v22 and "Neon" or "SmoothPlastic"];
                local v26 = l___fpModel__4[v21];
                v26.Material = v25;
                v26.Transparency = v24;
                v26.Color = v23;
            end;
        else
            l___fpModel__4:Destroy();
            p9._fpModel = nil;
        end;
    end;
    p9._lightModels = v14;
end;
function u8.new(p27, p28, p29, p30, p31) --[[ Line: 69 ]]
    -- upvalues: u8 (copy), u1 (copy)
    local v32 = setmetatable({
        _state = 0,
        _actor = p27,
        _config = p28,
        _lightModels = {}
    }, u8);
    local v33 = RaycastParams.new();
    v33.CollisionGroup = u1.PhysicsGroup.BulletCast;
    v33.FilterType = u1.RaycastFilterType.Exclude;
    local v34 = {};
    local v35;
    if p27 then
        v35 = p27.Character;
    else
        v35 = p27;
    end;
    v34[1], v34[2] = v35, p30.ParentModel;
    v33.FilterDescendantsInstances = v34;
    if p29 or not p30 then
        p30 = p30:GetChild(unpack(p29));
    end;
    local l__Model__5 = p30.Model;
    v32._model = l__Model__5;
    v32._transparencies = {};
    v32._colors = {};
    local v36 = {};
    for _, v37 in p28 do
        local v38 = v37.Light or "light";
        if not table.find(v36, v38) then
            v36[#v36 + 1] = v38;
        end;
    end;
    for _, v39 in v36 do
        if l__Model__5:FindFirstChild(v39) then
            v32._colors[v39] = l__Model__5[v39].Color;
            v32._transparencies[v39] = l__Model__5[v39].Transparency;
        elseif p27 then
            warn("weird actor behaviour - actor is alive: " .. (p27.Alive and "true" or "false") .. " actor is downed: " .. (p27.Downed and "true" or "false"));
        end;
    end;
    if p31 then
        local v40;
        if p29 or not p31 then
            v40 = p31:GetChild(unpack(p29));
        else
            v40 = p31;
        end;
        v32._fpModel = v40.Model;
        v33:AddToFilter(p31.ParentModel);
    end;
    v32._params = v33;
    return v32;
end;
function u8.SetState(p41, p42) --[[ Line: 120 ]]
    -- upvalues: u4 (copy)
    local v43 = p41._config[p42] or p41._config[p41._state];
    local l___activeModel__6 = p41._activeModel;
    if v43 and l___activeModel__6 then
        u4:CreateSound("Weapon_Interaction", l___activeModel__6, true, "Foley", "Weapon", "Button", v43.Button or "Soft", p42 == 0 and "Off" or "On").Destroy(2);
    end;
    p41._state = p42;
    p41:_updateModels();
end;
function u8.GetVPFModels(p44) --[[ Line: 132 ]]
    -- upvalues: u7 (copy), u1 (copy)
    local v45 = math.rad(p44._config[p44._state].Angle);
    local v46 = math.asin(v45) / 2;
    local v47 = {};
    for v48, v49 in p44._lightModels do
        local v50 = u7.Asset:Clone();
        v50.CFrame = v49.CFrame * CFrame.new(0, 0, -3);
        v50.Size = Vector3.new(v46, v46, 6);
        v50.Anchored = true;
        v50.Material = u1.Material.Neon;
        v50.Color = v49.Color;
        v50.Transparency = 0.85;
        v47[v48] = v50;
    end;
    return v47;
end;
function u8.Update(p51, _, p52, p53) --[[ Line: 157 ]]
    -- upvalues: u5 (copy), l__CurrentCamera__1 (copy), u6 (copy), u1 (copy)
    local v54 = p52 and p51._fpModel or p51._model;
    p51._activeModel = v54.PrimaryPart;
    if v54.Parent == nil then
    else
        local v55 = p51._config[p51._state];
        local l__Viewmodel__7 = u5.Viewmodel;
        if l__Viewmodel__7 then
            l__Viewmodel__7 = u5.Viewmodel.NVG;
        end;
        if p51._state == 0 or not p53 and (v55.IsIR and not l__Viewmodel__7) then
            if p51._lightObjects then
                for _, v56 in p51._lightObjects do
                    v56.Attachment:Destroy();
                end;
                p51._lightObjects = nil;
            end;
        else
            local v57 = v54[v55.Light or "light"];
            local l__Flare__8 = v57.Flare;
            if not p52 and l__Flare__8.WorldCFrame:ToObjectSpace(l__CurrentCamera__1.CFrame).Z < 0 then
                u6.Temp[l__Flare__8] = {
                    Color = v55.Color or Color3.new(1, 1, 1),
                    Intensity = v55.Brightness or 1
                };
            end;
            local l__WorldCFrame__9 = l__Flare__8.WorldCFrame;
            local l__Range__10 = v55.Range;
            local v58 = workspace:Raycast(l__WorldCFrame__9.Position, l__WorldCFrame__9.LookVector * l__Range__10, p51._params);
            if v58 then
                l__Range__10 = (l__WorldCFrame__9.Position - v58.Position).Magnitude;
            end;
            local v59 = math.max(60, l__Range__10 + 10);
            local v60 = v55.SegmentSize or 15;
            local v61 = (v59 - (60 - v60)) / v60;
            local v62 = v59 - v60 * math.floor(v61);
            local v63 = math.ceil(v61);
            if not p51._lightObjects then
                p51._lightObjects = {};
            end;
            local l___lightObjects__11 = p51._lightObjects;
            if v63 < #l___lightObjects__11 then
                for v64 = v63, #l___lightObjects__11 + 1, -1 do
                    l___lightObjects__11[v64].Attachment:Destroy();
                    table.remove(l___lightObjects__11, v64);
                end;
            elseif #l___lightObjects__11 < v63 then
                for v65 = #l___lightObjects__11 + 1, v63 do
                    local v66 = Instance.new("Attachment");
                    local v67 = Instance.new("SpotLight");
                    v67.Brightness = v55.Brightness or 1;
                    v67.Angle = v55.Angle or 20;
                    v67.Color = v55.Color or Color3.new(1, 1, 1);
                    v67.Face = u1.NormalId.Front;
                    v67.Shadows = true;
                    v67.Parent = v66;
                    l___lightObjects__11[v65] = {
                        Attachment = v66,
                        Light = v67
                    };
                end;
            end;
            local l___actor__12 = p51._actor;
            if l___actor__12 and not p52 then
                local l__ViewModel__13 = l___actor__12.ViewModel;
                if l__ViewModel__13 and l__ViewModel__13.Active then
                    v57 = l__ViewModel__13.Root;
                end;
            end;
            for v68 = 1, v63 do
                local v69 = l___lightObjects__11[v68];
                v69.Attachment.Parent = v57;
                v69.Attachment.WorldCFrame = l__WorldCFrame__9 + l__WorldCFrame__9.LookVector * (v60 * (v68 - 1));
                v69.Light.Range = v68 == v63 and v62 and v62 or 60;
                v69.Light.Color = v55.Color or Color3.new(1, 1, 1);
            end;
        end;
    end;
end;
function u8.Destroy(p70) --[[ Line: 244 ]]
    if p70._lightObjects then
        for _, v71 in p70._lightObjects do
            v71.Attachment:Destroy();
        end;
    end;
end;
return u8;