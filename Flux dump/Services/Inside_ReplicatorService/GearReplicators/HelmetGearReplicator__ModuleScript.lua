-- Services.ReplicatorService.GearReplicators.HelmetGearReplicator
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1, v2, u3, u4, u5 = shared.import("Enum", "require", "network", "asset", "frc");
local u6 = v2("SoundService");
local u7 = v2("InputService");
local u8 = v2("OverlayInterface");
local u9 = v2("BaseComponent");
local u10 = v2({ "FlashlightAttachmentReplicator", "LaserAttachmentReplicator", "StrobeAttachmentReplicator" });
local u11 = v2("Mathf");
local u12 = v2("Tubes");
local u13 = v2("Menu");
local u14 = v2("AttachmentIcons");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u15 = {};
u15.__index = u15;
function u15.new(p16, p17, u18, p19) --[[ Line: 29 ]]
    -- upvalues: u12 (copy), u15 (copy), u13 (copy), u14 (copy), u3 (copy), u1 (copy), u10 (copy), u8 (copy), u7 (copy), u4 (copy)
    local l__Tune__2 = p16.Tune;
    local v20 = u12[l__Tune__2.NVGTube];
    local u21 = setmetatable({
        TubePreset = 1,
        NVGTimer = 0,
        NVGCover = 0,
        _last = 0,
        ActionMenu = {},
        Flips = {},
        Tube = v20,
        Model = p16.ParentModel,
        LastActive = p19 or false,
        NVGActive = p19 or false,
        NVGFade = l__Tune__2.NVGFade or 5,
        _helmet = p16,
        _handle = l__Tune__2.NVGHandle or "Medium",
        _actor = p17,
        _isLocalPlayer = u18,
        _attachmentCache = {},
        _attachments = {}
    }, u15);
    local v22 = nil;
    local v23 = nil;
    local v24 = nil;
    for _, v25 in p16:GetDescendants() do
        local v26 = false;
        local l__Config__3 = v25.File.Config;
        if l__Config__3 then
            if l__Config__3.IsNVGMount then
                v23 = v25;
            end;
            if l__Config__3.IsNVGDevice then
                v22 = v25;
                v26 = true;
            end;
            if l__Config__3.NVGCancelFlip then
                u21._NVGCancelFlip = true;
            end;
        end;
        local l__Attachments__4 = v25.File.Attachments;
        if l__Attachments__4 then
            local v27 = u13;
            for v28 = 1, #v25.Path do
                v27 = v27[v25.Path[v28]];
            end;
            local u29 = v25:GetFullName();
            local u30 = nil;
            local function v42(p31, p32, p33) --[[ Line: 86 ]]
                -- upvalues: u29 (copy), u21 (copy), u18 (copy), u30 (ref), u14 (ref), u3 (ref), u1 (ref)
                local u34 = table.concat(u29, ".") .. "/" .. p33;
                u21._attachmentCache[u34] = { p33, p31, u29 };
                if u18 then
                    if #p31 == 1 then
                        u30 = u14[p33] or "";
                        p32[#p32 + 1] = {
                            Activated = false,
                            Titleline = p31[1].Name,
                            Image = u30,
                            Subline = { "Turn off " .. p31[1].Name, "Turn on " .. p31[1].Name },
                            Callback = function(p35) --[[ Name: Callback, Line 99 ]]
                                -- upvalues: u21 (ref), u34 (copy), u3 (ref), u1 (ref)
                                local v36 = p35 and 1 or 0;
                                u21:Attachment(u34, v36);
                                u3:FireServer("ActionActor", u1.ActionType.Helmet, "Attachment", u34, v36);
                            end
                        };
                        return;
                    end;
                    local function v38(p37) --[[ Line: 108 ]]
                        -- upvalues: u21 (ref), u34 (copy), u3 (ref), u1 (ref)
                        u21:Attachment(u34, p37);
                        u3:FireServer("ActionActor", u1.ActionType.Helmet, "Attachment", u34, p37);
                    end;
                    local v39 = {};
                    for v40, v41 in p31 do
                        v39[v40] = {
                            Titleline = v41.Name,
                            Subline = "Set " .. v41.Name,
                            Callback = v38,
                            Image = u14.Gear
                        };
                    end;
                    p32[#p32 + 1] = {
                        Activated = 0,
                        Titleline = p33,
                        Image = u14[p33],
                        Subline = "Set " .. p33 .. " mode",
                        Callbacks = v39
                    };
                    u30 = "";
                end;
            end;
            local v43 = u30;
            local v44 = {};
            for v45, v46 in l__Attachments__4 do
                v42(v46, v44, v45);
            end;
            local v47 = {
                Image = v26 and u14.NVG or (#v44 == 1 and v43 or u14.Multi),
                Name = v27.Name,
                Functions = v44
            };
            if v26 then
                v24 = v47;
            else
                u21.ActionMenu[#u21.ActionMenu + 1] = v47;
            end;
        end;
    end;
    if p17 then
        for v48, v49 in u21._attachmentCache do
            u21._attachments[v48] = u10[v49[1] .. "AttachmentReplicator"].new(p17, v49[2], v49[3], p16);
        end;
    end;
    if v22 then
        local l__Model__5 = v22.Model;
        if not u21._NVGCancelFlip then
            for _, v50 in l__Model__5:GetChildren() do
                local v51 = v50:FindFirstChild("anchor");
                if v51 then
                    local v52 = v51:FindFirstChild("offset");
                    if v52 then
                        local v53 = v50:FindFirstChildWhichIsA("Weld");
                        if v53 then
                            local v54 = v52.CFrame:Inverse();
                            u21.Flips[v53] = {
                                Base = v53.C1,
                                Adjustment = v54
                            };
                            if not p19 then
                                v53.C1 = v53.C1 * v54;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        if u18 then
            local v55 = u13;
            for v56 = 1, #v22.Path do
                v55 = v55[v22.Path[v56]];
            end;
            local v57 = v24 or {
                Name = v55.Name,
                Functions = {}
            };
            local l__Functions__6 = v57.Functions;
            local u59 = {
                Activated = false,
                Titleline = "Night Vision",
                Image = u14.NVG,
                Subline = { "Turn off Night Vision", "Turn on Night Vision" },
                Callback = function(p58) --[[ Name: Callback, Line 207 ]]
                    -- upvalues: u21 (copy), u8 (ref)
                    if tick() - u21._last < 1.1 then
                        return true;
                    elseif u8.Handle then
                    else
                        u21._last = tick();
                        u21:SetNVG(p58);
                    end;
                end
            };
            l__Functions__6[#l__Functions__6 + 1] = u59;
            local l__Presets__7 = v20.Presets;
            if #l__Presets__7 == 2 then
                l__Functions__6[#l__Functions__6 + 1] = {
                    Activated = false,
                    Image = u14.Tube,
                    Titleline = l__Presets__7[2].Name,
                    Subline = { "Turn off " .. l__Presets__7[2].Name, "Turn on " .. l__Presets__7[2].Name },
                    Callback = function(p60) --[[ Name: Callback, Line 229 ]]
                        -- upvalues: u21 (copy)
                        u21.TubePreset = p60 and 2 or 1;
                    end
                };
            elseif #l__Presets__7 > 2 then
                local function v62(p61) --[[ Line: 236 ]]
                    -- upvalues: u21 (copy)
                    u21.TubePreset = math.max(p61, 1);
                end;
                local v63 = {};
                for v64, v65 in l__Presets__7 do
                    v63[v64] = {
                        Titleline = v65.Name,
                        Subline = "Set " .. v65.Name,
                        Callback = v62,
                        Image = u14.Gear
                    };
                end;
                l__Functions__6[#l__Functions__6 + 1] = {
                    Activated = 0,
                    Titleline = "Tube setting",
                    Subline = "Change tube setting",
                    Image = u14.Tube,
                    Callbacks = v63
                };
            end;
            table.insert(u21.ActionMenu, 1, v57);
            u21._controls = u7:Connect({
                NVG = function(p66) --[[ Name: NVG, Line 263 ]]
                    -- upvalues: u21 (copy), u8 (ref), u59 (copy)
                    if p66 then
                        if tick() - u21._last < 1.1 then
                            return;
                        end;
                        if u8.Handle then
                            return;
                        end;
                        u21._last = tick();
                        local v67 = not u21.NVGActive;
                        u59.Activated = v67;
                        u21:SetNVG(v67);
                    end;
                end
            });
        end;
    end;
    local l__NVGLevel__8 = l__Tune__2.NVGLevel;
    local v68 = l__Tune__2.NVGUp or 0;
    local v69 = l__Tune__2.NVGForward or 0;
    if v23 then
        local l__Model__9 = v23.Model;
        local v70 = math.rad(90 - l__NVGLevel__8);
        local v71 = v68 / math.tan(v70);
        local v72 = math.rad(90 - l__NVGLevel__8);
        local v73 = v68 / math.sin(v72);
        local v74 = l__Model__9:FindFirstChild("upward");
        local v75 = l__Model__9:FindFirstChild("hinge");
        local v76 = l__Model__9:FindFirstChild("forward");
        if v75 then
            local l__Weld__10 = v75.Weld;
            local l__anchor__11 = v75.anchor;
            if v74 then
                l__Weld__10.C0 = l__anchor__11.WorldCFrame:ToObjectSpace(v74.CFrame):Inverse();
                l__Weld__10.Part0 = v74;
            end;
            l__Weld__10.C1 = l__anchor__11.CFrame;
        end;
        if v76 then
            local l__Weld__12 = v76.Weld;
            local l__anchor__13 = v76.anchor;
            l__Weld__12.C0 = l__anchor__13.WorldCFrame:ToObjectSpace(v75.CFrame):Inverse();
            l__Weld__12.C1 = l__anchor__13.CFrame * CFrame.new(0, 0, v69 - v71);
            l__Weld__12.Part0 = v75;
        end;
        if v74 then
            v74.Weld.C1 = v74.anchor.CFrame * CFrame.new(0, v73, 0);
        end;
        if v75 then
            local v77 = l__NVGLevel__8 + (l__Tune__2.NVGAdjust or 0);
            local v78 = l__Tune__2.NVGStow or -120;
            v75.Weld.C1 = v75.anchor.CFrame * CFrame.Angles(math.rad(v77 + (p19 and 0 or v78)), 0, 0);
            u21.Hinge = {
                Weld = v75.Weld,
                CFrame = v75.anchor.CFrame,
                Down = v77,
                Stow = v78
            };
        end;
    end;
    if v20 and (v20.Glow and p17) then
        local v79 = u4:Get("Shared", "Models", "Character", "NVGGlow", v20.Glow).Asset:Clone();
        p17:_createEquipWeld("Head", v79);
        v79.Color = v20.Presets[1].ColorCorrection.TintColor;
        v79.CanCollide = false;
        v79.CanTouch = false;
        v79.CanQuery = false;
        v79.AudioCanCollide = false;
        v79.Anchored = false;
        v79.Parent = p17.Character;
        u21._glowModel = v79;
    end;
    return u21;
end;
function u15.Attachment(p80, p81, p82) --[[ Line: 344 ]]
    local v83 = p80._attachments[p81];
    if v83 then
        v83:SetState(p82);
    end;
end;
function u15.SetNVG(p84, p85) --[[ Line: 353 ]]
    -- upvalues: u3 (copy), u1 (copy), u4 (copy), u9 (copy), u15 (copy), l__CurrentCamera__1 (copy), u6 (copy)
    if p84._isLocalPlayer then
        u3:FireServer("ActionActor", u1.ActionType.Helmet, "SetNVG", p85);
    end;
    local v86 = tick();
    p84.NVGActive = p85;
    p84.NVGTimer = v86;
    local l___actor__14 = p84._actor;
    l___actor__14:LoadAnimation(u4:Get("Animation", "CharacterAnimations", "NVG", "TP", p85 and "Down" or "Up").ID):Play(0.3);
    local l__PrimaryPart__15 = p84._helmet.ParentModel.PrimaryPart;
    local l__ViewModel__16 = l___actor__14.ViewModel;
    if l__ViewModel__16 then
        if p84._fpHelmet then
            p84._fpHelmet:Destroy();
            p84._fpHelmet = nil;
        end;
        local v87 = l__ViewModel__16:LoadAnimation(u4:Get("Animation", "CharacterAnimations", "NVG", "FP", p85 and "Down" or "Up").ID);
        v87.Priority = u1.AnimationPriority.Action3;
        v87:Play();
        local v88 = u9.Deserialize(p84._helmet:Serialize());
        for _, v89 in v88:GetDescendants() do
            local l__Config__17 = v89.File.Config;
            local v90 = l__Config__17 and (l__Config__17.IsNVGMount or l__Config__17.IsNVGDevice) and 0 or 1;
            for _, v91 in v89.ParentModel:GetDescendants() do
                if v91:IsA("BasePart") then
                    v91.CastShadow = false;
                    v91.Transparency = v90;
                end;
            end;
        end;
        v88.ParentModel.PrimaryPart.Transparency = 1;
        local v92 = u15.new(v88, nil, false, not p85);
        v92.NVGActive = p85;
        v92.NVGTimer = v86;
        v92.Model.Parent = l__CurrentCamera__1;
        p84._fpHelmet = v92;
        p84._fpHelmetAngle = p85 and 90 or 0;
        if l__ViewModel__16.Active then
            l__PrimaryPart__15 = nil;
        end;
    end;
    u6:CreateSound("Character", l__PrimaryPart__15, true, "Foley", "NVG", "Movement", p84._handle, p85 and "Activate" or "Stow").Destroy(4);
end;
function u15.Update(p93, p94) --[[ Line: 409 ]]
    -- upvalues: u11 (copy), u5 (copy), l__CurrentCamera__1 (copy)
    local v95 = tick();
    local v96 = math.clamp(p94 * (p93.NVGActive and 10 or 20), 0.003, 1);
    if v95 - p93.NVGTimer > (p93.NVGActive and 0.4 or 0.3) then
        p93.LastActive = p93.NVGActive;
        p93.NVGCover = u11.Lerp(p93.NVGCover, p93.NVGActive and 1 or 0, v96);
    end;
    local l___glowModel__18 = p93._glowModel;
    if l___glowModel__18 then
        l___glowModel__18.Transparency = p93.LastActive and p93.NVGCover > 0.98 and 0 or 1;
    end;
    local l__LastActive__19 = p93.LastActive;
    local l__Hinge__20 = p93.Hinge;
    if l__Hinge__20 then
        l__Hinge__20.Weld.C1 = l__Hinge__20.Weld.C1:Lerp(l__Hinge__20.CFrame * CFrame.Angles(math.rad(l__Hinge__20.Down + (l__LastActive__19 and 0 or l__Hinge__20.Stow)), 0, 0), v96);
    end;
    for v97, v98 in p93.Flips do
        v97.C1 = v97.C1:Lerp(v98.Base * (l__LastActive__19 and CFrame.new() or v98.Adjustment), v96);
    end;
    local l___actor__21 = p93._actor;
    if l___actor__21 then
        l___actor__21 = p93._actor.ViewModel;
    end;
    local v99;
    if l___actor__21 then
        v99 = l___actor__21.Active;
    else
        v99 = l___actor__21;
    end;
    for _, v100 in p93._attachments do
        v100.FirstPerson = v99;
        v100:Update(p94, v99);
    end;
    local l___fpHelmet__22 = p93._fpHelmet;
    if l___fpHelmet__22 then
        local v101;
        if p93.NVGActive == p93.LastActive then
            if p93.NVGActive and p93.NVGCover > 0.99 then
                v101 = true;
            else
                v101 = not p93.NVGActive;
                if v101 then
                    v101 = p93.NVGCover < 0.05;
                end;
            end;
        else
            v101 = false;
        end;
        if l___actor__21 and not v101 then
            if p93.NVGActive == p93.LastActive then
                if p93._fpHelmetAngle then
                    p93._fpHelmetAngle = u11.Lerp(p93._fpHelmetAngle, p93.NVGActive and 0 or 90, u5(p94 * (p93.NVGActive and 40 or 5)));
                else
                    p93._fpHelmetAngle = p93.NVGActive and 90 or 0;
                end;
            else
                p93._fpHelmetAngle = nil;
            end;
            local l__Model__23 = l___fpHelmet__22.Model;
            l__Model__23.Parent = l___actor__21.Active and l__CurrentCamera__1 or nil;
            l__Model__23.PrimaryPart.CFrame = l__CurrentCamera__1.CFrame * CFrame.new(0, 0.1, 0.2) * CFrame.Angles(math.rad(p93._fpHelmetAngle or 90), 0, 0);
            l___fpHelmet__22:Update(p94);
            return;
        end;
        l___fpHelmet__22:Destroy();
        p93._fpHelmet = nil;
    end;
end;
function u15.Destroy(p102) --[[ Line: 471 ]]
    if p102._controls then
        p102._controls:Disconnect();
    end;
    for _, v103 in p102._attachments do
        v103:Destroy();
    end;
    if p102._glowModel then
        p102._glowModel:Destroy();
    end;
    if p102._fpHelmet then
        p102._fpHelmet:Destroy();
    end;
    p102.Model:Destroy();
end;
return u15;