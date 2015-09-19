--[[
	~ Clientside Init - Item ~
	~ Applejack ~
--]]

include("sh_init.lua")

-- This is called when the entity should draw.
function ENT:Draw() self.Entity:DrawModel(); end

function ENT:ESPPaint(lines, pos, distance, lookingat)
	local item = self:GetItem();
	if (not item) then return end
	local amount, word = self.dt.amount;
	if (amount > 1) then
		word = amount .. " " .. item.Plural;
	else
		word = (item.Name:sub(1,1):lower():find"[aeio]" and "An " or "A ") .. item.Name;
	end
	lines:Add("Name", word, color_orange, 1);
	if (not lookingat) then return end
	if (item.Equippable and LocalPlayer():KeyDown(IN_SPEED)) then
		lines:Add("Instructions", "'Use' + 'Sprint' to " .. item.Equipword, color_brightgreen, 2);
	else
		lines:Add("Instructions", "'Use' to pick up", color_brightgreen, 2);
	end
	lines:Add("Size","Size: "..tostring(item.Size), color_white, 3);
end
