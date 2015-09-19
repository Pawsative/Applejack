--[[
	~Big Boxed Pocket ~
	~ Applejack ~
--]]


ITEM.Name			= "Big Boxed Pocket";
ITEM.Size			= 2;
ITEM.Cost			= 50000;
ITEM.Model			= "models/props_junk/cardboard_box004a.mdl";
ITEM.Batch			= 5;
ITEM.Store			= true;
ITEM.Plural			= "Big Boxed Pockets";
ITEM.Becomes		= "big_pocket";
ITEM.Description	= "Open this box to reveal a big pocket.";
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