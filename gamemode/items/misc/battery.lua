--[[
	~ Battery ~
	~ Applejack ~
--]]

ITEM.Name			= "Battery";
ITEM.Plural			= "Batteries";
ITEM.Size			= 2;
ITEM.Cost			= 100;
ITEM.Model			= "models/items/car_battery01.mdl";
ITEM.Batch			= 10;
ITEM.Store			= plugin;
ITEM.Description	= "Gives the player unlimited flashlight power.";
ITEM.Equippable		= true;
ITEM.Equipword		= "plug"
ITEM.Base			= "item"
if ((GM or GAMEMODE):GetPlugin("flashlight")) then
	-- Called when a player uses the item.
	function ITEM:onUse(ply)
		if (ply._Flashlight	== -1) then
			ply:Notify("You are already using a battery!", 1);
			return false;
		end
		ply._Flashlight	= -1;
	end
end