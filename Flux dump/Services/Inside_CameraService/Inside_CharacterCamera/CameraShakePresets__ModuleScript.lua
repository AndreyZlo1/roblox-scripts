-- Services.CameraService.CharacterCamera.CameraShakePresets
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1 = shared.import("require")("CameraShakeInstance");
local u10 = {
    Bump = function() --[[ Name: Bump, Line 7 ]]
        -- upvalues: u1 (copy)
        local v2 = u1.new(2, 8, 0.05, 0.2);
        v2.PositionInfluence = Vector3.new(0.05, 0.05, 0.05);
        v2.RotationInfluence = Vector3.new(1, 1, 1);
        return v2;
    end,
    Explosion = function() --[[ Name: Explosion, Line 16 ]]
        -- upvalues: u1 (copy)
        local v3 = u1.new(5, 10, 0, 1.5);
        v3.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
        v3.RotationInfluence = Vector3.new(4, 1, 1);
        return v3;
    end,
    Hit = function() --[[ Name: Hit, Line 25 ]]
        -- upvalues: u1 (copy)
        local v4 = u1.new(2, 20, 0, 0.2);
        v4.PositionInfluence = Vector3.new(0.1, 0.1, 0.1);
        v4.RotationInfluence = Vector3.new(2, 1, 1);
        return v4;
    end,
    Earthquake = function() --[[ Name: Earthquake, Line 34 ]]
        -- upvalues: u1 (copy)
        local v5 = u1.new(0.6, 3.5, 2, 10);
        v5.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
        v5.RotationInfluence = Vector3.new(1, 1, 4);
        return v5;
    end,
    BadTrip = function() --[[ Name: BadTrip, Line 43 ]]
        -- upvalues: u1 (copy)
        local v6 = u1.new(10, 0.15, 5, 10);
        v6.PositionInfluence = Vector3.new(0, 0, 0.15);
        v6.RotationInfluence = Vector3.new(2, 1, 4);
        return v6;
    end,
    HandheldCamera = function() --[[ Name: HandheldCamera, Line 52 ]]
        -- upvalues: u1 (copy)
        local v7 = u1.new(1, 0.25, 5, 10);
        v7.PositionInfluence = Vector3.new(0, 0, 0);
        v7.RotationInfluence = Vector3.new(1, 0.5, 0.5);
        return v7;
    end,
    Vibration = function() --[[ Name: Vibration, Line 61 ]]
        -- upvalues: u1 (copy)
        local v8 = u1.new(0.4, 20, 2, 2);
        v8.PositionInfluence = Vector3.new(0, 0.15, 0);
        v8.RotationInfluence = Vector3.new(1.25, 0, 4);
        return v8;
    end,
    RoughDriving = function() --[[ Name: RoughDriving, Line 70 ]]
        -- upvalues: u1 (copy)
        local v9 = u1.new(1, 2, 1, 1);
        v9.PositionInfluence = Vector3.new(0, 0, 0);
        v9.RotationInfluence = Vector3.new(1, 1, 1);
        return v9;
    end
};
return setmetatable({}, {
    __index = function(_, p11) --[[ Name: __index, Line 79 ]]
        -- upvalues: u10 (copy)
        local v12 = u10[p11];
        if type(v12) == "function" then
            return v12();
        end;
        error("No preset found with index \"" .. p11 .. "\"");
    end
});