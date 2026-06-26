-- Services.PrefabService.BunkerDoorPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _, _ = shared.import("require", "asset", "Enum");
local u2 = v1("SoundService");
local u3 = {};
u3.__index = u3;
function u3._toggle(u4, p5) --[[ Line: 8 ]]
    -- upvalues: u2 (copy)
    local l__Primary__1 = u4.Primary;
    if l__Primary__1 then
        for _, v6 in l__Primary__1:GetChildren() do
            if v6:IsA("Weld") then
                local l__Part1__2 = v6.Part1;
                for _, v7 in l__Part1__2:GetChildren() do
                    if v7:IsA("Attachment") and v7.Name == "Particle" then
                        v7.Emitter.Enabled = true;
                    end;
                end;
                u4._task = task.delay(u4._speed, function() --[[ Line: 26 ]]
                    -- upvalues: u4 (copy), l__Part1__2 (copy)
                    u4._task = nil;
                    for _, v8 in l__Part1__2:GetChildren() do
                        if v8:IsA("Attachment") and v8.Name == "Particle" then
                            v8.Emitter.Enabled = false;
                        end;
                    end;
                end);
                local v9 = l__Part1__2:GetAttribute("Sound");
                if v9 then
                    u2:CreateSound("Ambience", l__Part1__2, true, "Environment", v9 .. "_" .. (p5 and "Open" or "Close")).Destroy(u4._speed + 5);
                end;
            end;
        end;
    end;
end;
function u3.new(u10) --[[ Line: 44 ]]
    -- upvalues: u3 (copy)
    local v11 = {
        Model = u10,
        Primary = u10.PrimaryPart,
        _speed = u10:GetAttribute("Speed")
    };
    local u12 = setmetatable(v11, u3);
    u12._connection = u10:GetAttributeChangedSignal("Open"):Connect(function() --[[ Line: 52 ]]
        -- upvalues: u12 (copy), u10 (copy)
        u12:_toggle(u10:GetAttribute("Open"));
    end);
    if u10:GetAttribute("Open") then
        u12:_toggle(true);
    end;
    return u12;
end;
function u3.Destroy(p13) --[[ Line: 62 ]]
    if p13._task then
        task.cancel(p13._task);
    end;
end;
return u3;