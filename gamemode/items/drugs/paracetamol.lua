--[[
	~ Paracetamol ~
	~ Applejack ~
--]]


ITEM.Name			= "Paracetamol";
ITEM.Size			= 1;
ITEM.Cost			= 100;
ITEM.Model			= "models/props_junk/garbage_metalcan002a.mdl";
ITEM.Batch			= 10;
ITEM.Store			= true;
ITEM.Plural			= "Paracetamol";
ITEM.Description	= "A small pill which unblurs vision when low on health.";
ITEM.Equippable		= true
ITEM.Equipword		= "pop"
ITEM.Base			= "item"

function ITEM:onUse(player)
	if (player:Health() >= 50) then
		player:Notify("You do not need any paracetamol!", 1);
		return false;
	end
	player._HideHealthEffects	= true;
end
