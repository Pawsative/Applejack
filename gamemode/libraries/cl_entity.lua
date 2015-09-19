--[[
Name: "cl_entity.lua".
	~ Applejack ~
--]]

cider.entity = {};
cider.entity.stored = {}
local poetic = CreateClientConVar("cider_poetic", "1", true)

-- Check if an entity is a door.
function cider.entity.isDoor(entity)
	local class = entity:GetClass();

	-- Check if the entity is a valid door class.
	return entity._isDoor
		or class == "func_door"
		or class == "func_door_rotating"
		or class == "prop_door_rotating"
		or entity.LookupSequence and (entity:LookupSequence("open") or 0) > 0 and (entity:LookupSequence("close") or 0) > 0
end

-- Check to see if an entity is owned
function cider.entity.isOwned(entity)
	if not IsValid(entity) then
		error("Invalid entity passed to isOwned",2) --I really shouldn't have to do this, but I get passed NULL ents all the time for some retarded reason
	end
	local owner = cider.entity.getOwner(entity)
	return owner and owner ~= "Nobody"
end

-- Get an entities status
function cider.entity.getStatus(entity)
	local status = ""
	local p = poetic:GetBool()
	if cider.entity.hasAccess(entity) then
		if p then
			status = "You have access to this"
		else
			status = "(Access)"
		end
	end
	--[[
	if entity:GetDTInt(3) && OBJ_INUSE == OBJ_INUSE then
		if p then
			if status == "" then
				status = "This is in use"
			else
				status = status.. ", but it is in use"
			end
		else
			status = status.."(In Use)"
		end
	end
	if entity:GetDTInt(3) && OBJ_RAMMABLE == OBJ_RAMMABLE then
		if p then
			if status == "" then
				status = "You may ram this"
			else
				status = status..". You may ram it"
			end
		else
			status = status.."(Rammable)"
		end
	end
	--]]
	if bit.band(entity:GetDTInt(3), OBJ_LOCKED) == OBJ_LOCKED then
		if p then
			if status == "" then
				status = "This is locked"
			else
				status = status.." and it is locked"
			end
		else
			status = status.."(Locked)"
		end
	end
	if bit.band(entity:GetDTInt(3), OBJ_SEALED) == OBJ_SEALED then
		if p then
			if status == "" then
				status = "This is sealed shut"
			elseif status:sub(-2,-1) == "ed" then
				status = status.." and sealed shut"
			else
				status = status..". It is sealed shut"
			end
		else
			status = status.."(Sealed)"
		end
	end
	if status ~= "" and p then
		status = status.."."
	end
	return status
end

-- Check to see if an entity is ownable
function cider.entity.isOwnable(entity)
	return tobool(cider.entity.getOwner(entity))
end

-- Get the owner's name of an entity
function cider.entity.getOwner(entity)
	if not IsValid(entity) then
		error("Invalid entity passed to getOwner",2)
	end
	local name = entity:GetNetworkedString("cider_ownerName")
	if name and name ~= "" then
		return name
	end
	return nil
end

-- Does the local player have access to the entity?
function cider.entity.hasAccess(entity)
	if not IsValid(entity) then
		error("Invalid entity passed to hasAccess",2)
	end
	return cider.entity.stored[entity]
end

-- Called when the player's access to an entity is changed
local function incomingAccess(msg)
	local ent,access = msg:ReadEntity(),msg:ReadBool() or nil
	cider.entity.stored[ent] = access
	if GetConVarNumber"developer" > 0 and IsValid(ent) then
		local moneyAlert = {}

		-- Set some information for the money alert.
		local words = ent:GetNetworkedString("Name","Door")..","..tostring(cider.entity.getOwner(ent))
		moneyAlert.alpha = 255
		moneyAlert.add = 1

		-- Check to see if the amount is negative.
		if access then
			moneyAlert.color = color_white
			moneyAlert.text = "+ "..words
		else
			moneyAlert.color = color_black
			moneyAlert.text = "- "..words
		end
--		debugoverlay.Box(ent:GetPos(),ent:OBBMins(),ent:OBBMaxs(),20,moneyAlert.color,true)
		debugoverlay.Line(LocalPlayer():EyePos() + LocalPlayer():GetForward(),ent:GetPos(),20,moneyAlert.color,true)
		print("[DEBUG] Your access for "..tostring(ent).."['"..words.."'] has been set to '"..tostring(access).."'.")
		-- Insert the money alert into the table.
		table.insert(GAMEMODE.moneyAlerts, moneyAlert)
	end
end
usermessage.Hook("cider_IncomingAccess",incomingAccess)

local function wipeAccess(msg)
	cider.entity.stored = {}
	if GetConVarNumber"developer" > 0 then
		local moneyAlert = {};

		-- Set some information for the money alert.
		moneyAlert.alpha = 255;
		moneyAlert.add = 1;
		moneyAlert.color = color_black;
		moneyAlert.text = "ALL ACCESS WIPED"
		print"[DEBUG] Your access table has been wiped."

		-- Insert the money alert into the table.
		table.insert(GAMEMODE.moneyAlerts, moneyAlert);
	end
end
usermessage.Hook("cider_WipeAccess",wipeAccess)
local function massAccessSystem(msg)
	local len = msg:ReadShort()
	for i=1,len do
		local ent,access = msg:ReadEntity(),msg:ReadBool() or nil
		cider.entity.stored[ent] = access
	end
end
usermessage.Hook("cider_massAccessSystem",massAccessSystem)

timer.Create("keepAccessTableClean",GM.Config["Earning Interval"],0,function()
	for ent,access in pairs(cider.entity.stored) do
		if not IsValid(ent) or not access then
			cider.entity.stored[ent] = nil
		end
	end
end)
