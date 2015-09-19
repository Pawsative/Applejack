--[[
	~ Steroids ~
	~ Applejack ~
--]]

ITEM.Name			= "Steroids";
ITEM.Size			= 1;
ITEM.Cost			= 100;
ITEM.Model			= "models/items/battery.mdl";
ITEM.Batch			= 10;
ITEM.Plural			= "Steroids";
ITEM.Description	= "Small pills which restore 50 stamina, with side effects";
ITEM.Equippable		= true;
ITEM.Equipword		= "pop";
ITEM.Base			= "item";

if (GM:GetPlugin("stamina")) then
	ITEM.Store		= true;
	function ITEM:onUse(player)
		if (player._Stamina >= 100) then
			player:Notify("You do not need any steroids!", 1);
			return false;
		end
		player._Stamina	= math.min(player._Stamina + 50,100)
		player:TakeDamage(10)
	end
end