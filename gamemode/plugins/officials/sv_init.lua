--[[
Name: "sv_init.lua".
	~ Applejack ~
--]]
-- Include the shared file and add it to the client download list.
includecs("sh_init.lua");

-- Settup function
function PLUGIN:LoadData()
	self.group = cider.team.getGroup("Officials");
end

--Check if they're the right group/gang
function PLUGIN:IsAuthorised(player,ingang)
	if (self.group == cider.team.getGroupByTeam(player:Team())) then
		if (ingang) then
			return cider.team.getGang(player:Team()) == 1;
		end
		return true;
	end
	return false;
end

-- Say a message as a request.
function PLUGIN:SayRequest(ply, text)
	local filter = RecipientFilter();
	for k, v in pairs( player.GetAll() ) do
		if self:IsAuthorised(v, true) then
			filter:AddPlayer(v);
		end
	end
	filter:AddPlayer(ply); -- Let them see what they said.
	cider.chatBox.add(filter, ply, "request", text);
end

-- Say a message as a broadcast.
function PLUGIN:SayBroadcast(ply, text)
	cider.chatBox.add(nil, ply, "broadcast", text);
end

-- Called when a player's radio recipients should be adjusted.
function PLUGIN:PlayerAdjustRadioRecipients(ply, text, recipients)
	if (not self:IsAuthorised(ply)) then
		return
	end
	for k in pairs(recipients) do
		recipients[k] = nil;
	end
	for _,id in pairs(self.group.teams) do
		table.Add(recipients, team.GetPlayers(id));
	end
end

function PLUGIN:PlayerDestroyedContraband(ply, ent)
	local data = GM.Config["Contraband"][ent:GetClass()];
	if (not data or not self:IsAuthorised(ply)) then
		return;
	end
	ply:SayRadio("I have destroyed a "..data.name..".");
end

-- Called when a player dies.
function PLUGIN:PlayerDeath(ply, inflictor, killer)
	if (killer:IsPlayer() and self:IsAuthorised(killer)) then
		killer:SayRadio("I have killed "..ply:Name()..".")
		return;
	elseif (ply:Team() == TEAM_MAYOR and not ply._ChangeTeam) then
		for _, pl in pairs(player.GetAll()) do
			pl:UnWarrant(); -- Loop through all players and dewarrant them.
		end
		self.Lockdown = false; -- Disable the lockdown
		SetGlobalBool("lockdown",false);
		cider.propprotection.CleanupPlayerProps(ply); -- Since the mayor's reign is over, his props should go.
		ply:Demote(); -- Drop dem to da bttom
	end
end

-- Called when a player attempts to arrest another player.
function PLUGIN:PlayerCanArrest(ply, target)
	if (ply:IsAdmin()) then return end -- Light abuse
	if (not self:IsAuthorised(ply,true)) then
		ply:Notify("You do not have access to arrest this player!", 1);
		return false;
	elseif (self:IsAuthorised(target)) then
		return false;
	end
end

-- Called when a player attempts to stun a player.
function PLUGIN:PlayerCanStun(ply, target)
	if (ply:IsAdmin()) then return end -- Light abuse
	if (not self:IsAuthorised(ply,true)) then
		ply:Notify("You do not have access to stun this player!", 1);
		return false;
	elseif (self:IsAuthorised(target,true)) then
		return false;
	end
end

-- Called when a player attempts to knock out a player.
function PLUGIN:PlayerCanKnockOut(ply, target)
	if (ply:IsAdmin()) then return end -- Light abuse
	if (not self:IsAuthorised(ply,true)) then
		ply:Notify("You do not have access to knock out this player!", 1);
		return false;
	elseif (self:IsAuthorised(target,true)) then
		return false;
	end
end

-- Called when a player attempts to wake up a player.
function PLUGIN:PlayerCanWakeUp(ply, target)
	if (ply:IsAdmin()) then return end -- Light abuse
	if (not self:IsAuthorised(ply,true)) then
		ply:Notify("You do not have access to wake up this player!", 1);
		return false;
	end
end

-- Called when a player attempts to unarrest another player.
function PLUGIN:PlayerCanUnarrest(ply, target)
	if (ply:IsAdmin()) then return true; end -- Light abuse
	if (not self:IsAuthorised(ply,true)) then
		player:Notify("You do not have access to unarrest this player!", 1);
		return false;
	end
	return true;
end

local function tmr(ply)
	if (IsValid(ply)) then
		ply:GodDisable();
	end
end
-- Called when a player spawns.
function PLUGIN:PostPlayerSpawn(ply, light, teamchange)
	if (self:IsAuthorised(ply, true)) then
		ply._ScaleDamage = 0.5; -- Free kevlar
	end
	if (ply:Team() ~= TEAM_MAYOR) then
		if (teamchange == TEAM_MAYOR) then -- If they have just switched from being mayor then make sure their spawn immunity is gone
			timer.Stop("Spawn Immunity: "..ply:UniqueID());
			ply:SetCSVar(CLASS_LONG, "_SpawnImmunityTime", 0); -- Reset the player's immunity time client side.
		end
		return; -- Everything after this is for the mayor only.
	elseif (light) then
		return -- Spawn immunity is only for the freshly spawned
	end
	ply:GodEnable()
	local duration = 60 -- Players will be immune for 60 seconds
	ply:SetCSVar(CLASS_LONG, "_SpawnImmunityTime", CurTime() + duration); -- Tell the client they're immune
	timer.Create("Spawn Immunity: "..ply:UniqueID(), duration, 1, function()
		tmr(ply); -- Make a timer to stop the immunity later
	end)
end

-- Called when a player attempts to warrant another player.
function PLUGIN:PlayerCanWarrant(ply, target, class)
	local words = class;
	if (class == "search") then
		words = "a search";
	elseif (class == "arrest") then
		words = "an arrest";
	end

	if (self:IsAuthorised(target) and class ~= "search") then -- You can't arrest police, so don't let them try.
		ply:Notify("You cannot arrest city officials!", 1);
		return false;
	end

	if (ply:Team() == TEAM_MAYOR) then -- The mayor can always warrant.
		return true;
	end

	if (team.NumPlayers(TEAM_MAYOR) > 0) then -- If there's a mayor and we're not him, we gotta beg.
		if (self:IsAuthorised(ply)) then
			ply:SayRadio("Mayor, could you warrant "..target:Name().." for "..words.." please?");
		else
			self:SayRequest(ply,"Mayor, I suggest you warrant "..target:Name().." for "..words..".");
		end
		return false; -- Only the mayor can fufil our wish.
	end

	if (ply:Team() == TEAM_POLICECOMMANDER) then -- If there's no mayor then the police commander handles warrants.
		return true;
	end

	if (team.NumPlayers(TEAM_POLICECOMMANDER) > 0) then -- If there's no mayor and we're not the commander, then we gotta pester the commander about it.
			if (self:IsAuthorised(ply)) then
				ply:SayRadio("Commander, could you warrant "..target:Name().." for "..words.." please?");
			else
				self:SayRequest(ply,"Commander, I suggest you warrant "..target:Name().." for "..words..".");
			end
			return false; -- We still can't do it ourself.
	end

	if (ply:Team() == TEAM_POLICEOFFICER) then -- The cat is away so the mice do play.
		return true;
	end

	if (team.NumPlayers(TEAM_POLICEOFFICER) > 0) then -- I guess there might be police officers for us to pester?
		if (self:IsAuthorised(ply)) then
			ply:SayRadio("Could an offier warrant "..target:Name().." for "..words.." please?");
		else
			self:SayRequest(ply,"I suggest that an officer warrants "..target:Name().." for "..words..".");
		end
		return false; -- Whodathunk it? Still impotent.
	end
	ply:Notify("There is no one to hear your request!");
	return false;
end

function PLUGIN:PlayerWarrantExpired(ply, class)
	if (not IsValid(ply)) then return end -- You'd be surprised
	if (team.NumPlayers(TEAM_MAYOR) > 0) then
		team.GetPlayers(TEAM_MAYOR)[1]:SayRadio("The "..class.." warrant for "..ply:Name().." has expired.");
	elseif (team.NumPlayers(TEAM_POLICECOMMANDER) > 0) then
		team.GetPlayers(TEAM_POLICECOMMANDER)[1]:SayRadio("The "..class.." warrant for "..ply:Name().." has expired.");
	elseif (team.NumPlayers(TEAM_POLICEOFFICER) > 0) then
		team.GetPlayers(TEAM_POLICEOFFICER)[1]:SayRadio("The "..class.." warrant for "..ply:Name().." has expired.");
	end
end

-- Called when a player warrants another player.
function PLUGIN:PlayerWarrant(ply, target, class)
	if (not self:IsAuthorised(ply)) then
		return
	elseif (class == "search") then
		ply:SayRadio("I have warranted "..target:Name().." for a search.");
	elseif (class == "arrest") then
		ply:SayRadio("I have warranted "..target:Name().." for an arrest.");
	end
end

-- Called when a player unwarrants another player.
function PLUGIN:PlayerUnwarrant(ply, target)
	if (self:IsAuthorised(ply)) then
		ply:SayRadio("I have unwarranted "..target:Name()..".");
	end
end

--[[local doors = {
	{"prop_dynamic","models/props_lab/elevatordoor.mdl",Angle(000,000,000),Vector(-6866.8232421875,-9445.345703125,73.03125),"Lift Access"},
	{"prop_dynamic","models/props_lab/elevatordoor.mdl",Angle(000,000,000),Vector(-6768.6274414063,-9500.35546875,841.03125),"Cells + Commander's Office"},
	{"prop_dynamic","models/props_lab/elevatordoor.mdl",Angle(000,000,000),Vector(-7552.4541015625,-9159.3251953125,841.03125),"Cells"},
	{"prop_dynamic","models/props_lab/elevatordoor.mdl",Angle(000,090,000),Vector(-6919.013671875,-9440.412109375,1481.03125),"Quartermaster's Office"},
	{"prop_dynamic","models/props_lab/elevatordoor.mdl",Angle(000,090,000),Vector(-6829.3862304688,-9431.8671875,2617.03125),"Mayor's Suite"},
	{"prop_dynamic","models/props_lab/elevatordoor.mdl",Angle(000,000,000),Vector(-6965.9765625,-9148.5576171875,2489.03125),"Mayor's Office"},
}
function PLUGIN:InitPostEntity()
	if (game.GetMap():lower() ~= "rp_evocity_v2d") then return end
	for _,tab in ipairs(doors) do
		ent = ents.Create(tab[1]);
		if (not IsValid(ent)) then
			ErrorNoHalt("couldn't create a  "..tab[1].."!");
		else
			ent:SetAngles(tab[3]);
			ent:SetModel(tab[2]);
			ent:SetPos(tab[4]);
			if (tab[1] == "prop_dynamic") then
				ent:SetKeyValue("solid",6);
				ent:SetKeyValue("MinAnimTime",	1);
				ent:SetKeyValue("MaxAnimTime",	5);
			else
				ent:SetKeyValue("hardware",		1);
				ent:SetKeyValue("distance",		90);
				ent:SetKeyValue("speed",		100);
				ent:SetKeyValue("returndelay",	-1);
				ent:SetKeyValue("spawnflags",	8192);
				ent:SetKeyValue("forceclosed",	0);
			end
			ent:Spawn();
			ent:Activate();
			ent.PhysgunDisabled = true
			ent.m_tblToolsAllowed = {}
			ent._DoorState = "closed";
			ent._Autoclose = 5;
			cider.entity.makeOwnable(ent);
			cider.entity.setOwnerGang(ent,1,1);
			cider.entity.setName(ent,tab[5]);
			ent:Lock();
			ent:SetNWString("Name","GHQ");
		end
	end
end
-]]
function PLUGIN:PlayerKnockedOut(victim, attacker)
	if (IsValid(attacker) and self:IsAuthorised(attacker)) then
		attacker:SayRadio("I have knocked out " .. victim:Name() .. ".");
	end
end

function PLUGIN:PlayerWokenUp(victim, attacker)
	if (IsValid(attacker) and self:IsAuthorised(attacker)) then
		attacker:SayRadio("I have woken up " .. victim:Name() .. ".");
	end
end

-- Called when a player arrests another player.
function PLUGIN:PlayerArrest(ply, target)
	if (self:IsAuthorised(ply)) then
		ply:SayRadio("I have arrested "..target:Name()..".");
	end
end

-- Called when a player unarrests another player.
function PLUGIN:PlayerUnarrest(ply, target)
	if (self:IsAuthorised(ply)) then
		ply:SayRadio("I have unarrested "..target:Name()..".");
	end
end

-- Called when a player attempts to unwarrant another player.
function PLUGIN:PlayerCanUnwarrant(ply, target)
	if (ply:Team() == TEAM_MAYOR || ply:Team() == TEAM_POLICECOMMANDER) then
		return true;
	end
end

-- Called when a player attempts to change the city laws
function PLUGIN:PlayerCanChangeLaws(ply)
	if (ply:Team() == TEAM_MAYOR) then
		return true;
	end
end

-- Called when a player attempts to demote another.
function PLUGIN:PlayerCanDemote(ply,target)
	if (ply:Team() == TEAM_MAYOR and self:IsAuthorised(target)) then
		return true;
	end
end

-- A command to broadcast to all players.
cider.command.add("broadcast", "b", 1, function(ply, args)
	local team = ply:Team();
	if (team ~= TEAM_MAYOR and team ~= TEAM_POLICECOMMANDER) then
		return false, "You cannot make broadcasts!";
	end
	local words = table.concat(args, " "):Trim();
	if (words == "") then
		return false, "You did not specify enough text!";
	end
	if (team == TEAM_POLICECOMMANDER) then
		words = "(POLICE) "..words;
	end
	cider.chatBox.add(nil, ply, "broadcast", words);
end, "Police Commands", "<text>", "Broadcast a message to all players.");

local plugin = PLUGIN;

-- A command to request assistance from the Police and Mayor.
cider.command.add("request", "b", 1, function(ply, args)
	local words = table.concat(args, " "):Trim();
	if (words == "") then
		return false, "You did not specify enough text!";
	end
	if (plugin:IsAuthorised(ply)) then
		ply:SayRadio(words);
	else
		plugin:SayRequest(ply, words);
	end
end, "Commands", "<text>", "Request assistance from the Police and Mayor.");

-- A command to initiate lockdown.
cider.command.add("lockdown", "b", 0, function(ply)
	if (plugin.Lockdown) then
		return false, "There is already a lockdown active!";
	elseif (ply:Team() == TEAM_MAYOR) then
		plugin:SayBroadcast(ply, "A lockdown is in progress. Please return to your homes.");
		plugin.Lockdown = true;
		SetGlobalBool("lockdown", true);
		return true;
	elseif (team.NumPlayers(TEAM_MAYOR) > 0) then -- If there's a mayor and we're not him, we gotta beg.
		if (plugin:IsAuthorised(ply)) then
			ply:SayRadio("Mayor, could you initiate a lockdown please?");
		else
			plugin:SayRequest(ply,"Mayor, I suggest you initiate a lockdown.");
		end
		return false; -- Only the mayor can fufil our wish.
	end
	return false, "Only the Mayor can initiate a lockdown!";
end, "Commands", nil, "Requset or initiate a lockdown.");

-- A command to cancel lockdown.
cider.command.add("unlockdown", "b", 0, function(ply)
	if (not plugin.Lockdown) then
		return false, "There isn't an active lockdown!";
	elseif (ply:Team() == TEAM_MAYOR) then
		plugin:SayBroadcast(ply, "The lockdown has been cancelled.");
		plugin.Lockdown = false;
		SetGlobalBool("lockdown", false);
		return true;
	elseif (team.NumPlayers(TEAM_MAYOR) > 0) then -- If there's a mayor and we're not him, we gotta beg.
		if (plugin:IsAuthorised(ply)) then
			ply:SayRadio("Mayor, could you end the lockdown please?");
		else
			plugin:SayRequest(ply,"Mayor, I suggest you end the lockdown.");
		end
		return false; -- Only the mayor can fufil our wish.
	end
	return false, "Critical error 2194"; -- Lockdown without a mayor? This is not possible.
end, "Commands", nil, "Requset the end of or end the current lockdown.");