--[[
Name: "shared.lua".
	~ Applejack ~
--]]

if (SERVER) then
	AddCSLuaFile("shared.lua");
else
	SWEP.DrawAmmo = true;
	SWEP.DrawCrosshair = false;
	SWEP.ViewModelFlip = true;
	SWEP.CSMuzzleFlashes = true;
	SWEP.CustomCrosshair = false -- = true;
	SWEP.Slot = 2;
	SWEP.SlotPos = 3;
	SWEP.IconLetter = "x";
	SWEP.DrawWeaponInfoBox = true;
	killicon.AddFont( "cider_mp5", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

-- Set the base and category.
SWEP.Base = "rg_base";
SWEP.Category = "Cider";

-- Set some shared information.
SWEP.PrintName = "MP5";
SWEP.Author = "kuromeku";
SWEP.Purpose = "A small sub-machine gun with a fast fire rate.";
SWEP.Instructions = "Primary Fire: Shoot.\nUse + Secondary Fire: Change the fire mode.";
SWEP.Spawnable = false;
SWEP.AdminSpawnable = false;
SWEP.Weight = 5;
SWEP.AutoSwitchTo = false;
SWEP.AutoSwitchFrom = false;
SWEP.Size = TYPE_LARGE
SWEP.TypeName = "sub-machine gun"
SWEP.HoldType = "smg";
SWEP.FiresUnderwater = true;
SWEP.HasLaser = false;
SWEP.HasSilencer = false;
SWEP.CanPenetrate = true;
SWEP.CanPenetrateWorld = true;
SWEP.BulletTracer = 1;

-- Set some information for the primary fire.
SWEP.Primary.Sound = Sound("Weapon_MP5Navy.Single");
SWEP.Primary.Damage = 25;
SWEP.Primary.NumShots = 1;
SWEP.Primary.ClipSize = 31;
SWEP.Primary.DefaultClip = 31;
SWEP.Primary.Ammo = "smg1";

-- Set some information for the secondary fire.
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;

-- Set some information about the recoil and spray.
SWEP.RecoverTime = 0.65;
SWEP.MinSpread = 0.01;
SWEP.MaxSpread = 0.06;
SWEP.DeltaSpread = 0.005;
SWEP.MinRecoil = 1;
SWEP.MaxRecoil = 5;
SWEP.DeltaRecoil = 1;
SWEP.MinSpray = 0;
SWEP.MaxSpray = 2;
SWEP.DeltaSpray = 0.25;

-- Set some information about the iron sights.
SWEP.IronSightsPos = Vector(4.7456, -4.1011, 1.7288);
SWEP.IronSightsAng = Vector(2.0327, -0.1475, 0.2779);
--------------------
SWEP.IronSightsPos = Vector (4.7431, -3.1151, 1.8602)
SWEP.IronSightsAng = Vector (1.3507, -0.1619, 0)
--------------------


SWEP.IronSightZoom = 1;
SWEP.UseScope = false;
SWEP.ScopeScale = 0.4;
SWEP.ScopeZooms = {4, 8};
SWEP.DrawSniperSights = false;
SWEP.DrawRifleSights = false;

-- Set some information about the model and visual effects.
SWEP.ViewModel = "models/weapons/v_smg_mp5.mdl";
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl";
SWEP.MuzzleEffect = "rg_muzzle_rifle";
SWEP.ShellEffect = "rg_shelleject_rifle";
SWEP.MuzzleAttachment = "1";
SWEP.ShellEjectAttachment = "2";

-- Set some modifier information.
SWEP.CrouchModifier = 0.7;
SWEP.IronSightModifier = 0.4;
SWEP.RunModifier = 1.5;
SWEP.JumpModifier = 2;

-- Set some information about the available fire modes and RPM.
SWEP.AvailableFireModes = {"Auto", "Burst", "Semi"};
SWEP.AutoRPM = 750;
SWEP.SemiRPM = 700;
SWEP.BurstRPM = 850;