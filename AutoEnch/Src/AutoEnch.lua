AutoEnchConfig = AutoEnchConfig or {
    ActionType = 0,
    ForceReplace = 0
}

local slotLookup = {
    ["bracer"] = 9,
    ["boots"] = 8,
    ["chest"] = 5,
    ["weapon"] = 16,
    ["cloak"] = 15,
    ["gloves"] = 10,
    ["off-hand"] = 17,
    ["ring"] = 11,
    ["shield"] = 17
}

local function SearchEnchantingVellum()
    for x = 0, 4 do
        for y = 1, GetContainerNumSlots(x) do
            local currentItem = select(7, GetContainerItemInfo(x, y)) or ""

            if strfind(currentItem, "Enchanting Vellum") then
                return x, y
            end
        end
    end

    UIErrorsFrame:AddMessage("You have no Enchanting Vellums in your inventory!")
    return 0, 0
end

local function OpenSelectActionModeMenu()
    local AeMenu = {}

    tinsert(AeMenu, {
        text = "What to do on click?",
        isTitle = true,
        notCheckable = true
    })

    tinsert(AeMenu, {
        text = "AutoEnchant currently equipped gear.",
        func = function()
            AutoEnchConfig.ActionType = 1
        end
    })

    tinsert(AeMenu, {
        text = "Queue all enchants, you just need to click on items.",
        func = function()
            AutoEnchConfig.ActionType = 2
        end
    })

    tinsert(AeMenu, {
        text = "Place Enchant on a scroll.",
        func = function()
            AutoEnchConfig.ActionType = 3
        end
    })

    if AutoEnchConfig.ActionType > 0 then
        AeMenu[AutoEnchConfig.ActionType + 1].checked = true
    end

    EasyMenu(AeMenu, AeMenuFrame, "cursor", 2, 0, "MENU", 10)
end

local function PerformSelectedEnchantAction()
    if AutoEnchConfig.ActionType == 1 then
        DoTradeSkill(GetTradeSkillSelectionIndex())

        if SpellIsTargeting() then
            local slot = strlower(GetTradeSkillInfo(GetTradeSkillSelectionIndex()))

            PickupInventoryItem(
                strfind(slot, "bracer") and 9 or strfind(slot, "boots") and 8 or strfind(slot, "chest") and 5 or
                    strfind(slot, "weapon") and 16 or strfind(slot, "cloak") and 15 or strfind(slot, "gloves") and 10 or
                    strfind(slot, "off-hand") and 17 or strfind(slot, "ring") and 11 or strfind(slot, "shield") and 17 or
                    0)
        end
    elseif AutoEnchConfig.ActionType == 2 then
        DoTradeSkill(GetTradeSkillSelectionIndex(), select(3, GetTradeSkillInfo(GetTradeSkillSelectionIndex())))
    elseif AutoEnchConfig.ActionType == 3 then
        DoTradeSkill(GetTradeSkillSelectionIndex())

        if SpellIsTargeting() then
            UseContainerItem(searchEnchVel())
        end
    else
        OpenSelectActionModeMenu()
    end
end

local function HandleTradeSkillEvent()
    if GetTradeSkillLine() == "Enchanting" then
        local function onTradeSkillCreateAllButtonClick(_, button)
            if button == "RightButton" then
                OpenSelectActionModeMenu()
            elseif button == "LeftButton" then
                PerformSelectedEnchantAction()
            end
        end

        AutoEnch = AutoEnch or CreateFrame("Button", "AutoEnch", TradeSkillFrame, "UIPanelButtonTemplate")
        AutoEnch:SetSize(100, TradeSkillCreateButton:GetHeight())
        AutoEnch:SetText("Auto-Enchant")
        AutoEnch:SetPoint("TOPRIGHT", TradeSkillCreateButton, "TOPLEFT", 0, 0)
        AutoEnch:RegisterForClicks("AnyUp")
        AutoEnch:SetScript("OnClick", onTradeSkillCreateAllButtonClick)

        local function onTradeSkillCreateAllButtonHide()
            AutoEnch:Show()
        end

        local function onTradeSkillCreateAllButtonShow()
            AutoEnch:Hide()
        end

        TradeSkillCreateAllButton:SetScript("OnHide", onTradeSkillCreateAllButtonHide)
        TradeSkillCreateAllButton:SetScript("OnShow", onTradeSkillCreateAllButtonShow)

        if TradeSkillCreateAllButton:IsShown() then
            AutoEnch:Hide()
        else
            AutoEnch:Show()
        end
    end
end

local function HandleReplaceEnchantEvent(enchant1, enchant2)
    if enchant1 == enchant2 and AutoEnchConfig.ForceReplace == 1 then
        for x = STATICPOPUP_NUMDIALOGS, 1, -1 do
            if _G["StaticPopup" .. x]:IsShown() then
                _G["StaticPopup" .. x .. "Button1"]:Click()
                break
            end
        end
    end
end

local function OnEvent(self, event, ...)
    if event == "TRADE_SKILL_SHOW" then
        HandleTradeSkillEvent()
    elseif event == "REPLACE_ENCHANT" then
        HandleReplaceEnchantEvent(...)
    end
end

CreateFrame("Frame", "AeMenuFrame", UIParent, "UIDropDownMenuTemplate")

local autoEnchMainFrame = CreateFrame("Frame")
autoEnchMainFrame:RegisterEvent("REPLACE_ENCHANT")
autoEnchMainFrame:RegisterEvent("TRADE_SKILL_SHOW")
autoEnchMainFrame:SetScript("OnEvent", OnEvent)
