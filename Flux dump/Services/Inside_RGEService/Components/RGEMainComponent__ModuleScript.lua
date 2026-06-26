-- Services.RGEService.Components.RGEMainComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, v4 = shared.import("require", "network", "Roact", "RoactRodux");
local u5 = v1("RGELeftComponent");
local u6 = v1("RGERightComponent");
local u7 = v1("RGETopComponent");
local u8 = v1("RGEBottomComponent");
local u9 = v1("RGEStationsComponent");
return v4.connect(function(p10, p11) --[[ Line: 15 ]]
    return {
        window = p10.window,
        windows = p10.windows,
        selection = p10.selection,
        console = p10.console,
        id = p10.id,
        tool = p10.tool,
        worldSpace = p10.worldSpace,
        move = p10.move,
        rotate = p10.rotate,
        addChange = p10.addChange,
        changeHistory = p10.changeHistory,
        navMeshEditor = p10.navMeshEditor,
        stations = p11.stations,
        left = p11.left,
        right = p11.right,
        top = p11.top,
        bottom = p11.bottom
    };
end, function(u12) --[[ Line: 37 ]]
    -- upvalues: u2 (copy)
    return {
        changeTool = function(p13) --[[ Name: changeTool, Line 39 ]]
            -- upvalues: u12 (copy)
            u12({
                type = "changeTool",
                tool = p13
            });
        end,
        changeWindow = function(p14) --[[ Name: changeWindow, Line 45 ]]
            -- upvalues: u12 (copy)
            u12({
                type = "changeWindow",
                window = p14
            });
        end,
        closeWindow = function(p15) --[[ Name: closeWindow, Line 51 ]]
            -- upvalues: u12 (copy)
            u12({
                type = "closeWindow",
                window = p15
            });
        end,
        newWindow = function(p16) --[[ Name: newWindow, Line 57 ]]
            -- upvalues: u12 (copy)
            u12({
                type = "newWindow",
                window = p16
            });
        end,
        newSelection = function(p17) --[[ Name: newSelection, Line 63 ]]
            -- upvalues: u12 (copy)
            u12({
                type = "newSelection",
                selection = p17
            });
        end,
        newConsoleLine = function(p18) --[[ Name: newConsoleLine, Line 69 ]]
            -- upvalues: u12 (copy), u2 (ref)
            u12({
                type = "newConsoleLine",
                entry = table.concat(p18, " "),
                color = Color3.new(1, 1, 1)
            });
            u2:FireServer("ActivateConsole", unpack(p18));
        end,
        createGroup = function(p19) --[[ Name: createGroup, Line 77 ]]
            -- upvalues: u12 (copy)
            u12({
                type = "createGroup",
                group = p19
            });
        end,
        setPlace = function(p20, p21) --[[ Name: setPlace, Line 83 ]]
            -- upvalues: u12 (copy)
            u12({
                type = "setPlace",
                model = p20,
                callback = p21
            });
        end,
        changeWorld = function(p22) --[[ Name: changeWorld, Line 90 ]]
            -- upvalues: u12 (copy)
            u12({
                type = "changeWorld",
                id = p22
            });
        end,
        toggleWorldSpace = function() --[[ Name: toggleWorldSpace, Line 96 ]]
            -- upvalues: u12 (copy)
            u12({
                type = "toggleWorldSpace"
            });
        end,
        changeSnap = function(p23, p24) --[[ Name: changeSnap, Line 101 ]]
            -- upvalues: u12 (copy)
            u12({
                type = "changeSnap",
                tool = p23,
                value = p24
            });
        end,
        fullScreen = function() --[[ Name: fullScreen, Line 108 ]]
            -- upvalues: u12 (copy)
            u12({
                type = "fullScreen"
            });
        end
    };
end)(function(p25) --[[ Line: 115 ]]
    -- upvalues: u3 (copy), u5 (copy), u6 (copy), u7 (copy), u8 (copy), u9 (copy)
    local l__window__1 = p25.window;
    local l__windows__2 = p25.windows;
    local v26 = l__windows__2[l__window__1];
    local l__selection__3 = p25.selection;
    local l__id__4 = p25.id;
    local l__tool__5 = p25.tool;
    return u3.createFragment({
        Left = u3.createElement(u3.Portal, {
            target = p25.left
        }, u3.createElement(u5, {
            window = v26,
            selection = l__selection__3,
            id = l__id__4,
            newConsoleLine = p25.newConsoleLine,
            newSelection = p25.newSelection
        })),
        Right = u3.createElement(u3.Portal, {
            target = p25.right
        }, u3.createElement(u6, {
            window = v26,
            selection = l__selection__3,
            setPlace = p25.setPlace,
            addChange = p25.addChange,
            changeHistory = p25.changeHistory,
            newSelection = p25.newSelection,
            newConsoleLine = p25.newConsoleLine
        })),
        Top = u3.createElement(u3.Portal, {
            target = p25.top
        }, u3.createElement(u7, {
            window = v26,
            id = l__id__4,
            tool = l__tool__5,
            move = p25.move,
            rotate = p25.rotate,
            selection = l__selection__3,
            worldSpace = p25.worldSpace,
            setPlace = p25.setPlace,
            newSelection = p25.newSelection,
            createGroup = p25.createGroup,
            fullScreen = p25.fullScreen,
            changeSnap = p25.changeSnap,
            changeTool = p25.changeTool,
            newWindow = p25.newWindow,
            changeWorld = p25.changeWorld,
            toggleWorldSpace = p25.toggleWorldSpace,
            newConsoleLine = p25.newConsoleLine,
            navMeshEditor = p25.navMeshEditor
        })),
        Bottom = u3.createElement(u3.Portal, {
            target = p25.bottom
        }, u3.createElement(u8, {
            window = v26,
            console = p25.console,
            id = l__id__4,
            setPlace = p25.setPlace,
            newConsoleLine = p25.newConsoleLine,
            newWindow = p25.newWindow
        })),
        Stations = u3.createElement(u3.Portal, {
            target = p25.stations
        }, u3.createElement(u9, {
            window = l__window__1,
            windows = l__windows__2,
            changeWindow = p25.changeWindow,
            closeWindow = p25.closeWindow
        }))
    });
end);