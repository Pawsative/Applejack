--[[
Name: "sv_chat.lua".
	~ Applejack ~
--]]

cider.chatBox = {};

-- Add a new line.
function cider.chatBox.add(recipientFilter, player, filter, text)
	umsg.PoolString(filter)
	if (player) then
		umsg.Start("cider.chatBox.playerMessage", recipientFilter);
			umsg.Entity(player);
			umsg.String(filter);
			umsg.String(text);
		umsg.End();
	else
		umsg.Start("cider.chatBox.message", recipientFilter);
			umsg.String(filter);
			umsg.String(text);
		umsg.End();
	end
end

-- Add a new line to players within the radius of a position.
function cider.chatBox.addInRadius(ply, filter, text, position, radius)
	local rf, doit;
	rf = RecipientFilter();
	for k, v in pairs( player.GetAll() ) do
		if v:GetPos():Distance( position ) <= radius then
			rf:AddPlayer(v);
			doit = true;
		end
	end
	if (doit) then
		cider.chatBox.add(rf, ply, filter, text);
	end
end