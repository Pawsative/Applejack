--[[
	~ SaveFrags/Death Plugin ~
	~ Moonshine ~
--]]

PLUGIN.Name   = "Save Frags/Deaths";
local frags, deaths = {},{};

function PLUGIN:PlayerInitialized(player)
	local id = player:UniqueID()
	if frags[ id ] then
		player:SetFrags( frags[ id ] )
	end
	if deaths[ id ] then
		player:SetDeaths( deaths[ id ] )
	end
end

function PLUGIN:PlayerDisconnected(player)
	frags [player:UniqueID()] = player:Frags ()
	deaths[player:UniqueID()] = player:Deaths()
end