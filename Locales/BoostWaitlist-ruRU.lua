local L = LibStub("AceLocale-3.0"):NewLocale ("BoostWaitlist", "ruRU") 
if not L then return end 

L["addonLoading"] = "BoostWaitlist загружается"
L["setReply"] = "Приветствие сохранено."
L["setReplyEmpty"] = "Задано пустое приветствие."
L["setReplyTooLong"] = "Приветствие слишком длинное. Максимум - 104 символа."
L["setDone"] = "Ваше финальное сообщение установлено."
L["setDoneEmpty"] = "Ваше финальное сообщение удалено - теперь эта функция отключена."
L["setDoneTooLong"] = "Ваше сообщение слишком длинное. Максимум - 250 символов."
L["inactiveReplyMessage"] = "Ваше сообщение для неактивного режима установлено."
L["inactiveReplyMessageEmpty"] = "Ваше сообщение для неактивного режима удалено"
L["inactiveReplyMessageTooLong"] = "Ваше сообщение слишком длинное. Максимум - 200 символов."
L["inactiveReplyEnabled"] = "Включен авто-ответ для неактивного режима"
L["inactiveReplyDisabled"] = "Выключен авто-ответ для неактивного режима"
L["autoBillingEnabled"] = "Включено автосписание при о бновлении подземелья."
L["autoBillingDisabled"] = "Выключено автосписание при обновлении подземелья."
L["waitlistEnabled"] = "Включен лист ожидания."
L["waitlistDisabled"] = "Выключен лист ожидания."
L["setMaxWaitlist"] = function(S)
	return 'Задан максимальный размер листа ожидания: ' .. S
end
L["setMaxWaitlistUsage"] = "Ошибка. Формат команды: /boost maxwaitlist <##>"
L["balanceWhisperThresholdEnabled"] = "Включено напоминание при низком балансе. Прокачиваемые не будут получать сообщения, пока баланс больше указанной величины."
L["balanceWhisperThresholdValue"] = function(S)
  return S .. 'г.  /boost balancewhisperthreshold <##> для изменения величины.'
end
L["balanceWhisperThresholdDisabled"] = "Выключено напоминание при низком балансе. Прокачиваемые будут всегда получать сообщения об изменении баланса."
L["balanceWhisperThresholdSet"] = function(S)
  return 'Величина низкого баланса изменена на: ' .. S
end
L["balanceWhisperThresholdUsage"] = "Ошибка. Формат команды: /boost balancewhisperthreshold <##>"
L["statsEnabled"] = "Статистика включена. (Оно исчо не работает)"
L["statsDisabled"] = "Статистика выключена."
L["soundEnabled"] = "Включить звук при добавлении в лист ожидания"
L["soundDisabled"] = "Выключить звук при добавлении в лист ожидания"
L["setCost"] = "Стоимость изменена."
L["setCostInvalid"] = "Неправильное значение стоимости."
L["notInWaitlist"] = function(S)
  return S ..' не в листе ожидания'
end

L["invalidAmount"] = "Неправильное значение"
L["unsupportedCommand"] = function(S)
  return 'Не поддерживается команда: ' .. S
end
L["addonActivated"] = "Аддон BoostWaitlist активирован"
L["addonDeactivated"] = "Аддон BoostWaitlist деактивирован"
L["requestWaitlist"] = function(T,S)
  return 'Запрос на добавление в лист ожидания ' .. T ..' от ' .. S
end
L["cancelRequest"] = function(T,S)
  return 'Удален запрос на ' .. T .. ' от ' .. S
end
L["updateWaitlist"] = function(T,S)
  return 'Список ожидания обновлен. Отправитель = ' .. S ..', прокачиваемый = ' .. T
end
L["balanceNegative"] = function(N,B)
  return N .. ' ушёл в минус: ' .. B .."г."
end
L["overrideRemove"] = function(N)
  return 'BoostWaitlist - удалена специальная цена для ' .. N
end
L["overrideSet"] = function(N,A)
  return 'BoostWaitlist - Установлена специальная цена для ' .. N .. ' в размере ' .. A .. 'г. Измени на значение по умолчанию для удаления специальной цены.'
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
  enablebalancewhisperthreshold [on/off] -- напоминать о балансе при снижении баланса
  balancewhisperthreshold -- минимальный баланс для напоминания о балансе
  enablewaitlist [on/off] -- включить/выключить лист ожидания
  maxwaitlist <##> -- максимальный размер листа ожидания
  add <boostee> -- добавить персонажа в лист ожидания
  blacklist <boostee> <reason> -- отключить авто-ответ прокачиваемому
  remove blacklist <boostee> -- включить авто-ответ прокачиваемому
  print waitlist -- напечатать лист ожидания
  print blacklist -- напечатать черный список
  add <boostee> <waiting char> -- добавить игрока в список ожидания
  connect <boostee> <waiting char> -- обновить имя персонажа на котором сидят в ожидании прокачки
  break <time> -- перерыв до указанного времени
  break done -- вернуться с перерыва
  sounds [on/off] -- включить или выключить звук при добавлении в лист ожидания
  minimap [show/hide] -- настройка кнопки у мини-карты
  add balance <boostee> <amount> -- добавить баланс персонажу
  charge <boostee> -- списать с баланса стоимость прокачки
  chargeall -- списать стоимость прокачки с каждого в группе
  print balance <boostee> -- вывести баланс персонажа
  reset balance <boostee> -- удалить баланс персонажа
  inactivereply [on/off] -- включить или выключить авто-ответ когда прокачка не активна
  inactivereplymessage <message> -- задать сообщение о неактивности прокачки
  autobill [on/off] -- включить или выключить автосписание при сбросе подземелья
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
  return 'Если будешь ждать на другом персонаже - шепни мне \'!waitlist ' .. S .. '\' с этого персонажа.'
end
L["cancelRequestReply"] = "Спасибо. Запрос на прокачку удалён."
L["updateWaitlistReply"] = "Спасибо. Я напишу, как надо будет заходить."
L["whisperCommandHelp1"] = "!waitlist - запись на прокачку"
L["whisperCommandHelp2"] = "!waitlist <alt name> - записать твинка на прокачку"
L["whisperCommandHelp3"] = "!line - очередь на прокачку"
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
  return 'Привет ' .. T ..', приглашаю на прокачку.'
end
L["whisperGetReadySender"] = function(S,T)
  return 'Привет ' .. S ..', скоро буду готов прокачивать ' .. T .. '. Если ' .. T ..' далеко от подземелья  - уже можешь им выдвигаться.'
end
L["whisperGetReadyTarget"] = function(T)
  return 'Привет ' .. T .. ', скоро буду готов прокачивать тебя. Выдвигайся к подземелью, если ты далеко от него.'
end
L["whisperInviteFailedInGroup"] = "уже в группе";
L["whisperInviteFailedDeclined"] = "отказался";
L["whisperInviteFailed"] = function(R)
  return 'Привет, приглашал тебя на прокачку, но ты ' .. R .. '. Напиши \'!invite\' для приглашения или \'!cancel\' для отмены.'
end
L["whipserInviteNotReady"] = "Извини, пока не собираю."
L["initialReply"] = "Привет!"
L["whisperDone"] = "На сегодня всё. Извини, что не попал - постараюсь прокачать в следующий раз!"
L["whisperInactive"] = "Спасибо за интерес к прокачке. Я пока не качаю."

-- GUI. Interface!
L["Autobill"] = "Авто Счет"
L["AutobillTooltip"] = "Автоматически выставляет счет участникам, после обновления подземелья"
L["ChargeAll"] = "Счет всем"
L["DefaultPrice"] = "Цена:"
L["MinimapTooltipLeft"] = "LeftClick для открытия/закрытия BoostWaitlist GUI"
L["MinimapTooltipRight"] = "RightClick автивация BoostWaitlist"
L["MinimapTooltipSRight"] = "Shift+RightClick открыть настройки"
L["DoneBoosting"] = "Закончить буст"
L["Forming"] = "Сбор"
L["Full"] = "Полная"
L["Waitlist"] = "Лист ожидания"
L["WaitingOn"] = "Ожидает"
L["Actions"] = "Действие"
L["Remove"] = "Удалить"
L["Invite"] = "Пригласить"
L["Whisper"] = "Шепнуть"
L["Name"] = "Имя"
L["Bal"] = "Баланс"
L["Cost"] = "Цена"
L["Trade"] = "Торговля"
L["Add"] = "Добавить"
L["Charge"] = "Счет"

-- GUI. Option!
L["General"] = "Главная"
L["EminimapIcon"] = "Включить иконку у миникарты"
L["EminimapIconTT"] = "Показывает иконку BoostWaitlist у миникарты."
L["EStats"] = "Включить статистику (В РАЗРАБОТКЕ)"
L["EStatsTT"] = "Включаеи статистику золото/час и XP/час для игроков после каждого обновления. (НАХОДИТСЯ В РАЗРАБОТКЕ)"
L["BalanceWhisperThreshold"] = "Включить сообщение при достижении баланса"
L["BalanceWhisperThresholdTT"] = "Помогает избежать спама, отправляет сообщения игрокам только при достижении заданного баланса"
L["GThreshold"] = "Порог баланса"
L["GThresholdTT"] = "Устанавливает порог баланса для отправки сообщений игрокам"
L["EAutobill"] = "Включение авто-выставления счетов"
L["EAutobillTT"] = "Автоматически выставляет счет игроку при обновлениии подземелья"
L["ESounds"] = "Звуки для списка ожидания"
L["ESoundsTT"] = "Проигрывает звук при добавлении или удалении игрока из списка ожидания"
L["EWaitlist"] = "Включить список ожидания"
L["EWaitlistTT"] = "Автоматически отвечает на сообщения, приглашая игроков встать в очередь"
L["MWaitlist"] = "Размер списка"
L["MWaitlistTT"] = "Максимальное количество игроков в списке ожидания, прежде чем аддон перестанет отвечать на сообщения."
L["Player Database"] = "БазаДанных игроков"
L["Balance"] = "Баланс"
L["Override"] = "Спец цена"
L["Blacklist"] = "Черный список"