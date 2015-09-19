--[[
	~ Logging Derma ~
	~ Applejack ~
--]]
local PANEL = {}

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(cider.menu.width, cider.menu.height - 8)
	self.tabs = vgui.Create("DPropertySheet", self)
	--Ensure that the tabs are created and all sheets renewed
	self.categories = {}
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:StretchToParent(0, 22, 0, 0)
	self.tabs:StretchToParent(4, --[[28]]0, 4, 4)
	--print("Layout'd!")
end
local tick = 0;
function PANEL:Think()
	if CurTime() < tick then return end
	tick = CurTime() + 1;
	for k,v in pairs(cider.log.entries) do
		if !self.categories[k] then
			self.categories[k] = vgui.Create("cider_Log_eventlog", self)--.tabs)
			self.tabs:AddSheet(k,self.categories[k],nil,nil,nil,cider.log.namedcats[k])
			self.tabs:InvalidateLayout()
		end
	end
	for k,v in pairs(self.categories) do
		v:SetText(cider.log.entries[k])
	end
end
-- Register the panel.
vgui.Register("cider_Log", PANEL, "Panel")

local PANEL = {}

function PANEL:Init()
	-- Create a panel list to store the items.
	self.itemsList = vgui.Create("DPanelList", self)
 	self.itemsList:SizeToContents()
 	self.itemsList:SetPadding(2)
 	self.itemsList:SetSpacing(3)
	self.itemsList:StretchToParent(4, 4, 12, 44)
	self.itemsList:EnableVerticalScrollbar()
	self.mypanel = vgui.Create("DPanel",self)
	self.itemsList:AddItem(self.mypanel)
	self.labels = {}

end
-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:StretchToParent(0, 22, 0, 0)
	self.itemsList:StretchToParent(0, 0, 0, 0)
	local y = 5;
	-- Loop through all of our labels.
	for k, v in pairs(self.labels) do
		if !self.labels[k]:IsValid() then
			self.labels[k] = nil
		else
			self.labels[k]:SetPos(8, y);
			-- Increase the y position.
			y = y + self.labels[k]:GetTall() + 8
		end
	end
end
-- Set Text.
function PANEL:SetText(text)
	for k, v in pairs(self.labels) do v:Remove() end
	self.itemsList:Clear()
	self.mypanel = vgui.Create("DPanel",self)
	self.itemsList:AddItem(self.mypanel)
	-- Define our x and y positions.
	local y = 5
	local texty = {}
	for k,v in pairs(text) do
		local wrapped = {}
		-- Wrap the text to the width of the menu.
		cider.chatBox.wrapText(v, "Default", cider.menu.width - 48, 0, wrapped)
		for k2,v2 in pairs(wrapped) do
			table.insert(texty,v2)
		end
	end

	-- Loop through the text we're given.
	a = 1
	for k, v in pairs(texty) do
		local label = vgui.Create("DLabel", self.mypanel)
		--print(v)
		-- Set the text of the label.
		label:SetText( v )
		label:SetTextColor( Color(0, 0, 0, 255) )
		label:SizeToContents()

		-- Insert the label into our labels table.
		self.labels[a]= label
		a = a + 1
		-- Increase the y position.
		y = y + label:GetTall() + 8
	end
	--print("new")
	--PrintTable(self.labels)
	local reversed = {}
	for i = #self.labels, 1, -1 do
		reversed[#self.labels - i + 1] = self.labels[i]
	end
	self.labels = reversed

	-- Set the size of the panel.
	self.mypanel:SetSize(cider.menu.width, y)
	self:InvalidateLayout()
	--self.mypanel:InvalidateLayout()
end
-- Register the panel.
vgui.Register("cider_Log_eventlog", PANEL, "Panel")