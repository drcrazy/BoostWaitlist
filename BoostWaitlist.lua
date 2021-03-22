local addonName, addon = ...

-- Create saved global vars
_G.BoostWaitlistDB = _G.BoostWaitlistDB or {}

-- Create local vars
local DB -- assigned during ADDON_LOADED
local Main = addon
local GUI = addon.GUI


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
    print("BoostWaitlist Addon Loading")
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
        SendChatMessage(DB.inactivereplymsg, "WHISPER", nil, sender)
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
      print("Your initial reply has been set to empty.")
    elseif (strlen(cmd[2]) < 105) then
      DB.initialReply = cmd[2]
      print("Your initial reply has been set.")
    else
      print("Sorry, that reply is too long and will cause errors. Maximum 104 characters for this portion of the message.")
    end
    used = 1
  elseif (cmd[1] == "setdonemessage") then
    cmd = {strsplit(" ", msg, 2)}
    if (cmd[2] == nil) then
      DB.doneMessage = ""
      print("Your done message was empty - the feature is now disabled.")
    elseif (strlen(cmd[2]) < 250) then
      DB.doneMessage = cmd[2]
      print("Your done message has been set.")
    else
      print("Sorry, that message is too long and will cause errors. Maximum 250 characters.")
    end
    used = 1
  elseif (cmd[1] == "inactivereplymessage") then
    cmd = {strsplit(" ", msg, 2)}
    if (cmd[2] == nil) then
      DB.inactivereplymsg = ""
      print("Your inactive reply message has been set to empty.")
    elseif (strlen(cmd[2]) < 201) then
      DB.inactivereplymsg = cmd[2]
      print("Your inactive reply message has been set.")
    else
      print("Sorry, that reply is too long and will cause errors. Maximum 200 characters for this portion of the message.")
    end
    used = 1
  elseif (cmd[1] == "inactivereply") then
    if (cmd[2] == "on") then
      DB.inactivereply = true
      print("Enabling auto-replies when boostees appear to be asking for boosts while inactive.")
      used = 1
    elseif (cmd[2] == "off") then
      DB.inactivereply = false
      print("Disabling auto-replies when boostees appear to be asking for boosts while inactive.")
      used = 1
    end
  elseif (#cmd == 1) then
    if (cmd[1] == "help") then
      Main:PrintUsage()
      used = 1
    elseif (cmd[1] == "gui") then
      GUI:Show()
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
        print("Enabling auto-billing on instance reset.")
        GUI:Update()
        used = 1
      elseif (cmd[2] == "off") then
        DB.autobill = false
        print("Disabling auto-billing on instance reset.")
        GUI:Update()
        used = 1
      end
    elseif (cmd[1] == "enablewaitlist") then
      if (cmd[2] == "on") then
        DB.enableWaitlist = true
        print("Enabling waitlist features.")
        used = 1
      elseif (cmd[2] == "off") then
        DB.enableWaitlist = false
        print("Disabling waitlist features.")
        used = 1
      end
    elseif (cmd[1] == "maxwaitlist") then
        if (tonumber(cmd[2]) ~= nil) then
          DB.maxWaitlist = cmd[2]
          print("Setting maximum number of boostees on waitlist to: " .. cmd[2])
        else
          print("Incorrect usage: /boost maxwaitlist <##>")
        end
        used = 1
    elseif (cmd[1] == "enablebalancewhisperthreshold") then
      if (cmd[2] == "on") then
        DB.enableBalanceWhisperThreshold = true
        print("Enabling balance whisper threshold. Boostees will not be whispered until their balance meets")
        print(DB.balanceWhisperThreshold .. "g.  /boost balancewhisperthreshold <##> to change this value.")
        used = 1
      elseif (cmd[2] == "off") then
        DB.enableBalanceWhisperThreshold = false
        print("Disabling balance whisper threshold features.  Boostees will recieve whispers every time they are billed.")
        used = 1
      end
    elseif (cmd[1] == "balancewhisperthreshold") then
      if (tonumber(cmd[2]) ~= nil) then
        DB.balanceWhisperThreshold = cmd[2]
        print("Setting balance whisper threshold to: " .. cmd[2])
      else
        print("Incorrect usage: /boost balancewhisperthreshold <##>")
      end
      used = 1
    elseif (cmd[1] == "enablestats") then
      if (cmd[2] == "on") then
        DB.enableStats = true
        print("Enabling stats features. (Not Yet Implemented)")
        used = 1
      elseif (cmd[2] == "off") then
        DB.enableStats = false
        print("Disabling stats features.")
        used = 1
      end
    elseif (cmd[1] == "sounds") then
      if (cmd[2] == "on") then
        DB.enableSounds = true
        print("Enabling sound triggers for waitlist signup")
        used = 1
      elseif (cmd[2] == "off") then
        DB.enableSounds = false
        print("Disabling sound triggers for waitlist signup")
        used = 1
      end
    elseif (cmd[1] == "setcost") then
      local cost = tonumber(cmd[2])
      if (cost ~= nil) then
        DB.cost = cost
        print("Cost changed successfully")
        GUI:Update()
      else
        print("Invalid cost input")
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
        print(cmd[2].." isn't in the waitlist right now")
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
          print("Invalid amount input")
	end
        used = 1
      end
    end
  end
  if (used == 0) then
    print("Unsupported input command: "..msg)
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
  print("BoostWaitlist addon activated")
  DB.active = true
  Main.groupRoster = {}
  Main:HandleGroupRosterUpdate()
  if (DB.everActive == false) then
    GUI:ShowMinimapIcon()
  end
  GUI:UpdateBrokerTexture()
end

function Main:HandleAddonOff()
  print("BoostWaitlist addon deactivated")
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
      local rsp = "I'm sorry, but the waitlist is currently full."
      SendChatMessage(rsp, "WHISPER", nil, sender)
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
        local rsp = "The format for this command is: !waitlist <alt name>"
        SendChatMessage(rsp, "WHISPER", nil, sender)
        rsp = "For example, !waitlist Tekkie"
        SendChatMessage(rsp, "WHISPER", nil, sender)
      end
    else
      local rsp = "I'm sorry, but the waitlist is currently full."
      SendChatMessage(rsp, "WHISPER", nil, sender)
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
    local rsp = "Sorry, that command is not supported."
    SendChatMessage(rsp, "WHISPER", nil, sender)
    Main:WhisperCommands(sender)
  end
end

function Main:StartConv(sender)
  local groupFormSentence = ""
  if (DB.forming) then
    groupFormSentence = "I'm still forming the group, so you could get into my first run."
  else
    local num = Main:GetCardinalNumber(#Main:GetWaitlistInfo().waitlist + 1)
    -- 63 chars + 2 for num
    groupFormSentence = "The group is full right now, and you would be "..num.." in the waitlist."
  end
  -- 81 chars
  local rsp = DB.initialReply.." "..groupFormSentence.." Reply with '!waitlist' to get put on the waitlist, or '!commands' for more info."
  SendChatMessage(rsp, "WHISPER", nil, sender)
  Main:SetConvState(sender, "STARTED")
end

function Main:RequestWaitlistFromWhisper(sender, target)
  if (Main.managerOnBreak) then
    local rsp = "Sorry, I'm taking a break right now. I expect to be back at "..Main.managerBreakEndTime.."."
    SendChatMessage(rsp, "WHISPER", nil, sender) 
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
  print("Waitlist request for "..target.." from "..sender)

  local rsp = "Thanks. A group invite will be sent as soon as I'm ready. You can reply '!line' to see your place in the waitlist."
  SendChatMessage(rsp, "WHISPER", nil, sender)
  rsp = "If you want to log into a different character while waiting, just send me '!waitlist "..target.."' from that character."
  SendChatMessage(rsp, "WHISPER", nil, sender)

  GUI:Update()
end

function Main:RemoveWaitlist(sender, joinedGroup)
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

    if (not joinedGroup) then
      if (DB.enableSounds) then
        PlaySound(8959)
      end
      print("Cancel request for "..target.." from "..sender)
    end
    
    GUI:Update()
  end
end

function Main:UpdateWaitlistSender(sender, target)
  local waitlistInfo = Main:GetWaitlistInfo()
  local requestInfo = waitlistInfo.requestsByTarget[target]

  print("Updating waitlist sender = "..sender.." target = "..target)
  waitlistInfo.requestsBySender[requestInfo.sender] = nil
  waitlistInfo.requestsBySender[sender] = requestInfo
  requestInfo.sender = sender

  if (sender ~= target) then
    local rsp = "Thanks. I'll whisper you when I'm ready for you to log over."
    SendChatMessage(rsp, "WHISPER", nil, sender)
  end

  GUI:Update()
end

function Main:NotifyClearWaitlist()
  local waitlistInfo = Main:GetWaitlistInfo()
  for i=1,#waitlistInfo.waitlist do
    local request = waitlistInfo.waitlist[i]
    local rsp = DB.doneMessage
    SendChatMessage(rsp, "WHISPER", nil, request.sender)
    if (request.sender ~= request.target) then
      SendChatMessage(rsp, "WHISPER", nil, request.target)
    end
  end
  Main:ResetWaitlistInfo()
end

function Main:WhisperCommands(target)
  local rsps = {}
  table.insert(rsps, "!waitlist - sign up for boosts")
  table.insert(rsps, "!waitlist <alt name> - sign up to get boosts while waiting on a different character")
  table.insert(rsps, "!line - get current waitlist length")
  for i=1,#rsps do
    SendChatMessage(rsps[i], "WHISPER", nil, target)
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
  if (DB.accountBalance[name] ~= nil) then
    DB.accountBalance[name] = DB.accountBalance[name] - c
    if (DB.accountBalance[name] < 0) then
      print(name.." now has a negative account balance: "..DB.accountBalance[name].."g")
    end
    if (not DB.enableBalanceWhisperThreshold) then
      local rsp = c.."g was charged for your boost. New balance: "..DB.accountBalance[name].."g"
      SendChatMessage(rsp, "WHISPER", nil, name)
    elseif (DB.accountBalance[name] < DB.balanceWhisperThreshold) then
      local rsp = "Your current balance has changed. New balance: "..DB.accountBalance[name].."g"
      SendChatMessage(rsp, "WHISPER", nil, name)
    end
    if (not noUpdateGui) then
      GUI:Update()
    end
  end
end

function Main:SetOverrideDefaultCharge(name, amount)
  local a
  if (DB.cost == amount) then
    print('BoostWaitlist - Removing override for '..name)
    a = nil
  else
    print('BoostWaitlist - Setting override for '..name..' to '..amount..'g. Set to default charge amount to remove.')
    a = amount
  end
  DB.overrideCharge[name] = a
  GUI:Update()
end

function Main:GetOverrideDefaultCharge(name)
  return DB.overrideCharge[name]
end



function Main:AddBalance(name, amount)
  if (DB.accountBalance[name] ~= nil) then
    DB.accountBalance[name] = DB.accountBalance[name] + amount
  else
    DB.accountBalance[name] = amount
  end
  GUI:Update()
  local rsp = amount.."g was added to your balance. New balance: "..DB.accountBalance[name].."g"
  SendChatMessage(rsp, "WHISPER", nil, name)
end

function Main:RefundBalance(name, amount)
  if (DB.accountBalance[name] ~= nil) then
    DB.accountBalance[name] = DB.accountBalance[name] - amount
    GUI:Update()
    local rsp = amount.."g was refunded from your balance. New balance: "..DB.accountBalance[name].."g"
    SendChatMessage(rsp, "WHISPER", nil, name)
  end
end

function Main:GetBalance(name)
  if (DB.accountBalance[name] ~= nil) then
    return DB.accountBalance[name]
  else
    return 0
  end
end

function Main:SetBalance(name, amount)
  DB.accountBalance[name] = amount
  GUI:Update()
end

function Main:BalanceExists(name)
  return (DB.accountBalance[name] ~= nil)
end

function Main:ResetBalance(name)
  print("Resetting "..name.."'s balance. Prior balance: "..DB.accountBalance[name].."g")
  DB.accountBalance[name] = nil
end

function Main:PrintBalance(name)
  print(name.."'s current balance is: "..Main:GetBalance(name).."g")
end

function Main:WhisperBalance(name)
  if (DB.accountBalance[name] ~= nil) then
    local rsp = "Current balance: "..DB.accountBalance[name].."g"
    SendChatMessage(rsp, "WHISPER", nil, name)
  else
    local rsp = "No active balance is being tracked for your character."
    SendChatMessage(rsp, "WHISPER", nil, name)
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
    if (Main:BalanceExists(Main.tradeName) and Main:IsPartyName(Main.tradeName) and (Main.tradeMoney > 9999)) then
      Main:AddBalance(Main.tradeName, Main.tradeMoney / 10000)
    elseif (Main:BalanceExists(Main.tradeName) and (Main.playerTradeMoney > 9999)) then
      Main:RefundBalance(Main.tradeName, Main.playerTradeMoney / 10000)
    elseif (Main.tradeMoney > 0) then
      print("Saw trade of "..Main.tradeMoney.."c from "..Main.tradeName.." but it wasn't added to a balance.")
    elseif (Main.playerTradeMoney > 0) then
      print("Saw trade of "..Main.playerTradeMoney.."c to "..Main.tradeName.." but it didn't refund a balance.")
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
    local rsp
    if (etaInfo.inLine ~= nil) then
      rsp = "You are currently "..Main:GetCardinalNumber(etaInfo.lineSpot).." in the waitlist."
    else
      rsp = "The line is currently "..etaInfo.lineSpot.." players long."
    end
    SendChatMessage(rsp, "WHISPER", nil, target)
  else
    local rsp = "Sorry, I can't tell what place you are in the waitlist right now. I may have had a disconnect, but I will handle things manually."
    SendChatMessage(rsp, "WHISPER", nil, target)
  end
end

-- Group/Raid functions

function Main:HandleSystemMessage(msg)
  local head, tail, player = string.find(msg, "(.+) is already in a group.")
  if (head and not Main.groupRoster[player]) then
    Main:HandleInviteFail(player, "are in a group")
  else
    head, tail, player = string.find(msg, "(.+) declines your group invitation.")
    if (head) then
      Main:HandleInviteFail(player, "declined")
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
      local rsp = "Hi "..requestInfo.sender..", the boosts you requested for "..target.." are ready. Please log over and whisper me '!invite' from "..target.."."
      SendChatMessage(rsp, "WHISPER", nil, requestInfo.sender)

      local rsp = "Hi "..target..", your invite for boosts has been sent."
      SendChatMessage(rsp, "WHISPER", nil, target)
      InviteUnit(target)
    else
      local rsp = "Hi "..target..", your invite for boosts has been sent."
      SendChatMessage(rsp, "WHISPER", nil, target)
      InviteUnit(target)
    end
    if (Main.groupRoster[target]) then
      Main:SetConvState(target, "INRAID")
    else
      Main:SetConvState(target, "INVITED")
    end
    GUI:Update()
  else
    print("BoostWaitlist - triggering invite on "..target.." which doesn't have requestInfo")
  end
end

function Main:GetReadyWhisper(target)
  local requestInfo = Main:GetWaitlistInfo().requestsByTarget[target]
  if (requestInfo ~= nil) then
    if (requestInfo.sender ~= requestInfo.target) then
      local rsp = "Hi "..requestInfo.sender..", the boosts you requested for "..target.." will be ready soon. If "..target.." isn't ready outside, then please start heading over here when you get a chance."
      SendChatMessage(rsp, "WHISPER", nil, requestInfo.sender)
    end
    local rsp = "Hi "..target..", I'm almost ready to invite you for boosts. Please start heading over here when you get a chance."
    SendChatMessage(rsp, "WHISPER", nil, target)
  else
    print("BoostWaitlist - triggering whisper on "..target.." which doesn't have requestInfo")
  end
end

function Main:HandleInviteFail(player, reason)
  local requestInfo = Main:GetWaitlistInfo().requestsByTarget[player]
  if (requestInfo ~= nil) then
    local rsp = "Hi, I tried to invite you for boosts but you "..reason..". Reply with '!invite' to get another invite or '!cancel' to cancel your boosting request."
    SendChatMessage(rsp, "WHISPER", nil, player)
  end
end

function Main:HandleInviteRequest(player)
  local state = Main:GetConvState(player)
  if ((state == "INVITED") or (state == "INRAID")) then
    InviteUnit(player)
  else
    local rsp = "Sorry, I'm not ready to invite you for your boost just yet."
    SendChatMessage(rsp, "WHISPER", nil, player)
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
  print("BoostWaitlist printing waitlist")
  for i=1,#waitlist do 
    print("  "..waitlist[i].target.." - "..waitlist[i].sender)
  end
end

function Main:PrintBlacklist()
  print("BoostWaitlist printing blacklist")
  for k,v in pairs(DB.blacklist) do
    print("  "..k.." - "..v)
  end
end

function Main:PrintUsage()
  print("Printing supported input commands (starting with /boost)")
  print("  on -- enable the addon")
  print("  off -- disable the addon")
  print("  gui -- open the gui (/boost also does this)")
  print("  config -- open the conifguration panel")
  print("  setreply <reply sentence> -- set the initial reply to send to whispers")
  print("  reset -- reset all waitlist info")
  print("  enablebalancewhisperthreshold [on/off] -- whisper balance only when threshold met")
  print("  balancewhisperthreshold -- set the threshold to be met for whispers to be set")
  print("  enablewaitlist [on/off] -- enable/disable waitlist features")
  print("  maxwaitlist <##> -- set the maximum number of boosetees on the waitlist")
  print("  add <boostee> -- add boostee to waitlist manually")
  print("  blacklist <boostee> <reason> -- disable autoreplies for the boostee")
  print("  remove blacklist <boostee> -- reenable autoreplies for the boostee")
  print("  print waitlist -- output waitlist to terminal")
  print("  print blacklist -- output blacklist to terminal")
  print("  add <boostee> <waiting char> -- add player to waitlist manually")
  print("  connect <boostee> <waiting char> -- update the waiting character name")
  print("  break <time> -- take a break until time")
  print("  break done -- back from the break")
  print("  sounds [on/off] -- enable or disable the sound triggers from waitlist signup")
  print("  minimap [show/hide] -- configure the minimap icon")
  print("  add balance <boostee> <amount> -- add balance to the boostee's account")
  print("  charge <boostee> -- add balance to the boostee's account")
  print("  print <balance> <boostee> -- print boostee's current balance")
  print("  reset <balance> <boostee> -- remove all balance related to boostee's account")
  print("  inactivereply [on/off] -- enables/disables auto-replies while inactive.")
  print("  inactivereplymessage <message> -- sets the inactive reply message")
  print("  autobill [on/off] -- enables/disables auto-billing on instance reset.")
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

