--[[
	~ Flashlight Plugin / SV ~
	~ Applejack ~
--]]

includecs("sh_init.lua");

-- Called when a player spawns.
function PLUGIN:PostPlayerSpawn(player, light)
	if (not light) then
		player._Flashlight = 100;
	end
end

-- Called when a player switches their flashlight on or off.
function PLUGIN:PlayerSwitchFlashlight(player, on)
	if (on and player._Flashlight < 10 and player._Flashlight ~= -1) then
		return false;
	end
end

-- Called every tenth of a second that a player is on the server.
function PLUGIN:PlayerTenthSecond(player)
	if (not (player:Arrested() or player:Tied()) and player._Flashlight ~= -1) then
		if (player:FlashlightIsOn()) then
			player._Flashlight = player._Flashlight - 0.75;
			if (player._Flashlight < 0) then
				player:Flashlight(false);
			end
		else
			player._Flashlight = math.min(player._Flashlight + 0.5, 100);
		end
	end
	player:SetCSVar(CLASS_LONG, "_Flashlight", math.floor(player._Flashlight));
end