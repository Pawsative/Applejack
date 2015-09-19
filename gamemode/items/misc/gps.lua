--[[
	~ GPS ~
	~ Applejack ~
--]]

ITEM.Name			= "GPS";
ITEM.Size			= 1;
ITEM.Cost			= 1000;
ITEM.Model			= "models/props_c17/consolebox05a.mdl";
ITEM.Batch			= 10;
ITEM.Store			= true;
ITEM.Plural			= "GPSes";
ITEM.Description	= "Helps you find things you own. (Like your car)";
ITEM.Base			= "item";

function ITEM:onUpdate(ply,number)
	ply._GPS	= number >= 1;
end
