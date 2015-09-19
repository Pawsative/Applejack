--[[
Name: "init.lua".
	~ Applejack ~
--]]

include("sh_init.lua");

-- Add the files that need to be sent to the client.
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("sh_init.lua");

AccessorFunc(ENT, "iPlayer", "Player");

-- This is called when the entity initializes.
function ENT:Initialize()
	self:SetModel(self.Model);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	-- Get the physics object of the entity.
	local physicsObject = self:GetPhysicsObject();

	-- Check if the physics object is a valid entity.
	if ( IsValid(physicsObject) ) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end

	-- Get the contraband table.
	local contraband = GM.Config["Contraband"][ self:GetClass() ];

	-- Check if the contraband table is valid.
	if (contraband) then
		self:SetHealth(contraband.health);
		self.dt.energy = contraband.energy;
	else
		timer.Simple(0, function()
			self.Remove(self);
		end)
	end
end

function ENT:CanTool(player, trace, tool)
	return player:IsSuperAdmin();
end

function ENT:PhysgunPickup(player)
	return player:IsAdmin();
end

-- Called when the entity takes damage.
function ENT:OnTakeDamage(damageInfo)
	local killer = damageInfo:GetInflictor();

	-- Check if the player can destroy the contraband.
	if ( IsValid(killer) and killer:IsPlayer()
	and hook.Call("PlayerCanDestroyContraband", GAMEMODE, killer, self) ) then
		self:SetHealth( math.max(self:Health() - damageInfo:GetDamage(), 0) );

		-- Check if the entity has run out of health.
		if (self:Health() <= 0) then
			if ( IsValid(killer) and killer:IsPlayer() )then
				hook.Call("PlayerDestroyedContraband",GAMEMODE, killer, self)
			end

			-- Explode the contraband and then remove it.
			self:Explode();
			self:Remove();
		end
	end
end

-- Explode the entity.
function ENT:Explode()
	local effectData = EffectData();

	-- Set the information for the effect.
	effectData:SetStart( self:GetPos() );
	effectData:SetOrigin( self:GetPos() );
	effectData:SetScale(2);

	-- Create the effect from the data.
	util.Effect("Explosion", effectData);
end

-- Called when a player uses the entity.
function ENT:Use(player, caller)
	if (self.dt.energy < 5) then
		self.dt.energy = 5;

		-- Get some new effect data.
		local effectData = EffectData();

		-- Set the information for the effect.
		effectData:SetOrigin( self:GetPos() );
		effectData:SetMagnitude(2);
		effectData:SetScale(2);
		effectData:SetRadius(2);

		-- Create the effect from the data.
		util.Effect("Sparks", effectData, true, true);
	end
end
