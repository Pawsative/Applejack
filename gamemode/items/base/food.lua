--[[
	~ Base food ~
	~ Applejack ~
--]]
include("item.lua");
ITEM.Batch			= 5;
ITEM.Size			= 1;
ITEM.Hunger			= 0
ITEM.Equippable		= true
ITEM.Equipword		= "eat"
-- Called when a player drops the item.
function ITEM:onUse(ply)
	if (ply._Hunger.amount < 25) then
		ply:Notify("You do not need any more food!", 1);
		return false;
	end
	ply._Hunger.amount = math.max(ply._Hunger.amount - self.Hunger, 0);
end

