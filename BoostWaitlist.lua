local addonName, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale("BoostWaitlist", true)
local UTF8 = LibStub("UTF8")

-- Create saved global vars
_G.BoostWaitlistDB = _G.BoostWaitlistDB or {}

-- Create local vars
local DB -- assigned during ADDON_LOADED
local Main = addon
local GUI = addon.GUI
local SimpleThrottle = addon.SimpleThrottle


-- Register for events
local BoostWaitlistEvent = CreateFrame("FRAME")
BoostWaitlistEvent:RegisterEvent("ADDON_LOADED")
BoostWaitlistEvent:RegisterEvent("PLAYER_ENTERING_WORLD")
BoostWaitlistEvent:RegisterEvent("CHAT_MSG_WHISPER")
BoostWaitlistEvent:RegisterEvent("CHAT_MSG_SYSTEM")
BoostWaitlistEvent:RegisterEvent("GROUP_ROSTER_UPDATE")
BoostWaitlistEvent:RegisterEvent("TRADE_MONEY_CHANGED")
BoostWaitlistEvent:RegisterEvent("TRADE_ACCEPT_UPDATE")
BoostWaitlistEvent:RegisterEvent("UI_INFO_MESSAGE")
BoostWaitlistEvent:RegisterEvent("UNIT_NAME_UPDATE")

-- Main event handler function
local function eventHandler(self, event, arg1, arg2, ...)
  if ((event == "ADDON_LOADED") and (arg1 == "BoostWaitlist")) then
    print(L["addonLoading"])
    Main:Init()
  elseif (event == "CHAT_MSG_WHISPER") then
    if (DB.active) then
      local msg, sender = arg1, Main:RemoveServerFromName(arg2)
      if (not Main:IsBlacklist(sender)) then
        Main:HandleWhisperMessage(msg, sender)
      end
    elseif (DB.inactivereply and DB.inactivereplymsg ~= nil) then
      
      if (strlower(arg1):find("boost")) then
        local sender = Main:RemoveServerFromName(arg2)
        SimpleThrottle:SendChatMessage(DB.inactivereplymsg, "WHISPER", nil, sender)
      end
    end
  elseif (event == "CHAT_MSG_SYSTEM") then
    if (DB.active and DB.autobill) then
      Main:HandleSystemMessage(arg1)

      -- instance reset, chargeall
      if (
        string.match(arg1, string.gsub(INSTANCE_RESET_SUCCESS, "%%s", ".+")) or 
        string.match(arg1, string.gsub(INSTANCE_RESET_FAILED, "%%s", ".+")) or
        string.match(arg1, string.gsub(INSTANCE_RESET_FAILED_ZONING, "%%s", ".+")) or
        string.match(arg1, string.gsub(INSTANCE_RESET_FAILED_OFFLINE, "%%s", ".+"))
       ) then
        Main:ChargeAll()
      end
    end
  elseif (event == "PLAYER_ENTERING_WORLD") then
    if (DB.active) then
      Main:HandleGroupRosterUpdate()
    end
  elseif (event == "GROUP_ROSTER_UPDATE") then
    if (DB.active) then
      Main:HandleGroupRosterUpdate()
    end
  elseif (event == "UNIT_NAME_UPDATE") then
    if (DB.active) then
      Main:HandleGroupRosterUpdate()
    end
  elseif (event == "TRADE_ACCEPT_UPDATE") then
    if (DB.active) then
      Main:HandleTradeAcceptUpdate(arg1, arg2)
    end
  elseif (event == "TRADE_MONEY_CHANGED") then
    if (DB.active) then
      Main:HandleTradeMoneyChanged()
    end
  elseif (event == "UI_INFO_MESSAGE") then
    if (DB.active) then
      Main:HandleUIInfoMessage(arg2)
    end
  end
end

-- Register event handler
BoostWaitlistEvent:SetScript("OnEvent", eventHandler)

-- Slash commands
SLASH_BOOSTWAITLIST1 = "/boostwaitlist"
SLASH_BOOSTWAITLIST2 = "/boost"
SLASH_BOOSTWAITLIST3 = "/waitlist"
SlashCmdList["BOOSTWAITLIST"] = function(msg)
  local cmd = {strsplit(" ", msg)}
  local used = 0

  if ((msg == "") or (msg == nil)) then
    GUI:Show()
    used = 1
  elseif (cmd[1] == "setreply") then
    cmd = {strsplit(" ", msg, 2)}
    if (cmd[2] == nil) then
      DB.initialReply = ""
      print(L["setReplyEmpty"])
    elseif (strlen(cmd[2]) < 105) then
      DB.initialReply = cmd[2]
      print(L["setReply"])
    else
      print(L["setReplyTooLong"])
    end
    used = 1
  elseif (cmd[1] == "setdonemessage") then
    cmd = {strsplit(" ", msg, 2)}
    if (cmd[2] == nil) then
      DB.doneMessage = ""
      print(L["setDoneEmpty"])
    elseif (strlen(cmd[2]) < 250) then
      DB.doneMessage = cmd[2]
      print(L["setDone"])
    else
      print(L"setDoneTooLong")
    end
    used = 1
  elseif (cmd[1] == "inactivereplymessage") then
    cmd = {strsplit(" ", msg, 2)}
    if (cmd[2] == nil) then
      DB.inactivereplymsg = ""
      print(L["inactiveReplyMessageEmpty"])
    elseif (strlen(cmd[2]) < 201) then
      DB.inactivereplymsg = cmd[2]
      print(L["inactiveReplyMessage"])
    else
      print(L["inactiveReplyMessageTooLong"])
    end
    used = 1
  elseif (cmd[1] == "inactivereply") then
    if (cmd[2] == "on") then
      DB.inactivereply = true
      print(L["inactiveReplyEnabled"])
      used = 1
    elseif (cmd[2] == "off") then
      DB.inactivereply = false
      print(L["inactiveReplyDisabled"])
      used = 1
    end
  elseif (#cmd == 1) then
    if (cmd[1] == "help") then
      Main:PrintUsage()
      used = 1
    elseif (cmd[1] == "gui") then
      GUI:Show()
      used = 1
    elseif (cmd[1] == "chargeall") then
      if (DB.active) then
        Main:ChargeAll()
      end
      used = 1
    elseif (cmd[1] == "reset") then
      Main:ResetWaitlistInfo()
      used = 1
    elseif (cmd[1] == "on") then
      Main:HandleAddonOn()
      used = 1
    elseif (cmd[1] == "off") then
      Main:HandleAddonOff()
      used = 1
    elseif (cmd[1] == "config") then
      InterfaceOptionsFrame_OpenToCategory("BoostWaitlist");
      used = 1
    end
  elseif (cmd[1] == "blacklist") then
    cmd = {strsplit(" ", msg, 3)}
    if (#cmd == 2) then
      Main:AddBlacklist(strlower(cmd[2]):gsub("^%l", string.upper), "no reason")
    else
      Main:AddBlacklist(strlower(cmd[2]):gsub("^%l", string.upper), strlower(cmd[3]):gsub("^%l", string.upper))
    end
    used = 1
  elseif (#cmd == 2) then
    if (cmd[1] == "print") then
      if (cmd[2]:find("wait") == 1) then
        Main:PrintWaitlist()
        used = 1
      elseif (cmd[2]:find("black") == 1) then
        Main:PrintBlacklist()
        used = 1
      elseif (cmd[2]:find("reply") == 1) then
        print(DB.initialReply)
        used = 1
      end
    elseif (cmd[1] == "minimap") then
      if (cmd[2]:find("hide") == 1) then
        GUI:HideMinimapIcon()
        DB.everActive = false
        used = 1
      elseif (cmd[2]:find("show") == 1) then
        GUI:ShowMinimapIcon()
        DB.everActive = true
        used = 1
      end
    elseif (cmd[1] == "autobill") then
      if (cmd[2] == "on") then
        DB.autobill = true
        print(L["autoBillingEnabled"])
        GUI:Update()
        used = 1
      elseif (cmd[2] == "off") then
        DB.autobill = false
        print(L["autoBillingDisabled"])
        GUI:Update()
        used = 1
      end
    elseif (cmd[1] == "enablewaitlist") then
      if (cmd[2] == "on") then
        DB.enableWaitlist = true
        print(L["waitlistEnabled"])
        used = 1
      elseif (cmd[2] == "off") then
        DB.enableWaitlist = false
        print(L["waitlistDisabled"])
        used = 1
      end
    elseif (cmd[1] == "maxwaitlist") then
        if (tonumber(cmd[2]) ~= nil) then
          DB.maxWaitlist = cmd[2]
          print(L["setMaxWaitlist"](cmd[2]))
        else
          print(L["setMaxWaitlistUsage"])
        end
        used = 1
    elseif (cmd[1] == "enablebalancewhisperthreshold") then
      if (cmd[2] == "on") then
        DB.enableBalanceWhisperThreshold = true
        print(L["balanceWhisperThresholdEnabled"])
        print(L["balanceWhisperThresholdValue"](DB.balanceWhisperThreshold))
        used = 1
      elseif (cmd[2] == "off") then
        DB.enableBalanceWhisperThreshold = false
        print(L["balanceWhisperThresholdDisabled"] )
        used = 1
      end
    elseif (cmd[1] == "balancewhisperthreshold") then
      if (tonumber(cmd[2]) ~= nil) then
        DB.balanceWhisperThreshold = cmd[2]
        print(L["balanceWhisperThresholdSet"](cmd[2]))
      else
        print(L["balanceWhisperThresholdUsage"])
      end
      used = 1
    elseif (cmd[1] == "enablestats") then
      if (cmd[2] == "on") then
        DB.enableStats = true
        print(L["statsEnabled"])
        used = 1
      elseif (cmd[2] == "off") then
        DB.enableStats = false
        print(L["statsDisabled"])
        used = 1
      end
    elseif (cmd[1] == "sounds") then
      if (cmd[2] == "on") then
        DB.enableSounds = true
        print(L["soundEnabled"])
        used = 1
      elseif (cmd[2] == "off") then
        DB.enableSounds = false
        print(L["soundDisabled"])
        used = 1
      end
    elseif (cmd[1] == "setcost") then
      local cost = tonumber(cmd[2])
      if (cost ~= nil) then
        DB.cost = cost
        print(L["setCost"])
        GUI:Update()
      else
        print(L["setCostInvalid"])
      end
      used = 1
    elseif (cmd[1] == "charge") then
      Main:ChargeBalance(strlower(cmd[2]):gsub("^%l", string.upper))
      used = 1
    elseif (cmd[1] == "add") then
      Main:RequestWaitlist(strlower(cmd[2]):gsub("^%l", string.upper), strlower(cmd[2]):gsub("^%l", string.upper))
      used = 1
    elseif (cmd[1] == "forming") then
      DB.forming = (cmd[2] == "on")
      used = 1
    elseif (cmd[1] == "break") then
      if (cmd[2]:find("done") == 1) then
        Main.managerOnBreak = false
      else
        Main.managerOnBreak = true
        Main.managerBreakEndTime = cmd[2]
      end
      used = 1
    end
  elseif (#cmd == 3) then
    if (cmd[1] == "connect") then
      if (Main:InWaitlist(strlower(cmd[2]):gsub("^%l", string.upper))) then
        Main:UpdateWaitlistSender(strlower(cmd[3]):gsub("^%l", string.upper), strlower(cmd[2]):gsub("^%l", string.upper))
      else
        print(L["notInWaitlist"](cmd[2]))
      end
      used = 1
    elseif (cmd[1] == "add") then
      Main:RequestWaitlist(strlower(cmd[3]):gsub("^%l", string.upper), strlower(cmd[2]):gsub("^%l", string.upper))
      used = 1
    elseif (cmd[1] == "print") then
      if (cmd[2] == "balance") then
        Main:PrintBalance(strlower(cmd[3]):gsub("^%l", string.upper))
        used = 1
      end
    elseif (cmd[1] == "reset") then
      if (cmd[2] == "balance") then
        Main:ResetBalance(strlower(cmd[3]):gsub("^%l", string.upper))
        used = 1
      end
    elseif (cmd[1] == "remove") then
      if (cmd[2]:find("black") == 1) then
        Main:RemoveBlacklist(strlower(cmd[3]):gsub("^%l", string.upper))
        used = 1
      end
    end
  elseif (#cmd == 4) then
    if (cmd[1] == "add") then
      if (cmd[2] == "balance") then
        local amount = tonumber(cmd[4])
        if (amount ~= nil) then
          Main:AddBalance(strlower(cmd[3]):gsub("^%l", string.upper), amount)
        else
          print(L["invalidAmount"])
	end
        used = 1
      end
    end
  end
  if (used == 0) then
    print(L["unsupportedCommand"](msg))
    Main:PrintUsage()
  end
end

-- Init functions

function Main:Init()

  Main:CopyDBDefaults(_G.BoostWaitlistDB, _G.BoostWaitlistDBDefaults)
  DB = _G.BoostWaitlistDB.Main
  Main:FixWaitlistRefs()
  GUI:Init()
  Main:SetInitState()
  Main:PurgeAccountBlances()

  Main.groupRoster = {}
  Main.playerTradeMoney = 0
  Main.tradeMoney = 0
  Main.tradeName = "Unknown"
end

function Main:PurgeAccountBlances()
  if (not DB.active) then
    for n,a in pairs(DB.accountBalance) do
      if (a == 0) then
        DB.accountBalance[n] = nil
      end
    end
  end
end

function Main:CopyDBDefaults(db, def)
  for k,v in pairs(def) do
    if(db[k] == nil) then
      db[k] = def[k]
    elseif (type(v) == "table") then
      Main:CopyDBDefaults(db[k], v)
    end
  end
end

function Main:SetInitState()
  Main.convState = {}
  local waitlist = Main:GetWaitlistInfo().waitlist
  for i=1,#waitlist do
    Main:SetConvState(waitlist[i].target, "STARTED")
    Main:SetConvState(waitlist[i].sender, "STARTED")
  end
  Main.partyNames = {}
end

function Main:HandleAddonOn()
  DB.name = UnitName("player")
  print(L["addonActivated"])
  DB.active = true
  Main.groupRoster = {}
  Main:HandleGroupRosterUpdate()
  if (DB.everActive == false) then
    GUI:ShowMinimapIcon()
  end
  GUI:UpdateBrokerTexture()
end

function Main:HandleAddonOff()
  print(L["addonDeactivated"])
  DB.active = false
  if ((#Main:GetWaitlistInfo().waitlist > 0) and (DB.doneMessage ~= "")) then
    GUI:ShowPopupFrame("DONE_BOOSTING")
  end
  if (DB.everActive == false) then
    GUI:HideMinimapIcon()
  end
  GUI:UpdateBrokerTexture()
end

-- Whisper Message functions

function Main:HandleWhisperMessage(msg, sender)
  local state = Main:GetConvState(sender)
  if ((state == "INVITED") and (msg:find("inv") == 1)) then
    Main:HandleInviteRequest(sender)
  elseif(string.sub(msg,1,1) == "!") then
    if (state == "IDLE") then
      Main:SetConvState(sender, "STARTED")
    end
    Main:HandleWhisperCommand(msg, sender)
  elseif (state == "IDLE") then
    if (DB.enableWaitlist and DB.maxWaitlist > #DB.waitlistInfo.waitlist) then
      Main:StartConv(sender)
    end
  end
end

function Main:HandleWhisperCommand(msg, sender)
  local lc_msg = string.lower(msg)
  if ((lc_msg:find("wait") == 2) and not lc_msg:find(" ")) then
    if (DB.enableWaitlist and DB.maxWaitlist > #DB.waitlistInfo.waitlist) then
      Main:RequestWaitlistFromWhisper(sender, sender)
    else
      SimpleThrottle:SendChatMessage(L["waitlistFull"], "WHISPER", nil, sender)
    end
  elseif (lc_msg:find("wait") == 2) then
    if (DB.enableWaitlist and DB.maxWaitlist > #DB.waitlistInfo.waitlist) then
      local cmd, main = strsplit(" ", msg)
      if (main) then
        local mainuc = string.upper(string.sub(main, 1, 1))
        local mainlc = string.lower(string.sub(main, 2))
        main = mainuc..mainlc
        main = string.gsub(main, "[<>%s]+", "")
        Main:SetConvState(main, "STARTED")

        Main:RequestWaitlistFromWhisper(sender, main)
      else
        SimpleThrottle:SendChatMessage(L["waitlistExample1"], "WHISPER", nil, sender)
        SimpleThrottle:SendChatMessage(L["waitlistExample2"], "WHISPER", nil, sender)
      end
    else
      SimpleThrottle:SendChatMessage(L["waitlistFull"], "WHISPER", nil, sender, true)
    end
  elseif (lc_msg:find("canc") == 2) then
    Main:RemoveWaitlist(sender)
  elseif (lc_msg:find("bal") == 2) then
    Main:WhisperBalance(sender)
  elseif (lc_msg:find("inv") == 2) then
    Main:HandleInviteRequest(sender)
  elseif (lc_msg:find("lin") == 2) then
    Main:WhisperEta(sender)
  elseif (lc_msg:find("comm") == 2) then
    Main:WhisperCommands(sender)
  else
    SimpleThrottle:SendChatMessage(L["unsupportedCommandShort"], "WHISPER", nil, sender)
    Main:WhisperCommands(sender)
  end
end

function Main:StartConv(sender)
  local groupFormSentence = ""
  if (DB.forming) then
    groupFormSentence = L["groupForming"]
  else
    local num = Main:GetCardinalNumber(#Main:GetWaitlistInfo().waitlist + 1)
    -- 63 chars + 2 for num
    groupFormSentence = L["groupFull"](num)
  end
  -- 81 chars
  SimpleThrottle:SendChatMessage(L["groupFormSentence"](DB.initialReply, groupFormSentence), "WHISPER", nil, sender, true)
  Main:SetConvState(sender, "STARTED")
end

function Main:RequestWaitlistFromWhisper(sender, target)
  if (Main.managerOnBreak) then
    SimpleThrottle:SendChatMessage(L["managerOnBreak"](Main.managerBreakEndTime), "WHISPER", nil, sender) 
  else
    if (not Main:InWaitlist(target)) then
      Main:SetConvState(target, "STARTED")
      Main:RequestWaitlist(sender, target)
    else
      Main:UpdateWaitlistSender(sender, target)
    end
  end
end

-- Waitlist functions

function Main:GetWaitlistInfo()
  return DB.waitlistInfo
end

function Main:InWaitlist(target)
  local waitlist = Main:GetWaitlistInfo().waitlist
  for i=1,#waitlist do
    if (waitlist[i].target == target) then return true end
  end
end

function Main:ResetWaitlistInfo()
  DB.waitlistInfo.waitlist = {}
  DB.waitlistInfo.requestsBySender = {}
  DB.waitlistInfo.requestsByTarget = {}
  GUI:Update()
end

function Main:RequestWaitlist(sender, target)
  local waitlistInfo = Main:GetWaitlistInfo()
  
  local requestInfo = {}
  requestInfo.sender = sender
  requestInfo.target = target
  requestInfo.time = time()
  table.insert(waitlistInfo.waitlist, requestInfo)

  waitlistInfo.requestsBySender[sender] = requestInfo
  waitlistInfo.requestsByTarget[target] = requestInfo

  if (DB.enableSounds) then
    PlaySound(8960)
  end
  print(L["requestWaitlist"](target, sender))

  SimpleThrottle:SendChatMessage(L["requestWaitlistReply1"], "WHISPER", nil, sender, true)
  SimpleThrottle:SendChatMessage(L["requestWaitlistReply2"](target), "WHISPER", nil, sender, true)

  GUI:Update()
end

function Main:RemoveWaitlist(sender, silent)
  local waitlistInfo = Main:GetWaitlistInfo()
  local found = false
  for i=1,#waitlistInfo.waitlist do
    local request = waitlistInfo.waitlist[i]
    if ((request.sender == sender) or (request.target == sender)) then
      table.remove(waitlistInfo.waitlist, i)
      sender = request.sender
      target = request.target
      found = true
      break
    end
  end

  if (found) then
    waitlistInfo.requestsBySender[sender] = nil
    waitlistInfo.requestsByTarget[target] = nil

    if (not silent) then
      if (DB.enableSounds) then
        PlaySound(8959)
      end
      print(L["cancelRequest"](target, sender))
      SimpleThrottle:SendChatMessage(L["cancelRequestReply"], "WHISPER", nil, sender, true)
    end
    
    GUI:Update()
  end
end

function Main:UpdateWaitlistSender(sender, target)
  local waitlistInfo = Main:GetWaitlistInfo()
  local requestInfo = waitlistInfo.requestsByTarget[target]

  print(L["updateWaitlist"](target, sender))
  waitlistInfo.requestsBySender[requestInfo.sender] = nil
  waitlistInfo.requestsBySender[sender] = requestInfo
  requestInfo.sender = sender

  if (sender ~= target) then
    SimpleThrottle:SendChatMessage(L["updateWaitlistReply"], "WHISPER", nil, sender, true)
  end

  GUI:Update()
end

function Main:NotifyClearWaitlist()
  local waitlistInfo = Main:GetWaitlistInfo()
  for i=1,#waitlistInfo.waitlist do
    local request = waitlistInfo.waitlist[i]
    local rsp = DB.doneMessage
    SimpleThrottle:SendChatMessage(rsp, "WHISPER", nil, request.sender)
    if (request.sender ~= request.target) then
      SimpleThrottle:SendChatMessage(rsp, "WHISPER", nil, request.target)
    end
  end
  Main:ResetWaitlistInfo()
end

function Main:WhisperCommands(target)
  local rsps = {}
  table.insert(rsps, L["whisperCommandHelp1"])
  table.insert(rsps, L["whisperCommandHelp2"])
  table.insert(rsps, L["whisperCommandHelp3"])
  for i=1,#rsps do
    SimpleThrottle:SendChatMessage(rsps[i], "WHISPER", nil, target, true)
  end
end

function Main:FixWaitlistRefs()
  local waitlistInfo = Main:GetWaitlistInfo()
  waitlistInfo.requestsByTarget = {}
  waitlistInfo.requestsBySender = {}
  local waitlist = waitlistInfo.waitlist
  for i=1,#waitlist do
    waitlistInfo.requestsByTarget[waitlist[i].target] = waitlist[i]
    waitlistInfo.requestsBySender[waitlist[i].sender] = waitlist[i]
  end
end

-- Balance functions

function Main:ChargeAll()
  local partyNames = Main:GetPartyNames()
  for i=1,#partyNames do
    Main:ChargeBalance(partyNames[i], true)
  end
  GUI:Update()
end

function Main:ChargeBalance(name, noUpdateGui)
  local c = DB.overrideCharge[name] or DB.cost
  DB.accountBalance[name] = (DB.accountBalance[name] or 0) - c
  if (DB.accountBalance[name] < 0) then
    print(L["balanceNegative"](name, DB.accountBalance[name]))
  end
  if (not DB.enableBalanceWhisperThreshold) then
    SimpleThrottle:SendChatMessage(L["balanceCharged"](c, DB.accountBalance[name]), "WHISPER", nil, name)
  elseif (DB.accountBalance[name] < DB.balanceWhisperThreshold) then
    SimpleThrottle:SendChatMessage(L["balance"](DB.accountBalance[name]), "WHISPER", nil, name)
  end
  if (DB.accountBalance[name] == 0 ) then DB.accountBalance[name] = nil end
  if (not noUpdateGui) then
    GUI:Update()
  end
end

function Main:SetOverrideDefaultCharge(name, amount)
  local a
  if (DB.cost == amount) then
    print(L["overrideRemove"](name))
    a = nil
  else
    print(L["overrideSet"](name, amount))
    a = amount
  end
  DB.overrideCharge[name] = a
  GUI:Update()
end

function Main:GetOverrideDefaultCharge(name)
  return DB.overrideCharge[name]
end

function Main:AddBalance(name, amount)
  DB.accountBalance[name] = (DB.accountBalance[name] or 0) + amount
  GUI:Update()
  SimpleThrottle:SendChatMessage(L["addBalance"](amount, DB.accountBalance[name]), "WHISPER", nil, name)

  if (DB.accountBalance[name] == 0 ) then DB.accountBalance[name] = nil end
end

function Main:RefundBalance(name, amount)
  DB.accountBalance[name] = (DB.accountBalance[name] or 0) - amount
  GUI:Update()
  SimpleThrottle:SendChatMessage(L["refundBalance"](amount, DB.accountBalance[name]), "WHISPER", nil, name)
end

function Main:GetBalance(name)
  return (DB.accountBalance[name] or 0)
end

function Main:SetBalance(name, amount)
  DB.accountBalance[name] = amount
  GUI:Update()
end

function Main:BalanceExists(name)
  return (DB.accountBalance[name] ~= nil)
end

function Main:ResetBalance(name)
  print(L["resetBalance"](name, DB.accountBalance[name]))
  DB.accountBalance[name] = nil
end

function Main:PrintBalance(name)
  print(L["printBalance"](name, Main:GetBalance(name)))
end

function Main:WhisperBalance(name)
  if (DB.accountBalance[name] ~= nil) then
    SimpleThrottle:SendChatMessage(L["whisperBalance"](DB.accountBalance[name]), "WHISPER", nil, name)
  else
    SimpleThrottle:SendChatMessage(L["whisperBalanceMissing"], "WHISPER", nil, name)
  end
end

-- Trade handling functions

function Main:HandleTradeMoneyChanged()
  Main.tradeMoney = tonumber(GetTargetTradeMoney())
  Main.tradeName = UnitName("npc") or "Unknown"
end

function Main:HandleTradeAcceptUpdate(playerAgreed, targetAgreed)
  if (playerAgreed == 1) then
    Main.playerTradeMoney = tonumber(GetPlayerTradeMoney())
    Main.tradeName = UnitName("npc") or "Unknown"
  end
end

function Main:HandleUIInfoMessage(msg)
  if (msg == "Trade complete.") then
    if (Main:IsPartyName(Main.tradeName) and (Main.tradeMoney > 9999)) then
      Main:AddBalance(Main.tradeName, Main.tradeMoney / 10000)
    elseif ((Main.playerTradeMoney > 9999)) then
      Main:RefundBalance(Main.tradeName, Main.playerTradeMoney / 10000)
    elseif (Main.tradeMoney > 0) then
      print(L["tradeNotAdded"](Main.tradeMoney, Main.tradeName))
    elseif (Main.playerTradeMoney > 0) then
      print(L["tradeNotRefunded"](Main.playerTradeMoney, Main.tradeName))
    end
    Main.tradeName = "Unknown"
    Main.tradeMoney = 0
    Main.playerTradeMoney = 0
  elseif (msg == "Trade cancelled.") then
    Main.tradeName = "Unknown"
    Main.tradeMoney = 0
    Main.playerTradeMoney = 0
  end
end

-- ETA functions

function Main:GetETAInfo(addon, target)
  local etaInfo = {}

  local waitlistInfo = Main:GetWaitlistInfo()
  local requestInfo = waitlistInfo.requestsByTarget[target] or waitlistInfo.requestsBySender[target]

  if (requestInfo ~= nil) then
    local found = false
    for i=1,#waitlistInfo.waitlist do
      if (requestInfo == waitlistInfo.waitlist[i]) then
        etaInfo.lineSpot = i
        etaInfo.inLine = true
        break
      end
    end
  else
    etaInfo.lineSpot = #waitlistInfo.waitlist
  end

  return etaInfo
end

function Main:WhisperEta(target)
  local etaInfo = Main:GetETAInfo(false, target)

  if (etaInfo.lineSpot ~= nil) then
    if (etaInfo.inLine ~= nil) then
      SimpleThrottle:SendChatMessage(L["whisperEtaPosition"](Main:GetCardinalNumber(etaInfo.lineSpot)), "WHISPER", nil, target, true)
    else
      SimpleThrottle:SendChatMessage(L["whisperEtaLength"](etaInfo.lineSpot), "WHISPER", nil, target, true)
    end
    
  else
    SimpleThrottle:SendChatMessage(L["whisperEtaError"], "WHISPER", nil, target)
  end
end

-- Group/Raid functions

function Main:HandleSystemMessage(msg)
  local head, tail, player = string.find(msg, string.gsub(ERR_ALREADY_IN_GROUP_S, "%%s", "(%%S+)"))
  if (head and not Main.groupRoster[player]) then
    Main:HandleInviteFail(player, L["whisperInviteFailedInGroup"])
  else
    head, tail, player = string.find(msg, string.gsub(ERR_DECLINE_GROUP_S, "%%s", "(%%S+)"))
    if (head) then
      Main:HandleInviteFail(player, L["whisperInviteFailedDeclined"])
    else
      head, tail, player = string.find(msg, "Cannot find '(.+)'.")
      if (head) then
        -- print(player.." is offline right now, and can't be invited.")
      end
    end
  end
end

function Main:TriggerInvite(target)
  local requestInfo = Main:GetWaitlistInfo().requestsByTarget[target]
  if (requestInfo ~= nil) then
    if (requestInfo.sender ~= requestInfo.target) then
      SimpleThrottle:SendChatMessage(L["whisperBoostReady"](requestInfo.sender, target), "WHISPER", nil, requestInfo.sender)

      SimpleThrottle:SendChatMessage(L["whisperInviteSent"](target), "WHISPER", nil, target)
      InviteUnit(target)
    else
      SimpleThrottle:SendChatMessage(L["whisperInviteSent"](target), "WHISPER", nil, target)
      InviteUnit(target)
    end
    if (Main.groupRoster[target]) then
      Main:SetConvState(target, "INRAID")
    else
      Main:SetConvState(target, "INVITED")
    end
    GUI:Update()
  else
    print(L["inviteOther"](target))
  end
end

function Main:GetReadyWhisper(target)
  local requestInfo = Main:GetWaitlistInfo().requestsByTarget[target]
  if (requestInfo ~= nil) then
    if (requestInfo.sender ~= requestInfo.target) then
      SimpleThrottle:SendChatMessage(L["whisperGetReadySender"](requestInfo.sender, target), "WHISPER", nil, requestInfo.sender)
    end
    SimpleThrottle:SendChatMessage(L["whisperGetReadyTarget"](target), "WHISPER", nil, target)
  else
    print(L["getReadyOther"](target))
  end
end

function Main:HandleInviteFail(player, reason)
  local requestInfo = Main:GetWaitlistInfo().requestsByTarget[player]
  if (requestInfo ~= nil) then
    SimpleThrottle:SendChatMessage(L["whisperInviteFailed"](reason), "WHISPER", nil, player)
  end
end

function Main:HandleInviteRequest(player)
  local state = Main:GetConvState(player)
  if ((state == "INVITED") or (state == "INRAID")) then
    InviteUnit(player)
  else
    SimpleThrottle:SendChatMessage(L["whipserInviteNotReady"], "WHISPER", nil, player)
  end
end

function Main:HandleGroupRosterUpdate()
  for name,in_raid in pairs(Main.groupRoster) do
    Main.groupRoster[name] = false
  end
  for i=1,GetNumGroupMembers() do
    local name = UnitName("raid"..i) or UnitName("party"..(i-1)) or UnitName("player")
    if (name ~= "Unknown") then
      if (Main.groupRoster[name] == nil) then
        Main:RemoveWaitlist(name, true)
        Main:AddPartyName(name)
        if not Main:BalanceExists(name) then
          Main:SetBalance(name, 0)
        end
      end
      Main:SetConvState(name, "INRAID")
      Main.groupRoster[name] = true
    end
  end
  for name,in_raid in pairs(Main.groupRoster) do
    if (in_raid == false) then
      Main:RemovePartyName(name)
      Main.groupRoster[name] = nil
    end
  end
end

-- Party tracking functions

function Main:AddPartyName(name)
  if (not Main:IsPartyName(name) and (name ~= UnitName("player")) and not Main:IsBlacklist(name)) then
    table.insert(Main.partyNames, name)
    GUI:Update()
  end
end

function Main:RemovePartyName(name)
  for i=1,#Main.partyNames do
    if (name == Main.partyNames[i]) then
      table.remove(Main.partyNames, i)
      GUI:Update()
      break
    end
  end
end

function Main:IsPartyName(name)
  for i=1,#Main.partyNames do
    if (name == Main.partyNames[i]) then
      return true
    end
  end
  return false
end

function Main:GetPartyNames()
  return Main.partyNames or {}
end

-- Blacklist functions

function Main:AddBlacklist(player, reason)
  DB.blacklist[player] = reason
end

function Main:RemoveBlacklist(player)
  DB.blacklist[player] = nil
end

function Main:IsBlacklist(player)
  return (DB.blacklist[player] ~= nil)
end

-- Print functions

function Main:PrintWaitlist()
  local waitlist = Main:GetWaitlistInfo().waitlist
  print(L["printWaitlist"])
  for i=1,#waitlist do 
    print("  "..waitlist[i].target.." - "..waitlist[i].sender)
  end
end

function Main:PrintBlacklist()
  print(L["printBlacklist"])
  for k,v in pairs(DB.blacklist) do
    print("  "..k.." - "..v)
  end
end

function Main:PrintUsage()
  print(L["printUsage"])
end

-- Helper functions

function Main:RemoveServerFromName(name)
  local i = name:find("-")
  if (i) then
    name = string.sub(name, 1, i-1)
  end
  return name
end

function Main:GetCardinalNumber(num)
  if (type(num) == "string") then num = tonumber(num) end
  if (num == 1) then return "1st"
  elseif (num == 2) then return "2nd"
  elseif (num == 3) then return "3rd"
  else return num.."th" end
end

function Main:SetConvState(sender, state)
  Main.convState[sender] = state
end

function Main:GetConvState(sender)
  if (Main.convState[sender] == nil) then
    return "IDLE"
  else
    return Main.convState[sender]
  end
end

function Main:FormatCharName(str)
  local bytesPerChar = UTF8.utf8charbytes(str, 1)
  
  
end