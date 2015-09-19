--[[
Name: "cl_rules.lua".
	~ Applejack ~
--]]
local PANEL = {};

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
	local exploded = string.Explode("\n", GM.Config["Rules"]);
	local rules = {};
	local key = 0;

	-- Loop through our rules.
	for k, v in pairs(exploded) do
		if (k < #exploded or v ~= "") then
			if  string.sub(v, 1, 1) == "<" and string.sub(v, -1) == ">"  then
				key = key + 1
				rules[key] = { heading = "#"..string.sub(v, 2, -2) }
			elseif (string.sub(v, 1, 1) == "[" and string.sub(v, -1) == "]") then
				key = key + 1;

				-- Insert a new Rules heading.
				rules[key] = { heading = string.sub(v, 2, -2), rules = {} };
			else
				if ( rules[key] ) then
					local wrapped = {};

					-- Wrap the text to the width of the menu.
					cider.chatBox.wrapText(v, "Default", cider.menu.width - 48, 0, wrapped);

					-- Loop through the wrapped text.
					for k2, v2 in pairs(wrapped) do table.insert(rules[key].rules, v2); end
				end
			end
		end
	end

	-- Loop through our rules.
	for k, v in pairs(rules) do
		local header = vgui.Create("cider_Rules_Header", self);

		-- Set the text of the header label and add it to the item list.
		header.label:SetText(v.heading);
		if string.sub(v.heading, 1, 1) == "#" then
			header:SetHeight(header:GetTall()*3)
		end
		self.itemsList:AddItem(header);

		if v.rules then -- Create the text for this heading.
			local text = vgui.Create("cider_Rules_Text", self);

			-- Set the rules for this heading and add it to the item list.
			text:SetText(v.rules); self.itemsList:AddItem(text);
		end
	end
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:StretchToParent(0, 22, 0, 0);
	self.itemsList:StretchToParent(0, 0, 0, 0);
end

-- Register the panel.
vgui.Register("cider_Rules", PANEL, "Panel");

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
vgui.Register("cider_Rules_Text", PANEL, "DPanel");

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
vgui.Register("cider_Rules_Header", PANEL, "DPanel");
--[[
local PANEL = {};

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

	-- Create the text for this category.
	local text = vgui.Create("cider_Rules_Text", self);

	-- Set the help for this category.
	text:SetText( string.Explode("\n", GM.Config["Rules"]) );

	-- Add the text to the item list.
	self.itemsList:AddItem(text);
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:StretchToParent(0, 22, 0, 0);
	self.itemsList:StretchToParent(0, 0, 0, 0);
end

-- Register the panel.
vgui.Register("cider_Rules", PANEL, "Panel");

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
		if (v ~= "") then
			local label = vgui.Create("DLabel", self);

			-- Set the text of the label.
			label:SetText(v);
			label:SetTextColor( Color(0, 0, 0, 255) );
			label:SizeToContents();

			-- Insert the label into our labels table.
			table.insert(self.labels, label);

			-- Increase the y position.
			y = y + label:GetTall() + 8
		end
	end

	-- Set the size of the panel.
	self:SetSize(cider.menu.width, y);
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
end

-- Register the panel.
vgui.Register("cider_Rules_Text", PANEL, "DPanel");]]