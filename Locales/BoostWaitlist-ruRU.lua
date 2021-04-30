local L = LibStub("AceLocale-3.0"):NewLocale ("BoostWaitlist", "ruRU", false, true) 
if not L then return end 

L["addonLoading"] = "BoostWaitlist загружается"
L["setReply"] = "Приветствие сохранено."
L["setReplyEmpty"] = "Задано пустое приветствие."
L["setReplyTooLong"] = "Приветствие слишком длинное. Максимум - 104 символа."
L["setDone"] = "Your done message has been set."
L["setDoneEmpty"] = "Your done message was empty - the feature is now disabled."
L["setDoneTooLong"] = "Sorry, that message is too long and will cause errors. Maximum 250 characters."
L["inactiveReplyMessage"] = "Your inactive reply message has been set."
L["inactiveReplyMessageEmpty"] = "Your inactive reply message has been set to empty."
L["inactiveReplyMessageTooLong"] = "Sorry, that reply is too long and will cause errors. Maximum 200 characters for this portion of the message."
L["inactiveReplyEnabled"] = "Enabling auto-replies when boostees appear to be asking for boosts while inactive."
L["inactiveReplyDisabled"] = "Disabling auto-replies when boostees appear to be asking for boosts while inactive."
L["autoBillingEnabled"] = "Включено автосписание при обновлении подземелья."
L["autoBillingDisabled"] = "Выключено автосписание при обновлении подземелья."
L["waitlistEnabled"] = "Включен лист ожидания."
L["waitlistDisabled"] = "Выключен лист ожидания."
L["setMaxWaitlist"] = function(S)
	return 'Задан максимальный размер листа ожидания: ' .. S
end
L["setMaxWaitlistUsage"] = "Ошибка. Формат команды: /boost maxwaitlist <##>"
L["balanceWhisperThresholdEnabled"] = "Enabling balance whisper threshold. Boostees will not be whispered until their balance meets"
L["balanceWhisperThresholdValue"] = function(S)
  return S .. 'g.  /boost balancewhisperthreshold <##> to change this value.'
end
L["balanceWhisperThresholdDisabled"] = "Disabling balance whisper threshold features.  Boostees will recieve whispers every time they are billed."
L["balanceWhisperThresholdSet"] = function(S)
  return 'Setting balance whisper threshold to: ' .. S
end
L["balanceWhisperThresholdUsage"] = "Incorrect usage: /boost balancewhisperthreshold <##>"
L["statsEnabled"] = "Статистика включена. (Оно исчо не работает)"
L["statsDisabled"] = "Статистика выключена."
L["soundEnabled"] = "Enabling sound triggers for waitlist signup"
L["soundDisabled"] = "Disabling sound triggers for waitlist signup"
L["setCost"] = "Стоимость изменена."
L["setCostInvalid"] = "Неправильное значение стоимости."
L["notInWaitlist"] = function(S)
  return S ..' не в листе ожидания'
end

L["invalidAmount"] = "Invalid amount input"
L["unsupportedCommand"] = function(S)
  return 'Unsupported input command: ' .. S
end
L["addonActivated"] = "Аддон BoostWaitlist активирован"
L["addonDeactivated"] = "Аддон BoostWaitlist деактивирован"
L["requestWaitlist"] = function(T,S)
  return 'Запрос на добавление в лист ожидания ' .. T ..' от ' .. S
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
  return 'Сброшен баланс у ' .. N .. '. Предыдущий баланс: ' .. B .. 'г.'
end
L["printBalance"] = function(N,B)
  return 'Текущий баланс у ' .. N .. ': ' .. B ..'г.'
end
L["tradeNotAdded"] = function(M,N)
  return 'Получили ' .. M ..'меди от ' .. N ..' но не добавили на баланс.'
end
L["tradeNotRefunded"] = function(M,N)
  return 'Отдали ' .. M .. 'меди игроку ' .. N ..' но баланс не изменили.'
  end
L["inviteOther"] = function(T)
  return 'BoostWaitlist - приглашаю ' .. T ..'. Но запросов от него не было.'
end
L["getReadyOther"] = function(T)
  return 'BoostWaitlist - шепчу ' .. T .. '. Но запросов от него не было'
end
L["printWaitlist"] = "BoostWaitlist Лист ожидания"
L["printBlacklist"] = "BoostWaitlist Черный список"
L["printUsage"] = [[Поддерживаемые команды (/boost в начале)"
  on -- активировать аддон
  off -- деактивировать аддон
  gui -- открыть UI (Можно просто /boost)
  config -- открыть окно настроек
  setreply <reply sentence> -- задать приветствие
  reset -- сбросить лист ожидания
  enablebalancewhisperthreshold [on/off] -- whisper balance only when threshold met
  balancewhisperthreshold -- set the threshold to be met for whispers to be set
  enablewaitlist [on/off] -- включить/выключить лист ожидания
  maxwaitlist <##> -- максимальный размер листа ожидания
  add <boostee> -- добавить персонажа в лист ожидания
  blacklist <boostee> <reason> -- disable autoreplies for the boostee
  remove blacklist <boostee> -- reenable autoreplies for the boostee
  print waitlist -- напечатать лист ожидания
  print blacklist -- напечатать черный список
  add <boostee> <waiting char> -- add player to waitlist manually
  connect <boostee> <waiting char> -- update the waiting character name
  break <time> -- перерыв до указанного времени
  break done -- вернуться с перерыва
  sounds [on/off] -- enable or disable the sound triggers from waitlist signup
  minimap [show/hide] -- настройка кнопки у мини-карты
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
L["waitlistFull"] = "Извини, но лист ожидания уже заполнен."
L["waitlistExample1"] = "Формат команды: !waitlist <alt name>"
L["waitlistExample2"] = "Например: !waitlist ВасинТвинк"
L["unsupportedCommandShort"] = "Нет такой команды"
L["groupForming"] = "Группа еще формируется, запрыгивай!."
-- 63 chars + 2 for num
L["groupFull"] = function(S)
  return 'Группа заполнена. Ваша позиция в очереди: ' .. S
end
-- 81 chars
L["groupFormSentence"] = function(I, S)
  return I .. ' ' .. S ..' Напиши \'!waitlist\' для попадания в лист ожидания или "!commands" для списка команд.'
end
L["managerOnBreak"] = function(S)
  return 'Извини, отошел отдохнуть. Буду в ' .. S ..'.'
end
L["requestWaitlistReply1"] = "Спасибо. Приглашу в группу как будет возможность. Используй команду '!line' для уточнения позиции в очереди."
L["requestWaitlistReply2"] = function(S)
  return 'If you want to log into a different character while waiting, just send me \'!waitlist ' .. S .. '\' from that character.'
end
L["cancelRequestReply"] = "Спасибо. Запрос на прокачку удалён"
L["updateWaitlistReply"] = "Thanks. I'll whisper you when I'm ready for you to log over."
L["whisperCommandHelp1"] = "!waitlist - запись на прокачку"
L["whisperCommandHelp2"] = "!waitlist <alt name> - записать твинка на прокачку"
L["whisperCommandHelp3"] = "!line - get current waitlist length"
L["balanceCharged"] = function(C,B)
  return C .. 'г было списано за прокачу. Текущий баланс: ' .. B .. 'г.'
end
L["balance"] = function(B)
  return 'Баланс изменен. Новый баланс: ' .. B .. 'г.'
end
L["addBalance"] = function(A,B)
  return A .. 'г было добавлено к балансу. Новый баланс: ' .. B ..'г.'
end
L["refundBalance"] = function(R,B)
  return R ..'г было возвращено из баланса. Новый баланс: ' .. B .. 'г.'
end
L["whisperBalance"] = function(B)
  return 'Текущий баланс: ' .. B .. 'г'
end
L["whisperBalanceMissing"] = "Нет активного баланса для этого персонажа."
L["whisperEtaPosition"] = function(N)
  return 'Позиция в листе ожидания: ' .. N
end
L["whisperEtaLength"] = function(N)
  return 'Общая длина очереди: ' .. N ..' персонажей.'
end
L["whisperEtaError"] = "Извини, очередь слетела. Разберусь с очередью в ручном режиме."
L["whisperBoostReady"] = function(S,T)
  return 'Привет ' .. S .. ', готов прокачивать ' .. T ..'. Зайди на него и напиши мне \'!invite\' с персонажа ' .. T ..'.'
end
L["whisperInviteSent"] = function(T)
  return 'Hi ' .. T ..', your invite for boosts has been sent.'
end
L["whisperGetReadySender"] = function(S,T)
  return 'Привет ' .. S ..', скоро буду готов прокачивать ' .. T .. '. Если ' .. T ..' далеко от подземелья  - уже им можешь выдвигаться.'
end
L["whisperGetReadyTarget"] = function(T)
  return 'Привет ' .. T .. ', скоро буду готов прокачивать тебя. Выдвигайся к подземелью, если ты далеко от него.'
end
L["whisperInviteFailed"] = function(R)
  return 'Hi, I tried to invite you for boosts but you ' .. R .. '. Reply with \'!invite\' to get another invite or \'!cancel\' to cancel your boosting request.'
end
L["whipserInviteNotReady"] = "Sorry, I'm not ready to invite you for your boost just yet."
L["initialReply"] = "Привет!"
L["whisperDone"] = "На сегодня всё. Извини, что не попал - постараюсь прокачать в следующий раз!"
L["whisperInactive"] = "Спасибо за интерес к прокачке. Я пока не качаю."
