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
	SWEP.IconLetter = "q";
	SWEP.DrawWeaponInfoBox = true;
	killicon.AddFont( "cider_ump", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

-- Set the base and category.
SWEP.Base = "rg_base";
SWEP.Category = "Cider";

-- Set some shared information.
SWEP.PrintName = "UMP 4.5";
SWEP.Author = "Lexi";
SWEP.Purpose = "A small sub-machine gun with a medium fire rate but high damage.";
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

-- Set some information for the primary fire.ump45-1.
SWEP.Primary.Sound = Sound("Weapon_UMP45.Single");
SWEP.Primary.Damage = 3.5;
SWEP.Primary.NumShots = 1;
SWEP.Primary.ClipSize = 25;
SWEP.Primary.DefaultClip = 25;
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
SWEP.MaxRecoil = 3;
SWEP.DeltaRecoil = 1;
SWEP.MinSpray = 0;
SWEP.MaxSpray = 2;
SWEP.DeltaSpray = 0.25;

-- Set some information about the iron sights.
--------------------
SWEP.IronSightsPos = Vector (7.3074, -3.7238, 3.2311)
SWEP.IronSightsAng = Vector (-1.18, 0.1421, 0)
--------------------


SWEP.IronSightZoom = 1;
SWEP.UseScope = false;
SWEP.ScopeScale = 0.4;
SWEP.ScopeZooms = {4, 8};
SWEP.DrawSniperSights = false;
SWEP.DrawRifleSights = false;

-- Set some information about the model and visual effects.
SWEP.ViewModel = "models/weapons/v_smg_ump45.mdl";
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl";

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
SWEP.AvailableFireModes = {"Auto", "Semi"};
SWEP.AutoRPM = 600;
SWEP.SemiRPM = 500;