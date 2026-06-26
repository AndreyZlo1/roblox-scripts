-- Services.StatsService
-- ModuleScript | dc

-- Decompiled with Potassium's decompiler.

local u1, u2, v3, u4, u5 = shared.import("network", "Roact", "require", "server", "Enum");
local l__MarketplaceService__1 = game:GetService("MarketplaceService");
local l__Players__2 = game:GetService("Players");
local u6 = v3("SoundService");
local u7 = v3("PopupInterface", true);
local l__LocalPlayer__3 = l__Players__2.LocalPlayer;
local u8 = {};
u8.__index = u8;
function u8._productFinished(p9) --[[ Line: 24 ]]
    -- upvalues: u7 (copy)
    u7.Lazy:SetLoading(false);
    local l___waitingProduct__4 = p9._waitingProduct;
    p9._waitingProduct = nil;
    if l___waitingProduct__4 and l___waitingProduct__4.moneyIncrease then
        u7.Lazy:DisplayCredits(l___waitingProduct__4.moneyIncrease);
    end;
end;
function u8.new() --[[ Line: 38 ]]
    -- upvalues: u2 (copy), u8 (copy), l__MarketplaceService__1 (copy), u6 (copy), u7 (copy), u5 (copy), u1 (copy)
    local v10, u11 = u2.createBinding(0);
    local v12, u13 = u2.createBinding(0);
    local v14, u15 = u2.createBinding(0);
    local v16, u17 = u2.createBinding(0);
    local u18 = setmetatable({
        Money = 0,
        Level = 0,
        EXP = 0,
        MaxEXP = 0,
        Expires = 0,
        Main = 1,
        OperatorTokens = 0,
        TokenBinding = v10,
        MoneyBinding = v12,
        LevelBinding = v14,
        EXPBinding = v16,
        UpdateMoney = u13
    }, u8);
    l__MarketplaceService__1.PromptProductPurchaseFinished:Connect(function(_, _, p19) --[[ Line: 61 ]]
        -- upvalues: u18 (copy), u6 (ref), u7 (ref), u5 (ref)
        local l___waitingProduct__5 = u18._waitingProduct;
        if l___waitingProduct__5 and (p19 and not l___waitingProduct__5.isCurrency) then
            u6:CreateSound("Button", nil, true, "UISounds", "EXPPurchase").Destroy(10);
        end;
        u18:_productFinished();
        if not p19 and (l___waitingProduct__5 and (l___waitingProduct__5.isCurrency and not l___waitingProduct__5.dontRePrompt)) then
            u7.Lazy:Open("Buy Currency", nil, {
                { "Close", function() --[[ Line: 71 ]]
                        -- upvalues: u7 (ref)
                        u7.Lazy:Close();
                    end }
            }, u5.PopupType.Shop);
        end;
    end);
    u1:ConnectEvents({
        UpdateStats = function(p20, p21, p22, p23, p24, p25, p26) --[[ Name: UpdateStats, Line 79 ]]
            -- upvalues: u18 (copy), u7 (ref), u13 (copy), u11 (copy), u15 (copy), u17 (copy)
            local v27 = p20 - u18.Money;
            u18.Money = p20;
            u18.Level = p21;
            u18.EXP = p22;
            u18.MaxEXP = math.ceil(((p21 + 1) / 0.12909944485873) ^ 2 - (p21 / 0.12909944485873) ^ 2);
            u18.Expires = p23;
            u18.Main = p24;
            u18.OperatorTokens = p25;
            if p26 then
                local l___waitingProduct__6 = u18._waitingProduct;
                if l___waitingProduct__6 and l___waitingProduct__6.isCurrency then
                    l___waitingProduct__6.moneyIncrease = v27;
                    l___waitingProduct__6.timeout = tick() + 10;
                else
                    u7.Lazy:DisplayCredits(v27);
                end;
            else
                u13(p20);
            end;
            u11(p25);
            u15(p21);
            u17(p22);
        end,
        UpdateArmory = function(p28) --[[ Name: UpdateArmory, Line 105 ]]
            -- upvalues: u18 (copy)
            u18.ArmoryPresets = p28;
        end
    });
    return u18;
end;
function u8.Update(p29) --[[ Line: 113 ]]
    local l___waitingProduct__7 = p29._waitingProduct;
    if l___waitingProduct__7 then
        l___waitingProduct__7 = l___waitingProduct__7.timeout;
    end;
    if l___waitingProduct__7 and l___waitingProduct__7 < tick() then
        p29:_productFinished();
    end;
end;
function u8.PromptProduct(p30, p31, p32, p33) --[[ Line: 121 ]]
    -- upvalues: u4 (copy), u7 (copy), l__MarketplaceService__1 (copy), l__LocalPlayer__3 (copy)
    if u4.CHEATS_ENABLED then
    else
        p30._waitingProduct = {
            productId = p31,
            isCurrency = p32,
            dontRePrompt = p33
        };
        u7.Lazy:Close();
        u7.Lazy:SetLoading(true);
        l__MarketplaceService__1:PromptProductPurchase(l__LocalPlayer__3, p31);
    end;
end;
return u8.new();