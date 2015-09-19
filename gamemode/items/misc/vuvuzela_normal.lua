--[[
	~ Knife ~
	~ Applejack ~
--]]


ITEM.Name			= "Vuvuzela";
ITEM.Size			= 1;
ITEM.Cost			= 1000;
ITEM.Model			= "models/vuvuzela.mdl";
ITEM.Batch			= 1;
ITEM.Store			= FALSE_FALSE_OH_A_HUNDED_TIMES_FALSE;--true;
ITEM.Plural			= "Vuvuzelas";
ITEM.Description	= "Celebrate the World Cup in style!";
ITEM.Base			= "weapon";
hook.Add("PlayerCanDrop", "Nononono", function (ply, class) if (class == "vuvuzela_normal") then return false end end);