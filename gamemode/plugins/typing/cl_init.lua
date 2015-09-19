--[[
	~ Typing Plugin / CL ~
	~ Applejack ~
--]]

--[[
Changelog:
29/1/10: Updated to new plugin format.
]]
-- Include the shared file.
include("sh_init.lua");

-- Called when the ESP is running
function PLUGIN:AdjustESPLines(lines,tent,pos,distance,lookingat)
	local player = IsValid( tent:GetNetworkedEntity("Player")) and tent:GetNetworkedEntity("Player") or tent
	if player:IsPlayer() and  player:GetNetworkedBool("cider_Typing") then
		lines:ShiftWeightDown(1,1) -- Make everything under the player's name drop by one
		lines:Add("Talking","Talking",color_white,2)
	end
end

-- Called when a player starts typing.
function PLUGIN:OpenChatBox()
	RunConsoleCommand("cider_typing_start");
end

-- Called when a player finishes typing.
function PLUGIN:CloseChatBox()
	RunConsoleCommand("cider_typing_finish");
end