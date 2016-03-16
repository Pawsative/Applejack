--[[
	~ Stamina Plugin / SH ~
	~ Applejack ~
--]]

PLUGIN.Name = "Stamina";


function AntiJump(ply, bind, pressed)
	local stamina = ply._Stamina or 0
	if bind == "+jump" and pressed and stamina < 10 then
		return true
	end
end
hook.Add("PlayerBindPress", "AntiJump", AntiJump)
