-- Services.ReticleService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _ = shared.import("require", "asset");
local u2 = v1("Reticles");
local l__PlayerGui__1 = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");
local l__CurrentCamera__2 = workspace.CurrentCamera;
local u3 = {};
u3.__index = u3;
function u3.new() --[[ Line: 14 ]]
    -- upvalues: u3 (copy)
    return setmetatable({
        Active = false,
        _reticles = {}
    }, u3);
end;
function u3.Update(p4, _) --[[ Line: 24 ]]
    -- upvalues: l__CurrentCamera__2 (copy)
    for v5, v6 in p4._reticles do
        local v7 = l__CurrentCamera__2;
        if v6.VPF then
            v7 = v6.VPF.CurrentCamera;
        else
            v5.Enabled = p4.Active;
        end;
        local l__Position__3 = v7.CFrame.Position;
        if not v6.Fixed or v6.VPF then
            local l__Glass__4 = v6.Glass;
            local l__CFrame__5 = l__Glass__4.CFrame;
            local l__Size__6 = l__Glass__4.Size;
            if not v6.VPF then
                local v8 = l__CFrame__5:PointToObjectSpace(l__Position__3) / Vector3.new(l__Size__6.X, l__Size__6.Y, l__Size__6.Z);
                if not v6.Last or (v6.Last - v8).Magnitude > 0.01 then
                    v6.Reticle.Position = UDim2.fromScale(v8.X + 0.5, 0.5 - v8.Y);
                    v6.Last = v8;
                end;
            end;
            local v9 = v7:WorldToViewportPoint(l__CFrame__5.Position + l__CFrame__5.UpVector * l__Size__6.Y / 2);
            local v10 = (v7:WorldToViewportPoint(l__CFrame__5.Position - l__CFrame__5.UpVector * l__Size__6.Y / 2).Y - v9.Y) / (v6.VPF and 1 or v7.ViewportSize.Y);
            local v11;
            if v6.PercentOfScreen then
                v11 = v6.PercentOfScreen / v10 / (v7.FieldOfView / 70);
                if v6.VPF then
                    v11 = v11 * 1;
                end;
            else
                v11 = 1;
            end;
            v6.Reticle.Size = UDim2.fromScale(v6.Size.X.Scale * v11, v6.Size.Y.Scale * v11);
        end;
    end;
end;
function u3.RegisterReticle(p12, p13, p14, p15, p16) --[[ Line: 72 ]]
    -- upvalues: u2 (copy), l__PlayerGui__1 (copy)
    local v17 = u2[p14.Style];
    local v18 = p14.Resolution or (v17.Resolution or 500);
    local v19 = p14.Brightness or (v17.Brightness or 0);
    local v20, v21;
    if p16 then
        if p14.Style == "Vignette2" or p14.Style == "Vignette" then
            return;
        end;
        v20 = Instance.new("Frame");
        v20.BackgroundTransparency = 1;
        v20.Size = UDim2.fromScale(1, 1);
        v20.ClipsDescendants = true;
        v21 = Instance.new("Frame");
        v21.ZIndex = -1;
        v21.AnchorPoint = Vector2.new(0.5, 0.5);
        v21.BackgroundTransparency = 1;
        v21.ClipsDescendants = true;
        local v22 = p16.CurrentCamera:WorldToViewportPoint((p13.CFrame * CFrame.new(0, 0, p13.Size.Z / 2)).Position);
        v21.Position = UDim2.fromScale(v22.X, v22.Y);
        local v23 = p16.CurrentCamera:WorldToViewportPoint((p13.CFrame * CFrame.new(-p13.Size.X / 2, p13.Size.Y / 2, p13.Size.Z / 2)).Position);
        local v24 = p16.CurrentCamera:WorldToViewportPoint((p13.CFrame * CFrame.new(p13.Size.X / 2, -p13.Size.Y / 2, p13.Size.Z / 2)).Position);
        v21.Size = UDim2.fromScale((v24.X - v23.X) / (p16.AbsoluteSize.X / p16.AbsoluteSize.Y), v24.Y - v23.Y);
        v21.Parent = v20;
    else
        v20 = Instance.new("SurfaceGui");
        v20.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
        v20.PixelsPerStud = v18;
        v20.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud;
        v20.Face = Enum.NormalId.Back;
        v20.ZOffset = p15;
        v20.Adornee = p13;
        v20.Brightness = v19;
        v20.LightInfluence = 0;
        v21 = v20;
    end;
    v20.Name = p14.Style;
    local v25 = Instance.new("CanvasGroup");
    v25.BackgroundTransparency = 1;
    v25.Size = UDim2.fromScale(1, 1);
    v25.Parent = v21;
    local v26 = Instance.new("UICorner");
    v26.CornerRadius = UDim.new(p14.Rounding or 0, 0);
    v26.Parent = v25;
    local v27 = p14.Size or v17.Size;
    local v28 = Instance.new("ImageLabel");
    v28.BackgroundTransparency = 1;
    v28.SizeConstraint = Enum.SizeConstraint.RelativeYY;
    v28.Image = "rbxassetid://" .. v17.Image;
    v28.Size = v27;
    v28.Position = UDim2.fromScale(0.5, 0.5);
    v28.AnchorPoint = Vector2.new(0.5, 0.5);
    v28.ImageColor3 = p14.Color or (v17.Color or Color3.new(1, 1, 1));
    v28.Parent = v25;
    if (p14.Black or v17.Black) and not p16 then
        local v29 = Instance.new("Frame");
        v29.BorderSizePixel = 0;
        v29.BackgroundColor3 = Color3.new(0, 0, 0);
        v29.Size = UDim2.fromOffset(10000, 10000);
        v29.Position = UDim2.fromScale(1, 0.5);
        v29.AnchorPoint = Vector2.new(0, 0.5);
        v29.Parent = v28;
        local v30 = Instance.new("Frame");
        v30.BorderSizePixel = 0;
        v30.BackgroundColor3 = Color3.new(0, 0, 0);
        v30.Size = UDim2.fromOffset(10000, 10000);
        v30.Position = UDim2.fromScale(0, 0.5);
        v30.AnchorPoint = Vector2.new(1, 0.5);
        v30.Parent = v28;
        local v31 = Instance.new("Frame");
        v31.BorderSizePixel = 0;
        v31.BackgroundColor3 = Color3.new(0, 0, 0);
        v31.Size = UDim2.fromOffset(10000, 10000);
        v31.Position = UDim2.fromScale(0.5, 0);
        v31.AnchorPoint = Vector2.new(0.5, 1);
        v31.Parent = v28;
        local v32 = Instance.new("Frame");
        v32.BorderSizePixel = 0;
        v32.BackgroundColor3 = Color3.new(0, 0, 0);
        v32.Size = UDim2.fromOffset(10000, 10000);
        v32.Position = UDim2.fromScale(0.5, 1);
        v32.AnchorPoint = Vector2.new(0.5, 0);
        v32.Parent = v28;
    end;
    p12._reticles[v20] = {
        Glass = p13,
        Reticle = v28,
        PercentOfScreen = v17.PercentOfScreen or (p14.PercentOfScreen or p16 and 0.1),
        Resolution = v18,
        Size = v27,
        Fixed = p14.Fixed or v17.Fixed,
        VPF = p16
    };
    v20.Parent = p16 and p16.Parent or l__PlayerGui__1;
    return v20;
end;
function u3.UnregisterReticle(p33, p34) --[[ Line: 188 ]]
    if p33._reticles[p34] then
        p34:Destroy();
        p33._reticles[p34] = nil;
    end;
end;
return u3.new();