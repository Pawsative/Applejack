--[[
	~ Prison Points Plugin ~
	~ Applejack ~
--]]


PLUGIN.Name = "Prisonpoints";
PLUGIN.Prisonpoints = {};

function PLUGIN:LoadData()
	local path, data, status, results;

	path = "applejack/prisonpoints/"..string.lower(game.GetMap())..".txt";
	if (not file.Exists(path, "DATA")) then
		return
	end
	data = file.Read(path, "DATA");
	status, results = pcall(util.JSONToTable, data);
	if (status == false) then
		error("Error GLON decoding '"..path.."': "..results);
	elseif (not results) then
		return
	end
	self.Prisonpoints = results;
end

function PLUGIN:SaveData()
--	print("savedata!");
	local data,status,result,path;
--	PrintTable(self.Prisonpoints);
	status, result = pcall(util.TableToJSON, self.Prisonpoints);
--	print("status",status,"result",result);
	if (status == false) then
		error("["..os.date().."] Prisonpoints Plugin: Error GLON encoding prisonpoints : "..results);
	end
	path = "applejack/prisonpoints/"..string.lower(game.GetMap())..".txt";
--	print("path",path);
	if (not result or result == "") then
--		print("no result");
		if (file.Exists(path, "DATA")) then
--			print("file exists");
			file.Delete(path);
		end
		return;
	end
--	print("result, writing.");
	file.Write(path,result);
end

function PLUGIN:PlayerArrested(ply)
--	MsgAll("Plugin called PlayerArrested");
	if (table.Count(self.Prisonpoints) < 1) then
		player.NotifyAll("The Prisonpoints plugin is active but has no prison points set!");
		return;
	end
--	MsgAll("Gots Points");
	local data = table.Random(self.Prisonpoints);
--	MsgAll("Data: "..tostring(data)..", pos: "..data.pos..", ang: "..data.ang);
	ply:SetPos(data.pos);
	ply:SetAngles(data.ang);
end

local plugin = PLUGIN;
local points = plugin.Prisonpoints;
-- A command to add a player prison point.
cider.command.add("prisonpoint", "a", 1, function(ply,action)
	local pos,count;
	action = action:lower();
	if (action == "add") then
		local pos = ply:GetPos();
		table.insert(points,{pos = pos, ang = ply:GetAngles()});
		ply:Notify("You have added a prisonpoint where you are standing.");
		--ply:ConCommand("drawcross "..pos.x.." "..pos.y.." "..pos.z)
	elseif (action == "remove") then
		if (not table.Count(points)) then
			return false, "there are no prisonpoints!";
		end
		pos = ply:GetEyeTraceNoCursor().HitPos;
		count = 0;
		for k,data in pairs(points) do
			if ((pos - data.pos):LengthSqr() <= 65536) then
				points[k] = nil;
				count = count + 1;
			end
		end
		if (count > 0) then
			ply:Notify("You removed "..count.." prisonpoints from where you were looking, leaving "..table.Count(points).." left.");
		else
			ply:Notify("There are no prisonpoints where you are looking!");
		end
	else
		return false,"Invalid action specified!";
	end
	plugin:SaveData();
end, "Admin Commands", "<add|remove>", "Add a prisonpoint where you are standing or remove prisonpoints where you look.",true);