-- Services.EnvironmentService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4 = shared.import("require", "Enum", "network", "asset");
local u5 = v1("WorldService");
local u6 = v1("SoundService");
local u7 = v1("GameShellProxyService");
local u8 = v1("Mathf");
v1("LensFlares");
local u9 = v1("SkyboxPresets");
v1("GameSettings");
local u10 = v1("WaveCalculator");
local u11 = v1("ViewmodelService");
local u12 = v1("PostProcessingService");
v1("LensFlareManager");
local u13 = v1("LunarPhases");
local u14 = v1("AtmospherePresets");
local l__CollectionService__1 = game:GetService("CollectionService");
local l__ReplicatedFirst__2 = game:GetService("ReplicatedFirst");
local l__Lighting__3 = game:GetService("Lighting");
local l__Players__4 = game:GetService("Players");
local l__Debris__5 = game:GetService("Debris");
local l__Lerp__6 = u8.Lerp;
local l__UserGameSettings__7 = UserSettings():GetService("UserGameSettings");
local u15 = script:WaitForChild("RainChunk"):Clone();
local l__PlayerGui__8 = l__Players__4.LocalPlayer:WaitForChild("PlayerGui");
local l__CurrentCamera__9 = workspace.CurrentCamera;
local l__Terrain__10 = workspace.Terrain;
local u16 = {};
u16.__index = u16;
function u16._replicateLightning(p17, p18, u19) --[[ Line: 91 ]]
    -- upvalues: u2 (copy), l__Terrain__10 (copy), l__Debris__5 (copy), l__CurrentCamera__9 (copy), u6 (copy)
    local v20 = Instance.new("ImageHandleAdornment");
    v20.Color3 = Color3.fromRGB(181, 209, 243);
    v20.Transparency = 0.4;
    v20.AdornCullingMode = u2.AdornCullingMode.Never;
    v20.AlwaysOnTop = true;
    v20.CFrame = CFrame.new(u19.X, 7000, u19.Y) * CFrame.Angles(-1.5707963267948966, 0, 0);
    v20.Image = "rbxassetid://12726360088";
    v20.Parent = l__Terrain__10;
    v20.Adornee = l__Terrain__10;
    v20.Size = Vector2.new(80000, 80000);
    v20.ZIndex = -1;
    p17._bolt = v20;
    l__Debris__5:AddItem(v20, 0.5);
    local l__Position__11 = l__CurrentCamera__9.CFrame.Position;
    local v21;
    if p18 > 1 then
        v21 = (Vector2.new(l__Position__11.X, l__Position__11.Z) - u19).Magnitude < 10000;
    else
        v21 = false;
    end;
    l__Debris__5:AddItem(u6:CreateSound("Weather", nil, true, "Weather", "Thunder", v21 and "Close" or "Far").Sound, 15);
    if p18 > 1 then
        for v22 = 1, 7 do
            task.delay(v22 * 0.05, function() --[[ Line: 114 ]]
                -- upvalues: u2 (ref), u19 (ref), l__Terrain__10 (ref), l__Debris__5 (ref)
                local v23 = Instance.new("ImageHandleAdornment");
                v23.Color3 = Color3.fromRGB(181, 209, 243);
                v23.Transparency = 0.1;
                v23.AdornCullingMode = u2.AdornCullingMode.Never;
                v23.AlwaysOnTop = true;
                local v24 = CFrame.new(u19.X, 6900, u19.Y);
                local l__Angles__12 = CFrame.Angles;
                local v25 = math.random(-360, 360);
                v23.CFrame = v24 * l__Angles__12(0, math.rad(v25), 0) * CFrame.Angles(-1.5707963267948966, 0, 0);
                v23.Image = "rbxassetid://12726299456";
                v23.Parent = l__Terrain__10;
                v23.Adornee = l__Terrain__10;
                v23.Size = Vector2.new(15000, 15000);
                v23.ZIndex = -1;
                u19 = u19 + Vector2.new(math.random(-7000, 7000), math.random(-7000, 7000));
                l__Debris__5:AddItem(v23, 0.05);
            end);
        end;
    end;
end;
function u16._setSkybox(p26, p27) --[[ Line: 134 ]]
    -- upvalues: u9 (copy)
    local l___sky__13 = p26._sky;
    local v28 = u9[p27 or "Default"];
    l___sky__13.MoonAngularSize = v28.MoonAngularSize;
    l___sky__13.SunAngularSize = v28.SunAngularSize;
    l___sky__13.StarCount = v28.StarCount;
    l___sky__13.SkyboxBk = v28.SkyboxBk;
    l___sky__13.SkyboxDn = v28.SkyboxDn;
    l___sky__13.SkyboxFt = v28.SkyboxFt;
    l___sky__13.SkyboxLf = v28.SkyboxLf;
    l___sky__13.SkyboxRt = v28.SkyboxRt;
    l___sky__13.SkyboxUp = v28.SkyboxUp;
end;
function u16._updateRainDensity(p29, p30) --[[ Line: 150 ]]
    -- upvalues: u6 (copy), l__UserGameSettings__7 (copy), u15 (copy), l__ReplicatedFirst__2 (copy)
    local v31 = p30 and math.floor(p30) or 0;
    if v31 >= 7 then
        u6.Rain = 3;
    elseif v31 >= 4 then
        u6.Rain = 2;
    elseif v31 >= 1 then
        u6.Rain = 1;
    else
        u6.Rain = 0;
    end;
    p29.RainDensity = v31;
    if l__UserGameSettings__7.SavedQualityLevel.Value <= 5 then
        v31 = math.ceil(v31 / 2);
    end;
    if v31 < p29._rainDensity then
        for v32 = p29._rainDensity, v31 + 1, -1 do
            p29._rainActors[v32]:SetAttribute("Enabled", false);
            p29._rainActors[v32] = nil;
        end;
    elseif p29._rainDensity < v31 then
        for v33 = p29._rainDensity + 1, v31 do
            local v34 = Instance.new("Actor");
            local v35 = u15:Clone();
            v35:SetAttribute("Enabled", true);
            v35.Disabled = false;
            v35.Parent = v34;
            v34.Parent = l__ReplicatedFirst__2;
            p29._rainActors[v33] = v35;
        end;
    end;
    p29._rainDensity = v31;
end;
function u16._registerLight(u36, u37) --[[ Line: 186 ]]
    -- upvalues: u2 (copy)
    if u37:IsA("BasePart") and u37:IsDescendantOf(workspace) then
        local function u45(p38) --[[ Line: 191 ]]
            -- upvalues: u37 (copy), u2 (ref), u36 (copy)
            local l__Parent__14 = p38.Parent;
            if not l__Parent__14:IsA("Attachment") then
                l__Parent__14 = Instance.new("Attachment");
                l__Parent__14.Parent = u37;
                p38.Parent = l__Parent__14;
            end;
            local v39 = u37:FindFirstChildWhichIsA("Beam");
            local v40 = u37:FindFirstChild("Ground");
            local v41;
            if v40 then
                v41 = Instance.new("ImageHandleAdornment");
                v41.CFrame = u37.CFrame:ToObjectSpace(CFrame.new(v40.WorldPosition, v40.WorldPosition + Vector3.new(0, 1, 0)));
                v41.Size = Vector2.new(50, 50);
                v41.Color3 = p38.Color;
                v41.Image = "rbxassetid://9554734703";
                v41.Visible = false;
                v41.Adornee = u37;
                v41.Parent = u37;
            else
                v41 = nil;
            end;
            local u42 = not u37:GetAttribute("NoFlare");
            local u43 = {
                Intensity = 0,
                On = u37.Material == u2.Material.Neon,
                Size = u37:GetAttribute("Size") or 4,
                LightAttachment = l__Parent__14,
                LightObject = p38,
                LightPart = u37,
                Color = u37.Color,
                Position = u37.Position,
                DoShadows = p38.Shadows,
                Beam = v39,
                Ground = v41,
                Transparency = v39 and (v39.Transparency or 0) or 0,
                DoFlare = u42,
                LightOn = p38.Enabled
            };
            if v39 then
                v39 = v39.Enabled;
            end;
            u43.BeamOn = v39;
            u43.Connections = {};
            local function u44() --[[ Line: 243 ]]
                -- upvalues: u42 (ref), u43 (copy), u37 (ref)
                if u42 then
                    if u43.On then
                        u37:SetAttribute("LensFlareStrength", 0.75);
                        u37:SetAttribute("LensFlareSize", 0.5);
                        u37:SetAttribute("LensFlareStyle", "Small");
                        u37:AddTag("LensFlare");
                    else
                        u37:RemoveTag("LensFlare");
                    end;
                end;
            end;
            u43.Connections[#u43.Connections + 1] = u37:GetPropertyChangedSignal("CFrame"):Connect(function() --[[ Line: 258 ]]
                -- upvalues: u43 (copy), u37 (ref)
                u43.Position = u37.Position;
            end);
            u43.Connections[#u43.Connections + 1] = u37:GetPropertyChangedSignal("Material"):Connect(function() --[[ Line: 261 ]]
                -- upvalues: u43 (copy), u37 (ref), u2 (ref), u44 (copy)
                u43.On = u37.Material == u2.Material.Neon;
                u44();
            end);
            u44();
            u36._lights[#u36._lights + 1] = u43;
        end;
        local v46 = u37:FindFirstChildWhichIsA("Light", true);
        if v46 then
            u45(v46);
        else
            u36._tempLights[u37] = u37.DescendantAdded:Connect(function(p47) --[[ Line: 272 ]]
                -- upvalues: u36 (copy), u37 (copy), u45 (copy)
                if p47:IsA("Light") then
                    u36._tempLights[u37]:Disconnect();
                    u36._tempLights[u37] = nil;
                    task.defer(u45, p47);
                end;
            end);
        end;
    end;
end;
function u16._unregisterLight(p48, p49) --[[ Line: 286 ]]
    if p48._tempLights[p49] then
        p48._tempLights[p49]:Disconnect();
        p48._tempLights[p49] = nil;
    end;
    local l___lights__15 = p48._lights;
    local v50 = nil;
    for v54 = 1, #l___lights__15 do
        local v52 = l___lights__15[v54];
        if v52.LightPart == p49 then
            v50 = v54;
            for _, v53 in v52.Connections do
                v53:Disconnect();
                local v54 = v50;
                v50 = v54;
            end;
            break;
        end;
    end;
    if v50 then
        table.remove(l___lights__15, v50);
    end;
end;
function u16._registerEnvironment(p55, p56) --[[ Line: 311 ]]
    if p56:IsA("BasePart") then
        local l__CFrame__16 = p56.CFrame;
        local l__Size__17 = p56.Size;
        local v57 = p56:GetAttribute("InteriorTail");
        local v58 = p56:GetAttribute("ExteriorTail");
        if v57 and #v57 == 0 then
            v57 = nil;
        end;
        if v58 and #v58 == 0 then
            v58 = nil;
        end;
        p55._environments[{
            IsInterior = p56:GetAttribute("Interior"),
            ExplosionTail = p56:GetAttribute("ExplosionTail"),
            InteriorTail = v57,
            ExteriorTail = v58,
            DuckHelicopters = p56.Name == "ZNYC_SHIP_ConcreteMedium",
            Reverb = p56:GetAttribute("Reverb"),
            Sound = p56:GetAttribute("Sound"),
            Size = p56.Size.Magnitude
        }] = function(p59) --[[ Line: 337 ]]
            -- upvalues: l__CFrame__16 (copy), l__Size__17 (copy)
            local v60 = l__CFrame__16:PointToObjectSpace(p59);
            return math.abs(v60.X) <= l__Size__17.X / 2 and (math.abs(v60.Y) <= l__Size__17.Y / 2 and math.abs(v60.Z) <= l__Size__17.Z / 2);
        end;
    end;
end;
function u16._registerZone(p61, p62) --[[ Line: 349 ]]
    if p62:IsA("BasePart") then
        p61._zones[#p61._zones + 1] = {
            IsSnowing = p62.Name == "Snow",
            Ambience = p62:GetAttribute("Ambience"),
            Atmosphere = p62:GetAttribute("Atmosphere"),
            Radius = p62:GetAttribute("Radius") or p62.Size.X / 2,
            Position = p62.Position
        };
    end;
end;
function u16._unloadEnvironment(p63) --[[ Line: 363 ]]
    if p63._environmentConnection then
        p63._environmentConnection:Disconnect();
    end;
    p63._environments = {};
    if p63._zoneConnection then
        p63._zoneConnection:Disconnect();
    end;
    p63._zones = {};
end;
function u16._loadEnvironment(u64, p65) --[[ Line: 375 ]]
    u64:_unloadEnvironment();
    u64._environmentConnection = p65.Environments.DescendantAdded:Connect(function(p66) --[[ Line: 378 ]]
        -- upvalues: u64 (copy)
        u64:_registerEnvironment(p66);
    end);
    for _, v67 in p65.Environments:GetDescendants() do
        u64:_registerEnvironment(v67);
    end;
    u64._zoneConnection = p65.Zones.DescendantAdded:Connect(function(p68) --[[ Line: 385 ]]
        -- upvalues: u64 (copy)
        u64:_registerZone(p68);
    end);
    for _, v69 in p65.Zones:GetDescendants() do
        u64:_registerZone(v69);
    end;
end;
function u16.new() --[[ Line: 393 ]]
    -- upvalues: u7 (copy), u2 (copy), l__CurrentCamera__9 (copy), l__Lighting__3 (copy), l__Terrain__10 (copy), u5 (copy), l__PlayerGui__8 (copy), u12 (copy), u16 (copy), u3 (copy), u6 (copy), l__CollectionService__1 (copy), l__UserGameSettings__7 (copy)
    local v70 = u7:CreateProxy(1, u2.ShellPriority.AlwaysVisible, "EnvironmentService");
    local v71 = Instance.new("ImageLabel");
    v71.Size = UDim2.fromScale(1, 1);
    v71.Position = UDim2.new();
    v71.BackgroundTransparency = 1;
    v71.ImageTransparency = 1;
    v71.Image = "rbxassetid://9573916361";
    v71.Parent = v70;
    local v72 = Instance.new("ImageLabel");
    v72.Size = UDim2.fromScale(1, 1);
    v72.Position = UDim2.new();
    v72.BackgroundTransparency = 1;
    v72.ImageTransparency = 1;
    v72.Image = "rbxasset://textures/ui/TopBar/WhiteOverlayAsset.png";
    v72.ImageColor3 = Color3.new();
    v72.Parent = v70;
    local v73 = Instance.new("ImageLabel");
    v73.Size = UDim2.fromScale(1, 1);
    v73.Position = UDim2.new();
    v73.BackgroundTransparency = 1;
    v73.ImageTransparency = 1;
    v73.Image = "rbxasset://textures/ui/TopBar/WhiteOverlayAsset.png";
    v73.ImageColor3 = Color3.new();
    v73.Parent = v70;
    local v74 = RaycastParams.new();
    v74.FilterType = u2.RaycastFilterType.Blacklist;
    v74.FilterDescendantsInstances = { l__CurrentCamera__9 };
    v74.CollisionGroup = u2.PhysicsGroup.BulletCast;
    v74.IgnoreWater = false;
    local v75 = Instance.new("Sky");
    v75.SunTextureId = "rbxasset://sky/sun.jpg";
    v75.CelestialBodiesShown = true;
    v75.Parent = l__Lighting__3;
    local v76 = Instance.new("Clouds");
    v76.Parent = l__Terrain__10;
    local v77 = Instance.new("SunRaysEffect");
    v77.Intensity = 0.2;
    v77.Spread = 0.03;
    v77.Parent = l__Lighting__3;
    local v78 = Instance.new("Atmosphere");
    v78.Density = 0;
    v78.Color = Color3.new();
    v78.Decay = Color3.new();
    v78.Glare = 0;
    v78.Haze = 0;
    v78.Parent = l__Lighting__3;
    local v79 = Instance.new("Highlight");
    v79.FillColor = Color3.new(1, 1, 1);
    v79.FillTransparency = 0.2;
    v79.OutlineTransparency = 1;
    v79.Adornee = u5.ActiveWorld;
    v79.DepthMode = u2.HighlightDepthMode.Occluded;
    v79.Enabled = false;
    v79.Parent = l__PlayerGui__8;
    local v80 = u12:AddBrightness();
    local v81 = u12:AddBlur();
    local v82 = u12:AddColorCorrection({}, 1);
    u12:AddBloom({
        Intensity = 0.25,
        Size = 56,
        Threshold = 0.8
    });
    local v83 = u12:AddColorCorrection({
        Saturation = -1
    }, 2);
    v83.Enabled = false;
    local v84 = u12:AddBloom({
        Intensity = 0.2,
        Size = 21,
        Threshold = 0.2
    });
    v84.Enabled = false;
    local u85 = setmetatable({
        DoLights = true,
        FLIR = false,
        Vehicles = {},
        Actors = {},
        Temp = {},
        Flares = {},
        Smokers = {},
        BulletClack = 0,
        BulletOffset = Vector3.new(0, 0, 0),
        RainDensity = 0,
        _environments = {},
        _zones = {},
        _rainDensity = 0,
        _rainActors = {},
        _ui = v70,
        _sky = v75,
        _dirt = v71,
        _rays = v77,
        _vignette = v72,
        _suppression = v73,
        _atmosphere = v78,
        _clouds = v76,
        _lensParams = v74,
        _brightness = v80,
        _blur = v81,
        _colorCorrection = v82,
        _lastDensity = 0,
        _blurSize = 0,
        _flir = { v79, v83, v84 },
        _frame = 1,
        _cache = {},
        _tempLights = {},
        _lights = {},
        _lens = {}
    }, u16);
    u3:ConnectEvents({
        ReplicateLightning = function(p86, p87) --[[ Name: ReplicateLightning, Line 530 ]]
            -- upvalues: u85 (copy)
            if u85._weatherOverride then
            else
                u85:_replicateLightning(p86, p87);
            end;
        end,
        ReplicateGust = function() --[[ Name: ReplicateGust, Line 536 ]]
            -- upvalues: u85 (copy), u6 (ref)
            if u85._weatherOverride then
            else
                u6:CreateSound("Weather", nil, true, "Weather", "Gust").Destroy(8);
            end;
        end
    });
    l__CollectionService__1:GetInstanceRemovedSignal("LightActive"):Connect(function(p88) --[[ Line: 545 ]]
        -- upvalues: u85 (copy)
        u85:_unregisterLight(p88);
    end);
    l__CollectionService__1:GetInstanceAddedSignal("LightActive"):Connect(function(p89) --[[ Line: 548 ]]
        -- upvalues: u85 (copy)
        u85:_registerLight(p89);
    end);
    for _, v90 in l__CollectionService__1:GetTagged("LightActive") do
        u85:_registerLight(v90);
    end;
    local function v91() --[[ Line: 555 ]]
        -- upvalues: u85 (copy), l__Lighting__3 (ref)
        if u85._weatherOverride then
        else
            u85:_updateRainDensity(l__Lighting__3:GetAttribute("RainDensity"));
        end;
    end;
    l__UserGameSettings__7.Changed:Connect(v91);
    l__Lighting__3:GetAttributeChangedSignal("RainDensity"):Connect(v91);
    if not u85._weatherOverride then
        u85:_updateRainDensity(l__Lighting__3:GetAttribute("RainDensity"));
    end;
    u5.Changed:Connect(function(p92) --[[ Line: 566 ]]
        -- upvalues: u85 (copy)
        u85:_loadEnvironment(p92);
    end);
    if u5.World then
        u85:_loadEnvironment(u5.World);
    end;
    u85:_setSkybox(l__Lighting__3:GetAttribute("Skybox"));
    return u85;
end;
function u16.SetOverride(p93, p94) --[[ Line: 577 ]]
    -- upvalues: l__Lighting__3 (copy)
    p93._weatherOverride = p94;
    if p94 then
        p93:_setSkybox(p94.Skybox);
        p93:_updateRainDensity(p94.RainDensity);
        local l___atmosphere__18 = p93._atmosphere;
        local v95;
        if p94.NoColors then
            v95 = nil;
        else
            v95 = l__Lighting__3 or nil;
        end;
        l___atmosphere__18.Parent = v95;
    else
        p93:_setSkybox(l__Lighting__3:GetAttribute("Skybox"));
        p93:_updateRainDensity(l__Lighting__3:GetAttribute("RainDensity"));
        p93._atmosphere.Parent = l__Lighting__3;
    end;
end;
function u16.GetRoom(p96, p97) --[[ Line: 590 ]]
    local v98 = {};
    for v99, v100 in p96._environments do
        if v100(p97) then
            v98[#v98 + 1] = { v99, v99.Size };
        end;
    end;
    table.sort(v98, function(p101, p102) --[[ Line: 598 ]]
        return p101[2] < p102[2];
    end);
    local v103 = v98[1];
    if v103 then
        v103 = v98[1][1];
    end;
    return v103;
end;
function u16.Update(p104, p105, p106) --[[ Line: 606 ]]
    -- upvalues: l__CurrentCamera__9 (copy), l__Lighting__3 (copy), u10 (copy), u5 (copy), u13 (copy), l__Terrain__10 (copy), u6 (copy), u11 (copy), u14 (copy), l__Lerp__6 (copy), u8 (copy), u4 (copy)
    debug.profilebegin("Environment");
    debug.profilebegin("Weather");
    local l__Position__19 = l__CurrentCamera__9.CFrame.Position;
    local v107 = p104._weatherOverride or {
        ShowUnderWater = true,
        LunarPhase = l__Lighting__3:GetAttribute("LunarPhase") or 1,
        CloudDensity = l__Lighting__3:GetAttribute("CloudDensity") or 0.7,
        CloudCover = l__Lighting__3:GetAttribute("CloudCover") or 0.5,
        ClockTime = l__Lighting__3:GetAttribute("ClockTime"),
        FogDensity = l__Lighting__3:GetAttribute("FogDensity")
    };
    local v108;
    if l__Position__19.Y - 1 < u10:GetWaveHeight(l__Position__19, true) + u5.World.Water.Height then
        v108 = u5:InWater(l__Position__19);
    else
        v108 = false;
    end;
    local v109 = v107.ShowUnderWater and v108;
    p104.UnderWater = v109;
    local l__LunarPhase__20 = v107.LunarPhase;
    p104._sky.MoonTextureId = "rbxassetid://" .. u13[l__LunarPhase__20][1];
    local l__ClockTime__21 = v107.ClockTime;
    local v110 = l__ClockTime__21 < 6 and 0 or (l__ClockTime__21 < 7 and l__ClockTime__21 - 6 or (l__ClockTime__21 < 18 and 1 or (l__ClockTime__21 < 19 and (19 - l__ClockTime__21 or 0) or 0)));
    l__Lighting__3.ClockTime = l__ClockTime__21;
    local l___bolt__22 = p104._bolt;
    local v111 = 0;
    if l___bolt__22 then
        if l___bolt__22.Parent == l__Terrain__10 then
            v111 = math.random(100, 800) / 1000;
            l___bolt__22.Transparency = 1 - v111;
        else
            p104._bolt = nil;
        end;
    end;
    local v112 = 1 - v110;
    local v113 = l__ClockTime__21 < 3.2 and 0 or (l__ClockTime__21 < 4.2 and l__ClockTime__21 - 3.2 or (l__ClockTime__21 < 5.2 and (5.2 - l__ClockTime__21 or 0) or 0));
    debug.profileend();
    debug.profilebegin("Room");
    local v114 = {};
    if p106 then
        local l__Position__23 = p106.CFrame.Position;
        for v115, v116 in p104._environments do
            if v116(l__Position__23) then
                v114[#v114 + 1] = { v115, v115.Size };
            end;
        end;
    end;
    table.sort(v114, function(p117, p118) --[[ Line: 659 ]]
        return p117[2] < p118[2];
    end);
    local v119 = v114[1];
    if v119 then
        v119 = v114[1][1];
    end;
    if v119 ~= p104._room then
        if v119 then
            u6.IsInterior = v119.IsInterior;
            u6.InteriorTail = v119.InteriorTail;
            u6.ExteriorTail = v119.ExteriorTail;
            u6:Reverb(v119.Reverb);
            u6:Scape(v119.Sound);
        else
            u6.IsInterior = false;
            u6.InteriorTail = nil;
            u6.ExteriorTail = nil;
            u6:Reverb();
            u6:Scape();
        end;
    end;
    local v120 = u6;
    local v121;
    if v119 then
        v121 = v119.DuckHelicopters or false;
    else
        v121 = false;
    end;
    v120.DuckHelicopters = v121;
    p104._room = v119;
    local l__Snowing__24 = u5.World.Snowing;
    local l__Ambience__25 = u5.World.Ambience;
    local l__Atmosphere__26 = u5.World.Atmosphere;
    local v122 = 0;
    for _, v123 in p104._zones do
        local l__Magnitude__27 = (l__Position__19 - v123.Position).Magnitude;
        local l__Radius__28 = v123.Radius;
        if l__Magnitude__27 < l__Radius__28 then
            l__Ambience__25 = v123.Ambience or l__Ambience__25;
            l__Atmosphere__26 = v123.Atmosphere or l__Atmosphere__26;
            v122 = 1 - math.max(l__Magnitude__27 - l__Radius__28 * 0.8, 0) / (l__Radius__28 * 0.2);
            if v122 > 0.5 and v123.IsSnowing then
                l__Snowing__24 = true;
            end;
            break;
        end;
    end;
    l__Lighting__3:SetAttribute("IsSnowing", l__Snowing__24);
    u6.Ambience = l__Ambience__25;
    debug.profileend();
    debug.profilebegin("Atmosphere");
    if u11.Viewmodel then
        p104._vignette.ImageTransparency = 1 - u11.Viewmodel.CQB * 0.3;
    else
        p104._vignette.ImageTransparency = 1;
    end;
    local v124 = 1 - p104.BulletClack;
    p104.BulletClack = math.clamp(p104.BulletClack - p105 / 4, 0, 1);
    p104.BulletOffset = p104.BulletOffset:Lerp(Vector3.new(0, 0, 0), 1 - p104.BulletClack);
    p104._suppression.ImageTransparency = v124;
    local v125 = u14[u5.World.Atmosphere];
    local v126 = u14[l__Atmosphere__26];
    l__Lighting__3.GeographicLatitude = v107.GeographicLatitude or (v125.GeographicLatitude or 76);
    local l___weatherOverride__29 = p104._weatherOverride;
    if l___weatherOverride__29 then
        l___weatherOverride__29 = p104._weatherOverride.Atmosphere;
    end;
    if l___weatherOverride__29 then
        v125 = u14[l___weatherOverride__29];
        v126 = u14[l___weatherOverride__29];
    end;
    local v127 = l__Lerp__6(v125.Density, v126.Density, v122);
    local l__Night__30 = v125.Night;
    local v128 = Color3.fromRGB(l__Night__30[1], l__Night__30[2], l__Night__30[3]);
    local l__Color__31 = v125.Color;
    local v129 = v128:Lerp(Color3.fromRGB(l__Color__31[1], l__Color__31[2], l__Color__31[3]), v110);
    local l__Night__32 = v126.Night;
    local v130 = Color3.fromRGB(l__Night__32[1], l__Night__32[2], l__Night__32[3]);
    local l__Color__33 = v126.Color;
    local v131 = v129:Lerp(v130:Lerp(Color3.fromRGB(l__Color__33[1], l__Color__33[2], l__Color__33[3]), v110), v122);
    local l__Decay__34 = v125.Decay;
    local v132 = Color3.fromRGB(l__Decay__34[1], l__Decay__34[2], l__Decay__34[3]);
    local l__Decay__35 = v126.Decay;
    local v133 = v132:Lerp(Color3.fromRGB(l__Decay__35[1], l__Decay__35[2], l__Decay__35[3]), v122);
    local v134 = l__Lerp__6(v125.Glare, v126.Glare, v122);
    local v135 = l__Lerp__6(v125.Haze, v126.Haze, v122);
    local v136 = 0.5 - v127;
    local v137 = 0;
    if l__ClockTime__21 > 5 and l__ClockTime__21 < 6.5 then
        v137 = (l__ClockTime__21 - 5) / 1.5;
    elseif l__ClockTime__21 >= 6.5 and l__ClockTime__21 < 8 then
        v137 = 1 - (l__ClockTime__21 - 6.5) / 1.5;
    end;
    if l__ClockTime__21 > 16 and l__ClockTime__21 < 17 then
        v137 = l__ClockTime__21 - 16;
    elseif l__ClockTime__21 >= 17 and l__ClockTime__21 < 18 then
        v137 = 1 - (l__ClockTime__21 - 17);
    end;
    local l___clouds__36 = p104._clouds;
    l___clouds__36.Density = v107.CloudDensity;
    l___clouds__36.Cover = v107.CloudCover;
    l___clouds__36.Color = Color3.fromRGB(41, 47, 61):Lerp(Color3.new(1, 1, 1), v110):Lerp(Color3.fromRGB(225, 188, 173), v137);
    local v138 = l__Lerp__6;
    local l___lastDensity__37 = p104._lastDensity;
    local v139 = v127 + v136 * v107.FogDensity / 10;
    local v140 = math.min(1, p105);
    p104._lastDensity = math.max(v127, v138(l___lastDensity__37, v139, v140));
    local l___atmosphere__38 = p104._atmosphere;
    l___atmosphere__38.Density = v109 and 0.8 or p104._lastDensity;
    l___atmosphere__38.Color = v131:Lerp(Color3.fromRGB(199, 199, 199), v137);
    l___atmosphere__38.Decay = v133:Lerp(Color3.fromRGB(92, 60, 13), v137):Lerp(Color3.fromRGB(204, 221, 235), 1 - v110);
    l___atmosphere__38.Glare = l__Lerp__6(v134, 1.5, v137);
    l___atmosphere__38.Haze = l__Lerp__6(v135, 1, v137);
    l___atmosphere__38.Offset = 0;
    local l___colorCorrection__39 = p104._colorCorrection;
    local v141 = v125.ColorCorrection or {
        Contrast = 0,
        Brightness = 0,
        Saturation = 0,
        TintColor = Color3.new(1, 1, 1)
    };
    local v142 = v126.ColorCorrection or {
        Contrast = 0,
        Brightness = 0,
        Saturation = 0,
        TintColor = Color3.new(1, 1, 1)
    };
    local v143 = 0;
    local v144 = false;
    for v145 in p104.Smokers do
        local l__Magnitude__40 = (l__Position__19 - v145.Model.Position).Magnitude;
        if v145.Range >= l__Magnitude__40 then
            local l__Range__41 = v145.Range;
            local v146 = l__Range__41 - math.min(l__Range__41, 40);
            local v147 = l__Magnitude__40 < v146 and 1 or 1 - (l__Magnitude__40 - v146) / (l__Range__41 - v146);
            v144 = v145.Danger and true or v144;
            local v148 = v147 * (math.clamp((v145.Damage or 100) / 100, 0, 1) * 0.5 + 0.5);
            v143 = math.max(v148, v143);
        end;
    end;
    local v149 = false;
    local v150;
    if p106 and (next(p106.GasMask) and not v144) then
        v150 = true;
        local v151 = 0;
        local l__Inventory__42 = p104.Inventory;
        if l__Inventory__42 then
            for _, v152 in l__Inventory__42.Storages do
                for _, v153 in v152.Sections do
                    for _, v154 in v153 do
                        local l__MetaData__43 = v154.MetaData;
                        if l__MetaData__43.DurabilityType == "Filter" then
                            local v155 = l__MetaData__43.DurabilityMax / 4;
                            if l__MetaData__43.Durability > 0 then
                                v149 = true;
                                if v155 < l__MetaData__43.Durability then
                                    v151 = 0.8;
                                else
                                    v151 = math.max(v151, l__MetaData__43.Durability / v155 * 0.8);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        v143 = v143 * (1 - v151);
    else
        v150 = false;
    end;
    p104.SmokeText = v143 > 0 and (not v150 or (not v149 or v144)) and (v144 and "AREA TOO TOXIC" or (v150 and "NO MASK FILTERS" or "USE A GAS MASK")) or "";
    l___colorCorrection__39.Contrast = l__Lerp__6(l__Lerp__6(v141.Contrast, v142.Contrast, v122), -0.5, v143);
    l___colorCorrection__39.Brightness = l__Lerp__6(v141.Brightness, v142.Brightness, v122);
    l___colorCorrection__39.Saturation = -0.3 * (p104.RainDensity / 10) + l__Lerp__6(v141.Saturation, v142.Saturation, v122);
    l___colorCorrection__39.TintColor = (v109 and Color3.fromRGB(106, 220, 255) or v141.TintColor:Lerp(v142.TintColor, v122)):Lerp(Color3.fromRGB(255, 136, 57), v143);
    local l__FLIR__44 = p104.FLIR;
    local v156 = (1 - v110) * 0.5;
    local v157 = Color3.new(v156, v156, v156);
    if not v107.NoColors then
        l__Lighting__3.ColorShift_Top = l__FLIR__44 and v157 and v157 or (v125.ColorShift or Color3.new()):Lerp(v126.ColorShift or Color3.new(), v122):Lerp(Color3.fromRGB(253, 123, 101), v137);
        l__Lighting__3.OutdoorAmbient = l__FLIR__44 and v157 and v157 or (v125.OutdoorAmbient or Color3.new()):Lerp(v126.OutdoorAmbient or Color3.new(), v122):Lerp(Color3.fromRGB(181, 209, 243), v111 / 10);
    end;
    local l___rays__45 = p104._rays;
    local l__DoLights__46 = p104.DoLights;
    if l__DoLights__46 then
        l__DoLights__46 = not v107.NoColors;
    end;
    l___rays__45.Enabled = l__DoLights__46;
    p104._blurSize = l__Lerp__6(p104._blurSize, v119 and 0 or p104.RainDensity / 10 * 5, p105);
    p104._blur.Size = (v109 and 20 or p104._blurSize) + v143 * 10;
    p104._brightness.Size = l__Lerp__6(v110 * 0.5 + v112 * u13[l__LunarPhase__20][2], 0, v113) + v111 * 5 + u8.Lerp(v125.Brightness or 0, v126.Brightness or 0, v122);
    for _, v158 in p104._flir do
        v158.Enabled = l__FLIR__44;
    end;
    local v159 = tick();
    if l__Snowing__24 and p104.RainDensity > 0 then
        if not p104._snowPart then
            local v160 = Instance.new("Part");
            v160.Transparency = 1;
            v160.Anchored = true;
            v160.Size = Vector3.new(50, 30, 50);
            v160.CanCollide = false;
            v160.CanTouch = false;
            v160.CanQuery = false;
            v160.Parent = workspace;
            p104._snowPart = v160;
            local v161 = u4:Get("Shared", "Particles", "Foliage", "Snow").Asset:Clone();
            v161.Parent = v160;
            local v162 = u4:Get("Shared", "Particles", "Foliage", "SnowSmall").Asset:Clone();
            v162.Parent = v160;
            p104._snowEmitter = {
                [v161] = v161.Rate,
                [v162] = v162.Rate
            };
        end;
        local v163 = math.clamp(p104.RainDensity / 5, 0, 1);
        for v164, v165 in p104._snowEmitter do
            v164.Rate = v165 * v163;
            v164.Enabled = not u6.IsInterior;
        end;
        p104._snowPart.CFrame = CFrame.new(l__CurrentCamera__9.CFrame.Position + Vector3.new(30, 10, 0));
    elseif p104._snowPart then
        if p104._destroySnow then
            if p104._destroySnow < v159 then
                p104._snowPart:Destroy();
                p104._snowPart = nil;
                p104._snowEmitter = nil;
                p104._destroySnow = nil;
            end;
        else
            for v166 in p104._snowEmitter do
                v166.Enabled = false;
            end;
            p104._destroySnow = v159 + 5;
        end;
    end;
    debug.profileend();
    debug.profilebegin("Lens");
    local v167 = 1 - v110;
    local v168 = NumberSequence.new({ NumberSequenceKeypoint.new(0, v110), NumberSequenceKeypoint.new(0.7, 1 - v167 * 0.1), NumberSequenceKeypoint.new(1, 1) });
    for _, v169 in p104._lights do
        local l__On__47 = v169.On;
        local l__Magnitude__48 = (l__Position__19 - v169.Position).Magnitude;
        local l__Beam__49 = v169.Beam;
        if l__Beam__49 and (v169.Transparency ~= v168 or v169.BeamOn ~= l__On__47) then
            l__Beam__49.Transparency = v168;
            v169.Transparency = v168;
            l__Beam__49.Enabled = l__On__47;
            v169.BeamOn = l__On__47;
        end;
        if v169.LightOn ~= l__On__47 then
            v169.LightOn = l__On__47;
            v169.LightObject.Enabled = l__On__47;
        end;
        local l__Ground__50 = v169.Ground;
        if l__Ground__50 then
            local v170 = l__On__47 and (1 - math.max(v167, 0.2) * 0.8 * math.clamp((l__Magnitude__48 - 200) / 300, 0, 1) or 1) or 1;
            if v169.Intensity ~= v170 then
                l__Ground__50.Visible = l__Magnitude__48 > 200;
                l__Ground__50.Transparency = v170;
                v169.Intensity = v170;
            end;
        end;
    end;
    local v171 = p104._oldLens or {};
    local v172 = {};
    for v173, v174 in p104.Vehicles do
        v172[v173] = v174;
    end;
    for v175, v176 in p104.Flares do
        v172[v175] = v176;
    end;
    for v177, v178 in p104.Temp do
        v172[v177] = v178;
        p104.Temp[v177] = nil;
    end;
    for v179 in v171 do
        if not v172[v179] then
            v179:RemoveTag("LensFlare");
        end;
    end;
    for v180, v181 in v172 do
        if not v171[v180] then
            v180:SetAttribute("LensFlareSize", v181.Size or 1);
            v180:SetAttribute("LensFlareColor", v181.Color);
            v180:SetAttribute("LensFlareStrength", (v181.Intensity or 3.5) / 8);
            v180:SetAttribute("LensFlareStyle", v181.Style or "Small");
            v180:AddTag("LensFlare");
        end;
    end;
    p104._oldLens = v172;
    p104._ui.Visible = true;
    debug.profileend();
    debug.profileend();
end;
return u16.new();