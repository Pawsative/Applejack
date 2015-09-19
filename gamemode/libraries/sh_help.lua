--[[
Name: "sh_help.lua".
	~ Applejack ~
--]]

cider.help = {};
cider.help.stored = {};

function cider.help.add(cat, help, tip)
	cider.help.stored[cat] = cider.help.stored[cat] or {};
	table.insert(cider.help.stored[cat],{ text = help, tip = tip});
	if (CLIENT and cider.help.panel) then
		cider.help.panel:Reload();
	end
end
if (CLIENT) then
	net.Receive("helpReplace",function()
		local data = net.ReadTable()
		cider.help.stored = data;
		if (cider.help.panel) then
			cider.help.panel:Reload();
		end
	end);
else
	--[[ Add generic helps TODO: Do bettr ]]--
	cider.help.add("General", "For more information, hover your mouse over entries.");
	cider.help.add("General", "Using any exploits will get you banned permanently.");
	cider.help.add("General", "Put // before your message to talk in global OOC.");
	cider.help.add("General", "Put .// before your message to talk in local OOC.");
	cider.help.add("General", "Press F1 to see the main menu.");
	cider.help.add("General", "Press F2 to see the ownership menu.");
	hook.Add("PlayerInitialized","Applejack Help Spammer", function(ply)
		net.Start("helpReplace")
			net.WriteTable(cider.help.stored)
		net.Send(ply)
	end);
end
