-- Services.InventoryService.InventoryClass
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1 = shared.import("require");
local u2 = v1("ReplicatorService");
local u3 = v1("NotifyInterface");
local u4 = v1("SharedInventory");
local u5 = v1("StorageLayout");
local u6 = {};
u6.__index = u6;
function u6.new(p7, p8, p9, p10, p11, p12, p13) --[[ Line: 12 ]]
    -- upvalues: u6 (copy), u5 (copy), u4 (copy)
    local v14 = setmetatable({
        _ignore = true,
        Storages = p7,
        Owner = p10,
        StoragesID = p9,
        ID = p8,
        Changed = p13,
        Main = p12,
        Actor = p11
    }, u6);
    for _, v15 in p7 do
        for v16, v17 in v15.Sections do
            local l__Size__1 = u5[v15.StorageName].Sections[v16].Size;
            for v18, v19 in v17 do
                if u4.IsEquipPosition(v18, l__Size__1) then
                    u4.PerformEquipCalls(v19, nil, v14);
                end;
            end;
        end;
    end;
    v14._ignore = false;
    return v14;
end;
function u6.Remove(p20, p21, p22) --[[ Line: 40 ]]
    -- upvalues: u4 (copy)
    for v23, v24 in p20.Storages do
        for v25, v26 in v24.Sections do
            for v27, v28 in v26 do
                if v28.MetaData.UID == p21 then
                    u4.RemoveItem(p20, v23, v25, v27, p22);
                    return true;
                end;
            end;
        end;
    end;
    return false;
end;
function u6.Change(p29, p30, p31) --[[ Line: 54 ]]
    p29.Changed(p29, p30, p31);
end;
function u6.DropItems(_) --[[ Line: 58 ]] end;
function u6.ChangeWearable(p32, p33, p34) --[[ Line: 61 ]]
    -- upvalues: u2 (copy), u3 (copy)
    local v35 = u2.Actors[p32.Actor];
    if v35 then
        local v36 = u2.LocalActor == v35;
        if p34 then
            v35:State(p33, { p34.Name, p34.MetaData });
            if v36 and not p32._ignore then
                u3:Notify({
                    {
                        "Equipped",
                        p34.Layout.Name or (p34.Name or "???"),
                        Color3.new(0.603921, 1, 0.505882),
                        true
                    }
                });
            end;
        else
            v35:State(p33);
        end;
    end;
end;
return u6;