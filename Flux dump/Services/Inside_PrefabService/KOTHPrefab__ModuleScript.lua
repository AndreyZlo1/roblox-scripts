-- Services.PrefabService.KOTHPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _, _ = shared.import("require", "asset", "Enum");
local u2 = v1("POI");
local u3 = v1("ClientService");
local u4 = v1("HUDInterface", true);
local u5 = {
    Red = Color3.fromRGB(255, 10, 14),
    Orange = Color3.fromRGB(255, 150, 29),
    Blue = Color3.fromRGB(52, 133, 255),
    Yellow = Color3.fromRGB(255, 216, 57),
    Green = Color3.fromRGB(134, 255, 58)
};
local u6 = {};
u6.__index = u6;
function u6.new(p7) --[[ Line: 18 ]]
    -- upvalues: u2 (copy), u6 (copy)
    local v8 = p7:FindFirstChild("Marker");
    if not v8 then
        v8 = Instance.new("Attachment");
        v8.Name = "Marker";
        v8.CFrame = CFrame.new(0, 10, 0);
        v8.Parent = p7;
    end;
    local v9 = {
        Title = "Capture",
        Range = (1 / 0),
        Color = Color3.new(1, 1, 1)
    };
    u2[v8] = v9;
    return setmetatable({
        _part = p7,
        _attachment = v8,
        _marker = v9
    }, u6);
end;
function u6.Update(p10) --[[ Line: 44 ]]
    -- upvalues: u3 (copy), u5 (copy), u4 (copy)
    local l__LocalClient__1 = u3.LocalClient;
    if l__LocalClient__1 then
        local l___part__2 = p10._part;
        local v11 = l___part__2:GetAttribute("King");
        local v12 = l__LocalClient__1.Squad and (l__LocalClient__1.Squad == v11 and "Defend" or "Capture") or (v11 or "Neutral");
        p10._marker.Color = v11 and u5[v11] or Color3.new(1, 1, 1);
        p10._marker.Title = v12;
        local l__Actor__3 = l__LocalClient__1.Actor;
        local v13 = nil;
        if l__Actor__3 and (l__Actor__3.Alive and not l__Actor__3.Downed) then
            local v14 = l___part__2:GetAttribute("CaptureTeam");
            if v14 and v14 == l__LocalClient__1.Squad then
                local v15 = l___part__2.Size / 2;
                local v16 = l___part__2.CFrame:PointToObjectSpace(l__Actor__3.Position);
                if math.abs(v16.X) <= v15.X and (math.abs(v16.Y) <= v15.Y and math.abs(v16.Z) <= v15.Z) then
                    v13 = l___part__2:GetAttribute("CaptureTime");
                end;
            end;
        end;
        u4.Lazy.Capturing[l___part__2] = v13;
    end;
end;
function u6.Destroy(p17) --[[ Line: 81 ]]
    -- upvalues: u4 (copy), u2 (copy)
    u4.Lazy.Capturing[p17._part] = nil;
    u2[p17._attachment] = nil;
end;
return u6;