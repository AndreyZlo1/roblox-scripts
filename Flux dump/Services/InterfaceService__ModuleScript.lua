-- Services.InterfaceService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local v1, u2, u3 = shared.import("require", "network", "Enum");
local u4 = v1("GameShellProxyService");
local u5 = v1("ClientService");
local u6 = v1("versionToNumber");
local u7 = v1("Patchnotes");
local u8 = v1("PopupInterface");
local u9 = v1("LandingInterface");
v1("TutorialInterface");
local u10 = v1("TabletInterface");
local u11 = v1("InteractionInterface");
local u12 = v1("InventoryInterface");
local u13 = v1("RealmInterface");
local u14 = v1("ControlInterface");
local u15 = v1("ActionInterface");
local u16 = v1("CursorInterface");
v1("NotifyInterface");
local u17 = v1("PauseInterface");
local u18 = v1("IntroInterface");
local u19 = v1("RadioInterface");
local u20 = v1("MenuInterface");
local u21 = v1("HUDInterface");
local u22 = v1("TagInterface");
v1("DebugMenuInterface");
local u23 = {};
u23.__index = u23;
function u23.new() --[[ Line: 41 ]]
    -- upvalues: u4 (copy), u3 (copy), u23 (copy), u2 (copy), u17 (copy), u20 (copy), u5 (copy), u6 (copy), u7 (copy), u8 (copy), u13 (copy), u18 (copy)
    local v24 = {
        ControllerFrame = u4:CreateProxy(9, u3.ShellPriority.AlwaysVisible, "InterfaceService")
    };
    local v25 = setmetatable(v24, u23);
    u2:ConnectEvents({
        RegisterMenu = function(p26, p27) --[[ Name: RegisterMenu, Line 47 ]]
            -- upvalues: u17 (ref), u20 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref), u3 (ref)
            u17:Disable();
            u20:Enable(p26);
            if p27 then
                u5.LocalClient.LastVersion = p27;
                local v28 = u6(p27);
                local v29 = nil;
                local v30 = nil;
                for v31, v32 in u7 do
                    if v32.Major then
                        local v33 = u6(v31);
                        if v28 < v33 and (not v29 or v33 >= v29) then
                            v30 = v31;
                            v29 = v33;
                        end;
                    end;
                end;
                if v30 then
                    print(p27 .. " > " .. v30);
                    u8:Open("Release " .. v30, v30, {
                        { "Close", function() --[[ Line: 76 ]]
                                -- upvalues: u8 (ref)
                                u8:Close();
                            end }
                    }, u3.PopupType.Patch);
                end;
            end;
        end,
        UnregisterMenu = function() --[[ Name: UnregisterMenu, Line 83 ]]
            -- upvalues: u20 (ref), u17 (ref)
            u20:Disable();
            u17:Enable();
        end,
        ShowPause = function(p34) --[[ Name: ShowPause, Line 87 ]]
            -- upvalues: u17 (ref)
            if p34 then
                u17:Enable();
            else
                u17:Disable();
            end;
        end,
        UpdateRealm = function(...) --[[ Name: UpdateRealm, Line 94 ]]
            -- upvalues: u13 (ref)
            u13:Display(...);
        end,
        PlayIntro = function() --[[ Name: PlayIntro, Line 97 ]]
            -- upvalues: u18 (ref)
            u18:Play();
        end
    });
    return v25;
end;
function u23.Update(_, p35, p36) --[[ Line: 105 ]]
    -- upvalues: u10 (copy), u16 (copy), u15 (copy), u17 (copy), u20 (copy), u12 (copy), u9 (copy), u22 (copy), u21 (copy), u13 (copy), u11 (copy), u19 (copy), u14 (copy)
    u10:Update(p36);
    u16:Update(p36);
    u15:Update(p36);
    u17:Update(p36);
    u20:Update(p35, p36);
    u12:Update(p36);
    u9:Update(p36);
    u22:Update(p36);
    u21:Update(p36);
    u13:Update(p36);
    u11:Update(p36);
    u19:Update(p36);
    u14:Update(p36);
end;
return u23.new();