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
	SWEP.IconLetter = "c";
	SWEP.DrawWeaponInfoBox = true;
	killicon.AddFont( "cider_glock18", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

-- Set the base and category.
SWEP.Base = "rg_base";
SWEP.Category = "Cider";

-- Set some shared information.
SWEP.PrintName = "Glock 18";
SWEP.Author = "kuromeku";
SWEP.Purpose = "A weak pistol but effective at short range.";
SWEP.Instructions = "Primary Fire: Shoot.";
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
SWEP.HasSilencer = false;
SWEP.CanPenetrate = false;
SWEP.CanPenetrateWorld = false;
SWEP.BulletTracer = 1;

-- Set some information for the primary fire.
SWEP.Primary.Sound = Sound("Weapon_Glock.Single");
SWEP.Primary.Damage = 2.5;
SWEP.Primary.NumShots = 1;
SWEP.Primary.ClipSize = 16;
SWEP.Primary.DefaultClip = 16;
SWEP.Primary.Ammo = "pistol";

-- Set some information for the secondary fire.
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;

-- Set some information about the recoil and spray.
SWEP.RecoverTime = 0.6;

SWEP.MinSpread = 0.4;
SWEP.MaxSpread = 0.9;
SWEP.DeltaSpread = 0.3;
SWEP.MinRecoil = 5;
SWEP.MaxRecoil = 7;
SWEP.DeltaRecoil = 1;
SWEP.MinSpray = 1;
SWEP.MaxSpray = 2;
SWEP.DeltaSpray = 0.25;

-- Set some information about the iron sights.
SWEP.IronSightsPos = Vector(4.3337, -6.4072, 2.6426);
SWEP.IronSightsAng = Vector(2.0239, -0.0813, -0.1968);
--------------------
SWEP.IronSightsPos = Vector (4.327, -2.0574, 2.7606)
SWEP.IronSightsAng = Vector (0.8812, -0.0446, 0)
--------------------

SWEP.IronSightZoom = 1;
SWEP.UseScope = false;
SWEP.ScopeScale = 0.4;
SWEP.ScopeZooms = {4, 8};
SWEP.DrawSniperSights = false;
SWEP.DrawRifleSights = false;

-- Set some information about the model and visual effects.
SWEP.ViewModel = "models/weapons/v_pist_glock18.mdl";
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl";
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
SWEP.AvailableFireModes = {"Semi"};
SWEP.SemiRPM = 325;