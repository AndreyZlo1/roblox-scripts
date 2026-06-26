-- Services.InventoryService.ConsumableInventory
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4 = shared.import("require", "network", "Enum", "asset");
v1("TrajectoryService");
local u5 = v1("InputService");
local u6 = v1("ItemLayout");
local u7 = v1("Consumables");
local _ = workspace.CurrentCamera;
local u8 = {};
u8.__index = u8;
function u8.new(p9, p10, p11) --[[ Line: 15 ]]
    -- upvalues: u6 (copy), u7 (copy), u4 (copy), u8 (copy)
    local v12 = u6[p10.Name];
    local l__Timer__1 = u4:Get("Animation", "ConsumableAnimations", u7[p10.Name:sub(11)].Model, "TP", "Use").Asset.Timer;
    return setmetatable({
        _nextUse = 0,
        Name = v12.Name,
        _useTimer = l__Timer__1,
        _actor = p9,
        _item = p10,
        _inventory = p11
    }, u8);
end;
function u8.Update(p13, _) --[[ Line: 33 ]]
    if p13._finish and tick() >= p13._nextUse then
        p13._inventory:Remove(p13._item.MetaData.UID);
    end;
end;
function u8.Equip(u14) --[[ Line: 39 ]]
    -- upvalues: u5 (copy), u3 (copy), u2 (copy)
    u14._equipped = true;
    local l___item__2 = u14._item;
    local l___actor__3 = u14._actor;
    u14._controls = u5:Connect({
        Discharge = function(p15) --[[ Name: Discharge, Line 45 ]]
            -- upvalues: u5 (ref), u14 (copy), l___item__2 (copy), l___actor__3 (copy), u3 (ref), u2 (ref)
            if p15 and not (u5.RadialOpen or (u5.PauseOpen or u5.InventoryOpen)) then
                if tick() < u14._nextUse or u14._finish then
                elseif l___item__2.MetaData.Open then
                    u14._nextUse = tick() + u14._useTimer;
                    l___actor__3:Action(u3.ActionType.Inventory, "Use");
                    u2:FireServer("InventoryAction", "Use");
                else
                    l___item__2.MetaData.Open = true;
                    u14._nextUse = tick() + 1;
                    l___actor__3:Action(u3.ActionType.Inventory, "Open");
                    u2:FireServer("InventoryAction", "Open");
                end;
            end;
        end
    });
end;
function u8.Used(p16, p17) --[[ Line: 67 ]]
    -- upvalues: u3 (copy)
    p16._actor:Action(u3.ActionType.Inventory, "Used", p17);
end;
function u8.Finish(p18) --[[ Line: 72 ]]
    p18._finish = true;
    if not p18._equipped then
        p18._inventory:Remove(p18._item.MetaData.UID);
    end;
end;
function u8.Unequip(p19) --[[ Line: 79 ]]
    p19._equipped = false;
    if p19._controls then
        p19._controls:Disconnect();
        p19._controls = nil;
    end;
end;
function u8.Destroy(_) --[[ Line: 87 ]] end;
return u8;