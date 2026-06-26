-- Services.InventoryService.BreachInventory
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4, _ = shared.import("require", "network", "Enum", "asset", "frc");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u5 = v1("InputService");
local u6 = {};
u6.__index = u6;
function u6.new(p7, p8, p9) --[[ Line: 21 ]]
    -- upvalues: u3 (copy), u6 (copy), u4 (copy)
    local v10 = RaycastParams.new();
    v10.CollisionGroup = u3.PhysicsGroup.BotCast;
    v10.IgnoreWater = true;
    local l__Build__2 = p8.Layout.Build;
    local v11 = setmetatable({
        _placed = false,
        Name = p8.Layout.Name,
        _params = v10,
        _build = l__Build__2,
        _actor = p7,
        _item = p8,
        _inventory = p9
    }, u6);
    local v12 = u4:Get("Shared", "Models", "Gear", l__Build__2).Asset:Clone();
    local l__PrimaryPart__3 = v12.PrimaryPart;
    l__PrimaryPart__3.TextureID = "";
    l__PrimaryPart__3.Material = u3.Material.ForceField;
    l__PrimaryPart__3.Anchored = true;
    l__PrimaryPart__3.CanCollide = false;
    l__PrimaryPart__3.CanTouch = false;
    l__PrimaryPart__3.CanQuery = false;
    v11._ghostModel = v12;
    return v11;
end;
function u6.Update(p13, _) --[[ Line: 52 ]]
    -- upvalues: u3 (copy), l__CurrentCamera__1 (copy)
    local l___actor__4 = p13._actor;
    local l___ghostModel__5 = p13._ghostModel;
    local v14 = nil;
    local v15 = false;
    if not p13._placed and (l___actor__4.HeightState == u3.CharacterHeightState.Standing or l___actor__4.HeightState == u3.CharacterHeightState.Crouching) then
        local v16 = l___actor__4.CFrame.Position + Vector3.new(0, 1, 0);
        local _, v17 = l__CurrentCamera__1.CFrame:ToOrientation();
        local v18 = workspace:Raycast(v16, CFrame.Angles(0, v17, 0).LookVector * 3, p13._params);
        if v18 then
            local v19 = v18.Normal * Vector3.new(1, 0, 1);
            v14 = CFrame.new(v18.Position, v18.Position + v19) + v19 * 0.07;
            if workspace:Raycast(v18.Position, v19 * 4, p13._params) then
                v15 = true;
            else
                local v20 = v18.Position + v19 * 2.5;
                if workspace:Raycast(v20, v14.RightVector * 1.6, p13._params) then
                    v15 = true;
                elseif workspace:Raycast(v20, v14.RightVector * -1.6, p13._params) then
                    v15 = true;
                end;
            end;
        end;
    end;
    if v14 then
        l___ghostModel__5.PrimaryPart.Color = v15 and Color3.new(1, 0, 0) or Color3.new(0, 1, 0);
        l___ghostModel__5.PrimaryPart.CFrame = v14;
        l___ghostModel__5.Parent = workspace;
        if v15 then
            p13._placeCFrame = nil;
        else
            p13._placeCFrame = v14;
        end;
    else
        p13._placeCFrame = nil;
        l___ghostModel__5.Parent = nil;
    end;
end;
function u6.Equip(u21) --[[ Line: 100 ]]
    -- upvalues: u5 (copy), u3 (copy), u2 (copy)
    u21._equipped = true;
    u21._controls = u5:Connect({
        Discharge = function(p22) --[[ Name: Discharge, Line 103 ]]
            -- upvalues: u5 (ref), u21 (copy), u3 (ref), u2 (ref)
            if p22 then
                if u5.RadialOpen or (u5.PauseOpen or u5.InventoryOpen) then
                elseif u21._placed then
                    if not u21._used then
                        if tick() < u21._useAble then
                            return;
                        end;
                        if not u21._actor.BreachChargeInDistance then
                            return;
                        end;
                        u21._used = true;
                        task.delay(0.8, function() --[[ Line: 142 ]]
                            -- upvalues: u21 (ref)
                            u21._inventory:Remove(u21._item.MetaData.UID);
                        end);
                        u21._actor:Action(u3.ActionType.Inventory, "Use");
                        u2:FireServer("InventoryAction", "Use");
                    end;
                else
                    local l___placeCFrame__6 = u21._placeCFrame;
                    if l___placeCFrame__6 then
                        local l__Controller__7 = u21._actor.Controller;
                        if l__Controller__7 then
                            local v23 = (l___placeCFrame__6 - Vector3.new(0, 1, 0) + l___placeCFrame__6.LookVector * 2.5) * CFrame.Angles(0, 3.141592653589793, 0);
                            u21._placed = true;
                            u21._useAble = tick() + 2.2;
                            l__Controller__7:SetCFrame(v23, 2, true);
                            task.delay(2, function() --[[ Line: 126 ]]
                                -- upvalues: l__Controller__7 (copy)
                                l__Controller__7:SetCFrame();
                            end);
                            local _, v24 = l___placeCFrame__6:ToOrientation();
                            u21._actor:Action(u3.ActionType.Inventory, "Place", l___placeCFrame__6);
                            u2:FireServer("InventoryAction", "Place", l___placeCFrame__6.X, l___placeCFrame__6.Y, l___placeCFrame__6.Z, v24);
                        end;
                    end;
                end;
            end;
        end
    });
end;
function u6.Unequip(p25) --[[ Line: 152 ]]
    if p25._equipped then
        p25._ghostModel.Parent = nil;
        p25._equipped = false;
        if p25._controls then
            p25._controls:Disconnect();
            p25._controls = nil;
        end;
    end;
end;
function u6.Destroy(p26) --[[ Line: 166 ]]
    p26._ghostModel:Destroy();
end;
return u6;