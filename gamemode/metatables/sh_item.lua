--[[
	~ Item Metatable (shared) ~
	~ Applejack ~
--]]
---
-- The shared item metatable
-- @name meta
-- @class table
local meta = debug.getregistry().Item;
if (not meta) then
	ErrorNoHalt("Applejack: Error setting up shared item metatable - Item metatable does not exist!");
	return
end

---
-- Internal: Registers a populated item table.
function meta:Register()
	if (not self.UniqueID) then
		ErrorNoHalt("Item with no uniqueID registered!\nDumping table:\n");
		--[[ WARNING: DIRTY HACK TIME ]]--
		msg = Msg;
		Msg = ErrorNoHalt;
		PrintTable(self);
		Msg = msg;
		--[[ END OF DIRTY HACK ]]--
		return false;
	end
	if (self.Base) then
		base = {};
		if (type(self.Base) == "table") then
			for _,id in ipairs(self.base) do
				table.Merge(base, GM.Items[id] or {});
			end
		else
			table.Merge(base, GM.Items[self.Base] or {});
		end
		for k,v in pairs(base) do
			if (not self[k]) then
				self[k] = v;
			end
		end
	end
	if (self.Model) then
		util.PrecacheModel(self.Model);
	end
	GM.Items[self.UniqueID] = self;
	if (SERVER) then
		umsg.PoolString(self.UniqueID);
	end
end