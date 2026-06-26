-- Services.ControllerService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, _, _ = shared.import("require", "network", "server", "asset");
local u3 = v1("ReplicatorService");
local u4 = v1("InventoryService");
local u5 = v1({
    "CharacterController",
    "TabletController",
    "PassengerController",
    "GroundController",
    "InventoryController",
    "HelicopterController",
    "LockPickController",
    "TurretController"
});
local u6 = {};
u6.__index = u6;
function u6.new() --[[ Line: 31 ]]
    -- upvalues: u6 (copy), u2 (copy), u3 (copy)
    local u7 = setmetatable({
        Controller = nil
    }, u6);
    u2:ConnectEvents({
        RegisterController = function(p8, ...) --[[ Name: RegisterController, Line 38 ]]
            -- upvalues: u7 (copy)
            u7:RegisterController(p8, ...);
        end,
        UnregisterController = function() --[[ Name: UnregisterController, Line 41 ]]
            -- upvalues: u7 (copy), u3 (ref)
            if u7.Controller then
                u7.Controller:Destroy();
            end;
            u7.Controller = nil;
            local l__LocalActor__1 = u3.LocalActor;
            if l__LocalActor__1 then
                l__LocalActor__1.Controller = nil;
            end;
        end,
        ActivateController = function(p9, ...) --[[ Name: ActivateController, Line 52 ]]
            -- upvalues: u7 (copy)
            if u7.Controller then
                if u7.Controller[p9] then
                    u7.Controller[p9](u7.Controller, ...);
                end;
            end;
        end
    });
    return u7;
end;
function u6.RegisterController(p10, p11, ...) --[[ Line: 68 ]]
    -- upvalues: u3 (copy), u4 (copy), u5 (copy)
    if p10.Controller then
        p10.Controller:Destroy();
    end;
    local l__LocalActor__2 = u3.LocalActor;
    if not l__LocalActor__2 then
        error("Attempted to set controller with no active LocalActor.");
    end;
    u4:EvalEquip();
    local v12 = u5[string.format("%sController", p11)].new(l__LocalActor__2, ...);
    p10.Controller = v12;
    l__LocalActor__2.Controller = v12;
end;
function u6.Simulated(p13, p14, p15) --[[ Line: 84 ]]
    if p13.Controller then
        p13.Controller:Update(p14, p15);
    end;
end;
return u6.new();