--[[
	~ Serverside Init - Item ~
	~ Applejack ~
--]]

include("sh_init.lua");

-- Add the files that need to be sent to the client.
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("sh_init.lua");

-- This is called when the entity initializes.
function ENT:Initialize()
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_BBOX);
	self:SetSolid(SOLID_BBOX);
	self:SetUseType(SIMPLE_USE);
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	cider.propprotection.GiveToWorld(self)

	-- Get the physics object of the entity.
	local physicsObject = self:GetPhysicsObject();

	-- Check if the physics object is a valid entity.
	if ( IsValid(physicsObject) ) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end
end

-- A function to set the item of the entity
umsg.PoolString"item";
function ENT:SetItem(item,amount)
	print("ITAM", item.UniqueID);
	self.item = item;
	self:SetNWString("item",item.UniqueID);
	self.dt.amount = amount or 1
	self:SetModel(item.Model);
	if (item.Skin) then
		self:SetSkin(item.Skin);
	end
end

-- Update the ent's amount
function ENT:UpdateAmount(add)
	self.dt.amount = self.dt.amount + (add or 0)
	if self.dt.amount <= 0 then
		self:Remove()
	end
end

function ENT:CanTool(player, trace, tool)
	print(player,trace,tool)
	return player:IsSuperAdmin();
end

function ENT:PhysgunPickup(player)
	return player:IsAdmin();
end

-- Called when the entity is used.
function ENT:Use(activator, caller)
	if (not (activator:IsPlayer() and self.item)) then
		return
	end
	if (activator:KeyDown(IN_SPEED) and self.item.Equippable) then
		if (not activator:IsAdmin() and (activator._NextUseItem or 0) > CurTime()) then
			activator:Notify("You cannot use another item for "..math.ceil( activator._NextUseItem - CurTime() ).." second(s)!", 1);
			return false;
		elseif (activator:InVehicle() and self.item.NoVehicles) then
			activator:Notify("You cannot use this item here!", 1);
			return false;
		elseif (not gamemode.Call("PlayerCanUseItem", activator, self.item)) then
			return false;
		end
		activator._NextUseItem = CurTime() + 2;
		if (self.item.Weapon) then
			activator._NextHolsterWeapon = CurTime() + 5;
		end
		cider.inventory.update(activator, self.item.UniqueID, 1, true);
		if (self.item:Use(activator)) then
			GM:Log(EVENT_PICKUP,"%s picked up and used a %s.",activator:Name(),self.item.Name);
			self:UpdateAmount(-1);
		else
			cider.inventory.update(activator, self.item.UniqueID, -1, true);
		end
		return;
	end
	local picked = 0;
	if (self.item.Size == 0 or cider.inventory.canFit(activator, self.item.Size * self.dt.amount)) then
		local a,b = cider.inventory.update(activator, self.item.UniqueID, self.dt.amount);
		if (not a) then
			activator:Notify(b, 1);
			return;
		end
		picked = self.dt.amount;
	else
		local s,f
		for i = 1, self.dt.amount do
			s,f = cider.inventory.update(activator, self.item.UniqueID, 1);
			if (not s) then
				activator:Notify(f, 1);
				break
			end
			picked = picked + 1;
		end
	end
	if (picked > 0) then
		if (picked == 1) then
			GM:Log(EVENT_PICKUP,"%s picked up a %s.",activator:Name(),self.item.Name);
		else
			GM:Log(EVENT_PICKUP,"%s picked up %i %s.",activator:Name(),picked,self.item.Plural);
		end
		self:UpdateAmount(-picked);
	end
end
