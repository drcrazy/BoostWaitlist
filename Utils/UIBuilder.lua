local addonName, addon = ...
local UIBuilder = {}

addon.UIBuilder = UIBuilder

local StdUi = LibStub('StdUi'):NewInstance()
StdUi.config = {
	font        = {
		family    = "Interface\\AddOns\\BoostWaitlist\\res\\Expressway.ttf",
		size      = 12,
		titleSize = 25,
		effect    = 'NONE',
		strata    = 'OVERLAY',
		color     = {
			normal   = { r = 1, g = 1, b = 1, a = 1 },
			disabled = { r = 0.55, g = 0.55, b = 0.55, a = 1 },
			header   = { r = 0.4, g = 0, b = 0.9, a = 1 },
		}
	},

	backdrop    = {
		texture        = [[Interface\Buttons\WHITE8X8]],
		panel          = { r = 0.0588, g = 0.0588, b = 0.0588, a = 0.8 },
		slider         = { r = 0.15, g = 0.15, b = 0.15, a = 1 },

		highlight      = { r = 0.40, g = 0.40, b = 0, a = 0.5 },
		button         = { r = 0.20, g = 0.20, b = 0.20, a = 1 },
		buttonDisabled = { r = 0.15, g = 0.15, b = 0.15, a = 1 },

		border         = { r = 0.00, g = 0.00, b = 0.00, a = 1 },
		borderDisabled = { r = 0.40, g = 0.40, b = 0.40, a = 1 }
	},

	progressBar = {
		color = { r = 1, g = 0.9, b = 0, a = 0.5 },
	},

	highlight   = {
		color = { r = 1, g = 0.9, b = 0, a = 0.4 },
		blank = { r = 0, g = 0, b = 0, a = 0 }
	},

	dialog      = {
		width  = 400,
		height = 100,
		button = {
			width  = 100,
			height = 20,
			margin = 5
		}
	},

	tooltip     = {
		padding = 10
	}
};



local function underline(frame, anchor, length, offset)
    local line = frame:CreateTexture()
    line:SetTexture("Interface/BUTTONS/WHITE8X8")
    line:SetColorTexture(0.6 ,0.6, 0.6, 0.4)
    line:SetSize(length, 2)
    line:SetPoint("BOTTOMLEFT", anchor, 0, -4 + offset)
end

function UIBuilder:Header(frame, text, uline)
    local t = StdUi:FontString(frame, text)
    t:SetPoint("TOPLEFT", 16, -16)
    t:SetFont(StdUi.config.font.family,StdUi.config.font.titleSize)
    local c = StdUi.config.font.color.header
    t:SetTextColor(c.r, c.g, c.b, c.a)

    if (uline) then
        underline(frame, t, 500, 0)
    end

    return t
end

function UIBuilder:Label(frame, text)
    local l = StdUi:FontString(frame, text)
    l:SetFont(StdUi.config.font.family,StdUi.config.font.size)
    local c = StdUi.config.font.color.normal
    l:SetTextColor(c.r, c.g, c.b, c.a)

    return l
end

function UIBuilder:TextButton(frame, text, width, height, onclick)
    local b = StdUi:Button(frame, width, height, text)
    b.text:SetFont(StdUi.config.font.family,StdUi.config.font.size)
    b:SetScript("OnClick", onclick)

    return b
end

function UIBuilder:CloseButton(frame)
    local b = StdUi:SquareButton(frame, 16,16, 'DOWN')
    b:SetScript("OnClick", function()
        frame:Hide()
    end)
    return b
end

function UIBuilder:Checkbox(frame, label, description, callback)
    local checkbox = StdUi:Checkbox(frame, label)
    checkbox.text:SetFont(StdUi.config.font.family,StdUi.config.font.size)
    checkbox:AutoWidth()
    StdUi:FrameTooltip(checkbox, description, label, "TOP", true)
    checkbox:HookScript("OnClick", 
    function(self)
        callback(self:GetChecked())
    end)

    return checkbox
end

function UIBuilder:Slider(frame, label, tooltip, min, max, callback)
    local widget = StdUi:Panel(frame, 110, 60, nil)
    local t = StdUi:FontString(widget, label)
    t:SetPoint("TOP",0 , -3)
    t:SetFont(StdUi.config.font.family,StdUi.config.font.size)
    
    widget.isWidget = true
    widget.s = StdUi:Slider(widget, 100, 10, max, false, min, max)
    widget.editBox = StdUi:EditBox(widget, 60, 16, max)

    local s = widget.s
    local editBox = widget.editBox
    editBox:SetValue(max)
    
    StdUi:GlueTop(s, widget, 0,-20,'TOP')
    StdUi:GlueBelow(editBox, s, 0, -5, 'CENTER');


    StdUi:FrameTooltip(s, tooltip, label .. "Slider", "TOP", true)
    StdUi:FrameTooltip(editBox, tooltip, label .. "Editbox", "TOP", true)

    s:SetScript("OnValueChanged", 
    function(self,value)
        local roundvalue = math.floor(value+0.5)
        editBox:SetValue(roundvalue)
    end)
    editBox:HookScript("OnTextChanged",
    function(self, v)
        local value = tonumber(self:GetText())
        if (value ~= nil) then
            s:SetValue(value)
            callback(value)
        end
    end)
    

    widget.SetValue = function(_, v)
        editBox:SetValue(v)
        s:SetValue(v)
    end
    return widget
end





function UIBuilder:NumericEditBox(frame, value, width, height, callback)

    local editBox = StdUi:EditBox(frame, width, height, value)

    local HandleCallback = function()
        local vnum = tonumber(editBox:GetText())
        if (vnum ~= nil) then
            callback(vnum)
        end
    end

    editBox:SetScript("OnEditFocusLost",
    function()
        editBox.button:Hide()
        return true
    end)

    editBox:SetScript("OnEnterPressed",
    function()
        HandleCallback()
        editBox:ClearFocus()
        return true
    end)

    editBox.button:SetScript("OnClick",
    function()
        HandleCallback()
        editBox:ClearFocus()
        return true
    end)

    editBox.button:ClearAllPoints()
    editBox.button:SetPoint("BOTTOMRIGHT", editBox, "TOPRIGHT", 0, -4)

    return editBox
end


function UIBuilder:Dropdown(parent, width, height, options, value, callback)
    local d = StdUi:Dropdown(parent, width, height, options, value)
    d.OnValueChanged = callback
    
    return d
end


--Too specific, this needs to be changed.
function UIBuilder:TableNumericEditBox(table, frame, value, rowData, columnData, callback)
    frame.text:Hide()

    local HandleCallback = function()
        local vround = tonumber(frame.cellEdit:GetText())
        if (vround ~= nil) then
            local cellData = vround
            rowData[columnData.index] = cellData
            frame.text:SetText(cellData)
            if (columnData.color ~= nil) then
                local c
                if (type(columnData.color) == "function") then
                    c = columnData.color(nil, vround)
                else
                    c = columnData.color
                end
                frame.text:SetTextColor(c.r, c.g, c.b, c.a)
            end

            callback(vround, rowData, columnData)
        end
    end

    --we don't want to create thousands of instances of this editbox
    if (frame.cellEdit == nil) then
        frame.cellEdit = StdUi:EditBox(frame, frame:GetWidth(), frame:GetHeight(), value)
        frame.cellEdit:SetPoint('TOPLEFT')
        frame.cellEdit:SetFocus()

        table.scrollFrame:HookScript("OnVerticalScroll", 
        function()
            frame.cellEdit:ClearFocus()
        end)

        for k, v in pairs(table.head.columns) do
            table.head.columns[k]:HookScript("Onclick", function()
                frame.cellEdit:ClearFocus()
            end)
        end

    else
        frame.cellEdit:SetValue(value)
        frame.cellEdit:Show()
        frame.cellEdit:SetFocus()
    end


    frame.cellEdit:SetScript("OnEditFocusLost",
    function()
        frame.text:Show()
        frame.cellEdit:Hide()
    end
    )




    frame.cellEdit:SetScript("OnEnterPressed",
    function()
        frame.cellEdit:ClearFocus()
        HandleCallback()
        return true
    end)

    frame.cellEdit.button:SetScript("OnClick",
    function()
        frame.cellEdit:ClearFocus()
        HandleCallback()
        return true
    end)

    
    return frame.cellEdit
end

function UIBuilder:Table(frame, cols, visibleRows, ofx, ofy)
    local st = StdUi:ScrollTable(frame, cols, visibleRows, 24);
    st:EnableSelection(false);
    st:SetPoint('TOPLEFT', ofx, ofy)

    return st
end

function UIBuilder:ConfirmDialog(title, message, buttons)
    local f = StdUi:Confirm(title, "|n|n" .. message, buttons, addonName .. title)
    f.messageLabel:SetFont(StdUi.config.font.family,StdUi.config.font.size)
    f.titlePanel.label:SetFont(StdUi.config.font.family,16)

    f.titlePanel:SetPoint("TOPLEFT", f, "TOPLEFT", 0, -5)
    f.titlePanel.label:ClearAllPoints()
    f.titlePanel.label:SetPoint("LEFT", f.titlePanel, "LEFT", 10, 0)

    underline(f, f.titlePanel, 150, 4)
end

function UIBuilder:Window(parent, width, height, title)
    local f = StdUi:Panel(parent, width, height)
    f.titleLabel = UIBuilder:Header(f, title, false)
    f.titleLabel:SetFont(StdUi.config.font.family,20)
    underline(f,f.titleLabel,435,0)

    return f
end