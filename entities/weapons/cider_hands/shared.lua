--[[
Name: "shared.lua".
	~ Applejack ~
--]]

if (SERVER) then
	AddCSLuaFile("shared.lua");
end

-- Check if we're running on the client.
if (CLIENT) then
	SWEP.PrintName = "Hands";
	SWEP.Slot = 1;
	SWEP.SlotPos = 1;
	SWEP.DrawAmmo = false;
	SWEP.IconLetter = "H"
	SWEP.DrawCrosshair = false;

	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "CSSelectIcons", x + 0.59*wide, y + tall*0.2, Color(255, 220, 0, 255), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end
	killicon.AddFont( "cider_hands", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

-- Define some shared variables.
SWEP.Author	= "Lexi";
-- Bitchin smart lookin instructions o/
local title_color = "<color=230,230,230,255>"
local text_color = "<color=150,150,150,255>"
local end_color = "</color>"
SWEP.Instructions =	end_color..title_color.."Primary Fire:\t"..			end_color..text_color.." Punch / Throw\n"..
					end_color..title_color.."Secondary Fire:\t"..			end_color..text_color.." Knock / Pick Up / Drop\n"..
					end_color..title_color.."Sprint+Primary Fire:\t"..	end_color..text_color.." Lock\n"..
					end_color..title_color.."Sprint+Secondary Fire:\t"..	end_color..text_color.." Unlock";
SWEP.Purpose = "Picking stuff up, knocking on doors and punching people.";

-- Set the view model and the world model to nil.
SWEP.ViewModel = "models/weapons/v_fists.mdl";
SWEP.WorldModel = "models/weapons/w_fists.mdl";

-- Set the animation prefix and some other settings.
SWEP.AnimPrefix	= "admire";
SWEP.Spawnable = false;
SWEP.AdminSpawnable = false;

-- Set the primary fire settings.
SWEP.Primary.Damage = 1.5;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "";
SWEP.Primary.Force = 5;
SWEP.Primary.PunchAcceleration = 100
SWEP.Primary.ThrowAcceleration = 200
SWEP.Primary.Super = false;
SWEP.Primary.Refire = 1

-- Set the secondary fire settings.
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = 0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo	= "";

-- Set the iron sight positions (pointless here).
SWEP.IronSightPos = Vector(0, 0, 0);
SWEP.IronSightAng = Vector(0, 0, 0);
SWEP.NoIronSightFovChange = true;
SWEP.NoIronSightAttack = true;
SWEP.HeldEnt = NULL
local stam
-- Called when the SWEP is initialized.
function SWEP:Initialize()
	self.Primary.NextSwitch = CurTime()
	self:SetWeaponHoldType("normal");
	stam = (GM or GAMEMODE):GetPlugin("stamina");
end

-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Refire);
	if IsValid(self.HeldEnt)then
		self:DropObject(self.Primary.ThrowAcceleration)
		return
	end
	if not self.Owner:KeyDown(IN_SPEED) and self.Owner:GetNWBool"cider_Exausted" then
		return
	end
	-- Set the animation of the weapon and play the sound.
	self.Weapon:EmitSound("npc/vort/claw_swing2.wav");
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER);
	--if CLIENT then return end
	-- Get an eye trace from the owner.
	local trace = self.Owner:GetEyeTrace();


	-- Check the hit position of the trace to see if it's close to us.
	if self.Owner:GetPos():Distance(trace.HitPos) <= 128 and IsValid(trace.Entity) then
		if (trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:GetClass() == "prop_ragdoll") and not self.Owner:KeyDown(IN_SPEED) then
			if (--[[]]!self.Primary.Super and--]]
			trace.Entity:IsPlayer() and trace.Entity:Health() - self.Primary.Damage <= 15) then
				if CLIENT then return true end
				GM:Log(EVENT_EVENT,"%s knocked out %s with a punch.",self.Owner:Name(),trace.Entity:Name());
				trace.Entity._Stunned = true
				trace.Entity:KnockOut(GM.Config["Knock Out Time"] / 2);
			else
				local bullet = {}

				-- Set some information for the bullet.
				bullet.Num = 1;
				bullet.Src = self.Owner:GetShootPos();
				bullet.Dir = self.Owner:GetAimVector();
				bullet.Spread = Vector(0, 0, 0);
				bullet.Tracer = 0;
				bullet.Force = self.Primary.Force;
				bullet.Damage = self.Primary.Damage;
				if self.Primary.Super then
					bullet.Callback	= function ( attacker, tr, dmginfo )
						if  !IsValid(tr.Entity) then return end
						local effectData = EffectData();
						-- Set the information for the effect.
						effectData:SetStart( tr.HitPos );
						effectData:SetOrigin( tr.HitPos );
						effectData:SetScale(1);

						-- Create the effect from the data.
						util.Effect("Explosion", effectData);
					end
				end
				-- Fire bullets from the owner which will hit the trace entity.
				self.Owner:FireBullets(bullet);
			end
		else
			--if  then--cider.entity.isDoor(ent, true) or ent:IsVehicle() then
			if self.Owner:KeyDown(IN_SPEED) then
				self.Weapon:SetNextPrimaryFire(CurTime() + 0.75);
				self.Weapon:SetNextSecondaryFire(CurTime() + 0.75);
				--Keys!
				if CLIENT then return end
				if cider.entity.isOwnable(trace.Entity) and not trace.Entity._Jammed  then
					if cider.entity.hasAccess(trace.Entity,self.Owner) then
						trace.Entity:Lock()
						trace.Entity:EmitSound("doors/door_latch3.wav");
					else
						self.Owner:Notify("You do not have access to that!",1)
					end
				end
				return
			else
				local phys = trace.Entity:GetPhysicsObject()
				if IsValid(phys) and phys:IsMoveable() then
					trace.Entity:GetPhysicsObject():ApplyForceOffset(self.Owner:GetAimVector() * self.Primary.PunchAcceleration * phys:GetMass(), trace.HitPos);
					if self.Primary.Super then
						trace.Entity:TakeDamage(self.Primary.Damage,self.Owner)
					end
				end
			end
		end
		--]]

		-- Check if the trace hit an entity or the world.
		if (trace.Hit or trace.HitWorld) then self.Weapon:EmitSound("weapons/crossbow/hitbod2.wav"); end
	end
	if SERVER and stam and not self.Primary.Super then
		self.Owner._Stamina = math.Clamp(self.Owner._Stamina - 5,0,100)
	end
end

-- Called when the player attempts to secondary fire.
function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.25);
	if IsValid(self.HeldEnt)then
		self:DropObject()
		return
	end

	-- Get a trace from the owner's eyes.
	local trace = self.Owner:GetEyeTrace();
	--if (CLIENT) then return end
	-- Check to see if the trace entity is valid and that it's a door.
	if IsValid(trace.Entity) and self.Owner:GetPos():Distance(trace.HitPos) <= 128 then
		local ent = trace.Entity

			--self.Weapon:EmitSound("npc/vort/claw_swing2.wav");
		if cider.entity.isOwnable(ent) then
			if self.Owner:KeyDown(IN_SPEED) then
				self.Weapon:SetNextPrimaryFire(CurTime() + 0.75);
				self.Weapon:SetNextSecondaryFire(CurTime() + 0.75);
				self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER);
				--Keys!
				if CLIENT then return end
				if not trace.Entity._Jammed then
					if cider.entity.hasAccess(ent,self.Owner) then
						ent:UnLock()
						ent:EmitSound("doors/door_latch3.wav");
					else
						self.Owner:Notify("You do not have access to that!",1)
					end
				end
				return
			elseif cider.entity.isDoor(ent) then
				self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER);
				self.Weapon:EmitSound("physics/wood/wood_crate_impact_hard2.wav")
				if self.Primary.Super and SERVER and self.Owner:IsSuperAdmin() then cider.entity.openDoor(ent, 0, true, true) end
				return
			end
		end
		self:PickUp(ent,trace)
	end
end

function SWEP:Reload()
	if self.Primary.NextSwitch > CurTime() then return false end
	if self.Owner:IsAdmin() and self.Owner:KeyDown(IN_SPEED) then
		if self.Primary.Super then
			self.Primary.PunchAcceleration = 100
			self.Primary.ThrowAcceleration = 200
			self.Primary.Damage = 1.5
			self.Primary.Super = false
			self.Primary.Refire = 1
			self.Owner:PrintMessage(HUD_PRINTCENTER, "Super mode disabled")
		else
			self.Primary.PunchAcceleration = 500
			self.Primary.ThrowAcceleration = 1000
			self.Primary.Damage = 200
			self.Primary.Super = true
			self.Primary.Refire = 0
			self.Owner:PrintMessage(HUD_PRINTCENTER, "Super mode enabled")
		end
		self.Primary.NextSwitch = CurTime() + 1
	end
end
function SWEP:Think()
	if !self.HeldEnt or CLIENT then return end
	if !IsValid(self.HeldEnt) then
		if IsValid(self.EntWeld) then self.EntWeld:Remove() end
		self.Owner._HoldingEnt, self.HeldEnt.held, self.HeldEnt, self.EntWeld, self.EntAngles, self.OwnerAngles = nil
		self:Speed()
		return
	elseif !IsValid(self.EntWeld) then
		self.Owner._HoldingEnt, self.HeldEnt.held, self.HeldEnt, self.EntWeld, self.EntAngles, self.OwnerAngles = nil
		self:Speed()
		return
	end
	if !self.HeldEnt:IsInWorld() then
		self.HeldEnt:SetPos(self.Owner:GetShootPos())
		self:DropObject()
		return
	end
	if self.NoPos then return end
	local pos = self.Owner:GetShootPos()
	local ang = self.Owner:GetAimVector()
	self.HeldEnt:SetPos(pos+(ang*60))
	self.HeldEnt:SetAngles(Angle(self.EntAngles.p,(self.Owner:GetAngles().y-self.OwnerAngles.y)+self.EntAngles.y,self.EntAngles.r))
end
function SWEP:Speed(down)
	if down then
		self.Owner:SetRunSpeed( GM.Config["Incapacitated Speed"]);
		self.Owner:SetWalkSpeed(GM.Config["Incapacitated Speed"]);
		self.Owner:SetJumpPower( 0 )
	else
		self.Owner:SetRunSpeed( GM.Config["Run Speed"] );
		self.Owner:SetWalkSpeed(GM.Config["Walk Speed"]);
		self.Owner:SetJumpPower( GM.Config["Jump Power"] )
	end
end
function SWEP:Holster()
--	MsgN"Holstered"
	if CLIENT then return true end
	self:DropObject()
	self.Primary.NextSwitch = CurTime() + 1
	return true
end
function SWEP:PickUp(ent,trace)
	if CLIENT or ent.held then return end
	if (constraint.HasConstraints(ent) or ent:IsVehicle()) then
		return false
	end
	local pent = ent:GetPhysicsObject( )
	if !IsValid(pent) then return end
	if pent:GetMass() > 60 or not pent:IsMoveable() then
		return
	end
	if ent:GetClass() == "prop_ragdoll" then
--[[				cider.player.notify(self.Owner,"Temporarily disabled due to bugs. ):",1)
		self.EntWeld = constraint.Weld(ent,self.Owner,trace.PhysicsBone,0,0,1)
		if not IsValid(self.EntWeld) then
			return false
		end
		ent:DeleteOnRemove(self.EntWeld)
		self.NoPos = true
	--	print(self.EntWeld)
	--]]	return false
	else
		ent:SetCollisionGroup( COLLISION_GROUP_WORLD )
		local EntWeld = {}
		EntWeld.ent = ent
		function EntWeld:IsValid() return IsValid(self.ent) end
		function EntWeld:Remove()
			if IsValid(self.ent) then self.ent:SetCollisionGroup( COLLISION_GROUP_NONE ) end
		end
		self.NoPos = false
		self.EntWeld = EntWeld
	end
	--print(self.EntWeld)
--	print("k, pickin up")
	self.Owner._HoldingEnt = true
	self.HeldEnt = ent
	self.HeldEnt.held = true
	self.EntAngles = ent:GetAngles()
	self.OwnerAngles = self.Owner:GetAngles()
	self:Speed(true)
end
function SWEP:DropObject(acceleration)
	if CLIENT then return true end
	--[[if not acceleration then
		print("D:")
	end]]
	acceleration = acceleration or 0.1
	if !IsValid(self.HeldEnt) then return true end
	if IsValid(self.EntWeld) then self.EntWeld:Remove() end
	local pent = self.HeldEnt:GetPhysicsObject( )
	if pent:IsValid() then
		pent:ApplyForceCenter(self.Owner:GetAimVector() * pent:GetMass() * acceleration)
		--print(pent:GetMass() , acceleration,pent:GetMass() * acceleration)
	end
	self.Owner._HoldingEnt, self.HeldEnt.held, self.HeldEnt, self.EntWeld, self.EntAngles, self.OwnerAngles = nil
	self:Speed()
end
function SWEP:OnRemove( )
--	MsgN"Removed"
	if CLIENT then return true end
	self:DropObject()
	return true
end