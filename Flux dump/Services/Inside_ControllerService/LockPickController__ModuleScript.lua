-- Services.ControllerService.LockPickController
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4 = shared.import("require", "network", "Enum", "Roact");
local u5 = v1("InputService");
local u6 = v1("SoundService");
local u7 = v1("RoactTween");
local u8 = v1("InterfaceService");
local u9 = v1("LockPickComponent");
local l__Debris__1 = game:GetService("Debris");
local u10 = {};
u10.__index = u10;
function u10.new(p11, p12, p13, u14) --[[ Line: 19 ]]
    -- upvalues: u4 (copy), u7 (copy), u9 (copy), u8 (copy), u10 (copy), u5 (copy), u2 (copy), l__Debris__1 (copy), u6 (copy), u3 (copy)
    local v15, v16 = u4.createBinding(0);
    local v17, v18 = u4.createBinding(0);
    local v19, v20 = u4.createBinding(Color3.new(1, 1, 1));
    local v21, u22 = u4.createBinding(0);
    local u23 = {};
    for v24 = 1, 6 do
        u23[v24] = u7.new(0);
    end;
    local v25 = {
        _cancelled = false,
        _speed = 5,
        _lastTick = 0,
        _picks = 0,
        _at = 0,
        _localActor = p11,
        _cframe = p12,
        _expires = p13,
        _start = workspace:GetServerTimeNow(),
        _color = Color3.new(1, 1, 1),
        _updateTimer = v16,
        _updateCursor = v18,
        _updateColor = v20,
        _handle = u4.mount(u4.createElement(u9, {
            Timer = v15,
            Cursor = v17,
            Color = v19,
            Pick = v21,
            Scale = u14,
            Pins = u23
        }), u8.ControllerFrame)
    };
    local u26 = setmetatable(v25, u10);
    u26._controls = u5:Connect({
        Cancel = function(p27) --[[ Name: Cancel, Line 55 ]]
            -- upvalues: u5 (ref), u26 (copy), u2 (ref)
            if p27 and not (u5.PauseOpen or u26._cancelled) then
                u26._cancelled = true;
                u2:FireServer("ActivateInteract", "Exit");
            end;
        end,
        PickLock = function(p28) --[[ Name: PickLock, Line 61 ]]
            -- upvalues: u5 (ref), u26 (copy), u14 (copy), l__Debris__1 (ref), u6 (ref), u22 (copy), u23 (copy), u2 (ref)
            if p28 and not (u5.PauseOpen or u26._cancelled) then
                local v29 = tick();
                if v29 < u26._lastTick then
                    return;
                end;
                u26._lastTick = v29 + 0.5;
                local v30 = math.sin(u26._at) / 2 + 0.5;
                if 0.45 - u14 / 2 <= v30 and v30 <= u14 / 2 + 0.55 then
                    u26._speed = math.random(35, 70) / 10;
                    l__Debris__1:AddItem(u6:CreateSound("Character", nil, true, "LockPick", "Success").Sound, 2);
                    u26._picks = math.clamp(u26._picks + 1, 0, 6);
                    u26._color = Color3.new(0, 1, 0);
                else
                    l__Debris__1:AddItem(u6:CreateSound("Character", nil, true, "LockPick", "Error").Sound, 2);
                    u26._picks = math.clamp(u26._picks - 1, 0, 6);
                    u26._color = Color3.new(1, 0, 0);
                end;
                u22(u26._picks);
                for v31 = 1, #u23 do
                    u23[v31]:SetGoal(u26._picks == v31 and 1 or (v31 < u26._picks and 0.8 or 0));
                end;
                if u26._picks == 6 then
                    u26._cancelled = true;
                    u2:FireServer("ActivateInteract", "Picked");
                end;
            end;
        end
    });
    p11:State("LockPick", true);
    p11.HeightState = u3.CharacterHeightState.Crouching;
    return u26;
end;
function u10.Update(p32, _, p33) --[[ Line: 99 ]]
    local l___localActor__2 = p32._localActor;
    local v34 = l___localActor__2.CFrame:Lerp(p32._cframe, p33 * 5);
    local _, v35 = v34:ToOrientation();
    l___localActor__2.SimulatedPosition = v34.Position;
    l___localActor__2.Orientation = v35;
    l___localActor__2.Focused = true;
    p32._at = p32._at + p33 * p32._speed;
    p32._color = p32._color:Lerp(Color3.new(1, 1, 1), p33 * 5);
    p32._updateColor(p32._color);
    p32._updateCursor(math.sin(p32._at) / 2 + 0.5);
    p32._updateTimer((workspace:GetServerTimeNow() - p32._start) / (p32._expires - p32._start));
end;
function u10.Destroy(p36) --[[ Line: 114 ]]
    -- upvalues: u3 (copy), u4 (copy)
    p36._controls:Disconnect();
    p36._localActor:State("LockPick", false);
    p36._localActor.HeightState = u3.CharacterHeightState.Standing;
    u4.unmount(p36._handle);
end;
return u10;