-- Services.RGEService.Components.RGEAssetLoadingComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local _, u1 = shared.import("require", "Roact");
local l__RunService__1 = game:GetService("RunService");
local v2 = u1.Component:extend("RGEAssetLoading");
function v2.init(u3, _) --[[ Line: 12 ]]
    -- upvalues: u1 (copy), l__RunService__1 (copy)
    local v4, v5 = u1.createBinding(0);
    u3.CircleTween = v4;
    u3.UpdateCircle = v5;
    local u6 = os.clock();
    u3._conn = l__RunService__1.Heartbeat:Connect(function(_) --[[ Line: 15 ]]
        -- upvalues: u3 (copy), u6 (copy)
        u3.UpdateCircle((os.clock() - u6) * 1000);
    end);
end;
function v2.render(p7) --[[ Line: 20 ]]
    -- upvalues: u1 (copy)
    return u1.createElement("Frame", {
        BackgroundTransparency = 1
    }, { u1.createElement("ImageLabel", {
            BackgroundTransparency = 1,
            Image = "rbxassetid://93026081002023",
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.3, 0.3),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ImageColor3 = Color3.fromRGB(0, 120, 212),
            Rotation = p7.CircleTween
        }) });
end;
function v2.willUnmount(p8) --[[ Line: 36 ]]
    p8._conn:Disconnect();
end;
return v2;