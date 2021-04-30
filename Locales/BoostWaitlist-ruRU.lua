local L = LibStub("AceLocale-3.0"):NewLocale ("BoostWaitlist", "ruRU", false, true) 
if not L then return end 

L["addonLoading"] = "BoostWaitlist загружается"


-- Chat messages. Keep'em short!
L["unsupportedCommandShort"] = "Нет такой команды"


L["balanceCharged"] = function(C,B)
  return C .. 'г было списано за прокачу. Текущий баланс: ' .. B .. 'г'
end

L["whisperBalance"] = function(B)
  return 'Текущий баланс: ' .. B .. 'г'
end
