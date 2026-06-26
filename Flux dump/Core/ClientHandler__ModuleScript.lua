-- Core.ClientHandler
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3, u4, u5, u6 = shared.import("require", "network", "server", "asset", "frc", "signal");
v1("LandingInterface");
local u7 = v1("PopupInterface");
local u8 = v1("formatNumber");
local u9 = v1("VehicleButtonInterface");
local u10 = v1("GameShellProxyService");
local u11 = v1("PostProcessingService");
local u12 = v1("EnvironmentService");
local u13 = v1("ControllerService");
local u14 = v1("ReplicatorService");
local u15 = v1("ViewmodelService");
local u16 = v1("InterfaceService");
local u17 = v1("InventoryService");
local u18 = v1("TrajectoryService");
local u19 = v1("AnimationService");
local u20 = v1("VehicleService");
local u21 = v1("EffectsService");
local u22 = v1("CameraService");
local u23 = v1("PrefabService");
local u24 = v1("ReticleService");
local u25 = v1("InputService");
local u26 = v1("DebugService");
local u27 = v1("StatsService");
local u28 = v1("SoundService");
local u29 = v1("BlockService");
local u30 = v1("ChunkService");
local u31 = v1("ClientService");
local u32 = v1("SubStepper");
local u33 = v1("RGEService");
local u34 = v1("OverlayInterface");
local u35 = v1("ExtractionOverlay");
local u36 = v1("LensFlareManager");
local u37 = v1("ActionInterface");
local u38 = v1("CameraShakePresets");
local u39 = v1("WaveCalculator");
local u40 = v1("GameSettings");
local u41 = v1("GameSettingsTemplate");
local l__Players__1 = game:GetService("Players");
local l__RunService__2 = game:GetService("RunService");
local l__StarterGui__3 = game:GetService("StarterGui");
local l__UserInputService__4 = game:GetService("UserInputService");
local l__LocalPlayer__5 = l__Players__1.LocalPlayer;
local l__PlayerGui__6 = l__LocalPlayer__5:WaitForChild("PlayerGui");
local u42 = l__RunService__2:IsStudio();
local u43 = 240;
local u44 = 240;
local l__Z__7 = Enum.KeyCode.Z;
u26:Slider("Override Frame Rate", u43, 0.5, 2000, nil, function(p45) --[[ Line: 71 ]]
    -- upvalues: u43 (ref)
    u43 = p45;
end);
u26:Slider("Override Frame Simulation Time", u44, 0.5, 2000, nil, function(p46) --[[ Line: 72 ]]
    -- upvalues: u44 (ref)
    u44 = p46;
end);
local u47 = {};
u47.__index = u47;
function u47.new() --[[ Line: 78 ]]
    -- upvalues: u4 (copy), u26 (copy), u47 (copy), u32 (copy), u43 (ref), u5 (copy), u44 (ref), u42 (copy), l__Z__7 (copy), l__UserInputService__4 (copy), l__RunService__2 (copy), u25 (copy), u22 (copy), u14 (copy), u10 (copy), u15 (copy), u17 (copy), u16 (copy), u24 (copy), u33 (copy), u21 (copy), u36 (copy), u9 (copy), u19 (copy), u13 (copy), u20 (copy), u30 (copy), u12 (copy), u28 (copy), u18 (copy), u23 (copy), u11 (copy), u39 (copy), u29 (copy), u27 (copy), l__StarterGui__3 (copy), u2 (copy), u41 (copy), u40 (copy), u31 (copy), u7 (copy), u8 (copy), u37 (copy), u38 (copy), u3 (copy), l__LocalPlayer__5 (copy), u6 (copy), u34 (copy), u35 (copy), l__PlayerGui__6 (copy)
    u4.Debugger = u26;
    local v48 = Instance.new("ScreenGui");
    v48.DisplayOrder = 9999;
    local u49 = Instance.new("TextBox");
    u49.Parent = v48;
    u49.Size = UDim2.fromScale(0.9, 0.05);
    u49.Position = UDim2.fromScale(0.05, 0.9);
    u49.PlaceholderColor3 = Color3.new(0.5, 0.5, 0.5);
    u49.PlaceholderText = "Enter command here";
    u49.BackgroundColor3 = Color3.new();
    u49.BorderSizePixel = 0;
    u49.TextXAlignment = Enum.TextXAlignment.Left;
    u49.TextScaled = true;
    u49.TextColor3 = Color3.new(1, 1, 1);
    u49.Text = "";
    local u50 = setmetatable({}, u47);
    local u51 = 0;
    local u52 = nil;
    local l__PreRender__8 = l__RunService__2.PreRender;
    local function u56(_, _, p53) --[[ Line: 121 ]]
        -- upvalues: u25 (ref), u52 (ref), u50 (copy), u22 (ref), u14 (ref), u51 (ref), u10 (ref), u15 (ref), u17 (ref), u16 (ref), u24 (ref), u33 (ref), u21 (ref), u36 (ref), u9 (ref)
        local v54 = u25:GetCameraMovement();
        local v55 = u25:GetInputMovement();
        u52 = v54;
        if u25.RGE then
            u50._movementInput = Vector2.zero;
            u52 = Vector3.new(0, 0, 0);
        else
            u50._movementInput = v55;
        end;
        debug.profilebegin("CameraUpdate");
        u22:Update(u52, p53);
        debug.profileend();
        debug.profilebegin("ReplicatorService");
        u14:Update(p53);
        debug.profileend();
        debug.profilebegin("CameraRender");
        u22:Render(p53, u51);
        debug.profileend();
        debug.profilebegin("GameShellProxyStage1");
        u10:UpdateStage1(p53);
        debug.profileend();
        debug.profilebegin("Viewmodel");
        u15:Update(p53);
        debug.profileend();
        debug.profilebegin("InventoryService");
        u17:Update(p53);
        debug.profileend();
        debug.profilebegin("InterfaceService");
        u16:Update(u52, p53);
        debug.profileend();
        debug.profilebegin("GameShellProxyStage2");
        u10:UpdateStage2(p53);
        debug.profileend();
        debug.profilebegin("ReticleService");
        u24:Update(p53);
        debug.profileend();
        debug.profilebegin("ReplicatorService");
        u14:Render(p53);
        debug.profileend();
        debug.profilebegin("RGEService");
        u33:Update(v55, v54, p53);
        debug.profileend();
        debug.profilebegin("EffectsService");
        u21:Update(p53);
        debug.profileend();
        debug.profilebegin("LensFlareManager");
        u36:Update(p53);
        debug.profileend();
        u9:Update(p53);
    end;
    local function u57(_) --[[ Line: 186 ]] end;
    local u58 = u32.new(u43, 1);
    u58:ToggleAccumulator(false);
    local u59 = true;
    l__PreRender__8:Connect(function(p60) --[[ Line: 106 ]]
        -- upvalues: u5 (ref), u58 (copy), u43 (ref), u44 (ref), u59 (copy), u42 (ref), l__Z__7 (ref), l__UserInputService__4 (ref), u56 (copy), u57 (copy)
        local v61 = u5(p60);
        u58:SetRate(u43);
        u58:SetTimeDilation(u44);
        local v62 = u58;
        local v63 = u59 and (u42 and l__Z__7);
        if v63 then
            v63 = l__UserInputService__4:IsKeyDown(l__Z__7);
        end;
        v62:ToggleSubbing(v63);
        local v64 = u58;
        local v65 = u56;
        local v66 = nil;
        local v67 = u57;
        if v67 then
            v67 = u57(v61);
        end;
        if u59 or not v61 then
            v61 = nil;
        end;
        v64:Step(v65, v66, v67, v61);
    end);
    local l__PreSimulation__9 = l__RunService__2.PreSimulation;
    local function u69(_, _, p68) --[[ Line: 191 ]]
        -- upvalues: u14 (ref), u15 (ref)
        debug.profilebegin("ReplicatorService");
        u14:Stepped(p68);
        debug.profileend();
        debug.profilebegin("ViewmodelService");
        u15:Stepped(p68);
        debug.profileend();
    end;
    local function u70(_) --[[ Line: 199 ]] end;
    local u71 = u32.new(u43, 1);
    u71:ToggleAccumulator(false);
    local u72 = true;
    l__PreSimulation__9:Connect(function(p73) --[[ Line: 106 ]]
        -- upvalues: u5 (ref), u71 (copy), u43 (ref), u44 (ref), u72 (copy), u42 (ref), l__Z__7 (ref), l__UserInputService__4 (ref), u69 (copy), u70 (copy)
        local v74 = u5(p73);
        u71:SetRate(u43);
        u71:SetTimeDilation(u44);
        local v75 = u71;
        local v76 = u72 and (u42 and l__Z__7);
        if v76 then
            v76 = l__UserInputService__4:IsKeyDown(l__Z__7);
        end;
        v75:ToggleSubbing(v76);
        local v77 = u71;
        local v78 = u69;
        local v79 = nil;
        local v80 = u70;
        if v80 then
            v80 = u70(v74);
        end;
        if u72 or not v74 then
            v74 = nil;
        end;
        v77:Step(v78, v79, v80, v74);
    end);
    local l__PostSimulation__10 = l__RunService__2.PostSimulation;
    local function u84(_, _, p81) --[[ Line: 204 ]]
        -- upvalues: u51 (ref), u19 (ref), u50 (copy), u13 (ref), u20 (ref), u30 (ref), u12 (ref), u14 (ref), u28 (ref), u18 (ref), u23 (ref), u11 (ref), u39 (ref), u29 (ref), u36 (ref), u27 (ref), l__StarterGui__3 (ref), u49 (copy)
        u51 = p81;
        debug.profilebegin("AnimationService");
        u19:Update(p81);
        debug.profileend();
        debug.profilebegin("ControllerService");
        u13:Simulated(u50._movementInput, p81);
        debug.profileend();
        debug.profilebegin("VehicleService");
        u20:Simulated(p81);
        debug.profileend();
        debug.profilebegin("ChunkService");
        u30:Update(p81);
        debug.profileend();
        debug.profilebegin("EnvironmentUpdate");
        u12:Update(p81, u14.LocalActor);
        debug.profileend();
        debug.profilebegin("SoundService");
        u28:Update(p81);
        debug.profileend();
        debug.profilebegin("TrajectoryService");
        u18:Update(p81);
        debug.profileend();
        debug.profilebegin("PrefabService");
        u23:Update(p81);
        debug.profileend();
        debug.profilebegin("PostProcessingService");
        u11:Update(p81);
        debug.profileend();
        debug.profilebegin("WaveCalculator");
        u39:Update();
        debug.profileend();
        debug.profilebegin("BlockService");
        u29:Update();
        debug.profileend();
        debug.profilebegin("LensFlareManager");
        u36:Compute(p81);
        debug.profileend();
        u27:Update();
        local v82, v83 = pcall(l__StarterGui__3.GetCore, l__StarterGui__3, "DevConsoleVisible");
        u49.Visible = v82 and v83;
    end;
    local function u85(_) --[[ Line: 260 ]] end;
    local u86 = u32.new(u43, 1);
    u86:ToggleAccumulator(false);
    local u87 = true;
    l__PostSimulation__10:Connect(function(p88) --[[ Line: 106 ]]
        -- upvalues: u5 (ref), u86 (copy), u43 (ref), u44 (ref), u87 (copy), u42 (ref), l__Z__7 (ref), l__UserInputService__4 (ref), u84 (copy), u85 (copy)
        local v89 = u5(p88);
        u86:SetRate(u43);
        u86:SetTimeDilation(u44);
        local v90 = u86;
        local v91 = u87 and (u42 and l__Z__7);
        if v91 then
            v91 = l__UserInputService__4:IsKeyDown(l__Z__7);
        end;
        v90:ToggleSubbing(v91);
        local v92 = u86;
        local v93 = u84;
        local v94 = nil;
        local v95 = u85;
        if v95 then
            v95 = u85(v89);
        end;
        if u87 or not v89 then
            v89 = nil;
        end;
        v92:Step(v93, v94, v95, v89);
    end);
    u2:ConnectEvents({
        Debug = function(p96) --[[ Name: Debug, Line 265 ]]
            -- upvalues: u26 (ref)
            u26:Print(p96, Color3.new());
        end,
        UpdateSettings = function(p97) --[[ Name: UpdateSettings, Line 268 ]]
            -- upvalues: u28 (ref), u41 (ref), u40 (ref), u25 (ref)
            for v98, v99 in p97.Volume do
                u28:SetChannelVolume(v98, v99);
            end;
            for v100, v101 in u41 do
                u40[v100] = p97.Settings[v100] or (type(v101[1]) == "number" and (v101[1] or 1) or 1);
            end;
            u25.Overrides = {};
            for v102, v103 in p97.Keybinds do
                u25.Overrides[v102] = {
                    KeyCode = Enum.KeyCode[v103.Key],
                    InputType = Enum.UserInputType[v103.Input]
                };
            end;
            u25.BindingsChanged:Fire();
            u40.LoadoutBackground = p97.LoadoutBackground;
        end,
        UpdateLoadouts = function(p104, p105, p106) --[[ Name: UpdateLoadouts, Line 287 ]]
            -- upvalues: u31 (ref)
            u31.LocalClient.Unlocked = p104;
            u31.LocalClient.ActiveLoadout = p106;
            u31.LocalClient.Loadouts = p105;
        end,
        UpdateSurvivor = function(p107, p108, p109) --[[ Name: UpdateSurvivor, Line 294 ]]
            -- upvalues: u31 (ref)
            u31.LocalClient.CombatLogged = p108;
            u31.LocalClient.FreeToken = p109;
            u31.LocalClient.Survivor = p107;
        end,
        ReturnServer = function() --[[ Name: ReturnServer, Line 299 ]]
            -- upvalues: u7 (ref), u2 (ref)
            u7:Open("Return to Openworld", "Are you sure you want to return to your previous openworld server?", {
                { "Yes", function() --[[ Line: 301 ]]
                        -- upvalues: u2 (ref), u7 (ref)
                        u2:FireServer("ReturnServer");
                        u7:Close();
                    end },
                { "Cancel", function() --[[ Line: 305 ]]
                        -- upvalues: u7 (ref)
                        u7:Close();
                    end }
            });
        end,
        AmmoRefillPaid = function(p110, p111, p112) --[[ Name: AmmoRefillPaid, Line 310 ]]
            -- upvalues: u7 (ref), u8 (ref), u2 (ref)
            u7:Open("Purchase " .. p110 .. " Refill", p111, {
                { "Yes (" .. u8(p112) .. ")", function() --[[ Line: 312 ]]
                        -- upvalues: u2 (ref), u7 (ref)
                        u2:FireServer("ActivateInteract", "Confirm");
                        u7:Close();
                    end },
                { "Cancel", function() --[[ Line: 316 ]]
                        -- upvalues: u2 (ref), u7 (ref)
                        u2:FireServer("ActivateInteract", "Exit");
                        u7:Close();
                    end }
            });
        end,
        HitEffect = function(p113) --[[ Name: HitEffect, Line 322 ]]
            -- upvalues: u37 (ref), u21 (ref), u38 (ref), u28 (ref)
            u37:Hit(p113 > 0);
            if p113 < 0 then
            else
                u21.Camera:Shake(u38.Bump, p113 > 0 and 3 or 1);
                u28:CreateSound("Character", nil, true, "HitSounds", "FP", p113 == 0 and "Bullet" or (p113 == 1 and "Zombie" or "Melee")).Destroy(10);
            end;
        end,
        HitSlowness = function(p114) --[[ Name: HitSlowness, Line 331 ]]
            -- upvalues: u14 (ref)
            local l__LocalActor__11 = u14.LocalActor;
            if l__LocalActor__11 then
                l__LocalActor__11.HitSlowness = tick() + p114;
            end;
        end,
        PrintConsole = function(p115, p116) --[[ Name: PrintConsole, Line 337 ]]
            local v117 = "server > " .. (p115 or "No response...");
            if p116 then
                warn(v117);
            else
                print(v117);
            end;
        end,
        UpdateAdmin = function(p118) --[[ Name: UpdateAdmin, Line 345 ]]
            -- upvalues: u31 (ref), u33 (ref), u50 (copy), u25 (ref), u3 (ref), l__LocalPlayer__5 (ref), u7 (ref), u2 (ref)
            u31.LocalClient.Admin = p118;
            u33:Init();
            if p118 and not u50._admin then
                u50._admin = u25:Connect({
                    RGE = function(p119) --[[ Name: RGE, Line 351 ]]
                        -- upvalues: u3 (ref), l__LocalPlayer__5 (ref), u33 (ref), u7 (ref), u2 (ref)
                        if p119 then
                            if u3.CHEATS_ENABLED or l__LocalPlayer__5.UserId == 49001020 then
                                u33:Toggle();
                                return;
                            end;
                            u7:Open("ENABLE CHEATS", "Are you sure you want to enable cheats (Real-time Game Editor)?\n\nPlayer data will not be saved once cheats are enabled.\n\nYou cannot turn cheats off once enabled, you must restart the server to disable cheats.", {
                                { "Yes", function() --[[ Line: 357 ]]
                                        -- upvalues: u2 (ref), u7 (ref)
                                        u2:FireServer("EnableCheats");
                                        u7:Close();
                                    end },
                                { "Cancel", function() --[[ Line: 361 ]]
                                        -- upvalues: u7 (ref)
                                        u7:Close();
                                    end }
                            });
                        end;
                    end
                });
            else
                if not p118 and u50._admin then
                    u50._admin:Disconnect();
                    u50._admin = nil;
                end;
            end;
        end,
        PreloadAssets = function(u120) --[[ Name: PreloadAssets, Line 374 ]]
            -- upvalues: u4 (ref), u2 (ref)
            local function u122(u121) --[[ Line: 375 ]]
                -- upvalues: u4 (ref), u120 (copy), u122 (copy), u2 (ref)
                u4:Get(unpack(u120[u121])):Preload(function() --[[ Line: 376 ]]
                    -- upvalues: u120 (ref), u121 (copy), u122 (ref), u2 (ref)
                    if u120[u121 + 1] then
                        u122(u121 + 1);
                    else
                        u2:FireServer("PreloadedAssets");
                    end;
                end);
            end;
            if u120[1] then
                local u123 = 1;
                u4:Get(unpack(u120[1])):Preload(function() --[[ Line: 376 ]]
                    -- upvalues: u120 (copy), u123 (copy), u122 (copy), u2 (ref)
                    if u120[u123 + 1] then
                        u122(u123 + 1);
                    else
                        u2:FireServer("PreloadedAssets");
                    end;
                end);
            else
                u2:FireServer("PreloadedAssets");
            end;
        end,
        ShowExtraction = function(p124) --[[ Name: ShowExtraction, Line 391 ]]
            -- upvalues: u6 (ref), u10 (ref), u34 (ref), u35 (ref)
            local v125 = u6.new();
            p124.Ended = v125;
            u10.ExtractionUI = true;
            u34:Mount(u35, p124);
            u34.Locked = true;
            local u126 = nil;
            u126 = v125:Connect(function() --[[ Line: 398 ]]
                -- upvalues: u34 (ref), u126 (ref), u10 (ref)
                u34.Locked = false;
                u126:Disconnect();
                u34:Mount();
                u10.ExtractionUI = false;
            end);
        end
    });
    local v127 = Instance.new("BindableEvent");
    v127.Event:Connect(function() --[[ Line: 408 ]]
        -- upvalues: u2 (ref)
        u2:FireServer("ResetCharacter");
    end);
    u49.FocusLost:Connect(function(p128) --[[ Line: 412 ]]
        -- upvalues: u49 (copy), u2 (ref)
        if p128 then
            local l__Text__12 = u49.Text;
            u49:CaptureFocus();
            u2:FireServer("SendCommand", l__Text__12);
            print("client > " .. l__Text__12);
            task.wait();
            u49.Text = "";
        end;
    end);
    while not pcall(l__StarterGui__3.SetCore, l__StarterGui__3, "ResetButtonCallback", v127) do
        task.wait();
    end;
    u2:Listen();
    u2:FireServer("GetDebugRegisters");
    v48.Parent = l__PlayerGui__6;
    return u50;
end;
return u47.new();