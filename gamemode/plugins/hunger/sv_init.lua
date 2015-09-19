--[[
	~ Hunger Plugin / SV ~
	~ Applejack ~
--]]

-- Include the shared file and add it to the client download list.
includecs("sh_init.lua");

-- Called when a player initially spawns.
function PLUGIN:PlayerInitialSpawn(player)
	player._Hunger = {};
end

-- Called when a player has initialized.
function PLUGIN:PlayerInitialized(player)
	player._Hunger.lastTeam = nil;
	player._Hunger.suicided = false;
end

-- Called when a player spawns.
--[[
Changelog:
29/1/10: Set the player's health to 50 on hunger death.
]]
function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeTeam)
	if (not lightSpawn) then
		if ((player._Hunger.suicided or player._Hunger.amount == 100)
		and player._Hunger.lastTeam and player:Team() == player._Hunger.lastTeam) then
			player._Hunger.amount = 50;
			player:SetHealth(100);
		else
			player._Hunger.amount = 0;
		end
	end

	-- Set the last team.
	player._Hunger.lastTeam = player:Team();
	player._Hunger.suicided = false;
end

-- Called when a player dies.
function PLUGIN:PlayerDeath(player, inflictor, killer)
	if (player == killer or not killer:IsPlayer() ) then
		player._Hunger.suicided = true;
	end
end

-- Called every second that a player is on the server.
--[[
Changelog:
29/1/10: Made it not display the hunger bar when you are tied/arrested.
]]
function PLUGIN:PlayerSecond(player)
	if (not (player:Alive() and not (player:Arrested() or player:Tied()))) then
		player:SetCSVar(CLASS_LONG, "_Hunger",0);
		return
	end
	adition = 1/(GM.Config["Hunger Minutes"]*0.6);
	player._Hunger.amount = math.Clamp(player._Hunger.amount + adition, 0, 100);

	-- Set it so that we can get the player's hunger client side.
	player:SetCSVar(CLASS_LONG, "_Hunger", math.Round(player._Hunger.amount));
	local damage = GM.Config["Hunger Damage"];
	-- Check the player's hunger to see if it's at it's maximum.
	if (not (player._Hunger.amount == 100 and (player:Health() > damage or GM.Config["Hunger Death"] or player:KnockedOut()))) then
		return
	end
	local world = game.GetWorldEntity();

	-- Check if the player is knocked out.
	if (player:KnockedOut() and IsValid(player.ragdoll.entity)) then
		player.ragdoll.entity:TakeDamage(damage,world,player);
	elseif (player:InVehicle()) then
		player:TakeDamage(damage*2,world, player); --cars are dicks
	else
		player:TakeDamage(damage,world, player);
	end
end