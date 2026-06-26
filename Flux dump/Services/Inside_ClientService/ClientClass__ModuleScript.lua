-- Services.ClientService.ClientClass
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local u3 = v1("Menu");
local u4 = v1("DebugService");
local u5 = v1("StatsService");
local u6 = v1("AttachableComponent");
local l__MarketplaceService__1 = game:GetService("MarketplaceService");
local l__LocalPlayer__2 = game:GetService("Players").LocalPlayer;
local u7 = {
    7233611,
    194157058,
    131945411,
    6133997
};
local u8 = {};
u8.__index = u8;
function u8._checkGamepass(p9, p10) --[[ Line: 19 ]]
    -- upvalues: l__MarketplaceService__1 (copy)
    local v11, v12 = pcall(l__MarketplaceService__1.UserOwnsGamePassAsync, l__MarketplaceService__1, p9.Owner.UserId, p10);
    if v11 and v12 == true then
        p9._gamepasses[#p9._gamepasses + 1] = p10;
    end;
end;
function u8.new(p13, p14, p15) --[[ Line: 26 ]]
    -- upvalues: u8 (copy), l__LocalPlayer__2 (copy), u2 (copy), u7 (copy), u4 (copy)
    local u16 = setmetatable({
        Kills = 0,
        Deaths = 0,
        Unlocked = nil,
        Appearance = nil,
        Loadouts = nil,
        ActiveLoadout = nil,
        Order = p15,
        Owner = p13,
        _gamepasses = {}
    }, u8);
    if p13 == l__LocalPlayer__2 then
        u16.IsLocalClient = true;
        local v17, v18 = u2.createBinding(1);
        local v19, v20 = u2.createBinding(1);
        u16.Hunger = v17;
        u16.Thirst = v19;
        u16._updateHunger = v18;
        u16._updateThirst = v20;
        task.spawn(function() --[[ Line: 53 ]]
            -- upvalues: u7 (ref), u16 (copy)
            for _, v21 in u7 do
                u16:_checkGamepass(v21);
            end;
        end);
    end;
    for v22, v23 in p14 do
        u16[v22] = v23;
    end;
    u4:Print("Joined client (" .. p13.Name .. ")", Color3.new(0, 0.137254, 0.254901));
    return u16;
end;
function u8.UpdateHumanStats(p24, p25, p26) --[[ Line: 68 ]]
    p24._updateHunger(p25);
    p24._updateThirst(p26);
end;
function u8.HasGamepass(p27, p28) --[[ Line: 73 ]]
    if p28 == 0 then
        return true;
    end;
    if table.find(p27._gamepasses, p28) then
        return true;
    end;
    task.spawn(p27._checkGamepass, p27, p28);
    return false;
end;
function u8.UnlockComponent(p29, p30) --[[ Line: 85 ]]
    local l__Unlocked__3 = p29.Unlocked;
    for v31 = 1, #p30 do
        local v32 = p30[v31];
        l__Unlocked__3[v32] = l__Unlocked__3[v32] or {};
        l__Unlocked__3 = l__Unlocked__3[v32];
    end;
end;
function u8.IsComponentUnlocked(p33, p34, p35, p36) --[[ Line: 96 ]]
    -- upvalues: u3 (copy), u6 (copy), u5 (copy)
    local v37 = u3;
    if p35 then
        local v38 = table.clone(p34);
        table.remove(v38, #v38);
        local v39 = u6.new(v38);
        v37 = v39:GetCamoConfig(p34[#p34]);
        v39:Destroy();
    else
        for v40 = 1, #p34 do
            v37 = v37[p34[v40]];
        end;
    end;
    if not v37 then
        return true;
    end;
    if v37.Gamepass then
        if p36 then
            return false;
        end;
        if not p33:HasGamepass(v37.Gamepass) then
            return false;
        end;
    end;
    if (v37.Price or 0) == 0 and ((v37.Level or 0) <= u5.Level and (v37.ForSale ~= false and v37.OutOfStock ~= true)) then
        return true;
    end;
    local l__Unlocked__4 = p33.Unlocked;
    for v41 = 1, #p34 do
        l__Unlocked__4 = l__Unlocked__4[p34[v41]];
        if not l__Unlocked__4 then
            return false;
        end;
    end;
    return true;
end;
function u8.Destroy(p42) --[[ Line: 145 ]]
    -- upvalues: u4 (copy)
    u4:Print("Left client (" .. p42.Owner.Name .. ")", Color3.new(0, 0.137254, 0.254901));
end;
return u8;