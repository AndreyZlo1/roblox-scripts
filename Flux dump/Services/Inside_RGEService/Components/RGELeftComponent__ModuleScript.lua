-- Services.RGEService.Components.RGELeftComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local u3 = v1("RGEWidgetComponent");
local u4 = v1("RGEWorldComponent");
local u5 = v1("RGEBotComponent");
local u6 = v1("RGEPlayerComponent");
local u7 = v1("RGEVehicleComponent");
local u8 = v1("RGETriggerComponent");
local v9 = u2.Component:extend("RGELeft");
function v9.init(u10) --[[ Line: 16 ]]
    u10.tabs = {
        "World",
        "Players",
        "Vehicles",
        "Bots",
        "Triggers"
    };
    function u10.switch(p11) --[[ Line: 18 ]]
        -- upvalues: u10 (copy)
        u10:setState({
            selected = p11
        });
    end;
    u10:setState({
        selected = u10.tabs[2]
    });
end;
function v9.render(p12) --[[ Line: 29 ]]
    -- upvalues: u2 (copy), u4 (copy), u6 (copy), u7 (copy), u5 (copy), u8 (copy), u3 (copy)
    local l__selected__1 = p12.state.selected;
    local l__selection__2 = p12.props.selection;
    local l__newSelection__3 = p12.props.newSelection;
    local l__newConsoleLine__4 = p12.props.newConsoleLine;
    local v13 = {};
    if l__selected__1 == "World" then
        v13 = u2.createElement(u4, {
            selection = l__selection__2,
            newSelection = l__newSelection__3,
            id = p12.props.id
        });
    elseif l__selected__1 == "Players" then
        v13 = u2.createElement(u6, {
            selection = l__selection__2,
            newSelection = l__newSelection__3
        });
    elseif l__selected__1 == "Vehicles" then
        v13 = u2.createElement(u7, {
            selection = l__selection__2,
            newSelection = l__newSelection__3
        });
    elseif l__selected__1 == "Bots" then
        v13 = u2.createElement(u5, {
            selection = l__selection__2,
            newSelection = l__newSelection__3
        });
    elseif l__selected__1 == "Triggers" then
        v13 = u2.createElement(u8, {
            newConsoleLine = l__newConsoleLine__4,
            selection = l__selection__2,
            newSelection = l__newSelection__3,
            id = p12.props.id
        });
    end;
    return u2.createElement(u3, {
        selected = l__selected__1,
        tabs = p12.tabs,
        switch = p12.switch,
        content = v13
    });
end;
return v9;