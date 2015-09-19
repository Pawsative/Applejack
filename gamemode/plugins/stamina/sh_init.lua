--[[
	~ Stamina Plugin / SH ~
	~ Applejack ~
--]]

PLUGIN.Name = "Stamina";


function AntiJump(ply, bind, pressed)
	if bind == "+jump" and pressed and ply._Stamina < 10 then
		return true
	end
end
hook.Add("PlayerBindPress", "AntiJump", AntiJump)