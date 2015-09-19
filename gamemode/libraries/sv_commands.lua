--[[
Name: "sv_commands.lua".
	~ Applejack ~
--]]

cider.command = {};
cider.command.stored = {};

-- Add a new command.
function cider.command.add(command, access, arguments, callback, category, help, tip, unpack)
	cider.command.stored[command] = {access = access, arguments = arguments, callback = callback, unpack = tobool(unpack)};
	
	-- Check to see if a category was specified.
	if (category) then
		if (!help or help == "") then
			cider.help.add(category, GM.Config["Command Prefix"]..command.." <none>.", tip);
		else
			cider.help.add(category, GM.Config["Command Prefix"]..command.." "..help..".", tip);
		end
	end
end

-- This is called when a player runs a command from the console.
function cider.command.consoleCommand(player, _, arguments)
	if not (player._Initialized) then return end
	if (arguments and arguments[1]) then
		command = string.lower(table.remove(arguments, 1));
		-- Check to see if the command exists.
		if (cider.command.stored[command]) then
			-- Loop through the arguments and fix Valve's errors.
			for k, v in pairs(arguments) do
				arguments[k] = string.Replace(arguments[k], " ' ", "'");
				arguments[k] = string.Replace(arguments[k], " : ", ":");
			end
			
			-- Check if the player can use this command.
			if ( hook.Call("PlayerCanUseCommand", GAMEMODE, player, command, arguments) ) then
				if (#arguments >= cider.command.stored[command].arguments) then
					if (player:HasAccess(cider.command.stored[command].access) ) then
						-- Some callbacks remove arguments from the table, and we don't want to lose them ;)
						local success, fail,msg
						if cider.command.stored[command].unpack then
							success, fail,msg = pcall(cider.command.stored[command].callback, player, unpack(arguments));
						else
							success, fail,msg = pcall(cider.command.stored[command].callback, player, table.Copy(arguments));
						end
						if success then
							if fail ~= false then
								local text = ""
								if (table.concat(arguments, " ") ~= "") then
									text = text.." "..table.concat(arguments, " ")
								end
								GM:Log(EVENT_COMMAND,"%s used 'cider %s%s'.",player:Name(),command,text);
							else
								if msg and msg ~= "" then
									player:Notify(msg,1)
								end
							end
						else
							ErrorNoHalt(os.date().." callback for 'cider "..command.." "..table.concat(arguments," ").."' failed: "..fail.."\n")
						end
					else
						player:Notify("You do not have access to this command, "..player:Name()..".", 1);
					end
				else
					player:Notify("This command requires "..cider.command.stored[command].arguments.." arguments!", 1);
				end
			end
		else
			player:Notify("This is not a valid command!", 1);
		end
	else
		player:Notify("This is not a valid command!", 1);
	end
end

-- Add a new console command.
concommand.Add("cider", cider.command.consoleCommand);