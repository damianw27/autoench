local function SaveSettings(autoReplaceCheckbox)
    return function()
        local isChecked = autoReplaceCheckbox:GetChecked()
        AutoEnchConfig.ForceReplace = isChecked and 1 or 0
    end
end

local optionsFrame = CreateFrame("Frame", "AutoEnchConfigFrame", UIParent)
optionsFrame.name = "AutoEnch"
optionsFrame:Hide()
InterfaceOptions_AddCategory(optionsFrame)

local logo = optionsFrame:CreateTexture(nil, "ARTWORK")
logo:SetTexture("Interface\\Addons\\AutoEnch\\Media\\Icon")
logo:SetSize(127, 127)
logo:SetPoint("TOPLEFT", 10, -10)

local title = optionsFrame:CreateTexture(nil, "ARTWORK")
title:SetTexture("Interface\\Addons\\AutoEnch\\Media\\Title")
title:SetSize(159, 40)
title:SetPoint("RIGHT", logo, 165, 0)

local autoReplaceCheckbox = CreateFrame("CheckButton", "AutoEnchAutoReplaceCheckbox", optionsFrame, "UICheckButtonTemplate")
autoReplaceCheckbox:SetPoint("BOTTOMLEFT", logo, 0, -30)
autoReplaceCheckbox:SetScript("OnClick", SaveSettings(autoReplaceCheckbox))

getglobal('AutoEnchAutoReplaceCheckboxText'):SetText("Auto-Replace Same Enchant")

function HandleOnShowFrame()
    autoReplaceCheckbox:SetChecked(AutoEnchConfig.ForceReplace or 0 == 1)
end

optionsFrame:SetScript("OnShow", HandleOnShowFrame)
