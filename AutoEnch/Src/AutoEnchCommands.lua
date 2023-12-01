local function OpenOptions()
    InterfaceOptionsFrame_OpenToCategory("AutoEnch")
    InterfaceOptionsFrame_OpenToCategory("AutoEnch")
end

local function DisplayHelpMessages()
    print("To change AutoEnch mode just click at 'Auto-Enchant' button with right button.")
    print("Some settings are available in interface settings panel.")
    print("You can use following methods to use AutoEnch:")
    print("/ae options/o - opens options frame")
end

AutoEnchOptionTable = {
    ["options"] = OpenOptions,
    ["o"] = OpenOptions,
    ["help"] = DisplayHelpMessages
}

function AutoEnchOptionToggle(msg)
    local lowerMsg = strlower(msg)

    if AutoEnchOptionTable[lowerMsg] then
        AutoEnchOptionTable[lowerMsg]()
    else
        print("Not a valid command, type /ae help")
    end
end

SlashCmdList["AUTOENCH"] = AutoEnchOptionToggle
SLASH_AUTOENCH1 = "/ae"
SLASH_AUTOENCH2 = "/aench"
SLASH_AUTOENCH3 = "/autoench"