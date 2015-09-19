--[[
	~ 'Anonymous' Plugin ~
	~ Applejack ~
--]]

PLUGIN.Name = "Anonymous";

-- Prevent players being told who killed what.
usermessage.Hook("NPCKilledNPC", function() end);
usermessage.Hook("PlayerKilledNPC", function() end);
usermessage.Hook("PlayerKilled", function() end);
usermessage.Hook("PlayerKilledSelf", function() end);
usermessage.Hook("PlayerKilledByPlayer", function() end);