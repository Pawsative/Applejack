--[[
Name: "shared.lua".
	~ Applejack ~
--]]

if (SERVER) then
	AddCSLuaFile("shared.lua");
else
	SWEP.DrawAmmo = true;
	SWEP.DrawCrosshair = true;
	SWEP.ViewModelFlip = true;
	SWEP.CSMuzzleFlashes = true;
	SWEP.CustomCrosshair = false -- = true;
	SWEP.Slot = 2;
	SWEP.SlotPos = 3;
	SWEP.IconLetter = "k";
	SWEP.DrawWeaponInfoBox = true;
	killicon.AddFont( "cider_m3super90", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

-- Set the base and category.
SWEP.Base = "rg_base";
SWEP.Category = "Cider";

-- Set some shared information.
SWEP.PrintName = "M3 Super 90";
SWEP.Author = "kuromeku";
SWEP.Purpose = "A powerful shotgun which is great at short range.";
SWEP.Instructions = "Primary Fire: Shoot.\nUse + Secondary Fire: Change the fire mode.";
SWEP.Spawnable = false;
SWEP.AdminSpawnable = false;
SWEP.Weight = 5;
SWEP.AutoSwitchTo = false;
SWEP.AutoSwitchFrom = false;
SWEP.Size = TYPE_LARGE
SWEP.TypeName = "shotgun"
SWEP.HoldType = "ar2";
SWEP.FiresUnderwater = false;
SWEP.HasLaser = false;
SWEP.HasSilencer = false;
SWEP.CanPenetrate = true;
SWEP.CanPenetrateWorld = true;
SWEP.BulletTracer = 1;

-- Set some information for the primary fire.
SWEP.Primary.Sound = Sound("Weapon_M3.Single");
SWEP.Primary.Damage = 1;
SWEP.Primary.NumShots = 1;
SWEP.Primary.ClipSize = 8;
SWEP.Primary.DefaultClip = 8;
SWEP.Primary.Ammo = "buckshot";

-- Set some information for the secondary fire.
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;

-- Set some information about the recoil and spray.
SWEP.RecoverTime = 1;
SWEP.MinSpread = 0.16;
SWEP.MaxSpread = 0.5;
SWEP.DeltaSpread = 0.01;
SWEP.MinRecoil = 3;
SWEP.MaxRecoil = 5;
SWEP.DeltaRecoil = 1;
SWEP.MinSpray = 1;
SWEP.MaxSpray = 2;
SWEP.DeltaSpray = 0.25;

-- Set some information about the iron sights.
SWEP.IronSightsPos = Vector(5.7501, -4.1011, 3.3229);
SWEP.IronSightsAng = Vector(0.3413, 0.0286, 0);
--------------------
SWEP.IronSightsPos = Vector (4.3372, -3.7733, 2.8422)
SWEP.IronSightsAng = Vector (1.5857, -1.5918, 0)
--------------------


SWEP.IronSightZoom = 1;
SWEP.UseScope = false;
SWEP.ScopeScale = 0.4;
SWEP.ScopeZooms = {4, 8};
SWEP.DrawSniperSights = false;
SWEP.DrawRifleSights = false;

-- Set some information about the model and visual effects.
SWEP.ViewModel  = "models/weapons/v_shot_m3super90.mdl";
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl";
SWEP.MuzzleEffect = "rg_muzzle_highcal";
SWEP.ShellEffect = "rg_shelleject_shotgun";
SWEP.MuzzleAttachment = "1";
SWEP.ShellEjectAttachment = "2";

-- Set some modifier information.
SWEP.CrouchModifier = 0.75;
SWEP.IronSightModifier = 0.5;
SWEP.RunModifier = 1.5;
SWEP.JumpModifier = 2;

-- Set some information about the available fire modes and RPM.
SWEP.AvailableFireModes = {"Shotgun"};
SWEP.AutoRPM = 600;
SWEP.SemiRPM = 400;

-- Called when the SWEP is reloaded.
function SWEP:Reload()
	if (CLIENT) then return end

	-- Set our iron sights to be off.
	self:SetIronsights(false);

	-- Check if we are already reloading.
	if ( self.Weapon:GetNetworkedBool("reloading", false) ) then return; end

	-- Check if we can reload.
	if (self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
		self.Weapon:SetNetworkedBool("reloading", true);
		self.Weapon:SetVar("reloadtimer", CurTime() + 0.3);
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD);
	end
end

-- Called every frame.
function SWEP:Think()
	if ( self.Weapon:GetNetworkedBool("reloading", false) ) then
		if ( self.Weapon:GetVar("reloadtimer", 0) < CurTime() ) then
			if (self.Weapon:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then
				self.Weapon:SetNetworkedBool("reloading", false)

				-- Return here because we've finished reloading.
				return;
			end

			-- Set their reload timer to be a while from now.
			self.Weapon:SetVar("reloadtimer", CurTime() + 0.3);
			self.Weapon:SendWeaponAnim(ACT_VM_RELOAD);

			-- Remove ammo from the owner.
			self.Owner:RemoveAmmo(1, self.Primary.Ammo, false);
			self.Weapon:SetClip1( self.Weapon:Clip1() + 1);

			-- Check if we've finished reloading.
			if (self.Weapon:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then
				self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH);
			end
		end
	end

	-- Check if the owner is a valid entity.
	if ( IsValid(self.Owner) ) then self.previousOwner = self.Owner; end
end

-- Define the shotgun fire mode.
SWEP.FireModes = {};
SWEP.FireModes.Shotgun = {};
SWEP.FireModes.Shotgun.NumBullets = 8;
SWEP.ShotgunRPM = 175;

-- Called when the SWEP fires.
SWEP.FireModes.Shotgun.FireFunction = function(self)
	if ( !self:CanFire( self.Weapon:Clip1() ) or self.Weapon:GetNetworkedBool("reloading", false) ) then return; end

	-- Check if we are not an NPC.
	if (!self.OwnerIsNPC) then self:TakePrimaryAmmo(1); end

	-- Shoot a cheap bullet and apply recoil to the SWEP.
	self:RGShootBulletCheap(15, self.BulletSpeed, 0.075, 0, Vector(0,0,0), self.FireModes.Shotgun.NumBullets);
	self:ApplyRecoil(6, 1);

	-- Emit the weapon sound and set the next primary fire.
	self.Weapon:EmitSound(self.Primary.Sound);
	self.Weapon:SetNextPrimaryFire(CurTime() + 1);

	-- Create the shoot effects for the SWEP.
	self:ShootEffects();
end

-- Called when the fire mode initializes.
SWEP.FireModes.Shotgun.InitFunction = function(self)
	self.Primary.Automatic = false;
	self.Primary.Delay = 60 / self.ShotgunRPM;
	self.ShellEffect = "rg_muzzle_highcal";
	self.MuzzleEffect = "rg_shelleject_shotgun";
	self.Primary.Sound = Sound("Weapon_M3.Single");
end

-- Called when we revert from this fire mode.
SWEP.FireModes.Shotgun.RevertFunction = function(self)
	self.FiresUnderwater = false;
	self.ShellEffect = "rg_muzzle_highcal";
	self.MuzzleEffect = "rg_shelleject_shotgun";
	self.Primary.Sound = Sound("Weapon_M3.Single");
end