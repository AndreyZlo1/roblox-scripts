-- Services.RGEService.Components.RGEBottomComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local u3 = v1("RGEConsoleComponent");
local u4 = v1("RGEWidgetComponent");
local u5 = v1("RGEAssetBrowserComponent");
local v6 = u2.Component:extend("RGEBottom");
function v6.init(u7) --[[ Line: 13 ]]
    u7.tabs = { "Console", "Asset Browser" };
    function u7.switch(p8) --[[ Line: 15 ]]
        -- upvalues: u7 (copy)
        u7:setState({
            selected = p8
        });
    end;
    u7:setState({
        selected = u7.tabs[1]
    });
end;
function v6.render(p9) --[[ Line: 26 ]]
    -- upvalues: u2 (copy), u3 (copy), u5 (copy), u4 (copy)
    local l__selected__1 = p9.state.selected;
    local v10 = {};
    if l__selected__1 == "Console" then
        v10 = u2.createElement(u3, {
            newConsoleLine = p9.props.newConsoleLine,
            console = p9.props.console
        });
    elseif l__selected__1 == "Asset Browser" then
        v10 = u2.createElement(u5, {
            newConsoleLine = p9.props.newConsoleLine,
            id = p9.props.id,
            setPlace = p9.props.setPlace
        });
    end;
    return u2.createElement(u4, {
        selected = l__selected__1,
        tabs = p9.tabs,
        switch = p9.switch,
        content = v10
    });
end;
return v6;