--[[
	~ Plugin Library ~
	~ Applejack ~
--]]

local stored = {};

--[[
	Makes any hook call act like cider.plugin.call acted.
	(This has the added bonus of making plugin hooks immortal like gamemode ones.)
--]]
if (not hook.oCall) then
	hook.oCall = hook.Call;
end
function hook.Call(name,gm,...)
	local success, a, b, c, d, e, f, g, h;
	for _,plugin in pairs(stored) do
		if (type(plugin[name]) == "function") then
			success, a, b, c, e, f, g, h = pcall(plugin[name],plugin,...);
			if (not success) then
				ErrorNoHalt("["..os.date().."] Applejack "..plugin.Name.." Plugin: Hook "..name.." failed: "..a.."\n");
			elseif (a ~= nil) then
				if (name ~= "CalcView") then
					--MsgN(plugin.Name.." has overridden the "..name.." hook.");
				end
				return a,b,c,d,e,f,g,h;
			end
		end
	end
	return hook.oCall(name,gm,...);
end
--]]
function GM:LoadPlugins()
	local count = 0;
	MsgN("Applejack: Loading Plugins:");
	local path = self.LuaFolder.."/gamemode/plugins/";
	local _, folder = file.Find(path.."*", "LUA")
	for _,id in pairs(folder) do
		if (not id:find(".",1,true)) then
			PLUGIN = {};
			if (SERVER) then
				if (file.Exists(path..id.."/sv_init.lua", "LUA")) then
					include(path..id.."/sv_init.lua");
				end if (file.Exists(path..id.."/cl_init.lua", "LUA")) then
					AddCSLuaFile(path..id.."/cl_init.lua");
				end
			elseif (file.Exists(path..id.."/cl_init.lua", "LUA")) then
				include(path..id.."/cl_init.lua");
			end
			if (PLUGIN.Name) then
				MsgN(" Loaded plugin '"..PLUGIN.Name.."'")
				stored[id] = PLUGIN;
				count = count + 1;
			end
		end
	end
	PLUGIN = nil;
	if (self.Inited) then
		hook.Call("LoadData",self);
	end
	MsgN("Applejack: Loaded ",count," plugins.\n");
end

-- Concommand for debug
if SERVER then
	concommand.Add("cider_reload_plugins",function(ply)
		if (IsValid(ply) and not ply:IsSuperAdmin()) then return end
		GM:LoadPlugins();
	end)
elseif GetConVarNumber("developer") > 0 then -- Don't want the peons to get this command.
	concommand.Add("cider_reload_plugins_cl",function()
		GM:LoadPlugins();
	end)
end

function GM:GetPlugin(id)
	-- If we're passed a valid plugin ID, then return the plugin
	id = string.lower(id);
	if (stored[id]) then
		return stored[id];
	end
	local res, len;
	-- Otherwise, we're looking for part of a name.
	for _,data in pairs(stored) do
		if (data.Name:lower():find(id)) then
			local lon = data.Name:len();
			if (res) then
				if (lon < len) then
					res = data;
					len = lon;
				end
			else
				res = data;
				len = lon;
			end
		end
	end
	return res
end