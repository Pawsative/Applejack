--[[
Name: "cl_credits.lua".
	~ Applejack ~
--]]

local PANEL = {};

-- Store the credits in a string.


--If you're going to edit this, please leave the top 2 authors in this file, as they're the ones who actually MADE this gamemode.
PANEL.credits = [[
[Credits]
kurozael (Conna) - Made the core systems of Cider, populated it with items and released it.
Lexi - Vast swathes of improvements to the script, going with the philosophy that "Light RP doesn't have to be shit."
Pawsative - Conversion of the Gamemode.
rayts - Conversion of the Gamemode.
Int64 - Conversion of the Gamemode.

]]

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(cider.menu.width, cider.menu.height - 8);

	-- Create a panel list to store the items.
	self.itemsList = vgui.Create("DPanelList", self);
 	self.itemsList:SizeToContents();
 	self.itemsList:SetPadding(2);
 	self.itemsList:SetSpacing(3);
	self.itemsList:StretchToParent(4, 4, 12, 44);
	self.itemsList:EnableVerticalScrollbar();

	-- Get the exploded text.
	local exploded = string.Explode("\n", self.credits);
	local credits = {};
	local key = 0;

	-- Loop through our credits.
	for k, v in pairs(exploded) do
		if (k < #exploded or v ~= "") then
			if (string.sub(v, 1, 1) == "[" and string.sub(v, -1) == "]") then
				key = key + 1;

				-- Insert a new credits title.
				credits[key] = { title = string.sub(v, 2, -2), credits = {} };
			else
				if ( credits[key] ) then
					local wrapped = {};

					-- Wrap the text to the width of the menu.
					cider.chatBox.wrapText(v, "Default", cider.menu.width - 48, 0, wrapped);

					-- Loop through the wrapped text.
					for k2, v2 in pairs(wrapped) do table.insert(credits[key].credits, v2); end
				end
			end
		end
	end

	-- Loop through our credits.
	for k, v in pairs(credits) do
		local header = vgui.Create("cider_credits_Header", self);

		-- Set the text of the header label and add it to the item list.
		header.label:SetText(v.title); self.itemsList:AddItem(header);

		-- Create the text for this title.
		local text = vgui.Create("cider_credits_Text", self);

		-- Set the credits for this title and add it to the item list.
		text:SetText(v.credits); self.itemsList:AddItem(text);
	end
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:StretchToParent(0, 22, 0, 0);
	self.itemsList:StretchToParent(0, 0, 0, 0);
end

-- Register the panel.
vgui.Register("cider_Credits", PANEL, "Panel");

-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init() self.labels = {}; end

-- Set Text.
function PANEL:SetText(text)
	for k, v in pairs(self.labels) do v:Remove(); end

	-- Define our x and y positions.
	local y = 5;

	-- Loop through the text we're given.
	for k, v in pairs(text) do
		local label = vgui.Create("DLabel", self);

		-- Set the text of the label.
		label:SetText( v );
		label:SetTextColor( Color(0, 0, 0, 255) );
		label:SizeToContents();

		-- Insert the label into our labels table.
		table.insert(self.labels, label);

		-- Increase the y position.
		y = y + label:GetTall() + 8
	end

	-- Set the size of the panel.
	self:SetSize(cider.menu.width, y);
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	local y = 5;

	-- Loop through all of our labels.
	for k, v in pairs(self.labels) do
		-- self.labels[k]:SetPos(self:GetWide() / 2 - self.labels[k]:GetWide() / 2, y);
		self.labels[k]:SetPos(8, y);

		-- Increase the y position.
		y = y + self.labels[k]:GetTall() + 8
	end
end

-- Register the panel.
vgui.Register("cider_credits_Text", PANEL, "DPanel");

-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self.label = vgui.Create("DLabel", self);
	self.label:SetText("N/A");
	self.label:SetFont("ChatFont");
	self.label:SetTextColor( Color(0, 0, 0, 255) );
	self.label:SizeToContents();
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.label:SetPos(self:GetWide() / 2 - self.label:GetWide() / 2, self:GetTall() / 2 - self.label:GetTall() / 2);
	self.label:SizeToContents();
end

-- Register the panel.
vgui.Register("cider_credits_Header", PANEL, "DPanel");