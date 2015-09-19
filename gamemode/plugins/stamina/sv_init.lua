--[[
	~ Stamina Plugin / SV ~
	~ Applejack ~
--]]

-- Include the shared file and add it to the client download list.
includecs("sh_init.lua");

-- Called when a player spawns.
function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeTeam)
	if (not lightSpawn) then
		player._Stamina = 100;
	end
end

-- Called when a player presses a key.
function PLUGIN:KeyPress(player, key)
	if not (player:Arrested() or player:Tied() or player:GetNWBool"cider_Exausted") then
		if (player:Alive() and !player:KnockedOut()) then
			if (player:IsOnGround() and key == IN_JUMP) then
				player._Stamina = math.Clamp(player._Stamina - 5, 0, 100);
			end
		end
	end
	
	AntiJump()
end

-- Called every tenth of a second that a player is on the server.
function PLUGIN:PlayerTenthSecond(player)
	if (not (player:Arrested() or player:Tied() or player._HoldingEnt or player:GetMoveType() == MOVETYPE_NOCLIP)) then
		if (player:KeyDown(IN_SPEED) and player:Alive() and !player:KnockedOut() and not player:GetNWBool"Exausted"
		and player:GetVelocity():Length() > 0) then
			if (player:Health() < 50) then
				player._Stamina = math.Clamp(player._Stamina - (GM.Config["Stamina Drain"] + ( ( 50 - player:Health() ) * 0.05 ) ), 0, 100);
			else
				player._Stamina = math.Clamp(player._Stamina - GM.Config["Stamina Drain"], 0, 100);
			end
		else
			if (player:Health() < 50) then
				player._Stamina = math.Clamp(player._Stamina + (GM.Config["Stamina Restore"] - ( ( 50 - player:Health() ) * 0.0025 ) ), 0, 100);
			else
				player._Stamina = math.Clamp(player._Stamina + GM.Config["Stamina Restore"], 0, 100);
			end
		end
		
		-- Check the player's stamina to see if it's at it's maximum.
		if (player._Stamina <= 1) then
		--	player:Incapacitate();
		--	player:SetNWBool("Exausted", true)
		elseif player._Stamina <= 50 and player:GetNWBool"Exausted" then
			-- If you get exausted, it takes a while to wear off. ;)
		else
			local r= player._Stamina / 100
			player:SetRunSpeed( (GM.Config["Run Speed"] - GM.Config["Walk Speed"]) * r + GM.Config["Walk Speed"]);
			player:SetWalkSpeed( (GM.Config["Walk Speed"] - GM.Config["Incapacitated Speed"]) * r + GM.Config["Incapacitated Speed"]);
		--	player:SetNWBool("Exausted", false)
		end
	end
	
	
	-- Set it so that we can get the player's stamina client side.
	player:SetCSVar(CLASS_LONG, "_Stamina", math.Round(player._Stamina) );
end

function PLUGIN:PlayerCanBeRecapacitated(ply)
	if (ply:GetNWBool("Exausted")) then
		return false;
	end
end;