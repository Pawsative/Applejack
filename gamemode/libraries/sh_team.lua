--[[
Name: "sh_team.lua".
	~ Applejack ~
--]]
--[[
TEAM = {}
TEAM.Name = "Example Team";
TEAM.Description = "This team is an example to demonstrate the new team system";
TEAM.Salary = 300; -- Players get $300 every payday when in this team.
TEAM.Models = {
	Male = GM.Config["Male Citizen Models"]; -- This job uses the default male citzien models
	Female = GM.Config["Female Citizen Models"]; -- This job uses the default female citizen models
};
TEAM.Access = GM.Config['Default Access']; -- You only need the default access to join this team.
TEAM.Whitelist = false; -- This team does not require a whitelist to join
TEAM.Blacklist = true; -- Players can be blacklisted from this team
--]]
cider.team = {};
cider.team.index = 1;
cider.team.stored = {};
cider.team.groupindex = 0
cider.team.storedgroups = {}

-- Add a new team.
function cider.team.addGroup(name,desc,access)
	cider.team.groupindex = cider.team.groupindex + 1
	cider.team.storedgroups[cider.team.groupindex] = {
		index = cider.team.groupindex,
		name = name or "Incorrectly Set Up Group",
		description = desc or "N/a.",
		access = access or "",
		gangs = {},
		teams = {}
	}
	return cider.team.groupindex
end
function cider.team.getGroup(name)
	local group;

	-- Check if we have a number (it's probably an index).
	if ( tonumber(name) ) then
		for k, v in pairs(cider.team.storedgroups) do
			if ( v.index == tonumber(name) ) then group = v; break; end
		end
	else
		for k, v in pairs(cider.team.storedgroups) do
			if ( string.find( string.lower(v.name), string.lower(name) ) ) then
				if (group) then
					if ( string.len(v.name) < string.len(team.name) ) then
						group = v;
					end
				else
					group = v;
				end
			end
		end
	end

	-- Return the team that we found.
	return group;
end
function cider.team.getGroupByTeam(teamID)
	local teamID = (cider.team.get(teamID) or {})["index"]
	if !teamID then return nil end
	for groupid,group in pairs(cider.team.storedgroups) do
		if table.HasValue(group.teams,teamID) then
			return cider.team.getGroup(group.index)
		end
	end
	--This really should never get called
	ErrorNoHalt("Team specified ("..teamID..") is not in any groups!")
	return nil
end
function cider.team.getGang(teamID)
	local group = cider.team.getGroupByTeam(teamID)
	for gangid,gang in ipairs(group.gangs) do
		if table.HasValue(gang,teamID) then
			return gangid
		end
	end
	return nil
end
function cider.team.getGroupLevel(teamID)
	local groupdata = cider.team.query(teamID, "group", nil)
	if groupdata then
		return groupdata.level
	else
		return nil
	end
end
function cider.team.hasAccessGroup(teamID,access)
	local team = cider.team.get(teamID)
	--local group = cider.team.getGroupByTeam(team) --error
	local query = cider.team.query(team,"group",nil).access
	--print(query,access)
	local success = false
	-- Check to see if the team has access.
	if (query) then
		if ( string.len(access) == 1 ) then
			success = tobool( string.find(query, access) )
		else
			for i = 1, string.len(access) do
				local flag = string.sub(access, i, i);

				-- Check to see if the team does not has this flag.
				if ( !cider.team.hasAccessGroup(name, flag) ) then
					success = false
					break
				end

				-- Return true because we have all the required access.
				success = true;
			end
		end
	end
	return success
end
function cider.team.getGroupTeams(groupID)
	local group
	if type(groupID) == "table" and groupID.index then
		group = groupID
	else
		group = cider.team.getGroup(groupID)
	end
	if group then
		return group.teams
	end
end
function cider.team.getGroupBase(groupID)
	for _,teamid in ipairs(cider.team.getGroupTeams(groupID)) do
		if cider.team.getGroupLevel(teamid) == 1 then
			return teamid
		end
	end
	error("Someone's put the wrong group in.",2)
end
function cider.team.getGangTeams(groupID,gangID)
	local group
	if type(groupID) == "table" and groupID.index then
		group = groupID
	else
		group = cider.team.getGroup(groupID)
	end
	if group then
		--will be nil if it doesn't have that gang
		return group.gangs[gangID]
	end
	return nil
end
function cider.team.getGangMembers(groupID,gangID)
	--print"getting group"
	local group
	if type(groupID) == "table" and groupID.index then
		group = groupID
	else
		group = cider.team.getGroup(groupID)
	end
	local results
	local gangID = gangID or 0
	if group then
		if group.gangs[gangID] then
			results = {}
			for _,teamid in ipairs(group.gangs[gangID]) do
				table.Add(results,team.GetPlayers(teamid))
			end
		elseif gangID == 0 then -- Makes the entity shit work
			results = {}
			for _,teamid in ipairs(cider.team.getGroupTeams(groupID)) do
				table.Add(results,team.GetPlayers(teamid))
			end
		end
	end
	return results
end
function cider.team.add(name, color, males, females, group,description, salary, limit, access, blacklist,canmake,cantuse,time,guns,ammo)
	local data = {
		name = name,
		index = cider.team.index,
		color = color,
		models = {},
		salary = salary,
		limit = limit,
		access = access,
		blacklist = blacklist,
		group = group,
		description = description,
		canmake = canmake,
		cantuse = cantuse,
		guns = guns,
		ammo = ammo,
		isTeam = true,
	};

	-- Check if the male and female models are a table and if not make them one.
	if (males and type(males) ~= "table") then males = {males}; end
	if (males and type(females) ~= "table") then females = {females}; end

	-- Make the limit maximum players if there is none set.
	data.limit = data.limit or game.MaxPlayers();
	data.access = data.access or "b";
	data.description = data.description or "N/A.";
	data.models.male = males or GM.Config["Male Citizen Models"];
	data.models.female = females or GM.Config["Female Citizen Models"];
	data.canmake = data.canmake or {CATEGORY_VEHICLES,CATEGORY_CONTRABAND}
	data.cantuse = data.cantuse or {}
	time = time or {0,5}
	data.timelimit = time[1] * 60
	data.waiting = time[2] * 60
	-- {gang = 2, access = "bdgeD", level = 3, group = GROUP_UNDERGROUND}
	--Make sure there's a group
	if !data.group then
		error("You cannot create a team without a group! ("..tostring(name)..")",2)
		--As 0 and "" both evaluate to true, this will ensure the group's set up right
	elseif !(data.group.gang and data.group.access and tobool(data.group.level) --[[level can't be 0.]] and data.group.group) then
		error("Group syntax wrong! ("..tostring(name)..")",2)
	elseif !cider.team.getGroup(data.group.group) then
		error("Invalid group: "..data.group.group.." ("..tostring(name)..")",2)
	end

	-- Set the team up (this is called on the server and the client).
	team.SetUp(cider.team.index, name, color);

	-- Tell the group we exist (do this after setting the groups up, to prevent errors)
	local group = cider.team.getGroup(data.group.group)
	-- See if they're in a gang
	if data.group.gang > 0 then
		--Ensure the gang exists
		group.gangs[data.group.gang] = group.gangs[data.group.gang] or {}
		--Add the team to the gang
		table.insert(group.gangs[data.group.gang],data.index)
	end
	--Add the team to the group
	table.insert(group.teams,data.index)

	-- Insert the data for our new team into our table.
	cider.team.stored[name] = data;

	-- Increase the team index so we don't duplicate any team.
	cider.team.index = cider.team.index + 1;

	-- Return the index of the team.
	return data.index;
end

-- Get a team from a name of index.
function cider.team.get(name)
	local team;
	if type(name) == "table" then
		return name
	end--ErrorNoHalt("what the fuck? A table?",2) end
	-- Check if we have a number (it's probably an index).
	if ( tonumber(name) ) then
		for k, v in pairs(cider.team.stored) do
			if ( v.index == tonumber(name) ) then team = v; break; end
		end
	else
		for k, v in pairs(cider.team.stored) do
			if ( string.find( string.lower(v.name), string.lower(name) ) ) then
				if (team) then
					if ( string.len(v.name) < string.len(team.name) ) then
						team = v;
					end
				else
					team = v;
				end
			end
		end
	end

	-- Return the team that we found.
	return team;
end

-- Check if the team has the required access.
function cider.team.hasAccess(name, access)
	local query = cider.team.query(name, "access")
	local success = false
	-- Check to see if the team has access.
	if (query) then
		if ( string.len(access) == 1 ) then
			success = tobool( string.find(query, access) )
		else
			for i = 1, string.len(access) do
				local flag = string.sub(access, i, i);

				-- Check to see if the team does not has this flag.
				if ( !cider.team.hasAccess(name, flag) ) then
					success = false
					break
				end

				-- Return true because we have all the required access.
				success = true;
			end
		end
	end
	local group = cider.team.getGroupByTeam(name)
	if group then
		if ( string.len(access) == 1 ) then
			success = tobool( string.find(group.access, access) ) or success
		else
			for i = 1, string.len(access) do
				local flag = string.sub(access, i, i);

				-- Check to see if the team does not has this flag.
				if ( !cider.team.hasAccess(name, flag) ) then
					success = false
					break
				end

				-- Return true because we have all the required access.
				success = true;
			end
		end
	end
	return success
end

-- Query a variable from a team.
function cider.team.query(name, key, default)
	--if type(name) == "table" then error("what the fuck? A table?",2) end
	local team = cider.team.get(name);

	-- Check to see if it's a valid team.
	if (team) then
		return team[key] or default;
	else
		return default;
	end
end

-- Check to see if we're running on the client.
if (CLIENT) then
	cider.team.changed = cider.team.changed or false
--	LocalPlayer()._NextChangeTeam = {}
	local function CheckForInitalised(number)
		if !IsValid(LocalPlayer()) then
			return timer.Simple(1, function()
				CheckForInitalised(number)
			end)
		end
		LocalPlayer()._NextChangeTeam = LocalPlayer()._NextChangeTeam or {}
		LocalPlayer()._NextChangeTeam[ number ] = CurTime() + cider.team.query(number,"waiting",300);
		timer.Simple(0.1,function() cider.team.changed = true end)
	end
	usermessage.Hook("TeamChange", function(msg)
		local team = msg:ReadShort() or 0
		CheckForInitalised(team)
	end)
end

