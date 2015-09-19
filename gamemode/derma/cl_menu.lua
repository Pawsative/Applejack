--[[
Name: "cl_menu.lua".
	~ Applejack ~
--]]
--[[

] lua_run_cl PrintTable( file.Find( "../materials/gui/silkicons/*.vmt" ))
1	=	add.vmt
2	=	anchor.vmt
3	=	application.vmt
4	=	application_cascade.vmt
5	=	application_form_magnify.vmt
6	=	application_put.vmt
7	=	application_view_detail.vmt
8	=	application_view_tile.vmt
9	=	arrow_refresh.vmt
10	=	bomb.vmt
11	=	box.vmt
12	=	brick_add.vmt
13	=	car.vmt
14	=	check_off.vmt
15	=	check_on.vmt
16	=	check_on_s.vmt
17	=	emoticon_smile.vmt
18	=	exclamation.vmt
19	=	folder_go.vmt
20	=	group.vmt
21	=	heart.vmt
22	=	magnifier.vmt
23	=	page.vmt
24	=	page_white_find.vmt
25	=	page_white_magnify.vmt
26	=	page_white_wrench.vmt
27	=	palette.vmt
28	=	picture_edit.vmt
29	=	plugin.vmt
30	=	shield.vmt
31	=	sound.vmt
32	=	star.vmt
33	=	table_edit.vmt
34	=	user.vmt
35	=	world.vmt
36	=	wrench.vmt
37	=	application_xp_terminal.vmt
38	=	edgar.vmt
39	=	error.vmt
40	=	key.vmt
41	=	map.vmt
42	=	pill.vmt
43	=	sport_soccer.vmt
44	=	status_offline.vmt
45	=	thumb_down.vmt
46	=	newspaper.vmt
]]
cider.menu = {};
cider.menu.open = nil;
local width = 700
if ScrW() > width then
	cider.menu.width = width;
else
	cider.menu.width = ScrW()
end
cider.menu.height = ScrH()-40;

-- Define a new panel.
local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetTitle("Main Menu");
	self:SetBackgroundBlur(true);
	self:SetDeleteOnClose(false)
	self:ShowCloseButton(false)


	-- Create the close button.
	self.close = vgui.Create("DButton", self);
	self.close:SetText("Close");
	self.close:SetColor(color_white)
	self.close.Paint = function(self,w,h) draw.RoundedBox(0, 0, 0, w, h, Color(84, 84, 84)) end
	self.close.DoClick = function(self) cider.menu.toggle(); end
	
		--if not self:IsActive() then
			--cider.menu.toggle()
		--end
	-- Create the tabs property sheet.
	self.tabs = vgui.Create("DPropertySheet", self);

	-- Add the sheets for the other menus to the property sheet.
	self.tabs:AddSheet("Character", vgui.Create("cider_Character", self.tabs), "gui/silkicons/user");
	self.tabs:AddSheet("Help", vgui.Create("cider_Help", self.tabs), "gui/silkicons/page");
	self.tabs:AddSheet("Laws", vgui.Create("cider_Laws",self.tabs),"gui/silkicons/world");
	self.tabs:AddSheet("Rules", vgui.Create("cider_Rules", self.tabs), "gui/silkicons/exclamation");
	self.tabs:AddSheet("Inventory", vgui.Create("cider_Inventory", self.tabs), "gui/silkicons/application_view_tile");
	self.tabs:AddSheet("Store", vgui.Create("cider_Store", self.tabs), "gui/silkicons/box");
	self.tabs:AddSheet("Changelog",vgui.Create("cider_Changelog", self.tabs), "gui/silkicons/plugin");
	self.tabs:AddSheet("Donate", vgui.Create("cider_Donate", self.tabs), "gui/silkicons/heart");
	self.tabs:AddSheet("Credits",vgui.Create("cider_Credits",self.tabs), "gui/silkicons/group");
	--self.tabs:AddSheet("Log",vgui.Create("cider_Log",self.tabs), "gui/silkicons/page_white_magnify");
end

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	self:SetVisible(cider.menu.open);
	self:SetSize(cider.menu.width, cider.menu.height);
	self:SetPos(ScrW() / 2 - self:GetWide() / 2, ScrH() / 2 - self:GetTall() / 2);

	-- Set the size and position of the close button.
	self.close:SetSize(48, 16);
	self.close:SetPos(self:GetWide() - self.close:GetWide() - 4, 3);

	-- Stretch the tabs to the parent.
	self.tabs:StretchToParent(4, 28, 4, 4);

	-- Size To Contents.
	self:SizeToContents();

	-- Perform the layout of the main frame.
	DFrame.PerformLayout(self);
end

function PANEL:Paint(w,h)
draw.RoundedBox(0, 0, 0, w, h, Color(56, 56, 56))
end

-- Register the panel.
vgui.Register("cider_Menu", PANEL, "DFrame");

-- A function to toggle the menu.
function cider.menu.toggle(msg)
	if (GAMEMODE.playerInitialized) then
		cider.menu.open = !cider.menu.open;

		-- Toggle the screen clicker.
		gui.EnableScreenClicker(cider.menu.open);

		-- Check if the main menu exists.
		if (cider.menu.panel) then
			cider.menu.panel:SetVisible(cider.menu.open);
		else
			cider.menu.panel = vgui.Create("cider_Menu");
			cider.menu.panel:MakePopup();
		end
	end
end

-- Hook the usermessage to toggle the menu from the server.
usermessage.Hook("cider_Menu", cider.menu.toggle);