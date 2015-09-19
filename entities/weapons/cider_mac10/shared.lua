--[[
Name: "shared.lua".
	~ Applejack ~
--]]

if (SERVER) then
	AddCSLuaFile("shared.lua");
else
	SWEP.DrawAmmo			= true;
	SWEP.DrawCrosshair		= false;
	SWEP.ViewModelFlip		= true;
	SWEP.CSMuzzleFlashes	= true;
	SWEP.CustomCrosshair	= false -- = true;
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 1;
	SWEP.IconLetter			= "l"
	SWEP.DrawWeaponInfoBox	= true;
	killicon.AddFont( "cider_mac10", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

-- Set the base and category.
SWEP.Base = "rg_base";
SWEP.Category = "Cider";

-- Set some shared information.
SWEP.PrintName				= "Mac 10";
SWEP.Author					= "Lexi";
SWEP.Purpose				= "A concealable machine pistol";
SWEP.Instructions			= "Primary Fire: Shoot.";
SWEP.Spawnable				= false;
SWEP.AdminSpawnable			= false;
SWEP.Weight					= 5;
SWEP.AutoSwitchTo			= false;
SWEP.AutoSwitchFrom			= false;
SWEP.Size					= TYPE_SMALL
SWEP.TypeName				= "machine pistol"
SWEP.HoldType				= "ar2";
SWEP.FiresUnderwater		= false;
SWEP.HasLaser				= false;
SWEP.HasSilencer			= false;
SWEP.CanPenetrate			= true;
SWEP.CanPenetrateWorld		= true;
SWEP.BulletTracer			= 1;

-- Set some information for the primary fire.
SWEP.Primary.Sound			= Sound( "Weapon_mac10.Single" )
SWEP.Primary.Damage			= 3;
SWEP.Primary.NumShots		= 1;
SWEP.Primary.ClipSize		= 30;
SWEP.Primary.DefaultClip	= 30;
SWEP.Primary.Ammo			= "pistol";

-- Set some information for the secondary fire.
SWEP.Secondary.ClipSize		= -1;
SWEP.Secondary.DefaultClip	= -1;

-- Set some information about the recoil and spray.
SWEP.RecoverTime			= 0.75;
SWEP.MinSpread				= 0.05;
SWEP.MaxSpread				= 0.16;
SWEP.DeltaSpread			= 0.07;
SWEP.MinRecoil				= 1;
SWEP.MaxRecoil				= 3;
SWEP.DeltaRecoil			= 1;
SWEP.MinSpray				= 2;
SWEP.MaxSpray				= 5;
SWEP.DeltaSpray				= 0.5;

-- Set some information about the iron sights.

--------------------
SWEP.IronSightsPos = Vector (6.801, -1.8373, 2.8461)
SWEP.IronSightsAng = Vector (1.4081, 5.2456, 8.2831)
--------------------


SWEP.IronSightZoom 			= 1;
SWEP.UseScope 				= false;
SWEP.DrawSniperSights 		= false;
SWEP.DrawRifleSights 		= false;

-- Set some information about the model and visual effects.
SWEP.ViewModel				= "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_mac10.mdl"
SWEP.MuzzleEffect 			= "rg_muzzle_pistol";
SWEP.ShellEffect 			= "rg_shelleject";
SWEP.MuzzleAttachment 		= "1";
SWEP.ShellEjectAttachment	= "2";

-- Set some modifier information.
SWEP.CrouchModifier 		= 0.7;
SWEP.IronSightModifier 		= 0.5;
SWEP.RunModifier 			= 2;
SWEP.JumpModifier 			= 5;

-- Set some information about the available fire modes and RPM.
SWEP.AvailableFireModes 	= {"Auto"};
SWEP.AutoRPM 				= 600;