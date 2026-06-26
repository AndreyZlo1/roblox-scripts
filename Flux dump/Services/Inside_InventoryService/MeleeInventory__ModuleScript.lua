-- Services.InventoryService.MeleeInventory
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4 = shared.import("require", "network", "Enum", "asset");
v1("ReplicatorService");
v1("EffectsService");
local u5 = v1("InputService");
local u6 = v1("Calibers");
local u7 = v1("vector3toTable");
local u8 = v1("Melee");
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u9 = {};
u9.__index = u9;
function u9._use(u10, p11) --[[ Line: 19 ]]
    -- upvalues: u3 (copy), u2 (copy), l__CurrentCamera__1 (copy), u7 (copy)
    u10._swinging = p11;
    if u10._swinging and not (u10._looping or (u10._actor.Sprinting or u10._actor.Locked)) then
        u10._looping = true;
        while u10._swinging and not (u10._actor.Sprinting or u10._actor.Locked) do
            local v12 = math.random(1, 3);
            u10._actor:Action(u3.ActionType.Inventory, "Slash", v12);
            u2:FireServer("InventoryAction", "Slash", v12);
            task.delay(u10._delay, function() --[[ Line: 29 ]]
                -- upvalues: l__CurrentCamera__1 (ref), u10 (copy), u3 (ref), u2 (ref), u7 (ref)
                local v13, v14, v15 = u10._actor:Action(u3.ActionType.Inventory, "Impact", l__CurrentCamera__1.CFrame.LookVector * u10._distance);
                if v13 then
                    u2:FireServer("InventoryAction", "Impact", u7(v13), v14, v15);
                end;
            end);
            task.wait(u10._timer);
        end;
        u10._looping = false;
    end;
end;
function u9.new(p16, p17, p18) --[[ Line: 43 ]]
    -- upvalues: u8 (copy), u9 (copy), u4 (copy), u6 (copy)
    local l__Build__2 = p17.Layout.Build;
    local v19 = u8[l__Build__2];
    local v20 = setmetatable({
        Name = p17.Layout.Name,
        _build = l__Build__2,
        _timer = v19.Time,
        _delay = v19.Delay,
        _distance = v19.Reach,
        _breaching = v19.Breaching,
        _actor = p16,
        _item = p17,
        _inventory = p18
    }, u9);
    for v21 = 1, 3 do
        u4:Get("Animation", "MeleeAnimations", l__Build__2, "FP", "Hit" .. v21):Preload();
        u4:Get("Sound", "MeleeSounds", l__Build__2, "Hit" .. v21):Preload();
    end;
    local v22 = u6["melee_" .. l__Build__2];
    if v22.Sound then
        u4:Get("Sound", "MeleeImpacts", v22.Sound, "Head"):Preload();
        u4:Get("Sound", "MeleeImpacts", v22.Sound, "Body"):Preload();
    end;
    return v20;
end;
function u9.Update(_, _) --[[ Line: 76 ]] end;
function u9.Equip(u23) --[[ Line: 79 ]]
    -- upvalues: u5 (copy)
    if u23._breaching then
        u23._actor.BreachToolEquipped = true;
    end;
    u23._controls = u5:Connect({
        Discharge = function(p24) --[[ Name: Discharge, Line 85 ]]
            -- upvalues: u5 (ref), u23 (copy)
            if u5.RadialOpen or (u5.PauseOpen or u5.InventoryOpen) then
                p24 = false;
            end;
            u23:_use(p24);
        end
    });
end;
function u9.Unequip(p25) --[[ Line: 94 ]]
    p25._actor.BreachToolEquipped = nil;
    p25._swinging = false;
    if p25._controls then
        p25._controls:Disconnect();
        p25._controls = nil;
    end;
end;
function u9.Destroy(_) --[[ Line: 103 ]] end;
return u9;