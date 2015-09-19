--[[
	~ Base npc ~
	~ Applejack ~
--]]
include("item.lua");
ITEM.NoVehicles = true;
local pos;
function ITEM:onUse(ply)
	pos = ply:GetEyeTraceNoCursor().HitPos;
	if (ply:GetPos():Distance(pos) > 255) then
		pos = ply:GetShootPos() + ply:GetAimVector() * 255;
	else
		pos.z = pos.z + 16;
	end
	local ent = ents.Create("npc_"..self.UniqueID);
	if (not ent) then
		error("Applejack: Could not create npc with id "..self.UniqueID);
	end
	ent:SetPos(pos);
	ent:Spawn();
	return true;
end