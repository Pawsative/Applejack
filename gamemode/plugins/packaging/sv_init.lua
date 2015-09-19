--[[
	~ Packaging Plugin ~
	~ Applejack ~
--]]

PLUGIN.Name = "Packaging"
--[[
	Packaging plugin, to create disposable containers that automatically seal themselves after being spawned initially.
	(Does not work every time in actual application on the server =/)
--]]
function PLUGIN:PlayerClosedContainerWindow(player)
	if IsValid(player._UsingCrate) and cider.container.isContainer(player._UsingCrate) then -- If the player is using a crate then we want to seal it!
		local crate = player._UsingCrate
		crate._Sealed = true
	--	crate:SetNWBool("cider_Sealed",true)
		crate:SetDTInt(3, crate:GetDTInt(3) +  OBJ_SEALED);
		crate._InUse = nil
		local phys = crate:GetPhysicsObject()
			if IsValid(phys) then
			phys:EnableMotion(true)
			phys:Wake()
		end
		player:Emote("seals the "..cider.container.getName(crate).." with some tape.");
		player._UsingCrate = nil
	end
end


function PLUGIN:CrateTime(player,item)
	if player._UsingCrate then
		return false
	end
	local crate = ents.Create"prop_physics"
	crate:SetModel(item.Model)
	local trace = player:GetEyeTraceNoCursor()
	if player:GetPos():Distance(trace.HitPos) > 128 then
		crate:SetPos(player:GetShootPos() + player:GetAimVector() * 128)
		local Angles = player:GetAngles()
		Angles.pitch = 0
		Angles.roll = 0
		crate:SetAngles(Angles)
	elseif trace.Hit then
		local Ang = trace.HitNormal:Angle()
		Ang.pitch = Ang.pitch + 90
		crate:SetPos( trace.HitPos - trace.HitNormal * crate:OBBMins().z )
		crate:SetAngles( Ang )
	end
	cider.propprotection.PlayerMakePropOwner(player,crate,true)
	crate:Spawn()
	crate:Activate()
	if item.skin then
		crate:SetSkin(item.Skin)
	end
	crate:SetHealth(50)
	local phys = crate:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	else
		ErrorNoHalt("[",os.date(),"] Packaging Plugin:  Error while creating packaging with model ",item.Model,", model has no physics!")
		player:Notify("Physics error! Please report this immedidately.",1)
		crate:Remove()
		return false
	end
	cider.container.make(crate, item.Capacity, item.Name)
	local contents,io,filter = cider.container.getContents(crate,player,true)
	local tab = {
		contents = contents,
		meta = {
			io = io,
			filter = filter, -- Only these can be put in here, if nil then ignore, but empty means nothing.
			size = cider.container.getLimit(crate), -- Max space for the container
			entindex = crate:EntIndex(), -- You'll probably want it for something
			name = cider.container.getName(crate) or "Container"
		}
	}
	net.Start("cider_Container")
		net.WriteTable(tab)
	net.Send(player)
	crate._InUse = player
	player._UsingCrate = crate
end

function PLUGIN:PlayerCanUseContainer(player,container)
	if container._InUse and container._InUse ~= player then return false end
end

function PLUGIN:PlayerUpdateContainerContents(player, entity,item,amount,force)
	if not entity._InUse then return end
	if not( force or cider.container.canFit(entity,item,amount,player)) then
		player:Notify("Cannot fit that item in!",1)-- This is to stop the menu from being force-closed.
		return true
	end
end