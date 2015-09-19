--[[
	~ Shared Init - Item ~
	~ Applejack ~
--]]

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.PrintName = "Item";
ENT.Author = "Lexi";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

function ENT:SetupDataTables()
	self:DTVar("Int",0,"amount");
end

function ENT:GetItem()
	return GAMEMODE.Items[self:GetNWString"item"];
end
