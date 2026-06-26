-- Services.ReplicatorService.InventoryReplicators.GearInventoryReplicator
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local l__Lighting__1 = game:GetService("Lighting");
local v1, u2, u3, _ = shared.import("require", "asset", "Enum", "frc");
local u4 = v1("SoundService");
v1("ItemLayout");
local u5 = v1("Gear");
local u6 = {};
u6.__index = u6;
function u6.new(p7, p8) --[[ Line: 12 ]]
    -- upvalues: u5 (copy), u2 (copy), u6 (copy)
    local l__Model__2 = u5[p8.Layout.Gear].Model;
    local v9 = u2:Get("Shared", "Models", "Gear", l__Model__2).Asset:Clone();
    local l__PrimaryPart__3 = v9.PrimaryPart;
    local v10 = setmetatable({
        _item = p8,
        _actor = p7,
        _primary = l__PrimaryPart__3,
        _model = v9,
        _modelName = l__Model__2
    }, u6);
    local v11 = Instance.new("Motor6D");
    v11.Part0 = p7.Parts.RightHand;
    v11.Part1 = l__PrimaryPart__3;
    v11.Parent = v9;
    v11.C1 = l__PrimaryPart__3.Anchor.CFrame;
    return v10;
end;
function u6._updateCSEL(p12, p13) --[[ Line: 34 ]]
    local l__CSEL_Screen__4 = p12._model.CSEL_Screen;
    p13(l__CSEL_Screen__4, l__CSEL_Screen__4.UI);
    if p12._modelFP then
        local l__CSEL_Screen__5 = p12._modelFP.CSEL_Screen;
        p13(l__CSEL_Screen__5, l__CSEL_Screen__5.UI);
    end;
end;
function u6.CSEL(p14, p15) --[[ Line: 44 ]]
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local l___actor__6 = p14._actor;
    if p15 then
        if p14._useCSELAnim then
            p14._useCSELAnim:Stop(0);
            p14._useCSELAnim = nil;
        end;
        if p14._useCSELAnimFP then
            p14._useCSELAnimFP:Stop(0);
            p14._useCSELAnimFP = nil;
        end;
        if p14._useCSELSound then
            p14._useCSELSound.Destroy();
            p14._useCSELSound = nil;
        end;
        local v16 = l___actor__6:LoadAnimation(u2:Get("Animation", "GearAnimations", p14._modelName, "TP", "Use").ID);
        v16.Priority = u3.AnimationPriority.Action3;
        v16:Play(0);
        p14._useCSELAnim = v16;
        local l___primary__7 = p14._primary;
        local l__ViewModel__8 = l___actor__6.ViewModel;
        if l__ViewModel__8 then
            local v17 = l__ViewModel__8:LoadAnimation(u2:Get("Animation", "GearAnimations", p14._modelName, "FP", "Use").ID);
            v17.Priority = u3.AnimationPriority.Action3;
            v17:Play(0);
            p14._useCSELAnimFP = v17;
            if l__ViewModel__8.Active then
                l___primary__7 = nil;
            end;
        end;
        local v18 = u4:CreateSound("Weapon_Interaction", l___primary__7, false, "GearSounds", p14._modelName, "Use");
        v18.Play();
        p14._useCSELSound = v18;
        p14._cselButton = 1;
    else
        if p14._useCSELAnim then
            local v19 = 3.2;
            local l__TimePosition__9 = p14._useCSELAnim.TimePosition;
            if l__TimePosition__9 < 1.6 then
                l__TimePosition__9 = v19 + (1.6 - l__TimePosition__9);
            elseif v19 >= l__TimePosition__9 then
                l__TimePosition__9 = v19;
            end;
            p14._useCSELAnim.TimePosition = l__TimePosition__9;
            if p14._useCSELAnimFP then
                p14._useCSELAnimFP.TimePosition = l__TimePosition__9;
                p14._useCSELAnimFP = nil;
            end;
            if p14._useCSELSound then
                p14._useCSELSound.Sound.TimePosition = l__TimePosition__9;
                p14._useCSELSound = nil;
            end;
            p14._useCSELAnim = nil;
            p14:_updateCSEL(function(p20, p21) --[[ Line: 104 ]]
                p20.Transparency = 1;
                p21.Enabled = false;
            end);
        end;
    end;
end;
function u6.Zoom(p22, p23) --[[ Line: 111 ]]
    -- upvalues: u2 (copy), u3 (copy), u4 (copy)
    local l___actor__10 = p22._actor;
    if p23 then
        local v24 = l___actor__10:LoadAnimation(u2:Get("Animation", "GearAnimations", p22._modelName, "TP", "Zoom").ID);
        v24.Priority = u3.AnimationPriority.Action2;
        v24:Play(0);
        if not p22._zoomLoop then
            local v25 = l___actor__10:LoadAnimation(u2:Get("Animation", "GearAnimations", p22._modelName, "TP", "ZoomLoop").ID);
            v25.Looped = true;
            v25.Priority = u3.AnimationPriority.Action;
            v25:Play();
            p22._zoomLoop = v25;
        end;
    elseif p22._zoomLoop then
        p22._zoomLoop:Stop(0.3);
        p22._zoomLoop = nil;
    end;
    local l___primary__11 = p22._primary;
    local l__ViewModel__12 = l___actor__10.ViewModel;
    if l__ViewModel__12 then
        l__ViewModel__12.Disabled = p23;
        l___primary__11 = nil;
    end;
    u4:CreateSound("Weapon_Interaction", l___primary__11, false, "GearSounds", p22._modelName, "Magnify" .. (p23 and "In" or "Out")).Play();
end;
function u6.Equip(p26) --[[ Line: 141 ]]
    -- upvalues: u2 (copy), u4 (copy)
    p26._model.Parent = p26._actor.Character;
    p26._equipped = true;
    local l___primary__13 = p26._primary;
    local l__ViewModel__14 = p26._actor.ViewModel;
    if l__ViewModel__14 then
        local l__ID__15 = u2:Get("Animation", "GearAnimations", p26._modelName, "FP", "Idle").ID;
        local l__ID__16 = u2:Get("Animation", "GearAnimations", p26._modelName, "FP", "Equip").ID;
        local _, v27 = l__ViewModel__14:SetModel(p26._model, l__ID__15, l__ID__16, p26._primary.Anchor.CFrame);
        p26._modelFP = v27;
        l__ViewModel__14.SprintID = u2:Get("Animation", "GearAnimations", p26._modelName, "FP", "Sprint").ID;
        if l__ViewModel__14.Active then
            l___primary__13 = nil;
        end;
    end;
    u4:CreateSound("Weapon_Interaction", l___primary__13, false, "GearSounds", p26._modelName, "Equip").Play();
end;
function u6.Unequip(p28) --[[ Line: 163 ]]
    p28._model.Parent = nil;
    p28._equipped = false;
    if p28._zoomLoop then
        p28._zoomLoop:Stop();
        p28._zoomLoop = nil;
    end;
    if p28._useCSELAnim then
        p28._useCSELAnim:Stop();
        p28._useCSELAnim = nil;
        p28:_updateCSEL(function(p29, p30) --[[ Line: 175 ]]
            p29.Transparency = 1;
            p30.Enabled = false;
        end);
    end;
    if p28._useCSELSound then
        p28._useCSELSound.Destroy();
        p28._useCSELSound = nil;
    end;
    if p28._useCSELAnimFP then
        p28._useCSELAnimFP:Stop();
        p28._useCSELAnimFP = nil;
    end;
    p28._modelFP = nil;
    local l__ViewModel__17 = p28._actor.ViewModel;
    if l__ViewModel__17 then
        l__ViewModel__17.Disabled = nil;
        l__ViewModel__17.SprintID = nil;
        l__ViewModel__17:SetModel();
    end;
end;
function u6.Update(p31, _, p32, _) --[[ Line: 198 ]]
    -- upvalues: l__Lighting__1 (copy), u3 (copy)
    if p31._equipped and p32 <= 1 then
        if p31._useCSELAnim then
            local l___cselButton__18 = p31._cselButton;
            local l__TimePosition__19 = p31._useCSELAnim.TimePosition;
            if l__TimePosition__19 >= 1.6 and l___cselButton__18 == 1 then
                p31:_updateCSEL(function(p33, p34) --[[ Line: 208 ]]
                    -- upvalues: l__Lighting__1 (ref), u3 (ref)
                    p33.Transparency = 0;
                    p34.Enabled = true;
                    p34.Header.Text = "6 JAN " .. l__Lighting__1.TimeOfDay:sub(1, 5);
                    p34.Top.Text = "<u>MESSAGES</u>";
                    p34.Middle.Text = "NAVIGATION";
                    p34.Middle.TextXAlignment = u3.TextXAlignment.Left;
                    p34.Bottom.Text = "CALL EXFIL";
                    p34.Last.Text = "RADIO STATUS";
                end);
                p31._cselButton = 2;
                return;
            end;
            if l__TimePosition__19 >= 2.1 and l___cselButton__18 == 2 then
                p31:_updateCSEL(function(_, p35) --[[ Line: 220 ]]
                    p35.Top.Text = "MESSAGES";
                    p35.Middle.Text = "<u>NAVIGATION</u>";
                    p35.Bottom.Text = "CALL EXFIL";
                end);
                p31._cselButton = 3;
                return;
            end;
            if l__TimePosition__19 >= 2.3333333333333335 and l___cselButton__18 == 3 then
                p31:_updateCSEL(function(_, p36) --[[ Line: 227 ]]
                    p36.Top.Text = "MESSAGES";
                    p36.Middle.Text = "NAVIGATION";
                    p36.Bottom.Text = "<u>CALL EXFIL</u>";
                end);
                p31._cselButton = 4;
                return;
            end;
            if l__TimePosition__19 >= 2.7 and l___cselButton__18 == 4 then
                p31:_updateCSEL(function(_, p37) --[[ Line: 234 ]]
                    -- upvalues: u3 (ref)
                    p37.Header.Text = "";
                    p37.Top.Text = "";
                    p37.Middle.Text = "MESSAGE RECEIVED";
                    p37.Middle.TextXAlignment = u3.TextXAlignment.Center;
                    p37.Bottom.Text = "";
                    p37.Last.Text = "";
                end);
                p31._cselButton = 5;
                return;
            end;
            if l__TimePosition__19 >= 3.033333333333333 and l___cselButton__18 == 5 then
                p31:_updateCSEL(function(p38, p39) --[[ Line: 244 ]]
                    p38.Transparency = 1;
                    p39.Enabled = false;
                end);
                p31._cselButton = 6;
            end;
        end;
    end;
end;
function u6.Destroy(p40) --[[ Line: 253 ]]
    if p40._zoomLoop then
        p40._zoomLoop:Stop();
        p40._zoomLoop = nil;
    end;
    if p40._useCSELAnim then
        p40._useCSELAnim:Stop();
        p40._useCSELAnim = nil;
    end;
    if p40._useCSELAnimFP then
        p40._useCSELAnimFP:Stop();
        p40._useCSELAnimFP = nil;
    end;
    if p40._useCSELSound then
        p40._useCSELSound.Destroy();
        p40._useCSELSound = nil;
    end;
    p40._modelFP = nil;
    p40._model:Destroy();
    p40._equipped = false;
end;
return u6;