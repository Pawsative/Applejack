--[[
	~ Hunger Plugin / CL ~
	~ Applejack ~
--]]

include("sh_init.lua");

-- Called when the bottom bars should be drawn.
local mahbar = Color(50, 255, 50, 200)
function PLUGIN:DrawBottomBars(bar)
	local hunger = LocalPlayer()._Hunger or 0;
    hunger = 100 - hunger
	-- Draw the stamina bar.
	//if hunger < 25 then return end
	GAMEMODE:DrawBar("Default", bar.x, bar.y, bar.width, bar.height, mahbar, "Hunger: "..hunger, 100, hunger, bar);
end