--[[
	~ Rope ~
	~ Applejack ~
--]]


ITEM.Name			= "Spool of Rope";
ITEM.Size			= 1;
ITEM.Cost			= 200;
ITEM.Model			= "models/props_lab/pipesystem03d.mdl";
ITEM.Batch			= 10;
ITEM.Store			= true;
ITEM.Plural			= "Spools of Rope";
ITEM.Description	= "Can be used for tying people up"; --Tie dem bitches up like da hoes they are
ITEM.Base			= "item";

local function conditional(ply, victim, plypos, victimpos)
	return ply:IsValid() and victim:IsValid() and ply:GetPos() == plypos and victim:GetPos() == victimpos;
end
local function success(ply, victim)
	victim:TieUp();
	ply:Emote("completes the final loop and pulls the knot tight");
	victim._beTied = false;
	ply._Tying = false;
	gamemode.Call("PlayerTied", ply, victim);
end
local function failure(ply, victim)
	if (IsValid(victim)) then
		victim:Emote("breaks free and throws the rope to the floor.");
		GAMEMODE.Items["rope"]:Make(victim:GetPos());
		victim._beTied = false;
	end if (IsValid(ply)) then
		ply._Tying = false;
	end
end

-- TODO: Ballgag item
function ITEM:onUse(player)
	local trace	= player:GetEyeTraceNoCursor( );
	local target	= trace.Entity
	if ( IsValid(target._Player) ) then target	= target._Player; end
	if (not (IsValid(target) and target:IsPlayer() and player:GetPos():Distance(trace.HitPos) <= 128)) then
		player:Notify("You must look at a player to tie them up!",1)
		return false;
	end
	if (not hook.Call("PlayerCanTie",GAMEMODE, player, target)) then return false end
	player:Emote("grabs "..target:Name().."'s arms and starts tying them up.");
	player._Tying	= target;
	target._beTied	= player;
	local victim = target
	local plypos = player:GetPos()
	local victimpos = target:GetPos()

	timer.Simple(GM.Config["Tying Timeout"], function()
		if (ply:IsValid() and victim:IsValid() and ply:GetPos() == plypos and victim:GetPos() == victimpos) then
			success(ply, victim)
		end
	end)
end