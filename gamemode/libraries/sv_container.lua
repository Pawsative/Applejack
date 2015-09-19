--[[
Name: "sv_container.lua".
	~ Applejack ~
--]]
cider.container = {}
;
--[[
	We use hooks here to allow plugins to create their own fake containers that include player specific content, like for instance a banking system.
]]

--Make an entity into a container
function cider.container.make(entity, size, name, initialContents)
	if cider.container.isContainer(entity) then
		return true
	end
	entity._Inventory = {
		name = name or "Container",
		size = size or 30,
		contents = {},
	}
	entity:SetNWBool("cider_Container",true)
	entity:SetNWString("Name",entity._Inventory.name)
	entity:SetUseType(SIMPLE_USE)
	entity:CallOnRemove("Contents Dumper",cider.container.dumpContents)
	for item,amount in pairs(initialContents or {}) do
		local ret,msg = cider.container.update(entity,item,amount,true)
		if not ret then
			ErrorNoHalt(tostring(msg).."\n")
		end
	end
end

--Get the contents of a container
function cider.container.getContents(entity,player,forMenu)
	if not entity then error("wtf",2) end
	if not cider.container.isContainer(entity) then
		return nil
	end
	if player then
		local contents,io,filter = hook.Call("PlayerGetContainerContents",GAMEMODE,entity,player,forMenu)
		if contents then
			return contents,io,filter
		end
	end
	return entity._Inventory.contents,CAN_PUT+CAN_TAKE
end

-- Get the limit of a container
function cider.container.getLimit(entity)
	if not entity then error("wtf",2) end
	if cider.container.isContainer(entity) then
		return entity._Inventory.size
	end
end

-- Get the current space used
local item;
function cider.container.getContentsSize(entity,player)
	if not cider.container.isContainer(entity) then return end
	local contents = cider.container.getContents(entity,player)
	local size = 0
	for id,amount in pairs(contents) do
		item = GM.Items[id];
		if (item and item.Size > 0) then
			size = size + item.Size * math.abs(amount);
		end
	end
	return size
end

-- Get the space left
function cider.container.getSpaceLeft(entity,player)
	if not cider.container.isContainer(entity) then return end
	return cider.container.getLimit(entity) - cider.container.getContentsSize(entity,player)
end

-- Can an item fit in?
function cider.container.canFit(entity,item,amount,player)
	if not cider.container.isContainer(entity) then return end
	if player then
		local ret = hook.Call("PlayerCanFitContainer",GAMEMODE,entity,player)
		if ret ~= nil then
			return ret
		end
	end
	return cider.container.getSpaceLeft(entity,player) - GM.Items[item].Size * amount >= 0
end

-- Update a container's contents
function cider.container.update(entity,id,amount,force,player)
	if not cider.container.isContainer(entity) then return false,"Not a container!" end
	item = GM.Items[id];
	if (not item) then
		return false,"Invalid item "..id.."!"
	end
	local amount = amount or 0
	if (player) then
		local ret,msg = hook.Call("PlayerUpdateContainerContents",GAMEMODE,player, entity, id, amount, force);
		if (ret ~= nil) then
			return ret,msg;
		end
	end
	if (item.canContainer) then
		local ret,msg = item:canContainer(player,amount,force,entity);
		if (not ret) then
			return ret,msg;
		end
	end
	if not( force or cider.container.canFit(entity,id,amount,player)) then
		return false,"Cannot fit that item in!"
	end
	entity._Inventory.contents[id] = (entity._Inventory.contents[id] or 0) + amount
	if entity._Inventory.contents[id] <= 0 then
		entity._Inventory.contents[id] = nil
	end
	if player then
		if (id == "money") then
			player:GiveMoney(-amount)
		else
			cider.inventory.update(player, id, -amount, force)
		end
		hook.Call("PlayerUpdatedContainerContents",GAMEMODE, player, entity, id, amount, force)
	end
	return true
end

--Set the name of a cointainer
function cider.container.setName(entity,name)
	if not cider.container.isContainer(entity) then return end
	entity._Inventory.name = name
	entity:SetNWString("Name",entity._Inventory.name)
end

-- Get hte name of a container
function cider.container.getName(entity)
	if not cider.container.isContainer(entity) then return end
	return entity._Inventory.name
end

--See if an entity is a cointainer
function cider.container.isContainer(entity)
	if not entity then error("wtf",2) end
	--if not cider.container.isContainer(entity) then return end
	return tobool(entity._Inventory)
end

-- Dump the contents of a container at the pos
function cider.container.dumpContents(entity,pos)
	if not cider.container.isContainer(entity) then return end
	local pos = pos or entity:GetPos()
	pos = pos + Vector(0,0,32)
	local contents = cider.container.getContents(entity)
	local items = {}
	for name,amount in pairs(contents) do
		table.insert(items,GM.Items[name]:Make(pos,amount));
		cider.container.update(entity,name,-amount,true)
	end
	-- Ensure our items don't go flying
	for _, v in ipairs(items) do
		for _, v2 in ipairs(items) do
			if (v ~= v2 and IsValid(v) and IsValid(v2) ) then
				constraint.NoCollide(v, v2, 0, 0)
			end
		end
	end
end

-- Quick concommand for clients to say when they're done
concommand.Add("MommyIAmDoneWithTheContainerNow",function(player) hook.Call("PlayerClosedContainerWindow",GAMEMODE,player) end)