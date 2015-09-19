--[[
	~ Breach ~
	~ Applejack ~
--]]

ITEM.Name			= "Breach";
ITEM.Plural			= "Breaches";
ITEM.Size			= 2;
ITEM.Cost			= 3000;
ITEM.Model			= "models/weapons/w_c4_planted.mdl";
ITEM.Batch			= 10;
ITEM.Store			= true;
ITEM.Description	= "Will blow a door open if it is planted on one and destroyed.";
ITEM.Base			= "item";
ITEM.NoVehicles		= true;

function ITEM:onUse(ply)
	local trace	= ply:GetEyeTraceNoCursor();
	local door	= trace.Entity;
	if (not cider.entity.isDoor(door)) then
		ply:Notify("That is not a valid door!", 1);
	elseif (door:GetPos():Distance(ply:GetPos()) > 128) then	
		ply:Notify("You are not close enough to the door!", 1);
	elseif (door._Jammed or door._Sealed) then
		ply:Notify("This door cannot be breached!", 1);
	elseif (IsValid(door._Breach)) then	
		ply:Notify("This door already has a breach!", 1);
	else
		local ent = ents.Create("cider_breach");
		ent:Spawn();
		ent:SetDoor(door, trace, ply);
		door._Breach = ent;
		cider.propprotection.PlayerMakePropOwner(ply, ent, true);
		return true;
	end
	return false;
end
