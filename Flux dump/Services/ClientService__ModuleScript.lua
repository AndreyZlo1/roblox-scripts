-- Services.ClientService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1, v2, u3 = shared.import("network", "require", "signal");
local u4 = v2("DebugService");
local u5 = v2("ClientClass");
local u6 = {};
u6.__index = u6;
function u6._checkRetry(p7, p8) --[[ Line: 20 ]]
    -- upvalues: u5 (copy)
    if p8 then
        if p7.Clients[p8] then
            return p7.Clients[p8];
        end;
        local v9 = p7._retry[p8.UserId];
        if v9 then
            local v10 = u5.new(p8, v9, p7._order);
            p7._order = p7._order + 1;
            local v11 = p7.Replicator:GetFromPlayer(p8);
            if v11 then
                v10.Actor = v11;
            end;
            p7._retry[p8.UserId] = nil;
            p7.Clients[p8] = v10;
            return v10;
        end;
    end;
end;
function u6.new() --[[ Line: 46 ]]
    -- upvalues: u3 (copy), u6 (copy), u1 (copy), u5 (copy), u4 (copy)
    local v12 = {
        _order = 1,
        LocalClient = nil,
        _retry = {},
        SquadChanged = u3.new(),
        Clients = {}
    };
    local u13 = setmetatable(v12, u6);
    u1:ConnectEvents({
        RegisterClient = function(p14, p15, p16) --[[ Name: RegisterClient, Line 58 ]]
            -- upvalues: u13 (copy), u5 (ref)
            if p14 then
                if u13.Clients[p14] then
                else
                    local v17 = u5.new(p14, p15, u13._order);
                    local v18 = u13;
                    v18._order = v18._order + 1;
                    if v17.IsLocalClient then
                        u13.LocalClient = v17;
                    end;
                    u13.Clients[p14] = v17;
                    local v19 = u13.Replicator:GetFromPlayer(p14);
                    if v19 then
                        v17.Actor = v19;
                    end;
                end;
            else
                if p16 then
                    u13._retry[p16] = p15;
                end;
            end;
        end,
        UnregisterClient = function(p20) --[[ Name: UnregisterClient, Line 84 ]]
            -- upvalues: u13 (copy)
            local v21 = u13.Clients[p20];
            if v21 then
                v21:Destroy();
                u13.Clients[p20] = nil;
            end;
        end,
        ReplicateClient = function(p22, p23, p24) --[[ Name: ReplicateClient, Line 94 ]]
            -- upvalues: u13 (copy), u4 (ref)
            local v25 = u13:_checkRetry(p22);
            if v25 then
                u4:Print("Client (" .. v25.Owner.Name .. ") Set [" .. p23 .. "] to value (" .. (tostring(p24) or "nil") .. ")", Color3.new(0, 0.137254, 0.254901));
                v25[p23] = p24;
                if p23 == "Squad" then
                    u13.SquadChanged:Fire();
                end;
            end;
        end,
        ReplicateHumanStats = function(p26, p27) --[[ Name: ReplicateHumanStats, Line 111 ]]
            -- upvalues: u13 (copy)
            local l__LocalClient__1 = u13.LocalClient;
            if l__LocalClient__1 then
                l__LocalClient__1:UpdateHumanStats(p26, p27);
            end;
        end
    });
    return u13;
end;
function u6.GetClientFromName(p28, p29) --[[ Line: 122 ]]
    for _, v30 in p28.Clients do
        if v30.Owner.Name == p29 then
            return v30;
        end;
    end;
end;
function u6.GetClients(p31) --[[ Line: 130 ]]
    local v32 = {};
    for _, v33 in p31.Clients do
        v32[#v32 + 1] = v33;
    end;
    return v32;
end;
return u6.new();