-- Services.VehicleService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1, v2, v3, u4 = shared.import("network", "require", "Enum", "signal");
local u5 = v2("EnvironmentService");
v2("DebugService");
local v6 = v2({ "GroundVehicle", "HelicopterVehicle" });
local u7 = {
    [v3.VehicleType.Ground] = v6.GroundVehicle,
    [v3.VehicleType.Helicopter] = v6.HelicopterVehicle
};
local u8 = {};
u8.__index = u8;
function u8.new() --[[ Line: 32 ]]
    -- upvalues: u4 (copy), u8 (copy), u1 (copy), u7 (copy)
    local v9 = {
        Vehicles = {},
        Changed = u4.new()
    };
    local u10 = setmetatable(v9, u8);
    u1:ConnectEvents({
        RegisterVehicle = function(p11, p12, p13) --[[ Name: RegisterVehicle, Line 39 ]]
            -- upvalues: u10 (copy), u7 (ref)
            if u10.Vehicles[p11] then
            else
                local v14 = u7[p13.Type].new(p11, p12, p13);
                u10.Vehicles[p11] = v14;
                v14.Model.Parent = workspace;
                v14:InitMFDs();
                u10.Changed:Fire();
            end;
        end,
        UnregisterVehicle = function(p15) --[[ Name: UnregisterVehicle, Line 51 ]]
            -- upvalues: u10 (copy)
            local v16 = u10.Vehicles[p15];
            if v16 then
                v16:Destroy();
                u10.Vehicles[p15] = nil;
                u10.Changed:Fire();
            end;
        end,
        ReplicateVehicle = function(p17, p18, p19, p20, p21, p22, p23) --[[ Name: ReplicateVehicle, Line 62 ]]
            -- upvalues: u10 (copy)
            local v24 = u10.Vehicles[p17];
            if v24 then
                v24:ReplicateTurrets(p22);
                v24.Healths = p18;
                if not v24.Controlling then
                    v24:Replicate(p19, p20, p21, p23);
                end;
            end;
        end,
        ValuesVehicle = function(p25, p26) --[[ Name: ValuesVehicle, Line 74 ]]
            -- upvalues: u10 (copy)
            local v27 = u10.Vehicles[p25];
            if v27 then
                v27.Values = p26;
            end;
        end,
        ActivateVehicle = function(p28, p29, ...) --[[ Name: ActivateVehicle, Line 82 ]]
            -- upvalues: u10 (copy)
            local v30 = u10.Vehicles[p28];
            if v30 then
                v30[p29](v30, ...);
            end;
        end,
        StateVehicle = function(p31, p32, p33) --[[ Name: StateVehicle, Line 90 ]]
            -- upvalues: u10 (copy)
            local v34 = u10.Vehicles[p31];
            if v34 then
                v34:State(p32, p33);
            end;
        end
    });
    return u10;
end;
function u8.GetVehicle(p35, p36) --[[ Line: 103 ]]
    return p35.Vehicles[p36];
end;
function u8.QueryHitbox(p37, p38) --[[ Line: 107 ]]
    local l__Parent__1 = p38.Parent;
    for _, v39 in p37.Vehicles do
        if v39.Model == l__Parent__1 then
            return v39;
        end;
    end;
end;
function u8.SetSeat(p40, p41, p42, p43) --[[ Line: 116 ]]
    local v44 = p40.Vehicles[p41];
    if v44 then
        v44.Seats[p42].Occupant = p43;
    end;
end;
function u8.GetCameraCFrame(p45, p46) --[[ Line: 125 ]]
    local v47 = p45.Vehicles[p46];
    if v47 then
        return v47.Hitbox.CFrame:ToWorldSpace(v47.CameraOffset);
    end;
end;
function u8.GetSeatAttachment(p48, p49, p50) --[[ Line: 134 ]]
    local v51 = p48.Vehicles[p49];
    if v51 then
        local v52 = v51.Seats[p50];
        if v52 then
            return v52.Attachment;
        end;
    end;
end;
function u8.GetSeatCFrame(p53, p54, p55) --[[ Line: 148 ]]
    local v56 = p53.Vehicles[p54];
    if v56 then
        local v57 = v56.Turrets[p55];
        if v57 and not v57.Static then
            return (v56.CFrame:ToWorldSpace(v57.Offset) * CFrame.Angles(0, v57.Current.X, 0)):ToWorldSpace(v57.Seat);
        end;
        local v58 = v56.Seats[p55];
        if v58 then
            return v58.Attachment.WorldCFrame;
        end;
    end;
end;
function u8.SetDoorPosition(p59, p60, p61, p62) --[[ Line: 165 ]]
    local v63 = p59.Vehicles[p60];
    if v63 then
        local v64 = v63.Doors[p61];
        if v64 then
            if v64.Open == p62 then
            else
                v64.LastUsed = tick();
                v64.From = v64.CurrentAngle;
                v64.Open = p62;
            end;
        end;
    end;
end;
function u8.GetFromBodyPart(p65, p66) --[[ Line: 185 ]]
    local l__Parent__2 = p66.Parent;
    for _, v67 in p65.Vehicles do
        if v67.Model == l__Parent__2 then
            return v67;
        end;
    end;
end;
function u8.GetHitboxCFrame(p68, p69) --[[ Line: 194 ]]
    if p68.Vehicles[p69] then
        return p68.Vehicles[p69].CFrame;
    else
        return CFrame.new();
    end;
end;
function u8.RegisterElevator(p70, p71, p72) --[[ Line: 202 ]]
    p70.Vehicles[p71] = p72;
end;
function u8.UnregisterElevator(p73, p74) --[[ Line: 206 ]]
    p73.Vehicles[p74] = nil;
end;
function u8.Simulated(p75, p76) --[[ Line: 210 ]]
    -- upvalues: u1 (copy), u5 (copy)
    local v77 = {};
    for _, v78 in p75.Vehicles do
        if not v78.IsElevator then
            v78:SyncHealthEffects();
            local v79, v80, v81, v82 = pcall(v78.Update, v78, p76);
            if v79 and (v80 and v81) then
                v81.CFrame = v80;
                if v78.Controlling then
                    local v83, v84, v85, v86, v87, v88, v89, v90, v91, v92, v93, v94 = v80:GetComponents();
                    if v78.ComponentReplicates and (v78.ComponentReplicates ~= v78.ComponentReplicatesLastReplicated and tick() - v78.ComponentReplicatesLastSentTime > 0.1) then
                        local l__ComponentReplicates__3 = v78.ComponentReplicates;
                        v78.ComponentReplicatesLastReplicated = l__ComponentReplicates__3;
                        v78.ComponentReplicatesLastSentTime = tick();
                        u1:FireServer("ReplicateVehicle", v78.UID, v83, v84, v85, v86, v87, v88, v89, v90, v91, v92, v93, v94, v78.Steering, v78.Throttle, l__ComponentReplicates__3);
                    end;
                end;
                for v95, v96 in v82 do
                    v77[v95] = v96;
                end;
            end;
        end;
    end;
    u5.Vehicles = v77;
end;
return u8.new();