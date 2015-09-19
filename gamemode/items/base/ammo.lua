--[[
	~ Base ammo ~
	~ Applejack ~
	~[
		This base provides items with the ability
		 to give the player ammo when used.
	~]
--]]
include("item.lua");
ITEM.Equippable		= true
ITEM.Equipword		= "load"
ITEM.Ammo			= {"",0};
function ITEM:onUse(ply)
	ply:GiveAmmo(self.Ammo[2],self.Ammo[1]);
end