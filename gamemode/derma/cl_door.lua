--[[
Name: "cl_door.lua".
	~ Applejack ~
--]]

cider.door = {};

-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetTitle("Door Menu");
	self:SetBackgroundBlur(true);
	self:SetDeleteOnClose(true);
	self:ShowCloseButton(false)

	-- Create the close button.
	self.close = vgui.Create("DButton", self);
	self.close:SetText("Close");
	self.close.DoClick = function()
		self:Close();
		self:Remove();

		-- Disable the screen clicker.
		gui.EnableScreenClicker(false);
	end

	-- Capture the position of the local player.
	self.localPlayerPosition = LocalPlayer():GetPos();

	-- Create the label panels.
	self.label = vgui.Create("DLabel", self);
	self.nameLabel = vgui.Create("DLabel", self);
	self.nameLabel:SetTextColor( Color(0, 0, 0, 255) );
	self.nameLabel:SetText("Name:");
	self.nameLabel:SizeToContents();
	local function purch()
		self:Close();
		self:Remove();

		-- Disable the screen clicker.
		gui.EnableScreenClicker(false);
		-- Check if the local player's position is different from our captured one.
		if ( LocalPlayer():GetPos() ~= self.localPlayerPosition or !LocalPlayer():Alive() ) then
			return
		end

		if (self.textEntry:GetValue() == "") then
			RunConsoleCommand("cider", "door", "purchase");
		else
			RunConsoleCommand( "cider", "door", "purchase", self.textEntry:GetValue() );
		end
	end

	-- Create the text entry panel.
	self.textEntry = vgui.Create("DTextEntry", self);
	self.textEntry.OnEnter = purch
	self.textEntry:RequestFocus()

	-- Create the purchase button.
	self.purchase = vgui.Create("DButton", self);
	self.purchase:SetText("Purchase");
	self.purchase.DoClick = purch
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
		local width = math.max( 112, self.label:GetWide() );
	self:SetSize(8 + width + 8, 28 + self.label:GetTall() + 8 + self.textEntry:GetTall() + 8 + self.purchase:GetTall() + 8);

	-- Set the visibility of the label.
	self.label:SetVisible(true);

	-- Set the position of the menu.
	self:SetPos(ScrW() / 2 - self:GetWide() / 2, ScrH() / 2 - self:GetTall() / 2);

	-- Set the size and position of the close button.
	self.close:SetSize(48, 16);
	self.close:SetPos(self:GetWide() - self.close:GetWide() - 4, 3);

	-- Set the position of the label and the purchase button.
	self.label:SetPos(8, 28);
	self.purchase:SetPos(8, 50);

	-- Set the position of the label, text entry, and button panels.
	self.nameLabel:SetPos(8, 28 + 10);
	self.textEntry:SetPos(8 + self.nameLabel:GetWide() + 8, 28 + 8);
	self.textEntry:SetSize(self:GetWide() - self.nameLabel:GetWide() - 24, 18);
	self.purchase:SetText("Purchase");

	-- Set the position of the label and text entry panels.
	self.nameLabel:SetPos(8, 28 + self.label:GetTall() + 8);
	self.textEntry:SetPos(8 + self.nameLabel:GetWide() + 8, 28 + self.label:GetTall() + 8);

	-- Set the position of the purchase button.
	self.purchase:SetPos(8, 28 + self.label:GetTall() + 8 + self.textEntry:GetTall() + 8);

	self.label:SetTextColor( Color(50, 255, 50, 255) );
	self.label:SetText("Purchase this door for $"..GM.Config["Door Cost"]..".");
	self.label:SizeToContents();

	-- Set the label and text entry panels to be visible.
	self.nameLabel:SetVisible(true);
	self.textEntry:SetVisible(true);

	-- Set the frame to size itself based on it's contents.
	self:SizeToContents();
	-- Check if the local player's position is different from our captured one.
	if ( LocalPlayer():GetPos() ~= self.localPlayerPosition or !LocalPlayer():Alive() ) then
		self:Close();
		self:Remove();

		-- Disable the screen clicker.
		gui.EnableScreenClicker(false);
	end

	-- Perform the layout of the main frame.
	DFrame.PerformLayout(self);
end

-- Register the panel.
vgui.Register("cider_Door", PANEL, "DFrame");


usermessage.Hook("cider_BuyDoor",function()

	-- Enable the screen clicker.
	gui.EnableScreenClicker(true);

	-- Check if the door panel already exists.
	if (cider.door.panel) then cider.door.panel:Remove(); end
	cider.door.panel = vgui.Create("cider_Door");
	cider.door.panel.unsellable = unsellable;
	cider.door.panel:MakePopup();
end)
