--[[
	Door Stool v2
	Originally by High6
	Rewritten by Lexi
--]]

local GM = GAMEMODE;

-- Set up our convars
TOOL.ClientConVar[ "class" ] = "prop_dynamic"
TOOL.ClientConVar[ "model" ] = "models/props_combine/combine_door01.mdl"
TOOL.ClientConVar[ "autolock" ] = "1"
TOOL.ClientConVar[ "closetime" ] = "5"
TOOL.ClientConVar[ "hardware" ] = "1"
cleanup.Register( "door" )

-- Tool Infos
TOOL.Category		= "Construction"	// Name of the category
TOOL.Name			= "#Door V2"		// Name to display

if (SERVER) then
	if ( not ConVarExists("sbox_maxdoors") ) then
		CreateConVar("sbox_maxdoors", GM.Config["Maximum Doors"], {FCVAR_NOTIFY;FCVAR_REPLICATED} );
	else
		RunConsoleCommand("sbox_maxdoors", GM.Config["Maximum Doors"]);
	end
else
	language.Add( "Tool_door_name", "Door STool V2" )
	language.Add( "Tool_door_desc", "Spawn a Door" )
	language.Add( "Tool_door_0", "Click somewhere to spawn a door. This will cost $"..GM.Config["Door Cost"] )

	language.Add( "Undone_door", "Undone door" )
	language.Add( "Cleanup_door", "door" )
	language.Add( "SBoxLimit_doors", "You cannot spawn any more doors!" )
	language.Add( "Cleaned_door", "Cleaned up all doors" )

end


function TOOL:LeftClick(tr)
	if ( CLIENT ) then
		return true;
	elseif ( not self:GetSWEP():CheckLimit( "doors" ) ) then
		return false;
	end
	local class = self:GetClientInfo( "class" );
	if (class ~= "prop_dynamic" and class ~= "prop_door_rotating") then
		return false;
	end
	local model = self:GetClientInfo( "model" );
	if (not util.IsValidModel(model) ) then
		return false;
	end
	local ply = self:GetOwner();
	local ent = ents.Create(class);
	ent:SetModel(model);
	local ang = ply:GetAimVector():Angle()
	local minn = ent:OBBMins()
	tr.HitPos.Z = tr.HitPos.Z - (tr.HitNormal.z * minn.z);
	ent:SetPos( tr.HitPos )
	ent:SetAngles(Angle(0,ang.Yaw + 180,0))
	if (class == "prop_dynamic") then
		ent:SetKeyValue("solid",6);
		ent:SetKeyValue("MinAnimTime",	1);
		ent:SetKeyValue("MaxAnimTime",	5);
	else
		ent:SetKeyValue("hardware",		self:GetClientNumber("hardware"));
		ent:SetKeyValue("distance",		90);
		ent:SetKeyValue("speed",		100);
		ent:SetKeyValue("returndelay",	-1);
		ent:SetKeyValue("spawnflags",	8192); //"Use closes"
		ent:SetKeyValue("forceclosed",	0);
	end
	ent._Removeable = true;
	ent._State = "closed";
	ent:Spawn();
	ent:Activate();
	ent._Autoclose = math.max(self:GetClientNumber("closetime"),5);
	cider.entity.makeOwnable(ent);
	timer.Simple(0,function()
		ply:GiveDoor(ent,ply:GetName().."'s door",true);
		ent:Lock();
	end);
	ply:GiveMoney(-GM.Config["Door Cost"]);
	ply:Notify("You bought a door for $"..GM.Config["Door Cost"]..".", 0);
	ply:AddCleanup("doors", ent );
	undo.Create("Door");
	undo.AddEntity( ent );
	undo.AddFunction(function(undo)
		if IsValid(undo.Entities[1]) then
			undo.Owner:Notify("You got $"..GM.Config["Door Cost"]/2 .." for selling your door.",0);
			undo.Owner:TakeDoor(undo.Entities[1]);
			return true;
		end
	end);
	undo.SetPlayer( ply );
	undo.Finish();
	return true
end

function TOOL.BuildCPanel( CPanel )

	// HEADER
	CPanel:AddControl( "Header", { Text = "#Tool_door_name", Description	= "#Tool_door_desc" }  )

	// PRESETS
	local params = { Label = "#Presets", MenuButton = 1, Folder = "door", Options = {}, CVars = {} }

		params.Options.default = {
			door_model = "models/props_combine/combine_door01.mdl",
			door_open	= 1,
			door_close	= 2 }

		table.insert( params.CVars, "door_open" )
		table.insert( params.CVars, "door_close" )
		table.insert( params.CVars, "door_model" )

	CPanel:AddControl( "ComboBox", params )


	// EMITTERS
	local params = { Label = "#Models", --[[Height = 150,]]MenuButton = 0, Options = {} }
	params.Options[ "Tall Combine Door" ] = { door_class = "prop_dynamic",	door_model = "models/props_combine/combine_door01.mdl" }
	params.Options[ "Lab Elevator Door" ] = { door_class = "prop_dynamic",	door_model = "models/props_lab/elevatordoor.mdl" }
	params.Options[ "Wide Combine Door" ] = { door_class = "prop_dynamic",	door_model = "models/combine_gate_Vehicle.mdl" }
	params.Options[ "Thin Combine Door" ] = { door_class = "prop_dynamic",	door_model = "models/combine_gate_citizen.mdl" }
	params.Options[ "Secret Lab Door"   ] = { door_class = "prop_dynamic",	door_model = "models/props_doors/doorKLab01.mdl" }
	params.Options[ "Door with a handle"] = { door_hardware = "1",			door_class = "prop_door_rotating",door_model = "models/props_c17/door01_left.mdl" }
	params.Options[ "Door with a bar"   ] = { door_hardware = "2",			door_class = "prop_door_rotating",door_model = "models/props_c17/door01_left.mdl" }
	CPanel:AddControl( "ComboBox", params )
	CPanel:AddControl( "Slider",  { Label	= "#AutoClose Delay",
								Type	= "Float",
								Min		= 5,
								Max		= 120,
								Command = "door_closetime" }	 )
end

-- This is here because the ghost should match the spawnpos, and we spawn funky.
function TOOL:UpdateGhost( ent, Player )

	if ( !ent ) then return end
	if ( !ent:IsValid() ) then return end

	local tr 	= utilx.GetPlayerTrace( Player, Player:GetCursorAimVector() )
	local trace 	= util.TraceLine( tr )
	if (!trace.Hit) then return end
	local ang = Player:GetAimVector():Angle()
	local minn = ent:OBBMins()
	trace.HitPos.Z = trace.HitPos.Z - (trace.HitNormal.z * minn.z)
	ent:SetPos( trace.HitPos )
	ent:SetAngles(Angle(0,ang.Yaw+180,0))

end

-- This is in here so we can have all doors ghosted.
function TOOL:MakeGhostEntity( model, pos, angle )

	if (!util.IsValidModel(model)) then return end
	util.PrecacheModel( model )

	// We do ghosting serverside in single player
	// It's done clientside in multiplayer
	if (SERVER && !game.SinglePlayer()) then return end
	if (CLIENT && game.SinglePlayer()) then return end

	// Release the old ghost entity
	self:ReleaseGhostEntity()

	self.GhostEntity = ents.Create( "prop_physics" )

	// If there's too many entities we might not spawn..
	if (!self.GhostEntity:IsValid()) then
		self.GhostEntity = nil
		return
	end

	self.GhostEntity:SetModel( model )
	self.GhostEntity:SetPos( pos )
	self.GhostEntity:SetAngles( angle )
	self.GhostEntity:Spawn()

	self.GhostEntity:SetSolid( SOLID_VPHYSICS );
	self.GhostEntity:SetMoveType( MOVETYPE_NONE )
	self.GhostEntity:SetNotSolid( true );
	self.GhostEntity:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.GhostEntity:SetColor( 255, 255, 255, 150 )

end

function TOOL:Think()

	if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != self:GetClientInfo( "model" )) then
		self:MakeGhostEntity( self:GetClientInfo( "model" ), Vector(0,0,0), Angle(0,0,0) )
	end

	self:UpdateGhost( self.GhostEntity, self:GetOwner() )

end
