-- Services.PrefabService.ElevatorPrefab
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, _, u2, u3 = shared.import("require", "asset", "Enum", "frc");
local u4 = v1("SoundService");
local u5 = v1("VehicleService");
local u6 = v1("NumberTween");
local u7 = v1("Mathf");
local u8 = {};
u8.__index = u8;
function u8._makeDoors(p9, p10, p11) --[[ Line: 12 ]]
    for _, v12 in p10:GetChildren() do
        v12.CanCollide = true;
        v12.CanTouch = true;
        v12.CanQuery = true;
        v12.AudioCanCollide = true;
        if v12.Name == "Door" then
            local v13 = v12:FindFirstChildWhichIsA("Weld");
            local v14 = v12:GetAttribute("From");
            local v15 = v12:GetAttribute("To");
            p9._doors[p11][#p9._doors[p11] + 1] = {
                Weld = v13,
                From = v14,
                To = v15
            };
        end;
    end;
end;
function u8.new(p16) --[[ Line: 32 ]]
    -- upvalues: u6 (copy), u2 (copy), u8 (copy), u5 (copy)
    local l__Shaft__1 = p16:WaitForChild("Shaft");
    local l__PrimaryPart__2 = l__Shaft__1.PrimaryPart;
    local v17 = p16:GetAttribute("Top") or false;
    local v18 = p16:GetAttribute("Time") or 5;
    local v19 = p16:GetAttribute("DoorTime") or 2;
    local v20 = u6.new(v17 and 1 or 0, TweenInfo.new(v19, u2.EasingStyle.Quad, u2.EasingDirection.InOut, 0, false, 0));
    local v21 = u6.new(v17 and 0 or 1, TweenInfo.new(v19, u2.EasingStyle.Quad, u2.EasingDirection.InOut, 0, false, 0));
    local v22 = u6.new(1, TweenInfo.new(v19, u2.EasingStyle.Quad, u2.EasingDirection.InOut, 0, false, 0));
    local v23 = {
        IsElevator = true,
        _lerp = 0,
        _loaded = false,
        UID = p16.Name,
        Model = l__Shaft__1,
        CFrame = l__PrimaryPart__2.CFrame,
        Main = p16.Main,
        From = l__PrimaryPart__2.CFrame,
        To = l__PrimaryPart__2:WaitForChild("Goal").WorldCFrame,
        _timer = v18,
        _origin = p16.PrimaryPart.CFrame.Position,
        _doors = {
            Shaft = {},
            From = {},
            To = {}
        },
        _sound = p16:GetAttribute("Sound") or "Modern",
        _model = p16,
        _shaftMain = l__PrimaryPart__2,
        _place = v17 and 2 or 1,
        _doorTween = v22,
        _fromTween = v21,
        _toTween = v20
    };
    local v24 = setmetatable(v23, u8);
    local v25 = p16:FindFirstChild("Wheel");
    if v25 then
        v24._wheel = v25;
        v24._wheelCFrame = v25.CFrame;
    end;
    v24:_makeDoors(l__Shaft__1, "Shaft");
    if p16:GetAttribute("From") then
        v24:_makeDoors(p16:WaitForChild("From"), "From");
    end;
    if p16:GetAttribute("To") then
        v24:_makeDoors(p16:WaitForChild("To"), "To");
    end;
    u5:RegisterElevator(v24.UID, v24);
    return v24;
end;
function u8.Button(p26, p27) --[[ Line: 94 ]]
    -- upvalues: u4 (copy)
    if p26._loaded then
        if p27 == 0 then
            for _, v28 in p26._shaftMain:GetChildren() do
                if v28.Name == "Button" then
                    u4:CreateSound("World", v28, true, "Foley", "Elevator", p26._sound, "Button").Destroy(4);
                end;
            end;
        else
            for _, v29 in p26.Main:GetChildren() do
                if v29.Name == "To" and p27 == 2 or v29.Name == "From" and p27 == 1 then
                    u4:CreateSound("World", v29, true, "Foley", "Elevator", p26._sound, "Button").Destroy(4);
                end;
            end;
        end;
    end;
end;
function u8.Move(u30) --[[ Line: 116 ]]
    -- upvalues: u4 (copy)
    if u30._loaded then
        u4:CreateSound("World", u30._shaftMain, true, "Foley", "Elevator", u30._sound, "ElevatorStart").Destroy(u30._timer + 5);
        local u31 = u4:CreateSound("World", u30._shaftMain, true, "Foley", "Elevator", u30._sound, "ElevatorMoveLoop");
        u31.Sound.Looping = true;
        u31.Sound.TimePosition = Random.new():NextNumber(0, u31.Sound.TimeLength);
        u31.Sound.Volume = 0;
        u30._move = u31.Sound;
        task.delay(u30._timer, function() --[[ Line: 130 ]]
            -- upvalues: u4 (ref), u30 (copy), u31 (copy)
            u4:CreateSound("World", u30._shaftMain, true, "Foley", "Elevator", u30._sound, "ElevatorStop").Destroy(u30._timer + 5);
            u4:CreateSound("World", u30.Main[(u30._place == 1 and "From" or "To") .. "Sound"], true, "Foley", "Elevator", u30._sound, "Beep").Destroy(4);
            u31.Destroy();
            u30._move = nil;
        end);
    end;
end;
function u8.Door(p32, p33) --[[ Line: 142 ]]
    -- upvalues: u4 (copy)
    if p33 == 0 then
        p32._doorTween:SetGoal(0);
        p32._fromTween:SetGoal(0);
        p32._toTween:SetGoal(0);
        u4:CreateSound("World", p32.Main[(p32._place == 1 and "From" or "To") .. "Sound"], true, "Foley", "Elevator", p32._sound, "DoorClose").Destroy(4);
    elseif p33 == 1 then
        p32._doorTween:SetGoal(1);
        p32._fromTween:SetGoal(1);
        p32._toTween:SetGoal(0);
        u4:CreateSound("World", p32.Main.FromSound, true, "Foley", "Elevator", p32._sound, "DoorOpen").Destroy(4);
        p32._place = 1;
    else
        if p33 == 2 then
            p32._doorTween:SetGoal(1);
            p32._fromTween:SetGoal(0);
            p32._toTween:SetGoal(1);
            u4:CreateSound("World", p32.Main.ToSound, true, "Foley", "Elevator", p32._sound, "DoorOpen").Destroy(4);
            p32._place = 2;
        end;
    end;
end;
function u8.Destroy(p34) --[[ Line: 171 ]]
    -- upvalues: u5 (copy)
    u5:UnregisterElevator(p34.UID);
end;
function u8.Update(p35, p36, p37) --[[ Line: 175 ]]
    -- upvalues: u7 (copy), u3 (copy)
    local v38 = p35._model:GetAttribute("Lerp") or 0;
    p35._lerp = u7.Lerp(p35._lerp, v38, u3(p36 * 10));
    local l___wheel__3 = p35._wheel;
    if l___wheel__3 then
        l___wheel__3.CFrame = p35._wheelCFrame * CFrame.Angles(p35._lerp * 20, 0, 0);
    end;
    if (p37 - p35._origin).Magnitude <= 256 then
        p35._loaded = true;
        local l___doorTween__4 = p35._doorTween;
        for _, v39 in p35._doors.Shaft do
            v39.Weld.C0 = v39.From:Lerp(v39.To, l___doorTween__4:GetValue());
        end;
        local l___fromTween__5 = p35._fromTween;
        for _, v40 in p35._doors.From do
            v40.Weld.C0 = v40.From:Lerp(v40.To, l___fromTween__5:GetValue());
        end;
        local l___toTween__6 = p35._toTween;
        for _, v41 in p35._doors.To do
            v41.Weld.C0 = v41.From:Lerp(v41.To, l___toTween__6:GetValue());
        end;
        if p35._move then
            p35._move.Volume = math.sin(p35._lerp * 3.141592653589793) + 0.2;
        end;
        local v42 = p35.From:Lerp(p35.To, p35._lerp);
        p35.CFrame = v42;
        return p35._shaftMain, v42;
    end;
    p35._loaded = false;
end;
return u8;