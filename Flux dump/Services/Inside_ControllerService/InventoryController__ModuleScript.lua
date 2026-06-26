-- Services.ControllerService.InventoryController
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "network");
local u3 = v1("InputService");
local u4 = v1("InventoryInterface");
local u5 = v1("ActionInterface");
local u6 = {};
u6.__index = u6;
function u6.new(p7, p8) --[[ Line: 10 ]]
    -- upvalues: u6 (copy), u3 (copy), u4 (copy), u5 (copy)
    local u9 = setmetatable({
        _cancelled = false,
        _localActor = p7
    }, u6);
    p7.ForcedInventory = true;
    if p7.LastHeightState then
        p7.HeightState = p7.LastHeightState;
        p7.LastHeightState = nil;
    end;
    u9._controls = u3:Connect({
        Cancel = function(p10) --[[ Name: Cancel, Line 23 ]]
            -- upvalues: u3 (ref), u9 (copy), u4 (ref)
            if p10 and not (u3.PauseOpen or u9._cancelled) then
                u4:ForceClose();
            end;
        end
    });
    u5:ForceClose();
    u4:ForceOpen(p8);
    return u9;
end;
function u6.Update(p11, _, _) --[[ Line: 35 ]]
    -- upvalues: u3 (copy), u2 (copy)
    if not (u3.InventoryOpen or p11._cancelled) then
        p11._cancelled = true;
        u2:FireServer("ActivateInteract", "Exit");
    end;
end;
function u6.Destroy(p12) --[[ Line: 42 ]]
    -- upvalues: u4 (copy)
    p12._localActor.ForcedInventory = false;
    u4:ForceClose();
    p12._controls:Disconnect();
end;
return u6;