-- Services.PrefabService.ServerDoorPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _, u2 = shared.import("require", "asset", "Enum");
local l__TweenService__1 = game:GetService("TweenService");
local u3 = v1("SoundService");
local u4 = {};
u4.__index = u4;
function u4._toggle(p5, p6) --[[ Line: 10 ]]
    -- upvalues: u3 (copy)
    local _ = p5.isOpen;
    p5._lastUsed = tick();
    p5._isOpen = p6;
    local l___sound__2 = p5._sound;
    if l___sound__2 then
        local l___primary__3 = p5._primary;
        if l___primary__3 and l___primary__3:IsDescendantOf(workspace) then
            if p6 and not p5._isOpen then
                u3:CreateSound("World", l___primary__3, true, "ServerDoor", l___sound__2, "Open").Destroy(10);
            end;
        end;
    end;
end;
function u4.new(u7) --[[ Line: 30 ]]
    -- upvalues: u4 (copy)
    local v8 = {
        _isOpen = false,
        _lastUsed = 0,
        Model = u7,
        _tweens = {},
        _sound = u7:GetAttribute("Sound"),
        _timer = u7:GetAttribute("Timer") or 1
    };
    local u9 = setmetatable(v8, u4);
    for _, v10 in u7:GetChildren() do
        local l__PrimaryPart__4 = v10.PrimaryPart;
        for _, v11 in v10:GetChildren() do
            v11.CanCollide = true;
            v11.CanQuery = true;
            v11.CanTouch = true;
        end;
        u9._primary = l__PrimaryPart__4;
        u9._tweens[l__PrimaryPart__4] = {
            Home = l__PrimaryPart__4:GetAttribute("Home"),
            Goal = l__PrimaryPart__4:GetAttribute("Goal")
        };
    end;
    u9._connection = u7:GetAttributeChangedSignal("Open"):Connect(function() --[[ Line: 56 ]]
        -- upvalues: u9 (copy), u7 (copy)
        u9:_toggle(u7:GetAttribute("Open"));
    end);
    if u7:GetAttribute("Open") then
        u9:_toggle(true);
    end;
    return u9;
end;
function u4.Update(p12) --[[ Line: 66 ]]
    -- upvalues: l__TweenService__1 (copy), u2 (copy)
    local v13 = tick();
    if v13 < p12._lastUsed + p12._timer then
        local v14 = (v13 - p12._lastUsed) / p12._timer;
        if not p12._isOpen then
            v14 = 1 - v14;
        end;
        local v15 = l__TweenService__1:GetValue(v14, u2.EasingStyle.Sine, u2.EasingDirection.InOut);
        for v16, v17 in p12._tweens do
            v16:PivotTo(v17.Home:Lerp(v17.Goal, v15));
        end;
        p12._awake = true;
    else
        if p12._awake then
            for v18, v19 in p12._tweens do
                v18:PivotTo(p12._isOpen and v19.Goal or v19.Home);
            end;
            p12._awake = false;
        end;
    end;
end;
function u4.Destroy(p20) --[[ Line: 89 ]]
    p20._tweens = nil;
    p20._connection:Disconnect();
end;
return u4;