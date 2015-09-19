--[[
	~ Health Vial ~
	~ Applejack ~
--]]


ITEM.Name			= "Health Vial";
ITEM.Size			= 1;
ITEM.Cost			= 100;
ITEM.Model			= "models/healthvial.mdl";
ITEM.Batch			= 10;
ITEM.Store			= true;
ITEM.Plural			= "Health Vials";
ITEM.Description	= "A health vial which restores 25 health.";
ITEM.Equippable		= true
ITEM.Equipword		= "heal yourself"
ITEM.Base			= "item"

function ITEM:onUse(player)
	if (player:Health() >= 100) then
		player:Notify("You do not need any more health!", 1);
		return false;
	end
	player:SetHealth( math.Clamp(player:Health() + 25, 0, 100) );
end