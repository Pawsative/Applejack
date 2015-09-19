--[[
Name: "cl_init.lua".
	~ Applejack ~
--]]

include("sh_init.lua");

-- Add the files that need to be sent to the client.
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("sh_init.lua");

-- This is called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_wasteland/prison_padlock001a.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self.PhysgunDisabled = true
	self.m_tblToolsAllowed = {}

	-- Get the physics object of the entity.
	local physicsObject = self:GetPhysicsObject();

	-- Check if the physics object is a valid entity.
	if ( IsValid(physicsObject) ) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end
end

-- A function to set the door for the entity to breach.
function ENT:SetDoor(door, trace,owner)
	self._Door = door;
	self._Door:DeleteOnRemove(self);
	self._Planter = owner

	-- Set the position and angles of the entity.
	self:SetPos(trace.HitPos);
	self:SetAngles( trace.HitNormal:Angle() + Angle(0, 0, 0) );

	if door:GetClass() == "prop_door_rotating" then

		self:SetParent(door)
		local lpos = door:WorldToLocal(self:GetPos())
		if lpos.x < 0 then
			self:SetLocalPos(Vector(-1.3, 42.8091, 4.5221))
			self:SetLocalAngles(Angle(0,180,0))
		else
			self:SetLocalPos(Vector( 1.3, 42.8091, 4.5221))
			self:SetLocalAngles(Angle(0,-180,0))
		end
	elseif door:GetClass() == "prop_dynamic" then
		if ( IsValid( self:GetPhysicsObject() ) ) then
			self:GetPhysicsObject():EnableMotion(false);
		end
	else
		self:SetParent(door)--constraint.Weld(door, self, 0, 0);
	end
	self:SetHealth(50);
	self._Door:SetNWBool("Padlocked",true)
end

--Called when the entity takes damage.
function ENT:OnTakeDamage(damageInfo)
	if self.broken then return end
	self:SetHealth( math.max(self:Health() - damageInfo:GetDamage(), 0) );
	-- Check if the entity has run out of health.
	if (self:Health() <= 0) then
		if IsValid(self._Door) then
			if IsValid(damageInfo:GetAttacker()) and damageInfo:GetAttacker():IsPlayer() then
				local event = ""
				local addon = ""
				local entname = self._Door._eName or "entity"
				if cider.entity.isOwned(self._Door) then
					event = cider.entity.getPossessiveName(self._Door)
				else
					event = "an unowned"
				end
				if self._Door._isDoor then
					addon = cider.entity.getDoorName(self._Door)
					if addon ~= "" then
						addon = ": "..addon
					end
				else
					local name = hook.Call("GetEntityName",GAMEMODE,self._Door)
					if name and name ~= "" then
						addon = ": "..name
					end
				end

				GM:Log(EVENT_EVENT,"%s destroyed the padlock on %s %s%s.",damageInfo:GetAttacker():GetName(),event,entname,addon)
			end
			self._Door:SetNWBool("Padlocked",false)
		end
		self:FallOff();
	end
end
function ENT:FallOff()
	local pos = self:GetPos()
	self:SetParent(nil)
	self:SetPos(pos)
	constraint.RemoveAll(self)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(true)
		phys:Wake()
	end
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetModel("models/props_wasteland/prison_padlock001b.mdl")
	self.broken = true
	timer.Simple(20,function() if IsValid(self) then self:Remove() end end)
end
