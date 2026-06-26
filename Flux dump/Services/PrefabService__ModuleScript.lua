-- Services.PrefabService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "network");
local l__CollectionService__1 = game:GetService("CollectionService");
local l__CurrentCamera__2 = workspace.CurrentCamera;
local u3 = v1({
    "DoorPrefab",
    "LadderPrefab",
    "TurretPrefab",
    "FlagPrefab",
    "GlassPrefab",
    "HumanPrefab",
    "POIPrefab",
    "FlarePrefab",
    "ElevatorPrefab",
    "BunkerDoorPrefab",
    "ServerDoorPrefab",
    "TarpPrefab",
    "BlinkPrefab",
    "CarAlarmPrefab",
    "SmokerPrefab",
    "FlareBallPrefab",
    "ReturnServerPrefab",
    "KOTHPrefab"
});
local u4 = {};
u4.__index = u4;
function u4._registerPrefab(p5, p6, p7) --[[ Line: 42 ]]
    -- upvalues: u3 (copy)
    if p7 then
        local v8 = u3[p7 .. "Prefab"];
        if v8 then
            local v9 = v8.new(p6);
            p5._prefabs[p6] = v9;
        end;
    end;
end;
function u4._unregisterPrefab(p10, p11) --[[ Line: 54 ]]
    if p10._prefabs[p11] then
        p10._prefabs[p11]:Destroy();
        p10._prefabs[p11] = nil;
    end;
end;
function u4.new() --[[ Line: 62 ]]
    -- upvalues: u4 (copy), u2 (copy), l__CollectionService__1 (copy)
    local u12 = setmetatable({
        _prefabs = {}
    }, u4);
    u2:ConnectEvents({
        ActivatePrefab = function(p13, p14, ...) --[[ Name: ActivatePrefab, Line 68 ]]
            -- upvalues: u12 (copy)
            local v15 = u12._prefabs[p13];
            if v15 then
                v15[p14](v15, ...);
            end;
        end
    });
    l__CollectionService__1:GetInstanceAddedSignal("Prefab"):Connect(function(p16) --[[ Line: 76 ]]
        -- upvalues: u12 (copy)
        if p16:IsDescendantOf(workspace) then
            u12:_registerPrefab(p16, p16:GetAttribute("Prefab"));
        end;
    end);
    l__CollectionService__1:GetInstanceRemovedSignal("Prefab"):Connect(function(p17) --[[ Line: 84 ]]
        -- upvalues: u12 (copy)
        u12:_unregisterPrefab(p17);
    end);
    for _, v18 in l__CollectionService__1:GetTagged("Prefab") do
        if v18:IsDescendantOf(workspace) then
            u12:_registerPrefab(v18, v18:GetAttribute("Prefab"));
        end;
    end;
    return u12;
end;
function u4.GetPrefab(p19, p20) --[[ Line: 99 ]]
    return p19._prefabs[p20];
end;
function u4.Update(p21, p22) --[[ Line: 103 ]]
    -- upvalues: l__CurrentCamera__2 (copy)
    local v23 = l__CurrentCamera__2.Focus and l__CurrentCamera__2.Focus.Position or Vector3.new();
    local v24 = 0;
    local v25 = {};
    local v26 = {};
    for _, v27 in p21._prefabs do
        if v27.Update then
            local v28, v29 = v27:Update(p22, v23);
            if v28 and v29 then
                v24 = v24 + 1;
                v25[v24] = v28;
                v26[v24] = v29;
            end;
        end;
    end;
    if v24 > 0 then
        workspace:BulkMoveTo(v25, v26, Enum.BulkMoveMode.FireCFrameChanged);
    end;
end;
return u4.new();