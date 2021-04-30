local L = LibStub("AceLocale-3.0"):NewLocale ("BoostWaitlist", "enUS", true) 
if not L then return end 

--L["i'm cursed"] = true
--L["SpellTooltipFlashOFLight"] = "A quick expensive heal"
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
L[""] =
L[""] =
L[""] =
L[""] =

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
  return 'If you want to log into a different character while waiting, just send me "!waitlist ' .. S . '" from that character.'
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
L[""] =
L[""] =
L[""] =
L[""] =
L[""] =





