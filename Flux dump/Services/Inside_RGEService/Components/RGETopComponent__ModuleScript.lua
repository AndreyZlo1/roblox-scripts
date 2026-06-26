-- Services.RGEService.Components.RGETopComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4, u5 = shared.import("require", "Roact", "asset", "server", "network");
local l__Lighting__1 = game:GetService("Lighting");
local l__Players__2 = game:GetService("Players");
local u6 = v1("RGEWidgetComponent");
local u7 = v1("RGETopButtonComponent");
local v8 = u2.Component:extend("RGETop");
local l__LocalPlayer__3 = l__Players__2.LocalPlayer;
local l__CurrentCamera__4 = workspace.CurrentCamera;
local u9 = {
    { "ClearSky", 55, "rbxassetid://79097896253596" },
    { "RonoClearSky", 85, "rbxassetid://79097896253596" },
    { "Overcast1", 70, "rbxassetid://119245112614066" },
    { "Overcast2", 70, "rbxassetid://119245112614066" },
    { "Overcast3", 70, "rbxassetid://119245112614066" },
    { "Fog1", 45, "rbxassetid://126257053651421" },
    { "Fog2", 45, "rbxassetid://126257053651421" },
    { "Fog3", 45, "rbxassetid://126257053651421" },
    { "Rain1", 50, "rbxassetid://72764958848297" },
    { "Rain2", 50, "rbxassetid://72764958848297" },
    { "Rain3", 50, "rbxassetid://72764958848297" },
    { "Storm1", 60, "rbxassetid://74007491488394" },
    { "Storm2", 60, "rbxassetid://74007491488394" },
    { "Storm3", 60, "rbxassetid://74007491488394" }
};
local u10 = {
    red = Color3.fromRGB(255, 10, 14),
    orange = Color3.fromRGB(255, 150, 29),
    blue = Color3.fromRGB(52, 133, 255),
    yellow = Color3.fromRGB(255, 216, 57),
    green = Color3.fromRGB(134, 255, 58),
    neutral = Color3.fromRGB(255, 255, 255)
};
local u11 = {
    Left = "rbxassetid://123287110530043",
    Right = "rbxassetid://122293572428460",
    Center = "rbxassetid://77256209006212",
    Crouch = "rbxassetid://120443242873506",
    Prone = "rbxassetid://128137936439082"
};
local u12 = {
    Center = 0.4,
    Prone = 2,
    Crouch = 0.7,
    Left = 0.4,
    Right = 0.4
};
function v8.init(u13) --[[ Line: 64 ]]
    -- upvalues: u4 (copy), l__CurrentCamera__4 (copy), u3 (copy), u10 (copy), u12 (copy)
    u13.tabs = {
        "File",
        "Home",
        "Gamemode",
        "Weather",
        "AI"
    };
    if u4.IS_PVP then
        u13.tabs[#u13.tabs + 1] = "PVP";
    end;
    function u13.switch(p14) --[[ Line: 70 ]]
        -- upvalues: u13 (copy)
        u13:setState({
            selected = p14
        });
    end;
    u13:setState({
        selected = u13.tabs[2]
    });
    function u13.createPart(p15) --[[ Line: 80 ]]
        -- upvalues: l__CurrentCamera__4 (ref), u13 (copy)
        local l__CFrame__5 = l__CurrentCamera__4.CFrame;
        local v16 = l__CFrame__5 + l__CFrame__5.LookVector * 5;
        u13.props.newConsoleLine({
            "create",
            tostring(u13.props.id),
            p15,
            v16.X,
            v16.Y,
            v16.Z
        });
    end;
    function u13.teleportPlayer() --[[ Line: 87 ]]
        -- upvalues: u3 (ref), u13 (copy)
        local v17 = u3:Get("Shared", "Models", "Character", "Spawner").Asset:Clone();
        for _, v18 in v17:GetChildren() do
            v18.Color = Color3.new(1, 1, 1);
        end;
        v17.Parent = workspace;
        local u19 = {};
        for _, v20 in u13.props.selection do
            if v20:IsA("Player") then
                u19[#u19 + 1] = v20.Name;
            end;
        end;
        u13.props.setPlace(v17, function(p21) --[[ Line: 101 ]]
            -- upvalues: u19 (copy), u13 (ref)
            local _, v22 = p21:ToOrientation();
            for _, v23 in u19 do
                u13.props.newConsoleLine({
                    "teleport",
                    "player",
                    v23,
                    p21.X,
                    p21.Y,
                    p21.Z,
                    (math.deg(v22))
                });
            end;
        end);
    end;
    function u13.squadSpawn(u24) --[[ Line: 109 ]]
        -- upvalues: u3 (ref), u10 (ref), u13 (copy)
        local v25 = u3:Get("Shared", "Models", "Character", "Spawner").Asset:Clone();
        for _, v26 in v25:GetChildren() do
            v26.Color = u10[u24];
        end;
        v25.Parent = workspace;
        u13.props.setPlace(v25, function(p27) --[[ Line: 116 ]]
            -- upvalues: u13 (ref), u24 (copy)
            local _, v28 = p27:ToOrientation();
            u13.props.newConsoleLine({
                "squadspawn",
                p27.X,
                p27.Y,
                p27.Z,
                math.deg(v28),
                u24
            });
        end);
    end;
    function u13.pvpSpawn(u29) --[[ Line: 122 ]]
        -- upvalues: u3 (ref), u13 (copy)
        local v30 = u3:Get("Shared", "Models", "Character", "PVPSpawner").Asset:Clone();
        for _, v31 in v30:GetDescendants() do
            if v31:IsA("BasePart") then
                v31.Color = u29 == "attacking" and Color3.new(1, 0, 0) or Color3.new(0, 0, 1);
            end;
        end;
        v30.Parent = workspace;
        u13.props.setPlace(v30, function(p32) --[[ Line: 131 ]]
            -- upvalues: u13 (ref), u29 (copy)
            local _, v33 = p32:ToOrientation();
            u13.props.newConsoleLine({
                "pvp",
                "spawn",
                u29,
                p32.X,
                p32.Y,
                p32.Z,
                (math.deg(v33))
            });
        end);
    end;
    function u13.walkTo(u34) --[[ Line: 137 ]]
        -- upvalues: u3 (ref), u13 (copy)
        local v35 = u3:Get("Shared", "Models", "Character", "Spawner").Asset:Clone();
        v35.Parent = workspace;
        local u36 = {};
        for _, v37 in u13.props.selection do
            if v37:IsA("Actor") then
                u36[#u36 + 1] = v37;
            end;
        end;
        u13.props.newSelection({});
        u13.props.setPlace(v35, function(p38, p39) --[[ Line: 149 ]]
            -- upvalues: u36 (copy), u13 (ref), u34 (copy)
            for _, v40 in u36 do
                u13.props.newConsoleLine({
                    "bot",
                    "direct",
                    v40.UID,
                    u34,
                    p38.X,
                    p38.Y,
                    p38.Z
                });
            end;
            if p39 then
                u13.props.newSelection(u36);
            end;
        end);
    end;
    function u13.coverNode(u41) --[[ Line: 160 ]]
        -- upvalues: u3 (ref), u12 (ref), u13 (copy)
        local v42 = u3:Get("Shared", "Models", "Covers", u41).Asset:Clone();
        for _, v43 in v42:GetChildren() do
            v43.Material = Enum.Material.SmoothPlastic;
            v43.Color = Color3.new(1, 1, 1);
            v43.Anchored = true;
            v43.Transparency = v43 == v42.PrimaryPart and 1 or 0.5;
            v43.CanCollide = false;
            v43.CanTouch = false;
            v43.CanQuery = false;
        end;
        v42.PrimaryPart.PivotOffset = CFrame.new(0, -3 + u12[u41], 0);
        v42.Parent = workspace;
        u13.props.setPlace(v42, function(p44) --[[ Line: 176 ]]
            -- upvalues: u13 (ref), u41 (copy)
            local _, v45 = p44:ToOrientation();
            u13.props.newConsoleLine({
                "navMesh",
                "cover",
                u41,
                p44.X,
                p44.Y + 3,
                p44.Z,
                (math.deg(v45))
            });
        end);
    end;
    function u13.navNode() --[[ Line: 182 ]]
        -- upvalues: u13 (copy), u4 (ref)
        local v46 = Instance.new("Model");
        local v47 = Instance.new("Part");
        v47.Anchored = true;
        v47.CanCollide = false;
        v47.CanTouch = false;
        v47.CanQuery = false;
        v47.Shape = Enum.PartType.Ball;
        v47.CastShadow = false;
        v47.Size = Vector3.new(3, 3, 3);
        v47.Transparency = 0.5;
        v47.TopSurface = Enum.SurfaceType.Smooth;
        v47.BottomSurface = Enum.SurfaceType.Smooth;
        v47.PivotOffset = CFrame.new(0, 1.5, 0);
        v47.Parent = v46;
        v46.PrimaryPart = v47;
        v46.Parent = workspace;
        local u48 = nil;
        u13.props.setPlace(v46, function(p49, _, u50) --[[ Line: 202 ]]
            -- upvalues: u48 (ref), u13 (ref), u4 (ref)
            if u50 then
                u50 = u50.Instance;
            end;
            if u50 and u50:GetAttribute("NodeId") then
                local v51 = u50:GetAttribute("NodeId");
                local v52;
                if u48 then
                    u13.props.newConsoleLine({
                        "navMesh",
                        "join",
                        u48,
                        v51
                    });
                    v52 = true;
                else
                    v52 = false;
                end;
                u48 = v51;
                local l__Color__6 = u50.Color;
                u50.Color = Color3.new(1, 1, 0);
                task.delay(0.2, function() --[[ Line: 215 ]]
                    -- upvalues: u50 (copy), l__Color__6 (copy)
                    u50.Color = l__Color__6;
                end);
                return not v52;
            end;
            local v53 = u4.NAVMESH_COUNT + 1;
            u13.props.newConsoleLine({
                "navMesh",
                "add",
                p49.X,
                p49.Y - 1.5,
                p49.Z
            });
            if u48 then
                u13.props.newConsoleLine({
                    "navMesh",
                    "join",
                    u48,
                    v53
                });
            end;
            u48 = v53;
        end);
    end;
end;
function v8.render(u54) --[[ Line: 232 ]]
    -- upvalues: l__LocalPlayer__3 (copy), u4 (copy), u5 (copy), u9 (copy), l__Lighting__1 (copy), u3 (copy), u12 (copy), u11 (copy), u2 (copy), u7 (copy), u6 (copy)
    local l__selected__7 = u54.state.selected;
    local l__changeTool__8 = u54.props.changeTool;
    local l__changeSnap__9 = u54.props.changeSnap;
    local l__newWindow__10 = u54.props.newWindow;
    local l__newConsoleLine__11 = u54.props.newConsoleLine;
    local v55 = {};
    if l__selected__7 == "File" then
        local v58 = {
            {
                Name = "List",
                Size = 50,
                Image = "rbxassetid://78760891727739",
                Callback = function() --[[ Name: Callback, Line 246 ]]
                    -- upvalues: l__newConsoleLine__11 (copy)
                    l__newConsoleLine__11({ "file", "list" });
                end
            },
            {
                Name = "Load",
                Size = 50,
                Image = "rbxassetid://131935994917856",
                Input = true,
                Callback = function(p56) --[[ Name: Callback, Line 255 ]]
                    -- upvalues: l__newConsoleLine__11 (copy), l__LocalPlayer__3 (ref)
                    if p56 then
                        l__newConsoleLine__11({ "file", "load", l__LocalPlayer__3.UserId .. "_" .. p56 });
                    end;
                end
            },
            {
                Name = "Save As",
                Size = 60,
                Image = "rbxassetid://129080963355900",
                Input = true,
                Callback = function(p57) --[[ Name: Callback, Line 266 ]]
                    -- upvalues: l__newConsoleLine__11 (copy)
                    if p57 then
                        l__newConsoleLine__11({ "file", "save", (tostring(p57)) });
                    end;
                end
            }
        };
        if u4.MAP_ID then
            v58[#v58 + 1] = {
                Name = "Save",
                Size = 50,
                Image = "rbxassetid://78785806497584",
                Callback = function() --[[ Name: Callback, Line 278 ]]
                    -- upvalues: u4 (ref), u54 (copy)
                    local v59 = { "file", "save", (u4.MAP_ID:sub(u4.MAP_ID:find("_") + 1)) };
                    u54.props.newConsoleLine(v59);
                end
            };
        end;
        v55 = {
            {
                Name = "Project",
                Options = v58
            },
            {
                Name = "Permissions",
                Options = {
                    {
                        Name = "Allow Load Copy",
                        Size = 70,
                        Image = "rbxassetid://124103883868229",
                        Selected = u4.ALLOW_LOAD_COPY,
                        Callback = function() --[[ Name: Callback, Line 298 ]]
                            -- upvalues: u5 (ref), u4 (ref)
                            u5:FireServer("ChangeSetting", "AllowLoadCopy", not u4.ALLOW_LOAD_COPY);
                        end
                    },
                    {
                        Name = "Allow Save Copy",
                        Size = 70,
                        Image = "rbxassetid://111767938516681",
                        Selected = u4.ALLOW_SAVE_COPY,
                        Callback = function() --[[ Name: Callback, Line 307 ]]
                            -- upvalues: u5 (ref), u4 (ref)
                            u5:FireServer("ChangeSetting", "AllowSaveCopy", not u4.ALLOW_SAVE_COPY);
                        end
                    },
                    {
                        Name = "Allow Offline Saving",
                        Size = 80,
                        Image = "rbxassetid://91284960653665",
                        Selected = u4.ALLOW_OFFLINE_SAVE,
                        Callback = function() --[[ Name: Callback, Line 316 ]]
                            -- upvalues: u5 (ref), u4 (ref)
                            u5:FireServer("ChangeSetting", "AllowOfflineSave", not u4.ALLOW_OFFLINE_SAVE);
                        end
                    }
                }
            },
            {
                Name = "Model",
                Options = {
                    {
                        Name = "Save Model",
                        Size = 50,
                        Image = "rbxassetid://131935994917856",
                        Input = true,
                        Callback = function(p60) --[[ Name: Callback, Line 330 ]]
                            -- upvalues: u54 (copy), l__newConsoleLine__11 (copy)
                            if p60 then
                                local v61 = u54.props.selection[1];
                                if v61 and (v61:IsA("Model") and not v61:GetAttribute("PropName")) then
                                    l__newConsoleLine__11({
                                        "file",
                                        "savemodel",
                                        p60,
                                        v61:GetAttribute("World"),
                                        v61:GetAttribute("UID")
                                    });
                                end;
                            end;
                        end
                    },
                    {
                        Name = "Delete Model",
                        Size = 50,
                        Image = "rbxassetid://131935994917856",
                        Input = true,
                        Callback = function(p62) --[[ Name: Callback, Line 344 ]]
                            -- upvalues: l__newConsoleLine__11 (copy)
                            if p62 then
                                l__newConsoleLine__11({ "file", "deletemodel", p62 });
                            end;
                        end
                    }
                }
            }
        };
    elseif l__selected__7 == "Home" then
        v55 = {
            {
                Name = "Tools",
                Options = {
                    {
                        Size = 50,
                        Image = "rbxassetid://75971511342675",
                        Input = true,
                        Name = "World:\n" .. u54.props.id,
                        Callback = function(p63) --[[ Name: Callback, Line 363 ]]
                            -- upvalues: u54 (copy)
                            local v64 = tonumber(p63);
                            if v64 and v64 > 0 then
                                u54.props.changeWorld(p63);
                            end;
                        end
                    },
                    {
                        Name = "Move",
                        Size = 45,
                        Image = "rbxassetid://76451746138534",
                        Selected = u54.props.tool == 0,
                        Callback = function() --[[ Name: Callback, Line 375 ]]
                            -- upvalues: l__changeTool__8 (copy)
                            l__changeTool__8(0);
                        end
                    },
                    {
                        Name = "Scale",
                        Size = 45,
                        Image = "rbxassetid://101990079363803",
                        Selected = u54.props.tool == 1,
                        Callback = function() --[[ Name: Callback, Line 384 ]]
                            -- upvalues: l__changeTool__8 (copy)
                            l__changeTool__8(1);
                        end
                    },
                    {
                        Name = "Rotate",
                        Size = 50,
                        Image = "rbxassetid://79677445126525",
                        Selected = u54.props.tool == 2,
                        Callback = function() --[[ Name: Callback, Line 393 ]]
                            -- upvalues: l__changeTool__8 (copy)
                            l__changeTool__8(2);
                        end
                    },
                    {
                        Name = "World Space",
                        Size = 50,
                        Image = "rbxassetid://73438289028147",
                        Selected = u54.props.worldSpace,
                        Callback = function() --[[ Name: Callback, Line 402 ]]
                            -- upvalues: u54 (copy)
                            u54.props.toggleWorldSpace();
                        end
                    }
                }
            },
            {
                Name = "Snapping",
                Options = {
                    {
                        Size = 45,
                        Image = "rbxassetid://90993411119433",
                        Input = true,
                        Name = "Move:\n" .. u54.props.move,
                        Callback = function(p65) --[[ Name: Callback, Line 416 ]]
                            -- upvalues: l__changeSnap__9 (copy)
                            local v66 = tonumber(p65);
                            if v66 then
                                l__changeSnap__9("move", v66);
                            end;
                        end
                    },
                    {
                        Size = 50,
                        Image = "rbxassetid://110820709386554",
                        Input = true,
                        Name = "Rotate:\n" .. u54.props.rotate .. "°",
                        Callback = function(p67) --[[ Name: Callback, Line 428 ]]
                            -- upvalues: l__changeSnap__9 (copy)
                            local v68 = tonumber(p67);
                            if v68 then
                                l__changeSnap__9("rotate", v68);
                            end;
                        end
                    }
                }
            },
            {
                Name = "Cameras",
                Options = {
                    {
                        Name = "Topdown",
                        Size = 60,
                        Image = "rbxassetid://105369132583790",
                        Callback = function() --[[ Name: Callback, Line 444 ]]
                            -- upvalues: l__newWindow__10 (copy)
                            l__newWindow__10("Topdown");
                        end
                    },
                    {
                        Name = "Studio",
                        Size = 45,
                        Image = "rbxassetid://75522862700722",
                        Callback = function() --[[ Name: Callback, Line 452 ]]
                            -- upvalues: l__newWindow__10 (copy)
                            l__newWindow__10("Studio");
                        end
                    },
                    {
                        Name = "Cinematic",
                        Size = 65,
                        Image = "rbxassetid://78194542565587",
                        Callback = function() --[[ Name: Callback, Line 460 ]]
                            -- upvalues: l__newWindow__10 (copy)
                            l__newWindow__10("Cinematic");
                        end
                    },
                    {
                        Name = "Fullscreen",
                        Size = 70,
                        Image = "rbxassetid://118774518726738",
                        Callback = function() --[[ Name: Callback, Line 468 ]]
                            -- upvalues: u54 (copy)
                            u54.props.fullScreen();
                        end
                    }
                }
            },
            {
                Name = "Create",
                Options = {
                    {
                        Name = "Create Part",
                        Size = 50,
                        Image = "rbxassetid://78465238639586",
                        Callback = function() --[[ Name: Callback, Line 481 ]]
                            -- upvalues: u54 (copy)
                            u54.createPart("part");
                        end
                    },
                    {
                        Name = "Create Wedge",
                        Size = 55,
                        Image = "rbxassetid://85243642150273",
                        Callback = function() --[[ Name: Callback, Line 489 ]]
                            -- upvalues: u54 (copy)
                            u54.createPart("wedge");
                        end
                    },
                    {
                        Name = "Create Corner",
                        Size = 55,
                        Image = "rbxassetid://87692576929970",
                        Callback = function() --[[ Name: Callback, Line 497 ]]
                            -- upvalues: u54 (copy)
                            u54.createPart("corner");
                        end
                    },
                    {
                        Name = "Create Cylinder",
                        Size = 60,
                        Image = "rbxassetid://123825801319419",
                        Callback = function() --[[ Name: Callback, Line 505 ]]
                            -- upvalues: u54 (copy)
                            u54.createPart("cylinder");
                        end
                    },
                    {
                        Name = "Create Ball",
                        Size = 50,
                        Image = "rbxassetid://77116513799595",
                        Callback = function() --[[ Name: Callback, Line 513 ]]
                            -- upvalues: u54 (copy)
                            u54.createPart("ball");
                        end
                    },
                    {
                        Name = "Group Objects",
                        Size = 55,
                        Image = "rbxassetid://127376911211255",
                        Callback = function() --[[ Name: Callback, Line 521 ]]
                            -- upvalues: u54 (copy)
                            u54.props.createGroup(true);
                            u54.props.newSelection({});
                        end
                    },
                    {
                        Name = "Ungroup Objects",
                        Size = 55,
                        Image = "rbxassetid://92649610446336",
                        Callback = function() --[[ Name: Callback, Line 530 ]]
                            -- upvalues: u54 (copy)
                            u54.props.createGroup(false);
                            u54.props.newSelection({});
                        end
                    }
                }
            }
        };
    elseif l__selected__7 == "Weather" then
        local v69 = {};
        for v70, u71 in u9 do
            v69[v70] = {
                Name = u71[1],
                Size = u71[2],
                Image = u71[3],
                Selected = u4.WEATHER_PRESET == u71[1],
                Callback = function() --[[ Name: Callback, Line 546 ]]
                    -- upvalues: l__newConsoleLine__11 (copy), u71 (copy)
                    l__newConsoleLine__11({ "weather", "set", u71[1] });
                end
            };
        end;
        v55 = {
            {
                Name = "Time",
                Options = {
                    {
                        Size = 55,
                        Image = "rbxassetid://117779826597173",
                        Name = "Time:\n" .. (u4.TIME_ENABLED and "Enabled" or "Disabled"),
                        Selected = not u4.TIME_ENABLED,
                        Callback = function() --[[ Name: Callback, Line 561 ]]
                            -- upvalues: l__newConsoleLine__11 (copy), u4 (ref)
                            l__newConsoleLine__11({ "time", u4.TIME_ENABLED and "stop" or "start" });
                        end
                    },
                    {
                        Name = "Set\nTime",
                        Size = 45,
                        Image = "rbxassetid://124777195012991",
                        Input = true,
                        Callback = function(p72) --[[ Name: Callback, Line 570 ]]
                            -- upvalues: l__newConsoleLine__11 (copy)
                            if tonumber(p72) then
                                l__newConsoleLine__11({ "time", "set", p72 });
                            end;
                        end
                    }
                }
            },
            {
                Name = "Weather Cycle",
                Options = {
                    {
                        Size = 60,
                        Image = "rbxassetid://71320929825622",
                        Input = true,
                        Name = "Set\nLunar (" .. l__Lighting__1:GetAttribute("LunarPhase") .. ")",
                        Callback = function(p73) --[[ Name: Callback, Line 587 ]]
                            -- upvalues: l__newConsoleLine__11 (copy)
                            if tonumber(p73) then
                                l__newConsoleLine__11({ "weather", "lunar", p73 });
                            end;
                        end
                    },
                    {
                        Name = "Automatic Cycle",
                        Size = 70,
                        Image = "rbxassetid://134330800808597",
                        Selected = u4.WEATHER_PRESET == nil,
                        Callback = function() --[[ Name: Callback, Line 599 ]]
                            -- upvalues: l__newConsoleLine__11 (copy)
                            l__newConsoleLine__11({ "weather", "set" });
                        end
                    }
                }
            },
            {
                Name = "Weather Presets",
                Options = v69
            }
        };
    elseif l__selected__7 == "Gamemode" then
        v55 = {
            {
                Name = "Players",
                Options = {
                    {
                        Name = "Teleport\nSelection",
                        Size = 65,
                        Image = "rbxassetid://96378499658081",
                        Callback = function() --[[ Name: Callback, Line 619 ]]
                            -- upvalues: u54 (copy)
                            u54.teleportPlayer();
                        end
                    }
                }
            },
            {
                Name = "Squad Spawn Locations",
                Options = {
                    {
                        Name = "Set\nRed",
                        Size = 45,
                        Image = "rbxassetid://102931777556956",
                        Callback = function() --[[ Name: Callback, Line 632 ]]
                            -- upvalues: u54 (copy)
                            u54.squadSpawn("red");
                        end
                    },
                    {
                        Name = "Set\nOrange",
                        Size = 45,
                        Image = "rbxassetid://121429489453132",
                        Callback = function() --[[ Name: Callback, Line 640 ]]
                            -- upvalues: u54 (copy)
                            u54.squadSpawn("orange");
                        end
                    },
                    {
                        Name = "Set\nBlue",
                        Size = 45,
                        Image = "rbxassetid://134700140460590",
                        Callback = function() --[[ Name: Callback, Line 648 ]]
                            -- upvalues: u54 (copy)
                            u54.squadSpawn("blue");
                        end
                    },
                    {
                        Name = "Set\nYellow",
                        Size = 45,
                        Image = "rbxassetid://107004347086776",
                        Callback = function() --[[ Name: Callback, Line 656 ]]
                            -- upvalues: u54 (copy)
                            u54.squadSpawn("yellow");
                        end
                    },
                    {
                        Name = "Set\nGreen",
                        Size = 45,
                        Image = "rbxassetid://140394537114382",
                        Callback = function() --[[ Name: Callback, Line 664 ]]
                            -- upvalues: u54 (copy)
                            u54.squadSpawn("green");
                        end
                    },
                    {
                        Name = "Set\nNeutral",
                        Size = 55,
                        Image = "rbxassetid://83818918760018",
                        Callback = function() --[[ Name: Callback, Line 672 ]]
                            -- upvalues: u54 (copy)
                            u54.squadSpawn("neutral");
                        end
                    },
                    {
                        Name = "Remove Spawns",
                        Size = 50,
                        Image = "rbxassetid://119358513264727",
                        Callback = function() --[[ Name: Callback, Line 680 ]]
                            -- upvalues: l__newConsoleLine__11 (copy)
                            l__newConsoleLine__11({
                                "squadspawn",
                                ".",
                                ".",
                                ".",
                                ".",
                                "red"
                            });
                            l__newConsoleLine__11({
                                "squadspawn",
                                ".",
                                ".",
                                ".",
                                ".",
                                "orange"
                            });
                            l__newConsoleLine__11({
                                "squadspawn",
                                ".",
                                ".",
                                ".",
                                ".",
                                "blue"
                            });
                            l__newConsoleLine__11({
                                "squadspawn",
                                ".",
                                ".",
                                ".",
                                ".",
                                "yellow"
                            });
                            l__newConsoleLine__11({
                                "squadspawn",
                                ".",
                                ".",
                                ".",
                                ".",
                                "green"
                            });
                            l__newConsoleLine__11({
                                "squadspawn",
                                ".",
                                ".",
                                ".",
                                ".",
                                "neutral"
                            });
                        end
                    }
                }
            },
            {
                Name = "Game Rules",
                Options = {
                    {
                        Size = 100,
                        Image = "rbxassetid://137181471260296",
                        Name = "Squad Changing: " .. (u4.ALLOW_SQUAD_CHANGING and "Enabled" or "Disabled"),
                        Selected = not u4.ALLOW_SQUAD_CHANGING,
                        Callback = function() --[[ Name: Callback, Line 699 ]]
                            -- upvalues: l__newConsoleLine__11 (copy), u4 (ref)
                            l__newConsoleLine__11({ "squadchanging", u4.ALLOW_SQUAD_CHANGING and "disable" or "enable" });
                        end
                    },
                    {
                        Size = 80,
                        Image = "rbxassetid://129913715639010",
                        Name = "Friendly Fire: " .. (u4.FRIENDLY_FIRE == 0 and "Disabled" or (u4.FRIENDLY_FIRE == 1 and "Squad-only" or "Enabled")),
                        Callback = function() --[[ Name: Callback, Line 707 ]]
                            -- upvalues: l__newConsoleLine__11 (copy), u4 (ref)
                            l__newConsoleLine__11({ "friendlyfire", u4.FRIENDLY_FIRE == 0 and "squad" or (u4.FRIENDLY_FIRE == 1 and "all" or "disable") });
                        end
                    },
                    {
                        Size = 110,
                        Image = "rbxassetid://87472149316370",
                        Name = "Vehicle Spawning: " .. (u4.VEHICLESPAWNING_DISABLED and "Disabled" or "Enabled"),
                        Selected = u4.VEHICLESPAWNING_DISABLED,
                        Callback = function() --[[ Name: Callback, Line 716 ]]
                            -- upvalues: l__newConsoleLine__11 (copy), u4 (ref)
                            l__newConsoleLine__11({ "vehiclespawning", u4.VEHICLESPAWNING_DISABLED and "enable" or "disable" });
                        end
                    },
                    {
                        Size = 80,
                        Image = "rbxassetid://95240088483236",
                        Name = "First Person: " .. (u4.FIRST_PERSON and "Locked" or "Unlocked"),
                        Selected = u4.FIRST_PERSON,
                        Callback = function() --[[ Name: Callback, Line 725 ]]
                            -- upvalues: l__newConsoleLine__11 (copy), u4 (ref)
                            l__newConsoleLine__11({ "firstperson", u4.FIRST_PERSON and "unlock" or "lock" });
                        end
                    },
                    {
                        Size = 70,
                        Image = "rbxassetid://126516411067044",
                        Name = "Show HUD: " .. (u4.HUD_DISABLED and "Disabled" or "Enabled"),
                        Selected = u4.HUD_DISABLED,
                        Callback = function() --[[ Name: Callback, Line 734 ]]
                            -- upvalues: l__newConsoleLine__11 (copy), u4 (ref)
                            l__newConsoleLine__11({ "hud", u4.HUD_DISABLED and "enable" or "disable" });
                        end
                    },
                    {
                        Size = 120,
                        Image = "rbxassetid://85708517895306",
                        Name = "Enemy Compounds: " .. (u4.COMPOUNDS_ENABLED and "Enabled" or "Disabled"),
                        Selected = not u4.COMPOUNDS_ENABLED,
                        Callback = function() --[[ Name: Callback, Line 743 ]]
                            -- upvalues: l__newConsoleLine__11 (copy), u4 (ref)
                            l__newConsoleLine__11({ "compounds", u4.COMPOUNDS_ENABLED and "disable" or "enable" });
                        end
                    },
                    {
                        Size = 90,
                        Image = "rbxassetid://87529843188184",
                        Name = "Downs/Revive: " .. (u4.DOWNS_ENABLED and "Enabled" or "Disabled"),
                        Selected = not u4.DOWNS_ENABLED,
                        Callback = function() --[[ Name: Callback, Line 752 ]]
                            -- upvalues: l__newConsoleLine__11 (copy), u4 (ref)
                            l__newConsoleLine__11({ "revive", u4.DOWNS_ENABLED and "disable" or "enable" });
                        end
                    },
                    {
                        Size = 80,
                        Image = "rbxassetid://130348734403432",
                        Name = "Server Lock: " .. (u4.SERVERLOCK_ENABLED and "Enabled" or "Disabled"),
                        Selected = u4.SERVERLOCK_ENABLED,
                        Callback = function() --[[ Name: Callback, Line 761 ]]
                            -- upvalues: l__newConsoleLine__11 (copy), u4 (ref)
                            l__newConsoleLine__11({ "serverlock", u4.SERVERLOCK_ENABLED and "disable" or "enable" });
                        end
                    }
                }
            }
        };
    elseif l__selected__7 == "PVP" then
        v55 = {
            {
                Name = "Round Configuration",
                Options = {
                    {
                        Size = 90,
                        Image = "rbxassetid://120043932025052",
                        Input = true,
                        Name = "Round Length:\n" .. u4.ROUND_LENGTH,
                        Callback = function(p74) --[[ Name: Callback, Line 778 ]]
                            -- upvalues: l__newConsoleLine__11 (copy)
                            if tonumber(p74) then
                                l__newConsoleLine__11({ "pvp", "roundlength", p74 });
                            end;
                        end
                    },
                    {
                        Size = 90,
                        Image = "rbxassetid://99061594024383",
                        Input = true,
                        Name = "Round Count:\n" .. u4.ROUND_COUNT,
                        Callback = function(p75) --[[ Name: Callback, Line 789 ]]
                            -- upvalues: l__newConsoleLine__11 (copy)
                            if tonumber(p75) then
                                l__newConsoleLine__11({ "pvp", "roundcount", p75 });
                            end;
                        end
                    },
                    {
                        Name = "Cancel Round",
                        Size = 50,
                        Image = "rbxassetid://124699202386482",
                        Callback = function() --[[ Name: Callback, Line 799 ]]
                            -- upvalues: l__newConsoleLine__11 (copy)
                            l__newConsoleLine__11({ "pvp", "roundcancel" });
                        end
                    },
                    {
                        Name = "Cancel Match",
                        Size = 50,
                        Image = "rbxassetid://84914126643028",
                        Callback = function() --[[ Name: Callback, Line 807 ]]
                            -- upvalues: l__newConsoleLine__11 (copy)
                            l__newConsoleLine__11({ "pvp", "matchcancel" });
                        end
                    }
                }
            },
            {
                Name = "Objective",
                Options = {
                    {
                        Name = "Place Objective",
                        Size = 60,
                        Image = "rbxassetid://131916510663398",
                        Callback = function() --[[ Name: Callback, Line 820 ]]
                            -- upvalues: u3 (ref), u54 (copy), l__newConsoleLine__11 (copy)
                            local v76 = u3:Get("Shared", "Models", "Environment", "Objective").Asset:Clone();
                            for _, v77 in v76:GetDescendants() do
                                if v77:IsA("BasePart") then
                                    v77.CanCollide = false;
                                    v77.CanTouch = false;
                                    v77.CanQuery = false;
                                    v77.AudioCanCollide = false;
                                end;
                            end;
                            v76.PrimaryPart.PivotOffset = CFrame.new(0, 0.5, 0);
                            u54.props.setPlace(v76, function(p78) --[[ Line: 832 ]]
                                -- upvalues: l__newConsoleLine__11 (ref)
                                local _, v79 = p78:ToOrientation();
                                l__newConsoleLine__11({
                                    "pvp",
                                    "objective",
                                    p78.X,
                                    p78.Y - 0.5,
                                    p78.Z,
                                    (math.deg(v79))
                                });
                            end);
                        end
                    },
                    {
                        Name = "Reset Objective",
                        Size = 60,
                        Image = "rbxassetid://95638219041142",
                        Callback = function() --[[ Name: Callback, Line 842 ]]
                            -- upvalues: l__newConsoleLine__11 (copy)
                            l__newConsoleLine__11({ "pvp", "objectivereset" });
                        end
                    }
                }
            },
            {
                Name = "Spawns",
                Options = {
                    {
                        Name = "Place Attacking",
                        Size = 70,
                        Image = "rbxassetid://102931777556956",
                        Callback = function() --[[ Name: Callback, Line 855 ]]
                            -- upvalues: u54 (copy)
                            u54.pvpSpawn("attacking");
                        end
                    },
                    {
                        Name = "Place Defending",
                        Size = 70,
                        Image = "rbxassetid://134700140460590",
                        Callback = function() --[[ Name: Callback, Line 863 ]]
                            -- upvalues: u54 (copy)
                            u54.pvpSpawn("defending");
                        end
                    },
                    {
                        Name = "Reset Spawns",
                        Size = 50,
                        Image = "rbxassetid://119358513264727",
                        Callback = function() --[[ Name: Callback, Line 871 ]]
                            -- upvalues: l__newConsoleLine__11 (copy)
                            l__newConsoleLine__11({ "pvp", "spawn", "reset" });
                        end
                    }
                }
            }
        };
    elseif l__selected__7 == "AI" then
        local l__NAVMESH_COUNT__12 = u4.NAVMESH_COUNT;
        if l__NAVMESH_COUNT__12 then
            l__NAVMESH_COUNT__12 = u4.NAVMESH_COUNT >= 0;
        end;
        local l__navMeshEditor__13 = u54.props.navMeshEditor;
        local v80 = {
            {
                Size = 60,
                Image = "rbxassetid://79976777799101",
                Name = "NavMesh: " .. (l__NAVMESH_COUNT__12 and "Enabled" or "Disabled"),
                Selected = l__NAVMESH_COUNT__12,
                Callback = function() --[[ Name: Callback, Line 887 ]]
                    -- upvalues: l__NAVMESH_COUNT__12 (copy), l__newConsoleLine__11 (copy)
                    if not l__NAVMESH_COUNT__12 then
                        l__newConsoleLine__11({ "navMesh", "enable" });
                    end;
                end
            },
            {
                Size = 55,
                Image = "rbxassetid://119996442449660",
                Name = "Editor: " .. (l__navMeshEditor__13 and "Enabled" or "Disabled"),
                Selected = l__navMeshEditor__13,
                Callback = function() --[[ Name: Callback, Line 898 ]]
                    -- upvalues: l__newConsoleLine__11 (copy)
                    l__newConsoleLine__11({ "navMesh", "editor" });
                end
            }
        };
        if l__NAVMESH_COUNT__12 and l__navMeshEditor__13 then
            v80[#v80 + 1] = {
                Name = "Bake NavMesh",
                Size = 55,
                Image = "rbxassetid://112371474346947",
                Callback = function() --[[ Name: Callback, Line 909 ]]
                    -- upvalues: l__newConsoleLine__11 (copy)
                    l__newConsoleLine__11({ "navMesh", "bake" });
                end
            };
            v80[#v80 + 1] = {
                Name = "Place\nNode",
                Size = 55,
                Image = "rbxassetid://79977443763561",
                Callback = function() --[[ Name: Callback, Line 917 ]]
                    -- upvalues: u54 (copy)
                    u54.navNode();
                end
            };
            v80[#v80 + 1] = {
                Name = "Unjoin\nSelected",
                Size = 55,
                Image = "rbxassetid://73967230303508",
                Callback = function() --[[ Name: Callback, Line 925 ]]
                    -- upvalues: u54 (copy)
                    local v81 = {};
                    local v82 = {};
                    for _, v83 in u54.props.selection do
                        if v83:IsA("BasePart") and v83:GetAttribute("NodeId") then
                            v81[#v81 + 1] = v83:GetAttribute("NodeId");
                        end;
                    end;
                    for _, v84 in v81 do
                        for _, v85 in v81 do
                            if v84 ~= v85 then
                                local v86 = v84 .. "-" .. v85;
                                if not (v82[v86] or v82[v85 .. "-" .. v84]) then
                                    v82[v86] = true;
                                    u54.props.newConsoleLine({
                                        "navMesh",
                                        "unjoin",
                                        v84,
                                        v85
                                    });
                                end;
                            end;
                        end;
                    end;
                end
            };
            for u87 in u12 do
                v80[#v80 + 1] = {
                    Size = 55,
                    Name = "Cover\n" .. u87,
                    Image = u11[u87],
                    Callback = function() --[[ Name: Callback, Line 959 ]]
                        -- upvalues: u54 (copy), u87 (copy)
                        u54.coverNode(u87);
                    end
                };
            end;
        end;
        local u88 = u4["WORLD_ALARM_" .. tostring(u54.props.id)] and true or false;
        v55 = {
            {
                Name = "NavMesh",
                Options = v80
            },
            {
                Name = "State",
                Options = {
                    {
                        Name = "Alert\nWorld",
                        Size = 60,
                        Image = "rbxassetid://72178352560800",
                        Selected = u88,
                        Callback = function() --[[ Name: Callback, Line 1012 ]]
                            -- upvalues: u54 (copy), u88 (copy)
                            u54.props.newConsoleLine({
                                "bot",
                                "alert",
                                tostring(u54.props.id),
                                u88 and "false" or "true"
                            });
                        end
                    }
                }
            },
            {
                Name = "Directions",
                Options = {
                    {
                        Name = "Walk Weak",
                        Size = 50,
                        Image = "rbxassetid://136055657222757",
                        Callback = function() --[[ Name: Callback, Line 1025 ]]
                            -- upvalues: u54 (copy)
                            u54.walkTo("weak");
                        end
                    },
                    {
                        Name = "Walk Strong",
                        Size = 50,
                        Image = "rbxassetid://121067851606544",
                        Callback = function() --[[ Name: Callback, Line 1033 ]]
                            -- upvalues: u54 (copy)
                            u54.walkTo("strong");
                        end
                    },
                    {
                        Name = "Walk Direct",
                        Size = 50,
                        Image = "rbxassetid://92177275626164",
                        Callback = function() --[[ Name: Callback, Line 1041 ]]
                            -- upvalues: u54 (copy)
                            u54.walkTo("direct");
                        end
                    }
                }
            }
        };
    end;
    local v89 = { u2.createElement("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(43, 43, 43),
            Size = UDim2.new(0, 1, 0.6, 0),
            Position = UDim2.new(0, 0, 0.2, 0)
        }) };
    local v90 = 1;
    for _, v91 in v55 do
        local v92 = v90;
        local v93 = 0;
        for _, v94 in v91.Options do
            v89[#v89 + 1] = u2.createElement(u7, {
                Option = v94,
                Position = v90
            });
            v90 = v90 + v94.Size;
            v93 = v93 + v94.Size;
        end;
        v89[#v89 + 1] = u2.createElement("TextLabel", {
            BackgroundTransparency = 1,
            RichText = true,
            TextSize = 12,
            Position = UDim2.new(0, v92, 0.8, 0),
            Size = UDim2.new(0, v93, 0.2, 0),
            Text = v91.Name,
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.Ubuntu,
            TextXAlignment = Enum.TextXAlignment.Center
        });
        v89[#v89 + 1] = u2.createElement("Frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(43, 43, 43),
            Size = UDim2.new(0, 1, 0.6, 0),
            Position = UDim2.new(0, v90, 0.2, 0)
        });
        v90 = v90 + 1;
    end;
    local v95 = u2.createElement("ScrollingFrame", {
        Selectable = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 1,
        ScrollBarImageTransparency = 0,
        Size = UDim2.new(1, 0, 1, 0),
        BorderMode = Enum.BorderMode.Inset,
        ScrollBarImageColor3 = Color3.new(1, 1, 1),
        ScrollingDirection = Enum.ScrollingDirection.X,
        CanvasSize = UDim2.new(0, v90, 0, 0)
    }, v89);
    return u2.createElement("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 185, 0, 0),
        Size = UDim2.new(1, -185, 1, 0)
    }, { u2.createElement(u6, {
            top = true,
            selected = l__selected__7,
            tabs = u54.tabs,
            switch = u54.switch,
            content = v95
        }) });
end;
return v8;