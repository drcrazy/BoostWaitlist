local addonName, addon = ...

-- Create local vars
local DB -- assigned during ADDON_LOADED
local Main = addon
local GUI = {}
local UIBuilder = addon.UIBuilder

addon.GUI = GUI



-- Local functions
local waitlist = {}
local players = {}

local CustomSort = function(self, rowA, rowB, sortBy)
  local a = self:GetRow(rowA);
	local b = self:GetRow(rowB);
	local column = self.columns[sortBy];
	local idx = column.index;

	local direction = column.sort or 'asc';
  if (idx == 'time') then
    direction = 'dsc'
  end

	if direction:lower() == 'asc' then
    return a[idx] > b[idx];
	else
    return a[idx] < b[idx];
	end
end


local waitlistTableCols = {
  {
    name = 'Waitlist',
    width = 130,
    align = 'LEFT',
    format = 'string',
    index = 'target',
    sortable = true,
    compareSort = function(self, rowA, rowB, sortBy)
      return CustomSort(self, rowA, rowB, 3)
    end,
    color = {r=1,g=1,b=1,a=1}
  },
  {
    name = 'Waiting On',
    width = 115,
    align = 'LEFT',
    format = 'string',
    index = 'sender',
    sortable = true,
    compareSort = function(self, rowA, rowB, sortBy)
      return CustomSort(self, rowA, rowB, 3)
    end,
    color = {r=1,g=1,b=1,a=1}
  },
  {
    name = 'Actions',
    width = 170,
    align = 'RIGHT',
    format = 'custom',
    index = 'time',
    sortable = false,
    compareSort = function(self, rowA, rowB, sortBy)
      return CustomSort(self, rowA, rowB, 3)
    end,
    renderer = function(cellFrame, value, rowData, columnData)

                  if (cellFrame.remove == nil) then
                      cellFrame.remove = UIBuilder:TextButton(cellFrame, 'Remove', 50, 20)
                      cellFrame.remove:SetPoint('RIGHT', cellFrame, 'RIGHT', -1, 0)
                  end

                  if (cellFrame.invite == nil) then
                      cellFrame.invite = UIBuilder:TextButton(cellFrame, 'Invite', 50, 20)
                      cellFrame.invite:SetPoint('RIGHT', cellFrame.remove, 'LEFT', -1, 0)
                  end

                  if (cellFrame.whisper == nil) then
                      cellFrame.whisper = UIBuilder:TextButton(cellFrame, 'Whisper', 50, 20)
                      cellFrame.whisper:SetPoint('RIGHT', cellFrame.invite, 'LEFT', -1, 0)
                  end

                  cellFrame.whisper:SetScript("OnClick", function()
                    Main:GetReadyWhisper(rowData.target)
                  end)

                  cellFrame.invite:SetScript("OnClick", function()
                    Main:TriggerInvite(rowData.target)
                  end)

                  cellFrame.remove:SetScript("OnClick", function()
                    Main:RemoveWaitlist(rowData.target)
                  end)

              end,
  }
}


local playerTableCols = {
  {
      name = 'Name',
      width = 115,
      align = 'LEFT',
      format = 'string',
      index = 'name',
      sortable = true,
      defaultSort = 'dsc',
      compareSort = CustomSort,
      color = {r=1,g=1,b=1,a=1}
  },
  {
      name = 'Bal',
      width = 70,
      align = 'CENTER',
      format = 'number',
      index = 'accountBalance',
      compareSort = CustomSort,
      sortable = true,
      color = function (table, value)
          local c = {r=1,g=1,b=1,a=1}
          if (tonumber(value) < 0) then
              c = {r=1,g=0,b=0,a=1}
          end
          return c
      end,
      events = {
          OnClick = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
              local cellData = rowData[columnData.index]
              cellFrame.cellEdit = UIBuilder:TableNumericEditBox(table, cellFrame, cellData, rowData, columnData,
              function(value, row)
                  Main:SetBalance(row.name, value)
              end
              )
              return true
          end,
      }
  },
  {
      name = 'Cost',
      width = 70,
      align = 'CENTER',
      format = 'number',
      index = 'overrideCharge',
      sortable = true,
      compareSort = CustomSort,
      color = function (table, value)
          local c = {r=1,g=1,b=1,a=1}
          if (tonumber(value) < 0) then
              c = {r=1,g=0,b=0,a=1}
          end
          return c
      end,
      events = {
          OnClick = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
              local cellData = rowData[columnData.index]
              cellFrame.cellEdit = UIBuilder:TableNumericEditBox(table, cellFrame, cellData, rowData, columnData,
              function(value)
                  if (value < 0) then
                      Main:SetOverrideDefaultCharge(rowData.name, DB.Main.cost)
                  else
                      Main:SetOverrideDefaultCharge(rowData.name, value)
                  end
              end
              )
              return true
          end,
      }
  },
  {
      name = 'Actions',
      width = 160,
      align = 'RIGHT',
      format = 'custom',
      index = 'name',
      sortable = false,
      renderer = function(cellFrame, value, rowData, columnData)
                    if (cellFrame.trade == nil) then
                        cellFrame.trade = UIBuilder:TextButton(cellFrame, 'Trade', 50, 20)
                        cellFrame.trade:SetPoint('RIGHT', cellFrame, 'RIGHT', -1, 0)
                    end

                    if (cellFrame.add == nil) then
                        cellFrame.add = UIBuilder:TextButton(cellFrame, 'Add', 50, 20)
                        cellFrame.add:SetPoint('RIGHT', cellFrame.trade, 'LEFT', -1, 0)
                    end

                    if (cellFrame.addEditBox == nil) then
                      cellFrame.addEditBox = UIBuilder:NumericEditBox(cellFrame, DB.Main.cost, 50, 20, 
                      function(v) --doesn't scope properly
                        
                      end)
                      cellFrame.addEditBox:SetPoint('RIGHT', cellFrame.trade, 'LEFT', -1, 0)
                    end

                    if (cellFrame.charge == nil) then
                        cellFrame.charge = UIBuilder:TextButton(cellFrame, 'Charge', 50, 20)
                        cellFrame.charge:SetPoint('RIGHT', cellFrame.add, 'LEFT', -1, 0)
                    end

                    cellFrame.addEditBox:Hide()

                    local HandleAdd = function()
                      local vnum = tonumber(cellFrame.addEditBox:GetText())
                      if (vnum ~= nil) then
                          Main:AddBalance(value, vnum)
                      end

                      cellFrame.addEditBox:ClearFocus()
                    end

                    cellFrame.addEditBox:SetScript("OnEditFocusLost", function()
                      cellFrame.addEditBox:Hide()
                      cellFrame.addEditBox:SetValue(DB.Main.cost)
                      cellFrame.add:Show()
                    end)

                    cellFrame.addEditBox:SetScript("OnEnterPressed", function()
                      HandleAdd()
                    end)

                    cellFrame.addEditBox.button:SetScript("OnClick", function()
                      HandleAdd()
                    end)

                    cellFrame.trade:SetScript("Onclick", function()
                      InitiateTrade(value)
                    end)

                    cellFrame.add:SetScript("OnClick", function()
                      cellFrame.add:Hide()
                      cellFrame.addEditBox:Show()
                      cellFrame.addEditBox:HighlightText()
                      cellFrame.addEditBox:SetFocus()
                    end)

                    cellFrame.charge:SetScript("OnClick", function()
                      Main:ChargeBalance(value)
                    end)
                end,
  }
}


-- Init functions
function GUI:Init()
  DB = _G.BoostWaitlistDB
  GUI.created = false
  GUI:CreateMinimapIcon()
  GUI:UpdateBrokerTexture()
  GUI:ShowMinimapIcon()
  GUI:Create()
  if (not DB.Main.everActive) then
    GUI:HideMinimapIcon()
  end
  
end


-- Main GUI creation

function GUI:Create()
  local frame = UIBuilder:Window(UIParent, 467, 400, addonName)
  frame:SetToplevel(true)
  frame:SetPoint(DB.GUI.points[1], DB.GUI.points[2], DB.GUI.points[3], DB.GUI.points[4], DB.GUI.points[5])
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnMouseDown", frame.StartMoving)
  frame:SetScript("OnMouseUp", function(self)
    self:StopMovingOrSizing()
    local a,b,c,d,e = self:GetPoint()
    DB.GUI.points = {a, nil, c, d, e}
  end)

  local closeButton = UIBuilder:CloseButton(frame)
  closeButton:SetPoint('TOPRIGHT', frame, 'TOPRIGHT')

  -- Header options

  frame.auobillCheckbox = UIBuilder:Checkbox(frame,"Autobill","Automatically bill all players when instance reset is detected.",
  function(checked)
      DB.Main.autobill = checked
  end)
  frame.auobillCheckbox:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -65)
  frame.auobillCheckbox:SetChecked(DB.Main.autobill or false)

  frame.chargeAllButton = UIBuilder:TextButton(frame, "Charge All", 100, 25, 
  function()
    Main:ChargeAll()
  end)
  frame.chargeAllButton:SetPoint("LEFT", frame.auobillCheckbox, "RIGHT", 275, 0)

  frame.defaultPrice = UIBuilder:NumericEditBox(frame, DB.Main.cost, 40, 25, 
  function(v)
    DB.Main.cost = v
    GUI:Update()
  end)
  frame.defaultPrice:SetScript("OnEditFocusLost", 
  function()
    frame.defaultPrice:SetValue(DB.Main.cost)
  end)
  frame.defaultPrice:SetScript("OnEditFocusGained", function()
    frame.defaultPrice:HighlightText()
  end)
  frame.defaultPrice:SetPoint("RIGHT", frame.chargeAllButton, "LEFT", -10, 0)

  local defaultPriceLabel = UIBuilder:Label(frame, "Default Price:")
  defaultPriceLabel:SetPoint("RIGHT", frame.defaultPrice, "LEFT", -5, 0)

  -- player table

  frame.playerTable = UIBuilder:Table(frame, playerTableCols, 4, 10, -113)

  -- waitlist

  frame.waitlistTable = UIBuilder:Table(frame, waitlistTableCols, 4, 10, -90)
  frame.waitlistTable:SetPoint("TOPLEFT", frame.playerTable, "BOTTOMLEFT", 0, -65) 

  local formingOptions = {
      {text = 'Forming', value = 1},
      {text = 'Full', value = 0},
   }
   frame.formingDropdown = UIBuilder:Dropdown(frame, 100, 25, formingOptions, DB.Main.forming and 1 or 0, 
    function(_, v)
      DB.Main.forming = v > 0
    end)
    frame.formingDropdown:SetPoint("BOTTOMLEFT", frame.waitlistTable, "TOPLEFT", 0, 30) 

  frame:Hide()

  --hide on Escape, without exposing the entire frame.
  _G[addonName .. "MainFrame"] = 
    {
      Hide = function() frame:Hide() end,
      IsShown = function() return frame:IsShown() end
    }
  tinsert(UISpecialFrames, addonName .. "MainFrame")

  GUI.mainFrame = frame
  GUI:Update()
end

function GUI:Show()
  GUI:Update(true)
  GUI.mainFrame:Show()
end


function GUI:UpdateBrokerTexture()
    local i = "Interface\\AddOns\\BoostWaitlist\\res\\ability_warrior_charge_grey"
    if (DB.Main.active) then
      i = "Interface\\Icons\\Ability_Warrior_Charge"
    end
    GUI.minimapLDB.icon = i
end

function GUI:CreateMinimapIcon()
  -- Minimap Button ------------------------
  GUI.minimapButton = LibStub("LibDBIcon-1.0")
  GUI.minimapLDB = LibStub("LibDataBroker-1.1"):NewDataObject("BoostWaitlist", {
    type = "launcher",
    text = "BoostWaitlist",
    icon = "Interface\\AddOns\\BoostWaitlist\\res\\ability_warrior_charge_grey",
    OnClick = 
      function(_, button) 
        if (button == "LeftButton") then
          GUI:ShowToggle()
        elseif (button == "RightButton") then
          if (IsShiftKeyDown()) then
            InterfaceOptionsFrame_OpenToCategory("BoostWaitlist");
          else
            if (DB.Main.active) then
              Main:HandleAddonOff()
            else
              Main:HandleAddonOn()
            end
          end
        end
      end,
    OnTooltipShow = function(tt)
      tt:AddLine("BoostWaitlist")
      tt:AddLine("LeftClick to open/close the BoostWaitlist GUI")
      tt:AddLine("RightClick to activate BoostWaitlist")
      tt:AddLine("Shift+RightClick to open config panel")
    end,
  })

  GUI.minimapButton:Register("BoostWaitlist", GUI.minimapLDB, DB.GUI.minimap)
end


function GUI:ShowToggle()
  if (GUI.mainFrame ~= nil) then
    if (GUI.mainFrame:IsShown()) then
      GUI.mainFrame:Hide()
    else
      GUI:Show()
    end
  else
    GUI:Create()
    GUI:Show()
  end
end


function GUI:RebuildPlayerlist()
  local partyNames = Main:GetPartyNames() or {}
  local cols = {}
  for i=1,#partyNames do
    table.insert(cols, {
      name = partyNames[i],
      accountBalance = Main:GetBalance(partyNames[i]) or 0,
      overrideCharge = Main:GetOverrideDefaultCharge(partyNames[i]) or DB.Main.cost,
      offline = true,
  })
  end
  players = cols
end

function GUI:RebuildWaitlist()
  waitlist = DB.Main.waitlistInfo.waitlist or {}

  -- to make sure data is there between updates.
  for i=1,#waitlist do
    waitlist[i].time = waitlist[i].time or time()
  end
end

function GUI:Update(fullUpdate)
  local frame = GUI.mainFrame

  frame.auobillCheckbox:SetChecked(DB.Main.autobill)
  frame.defaultPrice:SetValue(DB.Main.cost)
  frame.formingDropdown:SetValue(DB.Main.forming and 1 or 0)

  if (#players ~= #Main:GetPartyNames() or fullUpdate) then
    GUI:RebuildPlayerlist()
  else
    for i=1,#players do
      players[i].accountBalance = Main:GetBalance(players[i].name) or 0
      players[i].overrideCharge = Main:GetOverrideDefaultCharge(players[i].name) or DB.Main.cost
      players[i].offline = UnitIsConnected(players[i].name) or false
    end
  end
  GUI:RebuildWaitlist()
  frame.playerTable:SetData(players)
  frame.playerTable:Refresh()

  frame.waitlistTable:SetData(waitlist)
  frame.waitlistTable:Refresh()
end

function GUI:ShowPopupFrame(reason)
  if (GUI.popupFrame == nil) then
    GUI:CreatePopupFrame()
  end

  if (reason == "DONE_BOOSTING") then
    GUI.popupFrame.text:SetText("You turned BoostWaitlist off, but you still have players in the waitlist.|nDo you want to clear the waitlist and whisper those players that you're done?")
    GUI.popupFrame.leftButton:SetText("Yes")
    GUI.popupFrame.leftButton:SetScript("OnClick", function(self, button, down)
      Main:NotifyClearWaitlist()
      GUI.popupFrame:Hide()
    end)
    GUI.popupFrame.rightButton:SetText("No")
    GUI.popupFrame.rightButton:SetScript("OnClick", function(self, button, down)
      GUI.popupFrame:Hide()
    end)
    GUI.popupFrame:Show()
  end
end

function GUI:CreatePopupFrame()
  -- Popup Frame --------------------------
  local frameName = "HPCustomerGUI-PopupFrame"
  local popupFrame = CreateFrame("Frame", frameName, UIParent)
  popupFrame:ClearAllPoints()
  popupFrame:SetPoint("CENTER", 0, 0)
  popupFrame:SetSize(520, 110)
  popupFrame:SetMovable(true)
  popupFrame:EnableMouse(true)
  popupFrame:RegisterForDrag("LeftButton")
  popupFrame:SetScript("OnMouseDown", popupFrame.StartMoving)
  popupFrame:SetScript("OnMouseUp", popupFrame.StopMovingOrSizing)
  popupFrame:SetToplevel(true)
  popupFrame:SetClampedToScreen(true)
  popupFrame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
  popupFrame:SetBackdropColor(0, 0, 0, 1)
  popupFrame:Hide()
  GUI.popupFrame = popupFrame

  -- Popup Title Frame ----------------------------
  popupFrame.titleFrame = CreateFrame("Frame", frameName.."-TitleFrame", popupFrame)
  popupFrame.titleFrame:SetSize(10, 10)
  popupFrame.titleFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"})
  popupFrame.titleFrame:SetBackdropColor(0, 0, 0, 1)
  popupFrame.titleFrame.text = popupFrame.titleFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  popupFrame.titleFrame.text:SetAllPoints(popupFrame.titleFrame)
  popupFrame.titleFrame.text:SetJustifyH("CENTER")
  popupFrame.titleFrame.text:SetText(DB.Main.name.."'s Boosting")
  popupFrame.titleFrame:ClearAllPoints()
  popupFrame.titleFrame:SetPoint("TOPLEFT", popupFrame, 10, -7)
  popupFrame.titleFrame:SetPoint("BOTTOMRIGHT", popupFrame, "TOPRIGHT", -30, -25)

  -- Popup Frame Text ---------------------------
  popupFrame.text = popupFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  popupFrame.text:SetPoint("CENTER", popupFrame, "CENTER", 0, 0) 
  popupFrame.text:SetJustifyH("CENTER")

  -- Popup Left Button -------------------
  popupFrame.leftButton = GUI:CreateButton(frameName.."-LeftButton", popupFrame, "CENTER", -70, -40)
  GUI:ConfigureButton(popupFrame.leftButton, 48, 20, "Confirm")
  popupFrame.leftButton:RegisterForClicks("LeftButtonUp")

  -- Popup Right Button -------------------
  popupFrame.rightButton = GUI:CreateButton(frameName.."-RightButton", popupFrame, "CENTER", 70, -40)
  GUI:ConfigureButton(popupFrame.rightButton, 48, 20, "Cancel")
  popupFrame.rightButton:RegisterForClicks("LeftButtonUp")
end

function GUI:CreateButton(name, parent, anchor, hpos, vpos)
  local button = CreateFrame("Button", name, parent)
  button:SetPoint("CENTER", parent, anchor, hpos, vpos)
  return button
end

function GUI:ConfigureButton(button, width, height, text)
  button:SetSize(width, height)
  button:SetText(text)
  button:SetNormalFontObject("GameFontNormal")

  local ntex = button:CreateTexture()
  ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
  ntex:SetTexCoord(0, 0.625, 0, 0.6875)
  ntex:SetAllPoints()	
  button:SetNormalTexture(ntex)
  
  local htex = button:CreateTexture()
  htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
  htex:SetTexCoord(0, 0.625, 0, 0.6875)
  htex:SetAllPoints()
  button:SetHighlightTexture(htex)
  
  local ptex = button:CreateTexture()
  ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
  ptex:SetTexCoord(0, 0.625, 0, 0.6875)
  ptex:SetAllPoints()
  button:SetPushedTexture(ptex)
end


function GUI:ShowMinimapIcon()
  DB.GUI.minimap.hide = false
  if (GUI.minimapButton ~= nil) then
    GUI.minimapButton:Show("BoostWaitlist")
  end
end

function GUI:HideMinimapIcon()
  DB.GUI.minimap.hide = true
  if (GUI.minimapButton ~= nil) then
    GUI.minimapButton:Hide("BoostWaitlist")
  end
end

