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
	SWEP.Slot = 1;
	SWEP.SlotPos = 5;
	SWEP.IconLetter = "a";
	SWEP.DrawWeaponInfoBox = true;
	killicon.AddFont( "cider_usp45", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

-- Set the base and category.
SWEP.Base = "rg_base";
SWEP.Category = "Cider";

-- Set some shared information.
SWEP.PrintName = "USP .45";
SWEP.Author = "kuromeku";
SWEP.Purpose = "A powerful pistol with burst fire and a silencer.";
SWEP.Instructions = "Primary Fire: Shoot.\nUse + Primary Fire: Attach/Detach the silencer.\nUse + Secondary Fire: Change the fire mode.";
SWEP.Spawnable = false;
SWEP.AdminSpawnable = false;
SWEP.Weight = 5;
SWEP.AutoSwitchTo = false;
SWEP.AutoSwitchFrom = false;
SWEP.Size = TYPE_SMALL
SWEP.TypeName = "pistol"
SWEP.HoldType = "pistol";
SWEP.FiresUnderwater = false;
SWEP.HasLaser = false;
SWEP.HasSilencer = true;
SWEP.CanPenetrate = true;
SWEP.CanPenetrateWorld = true;
SWEP.AnimationFix = 0.25;
SWEP.BulletTracer = 1;

-- Set some information for the primary fire.
SWEP.Primary.Sound = Sound("Weapon_USP.Single");
SWEP.Primary.Damage = 2.75;
SWEP.Primary.NumShots = 1;
SWEP.Primary.ClipSize = 12;
SWEP.Primary.DefaultClip = 12;
SWEP.Primary.Ammo = "pistol";

-- Set some information for the secondary fire.
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;

-- Set some information about the recoil and spray.
SWEP.RecoverTime = 0.65;
SWEP.MinSpread = 0.02;
SWEP.MaxSpread = 0.05;
SWEP.DeltaSpread = 0.012;
SWEP.MinRecoil = 1;
SWEP.MaxRecoil = 3;
SWEP.DeltaRecoil = 1;
SWEP.MinSpray = 0;
SWEP.MaxSpray = 2;
SWEP.DeltaSpray = 0.25;

-- Set some information about the iron sights.
SWEP.IronSightsPos = Vector(4.5106, -6.4072, 2.3808);
SWEP.IronSightsAng = Vector(2.0239, -0.0813, 0.5508);
--------------------
SWEP.IronSightsPos = Vector (4.4896, -1.4454, 2.6242)
SWEP.IronSightsAng = Vector (0.314, -0.0861, 0)
--------------------

SWEP.IronSightZoom = 1;
SWEP.UseScope = false;
SWEP.ScopeScale = 0.4;
SWEP.ScopeZooms = {4, 8};
SWEP.DrawSniperSights = false;
SWEP.DrawRifleSights = false;

-- Set some information about the model and visual effects.
SWEP.ViewModel = "models/weapons/v_pist_usp.mdl";
SWEP.WorldModel = "models/weapons/w_pist_usp.mdl";
SWEP.MuzzleEffect = "rg_muzzle_pistol";
SWEP.ShellEffect = "rg_shelleject";
SWEP.MuzzleAttachment = "1";
SWEP.ShellEjectAttachment = "2";

-- Set some modifier information.
SWEP.CrouchModifier = 0.7;
SWEP.IronSightModifier = 0.4;
SWEP.RunModifier = 1.5;
SWEP.JumpModifier = 2;

-- Set some information about the available fire modes and RPM.
SWEP.AvailableFireModes = {"Semi", "Burst"};
SWEP.SemiRPM = 350;
SWEP.BurstRPM = 850;