-- ReplicatedFirst.Flux/client
-- LocalScript | dc

-- Decompiled with Potassium's decompiler.

local l__Players__1 = game:GetService("Players");
local l__HttpService__2 = game:GetService("HttpService");
local l__StarterGui__3 = game:GetService("StarterGui");
local l__ReplicatedStorage__4 = game:GetService("ReplicatedStorage");
local l__TeleportService__5 = game:GetService("TeleportService");
local l__ReplicatedFirst__6 = game:GetService("ReplicatedFirst");
local l__LocalPlayer__7 = l__Players__1.LocalPlayer;
local v1 = l__TeleportService__5:GetLocalPlayerTeleportData();
if v1 then
    shared.teleportData = v1;
end;
local v2 = l__TeleportService__5:GetArrivingTeleportGui();
if v2 then
    l__ReplicatedFirst__6:RemoveDefaultLoadingScreen();
    v2.Parent = l__LocalPlayer__7:WaitForChild("PlayerGui");
    shared.landing = v2;
end;
task.spawn(function() --[[ Line: 46 ]]
    -- upvalues: l__StarterGui__3 (copy)
    while not pcall(l__StarterGui__3.SetCoreGuiEnabled, l__StarterGui__3, Enum.CoreGuiType.All, false) do
        task.wait();
    end;
end);
local l__Events__8 = l__ReplicatedStorage__4:WaitForChild("Events");
local l__RemoteEvent__9 = l__Events__8:WaitForChild("RemoteEvent");
local l__UnreliableRemoteEvent__10 = l__Events__8:WaitForChild("UnreliableRemoteEvent");
local l__RemoteFunction__11 = l__Events__8:WaitForChild("RemoteFunction");
local l__VerifyFunction__12 = l__Events__8:WaitForChild("VerifyFunction");
local u3 = {};
u3.__index = u3;
local function u16(p4, p5) --[[ Line: 78 ]]
    local v6 = "";
    for v7 = 1, #p4 do
        for v8 = 0, 3 do
            if v7 % 4 == v8 then
                local v9 = string.sub(p4, v7, v7);
                local v10 = p5[v8 + 1];
                local v11 = (string.byte(v9) - 32 + v10) % 95 + 32;
                v6 = v6 .. string.char(v11);
                break;
            end;
        end;
    end;
    for v12 = 1, p5[5] do
        local v13 = string.byte(p4);
        local v14 = tostring(v12);
        local v15 = v13 - string.byte(v14);
        v6 = v6 .. string.char(v15);
    end;
    return v6;
end;
local u17 = {};
u17.__index = u17;
function u17.new() --[[ Line: 97 ]]
    -- upvalues: l__VerifyFunction__12 (copy), l__LocalPlayer__7 (copy), l__HttpService__2 (copy), u17 (copy)
    local v18 = l__VerifyFunction__12:InvokeServer();
    local l__Key__13 = l__LocalPlayer__7:WaitForChild("PlayerGui"):WaitForChild("Key");
    local v19 = {
        _events = {},
        _functions = {},
        _code = v18,
        _key = l__HttpService__2:JSONDecode(l__Key__13.Value)
    };
    local v20 = setmetatable(v19, u17);
    l__Key__13.Value = "";
    l__Key__13:Destroy();
    return v20;
end;
function u17.Listen(u21) --[[ Line: 112 ]]
    -- upvalues: l__RemoteEvent__9 (copy), l__UnreliableRemoteEvent__10 (copy), l__RemoteFunction__11 (copy)
    l__RemoteEvent__9.OnClientEvent:Connect(function(p22, ...) --[[ Line: 113 ]]
        -- upvalues: u21 (copy)
        local v23 = u21._events[p22];
        if v23 then
            v23(...);
        end;
    end);
    l__UnreliableRemoteEvent__10.OnClientEvent:Connect(function(p24, ...) --[[ Line: 120 ]]
        -- upvalues: u21 (copy)
        local v25 = u21._events[p24];
        if v25 then
            v25(...);
        end;
    end);
    function l__RemoteFunction__11.OnClientInvoke(p26, ...) --[[ Line: 127 ]]
        -- upvalues: u21 (copy)
        local v27 = u21._functions[p26];
        if v27 then
            return v27(...);
        end;
    end;
end;
function u17.FireServer(p28, ...) --[[ Line: 135 ]]
    -- upvalues: l__RemoteEvent__9 (copy), u16 (copy), l__HttpService__2 (copy)
    l__RemoteEvent__9:FireServer((u16(l__HttpService__2:JSONEncode({ p28._code, ... }), p28._key)));
end;
function u17.FireUnreliableServer(_, ...) --[[ Line: 139 ]]
    -- upvalues: l__UnreliableRemoteEvent__10 (copy), l__HttpService__2 (copy)
    l__UnreliableRemoteEvent__10:FireServer(l__HttpService__2:JSONEncode({ ... }));
end;
function u17.InvokeServer(p29, ...) --[[ Line: 143 ]]
    -- upvalues: l__RemoteFunction__11 (copy), u16 (copy), l__HttpService__2 (copy)
    return l__RemoteFunction__11:InvokeServer((u16(l__HttpService__2:JSONEncode({ p29._code, ... }), p29._key)));
end;
function u17.ConnectEvents(p30, p31) --[[ Line: 147 ]]
    for v32, v33 in p31 do
        p30._events[v32] = v33;
    end;
end;
function u17.ConnectFunctions(p34, p35) --[[ Line: 153 ]]
    for v36, v37 in p35 do
        p34._functions[v36] = v37;
    end;
end;
function u3.new() --[[ Line: 159 ]]
    -- upvalues: u3 (copy), l__ReplicatedStorage__4 (copy), u17 (copy), l__ReplicatedFirst__6 (copy), l__VerifyFunction__12 (copy)
    local v38 = setmetatable({}, u3);
    local u39 = {};
    for _, v40 in l__ReplicatedStorage__4:WaitForChild("Packages"):GetChildren() do
        if u39[v40.Name] then
            error("Attempted to load two or more packages by the same name (" .. v40.Name .. ")");
        end;
        u39[v40.Name] = v40;
    end;
    local u41 = u17.new();
    function shared.import(...) --[[ Line: 171 ]]
        -- upvalues: u41 (copy), u39 (copy)
        local v42 = {};
        for v43, v44 in { ... } do
            if v44 == "network" then
                v42[v43] = u41;
            elseif u39[v44] then
                v42[v43] = require(u39[v44]);
            else
                error("Attempted to import an unknown package (" .. v44 .. "), " .. debug.traceback());
            end;
        end;
        return unpack(v42);
    end;
    shared.import("require")("ClientHandler");
    shared.import = nil;
    l__ReplicatedFirst__6:RemoveDefaultLoadingScreen();
    task.spawn(l__VerifyFunction__12.InvokeServer, l__VerifyFunction__12);
    l__VerifyFunction__12:Destroy();
    script:Destroy();
    return v38;
end;
u3.new();