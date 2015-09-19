--[[
	~ Serversie Player Library ~
	~ Applejack ~
--]]

local player,g_player,umsg,pairs,ipairs,string,timer,IsValid,table = player,g_player,umsg,pairs,ipairs,string,timer,IsValid,table

---
-- Allows plugins to add their own flags and functions to HasAccess without resorting to dirty hacks.
-- @usage GM.FlagFunctions[flag] = function(ply) return true end;
GM.FlagFunctions = {
	s = function(ply) return ply:IsSuperAdmin() end;
	a = function(ply) return ply:IsAdmin() end;
	m = function(ply) return ply:IsModerator() end;
}

---
-- Known SQL fields that should not be loaded into the player's .cider table.
-- @usage player.loadIgnoreKeys["_Key"] = true
player.loadIgnoreKeys = {
	_RPname = true;
	_Key = true;
	_SteamID = true;
	_UniqueID = true;
	_Name = true;
}

---
-- Known SQL fields that should be treated in a specific way
-- (cleaner to use this than let the auto take care of it)
-- Acceptable words: "function", "GLON", "number", "bool" and "string"
-- @usage player.loadKnownKeys["_Inventory"] = "function"
player.loadKnownKeys = {
	_Inventory	= "function";
	_Blacklist	= "GLON";
	_Misc		= "GLON";
	_Donator	= "number";
	_Money		= "number";
	_RPName	    = "string";
	_Clan		= "string";
	_Description = "string";
	_Access		= "string";
};

---
-- SQL fields that require special functions applied to them. (Currently only inventory, there used to be others.)
-- @usage player.loadFunctions["_Inventory"] = function(ply, data) ply._Inventory = data end
player.loadFunctions = {
	_Inventory =  function(ply, data)
		string.gsub(data, "([^;%s]+): ([0-9]+)", function(item, amount)
			if (GM.Items[item]) then
				cider.inventory.update(ply, item, tonumber(amount), true);
			else
				ErrorNoHalt("Ignoring " .. amount .. " nonexistant '" .. item .. "' items in " .. ply:Name() .. "'s inventory.");
			end
		end)
	end;
	_Arrested = function(ply, data)
		if (tobool(data)) then
			ply:Arrest();
		end
	end;
};

---
-- Keys in the player's .cider table that shouldn't be saved in to the SQL database
player.saveIgnoreKeys = {
}

---
-- Keys in the player's .cider table that need a custom function run on them
player.saveFunctions = {
	_Inventory = function(ply, data)
		local str = "";
		for item, amt in pairs(data) do
			str = str .. item .. ": " .. amt .. "; ";
		end
		return str:sub(1, -3);
	end;
}

---
-- Some keys in the player's cider table require escaping
player.saveEscapeKeys = {
	_Description = true;
	_RPName = true;
	_Name = true;
	_Clan = true;
}

---
-- Gets a player by a part of their name, or their steamID, or their UniqueID, or their UserID.
-- Will provide the player with the shortest name that matches the key. That way a search for 'lex' will return '||VM|| Lexi' even if 'LeXiCaL1ty{GT}' is available.
-- @param id An ID to search for the player by.
-- @return A player if one is found, nil otherwise.
function player.Get(id)
	local res, len, name, num, pname;
	name = string.lower(id);
	num = tonumber(id);
	for _,ply in pairs(player.GetAll()) do
		pname = ply:Name():lower();
		if ((num and ply:UserID() == num or ply:UniqueID() == num) or ply:SteamID() == id) then
			return ply;
		elseif (pname:find(name)) then
			local lon = pname:len();
			if (res) then
				if (lon < len) then
					res = ply;
					len = lon;
				end
			else
				res = ply;
				len = lon;
			end
		end
	end
	return res;
end

---
-- Notifies every player on the server that has the specified access.
-- @param access The access string to search for
-- @param message The message to display
-- @param level The notification level. Nil or unspecified = chat message. 0 = Water drip. 1 = Failure buzzer. 2 = 'Bip' Notification. 3 = 'Tic' Notification. (Used by the cleanup)
function player.NotifyByAccess(access, message, class)
	for _, ply in pairs(player.GetAll()) do
		if (ply:HasAccess(access)) then
			ply:Notify(message, class);
		end
	end
end

---
-- Notifies every player on the server and logs a public event
-- @see GM:Log
-- @param message The message to display. (Use same form as GM:Log)
-- @param level The notification level. Nil or unspecified = chat message. 0 = Water drip. 1 = Failure buzzer. 2 = 'Bip' Notification. 3 = 'Tic' Notification. (Used by the cleanup)
-- @param ... A series of strings to be applied to the message string via string.format().
function player.NotifyAll(message, level, ...)
	local msg = message:format(...);
	for _, ply in pairs(player.GetAll()) do
		ply:Notify(msg, level);
	end
	GM:Log(EVENT_PUBLICEVENT, message, ...);
end

local function saveallTimer(playerlist)
	local ply;
	for i = 1, 5 do
		ply = table.remove(playerlist);
		if (IsValid(ply)) then
			ply:SaveData();
		end
	end
end

---
-- Saves every player on the server's data. Unless told otherwise, this will do 5 per frame until they're all done, to ease server load.
-- @param now Process every player's profile right now - used when time is urgent.
function player.SaveAll(now)
	if (now) then
		for _, ply in pairs(player.GetAll()) do
			ply:SaveData();
		end
		return;
	end
	local plys = player.GetAll();
	saveallTimer(plys);
	if (#plys == 0) then return end
	timer.Create("Saving All Player Data", math.ceil(#plys / 5), 0, function()
		saveallTimer(plys);
	end)
end



--[[
	Functions for the timer from now on only
--]]
local autosendvars = {};
---
-- Adds a CS var that should be updated every second.
-- @param type What TYPE_ enum the variable is
-- @param name The name of the variable (Value sent will be ply[name])
function player.AddAutoCSVar(type, name)
	autosendvars[name] = type;
end

timer.Create("PlayerSaveTimer", 10, 0, function()
	player.SaveAll()
end)

local trup, trdown = Vector(0,0,10), Vector(0,0,-2147483648);
local nextsec = CurTime();
timer.Create("Player Update Timer", 0.1, 0, function()
	local second = nextsec <= CurTime();
	if (second) then
		nextsec = CurTime() + 1;
	end
	for _, ply in pairs(player.GetAll()) do
		if (ply._Initialized and ply._UpdateData) then
			gamemode.Call("PlayerTenthSecond", ply);
			if (second) then
				gamemode.Call("PlayerSecond", ply);
				-- Check if the player is stuck in the world or over open sky (stuck behind world) and disable them.
				if (ply:Alive() and not ply:KnockedOut() and ply:GetMoveType() == MOVETYPE_WALK  and (not ply:IsInWorld() or util.QuickTrace(ply:GetPos() + trup, trdown, ply).HitSky)) then
					ply._StuckInWorld = true;
				else
					ply._StuckInWorld = false;
				end
				-- Kick idles
				if (not ply:IsBot() and ply._IdleKick < CurTime()) then
					ply:Kick("AFK for " .. string.ToMinutesSeconds(GM.Config["Autokick time"]).." minutes.");
				end
				-- Disable paracetamol if yer over 50HP
				if (ply:Health() > 50) then
					ply._HideHealthEffects = false;
				end
				-- Give sleeping people a health regen.
				if (ply._Sleeping and ply:Health() < 100 and ply:Alive()) then
					-- It seems the game doesn't like fractions. Let's make this only happen once every 2 seconds then.
					if (not ply._Healthtick) then
						ply._Healthtick = true;
					else
						ply._Healthtick = false;
						ply:SetHealth(ply:Health() + 1);
						ply.ragdoll.health = ply:Health();
					end
				end

				for k,v in pairs(autosendvars) do
					ply:SetCSVar(v, k, ply[k]);
				end
				-- And the one CSVar that needs manual doin
				ply:SetCSVar(CLASS_LONG, "_Money", ply.cider._Money);
			end
		end
	end
end);

hook.Add("LibrariesLoaded", "Player Library's LibrariesLoaded", function()
	player.AddAutoCSVar(CLASS_STRING, "_NextSpawnGender");
	player.AddAutoCSVar(CLASS_STRING, "_Gender");
	player.AddAutoCSVar(CLASS_FLOAT, "_ScaleDamage");
	player.AddAutoCSVar(CLASS_BOOL, "_HideHealthEffects");
	player.AddAutoCSVar(CLASS_BOOL, "_Sleeping");
	player.AddAutoCSVar(CLASS_BOOL, "_GPS");
	player.AddAutoCSVar(CLASS_BOOL, "_beTied");
	player.AddAutoCSVar(CLASS_BOOL, "_Stunned");
	player.AddAutoCSVar(CLASS_BOOL, "_StuckInWorld");
	player.AddAutoCSVar(CLASS_LONG, "_JobTimeLimit");
	player.AddAutoCSVar(CLASS_LONG, "_JobTimeExpire");
	player.AddAutoCSVar(CLASS_LONG, "_Salary");
end);