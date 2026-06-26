-- Services.DebugService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, _, u3, u4 = shared.import("require", "Enum", "Roact", "network", "signal");
v1("PlaceService");
game:GetService("Debris");
local l__Players__1 = game:GetService("Players");
game:GetService("TextService");
local l__PlayerGui__2 = l__Players__1.LocalPlayer:WaitForChild("PlayerGui");
Instance.new("Folder", workspace).Name = "DebugServiceClient";
local u5 = {};
u5.__index = u5;
function u5.new() --[[ Line: 20 ]]
    -- upvalues: l__PlayerGui__2 (copy), u2 (copy), u4 (copy), u5 (copy), u3 (copy)
    local v6 = Instance.new("ScreenGui");
    v6.DisplayOrder = 100;
    v6.ResetOnSpawn = false;
    v6.Name = "Debug";
    v6.IgnoreGuiInset = true;
    v6.Parent = l__PlayerGui__2;
    local v7 = Instance.new("Frame");
    v7.BackgroundTransparency = 1;
    v7.Size = UDim2.fromScale(0.9, 0.9);
    v7.Position = UDim2.fromScale(0.05, 0.1);
    v7.Parent = v6;
    local v8 = Instance.new("UIListLayout");
    v8.FillDirection = u2.FillDirection.Vertical;
    v8.HorizontalAlignment = u2.HorizontalAlignment.Left;
    v8.VerticalAlignment = u2.VerticalAlignment.Top;
    v8.Parent = v7;
    local v9 = {
        _container = v7,
        _registeredCallbacks = {},
        OnRegisteredCallback = u4.new(),
        OnUnregisteredCallback = u4.new()
    };
    local u10 = setmetatable(v9, u5);
    u3:ConnectEvents({
        DebugCallbackCreated = function(p11, u12, p13) --[[ Name: DebugCallbackCreated, Line 49 ]]
            -- upvalues: u3 (ref), u10 (copy)
            table.insert(p13, function(p14) --[[ Line: 50 ]]
                -- upvalues: u3 (ref), u12 (copy)
                u3:FireServer("DebugCallback", u12, p14);
            end);
            u10[p11](u10, u12, table.unpack(p13));
        end,
        DebugEventFromServer = function(p15, ...) --[[ Name: DebugEventFromServer, Line 57 ]]
            -- upvalues: u10 (copy)
            u10[p15](u10, ...);
        end,
        DebugCallbackUnRegistered = function(p16) --[[ Name: DebugCallbackUnRegistered, Line 61 ]]
            -- upvalues: u10 (copy)
            u10:UnRegisterCallback(p16);
        end
    });
    return u10;
end;
function u5.IsEnabled(_) --[[ Line: 69 ]]
    return false;
end;
function u5.Graph(_, _, _, _, _, _) --[[ Line: 77 ]] end;
function u5.Gauge(_, _, _, _, _) --[[ Line: 123 ]] end;
function u5.MarkLocation(_, _, _, _, _, _, _) --[[ Line: 162 ]] end;
function u5.MarkArea(_, _, _, _, _, _, _) --[[ Line: 201 ]] end;
CFrame.Angles(0, 1.5707963267948966, 0);
local u17 = {};
function u5.ShowForce(_, _, _, _, _, _, _) --[[ Line: 241 ]] end;
function u5.WipeForces(_) --[[ Line: 294 ]]
    -- upvalues: u17 (ref)
    for _, v18 in u17 do
        v18:Destroy();
    end;
    u17 = {};
end;
function u5.Print(_, _, _, _) --[[ Line: 305 ]] end;
function u5.Switch(p19, p20, p21, p22) --[[ Line: 326 ]]
    if p20 then
        p19:Print(p21, Color3.new(0, 1, 0));
    else
        p19:Print(p22, Color3.new(1, 0, 0));
    end;
end;
function u5.Slider(_, _, _, _, _, _, _) --[[ Line: 339 ]] end;
function u5.Toggleable(_, _, _, _) --[[ Line: 363 ]] end;
function u5.ReadValue(p23, p24) --[[ Line: 386 ]]
    return p23._registeredCallbacks[p24].Params[1];
end;
function u5.UnRegisterCallback(p25, p26) --[[ Line: 391 ]]
    local v27 = p25._registeredCallbacks[p26];
    if v27 then
        p25._registeredCallbacks[p26] = nil;
        p25.OnUnregisteredCallback:Fire(v27);
    end;
end;
function u5.UnRegisterCallbacks(p28, p29) --[[ Line: 400 ]]
    for _, v30 in p29 do
        p28:UnRegisterCallback(v30);
    end;
end;
function u5.GetRegisteredCallbacks(p31) --[[ Line: 406 ]]
    return p31._registeredCallbacks;
end;
return u5.new();