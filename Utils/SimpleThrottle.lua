local addonName, addon = ...

local SimpleThrottle =  {}
addon.SimpleThrottle = SimpleThrottle

local DELAY = 5 -- seconds before next batch of messages can be sent
local BATCH_SIZE = 5

local batch = {}
local index = 1
local history = {}
local hindex = 0

-- this might be necessary if C_Timer.After is parallel.
--local locked = false

local historyAdd = function()
    hindex = hindex + 1
    if (hindex > BATCH_SIZE) then hindex = 1 end
    history[hindex] = GetTime()
end

local CanSend = function()
    if (#history < BATCH_SIZE) then return true end
    local tmpIndex = hindex + 1 
    if (tmpIndex > BATCH_SIZE) then tmpIndex = 1 end

    return (GetTime() - history[tmpIndex]) > DELAY
end

--DO NOT CALL THIS FUNCTION DIRECTLY
function SimpleThrottle:SendMessage(recurse)

    if (index > #batch) then
        index = 1
        batch = {}
    end

    while (index <= #batch and CanSend()) do
        local b = batch[index]
        SendChatMessage(b.message, b.type, b.language, b.channel)

        historyAdd()

        index = index + 1
    end

    if (#batch > 0 and recurse) then
        C_Timer.After(DELAY+0.1, function() SimpleThrottle:SendMessage(true) end)
    elseif (#batch == 1 and recurse == false) then
        C_Timer.After(DELAY+0.1, function() SimpleThrottle:SendMessage(true) end)
    end
end


function SimpleThrottle:SendChatMessage(msg, type, language, channel, priority)
    if (priority) then
        SendChatMessage(msg, type, language, channel)

        historyAdd()
    else
        table.insert(batch, #batch+1, {message = msg, type = type, language = language, channel = channel})
        
        if(#batch <= BATCH_SIZE) then
            SimpleThrottle:SendMessage(false)
        end
    end
end
