-- Services.RGEService.Components.RGEWorldComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local l____RGE__1 = workspace:WaitForChild("__RGE");
local u3 = v1("RGEScrollComponent");
local v4 = u2.Component:extend("RGEWorld");
function v4.init(u5) --[[ Line: 14 ]]
    -- upvalues: l____RGE__1 (copy)
    local u6 = {};
    u5.listeners = {};
    function u5.attachNew(p7) --[[ Line: 17 ]]
        -- upvalues: u6 (copy), u5 (copy), l____RGE__1 (ref)
        for v8 in u6 do
            u6[v8] = nil;
        end;
        local u9 = tostring(p7);
        u5._currentId = u9;
        local l__listeners__2 = u5.listeners;
        for v10 = 1, #l__listeners__2 do
            l__listeners__2[v10]:Disconnect();
        end;
        local u11 = nil;
        local function u19(p12) --[[ Line: 30 ]]
            -- upvalues: u11 (ref), u5 (ref), u6 (ref), u9 (ref)
            if u11 then
                u11:Disconnect();
            end;
            local u13 = {};
            local l__Parts__3 = p12:WaitForChild("Parts");
            local function v15(p14) --[[ Line: 36 ]]
                -- upvalues: u13 (copy)
                u13[p14] = {
                    Icon = "rbxassetid://9676324194",
                    Name = p14.Name
                };
            end;
            local function v17(p16) --[[ Line: 42 ]]
                -- upvalues: u13 (copy)
                u13[p16] = nil;
            end;
            for _, v18 in l__Parts__3:GetChildren() do
                u13[v18] = {
                    Icon = "rbxassetid://9676324194",
                    Name = v18.Name
                };
            end;
            u5.listeners[#u5.listeners + 1] = l__Parts__3.ChildAdded:Connect(v15);
            u5.listeners[#u5.listeners + 1] = l__Parts__3.ChildRemoved:Connect(v17);
            u6[u9] = u13;
        end;
        local v20 = l____RGE__1:FindFirstChild(u9);
        if l____RGE__1:FindFirstChild(u9) then
            u19(v20);
        else
            u11 = l____RGE__1.ChildAdded:Connect(function(p21) --[[ Line: 60 ]]
                -- upvalues: u9 (ref), u19 (copy)
                if p21.Name == u9 then
                    u19(p21);
                end;
            end);
            u5.listeners[#u5.listeners + 1] = u11;
        end;
    end;
    u5.attachNew(u5.props.id);
    u5:setState({
        worlds = u6
    });
end;
function v4.willUnmount(p22) --[[ Line: 75 ]]
    local l__listeners__4 = p22.listeners;
    for v23 = 1, #l__listeners__4 do
        l__listeners__4[v23]:Disconnect();
    end;
end;
function v4.render(p24) --[[ Line: 82 ]]
    -- upvalues: u2 (copy), u3 (copy)
    if p24.props.id ~= p24._currentId then
        p24.attachNew(p24.props.id);
    end;
    return u2.createElement(u3, {
        instanceCount = true,
        data = p24.state.worlds,
        selection = p24.props.selection,
        newSelection = p24.props.newSelection
    });
end;
return v4;