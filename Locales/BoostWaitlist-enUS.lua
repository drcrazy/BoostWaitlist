local L = LibStub("AceLocale-3.0"):NewLocale ("BoostWaitlist", "enUS", true, false) 
if not L then return end 

L["addonLoading"] = "BoostWaitlist Addon Loading"
L["setReply"] = "Your initial reply has been set."
L["setReplyEmpty"] = "Your initial reply has been set to empty."
L["setReplyTooLong"] = "Sorry, that reply is too long and will cause errors. Maximum 104 characters for this portion of the message."
L["setDone"] = "Your done message has been set."
L["setDoneEmpty"] = "Your done message was empty - the feature is now disabled."
L["setDoneTooLong"] = "Sorry, that message is too long and will cause errors. Maximum 250 characters."
L["inactiveReplyMessage"] = "Your inactive reply message has been set."
L["inactiveReplyMessageEmpty"] = "Your inactive reply message has been set to empty."
L["inactiveReplyMessageTooLong"] = "Sorry, that reply is too long and will cause errors. Maximum 200 characters for this portion of the message."
L["inactiveReplyEnabled"] = "Enabling auto-replies when boostees appear to be asking for boosts while inactive."
L["inactiveReplyDisabled"] = "Disabling auto-replies when boostees appear to be asking for boosts while inactive."
L["autoBillingEnabled"] = "Enabling auto-billing on instance reset."
L["autoBillingDisabled"] = "Disabling auto-billing on instance reset."
L["waitlistEnabled"] = "Enabling waitlist features."
L["waitlistDisabled"] = "Disabling waitlist features."
L["setMaxWaitlist"] = function(S)
	return 'Setting maximum number of boostees on waitlist to: ' .. S
end
L["setMaxWaitlistUsage"] = "Incorrect usage: /boost maxwaitlist <##>"
L["balanceWhisperThresholdEnabled"] = "Enabling balance whisper threshold. Boostees will not be whispered until their balance meets"
L["balanceWhisperThresholdValue"] = function(S)
  return S .. 'g.  /boost balancewhisperthreshold <##> to change this value.'
end
L["balanceWhisperThresholdDisabled"] = "Disabling balance whisper threshold features.  Boostees will recieve whispers every time they are billed."
L["balanceWhisperThresholdSet"] = function(S)
  return 'Setting balance whisper threshold to: ' .. S
end
L["balanceWhisperThresholdUsage"] = "Incorrect usage: /boost balancewhisperthreshold <##>"
L["statsEnabled"] = "Enabling stats features. (Not Yet Implemented)"
L["statsDisabled"] = "Disabling stats features."
L["soundEnabled"] = "Enabling sound triggers for waitlist signup"
L["soundDisabled"] = "Disabling sound triggers for waitlist signup"
L["setCost"] = "Cost changed successfully"
L["setCostInvalid"] = "Invalid cost input"
L["notInWaitlist"] = function(S)
  return S ..' is not in the waitlist right now'
end

L["invalidAmount"] = "Invalid amount input"
L["unsupportedCommand"] = function(S)
  return 'Unsupported input command: ' .. S
end
L["addonActivated"] = "BoostWaitlist addon activated"
L["addonDeactivated"] = "BoostWaitlist addon deactivated"
L["requestWaitlist"] = function(T,S)
  return 'Waitlist request for ' .. T ..' from ' .. S
end
L["cancelRequest"] = function(T,S)
  return 'Cancel request for ' .. T .. ' from ' .. S
end
L["updateWaitlist"] = function(T,S)
  return 'Updating waitlist sender = ' .. S ..' target = ' .. T
end
L["balanceNegative"] = function(N,B)
  return N .. ' now has a negative account balance: ' .. B .."g"
end
L["overrideRemove"] = function(N)
  return 'BoostWaitlist - Removing override for ' .. N
end
L["overrideSet"] = function(N,A)
  return 'BoostWaitlist - Setting override for ' .. N .. ' to ' .. A .. 'g. Set to default charge amount to remove.'
end
L["resetBalance"] = function(N, B)
  return 'Resetting ' .. N .. '\'s balance. Prior balance: ' .. B .. 'g'
end
L["printBalance"] = function(N,B)
  return N .. '\'s current balance is: ' .. B ..'g'
end
L["tradeNotAdded"] = function(M,N)
  return 'Saw trade of ' .. M ..'c from ' .. N ..' but it wasn\'t added to a balance.'
end
L["tradeNotRefunded"] = function(M,N)
  return 'Saw trade of ' .. M .. 'c to ' .. N ..' but it didn\'t refund a balance.'
  end
L["inviteOther"] = function(T)
  return 'BoostWaitlist - triggering invite on ' .. T ..' which doesn\'t have requestInfo'
end
L["getReadyOther"] = function(T)
  return 'BoostWaitlist - triggering whisper on ' .. T .. ' which doesn\'t have requestInfo'
end
L["printWaitlist"] = "BoostWaitlist printing waitlist"
L["printBlacklist"] = "BoostWaitlist printing blacklist"
L["printUsage"] = [[Printing supported input commands (starting with /boost)"
  on -- enable the addon
  off -- disable the addon
  gui -- open the gui (/boost also does this)
  config -- open the conifguration panel
  setreply <reply sentence> -- set the initial reply to send to whispers
  reset -- reset all waitlist info
  enablebalancewhisperthreshold [on/off] -- whisper balance only when threshold met
  balancewhisperthreshold -- set the threshold to be met for whispers to be set
  enablewaitlist [on/off] -- enable/disable waitlist features
  maxwaitlist <##> -- set the maximum number of boosetees on the waitlist
  add <boostee> -- add boostee to waitlist manually
  blacklist <boostee> <reason> -- disable autoreplies for the boostee
  remove blacklist <boostee> -- reenable autoreplies for the boostee
  print waitlist -- output waitlist to terminal
  print blacklist -- output blacklist to terminal
  add <boostee> <waiting char> -- add player to waitlist manually
  connect <boostee> <waiting char> -- update the waiting character name
  break <time> -- take a break until time
  break done -- back from the break
  sounds [on/off] -- enable or disable the sound triggers from waitlist signup
  minimap [show/hide] -- configure the minimap icon
  add balance <boostee> <amount> -- add balance to the boostee's account
  charge <boostee> -- add balance to the boostee's account
  chargeall -- charge all boostees in the party
  print balance <boostee> -- print boostee's current balance
  reset balance <boostee> -- remove all balance related to boostee's account
  inactivereply [on/off] -- enables/disables auto-replies while inactive.
  inactivereplymessage <message> -- sets the inactive reply message
  autobill [on/off] -- enables/disables auto-billing on instance reset.
  ]]


-- Chat messages. Keep'em short!
L["waitlistFull"] = "I'm sorry, but the waitlist is currently full."
L["waitlistExample1"] = "The format for this command is: !waitlist <alt name>"
L["waitlistExample2"] = "For example, !waitlist Tekkie"
L["unsupportedCommandShort"] = "Sorry, that command is not supported."
L["groupForming"] = "I'm still forming the group, so you could get into my first run."
-- 63 chars + 2 for num
L["groupFull"] = function(S)
  return 'The group is full right now, and you would be ' .. S .. ' in the waitlist.'
end
-- 81 chars
L["groupFormSentence"] = function(I, S)
  return I .. ' ' .. S ..' Reply with "!waitlist" to get put on the waitlist, or "!commands" for more info.'
end
L["managerOnBreak"] = function(S)
  return 'Sorry, I am taking a break right now. I expect to be back at ' .. S ..'.'
end
L["requestWaitlistReply1"] = "Thanks. A group invite will be sent as soon as I'm ready. You can reply '!line' to see your place in the waitlist."
L["requestWaitlistReply2"] = function(S)
  return 'If you want to log into a different character while waiting, just send me \'!waitlist ' .. S .. '\' from that character.'
end
L["cancelRequestReply"] = "Thanks. I'll cancel your request to join my boosts."
L["updateWaitlistReply"] = "Thanks. I'll whisper you when I'm ready for you to log over."
L["whisperCommandHelp1"] = "!waitlist - sign up for boosts"
L["whisperCommandHelp2"] = "!waitlist <alt name> - sign up to get boosts while waiting on a different character"
L["whisperCommandHelp3"] = "!line - get current waitlist length"
L["balanceCharged"] = function(C,B)
  return C .. 'g was charged for your boost. New balance: ' .. B .. 'g'
end
L["balance"] = function(B)
  return 'Your current balance has changed. New balance: ' .. B .. 'g'
end
L["addBalance"] = function(A,B)
  return A .. 'g was added to your balance. New balance: ' .. B ..'g'
end
L["refundBalance"] = function(R,B)
  return R ..'g was refunded from your balance. New balance: ' .. B .. 'g'
end
L["whisperBalance"] = function(B)
  return 'Current balance: ' .. B .. 'g'
end
L["whisperBalanceMissing"] = "No active balance is being tracked for your character."
L["whisperEtaPosition"] = function(N)
  return 'You are currently ' .. N ..' in the waitlist.'
end
L["whisperEtaLength"] = function(N)
  return 'The line is currently ' .. N ..' players long.'
end
L["whisperEtaError"] = "Sorry, I can't tell what place you are in the waitlist right now. I may have had a disconnect, but I will handle things manually."
L["whisperBoostReady"] = function(S,T)
  return 'Hi ' .. S .. ', the boosts you requested for ' .. T ..' are ready. Please log over and whisper me \'!invite\' from ' .. T ..'.'
end
L["whisperInviteSent"] = function(T)
  return 'Hi ' .. T ..', your invite for boosts has been sent.'
end
L["whisperGetReadySender"] = function(S,T)
  return 'Hi ' .. S ..', the boosts you requested for ' .. T .. ' will be ready soon. If ' .. T ..' isn\'t ready outside, then please start heading over here when you get a chance.'
end
L["whisperGetReadyTarget"] = function(T)
  return 'Hi ' .. T .. ', I\'m almost ready to invite you for boosts. Please start heading over here when you get a chance.'
end
L["whisperInviteFailedInGroup"] = "are in a group";
L["whisperInviteFailedDeclined"] = "declined";
L["whisperInviteFailed"] = function(R)
  return 'Hi, I tried to invite you for boosts but you ' .. R .. '. Reply with \'!invite\' to get another invite or \'!cancel\' to cancel your boosting request.'
end
L["whipserInviteNotReady"] = "Sorry, I'm not ready to invite you for your boost just yet."
L["initialReply"] = "Thanks for your interest in my boosts."
L["whisperDone"] = "Hey, I'm done boosting for now. Sorry you didn't get a chance to join - I'll try to get you in next time!"
L["whisperInactive"] = "Thanks for your interest in my boosts, however, I'm currently inactive."

-- GUI. Interface!
L["Autobill"] = true
L["AutobillTooltip"] = "Automatically bill all players when instance reset is detected."
L["ChargeAll"] = "Charge All"
L["DefaultPrice"] = "Default Price:"
L["MinimapTooltipLeft"] = "LeftClick to open/close the BoostWaitlist GUI"
L["MinimapTooltipRight"] = "RightClick to activate BoostWaitlist"
L["MinimapTooltipSRight"] = "Shift+RightClick to open config panel"
L["DoneBoosting"] = "DONE_BOOSTING"
L["Forming"] = true
L["Full"] = true
L["Waitlist"] = true
L["WaitingOn"] = "Waiting On"
L["Actions"] = true
L["Remove"] = true
L["Invite"] = true
L["Whisper"] = true
L["Name"] = true
L["Bal"] = true
L["Cost"] = true
L["Trade"] = true
L["Add"] = true
L["Charge"] = true

-- GUI. Option!
L["General"] = true
L["EminimapIcon"] = "Enable minimap icon"
L["EminimapIconTT"] = "Show BoostWaitlist button around minimap."
L["EStats"] = "Enable stats (NYI)"
L["EStatsTT"] = "Collect and display gold/hr and XP/hr for boostees after each reset.  (NOT YET IMPLEMENTED)"
L["BalanceWhisperThreshold"] = "Enable balance whisper threshold"
L["BalanceWhisperThresholdTT"] = "To help reduce spam, only whisper boostees when their balance exceeds gold threshold."
L["GThreshold"] = "Gold Threshold"
L["GThresholdTT"] = "Gold threshold to meet before whispering balance."
L["EAutobill"] = "Enable Autobill on instance reset"
L["EAutobillTT"] = "Automatically bill all players when instance reset is detected."
L["ESounds"] = "Play waitlist sounds"
L["ESoundsTT"] = "Play sounds when players are added or removed from the waitlist."
L["EWaitlist"] = "Enable waitlist"
L["EWaitlistTT"] = "Respond to whispers encouraging players to queue for your services."
L["MWaitlist"] = "Max Waitlist"
L["MWaitlistTT"] = "Maximum number of boostees on waitlist before addon stops responding."
L["Player Database"] = true
L["Balance"] = true
L["Override"] = true
L["Blacklist"] = true