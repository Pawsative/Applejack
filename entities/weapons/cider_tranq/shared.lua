--[[
Name: "shared.lua".
	~ Applejack ~
--]]
if !cider then return end
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
	SWEP.IconLetter = "n";
	SWEP.DrawWeaponInfoBox = true;
	killicon.AddFont( "cider_tranq", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

-- Set the base and category.
SWEP.Base = "rg_base";
SWEP.Category = "Cider";

-- Set some shared information.
SWEP.PrintName = "Tranq Gun";
SWEP.Author = "Lexi";
SWEP.Purpose = "A silenced tranq gun with a scope";
SWEP.Instructions = "Primary Fire: Knock Out.\nSecondary Fire: Zoom.";
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
SWEP.CanPenetrateWorld = true;
SWEP.BulletTracer = 1;

-- Set some information for the primary fire.
SWEP.Primary.Sound = Sound("Weapon_M4A1.Silenced");
SWEP.Primary.Damage = 0;
SWEP.Primary.NumShots = 1;
SWEP.Primary.ClipSize = 1;
SWEP.Primary.DefaultClip = 1;
SWEP.Primary.Ammo = "AR2";

-- Set some information for the secondary fire.
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;

-- Set some information about the recoil and spray.
SWEP.RecoverTime = 1;
SWEP.MinSpread = 0.5;
SWEP.MaxSpread = 5;
SWEP.DeltaSpread = 0.5;
SWEP.MinRecoil = 1;
SWEP.MaxRecoil = 3;
SWEP.DeltaRecoil = 2;
SWEP.MinSpray = 0;
SWEP.MaxSpray = 2;
SWEP.DeltaSpray = 0.5;

-- Set some information about the iron sights.
SWEP.IronSightsPos = Vector(5.4341, -6.4904, 2.0689);
SWEP.IronSightsAng = Vector(3.6868, 1.1562, 0.9656);
--------------------
SWEP.IronSightsPos = Vector (4.9966, -10.164, 2.4268)
SWEP.IronSightsAng = Vector (2.0689, -0.4242, 0)
--------------------

SWEP.IronSightZoom = 1;
SWEP.UseScope = true;
SWEP.ScopeScale = 0.4;
SWEP.ScopeZooms = {5, 15};
SWEP.DrawSniperSights = true;
SWEP.DrawRifleSights = false;

-- Set some information about the model and visual effects.
SWEP.ViewModel = "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl";
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
function SWEP:PrimaryAttack()
	if (not self:CanPrimaryAttack()) then
		return false;
	elseif (self.Owner.LagCompensation) then
		self.Owner:LagCompensation(true);
	end
	local tr = self.Owner:GetEyeTraceNoCursor();
	if (self.Owner.LagCompensation) then
		self.Owner:LagCompensation(false);
	end
	self.Owner:FireBullets({
		Num = self.Primary.NumShots;
		Src = self.Owner:GetShootPos();
		Dir = self.Owner:GetAimVector();
		Spread = vector_origin;
		Tracer = self.BulletTracer;
		Force = 0;
		Damage = 0;
	});
	self:TakePrimaryAmmo(1);
	self.Weapon:EmitSound(self.Primary.Sound)
	self:Reload();
	local ent = tr.Entity;
	if (SERVER and IsValid(ent) and ent:IsPlayer()) then
		ent:KnockOut(60);
		ent._Stunned = true;
		GM:Log(EVENT_EVENT, "%s tranq'd %s.", self.Owner:Name(), ent:Name())
		gamemode.Call("PlayerKnockedOut", ent, self.Owner);
	end
end