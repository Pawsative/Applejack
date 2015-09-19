
include( "player_infocard.lua" )

surface.CreateFont("ScoreboardPlayerName", {font="coolvetica", size=19, weight=500})
surface.CreateFont("ScoreboardPlayerNameBig", {font="coolvetica", size=22, weight=500})

local texGradient = surface.GetTextureID( "gui/center_gradient" )
local PANEL = {}

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()
local lpl = LocalPlayer()

	self.Size = 36
	self:OpenInfo( false )
	
	self.infoCard	= vgui.Create( "ScorePlayerInfoCard", self )
	
	self.lblName 	= vgui.Create( "DLabel", self )
	--self.lblTime 	= vgui.Create( "DLabel", self )
	--self.lblPoints 	= vgui.Create( "DLabel", self )
	self.lblFrags 	= vgui.Create( "DLabel", self )
	self.lblDeaths 	= vgui.Create( "DLabel", self )
	self.lblPing 	= vgui.Create( "DLabel", self )
	
	// If you don't do this it'll block your clicks
	self.lblName:SetMouseInputEnabled( true )
	--self.lblTime:SetMouseInputEnabled( false )
	--self.lblPoints:SetMouseInputEnabled( false )
	self.lblFrags:SetMouseInputEnabled( false )
	self.lblDeaths:SetMouseInputEnabled( false )
	self.lblPing:SetMouseInputEnabled( false )
	
	self.imgAvatar = vgui.Create( "AvatarImage", self )
	
	
	self:SetCursor( "none" )

end;


/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()

	if ( !IsValid( self.Player ) ) then return end;
	
	local color = team.GetColor( self.Player:Team() )

	if ( self.Open || self.Size != self.TargetSize ) then
	
		draw.RoundedBox( 4, 0, 16, self:GetWide(), self:GetTall() - 16, color )
		draw.RoundedBox( 4, 2, 16, self:GetWide()-4, self:GetTall() - 16 - 2, Color( 250, 250, 245, 255 ) )
		
		surface.SetTexture( texGradient )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( 2, 16, self:GetWide()-4, self:GetTall() - 16 - 2 ) 
	
	end;
	
	draw.RoundedBox( 4, 0, 0, self:GetWide(), 36, color )
	
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 0, 0, self:GetWide(), 36 ) 
	
	// This should be an image panel!
	surface.SetMaterial( self.texRating )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( self:GetWide() - 16 - 8, 36 / 2 - 8, 16, 16 ) 	
	
	return true

end;

/*---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------*/
function PANEL:SetPlayer( ply )

	self.Player = ply
	
	self.infoCard:SetPlayer( ply )
	
	if (ply:GetNWBool("_Undercover")) then
		self.imgAvatar:SetPlayer(nil)
	else
		self.imgAvatar:SetPlayer( ply )
	end
	
	self:UpdatePlayerData()

end;


local function formatTime(s)
	local res

	if (s > 3600) then
		res = math.Round(s / 3600)
		return res .. "h"
		
	elseif (s > 60) then
		res = math.Round(s / 60)
		return res .. "m"
	
	else
		return s .. "s"
	end
end

/*---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------*/
function PANEL:UpdatePlayerData()

	if ( !self.Player ) then return end;
	if ( !self.Player:IsValid() ) then return end;

	self.lblName:SetText( "["..self.Player:GetNetworkedString("Job").."] "..self.Player:Nick() .. " (" .. self.Player:GetNWString("RPName") .. ") [" .. self.Player:UserID() .. "]")
	self.lblName:SizeToContents()
	self.lblFrags:SetText( self.Player:Frags() )
	self.lblDeaths:SetText( self.Player:Deaths() )
	self.lblPing:SetText( self.Player:Ping() )
	--self.lblPoints:SetText( self.Player:GetNWInt("RPPoints") or 0)
	--self.lblTime:SetText( formatTime(self.Player:GetNWInt("cider_PlayTime") or 0))
	
	// Work out what icon to draw
	if (self.Player:IsSuperAdmin()) then
		self.texRating = Material("icon16/shield.png")
	elseif (self.Player:IsUserGroup("moderator")) then
		self.texRating = Material("icon16/emoticon_smile.png")
	elseif (self.Player:IsAdmin()) then
		self.texRating = Material("icon16/star.png")
	
	elseif ( self.Player:IsUserGroup( "developer" ) ) then
		self.texRating = Material("icon16/wrench.png")
	elseif (!self.Player:IsSuperAdmin() and !self.Player:IsAdmin() and self.Player:GetNetworkedBool("cider_Donator")) then
		self.texRating = Material("icon16/heart.png")
	else
		self.texRating = Material("icon16/user.png")
	end;

	if (self.Player:GetNWBool("_Undercover") && !self.Player:GetNWBool("_Undercover.DisplayIcon")) then
		self.texRating = Material("icon16/user.png")
	end
end;



/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:ApplySchemeSettings()

	self.lblName:SetFont( "ScoreboardPlayerNameBig" )
	self.lblFrags:SetFont( "ScoreboardPlayerName" )
	self.lblDeaths:SetFont( "ScoreboardPlayerName" )
	self.lblPing:SetFont( "ScoreboardPlayerName" )
	--self.lblPoints:SetFont( "ScoreboardPlayerName" )
	--self.lblTime:SetFont( "ScoreboardPlayerName" )
	
	self.lblName:SetFGColor( color_white )
	self.lblFrags:SetFGColor( color_white )
	self.lblDeaths:SetFGColor( color_white )
	self.lblPing:SetFGColor( color_white )
--	self.lblPoints:SetFGColor( color_white )
--	self.lblTime:SetFGColor( color_white )

end;

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:OpenInfo( bool )

	if ( bool ) then
		self.TargetSize = 150
	else
		self.TargetSize = 36
	end;
	
	self.Open = bool

end;

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:Think()

	if ( self.Size != self.TargetSize ) then
	
		self.Size = math.Approach( self.Size, self.TargetSize, (math.abs( self.Size - self.TargetSize ) + 1) * 10 * FrameTime() )
		self:PerformLayout()
		SCOREBOARD:InvalidateLayout()
	//	self:GetParent():InvalidateLayout()
	
	end;
	
	if ( !self.PlayerUpdate || self.PlayerUpdate < CurTime() ) then
	
		self.PlayerUpdate = CurTime() + 0.5
		self:UpdatePlayerData()
		
	end;

end;

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self.imgAvatar:SetPos( 2, 2 )
	self.imgAvatar:SetSize( 32, 32 )

	self:SetSize( self:GetWide(), self.Size )
	
	self.lblName:SizeToContents()
	self.lblName:SetPos( 24, 2 )
	self.lblName:MoveRightOf( self.imgAvatar, 8 )
	
	local COLUMN_SIZE = 50
	
	self.lblPing:SetPos( self:GetWide() - COLUMN_SIZE * 1, 3 )
	self.lblDeaths:SetPos( self:GetWide() - COLUMN_SIZE * 2, 3 )
	self.lblFrags:SetPos( self:GetWide() - COLUMN_SIZE * 3, 3 )
	--self.lblPoints:SetPos( self:GetWide() - COLUMN_SIZE * 4, 3 )
	--self.lblTime:SetPos( self:GetWide() - COLUMN_SIZE * 5, 3 )
	
	if ( self.Open || self.Size != self.TargetSize ) then
	
		self.infoCard:SetVisible( true )
		self.infoCard:SetPos( 4, self.imgAvatar:GetTall() + 10 )
		self.infoCard:SetSize( self:GetWide() - 8, self:GetTall() - self.lblName:GetTall() - 10 )
	
	else
	
		self.infoCard:SetVisible( false )
	
	end;
	
	

end;

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:HigherOrLower( row )

	return self.Player:Team() < row.Player:Team()

end;


vgui.Register( "ScorePlayerRow", PANEL, "Button" )