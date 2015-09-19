--[[
Name: "cl_inventory.lua".
	~ Applejack ~
--]]


cider.inventory 			= {};
cider.inventory.stored 		= {};
cider.inventory.updatePanel = true;

-- Hook into when the server sends the client an inventory item.
usermessage.Hook("cider_Inventory_Item", function(msg)
	local item = msg:ReadString();
	local amount = msg:ReadLong();
	
	-- Check to see if the amount is smaller than 1.
	if (amount < 1) then
		cider.inventory.stored[item] = nil;
	else
		cider.inventory.stored[item] = amount;
	end
	
	-- Tell the inventory panel that we should update.
	cider.inventory.updatePanel = true;
end);

-- Get the maximum amount of space a player has.
local item;
function cider.inventory.getMaximumSpace(inv,intial)
	local size = intial or GM.Config["Inventory Size"];
	inv = inv or cider.inventory.stored
	-- Loop through the player's inventory.
	for k, v in pairs(inv) do
		item = GM.Items[k];
		if (item and item.Size < 0) then
			size = size + (item.Size * -v);
		end
	end
	
	-- Return the size.
	return size;
end

-- Get the size of the local player's inventory.
function cider.inventory.getSize(inv)
	local size = 0;
	inv = inv or cider.inventory.stored
	-- Loop through the player's inventory.
	for k, v in pairs(inv) do
		item = GM.Items[k];
		if (item and item.Size > 0) then
			size = size + (item.Size * v);
		end
	end
	
	-- Return the size.
	return size;
end

-- Check if the local player can fit a specified size into their inventory.
function cider.inventory.canFit(size,inv)
	if ( cider.inventory.getSize(inv) + size > cider.inventory.getMaximumSpace(inv) ) then
		return false;
	else
		return true;
	end
end