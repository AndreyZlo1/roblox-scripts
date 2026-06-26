-- Services.RGEService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1, v2, u3, u4, u5, u6, u7, u8 = shared.import("network", "require", "Enum", "Roact", "RoactRodux", "Rodux", "signal", "asset");
local u9 = v2("RGEMainComponent");
local u10 = v2("ReplicatorService");
local u11 = v2("ClientService");
local u12 = v2("SoundService");
local u13 = v2("InputService");
local u14 = v2("GameShellProxyService");
local u15 = v2("EnvironmentService");
local u16 = v2("PopupInterface");
local u17 = v2("TutorialInterface");
local u18 = v2("HQManagerInterface");
local l__Debris__1 = game:GetService("Debris");
local l__Players__2 = game:GetService("Players");
local l__UserInputService__3 = game:GetService("UserInputService");
local l__SoundService__4 = game:GetService("SoundService");
local l__PlayerGui__5 = l__Players__2.LocalPlayer:WaitForChild("PlayerGui");
local u19 = v2({
    "RGELocalWindow",
    "RGEStudioWindow",
    "RGECinematicWindow",
    "RGETopdownWindow"
});
local l__CurrentCamera__6 = workspace.CurrentCamera;
local u20 = {
    Vector3.new(0, 1, 0),
    Vector3.new(-0, -1, -0),
    Vector3.new(1, 0, 0),
    Vector3.new(-1, -0, -0),
    Vector3.new(0, 0, 1),
    Vector3.new(-0, -0, -1)
};
local u21 = {};
u21.__index = u21;
local function u27(p22, p23) --[[ Line: 68 ]]
    local v24 = workspace:FindFirstChild("__RGE");
    if v24 then
        local v25 = v24:FindFirstChild((tostring(p22)));
        if v25 then
            for _, v26 in v25:GetChildren() do
                if v26:GetAttribute("UID") == p23 then
                    return v26;
                end;
            end;
        end;
    end;
end;
function u21._singlePartModel(_, p28) --[[ Line: 86 ]]
    if p28:IsA("Model") then
        if p28:GetAttribute("PropName") then
            local v29 = p28:GetChildren();
            if #v29 == 1 then
                return v29[1];
            end;
        end;
    end;
end;
function u21._verifyObject(p30, p31, p32, p33, p34) --[[ Line: 101 ]]
    -- upvalues: u27 (copy)
    if not (p31 and p31:IsDescendantOf(workspace)) then
        if p34 then
            if p30._navMesh[id] then
                return p30._navMesh[id].Ball;
            end;
        else
            p31 = u27(p32, p33);
        end;
    end;
    return p31;
end;
local function u54(p35, p36, p37, p38) --[[ Line: 132 ]]
    local v39 = p36 - p35;
    local v40 = v39.X * v39.X + v39.Y * v39.Y + v39.Z * v39.Z;
    if v40 == 0 and true or (nil or 1e-6) >= math.abs(v40 - 0) then
        return false, nil, nil;
    end;
    local v41 = math.abs(v40);
    local v42 = v39 * (1 / math.sqrt(v41));
    local v43 = p38 - p37;
    local v44 = v43.X * v43.X + v43.Y * v43.Y + v43.Z * v43.Z;
    if v44 == 0 and true or (nil or 1e-6) >= math.abs(v44 - 0) then
        return false, nil, nil;
    end;
    local v45 = math.abs(v44);
    local v46 = v43 * (1 / math.sqrt(v45));
    local v47 = p35 - p37;
    local v48 = v46:Dot(v42);
    local v49 = v46:Dot(v46);
    local v50 = v42:Dot(v42) * v49 - v48 * v48;
    if v50 == 0 and true or (nil or 1e-6) >= math.abs(v50 - 0) then
        return true, 0, 0;
    end;
    local v51 = v47:Dot(v46);
    local v52 = v47:Dot(v42);
    local v53 = (v51 * v48 - v52 * v49) / v50;
    return true, v53, (v51 + v53 * v48) / v49;
end;
local function u69(p55, p56) --[[ Line: 169 ]]
    -- upvalues: u54 (copy)
    local l__Direction__7 = p55.Direction;
    local l__Direction__8 = p56.Direction;
    local l__Unit__9 = l__Direction__7.Unit;
    local l__Unit__10 = l__Direction__8.Unit;
    local l__Origin__11 = p55.Origin;
    local v57 = l__Origin__11 + l__Direction__7;
    local l__Origin__12 = p56.Origin;
    local v58, v59, v60 = u54(l__Origin__11, v57, l__Origin__12, l__Origin__12 + l__Direction__8);
    if v58 then
        if v59 < 0 and v60 < 0 then
            local v61 = (l__Origin__12 - l__Origin__11):Dot(l__Unit__9);
            local v62 = l__Origin__11 + l__Unit__9 * math.max(v61, 0);
            local v63 = (l__Origin__11 - l__Origin__12):Dot(l__Unit__10);
            local v64 = l__Origin__12 + l__Unit__10 * math.max(v63, 0);
            local v65 = v62 - l__Origin__12;
            local v66 = v65.X * v65.X + v65.Y * v65.Y + v65.Z * v65.Z;
            local v67 = v64 - l__Origin__11;
            if v66 <= v67.X * v67.X + v67.Y * v67.Y + v67.Z * v67.Z then
                return v62;
            else
                return v64;
            end;
        else
            if v59 < 0 then
                return l__Origin__11;
            end;
            if v60 >= 0 then
                return l__Origin__11 + l__Unit__9 * v59;
            end;
            local v68 = (l__Origin__11 - l__Origin__12):Dot(l__Unit__10);
            return l__Origin__12 + l__Unit__10 * math.max(v68, 0);
        end;
    else
        return l__Origin__11;
    end;
end;
function u21._undo(u70) --[[ Line: 204 ]]
    local l___changeHistory__13 = u70._changeHistory;
    local v71 = l___changeHistory__13.Memory[l___changeHistory__13.Index];
    if v71 then
        v71.Undo(function(...) --[[ Line: 211 ]]
            -- upvalues: u70 (copy)
            return u70:_verifyObject(...);
        end);
        l___changeHistory__13.Index = l___changeHistory__13.Index - 1;
        local l___store__14 = u70._store;
        l___store__14:dispatch({
            type = "newConsoleLine",
            entry = "Undo action (" .. v71.Name .. ")",
            color = Color3.new(0.054901, 0.552941, 0.960784)
        });
        local v72 = l___store__14:getState();
        if v72.selection[1] and (v72.selection[1]:IsA("BasePart") or v72.selection[1]:IsA("Model")) then
            u70:_handles(v72.selection[1], v72.tool);
        end;
        l___changeHistory__13.Changed:Fire();
    end;
end;
function u21._redo(u73) --[[ Line: 230 ]]
    local l___changeHistory__15 = u73._changeHistory;
    local v74 = l___changeHistory__15.Memory[l___changeHistory__15.Index + 1];
    if v74 then
        v74.Redo(function(...) --[[ Line: 237 ]]
            -- upvalues: u73 (copy)
            return u73:_verifyObject(...);
        end);
        l___changeHistory__15.Index = l___changeHistory__15.Index + 1;
        local l___store__16 = u73._store;
        l___store__16:dispatch({
            type = "newConsoleLine",
            entry = "Redo action (" .. v74.Name .. ")",
            color = Color3.new(0.054901, 0.552941, 0.960784)
        });
        local v75 = l___store__16:getState();
        if v75.selection[1] and (v75.selection[1]:IsA("BasePart") or v75.selection[1]:IsA("Model")) then
            u73:_handles(v75.selection[1], v75.tool);
        end;
        l___changeHistory__15.Changed:Fire();
    end;
end;
function u21._addChange(u76, p77, p78, p79) --[[ Line: 256 ]]
    local l___changeHistory__17 = u76._changeHistory;
    if l___changeHistory__17.Index < #l___changeHistory__17.Memory then
        for v80 = #l___changeHistory__17.Memory, l___changeHistory__17.Index + 1, -1 do
            if v80 == 0 then
                break;
            end;
            table.remove(l___changeHistory__17.Memory, v80);
        end;
    end;
    if #l___changeHistory__17.Memory >= 40 then
        table.remove(l___changeHistory__17.Memory, 1);
    end;
    l___changeHistory__17.Index = #l___changeHistory__17.Memory + 1;
    l___changeHistory__17.Memory[l___changeHistory__17.Index] = {
        Name = p77,
        Undo = p79,
        Redo = p78
    };
    return p78(function(...) --[[ Line: 282 ]]
        -- upvalues: u76 (copy)
        return u76:_verifyObject(...);
    end);
end;
function u21._send(p81, ...) --[[ Line: 287 ]]
    -- upvalues: u1 (copy)
    p81._store:dispatch({
        type = "newConsoleLine",
        entry = table.concat({ ... }, " "),
        color = Color3.new(1, 1, 1)
    });
    u1:FireServer("ActivateConsole", ...);
end;
function u21._offset(_, p82, p83) --[[ Line: 296 ]]
    -- upvalues: l__CurrentCamera__6 (copy)
    local l__ViewportSize__18 = l__CurrentCamera__6.ViewportSize;
    local v84 = l__ViewportSize__18.X / l__ViewportSize__18.Y;
    local v85 = Vector2.new(p83.X.Scale * l__ViewportSize__18.X + p83.X.Offset, p83.Y.Scale * l__ViewportSize__18.Y + p83.Y.Offset);
    local v86 = Vector2.new(p82.X.Scale * l__ViewportSize__18.X + p82.X.Offset, p82.Y.Scale * l__ViewportSize__18.Y + p82.Y.Offset) / l__CurrentCamera__6.ViewportSize;
    local v87 = math.rad(l__CurrentCamera__6.FieldOfView) / 2;
    local v88 = math.tan(v87);
    local v89 = v85 / l__ViewportSize__18;
    return CFrame.new(0, 0, 0, v86.X, 0, 0, 0, v86.Y, 0, -v89.X * v88 * v84 * 2, v89.Y * v88 * 2, 1);
end;
function u21._duplicate(p90) --[[ Line: 314 ]]
    for _, v91 in p90._store:getState().selection do
        if v91:IsA("BasePart") or v91:IsA("Model") then
            p90:_send("duplicate", v91:GetAttribute("World"), v91:GetAttribute("UID"));
        end;
    end;
end;
function u21._jump(p92) --[[ Line: 324 ]]
    -- upvalues: u11 (copy)
    local v93 = p92._store:getState();
    local v94 = v93.selection[1];
    if v94 then
        local v95 = nil;
        if v94:IsA("Player") then
            local v96 = u11.Clients[v94];
            if v96 and v96.Actor then
                v95 = v96.Actor.CFrame;
            end;
        elseif v94:IsA("Model") then
            v95 = v94:GetBoundingBox();
        elseif v94:IsA("BasePart") then
            v95 = v94.CFrame;
        elseif v94:IsA("Vehicle") then
            v95 = v94.CFrame;
        elseif v94:IsA("Actor") then
            v95 = v94.CFrame;
        end;
        if v95 then
            v93.windows[v93.window]:Jump(v95);
        end;
    end;
end;
function u21._handles(p97, p98, p99) --[[ Line: 351 ]]
    -- upvalues: u20 (copy), u3 (copy), l__PlayerGui__5 (copy)
    if p97._handleModel then
        p97._handleModel:Destroy();
        p97._handleModel = nil;
    end;
    if p97._handleAdnorees then
        for _, v100 in p97._handleAdnorees do
            for v101 in v100.Handles do
                v101:Destroy();
            end;
        end;
        p97._handleAdnorees = nil;
    end;
    if p98 then
        local v102 = p98:IsA("Model");
        local v103 = p98:GetAttribute("NodeId") and true or false;
        local v104 = p97:_singlePartModel(p98);
        if v104 then
            p98 = v104;
        elseif v102 then
            local v105, v106 = p98:GetBoundingBox();
            p98 = Instance.new("Part");
            p98.Transparency = 1;
            p98.Size = v106;
            p98.CFrame = v105;
            p98.Anchored = true;
            p98.CanCollide = false;
            p98.CanTouch = false;
            p98.CanQuery = false;
            p98.AudioCanCollide = false;
            p98.Parent = workspace;
            p97._handleModel = p98;
        end;
        local v107 = {};
        for _, u108 in u20 do
            local v109 = Color3.new(math.abs(u108.X), math.abs(u108.Y), (math.abs(u108.Z)));
            local v110 = {
                Parent = p98,
                Position = p98.Size * u108 / 2 + u108 * 3,
                Handles = {}
            };
            if p99 == 0 then
                local v111 = Instance.new("ConeHandleAdornment");
                v111.Color3 = v109;
                v111.AdornCullingMode = u3.AdornCullingMode.Never;
                v111.Transparency = 0.75;
                v111.Height = 2;
                v111.Radius = 0.5;
                v111.AlwaysOnTop = true;
                v111.ZIndex = 0;
                v111.Adornee = p98;
                v111.Parent = l__PlayerGui__5;
                v110.Handles[v111] = {
                    {
                        Transparency = 0.75,
                        Height = function(p112) --[[ Name: Height, Line 416 ]]
                            return p112 * 2;
                        end,
                        Radius = function(p113) --[[ Name: Radius, Line 419 ]]
                            return p113 * 0.5;
                        end
                    },
                    {
                        Transparency = 0,
                        Height = function(p114) --[[ Name: Height, Line 425 ]]
                            return p114 * 2.175;
                        end,
                        Radius = function(p115) --[[ Name: Radius, Line 428 ]]
                            return p115 * 0.75;
                        end
                    },
                    CFrame = function(p116) --[[ Name: CFrame, Line 432 ]]
                        -- upvalues: u108 (copy)
                        return CFrame.lookAlong(p116 * u108 / 2 + u108 * 3 + u108, u108);
                    end
                };
                local v117 = Instance.new("CylinderHandleAdornment");
                v117.Color3 = v109;
                v117.AdornCullingMode = u3.AdornCullingMode.Never;
                v117.Transparency = 0.75;
                v117.Height = 3;
                v117.Radius = 0.15;
                v117.AlwaysOnTop = true;
                v117.ZIndex = 0;
                v117.Adornee = p98;
                v117.Parent = l__PlayerGui__5;
                v110.Handles[v117] = {
                    {
                        Transparency = 0.75,
                        Height = function(p118) --[[ Name: Height, Line 450 ]]
                            return p118 * 3;
                        end,
                        Radius = function(p119) --[[ Name: Radius, Line 453 ]]
                            return p119 * 0.15;
                        end
                    },
                    {
                        Transparency = 0,
                        Height = function(p120) --[[ Name: Height, Line 459 ]]
                            return p120 * 3;
                        end,
                        Radius = function(p121) --[[ Name: Radius, Line 462 ]]
                            return p121 * 0.25;
                        end
                    },
                    CFrame = function(p122) --[[ Name: CFrame, Line 466 ]]
                        -- upvalues: u108 (copy)
                        return CFrame.lookAlong(p122 * u108 / 2 + u108 * 3 - u108 * 0.5, u108);
                    end
                };
                local v123 = Instance.new("ConeHandleAdornment");
                v123.Color3 = v109;
                v123.AdornCullingMode = u3.AdornCullingMode.Never;
                v123.Transparency = 0.5;
                v123.Height = 2;
                v123.Radius = 0.5;
                v123.AlwaysOnTop = false;
                v123.ZIndex = 0;
                v123.Adornee = p98;
                v123.Parent = l__PlayerGui__5;
                v110.Handles[v123] = {
                    {
                        Height = function(p124) --[[ Name: Height, Line 483 ]]
                            return p124 * 2;
                        end,
                        Radius = function(p125) --[[ Name: Radius, Line 486 ]]
                            return p125 * 0.5;
                        end
                    },
                    {
                        Height = function(p126) --[[ Name: Height, Line 491 ]]
                            return p126 * 2;
                        end,
                        Radius = function(p127) --[[ Name: Radius, Line 494 ]]
                            return p127 * 0.5;
                        end
                    },
                    CFrame = function(p128) --[[ Name: CFrame, Line 498 ]]
                        -- upvalues: u108 (copy)
                        return CFrame.lookAlong(p128 * u108 / 2 + u108 * 3 + u108, u108);
                    end
                };
                local v129 = Instance.new("CylinderHandleAdornment");
                v129.Color3 = v109;
                v129.AdornCullingMode = u3.AdornCullingMode.Never;
                v129.Transparency = 0.5;
                v129.Height = 3;
                v129.Radius = 0.15;
                v129.AlwaysOnTop = false;
                v129.ZIndex = 0;
                v129.Adornee = p98;
                v129.Parent = l__PlayerGui__5;
                v110.Handles[v129] = {
                    {
                        Height = function(p130) --[[ Name: Height, Line 515 ]]
                            return p130 * 3;
                        end,
                        Radius = function(p131) --[[ Name: Radius, Line 518 ]]
                            return p131 * 0.15;
                        end
                    },
                    {
                        Height = function(p132) --[[ Name: Height, Line 523 ]]
                            return p132 * 3;
                        end,
                        Radius = function(p133) --[[ Name: Radius, Line 526 ]]
                            return p133 * 0.15;
                        end
                    },
                    CFrame = function(p134) --[[ Name: CFrame, Line 530 ]]
                        -- upvalues: u108 (copy)
                        return CFrame.lookAlong(p134 * u108 / 2 + u108 * 3 - u108 * 0.5, u108);
                    end
                };
            elseif p99 == 1 and (not v102 or v104) and not v103 then
                local v135 = Instance.new("SphereHandleAdornment");
                v135.Color3 = v109;
                v135.AdornCullingMode = u3.AdornCullingMode.Never;
                v135.Transparency = 0.75;
                v135.Radius = 0.5;
                v135.AlwaysOnTop = true;
                v135.ZIndex = 0;
                v135.Adornee = p98;
                v135.Parent = l__PlayerGui__5;
                v110.Handles[v135] = {
                    {
                        Transparency = 0.75,
                        Radius = function(p136) --[[ Name: Radius, Line 547 ]]
                            return p136 * 0.5;
                        end
                    },
                    {
                        Transparency = 0,
                        Radius = function(p137) --[[ Name: Radius, Line 553 ]]
                            return p137 * 0.75;
                        end
                    },
                    CFrame = function(p138) --[[ Name: CFrame, Line 557 ]]
                        -- upvalues: u108 (copy)
                        return CFrame.new(p138 * u108 / 2 + u108 * 3);
                    end
                };
                local v139 = Instance.new("SphereHandleAdornment");
                v139.Color3 = v109;
                v139.AdornCullingMode = u3.AdornCullingMode.Never;
                v139.Transparency = 0.5;
                v139.Radius = 0.5;
                v139.AlwaysOnTop = false;
                v139.ZIndex = 0;
                v139.Adornee = p98;
                v139.Parent = l__PlayerGui__5;
                v110.Handles[v139] = {
                    {
                        Radius = function(p140) --[[ Name: Radius, Line 573 ]]
                            return p140 * 0.5;
                        end
                    },
                    {
                        Radius = function(p141) --[[ Name: Radius, Line 578 ]]
                            return p141 * 0.5;
                        end
                    },
                    CFrame = function(p142) --[[ Name: CFrame, Line 582 ]]
                        -- upvalues: u108 (copy)
                        return CFrame.new(p142 * u108 / 2 + u108 * 3);
                    end
                };
            elseif p99 == 2 and (not v103 and (u108.X >= 0 and (u108.Y >= 0 and u108.Z >= 0))) then
                local u143 = (math.max(p98.Size.X, p98.Size.Y, p98.Size.Z) + 4) / 2;
                local v144 = 6.283185307179586 * u143;
                local u145 = CFrame.new();
                if u108.Z > 0 then
                    u145 = CFrame.Angles(1.5707963267948966, 0, 0);
                elseif u108.X > 0 then
                    u145 = CFrame.Angles(0, 0, 1.5707963267948966);
                end;
                v110.Direction = u108;
                for v146 = 1, 20 do
                    local u147 = (v146 - 0.5) / 20 * 6.283185307179586;
                    local v148 = -math.cos(u147);
                    local v149 = -math.sin(u147);
                    local u150 = math.atan2(v148, v149) + 1.5707963267948966;
                    local v151 = Instance.new("CylinderHandleAdornment");
                    v151.Color3 = v109;
                    v151.AdornCullingMode = u3.AdornCullingMode.Never;
                    v151.Transparency = 0.75;
                    v151.Height = v144 / 20;
                    v151.Radius = 0.05;
                    v151.AlwaysOnTop = true;
                    v151.ZIndex = 0;
                    v151.Adornee = p98;
                    v151.Parent = l__PlayerGui__5;
                    v110.Handles[v151] = {
                        {
                            Transparency = 0.75,
                            Radius = function(p152) --[[ Name: Radius, Line 620 ]]
                                return p152 * 0.05;
                            end
                        },
                        {
                            Transparency = 0,
                            Radius = function(p153) --[[ Name: Radius, Line 626 ]]
                                return p153 * 0.05;
                            end
                        },
                        CFrame = function() --[[ Name: CFrame, Line 630 ]]
                            -- upvalues: u145 (ref), u147 (copy), u143 (copy), u150 (copy)
                            return u145:ToWorldSpace(CFrame.new(math.cos(u147) * u143, 0, math.sin(u147) * u143) * CFrame.Angles(0, u150, 0));
                        end
                    };
                    local v154 = Instance.new("CylinderHandleAdornment");
                    v154.Color3 = v109;
                    v154.AdornCullingMode = u3.AdornCullingMode.Never;
                    v154.Transparency = 0.75;
                    v154.Height = v144 / 20;
                    v154.Radius = 0.05;
                    v154.AlwaysOnTop = false;
                    v154.ZIndex = 0;
                    v154.Adornee = p98;
                    v154.Parent = l__PlayerGui__5;
                    v110.Handles[v154] = {
                        {
                            Radius = function(p155) --[[ Name: Radius, Line 647 ]]
                                return p155 * 0.05;
                            end
                        },
                        {
                            Radius = function(p156) --[[ Name: Radius, Line 652 ]]
                                return p156 * 0.05;
                            end
                        },
                        CFrame = function() --[[ Name: CFrame, Line 656 ]]
                            -- upvalues: u145 (ref), u147 (copy), u143 (copy), u150 (copy)
                            return u145:ToWorldSpace(CFrame.new(math.cos(u147) * u143, 0, math.sin(u147) * u143) * CFrame.Angles(0, u150, 0));
                        end
                    };
                end;
            end;
            v107[u108] = v110;
        end;
        p97._handleAdnorees = v107;
        p97:_updateHandleAdornees();
    end;
end;
function u21._updateHandleAdornees(p157, p158) --[[ Line: 670 ]]
    -- upvalues: l__CurrentCamera__6 (copy)
    if p157._handleAdnorees then
        for v159, v160 in p157._handleAdnorees do
            local l__CFrame__19 = v160.Parent.CFrame;
            local l__Magnitude__20 = (l__CFrame__19.Position - l__CurrentCamera__6.CFrame.Position).Magnitude;
            local v161 = l__Magnitude__20 <= 50 and 1 or l__Magnitude__20 / 50;
            for v162, v163 in v160.Handles do
                for v164, v166 in v163[v159 == p158 and 2 or 1] do
                    if typeof(v166) == "function" then
                        local v166 = v166(v161) or v166;
                    end;
                    v162[v164] = v166;
                end;
                local v167 = v163.CFrame(v160.Parent.Size);
                if p157._worldSpace then
                    v162.CFrame = l__CFrame__19:Inverse() * CFrame.new(l__CFrame__19.Position) * v167;
                else
                    v162.CFrame = v167;
                end;
            end;
        end;
    end;
end;
function u21._didFullscreen(_) --[[ Line: 698 ]]
    -- upvalues: u3 (copy), u13 (copy), l__PlayerGui__5 (copy), l__Debris__1 (copy)
    local v168 = Instance.new("ScreenGui");
    v168.ZIndexBehavior = u3.ZIndexBehavior.Sibling;
    local v169 = Instance.new("Frame");
    v169.ZIndex = 4;
    v169.BackgroundColor3 = Color3.fromRGB(31, 31, 31);
    v169.BorderColor3 = Color3.fromRGB(43, 43, 43);
    v169.BorderSizePixel = 1;
    v169.Position = UDim2.new(0.2, 0, 0.1, 0);
    v169.Size = UDim2.new(0.6, 0, 0, 30);
    v169.Parent = v168;
    local v170 = Instance.new("TextLabel");
    v170.BackgroundTransparency = 1;
    v170.Position = UDim2.new(0, 0, 0.2, 0);
    v170.Size = UDim2.new(1, 0, 0.6, 0);
    v170.Text = "To exit fullscreen, press <b>" .. u13:GetBind("Fullscreen").Name .. "</b>";
    v170.RichText = true;
    v170.TextColor3 = Color3.new(1, 1, 1);
    v170.Font = u3.Font.Ubuntu;
    v170.TextXAlignment = u3.TextXAlignment.Center;
    v170.TextWrapped = true;
    v170.TextSize = 20;
    v170.Parent = v169;
    v168.Parent = l__PlayerGui__5;
    l__Debris__1:AddItem(v168, 4);
end;
function u21.new() --[[ Line: 729 ]]
    -- upvalues: u14 (copy), u3 (copy), u7 (copy), u21 (copy), u1 (copy)
    local _, v171 = u14:CreateProxy(100, u3.ShellPriority.AlwaysVisible, "RGEInterface");
    local v172 = Instance.new("Frame");
    v172.ZIndex = 4;
    v172.BackgroundColor3 = Color3.fromRGB(31, 31, 31);
    v172.BorderColor3 = Color3.fromRGB(43, 43, 43);
    v172.BorderSizePixel = 1;
    v172.Size = UDim2.new(1, 0, 0, 130);
    v172.Parent = v171;
    local v173 = Instance.new("Frame");
    v173.ZIndex = 3;
    v173.BackgroundColor3 = Color3.fromRGB(24, 24, 24);
    v173.BorderColor3 = Color3.fromRGB(43, 43, 43);
    v173.BorderSizePixel = 1;
    v173.Parent = v171;
    local v174 = Instance.new("Frame");
    v174.ZIndex = 3;
    v174.BackgroundColor3 = Color3.fromRGB(24, 24, 24);
    v174.BorderColor3 = Color3.fromRGB(43, 43, 43);
    v174.BorderSizePixel = 1;
    v174.AnchorPoint = Vector2.new(0, 1);
    v174.Position = UDim2.new(0, 0, 1, 0);
    v174.Parent = v171;
    local v175 = Instance.new("Frame");
    v175.ZIndex = 2;
    v175.BackgroundColor3 = Color3.fromRGB(24, 24, 24);
    v175.BorderColor3 = Color3.fromRGB(43, 43, 43);
    v175.BorderSizePixel = 1;
    v175.Position = UDim2.new(0, 0, 0, 130);
    v175.Parent = v171;
    local v176 = Instance.new("Frame");
    v176.ZIndex = 2;
    v176.BackgroundColor3 = Color3.fromRGB(24, 24, 24);
    v176.BorderColor3 = Color3.fromRGB(43, 43, 43);
    v176.BorderSizePixel = 1;
    v176.AnchorPoint = Vector2.new(1, 0);
    v176.Position = UDim2.new(1, 0, 0, 130);
    v176.Parent = v171;
    local v177 = Instance.new("Frame");
    v177.BackgroundColor3 = Color3.fromRGB(4, 57, 94);
    v177.BorderColor3 = Color3.fromRGB(0, 120, 212);
    v177.BorderSizePixel = 1;
    v177.BackgroundTransparency = 0.75;
    v177.Visible = false;
    v177.Parent = v171;
    local v178 = {
        Enabled = false,
        _angle = 0,
        _turn = 0,
        _panelY = 250,
        _panelL = 350,
        _panelR = 320,
        _ui = v171,
        _adornee = {},
        _changeHistory = {
            Index = 0,
            Memory = {},
            Changed = u7.new()
        },
        _navMesh = {},
        _navMeshCovers = {},
        _top = v172,
        _left = v175,
        _right = v176,
        _bottom = v174,
        _stations = v173,
        _selection = v177
    };
    local u179 = setmetatable(v178, u21);
    u1:ConnectEvents({
        ConsoleWrite = function(p180, p181) --[[ Name: ConsoleWrite, Line 812 ]]
            -- upvalues: u179 (copy)
            if u179._store then
                u179._store:dispatch({
                    type = "newConsoleLine",
                    entry = p180,
                    color = p181
                });
            end;
        end,
        NavMesh = function(p182, ...) --[[ Name: NavMesh, Line 821 ]]
            -- upvalues: u179 (copy)
            u179["NavMesh" .. p182](u179, ...);
        end
    });
    return u179;
end;
function u21.NavMeshClear(p183) --[[ Line: 829 ]]
    for v184, v185 in p183._navMesh do
        v185.Ball:Destroy();
        for v186, v187 in v185.Neighbors do
            local v188 = p183._navMesh[v186];
            if v188 then
                v188.Neighbors[v184] = nil;
            end;
            v187:Destroy();
        end;
    end;
    for _, v189 in p183._navMeshCovers do
        v189:Destroy();
    end;
    p183._navMeshCovers = {};
    p183._navMesh = {};
end;
function u21.NavMeshEditor(p190, p191) --[[ Line: 851 ]]
    p190._navMeshEditor = p191;
    p190._store:dispatch({
        type = ""
    });
end;
function u21.NavMeshSyncCover(p192, p193, p194, p195, p196, p197, p198) --[[ Line: 858 ]]
    -- upvalues: u8 (copy), u3 (copy)
    if not p192._navMeshCovers[p193] then
        local v199 = u8:Get("Shared", "Models", "Covers", p195).Asset:Clone();
        for _, v200 in v199:GetChildren() do
            v200.Material = u3.Material.SmoothPlastic;
            v200.Anchored = true;
            v200.CanCollide = false;
            v200.CanTouch = false;
            v200.CanQuery = not p197;
            if p197 then
                v200.Transparency = v200 == v199.PrimaryPart and 1 or 0.5;
            else
                v200:SetAttribute("CoverId", p193);
            end;
        end;
        if not p197 then
            v199:SetAttribute("CoverId", p193);
        end;
        v199.Parent = workspace;
        p192._navMeshCovers[p193] = v199;
    end;
    local v201 = p198 and Color3.new(1, 0, 1) or Color3.new(1, 1, 1);
    for _, v202 in p192._navMeshCovers[p193]:GetChildren() do
        v202.Color = v201;
    end;
    p192._navMeshCovers[p193]:PivotTo(p194 - Vector3.new(0, p196, 0));
end;
function u21.NavMeshUnsyncCover(p203, p204, _, _) --[[ Line: 891 ]]
    if p203._navMeshCovers[p204] then
        p203._navMeshCovers[p204]:Destroy();
        p203._navMeshCovers[p204] = nil;
    end;
end;
function u21.NavMeshSync(p205, p206, p207, p208, p209) --[[ Line: 898 ]]
    -- upvalues: u3 (copy)
    if not p205._navMesh[p206] then
        local v210 = Instance.new("Part");
        v210.Anchored = true;
        v210.CanCollide = false;
        v210.CanTouch = false;
        v210.Shape = u3.PartType.Ball;
        v210.CastShadow = false;
        v210.Size = Vector3.new(3, 3, 3);
        v210.Transparency = 0;
        v210.TopSurface = u3.SurfaceType.Smooth;
        v210.BottomSurface = u3.SurfaceType.Smooth;
        v210:SetAttribute("NodeId", p206);
        v210.Parent = workspace;
        p205._navMesh[p206] = {
            Ball = v210,
            Neighbors = {}
        };
    end;
    local v211 = p205._navMesh[p206];
    for _, v212 in p208 do
        local v213 = p205._navMesh[v212];
        if v213 and not (v213.Neighbors[p206] or v211.Neighbors[p206]) then
            local v214 = Instance.new("Part");
            v214.CastShadow = false;
            v214.Anchored = true;
            v214.CanCollide = false;
            v214.CanTouch = false;
            v214.Transparency = 0.5;
            v214.TopSurface = u3.SurfaceType.Smooth;
            v214.BottomSurface = u3.SurfaceType.Smooth;
            v214.Parent = workspace;
            p205._navMesh[p206].Neighbors[v212] = v214;
            v213.Neighbors[p206] = v214;
        end;
    end;
    local v215 = p209 and Color3.new(1, 0, 1) or Color3.new(1, 1, 1);
    v211.Position = p207;
    v211.Ball.CFrame = CFrame.new(p207);
    v211.Ball.Color = v215;
    for v216, v217 in v211.Neighbors do
        local v218 = p205._navMesh[v216];
        if v218 then
            if table.find(p208, v216) then
                local l__Position__21 = v218.Position;
                local l__Magnitude__22 = (p207 - l__Position__21).Magnitude;
                v217.CFrame = CFrame.lookAt((p207 + l__Position__21) / 2, p207);
                v217.Size = Vector3.new(0.2, 0.2, l__Magnitude__22);
                v217.Color = v215;
            else
                v217:Destroy();
                v218.Neighbors[p206] = nil;
                v211.Neighbors[v216] = nil;
            end;
        else
            v217:Destroy();
            v211.Neighbors[v216] = nil;
        end;
    end;
end;
function u21.NavMeshUnsync(p219, p220) --[[ Line: 977 ]]
    local v221 = p219._navMesh[p220];
    if v221 then
        for v222, v223 in v221.Neighbors do
            local v224 = p219._navMesh[v222];
            if v224 then
                v224.Neighbors[p220] = nil;
            end;
            v223:Destroy();
        end;
        v221.Ball:Destroy();
        p219._navMesh[p220] = nil;
    end;
end;
function u21.Init(u225) --[[ Line: 996 ]]
    -- upvalues: u6 (copy), u19 (copy), u3 (copy), l__PlayerGui__5 (copy), u11 (copy), u1 (copy)
    if u225._store then
    else
        u225._store = u6.Store.new(function(p226, p227) --[[ Line: 1001 ]]
            -- upvalues: u19 (ref), u225 (copy), u3 (ref), l__PlayerGui__5 (ref), u11 (ref), u1 (ref)
            local v228 = p226 or {
                id = 1,
                tool = 0,
                window = 0,
                move = 0.2,
                rotate = 5,
                worldSpace = false,
                selection = {},
                windows = {},
                console = {}
            };
            if p227.type == "toggleWorldSpace" then
                v228.worldSpace = not v228.worldSpace;
            elseif p227.type == "newWindow" then
                local l__windows__23 = v228.windows;
                local v229 = #l__windows__23 + 1;
                if v229 <= 30 then
                    local v230 = u19["RGE" .. p227.window .. "Window"].new();
                    local l__window__24 = v228.window;
                    l__windows__23[v229] = v230;
                    if l__window__24 > 0 then
                        l__windows__23[l__window__24]:Disable();
                        v230.Name = v230.Name .. " (" .. #l__windows__23 .. ")";
                    end;
                    v230:Enable();
                    v228.window = v229;
                    v228.windows = l__windows__23;
                end;
            elseif p227.type == "changeWindow" then
                local l__windows__25 = v228.windows;
                local l__window__26 = p227.window;
                if l__windows__25[l__window__26] then
                    l__windows__25[v228.window]:Disable();
                    l__windows__25[l__window__26]:Enable();
                    v228.window = l__window__26;
                    v228.windows = l__windows__25;
                end;
            elseif p227.type == "closeWindow" then
                local l__windows__27 = v228.windows;
                local v231 = l__windows__27[v228.window];
                local l__window__28 = p227.window;
                if l__windows__27[l__window__28] and l__windows__27[l__window__28].Closeable then
                    l__windows__27[l__window__28]:Disable();
                    l__windows__27[l__window__28]:Destroy();
                    table.remove(l__windows__27, l__window__28);
                    local v232 = table.find(l__windows__27, v231);
                    if v232 == nil then
                        v232 = l__window__28 - 1;
                    end;
                    l__windows__27[v232]:Enable();
                    v228.window = v232;
                    v228.windows = l__windows__27;
                end;
            elseif p227.type == "newSelection" then
                if u225._place then
                    u225._place:Destroy();
                    u225._place = nil;
                    u225._placeFunction = nil;
                end;
                local l__selection__29 = p227.selection;
                if typeof(l__selection__29) == "table" and not l__selection__29.IsA then
                    local v233 = {};
                    for _, v234 in l__selection__29 do
                        if not table.find(v233, v234) then
                            v233[#v233 + 1] = v234;
                        end;
                    end;
                    v228.selection = v233;
                elseif u225._command and u225._place == nil then
                    local v235 = table.find(v228.selection, l__selection__29);
                    if v235 then
                        table.remove(v228.selection, v235);
                    else
                        v228.selection[#v228.selection + 1] = l__selection__29;
                    end;
                else
                    v228.selection = { l__selection__29 };
                end;
                for v236, v237 in u225._adornee do
                    if not table.find(v228.selection, v236) then
                        v237:Destroy();
                        u225._adornee[v236] = nil;
                    end;
                end;
                for _, v238 in v228.selection do
                    if not u225._adornee[v238] then
                        if v238:IsA("BasePart") or v238:IsA("Model") then
                            local v239;
                            if v238:GetAttribute("NodeId") then
                                v239 = Instance.new("Highlight");
                                v239.Adornee = v238;
                                v239.FillTransparency = 1;
                                v239.OutlineTransparency = 0;
                                v239.OutlineColor = Color3.fromRGB(0, 120, 212);
                                v239.DepthMode = u3.HighlightDepthMode.AlwaysOnTop;
                                v239.Parent = l__PlayerGui__5;
                            else
                                v239 = Instance.new("SelectionBox");
                                v239.Adornee = v238;
                                v239.LineThickness = 0.02;
                                v239.SurfaceTransparency = 1;
                                v239.Transparency = 0;
                                v239.Color3 = Color3.fromRGB(0, 120, 212);
                                v239.Parent = l__PlayerGui__5;
                            end;
                            u225._adornee[v238] = v239;
                        elseif v238:IsA("Vehicle") then
                            local v240 = Instance.new("Highlight");
                            v240.Adornee = v238.Model;
                            v240.FillTransparency = 1;
                            v240.OutlineTransparency = 0;
                            v240.OutlineColor = Color3.fromRGB(0, 120, 212);
                            v240.DepthMode = u3.HighlightDepthMode.AlwaysOnTop;
                            v240.Parent = l__PlayerGui__5;
                            u225._adornee[v238] = v240;
                        elseif v238:IsA("Actor") then
                            local v241 = Instance.new("Highlight");
                            v241.Adornee = v238.Character;
                            v241.FillTransparency = 1;
                            v241.OutlineTransparency = 0;
                            v241.OutlineColor = Color3.fromRGB(0, 120, 212);
                            v241.DepthMode = u3.HighlightDepthMode.AlwaysOnTop;
                            v241.Parent = l__PlayerGui__5;
                            u225._adornee[v238] = v241;
                        elseif v238:IsA("Player") then
                            local v242 = u11.Clients[v238];
                            if v242 and v242.Actor then
                                local v243 = Instance.new("Highlight");
                                v243.FillTransparency = 1;
                                v243.OutlineTransparency = 0;
                                v243.OutlineColor = Color3.fromRGB(0, 120, 212);
                                v243.DepthMode = u3.HighlightDepthMode.AlwaysOnTop;
                                v243.Parent = l__PlayerGui__5;
                                v243.Adornee = v242.Actor.Character;
                                u225._adornee[v238] = v243;
                            end;
                        end;
                    end;
                end;
                if v228.selection[1] and (v228.selection[1]:IsA("BasePart") or v228.selection[1]:IsA("Model")) then
                    u225:_handles(v228.selection[1], v228.tool);
                else
                    u225:_handles();
                end;
            elseif p227.type == "newConsoleLine" then
                local v244 = #v228.console;
                if v244 == 20 then
                    table.remove(v228.console, 1);
                    v244 = v244 - 1;
                end;
                v228.console[v244 + 1] = { os.time(), p227.entry, p227.color };
            elseif p227.type == "setPlace" then
                v228.selection = {};
                u225:_handles();
                if u225._place then
                    u225._place:Destroy();
                end;
                u225._place = p227.model;
                u225._placeFunction = p227.callback;
                p227.model.Parent = workspace;
            elseif p227.type == "changeWorld" then
                local v245 = tonumber(p227.id);
                if v245 and v245 > 0 then
                    v228.id = math.ceil(v245);
                end;
            elseif p227.type == "changeTool" then
                v228.tool = p227.tool;
                if v228.selection[1] and (v228.selection[1]:IsA("BasePart") or v228.selection[1]:IsA("Model")) then
                    u225:_handles(v228.selection[1], v228.tool);
                else
                    u225:_handles();
                end;
            elseif p227.type == "changeSnap" then
                v228[p227.tool] = math.max(0.001, p227.value);
            elseif p227.type == "fullScreen" then
                u225:_didFullscreen();
                u225.Fullscreen = true;
            elseif p227.type == "createGroup" then
                if p227.group then
                    local v246 = { "group", (tostring(v228.id)) };
                    local v247 = false;
                    for _, v248 in v228.selection do
                        if v248:IsA("BasePart") or v248:IsA("Model") and not v248:GetAttribute("Prop") then
                            v246[#v246 + 1] = v248:GetAttribute("UID");
                            v247 = true;
                        end;
                    end;
                    if v247 then
                        u1:FireServer("ActivateConsole", unpack(v246));
                        v228.console[#v228.console + 1] = { os.time(), table.concat(v246, " "), Color3.new(1, 1, 1) };
                    end;
                else
                    local v249 = { "ungroup", (tostring(v228.id)) };
                    local v250 = false;
                    for _, v251 in v228.selection do
                        if v251:IsA("Model") and not v251:GetAttribute("Prop") then
                            v249[#v249 + 1] = v251:GetAttribute("UID");
                            v250 = true;
                        end;
                    end;
                    if v250 then
                        u1:FireServer("ActivateConsole", unpack(v249));
                        v228.console[#v228.console + 1] = { os.time(), table.concat(v249, " "), Color3.new(1, 1, 1) };
                    end;
                end;
            end;
            local v252 = {};
            for v253 = 1, #v228.windows do
                v252[v253] = v228.windows[v253];
            end;
            local v254 = {};
            for v255 = 1, #v228.console do
                v254[v255] = v228.console[v255];
            end;
            local v256 = {};
            for v257 = 1, #v228.selection do
                v256[v257] = v228.selection[v257];
            end;
            return {
                tool = v228.tool,
                id = v228.id,
                window = v228.window,
                selection = v256,
                windows = v252,
                console = v254,
                addChange = function(...) --[[ Name: addChange, Line 1256 ]]
                    -- upvalues: u225 (ref)
                    return u225:_addChange(...);
                end,
                changeHistory = u225._changeHistory,
                navMeshEditor = u225._navMeshEditor,
                worldSpace = v228.worldSpace,
                move = v228.move,
                rotate = v228.rotate
            };
        end);
        u225._store:dispatch({
            type = "newWindow",
            window = "Local"
        });
    end;
end;
function u21._delete(p258) --[[ Line: 1274 ]]
    local l___store__30 = p258._store;
    local l__selection__31 = l___store__30:getState().selection;
    for v259 = 1, #l__selection__31 do
        local v260 = l__selection__31[v259];
        local v261 = nil;
        local v262;
        if v260:IsA("BasePart") or v260:IsA("Model") then
            local v263 = v260:GetAttribute("NodeId") or v260:GetAttribute("CoverId");
            v262 = v263 and { "navmesh", "delete", v263 } or { "delete", v260:GetAttribute("World"), v260:GetAttribute("UID") };
        elseif v260:IsA("Vehicle") then
            v262 = { "vehicle", "delete", v260.UID };
        else
            v262 = v260:IsA("Actor") and { "bot", "delete", v260.UID } or v261;
        end;
        if v262 then
            p258:_send(unpack(v262));
        end;
    end;
    l___store__30:dispatch({
        type = "newSelection"
    });
end;
function u21.Toggle(u264) --[[ Line: 1304 ]]
    -- upvalues: u4 (copy), u5 (copy), u9 (copy), u13 (copy), u1 (copy)
    u264.Enabled = not u264.Enabled;
    if u264.Enabled and not u264._controls then
        if not u264._handle then
            u264._handle = u4.mount(u4.createElement(u5.StoreProvider, {
                store = u264._store
            }, u4.createElement(u9, {
                left = u264._left,
                right = u264._right,
                top = u264._top,
                bottom = u264._bottom,
                stations = u264._stations
            })));
        end;
        u264._controls = u13:Connect({
            Select = function(p265) --[[ Name: Select, Line 1321 ]]
                -- upvalues: u264 (copy)
                u264._down = p265;
                if p265 then
                    u264._process = true;
                end;
            end,
            Command = function(p266) --[[ Name: Command, Line 1327 ]]
                -- upvalues: u264 (copy)
                u264._command = p266;
            end,
            Delete = function(p267) --[[ Name: Delete, Line 1330 ]]
                -- upvalues: u264 (copy)
                if p267 then
                    u264:_delete();
                end;
            end,
            Backspace = function(p268) --[[ Name: Backspace, Line 1335 ]]
                -- upvalues: u264 (copy)
                if p268 then
                    u264:_delete();
                end;
            end,
            Fullscreen = function(p269) --[[ Name: Fullscreen, Line 1340 ]]
                -- upvalues: u264 (copy)
                if p269 and not u264._command then
                    u264.Fullscreen = not u264.Fullscreen;
                end;
            end,
            Move = function(p270) --[[ Name: Move, Line 1345 ]]
                -- upvalues: u264 (copy)
                if p270 then
                    u264._store:dispatch({
                        type = "changeTool",
                        tool = 0
                    });
                end;
            end,
            Scale = function(p271) --[[ Name: Scale, Line 1353 ]]
                -- upvalues: u264 (copy)
                if p271 then
                    u264._store:dispatch({
                        type = "changeTool",
                        tool = 1
                    });
                end;
            end,
            Rotate = function(p272) --[[ Name: Rotate, Line 1361 ]]
                -- upvalues: u264 (copy)
                if p272 then
                    u264._store:dispatch({
                        type = "changeTool",
                        tool = 2
                    });
                end;
            end,
            WorldSpace = function(p273) --[[ Name: WorldSpace, Line 1369 ]]
                -- upvalues: u264 (copy)
                if p273 and u264._command then
                    u264._store:dispatch({
                        type = "toggleWorldSpace"
                    });
                end;
            end,
            PropRotate = function(p274) --[[ Name: PropRotate, Line 1376 ]]
                -- upvalues: u264 (copy)
                u264._turn = p274 and 1 or 0;
            end,
            Duplicate = function(p275) --[[ Name: Duplicate, Line 1379 ]]
                -- upvalues: u264 (copy)
                if p275 and u264._command then
                    u264:_duplicate();
                end;
            end,
            Undo = function(p276) --[[ Name: Undo, Line 1384 ]]
                -- upvalues: u264 (copy)
                if p276 and u264._command then
                    u264:_undo();
                end;
            end,
            Redo = function(p277) --[[ Name: Redo, Line 1389 ]]
                -- upvalues: u264 (copy)
                if p277 and u264._command then
                    u264:_redo();
                end;
            end,
            Group = function(p278) --[[ Name: Group, Line 1394 ]]
                -- upvalues: u264 (copy)
                if p278 and u264._command then
                    u264._store:dispatch({
                        type = "createGroup",
                        group = true
                    });
                    u264._store:dispatch({
                        type = "newSelection",
                        selection = {}
                    });
                end;
            end,
            JumpTo = function(p279) --[[ Name: JumpTo, Line 1406 ]]
                -- upvalues: u264 (copy)
                if p279 then
                    u264:_jump();
                end;
            end
        });
        for _, v280 in u264._adornee do
            if v280:IsA("Highlight") then
                v280.Enabled = true;
            else
                v280.Visible = true;
            end;
        end;
        if u264._handleAdnorees then
            for _, v281 in u264._handleAdnorees do
                for v282 in v281.Handles do
                    v282.Visible = true;
                end;
            end;
        end;
    elseif not u264.Enabled and u264._controls then
        u264._controls:Disconnect();
        u264._controls = nil;
        u264.Fullscreen = false;
        for _, v283 in u264._adornee do
            if v283:IsA("Highlight") then
                v283.Enabled = false;
            else
                v283.Visible = false;
            end;
        end;
        if u264._handleAdnorees then
            for _, v284 in u264._handleAdnorees do
                for v285 in v284.Handles do
                    v285.Visible = false;
                end;
            end;
        end;
        if u264._navMeshEditor then
            u264:_send("navmesh", "editor");
        end;
        if u264._handle then
            u4.unmount(u264._handle);
            u264._handle = nil;
        end;
        u1:FireServer("RGEReplication");
    end;
end;
function u21.Update(u286, p287, p288, p289) --[[ Line: 1457 ]]
    -- upvalues: u14 (copy), u18 (copy), u16 (copy), u17 (copy), u3 (copy), u12 (copy), u13 (copy), u15 (copy), l__CurrentCamera__6 (copy), l__UserInputService__3 (copy), l__SoundService__4 (copy), u69 (copy), u10 (copy), u1 (copy)
    local l__Fullscreen__32 = u286.Fullscreen;
    local l___ui__33 = u286._ui;
    local l__Enabled__34 = u286.Enabled;
    if l__Enabled__34 then
        l__Enabled__34 = not l__Fullscreen__32;
    end;
    l___ui__33.Enabled = l__Enabled__34;
    local l___store__35 = u286._store;
    if l___store__35 then
        l___store__35 = u286._store:getState();
    end;
    local v290;
    if l___store__35 then
        v290 = l___store__35.windows[l___store__35.window];
    else
        v290 = l___store__35;
    end;
    if not u286.Enabled then
        for v291, v292 in u14.FrameList do
            v291.Position = UDim2.fromScale(0, 0);
            v291.Size = UDim2.fromScale(1, 1);
            local l__UIVisible__36 = u14.UIVisible;
            if l__UIVisible__36 then
                l__UIVisible__36 = not u14.ExtractionUI;
            end;
            local v293 = not u18.Open or ((u18.UI == v291 or u16.UI == v291) and true or u17.UI == v291);
            if not l__UIVisible__36 and v292 ~= u3.ShellPriority.AlwaysVisible then
                v293 = false;
            end;
            v291.Visible = v293;
        end;
        u12.Channels.Non_diegetic.Volume = 1;
        u13.RGE = false;
        u15.DoLights = true;
        u286.Controls = false;
        if v290 and not v290.Disabled then
            v290.Disabled = true;
            v290:Disable();
        end;
        return;
    end;
    local l__ViewportSize__37 = l__CurrentCamera__6.ViewportSize;
    local v294 = l__UserInputService__3:GetMouseLocation();
    if v290.Disabled then
        v290.Disabled = nil;
        v290:Enable();
    end;
    local l__Resize__38 = u286.Resize;
    if u286._down then
        if l__Resize__38 == "L" then
            u286._panelL = math.clamp(v294.X, 100, l__ViewportSize__37.X - u286._panelR - 100);
        elseif l__Resize__38 == "R" then
            u286._panelR = math.clamp(l__ViewportSize__37.X - v294.X, 100, l__ViewportSize__37.X - u286._panelL - 100);
        elseif l__Resize__38 == "B" then
            u286._panelY = math.clamp(l__ViewportSize__37.Y - v294.Y, 100, l__ViewportSize__37.Y - 130 - 100);
        end;
    else
        local l___panelY__39 = u286._panelY;
        local v295 = nil;
        if v294.Y > 140 and v294.Y < l__ViewportSize__37.Y - 10 - l___panelY__39 then
            local l___panelL__40 = u286._panelL;
            local l___panelR__41 = u286._panelR;
            l__Resize__38 = v294.X > l___panelL__40 - 10 and v294.X < l___panelL__40 + 10 and "L" or (v294.X > l__ViewportSize__37.X - l___panelR__41 - 10 and v294.X < l__ViewportSize__37.X - l___panelR__41 + 10 and "R" or v295);
        else
            l__Resize__38 = v294.Y > l__ViewportSize__37.Y - l___panelY__39 - 10 and v294.Y < l__ViewportSize__37.Y - l___panelY__39 + 10 and "B" or v295;
        end;
    end;
    local l___panelL__42 = u286._panelL;
    local l___panelR__43 = u286._panelR;
    local l___panelY__44 = u286._panelY;
    local v296 = l__ViewportSize__37.X - (l___panelL__42 + l___panelR__43);
    local v297 = l__ViewportSize__37.Y - 130 - l___panelY__44;
    local l__UI__45 = v290.UI;
    if l__UI__45 then
        l__UI__45 = not l__Fullscreen__32;
    end;
    u13.RGE = not v290.UI;
    u15.DoLights = l__Fullscreen__32;
    u286.Viewport = {
        Size = UDim2.fromOffset(v296, v297 - 32),
        Position = UDim2.fromOffset(l___panelL__42, 162)
    };
    u286._left.Size = UDim2.fromOffset(l___panelL__42, v297);
    u286._right.Size = UDim2.fromOffset(l___panelR__43, v297);
    u286._bottom.Size = UDim2.new(1, 0, 0, l___panelY__44);
    u286._stations.Size = UDim2.new(1, -l___panelL__42 - l___panelR__43, 0, 32);
    u286._stations.Position = UDim2.fromOffset(l___panelL__42, 130);
    u286.Resize = l__Resize__38;
    local v298;
    if v294.Y > 162 and (v294.Y < l__ViewportSize__37.Y - u286._panelY and v294.X > u286._panelL) then
        v298 = v294.X < l__ViewportSize__37.X - u286._panelR;
    else
        v298 = false;
    end;
    if u286._command then
        p287 = Vector2.new() or p287;
    end;
    local v299 = v290:Update(p287, Vector3.new(p288.X, p288.Y, v298 and p288.Z or 0), p289);
    l__CurrentCamera__6.CFrame = v299;
    l__SoundService__4:SetListener(u3.ListenerType.CFrame, v299);
    u12.Channels.Non_diegetic.Volume = v290.UI and 1 or 0;
    local l__Viewport__46 = u286.Viewport;
    local l__Position__47 = l__Viewport__46.Position;
    local l__Size__48 = l__Viewport__46.Size;
    if l__Fullscreen__32 then
        l__Position__47 = UDim2.fromScale(0, 0);
        l__Size__48 = UDim2.fromScale(1, 1);
    end;
    for v300, v301 in u14.FrameList do
        v300.Position = l__Position__47;
        v300.Size = l__Size__48;
        local v302;
        if l__UI__45 then
            v302 = u14.UIVisible and not u14.ExtractionUI or v301 == u3.ShellPriority.AlwaysVisible;
        else
            v302 = l__UI__45;
        end;
        v300.Visible = v302;
    end;
    local v303 = l__Fullscreen__32 and v294 and v294 or Vector2.new((v294.X - l__Position__47.X.Offset) / l__Size__48.X.Offset * l__ViewportSize__37.X, (v294.Y - l__Position__47.Y.Offset) / l__Size__48.Y.Offset * l__ViewportSize__37.Y);
    local v304 = nil;
    local l__worldSpace__49 = l___store__35.worldSpace;
    if l__worldSpace__49 then
        l__worldSpace__49 = l___store__35.tool ~= 1;
    end;
    u286._worldSpace = l__worldSpace__49;
    if u286._handleAdnorees then
        local v305 = nil;
        for v306, v307 in u286._handleAdnorees do
            local l__CFrame__50 = v307.Parent.CFrame;
            for v308 in v307.Handles do
                local l__Position__51 = l__CFrame__50:ToWorldSpace(v308.CFrame).Position;
                local v309, v310 = l__CurrentCamera__6:WorldToViewportPoint(l__Position__51);
                if v310 and (Vector2.new(v309.X, v309.Y) - v303).Magnitude <= 50 then
                    local l__Magnitude__52 = (l__CurrentCamera__6.CFrame.Position - l__Position__51).Magnitude;
                    if not v305 or l__Magnitude__52 < v305 then
                        v304 = v306;
                        v305 = l__Magnitude__52;
                    end;
                end;
            end;
        end;
    end;
    u286.Hover = v304 and true or false;
    u286._angle = (u286._angle + u286._turn * p289 * 100) % 360;
    local l___place__53 = u286._place;
    if l___place__53 then
        local v311 = l__CurrentCamera__6:ViewportPointToRay(v303.X, v303.Y, 0);
        local v312 = v311.Origin + v311.Direction * 1000;
        local v313 = workspace:Raycast(v311.Origin, v311.Direction * 1000);
        if v313 then
            v312 = v313.Position;
        end;
        if u286._navMeshEditor and (v313 and (v313.Instance and v313.Instance:GetAttribute("NodeId"))) then
            v312 = v313.Instance.Position;
        end;
        local v314;
        if l___place__53.PrimaryPart then
            v314 = l___place__53.PrimaryPart.Size;
        else
            local v315;
            v315, v314 = l___place__53:GetBoundingBox();
        end;
        local v316 = math.floor(u286._angle / l___store__35.rotate) * l___store__35.rotate;
        local v317 = math.rad(v316);
        u286._placeCFrame = CFrame.new(math.floor(v312.X / l___store__35.move) * l___store__35.move, v312.Y + v314.Y / 2, math.floor(v312.Z / l___store__35.move) * l___store__35.move) * CFrame.Angles(0, v317, 0);
        u286._placeResult = v313;
        u286._place:PivotTo(u286._placeCFrame);
    end;
    if u286._process and not v298 then
        u286._process = false;
    end;
    if u286._process and not l__Resize__38 then
        u286._process = false;
        if u286._place then
            local v318 = not u286._command;
            local v319 = u286._placeFunction(u286._placeCFrame, v318, u286._placeResult);
            if v318 and (u286._place and not v319) then
                u286._place:Destroy();
                u286._place = nil;
                u286._placeFunction = nil;
            end;
        elseif v304 then
            local l__Parent__54 = u286._handleAdnorees[v304].Parent;
            local l__CFrame__55 = l__Parent__54.CFrame;
            if l__worldSpace__49 then
                l__CFrame__55 = CFrame.new(l__CFrame__55.Position);
            end;
            local l__tool__56 = l___store__35.tool;
            local v320 = CFrame.lookAt(l__CFrame__55.Position, l__CFrame__55:PointToWorldSpace(v304));
            local v321 = Ray.new(l__CFrame__55.Position - v320.LookVector * 1000, v320.LookVector);
            local v322 = -v320:PointToObjectSpace((u69(v321, l__CurrentCamera__6:ViewportPointToRay(v303.X, v303.Y, 0)))).Z;
            local l__Direction__57 = u286._handleAdnorees[v304].Direction;
            local v323;
            if l__tool__56 == 2 then
                local v324 = l__CurrentCamera__6:ViewportPointToRay(v303.X, v303.Y, 0);
                local v325 = v324.Origin + v324.Direction * (l__CurrentCamera__6.CFrame.Position - l__CFrame__55.Position).Magnitude;
                local l__Position__58 = l__CFrame__55.Position;
                local v326 = l__CFrame__55:VectorToWorldSpace(l__Direction__57);
                local v327 = l__CFrame__55:PointToObjectSpace(v325 + (l__Position__58 - v325):Dot(v326) / (v326.X ^ 2 + v326.Y ^ 2 + v326.Z ^ 2) * v326);
                if l__Direction__57.Z > 0 then
                    v323 = math.atan2(-v327.Y, -v327.X);
                elseif l__Direction__57.X > 0 then
                    v323 = math.atan2(-v327.Z, -v327.Y);
                else
                    v323 = math.atan2(-v327.X, -v327.Z);
                end;
                if v323 < 0 then
                    v323 = v323 + 6.283185307179586;
                end;
            else
                v323 = nil;
            end;
            local v328 = {};
            for _, v329 in l___store__35.selection do
                if v329:IsA("BasePart") then
                    v328[#v328 + 1] = { v329, v329.CFrame, v329.Size };
                elseif v329:IsA("Model") then
                    local v330 = u286:_singlePartModel(v329);
                    if v330 then
                        v328[#v328 + 1] = { v329, v329.WorldPivot, v330.Size };
                    else
                        local _, v331 = v329:GetBoundingBox();
                        v328[#v328 + 1] = { v329, v329.WorldPivot, v331 };
                    end;
                end;
            end;
            u286._moving = true;
            u286._movingObject = {
                Tool = l__tool__56,
                Objects = v328,
                Look = v320,
                Direction = l__Direction__57,
                Normal = v304,
                BaseDeg = v323,
                BaseDistance = v322,
                BaseRay = v321,
                Plane = l__CFrame__55,
                Parent = l__Parent__54,
                Origin = l__Parent__54.CFrame
            };
        else
            u286._selecting = true;
            u286._selectionStart = { v294.X, v294.Y };
        end;
        u286._processing = true;
    elseif not u286._down and u286._processing then
        u286._processing = false;
        u286._selecting = false;
        u286._moving = false;
    end;
    if u286._moving then
        local l___movingObject__59 = u286._movingObject;
        local v332 = u69(l___movingObject__59.BaseRay, l__CurrentCamera__6:ViewportPointToRay(v303.X, v303.Y, 0));
        local v333 = -l___movingObject__59.Look:PointToObjectSpace(v332).Z - l___movingObject__59.BaseDistance;
        local l__Tool__60 = l___movingObject__59.Tool;
        local l__Normal__61 = l___movingObject__59.Normal;
        if l__Tool__60 == 0 then
            local v334 = l__Normal__61 * (math.floor(v333 / l___store__35.move) * l___store__35.move);
            if not l__worldSpace__49 then
                v334 = l___movingObject__59.Objects[1][2]:VectorToWorldSpace(v334);
            end;
            l___movingObject__59.Parent.CFrame = l___movingObject__59.Origin + v334;
            for _, v335 in l___movingObject__59.Objects do
                if v335[1]:IsA("BasePart") then
                    v335[1].CFrame = v335[2] + v334;
                else
                    v335[1]:PivotTo(v335[2] + v334);
                end;
            end;
        elseif l__Tool__60 == 1 then
            local v336 = math.floor(v333 / l___store__35.move) * l___store__35.move;
            local v337 = math.abs(l__Normal__61.X);
            local v338 = math.abs(l__Normal__61.Y);
            local v339 = math.abs(l__Normal__61.Z);
            local v340 = Vector3.new(v337, v338, v339);
            for _, v341 in l___movingObject__59.Objects do
                if v341[1]:IsA("BasePart") then
                    v341[1].CFrame = v341[2] * CFrame.new(l__Normal__61 * v336 / 2);
                    v341[1].Size = v341[3] + v340 * v336;
                else
                    local v342 = u286:_singlePartModel(v341[1]);
                    if v342 then
                        v342.CFrame = v341[2] * CFrame.new(l__Normal__61 * v336 / 2);
                        v342.Size = v341[3] + v340 * v336;
                    end;
                end;
            end;
        elseif l__Tool__60 == 2 then
            local l__Plane__62 = l___movingObject__59.Plane;
            local l__Direction__63 = l___movingObject__59.Direction;
            local v343 = l__CurrentCamera__6:ViewportPointToRay(v303.X, v303.Y, 0);
            local v344 = v343.Origin + v343.Direction * (l__CurrentCamera__6.CFrame.Position - l__Plane__62.Position).Magnitude;
            local l__Position__64 = l__Plane__62.Position;
            local v345 = l__Plane__62:VectorToWorldSpace(l__Direction__63);
            local v346 = l__Plane__62:PointToObjectSpace(v344 + (l__Position__64 - v344):Dot(v345) / (v345.X ^ 2 + v345.Y ^ 2 + v345.Z ^ 2) * v345);
            math.atan2(-v346.X, -v346.Z);
            local v347;
            if l__Direction__63.Z > 0 then
                v347 = math.atan2(-v346.Y, -v346.X);
            elseif l__Direction__63.X > 0 then
                v347 = math.atan2(-v346.Z, -v346.Y);
            else
                v347 = math.atan2(-v346.X, -v346.Z);
            end;
            if v347 < 0 then
                v347 = v347 + 6.283185307179586;
            end;
            local v348 = math.deg(v347 - l___movingObject__59.BaseDeg) / l___store__35.rotate;
            local v349 = math.floor(v348) * l___store__35.rotate;
            local v350 = l__Normal__61 * math.rad(v349);
            local v351 = CFrame.Angles(v350.X, v350.Y, v350.Z);
            if l__worldSpace__49 then
                l___movingObject__59.Parent.CFrame = v351 * (l___movingObject__59.Origin - l___movingObject__59.Origin.Position) + l___movingObject__59.Origin.Position;
            else
                l___movingObject__59.Parent.CFrame = l___movingObject__59.Origin * v351;
            end;
            for _, v352 in l___movingObject__59.Objects do
                if v352[1]:IsA("BasePart") then
                    if l__worldSpace__49 then
                        v352[1].CFrame = v351 * (v352[2] - v352[2].Position) + v352[2].Position;
                    else
                        v352[1].CFrame = v352[2] * v351;
                    end;
                elseif l__worldSpace__49 then
                    v352[1]:PivotTo(v351 * (v352[2] - v352[2].Position) + v352[2].Position);
                else
                    v352[1]:PivotTo(v352[2] * v351);
                end;
            end;
        end;
    elseif u286._movingObject then
        local l___movingObject__65 = u286._movingObject;
        local l__Tool__66 = l___movingObject__65.Tool;
        local u353 = {};
        for _, v354 in l___movingObject__65.Objects do
            local v355 = v354[1];
            local v356 = u286:_singlePartModel(v355);
            local v357;
            if v356 then
                v357 = v356.CFrame;
            elseif v355:IsA("Model") then
                v357 = v355.WorldPivot;
            else
                v357 = v355.CFrame;
            end;
            local v358 = v355:GetAttribute("NodeId") or v355:GetAttribute("CoverId");
            local v359 = v355:GetAttribute("World");
            local v360 = v355:GetAttribute("UID");
            if v359 and v360 or v358 then
                local v361 = nil;
                if l__Tool__66 == 1 then
                    if v355:IsA("BasePart") then
                        v361 = v355.Size;
                    elseif v356 then
                        v361 = v356.Size;
                    end;
                end;
                u353[#u353 + 1] = {
                    Object = v355,
                    World = v359,
                    UID = v360,
                    NodeId = v358,
                    SinglePartModel = v356,
                    OriginalCFrame = v354[2],
                    OriginalSize = v354[3],
                    CFrame = v357,
                    Size = v361
                };
            end;
        end;
        u286:_addChange("Transform", function() --[[ Line: 1858 ]]
            -- upvalues: u353 (copy), u286 (copy)
            for _, v362 in u353 do
                local v363 = u286:_verifyObject(v362.Object, v362.World, v362.UID, v362.NodeId);
                if v363 then
                    local l__CFrame__67 = v362.CFrame;
                    local l__NodeId__68 = v362.NodeId;
                    local v364, v365, v366 = l__CFrame__67:ToOrientation();
                    if l__NodeId__68 then
                        if tonumber(l__NodeId__68) then
                            v365 = nil;
                        end;
                        local v367 = u286;
                        local v368 = "navmesh";
                        local v369 = "move";
                        local l__X__69 = l__CFrame__67.X;
                        local l__Y__70 = l__CFrame__67.Y;
                        local l__Z__71 = l__CFrame__67.Z;
                        if v365 then
                            v365 = math.deg(v365);
                        end;
                        v367:_send(v368, v369, l__NodeId__68, l__X__69, l__Y__70, l__Z__71, v365);
                    else
                        if v363:IsA("Model") then
                            v363:PivotTo(l__CFrame__67);
                        else
                            v363.CFrame = l__CFrame__67;
                        end;
                        u286:_send("move", v362.World, v362.UID, l__CFrame__67.X, l__CFrame__67.Y, l__CFrame__67.Z, math.deg(v364), math.deg(v365), (math.deg(v366)));
                        if v362.Size then
                            if v362.SinglePartModel then
                                v362.SinglePartModel.Size = v362.Size;
                            else
                                v363.Size = v362.Size;
                            end;
                            u286:_send("size", v362.World, v362.UID, v362.Size.X, v362.Size.Y, v362.Size.Z);
                        end;
                    end;
                end;
            end;
        end, function() --[[ Line: 1895 ]]
            -- upvalues: u353 (copy), u286 (copy)
            for _, v370 in u353 do
                local v371 = u286:_verifyObject(v370.Object, v370.World, v370.UID, v370.NodeId);
                if v371 then
                    local l__OriginalCFrame__72 = v370.OriginalCFrame;
                    local l__NodeId__73 = v370.NodeId;
                    local v372, v373, v374 = l__OriginalCFrame__72:ToOrientation();
                    if l__NodeId__73 then
                        if tonumber(l__NodeId__73) then
                            v373 = nil;
                        end;
                        local v375 = u286;
                        local v376 = "navmesh";
                        local v377 = "move";
                        local l__X__74 = l__OriginalCFrame__72.X;
                        local l__Y__75 = l__OriginalCFrame__72.Y;
                        local l__Z__76 = l__OriginalCFrame__72.Z;
                        if v373 then
                            v373 = math.deg(v373);
                        end;
                        v375:_send(v376, v377, l__NodeId__73, l__X__74, l__Y__75, l__Z__76, v373);
                    else
                        if v371:IsA("Model") then
                            v371:PivotTo(l__OriginalCFrame__72);
                        else
                            v371.CFrame = l__OriginalCFrame__72;
                        end;
                        u286:_send("move", v370.World, v370.UID, l__OriginalCFrame__72.X, l__OriginalCFrame__72.Y, l__OriginalCFrame__72.Z, math.deg(v372), math.deg(v373), (math.deg(v374)));
                        if (v371:IsA("BasePart") or v370.SinglePartModel) and (v370.OriginalSize and v370.Size) then
                            if v370.SinglePartModel then
                                v370.SinglePartModel.Size = v370.OriginalSize;
                            else
                                v371.Size = v370.OriginalSize;
                            end;
                            u286:_send("size", v370.World, v370.UID, v370.OriginalSize.X, v370.OriginalSize.Y, v370.OriginalSize.Z);
                        end;
                    end;
                end;
            end;
        end);
        if l___store__35.selection[1] and (l___store__35.selection[1]:IsA("BasePart") or l___store__35.selection[1]:IsA("Model")) then
            u286:_handles(l___store__35.selection[1], l___store__35.tool);
        else
            u286:_handles();
        end;
        u286._movingObject = nil;
    end;
    local l___selection__77 = u286._selection;
    local v378, v379;
    if u286._selecting then
        local l___selectionStart__78 = u286._selectionStart;
        l___selection__77.Position = UDim2.fromOffset(l___selectionStart__78[1], l___selectionStart__78[2]);
        l___selection__77.Size = UDim2.fromOffset(v294.X - l___selectionStart__78[1], v294.Y - l___selectionStart__78[2]);
        l___selection__77.Visible = true;
    elseif u286._selectionStart then
        local l___selectionStart__79 = u286._selectionStart;
        u286._selectionStart = nil;
        l___selection__77.Visible = false;
        local v380 = l__Fullscreen__32 and Vector2.new(l___selectionStart__79[1], l___selectionStart__79[2]) or Vector2.new((l___selectionStart__79[1] - l__Position__47.X.Offset) / l__Size__48.X.Offset * l__ViewportSize__37.X, (l___selectionStart__79[2] - l__Position__47.Y.Offset) / l__Size__48.Y.Offset * l__ViewportSize__37.Y);
        local v381 = {};
        if (v303 - v380).Magnitude < 5 then
            local v382 = l__CurrentCamera__6:ViewportPointToRay(v303.X, v303.Y, 0);
            local v383 = workspace:Raycast(v382.Origin, v382.Direction * 1000);
            if v383 then
                v383 = v383.Instance;
            end;
            if u286._navMeshEditor then
                if v383 and v383:GetAttribute("NodeId") then
                    v381 = v383;
                elseif v383 and v383:GetAttribute("CoverId") then
                    v381 = v383.Parent;
                elseif u286._command then
                    v381 = nil;
                end;
            elseif v383 and v383:GetAttribute("World") == tostring(l___store__35.id) then
                if v383.Parent:IsA("Model") then
                    v381 = v383.Parent;
                else
                    v381 = v383;
                end;
            else
                local _, v384 = u10:GetFromBodyPart(v383);
                if v384 then
                    v381 = v384.Owner or v384;
                elseif u286._command then
                    v381 = nil;
                end;
            end;
        else
            local v385 = l__CurrentCamera__6:ViewportPointToRay(v380.X, v380.Y, 0);
            local v386 = v385.Origin + v385.Direction * 1000;
            local v387 = workspace:Raycast(v385.Origin, v385.Direction * 1000);
            if v387 then
                v386 = v387.Position;
            end;
            local v388 = l__CurrentCamera__6:ViewportPointToRay(v303.X, v303.Y, 0);
            local v389 = v388.Origin + v388.Direction * 1000;
            local v390 = workspace:Raycast(v388.Origin, v388.Direction * 1000);
            if v390 then
                v389 = v390.Position;
            end;
            local v391 = (v389 - v386).Magnitude / 2;
            if v303.X < v380.X then
                local l__X__80 = v303.X;
                v303 = Vector2.new(v380.X, v303.Y);
                v380 = Vector2.new(l__X__80, v380.Y);
            end;
            if v303.Y < v380.Y then
                local l__Y__81 = v303.Y;
                v303 = Vector2.new(v303.X, v380.Y);
                v380 = Vector2.new(v380.X, l__Y__81);
            end;
            local v392 = workspace:GetPartBoundsInRadius(v386:Lerp(v389, 0.5), v391);
            for _, v393 in workspace:GetPartBoundsInRadius(l__CurrentCamera__6.CFrame.Position + l__CurrentCamera__6.CFrame.LookVector * 75, 100) do
                v392[#v392 + 1] = v393;
            end;
            for _, v394 in v392 do
                local v395 = nil;
                local v396, v397;
                if u286._navMeshEditor then
                    if v394:GetAttribute("CoverId") then
                        v395 = v394.Parent;
                        if not table.find(v381, v395 or v394) then
                            v396, v397 = l__CurrentCamera__6:WorldToViewportPoint(v394.Position);
                            if v397 and (v396.X > v380.X and (v396.X < v303.X and (v396.Y > v380.Y and v396.Y < v303.Y))) then
                                if v395 then
                                    v381[#v381 + 1] = v395;
                                elseif u286._navMeshEditor then
                                    v381[#v381 + 1] = v394;
                                elseif v394.Parent:IsA("Model") then
                                    v381[#v381 + 1] = v394.Parent;
                                else
                                    v381[#v381 + 1] = v394;
                                end;
                            end;
                        end;
                    end;
                    if v394:GetAttribute("NodeId") then
                        if not table.find(v381, v395 or v394) then
                            v396, v397 = l__CurrentCamera__6:WorldToViewportPoint(v394.Position);
                            if v397 and (v396.X > v380.X and (v396.X < v303.X and (v396.Y > v380.Y and v396.Y < v303.Y))) then
                                if v395 then
                                    v381[#v381 + 1] = v395;
                                elseif u286._navMeshEditor then
                                    v381[#v381 + 1] = v394;
                                elseif v394.Parent:IsA("Model") then
                                    v381[#v381 + 1] = v394.Parent;
                                else
                                    v381[#v381 + 1] = v394;
                                end;
                            end;
                        end;
                    end;
                elseif v394:GetAttribute("World") == tostring(l___store__35.id) then
                    if not table.find(v381, v395 or v394) then
                        v396, v397 = l__CurrentCamera__6:WorldToViewportPoint(v394.Position);
                        if v397 and (v396.X > v380.X and (v396.X < v303.X and (v396.Y > v380.Y and v396.Y < v303.Y))) then
                            if v395 then
                                v381[#v381 + 1] = v395;
                            elseif u286._navMeshEditor then
                                v381[#v381 + 1] = v394;
                            elseif v394.Parent:IsA("Model") then
                                v381[#v381 + 1] = v394.Parent;
                            else
                                v381[#v381 + 1] = v394;
                            end;
                        end;
                    end;
                else
                    local _, v398 = u10:GetFromBodyPart(v394);
                    if v398 then
                        v395 = v398.Owner or v398;
                        if not table.find(v381, v395 or v394) then
                            v396, v397 = l__CurrentCamera__6:WorldToViewportPoint(v394.Position);
                            if v397 and (v396.X > v380.X and (v396.X < v303.X and (v396.Y > v380.Y and v396.Y < v303.Y))) then
                                if v395 then
                                    v381[#v381 + 1] = v395;
                                elseif u286._navMeshEditor then
                                    v381[#v381 + 1] = v394;
                                elseif v394.Parent:IsA("Model") then
                                    v381[#v381 + 1] = v394.Parent;
                                else
                                    v381[#v381 + 1] = v394;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        u286._store:dispatch({
            type = "newSelection",
            selection = v381
        });
        u286:_updateHandleAdornees(v304);
        if not l__Fullscreen__32 then
            v378 = l__CurrentCamera__6;
            v378.CFrame = v378.CFrame * u286:_offset(UDim2.fromOffset(v296, v296 * (l__ViewportSize__37.Y / l__ViewportSize__37.X)), UDim2.fromOffset((l___panelL__42 - l___panelR__43) / 2, -((l___panelY__44 - 130 - 32) / 2)));
        end;
        v379 = l__CurrentCamera__6.CFrame.Position;
        u1:FireServer("RGEReplication", v379.X, v379.Y, v379.Z);
    end;
    u286:_updateHandleAdornees(v304);
    if not l__Fullscreen__32 then
        v378 = l__CurrentCamera__6;
        v378.CFrame = v378.CFrame * u286:_offset(UDim2.fromOffset(v296, v296 * (l__ViewportSize__37.Y / l__ViewportSize__37.X)), UDim2.fromOffset((l___panelL__42 - l___panelR__43) / 2, -((l___panelY__44 - 130 - 32) / 2)));
    end;
    v379 = l__CurrentCamera__6.CFrame.Position;
    u1:FireServer("RGEReplication", v379.X, v379.Y, v379.Z);
end;
return u21.new();