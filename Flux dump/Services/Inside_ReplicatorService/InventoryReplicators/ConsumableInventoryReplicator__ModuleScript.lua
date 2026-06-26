-- Services.ReplicatorService.InventoryReplicators.ConsumableInventoryReplicator
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4 = shared.import("require", "asset", "Enum", "frc");
local u5 = v1("SoundService");
local u6 = v1("FluidSimulation");
local u7 = v1("SpringQuaternion");
local u8 = v1("QuaternionBetter");
local u9 = v1("ItemLayout");
local u10 = v1("Consumables");
local u11 = {};
u11.__index = u11;
function u11.new(p12, p13) --[[ Line: 21 ]]
    -- upvalues: u9 (copy), u10 (copy), u2 (copy), u7 (copy), u8 (copy), u11 (copy)
    local _ = u9[p13.Name];
    local v14 = u10[p13.Name:sub(11)];
    local v15 = u2:Get("Shared", "Models", "Consumables", v14.Model).Asset:Clone();
    for v16, v17 in v14.Texture do
        v15[v16].TextureID = v17;
    end;
    local v18 = {
        _percentage = 0,
        _lerpedPercentage = 0,
        _modelName = v14.Model,
        _fizzy = v14.IsFizzy,
        _max = v14.Uses,
        _item = p13,
        _actor = p12,
        _model = v15,
        _primary = v15.PrimaryPart,
        _tpSpring = u7.new(u8.fromCFrame(CFrame.new()), 0.34, 12),
        _fpSpring = u7.new(u8.fromCFrame(CFrame.new()), 0.34, 12)
    };
    local v19 = setmetatable(v18, u11);
    if v14.Fluid then
        local l__Fluid__1 = v15:WaitForChild("Fluid");
        l__Fluid__1.Color = v14.Fluid;
        v19._fluid = l__Fluid__1.Size;
    end;
    local v20 = Instance.new("Motor6D");
    v20.Part0 = p12.Parts.RightHand;
    v20.Part1 = v15.PrimaryPart;
    v20.Parent = v15;
    v20.C1 = v15.PrimaryPart.Anchor.CFrame;
    return v19;
end;
function u11._doOpenIdle(p21) --[[ Line: 60 ]]
    -- upvalues: u2 (copy), u3 (copy)
    if p21._equipped then
        p21._open_idle_tp = p21._actor:LoadAnimation(u2:Get("Animation", "ConsumableAnimations", p21._modelName, "TP", "IdleOpen").ID);
        p21._open_idle_tp.Looped = true;
        p21._open_idle_tp.Priority = u3.AnimationPriority.Action;
        p21._open_idle_tp:Play(0);
        local l__ViewModel__2 = p21._actor.ViewModel;
        if l__ViewModel__2 then
            p21._open_idle_fp = l__ViewModel__2:LoadAnimation(u2:Get("Animation", "ConsumableAnimations", p21._modelName, "FP", "IdleOpen").ID);
            p21._open_idle_fp.Looped = true;
            p21._open_idle_fp.Priority = u3.AnimationPriority.Action;
            p21._open_idle_fp:Play(0);
        end;
    end;
end;
function u11._updateModel(p22) --[[ Line: 79 ]]
    -- upvalues: u2 (copy)
    local u23 = (p22._item.MetaData.Uses or 0) / p22._max;
    p22._percentage = 1 - u23;
    p22._goal = p22._percentage;
    local l__Transform__3 = u2:Get("Animation", "ConsumableAnimations", p22._modelName, "TP", "Use").Asset.Transform;
    if l__Transform__3 then
        local function v28(p24) --[[ Line: 89 ]]
            -- upvalues: l__Transform__3 (copy), u23 (copy)
            local l__PrimaryPart__4 = p24.PrimaryPart;
            if l__PrimaryPart__4 then
                for v25, v26 in l__Transform__3 do
                    local v27 = l__PrimaryPart__4:FindFirstChild(v25);
                    if v27 then
                        v27.C1 = v26.From:Lerp(v26.To, u23);
                    end;
                end;
            end;
        end;
        v28(p22._model);
        if p22._fpModel then
            v28(p22._fpModel);
        end;
    end;
end;
function u11.Equip(p29) --[[ Line: 109 ]]
    -- upvalues: u2 (copy), u5 (copy)
    p29._model.Parent = p29._actor.Character;
    p29._equipped = true;
    if p29._item.MetaData.Open then
        p29:_doOpenIdle();
    end;
    local l___primary__5 = p29._primary;
    local l__ViewModel__6 = p29._actor.ViewModel;
    if l__ViewModel__6 then
        if l__ViewModel__6.Active then
            l___primary__5 = nil;
        end;
        local l__ID__7 = u2:Get("Animation", "ConsumableAnimations", p29._modelName, "FP", "Idle").ID;
        local l__ID__8 = u2:Get("Animation", "ConsumableAnimations", p29._modelName, "FP", "Equip").ID;
        local l__ID__9 = u2:Get("Animation", "ConsumableAnimations", p29._modelName, "FP", "Sprint").ID;
        local _, v30 = l__ViewModel__6:SetModel(p29._model, l__ID__7, l__ID__8);
        l__ViewModel__6.SprintID = l__ID__9;
        p29._fpModel = v30;
    else
        p29._fpModel = nil;
    end;
    u5:CreateSound("Weapon_Interaction", l___primary__5, true, "ConsumableSound", p29._modelName, "Equip").Destroy(6);
    p29:_updateModel();
    p29._lerpedPercentage = p29._percentage;
end;
function u11.Unequip(p31) --[[ Line: 141 ]]
    p31._model.Parent = nil;
    if p31._use then
        p31._use:Stop(0);
    end;
    if p31._use_fp then
        p31._use_fp:Stop(0);
    end;
    if p31._open_idle_tp then
        p31._open_idle_tp:Stop();
    end;
    if p31._open_idle_fp then
        p31._open_idle_fp:Stop(0);
    end;
    if p31._goalDelay then
        task.cancel(p31._goalDelay);
        p31._goalDelay = nil;
    end;
    local l__ViewModel__10 = p31._actor.ViewModel;
    if l__ViewModel__10 then
        l__ViewModel__10:SetModel();
        l__ViewModel__10.SprintID = nil;
    end;
    if p31._useSound then
        p31._useSound.Destroy();
        p31._useSound = nil;
    end;
    p31._fpModel = nil;
    p31._equipped = false;
    p31._goal = nil;
end;
function u11.Used(p32, p33) --[[ Line: 180 ]]
    p32._item.MetaData.Uses = p33;
    p32:_updateModel();
end;
function u11.Use(u34) --[[ Line: 185 ]]
    -- upvalues: u2 (copy), u3 (copy), u5 (copy)
    u34._use = u34._actor:LoadAnimation(u2:Get("Animation", "ConsumableAnimations", u34._modelName, "TP", "Use").ID);
    u34._use.Priority = u3.AnimationPriority.Action3;
    u34._use:Play(0);
    if u34._fluid then
        u34._goalDelay = task.delay(0.5, function() --[[ Line: 191 ]]
            -- upvalues: u34 (copy)
            u34._goalDelay = nil;
            u34._goal = 1 - ((u34._item.MetaData.Uses or 0) + 1) / u34._max;
        end);
    end;
    u34._item.MetaData.Open = true;
    local l___primary__11 = u34._primary;
    local l__ViewModel__12 = u34._actor.ViewModel;
    if l__ViewModel__12 then
        if l__ViewModel__12.Active then
            l___primary__11 = nil;
        end;
        u34._use_fp = l__ViewModel__12:LoadAnimation(u2:Get("Animation", "ConsumableAnimations", u34._modelName, "FP", "Use").ID);
        u34._use_fp.Priority = u3.AnimationPriority.Action3;
        u34._use_fp:Play(0);
    end;
    local v35 = u5:CreateSound("Weapon_Interaction", l___primary__11, true, "ConsumableSound", u34._modelName, "Use");
    v35.Destroy(6);
    u34._useSound = v35;
end;
function u11.Open(p36) --[[ Line: 217 ]]
    -- upvalues: u2 (copy), u3 (copy), u5 (copy)
    local v37 = p36._actor:LoadAnimation(u2:Get("Animation", "ConsumableAnimations", p36._modelName, "TP", "Open").ID);
    v37.Priority = u3.AnimationPriority.Action3;
    v37:Play();
    p36._item.MetaData.Open = true;
    local l___primary__13 = p36._primary;
    local l__ViewModel__14 = p36._actor.ViewModel;
    if l__ViewModel__14 then
        if l__ViewModel__14.Active then
            l___primary__13 = nil;
        end;
        local v38 = l__ViewModel__14:LoadAnimation(u2:Get("Animation", "ConsumableAnimations", p36._modelName, "FP", "Open").ID);
        v38.Priority = u3.AnimationPriority.Action3;
        v38:Play();
    end;
    u5:CreateSound("Weapon_Interaction", l___primary__13, true, "ConsumableSound", p36._modelName, p36._fizzy and "OpenFizzy" or "Open").Destroy(6);
    task.delay(0.2, p36._doOpenIdle, p36);
end;
function u11.Update(p39, _, p40, p41) --[[ Line: 242 ]]
    -- upvalues: u4 (copy), u8 (copy), u6 (copy)
    if p39._equipped and p40 <= 1 then
        local l___fluid__15 = p39._fluid;
        if l___fluid__15 then
            local l___lerpedPercentage__16 = p39._lerpedPercentage;
            if p39._goal then
                local l___goal__17 = p39._goal;
                local v42 = u4(p41 * 10);
                p39._lerpedPercentage = math.lerp(l___lerpedPercentage__16, l___goal__17, v42);
                l___lerpedPercentage__16 = p39._lerpedPercentage;
            end;
            local v43 = l___lerpedPercentage__16 * 0.95;
            local l__Fluid__18 = p39._model.Fluid;
            p39._tpSpring.Target = u8.fromCFrame(l__Fluid__18.CFrame);
            u6(p39._tpSpring.Position:ToCFrame(), l___fluid__15, v43, l__Fluid__18:GetChildren());
            if p39._fpModel then
                local l__Fluid__19 = p39._fpModel.Fluid;
                if not p39._fpCFrame then
                    p39._fpCFrame = l__Fluid__19.CFrame;
                end;
                local v44 = l__Fluid__19.CFrame:ToObjectSpace(p39._fpCFrame).Position / p41 / 20;
                p39._fpCFrame = l__Fluid__19.CFrame;
                p39._fpSpring.Target = u8.fromCFrame(l__Fluid__19.CFrame * CFrame.fromEulerAnglesYXZ(math.clamp(v44.Z, -0.5, 0.5), math.clamp(-v44.Y, -0.5, 0.5), (math.clamp(-v44.X, -0.5, 0.5))));
                u6(p39._fpSpring.Position:ToCFrame(), l___fluid__15, v43, l__Fluid__19:GetChildren());
            end;
        end;
    end;
end;
function u11.Destroy(p45) --[[ Line: 274 ]]
    if p45._goalDelay then
        task.cancel(p45._goalDelay);
        p45._goalDelay = nil;
    end;
    p45._equipped = false;
    p45._model:Destroy();
end;
return u11;