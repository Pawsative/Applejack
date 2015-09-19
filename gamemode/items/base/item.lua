--[[
	~ Base item ~
	~ Applejack ~
	~[
		This base provides items that call it with the base 
		 functions 'Drop' and 'Destroy', with nothing
		 happening when they're run.
	~]
--]]
local function f() end
ITEM.onDrop = f;
ITEM.onDestroy = f;