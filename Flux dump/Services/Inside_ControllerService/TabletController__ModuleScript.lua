-- Services.ControllerService.TabletController
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "network");
local u3 = v1("InputService");
local u4 = v1("TabletInterface");
local u5 = {};
u5.__index = u5;
function u5.new(_, p6, p7, ...) --[[ Line: 10 ]]
    -- upvalues: u5 (copy), u3 (copy), u2 (copy), u4 (copy)
    local u8 = setmetatable({
        _cancelled = false
    }, u5);
    u8._controls = u3:Connect({
        Cancel = function(p9) --[[ Name: Cancel, Line 16 ]]
            -- upvalues: u3 (ref), u8 (copy), u2 (ref)
            if p9 and not (u3.PauseOpen or u8._cancelled) then
                u8._cancelled = true;
                u2:FireServer("ActivateInteract", "Exit");
            end;
        end
    });
    local v10 = {
        ScreenPart = p7
    };
    local v11 = { ... };
    if p6 == "VehicleSpawner" then
        v10.VehicleType = v11[1];
        v10.VehicleData = v11[2];
        v10.HasVehicle = v11[3];
        v10.MaxSlots = v11[4];
        v10.RepairDiscount = v11[5];
    elseif p6 == "ManageCompany" then
        v10.CompanyData = v11[1];
        v10.WasRaided = v11[2];
    elseif p6 == "Quest" then
        v10.Quests = v11[1];
        v10.QuestList = v11[2];
        v10.QuestsCompleted = v11[3];
        v10.HasQuest = v11[4];
    end;
    u4:Enable(p7, p6, v10);
    return u8;
end;
function u5.Ping(_, p12) --[[ Line: 48 ]]
    -- upvalues: u4 (copy)
    u4:Ping(p12);
end;
function u5.Update(_, _, _) --[[ Line: 52 ]] end;
function u5.Destroy(p13) --[[ Line: 56 ]]
    -- upvalues: u4 (copy)
    p13._controls:Disconnect();
    u4:Disable();
end;
return u5;