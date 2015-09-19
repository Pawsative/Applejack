--[[
	~ Base contraband ~
	~ Applejack ~
--]]
ITEM.NoVehicles = true;
ITEM.Size		= 3;
local function checkcount(ply,self)
	if (ply:GetCount(self.UniqueID) == GM.Config.Contraband[self.UniqueID].maximum) then
		ply:Notify("You have reached the maximum "..self.Plural.."!", 1);
		return false;
	end
	return true;
end
local ent;
local function dospawn(self,ply,pos)
	ent = ents.Create(self.UniqueID);
	ent:SetPos(pos);
	ent._UniqueID = ply:UniqueID();
	ent:SetPlayer(ply);
	ent:Spawn();
	ply:AddCount(self.UniqueID, ent);
end
	
-- Called when a player drops the item.
function ITEM:onDrop(ply, pos)
	if (not checkcount(ply,self)) then return false end
	-- Spawn it ourselves
	dospawn(self, ply, pos);
	-- Remove the item from their inventory
	cider.inventory.update(ply, self.UniqueID, -1);
	-- Prevent the gamemode doing what it wants to
	return false;
end

-- Called when a player destroys the item
function ITEM:onDestroy() end

-- Called when a player attempts to manufacture an item.
function ITEM:canManufacture(ply)
	return checkcount(ply,self);
end

-- Called when a player manufactures an item.
local pos
function ITEM:onManufacture(ply,ent)
	pos = ent:GetPos();
	ent:Remove();
	dospawn(self,ply,pos);
end