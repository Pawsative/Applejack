--[[
Name: "shared.lua".
	~ Applejack ~
--]]

if (SERVER) then
	AddCSLuaFile("shared.lua");
end

-- Check if we're running on the client.
if (CLIENT) then
	SWEP.PrintName = "Baton";
	SWEP.Slot = 0;
	SWEP.SlotPos = 0;
	SWEP.DrawAmmo = false;
	SWEP.DrawCrosshair = true;
	SWEP.IconLetter = "n";
end

-- Define some shared variables.
SWEP.Author	= "Lexi"; --Admitedly, mostly made up of kudo's parts.
SWEP.Instructions = "Primary Fire: Knock Out. Use+Primary Fire: Damage\nSecondary Fire: Arrest/breach door.";
--SWEP.Contact = "urmom@urhouse lol.";
SWEP.Purpose = "General Purpous Electrical Baton";

-- Set the view model and the world model to nil.
SWEP.ViewModel = "models/weapons/v_stunstick.mdl";
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl";

-- Set the animation prefix and some other settings.
SWEP.AnimPrefix	= "stunstick";
SWEP.Spawnable = false;
SWEP.AdminSpawnable = false;

-- Set the primary fire settings.
SWEP.Primary.Delay = 0.75;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "";

-- Set the secondary fire settings.
SWEP.Secondary.Delay = 0.75;
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = 0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo	= "";

-- Set the iron sight positions (pointless here).
SWEP.IronSightPos = Vector(0, 0, 0);
SWEP.IronSightAng = Vector(0, 0, 0);
SWEP.NoIronSightFovChange = true;
SWEP.NoIronSightAttack = true;

-- Called when the SWEP is initialized.
function SWEP:Initialize()
	self:SetWeaponHoldType("melee");
end
-- Do the SWEP's hit effects. <-- Credits to kuromeku
function SWEP:DoHitEffects(sound)
	local trace = self.Owner:GetEyeTrace();
	-- Check if the trace hit or it hit the world.
	if ( ( (trace.Hit or trace.HitWorld) and self.Owner:GetPos():Distance(trace.HitPos) <= 96 ) ) then
		if ( IsValid(trace.Entity) and ( trace.Entity:IsPlayer() or trace.Entity:IsNPC() ) ) then
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER);
			self.Weapon:EmitSound(sound or "weapons/stunstick/stunstick_fleshhit"..math.random(1, 2)..".wav");
		elseif ( IsValid(trace.Entity)
		and IsValid( trace.Entity:GetNetworkedEntity("cydar_Player") ) ) then
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER);
			self.Weapon:EmitSound(sound or "weapons/stunstick/stunstick_fleshhit"..math.random(1, 2)..".wav");
		else
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER);
			self.Weapon:EmitSound(sound or "weapons/stunstick/stunstick_impact"..math.random(1, 2)..".wav");
		end

		-- Create new effect data.
		local effectData = EffectData();

		-- Set some information about the effect.
		effectData:SetStart(trace.HitPos);
		effectData:SetOrigin(trace.HitPos)
		effectData:SetScale(32);

		-- Create the effect.
		util.Effect("StunstickImpact", effectData);
	else
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER);
		self.Weapon:EmitSound("weapons/stunstick/stunstick_swing1.wav");
	end
end
function SWEP:GetPlayer(ent)
	if (self.Owner.LagCompensation) then
		self.Owner:LagCompensation(true);
	end
	local tr = self.Owner:GetEyeTrace();
	if (self.Owner.LagCompensation) then
		self.Owner:LagCompensation(false);
	end
	local ent = tr.Entity;
	if (not IsValid(ent) or self.Owner:GetPos():Distance(tr.HitPos) > 128) then
		return false;
	elseif(IsValid(ent._Player)) then -- Player Ragdoll
		ent = ent._Player;
	elseif (ent:IsVehicle()) then
		if (ent:GetClass() ~= "prop_vehicle_jeep") then
			ent = ent:GetDriver();
		else
			tr = util.QuickTrace(tr.HitPos, tr.Normal * 512, ent);
			if (IsValid(tr.Entity)) then
				ent = tr.Entity;
				if (ent:IsVehicle() and ent:GetClass() == "prop_vehicle_prisoner_pod" and IsValid(ent:GetDriver())) then
					ent = ent:GetDriver();
				elseif (not(ent:IsPlayer() and ent:InVehicle())) then
					return false;
				end
			end
		end
	end
	if (ent:IsPlayer() and not (ent:Alive() and (ent:GetMoveType() ~= MOVETYPE_NOCLIP or ent:InVehicle()))) then
		return false;
	end
	return ent;
end
-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay);
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay);
	-- Set the animation of the owner and weapon and play the sound.
	self.Owner:SetAnimation(PLAYER_ATTACK1);
	self:DoHitEffects()

	-- Check if we're running on the client.
	if (CLIENT) then return; end

	local player = self:GetPlayer(true)

	-- Check to see if the entity is a player and that it's close to the owner.
	if player then
		if not player:IsPlayer() then
			if GM.Config["Contraband"][player:GetClass()] then -- Theese lets us remove contra with a single baton blast
				player:TakeDamage(player:Health(),self.Owner,self.Owner)
			end
		elseif not player:Alive() then
			return false
		elseif self.Owner:KeyDown(IN_USE) and hook.Call("PlayerCanStun", GAMEMODE, self.Owner, player) then --VIOLENCE YAY \O/
			local normal = ( player:GetPos() - self.Owner:GetPos() ):Normalize();
			local push = 256 * normal;
			-- Set the velocity of the player.
			player:SetLocalVelocity(push);
			player:TakeDamage(10, self.Owner, self.Owner);
		elseif !player:KnockedOut() and hook.Call("PlayerCanKnockOut", GAMEMODE, self.Owner, player) then
			if player:InVehicle() then player:ExitVehicle() end
			player:KnockOut(60);
			if player.ragdoll then
				player.ragdoll.time = CurTime() + 2
			end
			player._Stunned = true
			-- Let the administrators know that this happened.
			GM:Log(EVENT_POLICEEVENT,"%s knocked out %s.",self.Owner:Name(),player:Name());
			-- Call a hook.
			hook.Call("PlayerKnockedOut", GAMEMODE, player, self.Owner);
		elseif player:KnockedOut() and hook.Call("PlayerCanWakeUp", GAMEMODE, self.Owner, player) then
			player:WakeUp();
			-- Let the administrators know that this happened.
			GM:Log(EVENT_POLICEEVENT,"%s woke up %s.",self.Owner:Name(),player:Name())
			-- Call a hook.
			hook.Call("PlayerWokenUp", GAMEMODE, player, self.Owner)
		end
	end
end

-- Called when the player attempts to secondary fire.
function SWEP:SecondaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay);
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay);
	-- Set the animation of the owner and weapon and play the sound.
	self.Owner:SetAnimation(PLAYER_ATTACK1);
	self:DoHitEffects()

	-- Check if we're running on the client.
	if (CLIENT) then return; end

	local player = self:GetPlayer(true)

	-- Check to see if the entity is a player and that it's close to the owner.
	if player then
		if player:IsPlayer() then
			if player.cider._Arrested and  hook.Call("PlayerCanUnarrest", GAMEMODE, self.Owner, player)  then
				if player:KnockedOut() then player:WakeUp() end
				player:UnArrest();
				-- Let the administrators know that this happened.
				GM:Log(EVENT_POLICEEVENT,"%s unarrested %s.",self.Owner:Name(),player:Name());

				-- Call a hook.
				hook.Call("PlayerUnarrest", GAMEMODE, self.Owner, player);
			elseif !player.cider._Arrested and hook.Call("PlayerCanArrest", GAMEMODE, self.Owner, player)  then
				if player:KnockedOut() then player:WakeUp() end
				if player:InVehicle() then player:ExitVehicle() end
				player:Arrest();

				-- Let the administrators know that this happened.
				GM:Log(EVENT_POLICEEVENT,"%s arrested %s.",self.Owner:Name(),player:Name());

				-- Call a hook.
				hook.Call("PlayerArrest", GAMEMODE, self.Owner, player);
			end
		elseif cider.entity.isDoor(player,true) and hook.Call("PlayerCanRamDoor", GAMEMODE, self.Owner, player) then
		--	local jam =
			cider.entity.openDoor(player, 0.25, true, true, hook.Call("PlayerCanJamDoor",GAMEMODE,self.Owner, player));
		end
	end
end
