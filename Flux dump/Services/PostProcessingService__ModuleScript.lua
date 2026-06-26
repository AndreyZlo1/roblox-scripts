-- Services.PostProcessingService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _ = shared.import("require", "asset");
local l__Lighting__1 = game:GetService("Lighting");
local l__Players__2 = game:GetService("Players");
local u2 = v1("InputService");
l__Players__2.LocalPlayer:WaitForChild("PlayerGui");
local _ = workspace.CurrentCamera;
local u3 = {};
u3.__index = u3;
function u3.new() --[[ Line: 15 ]]
    -- upvalues: l__Lighting__1 (copy), u3 (copy)
    local v4 = Instance.new("BlurEffect");
    v4.Size = 0;
    v4.Enabled = false;
    v4.Parent = l__Lighting__1;
    local v5 = Instance.new("ColorCorrectionEffect");
    v5.Saturation = 0;
    v5.Contrast = 0;
    v5.Brightness = 0;
    v5.Parent = l__Lighting__1;
    local v6 = Instance.new("BloomEffect");
    v6.Intensity = 0;
    v6.Size = 0;
    v6.Threshold = 0;
    v6.Parent = l__Lighting__1;
    local v7 = Instance.new("DepthOfFieldEffect");
    v7.Enabled = false;
    v7.Parent = l__Lighting__1;
    return setmetatable({
        DepthOfFieldMasterEnabled = true,
        Blur = v4,
        _blurs = {},
        _colorCorrection = v5,
        _colorCorrections = {},
        _bloom = v6,
        _blooms = {},
        _depthOfField = v7,
        _depthOfFields = {},
        _brightness = {},
        _exposures = {}
    }, u3);
end;
function u3.Update(p8, _) --[[ Line: 59 ]]
    -- upvalues: u2 (copy), l__Lighting__1 (copy)
    local l__RGE__3 = u2.RGE;
    l__Lighting__1.Ambient = not l__RGE__3 and p8.Ambient or Color3.new();
    local v9 = 0;
    for v10 in p8._blurs do
        if not (v10.DisableDuringRGE and l__RGE__3) then
            local l__Size__4 = v10.Size;
            if typeof(l__Size__4) ~= "number" then
                l__Size__4 = l__Size__4:getValue();
            end;
            v9 = math.max(v9, l__Size__4);
        end;
    end;
    local l__Blur__5 = p8.Blur;
    if v9 > 0.1 then
        l__Blur__5.Size = v9;
        l__Blur__5.Enabled = true;
    else
        l__Blur__5.Enabled = false;
    end;
    local v11 = Color3.new(1, 1, 1);
    local v12 = 0;
    local v13 = 0;
    local v14 = 0;
    local v15 = 0;
    for v16, v17 in p8._colorCorrections do
        if not (v16.DisableDuringRGE and l__RGE__3) and v16.Enabled then
            local l__Saturation__6 = v16.Saturation;
            if typeof(l__Saturation__6) ~= "number" then
                l__Saturation__6 = l__Saturation__6:getValue();
            end;
            local l__Contrast__7 = v16.Contrast;
            if typeof(l__Contrast__7) ~= "number" then
                l__Contrast__7 = l__Contrast__7:getValue();
            end;
            local l__Brightness__8 = v16.Brightness;
            if typeof(l__Brightness__8) ~= "number" then
                l__Brightness__8 = l__Brightness__8:getValue();
            end;
            if v17 == -1 then
                v11 = v16.TintColor;
                v12 = l__Saturation__6 or 0;
                v13 = l__Contrast__7 or 0;
                v14 = l__Brightness__8 or 0;
                v15 = 2;
                break;
            end;
            v12 = v12 + l__Saturation__6;
            v13 = v13 + l__Contrast__7;
            v14 = v14 + l__Brightness__8;
            if v15 < v17 then
                v11 = v16.TintColor;
                v15 = v17;
            end;
        end;
    end;
    local v18 = math.clamp(v12, -1, 1);
    local l___colorCorrection__9 = p8._colorCorrection;
    l___colorCorrection__9.Saturation = v18;
    l___colorCorrection__9.Contrast = math.clamp(v13, -1, 1);
    l___colorCorrection__9.Brightness = math.clamp(v14, -1, 1);
    l___colorCorrection__9.TintColor = v15 > 1 and v11 and v11 or v11:Lerp(Color3.new(1, 1, 1), -math.clamp(v18, -1, 0));
    local v19 = 0;
    local v20 = 0;
    local v21 = 4;
    for v22, v23 in p8._blooms do
        if not (v22.DisableDuringRGE and l__RGE__3) and v22.Enabled then
            local l__Intensity__10 = v22.Intensity;
            if typeof(l__Intensity__10) ~= "number" then
                l__Intensity__10 = l__Intensity__10:getValue();
            end;
            local l__Size__11 = v22.Size;
            if typeof(l__Size__11) ~= "number" then
                l__Size__11 = l__Size__11:getValue();
            end;
            local l__Threshold__12 = v22.Threshold;
            if typeof(l__Threshold__12) ~= "number" then
                l__Threshold__12 = l__Threshold__12:getValue();
            end;
            if v23 == -1 then
                v21 = l__Threshold__12;
                v20 = l__Size__11;
                v19 = l__Intensity__10;
                break;
            end;
            v19 = math.max(v19, l__Intensity__10);
            v20 = math.max(v20, l__Size__11);
            v21 = math.min(v21, l__Threshold__12);
        end;
    end;
    local l___bloom__13 = p8._bloom;
    l___bloom__13.Intensity = v19;
    l___bloom__13.Size = v20;
    l___bloom__13.Threshold = v21;
    local v24 = 0;
    local v25 = 0;
    local v26 = 0;
    local v27 = 0;
    local v28 = 0;
    for v29, v30 in p8._depthOfFields do
        if not (v29.DisableDuringRGE and l__RGE__3) and (v24 < v30 and v29.Enabled) then
            v25 = v29.FarIntensity;
            v26 = v29.FocusDistance;
            v27 = v29.InFocusRadius;
            v28 = v29.NearIntensity;
            v24 = v30;
        end;
    end;
    local l___depthOfField__14 = p8._depthOfField;
    if v24 > 0 and p8.DepthOfFieldMasterEnabled then
        l___depthOfField__14.FarIntensity = v25;
        l___depthOfField__14.FocusDistance = v26;
        l___depthOfField__14.InFocusRadius = v27;
        l___depthOfField__14.NearIntensity = v28;
        l___depthOfField__14.Enabled = true;
    else
        l___depthOfField__14.Enabled = false;
    end;
    local v31 = 1;
    for v32, v33 in p8._brightness do
        if not (v32.DisableDuringRGE and l__RGE__3) then
            local l__Size__15 = v32.Size;
            if typeof(l__Size__15) ~= "number" then
                l__Size__15 = l__Size__15:getValue();
            end;
            if v33 == -1 then
                v31 = l__Size__15;
                break;
            end;
            v31 = v31 + l__Size__15;
        end;
    end;
    l__Lighting__1.Brightness = v31;
    local v34 = 0;
    for v35, v36 in p8._exposures do
        if not (v35.DisableDuringRGE and l__RGE__3) then
            local l__Size__16 = v35.Size;
            if typeof(l__Size__16) ~= "number" then
                l__Size__16 = l__Size__16:getValue();
            end;
            if v36 == -1 then
                v34 = l__Size__16;
                break;
            end;
            v34 = v34 + l__Size__16;
        end;
    end;
    l__Lighting__1.ExposureCompensation = v34;
end;
function u3.AddBlur(u37, p38, p39, p40) --[[ Line: 253 ]]
    local u41 = {
        DisableDuringRGE = p40,
        Size = (p38 or {}).Size or 0
    };
    function u41.Destroy() --[[ Line: 262 ]]
        -- upvalues: u37 (copy), u41 (copy)
        u37._blurs[u41] = nil;
    end;
    u37._blurs[u41] = p39 or 0;
    return u41;
end;
function u3.AddBrightness(u42, p43, p44, p45) --[[ Line: 269 ]]
    local u46 = {
        DisableDuringRGE = p45,
        Size = (p43 or {}).Size or 0
    };
    function u46.Destroy() --[[ Line: 278 ]]
        -- upvalues: u42 (copy), u46 (copy)
        u42._brightness[u46] = nil;
    end;
    u42._brightness[u46] = p44 or 0;
    return u46;
end;
function u3.AddExposure(u47, p48, p49, p50) --[[ Line: 285 ]]
    local u51 = {
        DisableDuringRGE = p50,
        Size = (p48 or {}).Size or 0
    };
    function u51.Destroy() --[[ Line: 294 ]]
        -- upvalues: u47 (copy), u51 (copy)
        u47._exposures[u51] = nil;
    end;
    u47._exposures[u51] = p49 or 0;
    return u51;
end;
function u3.AddBloom(u52, p53, p54, p55) --[[ Line: 301 ]]
    local v56 = p53 or {};
    local u57 = {
        Enabled = true,
        DisableDuringRGE = p55,
        Intensity = v56.Intensity or 0,
        Size = v56.Size or 0,
        Threshold = v56.Threshold or 0
    };
    function u57.Destroy() --[[ Line: 313 ]]
        -- upvalues: u52 (copy), u57 (copy)
        u52._blooms[u57] = nil;
    end;
    u52._blooms[u57] = p54 or 0;
    return u57;
end;
function u3.AddColorCorrection(u58, p59, p60, p61) --[[ Line: 320 ]]
    local v62 = p59 or {};
    local u63 = {
        Enabled = true,
        DisableDuringRGE = p61,
        Saturation = v62.Saturation or 0,
        Contrast = v62.Contrast or 0,
        Brightness = v62.Brightness or 0,
        TintColor = v62.TintColor or Color3.new(1, 1, 1)
    };
    function u63.Destroy() --[[ Line: 333 ]]
        -- upvalues: u58 (copy), u63 (copy)
        u58._colorCorrections[u63] = nil;
    end;
    u58._colorCorrections[u63] = p60 or 0;
    return u63;
end;
function u3.AddDepthOfField(u64, p65, p66, p67) --[[ Line: 340 ]]
    local v68 = p65 or {};
    local l__AutoFocus__17 = v68.AutoFocus;
    local u69 = {
        Enabled = true,
        DisableDuringRGE = p67,
        FarIntensity = v68.FarIntensity or 0,
        FocusDistance = v68.FocusDistance or (l__AutoFocus__17 and (l__AutoFocus__17.Min or 0) or 0),
        InFocusRadius = v68.InFocusRadius or 0,
        NearIntensity = v68.NearIntensity or 0,
        AutoFocus = l__AutoFocus__17
    };
    function u69.Destroy() --[[ Line: 355 ]]
        -- upvalues: u64 (copy), u69 (copy)
        u64._depthOfFields[u69] = nil;
    end;
    u64._depthOfFields[u69] = p66 or 0;
    return u69;
end;
return u3.new();