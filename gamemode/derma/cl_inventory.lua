--[[
Name: "cl_inventory.lua".
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

	-- Set this to true to begin with so that we do one starting update.
	cider.inventory.updatePanel = true;

	-- We call think just once on initialize so that we can update.
	self:Think();
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:StretchToParent(0, 22, 0, 0);
	self.itemsList:StretchToParent(0, 0, 0, 0);
end

-- Called every frame.
function PANEL:Think()
	if (cider.inventory.updatePanel) then
		cider.inventory.updatePanel = false;

		-- Clear the current list of items.
		self.itemsList:Clear();
		self.itemsList:AddItem( vgui.Create("cider_Inventory_Information", self) );
			-- Create a table to store the categories.
		local categories = { none = {} };

		-- Loop through the items.
		for k, v in pairs(cider.inventory.stored) do
			item = GM.Items[k];
			if (item) then
				cat = item.Category;
				if (cat and GM:GetCategory(cat)) then
					categories[cat] = categories[cat] or {};

					-- Insert the item into the category table.
					table.insert(categories[cat], k);
				else
					table.insert(categories.none, k);
				end
			end
		end
	--	table.sort(categories)
		-- Loop through the categories.
		for k, v in pairs(categories) do
			if (k == "none") then
				-- Loop through the items.
				for k2, v2 in pairs(v) do
					self.currentItem = v2;
					self.itemsList:AddItem( vgui.Create("cider_Inventory_Item", self) ) ;
				end
			else
				local c = GM:GetCategory(k)
				if (not c.NoShow) then -- If the category doesn't want to show up (like it's plugin is missing) then don't show it.
					local header = vgui.Create("DCollapsibleCategory", self)
					header:SetSize(cider.menu.width, 50); -- Keep the second number at 50
					header:SetLabel( c.Name )
					header:SetToolTip( c.Description )
					self.itemsList:AddItem(header);
					local subitemsList = vgui.Create("DPanelList", self);
					subitemsList:SetAutoSize( true )
					subitemsList:SetPadding(2);
					subitemsList:SetSpacing(3);
					header:SetContents( subitemsList )
					-- Loop through the items.
					for k2, v2 in pairs(v) do
						self.currentItem = v2;
						-- Add the item to the item list.
						subitemsList:AddItem( vgui.Create("cider_Inventory_Item", self) ) ;
					end
				end
			end
		end
		-- Rebuild the items list.
		self.itemsList:Rebuild();
	end
end

-- Register the panel.
vgui.Register("cider_Inventory", PANEL, "Panel");

-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
local word;
function PANEL:Init()
	self.itemFunctions = {};

	-- Set the size and position of the panel.
	self:SetSize(cider.menu.width, 75);
	self:SetPos(1, 5);

	-- Set the item that we are.
	self.item = self:GetParent().currentItem;
	local item = GM.Items[self.item]
	local amount = cider.inventory.stored[self.item];
	-- Create a label for the name.
	self.name = vgui.Create("DLabel", self);
	word = (amount > 1) and item.Plural or item.Name;
	self.name:SetText(amount.." "..word.." (Size: "..item.Size..")");
	self.name:SizeToContents();
	self.name:SetTextColor( Color(0, 0, 0, 255) );

	-- Create a label for the description.
	self.description = vgui.Create("DLabel", self);
	self.description:SetText(item.Description);
	self.description:SizeToContents();
	self.description:SetTextColor( Color(0, 0, 0, 255) );

	-- Create the spawn icon.
	self.spawnIcon = vgui.Create("SpawnIcon", self);

	-- Set the model of the spawn icon to the one of the item.
	self.spawnIcon:SetModel(item.Model,item.Skin)


	self.spawnIcon:SetToolTip();
	self.spawnIcon.DoClick = function() return; end
	self.spawnIcon.OnMousePressed = function() return; end

	-- Check to see if the item has an on use callback.
	if (item.onUse) then table.insert(self.itemFunctions, "Use"); end
	if (item.onDrop) then table.insert(self.itemFunctions, "Drop"); end
	if (item.onSell ) then table.insert(self.itemFunctions, "Sell"); end
	if (item.onPickup) then table.insert(self.itemFunctions, "Pick up") end
	if (item.onDestroy) then table.insert(self.itemFunctions, "Destroy All"); end
	-- Create the table to store the item buttons.
	self.itemButton = {};

	-- Loop through the item functions.
	-- TODO: Make this not as inefficient
	for i = 1, #self.itemFunctions do
		if (self.itemFunctions[i]) then
			self.itemButton[i] = vgui.Create("DButton", self);
			self.itemButton[i]:SetText(self.itemFunctions[i]);

			-- Check what type of button it is.
			if (self.itemFunctions[i] == "Use") then
				self.itemButton[i].DoClick = function()
					RunConsoleCommand("cider", "inventory", self.item, "use");
					if item.AutoClose then
						cider.menu.toggle()
					end
				end
			elseif (self.itemFunctions[i] == "Drop") then
				self.itemButton[i].DoClick = function()

					if cider.inventory.stored[self.item] < 2 then
						RunConsoleCommand("cider", "inventory", self.item, "drop", 1);
						-- Close the main menu.
						cider.menu.toggle();
						return
					end
					local menu = DermaMenu();

					-- Add an option for yes and no.
					menu:AddOption("1", function()
						RunConsoleCommand("cider", "inventory", self.item, "drop", 1);
						-- Close the main menu.
						cider.menu.toggle();
					end);
					menu:AddOption("All", function()
						RunConsoleCommand("cider", "inventory", self.item, "drop", "all");
						-- Close the main menu.
						cider.menu.toggle();
					end);
					menu:AddOption("Amount",function()
							local EditPanel = vgui.Create( "DFrame" )
							EditPanel:SetPos( (ScrW()- 50)/2,(ScrH() -38)/2 )
							EditPanel:SetSize( 100 ,76 )
							EditPanel:SetTitle( "Amount" )
							EditPanel:SetVisible( true )
							EditPanel:SetDraggable( true )
							EditPanel:ShowCloseButton( true )
							EditPanel:MakePopup()
							--	y = 28
							local box = vgui.Create("DTextEntry",EditPanel)
							box:SetPos(10,28)
							box:SetSize(EditPanel:GetWide()-20,16)
							box:RequestFocus()
							box.OnEnter = function()
								val = tonumber(box:GetValue())
								if not val or string.sub(val,1,1) == "-" then return end
								RunConsoleCommand("cider", "inventory", self.item, "drop", math.floor(val));
								EditPanel:Close()
								-- Close the main menu.
								cider.menu.toggle();
							end
							button = vgui.Create("DButton",EditPanel)
							button:SetText("Drop")
							button.DoClick = function()
								val = tonumber(box:GetValue())
								if not val then return end
								RunConsoleCommand("cider", "inventory", self.item, "drop", val);
								EditPanel:Close()
								-- Close the main menu.
								cider.menu.toggle();
							end
							button:SetPos(EditPanel:GetWide()-button:GetWide()-10,46)
					end)

					-- Open the menu.
					menu:Open() ;

				end
			elseif (self.itemFunctions[i] == "Pick up") then
				self.itemButton[i].DoClick = function()
					RunConsoleCommand("cider", "inventory", self.item, "pickup");
				end
			elseif (self.itemFunctions[i] == "Sell") then
				self.itemButton[i].DoClick = function()
					local menu = DermaMenu();

					-- Add an option for yes and no.
					menu:AddOption("No", function() end);
					menu:AddOption("Yes", function()
						RunConsoleCommand("cider", "inventory", self.item, "sell");
					end);

					-- Open the menu.
					menu:Open() ;
				end
			elseif (self.itemFunctions[i] == "Destroy All") then
				self.itemButton[i].DoClick = function()
					local menu = DermaMenu();

					-- Add an option for yes and no.
					menu:AddOption("No", function() end);
					menu:AddOption("Yes", function()
						RunConsoleCommand("cider", "inventory", self.item, "destroy");
					end);

					-- Open the menu.
					menu:Open() ;
				end
			end
		end
	end
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self.spawnIcon:SetPos(4, 5);
	self.name:SizeToContents();
	self.description:SetPos(75, 24);
	self.description:SizeToContents();

	-- Define the x position of the item functions.
	local x = self.spawnIcon.x + self.spawnIcon:GetWide() + 8;

	-- Set the position of the name and description.
	self.name:SetPos(x, 4);
	self.description:SetPos(x, 24);

	-- Loop through the item functions and set the position of their button.
	for i = 1, #self.itemFunctions do
		if (self.itemButton[i]) then
			self.itemButton[i]:SetPos(x, 47);

			-- Increase the x position for the next item function.
			x = x + self.itemButton[i]:GetWide() + 4;
		end
	end
end

-- Register the panel.
vgui.Register("cider_Inventory_Item", PANEL, "DPanel");

-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local maximumSpace = cider.inventory.getMaximumSpace();

	-- Create the space used label.
	self.spaceUsed = vgui.Create("DLabel", self);
	self.spaceUsed:SetText("Space Used: "..cider.inventory.getSize().."/"..maximumSpace);
	self.spaceUsed:SizeToContents();
	self.spaceUsed:SetTextColor( Color(0, 0, 0, 255) );
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	local maximumSpace = cider.inventory.getMaximumSpace();

	-- Set the position of the label.
	self.spaceUsed:SetPos( (self:GetWide() / 2) - (self.spaceUsed:GetWide() / 2), 5 );
	self.spaceUsed:SetText("Space Used: "..cider.inventory.getSize().."/"..maximumSpace);
end

-- Register the panel.
vgui.Register("cider_Inventory_Information", PANEL, "DPanel");