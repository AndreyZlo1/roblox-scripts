-- Services.ReplicatorService.AttachmentReplicators.StrobeAttachmentReplicator
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1, v2 = shared.import("Enum", "require");
local u3 = v2("SoundService");
local u4 = v2("ViewmodelService");
local u5 = v2("EnvironmentService");
local u6 = {};
u6.__index = u6;
function u6.new(p7, p8, p9, p10) --[[ Line: 10 ]]
    -- upvalues: u6 (copy)
    local v11 = {
        _state = 0,
        _actor = p7,
        _start = os.clock(),
        _config = p8
    };
    local v12 = setmetatable(v11, u6);
    if p9 or not p10 then
        p10 = p10:GetChild(unpack(p9));
    end;
    local l__secondary__1 = p10.Model.secondary;
    v12._transparency = l__secondary__1.Transparency;
    v12._color = l__secondary__1.Color;
    v12._model = l__secondary__1;
    return v12;
end;
function u6.SetState(p13, p14) --[[ Line: 25 ]]
    -- upvalues: u3 (copy)
    local v15 = p13._config[p14] or p13._config[p13._state];
    local l___cast__2 = p13._cast;
    if v15 and l___cast__2 then
        u3:CreateSound("Weapon_Interaction", l___cast__2, true, "Foley", "Weapon", "Button", v15.Button or "Soft", p14 == 0 and "Off" or "On").Destroy(2);
    end;
    p13._state = p14;
end;
function u6.GetVPFModels(_) --[[ Line: 36 ]]
    return {};
end;
function u6.Update(p16, _, p17) --[[ Line: 40 ]]
    -- upvalues: u4 (copy), u1 (copy), u5 (copy)
    local v18 = p16._config[p16._state];
    local v19 = nil;
    if v18 then
        if v18.StrobeSpeed then
            if (os.clock() - p16._start) % v18.StrobeSpeed < v18.StrobeBlink then
                v19 = v18.Color;
            end;
        else
            v19 = v18.Color;
        end;
        if v19 then
            local l__Viewmodel__3 = u4.Viewmodel;
            if l__Viewmodel__3 then
                l__Viewmodel__3 = u4.Viewmodel.NVG;
            end;
            if v18.IsIR and not l__Viewmodel__3 then
                v19 = nil;
            end;
        end;
    end;
    if p16.FirstPerson then
        v19 = nil;
    end;
    local l___model__4 = p16._model;
    if v19 then
        l___model__4.Material = u1.Material.Neon;
        l___model__4.Color = v19;
        l___model__4.Transparency = v18.Transparency or 0;
        u5.Temp[l___model__4.light] = {
            Color = v19,
            Intensity = v18.Brightness or 0.5
        };
    else
        l___model__4.Material = u1.Material.SmoothPlastic;
        l___model__4.Color = p16._color;
        l___model__4.Transparency = p16._transparency;
    end;
    if p17 and p16._actor then
        l___model__4 = p16._actor.Parts.Head or l___model__4;
    end;
    p16._cast = l___model__4;
end;
function u6.Destroy(_) --[[ Line: 83 ]] end;
return u6;