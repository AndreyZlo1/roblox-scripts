-- Services.RGEService.Components.RGEVehicleComponent
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2 = shared.import("require", "Roact");
local u3 = v1("VehicleService");
local u4 = v1("RGEScrollComponent");
local v5 = u2.Component:extend("RGEVehicle");
local u6 = {
    Ground = "rbxassetid://9682135051",
    Helicopter = "rbxassetid://9682144776",
    Aircraft = "rbxassetid://9682422875"
};
function v5.init(u7) --[[ Line: 21 ]]
    -- upvalues: u3 (copy), u6 (copy)
    local function v10() --[[ Line: 22 ]]
        -- upvalues: u3 (ref), u6 (ref), u7 (copy)
        local v8 = {
            Ground = {},
            Helicopter = {},
            Aircraft = {}
        };
        for _, v9 in u3.Vehicles do
            if not v9.IsElevator then
                v8[v9.VehicleType][v9] = {
                    Name = v9._vehicleName,
                    Icon = u6[v9.VehicleType]
                };
            end;
        end;
        u7:setState({
            vehicles = v8
        });
    end;
    u7._change = u3.Changed:Connect(v10);
    v10();
end;
function v5.willUnmount(p11) --[[ Line: 49 ]]
    p11._change:Disconnect();
end;
function v5.render(p12) --[[ Line: 53 ]]
    -- upvalues: u2 (copy), u4 (copy)
    return u2.createElement(u4, {
        data = p12.state.vehicles,
        selection = p12.props.selection,
        newSelection = p12.props.newSelection
    });
end;
return v5;