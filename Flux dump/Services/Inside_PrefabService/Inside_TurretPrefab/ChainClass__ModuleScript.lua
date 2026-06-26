-- Services.PrefabService.TurretPrefab.ChainClass
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _, _ = shared.import("require", "asset", "Enum");
local u2 = v1("EffectsService");
local u3 = v1("SoundService");
local u4 = v1("Turrets");
local l__Weapon__1 = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Particles"):WaitForChild("Weapon");
local l__Effects__2 = l__Weapon__1:WaitForChild("Effects");
local l__Eject__3 = l__Weapon__1:WaitForChild("Eject");
local l__Shell__4 = l__Weapon__1:WaitForChild("Shell");
local u5 = {};
u5.__index = u5;
function u5.new(p6, u7, p8, u9, p10, p11, p12) --[[ Line: 19 ]]
    -- upvalues: u5 (copy), l__Effects__2 (copy), l__Eject__3 (copy), u4 (copy), l__Shell__4 (copy), u2 (copy)
    local u13 = {};
    local v14 = {
        _rpm = 0,
        Length = p12 or 200,
        _model = u7,
        _last = tick(),
        _name = p6,
        _loadedAnimations = {},
        _currentBulletModels = u13
    };
    local u15 = setmetatable(v14, u5);
    if typeof(u9) ~= "table" then
        u9 = {};
        for _, v16 in {
            "Chain1",
            "Chain2",
            "Chain3",
            "Chain4",
            "Chain5",
            "Chain6",
            "Chain7"
        } do
            local v17 = p8:FindFirstChild(v16);
            if v17 then
                local v18 = Instance.new("Part");
                v18.Transparency = 1;
                v18.Name = v16;
                v18.Anchored = false;
                v18.Massless = true;
                v18.CanCollide = false;
                v18.CanTouch = false;
                v18.AudioCanCollide = false;
                v18.CanQuery = false;
                v18.Size = Vector3.new(0.2, 0.2, 0.2);
                v18.Parent = u7;
                u9[#u9 + 1] = v18;
                local v19 = Instance.new("Motor6D");
                v19.Part0 = p8;
                v19.Part1 = v18;
                v19.C0 = v17.WorldCFrame:ToObjectSpace(p8.CFrame):Inverse();
                v19.Parent = v18;
            end;
        end;
    end;
    if p10 then
        local v20 = Instance.new("AnimationController");
        v20.Parent = p10;
        Instance.new("Animator").Parent = v20;
        u15._animator = v20;
        local v21 = u7:FindFirstChild("tip");
        for _, v22 in l__Effects__2:GetChildren() do
            v22:Clone().Parent = v21;
        end;
        u15._muzzle = v21;
        local v23 = u7:FindFirstChild("eject");
        if v23 then
            for _, v24 in l__Eject__3:GetChildren() do
                v24:Clone().Parent = v23;
            end;
        end;
        u15._config = u4[p6];
    end;
    local v25 = p11 or u15._config.Link;
    if #u9 > 0 then
        local u26 = l__Shell__4[v25]:Clone();
        local u27 = u26.Size.X / 2;
        local u28 = true;
        u26.Anchored = true;
        u26.CanCollide = false;
        u26.CanQuery = false;
        u26.AudioCanCollide = false;
        u26.CanTouch = false;
        u15._uid = u2:RegisterEffect(p8, function(_, _, p29, _) --[[ Line: 101 ]]
            -- upvalues: u28 (ref), u13 (ref), u9 (ref), u15 (copy), u27 (copy), u26 (copy), u7 (copy)
            if p29 > 1 then
                if u28 and #u13 > 0 then
                    for v30 = 1, #u13 do
                        u13[v30]:Destroy();
                    end;
                    u13 = {};
                end;
                u28 = false;
                return;
            end;
            u28 = true;
            local v31 = 0;
            local v32 = {};
            for v33 = #u9, 2, -1 do
                local v34 = u9[v33];
                v31 = v31 + (v34.Position - u9[v33 - 1].Position).Magnitude;
                v32[#v32 + 1] = {
                    Start = v31,
                    From = v34.CFrame,
                    To = u9[v33 - 1].CFrame
                };
            end;
            local l__Length__5 = u15.Length;
            local v35 = math.floor(v31 / u27);
            local v36 = math.min(l__Length__5, v35);
            local v37 = nil;
            for v38 = v36, 1, -1 do
                if not u13[v38] then
                    local v39 = u26:Clone();
                    v39.Parent = u7;
                    u13[v38] = v39;
                end;
                local v40 = CFrame.new();
                local v41 = u13[v38];
                local v42 = v38 / (v31 / u27);
                local v43 = u27;
                local v44 = (u15._last + u15._rpm - tick()) / u15._rpm;
                local v45 = v42 + v43 * math.clamp(v44, 0, 1) / v31;
                for v46 = 1, #v32 do
                    local v47 = v32[v46];
                    if v45 < v47.Start / v31 then
                        local v48 = v32[v46 - 1] and (v32[v46 - 1].Start / v31 or 0) or 0;
                        v40 = v47.From:Lerp(v47.To, (v45 - v48) / (v47.Start / v31 - v48));
                        break;
                    end;
                end;
                local v49;
                if v37 then
                    local v50, _, _ = CFrame.new(v40.Position, v37.Position):ToOrientation();
                    v49 = -v50;
                else
                    v49 = 0;
                end;
                v41.CFrame = v40 * CFrame.Angles(v49, 0, 0) * v41.Anchor.CFrame;
                v37 = v40;
            end;
            if v36 < #u13 and #u13 > 0 then
                for v51 = #u13, v36, -1 do
                    if v51 > 0 then
                        u13[v51]:Destroy();
                        u13[v51] = nil;
                    end;
                end;
            end;
        end);
    end;
    return u15;
end;
function u5.Reload(p52, p53) --[[ Line: 174 ]]
    -- upvalues: u3 (copy)
    if p52._config then
        if p53 then
            local v54 = p52:LoadAnimation(p52._config.Animations[p53]);
            v54:Play();
            p52._reloadAnimation = v54;
            local v55 = u3:CreateSound("Weapon_Interaction", p52._muzzle, true, "Weapons", p52._name, "Handling", p53 == "Reload" and "Partial" or "Empty");
            v55.Destroy(20);
            p52._reloadSound = v55;
        else
            if p52._reloadAnimation then
                p52._reloadAnimation:Stop();
                p52._reloadAnimation = nil;
            end;
            if p52._reloadSound then
                p52._reloadSound.Sound:Destroy();
                p52._reloadSound = nil;
            end;
        end;
    end;
end;
function u5.LoadAnimation(p56, p57) --[[ Line: 199 ]]
    if p56._animator then
        local v58 = p56._loadedAnimations[p57];
        if v58 then
            return v58;
        end;
        local v59 = Instance.new("Animation");
        v59.AnimationId = "rbxassetid://" .. p57;
        local v60 = p56._animator:LoadAnimation(v59);
        p56._loadedAnimations[p57] = v60;
        return v60;
    end;
end;
function u5.Discharge(p61, p62, p63, p64, p65) --[[ Line: 217 ]]
    -- upvalues: u2 (copy)
    p61.Length = p62;
    p61._last = tick();
    p61._rpm = 60 / p63;
    local v66 = p61._config and u2:BulletFired(p61._model, p64, p61._name, p65, {
        Tune = {}
    });
    if v66 then
        v66(true);
    end;
end;
function u5.Destroy(p67) --[[ Line: 232 ]]
    -- upvalues: u2 (copy)
    if p67._uid then
        u2:UnregisterEffect(p67._uid);
    end;
    for v68 = 1, #p67._currentBulletModels do
        p67._currentBulletModels[v68]:Destroy();
    end;
end;
return u5;