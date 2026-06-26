-- Services.PrefabService.FlagPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local _, _, _ = shared.import("require", "asset", "Enum");
local _ = workspace.CurrentCamera;
local u1 = {};
u1.__index = u1;
function u1.new(u2) --[[ Line: 8 ]]
    -- upvalues: u1 (copy)
    local l__Main__1 = u2:WaitForChild("Main");
    local l__Top__2 = l__Main__1:WaitForChild("Top");
    local l__Bottom__3 = l__Main__1:WaitForChild("Bottom");
    local v3 = l__Bottom__3.WorldCFrame:Lerp(l__Top__2.WorldCFrame, 0.5);
    local l__Magnitude__4 = (l__Top__2.Position - l__Bottom__3.Position).Magnitude;
    local u4 = Instance.new("Beam");
    u4.Attachment0 = l__Top__2;
    u4.Attachment1 = l__Bottom__3;
    u4.CurveSize0 = 2;
    u4.CurveSize1 = 0.5;
    u4.Segments = 10;
    u4.Width0 = l__Magnitude__4;
    u4.Width1 = l__Magnitude__4;
    u4.Transparency = NumberSequence.new(0);
    u4.TextureSpeed = 0;
    u4.Color = ColorSequence.new(Color3.fromRGB(181, 181, 181));
    u4.LightInfluence = 1;
    local v5 = l__Main__1:FindFirstChild("Anchor");
    local v6 = u2:GetAttribute("Length") or l__Magnitude__4 * 1.7;
    local v7 = {
        _main = l__Main__1,
        _connection = u2:GetAttributeChangedSignal("Flag"):Connect(function() --[[ Name: changeFlag, Line 28 ]]
            -- upvalues: u2 (copy), u4 (copy)
            u4.Texture = u2:GetAttribute("Flag") or "rbxassetid://81895312476313";
        end),
        _anchor = v5,
        _center = l__Main__1.Position,
        _flagTop = l__Top__2,
        _flagBottom = l__Bottom__3,
        _flagCenter = l__Main__1.CFrame:ToObjectSpace(v3),
        _flagEnd = l__Main__1.CFrame:ToObjectSpace(v3:ToWorldSpace(CFrame.new(v6, 0, 0)))
    };
    local v8 = setmetatable(v7, u1);
    u4.Texture = u2:GetAttribute("Flag") or "rbxassetid://81895312476313";
    u4.Parent = l__Main__1;
    return v8;
end;
function u1.Update(p9, _, p10) --[[ Line: 52 ]]
    if (p10 - p9._center).Magnitude > 256 then
    else
        local v11 = tick();
        p9._flagTop.CFrame = p9._flagCenter * CFrame.Angles(0, math.sin(v11), 0);
        local l___anchor__5 = p9._anchor;
        if l___anchor__5 then
            p9._flagBottom.CFrame = l___anchor__5.CFrame * CFrame.Angles(0, -math.sin(v11) * 2, 0);
        else
            p9._flagBottom.CFrame = p9._flagEnd * CFrame.new(0, 0, math.cos(v11) * 2) * CFrame.Angles(0, -math.sin(v11) * 2, 0);
        end;
    end;
end;
function u1.Destroy(p12) --[[ Line: 68 ]]
    p12._connection:Disconnect();
end;
return u1;