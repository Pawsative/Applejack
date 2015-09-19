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
	SWEP.CustomCrosshair = false -- = false;
	SWEP.Slot = 3;
	SWEP.SlotPos = 4;
	SWEP.IconLetter = "i";
	SWEP.DrawWeaponInfoBox = true;
	killicon.AddFont( "cider_g3sg1", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

-- Set the base and category.
SWEP.Base = "rg_base";
SWEP.Category = "Cider";

-- Set some shared information.
SWEP.PrintName = "G3SG1";
SWEP.Author = "kuromeku";
SWEP.Purpose = "A very high powered sniper rifle with a silencer.";
SWEP.Instructions = "Primary Fire: Shoot.\nSecondary Fire: Zoom.";
SWEP.Spawnable = false;
SWEP.AdminSpawnable = false;
SWEP.Weight = 5;
SWEP.AutoSwitchTo = false;
SWEP.AutoSwitchFrom = false;
SWEP.Size = TYPE_LARGE
SWEP.TypeName = "rifle"
SWEP.HoldType = "smg";
SWEP.FiresUnderwater = false;
SWEP.HasLaser = true;
SWEP.HasSilencer = false;
SWEP.CanPenetrate = true;
SWEP.CanPenetrateCont = true
SWEP.CanPenetrateWorld = true;
SWEP.BulletTracer = 1;

-- Set some information for the primary fire.
SWEP.Primary.Sound = Sound("Weapon_M4A1.Silenced");
SWEP.Primary.Damage = 30;
SWEP.Primary.NumShots = 1;
SWEP.Primary.ClipSize = 10;
SWEP.Primary.DefaultClip = 10;
SWEP.Primary.Ammo = "357";

-- Set some information for the secondary fire.
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;

-- Set some information about the recoil and spray.
SWEP.RecoverTime = 1;
SWEP.MinSpread = 0.5;
SWEP.MaxSpread = 5;
SWEP.DeltaSpread = 0.5;
SWEP.MinRecoil = 5;
SWEP.MaxRecoil = 5;
SWEP.DeltaRecoil = 2;
SWEP.MinSpray = 0;
SWEP.MaxSpray = 2;
SWEP.DeltaSpray = 0.5;

-- Set some information about the iron sights.
SWEP.IronSightsPos = Vector(5.4341, -6.4904, 2.0689);
SWEP.IronSightsAng = Vector(3.6868, 1.1562, 0.9656);

SWEP.IronSightsPos = Vector (5.3997, -6.5189, 2.0978)
SWEP.IronSightsAng = Vector (1.0814, 0.4016, 0)

SWEP.IronSightZoom = 1;
SWEP.UseScope = true;
SWEP.ScopeScale = 0.4;
SWEP.ScopeZooms = {10};
SWEP.DrawSniperSights = true;
SWEP.DrawRifleSights = false;

-- Set some information about the model and visual effects.
SWEP.ViewModel = "models/weapons/v_snip_g3sg1.mdl";
SWEP.WorldModel = "models/weapons/w_snip_g3sg1.mdl";
SWEP.MuzzleEffect = "rg_muzzle_highcal";
SWEP.ShellEffect = "rg_shelleject_rifle";
SWEP.MuzzleAttachment = "1";
SWEP.ShellEjectAttachment = "2";

-- Set some modifier information.
SWEP.CrouchModifier = 0.75;
SWEP.IronSightModifier = 0;
SWEP.RunModifier = 1.5;
SWEP.JumpModifier = 2;

-- Set some information about the available fire modes and RPM.
SWEP.AvailableFireModes = {"Semi"};
SWEP.SemiRPM = 100;