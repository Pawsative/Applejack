--[[
Name: "cl_store.lua".
	~ Applejack ~
--]]
--[[
local cmo = RunConsoleCommand
local RunConsoleCommand = function(...)
	print(...)
	cmo(...)
end
--]]
local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self.team = LocalPlayer():Team()
	self.headers = {}
	self:SetSize(cider.menu.width, cider.menu.height - 8);

	-- Create a panel list to store the items.
	self.itemsList = vgui.Create("DPanelList", self);
 	self.itemsList:SizeToContents();
 	self.itemsList:SetPadding(2);
 	self.itemsList:SetSpacing(3);
	self.itemsList:StretchToParent(4, 4, 12, 44);
	self.itemsList:EnableVerticalScrollbar();

	-- Create a table to store the categories.
	local categories = {};
	-- Loop through the items
	for k, v in pairs(GM.Items) do
		if (v.Store and v.Cost and v.Batch) then
			local cat = v.Category;
			if cat and GM:GetCategory(cat) then
				categories[cat] = categories[cat] or {};
				-- Insert the item into the category table.
				table.insert(categories[cat], k);
			else
				categories.none = categories.none or {}
				table.insert(categories.none, k);
			end
		end
	end
	-- Loop through the categories.
	for k, v in pairs(categories) do
		if (k == "none") then
			table.sort(v, function(a, b) return GM.Items[a].Cost > GM.Items[b].Cost end)
			-- Loop through the items.
			for k2, v2 in pairs(v) do
				self.currentItem = v2;

				-- Add the item to the item list.
				self.itemsList:AddItem( vgui.Create("cider_Store_Item", self) );
			end
		else
			local c = GM:GetCategory(k)
			if (not c.NoShow) then -- If the category doesn't want to show up (like it's plugin is missing) then don't show it.
				self.headers[k] = vgui.Create("DCollapsibleCategory", self)
				self.headers[k]:SetSize(cider.menu.width, 50); -- Keep the second number at 50
				self.headers[k]:SetExpanded( table.HasValue(cider.team.query(self.team,"canmake",{}), k)) -- Expanded when popped up
				self.headers[k]:SetLabel( c.Name )
				self.headers[k]:SetTooltip( c.Description )
				self.itemsList:AddItem(self.headers[k]);
				local subitemsList = vgui.Create("DPanelList", self);
				subitemsList:SetAutoSize( true )
				subitemsList:SetPadding(2);
				subitemsList:SetSpacing(3);
				self.headers[k]:SetContents( subitemsList )
				-- Sort the items by cost.
				table.sort(v, function(a, b) return GM.Items[a].Cost > GM.Items[b].Cost end)

				-- Loop through the items.
				for k2, v2 in pairs(v) do
					self.currentItem = v2;

					-- Add the item to the item list.
					subitemsList:AddItem( vgui.Create("cider_Store_Item", self) );
				end
			end
		end
	end
end
function PANEL:Think()
	local job = LocalPlayer():Team()
	if job ~= self.team then
		self.team = job
		for k,v in pairs(self.headers) do
			v:Toggle()
			v:SetExpanded( table.HasValue(cider.team.query(self.team,"canmake",{}), k))
	end
	end
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:StretchToParent(0, 22, 0, 0);
	self.itemsList:StretchToParent(0, 0, 0, 0);
end

-- Register the panel.
vgui.Register("cider_Store", PANEL, "Panel");

-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self.item = self:GetParent().currentItem;
	local item = GM.Items[self.item]
	-- Get the cost of the item in total.
	local cost = item.Cost * item.Batch;

	-- The name of the item.
	self.label = vgui.Create("DLabel", self);
	self.label:SetTextColor( Color(0, 0, 0, 255) );

	-- Check if it is not a single batch.
	if (item.Batch > 1) then
		self.label:SetText(item.Batch.." "..item.Plural.." ($"..cost..")");
	else
		self.label:SetText(item.Batch.." "..item.Name.." ($"..cost..")");
	end

	-- The description of the item.
	self.description = vgui.Create("DLabel", self);
	self.description:SetTextColor( Color(0, 0, 0, 255) );
	self.description:SetText(item.Description);

	-- Set the size of the panel.
	self:SetSize(cider.menu.width, 75);

	-- Create the button and the spawn icon.
	self.button = vgui.Create("DButton", self);
	self.spawnIcon = vgui.Create("SpawnIcon", self);

	-- Set the text of the button.
	self.button:SetText("Manufacture");
	self.button:SetSize(80, 22);
	self.button.DoClick = function()
		RunConsoleCommand("cider", "manufacture", self.item);
	end

	-- Set the model of the spawn icon to the one of the item.
	self.spawnIcon:SetModel(item.Model,item.Skin)
	self.spawnIcon:SetToolTip()
	self.spawnIcon.DoClick = function() return end
	self.spawnIcon.OnMousePressed = function() return end
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.spawnIcon:SetPos(4, 5);
	self.label:SetPos(self.spawnIcon.x + self.spawnIcon:GetWide() + 8, 5);
	self.label:SizeToContents();
	self.description:SetPos(self.spawnIcon.x + self.spawnIcon:GetWide() + 8, 24);
	self.description:SizeToContents();
	self.button:SetPos( self.spawnIcon.x + self.spawnIcon:GetWide() + 8, self.spawnIcon.y + self.spawnIcon:GetTall() - self.button:GetTall() );
end

-- Register the panel.
vgui.Register("cider_Store_Item", PANEL, "DPanel");

-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self.label = vgui.Create("DLabel", self);
	self.label:SetText("N/A");
	self.label:SizeToContents();
	self.label:SetTextColor( Color(0, 0, 0, 255) );
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.label:SetPos( (self:GetWide() / 2) - (self.label:GetWide() / 2), 5 );
	self.label:SizeToContents();
end

-- Register the panel.
vgui.Register("cider_Store_Header", PANEL, "DPanel");