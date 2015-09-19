--[[
	~ Boxed Pocket ~
	~ Applejack ~
--]]


ITEM.Name			= "Boxed Pocket";
ITEM.Size			= 2;
ITEM.Cost			= 5000;
ITEM.Model			= "models/props_junk/cardboard_box004a.mdl";
ITEM.Batch			= 10;
ITEM.Store			= true;
ITEM.Plural			= "Boxed Pockets";
ITEM.Becomes		= "small_pocket";
ITEM.Description	= "Open this box to reveal a small pocket.";
ITEM.Max			= 100;
ITEM.Equippable		= true;
ITEM.Equipword		= "open";
ITEM.Base			= "item";

function ITEM:onUse(ply)
	if ((ply.cider._Inventory[self.Becomes] or 0) >= self.Max) then
		ply:Notify("You've hit the pockets limit!", 1);
		return false;
	end
	cider.inventory.update(ply, self.Becomes, 1);
end
