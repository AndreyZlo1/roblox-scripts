-- Services.CameraService.SpectateCamera
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1 = shared.import("require");
local u2 = v1("ViewmodelService");
local u3 = v1("ClientService");
local u4 = v1("InputService");
local u5 = v1("HUDInterface");
local l__LocalPlayer__1 = game:GetService("Players").LocalPlayer;
local l__CurrentCamera__2 = workspace.CurrentCamera;
local u6 = {};
u6.__index = u6;
function u6.new() --[[ Line: 17 ]]
    -- upvalues: u6 (copy), u5 (copy), u4 (copy)
    local u7 = setmetatable({
        _x = 0,
        _spectating = 1,
        _spectatingList = 1
    }, u6);
    u5:UpdateSpectating(true);
    u7._controls = u4:Connect({
        SpectateNext = function(p8) --[[ Name: SpectateNext, Line 27 ]]
            -- upvalues: u7 (copy)
            if p8 then
                if u7._spectating >= u7._spectatingList then
                    u7._spectating = 1;
                    return;
                end;
                local v9 = u7;
                v9._spectating = v9._spectating + 1;
            end;
        end,
        SpectatePrev = function(p10) --[[ Name: SpectatePrev, Line 36 ]]
            -- upvalues: u7 (copy)
            if p10 then
                if u7._spectating <= 1 then
                    u7._spectating = u7._spectatingList;
                    return;
                end;
                local v11 = u7;
                v11._spectating = v11._spectating - 1;
            end;
        end
    });
    return u7;
end;
function u6.Update(p12, p13, _) --[[ Line: 50 ]]
    -- upvalues: u3 (copy), l__LocalPlayer__1 (copy), u2 (copy), l__CurrentCamera__2 (copy)
    p12._x = p12._x - p13.X;
    local v14 = u3.Clients[l__LocalPlayer__1];
    local v15 = {};
    for _, v16 in u3:GetClients() do
        if v16 ~= v14 and (v16 and (v16.Actor and (v16.Actor.Alive and (v14.Squad == nil or v16.Squad == v14.Squad)))) then
            v15[#v15 + 1] = v16;
        end;
    end;
    table.sort(v15, function(p17, p18) --[[ Line: 66 ]]
        return p17.Order + (p17.Squad == "Red" and 1000 or 0) < p18.Order + (p18.Squad == "Red" and 1000 or 0);
    end);
    if #v15 > 0 then
        local v19 = math.clamp(p12._spectating, 1, #v15);
        if #v15 ~= p12._spectatingList then
            if p12._lastSpectate then
                v19 = table.find(v15, p12._lastSpectate) or v19;
            end;
            p12._spectatingList = #v15;
        end;
        p12._spectating = v19;
        local v20 = v15[v19];
        local l__Actor__3 = v20.Actor;
        l__Actor__3.Zoom = 0;
        l__Actor__3.Focused = true;
        local l__Viewmodel__4 = u2.Viewmodel;
        if p12._lastSpectate ~= v20 or l__Viewmodel__4 and l__Viewmodel__4.Actor ~= l__Actor__3 then
            local l___lastSpectate__5 = p12._lastSpectate;
            if l___lastSpectate__5 then
                l___lastSpectate__5 = p12._lastSpectate.Actor;
            end;
            if l___lastSpectate__5 then
                l___lastSpectate__5.Focused = false;
            end;
            p12._lastSpectate = v20;
            u2:RegisterViewmodel(l__Actor__3);
            l__Actor__3:Reequip();
        end;
        if l__Viewmodel__4 then
            local v21 = 0;
            local l__Magnifier__6 = l__Viewmodel__4.Magnifier;
            if l__Magnifier__6 then
                v21 = v21 + l__Magnifier__6.FOV * l__Magnifier__6.Lerp * l__Viewmodel__4.ADSLerp * (l__Viewmodel__4.Canted and (1 - l__Viewmodel__4.Canted or 1) or 1);
            end;
            if l__Viewmodel__4.ADSFOV then
                v21 = v21 + l__Viewmodel__4.ADSFOV * l__Viewmodel__4.ADSLerp;
            end;
            l__CurrentCamera__2.FieldOfView = 70 + l__Viewmodel__4.CQB * 10 * (1 - l__Viewmodel__4.ADSLerp) - v21 + (l__Viewmodel__4.NVGFOV or 0) + ((1 - l__Viewmodel__4.SprintLerp) * 10 or 0);
        end;
        l__CurrentCamera__2.CFrame = CFrame.new(l__Actor__3.Position + Vector3.new(0, 2.35, 0)) * CFrame.Angles(0, l__Actor__3.CameraX, 0) * CFrame.Angles(l__Actor__3.CameraY, 0, 0);
    else
        if p12._lastSpectate then
            u2:UnregisterViewmodel();
            local l__Actor__7 = p12._lastSpectate.Actor;
            if l__Actor__7 then
                l__Actor__7.Focused = false;
            end;
            p12._lastSpectate = nil;
        end;
        p12._spectating = 1;
        local v22 = l__CurrentCamera__2;
        local l__new__8 = CFrame.new;
        local v23 = math.sin(p12._x) * 15;
        local v24 = math.cos(p12._x) * 15;
        v22.CFrame = l__new__8(Vector3.new(v23, 10, v24), Vector3.new(0, 4, 0)) + workspace.Terrain.Objective.CFrame.Position;
        l__CurrentCamera__2.FieldOfView = 70;
    end;
    l__CurrentCamera__2.Focus = CFrame.new(l__CurrentCamera__2.CFrame.Position);
end;
function u6.Shake(_) --[[ Line: 134 ]] end;
function u6.Destroy(p25) --[[ Line: 137 ]]
    -- upvalues: u5 (copy), u2 (copy)
    u5:UpdateSpectating(false);
    u2:UnregisterViewmodel();
    p25._controls:Disconnect();
    local v26 = p25._lastSpectate and p25._lastSpectate.Actor;
    if v26 then
        v26.Focused = false;
    end;
end;
return u6;