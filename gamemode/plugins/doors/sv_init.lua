--[[
	~ Doors Plugin / SV ~
	~ Applejack ~
--]]

--[[
Changelog:
29/1/10: Mostly rewritten to use the new plugin format and be sane.
]]

-- Include the shared file and add it to the client download list.
includecs("sh_init.lua");

--[[
	This function will load saved data from a file with this map's name and attempt to apply it to doors on the map.
	Uses bits of code by grea$emonkey who posted them here: http://www.facepunch.com/showthread.php?t=886729
--]]
function PLUGIN:LoadDoors()
	local results,validents,numents,radiussquared; -- Important vars
	local data, path, status, entity; -- Unimportant vars
	self.Doors = {}
	-- Check there is actually data for us to load
	path = GM.LuaFolder.."/doors/"..game.GetMap()..".txt"
	if (not file.Exists(path, "DATA")) then
		return
	end
	-- Load the data and attempt to decode it
	data = file.Read(path, "DATA");
	status, results = pcall(glon.decode, data);
	if (status == false) then -- Yes I know 'not status' is the same thing but this looks nicer in the circumstances.
		error("["..os.date().."] Doors Plugin: Error GLON decoding '"..path.."': "..results);
	elseif (not results) then -- If we end up with an empty table, why bother doing more?
		return
	end
	status,path,data = nil;
	validents = {};
	for _, ent in pairs(ents.GetAll()) do
		if (ent:IsValid() and cider.entity.isOwnable(ent) and cider.entity.isDoor(ent)) then
			validents[#validents + 1] = ent;
			ent._StartPos = ent:GetPos();
		end
	end
	numents = #validents;
	if (numents < 1) then -- You never know.
		error("["..os.date().."] Doors Plugin: a "..#results.." long file exists for "..game.GetMap().." but it has no suitable entities!");
	end
	radiussquared = 1; -- Our SQUARED search radius. A 1r sphere should do the job fine.
	for i = 1, #results do-- Loop through our results
		data = results[i];
		for i = 1, numents do -- Loop through our suitable ents
			entity = validents[i];
			if ((data.Position - entity:GetPos()):LengthSqr() <= radiussquared) then -- Check if the current ent is within a unit of our target
				-- Now we check if the data has various things set on it, and apply them if so
				if (data.Master) then -- Does this door have a master entity?
					for i = 1, numents do -- Loop through our suitable ents (again!)
						master = validents[i];
						if ((data.Master - entity:GetPos()):LengthSqr() <= radiussquared) then -- Check if the current ent is within a unit of our target
							cider.entity.setMaster(entity,master); -- If it is, set it as the entity's master.
							break; -- We can either have the last appropriate entity as the master, or the first. Let's choose the first for speed.
						end
					end
				end if (data.Sealed) then -- Is this door sealed?
					entity._Sealed = true; -- Tell the server that it is sealed
					entity:SetDTInt(3, entity:GetDTInt(3) +  OBJ_SEALED); -- Tell the client that it is sealed.
				end if (data.PreOwned) then -- Is this door pre-owned by a team or gang?
					if (data.PreOwned == "team") then -- If it's a team that owns it
						cider.entity.setOwnerTeam(entity, data.Owner);
					else -- Otherwise a gang must own it.
						cider.entity.setOwnerGang(entity,data.Owner[1],data.Owner[2]);
					end
				end if (data.Name) then -- Does this door have a custom name?
					entity:SetNWString("Name", data.Name);
				end if (data.Unownable) then -- Is this door unownable?
					if (not data.PreOwned) then -- If the door doesn't already have an owner
						cider.entity.setOwnerTeam(entity, TEAM_NONE); -- Give it to the dummy team we set up earlier, so no one else can have it.
					end
					cider.entity.setName(entity,data.Unownable); -- Give it it's custom name.
					entity._Unownable = true; -- Let the server know.
				end
				self.Doors[entity] = data; -- Save all this for future usage/saveage
			end
		end
	end
end


-- Called when all good plugins should load their datas. (Normally a frame after InitPostEntity)
function PLUGIN:LoadData()
	timer.Simple(FrameTime()*5, function()
		self.LoadDoors(self); -- Load the doors in what (if we're lucky) will be 5 frames time.
	end)
end

-- Called when a player attempts to jam a door (ie with a breach)
function PLUGIN:PlayerCanJamDoor(ply, door)
	if (door._Unownable) then
		return false
	end
end

--Called when a player attempts to own a door.
function PLUGIN:PlayerCanOwnDoor(player, door)
	if (door._Unownable) then
		return false;
	end
end

-- Gets the data for the door, either creating it if it doesn't exist or returning a blank table.
function PLUGIN:GetDoorData(door, create)
	local ret;
	if (self.Doors[door]) then
		ret = self.Doors[door];
	elseif (create) then
		ret = {
			Position = door._StartPos or door:GetPos();
		}
		self.Doors[door] = ret;
	else
		ret = {};
	end
	return ret;
end

-- Called when data needs to be saved
function PLUGIN:SaveData()
	local tocode, status, result, count;
	tocode = {};
	count = 0;
	for ent, data in pairs(self.Doors) do -- Loop through our stored door data
		if (IsValid(ent) and table.Count(data) > 0) then -- Make sure this door exists and has data
			count = count + 1;
			tocode[count] = data;
		else
			self.Doors[ent] = nil;
		end
	end
	if (count < 1) then
		return
	end
	status, result = pcall(glon.encode, tocode); -- Encode the data with glon.
	if (status == false) then
		error("["..os.date().."] Doors Plugin: Error GLON encoding "..game.GetMap().."'s door data: "..result);
	end
	file.Write(GM.LuaFolder.."/doors/"..game.GetMap()..".txt", tostring(result));
end

function PLUGIN:EntityNameSet(door, name)
	if (not (IsValid(door) and cider.entity.isOwnable(door) and door._isDoor)) then
		return
	elseif (not name or name == "") then
		self:GetDoorData(door).Name = nil;
	else
		self:GetDoorData(door,true).Name = name;
	end
	self:SaveData();
end

function PLUGIN:EntityMasterSet(door,master)
	if (not (IsValid(door) and cider.entity.isOwnable(door) and door._isDoor)) then
		return
	elseif (IsValid(master)) then
		self:GetDoorData(door,true).Master = master:GetPos();
	else
		self:GetDoorData(door).Master = nil;
	end
	self:SaveData();
end

function PLUGIN:EntitySealed(door,unsealed)
	if (not (IsValid(door) and cider.entity.isOwnable(door) and door._isDoor)) then
		return
	elseif (unsealed) then
		self:GetDoorData(door).Sealed = nil;
	else
		self:GetDoorData(door,true).Sealed = true;
	end
	self:SaveData();
end

function PLUGIN:EntityOwnerSet(door, kind, target)
	if (not (IsValid(door) and cider.entity.isOwnable(door) and door._isDoor)) then
		return
	end
	local data = self:GetDoorData(door,true);
	if (kind == "remove") then
		data.PreOwned = nil;
		data.Onwer = nil;
	else
		data.PreOwned = kind;
		data.Owner = target;
	end	if (data.Unownable) then
		cider.entity.setName(door, data.Unownable);
	end
	self:SaveData();
end
local plugin = PLUGIN;
cider.command.add("unownable", "s", 0, function(ply, action, ...)
	local door = ply:GetEyeTraceNoCursor().Entity;
	if (not (IsValid(door) and cider.entity.isOwnable(door) and door._isDoor)) then
		return false, "You must look at a valid door!";
	end
	door = cider.entity.getMaster(door) or door;
	if (action == "remove") then
		if (not door._Unownable) then
			return false, "That door is not currently set as unownable!";
		end
		door._Unownable = nil;
		cider.entity.clearData(door, true);
		local data = plugin:GetDoorData(door);
		if (data.PreOwned) then
			if (data.PreOwned == "team") then
				cider.entity.setOwnerTeam(door, data.Owner);
			else
				cider.entity.setOwnerGang(door, data.Owner[1], data.Owner[2]);
			end
		else
			cider.entity.updateSlaves(door);
		end
		local name = cider.entity.getDoorName(door)
		ply:Notify("'"..name.."' is no longer unownable.");
		GM:Log(EVENT_EVENT,"%s de unownable'd %q",ply:Name(),name)
	else
		local name = (action or "").." "..table.concat({...}, " ");
		name:Trim();
		local data = plugin:GetDoorData(door, true);
		data.Unownable = name;
		door._Unownable = true;
		if (not data.PreOwned) then
			cider.entity.clearData(door,true);
			cider.entity.setOwnerTeam(door,TEAM_NONE);
		elseif (data.Owner ~= cider.entity.getOwner(door)) then
			if (data.PreOwned == "team") then
				cider.entity.setOwnerTeam(door, data.Owner);
			else
				cider.entity.setOwnerGang(door, data.Owner[1], data.Owner[2]);
			end
		end
		cider.entity.setName(door,name)
		name = cider.entity.getDoorName(door)
		ply:Notify("'"..name.."' is now unownable.");
		GM:Log(EVENT_EVENT,"%s unownable'd %q",ply:Name(),name)
	end
	plugin:SaveData();
end, "Super Admin Commands", "[name|remove]", "Add (and optionally name) or remove an unownable door.", true);