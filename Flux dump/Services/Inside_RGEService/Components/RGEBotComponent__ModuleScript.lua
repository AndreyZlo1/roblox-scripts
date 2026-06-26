-- Services.RGEService.Components.RGEBotComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local u3 = v1("ReplicatorService");
local u4 = v1("RGEScrollComponent");
local v5 = u2.Component:extend("RGEBot");
function v5.init(p6) --[[ Line: 14 ]]
    -- upvalues: u3 (copy)
    local v7 = {
        {}
    };
    for _, v8 in u3:GetActors() do
        if not v8.Owner then
            v7[1][v8] = {
                Name = "Bot",
                Icon = "rbxassetid://9676324194"
            };
        end;
    end;
    p6:setState({
        bots = v7
    });
end;
function v5.willUnmount(_) --[[ Line: 33 ]] end;
function v5.render(p9) --[[ Line: 37 ]]
    -- upvalues: u2 (copy), u4 (copy)
    return u2.createElement(u4, {
        botsDebug = true,
        data = p9.state.bots,
        selection = p9.props.selection,
        newSelection = p9.props.newSelection
    });
end;
return v5;