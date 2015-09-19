--[[
	~ Commands ~
	~ Applejack ~
--]]

cider.command.add("fuck","b",0,function(p)
	p:Notify("FUCK!", 1);
end,"Commands", "", "Free gratuitous swearing");

--[[ ADMIN ABUSE COMMANDS ]]--
--[[
	These are only here at the insistance of my admins. They only apply to SuperAdmins, who probably can be trusted.
	If yours can't be trusted, delete the space between the [s as shown below.
--]]
--[ [<--Delete the space between these [s if you want to disable the abuse commands

-- Knock out one person for an optional amount of time. Will default to 5.
cider.command.add("knockout","s",1,function(ply, target, time)
	local victim = player.Get(target);
	if (victim) then
		victim:KnockOut(tonumber(time) or 5);
		GM:Log(EVENT_EVENT, "%s knocked out %s", ply:Name(), victim:Name());
	else
		return false, "Invalid player '"..target.."'!";
	end
end, "Admin Abuse Commands", "<player> [time]", "Knock a player out", true);

-- Wake a player up
cider.command.add("wakeup","s",1,function(ply, target)
	local victim = player.Get(target);
	if (victim) then
		victim:WakeUp();
		GM:Log(EVENT_EVENT, "%s woke up %s", ply:Name(), victim:Name());
	else
		return false, "Invalid player '"..target.."'!";
	end
end, "Admin Abuse Commands", "<player>", "wake a player up", true);

local function knockoutfunct(tbl,tiem)
	local target = table.remove(tbl);
	if (IsValid(target)) then
		target:KnockOut(tiem);
	end
end
-- Knock out everyone for a specified time. (Try not to use)
cider.command.add("knockoutall","s",0,function(ply, time)
	local tbl = player.GetAll();
	player.NotifyAll("%s knocked everyone out .", 0, ply:Name());
	timer.Create(ply:Name().." admin abuse knockout", 0, #tbl, function()
		knockoutfunct(tbl, tonumber(time) or 5);
	end)
end, "Admin Abuse Commands", "[time]", "Knock out all players", true);

local function unknockoutfunct(tbl)
	local target = table.remove(tbl);
	if (IsValid(target)) then
		target:WakeUp();
	end
end
-- Wake everyone up
cider.command.add("wakeupall","s",0,function(ply)
	local tbl = player.GetAll();
	player.NotifyAll("%s woke everyone up.", 0, ply:Name());
	timer.Create(ply:Name().." admin abuse unknockout", 0, #tbl, function()
		knockoutfunc(tbl);
	end)
end, "Admin Abuse Commands", "[time]", "wake up all players");

-- Tie a player up
cider.command.add("tie","s",1,function(ply, target)
	local victim = player.Get(target);
	if (victim) then
		victim:TieUp();
		GM:Log(EVENT_EVENT, "%s tied up %s", ply:Name(), victim:Name());
	else
		return false, "Invalid player '"..target.."'!";
	end
end, "Admin Abuse Commands", "<player>", "tie a player", true);

cider.command.add("untie","s",1,function(ply, target)
	local victim = player.Get(target);
	if (victim) then
		victim:UnTie();
		GM:Log(EVENT_EVENT, "%s untied %s", ply:Name(), victim:Name());
	else
		return false, "Invalid player '"..target.."'!";
	end
end, "Admin Abuse Commands", "<player>", "untie a player", true);

-- There were '(un)tieall' commands here but they were removed.

-- Respawn a player completely
cider.command.add("spawn","s",1,function(ply, target)
	local victim = player.Get(target);
	if (victim) then
		victim:Spawn();
		GM:Log(EVENT_EVENT, "%s respawned %s", ply:Name(), victim:Name());
	else
		return false, "Invalid player '"..target.."'!";
	end
end, "Admin Abuse Commands", "<player>", "respawn a player", true);

-- Set a player to a particular team (ignoring all restrictions like team size)
cider.command.add("setteam","a",2,function(ply, target, targetteam)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	end
	local tdata = cider.team.get(targetteam);
	if (not tdata) then
		return false, "Invalid team '"..targetteam.."'!";
	end
	victim:JoinTeam(tdata.index);
	GM:Log(EVENT_EVENT,"%s set %s's team to %q", ply:Name(), victim:Name(), tdata.name);
end, "Admin Abuse Commands", "<player> <team>", "set a player's team", true);

-- Arrest a player with optional arrest time
cider.command.add("arrest","s",1,function(ply, target, time)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	end
	victim:Arrest(tonumber(time));
	GM:Log(EVENT_EVENT, "%s arrested %s", ply:Name(), victim:Name());
end, "Admin Abuse Commands", "<player> [time]", "arrest a player", true);

-- Unarrest a player
cider.command.add("unarrest","s",1,function(ply, target)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	end
	victim:UnArrest();
	GM:Log(EVENT_EVENT, "%s unarrested %s", ply:Name(), victim:Name());
end, "Admin Abuse Commands", "<player>", "unarrest a player", true);

-- Give a player an instant warrant with optional length
cider.command.add("awarrant","s",2,function(ply, target, kind, time)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	end
	kind = string.lower(kind);
	if (kind ~= "arrest" and kind ~= "search") then
		return false, "Invalid warrant type '"..kind.."'!";
	end
	time = tonumber(time);
	GM:Log(EVENT_EVENT,"%s gave %s a %s warrant for %s seconds", ply:Name(), victim:Name(), kind, time or "default");
	victim:Warrant(kind, time);
end, "Admin Abuse Commands", "<player> <warrant> [time]", "warrant a player without going through the normal routes", true);

-- Give a player a named SWep/HL2 gun
cider.command.add("give","s",2,function(ply, target, kind)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	end
	if (not IsValid(victim:Give(kind))) then
		return false, "Invalid weapon '"..kind.."'!";
	end
	GM:Log(EVENT_EVENT, "%s gave %s a %s", ply:Name(), victim:Name(), kind);
end, "Admin Abuse Commands", "<player> <swep>", "give a player a named swep (ie cider_baton)", true);

-- give a player some ammo
cider.command.add("giveammo","s",2,function(ply, target, kind, amount)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	end
	amount = tonumber(amount) or 20
	victim:GiveAmmo(amount, kind);
	GM:Log(EVENT_EVENT, "%s gave %s %s %s ammo", ply:Name(), victim:Name(), amount, kind);
end, "Admin Abuse Commands", "<player> <ammo> [amoun]", "give a player named ammo (ie SMG1_Grenade)", true);

cider.command.add("invisible","a",0,function(ply, target)
	local victim
	if (target) then
		victim = player.Get(target);
		if (not victim) then
			return false, "Invalid player '"..target.."'!";
		end
	else
		victim = ply;
	end
	if (victim:GetColor() == 0) then
		victim:SetColor(255,255,255,255)
		victim:DrawShadow(true);
		victim:Notify("You are now visible",0);
		if (ply ~= victim) then
			ply:Notify(tostring(victim) .. " is now visible.",0);
		end
	else
		victim:SetColor(0,0,0,0)
		victim:DrawShadow(false);
		victim:Notify("You are now invisible",0);
		if (ply ~= victim) then
			ply:Notify(tostring(victim) .. " is now invisible.",0);
		end
	end
end, "Admin Abuse Commands","[target]","Make yourself or someone else invisible. (needs 'i' access)", true)

-- Give or take items away from players.
cider.command.add("giveitem", "s", 2, function(ply, target, name, amount, force)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	end
	local item = GM:GetItem(name);
	if (not item) then
		return false, "Invalid item '"..name.."'!";
	end
	if (amount == "force") then -- Some people use the old (silly) order. They really shouldn't by now but meh. Luckily they tend to use 'force' instead of 'true'.
		ply:Notify("YOU'RE DOING IT WRONG GODDAMNIT JOIN THE NEW WORD ORDER", 1);
		ply:Notify("Puns are the best form of humor. Reguardless, the syntax IS /giveitem "..target.." "..name.." "..(tonumber(force) or 1).." force, not /giveitem "..target.." "..name.." force "..(tonumber(force) or 1)..".");
		ply:Notify("Please remember the order. This warning will not always work properly.");
		amount,force = force, amount;
	end
	amount = tonumber(amount) or 1;
	force = tobool(force);
	if (amount == 0) then
		return false, "What is the point of doing that?";
	elseif (amount * item.Size > 50) then -- Something that not everyone bears in mind. (Including me occasionally.)
		ply:Notify("Warning: You are giving "..victim:Name().." more items than players can normally fit in their inventories. Experience has shown this if often a bad idea if done to anyone not part of the cabal. Remember you can remove items with negative numbers.");
	end
	local s,f = cider.inventory.update(victim, item.UniqueID, amount, force);
	if (not s) then
		return false, f;
	end
	-- Do tha loggin
	if (amount == 1) then
		amount = "a";
		name = item.Name;
	else
		name = item.Plural;
	end
	local person = "themselves";
	if (ply ~= victim) then
		person = victim:Name();
		victim:Notify(ply:Name() .. " has given you " .. amount .. " " .. name .. ".", 0);
	end
	player.NotifyByAccess("s", ply:Name() .. " gave " .. person .. " " .. amount .. " " .. name .. ".", 0);
	GM:Log(EVENT_SUPEREVENT, "%s gave %s %s %s.", ply:Name(), person, amount, name);
end, "Admin Abuse Commands", "<player> <item> [number] [force]", "Give an item to a player. (Or take it away with negative numbers.)", true);

cider.command.add("setmodel","a",2,function(ply, target, model)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	elseif (not util.IsValidModel(model)) then
		return false, "Invalid model!";
	end
	victim:SetModel(model);
	GM:Log(EVENT_EVENT,"%s set %s's model to %q", ply:Name(), victim:Name(), model);
end, "Admin Abuse Commands", "<name> <model>","Override the player's current model.", true)

cider.command.add("notify", "a", 3, function(ply, target, level, ...)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	end
	local words = string.Trim(table.concat({...}, " "));
	--<chat|drip/0|error/1|bip/2|tic/3>
	level = string.lower(level);
	if (level == "drip") then
		level = 0;
	elseif (level == "error") then
		level = 1;
	elseif (level == "undo") then
		level = 2;
	elseif (level == "bell") then
		level = 3;
	end
	level = tonumber(level);
	victim:Notify(words, level);
	GM:Log(EVENT_SUPEREVENT, "%s sent %s a level %s notification saying %q", ply:Name(), victim:Name(), level or "chat", words);
end, "Admin Abuse Commands", "<player> <chat|drip/0|error/1|undo/2|bell/3> <words>", "Send a player a notification using the built in system.", true);
cider.command.add("notifyall", "a", 2, function(ply, level, ...)
	local words = string.Trim(table.concat({...}, " "));
	--<chat|drip/0|error/1|bip/2|tic/3>
	level = string.lower(level);
	if (level == "drip") then
		level = 0;
	elseif (level == "error") then
		level = 1;
	elseif (level == "undo") then
		level = 2;
	elseif (level == "bell") then
		level = 3;
	end
	level = tonumber(level);
	player.NotifyAll("%s", level, words); -- Feeelthy hack to prevent unwanted stacking in the pooled string table.
	GM:Log(EVENT_SUPEREVENT, "%s sent %s a level %s notification saying %q", ply:Name(), "everyone", level or "chat", words);
end, "Admin Abuse Commands", "<chat|drip/0|error/1|undo/2|bell/3> <words>", "Send a player a notification using the built in system.", true);
--]]
--[[ END OF ADMIN ABUSE COMMANDS ]]--



cider.command.add("giveaccess", "s", 2, function(ply, target, flags)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	end
	flags:gsub("[asm%s]", "");
	if (flags == "") then
		return false;
	end
	victim:GiveAccess(flags);
	player.NotifyAll("%s gave %s access to the %q flag%s", nil, ply:Name(), victim:Name(), flags, flags:len() > 1 and "s" or "");
end, "Super Admin Commands", "<player> <access>", "Give access to a player.", true);

-- A command to take access from a player.
cider.command.add("takeaccess", "s", 2, function(ply, target, flags)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	end
	flags:gsub("[asm%s]", "");
	if (flags == "") then
		return false;
	end
	victim:TakeAccess(flags);
	player.NotifyAll("%s took %s's access to the %q flag%s", nil, ply:Name(), victim:Name(), flags, flags:len() > 1 and "s" or "");
end, "Super Admin Commands", "<player> <access>", "Take access from a player.", true);


cider.command.add("restartmap", "m", 0, function(ply)
	for _, pl in pairs(player.GetAll()) do
		pl:HolsterAll();
		pl:SaveData();
	end
	player.NotifyAll(ply:Name().." restarted the map!");
	game.ConsoleCommand("changelevel "..game.GetMap().."\n");
end, "Admin Commands", "", "Restart the map immediately.");

local function getnamething(kind,thing)
	if kind == "team" then
	-- Team blacklist
		local team = cider.team.get(thing)
		if		not team			then return false,thing.." is not a valid team!"
		elseif  not team.blacklist	then return false, team.name.." isn't blacklistable!"
		end
		return team.name, team.index
	elseif kind == "item" then
	-- Item blacklist
		local  item = GM:GetItem(thing)
		if not item then return false,thing.." is not a valid item!" end
		return item.Name, item.UniqueID
	elseif kind == "cat" then
	-- Category blacklist
		local  cat = GM:GetCategory(thing)
		if not cat then return false,thing.." is not a valid category!" end
		return cat.Name, cat.index;
	elseif kind == "cmd" then
	-- Command blacklist
		local cmd = cider.command.stored[thing]
		if not cmd then return false,thing.." is not a valid command!" end
		return thing, thing;
	else
		return false,thing.." is not a valid blacklist type! Valid: team/item/cat/cmd"
	end
end
local function getBlacklistTime(time)
	if (time >= 1440) then
		return math.ceil(time / 1440) .. " days";
	elseif (time >= 60) then
		return math.ceil(time / 60) .. " hours";
	else
		return time .. " minutes";
	end
end
-- A command to blacklist a player from a team.
--/blacklist chronic team police 0 "asshat"
-- team/item/cat/cmd
--<name> <type> <thing> <time> <reason>
--TODO: Make a vgui to handle this shit.
cider.command.add("blacklist", "m", 5, function(ply, target, kind, thing, time, ...)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	end
	kind, thing, time = string.lower(kind), string.lower(thing), tonumber(time);
	if (time < 1) then
		return false, "You cannot blacklist for less than a minute!";
	elseif ((time > 10080 and not ply:IsSuperAdmin()) or (time > 1440 and not ply:IsAdmin())) then
		return false, "You cannot blacklist for that long!";
	end
	local reason = table.concat({...}, " "):sub(1,65):Trim();
	if (not reason or reason == "" or (reason:len() < 5 and not ply:IsSuperAdmin())) then
		return false, "You must specify a reason!";
	end
	-- Get the name of what we're doing and the thing itself.
	local name, thing = getnamething(kind, thing);
	if (not name) then
		return false, thing;
	end
	if (victim:Blacklisted(kind, thing) ~= 0) then
		return false, victim:Name() .. " is already blacklisted from that!";
	end
	if (not gamemode.Call("PlayerCanBlacklist", ply, victim, kind, thing, time, reason)) then
		return false;
	end
	gamemode.Call("PlayerBlacklisted", victim, kind, thing, time, reason, ply);
	victim:Blacklist(kind, thing, time, reason, ply:Name());
	time = getBlacklistTime(time);
	player.NotifyAll("%s blacklisted %s from using %s for %s for %q.", nil, ply:Name(), victim:Name(), name, time, reason);
end, "Moderator Commands", "<player> <team|item|cat|cmd> <thing> <time> <reason>", "Blacklist a player from something", true);

cider.command.add("unblacklist", "m", 3, function(ply, target, kind, thing)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	end
	kind, thing = string.lower(kind), string.lower(thing);
	-- Get the name of what we're doing and the thing itself.
	local name, thing = getnamething(kind, thing);
	if (not name) then
		return false, thing;
	end
	if (victim:Blacklisted(kind, thing) == 0) then
		return false, victim:Name() .. " is not blacklisted from that!";
	end
	if (not gamemode.Call("PlayerCanUnBlacklist", ply, victim, kind, thing)) then
		return false;
	end
	gamemode.Call("PlayerUnBlacklisted", victim, kind, thing, ply);
	victim:UnBlacklist(kind, thing);
	player.NotifyAll("%s unblacklisted %s from using %s.", nil, ply:Name(), victim:Name(), name);
end, "Moderator Commands", "<player> <team|item|cat|cmd> <thing>", "Unblacklist a player from something", true)

cider.command.add("blacklistlist", "m", 1, function(ply, target)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	end
	local blacklist = victim.cider._Blacklist;
	if (table.Count(blacklist) == 0) then
		return false, victim:Name() .. " isn't blacklisted from anything!";
	end
	local printtable, words = {};
	local namelen, adminlen, timelen = 0, 0, 0;
	local time, name, admin, reason
	for kind, btab in pairs(blacklist) do
		if (table.Count(btab) == 0) then
			blacklist[kind] = nil;
		else
			words = {};
			for thing in pairs(btab) do
				time, reason, admin = victim:Blacklisted(kind, thing);
				if (time ~= 0) then
					name = getnamething(kind, thing);
					time = getBlacklistTime(time);
					if ( name:len() > namelen ) then  namelen = name:len();  end
					if (admin:len() > adminlen) then adminlen = admin:len(); end
					if (time:len()  > timelen ) then  timelen = time:len();  end
					words[#words + 1] = {name, time, admin, reason};
				end
			end
			if (#words ~= 0) then
				printtable[#printtable + 1] = {kind, words};
			end
		end
	end
	if (#printtable == 0) then
		return false, victim:Name() .. " isn't blacklisted from anything!";
	end
	local a,b,c = ply.PrintMessage, ply, HUD_PRINTCONSOLE;
	-- A work of art in ASCII formatting. A shame it is soon to be swept away
		a(b,c, "----------------------------[ Blacklist Details ]-----------------------------");
		local w = "%-" .. namelen + 2 .. "s| %-" .. timelen + 2 .. "s| %-" .. adminlen + 2 .. "s| %s";
		a(b,c,w:format("Thing", "Time", "Admin", "Reason"));
		for _,t in ipairs(printtable) do
			a(b,c, "-----------------------------------[ "..string.format("%-4s",t[1]).." ]------------------------------------");
			for _,t in ipairs(t[2]) do
				a(b,c,w:format(t[1], t[2], t[3], t[4]));
			end
		end
	-- *sigh*
	player:Notify("Blacklist details have been printed to your console.",0);
end, "Moderator Commands", "<player>", "Print a player's blacklist to your console (temp)", true);

-- A command to demote a player.
cider.command.add("demote", "b", 2, function(ply, target, ...)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	end
	local reason = table.concat({...}, " "):sub(1,65):Trim();
	if (not reason or reason == "" or (reason:len() < 5 and not ply:IsSuperAdmin())) then
		return false, "You must specify a reason!";
	end
	if (not gamemode.Call("PlayerCanDemote", ply, victim)) then
		return false;
	end
	local tid = victim:Team();
	victim:Demote();
	player.NotifyAll("%s demoted %s from %s for %q.", nil, ply:Name(), victim:Name(), team.GetName(tid), reason);
end, "Commands", "<player> <reason>", "Demote a player from their current team.", true);

cider.command.add("save", "s", 0, function(ply)
	player.SaveAll()
	GM:Log(EVENT_PUBLICEVENT,"%s saved everyone's profiles.", ply:Name())
end, "Super Admin Commands", "", "Forceably save all profiles")

-- A command to privately message a player.
cider.command.add("pm", "b", 2, function(ply, target, ...)
	local victim = player.Get(target);
	if (not victim) then
		return false, "Invalid player '"..target.."'!";
	elseif (victim == ply) then
		return false, "You can't PM yourself.";
	end
	local words = table.concat({...}, " "):sub(1,125):Trim();
	if (not words or words == "") then
		return false, "You must specify a message!";
	end
	GM:Log(EVENT_SUPEREVENT, "%s pmed %s: %s",ply:Name(), victim:Name(), words)
	-- Print a message to both players participating in the private message.
	cider.chatBox.add(victim, ply, "pm", words);
	words = "@" ..    victim:Name() .. " " .. words;
	cider.chatBox.add(ply,    ply, "pm", words);
end, "Commands", "<player> <text>", "Send an OOC private messsage to a player.", true);

-- A command to give a player some money.
cider.command.add("givemoney", "b", 1, function(ply, amt)
	local victim = ply:GetEyeTraceNoCursor().Entity;
	if (not (IsValid(victim) and victim:IsPlayer())) then
		return false, "You must look at a player to give them money!";
	end
	amt = tonumber(amt);
	if (not amt or amt < 1) then
		return false, "You must specify a valid amount of money!";
	end
	amt = math.floor(amt);
	if (not ply:CanAfford(amt)) then
		return false, "You do not have enough money!";
	end
	ply:GiveMoney(-amt);
	victim:GiveMoney(amt);

	ply:Emote("hands " .. victim:Name() .. " a wad of money.");

	ply:Notify("You gave " .. victim:Name() .. " $" .. amt .. ".", 0);
	victim:Notify(ply:Name() .. " gave you $" .. amt .. ".", 0);
	GM:Log(EVENT_EVENT, "%s gave %s $%i.", ply:Name(), victim:Name(), amt);
end, "Commands", "<amount>", "Give some money to the player you're looking at.", true);

-- A command to drop money.
cider.command.add("dropmoney", "b", 1, function(ply, amt)
	-- Prevent fucktards spamming the dropmoney command.
	ply._NextMoneyDrop = ply._NextMoneyDrop or 0;
	if ((ply._NextMoneyDrop or 0) > CurTime()) then
		return false, "You need to wait another " .. (ply._NextMoneyDrop - CurTime()).. " seconds before dropping more money.";
	end
	local pos = ply:GetEyeTraceNoCursor().HitPos;
	if (ply:GetPos():Distance(pos) > 255) then
		pos = ply:GetShootPos() + ply:GetAimVector() * 255;
	end
	amt = tonumber(amt);
	if (not amt or amt < 1) then
		return false, "You must specify a valid amount of money!";
	end
	amt = math.floor(amt);
	if (not ply:CanAfford(amt)) then
		return false, "You do not have enough money!";
	elseif (amt < 500) then -- Fucking spammers again.
		return false, "You cannot drop less than $500.";
	end
	ply._NextMoneyDrop = CurTime() + 30;
	ply:GiveMoney(-amt);
	cider.propprotection.PlayerMakePropOwner(GM.Items["money"]:Make(pos, amt), ply, true);
	GM:Log(EVENT_EVENT,"%s dropped $%i.", ply:Name(), amt);
end, "Commands", "<amount>", "Drop some money where you are looking.", true);

-- A command to write a note.
local function noteclean(note, id)
	if (not IsValid(note)) then
		timer.Destroy("Note Cleanup: "..id);
		return;
	end
	local r,g,b,a = note:GetColor();
	a = a - 10;
	if (a < 1) then
		timer.Destroy("Note Cleanup: "..id);
		note:Remove();
		return;
	end
	note:SetColor(r,g,b,a);
end
cider.command.add("note", "b", 1, function(ply, ...)
	if (ply:GetCount("notes") == GM.Config["Maximum Notes"]) then
		return false, "You've hit the notes limit!";
	end
	local pos = ply:GetEyeTraceNoCursor().HitPos;
	if (ply:GetPos():Distance(pos) > 255) then
		pos = ply:GetShootPos() + ply:GetAimVector() * 255;
	end
	local words = table.concat({...}, " "):sub(1,125):Trim();
	if (not words or words == "") then
		return false, "You must specify a message!";
	end

	-- Create the money entity.
	local entity = ents.Create("cider_note");

	-- Set the amount and position of the money.
	entity:SetText(words);
	entity:SetPos(pos + Vector(0, 0, 5 ) );

	-- Spawn the money entity.
	entity:Spawn();
	cider.propprotection.PlayerMakePropOwner(ply, entity, true);

	ply:AddCount("notes", entity);
	local index = entity:EntIndex()
	-- This is an inifite timer as it allows admins to extend the lifespan of their note by setting it's colour every so often.
	timer.Create("Note Cleanup: " .. index, GM.Config["Note Fade Speed"], 0, function()
		noteclean(entity, index);
	end)
	-- Add this to our undo table.
	undo.Create("Note");
		undo.SetPlayer(ply);
		undo.AddEntity(entity);
	undo.Finish();
	GM:Log(EVENT_EVENT, "%s wrote a note: %s", ply:Name(), words);
end, "Commands", "<text>", "Write a note at your target position.", true);

-- A command to change your job title
cider.command.add("job", "b", 0, function(ply, ...)
	local words = table.concat({...}, " "):sub(1,80):Trim();
	if (not words or words == "") then
		words = team.GetName(ply:Team());
	end
	ply._Job = words;
	ply:SetNWString("Job", ply._Job);
	ply:Notify("You have changed your job title to '" .. words .. "'.");
	GM:Log(EVENT_EVENT, "%s changed " .. ply._GenderWord .. " job text to %q.", ply:Name(), words);
end, "Commands", "[text]", "Change your job title or reset it.", true);

cider.command.add("description", "b", 0, function(ply, ...)
	local words = table.concat({...}, " "):sub(1,50):Trim();
	if (not words or words == "quit" or words == "none") then
		words = "";
	end
	ply.cider._Description = words;
	ply:SetNWString("Description", words);
	GM:Log(EVENT_EVENT, "%s set their Description to %q.", ply:Name(), words);
	if (words == "") then
		ply:Notify("You have unset your Description", 0);
	else
		ply:Notify("You have changed your clan to '"..text.."'.");
		GM:Log(EVENT_EVENT, "%s changed "..ply._GenderWord.." details to %q.",ply:Name(),text)
	end
	ply:SaveData()
end, "Commands", "[text|none]", "Change your description or remove your current one.",true);


-- A command to change your clan.
cider.command.add("clan", "b", 0, function(ply, ...)
	local words = table.concat({...}, " "):sub(1,50):Trim();
	if (not words or words == "quit" or words == "none") then
		words = "";
	end
	ply.cider._Clan = words;
	ply:SetNWString("Clan", words);
	GM:Log(EVENT_EVENT, "%s set their clan to %q.", ply:Name(), words);
	if (words == "") then
		ply:Notify("You have unset your clan", 0);
	else
		ply:Notify("You have set your clan to '"..text.."'.");
	end
	ply:SaveData()
end, "Commands", "[text|quit|none]", "Change your clan or quit your current one.",true);

cider.command.add("rpname", "b", 0, function(ply, ...)
	local words = table.concat({...}, " "):sub(1,50):Trim();
	if (not words) then
		words = "John Doe";
	end
	ply.cider._RPName = words;
	ply:SetNWString("RPName", words);
	GM:Log(EVENT_EVENT, "%s set their RPName to %q.", ply:Name(), words);
		ply:Notify("You have set your RPName to '" .. words .. "'.", 0);
	ply:SaveData()
end, "Commands", "[text]", "Change your RPName.",true);
-- A command to change your gender.
cider.command.add("gender", "b", 1, function(ply, gender)
	gender = string.lower(gender);
	if (gender ~= "male" and gender ~= "female") then
		return false, "Invalid gender specified.";
	elseif (string.lower(ply._Gender) == gender) then
		return false, "You are already " .. gender .. "!";
	elseif (gender == "male") then
		ply._NextSpawnGender = "Male";
		ply._NextSpawnGenderWord = "his";
	else
		ply._NextSpawnGender = "Female";
		ply._NextSpawnGenderWord = "her";
	end
	ply:Notify("You will be " .. gender .. " next time you spawn.", 0);
	GM:Log(EVENT_EVENT, "%s set " .. ply._NextSpawnGenderWord .. " gender to " .. gender .. ".", ply:Name());
end, "Menu Handlers", "<male|female>", "Change your gender.", true);

-- A command to yell in character.
cider.command.add("y", "b", 1, function(ply, ...)
	local words = table.concat({...}, " "):Trim();
	if (not words or words == "") then
		return false, "You must specify a message!";
	end

	-- Print a message to other players within a radius of the player's position.
	cider.chatBox.addInRadius(ply, "yell", words, ply:GetPos(), GM.Config["Talk Radius"] * 2);
end, "Commands", "<text>", "Yell to players near you.", true);

-- A command to do 'me' style text.
cider.command.add("me", "b", 1, function(ply, ...)
	local words = table.concat({...}, " "):Trim();
	if (not words or words == "") then
		return false, "You must specify a message!";
	end
	ply:Emote(words);
end, "Commands", "<text>", "e.g: <your name> cries a river.", true);

-- A command to whisper in character.
cider.command.add("w", "b", 1, function(ply, ...)
	local words = table.concat({...}, " "):Trim();
	if (not words or words == "") then
		return false, "You must specify a message!";
	end

	-- Print a message to other players within a radius of the player's position.
	cider.chatBox.addInRadius(ply, "whisper", words, ply:GetPos(), GM.Config["Talk Radius"] / 2);
end, "Commands", "<text>", "Whisper to players near you.", true);

-- A command to send an advert to all players.
cider.command.add("advert", "b", 1, function(ply, ...)
	if (ply._NextAdvert > CurTime()) then
		local timeleft = math.ceil(ply._NextAdvert - CurTime());
		if (timeleft > 60) then
			timeleft = string.ToMinutesSeconds(timeleft).." minutes"
		else
			timeleft = timeleft.." second(s)"
		end
		return false,"You must wait "..timeleft.." before using advert again!";
	elseif (not ply:CanAfford(GM.Config['Advert Cost'])) then
		return false, "You need another $" .. (GM.Config['Advert Cost'] - ply.cider._Money) .. "!";
	end
	local words = table.concat({...}, " "):Trim();
	if (not words or words == "") then
		return false, "You must specify a message!";
	end
	ply._NextAdvert = CurTime() + GM.Config["Advert Timeout"]
	-- Print a message to all players.
	cider.chatBox.add(nil, ply, "advert", words);
	ply:GiveMoney(-GM.Config["Advert Cost"]);
	GM:Log(EVENT_EVENT, "%s advertised %q",ply:Name(),words)
end, "Commands", "<text>", "Send an advert to all players ($"..GM.Config["Advert Cost"]..").", true);

-- A command to change your team.
cider.command.add("team", "b", 1, function(ply, identifier)
	local teamdata = cider.team.get(identifier);
	if (not teamdata) then
		return false, "Invalid team!";
	end
	local teamid = teamdata.index;
	if (teamid == ply:Team()) then
		return false, "You are already that team!";
	elseif (team.NumPlayers(teamid) >= teamdata.limit) then
		return false, "That team is full!";
	elseif (not gamemode.Call("PlayerCanJoinTeam", ply, teamid)) then
		return false;
	end
	ply:HolsterAll();
	return ply:JoinTeam(teamid);
end, "Menu Handlers", "<team>", "Change your team.", true);

-- A command to perform inventory action on an item.
cider.command.add("inventory", "b", 2, function(ply, id, action, amount)
	id = string.lower(id);
	action = string.lower(action);
	local item = GM.Items[id];
	if (not item) then
		return false, "Invalid item specified.";
	end
	local holding = ply.cider._Inventory[id]
	if (not holding or holding < 1) then
		return false, "You do not own any " .. item.Plural .."!";
	elseif (action == "destroy") then
		item:Destroy(ply);
	-- START CAR ACTIONS (TODO: find some other way of doing this?)
	elseif (action == "pickup") then
		item:Pickup(ply);
	elseif (action == "sell") then
		item:Sell(ply);
	-- END CAR ACTIONS
	elseif (action == "drop") then
		if (amount == "all") then
			amount = holding;
		else
			amount = tonumber(amount) or 1;
		end
		if (amount > holding) then
			return false, "You don't have that many " .. item.Plural .. "!";
		elseif (amount < 1) then
			return false, "Invalid amount";
		end
		local pos = ply:GetEyeTraceNoCursor().HitPos;
		if (ply:GetPos():Distance(pos) > 255) then
			pos = ply:GetShootPos() + ply:GetAimVector() * 255;
		end
		return item:Drop(ply, pos, amount);
	elseif (action == "use") then
		local time = CurTime();
		if (not ply:IsAdmin()) then -- Admins bypass the item timer
			if ((ply._NextUseItem or 0) > time) then
				return false, "You cannot use another item for " .. math.ceil(ply._NextUseItem - time) .. " more seconds!";
			elseif ((ply._NextUse[id] or 0) > time) then
				return false, "You cannot use another " .. item.Name .. " for " .. math.ceil(ply._NextUse[id]) .. " more seconds!";
			end
		end if (ply:InVehicle() and item.NoVehicles) then
			return false, "You cannot use that item while in a vehicle!";
		elseif (not gamemode.Call("PlayerCanUseItem", ply, id)) then
			return false;
		end if (item.Weapon) then
			ply._NextHolsterWeapon = CurTime() + 1;
		end
		ply._NextUseItem = time + GM.Config['Item Timer'];
		ply._NextUse[id] = time + GM.Config['Item Timer (S)'];
		return item:Use(ply);
	else
		return false, "Invalid action specified!"
	end
end, "Menu Handlers", "<item> <destroy|drop|use> [amount]", "Perform an inventory action on an item.", true);

local function containerHandler(ply, item, action, number)
	local container = ply:GetEyeTraceNoCursor().Entity
	if not (IsValid(container) and cider.container.isContainer(container) and ply:GetPos():Distance( ply:GetEyeTraceNoCursor().HitPos ) <= 128) then
		return false,"That is not a valid container!"
	elseif not gamemode.Call("PlayerCanUseContainer",ply,container) then
		return false,"You cannot use that container!"
	end
	item = item:lower()
	action = action:lower()
	if (action ~= "put" and action ~= "take") then
		return false, "Invalid option: "..action.."!";
	end
	number = math.floor(tonumber(number) or 1);
	if (number < 1) then
		return false, "Invalid amount!";
	elseif not GM.Items[item]  then
		return false,"Invalid item!"
	end
	local cInventory,io,filter = cider.container.getContents(container,ply,true)
	local pInventory = ply.cider._Inventory
	if action == "put" then
		local amount = item == "money" and ply.cider._Money or pInventory[item]
		number = math.abs(tonumber(number) or amount or 0)
		if not (amount and amount > 0 and amount >= number) then
			return false, "You do not have enough items!"
		end
	else
		local amount = cInventory[item]
		number = math.abs(tonumber(number) or amount or 0)
		if not (amount and math.abs(amount) > 0 and math.abs(amount) >= number) then
			return false, "There aren't enough items in the container!"
		elseif amount < 0 then
			return false, "You cannot take that item out!"
		end
	end
	if filter and action == "put" and not filter[item] then
		return false, "You cannot put that item in!"
	end
	do
		local action = action == "put" and CAN_PUT or CAN_TAKE
		if not( action && io == action) then
			return false,"You cannot do that!"
		end
	end
	if number == 0 then return false, "Invalid amount!" end
	if action == "take" then number = -number end
	return cider.container.update(container,item,number,nil,ply)
end

cider.command.add("container", "b", 2, function(ply, ...)
	-- I use a handler because returning a value is so much neater than a pyramid of ifs.
	local res,msg = containerHandler(ply, ...)
	if res then
		local entity = ply:GetEyeTraceNoCursor().Entity
		local contents,io,filter = cider.container.getContents(entity,ply,true)
		local tab = {
			contents = contents,
			meta = {
				io = io,
				filter = filter, -- Only these can be put in here, if nil then ignore, but empty means nothing.
				size = cider.container.getLimit(entity), -- Max space for the container
				entindex = entity:EntIndex(), -- You'll probably want it for something
				name = cider.container.getName(entity) or "Container"
			}
		}
		net.Start("cider_Container_Update")
			net.WriteTable(tab)
		net.Send(ply)
	else
		SendUserMessage("cider_CloseContainerMenu",ply);
	end
	return res,msg
end, "Menu Handlers", "<item> <put|take> <amount>", "Put or take an item from a container", true);


do --isolate vars
	local function conditional(ply,pos)
		return ply:IsValid() and ply:GetPos() == pos;
	end
	local function success(ply,_,class)
		if (not ply:IsValid()) then return end
		ply._Equipping = false;
		local s,f = cider.inventory.update(ply, class, 1);
		if (not s) then
			ply:Emote(GM.Config["Weapon Timers"]["Equip Message"]["Abort"]:format(ply._GenderWord));
			if (f and f ~= "") then
				ply:Notify(f, 1);
			end
			return
		end
		ply:StripWeapon(class);
		GM:Log(EVENT_EVENT, "%s holstered "..ply._GenderWord.." %s.",ply:Name(),GM.Items[class].Name);
		ply:SelectWeapon("cider_hands");
		local weptype = GM.Items[class].WeaponType
		if weptype then
			ply:Emote(GM.Config["Weapon Timers"]["Equip Message"]["Plugh"]:format( weptype, ply._GenderWord ));
		end
	end

	local function failure(ply)
		if (not ply:IsValid()) then return end
		ply:Emote(GM.Config["Weapon Timers"]["Equip Message"]["Abort"]:format(ply._GenderWord));
		ply._Equipping = false;
	end

	-- A command to holster your current weapon.
	cider.command.add("holster", "b", 0, function(ply)
		local weapon = ply:GetActiveWeapon();

		-- Check if they can holster another weapon yet.
		if ( !ply:IsAdmin() and ply._NextHolsterWeapon and ply._NextHolsterWeapon > CurTime() ) then
			return false, "You cannot holster this weapon for "..math.ceil( ply._NextHolsterWeapon - CurTime() ).." second(s)!";
		else
			ply._NextHolsterWeapon = CurTime() + 2;
		end

		-- Check if the weapon is a valid entity.
		if not ( IsValid(weapon) and GM.Items[weapon:GetClass()] ) then
			return false, "This is not a valid weapon!";
		end
		local class = weapon:GetClass();
		if not ( gamemode.Call("PlayerCanHolster", ply, class) ) then
			return false
		end

		ply._Equipping = ply:GetPos()
		local delay = GM.Config["Weapon Timers"]["equiptime"][GM.Items[class].WeaponType or -1] or 0
		if not (delay and delay > 0)then
			success(ply,_,class);
			return true
		end
		ply:Emote(GM.Config["Weapon Timers"]["Equip Message"]["Start"]:format(ply._GenderWord));
	end, "Commands", nil, "Holster your current weapon.");
end

-- A command to drop your current weapon.
cider.command.add("drop", "b", 0, function()
	return false, "Use /holster instead.";
end, "Commands", nil, "Put in for DarkRP players. Do not use.");

-- A command to perform an action on a door.
cider.command.add("door", "b", 1, function(ply, arguments)
	local door = ply:GetEyeTraceNoCursor().Entity
	-- Check if the player is aiming at a door.
	if not( IsValid(door) and cider.entity.isDoor(door) and ply:GetPos():Distance( ply:GetEyeTraceNoCursor().HitPos ) <= 128	) then
		return false,"This is not a valid door!"
	end
	local word = table.remove(arguments,1)
	if cider.entity.isOwned(door) then
		if word == "purchase" then
			return false,"This door is already owned!"
		elseif word == "sell" then
			if cider.entity.getOwner(door) ~= ply or door._Unsellable then
				fail = "You cannot sell this door."
			else
				ply:TakeDoor(door);
				local nahm = cider.entity.getDoorName(door)
				GM:Log(EVENT_EVENT, "%s sold "..ply._GenderWord.." door%s.",ply:Name(),nahm)
			end
		else
			return false,"This method is no longer supported."
		end
		return true
	end
	if (word ~= "purchase") then
		print("'"..word.."'")
		return false,"You cannot do that to this door."
	elseif not hook.Call("PlayerCanOwnDoor",GAMEMODE, ply, door)  then
		return false,""
	end
	local doors = 0;

	-- Loop through the entities in the map.
	--[[
	for k, v in ipairs( ents.GetAll() ) do
		if cider.entity.isDoor(v) and cider.entity.getOwner(v) == player then
			doors = doors + 1;
		end
	end
	--]]
	-- Check if we have already got the maximum doors.
	if not ply:CheckLimit"doors" then--(doors >= GM.Config["Maximum Doors"]) then
		return false
	end
	local cost = GM.Config["Door Cost"];

	-- Check if the player can afford this door.
	if not( ply:CanAfford(cost) ) then
		return false,"You need another $"..cost - ply.cider._Money.."!"
	end
	ply:GiveMoney(-cost);

	-- Get the name from the arguments.
	local name = table.concat(arguments, " "):sub(1, 24);
	if name:find"Sale" or name:find"Nobody" then
		name = ""
	end
	ply:GiveDoor(door, name);
	name = cider.entity.getDoorName(door)
	cider.propprotection.ClearSpawner(door)
	GM:Log(EVENT_EVENT, "%s bought a door called %q.",ply:Name(),name)
end, "Menu Handlers", "<purchase|sell>", "Perform an action on the door you're looking at.");

local entHandler = function(ply, arguments,entity)
	local action = table.remove(arguments,1)
	if action == "name" then
		if not hook.Call("PlayerCanSetEntName",GAMEMODE,ply,entity) then
			return false, "You cannot do that to this!"
		end
		local name = table.concat(arguments," "):sub(1, 24);
		--[[
		name = name:trim()
		if not name or name == "" then
			return false, "You must specify a longer name"
		end
		--]]
		if not name then name = "" end
		if name:lower():find"sale" or name:lower():find"f2" or name:lower():find"press" or name == "Nobody" then
			return false, "Choose a different name."
		end
		local oldname = cider.entity.getName(entity)
		cider.entity.setName(entity,name)
		GM:Log(EVENT_ENTITY, "%s changed "..ply._GenderWord.." %s's name from %q to %q.",ply:Name(),entity._isDoor and "door" or entity:GetNWString("Name","entity"),oldname,name)
		return
	end
	if  not( action == "give" or action == "take" ) then
		return false, "Invalid action '"..action.."' specified!"
	end
	local kind = table.remove(arguments,1)
	local id = table.remove(arguments,1)
	local target
	local name
	if kind == "player" then
		target = player.Get(id)
		name = target:Name()
	elseif kind == "team" then
		target = cider.team.get(id)
		name = target.name
	elseif kind == "gang" and id:find";" then
		target = string.Explode(";",id)
		local a,b = unpack(target)
		a,b =  tonumber(a),tonumber(b)
		name = cider.team.gangs[a][b][1]
	end
	if not target then
		return false, "Invalid target!"
	end
	local word
	if action == "give" then
		if kind == "player" then
			cider.entity.giveAccessPlayer(entity,target)
		elseif kind == "team" then
			cider.entity.giveAccessTeam(entity,target)
		elseif kind == "gang" then
			cider.entity.giveAccessGang(entity,unpack(target))
		end
		word = "%s gave %s access to "..ply._GenderWord.." %s."
	else
		if kind == "player" then
			cider.entity.takeAccessPlayer(entity,target)
		elseif kind == "team" then
			cider.entity.takeAccessTeam(entity,target)
		elseif kind == "gang" then
			cider.entity.takeAccessGang(entity,unpack(target))
		end
		word = "%s removed %s's access from "..ply._GenderWord.." %s."
	end
	GM:Log(EVENT_ENTITY, word,ply:Name(),name,entity._isDoor and "door" or entity:GetNWString("Name","entity"))
end
-- A command to perform an action on an ent
cider.command.add("entity", "b", 2, function(ply, arguments)
	-- The access menu must be updated every action, reguardless of result, so we gotta use a handler for neatness.
	local entity = ply:GetEyeTraceNoCursor().Entity
	if not (IsValid(entity) and cider.entity.isOwnable(entity) and ply:GetPos():Distance( ply:GetEyeTraceNoCursor().HitPos ) <= 128) then
		return false, "That is not a valid entity!"
	elseif cider.entity.getOwner(entity) ~= ply then
		return false, "You do not have access to that!"
	end
	local a,b = entHandler(ply,arguments,entity)
	local detailstable = {}
	local owner = cider.entity.getOwner(entity)
	detailstable.access = table.Copy(entity._Owner.access)
	if owner == ply then
		table.insert(detailstable.access,ply)
		detailstable.owned = {
			sellable = tobool(entity._isDoor and not entity._Unsellable) or nil,
			name = hook.Call("PlayerCanSetEntName",GAMEMODE,ply,entity) and cider.entity.getName(entity) or nil,
		}
	end
	detailstable.owner = cider.entity.getPossessiveName(entity)
	if entity._isDoor then
		detailstable.owner = detailstable.owner.." door"
	else
		detailstable.owner = detailstable.owner.." "..entity:GetNWString("Name","entity")
	end
	net.Start("cider_Access_Update")
		net.WriteTable(detailstable)
	net.Send(ply)
	return a,b
end, "Menu Handlers", "<give|take> <ID> <type> or <name> <mynamehere>", "Perform an action on the entity you're looking at")
-- A command to manufacture an item.
cider.command.add("manufacture", "b", 1, function(ply, arguments)
	local item = GM:GetItem(arguments[1]);

	-- Check if the item exists.
	if (item) then
		if (item.Category) then
			if !table.HasValue(cider.team.query(ply:Team(),"canmake",{}), item.Category) then
				return false, cider.team.query(ply:Team(),"name","Your team's member").."s cannot manufacture "..GM:GetCategory(item.Category).Name.."!";
			end
		end
		-- Check if they can manufacture this item yet.
		if ( !ply:IsAdmin() and ply._NextManufactureItem and ply._NextManufactureItem > CurTime() ) then
			return false, "You cannot manufacture another item for "..math.ceil( ply._NextManufactureItem - CurTime() ).." second(s)!";
		else
			ply._NextManufactureItem = CurTime() + (5 * item.Batch);
		end

		if ( ply:CanAfford(item.Cost * item.Batch) ) then
			if (item.canManufacture and not item:canManufacture(ply)) then return; end
			-- Take the cost the from player.
			ply:GiveMoney(-(item.Cost * item.Batch) );

			-- Get a trace line from the player's eye position.
			local trace = ply:GetEyeTraceNoCursor();
			local entity = item:Make(trace.HitPos + Vector(0,0,16),item.Batch );
			if (item.onManufacture) then item:onManufacture(ply, entity, amount); end
			cider.propprotection.PlayerMakePropOwner(entity,ply,true);
			local text = ""
			-- Check if the item comes as a batch.
			if (item.Batch > 1) then
				text = item.Batch.." "..item.Plural.."."
			else
				text = "a "..item.Name.."."
			end
			ply:Notify("You manufactured "..text)
			GM:Log(EVENT_EVENT, "%s manufactured %s",ply:Name(),text)
		else
			local amount = (item.Cost * item.Batch) - ply.cider._Money;

			-- Print a message to the player telling them how much they need.
			return false, "You need another $"..amount.."!";
		end
	else
		return false, "This is not a valid item!";
	end
end, "Menu Handlers", "<item>", "Manufacture an item (usually a shipment).");

-- A command to warrant a player.
cider.command.add("warrant", "b", 1, function(ply, arguments)
	local target = player.Get(arguments[1])

	-- Get the class of the warrant.
	local class = string.lower(arguments[2] or "");

	-- Check if a second argument was specified.
	if (class == "search" or class == "arrest") then
		if (target) then
			if ( target:Alive() ) then
				if (target._Warranted ~= class) then
					if (!target.cider._Arrested) then
						if (CurTime() > target._CannotBeWarranted) then
							if ( hook.Call("PlayerCanWarrant",GAMEMODE, ply, target, class) ) then
								hook.Call("PlayerWarrant",GAMEMODE, ply, target, class);

								-- Warrant the player.
								target:Warrant(class);
							end
						else
							return false, target:Name().." has only just spawned!";
						end
					else
						return false, target:Name().." is already arrested!";
					end
				else
					if (class == "search") then
						return false, target:Name().." is already warranted for a search!";
					elseif (class == "arrest") then
						return false, target:Name().." is already warranted for an arrest!";
					end
				end
			else
				return false, target:Name().." is dead and cannot be warranted!";
			end
		else
			return false, arguments[1].." is not a valid player!"
		end
	else
		return false, "Invalid warrant type. Use 'search' or 'arrest'"
	end
end, "Commands", "<player> <search|arrest>", "Warrant a player.");

-- A command to unwarrant a player.
cider.command.add("unwarrant", "b", 1, function(ply, arguments)
	local target = player.Get(arguments[1])

	-- Check to see if we got a valid target.
	if (target) then
		if (target._Warranted) then
			if ( hook.Call("PlayerCanUnwarrant",GAMEMODE, ply, target) ) then
				hook.Call("PlayerUnwarrant",GAMEMODE, ply, target);

				-- Warrant the player.
				target:UnWarrant();
			end
		else
			return false, target:Name().." does not have a warrant!"
		end
	else
		return false, arguments[1].." is not a valid player!"
	end
end, "Commands", "<player>", "Unwarrant a player.");

do -- Reduce the upvalues poluting the area.
	local function conditional(ply, pos)
		return IsValid(ply) and ply:GetPos() == pos;
	end


	local function failure(ply)
		ply:SetCSVar(CLASS_LONG, "_GoToSleepTime");
	end
	-- A command to sleep or wake up.
	cider.command.add("sleep", "b", 0, function(ply)
		if (ply._Sleeping and ply:KnockedOut()) then
			return ply:WakeUp();
		end
		local sleeppos = ply:GetPos()
		timer.Simple(GM.Config["Sleep Waiting Time"], function()
			if (ply:GetPos() == sleeppos) then
				ply:KnockOut();
				GM:Log(EVENT_EVENT, "%s went to sleep.", ply:Name());
				ply._Sleeping = true;
				ply:Emote("slumps to the floor, asleep.");
				ply:SetCSVar(CLASS_LONG, "_GoToSleepTime");
			end
		end)


	end, "Commands", nil, "Go to sleep or wake up from sleeping.");
end
-- A command to send a message to all players on the same team.
cider.command.add("radio", "b", 1, function(ply, arguments)
	local text = table.concat(arguments, " ");

	-- Say a message as a radio broadcast.
	ply:SayRadio(text);
end, "Commands", "<text>", "Send a message to all players on your team.");

cider.command.add("trip", "b", 0, function(ply,arguments)
	if ply:GetVelocity() == Vector(0,0,0) then
		return false,"You must be moving to trip!"
	elseif ply:InVehicle() then
		return false,"There is nothing to trip on in here!";
	end
	ply:KnockOut(5)
	ply._Tripped = true
	cider.chatBox.addInRadius(ply, "me", "trips and falls heavily to the ground.", ply:GetPos(), GM.Config["Talk Radius"]);
	GM:Log(EVENT_EVENT,"%s fell over.",ply:GetName())
end, "Commands", "", [[Fall over while walking. (bind key "say /trip")]]);

cider.command.add("fallover", "b", 0, function(ply,arguments)
	if not (ply:KnockedOut() or ply:InVehicle()) then
		ply:KnockOut(5)
		ply._Tripped = true
		cider.chatBox.addInRadius(ply, "me", "slumps to the ground.", ply:GetPos(), GM.Config["Talk Radius"]);
		GM:Log(EVENT_EVENT,"%s fell over.",ply:GetName())
	end
end, "Commands", "", "Fall over.");
cider.command.add("mutiny","b",1,function(ply,arguments)
	local target = player.Get( arguments[1] ) or nil
	if not (IsValid(target) and target:IsPlayer()) then
		return false, arguments[1].." is not a valid player!"
	end
	local pteam,tteam = ply:Team(),target:Team()
	if 	cider.team.getGroupByTeam(pteam)	~=	cider.team.getGroupByTeam	(tteam)		or
		cider.team.getGang		 (pteam) 	~=	cider.team.getGang			(tteam)		or
		cider.team.getGang		 (tteam)	==	nil										or
		cider.team.getGroupLevel (pteam)	>=	cider.team.getGroupLevel	(tteam)		or
		not										cider.team.hasAccessGroup	(tteam,"D")	then
			return false,"You cannot mutiny against this person"
	end
	target._Depositions = target._Depositions or {}
	if target._Depositions [ply:UniqueID()] then
		return false,"You have already tried to mutiny against your leader!"
	else
		target._Depositions[ply:UniqueID()] = ply
	end
	for ID,ply in pairs(target._Depositions) do
		if IsValid(ply) then
			local pteam = ply:Team()
			if 	cider.team.getGroupByTeam(pteam)	~=	cider.team.getGroupByTeam(tteam)	or
				cider.team.getGang		 (pteam) 	~=	cider.team.getGang		 (tteam)	or
				cider.team.getGroupLevel (pteam)	>=	cider.team.getGroupLevel (tteam)	then
					target._Depositions	 [ID]		 =	nil
			end
		else
			target._Depositions[ID] = nil
		end
	end
	local count	= table.Count(target._Depositions)
	local num	=  math.floor( table.Count( cider.team.getGangMembers( cider.team.getGroupByTeam(tteam), cider.team.getGang(tteam) ) ) * GM.Config["Mutiny Percentage"])
	if  num < GM.Config["Minimum to mutiny"] then
		num = GM.Config["Minimum to mutiny"]
	end
	if count < num then
		ply:Notify("Not enough of the gang agrees with you yet to do anything, but they acknowledge your thoughts...")
		GM:Log(EVENT_EVENT,"%s voted to mutiny against %s. %i/%i",ply:Name(),target:Name(),count,num)
		return
	end
	target:Notify("Your gang has overthrown you!",1)
	target:Demote()
	player.NotifyAll("%s was overthrown as leader.",nil,target:Name())
end, "Commands","<player>","Try to start a mutiny against your leader")

-- A command to give Donator status to a player.
cider.command.add("donator", "s", 1, function(ply, arguments)
	local target = player.Get( arguments[1] )

	-- Calculate the days that the player will be given Donator status for.
	local days = math.ceil(tonumber( arguments[2] ) or 30);

	-- Check if we got a valid target.
	if not (target) then
		return false, arguments[1].." is not a valid player!"
	end
		target.cider._Donator = os.time() + (86400 * days);

		-- Give them their access and save their data.
		target:GiveAccess("tpew");
		target:SaveData();

		-- Give them the tool and the physics gun.
		target:Give("gmod_tool");
		target:Give("weapon_physgun");

		-- Set some Donator only player variables.
		target._SpawnTime = target._SpawnTime / 2;
		target._ArrestTime = target._ArrestTime / 2;
		target._KnockOutTime = target._KnockOutTime / 2;

		-- Print a message to all players about this player getting Donator status.
		player.NotifyAll("%s has given Donator status to %s for %i day(s).", nil, ply:Name(), target:Name(), days);
end, "Super Admin Commands", "<player> <days|none>", "Give Donator status to a player.");

-- A command to change your clan.
cider.command.add("details", "b", 0, function(ply, arguments)
	local text = table.concat(arguments, " ")
	--[[ Check the length of the arguments.
	if ( string.len(text) > 64 ) then
		return false,"Your details can be a maximum of 64 characters!"
	end--]]
	text = text:sub(1,64):Trim()
	if (text == "" or string.lower(text) == "none") then
		ply._Description = "";

		-- Print a message to the player.
		ply:Notify("You have set your details to nothing.");
		GM:Log(EVENT_EVENT, "%s changed "..ply._GenderWord.." details to %q.",ply:Name(),"nothing")
	else
		ply._Description = text;

		-- Print a message to the player.
		ply:Notify("You have changed your details to '"..text.."'.");
		GM:Log(EVENT_EVENT, "%s changed "..ply._GenderWord.." details to %q.",ply:Name(),text)
	end
	ply:SetNWString("Details", ply._Description);
end, "Commands", "<text|none>", "Change your details or make them blank.");


cider.command.add("action","b",1,function(ply,arguments)
	local text = table.concat(arguments, " ");

	-- Check if the there is enough text.
	if (text == "") then
		return false,"You did not specify enough text!"
	end
	cider.chatBox.addInRadius(ply, "action", text, ply:GetPos(), GM.Config["Talk Radius"]);
end, "Commands", "<text>", "Add an environmental emote")

cider.command.add("globalaction","m",1,function(ply,arguments)
	local text = table.concat(arguments, " ");

	-- Check if the there is enough text.
	if (text == "") then
		return false,"You did not specify enough text!"
	end
	cider.chatBox.add(nil,ply, "action", text);
end, "Moderator Commands", "<text>","Add a global environmental emote")

cider.command.add("ooc","b",1,function(ply,arguments)
	local text = table.concat(arguments," ")
	if not text or text == "" then return false,"wat" end
	if ( hook.Call("PlayerCanSayOOC",GAMEMODE, ply, text) ) then
		cider.chatBox.add(nil,ply, "ooc",text);
		--GM:Log(EVENT_TALKING,"(OOC) %s: %s",player:Name(),text)
	else
		return false
	end
end, "Commands", "<text>", "Say something out of character to everyone. (shortcut: //<text>)")

cider.command.add("looc","b",1,function(ply,arguments)
	local text = table.concat(arguments," ")
	if not text or text == "" then return false,"wat" end
	if ( hook.Call("PlayerCanSayLOOC",GAMEMODE, ply, text) ) then
		cider.chatBox.addInRadius(ply, "looc",text , ply:GetPos(), GM.Config["Talk Radius"]);
		--GM:Log(EVENT_TALKING,"(Local OOC) %s: %s",player:Name(),text)
	else
		return false
	end
end, "Commands", "<text>", "Say something out of character to the people around you. (shortcut: .//<text>)")


-- Set an ent's master
cider.command.add("setmaster","s",1,function(ply, masterID)
	local entity = ply:GetEyeTraceNoCursor().Entity
	local master = Entity(masterID)
	if not (IsValid(entity) and cider.entity.isOwnable(entity)) then
		return false,"That is not a valid entity!"
	elseif not ((IsValid(master) and cider.entity.isOwnable(master)) or masterID == 0) then
		return false,"That is not a valid entity ID!"
	end
	if masterID == 0 then
		master = NULL
		GM:Log(EVENT_ENTITY, "%s unset a %s's master",ply:Name(),entity._isDoor and "door" or entity:GetNWString("Name","entity"))
	else
		GM:Log(EVENT_ENTITY, "%s set a %s's master",ply:Name(),entity._isDoor and "door" or entity:GetNWString("Name","entity"))
	end
	cider.entity.setMaster(entity,master)
	hook.Call("EntityMasterSet",GAMEMODE,entity,master)
end, "Super Admin Commands", "<ID of master|0>", "Set/Unset an ent's master",true)
-- Seal a door
cider.command.add("seal","s",0,function(ply,unseal)
	local entity = ply:GetEyeTraceNoCursor().Entity
	if not (IsValid(entity) and cider.entity.isOwnable(entity)) then
		return false,"That is not a valid entity!"
	end
	if unseal then
		entity._Sealed = false

		if (bit.band(entity:GetDTInt(3) , OBJ_SEALED) == OBJ_SEALED) then
			entity:SetDTInt(3, entity:GetDTInt(3) -  OBJ_SEALED);
		end
		hook.Call("EntitySealed",GAMEMODE,entity,true)
		GM:Log(EVENT_ENTITY, "%s unsealed a %s,",ply:Name(),entity._isDoor and "door" or entity:GetNWString("Name","entity"))
	else
		entity._Sealed = true
		if (bit.band(entity:GetDTInt(3) , OBJ_SEALED) ~= OBJ_SEALED) then
			entity:SetDTInt(3, entity:GetDTInt(3) +  OBJ_SEALED);
		end
		hook.Call("EntitySealed",GAMEMODE,entity)
		GM:Log(EVENT_ENTITY, "%s sealed a %s,",ply:Name(),entity._isDoor and "door" or entity:GetNWString("Name","entity"))
	end
end, "Super Admin Commands", "[unseal]", "Seal/Unseal an entity so it cannot be used",true)

cider.command.add("setname","s",1,function(ply,arguments)
	local entity = ply:GetEyeTraceNoCursor().Entity
	if not (IsValid(entity) and cider.entity.isOwnable(entity) and entity._isDoor) then
		return false,"That is not a valid door!"
	end
	local words = table.concat(arguments," "):Trim():sub(1,25)
	if not words or words == "" then
		words = ""
	end
	entity:SetNWString("Name",words)
	GM:Log(EVENT_ENTITY, "%s changed a door's name to %q.",ply:Name(),words)
	hook.Call("EntityNameSet",GAMEMODE,entity,words)
end, "Super Admin Commands", "<name>", "Set the name of a door")

cider.command.add("setowner","s",1,function(ply,kind,id,gangid)
	local entity = ply:GetEyeTraceNoCursor().Entity
	if not (IsValid(entity) and cider.entity.isOwnable(entity) and entity._isDoor) then
		return false,"That is not a valid door!"
	end
	entity = cider.entity.getMaster(entity) or entity
	local target
	local name
	if kind == "player" then
		target = player.Get(id)
		if not target then return false, "Invalid player specified!" end
		cider.entity.setOwnerPlayer(entity,target)
		name = target:Name()
	elseif kind == "team" then
		target = cider.team.get(id)
		if not target then return false, "Invalid team specified!" end
		name = target.name
		target = target.index
		cider.entity.setOwnerTeam(entity,target)
	elseif kind == "gang" and gangid then
		print("gange")
		id = tonumber(id);
		gangid = tonumber(gangid);
		if not (cider.team.gangs[id] and cider.team.gangs[id][gangid]) then
			return false,"Invalid gang"
		end
		cider.entity.setOwnerGang(entity,id,gangid)
		name = cider.team.gangs[id][gangid][1]
		target = {id,gangid};
	elseif kind == "remove" then
		cider.entity.clearData(entity,true)
		target = ""
	end
	if not target then
		return false, "Invalid target!"
	end
	cider.entity.updateSlaves(entity)
	hook.Call("EntityOwnerSet",GAMEMODE,entity,kind,target)
	GM:Log(EVENT_ENTITY, "%s gave ownership of %s to %s.",ply:Name(),entity._isDoor and "door" or entity:GetNWString("Name","entity"),name)
end, "Super Admin Commands", "<player|team|gang|remove> [identifier] [gang identifier]", "Set the owner of a door",true)

cider.command.add("a","a",1,function(ply,arguments)
	local text = table.concat(arguments," ")
	if not text or text == "" then return false,"wat" end
	local rp = RecipientFilter()
	for _,ply in pairs(player.GetAll()) do
		if (ply:IsAdmin()) then
			rp:AddPlayer(ply)
		end
	end
	cider.chatBox.add(rp, ply, "achat", text);
end, "Admin Commands", "<text>", "Say something only to the other admins")

cider.command.add("m","m",1,function(ply,arguments)
	local text = table.concat(arguments," ")
	if not text or text == "" then return false,"wat" end
	local rp = RecipientFilter()
	for _,ply in pairs(player.GetAll()) do
		if (ply:IsModerator()) then
			rp:AddPlayer(ply)
		end
	end
	cider.chatBox.add(rp, ply, "mchat", text);
end, "Moderator Commands", "<text>", "Say something only to the other admins and moderators")