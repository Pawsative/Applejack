--[[
	~ Flashlight Plugin / CL ~
	~ Applejack ~
--]]

include("sh_init.lua");

-- Called when the bottom bars should be drawn.
function PLUGIN:DrawBottomBars(bar)
	local flashlight = LocalPlayer()._Flashlight or 100;
	if (flashlight < 100 and flashlight ~= -1) then
		GAMEMODE:DrawBar("Default", bar.x, bar.y, bar.width, bar.height, Color(225, 75, 200, 200), "Flashlight: "..flashlight.."%", 100, flashlight, bar);
	end
end