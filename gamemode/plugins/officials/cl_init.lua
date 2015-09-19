--[[
	~ Officials Plugin / CL ~
	~ Applejack ~
--]]

-- Include the shared file.
include("sh_init.lua");

local arrestwarrant = Color(255, 50, 50, 255)
local spawnimmunity = Color(150, 255, 75, 255)

local function drawinfo(x, y, width, height)
	return x - width - 8, y;
end
-- Called when the top text should be drawn.
function PLUGIN:DrawTopText(text)
	if (GetGlobalBool("lockdown")) then
		text.y = GAMEMODE:DrawInformation("A lockdown is in progress. Please return to your home.", "ChatFont", text.x, text.y, arrestwarrant, 255, true, drawinfo);
	end
	
	-- Check if the player is the Mayor.
	if (LocalPlayer():Team() ~= TEAM_MAYOR) then
		return
	end
	local spawntime = math.floor((LocalPlayer()._SpawnImmunityTime or 0) - CurTime());
	if (spawntime > 0) then
		text.y = GAMEMODE:DrawInformation("You have spawn immunity for "..spawntime.." second(s).", "ChatFont", text.x, text.y, spawnimmunity, 255, true, drawinfo);
	end
end