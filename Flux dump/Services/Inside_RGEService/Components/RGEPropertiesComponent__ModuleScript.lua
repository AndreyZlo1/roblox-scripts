-- Services.RGEService.Components.RGEPropertiesComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4, u5 = shared.import("require", "Roact", "Enum", "server", "asset");
local l__Players__1 = game:GetService("Players");
local u6 = v1("RGEPropertiesButtonComponent");
local u7 = v1("getMainFromModel");
local u8 = v1("isTintable");
local v9 = u2.Component:extend("RGEProperties");
local l__UserId__2 = l__Players__1.LocalPlayer.UserId;
function v9.init(u10) --[[ Line: 40 ]]
    -- upvalues: u5 (copy)
    function u10.teleportPlayer(_) --[[ Line: 41 ]]
        -- upvalues: u5 (ref), u10 (copy)
        local v11 = u5:Get("Shared", "Models", "Character", "Spawner").Asset:Clone();
        for _, v12 in v11:GetChildren() do
            v12.Color = Color3.new(1, 1, 1);
        end;
        v11.Parent = workspace;
        local u13 = {};
        for _, v14 in u10.props.selection do
            if v14:IsA("Player") then
                u13[#u13 + 1] = v14.Name;
            end;
        end;
        u10.props.setPlace(v11, function(p15) --[[ Line: 55 ]]
            -- upvalues: u13 (copy), u10 (ref)
            local _, v16 = p15:ToOrientation();
            for _, v17 in u13 do
                u10.props.newConsoleLine({
                    "teleport",
                    "player",
                    v17,
                    p15.X,
                    p15.Y,
                    p15.Z,
                    (math.deg(v16))
                });
            end;
        end);
    end;
    u10._conn = u10.props.changeHistory.Changed:Connect(function() --[[ Line: 63 ]]
        -- upvalues: u10 (copy)
        u10:setState({});
    end);
end;
function v9.willUnmount(p18) --[[ Line: 68 ]]
    p18._conn:Disconnect();
end;
function v9.render(u19) --[[ Line: 72 ]]
    -- upvalues: u4 (copy), u3 (copy), u7 (copy), u8 (copy), l__UserId__2 (copy), u2 (copy), u6 (copy)
    -- block 135
    local l__newConsoleLine__3 = u19.props.newConsoleLine;
    local l__newSelection__4 = u19.props.newSelection;
    local l__selection__5 = u19.props.selection;
    local _ = u19.props.addChange;
    local v20, v21, v22;
    v20, v21, v22 = #l__selection__5 == 0 and { u19.props.window } or l__selection__5, nil, nil;
    local _ = {};
    local _ = {};
    local _ = -1;
    local _ = false;
    local v23, u24;
    if type(v20) == "function" then
        v23, u24 = v20(v21, v22);
    else
        v23, u24 = next(v20, v22);
    end;
    v22 = v23;
    while true do
        local v25 = {};
        if u24:IsA("StudioCamera") then
            v25 = {
                {
                    Name = "About",
                    Options = {
                        {
                            Name = "Name",
                            Value = u24.Name
                        }
                    }
                },
                {
                    Name = "Movement",
                    Options = {
                        {
                            Name = "Speed",
                            Value = u24.Speed,
                            Callback = function(p26) --[[ Name: Callback, Line 108 ]]
                                -- upvalues: u24 (copy)
                                local v27 = tonumber(p26);
                                if v27 and v27 > 0 then
                                    u24.Speed = v27;
                                    return v27;
                                end;
                            end
                        },
                        {
                            Name = "Zoom",
                            Value = u24.Zoom,
                            Callback = function(p28) --[[ Name: Callback, Line 119 ]]
                                -- upvalues: u24 (copy)
                                local v29 = tonumber(p28);
                                if v29 and v29 > 0 then
                                    u24.Zoom = v29;
                                    return v29;
                                end;
                            end
                        }
                    }
                }
            };
        elseif u24:IsA("TopdownCamera") then
            v25 = {
                {
                    Name = "About",
                    Options = {
                        {
                            Name = "Name",
                            Value = u24.Name
                        }
                    }
                },
                {
                    Name = "Movement",
                    Options = {
                        {
                            Name = "Speed",
                            Value = u24.Speed,
                            Callback = function(p30) --[[ Name: Callback, Line 147 ]]
                                -- upvalues: u24 (copy)
                                local v31 = tonumber(p30);
                                if v31 and v31 > 0 then
                                    u24.Speed = v31;
                                    return v31;
                                end;
                            end
                        },
                        {
                            Name = "Zoom",
                            Value = u24.Zoom,
                            Callback = function(p32) --[[ Name: Callback, Line 158 ]]
                                -- upvalues: u24 (copy)
                                local v33 = tonumber(p32);
                                if v33 and v33 > 0 then
                                    u24.Zoom = v33;
                                    return v33;
                                end;
                            end
                        }
                    }
                }
            };
        elseif u24:IsA("CinematicCamera") then
            v25 = {
                {
                    Name = "About",
                    Options = {
                        {
                            Name = "Name",
                            Value = u24.Name
                        }
                    }
                },
                {
                    Name = "Movement",
                    Options = {
                        {
                            Name = "Speed",
                            Value = u24.VelSpeed,
                            Callback = function(p34) --[[ Name: Callback, Line 186 ]]
                                -- upvalues: u24 (copy)
                                local v35 = tonumber(p34);
                                if v35 and v35 > 0 then
                                    u24.VelSpeed = v35;
                                    return v35;
                                end;
                            end
                        },
                        {
                            Name = "Pan",
                            Value = u24.PanSpeed,
                            Callback = function(p36) --[[ Name: Callback, Line 197 ]]
                                -- upvalues: u24 (copy)
                                local v37 = tonumber(p36);
                                if v37 and v37 > 0 then
                                    u24.PanSpeed = v37;
                                    return v37;
                                end;
                            end
                        },
                        {
                            Name = "Zoom",
                            Value = u24.FovSpeed,
                            Callback = function(p38) --[[ Name: Callback, Line 208 ]]
                                -- upvalues: u24 (copy)
                                local v39 = tonumber(p38);
                                if v39 and v39 > 0 then
                                    u24.FovSpeed = v39;
                                    return v39;
                                end;
                            end
                        }
                    }
                },
                {
                    Name = "Damping",
                    Options = {
                        {
                            Name = "Speed",
                            Value = u24.VelSpring.f,
                            Callback = function(p40) --[[ Name: Callback, Line 224 ]]
                                -- upvalues: u24 (copy)
                                local v41 = tonumber(p40);
                                if v41 and v41 > 0 then
                                    u24.VelSpring.f = v41;
                                    return v41;
                                end;
                            end
                        },
                        {
                            Name = "Pan",
                            Value = u24.PanSpring.f,
                            Callback = function(p42) --[[ Name: Callback, Line 235 ]]
                                -- upvalues: u24 (copy)
                                local v43 = tonumber(p42);
                                if v43 and v43 > 0 then
                                    u24.PanSpring.f = v43;
                                    return v43;
                                end;
                            end
                        },
                        {
                            Name = "Zoom",
                            Value = u24.FovSpring.f,
                            Callback = function(p44) --[[ Name: Callback, Line 246 ]]
                                -- upvalues: u24 (copy)
                                local v45 = tonumber(p44);
                                if v45 and v45 > 0 then
                                    u24.FovSpring.f = v45;
                                    return v45;
                                end;
                            end
                        }
                    }
                },
                {
                    Name = "Depth Of Field",
                    Options = {
                        {
                            Name = "Focus Distance",
                            Value = u24.DOFEffect.FocusDistance,
                            Callback = function(p46) --[[ Name: Callback, Line 262 ]]
                                -- upvalues: u24 (copy)
                                local v47 = tonumber(p46);
                                if v47 then
                                    u24.DOFEffect.FocusDistance = math.clamp(v47, 0, 200);
                                    return u24.DOFEffect.FocusDistance;
                                end;
                            end
                        },
                        {
                            Name = "In Focus Radius",
                            Value = u24.DOFEffect.InFocusRadius,
                            Callback = function(p48) --[[ Name: Callback, Line 273 ]]
                                -- upvalues: u24 (copy)
                                local v49 = tonumber(p48);
                                if v49 then
                                    u24.DOFEffect.InFocusRadius = math.clamp(v49, 0, 50);
                                    return u24.DOFEffect.InFocusRadius;
                                end;
                            end
                        },
                        {
                            Name = "Far Intensity",
                            Value = u24.DOFEffect.FarIntensity,
                            Callback = function(p50) --[[ Name: Callback, Line 284 ]]
                                -- upvalues: u24 (copy)
                                local v51 = tonumber(p50);
                                if v51 then
                                    u24.DOFEffect.FarIntensity = math.clamp(v51, 0, 1);
                                    return u24.DOFEffect.FarIntensity;
                                end;
                            end
                        },
                        {
                            Name = "Near Intensity",
                            Value = u24.DOFEffect.NearIntensity,
                            Callback = function(p52) --[[ Name: Callback, Line 295 ]]
                                -- upvalues: u24 (copy)
                                local v53 = tonumber(p52);
                                if v53 then
                                    u24.DOFEffect.NearIntensity = math.clamp(v53, 0, 1);
                                    return u24.DOFEffect.NearIntensity;
                                end;
                            end
                        }
                    }
                },
                {
                    Name = "Color Correction",
                    Options = {
                        {
                            Name = "Saturation",
                            Value = u24.CCEffect.Saturation,
                            Callback = function(p54) --[[ Name: Callback, Line 311 ]]
                                -- upvalues: u24 (copy)
                                local v55 = tonumber(p54);
                                if v55 then
                                    u24.CCEffect.Saturation = math.clamp(v55, -1, 1);
                                    return u24.CCEffect.Saturation;
                                end;
                            end
                        },
                        {
                            Name = "Contrast",
                            Value = u24.CCEffect.Contrast,
                            Callback = function(p56) --[[ Name: Callback, Line 322 ]]
                                -- upvalues: u24 (copy)
                                local v57 = tonumber(p56);
                                if v57 then
                                    u24.CCEffect.Contrast = math.clamp(v57, -1, 1);
                                    return u24.CCEffect.Contrast;
                                end;
                            end
                        },
                        {
                            Name = "Brightness",
                            Value = u24.CCEffect.Brightness,
                            Callback = function(p58) --[[ Name: Callback, Line 333 ]]
                                -- upvalues: u24 (copy)
                                local v59 = tonumber(p58);
                                if v59 then
                                    u24.CCEffect.Brightness = math.clamp(v59, -1, 1);
                                    return u24.CCEffect.Brightness;
                                end;
                            end
                        }
                    }
                },
                {
                    Name = "Origin",
                    Options = {
                        {
                            Name = "Set",
                            Callback = function() --[[ Name: Callback, Line 348 ]]
                                -- upvalues: u24 (copy)
                                u24:SetOrigin();
                            end
                        },
                        {
                            Name = "Jump",
                            Callback = function() --[[ Name: Callback, Line 354 ]]
                                -- upvalues: u24 (copy)
                                u24:GoOrigin();
                            end
                        }
                    }
                },
                {
                    Name = "Actions",
                    Options = {
                        {
                            Name = "Lock",
                            Callback = function() --[[ Name: Callback, Line 365 ]]
                                -- upvalues: u24 (copy)
                                u24:Lock();
                            end
                        },
                        {
                            Name = "Attach",
                            Callback = function() --[[ Name: Callback, Line 371 ]]
                                -- upvalues: u24 (copy)
                                u24:Attach();
                            end
                        }
                    }
                }
            };
        elseif u24:IsA("Player") then
            v25 = {
                {
                    Name = "About",
                    Options = {
                        {
                            Name = "Name",
                            Value = u24.Name
                        }
                    }
                },
                {
                    Name = "Squads",
                    Options = {
                        {
                            Name = "None",
                            Callback = function() --[[ Name: Callback, Line 398 ]]
                                -- upvalues: l__newConsoleLine__3 (copy), u24 (copy)
                                l__newConsoleLine__3({ "squad", u24.Name, "none" });
                            end
                        },
                        {
                            Name = "Red",
                            Callback = function() --[[ Name: Callback, Line 404 ]]
                                -- upvalues: l__newConsoleLine__3 (copy), u24 (copy)
                                l__newConsoleLine__3({ "squad", u24.Name, "red" });
                            end
                        },
                        {
                            Name = "Blue",
                            Callback = function() --[[ Name: Callback, Line 410 ]]
                                -- upvalues: l__newConsoleLine__3 (copy), u24 (copy)
                                l__newConsoleLine__3({ "squad", u24.Name, "blue" });
                            end
                        },
                        {
                            Name = "Yellow",
                            Callback = function() --[[ Name: Callback, Line 416 ]]
                                -- upvalues: l__newConsoleLine__3 (copy), u24 (copy)
                                l__newConsoleLine__3({ "squad", u24.Name, "yellow" });
                            end
                        },
                        {
                            Name = "Orange",
                            Callback = function() --[[ Name: Callback, Line 422 ]]
                                -- upvalues: l__newConsoleLine__3 (copy), u24 (copy)
                                l__newConsoleLine__3({ "squad", u24.Name, "orange" });
                            end
                        },
                        {
                            Name = "Green",
                            Callback = function() --[[ Name: Callback, Line 428 ]]
                                -- upvalues: l__newConsoleLine__3 (copy), u24 (copy)
                                l__newConsoleLine__3({ "squad", u24.Name, "green" });
                            end
                        }
                    }
                },
                {
                    Name = "Actions",
                    Options = {
                        {
                            Name = "Teleport",
                            Callback = function() --[[ Name: Callback, Line 439 ]]
                                -- upvalues: u19 (copy), u24 (copy)
                                u19.teleportPlayer(u24.Name);
                            end
                        },
                        {
                            Name = "Respawn",
                            Callback = function() --[[ Name: Callback, Line 445 ]]
                                -- upvalues: l__newConsoleLine__3 (copy), u24 (copy)
                                l__newConsoleLine__3({ "respawn", "player", u24.Name });
                            end
                        }
                    }
                },
                {
                    Name = "Moderation",
                    Options = {
                        {
                            Name = "Kick",
                            Callback = function() --[[ Name: Callback, Line 456 ]]
                                -- upvalues: l__newConsoleLine__3 (copy), u24 (copy)
                                l__newConsoleLine__3({ "kick", u24.Name });
                            end
                        },
                        {
                            Name = "Ban",
                            Callback = function() --[[ Name: Callback, Line 462 ]]
                                -- upvalues: l__newConsoleLine__3 (copy), u24 (copy)
                                l__newConsoleLine__3({ "ban", u24.Name });
                            end
                        }
                    }
                }
            };
        elseif u24:IsA("BasePart") then
            if u24:GetAttribute("NodeId") then
                v25 = {};
                local v60 = {
                    Name = "About",
                    Options = {
                        {
                            Name = "NodeId",
                            Value = u24:GetAttribute("NodeId")
                        }
                    }
                };
                local v61 = {
                    Name = "Transform"
                };
                local v62 = {};
                local v63 = {
                    Name = "Position"
                };
                local l__Position__6 = u24.Position;
                v63.Value = string.format("%.3f, %.3f, %.3f", l__Position__6.X, l__Position__6.Y, l__Position__6.Z);
                function v63.Callback(p64) --[[ Line: 488 ]]
                    -- upvalues: u24 (copy), l__newConsoleLine__3 (copy)
                    local v65 = string.split(p64, ",");
                    if v65 then
                        local u66 = tonumber(v65[1]);
                        local u67 = tonumber(v65[2]);
                        local u68 = tonumber(v65[3]);
                        if u66 and (u67 and u68) then
                            local u69 = u24:GetAttribute("NodeId");
                            return function() --[[ Line: 500 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u69 (copy), u66 (copy), u67 (copy), u68 (copy)
                                l__newConsoleLine__3({
                                    "navmesh",
                                    "move",
                                    u69,
                                    u66,
                                    u67,
                                    u68
                                });
                            end, function() --[[ Line: 502 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u69 (copy)
                                l__newConsoleLine__3({
                                    "navmesh",
                                    "move",
                                    u69,
                                    oldPosition.X,
                                    oldPosition.Y,
                                    oldPosition.Z
                                });
                            end;
                        end;
                    end;
                end;
                v62[1] = v63;
                v61.Options = v62;
                v25[1], v25[2], v25[3] = v60, v61, {
    Name = "Actions",
    Options = {
        {
            Name = "Delete",
            Callback = function() --[[ Name: Callback, Line 515 ]]
                -- upvalues: l__newConsoleLine__3 (copy), u24 (copy), l__newSelection__4 (copy)
                l__newConsoleLine__3({ "navmesh", "delete", u24:GetAttribute("NodeId") });
                l__newSelection__4({});
            end
        }
    }
};
            else
                local v70 = tonumber(u24.CollisionGroup) or 0;
                local u71 = u24:HasTag("Trigger");
                local v72;
                if u71 then
                    local v73 = {};
                    local v74 = u4["TRIGGER_GROUP_" .. u24:GetAttribute("World")];
                    if v74 then
                        u24:GetAttribute("Trigger");
                        for _, v75 in v74 do
                            local u76 = v75[1];
                            local u77 = u24:GetAttribute("Trigger_" .. u76);
                            v73[#v73 + 1] = {
                                Name = u76,
                                Value = u77 and true or false,
                                Callback = function() --[[ Name: Callback, Line 539 ]]
                                    -- upvalues: u24 (copy), u77 (copy), l__newConsoleLine__3 (copy), u76 (copy)
                                    local v78 = u24:GetAttribute("World");
                                    local v79 = u24:GetAttribute("UID");
                                    if u77 then
                                        l__newConsoleLine__3({
                                            "trigger",
                                            "set",
                                            v78,
                                            v79,
                                            u76,
                                            "false"
                                        });
                                    else
                                        l__newConsoleLine__3({
                                            "trigger",
                                            "set",
                                            v78,
                                            v79,
                                            u76,
                                            "true"
                                        });
                                    end;
                                end
                            };
                        end;
                    end;
                    v72 = {
                        Name = "Trigger",
                        Options = v73
                    };
                else
                    v72 = {
                        Name = "Collision"
                    };
                    local v80 = {};
                    local v81 = {
                        Name = "Characters"
                    };
                    local v82;
                    if v70 == u3.PhysicsGroup.CharacterCast then
                        v82 = false;
                    else
                        v82 = v70 ~= u3.PhysicsGroup.RGESelectable;
                    end;
                    v81.Value = v82;
                    function v81.Callback() --[[ Line: 564 ]]
                        -- upvalues: u24 (copy), u3 (ref), l__newConsoleLine__3 (copy)
                        local v83 = u24:GetAttribute("World");
                        local v84 = u24:GetAttribute("UID");
                        local v85 = tonumber(u24.CollisionGroup);
                        if v85 == u3.PhysicsGroup.RGESelectable then
                            l__newConsoleLine__3({
                                "collision",
                                v83,
                                v84,
                                2
                            });
                        elseif v85 == u3.PhysicsGroup.BulletCast then
                            l__newConsoleLine__3({
                                "collision",
                                v83,
                                v84,
                                3
                            });
                        elseif v85 == u3.PhysicsGroup.CharacterCast then
                            l__newConsoleLine__3({
                                "collision",
                                v83,
                                v84,
                                0
                            });
                        else
                            l__newConsoleLine__3({
                                "collision",
                                v83,
                                v84,
                                1
                            });
                        end;
                    end;
                    local v86 = {
                        Name = "Bullets"
                    };
                    local v87;
                    if v70 == u3.PhysicsGroup.BulletCast then
                        v87 = false;
                    else
                        v87 = v70 ~= u3.PhysicsGroup.RGESelectable;
                    end;
                    v86.Value = v87;
                    function v86.Callback() --[[ Line: 583 ]]
                        -- upvalues: u24 (copy), u3 (ref), l__newConsoleLine__3 (copy)
                        local v88 = u24:GetAttribute("World");
                        local v89 = u24:GetAttribute("UID");
                        local v90 = tonumber(u24.CollisionGroup);
                        if v90 == u3.PhysicsGroup.RGESelectable then
                            l__newConsoleLine__3({
                                "collision",
                                v88,
                                v89,
                                1
                            });
                        elseif v90 == u3.PhysicsGroup.BulletCast then
                            l__newConsoleLine__3({
                                "collision",
                                v88,
                                v89,
                                0
                            });
                        elseif v90 == u3.PhysicsGroup.CharacterCast then
                            l__newConsoleLine__3({
                                "collision",
                                v88,
                                v89,
                                3
                            });
                        else
                            l__newConsoleLine__3({
                                "collision",
                                v88,
                                v89,
                                2
                            });
                        end;
                    end;
                    v80[1], v80[2] = v81, v86;
                    v72.Options = v80;
                end;
                local v110 = {
                    {
                        Name = "World",
                        Value = u24:GetAttribute("World")
                    },
                    {
                        Name = "UID",
                        Value = u24:GetAttribute("UID")
                    },
                    {
                        Name = "Name",
                        Value = u24.Name,
                        Callback = function(u91) --[[ Name: Callback, Line 615 ]]
                            -- upvalues: u24 (copy), l__newConsoleLine__3 (copy)
                            local u92 = u24:GetAttribute("World");
                            local u93 = u24:GetAttribute("UID");
                            local l__Name__7 = u24.Name;
                            return function() --[[ Line: 620 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u92 (copy), u93 (copy), u91 (copy)
                                l__newConsoleLine__3({
                                    "rename",
                                    u92,
                                    u93,
                                    u91
                                });
                            end, function() --[[ Line: 622 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u92 (copy), u93 (copy), l__Name__7 (copy)
                                l__newConsoleLine__3({
                                    "rename",
                                    u92,
                                    u93,
                                    l__Name__7
                                });
                            end;
                        end
                    },
                    {
                        Name = "Transparency",
                        Value = string.format("%.3f", u24.Transparency),
                        Callback = function(u94) --[[ Name: Callback, Line 630 ]]
                            -- upvalues: u24 (copy), l__newConsoleLine__3 (copy)
                            local u95 = u24:GetAttribute("World");
                            local u96 = u24:GetAttribute("UID");
                            local l__Transparency__8 = u24.Transparency;
                            return function() --[[ Line: 635 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u95 (copy), u96 (copy), u94 (copy)
                                l__newConsoleLine__3({
                                    "transparency",
                                    u95,
                                    u96,
                                    u94
                                });
                            end, function() --[[ Line: 637 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u95 (copy), u96 (copy), l__Transparency__8 (copy)
                                l__newConsoleLine__3({
                                    "transparency",
                                    u95,
                                    u96,
                                    (tostring(l__Transparency__8))
                                });
                            end;
                        end
                    },
                    {
                        Name = "Material",
                        Value = #u24.MaterialVariant > 0 and "BRM5/" .. u24.MaterialVariant or "RBLX/" .. u24.Material.Name,
                        Callback = function(u97) --[[ Name: Callback, Line 645 ]]
                            -- upvalues: u24 (copy), l__newConsoleLine__3 (copy)
                            local u98 = u24:GetAttribute("World");
                            local u99 = u24:GetAttribute("UID");
                            local u100 = #u24.MaterialVariant > 0 and "BRM5/" .. u24.MaterialVariant or "RBLX/" .. u24.Material.Name;
                            return function() --[[ Line: 650 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u98 (copy), u99 (copy), u97 (copy)
                                l__newConsoleLine__3({
                                    "material",
                                    u98,
                                    u99,
                                    u97
                                });
                            end, function() --[[ Line: 652 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u98 (copy), u99 (copy), u100 (copy)
                                l__newConsoleLine__3({
                                    "material",
                                    u98,
                                    u99,
                                    u100
                                });
                            end;
                        end
                    },
                    {
                        Name = "Color",
                        Value = math.floor(u24.Color.R * 255) .. ", " .. math.floor(u24.Color.G * 255) .. ", " .. math.floor(u24.Color.B * 255),
                        Callback = function(p101) --[[ Name: Callback, Line 660 ]]
                            -- upvalues: u24 (copy), l__newConsoleLine__3 (copy)
                            local v102 = string.split(p101, ",");
                            if v102 then
                                local u103 = tonumber(v102[1]);
                                local u104 = tonumber(v102[2]);
                                local u105 = tonumber(v102[3]);
                                if u103 and (u104 and u105) then
                                    local u106 = u24:GetAttribute("World");
                                    local u107 = u24:GetAttribute("UID");
                                    local l__Color__9 = u24.Color;
                                    return function() --[[ Line: 674 ]]
                                        -- upvalues: l__newConsoleLine__3 (ref), u106 (copy), u107 (copy), u103 (copy), u104 (copy), u105 (copy)
                                        l__newConsoleLine__3({
                                            "color",
                                            u106,
                                            u107,
                                            u103,
                                            u104,
                                            u105
                                        });
                                    end, function() --[[ Line: 676 ]]
                                        -- upvalues: l__newConsoleLine__3 (ref), u106 (copy), u107 (copy), l__Color__9 (copy)
                                        l__newConsoleLine__3({
                                            "color",
                                            u106,
                                            u107,
                                            l__Color__9.R * 255,
                                            l__Color__9.G * 255,
                                            l__Color__9.B * 255
                                        });
                                    end;
                                end;
                            end;
                        end
                    },
                    {
                        Name = "IsTrigger",
                        Value = u71,
                        Callback = function() --[[ Name: Callback, Line 685 ]]
                            -- upvalues: u24 (copy), l__newConsoleLine__3 (copy), u71 (copy)
                            local u108 = u24:GetAttribute("World");
                            local u109 = u24:GetAttribute("UID");
                            return function() --[[ Line: 689 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u71 (ref), u108 (copy), u109 (copy)
                                l__newConsoleLine__3({
                                    "trigger",
                                    u71 and "remove" or "add",
                                    u108,
                                    u109
                                });
                            end, function() --[[ Line: 691 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u71 (ref), u108 (copy), u109 (copy)
                                l__newConsoleLine__3({
                                    "trigger",
                                    u71 and "add" or "remove",
                                    u108,
                                    u109
                                });
                            end;
                        end
                    }
                };
                if u71 then
                    local u111 = u24:HasTag("Prefab");
                    if u111 then
                        u111 = u24:GetAttribute("Prefab") == "TriggerButton";
                    end;
                    v110[#v110 + 1] = {
                        Name = "IsButton",
                        Value = u111,
                        Callback = function() --[[ Name: Callback, Line 703 ]]
                            -- upvalues: u24 (copy), l__newConsoleLine__3 (copy), u111 (copy)
                            local u112 = u24:GetAttribute("World");
                            local u113 = u24:GetAttribute("UID");
                            return function() --[[ Line: 707 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u111 (ref), u112 (copy), u113 (copy)
                                l__newConsoleLine__3({
                                    "trigger",
                                    u111 and "removebutton" or "addbutton",
                                    u112,
                                    u113
                                });
                            end, function() --[[ Line: 709 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u111 (ref), u112 (copy), u113 (copy)
                                l__newConsoleLine__3({
                                    "trigger",
                                    u111 and "addbutton" or "removebutton",
                                    u112,
                                    u113
                                });
                            end;
                        end
                    };
                end;
                v25 = {};
                local v114 = {
                    Name = "Transform"
                };
                local v115 = {};
                local v116 = {
                    Name = "Size"
                };
                local l__Size__10 = u24.Size;
                v116.Value = string.format("%.3f, %.3f, %.3f", l__Size__10.X, l__Size__10.Y, l__Size__10.Z);
                function v116.Callback(p117) --[[ Line: 727 ]]
                    -- upvalues: u24 (copy), l__newConsoleLine__3 (copy)
                    local v118 = string.split(p117, ",");
                    if v118 then
                        local u119 = tonumber(v118[1]);
                        local u120 = tonumber(v118[2]);
                        local u121 = tonumber(v118[3]);
                        if u119 and (u120 and u121) then
                            local u122 = u24:GetAttribute("World");
                            local u123 = u24:GetAttribute("UID");
                            local l__Size__11 = u24.Size;
                            return function() --[[ Line: 741 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u122 (copy), u123 (copy), u119 (copy), u120 (copy), u121 (copy)
                                l__newConsoleLine__3({
                                    "size",
                                    u122,
                                    u123,
                                    u119,
                                    u120,
                                    u121
                                });
                            end, function() --[[ Line: 743 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u122 (copy), u123 (copy), l__Size__11 (copy)
                                l__newConsoleLine__3({
                                    "size",
                                    u122,
                                    u123,
                                    l__Size__11.X,
                                    l__Size__11.Y,
                                    l__Size__11.Z
                                });
                            end;
                        end;
                    end;
                end;
                local v124 = {
                    Name = "Position"
                };
                local l__Position__12 = u24.Position;
                v124.Value = string.format("%.3f, %.3f, %.3f", l__Position__12.X, l__Position__12.Y, l__Position__12.Z);
                function v124.Callback(p125) --[[ Line: 752 ]]
                    -- upvalues: u24 (copy), l__newConsoleLine__3 (copy)
                    local v126 = string.split(p125, ",");
                    if v126 then
                        local u127 = tonumber(v126[1]);
                        local u128 = tonumber(v126[2]);
                        local u129 = tonumber(v126[3]);
                        if u127 and (u128 and u129) then
                            local u130 = u24:GetAttribute("World");
                            local u131 = u24:GetAttribute("UID");
                            local l__Position__13 = u24.Position;
                            local u132, u133, u134 = u24.CFrame:ToOrientation();
                            return function() --[[ Line: 768 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u130 (copy), u131 (copy), u127 (copy), u128 (copy), u129 (copy), u132 (copy), u133 (copy), u134 (copy)
                                l__newConsoleLine__3({
                                    "move",
                                    u130,
                                    u131,
                                    u127,
                                    u128,
                                    u129,
                                    math.deg(u132),
                                    math.deg(u133),
                                    (math.deg(u134))
                                });
                            end, function() --[[ Line: 770 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u130 (copy), u131 (copy), l__Position__13 (copy), u132 (copy), u133 (copy), u134 (copy)
                                l__newConsoleLine__3({
                                    "move",
                                    u130,
                                    u131,
                                    l__Position__13.X,
                                    l__Position__13.Y,
                                    l__Position__13.Z,
                                    math.deg(u132),
                                    math.deg(u133),
                                    (math.deg(u134))
                                });
                            end;
                        end;
                    end;
                end;
                local v135 = {
                    Name = "Orientation"
                };
                local v136, v137, v138 = u24.CFrame:ToOrientation();
                v135.Value = string.format("%.3f, %.3f, %.3f", math.deg(v136), math.deg(v137), (math.deg(v138)));
                function v135.Callback(p139) --[[ Line: 779 ]]
                    -- upvalues: u24 (copy), l__newConsoleLine__3 (copy)
                    local v140 = string.split(p139, ",");
                    if v140 then
                        local u141 = tonumber(v140[1]);
                        local u142 = tonumber(v140[2]);
                        local u143 = tonumber(v140[3]);
                        if u141 and (u142 and u143) then
                            local u144 = u24:GetAttribute("World");
                            local u145 = u24:GetAttribute("UID");
                            local u146, u147, u148 = u24.CFrame:ToOrientation();
                            local l__Position__14 = u24.CFrame.Position;
                            return function() --[[ Line: 795 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u144 (copy), u145 (copy), l__Position__14 (copy), u141 (copy), u142 (copy), u143 (copy)
                                l__newConsoleLine__3({
                                    "move",
                                    u144,
                                    u145,
                                    l__Position__14.X,
                                    l__Position__14.Y,
                                    l__Position__14.Z,
                                    u141,
                                    u142,
                                    u143
                                });
                            end, function() --[[ Line: 797 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u144 (copy), u145 (copy), l__Position__14 (copy), u146 (copy), u147 (copy), u148 (copy)
                                l__newConsoleLine__3({
                                    "move",
                                    u144,
                                    u145,
                                    l__Position__14.X,
                                    l__Position__14.Y,
                                    l__Position__14.Z,
                                    u146,
                                    u147,
                                    u148
                                });
                            end;
                        end;
                    end;
                end;
                v115[1], v115[2], v115[3] = v116, v124, v135;
                v114.Options = v115;
                v25[1], v25[2], v25[3], v25[4] = {
    Name = "About",
    Options = v110
}, v114, v72, {
    Name = "Actions",
    Options = {
        {
            Name = "Delete",
            Callback = function() --[[ Name: Callback, Line 811 ]]
                -- upvalues: l__newConsoleLine__3 (copy), u24 (copy), l__newSelection__4 (copy)
                l__newConsoleLine__3({ "delete", u24:GetAttribute("World"), u24:GetAttribute("UID") });
                l__newSelection__4({});
            end
        }
    }
};
            end;
        elseif u24:IsA("Model") then
            if u24:GetAttribute("CoverId") then
                v25 = {};
                local v149 = {
                    Name = "About",
                    Options = {
                        {
                            Name = "CoverId",
                            Value = u24:GetAttribute("CoverId")
                        },
                        {
                            Name = "CoverType",
                            Value = u24.Name
                        }
                    }
                };
                local v150 = {
                    Name = "Transform"
                };
                local v151 = {};
                local v152 = {
                    Name = "Position"
                };
                local l__Position__15 = u24:GetBoundingBox().Position;
                v152.Value = string.format("%.3f, %.3f, %.3f", l__Position__15.X, l__Position__15.Y, l__Position__15.Z);
                function v152.Callback(p153) --[[ Line: 842 ]]
                    -- upvalues: u24 (copy), l__newConsoleLine__3 (copy)
                    local v154 = string.split(p153, ",");
                    if v154 then
                        local u155 = tonumber(v154[1]);
                        local u156 = tonumber(v154[2]);
                        local u157 = tonumber(v154[3]);
                        if u155 and (u156 and u157) then
                            local u158 = u24:GetAttribute("CoverId");
                            local l__Position__16 = u24.PrimaryPart.Position;
                            local _, u159, _ = u24.PrimaryPart.CFrame:ToOrientation();
                            return function() --[[ Line: 856 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u158 (copy), u155 (copy), u156 (copy), u157 (copy), u159 (copy)
                                l__newConsoleLine__3({
                                    "navmesh",
                                    "move",
                                    u158,
                                    u155,
                                    u156,
                                    u157,
                                    (math.deg(u159))
                                });
                            end, function() --[[ Line: 858 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u158 (copy), l__Position__16 (copy), u159 (copy)
                                l__newConsoleLine__3({
                                    "navmesh",
                                    "move",
                                    u158,
                                    l__Position__16.X,
                                    l__Position__16.Y,
                                    l__Position__16.Z,
                                    (math.deg(u159))
                                });
                            end;
                        end;
                    end;
                end;
                local v160 = {
                    Name = "Orientation"
                };
                local v161, v162, v163 = u24:GetBoundingBox():ToOrientation();
                v160.Value = string.format("%.3f, %.3f, %.3f", math.deg(v161), math.deg(v162), (math.deg(v163)));
                function v160.Callback(p164) --[[ Line: 867 ]]
                    -- upvalues: u24 (copy), l__newConsoleLine__3 (copy)
                    local v165 = string.split(p164, ",");
                    if v165 then
                        local v166 = tonumber(v165[1]);
                        local u167 = tonumber(v165[2]);
                        if v166 and (u167 and tonumber(v165[3])) then
                            local u168 = u24:GetAttribute("CoverId");
                            local _, u169, _ = u24.PrimaryPart.CFrame:ToOrientation();
                            local l__Position__17 = u24.PrimaryPart.Position;
                            return function() --[[ Line: 881 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u168 (copy), l__Position__17 (copy), u167 (copy)
                                l__newConsoleLine__3({
                                    "navmesh",
                                    "move",
                                    u168,
                                    l__Position__17.X,
                                    l__Position__17.Y,
                                    l__Position__17.Z,
                                    u167
                                });
                            end, function() --[[ Line: 883 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u168 (copy), l__Position__17 (copy), u169 (copy)
                                l__newConsoleLine__3({
                                    "navmesh",
                                    "move",
                                    u168,
                                    l__Position__17.X,
                                    l__Position__17.Y,
                                    l__Position__17.Z,
                                    u169
                                });
                            end;
                        end;
                    end;
                end;
                v151[1], v151[2] = v152, v160;
                v150.Options = v151;
                v25[1], v25[2], v25[3] = v149, v150, {
    Name = "Actions",
    Options = {
        {
            Name = "Delete",
            Callback = function() --[[ Name: Callback, Line 896 ]]
                -- upvalues: l__newConsoleLine__3 (copy), u24 (copy), l__newSelection__4 (copy)
                l__newConsoleLine__3({ "navmesh", "delete", u24:GetAttribute("CoverId") });
                l__newSelection__4({});
            end
        }
    }
};
            else
                local u170 = u24:GetBoundingBox();
                if u24:GetAttribute("PropName") then
                    local v171 = u7(u24);
                    if v171 then
                        u170 = v171.CFrame;
                    end;
                end;
                local v172 = {};
                local v173 = {
                    Name = "Position"
                };
                local l__Position__18 = u170.Position;
                v173.Value = string.format("%.3f, %.3f, %.3f", l__Position__18.X, l__Position__18.Y, l__Position__18.Z);
                function v173.Callback(p174) --[[ Line: 917 ]]
                    -- upvalues: u24 (copy), u170 (ref), l__newConsoleLine__3 (copy)
                    local v175 = string.split(p174, ",");
                    if v175 then
                        local u176 = tonumber(v175[1]);
                        local u177 = tonumber(v175[2]);
                        local u178 = tonumber(v175[3]);
                        if u176 and (u177 and u178) then
                            local u179 = u24:GetAttribute("World");
                            local u180 = u24:GetAttribute("UID");
                            local l__Position__19 = u170.Position;
                            local u181, u182, u183 = u170:ToOrientation();
                            return function() --[[ Line: 933 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u179 (copy), u180 (copy), u176 (copy), u177 (copy), u178 (copy), u181 (copy), u182 (copy), u183 (copy)
                                l__newConsoleLine__3({
                                    "move",
                                    u179,
                                    u180,
                                    u176,
                                    u177,
                                    u178,
                                    math.deg(u181),
                                    math.deg(u182),
                                    (math.deg(u183))
                                });
                            end, function() --[[ Line: 935 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u179 (copy), u180 (copy), l__Position__19 (copy), u181 (copy), u182 (copy), u183 (copy)
                                l__newConsoleLine__3({
                                    "move",
                                    u179,
                                    u180,
                                    l__Position__19.X,
                                    l__Position__19.Y,
                                    l__Position__19.Z,
                                    math.deg(u181),
                                    math.deg(u182),
                                    (math.deg(u183))
                                });
                            end;
                        end;
                    end;
                end;
                local v184 = {
                    Name = "Orientation"
                };
                local v185, v186, v187 = u170:ToOrientation();
                v184.Value = string.format("%.3f, %.3f, %.3f", math.deg(v185), math.deg(v186), (math.deg(v187)));
                function v184.Callback(p188) --[[ Line: 944 ]]
                    -- upvalues: u24 (copy), u170 (ref), l__newConsoleLine__3 (copy)
                    local v189 = string.split(p188, ",");
                    if v189 then
                        local u190 = tonumber(v189[1]);
                        local u191 = tonumber(v189[2]);
                        local u192 = tonumber(v189[3]);
                        if u190 and (u191 and u192) then
                            local u193 = u24:GetAttribute("World");
                            local u194 = u24:GetAttribute("UID");
                            local u195, u196, u197 = u170:ToOrientation();
                            local l__Position__20 = u170.Position;
                            return function() --[[ Line: 960 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u193 (copy), u194 (copy), l__Position__20 (copy), u190 (copy), u191 (copy), u192 (copy)
                                l__newConsoleLine__3({
                                    "move",
                                    u193,
                                    u194,
                                    l__Position__20.X,
                                    l__Position__20.Y,
                                    l__Position__20.Z,
                                    u190,
                                    u191,
                                    u192
                                });
                            end, function() --[[ Line: 962 ]]
                                -- upvalues: l__newConsoleLine__3 (ref), u193 (copy), u194 (copy), l__Position__20 (copy), u195 (copy), u196 (copy), u197 (copy)
                                l__newConsoleLine__3({
                                    "move",
                                    u193,
                                    u194,
                                    l__Position__20.X,
                                    l__Position__20.Y,
                                    l__Position__20.Z,
                                    u195,
                                    u196,
                                    u197
                                });
                            end;
                        end;
                    end;
                end;
                v172[1], v172[2] = v173, v184;
                if u24:GetAttribute("PropName") then
                    local v198 = u24:GetChildren();
                    if #v198 == 1 then
                        local u199 = v198[1];
                        local v200 = {
                            Name = "Size"
                        };
                        local l__Size__21 = u199.Size;
                        v200.Value = string.format("%.3f, %.3f, %.3f", l__Size__21.X, l__Size__21.Y, l__Size__21.Z);
                        function v200.Callback(p201) --[[ Line: 977 ]]
                            -- upvalues: u24 (copy), u199 (copy), l__newConsoleLine__3 (copy)
                            local v202 = string.split(p201, ",");
                            if v202 then
                                local u203 = tonumber(v202[1]);
                                local u204 = tonumber(v202[2]);
                                local u205 = tonumber(v202[3]);
                                if u203 and (u204 and u205) then
                                    local u206 = u24:GetAttribute("World");
                                    local u207 = u24:GetAttribute("UID");
                                    local l__Size__22 = u199.Size;
                                    return function() --[[ Line: 991 ]]
                                        -- upvalues: l__newConsoleLine__3 (ref), u206 (copy), u207 (copy), u203 (copy), u204 (copy), u205 (copy)
                                        l__newConsoleLine__3({
                                            "size",
                                            u206,
                                            u207,
                                            u203,
                                            u204,
                                            u205
                                        });
                                    end, function() --[[ Line: 993 ]]
                                        -- upvalues: l__newConsoleLine__3 (ref), u206 (copy), u207 (copy), l__Size__22 (copy)
                                        l__newConsoleLine__3({
                                            "size",
                                            u206,
                                            u207,
                                            l__Size__22.X,
                                            l__Size__22.Y,
                                            l__Size__22.Z
                                        });
                                    end;
                                end;
                            end;
                        end;
                        table.insert(v172, 2, v200);
                    end;
                end;
                local v208 = {
                    {
                        Name = "World",
                        Value = u24:GetAttribute("World")
                    },
                    {
                        Name = "UID",
                        Value = u24:GetAttribute("UID")
                    }
                };
                local v209 = u24:GetAttribute("PropName");
                if v209 then
                    v208[#v208 + 1] = {
                        Name = "PropName",
                        Value = v209
                    };
                end;
                v208[#v208 + 1] = {
                    Name = "Name",
                    Value = u24.Name,
                    Callback = function(p210) --[[ Name: Callback, Line 1024 ]]
                        -- upvalues: l__newConsoleLine__3 (copy), u24 (copy)
                        l__newConsoleLine__3({
                            "rename",
                            u24:GetAttribute("World"),
                            u24:GetAttribute("UID"),
                            p210
                        });
                    end
                };
                local u211 = u8(u24);
                if v209 and u211 then
                    v208[#v208 + 1] = {
                        Name = "Color",
                        Value = math.floor(u211.Color.R * 255) .. ", " .. math.floor(u211.Color.G * 255) .. ", " .. math.floor(u211.Color.B * 255),
                        Callback = function(p212) --[[ Name: Callback, Line 1034 ]]
                            -- upvalues: u24 (copy), u211 (copy), l__newConsoleLine__3 (copy)
                            local v213 = string.split(p212, ",");
                            if v213 then
                                local u214 = tonumber(v213[1]);
                                local u215 = tonumber(v213[2]);
                                local u216 = tonumber(v213[3]);
                                if u214 and (u215 and u216) then
                                    local u217 = u24:GetAttribute("World");
                                    local u218 = u24:GetAttribute("UID");
                                    local l__Color__23 = u211.Color;
                                    return function() --[[ Line: 1048 ]]
                                        -- upvalues: l__newConsoleLine__3 (ref), u217 (copy), u218 (copy), u214 (copy), u215 (copy), u216 (copy)
                                        l__newConsoleLine__3({
                                            "color",
                                            u217,
                                            u218,
                                            u214,
                                            u215,
                                            u216
                                        });
                                    end, function() --[[ Line: 1050 ]]
                                        -- upvalues: l__newConsoleLine__3 (ref), u217 (copy), u218 (copy), l__Color__23 (copy)
                                        l__newConsoleLine__3({
                                            "color",
                                            u217,
                                            u218,
                                            l__Color__23.R * 255,
                                            l__Color__23.G * 255,
                                            l__Color__23.B * 255
                                        });
                                    end;
                                end;
                            end;
                        end
                    };
                    v25 = {
                        {
                            Name = "About",
                            Options = v208
                        },
                        {
                            Name = "Transform",
                            Options = v172
                        },
                        {
                            Name = "Actions",
                            Options = {
                                {
                                    Name = "Delete",
                                    Callback = function() --[[ Name: Callback, Line 1072 ]]
                                        -- upvalues: l__newConsoleLine__3 (copy), u24 (copy), l__newSelection__4 (copy)
                                        l__newConsoleLine__3({ "delete", u24:GetAttribute("World"), u24:GetAttribute("UID") });
                                        l__newSelection__4({});
                                    end
                                }
                            }
                        }
                    };
                else
                    v25 = {
                        {
                            Name = "About",
                            Options = v208
                        },
                        {
                            Name = "Transform",
                            Options = v172
                        },
                        {
                            Name = "Actions",
                            Options = {
                                {
                                    Name = "Delete",
                                    Callback = function() --[[ Name: Callback, Line 1072 ]]
                                        -- upvalues: l__newConsoleLine__3 (copy), u24 (copy), l__newSelection__4 (copy)
                                        l__newConsoleLine__3({ "delete", u24:GetAttribute("World"), u24:GetAttribute("UID") });
                                        l__newSelection__4({});
                                    end
                                }
                            }
                        }
                    };
                end;
            end;
        elseif u24:IsA("Vehicle") then
            v25 = {
                {
                    Name = "About",
                    Options = {
                        {
                            Name = "UID",
                            Value = u24.UID
                        },
                        {
                            Name = "Owner",
                            Value = u24.Owner and (u24.Owner.Name or "[server]") or "[server]"
                        }
                    }
                },
                {
                    Name = "Actions",
                    Options = {
                        {
                            Name = "Delete",
                            Callback = function() --[[ Name: Callback, Line 1101 ]]
                                -- upvalues: l__newConsoleLine__3 (copy), u24 (copy), l__newSelection__4 (copy)
                                l__newConsoleLine__3({ "vehicle", "delete", u24.UID });
                                l__newSelection__4({});
                            end
                        }
                    }
                }
            };
        elseif u24:IsA("Actor") then
            v25 = {
                {
                    Name = "About",
                    Options = {
                        {
                            Name = "UID",
                            Value = u24.UID
                        },
                        {
                            Name = "Health",
                            Value = typeof(u24.Health) == "number" and u24.Health or u24.Health.Ability
                        }
                    }
                },
                {
                    Name = "Actions",
                    Options = {
                        {
                            Name = "Delete",
                            Callback = function() --[[ Name: Callback, Line 1129 ]]
                                -- upvalues: l__newConsoleLine__3 (copy), u24 (copy), l__newSelection__4 (copy)
                                l__newConsoleLine__3({ "bot", "delete", u24.UID });
                                l__newSelection__4({});
                            end
                        }
                    }
                }
            };
        elseif u24:IsA("Trigger") then
            u24:Sync();
            local v219 = {
                {
                    Name = "Activate",
                    Callback = function() --[[ Name: Callback, Line 1143 ]]
                        -- upvalues: l__newConsoleLine__3 (copy), u24 (copy)
                        l__newConsoleLine__3({
                            "trigger",
                            "activate",
                            u24.World,
                            u24.Name
                        });
                    end
                }
            };
            if not u24.Active then
                v219[#v219 + 1] = {
                    Name = "Reset",
                    Callback = function() --[[ Name: Callback, Line 1151 ]]
                        -- upvalues: l__newConsoleLine__3 (copy), u24 (copy)
                        l__newConsoleLine__3({
                            "trigger",
                            "reset",
                            u24.World,
                            u24.Name
                        });
                    end
                };
            end;
            local v220 = {};
            for v221, u222 in {
                "Players",
                "Bots",
                "Helicopters",
                "Ground"
            } do
                v220[v221] = {
                    Name = u222,
                    Value = u24[u222],
                    Callback = function(_) --[[ Name: Callback, Line 1162 ]]
                        -- upvalues: l__newConsoleLine__3 (copy), u24 (copy), u222 (copy)
                        l__newConsoleLine__3({
                            "trigger",
                            "whitelist",
                            u24.World,
                            u24.Name,
                            u222,
                            u24[u222] and "false" or "true"
                        });
                    end
                };
            end;
            local v223 = {};
            for u224, v225 in u24.Executable do
                v223[#v223 + 1] = {
                    Small = true,
                    Name = tostring(u224),
                    Value = v225[1] == l__UserId__2 and v225[2] or "[Unavailable]",
                    Callback = function(p226) --[[ Name: Callback, Line 1174 ]]
                        -- upvalues: l__newConsoleLine__3 (copy), u24 (copy), u224 (copy)
                        if #p226 == 0 then
                            p226 = nil;
                        end;
                        l__newConsoleLine__3({
                            "trigger",
                            "executable",
                            u24.World,
                            u24.Name,
                            u224,
                            p226
                        });
                    end
                };
            end;
            v223[#v223 + 1] = {
                Name = "Add Line",
                Callback = function(_) --[[ Name: Callback, Line 1185 ]]
                    -- upvalues: l__newConsoleLine__3 (copy), u24 (copy)
                    l__newConsoleLine__3({
                        "trigger",
                        "executable",
                        u24.World,
                        u24.Name,
                        #u24.Executable + 1,
                        ""
                    });
                end
            };
            v25 = {
                {
                    Name = "About",
                    Options = {
                        {
                            Name = "Name",
                            Value = u24.Name
                        },
                        {
                            Name = "Status",
                            Value = u24.Active and "Active" or "Inactive"
                        },
                        {
                            Name = "Color",
                            Value = math.floor(u24.Color.R * 255) .. ", " .. math.floor(u24.Color.G * 255) .. ", " .. math.floor(u24.Color.B * 255),
                            Callback = function(p227) --[[ Name: Callback, Line 1205 ]]
                                -- upvalues: u24 (copy), l__newConsoleLine__3 (copy)
                                local v228 = string.split(p227, ",");
                                if v228 then
                                    local u229 = tonumber(v228[1]);
                                    local u230 = tonumber(v228[2]);
                                    local u231 = tonumber(v228[3]);
                                    if u229 and (u230 and u231) then
                                        local l__Name__24 = u24.Name;
                                        local l__World__25 = u24.World;
                                        local l__Color__26 = u24.Color;
                                        return function() --[[ Line: 1219 ]]
                                            -- upvalues: l__newConsoleLine__3 (ref), l__World__25 (copy), l__Name__24 (copy), u229 (copy), u230 (copy), u231 (copy)
                                            l__newConsoleLine__3({
                                                "trigger",
                                                "color",
                                                l__World__25,
                                                l__Name__24,
                                                u229,
                                                u230,
                                                u231
                                            });
                                        end, function() --[[ Line: 1221 ]]
                                            -- upvalues: l__newConsoleLine__3 (ref), l__World__25 (copy), l__Name__24 (copy), l__Color__26 (copy)
                                            l__newConsoleLine__3({
                                                "trigger",
                                                "color",
                                                l__World__25,
                                                l__Name__24,
                                                l__Color__26.R * 255,
                                                l__Color__26.G * 255,
                                                l__Color__26.B * 255
                                            });
                                        end;
                                    end;
                                end;
                            end
                        },
                        {
                            Name = "IsLooping",
                            Value = u24.IsLooping,
                            Callback = function(_) --[[ Name: Callback, Line 1230 ]]
                                -- upvalues: l__newConsoleLine__3 (copy), u24 (copy)
                                l__newConsoleLine__3({
                                    "trigger",
                                    "whitelist",
                                    u24.World,
                                    u24.Name,
                                    "IsLooping",
                                    u24.IsLooping and "false" or "true"
                                });
                            end
                        }
                    }
                },
                {
                    Name = "Whitelist",
                    Options = v220
                },
                {
                    Name = "Executable",
                    Options = v223
                },
                {
                    Name = "Actions",
                    Options = v219
                }
            };
        end;
        local v232, v233, v234;
        v232, v233, v234 = v25, nil, nil;
        local v235, v236;
        if type(v232) == "function" then
            v235, v236 = v232(v233, v234);
        else
            v235, v236 = next(v232, v234);
        end;
        v234 = v235;
    end;
end;
return v9;