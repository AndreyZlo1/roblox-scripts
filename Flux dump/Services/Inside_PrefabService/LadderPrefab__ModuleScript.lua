-- Services.PrefabService.LadderPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _, u2 = shared.import("require", "asset", "Enum");
v1("SoundService");
local _ = workspace.CurrentCamera;
local u3 = {};
u3.__index = u3;
function u3.new(p4) --[[ Line: 10 ]]
    -- upvalues: u2 (copy), u3 (copy)
    local v5 = Instance.new("Attachment");
    local v6 = Instance.new("ProximityPrompt");
    v6.Name = "Ladder";
    v6.ActionText = "Climb Ladder";
    v6.ClickablePrompt = false;
    v6.Style = u2.ProximityPromptStyle.Custom;
    v6.Exclusivity = u2.ProximityPromptExclusivity.OneGlobally;
    v6.MaxActivationDistance = 4;
    v6.RequiresLineOfSight = false;
    v6.GamepadKeyCode = u2.KeyCode.World0;
    v6.KeyboardKeyCode = u2.KeyCode.World0;
    v6.Parent = v5;
    v5.Parent = p4;
    p4.Transparency = 1;
    p4.Anchored = true;
    p4.CanCollide = false;
    p4.CanQuery = false;
    p4.AudioCanCollide = false;
    return setmetatable({
        _ladder = p4,
        _attachment = v5
    }, u3);
end;
function u3.Update(p7, _, p8) --[[ Line: 39 ]]
    local l___ladder__1 = p7._ladder;
    local l__CFrame__2 = l___ladder__1.CFrame;
    local v9 = l___ladder__1.Size.Y / 2;
    if (p8 - l__CFrame__2.Position).Magnitude > v9 + 6 then
    else
        local v10;
        if p8.Y > l__CFrame__2.Y then
            v10 = Ray.new(l__CFrame__2:PointToWorldSpace((Vector3.new(0, v9, 0))), -l__CFrame__2.UpVector);
        else
            v10 = Ray.new(l__CFrame__2:PointToWorldSpace((Vector3.new(0, -v9, 0))), l__CFrame__2.UpVector);
        end;
        p7._attachment.WorldPosition = v10:ClosestPoint(p8 + Vector3.new(0, 1.5, 0));
    end;
end;
function u3.Destroy(_) --[[ Line: 58 ]] end;
return u3;