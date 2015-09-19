--[[
Name: "cl_donate.lua".
	~ Applejack ~
--]]

local PANEL = {};

-- Store the services in a string.
PANEL.services = [[
Official Forum Thread: donate link 

donate details here
]];

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
	local exploded = string.Explode("\n", self.services);
	local services = {};
	local key = 0;

	-- Loop through our services.
	for k, v in pairs(exploded) do
		if (k < #exploded or v ~= "") then
			if (string.sub(v, 1, 1) == "[" and string.sub(v, -1) == "]") then
				key = key + 1;

				-- Insert a new donate service.
				services[key] = { service = string.sub(v, 2, -2), bonuses = {} };
			else
				if (key == 0) then
					key = key + 1; services[key] = { service = "Donate", bonuses = {} };
				end

				-- Check if a service for this key exists.
				if ( services[key] ) then
					local wrapped = {};

					-- Wrap the text to the width of the menu.
					cider.chatBox.wrapText(v, "Default", cider.menu.width - 52, 0, wrapped);

					-- Loop through the wrapped text.
					for k2, v2 in pairs(wrapped) do table.insert(services[key].bonuses, v2); end
				end
			end
		end
	end

	-- Loop through our services.
	for k, v in pairs(services) do
		local form = vgui.Create("DForm"); self.itemsList:AddItem(form);

		-- Set some information about the form.
		form:SetName(v.service);
		form:SetPadding(4);

		-- Create the text for this category.
		local text = vgui.Create("cider_Donate_Text", self);

		-- Set the rules for this category and add it to the item list.
		text:SetText(v.bonuses); form:AddItem(text);
	end
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:StretchToParent(0, 22, 0, 0);
	self.itemsList:StretchToParent(0, 0, 0, 0);
end

-- Register the panel.
vgui.Register("cider_Donate", PANEL, "Panel");

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
		label:SetText( string.Replace(v, "> ", "") );
		label:SetTextColor( Color(0, 0, 0, 255) );
		label:SizeToContents();

		-- Check if the text is supposed to be green.
		if ( string.find(v, "> ") ) then
			label:SetTextColor( Color(150, 255, 100, 255) );
		end

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
		self.labels[k]:SetPos(8, y);

		-- Increase the y position.
		y = y + self.labels[k]:GetTall() + 8
	end
end

-- Register the panel.
vgui.Register("cider_Donate_Text", PANEL, "DPanel");