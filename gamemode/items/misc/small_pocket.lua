--[[
	~ Small Pocket ~
	~ Applejack ~
--]]


ITEM.Name				= "Small Pocket";
ITEM.Size				= -5;
ITEM.Model				= "models/props_junk/garbage_bag001a.mdl";
ITEM.Plural				= "Small Pockets";
ITEM.Description		= "A small pocket which allows you to hold more.";
ITEM.Becomes			= "boxed_pocket"
ITEM.RecursiveDestroy	= true

-- Called when a player drops the item.
function ITEM:onDrop(player, position, amount)
	if (cider.inventory.canFit(player,5 * amount)) then
		-- Remove the item from the player's inventory.
		local boxed = GM.Items[self.Becomes];
		if (amount == 1) then
			GM:Log(EVENT_ITEM, "%s dropped a %s.", player:Name(), boxed.Name);
		else
			GM:Log(EVENT_ITEM, "%s dropped %i %s", player:Name(), amount, boxed.Plural);
		end
		cider.inventory.update(player, self.UniqueID, -amount);
		boxed:Make(position, amount);
	else
		player:Notify("You cannot drop that, you will be overencumbered!", 1);
	end
	return false;
end

-- Called when a player destroys the item.
function ITEM:onDestroy(player)
	if (not cider.inventory.canFit(player,5)) then
		player:Notify("You cannot destroy that, you will be overencumbered!",1);
		return false;
	end
end