-- Services.ReplicatorService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1, v2, u3 = shared.import("network", "require", "Enum");
local l__Players__1 = game:GetService("Players");
local l__ReplicatedFirst__2 = game:GetService("ReplicatedFirst");
local u4 = v2("ViewmodelService");
local u5 = v2("ClientService");
local u6 = v2("EffectsService");
local u7 = v2("PrefabService");
local u8 = v2("VehicleService");
v2("DebugService");
local u9 = v2("ActorClass");
local u10 = v2("ZombieClass");
local u11 = v2("GameSettings");
local l__CurrentCamera__3 = workspace.CurrentCamera;
local l__LocalPlayer__4 = l__Players__1.LocalPlayer;
local u12 = { u3.ActionType.Inventory, u3.ActionType.Helmet, u3.ActionType.FunctionIgnoreClient };
local u13 = {};
u13.__index = u13;
function u13._bulletProcess(p14, p15, p16, _, p17, _, _, p18) --[[ Line: 47 ]]
    -- upvalues: u3 (copy), u8 (copy), u1 (copy)
    if p17 and p16 then
        local v19 = nil;
        local v20, _, v21 = p14:GetFromBodyPart(p17);
        local v22;
        if v20 then
            v22 = {
                Type = u3.DamageType.Actor,
                Part = p17.Name,
                UID = v20,
                Unix = v21
            };
        else
            local v23, _, v24 = u8:GetFromBodyPart(p17);
            v22 = v23 and {
                Type = u3.DamageType.Vehicle,
                Component = p17:GetAttribute("Component") or "Hull",
                UID = v23.UID,
                Unix = v24
            } or v19;
        end;
        if v22 then
            u1:FireServer("ReplicateBullet", p15, p18, v22);
        end;
    end;
end;
function u13._bulletEffects(p25, p26, p27, p28, p29, p30, p31, p32) --[[ Line: 79 ]]
    -- upvalues: u6 (copy)
    local v33, v34 = p25:GetFromBodyPart(p28);
    u6:BulletLand(p26, p27, p28, p29, v33 and "Blood" or p30, p31, p32);
    if v34 and v34.Zombie then
        v34:Flinch(p28.Name);
    end;
end;
function u13._bulletClack(_, p35, p36) --[[ Line: 87 ]]
    -- upvalues: u6 (copy)
    u6:BulletClack(p35, p36);
end;
function u13.ShatterGlass(_, p37, ...) --[[ Line: 91 ]]
    -- upvalues: u7 (copy)
    local v38 = u7:GetPrefab(p37);
    if v38 then
        v38:Shatter(...);
        return true;
    end;
end;
function u13.new() --[[ Line: 100 ]]
    -- upvalues: u13 (copy), l__ReplicatedFirst__2 (copy), u1 (copy), u10 (copy), u9 (copy), l__LocalPlayer__4 (copy), u4 (copy), u5 (copy), u12 (copy)
    local v39 = Instance.new("BindableEvent");
    v39.Name = "BulletEvent";
    local u40 = setmetatable({
        _lastReplicate = 0,
        Actors = {}
    }, u13);
    v39.Event:Connect(function(p41, ...) --[[ Line: 109 ]]
        -- upvalues: u40 (copy)
        if p41 == 1 then
            u40:_bulletProcess(...);
        elseif p41 == 2 then
            u40:_bulletEffects(...);
        elseif p41 == 3 then
            u40:ShatterGlass(...);
        else
            if p41 == 4 then
                u40:_bulletClack(...);
            end;
        end;
    end);
    v39.Parent = l__ReplicatedFirst__2;
    u1:ConnectEvents({
        RegisterActor = function(p42, p43, p44, p45) --[[ Name: RegisterActor, Line 123 ]]
            -- upvalues: u40 (copy), u10 (ref), u9 (ref), l__LocalPlayer__4 (ref), u4 (ref), u5 (ref)
            if u40.Actors[p42] then
            else
                local v46;
                if p45 then
                    v46 = u10.new(u40, p43, p44, p42);
                else
                    v46 = u9.new(u40, p43, p44, p42);
                end;
                v46.UID = p42;
                if p43 == l__LocalPlayer__4 then
                    u4:RegisterViewmodel(v46);
                    u40.LocalActor = v46;
                    u40._uid = p42;
                end;
                u40.Actors[p42] = v46;
                if u5.Clients[p43] then
                    u5.Clients[p43].Actor = v46;
                end;
            end;
        end,
        UnregisterActor = function(p47) --[[ Name: UnregisterActor, Line 149 ]]
            -- upvalues: u40 (copy), u4 (ref), u5 (ref)
            local v48 = u40.Actors[p47];
            if v48 then
                if u40.LocalActor == v48 then
                    u4:UnregisterViewmodel();
                    u40.LocalActor = nil;
                    u40._uid = nil;
                end;
                local l__Owner__5 = v48.Owner;
                v48:Destroy();
                u40.Actors[p47] = nil;
                if u5.Clients[l__Owner__5] and u5.Clients[l__Owner__5].Actor == v48 then
                    u5.Clients[l__Owner__5].Actor = nil;
                end;
            end;
        end,
        ReplicateActor = function(p49, p50, p51, p52, p53, p54, p55, p56, p57, p58, p59) --[[ Name: ReplicateActor, Line 171 ]]
            -- upvalues: u40 (copy)
            local v60 = u40.Actors[p49];
            if v60 then
                v60.Seat = p59;
                if p49 == u40._uid then
                    v60.Health = p50;
                else
                    v60:Replicate(p50, p51, p52, p53, p54, p55, p56, p57, p58);
                end;
            end;
        end,
        ReplicateBulkActor = function(p61) --[[ Name: ReplicateBulkActor, Line 189 ]]
            -- upvalues: u40 (copy)
            for _, v62 in p61 do
                local v63, v64, v65, v66, v67, v68, v69, v70, v71, v72, v73, v74 = unpack(v62);
                local v75 = u40.Actors[v63];
                if v75 then
                    v75.Seat = v74;
                    if v63 == u40._uid then
                        v75.Health = v64;
                    else
                        v75:Replicate(v64, v65, v66, v67, v68, v69, v70, v71, v72, v73);
                    end;
                end;
            end;
        end,
        StateActor = function(p76, p77, p78, p79) --[[ Name: StateActor, Line 212 ]]
            -- upvalues: u40 (copy)
            local v80 = u40.Actors[p76];
            if v80 then
                if v80 == u40.LocalActor and not p79 then
                else
                    v80:State(p77, p78);
                end;
            end;
        end,
        ActionActor = function(p81, p82, p83, ...) --[[ Name: ActionActor, Line 223 ]]
            -- upvalues: u40 (copy), u12 (ref)
            local v84 = u40.Actors[p81];
            if v84 then
                if v84 == u40.LocalActor and table.find(u12, p82) then
                else
                    v84:Action(p82, p83, ...);
                end;
            end;
        end
    });
    u5.Replicator = u40;
    return u40;
end;
function u13.GetFromPlayer(p85, p86) --[[ Line: 241 ]]
    for _, v87 in p85.Actors do
        if v87.Owner == p86 then
            return v87;
        end;
    end;
end;
function u13.GetFromBodyPart(p88, p89) --[[ Line: 249 ]]
    if p89 then
        local l__Parent__6 = p89.Parent;
        if l__Parent__6 then
            for _, v90 in p88.Actors do
                if l__Parent__6 == v90.Character then
                    return v90:GetSelf(p89);
                end;
            end;
        end;
    end;
end;
function u13.GetActors(p91) --[[ Line: 266 ]]
    return p91.Actors;
end;
function u13.GetActorPosition(p92, p93) --[[ Line: 270 ]]
    local v94 = p92.Actors[p93];
    if v94 and v94.Alive then
        return v94.UseClient and v94.Position or v94.ServerPosition;
    end;
end;
function u13.GetClientFromPart(p95, p96) --[[ Line: 277 ]]
    -- upvalues: u5 (copy)
    local _, v97 = p95:GetFromBodyPart(p96);
    if v97 then
        return u5.Clients[v97.Owner], v97, v97.OwnerName;
    end;
end;
function u13.Update(p98, p99) --[[ Line: 284 ]]
    -- upvalues: u1 (copy), u11 (copy), l__CurrentCamera__3 (copy), u3 (copy)
    debug.profilebegin("ActorsUpdate");
    local l___uid__7 = p98._uid;
    local l__LocalActor__8 = p98.LocalActor;
    if l__LocalActor__8 and l___uid__7 then
        local v100 = tick();
        if p98._lastReplicate < v100 then
            local v101 = l__LocalActor__8.ForceNextPosition or l__LocalActor__8.SimulatedPosition;
            u1:FireUnreliableServer("ReplicateMovement", l___uid__7, v101.X, v101.Y, v101.Z, l__LocalActor__8.Orientation, l__LocalActor__8.Sprinting, l__LocalActor__8.HeightState, l__LocalActor__8.CameraX, l__LocalActor__8.CameraY, l__LocalActor__8.LeanGoal, l__LocalActor__8.Platform);
            l__LocalActor__8.ForceNextPosition = nil;
            p98._lastReplicate = v100 + 0.1;
        end;
    end;
    local v102 = {};
    for _, v103 in p98.Actors do
        v103.OnScreen = false;
        if v103.LOD_OnScreen then
            v102[#v102 + 1] = { v103, v103.LOD_Distance };
        else
            v102[#v102 + 1] = { v103, (1 / 0) };
        end;
    end;
    table.sort(v102, function(p104, p105) --[[ Line: 309 ]]
        return p104[2] < p105[2];
    end);
    local v106 = u11.WorldDetail or 1;
    local l__Position__9 = l__CurrentCamera__3.Focus.Position;
    local l__CFrame__10 = l__CurrentCamera__3.CFrame;
    local v107 = 0;
    local v108 = {};
    local v109 = {};
    for v110, v111 in v102 do
        local v112 = v111[1];
        if v110 <= 10 then
            v112.OnScreen = true;
        end;
        local v113, v114 = v112:Update(v106, l__Position__9, l__CFrame__10, p99);
        if v113 then
            v108[v107 + 1] = v114;
            v109[v107 + 1] = v113;
            v107 = v107 + 1;
        end;
    end;
    workspace:BulkMoveTo(v108, v109, u3.BulkMoveMode.FireCFrameChanged);
    debug.profileend();
end;
function u13.Render(p115, p116) --[[ Line: 338 ]]
    debug.profilebegin("ActorsRender");
    for _, v117 in p115.Actors do
        v117:Render(p116);
    end;
    debug.profileend();
end;
function u13.Stepped(p118, p119) --[[ Line: 348 ]]
    debug.profilebegin("ActorsStepped");
    for _, v120 in p118.Actors do
        v120:Stepped(p119);
    end;
    debug.profileend();
end;
return u13.new();