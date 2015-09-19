--[[
Name: "cl_containr.lua".
	~ Applejack ~
--]]
local PANEL = {};
local width,height = ScrW()*0.75,ScrH()*0.75
local containermenu,targetEntity,lpl

local function closeMenu()
	if containermenu then
		containermenu:Close()
		containermenu:Remove()
		gui.EnableScreenClicker(false)
		RunConsoleCommand"MommyIAmDoneWithTheContainerNow"
	end
end
usermessage.Hook("cider_CloseContainerMenu",closeMenu)
local function CheckPos()
	if not IsValid(lpl) then lpl = LocalPlayer() end
	--print("POS!")
	if not (lpl:Alive() and lpl:GetEyeTraceNoCursor().Entity == targetEntity) then
		closeMenu()
		return false
	end
	return true
end
--[[
local cmo = RunConsoleCommand
local RunConsoleCommand = function(...)
	print(...)
	cmo(...)
end
--]]
-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(width/2 -12, height - 40);
	self:ShowCloseButton(false)

	-- Create a panel list to store the items.
	self.itemsList = vgui.Create("DPanelList", self);
 	self.itemsList:SizeToContents();
 	self.itemsList:SetPadding(2);
 	self.itemsList:SetSpacing(3);
	self.itemsList:StretchToParent(4, 4, 12, 44);
	self.itemsList:EnableVerticalScrollbar();

	self.updatePanel = false
	self.mSpace = 40
	self.inventory = {}
	self.action = 0
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
--	self:StretchToParent(0, 22, 0, 0);
	self.itemsList:StretchToParent(0, 0, 0, 0);
end

-- Called every frame.
local item,cat;
function PANEL:Think()
	if (self.updatePanel) then
		self.updatePanel = false;

		-- Clear the current list of items.
		self.itemsList:Clear();
		local info = vgui.Create("cider_Container_Information", self)
		info.mSpace = self.mSpace
		info.word = self.name
		info.inventory = self.inventory
		self.itemsList:AddItem( info);
			-- Create a table to store the categories.
		local categories = { none = {} };

		-- Loop through the items.
		for k, v in pairs(self.inventory) do
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
		for k, v in pairs(categories) do
			if (k == "none") then
				-- Loop through the items.
				for k2, v2 in pairs(v) do
					self.currentItem = v2;
					self.itemsList:AddItem( vgui.Create("cider_Container_Item", self) ) ;
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
						subitemsList:AddItem( vgui.Create("cider_Container_Item", self) ) ;
					end
				end
			end
		end
		-- Rebuild the items list.
		self.itemsList:Rebuild();
	end
end

-- Register the panel.
vgui.Register("cider_Container_Inventory", PANEL, "Panel");

-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
local word;
function PANEL:Init()
	-- Set the size and position of the panel.
	self:SetSize(width/2, 75);
	self:SetPos(1, 5);

	-- Set the item that we are.
	self.item = self:GetParent().currentItem;
	self.action = self:GetParent().action
	local amount = self:GetParent().inventory[self.item]
	local notake = false
	local item = GM.Items[self.item]
	if amount < 0 or item.Size < 0 	then
		notake = true
		amount = math.abs(amount)
	end
	-- Create a label for the name.
	self.name = vgui.Create("DLabel", self);
	word = (amount > 1) and item.Plural or item.Name;
	self.name:SetText(amount.." "..word.." (Size: "..item.Size..")");
	self.name:SizeToContents();
	self.name:SetTextColor( Color(0, 0, 0, 255) );

	-- Create a label for the description.
	self.description = vgui.Create("DLabel", self);
	self.description:SetText(item.Description or "");
	self.description:SizeToContents();
	self.description:SetTextColor( Color(0, 0, 0, 255) );

	-- Create the spawn icon.
	self.spawnIcon = vgui.Create("SpawnIcon", self);

	-- Set the model of the spawn icon to the one of the item.
	self.spawnIcon:SetModel(item.Model,item.Skin)


	self.spawnIcon:SetToolTip();
	self.spawnIcon.DoClick = function() return; end
	self.spawnIcon.OnMousePressed = function() return; end
	self.itemFunctions = {};

	-- Check to see if the item has an on use callback.
	if not notake and self.action && containermenu.meta.io == self.action then
		if self.action == CAN_PUT then
			if not containermenu.meta.filter or containermenu.meta.filter[self.item] then
				table.insert(self.itemFunctions, "Put" )
			end
		else
			table.insert(self.itemFunctions, "Take")
		end
	end
	--[[
	THE CONTAINER SYSTEM IS COMPLETE (fuck yeah)
[youtube]http://www.youtube.com/watch?v=D_B0ZUwhBEk&fmt=18[/youtube]
[b]there are no plugins that use it yet[/b].
In the interests of getting this fucking massive update out the door within the week, single-use crates will [b]not[/b] be included. The postal system will [b]not[/b] be included. The new contraband system will [b]not[/b] be included.
The only thing that you can do with containers this update is spawn them from the Q menu. They [b]are[/b] Lock(pick)able, and they [b]are[/b] multiown, so it's not all that bad.
Container props like filing cabinets spawned by the detail system [b]are[/b] automatically made into containers.
--]]

	-- Create the table to store the item buttons.
	self.itemButton = {};
	--TODO: Deal with this horrible mess of inline functions
	local function menus(self)
		if not CheckPos() then return end
		if containermenu.Buttoned then return end -- If a button has been pressed, we can't do anything until sent an update.
		if amount < 2 then
			RunConsoleCommand("cider", "container", item.UniqueID, string.lower(self:GetValue()), 1);
			containermenu.Buttoned = true
			return
		end
		local menu = DermaMenu();
		-- Add an option for yes and no.
		menu:AddOption("1", function()
			RunConsoleCommand("cider", "container", item.UniqueID, string.lower(self:GetValue()), 1);
			-- Close the main menu.
			containermenu.Buttoned = true
		end);
		menu:AddOption("All", function()
			RunConsoleCommand("cider", "container", item.UniqueID, string.lower(self:GetValue()), "all");
			-- Close the main menu.
			containermenu.Buttoned = true
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
				local func = function()
					val = tonumber(box:GetValue())
					if (not val) or string.sub(val,1,1) == "-" then return end
					RunConsoleCommand("cider", "container", item.UniqueID, string.lower(self:GetValue()), math.floor(val));
					EditPanel:Close()
					-- Close the main menu.
					containermenu.Buttoned = true
				end
				box.OnEnter = func
				button = vgui.Create("DButton",EditPanel)
				button:SetText(self:GetValue())
				button.DoClick = func
				button:SetPos(EditPanel:GetWide()-button:GetWide()-10,46)
		end)

		-- Open the menu.
		menu:Open() ;

	end

	-- Loop through the item functions.
	for i = 1, #self.itemFunctions do
		if (self.itemFunctions[i]) then
			self.itemButton[i] = vgui.Create("DButton", self);
			self.itemButton[i]:SetText(self.itemFunctions[i]);
			self.itemButton[i].DoClick = menus
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
vgui.Register("cider_Container_Item", PANEL, "DPanel");
-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()

	-- Create the space used label.
	self.word = self.word or "argh"
	self.spaceUsed = vgui.Create("DLabel", self);
	self.spaceUsed:SetText(self.word.." Space Used: MMMMM/MMMMM");
	self.spaceUsed:SizeToContents();
	self.spaceUsed:SetTextColor( Color(0, 0, 0, 255) );
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()

	-- Set the position of the label.
	self.spaceUsed:SetPos( (self:GetWide() / 2) - (self.spaceUsed:GetWide() / 2), 5 );
	self.spaceUsed:SetText(self.word.." Space Used: "..cider.inventory.getSize(self.inventory).."/"..self.mSpace);
	self.spaceUsed:SizeToContents();
end

-- Register the panel.
vgui.Register("cider_Container_Information", PANEL, "DPanel");

-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetTitle("Container");
	self:SetBackgroundBlur(true);
	self:SetDeleteOnClose(true);
	-- Create the close button.
	self.close = vgui.Create("DButton", self);
	self.close:SetText("Close");
	self.close.DoClick = closeMenu

	-- Capture the position of the local player.
	localPlayerPosition = LocalPlayer():GetPos();
	self.pInventory = vgui.Create("cider_Container_Inventory",self)
	self.cInventory = vgui.Create("cider_Container_Inventory",self)
	self.pInventory.action = CAN_PUT
	self.pInventory.name = "Your Inventory"
	self.cInventory.action = CAN_TAKE
	self.cInventory.name = "Container Inventory"

end

-- Called when the layout should be performed.
function PANEL:PerformLayout()

	self:SetSize(width,height)
	self:SetPos((ScrW() - width)/2,(ScrH() - height)/2)
	--[[
	self:SetSize(8 + self.InventoryList:GetWide() + 8 + self.containerList:GetWide() + 8, 28 + self.InventoryList:GetTall() + 8 + self.textEntry:GetTall() + 8);
	self:SetPos(ScrW() / 2 - self:GetWide() / 2, ScrH() / 2 - self:GetTall() / 2);
	--]]
	self.close:SetSize(48, 16);
	self.close:SetPos(self:GetWide() - self.close:GetWide() - 4, 3);

	-- Set the position of both lists
	self.pInventory:SetPos(8, 25);
	self.cInventory:SetPos(8 + self.cInventory:GetWide() + 8, 25);
	-- Perform the layout of the main frame.
	DFrame.PerformLayout(self);
end

-- Register the panel.
vgui.Register("cider_Container", PANEL, "DFrame");--]]
local function UpdateContainer(decoded)
	if not containermenu then return end
	containermenu.meta = decoded.meta
	targetEntity = Entity(decoded.meta.entindex)
	if not IsValid(targetEntity) then
		ErrorNoHalt("Invalid entity passed to the container menu!")
		closeMenu()
		return
	end
	containermenu:SetTitle(decoded.meta.name)
	local pinventory = table.Copy(cider.inventory.stored);
	local cinventory = decoded.contents
	local m = LocalPlayer()._Money
	pinventory["money"] =  m > 0 and m or nil
	containermenu.pInventory.inventory = pinventory
	containermenu.cInventory.inventory = cinventory
	containermenu.cInventory.mSpace = containermenu.meta.size
	containermenu.pInventory.mSpace = cider.inventory.getMaximumSpace()
	containermenu.pInventory.updatePanel = true
	containermenu.cInventory.updatePanel = true
	containermenu.Buttoned = false
end
hook.Add("Tick","Hackily keep the money counter up to date",function()
	if not (containermenu and containermenu.pInventory and containermenu.pInventory.inventory) then return end
	CheckPos()
	local m = LocalPlayer()._Money
	m = m > 0 and m or nil
	if containermenu.pInventory.inventory["money"] == m then return end
	containermenu.pInventory.inventory["money"] = m
	containermenu.pInventory.updatePanel = true
end)
local function NewContainer()
	local decoded = net.ReadTable()
	--[[
	local tab = {
		contents = {
			cider_usp45 = 2,
			chinese_takeout = -4, --There are four of these, but they can't be taken out
			money = 20000, -- Money is now an item for containers, so put the player's money in the inventory window. (It's not in there by default)
			boxed_pocket = 5
		},
		meta = {
			io = 3,
			filter = {
				money = true,
				weapon_crowbar = true
			}, -- Only these can be put in here, if nil then ignore, but empty means nothing.
			size = 40, -- Max space for the container
			entindex = 64, -- You'll probably want it for something
			name = "flib",
		}
	}
	--]]
	--[[
	decoded.meta.cantake = CAN_TAKE && decoded.meta.io == CAN_TAKE
	decoded.meta.canput  = CAN_PUT  && decoded.meta.io == CAN_PUT
	--]]
	if containermenu then containermenu:Remove() end
	containermenu = vgui.Create"cider_Container"
	gui.EnableScreenClicker(true);
	containermenu:MakePopup()
	UpdateContainer(decoded)
end
net.Receive( "cider_Container", NewContainer );
net.Receive( "cider_Container_Update", function()
	local decoded = net.ReadTable()
	UpdateContainer(decoded)
end)