--[[
	~ Nitrazepam ~
	~ Applejack ~
--]]


ITEM.Name			= "Nitrazepam";
ITEM.Size			= 1;
ITEM.Cost			= 60;
ITEM.Model			= "models/props_c17/trappropeller_lever.mdl";
ITEM.Batch			= 10;
ITEM.Store			= true;
ITEM.Plural			= "Nitrazepam";
ITEM.Description	= "An injection which puts you to sleep instantly.";
ITEM.Equippable		= true
ITEM.Equipword		= "inject"
ITEM.Base			= "item"

function ITEM:onUse(player)
	player:Emote("unexpectedly collapses.");
	player:KnockOut();
	-- Set sleeping to true because we are now sleeping.
	player._Sleeping	= true;
end
