-- Services.InventoryService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4, u5, u6 = shared.import("require", "network", "signal", "Enum", "server", "asset");
local u7 = v1("SharedInventory");
local u8 = v1("InventoryClass");
local u9 = v1("HUDInterface");
local u10 = v1("NotifyInterface");
local u11 = v1("TutorialInterface");
local u12 = v1("InteractionInterface");
local u13 = v1("EnvironmentService");
local u14 = v1("ClientService");
local u15 = v1("ReplicatorService");
local u16 = v1("InputService");
local u17 = v1("FluidSimulation");
local u18 = v1("Consumables");
local u19 = v1("ItemLayout");
local u20 = v1("StorageLayout");
local u21 = v1("BaseComponent");
local u22 = v1({
    "GrenadeInventory",
    "FirearmInventory",
    "MeleeInventory",
    "RocketInventory",
    "ConsumableInventory",
    "GearInventory",
    "BreachInventory",
    "DroneInventory"
});
local l__Players__1 = game:GetService("Players");
local l__Terrain__2 = workspace.Terrain;
local l__LocalPlayer__3 = l__Players__1.LocalPlayer;
local l__CurrentCamera__4 = workspace.CurrentCamera;
local u23 = {};
u23.__index = u23;
local function u30(p24, u25) --[[ Line: 43 ]]
    -- upvalues: u21 (copy), u4 (copy)
    local l__ParentModel__5 = u21.Deserialize(p24.MetaData.Build).ParentModel;
    local u26 = l__ParentModel__5.PrimaryPart:FindFirstChild("anchor");
    l__ParentModel__5.PrimaryPart.Anchored = true;
    local l__ItemType__6 = p24.Layout.ItemType;
    task.defer(function() --[[ Line: 51 ]]
        -- upvalues: l__ParentModel__5 (copy), u26 (copy), l__ItemType__6 (copy), u4 (ref), u25 (copy)
        l__ParentModel__5.PrimaryPart = nil;
        if u26 then
            if l__ItemType__6 == u4.ItemType.Backpack then
                local v27 = u26;
                v27.CFrame = v27.CFrame + Vector3.new(0, 0, 0.5);
            elseif l__ItemType__6 == u4.ItemType.Vest then
                local v28 = u26;
                v28.CFrame = v28.CFrame - Vector3.new(0, 0, 0.5);
            elseif l__ItemType__6 == u4.ItemType.Facewear then
                local v29 = u26;
                v29.CFrame = v29.CFrame - Vector3.new(0, 0, 0.25);
            end;
            l__ParentModel__5.WorldPivot = u26.WorldCFrame;
        else
            l__ParentModel__5.WorldPivot = l__ParentModel__5:GetBoundingBox();
        end;
        l__ParentModel__5:PivotTo(u25 * CFrame.Angles(l__ItemType__6 == u4.ItemType.Backpack and -1.5707963267948966 or (l__ItemType__6 == u4.ItemType.Helmet and 0 or (l__ItemType__6 == u4.ItemType.Eyewear and 0 or 1.5707963267948966)), 0, 0));
    end);
    return l__ParentModel__5, true;
end;
local u86 = {
    [u4.ItemType.Mag] = function(p31, p32) --[[ Line: 81 ]]
        -- upvalues: u21 (copy)
        local l__ParentModel__7 = u21.new({ "Weapon", "Mag", p31.MetaData.Name }, nil, nil).ParentModel;
        local l__Size__8 = l__ParentModel__7.PrimaryPart.Size;
        local v33 = math.min(l__Size__8.X, l__Size__8.Y, l__Size__8.Z);
        l__ParentModel__7:PivotTo(p32 * CFrame.Angles(0, 0, 1.5707963267948966) + Vector3.new(0, v33 / 2, 0));
        return l__ParentModel__7;
    end,
    [u4.ItemType.Grenade] = function(p34, p35) --[[ Line: 88 ]]
        -- upvalues: u6 (copy)
        local v36 = u6:Get("Shared", "Models", "Grenade", p34.Layout.Model).Asset:Clone();
        local l__Size__9 = v36.PrimaryPart.Size;
        local v37 = math.min(l__Size__9.X, l__Size__9.Y, l__Size__9.Z);
        v36:PivotTo(p35 * CFrame.Angles(0, 0, 1.5707963267948966) + Vector3.new(0, v37 / 2, 0));
        return v36;
    end,
    [u4.ItemType.Consumable] = function(p38, p39) --[[ Line: 95 ]]
        -- upvalues: u18 (copy), u6 (copy), u17 (copy)
        local v40 = u18[p38.Name:sub(11)];
        local v41 = u6:Get("Shared", "Models", "Consumables", v40.Model).Asset:Clone();
        for v42, v43 in v40.Texture do
            v41[v42].TextureID = v43;
        end;
        local l__PrimaryPart__10 = v41.PrimaryPart;
        local v44 = l__PrimaryPart__10.Size.Y / 2 + (l__PrimaryPart__10:GetAttribute("Offset") or 0);
        v41:PivotTo(p39 + Vector3.new(0, v44, 0));
        if v40.Fluid then
            local l__Fluid__11 = v41:WaitForChild("Fluid");
            l__Fluid__11.Color = v40.Fluid;
            u17(l__Fluid__11.CFrame, l__Fluid__11.Size, 1 - (p38.MetaData.Uses or 0) / v40.Uses, l__Fluid__11:GetChildren());
        end;
        return v41;
    end,
    [u4.ItemType.Medical] = function(p45, p46) --[[ Line: 114 ]]
        -- upvalues: u6 (copy)
        local v47 = u6:Get("Shared", "Models", "Medical", p45.Name).Asset:Clone();
        local v48;
        if v47:IsA("BasePart") then
            v48 = Instance.new("Model");
            v47.Parent = v48;
            v48.PrimaryPart = v47;
        else
            v48 = v47;
        end;
        v48.WorldPivot = v48.PrimaryPart.CFrame;
        local l__Size__12 = v48.PrimaryPart.Size;
        local v49 = math.min(l__Size__12.X, l__Size__12.Y, l__Size__12.Z);
        v48:PivotTo(p46 * CFrame.Angles(1.5707963267948966, 0, 0) + Vector3.new(0, v49 / 2, 0));
        return v48;
    end,
    [u4.ItemType.Firearm] = function(p50, u51) --[[ Line: 129 ]]
        -- upvalues: u21 (copy)
        local v52 = u21.Deserialize(p50.MetaData.Build);
        if not p50.MetaData.Mag and v52:GetChild("Mag") then
            v52:Remove("Mag");
        end;
        local l__ParentModel__13 = v52.ParentModel;
        l__ParentModel__13.PrimaryPart.Anchored = true;
        local l__Size__14 = l__ParentModel__13.PrimaryPart.Size;
        local u53 = math.min(l__Size__14.X, l__Size__14.Y, l__Size__14.Z);
        task.defer(function() --[[ Line: 140 ]]
            -- upvalues: l__ParentModel__13 (copy), u51 (copy), u53 (copy)
            l__ParentModel__13.PrimaryPart = nil;
            l__ParentModel__13.WorldPivot = l__ParentModel__13:GetBoundingBox();
            l__ParentModel__13:PivotTo(u51 * CFrame.Angles(1.5707963267948966, 1.5707963267948966, 0) + Vector3.new(0, u53 / 2, 0));
        end);
        return l__ParentModel__13, true;
    end,
    [u4.ItemType.Melee] = function(p54, p55) --[[ Line: 147 ]]
        -- upvalues: u6 (copy)
        local v56 = u6:Get("Shared", "Models", "Weapon", "Melee", p54.Layout.Build).Asset:Clone();
        v56.PrimaryPart.Anchored = true;
        v56.WorldPivot = v56.PrimaryPart.CFrame;
        local l__Size__15 = v56.PrimaryPart.Size;
        local v57 = math.min(l__Size__15.X, l__Size__15.Y, l__Size__15.Z);
        v56:PivotTo(p55 * CFrame.Angles(1.5707963267948966, 1.5707963267948966, 0) + Vector3.new(0, v57 / 2, 0));
        return v56, true;
    end,
    [u4.ItemType.Shirt] = function(p58, p59) --[[ Line: 157 ]]
        -- upvalues: u6 (copy)
        local v60 = u6:Get("Shared", "Models", "Outfit", "Physical", "Shirt").Asset:Clone();
        u6:Get("Shared", "Models", "Outfit", "ShirtTransparent", p58.Layout.Build).Asset:Clone().Parent = v60;
        local v61 = Instance.new("Model");
        v60.CFrame = p59 * CFrame.Angles(1.5707963267948966, 0, 0) + Vector3.new(0, 0.1, 0);
        v60.Parent = v61;
        v61.PrimaryPart = v60;
        return v61;
    end,
    [u4.ItemType.Pants] = function(p62, p63) --[[ Line: 168 ]]
        -- upvalues: u6 (copy)
        local v64 = u6:Get("Shared", "Models", "Outfit", "Physical", "Pants").Asset:Clone();
        u6:Get("Shared", "Models", "Outfit", "Pants", p62.Layout.Build).Asset:Clone().Parent = v64;
        local v65 = Instance.new("Model");
        v64.CFrame = p63 * CFrame.Angles(1.5707963267948966, 0, 0) + Vector3.new(0, 0.15, 0);
        v64.Parent = v65;
        v65.PrimaryPart = v64;
        return v65;
    end,
    [u4.ItemType.Ammo] = function(p66, p67) --[[ Line: 179 ]]
        -- upvalues: u6 (copy)
        local v68 = u6:Get("Shared", "Models", "Boxes", p66.Layout.Box).Asset:Clone();
        local v69 = Instance.new("Model");
        v68.CFrame = p67 + Vector3.new(0, v68.Size.Y / 2, 0);
        v68.Parent = v69;
        v69.PrimaryPart = v68;
        return v69;
    end,
    [u4.ItemType.Junk] = function(p70, p71) --[[ Line: 187 ]]
        -- upvalues: u6 (copy)
        local v72 = u6:Get("Shared", "Models", "Junk", p70.Layout.Build).Asset:Clone();
        if v72:IsA("BasePart") then
            local v73 = Instance.new("Model");
            v72.Parent = v73;
            v73.PrimaryPart = v72;
            local v74 = v72:FindFirstChild("PivotAnchor");
            if v74 then
                v72.PivotOffset = v74.CFrame;
                v72 = v73;
            else
                v72 = v73;
            end;
        else
            local v75 = v72.PrimaryPart:FindFirstChild("PivotAnchor");
            if v75 then
                v72.PrimaryPart.PivotOffset = v75.CFrame;
            end;
        end;
        v72:PivotTo(p71);
        local v76;
        if p70.Name == "JunkCompass" then
            local _, v77 = p71:ToOrientation();
            v72.PrimaryPart.Spin.C1 = CFrame.Angles(0, v77, 0);
            v72.PrimaryPart.Anchored = true;
            v76 = true;
        else
            v76 = false;
        end;
        return v72, v76;
    end,
    [u4.ItemType.Rocket] = function(p78, p79) --[[ Line: 218 ]]
        -- upvalues: u6 (copy)
        local v80 = u6:Get("Shared", "Models", "Rocket", p78.Layout.Model).Asset:Clone();
        local v81 = v80:FindFirstChild("rocket", true);
        if v81 and not p78.MetaData.Mag then
            v81:Destroy();
        end;
        v80:PivotTo(p79);
        return v80;
    end,
    [u4.ItemType.Gear] = function(p82, p83) --[[ Line: 228 ]]
        -- upvalues: u6 (copy)
        local v84 = u6:Get("Shared", "Models", "Gear", p82.Layout.Build).Asset:Clone();
        local v85 = v84.PrimaryPart:FindFirstChild("PivotAnchor");
        if v85 then
            v84.PrimaryPart.PivotOffset = v85.CFrame;
        end;
        v84:PivotTo(p83);
        return v84;
    end,
    [u4.ItemType.Helmet] = function(...) --[[ Line: 239 ]]
        -- upvalues: u30 (copy)
        return u30(...);
    end,
    [u4.ItemType.Vest] = function(...) --[[ Line: 242 ]]
        -- upvalues: u30 (copy)
        return u30(...);
    end,
    [u4.ItemType.Belt] = function(...) --[[ Line: 245 ]]
        -- upvalues: u30 (copy)
        return u30(...);
    end,
    [u4.ItemType.Facewear] = function(...) --[[ Line: 248 ]]
        -- upvalues: u30 (copy)
        return u30(...);
    end,
    [u4.ItemType.Earwear] = function(...) --[[ Line: 251 ]]
        -- upvalues: u30 (copy)
        return u30(...);
    end,
    [u4.ItemType.Eyewear] = function(...) --[[ Line: 254 ]]
        -- upvalues: u30 (copy)
        return u30(...);
    end,
    [u4.ItemType.Wrist] = function(...) --[[ Line: 257 ]]
        -- upvalues: u30 (copy)
        return u30(...);
    end,
    [u4.ItemType.Backpack] = function(...) --[[ Line: 260 ]]
        -- upvalues: u30 (copy)
        return u30(...);
    end
};
function degToCompass(p87)
    return ({
        "N",
        "NNE",
        "NE",
        "ENE",
        "E",
        "ESE",
        "SE",
        "SSE",
        "S",
        "SSW",
        "SW",
        "WSW",
        "W",
        "WNW",
        "NW",
        "NNW"
    })[math.floor((p87 / 22.5 + 0.5) % 16) + 1];
end;
function u23._hasRadio(p88) --[[ Line: 271 ]]
    local l__Primary__16 = p88.Primary;
    if l__Primary__16 then
        local v89 = p88.Inventories[l__Primary__16];
        if v89 then
            for _, v90 in v89.Storages do
                for _, v91 in v90.Sections do
                    for _, v92 in v91 do
                        if v92.Name == "JunkRadio" then
                            return true;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
function u23._hasCompass(p93) --[[ Line: 293 ]]
    local l__Primary__17 = p93.Primary;
    if l__Primary__17 then
        local v94 = p93.Inventories[l__Primary__17];
        if v94 then
            for _, v95 in v94.Storages do
                for _, v96 in v95.Sections do
                    for _, v97 in v96 do
                        if v97.Name == "JunkCompass" then
                            return true;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
function u23._canEquip(p98, p99) --[[ Line: 315 ]]
    -- upvalues: u16 (copy), u4 (copy), u12 (copy), u6 (copy)
    if p99.Alive then
        if p99.Downed or (u16.TabletOpen or (p99.Rappelling or (not p99.Controller or (p99.Locked == true or p99.ForcedInventory)))) then
            return false;
        else
            local l__HeightState__18 = p99.HeightState;
            if l__HeightState__18 == u4.CharacterHeightState.Climbing or (l__HeightState__18 == u4.CharacterHeightState.Vaulting or (l__HeightState__18 == u4.CharacterHeightState.Swimming or (l__HeightState__18 == u4.CharacterHeightState.Skydiving or l__HeightState__18 == u4.CharacterHeightState.Parachuting))) then
                return false;
            elseif l__HeightState__18 == u4.CharacterHeightState.Sitting or not p99.Seat then
                if l__HeightState__18 == u4.CharacterHeightState.Sitting and not p99.SeatCanEquip then
                    return false;
                else
                    local l__PromptTask__19 = u12.PromptTask;
                    if l__PromptTask__19 and not l__PromptTask__19.Analogue then
                    else
                        local l__Emote__20 = p99.CurrentState.Emote;
                        if l__Emote__20 and not u6:Get("Animation", "Emotes", l__Emote__20, "Start", "TP").Asset.CanEquip then
                            return false;
                        else
                            return not (p99.CurrentState.LockPick or (p99.CurrentState.Medical or p99.CurrentState.Dragging));
                        end;
                    end;
                end;
            end;
        end;
    else
        p98._lastEquipped = nil;
    end;
end;
function u23._update(p100) --[[ Line: 352 ]]
    -- upvalues: u9 (copy)
    u9:UpdateInventories(p100._inventories);
end;
function u23._sync(p101, p102) --[[ Line: 356 ]]
    -- upvalues: u2 (copy)
    local l___localActor__21 = p101._localActor;
    if l___localActor__21 and l___localActor__21.Alive then
        local l__Equipped__22 = p101.Equipped;
        if l__Equipped__22 then
            if l__Equipped__22.Handler then
                l__Equipped__22.Handler:Unequip();
            end;
            l__Equipped__22.Selected = false;
        end;
        if p102 and p102.Handler then
            p102.Handler:Equip();
            p102.Selected = true;
            l___localActor__21:State("Equip", p102.UID);
        else
            if not p101._lastEquipped then
                p101._subcat = 0;
                p101._selected = 0;
            end;
            l___localActor__21:State("Equip");
        end;
        p101:_update();
        p101.Equipped = p102;
        l___localActor__21.Equipped = p102 ~= nil;
        u2:FireServer("InventoryEquip", p102 and p102.UID or "");
    end;
end;
function u23._cycle(p103, p104) --[[ Line: 387 ]]
    local l___localActor__23 = p103._localActor;
    if l___localActor__23 and (l___localActor__23.Alive and not l___localActor__23.Locked) then
        local v105 = #p103._inventories[p104];
        if v105 > 0 and p103:_canEquip(l___localActor__23) then
            if p103._subcat == p104 then
                p103._selected = v105 <= p103._selected and 0 or p103._selected + 1;
            else
                p103._subcat = p104;
                p103._selected = 1;
            end;
            p103._lastEquipped = nil;
            if p103._selected > 0 then
                p103:_sync(p103._inventories[p104][p103._selected]);
            else
                p103:_sync();
            end;
        else
            if p103.Equipped then
                p103:_sync();
            end;
        end;
    end;
end;
function u23._spawnDroppedItem(p106, p107, p108, p109) --[[ Line: 413 ]]
    -- upvalues: u4 (copy), l__Terrain__2 (copy), u86 (copy)
    local v110 = Instance.new("Attachment");
    local v111 = Instance.new("ProximityPrompt");
    v111.Name = "PickUp";
    v111.ActionText = "Pick up " .. (p109.Layout.Name or p109.Name);
    v111.ClickablePrompt = false;
    v111.Style = u4.ProximityPromptStyle.Custom;
    v111.Exclusivity = u4.ProximityPromptExclusivity.OneGlobally;
    v111.MaxActivationDistance = 6;
    v111.RequiresLineOfSight = false;
    v111.GamepadKeyCode = u4.KeyCode.World0;
    v111.KeyboardKeyCode = u4.KeyCode.World0;
    v111.Parent = v110;
    v110.Name = p107;
    v110.CFrame = CFrame.new(p108.Position);
    v110.Parent = l__Terrain__2;
    local v112 = false;
    local l__ItemType__24 = p109.Layout.ItemType;
    local v113;
    if u86[l__ItemType__24] then
        v113, v112 = u86[l__ItemType__24](p109, p108);
    else
        v113 = Instance.new("Model");
    end;
    for _, v114 in v113:GetDescendants() do
        if v114:IsA("BasePart") then
            if not v112 then
                v114.Anchored = true;
            end;
            v114.CanCollide = false;
            v114.CanTouch = false;
            v114.CanQuery = false;
        end;
    end;
    v113.Parent = workspace;
    p106._droppedItems[p107] = {
        Model = v113,
        Attachment = v110
    };
end;
function u23.new() --[[ Line: 458 ]]
    -- upvalues: u3 (copy), u23 (copy), u7 (copy), u10 (copy), u2 (copy), u14 (copy), u9 (copy), u16 (copy), u11 (copy)
    local v115 = {
        _subcat = 1,
        _selected = 1,
        OnInterfaceStateChanged = u3.new(),
        Inventories = {},
        _droppedItems = {},
        _inventories = {}
    };
    local u116 = setmetatable(v115, u23);
    u7.NotifySignal:Connect(function(p117) --[[ Line: 470 ]]
        -- upvalues: u10 (ref)
        u10:Notify({
            { "Inventory", p117, Color3.new(1, 0.866666, 0.505882) }
        });
    end);
    u2:ConnectEvents({
        InventoryReceive = function(p118) --[[ Name: InventoryReceive, Line 481 ]]
            -- upvalues: u7 (ref), u116 (copy)
            local v119, v120, v121, v122, v123 = u7.DeserializeClient(p118);
            if u116.Inventories[v121] then
                u116:Sync(v119, v121, v120, v122, v123);
            else
                u116:Load(v119, v121, v120, v122, v123);
            end;
        end,
        InventoryRemove = function(p124) --[[ Name: InventoryRemove, Line 489 ]]
            -- upvalues: u116 (copy)
            if u116.Primary == p124 then
                u116:_cleanInventory();
                if u116._controls then
                    u116._controls:Disconnect();
                    u116._controls = nil;
                end;
            end;
            u116.Inventories[p124] = nil;
            u116.OnInterfaceStateChanged:Fire();
        end,
        InventoryAction = function(p125, p126, ...) --[[ Name: InventoryAction, Line 501 ]]
            -- upvalues: u116 (copy)
            for _, v127 in u116._inventories do
                for _, v128 in v127 do
                    if v128.UID == p125 then
                        v128.Handler[p126](v128.Handler, ...);
                    end;
                end;
            end;
        end,
        InventoryDropAdd = function(p129, p130, p131) --[[ Name: InventoryDropAdd, Line 510 ]]
            -- upvalues: u116 (copy)
            u116:_spawnDroppedItem(p129, p130, p131);
        end,
        InventoryDropRemove = function(p132) --[[ Name: InventoryDropRemove, Line 513 ]]
            -- upvalues: u116 (copy)
            local v133 = u116._droppedItems[p132];
            if v133 then
                v133.Model:Destroy();
                v133.Attachment:Destroy();
                u116._droppedItems[p132] = nil;
            end;
        end
    });
    u116.OnInterfaceStateChanged:Connect(function(...) --[[ Line: 523 ]]
        -- upvalues: u116 (copy), u14 (ref), u9 (ref), u2 (ref), u16 (ref)
        u116.HasRadio = u116:_hasRadio();
        local l__LocalClient__25 = u14.LocalClient;
        if l__LocalClient__25 then
            l__LocalClient__25.HasRadio = u116.HasRadio;
        end;
        if u116:_hasCompass() then
            if u116._compassControls then
            else
                u116._compassLast = 0;
                u116.CompassOpen = false;
                function u116.Compass(p134) --[[ Line: 539 ]]
                    -- upvalues: u116 (ref), u9 (ref), u2 (ref)
                    u116.CompassOpen = p134;
                    if not p134 then
                        u9.UpdateCompass();
                    end;
                    local l___localActor__26 = u116._localActor;
                    if l___localActor__26 then
                        l___localActor__26:State("Compass", p134);
                        u2:FireServer("SetCompass", p134);
                    end;
                end;
                u116._compassControls = u16:Connect({
                    Compass = function(p135) --[[ Name: Compass, Line 553 ]]
                        -- upvalues: u116 (ref)
                        local v136 = tick();
                        if p135 then
                            if v136 - u116._compassLast < 0.3 then
                                u116._compassKeep = true;
                            end;
                            u116._compassLast = v136;
                        end;
                        if p135 or not u116._compassKeep then
                            u116.Compass(p135);
                        else
                            u116._compassKeep = nil;
                        end;
                    end
                });
            end;
        else
            if u116._compassControls then
                u116.CompassOpen = nil;
                u116.Compass = nil;
                u9.UpdateCompass();
                u116._compassControls:Disconnect();
                u116._compassControls = nil;
                local l___localActor__27 = u116._localActor;
                if l___localActor__27 then
                    l___localActor__27:State("Compass", false);
                    u2:FireServer("SetCompass", false);
                end;
            end;
        end;
    end);
    u11.InventoryService = u116;
    return u116;
end;
function u23.EvalEquip(p137, p138) --[[ Line: 591 ]]
    local l__Equipped__28 = p137.Equipped;
    local l___localActor__29 = p137._localActor;
    if l___localActor__29 then
        local v139;
        if p138 then
            v139 = p137:_canEquip(l___localActor__29);
        else
            v139 = p138;
        end;
        if l__Equipped__28 then
            if not v139 then
                p137._lastEquipped = l__Equipped__28;
                p137:_sync();
                return;
            end;
            if not l__Equipped__28.Handler then
                p137._lastEquipped = nil;
                p137:_sync();
                return;
            end;
            if p138 then
                l__Equipped__28.Handler:Update(p138);
            end;
        elseif p137._lastEquipped and v139 then
            p137:_sync(p137._lastEquipped);
            p137._lastEquipped = nil;
        end;
    end;
end;
function u23.Update(p140, p141) --[[ Line: 617 ]]
    -- upvalues: l__CurrentCamera__4 (copy), u9 (copy)
    if p140.CompassOpen then
        local _, v142 = l__CurrentCamera__4.CFrame:ToOrientation();
        local v143 = math.deg(v142);
        local v144 = math.round(v143);
        local v145;
        if v144 < 0 then
            v145 = math.abs(v144);
        else
            v145 = 180 - v144 + 180;
        end;
        u9.UpdateCompass(v145 .. "°\n" .. degToCompass(v145));
    end;
    p140:EvalEquip(p141);
end;
function u23._cleanInventory(p146) --[[ Line: 632 ]]
    -- upvalues: u15 (copy), u13 (copy)
    local l__Equipped__30 = p146.Equipped;
    if l__Equipped__30 then
        l__Equipped__30 = p146.Equipped.UID;
    end;
    p146._lastEquipped = nil;
    for _, v147 in p146._inventories do
        for _, v148 in v147 do
            if v148.Handler then
                if v148.UID == l__Equipped__30 then
                    v148.Handler:Unequip();
                end;
                v148.Handler:Destroy();
                v148.Handler = nil;
            end;
        end;
    end;
    p146._localActor = u15.LocalActor;
    p146._subcat = 0;
    p146._selected = 0;
    p146._inventories = {};
    p146.Equipped = nil;
    p146._inventory = {};
    for v149 = 1, 4 do
        p146._inventories[v149] = {};
    end;
    u13.Inventory = nil;
end;
function u23.Init(u150, p151) --[[ Line: 661 ]]
    -- upvalues: u16 (copy)
    u150:_cleanInventory();
    u150.Primary = p151;
    if not u150._controls then
        u150._controls = u16:Connect({
            CycleOne = function(p152) --[[ Name: CycleOne, Line 667 ]]
                -- upvalues: u150 (copy)
                if p152 then
                    u150:_cycle(1);
                end;
            end,
            CycleTwo = function(p153) --[[ Name: CycleTwo, Line 672 ]]
                -- upvalues: u150 (copy)
                if p153 then
                    u150:_cycle(2);
                end;
            end,
            CycleThree = function(p154) --[[ Name: CycleThree, Line 677 ]]
                -- upvalues: u150 (copy)
                if p154 then
                    u150:_cycle(3);
                end;
            end,
            CycleFour = function(p155) --[[ Name: CycleFour, Line 682 ]]
                -- upvalues: u150 (copy)
                if p155 then
                    u150:_cycle(4);
                end;
            end
        });
    end;
    u150:_update();
end;
function u23.Load(u156, p157, p158, p159, p160, p161) --[[ Line: 693 ]]
    -- upvalues: l__LocalPlayer__3 (copy), u8 (copy), u19 (copy), u22 (copy), u13 (copy), u5 (copy)
    local u162;
    if p160 == l__LocalPlayer__3 then
        u162 = p157[1];
        if u162 then
            u162 = p157[1].StorageName == "Main";
        end;
    else
        u162 = false;
    end;
    if u162 then
        u156:Init(p158);
    end;
    u156.Inventories[p158] = u8.new(p157, p158, p159, p160, p161, u162, function(p163, p164, p165) --[[ Line: 699 ]]
        -- upvalues: u162 (copy), u156 (copy), u19 (ref), u22 (ref)
        if not u162 then
            return;
        end;
        local l___localActor__31 = u156._localActor;
        if not (l___localActor__31 and l___localActor__31.Alive) then
            return;
        end;
        local v166 = false;
        local v167 = u19[p164.Name];
        local l__InventoryGroup__32 = v167.InventoryGroup;
        local l__UID__33 = p164.MetaData.UID;
        if p165 then
            u156._inventory[l__UID__33] = p164;
            local v168 = u22[v167.Handler .. "Inventory"].new(l___localActor__31, p164, p163);
            table.insert(u156._inventories[l__InventoryGroup__32], 1, {
                Selected = false,
                UID = l__UID__33,
                Name = v168.Name,
                Handler = v168
            });
        else
            v166 = u156.Equipped;
            if v166 then
                v166 = u156.Equipped.UID == l__UID__33;
            end;
            for _, v169 in u156._inventories do
                for v170, v171 in v169 do
                    if v171.UID == l__UID__33 then
                        if v166 then
                            v171.Handler:Unequip();
                        end;
                        v171.Handler:Destroy();
                        v171.Handler = nil;
                        table.remove(v169, v170);
                        break;
                    end;
                end;
            end;
            u156._inventory[l__UID__33] = nil;
        end;
        l___localActor__31:State("Inventory", u156._inventory);
        if v166 then
            u156:_sync();
        end;
        u156:_update();
    end);
    if u162 then
        u13.Inventory = u156.Inventories[p158];
    end;
    if u5.IS_PVP then
        u156:_cycle(1);
    end;
    u156.OnInterfaceStateChanged:Fire();
end;
function u23.Sync(p172, p173, p174, p175, p176) --[[ Line: 759 ]]
    -- upvalues: u7 (copy), u20 (copy)
    local v177 = p172.Inventories[p174];
    v177.StoragesID = p175;
    v177.Owner = p176;
    for v178, v179 in v177.Storages do
        if p173[v178] then
            for v180, v181 in v179.Sections do
                if p173[v178].Sections[v180] then
                    local v182 = u7.GetAllFunctional(v177, v178, v180);
                    local v183 = u7.GetAllFunctional({
                        Storages = p173
                    }, v178, v180);
                    table.clear(v181);
                    for v184, v185 in p173[v178].Sections[v180] do
                        v181[v184] = v185;
                    end;
                    local l__FunctionCells__34 = u20[v179.StorageName].Sections[v180].FunctionCells;
                    if l__FunctionCells__34 then
                        for v186 = 1, #l__FunctionCells__34 do
                            local v187 = v182[v186];
                            local v188 = v183[v186];
                            if not v187 or (not v187.MetaData or (not v188 or (not v188.MetaData or v187.MetaData.UID ~= v188.MetaData.UID))) then
                                u7.PerformEquipCalls(v188, v187, v177);
                            end;
                        end;
                    end;
                else
                    for _, v189 in u7.GetAllFunctional(v177, v178, v180) do
                        u7.PerformEquipCalls(nil, v189, v177);
                    end;
                    v177.Storages[v178].Sections[v180] = nil;
                end;
            end;
        else
            for v190, _ in v177.Storages[v178].Sections do
                for _, v191 in u7.GetAllFunctional(v177, v178, v190) do
                    u7.PerformEquipCalls(nil, v191, v177);
                end;
            end;
            v177.Storages[v178] = nil;
        end;
    end;
    for v192, v193 in p173 do
        if not v177.Storages[v192] then
            v177.Storages[v192] = v193;
            for v194, _ in v193.Sections do
                for _, v195 in u7.GetAllFunctional(v177, v192, v194) do
                    u7.PerformEquipCalls(v195, nil, v177);
                end;
            end;
        end;
    end;
    p172.OnInterfaceStateChanged:Fire();
    for _, v196 in p172._inventories do
        for _, v197 in v196 do
            if v197.Handler.UpdateHUD and v197.Handler.Equipped then
                v197.Handler:UpdateHUD();
            end;
        end;
    end;
end;
function u23.CanMoveItem(p198, p199, p200, p201, p202, p203, p204, p205, p206, p207) --[[ Line: 834 ]]
    -- upvalues: u7 (copy)
    return u7.CanMoveItem(p198.Inventories, p199, p200, p201, p202, p203, p204, p205, p206, p207);
end;
function u23.MoveItem(p208, p209, p210, p211, p212, p213, p214, p215, p216, p217) --[[ Line: 838 ]]
    -- upvalues: u7 (copy), u2 (copy)
    if u7.MoveItem(p208.Inventories, p209, p210, p211, p212, p213, p214, p215, p216, p217) then
        p208.OnInterfaceStateChanged:Fire();
        u2:FireServer("InventoryMove", p209, p210, p211, p212, p213, p214, p215, p216, p217);
    end;
end;
function u23.GetMain(p218) --[[ Line: 846 ]]
    for _, v219 in p218.Inventories do
        if v219.Storages[1] and v219.Storages[1].StorageName == "Main" then
            return v219;
        end;
    end;
end;
function u23.DropItem(p220, p221, p222, p223, p224) --[[ Line: 854 ]]
    -- upvalues: u5 (copy), u7 (copy), u2 (copy)
    if u5.ITEM_DROPS then
        u7.RemoveItem(p220.Inventories[p221], p222, p223, p224);
        p220.OnInterfaceStateChanged:Fire();
        u2:FireServer("InventoryDrop", p221, p222, p223, p224);
    end;
end;
return u23.new();