--[[
	~ Chloroform ~
	~ Applejack ~
--]]


ITEM.Name			= "Chloroform";
ITEM.Plural			= "Chloroform";
ITEM.Size			= 1;
ITEM.Cost			= 1000;
ITEM.Model			= "models/props_junk/garbage_newspaper001a.mdl";
ITEM.Batch			= 10;
ITEM.Store			= true;
ITEM.Description	= "Can knockout players for a limited time.";
ITEM.Base			= "item"
ITEM.NoVehicles		= true;
-- Called when a player uses the item.
function ITEM:onUse(ply)
	local tr, victim;
	tr = ply:GetEyeTraceNoCursor();
	victim = tr.Entity;
	if (not (IsValid(victim) and victim:IsPlayer()
	and victim:Alive() and not victim:KnockedOut()
	and ply:GetShootPos():Distance(tr.HitPos) <= 80
	and math.abs(victim:GetAimVector():Angle().y - tr.Normal:Angle().y) < 35)) then
		ply:Notify("You must be right behind someone to chloroform them!", 1);
		return false;
	end
	ply:Emote("grabs " .. victim:Name() .. " from behind and shoves a dirty rag over "..victim._GenderWord.." mouth");
	victim:Emote("struggles a bit then slumps to the floor");
	victim._Sleeping = true;
	victim:KnockOut(victim._KnockOutTime);
	GM:Log(EVENT_EVENT, "%s just chloroformed %s.", ply:Name(), victim:Name());
	gamemode.Call("PlayerKnockedOut", victim, ply);
	return true
end