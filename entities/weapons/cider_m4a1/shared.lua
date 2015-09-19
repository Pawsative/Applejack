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
	SWEP.Slot = 3;
	SWEP.SlotPos = 1;
	SWEP.IconLetter = "w";
	SWEP.DrawWeaponInfoBox = true;
	killicon.AddFont( "cider_m4a1", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

-- Set the base and category.
SWEP.Base = "rg_base";
SWEP.Category = "Cider";

-- Set some shared information.
SWEP.PrintName = "M4A1";
SWEP.Author = "kuromeku";
SWEP.Purpose = "A powerful rifle with a silencer attachment.";
SWEP.Instructions = "Primary Fire: Shoot.\nUse + Primary Fire: Attach/Detach the silencer.\nUse + Secondary Fire: Change the fire mode.";
SWEP.Spawnable = false;
SWEP.AdminSpawnable = false;
SWEP.Weight = 5;
SWEP.AutoSwitchTo = false;
SWEP.AutoSwitchFrom = false;
SWEP.Size = TYPE_LARGE
SWEP.TypeName = "assault rifle"
SWEP.HoldType = "ar2";
SWEP.FiresUnderwater = true;
SWEP.HasLaser = false;
SWEP.HasSilencer = true;
SWEP.CanPenetrate = true;
SWEP.CanPenetrateWorld = true;
SWEP.AnimationFix = 0.25;
SWEP.BulletTracer = 1;

-- Set some information for the primary fire.
SWEP.Primary.Sound = Sound("Weapon_M4A1.Single");
SWEP.Primary.Damage = 30;
SWEP.Primary.NumShots = 1;
SWEP.Primary.ClipSize = 30;
SWEP.Primary.DefaultClip = 30;
SWEP.Primary.Ammo = "smg1";

-- Set some information for the secondary fire.
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;

-- Set some information about the recoil and spray.
SWEP.RecoverTime = 0.7;
SWEP.MinSpread = 0.01;
SWEP.MaxSpread = 0.06;
SWEP.DeltaSpread = 0.005;
SWEP.MinRecoil = 1;
SWEP.MaxRecoil = 5;
SWEP.DeltaRecoil = 0.75;
SWEP.MinSpray = 0;
SWEP.MaxSpray = 2;
SWEP.DeltaSpray = 0.2;

-- Set some information about the iron sights.
SWEP.IronSightsPos = Vector(5.8309, -6.4258, 1.0894);
SWEP.IronSightsAng = Vector(3.6868, 1.1562, 4.8196);

--------------------
SWEP.IronSightsPos = Vector (6.2192, -1.7849, 0.893)
SWEP.IronSightsAng = Vector (3.5076, 2.5838, 4.4109)
--------------------

SWEP.IronSightZoom = 1;
SWEP.UseScope = false;
SWEP.ScopeScale = 0.4;
SWEP.ScopeZooms = {4, 8};
SWEP.DrawSniperSights = false;
SWEP.DrawRifleSights = false;

-- Set some information about the model and visual effects.
SWEP.ViewModel = "models/weapons/v_rif_m4a1.mdl";
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl";
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