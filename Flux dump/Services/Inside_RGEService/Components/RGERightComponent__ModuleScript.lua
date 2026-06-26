-- Services.RGEService.Components.RGERightComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local u3 = v1("RGEWidgetComponent");
local u4 = v1("RGEPropertiesComponent");
local u5 = v1("RGEMaterialsComponent");
local u6 = v1("RGEColorComponent");
local v7 = u2.Component:extend("RGERight");
function v7.init(u8) --[[ Line: 14 ]]
    u8.tabs = { "Properties", "Materials", "Color" };
    function u8.switch(p9) --[[ Line: 16 ]]
        -- upvalues: u8 (copy)
        u8:setState({
            selected = p9
        });
    end;
    u8:setState({
        selected = u8.tabs[1]
    });
end;
function v7.render(p10) --[[ Line: 27 ]]
    -- upvalues: u2 (copy), u4 (copy), u5 (copy), u6 (copy), u3 (copy)
    local l__selected__1 = p10.state.selected;
    local l__selection__2 = p10.props.selection;
    local v11 = {};
    if l__selected__1 == "Properties" then
        v11 = u2.createElement(u4, {
            window = p10.props.window,
            selection = l__selection__2,
            setPlace = p10.props.setPlace,
            changeHistory = p10.props.changeHistory,
            addChange = p10.props.addChange,
            newSelection = p10.props.newSelection,
            newConsoleLine = p10.props.newConsoleLine
        });
    elseif l__selected__1 == "Materials" then
        v11 = u2.createElement(u5, {
            window = p10.props.window,
            selection = l__selection__2,
            addChange = p10.props.addChange,
            newSelection = p10.props.newSelection,
            newConsoleLine = p10.props.newConsoleLine
        });
    elseif l__selected__1 == "Color" then
        v11 = u2.createElement(u6, {
            window = p10.props.window,
            selection = l__selection__2,
            addChange = p10.props.addChange,
            newSelection = p10.props.newSelection,
            newConsoleLine = p10.props.newConsoleLine
        });
    end;
    return u2.createElement(u3, {
        selected = l__selected__1,
        tabs = p10.tabs,
        switch = p10.switch,
        content = v11
    });
end;
return v7;