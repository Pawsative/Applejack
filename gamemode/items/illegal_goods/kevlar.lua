--[[
Name: "sh_kevlar.lua".
	~ Applejack ~
--]]


ITEM.Name	= "Kevlar";
ITEM.Size	= 2;
ITEM.Cost	= 450;
--ITEM.Model	= "models/props_c17/suitcase_passenger_physics.mdl";
ITEM.Model	= "models/bloocobalt/clothes/combine_vest.mdl";
ITEM.Batch	= 10;
ITEM.Store	= true;
ITEM.Plural	= "Kevlars";
ITEM.Description	= "Reduces damage the player receives by 50%.";
ITEM.Equippable	= true
ITEM.Equipword	= "put on"
ITEM.Base	= "item"
-- Called when a player uses the item.
function ITEM:onUse(player)
	if (player._ScaleDamage ~= 1) then
		player:Notify("You are already wearing Kevlar!", 1);
		
		-- Return false because we cannot use the item.
		return false;
	else
		player._ScaleDamage	= 0.5;
	end
end
