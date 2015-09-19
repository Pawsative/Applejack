--[[
	~ Item Metatable (serverside) ~
	~ Applejack ~
--]]
---
-- The serverside item metatable
-- @name meta
-- @class table
local meta = debug.getregistry().Item;
if (not meta) then
	ErrorNoHalt("Applejack: Error setting up serverside item metatable - Item metatable does not exist!");
	return
end

---
-- Cause the item to call it's OnUse function then remove 1* itself from the player's library.
-- @param ply The player who has clicked 'use' on an item
-- @return True for success, false for failure.
function meta:Use(ply)
	if (not self.onUse
	 or not (ply.cider._Inventory[self.UniqueID] and ply.cider._Inventory[self.UniqueID] > 0)
	 or self:onUse(ply) == false) then
		return false;
	end
	cider.inventory.update(ply, self.UniqueID, -1);
	GM:Log(EVENT_ITEM,"%s used a %s.",ply:Name(),self.Name);
	return true;
end

---
-- Cause the player to drop amt number of this item from their inventory as the specified position.
-- @param ply The player who is dropping the item
-- @param pos The position the items are to be dropped into
-- @param amt How many of the item to drop
function meta:Drop(ply, pos, amt)
	if (not self.onDrop
	 or not (ply.cider._Inventory[self.UniqueID] and ply.cider._Inventory[self.UniqueID] > 0)
	 or self:onDrop(ply, pos, amt) == false) then
		return false;
	end
	cider.inventory.update(ply, self.UniqueID, -amt);
	self:Make(pos, amt);
	if (amt == 1) then
		GM:Log(EVENT_ITEM,"%s dropped a %s.",ply:Name(),self.Name);
	else
		GM:Log(EVENT_ITEM,"%s dropped %i %s",ply:Name(),amt,self.Plural);
	end
end

local j,amt;
---
-- Delete every item the player has from their inventory.
-- @param ply The player whose inventory to delete the items from
-- @return True for success, false for failure.
function meta:Destroy(ply)
	amt = ply.cider._Inventory[self.UniqueID]
	if (not self.onDestroy
	 or not (amt and amt > 0)) then
		return false;
	end
	j = 0;
	if (self.RecursiveDestroy) then
		for i = 1, amt do
			if (self:onDestroy(ply) == false) then
				break;
			end
			j = j + 1;
			cider.inventory.update(ply, self.UniqueID, -1);
		end
	else
		j = amt;
		cider.inventory.update(ply, self.UniqueID, -amt);
	end
	if (j == 0) then
		return false;
	end
	local t = (j == amt and "%s destroyed all their %s.") or "%s destroyed some of their %s";
	GM:Log(EVENT_ITEM,t,ply:Name(),self.Plural);
	-- Return true because we did it successfully.
	return true;
end

local ent;
local up = Vector(0,0,16);
---
-- Makes a copy of the item at the specified pos and amount
-- @param pos The position to make the item
-- @param amt The amount of the item to make
-- @return The newly made item entity
function meta:Make(pos, amt)
	ent = ents.Create("cider_item");
	ent:SetItem(self, amt);
	ent:SetPos(pos + up);
	print(pos + up)
	ent:Spawn();
	return ent;
end

--TODO: Somehow have these done by the plugin not here, so implementations without the carmod don't get unneeded functions

local a,b,refund
---
-- Remove one of this item and give the player 1/2 the item's price (for cars)
-- @param ply The player from whose inventory to sell this item
-- @return True for success, false for failure.
function meta:Sell(ply)
	if (not self.onSell
	 or not (ply.cider._Inventory[self.UniqueID] and ply.cider._Inventory[self.UniqueID] > 0)
	 or self:onSell(ply) == false) then
		return false;
	end
	a,b = cider.inventory.update(ply, self.UniqueID, -1);
	GM:Log(EVENT_ITEM,"%s sold a %s.",ply:Name(),self.Name);
	refund = self.Refund or self.Cost / 2;
	ply:Notify("You got $"..refund.." for selling your "..self.Name.." secondhand", 0);
	ply:GiveMoney(refund);
	return true;
end

---
-- Call the 'onPickup' function of this item.
-- @param ply The player to pass to the function
-- @return True for success, false for failure.
function meta:Pickup(ply)
	if (not self.onPickup
	 or not (ply.cider._Inventory[self.UniqueID] and ply.cider._Inventory[self.UniqueID] > 0)
	 or self:onPickup(ply) == false) then
		return false;
	end
	return true;
end