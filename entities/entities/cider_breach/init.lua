--[[
Name: "cl_init.lua".
	~ Applejack ~
--]]

-- TODO: This will error if a player disconnects after planting.
include("sh_init.lua");

-- Add the files that need to be sent to the client.
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("sh_init.lua");

-- This is called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/weapons/w_c4_planted.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetSolid(SOLID_NONE);
	self:SetUseType(SIMPLE_USE);
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
local function dobreach(self)
	if not (IsValid(self) and IsValid(self._Door)) then return end
	local event = ""
	local addon = cider.entity.getDoorName(self._Door)
	if addon ~= "" then
		addon = ": "..addon
	end
	if cider.entity.isOwned(self._Door) then
		event = cider.entity.getPossessiveName(self._Door)
	else
		event = "an unowned"
	end
	GM:Log(EVENT_EVENT,"%s breached %s door%s.",self._Planter:GetName(),event,addon)
	cider.entity.openDoor(self._Door, 0, true, true, hook.Call("PlayerCanJamDoor",GAMEMODE,self._Planter,self._Door));
	if self._Door:GetClass() == "prop_door_rotating" then
		self:BlowDoorOffItsHinges()
	end
	self:Remove();
	self:Explode();
end
function ENT:SetDoor(door, trace,owner)
	self._Door = door;
	self._Door:DeleteOnRemove(self);
	self._Planter = owner

	-- Set the position and angles of the entity.
	self:SetPos(trace.HitPos);
	self:SetAngles( trace.HitNormal:Angle() + Angle(-90, 0, 180) );

	if door:GetClass() == "prop_door_rotating" then

		self:SetParent(door)
		local lpos = door:WorldToLocal(self:GetPos())
		if lpos.x < 0 then
			self:SetLocalPos(Vector(-1.5, 21.3057, -8.1018))
			self:SetLocalAngles(Angle(-90,0,0))
		else
			self:SetLocalPos(Vector(1.5, 21.3057, -8.1018))
			self:SetLocalAngles(Angle(-90,-180,0))
		end
	elseif door:GetClass() == "prop_dynamic" then
		if ( IsValid( self:GetPhysicsObject() ) ) then
			self:GetPhysicsObject():EnableMotion(false);
		end
	else
		constraint.Weld(door, self, 0, 0);
	end

	-- Set the health of the entity.
	self:Beep()
	local i = 1
	timer.Create(self:EntIndex().."Beep1",1,5,function()
		if not (IsValid(self) and IsValid(self._Door)) then return end
		if i == 5 then
			timer.Create(self:EntIndex().."Beep2",0.2,5, function()
				self.Beep(self)
			end)
		end
		self:Beep()
		i = i + 1
	end)
	timer.Simple(6.1, function()
		dobreach(self)
	end)
end

local function dothrow(ent,backwards)
	if not IsValid(ent) then return end
	local pent = ent:GetPhysicsObject()
	if not IsValid(pent) then return end
	pent:ApplyForceCenter(backwards * 10000)
end
local function doremove(ent,door)
	if IsValid(ent) then
		ent:Remove()
	end
	if IsValid(door) then
		door:SetNotSolid(false)
		door:SetNoDraw(false)
	end
end
function ENT:BlowDoorOffItsHinges()
	local backwards = self:GetUp() * -1 -- If you fuck with the model, this won't work
	local pos   = self._Door:GetPos()
	local ang   = self._Door:GetAngles()
	local model = self._Door:GetModel()
	local skin  = self._Door:GetSkin()
	self._Door:SetNotSolid(true)
	self._Door:SetNoDraw(true)
	local ent = ents.Create("prop_physics")
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent:SetModel(model)
	if (skin) then
		ent:SetSkin(skin)
	end
	ent:Spawn()
	ent:Activate()
	cider.propprotection.GiveToWorld(ent)
	local door = self._Door
	timer.Simple(0.1, function()
		dothrow(ent,backwards);
	end)
	timer.Simple(GM.Config["Jam Time"], function() doremove(ent,door) end)
end
local beep = Sound("hl1/fvox/beep.wav")
function ENT:Beep()
	self:EmitSound(beep)
end

-- Explode the entity.
function ENT:Explode()
	local effectData = EffectData();

	-- Set the information for the effect.
	effectData:SetStart( self:GetPos() );
	effectData:SetOrigin( self:GetPos() );
	effectData:SetScale(1);

	-- Create the effect from the data.
	util.Effect("Explosion", effectData);
	util.BlastDamage(self._Planter,self,self:GetPos(),256,100) -- Ouch!
end