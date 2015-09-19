--[[
	~ Shared Item Library ~
	~ Applejack ~
--]]

local GM	= GM or GAMEMODE;
GM.Items	= {};
local meta	= {};
local cats	= {}; -- meow
local index	= 1;
-- Set the metatable up
meta.__index = meta;
setmetatable(meta,{__call = function(self, tab)
	return setmetatable(tab or {},self);
end})
debug.getregistry().Item = meta;

local newcat,str,count,path,total;
function GM:LoadItems()
	path = self.LuaFolder.."/gamemode/items/";
	MsgN("Applejack: Loading Item Bases:")
	for _, filename in pairs( file.Find(path.."base/*.lua", "LUA")) do
		if (validfile(filename)) then
			ITEM = meta();
			ITEM.Name = "NULL"; -- For the search
			includecs(path.."base/"..filename);
			ITEM.UniqueID = filename:sub(1,-5);
			ITEM:Register();
			MsgN(" Loaded item base '"..ITEM.UniqueID.."'");
		end
	end
	total = 0;
	MsgN("Applejack: Loading Categories:")
	local _, folders = file.Find(path.."*", "LUA")
	for _, filename in ipairs( folders) do
		if (validfile(filename) and not filename:find('.',1,true)) and (filename != "base") then
			str,count = "",0;
			CAT = {};
			includecs(path..filename.."/init.lua");
			newcat = self:RegisterCategory(CAT);
			//_E['CATEGORY_'..string.upper(filename)] = newcat;
			for _, item in ipairs(file.Find(path..filename.."/*.lua", "LUA")) do
				if (validfile(item) and item ~= "init.lua") then
					ITEM = meta();
					_G['CATEGORY_'..string.upper(filename)] = newcat;
					includecs(path..filename.."/"..item);
					ITEM.UniqueID = item:sub(1,-5);
					ITEM.Category = newcat;
					ITEM:Register();
					str = str..", "..ITEM.UniqueID;
					count = count + 1;
				end
			end
			str = str:sub(3);
			total = total + count;
			MsgN(" Loaded category '"..filename.."' with "..count.." items:\n  "..str);
		end
	end
	ITEM,CAT = nil;
	MsgN("Applejack: Loaded "..total.." items in total.\n");
end

function GM:GetItem(id)
	-- If we're passed a valid UniqueID, then return the item
	if (self.Items[id]) then
		return self.Items[id];
	end
	local res, len;
	-- Otherwise, we're looking for part of a name.
	id = id:lower();
	for _,data in pairs(self.Items) do
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

-- Concommand for debug
if SERVER then
	concommand.Add("cider_reload_items",function(ply)
		if (IsValid(ply) and not ply:IsSuperAdmin()) then return end
		GM:LoadItems();
	end)
elseif GetConVarNumber("developer") > 0 then -- Don't want the peons to get this command.
	concommand.Add("cider_reload_items_cl",function()
		GM:LoadItems();
	end)
end

function GM:RegisterCategory(cat) -- meow
	cat.index = index;
	cats[index] = cat;
	index = index + 1;
	return cat.index;
end

function GM:GetCategory(id)
	-- If we're passed a valid id, return the category
	if cats[id] then
		return cats[id];
	end
	local res, len;
	-- Otherwise, we're looking for part of a name.
	id = id:lower();
	for _,data in pairs(cats) do
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
	return res;
end