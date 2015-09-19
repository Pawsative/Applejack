--[[
Name: "sh_init.lua".
	~ Applejack ~
--]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Model = "models/props_c17/cashregister01a.mdl";
ENT.PrintName = "Contraband";
ENT.Author = "kuromeku";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "energy");
end
