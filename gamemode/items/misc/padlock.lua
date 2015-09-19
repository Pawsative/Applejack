--[[
	~ Padlock ~
	~ Applejack ~
--]]


ITEM.Name			= "Padlock";
ITEM.Size			= 2;
ITEM.Cost			= 250;
ITEM.Model			= "models/props_wasteland/prison_padlock001a.mdl";
ITEM.Batch			= 10;
ITEM.Store			= true;
ITEM.Plural			= "Padlocks";
ITEM.Description	= "Will make a lock harder to pick.";
ITEM.Base			= "item"

function ITEM:onUse(ply)
	local trace	= ply:GetEyeTraceNoCursor();
	local door	= trace.Entity;
	if (not (IsValid(door) and cider.entity.isOwnable(door))) then
		ply:Notify("You can't put a padlock on that!", 1);
	elseif (door:GetPos():Distance(ply:GetPos()) > 128) then
		ply:Notify("You are not close enough to the door!", 1);
	elseif (door:GetNWBool("Padlocked")) then
		ply:Notify("That door already has a padlock!", 1);
	else
		local entity = ents.Create("cider_padlock");
		entity:Spawn();
		entity:SetDoor(door, trace, ply);
		cider.propprotection.PlayerMakePropOwner(ply,entity,true);
		local event	= "";
		local addon	= "";
		local entname	= door._eName or "entity";
		if (cider.entity.isOwned(door)) then
			event	= cider.entity.getPossessiveName(door);
		else
			event	= "an unowned";
		end
		if (cider.entity.isDoor(door)) then
			addon	= cider.entity.getDoorName(door);
			if (addon ~= "") then
				addon = ": "..addon;
			end
		else
			local name	= hook.Call("GetEntityName",GAMEMODE,door);
			if (name and name ~= "") then
				addon	= ": "..name;
			end
		end
		GM:Log(EVENT_EVENT, "%s put a padlock on %s %s%s.", ply:GetName(), event, entname, addon);
		return true;
	end
	return false;
end
