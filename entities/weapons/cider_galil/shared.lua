--[[
Name: "shared.lua".
	~ Applejack ~
--]]

if (SERVER) then
	AddCSLuaFile("shared.lua");
else
	SWEP.Slot = 3;
	SWEP.SlotPos = 4;
	SWEP.DrawAmmo = true;
	SWEP.IconLetter = "v";
	SWEP.DrawCrosshair = false;
	SWEP.CSMuzzleFlashes = true;
	SWEP.CustomCrosshair = false -- = true;
	SWEP.DrawWeaponInfoBox = true;
	killicon.AddFont( "cider_galil", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

-- Set the base and category.
SWEP.Base = "rg_base";
SWEP.Category = "Cider";

-- Set some view model information.
SWEP.ViewModelFOV = 75;
SWEP.ViewModelFlip = false;

-- Set some shared information.
SWEP.PrintName = "Galil";
SWEP.Author = "kuromeku";
SWEP.Purpose = "Less powerful than the AK47 but with a faster firerate.";
SWEP.Instructions = "Primary Fire: Shoot.\nUse + Secondary Fire: Change the fire mode.";
SWEP.Spawnable = false;
SWEP.AdminSpawnable = false;
SWEP.Weight = 5;
SWEP.AutoSwitchTo = false;
SWEP.AutoSwitchFrom = false;
SWEP.Size = TYPE_LARGE
SWEP.TypeName = "assault rifle"
SWEP.HoldType = "ar2";
SWEP.FiresUnderwater = false;
SWEP.HasLaser = false;
SWEP.HasSilencer = false;
SWEP.CanPenetrate = true;
SWEP.CanPenetrateWorld = true;
SWEP.BulletTracer = 1;

-- Set some information for the primary fire.
SWEP.Primary.Sound = Sound("Weapon_Galil.Single");
SWEP.Primary.Damage = 5;
SWEP.Primary.NumShots = 1;
SWEP.Primary.ClipSize = 35;
SWEP.Primary.DefaultClip = 35;
SWEP.Primary.Ammo = "smg1";

-- Set some information for the secondary fire.
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;

-- Set some information about the recoil and spray.
SWEP.RecoverTime = 0.70;
SWEP.MinSpread = 0.01;
SWEP.MaxSpread = 0.07;
SWEP.DeltaSpread = 0.008;
SWEP.MinRecoil = 1;
SWEP.MaxRecoil = 5;
SWEP.DeltaRecoil = 1;
SWEP.MinSpray = 0;
SWEP.MaxSpray = 2;
SWEP.DeltaSpray = 0.25;

-- Set some information about the iron sights.
SWEP.IronSightsPos = Vector(-5.15, -3, 2.37);
SWEP.IronSightsAng = Vector(-0.4, 0, 0);
--------------------
SWEP.IronSightsPos = Vector (-5.1379, -2.58, 2.2395)
SWEP.IronSightsAng = Vector (0.0254, 0.0961, 0)
--------------------

SWEP.IronSightZoom = 1;
SWEP.UseScope = false;
SWEP.ScopeScale = 0.4;
SWEP.ScopeZooms = {4, 8};
SWEP.DrawSniperSights = false;
SWEP.DrawRifleSights = false;

-- Set some information about the model and visual effects.
SWEP.ViewModel = "models/weapons/v_rif_galil.mdl";
SWEP.WorldModel = "models/weapons/w_rif_galil.mdl";
SWEP.MuzzleEffect = "rg_muzzle_highcal";
SWEP.ShellEffect = "rg_shelleject_rifle";
SWEP.MuzzleAttachment = "1";
SWEP.ShellEjectAttachment = "2";

-- Set some modifier information.
SWEP.CrouchModifier = 0.7;
SWEP.IronSightModifier = 0.4;
SWEP.RunModifier = 1.5;
SWEP.JumpModifier = 2;

-- Set some information about the available fire modes and RPM.
SWEP.AvailableFireModes = {"Auto", "Semi"};
SWEP.AutoRPM = 675;
SWEP.SemiRPM = 500;