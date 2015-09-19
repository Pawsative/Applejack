--[[
	~ Health Kit ~
	~ Applejack ~
--]]


ITEM.Name			= "Health Kit";
ITEM.Size			= 1;
ITEM.Cost			= 300;
ITEM.Model			= "models/items/healthkit.mdl";
ITEM.Batch			= 10;
ITEM.Store			= true;
ITEM.Plural			= "Health Kits";
ITEM.Description	= "A health kit which restores 50 health.";
ITEM.Equippable		= true
ITEM.Equipword		= "heal yourself"
ITEM.Base			= "item"

function ITEM:onUse(player)
	if (player:Health() >= 100) then
		player:Notify("You do not need any more health!", 1);
		return false;
	end
	player:SetHealth( math.Clamp(player:Health() + 50, 0, 100) );
end