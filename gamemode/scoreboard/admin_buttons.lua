
local PANEL = {}

/*---------------------------------------------------------
   Name:
---------------------------------------------------------*/
function PANEL:Init()

	self:SetCursor( "hand" )

end

/*---------------------------------------------------------
   Name:
---------------------------------------------------------*/
function PANEL:DoClick( x, y )

	--if ( !self:GetParent().Player || LocalPlayer() == self:GetParent().Player ) then return end

	self:DoCommand( self:GetParent().Player )
	timer.Simple( 0.1, function()
		SCOREBOARD.UpdateScoreboard(SCOREBOARD )
	end)

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()

	local bgColor = Color( 0,0,0,10 )

	if ( self.Selected ) then
		bgColor = Color( 0, 200, 255, 255 )
	elseif ( self.Armed ) then
		bgColor = Color( 255, 255, 0, 255 )
	end

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), bgColor )

	draw.SimpleText( self.Text, "DefaultSmall", self:GetWide() / 2, self:GetTall() / 2, Color(0,0,0,150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	return true

end


vgui.Register( "SpawnMenuAdminButton", PANEL, "Button" )



/*   PlayerKickButton */

PANEL = {}
PANEL.Text = "Kick"

/*---------------------------------------------------------
   Name: DoCommand
---------------------------------------------------------*/
function PANEL:DoCommand( ply )

	RunConsoleCommand( "citrus", "kick", ply:UserID() )

end

vgui.Register( "PlayerKickButton", PANEL, "SpawnMenuAdminButton" )


/*   PlayerDemoteButton */

PANEL = {}
PANEL.Text = "Demote"

/*---------------------------------------------------------
   Name: DoCommand
---------------------------------------------------------*/
function PANEL:DoCommand( ply )
	local EditPanel = vgui.Create( "DFrame" )
	EditPanel:SetPos( (ScrW()- 50)/2,(ScrH() -38)/2 )
	EditPanel:SetSize( 100 ,76 )
	EditPanel:SetTitle( "Reason" )
	EditPanel:SetVisible( true )
	EditPanel:SetDraggable( true )
	EditPanel:ShowCloseButton( true )
	EditPanel:MakePopup()
--	y = 28
	local box = vgui.Create("DTextEntry",EditPanel)
	box:SetPos(10,28)
	box:SetSize(EditPanel:GetWide()-20,16)
	box.OnEnter = function()
		val = box:GetValue()
		if string.len(val) > 80 then
			val = string.sub(val,1,80)
		end
		if val == "" then return end
		RunConsoleCommand("cider", "demote",ply:UserID(),val);
		EditPanel:Close()
	end
	button = vgui.Create("DButton",EditPanel)
	button:SetText("Demote")
	button.DoClick = function()
		val = box:GetValue()
		if string.len(val) > 80 then
			val = string.sub(val,1,80)
		end
		if val == "" then return end
		RunConsoleCommand("cider", "demote",ply:UserID(),val.."\n");
		EditPanel:Close()
	end
	button:SetPos(EditPanel:GetWide()-button:GetWide()-10,46)
end

vgui.Register( "PlayerDemoteButton", PANEL, "SpawnMenuAdminButton" )

/*   PlayerPermBanButton */

PANEL = {}
PANEL.Text = "PermBan"

/*---------------------------------------------------------
   Name: DoCommand
---------------------------------------------------------*/
function PANEL:DoCommand( ply )

--	RunConsoleCommand( "banid2", "0", ply:UserID() )
--	RunConsoleCommand( "kickid2", ply:UserID(), "Permabanned" )
	RunConsoleCommand( "citrus", "ban", ply:UserID(),0 )

end

vgui.Register( "PlayerPermBanButton", PANEL, "SpawnMenuAdminButton" )



/*   Player1hBanButton */

PANEL = {}
PANEL.Text = "1hr Ban"

/*---------------------------------------------------------
   Name: DoCommand
---------------------------------------------------------*/
function PANEL:DoCommand( ply )

--	RunConsoleCommand( "banid2", "60", ply:UserID() )
--		RunConsoleCommand( "kickid2", ply:UserID(), "Banned for 1 hour" )
	RunConsoleCommand( "citrus", "ban", ply:UserID(),60 )
end

vgui.Register( "PlayerBanButton", PANEL, "SpawnMenuAdminButton" )


