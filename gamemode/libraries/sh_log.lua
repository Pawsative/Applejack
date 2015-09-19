--[[
	~ Logging Library ~
	~ Applejack ~
--]]
local GM = GM or GAMEMODE; -- eeeh

---
-- The various log categories and information about them, indexed by name
GM.LogCategoryData = {
}

---
-- The various log categories and information about them, indexed by ID.
GM.LogCategories = {

}
-- The current category index
local index = 0;

---
-- Register a normal category for the logs
-- @param name The name of the category
-- @param description The description to show up in the logging VGUI
-- @param access The access a player requires to see the events in this subcategory
-- @param color The colour to show up if the client is using Nevec's gm_console dll
function GM:RegisterLogCategory(name, description, access, color)
	local category = {
		name = name,
		description = description,
		access = access,
		color = color
	}
	self.LogCategoryData[name] = category;
	index = index + 1;
	self.LogCategories[index] = category;
	if (SERVER) then
		umsg.PoolString(name);
	end
	return index;
end

---
-- Register a master category for the logs.
-- This is for categories such as EVENT, which covers a lot and has various subsections like ADMINEVENT or PUBlICEVENT, all of which have different access requirements but are still part of the same category.
-- @usage EVENT_EVENT_TYPE = GM:RegisterLogCategegoryMaster("Event",  "Events that you have access to",	color_white);
-- @param name The name of the overall category
-- @param description The description to show up in the logging VGUI
-- @param color The colour to show up if the client is using Nevec's gm_console dll
-- @return The identifier for the category type. In this case, it's the name.
function GM:RegisterLogCategegoryMaster(name, description, color)
	self.LogCategoryData[name] = {
		name = name,
		description = description,
		color = color
	}
	if (SERVER) then
		umsg.PoolString(name);
	end
	return name;
end

---
-- Registers a subcategory of a master category with a specified access level.
-- This has the overall effect of registering a new category with the same name and description of the master category with a different access level.
-- @usage EVENT_SUPEREVENT = GM:RegisterLogSubCategory(EVENT_EVENT_TYPE, "s")
-- @param master The name of the master category
-- @param access The access a player requires to see the events in this subcategory
-- @returns The ID of the new category.
function GM:RegisterLogSubCategory(master, access)
	local data = self.LogCategoryData[master];
	if (not data) then
		error("["..os.date().."] Applejack Logging Library: Unknown master category '"..tostring(master).."' provided to RegisterLogSubCategory!",2);
	end
	index = index + 1;
	self.LogCategories[index] = {
		name = master,
		description = data.description,
		color = data.color,
		access = access
	}
	return index;
end


concommand.Add("consoleprinttest",function()
	console.Print(Color(000,000,000), "Black");
	console.Print(Color(255,000,000), "Red");
	console.Print(Color(000,255,000), "Green");
	console.Print(Color(000,000,255), "Blue");
	console.Print(Color(255,255,000), "Yellow");
	console.Print(Color(000,255,255), "Cyan");
	console.Print(Color(255,000,255), "Magenta");
	console.Print(Color(255,255,255), "White");
end);

-- Prints the new log entry to the console
local function doprint(name, msg, ...)
	-- Create our log text
	local text = string.format("[%s] "..msg, name, ...);
	if (name == "Errors") then -- Throw errors as actual errors.
		ErrorNoHalt("["..os.date().."]",text,"\n");
		return;
	end
	if (SERVER) then
		-- Neatly work with Source's logging system.
		ServerLog(text.."\n");
		-- Listen servers don't need the serverside messages because they get the clientside ones.
		if (GM:IsListenServer()) then
			return;
		end
	end if (console) then
		-- If we've got the nice console module installed, give us some colours.
		console.Print(GM.LogCategoryData[name].color, text.."\n");
	else
		print(text);
	end
end

if (SERVER) then
	---
	-- Log an event that has happened. (serverside)
	-- These events will be stored in the server's /log/ directory if the 'log on' command has been issued at startup and will be sent to any client that has the relevent access.
	-- @usage GM:Log(EVENT_BUILD, "%s spawned a %q", player:Name(), model);
	-- @param category The categoryID for the kind of event we are logging.
	-- @param event A string that contains the base of the event. This will be pooled and have string.format run on it with the other arguments. Try to keep it as generic as possible. See the usage tag.
	-- @param ... A series of strings to be applied to the event string via string.format().
	function GM:Log(category, event, ...)
		local data, tosend, filtr, i;
		data = self.LogCategories[category];
		-- Ensure we have a valid category
		if (not data) then
			error("["..os.date().."] Applejack Logging Library: Unknown category '"..tostring(category).."'!",2);
		end
		-- Print the data to the server console
		doprint(data.name, event, ...);
		-- Ensure every argument is a string for the umsgs
		tosend = {};
		for _,value in pairs{...} do
			tosend[#tosend+1] = tostring(value);
		end
		filtr = RecipientFilter();
		i = 0;
		-- Check through all the players on the server and add them to the filter if they have the required access
		for _, ply in pairs(player.GetAll()) do
			if (ply:HasAccess(data.access, true)) then
				i = i + 1;
				filtr:AddPlayer(ply);
			end
		end
		-- Pool the event string, so that it won't take up so much bandwith next time
		umsg.PoolString(event);
		-- If no one has access to this event, do not bother sending it.
		if (i == 0) then
			return;
		end
		-- Send the event to
		umsg.Start("LogEvent", filtr)
			umsg.Short(category);
			umsg.String( event );
			umsg.Short( #tosend);
			if (#tosend > 0) then
				for i = 1, #tosend do
					umsg.String(tosend[i]);
				end
			end
		umsg.End();
	end
else
	-- All the stored log entries (clientside)
	GM.LogEntries = {
		All = {},
	};
	concommand.Add("cider_dumplog", function()
		file.Write("cider_logdump_"..os.date()..".txt", util.TableToKeyValues(GM.LogEntries)); --Very ugly dump, consider making it prettier in the future
	end)
    usermessage.Hook("LogEvent",function(msg)
		local category = msg:ReadShort();
		local event = msg:ReadString();
		local length = msg:ReadShort();
		local args = {};
		if (length > 0) then
			for i = 1, length do
				args[i] = msg:ReadString();
			end
		end
		local text = string.format(event,unpack(args));
		local name = GM.LogCategories[category].name;
		if (not GM.LogEntries[name]) then
			GM.LogEntries[name] = {};
			GM.LogEntries.newCategory = true;
		end
		table.insert(GM.LogEntries[name ], text);
		table.insert(GM.LogEntries["All"], text);
		doprint(name, text);
	end)
end