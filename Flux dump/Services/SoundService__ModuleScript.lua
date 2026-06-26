-- Services.SoundService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3 = shared.import("require", "asset", "network");
local u4 = v1("ChannelPresets");
local u5 = v1("MasterPresets");
local u6 = v1("ReverbPresets");
local u7 = v1("SoundPresets");
local u8 = v1("EffectPresets");
local u9 = v1("DebugService");
local u10 = v1("WorldService");
local u11 = v1("Mathf");
local u12 = v1("Octree");
local l__Debris__1 = game:GetService("Debris");
local l__Lighting__2 = game:GetService("Lighting");
local l__SoundService__3 = game:GetService("SoundService");
local l__CurrentCamera__4 = workspace.CurrentCamera;
local u13 = {
    Zombies = { "BRM6_MUSIC_ZAMB_CALM1", "BRM6_MUSIC_ZAMB_RETRIBUTION", "BRM6_MUSIC_ZAMB_SOLACE" }
};
local u14 = {
    DelayTime = 0,
    DryLevel = 0,
    Feedback = 0,
    RampTime = 0,
    WetLevel = -80
};
local u15 = {
    DecayRatio = 0,
    DecayTime = 0,
    Density = 0,
    Diffusion = 0,
    DryLevel = 0,
    EarlyDelayTime = 0,
    HighCutFrequency = 20000,
    LateDelayTime = 0,
    LowShelfFrequency = 20,
    LowShelfGain = 0,
    ReferenceFrequency = 5000,
    WetLevel = -80
};
local u16 = {};
u16.__index = u16;
local function u21(p17) --[[ Line: 74 ]]
    local u18 = Instance.new("Audio" .. p17._type);
    for u19, u20 in p17 do
        if u19 ~= "_type" then
            pcall(function() --[[ Line: 82 ]]
                -- upvalues: u18 (copy), u19 (copy), u20 (copy)
                u18[u19] = u20;
            end);
        end;
    end;
    return u18;
end;
local function u32(p22, p23) --[[ Line: 90 ]]
    -- upvalues: u21 (copy)
    local v24 = {};
    local v25 = {};
    local v26 = nil;
    local v27 = nil;
    for v28 = 1, #p23 do
        local v29 = p23[v28];
        local v30 = u21(v29);
        if v29._sidechain then
            v24[#v24 + 1] = {
                "Sidechain",
                v29._sidechain,
                v30,
                v29
            };
        end;
        if v29._effect then
            v24[#v24 + 1] = {
                "Effect",
                v29._effect,
                v30,
                v29
            };
        end;
        v25[v28] = {
            Instance = v30,
            Properties = v29
        };
        v26 = v26 or v30;
        if v27 then
            local v31 = Instance.new("Wire");
            v31.SourceInstance = v27;
            v31.TargetInstance = v30;
            v31.Parent = v27;
        end;
        v30.Parent = p22;
        v27 = v30;
    end;
    return v26, v27, v24, v25;
end;
local function u35(p33, p34) --[[ Line: 142 ]]
    -- upvalues: u11 (copy)
    local l__Instance__5 = p33.Instance;
    local l__Properties__6 = p33.Properties;
    if l__Properties__6._type == "Equalizer" then
        l__Instance__5.HighGain = u11.Lerp(0, l__Properties__6.HighGain, p34);
        l__Instance__5.MidGain = u11.Lerp(0, l__Properties__6.MidGain, p34);
        l__Instance__5.LowGain = u11.Lerp(0, l__Properties__6.LowGain, p34);
    else
        if l__Properties__6._type == "Reverb" then
            l__Instance__5.DryLevel = u11.Lerp(1, l__Properties__6.DryLevel, p34);
            l__Instance__5.WetLevel = u11.Lerp(-40, l__Properties__6.WetLevel, p34);
            l__Instance__5.Bypass = p34 <= 0;
        end;
    end;
end;
function u16._zoneTrack(p36, p37, p38) --[[ Line: 156 ]]
    if p38 and not p37[p38] then
        p37[p38] = {
            Day = p36:CreateSound("Ambience", nil, false, "AmbienceTrack", p38, "Day").Sound,
            Night = p36:CreateSound("Ambience", nil, false, "AmbienceTrack", p38, "Night").Sound
        };
    end;
end;
function u16._loadSound(u39, p40) --[[ Line: 165 ]]
    -- upvalues: u2 (copy)
    for _, v41 in u39._zones do
        v41.Day:Destroy();
        v41.Night:Destroy();
    end;
    local v42 = {};
    for _, v43 in p40.Zones:GetDescendants() do
        if v43:IsA("BasePart") then
            u39:_zoneTrack(v42, (v43:GetAttribute("Ambience")));
        end;
    end;
    u39:_zoneTrack(v42, p40.Ambience);
    u39._octree:ClearNodes();
    u39._zones = v42;
    for _, v44 in u39._loading do
        v44();
    end;
    u39._loading = {};
    local l___soundBoxes__7 = u39._soundBoxes;
    l___soundBoxes__7:ClearAllChildren();
    local u45 = tick();
    for _, u46 in p40.Sounds:GetChildren() do
        local u47 = u46:GetAttribute("Sound");
        local v48, v49 = pcall(u2.Get, u2, "Sound", "Environment", u47);
        if v48 then
            local l__Asset__8 = v49.Asset;
            local l__Sound__9 = u39:CreateSound("Ambience", nil, false, "Environment", u47).Sound;
            local function u52(p50) --[[ Line: 202 ]]
                -- upvalues: u39 (copy), l__Sound__9 (copy), u46 (copy), l___soundBoxes__7 (copy), u47 (copy), l__Asset__8 (ref), u45 (copy)
                u39._loading[l__Sound__9] = nil;
                local v51 = Instance.new("Part");
                v51.Transparency = 1;
                v51.Anchored = true;
                v51.CanCollide = false;
                v51.CanQuery = false;
                v51.AudioCanCollide = false;
                v51.CanTouch = false;
                v51.Size = u46.Size;
                v51.CFrame = u46.CFrame;
                v51.Parent = l___soundBoxes__7;
                u39._octree:CreateNode(u46.Position, {
                    Box = v51,
                    Sound = u47,
                    Loop = l__Asset__8._loop,
                    Start = u45 + math.random(1, 120),
                    Length = p50,
                    Position = u46.Position
                });
            end;
            local u53 = false;
            task.spawn(function() --[[ Line: 124 ]]
                -- upvalues: u53 (ref), l__Sound__9 (copy), u52 (copy)
                while task.wait() do
                    if u53 then
                        return;
                    end;
                    if l__Sound__9.IsReady then
                        u52(l__Sound__9.TimeLength);
                        return;
                    end;
                end;
            end);
            u39._loading[l__Sound__9] = function() --[[ Line: 137 ]]
                -- upvalues: u53 (ref)
                u53 = true;
            end;
        end;
    end;
end;
function u16.new() --[[ Line: 230 ]]
    -- upvalues: u12 (copy), u16 (copy), u21 (copy), l__SoundService__3 (copy), u32 (copy), u5 (copy), l__CurrentCamera__4 (copy), u4 (copy), u10 (copy), u3 (copy), l__Debris__1 (copy)
    local v54 = Instance.new("Folder");
    v54.Parent = workspace;
    local v55 = {
        Rain = 0,
        IsInterior = false,
        _reverb = "None",
        _zone = 0,
        _lastTrack = 0,
        DiegeticMix = {},
        Effects = {},
        _octree = u12.new(),
        _effects = {},
        _volumetrics = {},
        _loading = {},
        _fadeOut = {},
        _zones = {},
        _channelVolume = {},
        _loadedSounds = {},
        _soundBoxes = v54
    };
    local u56 = setmetatable(v55, u16);
    local v57 = u21({
        _type = "DeviceOutput",
        Parent = l__SoundService__3
    });
    u56._masterDeviceOut = v57;
    local v58, v59, v60 = u32(v57, u5);
    local u61 = {};
    for _, v62 in v60 do
        u61[#u61 + 1] = v62;
    end;
    local v63 = Instance.new("Wire");
    v63.SourceInstance = v59;
    v63.TargetInstance = v57;
    v63.Parent = v59;
    local u64 = {};
    local function u80(p65, p66, p67) --[[ Line: 270 ]]
        -- upvalues: u21 (ref), l__SoundService__3 (ref), l__CurrentCamera__4 (ref), u56 (copy), u64 (copy), u32 (ref), u61 (copy), u80 (copy)
        local v68 = u21({
            _type = "Fader",
            Name = p66,
            Volume = p67._volume,
            Parent = l__SoundService__3
        });
        local v69 = u21({
            _type = "Listener",
            Name = p66,
            AudioInteractionGroup = p66,
            Parent = l__CurrentCamera__4
        });
        u56._channelVolume[p66] = p67._volume;
        u64[p66] = v68;
        local v70 = Instance.new("Wire");
        v70.SourceInstance = v69;
        v70.TargetInstance = v68;
        v70.Parent = v69;
        if #p67._effects > 0 then
            local v71, v72, v73 = u32(v68, p67._effects);
            for _, v74 in v73 do
                u61[#u61 + 1] = v74;
            end;
            local v75 = Instance.new("Wire");
            v75.SourceInstance = v68;
            v75.TargetInstance = v71;
            v75.Parent = v68;
            local v76 = Instance.new("Wire");
            v76.SourceInstance = v72;
            v76.TargetInstance = p65;
            v76.Parent = v72;
        else
            local v77 = Instance.new("Wire");
            v77.SourceInstance = v68;
            v77.TargetInstance = p65;
            v77.Parent = v68;
        end;
        for v78, v79 in p67._channels do
            u80(v68, v78, v79);
        end;
    end;
    u80(v58, "Non_diegetic", u4.Non_diegetic);
    local v81 = u21({
        _type = "Reverb",
        Parent = l__SoundService__3
    });
    u56._diegeticReverb = v81;
    local v82 = Instance.new("Wire");
    v82.SourceInstance = v81;
    v82.TargetInstance = v58;
    v82.Parent = v81;
    local v83 = u21({
        _type = "Echo",
        Parent = l__SoundService__3
    });
    u56._diegeticEcho = v83;
    local v84 = Instance.new("Wire");
    v84.SourceInstance = v83;
    v84.TargetInstance = v81;
    v84.Parent = v83;
    u80(v83, "Diegetic", u4.Diegetic);
    u56.Channels = u64;
    for _, v85 in u61 do
        local v86, v87, v88, v89 = unpack(v85);
        if v86 == "Sidechain" then
            local v90 = u64[v87];
            local v91 = Instance.new("Wire");
            v91.SourceInstance = v90;
            v91.TargetInstance = v88;
            v91.TargetName = "Sidechain";
            v91.Parent = v90;
        elseif v86 == "Effect" then
            if not u56.Effects[v87] then
                u56.Effects[v87] = {
                    Mix = 0,
                    Instances = {}
                };
            end;
            local l__Instances__10 = u56.Effects[v87].Instances;
            l__Instances__10[#l__Instances__10 + 1] = {
                Instance = v88,
                Properties = v89
            };
        end;
    end;
    local v92 = {
        Inside = {},
        Outside = {}
    };
    local v93 = {
        Inside = {},
        Outside = {}
    };
    for v94 = 1, 3 do
        v92.Inside[v94] = u56:CreateSound("Weather", nil, false, "Weather", "Rain", "Inside", "Inside" .. v94).Sound;
    end;
    for v95 = 1, 3 do
        v92.Outside[v95] = u56:CreateSound("Weather", nil, false, "Weather", "Rain", "Outside", "Outside" .. v95).Sound;
    end;
    v93.Inside[1] = u56:CreateSound("Weather", nil, false, "Weather", "Snow", "Inside", "Inside" .. 1).Sound;
    v93.Outside[1] = u56:CreateSound("Weather", nil, false, "Weather", "Snow", "Outside", "Outside" .. 1).Sound;
    u56._rains = v92;
    u56._snows = v93;
    u10.Changed:Connect(function(p96) --[[ Line: 367 ]]
        -- upvalues: u56 (copy)
        u56:_loadSound(p96);
    end);
    if u10.World then
        u56:_loadSound(u10.World);
    end;
    u3:ConnectEvents({
        PlaySound = function(p97, p98, ...) --[[ Name: PlaySound, Line 375 ]]
            -- upvalues: u56 (copy), l__Debris__1 (ref)
            local v99;
            if p97 then
                v99 = Instance.new("Attachment");
                v99.CFrame = CFrame.new(p97);
                v99.Parent = workspace.Terrain;
            else
                v99 = nil;
            end;
            u56:CreateSound("World", v99, true, ...).Destroy(p98);
            l__Debris__1:AddItem(v99, p98 + 1);
        end,
        PlayMusic = function(p100, p101) --[[ Name: PlayMusic, Line 387 ]]
            -- upvalues: u56 (copy)
            u56:PlayMusic(p100, p101);
        end,
        SetMixtape = function(p102) --[[ Name: SetMixtape, Line 390 ]]
            -- upvalues: u56 (copy)
            u56._mixtapeName = p102;
        end
    });
    u56:Reverb();
    return u56;
end;
function u16.Reverb(p103, p104) --[[ Line: 399 ]]
    -- upvalues: u9 (copy)
    p103._reverb = p104 or "None";
    if u9:IsEnabled() then
    end;
end;
function u16.Scape(p105, p106) --[[ Line: 427 ]]
    local l___scape__11 = p105._scape;
    if l___scape__11 and l___scape__11.Name ~= p106 then
        l___scape__11.Sound.FadeOut(3);
        p105._scape = nil;
    end;
    if p106 and not p105._scape then
        local v107 = p105:CreateSound("Ambience", nil, true, "Environment", p106);
        p105._scape = {
            Name = p106,
            Sound = v107,
            Player = v107.Sound,
            Volume = v107.Sound.Volume
        };
        v107.Sound.Volume = 0;
    end;
end;
function u16.PlayMusic(p108, p109, p110) --[[ Line: 446 ]]
    local v111 = tick();
    if p108._lastTrack < v111 or p110 then
        if p108._musicTrack then
            p108._musicTrack.FadeOut(5);
            p108._musicTrack = nil;
        end;
        if p109 and #p109 > 0 then
            local v112 = p108:CreateSound("GameMusic", nil, true, "Music", p109);
            p108._musicTrack = v112;
            p108._lastTrack = v111 + (v112.Duration or 180);
            return;
        end;
        p108._lastTrack = v111 + 60;
    end;
end;
function u16.CancelMusic(p113) --[[ Line: 464 ]]
    p113._fadeOutMusic = tick() + 20;
end;
function u16.GetChannelVolume(p114, p115) --[[ Line: 468 ]]
    return p114.Channels[p115].Volume / p114._channelVolume[p115];
end;
function u16.SetChannelVolume(p116, p117, p118) --[[ Line: 472 ]]
    p116.Channels[p117].Volume = p116._channelVolume[p117] * p118;
end;
function u16.SetEffectMix(p119, p120, p121) --[[ Line: 476 ]]
    if p119.Effects[p120] then
        p119.Effects[p120].Mix = p121;
    end;
end;
function u16.GetEffectMix(p122, p123) --[[ Line: 482 ]]
    return not p122.Effects[p123] and 0 or p122.Effects[p123].Mix;
end;
function u16.Update(p124, p125) --[[ Line: 489 ]]
    -- upvalues: u13 (copy), u11 (copy), u35 (copy), u6 (copy), u14 (copy), u15 (copy), l__CurrentCamera__4 (copy), l__Lighting__2 (copy)
    local v126 = tick();
    for v127, v128 in p124._fadeOut do
        if v128.Finish < v126 then
            p124._fadeOut[v127] = nil;
            v127:Destroy();
        else
            v127.Volume = v128.Volume * (1 - (v126 - v128.Start) / (v128.Finish - v128.Start));
        end;
    end;
    local l___musicTrack__12 = p124._musicTrack;
    if l___musicTrack__12 and (l___musicTrack__12.Sound.IsPlaying and (p124._fadeOutMusic and not l___musicTrack__12.Properties.NoFadeOut)) then
        if p124._fadeOutMusic < v126 then
            l___musicTrack__12.Sound.Volume = math.lerp(l___musicTrack__12.Sound.Volume, l___musicTrack__12.Volume, p125 / 4);
        else
            l___musicTrack__12.Sound.Volume = math.lerp(l___musicTrack__12.Sound.Volume, 0, p125 / 4);
        end;
    end;
    local l___mixtapeName__13 = p124._mixtapeName;
    if l___mixtapeName__13 and v126 - p124._lastTrack > 600 then
        local v129 = u13[l___mixtapeName__13];
        p124:PlayMusic(v129[math.random(1, #v129)]);
    end;
    local v130 = 1;
    for _, v131 in p124.DiegeticMix do
        v130 = v130 * v131;
    end;
    p124.Channels.Diegetic.Volume = v130;
    p124.Channels.Helicopter.Volume = u11.Lerp(p124.Channels.Helicopter.Volume, p124.DuckHelicopters and 0.2 or 1, p125 * 2);
    local l___scape__14 = p124._scape;
    if p124._scape then
        l___scape__14.Player.Volume = u11.Lerp(l___scape__14.Player.Volume, l___scape__14.Volume, p125);
    end;
    for _, v132 in p124.Effects do
        local l__Mix__15 = v132.Mix;
        for _, v133 in v132.Instances do
            u35(v133, l__Mix__15);
        end;
    end;
    local l___reverb__16 = p124._reverb;
    local v134 = u6[l___reverb__16] or u6.DEFAULT_EXTERIOR;
    local v135 = p125 * (l___reverb__16 == "None" and 2 or 5);
    local v136 = v134.Echo or {};
    for v137, v138 in u14 do
        if not v136[v137] then
            v136[v137] = v138;
        end;
    end;
    local l___diegeticEcho__17 = p124._diegeticEcho;
    l___diegeticEcho__17.DelayTime = u11.Lerp(l___diegeticEcho__17.DelayTime, v136.DelayTime, v135);
    l___diegeticEcho__17.DryLevel = u11.Lerp(l___diegeticEcho__17.DryLevel, v136.DryLevel, v135);
    l___diegeticEcho__17.Feedback = u11.Lerp(l___diegeticEcho__17.Feedback, v136.Feedback, v135);
    l___diegeticEcho__17.RampTime = u11.Lerp(l___diegeticEcho__17.RampTime, v136.RampTime, v135);
    l___diegeticEcho__17.WetLevel = u11.Lerp(l___diegeticEcho__17.WetLevel, v136.WetLevel, v135);
    local v139 = v134.Reverb or {};
    for v140, v141 in u15 do
        if not v139[v140] then
            v139[v140] = v141;
        end;
    end;
    local l___diegeticReverb__18 = p124._diegeticReverb;
    l___diegeticReverb__18.DecayRatio = u11.Lerp(l___diegeticReverb__18.DecayRatio, v139.DecayRatio, v135);
    l___diegeticReverb__18.DecayTime = u11.Lerp(l___diegeticReverb__18.DecayTime, v139.DecayTime, v135);
    l___diegeticReverb__18.Density = u11.Lerp(l___diegeticReverb__18.Density, v139.Density, v135);
    l___diegeticReverb__18.Diffusion = u11.Lerp(l___diegeticReverb__18.Diffusion, v139.Diffusion, v135);
    l___diegeticReverb__18.DryLevel = u11.Lerp(l___diegeticReverb__18.DryLevel, v139.DryLevel, v135);
    l___diegeticReverb__18.EarlyDelayTime = u11.Lerp(l___diegeticReverb__18.EarlyDelayTime, v139.EarlyDelayTime, v135);
    l___diegeticReverb__18.HighCutFrequency = u11.Lerp(l___diegeticReverb__18.HighCutFrequency, v139.HighCutFrequency, v135);
    l___diegeticReverb__18.LateDelayTime = u11.Lerp(l___diegeticReverb__18.LateDelayTime, v139.LateDelayTime, v135);
    l___diegeticReverb__18.LowShelfFrequency = u11.Lerp(l___diegeticReverb__18.LowShelfFrequency, v139.LowShelfFrequency, v135);
    l___diegeticReverb__18.LowShelfGain = u11.Lerp(l___diegeticReverb__18.LowShelfGain, v139.LowShelfGain, v135);
    l___diegeticReverb__18.ReferenceFrequency = u11.Lerp(l___diegeticReverb__18.ReferenceFrequency, v139.ReferenceFrequency, v135);
    l___diegeticReverb__18.WetLevel = u11.Lerp(l___diegeticReverb__18.WetLevel, v139.WetLevel, v135);
    local l__Position__19 = l__CurrentCamera__4.CFrame.Position;
    local l___volumetrics__20 = p124._volumetrics;
    for v142, v143 in l___volumetrics__20 do
        local l__Player__21 = v143.Player;
        local l__Origin__22 = v143.Origin;
        if l__Player__21.Parent == nil or l__Origin__22.Parent == nil then
            v142:Destroy();
            l___volumetrics__20[v142] = nil;
        else
            CFrame.new();
            local v144;
            if l__Origin__22:IsA("Attachment") then
                v144 = l__Origin__22.WorldCFrame;
            else
                v144 = l__Origin__22.CFrame;
            end;
            v142.CFrame = v142.CFrame:Lerp(v144, (math.clamp(p125 * 1125.33 / (l__Position__19 - v144.Position).Magnitude, 0, 1)));
        end;
    end;
    local v145 = l__Lighting__2:GetAttribute("IsSnowing") or false;
    local l___rains__23 = p124._rains;
    local l___snows__24 = p124._snows;
    local l__Rain__25 = p124.Rain;
    local l__IsInterior__26 = p124.IsInterior;
    local v146 = {};
    local v147 = nil;
    for v148, v149 in {
        Rain = l___rains__23,
        Snow = l___snows__24
    } do
        local v150 = v148 == "Snow";
        for v151, v152 in v149 do
            local v153 = v151 == "Inside";
            for v154, v155 in v152 do
                if v145 == v150 and (l__IsInterior__26 == v153 and v154 == l__Rain__25) then
                    v147 = v155;
                else
                    v146[#v146 + 1] = v155;
                end;
            end;
        end;
    end;
    local v156 = l__IsInterior__26 and 6 or 0.75;
    if v147 then
        if v147.IsPlaying then
            if v147.Volume < v156 then
                v147.Volume = v147.Volume + p125 * v156;
            else
                v147.Volume = v156;
            end;
        else
            v147.Volume = 0;
            v147:Play();
        end;
    end;
    for _, v157 in v146 do
        if v157.Volume > 0 then
            v157.Volume = v157.Volume - p125;
        elseif v157.IsPlaying then
            v157:Stop();
        end;
    end;
    local l___loadedSounds__27 = p124._loadedSounds;
    local v158 = p124._octree:RadiusSearch(l__Position__19, 512);
    for _, v159 in l___loadedSounds__27 do
        v159[2] = false;
    end;
    for v160 = 1, #v158 do
        local v161 = v158[v160];
        local v162 = l___loadedSounds__27[v161];
        if v162 then
            v162[2] = true;
            local v163 = v162[1];
            if v163.IsPlaying == false then
                if v163.Looping then
                    if v163.TimeLength > 0 then
                        v163:Play();
                    end;
                elseif v162[3] then
                    if tick() > v162[3] then
                        v162[3] = nil;
                        v163:Play();
                    end;
                elseif v161.Loop then
                    v162[3] = tick() + math.random(v161.Loop[1], v161.Loop[2]);
                end;
            end;
        else
            local l__Sound__28 = p124:CreateSound("Ambience", v161.Box, true, "Environment", v161.Sound).Sound;
            if l__Sound__28.Looping then
                l__Sound__28.TimePosition = (tick() - v161.Start) % v161.Length;
            end;
            l___loadedSounds__27[v161] = { l__Sound__28, true };
        end;
    end;
    for v164, v165 in l___loadedSounds__27 do
        if not v165[2] then
            v165[1]:Destroy();
            l___loadedSounds__27[v164] = nil;
        end;
    end;
    p124._zone = u11.Lerp(p124._zone, l__IsInterior__26 and 0.2 or 1, (math.min(p125 * 2, 1)));
    local l__ClockTime__29 = l__Lighting__2.ClockTime;
    local v166 = l__ClockTime__29 < 6 and 0 or (l__ClockTime__29 < 7 and l__ClockTime__29 - 6 or (l__ClockTime__29 < 18 and 1 or (l__ClockTime__29 < 19 and 19 - l__ClockTime__29 or 0)));
    local v167 = 1 - v166;
    for v168, v169 in p124._zones do
        local v170 = (v168 == p124.Ambience and 1 or 0) * p124._zone;
        local v171 = u11.Lerp(v169.Day.Volume, v170 * v166, p125);
        local v172 = u11.Lerp(v169.Night.Volume, v170 * v167, p125);
        v169.Day.Volume = v171;
        if v169.Day.IsPlaying and v171 < 0.05 then
            v169.Day:Stop();
        elseif not v169.Day.IsPlaying and v171 > 0.05 then
            v169.Day:Play();
        end;
        v169.Night.Volume = v172;
        if v169.Night.IsPlaying and v172 < 0.05 then
            v169.Night:Stop();
        elseif not v169.Night.IsPlaying and v172 > 0.05 then
            v169.Night:Play();
        end;
    end;
end;
function u16.CreateSound(u173, p174, u175, p176, ...) --[[ Line: 712 ]]
    -- upvalues: u2 (copy), l__SoundService__3 (copy), u7 (copy), u21 (copy), u11 (copy), l__CurrentCamera__4 (copy), u32 (copy), u8 (copy), u35 (copy)
    if typeof(u175) == "Instance" and not u175:IsDescendantOf(workspace) then
        local u177 = Instance.new("AudioPlayer");
        return {
            Region = 1,
            Volume = 0,
            Duration = 0,
            MaxDistance = 0,
            Sound = u177,
            Properties = {},
            AddEffect = function() --[[ Name: AddEffect, Line 722 ]] end,
            Destroy = function() --[[ Name: Destroy, Line 723 ]]
                -- upvalues: u177 (copy)
                u177:Destroy();
            end,
            FadeOut = function() --[[ Name: FadeOut, Line 724 ]]
                -- upvalues: u177 (copy)
                u177:Destroy();
            end,
            Play = function() --[[ Name: Play, Line 725 ]] end
        };
    end;
    local v178, v179 = pcall(u2.Get, u2, "Sound", ...);
    if not v178 then
        warn("[SoundService]: " .. "No sound found for " .. v179);
        v179 = {
            ID = 0,
            Asset = {}
        };
    end;
    local l___regions__30 = v179.Asset._regions;
    local l__ID__31 = v179.ID;
    if l__ID__31 == 0 then
        local u180 = Instance.new("AudioPlayer");
        return {
            Region = 1,
            Volume = 0,
            Duration = 0,
            MaxDistance = 0,
            Sound = u180,
            Properties = {},
            AddEffect = function() --[[ Name: AddEffect, Line 746 ]] end,
            Destroy = function() --[[ Name: Destroy, Line 747 ]]
                -- upvalues: u180 (copy)
                u180:Destroy();
            end,
            FadeOut = function() --[[ Name: FadeOut, Line 748 ]]
                -- upvalues: u180 (copy)
                u180:Destroy();
            end,
            Play = function() --[[ Name: Play, Line 749 ]] end
        };
    end;
    local u181 = Instance.new("AudioPlayer");
    u181.AssetId = "rbxassetid://" .. l__ID__31;
    u181.Parent = u175 or l__SoundService__3;
    local u182 = false;
    local u183 = nil;
    local u184 = nil;
    u184 = u181.AncestryChanged:Connect(function(_, p185) --[[ Line: 759 ]]
        -- upvalues: u182 (ref), u183 (ref), u184 (ref), u181 (copy)
        if p185 then
        else
            u182 = true;
            if u183 then
                task.cancel(u183);
                u183 = nil;
            end;
            u184:Disconnect();
            u184 = nil;
            u181:Stop();
        end;
    end);
    local v186 = table.clone(v179.Asset);
    local l__Preset__32 = v179.Asset.Preset;
    if l__Preset__32 and u7[l__Preset__32] then
        for v187, v188 in u7[l__Preset__32] do
            v186[v187] = v188;
        end;
    end;
    u181.Volume = v186.Volume or 1;
    if v186.Looped or v186.Looping then
        u181.Looping = true;
    end;
    if v186.ForceChannel then
        p174 = v186.ForceChannel;
    end;
    local v189;
    if u175 then
        v189 = u175:FindFirstChild("Emitter_" .. p174) or u21({
            _type = "Emitter",
            AudioInteractionGroup = p174,
            Name = "Emitter_" .. p174,
            Parent = u175
        });
    else
        v189 = nil;
    end;
    local l__VolumetricRadius__33 = v186.VolumetricRadius;
    local l__IsVolumetric__34 = v186.IsVolumetric;
    local v190 = 0;
    local u191 = nil;
    if u175 then
        if v186.DistanceAttenuation then
            v189:SetDistanceAttenuation(v186.DistanceAttenuation);
        else
            local v192 = v186.RollOffMinDistance or 10;
            v190 = v186.RollOffMaxDistance or 10000;
            local v193 = {};
            if (v186.RollOffMode or Enum.RollOffMode.InverseTapered) == Enum.RollOffMode.Linear then
                v193 = {
                    [v192] = 1,
                    [v190] = 0
                };
            else
                for v194 = 0, 15 do
                    local v195 = u11.Lerp(v192, v190, v194 / 15);
                    v193[math.floor(v195)] = 1 - (v194 / 15) ^ 2;
                end;
            end;
            v189:SetDistanceAttenuation(v193);
        end;
        if v186.AngleAttenuation then
            v189:SetAngleAttenuation(v186.AngleAttenuation);
        end;
        if not (l__IsVolumetric__34 or l__VolumetricRadius__33) then
            u191 = Instance.new("Wire");
            u191.SourceInstance = u181;
            u191.TargetInstance = v189;
            u191.Parent = u181;
        end;
    else
        local v196 = u173.Channels[p174];
        u191 = Instance.new("Wire");
        u191.SourceInstance = u181;
        u191.TargetInstance = v196;
        u191.Parent = u181;
    end;
    local l__Duration__35 = v186.Duration;
    local v197 = 1;
    if l___regions__30 then
        if not v179.Asset._regionfix then
            local l___last__36 = v179.Asset._last;
            local v198 = {};
            for v199 in l___regions__30 do
                if v199 ~= l___last__36 then
                    v198[#v198 + 1] = v199;
                end;
            end;
            if #v198 == 0 then
                warn("[SoundService]: " .. "No regions found for " .. l__ID__31);
            end;
            v197 = v198[math.random(1, #v198)];
            v179.Asset._last = v197;
        end;
        local v200 = v197 == 1 and 0 or l___regions__30[v197 - 1];
        local v201 = l___regions__30[v197] - 0.01;
        u181.PlaybackRegion = NumberRange.new(v200, v201);
        l__Duration__35 = v201 - v200;
    end;
    local function u205(p202) --[[ Line: 872 ]]
        -- upvalues: u182 (ref), u183 (ref), u175 (copy), l__CurrentCamera__4 (ref), u181 (copy)
        if u182 then
        else
            if u183 then
                task.cancel(u183);
                u183 = nil;
            end;
            if not p202 and u175 then
                local v203;
                if u175:IsA("Attachment") then
                    v203 = u175.WorldPosition;
                else
                    v203 = u175.Position;
                end;
                p202 = (l__CurrentCamera__4.CFrame.Position - v203).Magnitude;
            end;
            local v204 = p202 and p202 / 1125.33 or 0;
            if v204 == v204 and v204 > 0 then
                u183 = task.delay(v204, function() --[[ Line: 895 ]]
                    -- upvalues: u183 (ref), u181 (ref)
                    u183 = nil;
                    u181:Play();
                end);
            else
                u181:Play();
            end;
        end;
    end;
    if u175 then
        Vector3.new();
        local v206;
        if u175:IsA("Attachment") then
            v206 = u175.WorldPosition;
        else
            v206 = u175.Position;
        end;
        if l__VolumetricRadius__33 then
            local v207 = Instance.new("Part");
            v207.Shape = Enum.PartType.Ball;
            v207.Size = Vector3.new(l__VolumetricRadius__33 * 2, l__VolumetricRadius__33 * 2, l__VolumetricRadius__33 * 2);
            v207.Name = "VOLUMETRIC_RADIUS";
            v207.CanCollide = false;
            v207.CanQuery = false;
            v207.AudioCanCollide = false;
            v207.CanTouch = false;
            v207.Anchored = true;
            v207.Massless = false;
            v207.Transparency = 1;
            v207.CFrame = CFrame.new(v206);
            v207.Parent = workspace;
            u181.Parent = v207;
            for _, v208 in {
                Vector3.new(0, 0, 0),
                Vector3.new(l__VolumetricRadius__33, 0, 0),
                Vector3.new(-l__VolumetricRadius__33, 0, 0),
                Vector3.new(0, 0, l__VolumetricRadius__33),
                Vector3.new(0, 0, -l__VolumetricRadius__33),
                Vector3.new(0, l__VolumetricRadius__33, 0),
                (Vector3.new(0, -l__VolumetricRadius__33, 0))
            } do
                local v209 = Instance.new("Attachment");
                v209.Visible = false;
                v209.CFrame = CFrame.new(v208);
                v209.Parent = v207;
                local v210 = v189:Clone();
                v210.Parent = v209;
                u191 = Instance.new("Wire");
                u191.SourceInstance = u181;
                u191.TargetInstance = v210;
                u191.Parent = u181;
            end;
            u173._volumetrics[v207] = {
                Player = u181,
                Origin = u175
            };
        elseif l__IsVolumetric__34 and u175:IsA("BasePart") then
            local l__Size__37 = u175.Size;
            local v211 = Instance.new("Part");
            v211.Shape = Enum.PartType.Block;
            v211.Size = l__Size__37;
            v211.Name = "IS_VOLUMETRIC";
            v211.CanCollide = false;
            v211.CanQuery = false;
            v211.AudioCanCollide = false;
            v211.CanTouch = false;
            v211.Anchored = true;
            v211.Massless = false;
            v211.Transparency = 1;
            v211.CFrame = u175.CFrame;
            v211.Parent = workspace;
            u181.Parent = v211;
            local v212 = v189:Clone();
            v212.Parent = v211;
            u191 = Instance.new("Wire");
            u191.SourceInstance = u181;
            u191.TargetInstance = v212;
            u191.Parent = u181;
            u173._volumetrics[v211] = {
                Player = u181,
                Origin = u175
            };
        end;
    end;
    if p176 then
        u205();
    end;
    local u213 = nil;
    return {
        Loaded = true,
        Region = v197,
        Sound = u181,
        Volume = u181.Volume,
        Duration = l__Duration__35,
        MaxDistance = v190,
        Properties = v186,
        ApplyEffect = function(p214) --[[ Name: ApplyEffect, Line 994 ]]
            -- upvalues: u182 (ref), u191 (ref), u32 (ref), u181 (copy), u8 (ref), u35 (ref)
            if not u182 then
                local l__TargetInstance__38 = u191.TargetInstance;
                local v215, v216, _, u217 = u32(u181, u8[p214]);
                u191.TargetInstance = v215;
                local v218 = Instance.new("Wire");
                v218.SourceInstance = v216;
                v218.TargetInstance = l__TargetInstance__38;
                v218.Parent = v216;
                return function(p219) --[[ Line: 1004 ]]
                    -- upvalues: u217 (copy), u35 (ref)
                    for _, v220 in u217 do
                        u35(v220, p219);
                    end;
                end;
            end;
        end,
        Destroy = function(p221) --[[ Name: Destroy, Line 1010 ]]
            -- upvalues: u182 (ref), u213 (ref), u183 (ref), u181 (copy)
            if u182 then
            else
                if u213 then
                    task.cancel(u213);
                    u213 = nil;
                end;
                if p221 then
                    u213 = task.delay(p221, function() --[[ Line: 1021 ]]
                        -- upvalues: u183 (ref), u181 (ref), u182 (ref)
                        if u183 then
                            task.cancel(u183);
                            u183 = nil;
                        end;
                        u181:Stop();
                        u181:Destroy();
                        u182 = true;
                    end);
                else
                    u181:Stop();
                    u181:Destroy();
                    u182 = true;
                end;
            end;
        end,
        FadeOut = function(p222) --[[ Name: FadeOut, Line 1037 ]]
            -- upvalues: u182 (ref), u173 (copy), u181 (copy)
            if u182 then
            else
                local v223 = tick();
                u173._fadeOut[u181] = {
                    Volume = u181.Volume,
                    Start = v223,
                    Finish = v223 + (p222 or 1)
                };
            end;
        end,
        Play = function(p224) --[[ Name: Play, Line 1049 ]]
            -- upvalues: u205 (copy)
            u205(p224);
        end,
        Stop = function() --[[ Name: Stop, Line 1052 ]]
            -- upvalues: u181 (copy)
            u181:Stop();
        end
    };
end;
return u16.new();