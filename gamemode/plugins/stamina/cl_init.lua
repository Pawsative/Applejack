--[[
	~ Stamina Plugin / CL ~
	~ Applejack ~
--]]

-- Include the shared file.
include("sh_init.lua");

-- Called when the bottom bars should be drawn.
function PLUGIN:DrawBottomBars(bar)
	local stamina = LocalPlayer()._Stamina or 100;

	-- Check if the stamina is smaller than 100.
	if (stamina < 100) then
		GAMEMODE:DrawBar("Default", bar.x, bar.y, bar.width, bar.height, Color(50, 50, 255, 200), "Stamina: "..stamina, 100, stamina, bar);
	end
end

-- Called when the local player presses a bind.
function PLUGIN:PlayerBindPress(player, bind, pressed)
	local stamina = LocalPlayer()._Stamina or 100;

	-- Check if the stamina is smaller than 10.
	if not player:KnockedOut() and player:GetNWBool("Exausted") and bind:find("+jump") then
		return true;
	end
end