--[[
Name: "cl_help.lua".
	~ Applejack ~
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(cider.menu.width, cider.menu.height - 8);

	-- Here we can tell the help system that this is our panel.
	cider.help.panel = self;

	-- Create a panel list to store the items.
	self.itemsList = vgui.Create("DPanelList", self);
 	self.itemsList:SizeToContents();
 	self.itemsList:SetPadding(2);
 	self.itemsList:SetSpacing(3);
	self.itemsList:StretchToParent(4, 4, 12, 44);
	self.itemsList:EnableVerticalScrollbar();

	-- We need to load the current help into our items list.
	self:Reload();
end

-- Reload the help text.
function PANEL:Reload()
	for k, v in pairs(cider.help.stored) do
		local header = vgui.Create("cider_Help_Header", self);

		-- Set the text of the header label.
		header.label:SetText(k);

		-- Add the header to the item list.
		self.itemsList:AddItem(header);

		-- Create the text for this category.
		local text = vgui.Create("cider_Help_Text", self);

		-- Set the help for this category.
		text:SetText(v);

		-- Add the text to the item list.
		self.itemsList:AddItem(text);
	end
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:StretchToParent(0, 22, 0, 0);
	self.itemsList:StretchToParent(0, 0, 0, 0);
end

-- Register the panel.
vgui.Register("cider_Help", PANEL, "Panel");

-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init() self.labels = {}; end

-- Set Text.
function PANEL:SetText(text)
	for k, v in ipairs(self.labels) do v:Remove(); end

	-- Define our x and y positions.
	local y = 5;

	-- Loop through the text we're given.
	for k, v in ipairs(text) do
		local label = vgui.Create("cider_Help_Label", self);

		-- Set the text of the label.
		label.label:SetText(v.text);
		label:SetToolTip(v.tip);

		-- Insert the label into our labels table.
		table.insert(self.labels, label);

		-- Increase the y position.
		y = y + label:GetTall() + 8
	end
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	local y = 5;

	-- Loop through all of our labels.
	for k, v in pairs(self.labels) do
		self.labels[k]:SetPos(self:GetWide() / 2 - self.labels[k]:GetWide() / 2, y);

		-- Increase the y position.
		y = y + self.labels[k]:GetTall() + 8
	end

	-- Set the size of the panel.
	self:SetSize(cider.menu.width - 28, y);
end

-- Register the panel.
vgui.Register("cider_Help_Text", PANEL, "DPanel");

-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self.label = vgui.Create("DLabel", self);
	self.label:SetText("N/A");
	self.label:SetTextColor( Color(0, 0, 0, 255) );
	self.label:SizeToContents();
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.label:SetPos(self:GetWide() / 2 - self.label:GetWide() / 2, self:GetTall() / 2 - self.label:GetTall() / 2);
	self.label:SizeToContents();
end

-- Register the panel.
vgui.Register("cider_Help_Header", PANEL, "DPanel");

-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self.label = vgui.Create("DLabel", self);

	-- Set the text color of the label.
	self.label:SetTextColor( Color(0, 0, 0, 255) );
end

-- Called when the panel should be painted.
function PANEL:Paint() return true; end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.label:SizeToContents();
	self:SetSize( self.label:GetWide(), self.label:GetTall() );
end

-- Register the panel.
vgui.Register("cider_Help_Label", PANEL, "DPanel");