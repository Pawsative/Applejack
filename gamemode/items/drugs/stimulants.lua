--[[
	~ Stimulants ~
	~ Applejack ~
--]]


ITEM.Name			= "Stimulants";
ITEM.Size			= 1;
ITEM.Cost			= 60;
ITEM.Model			= "models/props_c17/trappropeller_lever.mdl";
ITEM.Batch			= 10;
ITEM.Store			= true;
ITEM.Plural			= "Stimulants";
ITEM.Description	= "An injection which wakes someone up instantly.";
ITEM.Base			= "item"

local function yell(ply,text)
	cider.chatBox.addInRadius(ply, "yell", text, ply:GetPos(), GM.Config["Talk Radius"] * 2);
end

function ITEM:onUse(ply)
	local trace	= ply:GetEyeTraceNoCursor( );
	local target	= trace.Entity
	if ( IsValid(target._Player) ) then target	= target._Player; end
	if (not (IsValid(target) and target:IsPlayer() and ply:GetPos():Distance(trace.HitPos) <= 128 and target:Alive())) then
		ply:Notify("You must look at a player to stimulate them!",1)
		return false;
	end
	ply:Emote("stabs "..target:Name().." in the arm with a needle.");
	if (target:KnockedOut()) then
		target:WakeUp();
		target:Emote("jumps to their feet in screaming.");
		yell(target, "AAAAAAAAAAH! OH GOD IT BURNSSSS!")
		gamemode.Call("PlayerWokenUp", target, ply);
	else
		target:Emote("jerks in shock and screams");
		yell(target, "OH JESUS YOU STABBED ME IN THE ARM AAAAH! IT BURNSSSSS");
	end
end
