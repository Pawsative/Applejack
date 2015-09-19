--[[
Name: "cl_init.lua".
	~ Applejack ~
--]]

include("sh_init.lua");

-- This is called when the entity should draw.
function ENT:Draw() self.Entity:DrawModel(); end

function ENT:ESPPaint(lines, pos, distance, lookingat)
	local contra = GM.Config["Contraband"][self:GetClass()];
	if (not contra) then return end
	lines:Add("Name", contra.name, color_brightgreen, 1);
	if (lookingat) then
		lines:Add("Status", "Energy: " .. self.dt.energy .. "/" .. contra.energy, color_white, 2);
	end
end
