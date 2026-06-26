-- Services.ControllerService.PassengerController
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3 = shared.import("require", "network", "Enum");
local u4 = v1("InputService");
local u5 = v1("VehicleService");
local u6 = v1("NotifyInterface");
local u7 = v1("VehicleButtonInterface");
local u8 = {};
u8.__index = u8;
function u8.new(p9, p10, p11, p12) --[[ Line: 11 ]]
    -- upvalues: u8 (copy), u5 (copy), u7 (copy), u4 (copy), u2 (copy), u3 (copy)
    local v13 = setmetatable({
        _localActor = p9
    }, u8);
    local v14 = u5:GetVehicle(p10);
    if v14 and p12 then
        v13._vehicle = v14;
    end;
    if v14 and next(v14.Buttons) then
        u7:Init(p9, v14);
    end;
    v13._controls = u4:Connect({
        Exit = function(p15) --[[ Name: Exit, Line 26 ]]
            -- upvalues: u4 (ref), u2 (ref)
            if p15 and not (u4.PauseOpen or (u4.RadialOpen or u4.InventoryOpen)) then
                u2:FireServer("ActivateInteract", "Exit");
            end;
        end
    });
    p9.SeatCanEquip = p11;
    p9.HeightState = u3.CharacterHeightState.Sitting;
    return v13;
end;
function u8.Update(p16, _, _) --[[ Line: 38 ]]
    -- upvalues: u4 (copy), u6 (copy), u2 (copy)
    local l___vehicle__1 = p16._vehicle;
    if l___vehicle__1 then
        if l___vehicle__1.Rappels and not p16._rappelControls then
            u6:Notify({
                { "Alert", "Press [" .. u4:GetBind("Rappel").Name .. "] to rappel out of vehicle", Color3.new(1, 0.866666, 0.505882) }
            });
            p16._rappelControls = u4:Connect({
                Rappel = function(p17) --[[ Name: Rappel, Line 52 ]]
                    -- upvalues: u4 (ref), u2 (ref)
                    if p17 and not u4.PauseOpen then
                        u2:FireServer("ActivateInteract", "Rappel");
                    end;
                end
            });
            u4.RappelOpen = true;
            return;
        end;
        if not l___vehicle__1.Rappels and p16._rappelControls then
            p16._rappelControls:Disconnect();
            p16._rappelControls = nil;
            u4.RappelOpen = false;
        end;
    end;
end;
function u8.Destroy(p18) --[[ Line: 67 ]]
    -- upvalues: u7 (copy), u4 (copy)
    p18._localActor.SeatCanEquip = nil;
    if p18._rappelControls then
        p18._rappelControls:Disconnect();
    end;
    u7:Clear();
    p18._controls:Disconnect();
    u4.RappelOpen = false;
end;
return u8;