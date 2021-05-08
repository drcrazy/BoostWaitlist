local L = LibStub("AceLocale-3.0"):GetLocale("BoostWaitlist", true)

local addonName, addon = ...
local Options = addon.Options or {}
-- local Options = _G.BoostWaitlistOptions or {}

local about = CreateFrame("Frame", "BoostWaitlistAboutOptions", InterfaceOptionsFramePanelContainer)
local general = CreateFrame("Frame")
local playerDB = CreateFrame("Frame")

Options.about = about
Options.general = general
Options.playerDB = playerDB

local DB -- assigned during init
local GUI = addon.GUI
local UIBuilder = addon.UIBuilder


---General---------------------------------------------

general.name = L["General"]
general.parent = addonName
general:Hide()

function Options:GeneralShow()

    local title = UIBuilder:Header(general, general.name, true)

    local minimapIcon = UIBuilder:Checkbox(general, L["EminimapIcon"], L["EminimapIconTT"],
        function(checked)
            if(checked) then GUI:ShowMinimapIcon() else GUI:HideMinimapIcon() end DB.Main.everActive = checked
        end
    )
    minimapIcon:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -2, -16)

    local enableStats = UIBuilder:Checkbox(general, L["EStats"], L["EStatsTT"],
        function(checked)
            DB.Main.enableStats = checked
        end
    )
    enableStats:SetPoint("TOPLEFT", minimapIcon, "BOTTOMLEFT", 0, 0)

    local enableBalanceWhisperThreshold = UIBuilder:Checkbox(general, L["BalanceWhisperThreshold"], L["BalanceWhisperThresholdTT"],
    function(checked)
        DB.Main.enableBalanceWhisperThreshold = checked
    end)
    enableBalanceWhisperThreshold:SetPoint("TOPLEFT", enableStats, "BOTTOMLEFT", 0, 0)

    local goldThreshold = UIBuilder:Slider(general, L["GThreshold"], L["GThresholdTT"], -100, 100, 
    function(v)
        DB.Main.balanceWhisperThreshold = v
    end)
    goldThreshold:SetPoint("TOPLEFT", enableBalanceWhisperThreshold, "BOTTOMLEFT", 0, -5)

    --
    -- Column 2
    --
    local enableAutobill = UIBuilder:Checkbox(general, L["EAutobill"], L["EAutobillTT"],
    function(checked)
        DB.Main.autobill = checked
    end
    )
    enableAutobill:SetPoint("LEFT", minimapIcon, "RIGHT", 120, 0)

    local enableSounds = UIBuilder:Checkbox(general, L["ESounds"], L["ESoundsTT"],
    function(checked)
        DB.Main.enableSounds = checked
    end
    )
    enableSounds:SetPoint("TOPLEFT", enableAutobill, "BOTTOMLEFT", 0, 0)

    local enableWaitlist = UIBuilder:Checkbox(general, L["EWaitlist"], L["EWaitlistTT"],
    function(checked)
        DB.Main.enableWaitlist = checked
    end)
    enableWaitlist:SetPoint("TOPLEFT", enableSounds, "BOTTOMLEFT", 0, 0)


    local maxWaitlist = UIBuilder:Slider(general, L["MWaitlist"], L["MWaitlistTT"], 1, 20, 
    function(v)
        DB.Main.maxWaitlist = v
    end)
    maxWaitlist:SetPoint("TOPLEFT", enableWaitlist, "BOTTOMLEFT", 0, -5)



    local function init()
        DB = _G.BoostWaitlistDB

        minimapIcon:SetChecked(DB.Main.everActive)
        enableStats:SetChecked(DB.Main.enableStats or false)
        enableBalanceWhisperThreshold:SetChecked(DB.Main.enableBalanceWhisperThreshold or false)
        goldThreshold:SetValue(DB.Main.balanceWhisperThreshold)
        enableAutobill:SetChecked(DB.Main.autobill or false)
        enableSounds:SetChecked(DB.Main.enableSounds or false)
        enableWaitlist:SetChecked(DB.Main.enableWaitlist or false)
        maxWaitlist:SetValue(DB.Main.maxWaitlist or 20)

    end

    init()

    general:Show()
    general:SetScript("OnShow", init)
end

---General END-----------------------------------------

---About-----------------------------------------------
about.name = addonName
about:Hide()

function Options:AboutShow()
    local title = UIBuilder:Header(about, about.name, true)

    local subtitle = about:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subtitle:SetHeight(32)
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
	subtitle:SetNonSpaceWrap(true)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetJustifyV("TOP")
	subtitle:SetText(GetAddOnMetadata(addonName, "Notes"))

    local author = about:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	author:SetHeight(32)
	author:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, 20)
	author:SetNonSpaceWrap(true)
	author:SetJustifyH("LEFT")
	author:SetJustifyV("TOP")
	author:SetText("|cFF4400EEWritten by: |r" .. GetAddOnMetadata(addonName, "Author"))


    local version = about:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	version:SetHeight(32)
	version:SetPoint("TOPLEFT", title, "TOPRIGHT", 0, -2)
	version:SetText('v.' .. GetAddOnMetadata(addonName, "Version"))

    local line = about:CreateTexture()
    line:SetTexture("Interface/BUTTONS/WHITE8X8")
    line:SetColorTexture(0.6 ,0.6, 0.6, 0.4)
    line:SetSize(500, 2)
    line:SetPoint("BOTTOMLEFT", author)

    about:Show()
    about:SetScript("OnShow", nil)
end
---About END--------------------------------------------

---About-----------------------------------------------
playerDB.name = L["Player Database"]
playerDB.parent = addonName
playerDB:Hide()

function Options:PlayerDBShow()

    

    local tableCols = {
        {
            name = L["Name"],
            width = 120,
            align = 'LEFT',
            format = 'string',
            index = 'name',
            sortable = true,
            defaultSort = 'dsc',
            color = {r=1,g=1,b=1,a=1}
        },
        {
            name = L["Balance"],
            width = 100,
            align = 'LEFT',
            format = 'number',
            index = 'accountBalance',
            sortable = true,
            color = function (table, value)
                local c = {r=1,g=1,b=1,a=1}
                if (tonumber(value) < 0) then
                    c = {r=1,g=0,b=0,a=1}
                end
                return c
            end,
            events = {
                OnClick = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                    local cellData = rowData[columnData.index]
                    cellFrame.cellEdit = UIBuilder:TableNumericEditBox(table, cellFrame, cellData, rowData, columnData,
                    function(value, row)
                        DB.Main.accountBalance[row.name] = value
                    end
                    )
                    return true
                end,
            }
        },
        {
            name = L["Override"],
            width = 120,
            align = 'LEFT',
            format = 'number',
            index = 'overrideCharge',
            sortable = true,
            color = function (table, value)
                local c = {r=1,g=1,b=1,a=1}
                if (tonumber(value) < 0) then
                    c = {r=1,g=0,b=0,a=1}
                end
                return c
            end,
            events = {
                OnClick = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                    local cellData = rowData[columnData.index]
                    cellFrame.cellEdit = UIBuilder:TableNumericEditBox(table, cellFrame, cellData, rowData, columnData,
                    function(value)
                        if (value < 0) then
                            DB.Main.overrideCharge[rowData.name] = nil
                            table:Refresh()
                        else
                            DB.Main.overrideCharge[rowData.name] = value
                        end
                    end
                    )
                    return true
                end,
            }
        },
        {
            name = L["Blacklist"],
            width = 70,
            align = 'LEFT',
            format = 'boolean',
            index = 'blacklist',
            sortable = false,
        }
    }

       --could definitely use some efficiency improvements
    local function populateColumns()
        local cols={}
        local playerlist = {}
        for k,v in pairs(DB.Main.blacklist) do
           if (playerlist[k] == nil) then
                playerlist[k] = {}
           end
           playerlist[k].blacklist = 'true'
        end
        for k,v in pairs(DB.Main.overrideCharge) do
            if (playerlist[k] == nil) then
                playerlist[k] = {}
            end
            playerlist[k].overrideCharge = v
        end
        for k,v in pairs(DB.Main.accountBalance) do
            if (playerlist[k] == nil) then
                playerlist[k] = {}
            end
            playerlist[k].accountBalance = v
        end

    
        local i=1
        for k,v in pairs(playerlist) do
            cols[i] = {
                name = k,
                accountBalance = playerlist[k].accountBalance or 0,
                overrideCharge = playerlist[k].overrideCharge or 0,
                blacklist = playerlist[k].blacklist or 'false',
            }
            i = i + 1
        end    

        return cols
    end


    local title = UIBuilder:Header(playerDB, playerDB.name, true)
    local playerTable = UIBuilder:Table(playerDB, tableCols, 18, 10, -100)
 

    local function init()
        DB = _G.BoostWaitlistDB
        playerTable:SetData(populateColumns())
        playerTable:Refresh()
    end

    init()

    playerDB:Show()
    playerDB:SetScript("OnShow", init)
end




about:SetScript("OnShow", Options.AboutShow)
general:SetScript("OnShow", Options.GeneralShow)
playerDB:SetScript("OnShow", Options.PlayerDBShow)


InterfaceOptions_AddCategory(about)

InterfaceOptions_AddCategory(general, Options.about)
InterfaceOptions_AddCategory(playerDB, Options.about)



