--[[
	~ UMP ~
	~ Applejack ~
	~[
		Now really by all rights this should be cider_ump45.lua.
		However, when making this item I, (for some reason) just called it cider_ump,
		 so to avoid having to either change every entry in the DB or do a hacky
		 'replace when used' addon to the inventory loader, I'm leaving it like that.
		*SIGH*
	~]
--]]


ITEM.Name			= "UMP 45";
ITEM.Size			= 2;
ITEM.Cost			= 14000;
ITEM.Model			= "models/weapons/w_smg_ump45.mdl";
ITEM.Batch			= 10;
ITEM.Store			= true;
ITEM.Plural			= "UMP 45s";
ITEM.Description	= "A small sub-machine gun with a medium fire rate but high damage.";
ITEM.Ammo			= "smg1"
ITEM.WeaponType		= TYPE_LARGE;
ITEM.Base			= "weapon";
