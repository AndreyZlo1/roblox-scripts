-- Services.PrefabService.HumanPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3 = shared.import("require", "asset", "Enum");
local u4 = v1("BotAppearance");
local u5 = v1("BaseComponent");
local u6 = v1("Menu");
local u7 = {
    11196453344,
    11196455899,
    11196459907,
    11196462300,
    11232222662
};
local u8 = {
    11232227375,
    11232229871,
    11232230975,
    11232233805
};
local u9 = {
    Shirt = {
        "LeftHand",
        "LeftLowerArm",
        "LeftUpperArm",
        "UpperTorso",
        "RightUpperArm",
        "RightLowerArm",
        "RightHand"
    },
    Pants = {
        "LeftFoot",
        "LeftLowerLeg",
        "LeftUpperLeg",
        "LowerTorso",
        "RightUpperLeg",
        "RightLowerLeg",
        "RightFoot"
    }
};
local u10 = {};
u10.__index = u10;
function u10._changeName(p11) --[[ Line: 63 ]]
    -- upvalues: u3 (copy)
    if p11._nameTag then
        p11._nameTag:Destroy();
        p11._nameTag = nil;
    end;
    local v12 = p11._human:GetAttribute("Name");
    if v12 then
        local l__Head__1 = p11._parts.Head;
        local v13 = Instance.new("BillboardGui");
        v13.Active = true;
        v13.ClipsDescendants = true;
        v13.ExtentsOffset = Vector3.new(0, 2.5, 0);
        v13.MaxDistance = 25;
        v13.Size = UDim2.fromScale(10, 0.7);
        v13.ZIndexBehavior = u3.ZIndexBehavior.Sibling;
        v13.Parent = l__Head__1;
        v13.Adornee = l__Head__1;
        local v14 = Instance.new("TextLabel");
        v14.BackgroundTransparency = 1;
        v14.FontFace = Font.new("rbxassetid://12187375422", u3.FontWeight.Bold, u3.FontStyle.Normal);
        v14.Size = UDim2.fromScale(1, 1);
        v14.Text = v12;
        v14.TextColor3 = Color3.new(1, 1, 1);
        v14.TextScaled = true;
        v14.TextStrokeTransparency = 0;
        v14.Parent = v13;
        p11._nameTag = v13;
    end;
end;
function u10._changeOutfit(p15, p16, p17) --[[ Line: 102 ]]
    -- upvalues: u2 (copy), u9 (copy)
    local l___parts__2 = p15._parts;
    local l__Asset__3 = u2:Get("Shared", "Models", "Outfit", p17, p16).Asset;
    local v18 = {};
    for _, v19 in u9[p17] do
        local v20 = l__Asset__3:Clone();
        v18[#v18 + 1] = v20;
        v20.Parent = l___parts__2[v19];
    end;
    p15._outfit[p17] = v18;
end;
function u10._createEquipWeld(p21, p22, p23, p24) --[[ Line: 114 ]]
    local v25 = p23:FindFirstChild("Anchor") or p23:FindFirstChild("anchor");
    local v26 = Instance.new("Weld");
    v26.Part0 = p21._parts[p22];
    v26.Part1 = p23;
    v26.C0 = p24 or CFrame.new();
    v26.C1 = v25.CFrame;
    v26.Parent = p23;
    p23.Name = "Part";
    v25:Destroy();
    return v26;
end;
function u10._changeGloves(p27, _, p28) --[[ Line: 128 ]]
    -- upvalues: u6 (copy), u2 (copy)
    local l___gloves__4 = p27._gloves;
    if l___gloves__4 then
        l___gloves__4.L:Destroy();
        l___gloves__4.R:Destroy();
        p27._gloves = nil;
    end;
    if p28 then
        local v29 = p28[2].Build[1][3];
        local l__Texture__5 = u6.Character.Gloves[v29].Camos[p28[2].Build[2].Camo or "Default"].Texture;
        local l___model__6 = p27._model;
        local v30 = u2:Get("Shared", "Models", "Character", "Arm", "Gloves", v29, "TP", "L").Asset:Clone();
        v30.TextureID = l__Texture__5;
        v30.CanQuery = false;
        v30.AudioCanCollide = false;
        v30.CanCollide = false;
        v30.CanTouch = false;
        v30.Parent = l___model__6;
        local v31 = u2:Get("Shared", "Models", "Character", "Arm", "Gloves", v29, "TP", "R").Asset:Clone();
        v31.TextureID = l__Texture__5;
        v31.CanQuery = false;
        v31.AudioCanCollide = false;
        v31.CanCollide = false;
        v31.CanTouch = false;
        v31.Parent = l___model__6;
        p27:_createEquipWeld("LeftHand", v30);
        p27:_createEquipWeld("RightHand", v31);
        p27._gloves = {
            L = v30,
            R = v31
        };
    end;
end;
function u10._changeBoots(p32, _, p33) --[[ Line: 167 ]]
    -- upvalues: u6 (copy), u2 (copy)
    local l___boots__7 = p32._boots;
    if l___boots__7 then
        l___boots__7.L:Destroy();
        l___boots__7.R:Destroy();
        p32._boots = nil;
    end;
    if p33 then
        local v34 = p33[2].Build[1][3];
        local l__Texture__8 = u6.Character.Boots[v34].Camos[p33[2].Build[2].Camo or "Default"].Texture;
        local l___model__9 = p32._model;
        local v35 = u2:Get("Shared", "Models", "Character", "Boot", v34, "L").Asset:Clone();
        v35.TextureID = l__Texture__8;
        v35.CanQuery = false;
        v35.AudioCanCollide = false;
        v35.CanCollide = false;
        v35.CanTouch = false;
        v35.Parent = l___model__9;
        local v36 = u2:Get("Shared", "Models", "Character", "Boot", v34, "R").Asset:Clone();
        v36.TextureID = l__Texture__8;
        v36.CanQuery = false;
        v36.AudioCanCollide = false;
        v36.CanCollide = false;
        v36.CanTouch = false;
        v36.Parent = l___model__9;
        p32:_createEquipWeld("LeftFoot", v35);
        p32:_createEquipWeld("RightFoot", v36);
        p32._boots = {
            L = v35,
            R = v36
        };
    end;
end;
function u10._updateLOD(p37, p38) --[[ Line: 207 ]]
    p37._lod = p38;
    local v39;
    if p38 then
        v39 = nil;
    else
        v39 = p37._model or nil;
    end;
    for _, v40 in {
        "Vest",
        "Belt",
        "Eyewear",
        "Earwear",
        "Facewear",
        "Backpack",
        "Wrist"
    } do
        if p37[v40] then
            p37[v40].Parent = v39;
        end;
    end;
end;
function u10._changeWearable(p41, p42, p43) --[[ Line: 218 ]]
    -- upvalues: u5 (copy)
    if p41[p42] then
        p41[p42]:Destroy();
        p41[p42] = nil;
        p41._hairCancels[p42] = nil;
        p41._faceCancels[p42] = nil;
        p41._balaclavaColor[p42] = nil;
    end;
    if p43 then
        local v44 = u5.Deserialize(p43[2].Build);
        if v44.Tune.NoHair then
            p41._hairCancels[p42] = true;
        end;
        if v44.Tune.NoFace then
            p41._faceCancels[p42] = true;
        end;
        if v44.Tune.BalaclavaColors then
            local v45 = "Default";
            for v46 in v44.CamoConfigs do
                v45 = v46;
                break;
            end;
            p41._balaclavaColor[p42] = v44.Tune.BalaclavaColors[v45];
        end;
        local l__ParentModel__10 = v44.ParentModel;
        p41:_createEquipWeld(p42 == "Wrist" and "LeftLowerArm" or ((p42 == "Vest" or p42 == "Backpack") and "UpperTorso" or (p42 == "Belt" and "LowerTorso" or "Head")), l__ParentModel__10.PrimaryPart);
        local v47;
        if p41._lod then
            v47 = nil;
        else
            v47 = p41._model or nil;
        end;
        l__ParentModel__10.Parent = v47;
        p41[p42] = l__ParentModel__10;
    end;
end;
function u10._updateSkin(p48) --[[ Line: 254 ]]
    local l__SkinColor__11 = p48.SkinColor;
    local l__Shirt__12 = p48._outfit.Shirt;
    if l__Shirt__12 and #l__Shirt__12 > 0 then
        for _, v49 in p48._balaclavaColor do
            l__SkinColor__11 = v49;
            break;
        end;
    end;
    p48._parts.UpperTorso.Color = l__SkinColor__11;
end;
function u10._updateFace(p50) --[[ Line: 267 ]]
    local v51 = false;
    for _ in p50._faceCancels do
        v51 = true;
        break;
    end;
    p50._parts.Head.Mouth.Transparency = v51 and 1 or 0;
end;
function u10._updateHair(p52) --[[ Line: 277 ]]
    -- upvalues: u2 (copy)
    local v53 = p52._hairColor or Color3.new(0, 0, 0);
    local v54 = false;
    for _ in p52._hairCancels do
        v54 = true;
        break;
    end;
    if v54 and p52._hairModel then
        p52._hairModel:Destroy();
        p52._hairModel = nil;
    elseif not v54 and (not p52._hairModel and p52._hair) then
        local v55 = u2:Get("Shared", "Models", "Appearance", "Hair", p52._hair).Asset:Clone();
        v55.Mesh.VertexColor = Vector3.new(v53.R, v53.G, v53.B);
        v55.CanCollide = false;
        v55.CanTouch = false;
        v55.AudioCanCollide = false;
        v55.CanQuery = false;
        v55.Parent = p52._model;
        local v56 = Instance.new("Weld");
        v56.Part0 = p52._parts.Head;
        v56.Part1 = v55;
        v56.C1 = v55.anchor.CFrame;
        v56.Parent = v55;
        p52._hairModel = v55;
    end;
    local v57 = false;
    for _ in p52._faceCancels do
        v57 = true;
        break;
    end;
    if v57 and p52._faceModel then
        p52._faceModel:Destroy();
        p52._faceModel = nil;
    else
        if not v57 and (not p52._faceModel and p52._facialHair) then
            local v58 = u2:Get("Shared", "Models", "Appearance", "FacialHair", p52._facialHair).Asset:Clone();
            v58.Mesh.VertexColor = Vector3.new(v53.R, v53.G, v53.B);
            v58.CanCollide = false;
            v58.CanTouch = false;
            v58.AudioCanCollide = false;
            v58.CanQuery = false;
            v58.Parent = p52._model;
            local v59 = Instance.new("Weld");
            v59.Part0 = p52._parts.Head;
            v59.Part1 = v58;
            v59.C1 = v58.anchor.CFrame;
            v59.Parent = v58;
            p52._faceModel = v58;
        end;
    end;
end;
function u10.new(p60) --[[ Line: 339 ]]
    -- upvalues: u2 (copy), u4 (copy), u10 (copy)
    local v61 = u2:Get("Shared", "Models", "Character", "Male").Asset:Clone();
    v61:PivotTo(p60.CFrame - Vector3.new(0, 0.45, 0));
    local v62 = Random.new();
    local v63 = u4[p60.Name] or u4.FAI_Rifleman;
    local v64 = v63.Bias[v62:NextInteger(1, #v63.Bias)];
    local v65 = v63.Appearance[v64];
    local v66 = v65.Gear[v62:NextInteger(1, #v65.Gear)];
    local v67 = v65.Clothes[v62:NextInteger(1, #v65.Clothes)];
    local v68 = v65.Skin[v62:NextInteger(1, #v65.Skin)];
    local v69 = {};
    for _, v70 in v61:GetChildren() do
        if v70:IsA("BasePart") then
            v69[v70.Name] = v70;
            v70.CanCollide = false;
            v70.CanQuery = false;
            v70.AudioCanCollide = false;
            v70.CanTouch = false;
            v70.Color = v68;
        end;
    end;
    local v71 = {};
    for _, v72 in p60:GetChildren() do
        if v72:IsA("Attachment") then
            local v73 = tonumber(v72.Name);
            if v73 ~= nil then
                local v74 = v73 == 1 and p60.CFrame or p60[tostring(v73 - 1)].WorldCFrame;
                local v75 = CFrame.new(v74.Position, (Vector3.new(v72.WorldPosition.X, v74.Y, v72.WorldPosition.Z)));
                v71[v73] = {
                    From = v75,
                    To = v75 - v75.Position + v72.WorldPosition,
                    Distance = (v74.Position - v72.WorldPosition).Magnitude
                };
            end;
        end;
    end;
    local l__Position__13 = p60.Position;
    local v76 = 0;
    if #v71 > 0 then
        local v77 = Vector3.new(0, 0, 0);
        for v78 = 1, #v71 do
            v71[v78].Total = v76;
            v76 = v76 + v71[v78].Distance;
            v77 = v77 + v71[v78].From.Position;
        end;
        l__Position__13 = v77 / #v71;
    end;
    local v79 = Instance.new("AnimationController");
    v79.Parent = v61;
    local v80 = Instance.new("Animator");
    v80.Parent = v79;
    local v81 = p60:GetAttribute("Speed") or 8;
    local v82 = {
        _loaded = false,
        _orientation = 0,
        _lastAnim = 0,
        _human = p60,
        _model = v61,
        _duration = v76 / v81,
        _speed = v81,
        _origin = l__Position__13,
        _total = v76,
        _path = v71,
        _parts = v69,
        _talking = p60:GetAttribute("Talking"),
        SkinColor = v68,
        _hair = v66.Hair,
        _facialHair = v66.FacialHair,
        _hairColor = v66.HairColor,
        _outfit = {},
        _hairCancels = {},
        _faceCancels = {},
        _balaclavaColor = {},
        _seed = v62,
        _animator = v80,
        _loadedAnimations = {}
    };
    local u83 = setmetatable(v82, u10);
    u83:_changeOutfit(v67.Shirt[v62:NextInteger(1, #v67.Shirt)], "Shirt");
    u83:_changeOutfit(v67.Pants[v62:NextInteger(1, #v67.Pants)], "Pants");
    if v66 then
        for _, v84 in {
            "Vest",
            "Helmet",
            "Facewear",
            "Eyewear",
            "Earwear",
            "Gloves",
            "Boots"
        } do
            if v66[v84] then
                if v84 == "Gloves" then
                    u83:_changeGloves(nil, {
                        "",
                        {
                            Build = v66[v84]
                        }
                    });
                elseif v84 == "Boots" then
                    u83:_changeBoots(nil, {
                        "",
                        {
                            Build = v66[v84]
                        }
                    });
                else
                    u83:_changeWearable(v84, {
                        "",
                        {
                            Build = v66[v84]
                        }
                    });
                end;
            end;
        end;
    end;
    u83:_updateHair();
    u83:_updateSkin();
    u83:_updateFace();
    local v85 = p60:GetAttribute("Emote");
    local v86 = p60:GetAttribute("Weapon");
    if v86 then
        local v87 = u2:Get("Shared", "Models", "LOD", "Weapon", v86).Asset:Clone();
        u83:_createEquipWeld("RightHand", v87, CFrame.new(-0.3, 0, -0.5) * CFrame.Angles(1.5707963267948966, 3.141592653589793, 3.141592653589793));
        v87.Parent = v61;
        v85 = v85 or "AI_KickGround";
    end;
    u83._idleEmote = v85 == "Downed" and "AI_Downed" or v85;
    p60.Transparency = 1;
    p60.CanCollide = false;
    p60.CanQuery = false;
    p60.AudioCanCollide = false;
    p60.CanTouch = false;
    u83:_changeName();
    u83._attConn = p60:GetAttributeChangedSignal("Name"):Connect(function() --[[ Line: 491 ]]
        -- upvalues: u83 (copy)
        u83:_changeName();
    end);
    return u83;
end;
function u10.LoadAnimation(p88, p89) --[[ Line: 498 ]]
    local v90 = p88._loadedAnimations[p89];
    if v90 then
        return v90;
    end;
    local v91 = Instance.new("Animation");
    v91.AnimationId = "rbxassetid://" .. p89;
    local v92 = p88._animator:LoadAnimation(v91);
    p88._loadedAnimations[p89] = v92;
    return v92;
end;
function u10.Destroy(p93) --[[ Line: 512 ]]
    p93._attConn:Disconnect();
    p93._model:Destroy();
end;
function u10.Update(p94, p95, p96) --[[ Line: 517 ]]
    -- upvalues: u2 (copy), u3 (copy), u7 (copy), u8 (copy)
    local l__Magnitude__14 = (p96 - p94._origin).Magnitude;
    if l__Magnitude__14 > 1024 then
        if p94._loaded then
            p94._loaded = false;
            p94._model.Parent = nil;
        end;
        return;
    end;
    local v97 = l__Magnitude__14 > 256;
    if v97 and not p94._lod then
        p94:_updateLOD(true);
    elseif not v97 and p94._lod then
        p94:_updateLOD(false);
    end;
    local l___path__15 = p94._path;
    local v98 = #l___path__15 > 0;
    if not p94._loaded then
        p94._loaded = true;
        p94._model.Parent = workspace;
        local v99 = 7082966514;
        local v100;
        if p94._idleEmote then
            v100 = u2:Get("Animation", "Emotes", p94._idleEmote, "Idle", "TP").ID;
            local v101 = p94:LoadAnimation(u2:Get("Animation", "CharacterPacks", "Unequipped", "Idle", "Standing").ID);
            v101.Priority = u3.AnimationPriority.Core;
            v101:Play(0);
        else
            v100 = v98 and 15543456284 or v99;
        end;
        local v102 = p94:LoadAnimation(v100);
        v102.Priority = u3.AnimationPriority.Idle;
        v102:Play(0);
        if v98 then
            v102:AdjustSpeed(p94._speed / 12);
        end;
    end;
    local v103 = workspace:GetServerTimeNow();
    if not v98 then
        local l___talking__16 = p94._talking;
        if p94._lastAnim < v103 and l___talking__16 then
            p94._lastAnim = v103 + p94._seed:NextNumber(4, l___talking__16 and 6 or 8);
            local v104 = l___talking__16 and u7 or u8;
            local v105 = p94:LoadAnimation(v104[p94._seed:NextInteger(1, #v104)]);
            v105.Priority = u3.AnimationPriority.Idle;
            v105:Play();
        end;
        return;
    end;
    local v106 = p94._total * (v103 % p94._duration / p94._duration);
    local v107 = l___path__15[1];
    for v108 = 1, #l___path__15 do
        local v109 = l___path__15[v108];
        if v109.Total <= v106 and v106 <= v109.Total + v109.Distance then
            v107 = v109;
            break;
        end;
    end;
    local v110 = v107.From:Lerp(v107.To, (v106 - v107.Total) / v107.Distance);
    local v111 = v110.Position - Vector3.new(0, 0.45, 0);
    local _, v112 = v110:ToOrientation();
    local l___orientation__17 = p94._orientation;
    local v113 = p95 * 10;
    local v114 = ((v112 - l___orientation__17) % 6.283185307179586 + 9.42477796076938) % 6.283185307179586 - 3.141592653589793;
    if math.abs(v114) >= 0.03490658503988659 then
        v112 = l___orientation__17 + v114 * math.min(1, v113);
    end;
    p94._orientation = v112;
    p94._model:PivotTo(CFrame.new(v111) * CFrame.Angles(0, p94._orientation, 0));
end;
return u10;