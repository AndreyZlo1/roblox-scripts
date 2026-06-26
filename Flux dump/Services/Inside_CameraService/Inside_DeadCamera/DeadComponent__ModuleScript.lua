-- Services.CameraService.DeadCamera.DeadComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local u3 = v1("PostProcessingService");
local u4 = v1("SoundService");
local u5 = v1("RoactTween");
local v6 = u2.Component:extend("Dead");
function v6.init(p7, _) --[[ Line: 10 ]]
    -- upvalues: u4 (copy), u5 (copy), u3 (copy)
    local u8 = u4:CreateSound("Button", nil, false, "UISounds", "MatchCounter");
    u8.Play();
    task.delay(1, function() --[[ Line: 14 ]]
        -- upvalues: u8 (copy)
        u8.Play();
        u8.Destroy(3);
    end);
    p7.PromptProgress = u5.new(0, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0));
    p7.PromptProgress:SetGoal(1);
    p7.ColorEffect = u3:AddColorCorrection({
        Saturation = p7.PromptProgress:Map(function(p9) --[[ Line: 23 ]]
            return -p9;
        end)
    }, nil, true);
end;
function v6.willUnmount(p10) --[[ Line: 29 ]]
    p10.ColorEffect.Destroy();
end;
function v6.render(p11) --[[ Line: 33 ]]
    -- upvalues: u2 (copy)
    return u2.createFragment({
        Skull = u2.createElement("ImageLabel", {
            BackgroundTransparency = 1,
            Image = "rbxassetid://71333190142604",
            Visible = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.075, 0.075),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            ImageColor3 = p11.PromptProgress:Map(function(p12) --[[ Line: 42 ]]
                return Color3.new(1, 1, 1):Lerp(Color3.new(1, 0.5, 0.5), p12);
            end),
            ImageTransparency = p11.PromptProgress:Map(function(p13) --[[ Line: 45 ]]
                return 1 - p13;
            end)
        }),
        Progress = u2.createElement("ImageLabel", {
            BackgroundTransparency = 1,
            Image = "rbxassetid://91586039536034",
            Visible = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = p11.PromptProgress:Map(function(p14) --[[ Line: 54 ]]
                local v15 = p14 * 0.05 + 0.15;
                return UDim2.fromScale(v15, v15);
            end),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            ImageColor3 = Color3.new(1, 0.5, 0.5)
        }, {
            u2.createElement("UIGradient", {
                Color = ColorSequence.new(Color3.new(1, 1, 1)),
                Offset = Vector2.new(0, 0),
                Rotation = p11.PromptProgress:Map(function(p16) --[[ Line: 66 ]]
                    return math.clamp(p16 * 2, 0, 1) * -180;
                end),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.495, 1),
                    NumberSequenceKeypoint.new(0.505, 0),
                    NumberSequenceKeypoint.new(1, 0)
                })
            }),
            Inside = u2.createElement("ImageLabel", {
                BackgroundTransparency = 1,
                Rotation = 180,
                Image = "rbxassetid://91586039536034",
                ImageColor3 = Color3.new(1, 0.5, 0.5),
                AnchorPoint = Vector2.new(0, 0),
                Position = UDim2.fromOffset(-2, 0),
                Size = UDim2.fromScale(1, 1),
                Visible = p11.PromptProgress:Map(function(p17) --[[ Line: 82 ]]
                    return p17 >= 0.5;
                end)
            }, { u2.createElement("UIGradient", {
                    Color = ColorSequence.new(Color3.new(1, 1, 1)),
                    Offset = Vector2.new(0, 0),
                    Rotation = p11.PromptProgress:Map(function(p18) --[[ Line: 91 ]]
                        return math.clamp((p18 - 0.5) * 2, 0, 1) * -180;
                    end),
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.495, 1),
                        NumberSequenceKeypoint.new(0.505, 0),
                        NumberSequenceKeypoint.new(1, 0)
                    })
                }) })
        })
    });
end;
return v6;