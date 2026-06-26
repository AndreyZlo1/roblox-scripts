-- Services.WorldService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1, u2, u3 = shared.import("require", "server", "signal");
local u4 = u1("DebugService");
local l__Players__1 = game:GetService("Players");
local l__Worlds__2 = game:GetService("ReplicatedStorage"):WaitForChild("LocalAssets"):WaitForChild("Worlds");
local l__LocalPlayer__3 = l__Players__1.LocalPlayer;
local u5 = {};
u5.__index = u5;
function u5._checkWorld(p6, p7) --[[ Line: 18 ]]
    if p6._world ~= p7.WORLD then
        p6:SetWorld(p7.WORLD);
    end;
end;
function u5.InWater(p8, p9) --[[ Line: 24 ]]
    local l__Water__4 = p8.World.Water;
    if not (l__Water__4 and (l__Water__4.Ignore and l__Water__4.Enabled)) then
        return false;
    end;
    local v10 = math.floor(p9.X / 512);
    local v11 = math.floor(p9.Z / 512);
    return not table.find(l__Water__4.Ignore, v10 .. "," .. v11);
end;
function u5.new() --[[ Line: 38 ]]
    -- upvalues: l__LocalPlayer__3 (copy), u3 (copy), u5 (copy), u2 (copy)
    local v12 = Instance.new("WorldModel");
    v12.Parent = l__LocalPlayer__3;
    local v13 = Instance.new("Model");
    v13.Parent = workspace;
    local v14 = {
        ActiveWorld = v13,
        InactiveWorld = v12,
        Changed = u3.new()
    };
    local u15 = setmetatable(v14, u5);
    u2.Changed:Connect(function(p16) --[[ Line: 51 ]]
        -- upvalues: u15 (copy)
        u15:_checkWorld(p16);
    end);
    u15:_checkWorld(u2);
    return u15;
end;
function u5.SetWorld(p17, p18) --[[ Line: 59 ]]
    -- upvalues: l__Worlds__2 (copy), u1 (copy), u4 (copy)
    local v19 = l__Worlds__2:WaitForChild(p18);
    local v20 = v19:FindFirstChild("Chunk");
    local v21 = v19:FindFirstChild("Water");
    local v22 = v19:FindFirstChild("Environments");
    if not v22 then
        v22 = Instance.new("Folder");
        v22.Name = "Environments";
        v22.Parent = v19;
    end;
    local v23 = v19:FindFirstChild("Sounds");
    if not v23 then
        v23 = Instance.new("Folder");
        v23.Name = "Sounds";
        v23.Parent = v19;
    end;
    local v24 = v19:FindFirstChild("Blocks");
    if not v24 then
        v24 = Instance.new("Folder");
        v24.Name = "Blocks";
        v24.Parent = v19;
    end;
    local v25 = v19:FindFirstChild("LOD");
    if not v25 then
        v25 = Instance.new("Folder");
        v25.Name = "LOD";
        v25.Parent = v19;
    end;
    local v26 = v19:FindFirstChild("Zones");
    if not v26 then
        v26 = Instance.new("Folder");
        v26.Name = "Zones";
        v26.Parent = v19;
    end;
    local v27 = {};
    local v28 = v19:FindFirstChild("RestrictedAirspace");
    if v28 then
        for v29, v30 in v28:GetChildren() do
            v27[v29] = { v30.Position, v30:GetAttribute("Radius") or v30.Size.Y / 2 };
        end;
    end;
    p17.World = {
        Environments = v22,
        Atmosphere = v19:GetAttribute("Atmosphere") or "Default",
        Ambience = v19:GetAttribute("Ambience"),
        Snowing = v19:GetAttribute("Snowing"),
        Sounds = v23,
        Blocks = v24,
        Zones = v26,
        LOD = v25,
        Store = v19:GetAttribute("Store") or "Ronograd_FOB",
        RestrictedAirspace = v27,
        Chunk = v20 and u1(v20) or "//",
        Water = v21 and u1(v21) or {
            Height = -20,
            Depth = -50,
            Enabled = false,
            Ignore = {}
        }
    };
    p17._world = p18;
    p17.Changed:Fire(p17.World);
    u4:Print("Set World (" .. p18 .. ")");
end;
return u5.new();