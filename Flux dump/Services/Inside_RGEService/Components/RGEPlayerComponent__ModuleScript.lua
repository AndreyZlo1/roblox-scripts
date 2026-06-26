-- Services.RGEService.Components.RGEPlayerComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local l__Players__1 = game:GetService("Players");
local u3 = v1("RGEScrollComponent");
local v4 = u2.Component:extend("RGEPlayer");
function v4.init(u5) --[[ Line: 14 ]]
    -- upvalues: l__Players__1 (copy)
    u5.listeners = {};
    local u6 = {};
    u5.listeners[#u5.listeners + 1] = l__Players__1.PlayerRemoving:Connect(function(p7) --[[ Line: 25 ]]
        -- upvalues: u6 (copy), u5 (copy)
        u6[p7] = nil;
        u5:setState({
            players = u6
        });
    end);
    u5.listeners[#u5.listeners + 1] = l__Players__1.PlayerAdded:Connect(function(p8) --[[ Line: 31 ]]
        -- upvalues: u6 (copy), u5 (copy)
        u6[p8] = {
            Icon = "rbxassetid://9681369030",
            Name = p8.Name
        };
        u5:setState({
            players = u6
        });
    end);
    for _, v9 in pairs(l__Players__1:GetPlayers()) do
        u6[v9] = {
            Icon = "rbxassetid://9681369030",
            Name = v9.Name
        };
    end;
    u5:setState({
        players = u6
    });
end;
function v4.willUnmount(p10) --[[ Line: 46 ]]
    local l__listeners__2 = p10.listeners;
    for v11 = 1, #l__listeners__2 do
        l__listeners__2[v11]:Disconnect();
    end;
end;
function v4.render(p12) --[[ Line: 53 ]]
    -- upvalues: u2 (copy), u3 (copy)
    return u2.createElement(u3, {
        data = p12.state.players,
        selection = p12.props.selection,
        newSelection = p12.props.newSelection
    });
end;
return v4;