local addonName, addon = ...

local SimpleThrottle =  {}
addon.SimpleThrottle = SimpleThrottle

local LEADIN_DELAY = 0.3 -- seconds before first batch of messages send
local DELAY = 5 -- seconds before next batch of messages can be sent
local BATCH_SIZE = 5

local batch = {}
local index = 1
-- this might be necessary if C_Timer.After is parallel.
--local locked = false

--DO NOT CALL THIS FUNCTION DIRECTLY
function SimpleThrottle:SendMessage()
    local oldIndex = index
    while (index <= #batch and (index - oldIndex) < BATCH_SIZE) do
        local b = batch[index]
        SendChatMessage(b.message, b.type, b.language, b.channel)

        index = index + 1
    end

    if (index >= #batch) then
        index = 1
        batch = {}
    elseif (#batch > 0) then
        C_Timer.After(DELAY, SimpleThrottle.SendMessage)
    end
end


function SimpleThrottle:SendChatMessage(msg, type, language, channel)
    table.insert(batch, #batch+1, {message = msg, type = type, language = language, channel = channel})

    if (#batch == 1) then
        C_Timer.After(LEADIN_DELAY, SimpleThrottle.SendMessage)
    end
end
