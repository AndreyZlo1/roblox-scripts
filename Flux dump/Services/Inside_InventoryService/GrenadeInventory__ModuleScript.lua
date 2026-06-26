-- Services.InventoryService.GrenadeInventory
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3 = shared.import("require", "network", "Enum");
local u4 = v1("TrajectoryService");
local u5 = v1("InputService");
local u6 = v1("NotifyInterface");
local u7 = v1("ItemLayout");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u8 = {};
u8.__index = u8;
function u8.new(p9, p10, p11) --[[ Line: 16 ]]
    -- upvalues: u7 (copy), u8 (copy)
    local v12 = u7[p10.Name];
    return setmetatable({
        Name = v12.Name,
        _actor = p9,
        _item = p10,
        _inventory = p11,
        _type = v12.GrenadeType
    }, u8);
end;
function u8.Update(p13, _) --[[ Line: 30 ]]
    -- upvalues: l__CurrentCamera__1 (copy), u4 (copy), u3 (copy)
    if p13._preview then
        local l__LookVector__2 = (l__CurrentCamera__1.CFrame * CFrame.Angles(0.3490658503988659, 0, 0)).LookVector;
        local v14 = u4:Cast(p13._actor.CFrame:PointToWorldSpace(Vector3.new(1, 1.5, 0)) + l__LookVector__2, l__LookVector__2 * 0.8 * (p13._set and 120 or 60), u3.Material.SmoothPlastic);
        p13._path = v14;
        u4:Draw(v14);
    else
        u4:Cleanup();
    end;
end;
function u8.Equip(u15) --[[ Line: 44 ]]
    -- upvalues: u5 (copy), u3 (copy), u6 (copy), u2 (copy)
    local l___item__3 = u15._item;
    local l___actor__4 = u15._actor;
    local l___inventory__5 = u15._inventory;
    local l___type__6 = u15._type;
    u15._controls = u5:Connect({
        GrenadeHighThrow = function(p16) --[[ Name: GrenadeHighThrow, Line 51 ]]
            -- upvalues: u5 (ref), l___actor__4 (copy), l___type__6 (copy), u3 (ref), u6 (ref), u15 (copy), u2 (ref), l___inventory__5 (copy), l___item__3 (copy)
            if u5.RadialOpen or (u5.PauseOpen or u5.InventoryOpen) then
            elseif l___actor__4.CurrentState.Bunker and l___type__6 == u3.GrenadeType.Smoke then
                if p16 then
                    u6:Notify({
                        { "Alert", "You cannot use smoke grenades inside bunker", Color3.new(1, 0.866666, 0.505882) }
                    });
                end;
            else
                u15._preview = p16;
                if p16 and u15._set == nil or u15._set == true then
                    u15._set = true;
                    if p16 then
                        l___actor__4:Action(u3.ActionType.Inventory, "PullPin", true);
                        u2:FireServer("InventoryAction", "PullPin", true);
                        return;
                    end;
                    if u15._path then
                        l___actor__4:Action(u3.ActionType.Inventory, "Throw", u15._path);
                        u2:FireServer("InventoryAction", "Throw", u15._path);
                        l___inventory__5:Remove(l___item__3.MetaData.UID);
                    end;
                end;
            end;
        end,
        GrenadeLowThrow = function(p17) --[[ Name: GrenadeLowThrow, Line 82 ]]
            -- upvalues: u5 (ref), l___actor__4 (copy), l___type__6 (copy), u3 (ref), u6 (ref), u15 (copy), u2 (ref), l___inventory__5 (copy), l___item__3 (copy)
            if u5.RadialOpen or (u5.PauseOpen or u5.InventoryOpen) then
            elseif l___actor__4.CurrentState.Bunker and l___type__6 == u3.GrenadeType.Smoke then
                if p17 then
                    u6:Notify({
                        { "Alert", "You cannot use smoke grenades inside bunker", Color3.new(1, 0.866666, 0.505882) }
                    });
                end;
            else
                u15._preview = p17;
                if p17 and u15._set == nil or u15._set == false then
                    u15._set = false;
                    if p17 then
                        l___actor__4:Action(u3.ActionType.Inventory, "PullPin", false);
                        u2:FireServer("InventoryAction", "PullPin", false);
                        return;
                    end;
                    if u15._path then
                        l___actor__4:Action(u3.ActionType.Inventory, "Throw", u15._path);
                        u2:FireServer("InventoryAction", "Throw", u15._path);
                        l___inventory__5:Remove(l___item__3.MetaData.UID);
                    end;
                end;
            end;
        end
    });
end;
function u8.Unequip(p18) --[[ Line: 116 ]]
    -- upvalues: u4 (copy)
    p18._set = nil;
    p18._preview = false;
    p18._path = nil;
    if p18._controls then
        p18._controls:Disconnect();
        p18._controls = nil;
    end;
    u4:Cleanup();
end;
function u8.Destroy(_) --[[ Line: 127 ]] end;
return u8;