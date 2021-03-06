--[[
	~ Serverside Player Hooks ~
	~ Applejack ~
--]]
---
-- @name GM
-- @class table
-- @description The gamemode table. In this case, the serverside player hooks section of it. This is a reference of every hook that could be called on the player only on the server that the gamemode deals with.
local GM = GM;

---
-- Called when a player's warrant timer ends.
-- @param ply The player whose warrant just expired
-- @param class The class of warrant. 'arrest' or 'search'.
function GM:PlayerWarrantExpired(player, class)
	-- We don't care
end

---
-- Called when a player demotes another player from a team.
-- @param ply The player that did the demoting
-- @param victim The player that got demoted
-- @param teamID The ID of the team the victim got demoted from
-- @param reason The reason the player demoted the victim.
function GM:PlayerDemote(ply, victim, teamID, reason)
end

---
-- Called to check if a player can blacklist another player from something
-- @param ply The admin who wants to do the blacklisting
-- @param victim The player the admin wants to blacklist
-- @param kind What kind of activity. Can be one of "cat","item","cmd" or "team". In order: Item category, specific item, command or specific team/job.
-- @param thing What specific activity. For instance if the kind was 'cmd', the thing could be 'unblacklist'.
-- @param time How long in seconds admin wants to blacklist them for.
-- @param reason Why the admin wants to blacklist them
-- @return true if they can, false if they can't.
function GM:PlayerCanBlacklist(ply, victim, kind, thing, time, reason)
	return true; -- There's no actal reason why not.
end

---
-- Called to check if a player can removing an existing blacklist before the timer expires.
-- @param ply The admin who wants to do the unblacklisting
-- @param target The player the admin wants to unblacklist
-- @param kind What kind of activity. Can be one of "cat","item","cmd" or "team". In order: Item category, specific item, command or specific team/job.
-- @param thing What specific activity. For instance if the kind was 'cmd', the thing could be 'unblacklist'.
-- @return true if they can, false if they can't.
function GM:PlayerCanUnBlacklist(ply, target, kind, thing)
	return true; -- There's no actal reason why not.
end

---
-- Called when a player has been blacklisted from something
-- @param ply The player that has been blacklisted
-- @param kind What kind of activity. Can be one of "cat","item","cmd" or "team". In order: Item category, specific item, command or specific team/job.
-- @param thing What specific activity. For instance if the kind was 'cmd', the thing could be 'unblacklist'.
-- @param time How long in seconds they have been blacklisted for
-- @param reason Why they have been blacklisted.
-- @param blacklister The admin who blacklisted them.
function GM:PlayerBlacklisted(ply, kind, thing, time, reason, blacklister)
	-- If they've been blacklisted from their current team, demote them.
	if (kind == "team" and ply:Team() == thing) then
		ply:Demote();
	elseif (kind == "cat" and thing == CATEGORY_WEAPONS) then -- If they've been blacklisted from using weapons category, blacklist them from every other one too.
		ply:HolsterAll();
		ply:Blacklist(kind, CATEGORY_ILLEGAL_WEAPONS, time, reason, blacklister:Name());
		ply:Blacklist(kind, CATEGORY_POLICE_WEAPONS, time, reason, blacklister:Name());
	end
end

---
-- Called when a player has been unblacklisted from something
-- @param ply The player that has been unblacklisted
-- @param kind What kind of activity. Can be one of "cat","item","cmd" or "team". In order: Item category, specific item, command or specific team/job.
-- @param thing What specific activity. For instance if the kind was 'cmd', the thing could be 'unblacklist'.
-- @param unblacklister The admin who unblacklisted them.
function GM:PlayerUnBlacklisted(ply, kind, thing, unblacklister)
	if (kind == "cat" and thing == CATEGORY_WEAPONS) then -- If they've been unblacklisted from using weapons category, we need to unblacklist them from every other one too.
		ply:UnBlacklist(kind, CATEGORY_ILLEGAL_WEAPONS);
		ply:UnBlacklist(kind, CATEGORY_POLICE_WEAPONS );
	end
end

---
-- Called when a player knocks out another player (tranq/baton/chloroform etc)
-- @param ply The player that did the knocking
-- @param victim The player that got knocked.
function GM:PlayerKnockOut(ply, victim)
end

---
-- Called when a player wakes up another player (stims/baton etc)
-- @param ply The player that did the waking up
-- @param victim The player that got woke up
function GM:PlayerWakeUp(ply, victim)
end

---
-- Called when a player arrests another player.
-- @param ply The player that did it
-- @param victim The player that it was done to
function GM:PlayerArrest(ply, victim) end

---
-- Called when a player unarrests another player.
-- @param ply The player that did it
-- @param victim The player that it was done to
function GM:PlayerUnarrest(ply, victim) end

---
-- Called when a player warrants another player.
-- @param ply The player that did it
-- @param victim The player that it was done to
function GM:PlayerWarrant(ply, victim, class) end

---
-- Called when a player unwarrants another player.
-- @param ply The player that did it
-- @param victim The player that it was done to
function GM:PlayerUnwarrant(ply, victim) end

---
-- Called when a player ties up another player.
-- @param ply The player that did it
-- @param victim The player that it was done to
function GM:PlayerTied(ply, victim) end

---
-- Called when a player unties another player.
-- @param ply The player that did it
-- @param victim The player that it was done to
function GM:PlayerUnTied(ply, victim) end

---
-- Called when a player tries to tie another player up
-- @param ply The player trying to do the tying
-- @param target The player the attempted tie is apon
-- @return true if they can, false if they can't.
function GM:PlayerCanTie(ply, target)
	if (not target:Alive() or target:Tied() or target._beTied or target:Arrested()) then
		return false;
	end
	return gamemode.Call("PlayerCanDoSomething", ply);
end

---
-- Called when a player tries to untie another player
-- @param ply The player trying to do the untying
-- @param target The player the attempted untie is apon
-- @return true if they can, false if they can't.
function GM:PlayerCanUntie(ply, target)
	if (target:Tied() and not target._beUnTied) then
		return gamemode.Call("PlayerCanDoSomething", ply);
	end
	return false
end

---
-- Called when a player attempts to own a door.
-- @param ply The player trying to do the buying
-- @param door The door the player wants to buy
-- @return true if they can, false if they can't.
function GM:PlayerCanOwnDoor(ply, door)
	return door._isDoor and not( door._Sealed or cider.entity.isOwned(door))
end
---
-- Called when a player attempts to view an ent's access data.
-- @param ply The player trying to do the viewing
-- @param ent The ent the player is trying to view
-- @return true if they can, false if they can't.
function GM:PlayerCanViewEnt(ply, ent)
	return cider.entity.hasAccess(ent, ply);
end
---
-- Caled when a player attempts to set the name of an ent
-- @param ply The player trying to do the setting
-- @param ent The entity the player is trying to set on
-- @return True if they can, false if they can't.
function GM:PlayerCanSetEntName(ply, ent, name)
	return ent._isDoor --and name and name ~= "" and not name:find("Sale"));
end

---
-- Called when a player tries to jam a door
-- @param ply The player in question
-- @param door The door in question
-- @return True if they can, false if they can't.
function GM:PlayerCanJamDoor(ply, door)
	return tobool(string.find(door:GetClass(),"func_door"));
end

---
-- Called when a player attempts to holster a weapon.
-- @param ply The player in question
-- @param class The weapon class
-- @param silent Wether to be quiet about it or not
-- @return True if they can, false if they can't.
function GM:PlayerCanHolster(ply, class, silent)
	if (ply._SpawnWeapons[ class] or ply._Equipping) then
		if (not silent) then
			ply:Notify("You cannot holster this weapon!", 1);
		end
		return false;
	end
	return true;
end

---
-- Called when a player attempts to drop a weapon.
-- @param ply The player in question
-- @param class The weapon class
-- @param silent Wether to be quiet about it or not
-- @return True if they can, false if they can't.
function GM:PlayerCanDrop(ply, class, silent)
	do return false; end
	if (ply._SpawnWeapons[class]) then
		if (not silent) then
			ply:Notify("You cannot holster this weapon!", 1);
		end
		return false;
	end
	return true;
end

---
-- Called when a player attempts to use an item.
-- @param ply The player in question
-- @param id The UniqueID of the item
-- @return True if they can, false if they can't.
function GM:PlayerCanUseItem(ply, id)
	item = self.Items[id];
	if (not item) then return false; end
	if (item.Category) then
		local cat = item.Category;
		if (table.HasValue( cider.team.query( ply:Team(), "cantuse", {}), cat)) then -- Is it set that our team can't use this category? (ie police can't use illegals)
			ply:Notify(cider.team.query(ply:Team(),"name","Your team's member").."s cannot use "..self:GetCategory(cat).Name.."!", 1);
			return false;
		elseif (ply:Blacklisted("cat", cat) > 0) then -- Are we blacklisted from this category?
			ply:BlacklistAlert("cat",cat,self:GetCategory(cat).Name);
			return false;
		end
	end
	if (ply:Blacklisted("item", item.UniqueID) > 0) then -- Are we blacklisted from this specific item?
		ply:BlacklistAlert("item",item.UniqueID,item.Plural);
		return false;
	end
	--[ [ TODO: Why is this needed? I don't think it is tbh
	if ( ply._SpawnWeapons[item.UniqueID] ) then -- Did we spawn with this weapon?
		if (not silent) then ply:Notify("You cannot use this weapon!", 1) end
		return false
	end
	--]]
	return true;
end

---
-- Called when a plyer attempts to stun another player
-- @param ply The player in question
-- @param target The player's intended victim
-- @return True if they can, false if they can't.
function GM:PlayerCanStun(ply, target)
	return true
end

---
-- Called when a player attempts to knock out a player.
-- @param ply The player in question
-- @param target The player's intended victim
-- @return True if they can, false if they can't.
function GM:PlayerCanKnockOut(ply, target)
	return true
end

---
-- Called when a player attempts to warrant a player.
-- @param ply The player in question
-- @param target The player's intended victim
-- @return True if they can, false if they can't.
function GM:PlayerCanWarrant(ply, target)
	return true
end

---
-- Called when a player attempts to wake up another player.
-- @param target The player's intended victim
-- @param ply The player in question
-- @return True if they can, false if they can't.
function GM:PlayerCanWakeUp(ply, target)
	return true
end

---
-- Called when a player attempts to destroy contraband.
-- @param ply The player in question
-- @param ent The contraband the player wants to destroy
-- @return True if they can, false if they can't.
function GM:PlayerCanDestroyContraband(ply, ent)
	return true
end

---
-- Called when a player destroys contraband.
-- @param ply The player in question
-- @param ent The contraband the player just destroyed
function GM:PlayerDestroyedContraband(ply, ent)
	local contra = self.Config['Contraband'][ent:GetClass()];
	if (not contra) then return end
	ply:GiveMoney(contra.money);
	ply:Notify("You earned $" .. contra.money .. " for destroying that " .. contra.name .. "!", 0);

	local pl = ent:GetPlayer();
	local name;
	if (IsValid(pl)) then
		name = pl:Name();
	else
		name = "someone";
	end
	GM:Log(EVENT_ADMINEVENT, "%s destroyed %s's %s.", ply:Name(), name, contra.name);
end

---
-- Called when a player attempts to ram a door.
-- @param ply The player in question
-- @param door The door in question
-- @return True if they can, false if they can't.
function GM:PlayerCanRamDoor(ply, door)
	if (door._Jammed or door._Sealed) then
		ply:Notify("You cannot ram this door!", 1);
		return false;
	elseif (cider.entity.isOwned(door)) then
		for _,pl in pairs(cider.entity.getAllAccessors(door)) do
			if (pl:Warranted() or pl == ply) then
				return true;
			end
		end
		local owner = cider.entity.getOwner(door)
		if (type(owner) == "Player" and IsValid(owner) and owner:Arrested()) then
			return true
		end
		ply:Notify("You do not have the authority to ram this door.", 1);
		return false;
	end
	return true;
end

---
-- Called when a player attempts to use a door.
-- @param ply The player in question
-- @param door The door in question
-- @return True if they can, false if they can't.
function GM:PlayerCanUseDoor(ply, door)
	if (door._Jammed or door._Sealed or ply:GetPos():Distance(ply:GetEyeTraceNoCursor().HitPos) > 128) then
		return false;
	end
	return not tobool(door._Locked);
end

---
-- Called when a player attempts to open a container
-- @param ply The player in question
-- @param ent The container in question
-- @return True if they can, false if they can't.
function GM:PlayerCanUseContainer(ply, ent)
	return (ply:GetEyeTraceNoCursor().HitPos:Distance(ply:EyePos()) < 129 and not (ent._Locked or ent._Sealed));
end

---
-- Called when a player starts to put/take an item into/from a container (Allows the overriding of the insertion proccess, or denying insertion, for banks or whatever)
-- @param ply The player in question
-- @param ent The container in question
-- @param itemid The ID of the item in question
-- @param amount How much of the item the player wants to do. (Negative values indicate removing from the container)
-- @param force Whether or not to ignore normal restraints such as size limits. If the gamemode sends a force request, it's not expecting it to fail nor is it going to handle any output you return.
-- @return nil to update as normal, true to indicate that you have updated the container and all is fine or false (and an optional message) to indicate failure and that the container window should be closed.
function GM:PlayerUpdateContainerContents(ply, ent, itemid, amount, force)
	if (ent._Locked or ent._Sealed) then
		return false;
	end
end

---
-- Called when a player has put/taken an item into/from a container (For notifications etc)
-- @param ply The player in question
-- @param ent The container in question
-- @param itemid The ID of the item in question
-- @param amount How much of the item the player wants to do. (Negative values indicate removing from the container)
-- @param force If the update was forced.
function GM:PlayerUpdatedContainerContents(ply, ent, itemid, amount, force)
	if (amount == 0) then
		return;
	end
	local item = self.Items[itemid];
	local iname, ename, oname, word;
	if (math.abs(amount) > 1) then
		iname = "some " .. item.Plural;
	else
		iname = (item.Name:sub(1,1):lower():find"[aeio]" and "an " or "a ") .. item.Name;
	end
	ename = ent:GetNWString("Name","container")
	oname = cider.entity.isOwned(ent) and cider.entity.getPossessiveName(ent) or ename:sub(1,1):find"[aeiou]" and "an" or "a"
	if (amount < 0) then
		amount = -amount;
		word = "%s took %i %s from %s %s";
		ply:Emote("takes " .. iname .. " from the " .. ename .. ".");
	else
		word = "%s put %i %s into %s %s";
		ply:Emote("puts " .. iname .. " into the " .. ename .. ".");
	end
	GM:Log(EVENT_ENTITY, word, ply:Name(), amount, (amount > 1 and item.Plural or item.Name), oname, ename);
end

---
-- Called when a player attempts to lockpick an entity
-- @param ply The player in question
-- @param ent The entity in question
-- @return True if they can, false if they can't.
function GM:PlayerCanLockpick(ply, ent)
	return IsValid(ent) and ((cider.entity.isOwnable(ent) and not (ent._Jammed or ent._Sealed)) or (ent:IsPlayer() and ent:Arrested()));
end

---
-- Called when a player attempts to earn contraband money.
-- @param ply The player in question
-- @return True if they can, false if they can't.
function GM:PlayerCanEarnContraband(ply)
	return true
end

---
-- Called when a player attempts to change the city laws
-- @param ply The player in question
-- @return True if they can, false if they can't.
function GM:PlayerCanChangeLaws(ply)
	return ply:IsModerator(); -- Let mods change the laws
end

---
-- Called when a player attempts to unwarrant a player.
-- @param ply The player in question
-- @param target The player's intended victim
-- @return True if they can, false if they can't.
function GM:PlayerCanUnwarrant(ply, target)
	return ply:IsAdmin() -- Let admins circumnavagate the system. (HAAAX!)
end

---
-- Called when a player has been warranted
-- @param ply The player in question
-- @param class The class of warrant
function GM:PlayerWarranted(ply, class)
end

---
-- Called when a player has been unwarranted either due to direct action or the time expiring
-- @param ply The player in question
function GM:PlayerUnwarranted(ply)
end

---
-- Called when a player switches teams
-- @param ply The player in question
-- @param oldteam The id of the old team
-- @param newteam The id of the new team
function GM:PlayerChangedTeams(ply, oldteam, newteam)
end

---
-- Called when a player is arrested
-- @param ply The player in question
function GM:PlayerArrested(ply)
end

---
-- Called when a player is unarrested
-- @param ply The player in question
function GM:PlayerUnArrested(ply)
end

---
-- Called when a player is knocked out, possibly by enemy action
-- @param ply The player in question
-- @param attacker (optional) The person who knocked them out
function GM:PlayerKnockedOut(ply, attacker)
end

---
-- Called when a player is woken up, possibly by enemy action
-- @param ply The player in question
-- @param attacker (optional) The person who woke them up
function GM:PlayerWokenUp(ply, attacker)
end

---
-- Called every 10th second a player is on the server
-- @param ply The player in question
function GM:PlayerTenthSecond(ply)
end

---
-- Called every second a player is on the server
-- @param ply The player in question
function GM:PlayerSecond(ply)
end

---
-- Called when a player attempts to say something in-character.
-- @param ply The player in question
-- @param text What the player is trying to say
function GM:PlayerCanSayIC(ply, text)
	if (not ply:Alive() or (ply:KnockedOut() and not ply._Tripped)) then
		ply:Notify("You cannot talk in this state!", 1)
		return false
	end
	return true
end

---
-- Called when a player attempts to say something in OOC.
-- @param ply The player in question
-- @param text What the player is trying to say
function GM:PlayerCanSayOOC(ply, text)
	if (ply:IsModerator()) then -- Mods can always use ooc
		return true;
	elseif ((ply._NextOOC or 0) > CurTime()) then -- Prevent OOC spam
		timeleft = ply._NextOOC - CurTime();
		if (timeleft > 60) then
			timeleft = string.ToMinutesSeconds(math.ceil(timeleft)).." minute(s)";
		else
			timeleft = math.ceil(timeleft).." second(s)";
		end
		ply:Notify("You must wait " .. timeleft .. " before using OOC again!", 1);
		return false;
	elseif (GetConVarNumber("cider_ooc") == 0) then -- Check if an irate superadmin has turned OOC off
		ply:Notify("Talking in OOC has been disabled.", 1)
		return false
	end
	ply._NextOOC = CurTime() + self.Config["OOC Timeout"]; -- Stop the player talking in OOC again for a while
	return true;
end

---
-- Called when a player attempts to say something in local OOC.
-- @param ply The player in question
-- @param text What the player is trying to say
function GM:PlayerCanSayLOOC(ply, text)
	return true
end

---
-- Called when attempts to use a command.
-- @param ply The player in question
-- @param cmd What command the player just tried to use
-- @param args A table of all the arguments the player passed
function GM:PlayerCanUseCommand(ply, cmd, args)
	-- Stop the player using the command if they're blacklisted from it
	if (ply:Blacklisted("cmd", command) > 0) then
		ply:BlacklistAlert("cmd",command,command);
		return false;
	end
	-- Some commands need to be usable when they normally wouldn't be.
	if (cmd == "sleep" and ply:Alive() and not ply:Arrested() and ply._Sleeping) --So they can wake up
	or ((cmd == "dropmoney" or cmd == "givemoney") and ply:Alive() and not ply:KnockedOut()) -- So you can bribe your way out of being arrested/tied up
	or ((cmd == "me" or cmd == "y" or cmd == "w") and ply:Alive() and not (ply:KnockedOut() and not ply._Tripped)) -- So you can emote while arrested/tripped
	or (cmd == "team" and not (ply:Arrested() or ply:Tied())) -- So you can't change job while arrested or tied, but can while dead or unconsious
	or table.HasValue(self.Config["Usable Commands"], cmd) then -- Or if it's one of the persistant commands
		return true;
	else --Otherwise, check the defeaults
		return gamemode.Call("PlayerCanDoSomething", ply);
	end
end

---
-- Called when a player is about to be recapacitated
-- @param ply The player in question
-- @return True if they can, false if they can't.
function GM:PlayerCanBeRecapacitated(ply)
	return not (ply:Arrested() or ply:Tied() or ply._HoldingEnt);
end

---
-- Called when a player is about to recieve their weapons
-- @param ply The player in question
-- @return True if they can, false if they can't.
function GM:PlayerCanRecieveWeapons(ply)
	return not (ply:Arrested() or ply:Tied());
end