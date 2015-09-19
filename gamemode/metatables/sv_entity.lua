--[[
	~ Serverside Entity metatable ~
	~ Applejack ~
--]]
local meta = debug.getregistry().Entity;
if (not meta) then
	error("["..os.date().."] Applejack Serverside Entity metatable: No metatable found!");
end
;
