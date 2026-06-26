-- Services.InventoryService.GearInventory
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4, u5 = shared.import("require", "network", "Enum", "Roact", "frc");
local u6 = v1("OverlayInterface");
local u7 = v1("InputService");
local u8 = v1("NotifyInterface");
local u9 = v1("RoactTween");
local u10 = v1("vector3toTable");
local u11 = v1("Gear");
local u12 = v1({ "BinocularsOverlay", "RangeFinderOverlay", "HelixOverlay" });
local l__CurrentCamera__1 = workspace.CurrentCamera;
local u13 = {};
u13.__index = u13;
function u13.new(p14, p15, p16) --[[ Line: 25 ]]
    -- upvalues: u11 (copy), u13 (copy), u3 (copy), l__CurrentCamera__1 (copy), u9 (copy), u4 (copy)
    local v17 = u11[p15.Layout.Gear];
    local v18 = setmetatable({
        Name = p15.Layout.Name,
        _gear = v17,
        _actor = p14,
        _item = p15,
        _inventory = p16
    }, u13);
    if v17.Magnify then
        local v19 = RaycastParams.new();
        v19.CollisionGroup = u3.PhysicsGroup.BulletCast;
        v19.FilterType = u3.RaycastFilterType.Exclude;
        v19.FilterDescendantsInstances = { l__CurrentCamera__1 };
        v19.IgnoreWater = true;
        v18._zoomLerp = u9.new(0);
        v18._zoomParams = v19;
        v18._zoomLerp = u9.new(0);
        v18._zoomGoal = v17.Magnify[1];
        v18._zoomCurrent = u9.new(v18._zoomGoal);
        v18._zoomStreaming = tick();
        v18._overlayProps = {
            Lerp = v18._zoomLerp,
            Zoom = v18._zoomCurrent,
            Magnify = v17.Magnify
        };
    end;
    if v17.Type == u3.GearType.RangeFinder then
        local v20, v21 = u4.createBinding();
        local v22, v23 = u4.createBinding(false);
        v18._overlayProps.Ranging = v22;
        v18._overlayProps.Range = v20;
        v18._updateRange = v21;
        v18._updateRanging = v23;
    end;
    return v18;
end;
function u13.Update(p24, p25) --[[ Line: 69 ]]
    -- upvalues: u5 (copy), l__CurrentCamera__1 (copy), u2 (copy), u10 (copy)
    local l___gear__2 = p24._gear;
    local l___actor__3 = p24._actor;
    local v26 = tick();
    local l___zoomLerp__4 = p24._zoomLerp;
    if l___zoomLerp__4 then
        local v27 = l___zoomLerp__4:GetValue();
        if v27 > 0.001 then
            if l___actor__3.BinoZoom then
                p24._zoomGoal = math.clamp(p24._zoomGoal + l___actor__3.BinoZoom * 2, l___gear__2.Magnify[1], l___gear__2.Magnify[2]);
                l___actor__3.BinoZoom = nil;
            end;
            local v28 = p24._zoomCurrent:GetValue();
            local v29 = math.lerp(v28, p24._zoomGoal, u5(p25 * 10));
            p24._zoomCurrent:SetValue(v29);
            l___actor__3.CameraZoom = v27 * v29;
            if p24._zoomStreaming + 1 < v26 then
                u2:FireServer("InventoryAction", "StreamLocation", u10(l__CurrentCamera__1.CFrame.LookVector));
                p24._zoomStreaming = v26;
            end;
        else
            l___actor__3.CameraZoom = nil;
        end;
    end;
end;
function u13.Equip(u30) --[[ Line: 98 ]]
    -- upvalues: u7 (copy), u3 (copy), u2 (copy), u6 (copy), u12 (copy), l__CurrentCamera__1 (copy), u8 (copy)
    u30._equipped = true;
    local _ = u30._item;
    local l___actor__5 = u30._actor;
    local l___gear__6 = u30._gear;
    local l__Type__7 = l___gear__6.Type;
    local v31 = {};
    if u30._zoomLerp then
        function v31.ADS(p32) --[[ Line: 108 ]]
            -- upvalues: l___actor__5 (copy), u7 (ref), u30 (copy), u3 (ref), u2 (ref), u6 (ref), u12 (ref), l___gear__6 (copy)
            l___actor__5.UsingBinoculars = p32;
            u7.OverlayOpen = p32;
            u30._zoomLerp:SetGoal(p32 and 1 or 0);
            l___actor__5:Action(u3.ActionType.Inventory, "Zoom", p32);
            u2:FireServer("InventoryAction", "Zoom", p32);
            if p32 then
                if not u30._overlay then
                    u30._overlay = u6:Mount(u12[l___gear__6.Overlay .. "Overlay"], u30._overlayProps);
                end;
            elseif u30._overlay then
                u30._overlay = nil;
                u6:Mount();
                u2:FireServer("InventoryAction", "StreamLocation", nil);
                if u30._updateRange then
                    u30._updateRange(nil);
                end;
            end;
        end;
    end;
    if l__Type__7 == u3.GearType.RangeFinder then
        function v31.Discharge(p33) --[[ Line: 132 ]]
            -- upvalues: u30 (copy), l___gear__6 (copy), l__CurrentCamera__1 (ref)
            u30._updateRanging(p33);
            if p33 then
            else
                local l__Range__8 = l___gear__6.Range;
                local l__CFrame__9 = l__CurrentCamera__1.CFrame;
                local v34 = workspace:Raycast(l__CFrame__9.Position, l__CFrame__9.LookVector * l__Range__8, u30._zoomParams);
                if v34 then
                    l__Range__8 = v34.Distance;
                end;
                u30._updateRange(l__Range__8);
            end;
        end;
    end;
    if l__Type__7 == u3.GearType.CSEL then
        function v31.Discharge(p35) --[[ Line: 149 ]]
            -- upvalues: u30 (copy), u7 (ref), u8 (ref), l___actor__5 (copy), u3 (ref), u2 (ref)
            if p35 then
                u30._lastPress = tick();
            else
                if tick() - u30._lastPress < 0.5 then
                    u8:Notify({
                        { "Alert", "Hold [" .. u7:GetBind("Discharge").Name .. "] to call for an EXFIL", Color3.new(1, 0.866666, 0.505882) }
                    });
                end;
                u30._lastPress = nil;
            end;
            l___actor__5:Action(u3.ActionType.Inventory, "CSEL", p35);
            u2:FireServer("InventoryAction", "CallExtract", p35);
        end;
    end;
    u30._controls = u7:Connect(v31);
end;
function u13.Unequip(p36) --[[ Line: 174 ]]
    -- upvalues: u7 (copy), u6 (copy)
    if p36._equipped then
        local l___actor__10 = p36._actor;
        p36._equipped = false;
        u7.OverlayOpen = nil;
        l___actor__10.CameraZoom = nil;
        l___actor__10.BinoZoom = nil;
        l___actor__10.UsingBinoculars = false;
        if p36._zoomLerp then
            p36._zoomLerp:SetValue(0);
        end;
        if p36._overlay then
            p36._overlay = nil;
            u6:Mount();
        end;
        if p36._controls then
            p36._controls:Disconnect();
            p36._controls = nil;
        end;
    end;
end;
function u13.Destroy(_) --[[ Line: 198 ]] end;
return u13;