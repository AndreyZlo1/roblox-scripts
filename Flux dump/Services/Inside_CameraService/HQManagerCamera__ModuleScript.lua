-- Services.CameraService.HQManagerCamera
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _, u2 = shared.import("require", "network", "Roact");
local l__CollectionService__1 = game:GetService("CollectionService");
local l__Players__2 = game:GetService("Players");
local u3 = v1("HQManagerInterface");
v1("ViewmodelService");
local u4 = v1("InputService");
local u5 = v1("RoactTween");
local l__PlayerGui__3 = l__Players__2.LocalPlayer:WaitForChild("PlayerGui");
local l__CurrentCamera__4 = workspace.CurrentCamera;
local u6 = {};
u6.__index = u6;
function u6.new(_, p7, p8) --[[ Line: 24 ]]
    -- upvalues: l__PlayerGui__3 (copy), u2 (copy), l__CollectionService__1 (copy), u5 (copy), u6 (copy), u3 (copy), u4 (copy)
    local u9 = {};
    local function u15(p10) --[[ Line: 26 ]]
        -- upvalues: l__PlayerGui__3 (ref), u2 (ref), u9 (copy)
        local v11 = Instance.new("Highlight");
        v11.Adornee = p10;
        v11.OutlineTransparency = 1;
        v11.FillColor = Color3.fromRGB(255, 194, 89);
        v11.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
        v11.Parent = l__PlayerGui__3;
        local v12 = p10:GetBoundingBox();
        local v13, v14 = u2.createBinding(UDim2.new());
        u9[p10.Name] = {
            Position = v13,
            UpdatePosition = v14,
            Origin = v12.Position,
            Highlight = v11,
            Model = p10
        };
    end;
    local v18 = {
        [#v18 + 1] = l__CollectionService__1:GetInstanceRemovedSignal("HQUpgrade"):Connect(function(p16) --[[ Line: 55 ]]
            -- upvalues: u9 (copy)
            local l__Name__5 = p16.Name;
            if u9[l__Name__5] then
                u9[l__Name__5].Highlight:Destroy();
                u9[l__Name__5] = nil;
            end;
        end),
        [#v18 + 1] = l__CollectionService__1:GetInstanceAddedSignal("HQUpgrade"):Connect(function(p17) --[[ Line: 58 ]]
            -- upvalues: u9 (copy), u15 (copy)
            local l__Name__6 = p17.Name;
            if u9[l__Name__6] then
                u9[l__Name__6].Highlight:Destroy();
                u9[l__Name__6] = nil;
            end;
            u15(p17);
        end)
    };
    for _, v19 in l__CollectionService__1:GetTagged("HQUpgrade") do
        u15(v19);
    end;
    local v20 = u5.new(1);
    local v21, v22 = u2.createBinding("");
    local v23 = setmetatable({
        _origin = Vector3.new(50, 1000, -549),
        _cameraPage = "",
        _connections = v18,
        _hqUpgrades = u9,
        _cameraTransition = v20,
        _cameraFocus = v21
    }, u6);
    v20:SetGoal(0);
    u3:Enable(p7, u9, v22, p8);
    u4.TabletOpen = true;
    return v23;
end;
function u6.Update(p24, p25, p26) --[[ Line: 84 ]]
    -- upvalues: l__CurrentCamera__4 (copy), u4 (copy)
    local v27 = p24._cameraFocus:getValue();
    local l___cameraTransition__7 = p24._cameraTransition;
    if p24._cameraPage ~= v27 then
        p24._cameraPage = v27;
        l___cameraTransition__7:SetValue(1);
        l___cameraTransition__7:SetGoal(0);
    end;
    if #v27 > 0 then
        local v28 = workspace.Terrain["Camera_" .. v27];
        l__CurrentCamera__4.CFrame = v28.WorldCFrame - v28.WorldCFrame.LookVector * l___cameraTransition__7:GetValue() * 10;
        l__CurrentCamera__4.Focus = l__CurrentCamera__4.CFrame;
        for _, v29 in p24._hqUpgrades do
            v29.Highlight.FillTransparency = 1;
        end;
        return;
    end;
    local l___origin__8 = p24._origin;
    local v30 = l___origin__8.Y / 10;
    local l__X__9 = p25.X;
    local l__Y__10 = p25.Y;
    if u4.Gamepad then
        l__X__9 = l__X__9 * -3;
        l__Y__10 = l__Y__10 * -3;
    elseif not u4.Touch then
        l__X__9 = l__X__9 - u4._inputMovement.X * p26 * 20;
        l__Y__10 = l__Y__10 - u4._inputMovement.Y * p26 * 20;
    end;
    local v31 = math.clamp(l___origin__8.X - l__X__9 * v30, -700, 700);
    local v32 = math.clamp(l___origin__8.Y - p25.Z * 10, 100, 1000);
    local v33 = math.clamp(l___origin__8.Z - l__Y__10 * v30, -700, 700);
    local v34 = Vector3.new(v31, v32, v33);
    local v35 = l__CurrentCamera__4;
    local l__new__11 = CFrame.new;
    local v36 = l___cameraTransition__7:GetValue() * 100;
    v35.CFrame = l__new__11(v34 + Vector3.new(0, v36, 0)) * CFrame.Angles(-1.5707963267948966, 0, 0);
    l__CurrentCamera__4.Focus = CFrame.new(v34.X, 25, v34.Z);
    l__CurrentCamera__4.FieldOfView = 70;
    local v37 = false;
    for _, v38 in p24._hqUpgrades do
        if v38.Hover then
            v37 = true;
            break;
        end;
    end;
    local v39 = tick();
    for _, v40 in p24._hqUpgrades do
        local v41 = l__CurrentCamera__4:WorldToViewportPoint(v40.Origin);
        v40.Highlight.FillTransparency = v40.Hover and 0.5 or (v37 and 0.9 or 0.85 - math.sin(v39 * 3) / 20);
        v40.UpdatePosition(UDim2.fromOffset(v41.X, v41.Y));
    end;
    p24._origin = v34;
end;
function u6.Shake(_) --[[ Line: 138 ]] end;
function u6.Destroy(p42) --[[ Line: 141 ]]
    -- upvalues: u3 (copy), u4 (copy)
    for _, v43 in p42._connections do
        v43:Disconnect();
    end;
    for _, v44 in p42._hqUpgrades do
        v44.Highlight:Destroy();
    end;
    u3:Disable();
    u4.TabletOpen = false;
end;
return u6;