--[[
	~ rg_base shared ~
	~ Applejack ~
	~[
		This is a modified version of Teta_Bonita's rg_base.
		I'm not sure how much modification kuromeku has done to
		 this, but I've been rewriting bits of it as I go along.
		~Lexi
	~]
--]]

if SERVER then

	AddCSLuaFile("shared.lua")
	AddCSLuaFile("cl_init.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

function SWEP:SetupDataTables()
	self:DTVar("Int",0,"firemode");
	self:DTVar("Bool",0,"ironsights");
	self:DTVar("Bool",1,"silenced");
	self:DTVar("Bool",2,"scope");
	self:DTVar("Float",0,"scopezoom");
	self:DTVar("Float",1,"lastshoottime");
end

SWEP.Author			= "Teta_Bonita"
SWEP.Contact		= ""
SWEP.Purpose		= "To crush your enemies."
SWEP.Instructions	= "Aim away from face."

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound			= Sound("Weapon_TMP.Single")
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Size 					= TYPE_SMALL
SWEP.TypeName 				= "pistol"
SWEP.AutoRPM				= 200
SWEP.SemiRPM				= 200
SWEP.BurstRPM				= 200
SWEP.MuzzleVelocity 		= 1000
SWEP.AvailableFireModes		= {}
SWEP.FiresUnderwater 		= false
SWEP.HasSilencer			= false
SWEP.IsHolster				= true
SWEP.CanPenetrate           = false
SWEP.CanPenetrateWorld      = false
SWEP.CanPenetrateCont		= false
SWEP.BulletTracer           = 1

SWEP.MuzzleEffect			= "rg_muzzle_pistol"
SWEP.ShellEjectEffect		= "rg_shelleject"
SWEP.MuzzleAttachment		= "1"
SWEP.ShellEjectAttachment	= "2"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.Sound		= Sound("Weapon_AR2.Double") -- For grenade launching
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false -- Best left at false, as secondary is used for ironsights/switching firemodes
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightZoom 			= 1.2
SWEP.ScopeZooms				= {5,10}
SWEP.UseScope				= false
SWEP.ScopeScale 			= 0.4
SWEP.DrawSniperSights		= false
SWEP.DrawRifleSights		= false
SWEP.LaserRespawnTime 		= 0.9
SWEP.LaserLastRespawn 		= 0
SWEP.HasLaser				= false
SWEP.HasSilencer			= true

SWEP.MinRecoil			= 0.1
SWEP.MaxRecoil			= 0.5
SWEP.DeltaRecoil		= 0.1

SWEP.RecoverTime 		= 1
SWEP.MinSpread			= 0
SWEP.MaxSpread			= 0
SWEP.DeltaSpread		= 0

SWEP.MinSpray			= 0.2
SWEP.MaxSpray			= 1.5
SWEP.DeltaSpray			= 0.2

SWEP.CrouchModifier		= 0.5
SWEP.IronSightModifier 	= 0.7
SWEP.RunModifier 		= 2
SWEP.JumpModifier 		= 4



---------------------------------------------------------
--------------------Firemodes------------------------
---------------------------------------------------------
SWEP.FireModes = {}

---------------------------------------
-- Firemode: Semi Automatic --
---------------------------------------
SWEP.FireModes.Semi = {}
SWEP.FireModes.Semi.FireFunction = function(self)

	self:BaseAttack()

end

SWEP.FireModes.Semi.InitFunction = function(self)

	self.Primary.Automatic = false
	self.Primary.Delay = 60/self.SemiRPM

end

-- We don't need to do anything for these revert functions, as self.Primary.Automatic, self.Primary.Delay, self.FireModeDrawTable.x, and self.FireModeDrawTable.y are set in every init function
SWEP.FireModes.Semi.RevertFunction = function(self)

	return

end

---------------------------------------
-- Firemode: Fully Automatic --
---------------------------------------
SWEP.FireModes.Auto = {}
SWEP.FireModes.Auto.FireFunction = function(self)

	self:BaseAttack()

end

SWEP.FireModes.Auto.InitFunction = function(self)

	self.Primary.Automatic = true
	self.Primary.Delay = 60/self.AutoRPM

end

SWEP.FireModes.Auto.RevertFunction = function(self)

	return

end

-------------------------------------------
-- Firemode: Three-Round Burst --
-------------------------------------------
SWEP.FireModes.Burst = {}
SWEP.FireModes.Burst.FireFunction = function(self)

	local clip = self.Weapon:Clip1()
	if not self:CanFire(clip) then return end

	self:BaseAttack()
	--[
	timer.Simple(self.BurstDelay, function()
		self.BaseAttack(self)
	end)

	if clip > 1 then
		timer.Simple(2*self.BurstDelay, function()
			self.BaseAttack(self)
		end)
	end
	--]]
	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )

end

SWEP.FireModes.Burst.InitFunction = function(self)

	self.Primary.Automatic = true
	self.Primary.Delay = 60/self.SemiRPM + 3*self.BurstDelay -- Burst delay is derived from self.BurstRPM

end

SWEP.FireModes.Burst.RevertFunction = function(self)

	return

end


---------------------------------------------------------
-----------------Init Functions----------------------
---------------------------------------------------------

local sndZoomIn = Sound("Weapon_AR2.Special1")
local sndZoomOut = Sound("Weapon_AR2.Special2")
local sndCycleZoom = Sound("Default.Zoom")
local sndCycleFireMode = Sound("Weapon_Pistol.Special2")


function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)

	if SERVER then
		-- This is so NPCs know wtf they are doing
		self:SetNPCMinBurst(3)
		self:SetNPCMaxBurst(6)
		self:SetNPCFireRate(60/self.AutoRPM)
	end

	self.CurFireMode		= 1 -- This is just an index to get the firemode from the available firemodes table

	if CLIENT then

		-- We need to get these so we can scale everything to the player's current resolution.
		local iScreenWidth = surface.ScreenWidth()
		local iScreenHeight = surface.ScreenHeight()

		-- The following code is only slightly riped off from Night Eagle
		-- These tables are used to draw things like scopes and crosshairs to the HUD.
		self.ScopeTable = {}
		self.ScopeTable.l = iScreenHeight*self.ScopeScale
		self.ScopeTable.x1 = 0.5*(iScreenWidth + self.ScopeTable.l)
		self.ScopeTable.y1 = 0.5*(iScreenHeight - self.ScopeTable.l)
		self.ScopeTable.x2 = self.ScopeTable.x1
		self.ScopeTable.y2 = 0.5*(iScreenHeight + self.ScopeTable.l)
		self.ScopeTable.x3 = 0.5*(iScreenWidth - self.ScopeTable.l)
		self.ScopeTable.y3 = self.ScopeTable.y2
		self.ScopeTable.x4 = self.ScopeTable.x3
		self.ScopeTable.y4 = self.ScopeTable.y1

		self.ParaScopeTable = {}
		self.ParaScopeTable.x = 0.5*iScreenWidth - self.ScopeTable.l
		self.ParaScopeTable.y = 0.5*iScreenHeight - self.ScopeTable.l
		self.ParaScopeTable.w = 2*self.ScopeTable.l
		self.ParaScopeTable.h = 2*self.ScopeTable.l

		self.ScopeTable.l = (iScreenHeight + 1)*self.ScopeScale -- I don't know why this works, but it does.

		self.QuadTable = {}
		self.QuadTable.x1 = 0
		self.QuadTable.y1 = 0
		self.QuadTable.w1 = iScreenWidth
		self.QuadTable.h1 = 0.5*iScreenHeight - self.ScopeTable.l
		self.QuadTable.x2 = 0
		self.QuadTable.y2 = 0.5*iScreenHeight + self.ScopeTable.l
		self.QuadTable.w2 = self.QuadTable.w1
		self.QuadTable.h2 = self.QuadTable.h1
		self.QuadTable.x3 = 0
		self.QuadTable.y3 = 0
		self.QuadTable.w3 = 0.5*iScreenWidth - self.ScopeTable.l
		self.QuadTable.h3 = iScreenHeight
		self.QuadTable.x4 = 0.5*iScreenWidth + self.ScopeTable.l
		self.QuadTable.y4 = 0
		self.QuadTable.w4 = self.QuadTable.w3
		self.QuadTable.h4 = self.QuadTable.h3

		self.LensTable = {}
		self.LensTable.x = self.QuadTable.w3
		self.LensTable.y = self.QuadTable.h1
		self.LensTable.w = 2*self.ScopeTable.l
		self.LensTable.h = 2*self.ScopeTable.l

		self.CrossHairTable = {}
		self.CrossHairTable.x11 = 0
		self.CrossHairTable.y11 = 0.5*iScreenHeight
		self.CrossHairTable.x12 = iScreenWidth
		self.CrossHairTable.y12 = self.CrossHairTable.y11
		self.CrossHairTable.x21 = 0.5*iScreenWidth
		self.CrossHairTable.y21 = 0
		self.CrossHairTable.x22 = 0.5*iScreenWidth
		self.CrossHairTable.y22 = iScreenHeight

	end

	self.BulletSpeed	= self.MuzzleVelocity*50 -- phoenix - 39.37 -- Assuming source units are in inches per second
	self.BurstDelay		= 60/self.BurstRPM
	self.Primary.Delay	= 60/self.SemiRPM

	self.FireFunction	= self.FireModes[self.AvailableFireModes[self.CurFireMode]].FireFunction
	self.dt.firemode	= 1;
	self.dt.ironsights	= false;
	self.dt.silenced	= false;
	self.dt.scope		= false;
	self.dt.scopezoom	= 0;

	self.ScopeZooms 		= self.ScopeZooms or {5}
	if self.UseScope then
		self.CurScopeZoom	= 1 -- Another index, this time for ScopeZooms
	end

	self:ResetVars()

end

concommand.Add("DropPrim",function(p) p:DropWeapon(p:GetActiveWeapon()) end)
function SWEP:Deploy()
	--MsgN"Deploy!"
	--[[
	if self.Owner._NextDeploy > CurTime() then
		print"AFKSLDFKSL"
		return false
	end--]]
	if (SERVER) then
		if (!self.DrawCrosshair or self.CustomCrosshair) then self.Owner:CrosshairDisable() end
		if (self.Owner._Ammo[self.Classname]) then
			self.Weapon:SetClip1(self.Owner._Ammo[self.Classname]);
		end
		if not self.Owner._FreshWeapons[self.Classname] then
			cider.chatBox.addInRadius(self.Owner, "me",
				GM.Config["Weapon Timers"]["deploymessage"][self.Size]:format(self.TypeName,self.Owner._GenderWord),
				self.Owner:GetPos(), GM.Config["Talk Radius"]
			);
		else
			self.Owner._FreshWeapons[self.Classname] = nil
		end
		self.Weapon:SetNextPrimaryFire(CurTime() + GM.Config["Weapon Timers"]["deploytime"][self.Size])
		self:OhGodGetItOff()
	end

	self.Owner._NextDeploy	= CurTime() + GM.Config["Weapon Timers"]["redeploytime" ][self.Size]
	self.NextHolster		= CurTime() + GM.Config["Weapon Timers"]["reholstertime"][self.Size]
	if ( self.dt.silenced ) then
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW_SILENCED);
	else
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW);
	end
	return true
end


-- This function resets spread, recoil, ironsights, etc.
function SWEP:ResetVars()

	self.NextSecondaryAttack = 0

	self.CurrentSpread = self.MinSpread
	self.CurrentRecoil	= self.MinRecoil
	self.CurrentSpray 	= self.MinSpray
	self.SprayVec 		= Vector(0,0,0)

	self.bLastIron = false
	self.dt.ironsights = false;

	if self.UseScope then
		self.CurScopeZoom = 1
		self.fLastScopeZoom = 1
		self.bLastScope = false
		self.dt.scope = false;
		self.dt.scopezoom = self.ScopeZooms[1];
	end

	if self.Owner and self.Owner:IsValid() then
		self.OwnerIsNPC = self.Owner:IsNPC() -- This ought to be better than getting it every time we fire
		self:SetIronsights(false,self.Owner) -- phoenix - placed in SWEP:Deply()
		self:SetScope(false,self.Owner) -- phoenix - placed in SWEP:Deply()
		self:SetFireMode() -- phoenix - placed in SWEP:Deply()
	end

end

--Stick shit on my back
function SWEP:StickAGunToMyBack	()
	local player,model = self.Owner,self.WorldModel
	if IsValid				(player._BackGun) then
		return false
	end
	local pos, ang, up, forward = player:GetPos(), player:GetAngles(), player:GetUp(), player:GetForward()
	local ent = ents.Create		("cider_weaponback")
	if not IsValid			(ent) then
		error					("Failed to create back weapon "..model.." for "..player:Name())
	end
	ent:SetPos					(pos + up*40+forward*-7)--+right*4)
	ent:SetModel				(model)
	ent:SetAngles				(Angle(-90,ang.y+90,180))
	ent:Spawn					()
	ent:Activate				()
	ent:SetSolid				(SOLID_NONE)
	ent:SetMoveType				(MOVETYPE_NONE)
	ent:SetCollisionGroup		(COLLISION_GROUP_NONE)
	ent:SetNotSolid				(true)
	ent:DrawShadow				(false)
	ent:SetOwner				(player)
	ent:SetParent				(player)
	ent.ply = 					 player
	--This bit makes the gun go a bit crazy so it's commented out. It looks neat when it works though.
	--ent:Fire( "SetParentAttachmentMaintainOffset", "chest", 1.00 )--chest,forward,eyes,anim_attachment_RH,ValveBiped.Bip01_Spine2
	player._BackGun = ent
	return true
end

function SWEP:OhGodGetItOff()
	--MsgN"RemovingGun"
	if IsValid(self.Owner._BackGun) then
		--MsgN"Valid"
		if  self.Owner._BackGun:GetModel() == self.WorldModel then
			--MsgN"Same"
			self.Owner._BackGun:Remove	()
		else
			--this ensures we don't remove a different model of gun if some idiot has set the large weapon limit higher than 1
		end
	end
end

-- Saves the weapon's clip and automatically puts it into the player's inventory if it has no ammo when the player switches to a different weapon.
-- Adjusted and recommented because it was a fucking mess before
local function ammostuff(owner, classname)
	-- Make sure there's still a person and the have that weapon
	if IsValid(owner) and owner:HasWeapon(classname)
		-- Ensure they can holster it
	and	hook.Call("PlayerCanHolster", GAMEMODE, owner, classname, true)
		-- Doo eet
	and	cider.inventory.update(owner, classname, 1) then
		owner:StripWeapon(classname)
	end
end

function SWEP:DoAmmoStuff()
	-- Get rid of pointles runs
	if CLIENT or not IsValid(self.previousOwner) then return end
	self.previousOwner:CrosshairEnable()
	-- Grab the ammo counts
	self.previousOwner._Ammo = self.previousOwner._Ammo or {}
	self.previousOwner._Ammo[self.Classname] = self.Weapon:Clip1();
	-- Make sure that the weapon's clip is empty and the player doesn't have any more ammo to put in the clip
	if not (self.previousOwner._Ammo[self.Classname] == 0 and self.previousOwner:GetAmmoCount(self.Primary.Ammo) == 0)
	-- Make sure the player is alive
	or not  self.previousOwner:Alive()
	-- Make sure the player can actually put this weapon in their inventory
	or not  GAMEMODE.Items[self.Classname]
	-- Make sure we haven't done this already
	or		self.doneAmmoStuff
	-- Make sure the owner isn't already holstering
	or      self.previousOwner._Equipping
	then return end
	-- Set up a quick timer to remove the weapon
	timer.Simple(0, function()
		ammostuff(self.previousOwner, self.Classname);
	end)
	-- Stop the player managing to get multiple weapons in their inventory with quick button presses
	self.doneAmmoStuff = true
end

-- We need to call ResetVars() on these functions so we don't whip out a weapon with scope mode or insane recoil right of the bat or whatnot
function SWEP:Holster(wep)
	--MsgN"Holster!"
	if self.NextHolster and self.NextHolster >= CurTime() then
		if SERVER then
			timer.Simple(0,function()
				if not( IsValid(self.Owner) and IsValid(self.Weapon) and IsValid(self.Owner:GetWeapon( self.Weapon:GetClass() ))) then return end
				self.Owner:GetViewModel( ):RemoveEffects( EF_NODRAW )
				self.Owner:GetWeapon( self.Weapon:GetClass() ):RemoveEffects( EF_NODRAW )
				self.Owner:Notify("You must wait another "..string.ToMinutesSeconds(self.NextHolster-CurTime()).." before doing that!",1)
			end)
		end
		return false
	end
	if SERVER and IsValid(self.Owner) and self.Owner:Alive() and not self.Owner._Deaded then
		timer.Stop(self.Owner:UniqueID().." holster");
		if not self.Owner:KnockedOut() then
			if GM.Config["Back Weapons"][self.Size] then
				self:StickAGunToMyBack()
			end
			cider.chatBox.addInRadius(self.Owner, "me",
				GM.Config["Weapon Timers"]["holstermessage"][self.Size]:format(self.TypeName,self.Owner._GenderWord),
				self.Owner:GetPos(), GM.Config["Talk Radius"]);
		end
		self:DoAmmoStuff()
	end
	self.Owner._NextDeploy	= CurTime() + GM.Config["Weapon Timers"]["redeploytime" ][self.Size]
	self.NextHolster		= CurTime() + GM.Config["Weapon Timers"]["reholstertime"][self.Size]
	self:ResetVars()
	return true
end
function SWEP:Equip(NewOwner)
	if NewOwner._GunCounts then
		NewOwner._GunCounts[self.Size] = NewOwner._GunCounts[self.Size] or 0
		NewOwner._GunCounts[self.Size] = NewOwner._GunCounts[self.Size] + 1
	end
	--MsgN"Equip"
	self:ResetVars()
	return true
end
function SWEP:OnRemove()
	--MsgN"Remove"
	self:DoAmmoStuff()
	self:ResetVars()

	return true
end
function SWEP:OnDrop()
	--MsgN"Drop"
	--MsgN( self.previousOwner )
	--MsgN( self.previousOwner._GunCounts )
	if IsValid(self.previousOwner) and self.previousOwner._GunCounts then
		self.previousOwner._GunCounts[self.Size] = self.previousOwner._GunCounts[self.Size] or 1
		self.previousOwner._GunCounts[self.Size] = self.previousOwner._GunCounts[self.Size] -  1
	end
	self:DoAmmoStuff()
	self:ResetVars()

	return true
end
function SWEP:OwnerChanged()
	--MsgN"Owner Changed"
	self:ResetVars()
	return true
end
function SWEP:OnRestore()
	----MsgN"Restore!"
	self:ResetVars()
	return true
end


---------------------------------------------------------
----------Attack Helper Functions----------------
---------------------------------------------------------

-- Generic attack function
SWEP.LastAttack = CurTime()
SWEP.LastDeltaSprayVec = Vector(0,0,0)
function SWEP:BaseAttack()

	if not self:CanFire(self.Weapon:Clip1()) then return end

	-- Calculate recover (cool down) scale
	local fCurTime = CurTime()
	local DeltaTime = fCurTime - self.LastAttack
	local RecoverScale = (1 - DeltaTime/self.RecoverTime)
	self.LastAttack = fCurTime

	-- Apply cool-down to spread, spray, and recoil
	self.CurrentSpread = math.Clamp(self.CurrentSpread*RecoverScale, self.MinSpread, self.MaxSpread)
	self.CurrentRecoil = math.Clamp(self.CurrentRecoil*RecoverScale, self.MinRecoil, self.MaxRecoil)
	self.CurrentSpray = math.Clamp(self.CurrentSpray*RecoverScale, self.MinSpray, self.MaxSpray)
	self.SprayVec = self.SprayVec*((self.CurrentSpray - self.MinSpray)/(self.MaxSpray - self.MinSpray))

	-- Calculate modifiers/take ammo
	local modifier = 1
	if not self.OwnerIsNPC then -- NPCs don't get modifiers

		modifier = self:CalculateModifiers(self.RunModifier,self.CrouchModifier,self.JumpModifier,self.IronSightModifier)

	end
	self:TakePrimaryAmmo(1)
	self.Weapon:EmitSound(self.Primary.Sound)
	local NewSpray 		= self.CurrentSpray*modifier

	self:RGShootBulletCheap(self.Primary.Damage,
						self.BulletSpeed,
						self.CurrentSpread*modifier,
						NewSpray,
						self.SprayVec)

	-- Apply recoil and spray
	self:ApplyRecoil(self.CurrentRecoil*modifier,NewSpray)

	-- Update spread, spray, and recoil
	self.CurrentRecoil 	= math.Clamp(self.CurrentRecoil + self.DeltaRecoil, self.MinRecoil, self.MaxRecoil)
	self.CurrentSpread 	= math.Clamp(self.CurrentSpread + self.DeltaSpread, self.MinSpread, self.MaxSpread)
	self.CurrentSpray 	= math.Clamp(self.CurrentSpray + self.DeltaSpray, self.MinSpray, self.MaxSpray)

	local DeltaSprayVec = VectorRand()*0.02 -- Change in spray vector
	self.SprayVec = self.SprayVec + DeltaSprayVec + self.LastDeltaSprayVec -- This "smooths out" the motion of the spray vector
	self.LastDeltaSprayVec = DeltaSprayVec

	-- Shoot Effects
	self:ShootEffects()

end
local text = SERVER and "Server: " or "Client: "
-- You don't like my physically simulated bullets? : (
local function carshoot(self,tr,dmg)
	if tr.Entity:IsValid() and tr.Entity:GetClass() == "prop_vehicle_jeep" and SERVER then
		local trace = { start = tr.HitPos, endpos = tr.HitPos + tr.Normal * 64, filter = tr.Entity}
		trace = util.TraceLine(trace)
		if trace.Hit and IsValid(trace.Entity) then
			local ent = trace.Entity
			if ent:IsVehicle() and IsValid(ent:GetDriver()) and ent:GetClass() == "prop_vehicle_prisoner_pod" then
				ent:TakeDamage(dmg,self.Owner)
			elseif ent:IsPlayer() and ent:InVehicle() then
				ent:GetVehicle():TakeDamage(dmg,self.Owner)
			end
		end
		hook.Call("VehicleShot",GAMEMODE,atk,tr,dmg,dmgInfo) -- For knocking out wheels n shit
	end
end
function SWEP:RGShootBulletCheap(dmg, speed, spread, spray, sprayvec, numbul)
--[[
	if (self.Owner.LagCompensation) then
		self.Owner:LagCompensation(true);
	end
	-]]
	local PlayerAim = self.Owner:GetAimVector()
	local PlayerPos = self.Owner:GetShootPos()
	--[[
	if (self.Owner.LagCompensation) then
		self.Owner:LagCompensation(false);
	end
	--]]
	numbul = numbul or 1
	if self.dt.silenced then
		dmg = dmg / 2
	end
	self.PenetrateInfo = {
		Num = numbul,
		_Spread = Vector(spread, spread, 0),
		Spread = Vector(spread, spread, 0),
		Dir = ( PlayerAim + 0.04 * spray * sprayvec:GetNormalized() ):GetNormalized(),
		Damage = dmg,
		Force = 5 * dmg,
		Tracer = self.BulletTracer
	}
	local traces = {}
	local bullet = {}
	bullet.Num		= self.PenetrateInfo.Num
	bullet.Src		= PlayerPos
	bullet.Dir		= self.PenetrateInfo.Dir -- phoenix - PlayerAim
	bullet.Spread	= self.PenetrateInfo.Spread -- phoenix - Vector(spread, spread, 0)
	bullet.Force	= self.PenetrateInfo.Force
	bullet.Damage	= self.PenetrateInfo.Damage
	bullet.Tracer	= self.PenetrateInfo.Tracer
	bullet.Callback = function(atk,tr,dmgInfo)
		table.insert(traces,tr)
		carshoot(self,tr,dmg);
		if game.SinglePlayer() then
			debugoverlay.Line(tr.StartPos,tr.HitPos,10,Color(237,40,31,255),true)
		end
		--debugoverlay.Cross(tr.HitPos,10,5,color_white,true)
		--self:PenetrateCallback(atk, tr)
	end
	self.Owner:FireBullets( bullet )
	for _,trace in ipairs(traces) do
		self:PenetrateCallback(self.Owner, trace,self.PenetrateInfo.Damage,self.PenetrateInfo.Force)
	end
end
local
ricochetmats = {}
ricochetmats[MAT_CLIP]			=-0.1 --Clipping brushes I guess
ricochetmats[88		]			=-0.1 --skybox
ricochetmats[MAT_ALIENFLESH]	= 0.2
ricochetmats[MAT_ANTLION]		= 0.2
ricochetmats[MAT_BLOODYFLESH]	= 0.2
ricochetmats[MAT_SAND]			= 0.2
ricochetmats[MAT_FLESH]			= 0.2
ricochetmats[MAT_FOLIAGE]		= 0.2
ricochetmats[MAT_SLOSH]			= 0.2
ricochetmats[MAT_DIRT]			= 0.2
ricochetmats[MAT_WOOD]			= 0.2
ricochetmats[MAT_COMPUTER]		= 0.4
ricochetmats[MAT_CONCRETE]		= 0.5
ricochetmats[MAT_GLASS]			= 0.6
ricochetmats[MAT_PLASTIC]		= 0.6
ricochetmats[MAT_TILE]			= 0.6
ricochetmats[MAT_GRATE]			= 0.8
ricochetmats[MAT_METAL]			= 0.9
ricochetmats[MAT_VENT]			= 0.9
local function bounce(tr)
	local ang = tr.Normal:Angle()
	ang:RotateAroundAxis(tr.HitNormal,180)
	return ang:Forward() * -1
end
-- The penetrating callback.
local vec_nul = Vector(0,0,0)
local f,p,y,a
function SWEP:PenetrateCallback(pl, trace,damage,force)
	if not trace.Hit then
		return
	end
	if game.SinglePlayer() then
		debugoverlay.Text(trace.HitPos,"force: "..force,10)
	end
	local dir
	local mats = ricochetmats[trace.MatType]
	if (not mats) then
		ErrorNoHalt("Unkown material type '"..trace.MatType.."' for ricochet callback! o_O");
		mats = -0.1
	end
	if	-(trace.Normal:Dot(trace.HitNormal)) < mats
	and	hook.Call("CanRicochet",GAMEMODE,trace,force,self)
	then
		if game.SinglePlayer() then
			debugoverlay.Text(trace.HitPos+vector_up,"ricochet",10)
		end
		dir = bounce(trace) + VectorRand() /4
		damage,force = damage * 0.75, force / 2
	elseif	self.CanPenetrate
	and		(!trace.HitWorld or self.CanPenetrateWorld)
	and		hook.Call("CanPenetrate",GAMEMODE,trace,force,self)
	and not self.dt.silenced
	then
		if game.SinglePlayer() then
			debugoverlay.Text(trace.HitPos+vector_up,"penetrate",10)
		end
		if (force < 100) then
			f = (100 - force) / 100
			p = math.random(-45,45) * f;
			y = math.random(-45,45) * f;
			a = trace.Normal:Angle();
			a.p = a.p + p;
			a.y = a.y + y;
			dir = a:Forward();
		else
			dir = trace.Normal;
		end
		damage,force = damage / 2,force / 3
	else
		return
	end
	dir:Normalize()
	local bullet	= {}
	local tr;
	bullet.Num		= 1
	bullet.Tracer	= self.PenetrateInfo.Tracer
	bullet.Force	= force
	bullet.Damage	= damage
	bullet.Dir		= dir
	bullet.Src		= trace.HitPos + (16 * bullet.Dir)
	bullet.Callback = function( atk,_trace,di)
		hook.Call("PenetrationDamage",GAMEMODE,_trace,di,self,atk)
		if game.SinglePlayer() then
			debugoverlay.Line(_trace.StartPos,_trace.HitPos,10,Color(255,237,31,255),true)
			debugoverlay.Line(trace.HitPos,_trace.HitPos,10,Color(200,200,255,255),true)
		end
		tr = _trace
		carshoot(self,_trace,damage);
		timer.Simple(0, function()
			self.PenetrateCallback(self, pl, _trace,damage,force);
		end)
		--debugoverlay.Cross(_trace.HitPos,10,5,color_white,true)
		local matTypes = {
			[MAT_CONCRETE] = {"Impact.Concrete", "MetalSpark"},
			[MAT_METAL] = {"Impact.Metal", "MetalSpark"},
			[MAT_WOOD] = {"Impact.Wood", "MetalSpark"},
			[MAT_GLASS] = {"Impact.Glass", "GlassImpact"}
		}
		if ( !IsValid(_trace.Entity) or ( !_trace.Entity:IsPlayer() and !_trace.Entity:IsNPC() ) ) then
			if (_trace.Entity == trace.Entity) then
				if (matTypes[_trace.MatType]) then
					util.Decal(matTypes[_trace.MatType][1], _trace.HitPos + _trace.HitNormal, _trace.HitPos - _trace.HitNormal)
					local effectData = EffectData()
						effectData:SetStart(_trace.HitPos)
						effectData:SetOrigin(_trace.HitPos)
					util.Effect(matTypes[_trace.MatType][2], effectData)
				end
			end
		end
	end
	self.Owner:FireBullets( bullet )
end



function SWEP:ApplyRecoil(recoil,spray)

	if self.OwnerIsNPC or (SERVER--[[ and not self.Owner:IsListenServerHost()--]]) then return end

	local EyeAng = Angle(
	recoil*math.Rand(-1,-0.7 + spray*0.4) + spray*math.Rand(-0.3,0.3), -- Up/Down recoil
	recoil*math.Rand(-0.4,0.4) + spray*math.Rand(-0.4,0.4), -- Left/Right recoil
	0)

	-- Punch the player's view
	self.Owner:ViewPunch(1.3*EyeAng) -- This smooths out the player's screen movement when recoil is applied
	self.Owner:SetEyeAngles(self.Owner:EyeAngles() + EyeAng)

end

-- Acuracy/recoil modifiers
function SWEP:CalculateModifiers(run,crouch,jump,iron)

	local modifier = 1

	if self.Owner:KeyDown(bit.bor(IN_FORWARD , IN_BACK , IN_MOVELEFT , IN_MOVERIGHT)) then
		modifier = modifier*run
	end

	if self.dt.ironsights then
		modifier = modifier*iron
	end

	if not self.Owner:IsOnGround() then
		return modifier*jump --You can't be jumping and crouching at the same time, so return here
	end

	if self.Owner:Crouching() then
		modifier = modifier*crouch
	end

	return modifier

end

function SWEP:ShootEffects()

	local PlayerPos = self.Owner:GetShootPos()
	local PlayerAim = self.Owner:GetAimVector()

	self.Owner:MuzzleFlash()
	if self.dt.silenced then
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SILENCED)
		if (self.AnimationFix) then
			timer.Create("Animation Fix: "..tostring(self.Weapon), self.AnimationFix, 1, function()
				if ( IsValid(self.Weapon) ) then
					self.Weapon:SendWeaponAnim(ACT_VM_IDLE_SILENCED)
				end
			end);
		end
	else
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		if (self.AnimationFix) then
			timer.Create("Animation Fix: "..tostring(self.Weapon), self.AnimationFix, 1, function()
				if ( IsValid(self.Weapon) ) then
					self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
				end
			end);
		end
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	local fx = EffectData()
	fx:SetEntity(self.Weapon)
	fx:SetOrigin(PlayerPos)
	fx:SetNormal(PlayerAim)
	fx:SetAttachment(self.MuzzleAttachment)
	util.Effect(self.MuzzleEffect,fx)						-- Additional muzzle effects

	local fx = EffectData()
	fx:SetEntity(self.Weapon)
	fx:SetNormal(PlayerAim)
	fx:SetAttachment(self.ShellEjectAttachment)
	util.Effect(self.ShellEffect,fx)						-- Shell ejection

end

-- Clip can be any number, ideally a clip or ammo count
function SWEP:CanFire(clip)

	if not self.Weapon or not self.Owner or not (self.OwnerIsNPC or self.Owner:Alive()) then return end

	if clip <= 0 or (self.Owner:WaterLevel() >= 3 and not self.FiresUnderwater) then

		self.Weapon:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
		return false -- Note that we don't automatically reload.  The player has to do this manually.

	end

	return true

end


---------------------------------------------------------
----FireMode/IronSight Helper Functions----
---------------------------------------------------------

local IRONSIGHT_TIME = 0.35 -- How long it takes to raise our rifle
function SWEP:SetIronsights(b,player)

if CLIENT or (not player) or player:IsNPC() then return end

	-- Send the ironsight state to the client, so it can adjust the player's FOV/Viewmodel pos accordingly
	self.dt.ironsights = b;

	if self.UseScope then -- If we have a scope, use that instead of ironsights
		if b then
			--Activate the scope after we raise the rifle
			timer.Simple(IRONSIGHT_TIME, function() self.SetScope(self, true, player) end)
		else
			self:SetScope(false, player)
		end
	end

end

function SWEP:SetScope(b,player)

if CLIENT or (not player) or player:IsNPC() then return end

	local PlaySound = b ~= self.dt.scope -- Only play zoom sounds when chaning in/out of scope mode
	self.CurScopeZoom = 1 -- Just in case...
	self.dt.scopezoom = self.ScopeZooms[self.CurScopeZoom];

	if b then
		player:DrawViewModel(false)
		if PlaySound then
			self.Weapon:EmitSound(sndZoomIn)
		end
	else
		player:DrawViewModel(true)
		if PlaySound then
			self.Weapon:EmitSound(sndZoomOut)
		end
	end

	-- Send the scope state to the client, so it can adjust the player's fov/HUD accordingly
	self.dt.scope = b;

end

function SWEP:SetFireMode()

	local FireMode = self.AvailableFireModes[self.CurFireMode]
	self.dt.firemode = self.CurFireMode;

	if (self.FireModes[FireMode]) then
		self.FireFunction = self.FireModes[FireMode].FireFunction

		-- Run the firemode's init function (for updating delay and other variables)
		self.FireModes[FireMode].InitFunction(self)
	end

end

function SWEP:RevertFireMode()

	local FireMode = self.AvailableFireModes[self.CurFireMode]

	-- Run the firemode's revert function (for changing back variables that could interfere with other firemodes)
	self.FireModes[FireMode].RevertFunction(self)

end


---------------------------------------------------------
------------Main SWEP functions----------------
---------------------------------------------------------

function SWEP:PrimaryAttack()

	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	if not self.Owner:KeyDown(IN_USE) then
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:FireFunction()
	else
		if self.HasSilencer then
			if self.dt.silenced then
				self.Weapon:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
				self.dt.silenced = false;
			else
				self.Weapon:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
				self.dt.silenced = true;
			end
			self.Weapon:SetNextPrimaryFire( CurTime() + 2.1 )
		end
	end
	if CLIENT then
		self.LastShootTime = CurTime();
	end
end

function SWEP:Think()
	if self.Weapon then
		if self.HasSilencer then
			if self.dt.silenced then
				self.Primary.Sound = Sound("Weapon_M4A1.Silenced")
			else
				self.Primary.Sound = Sound("Weapon_M4A1.Single")
			end
		end
	end
	if self.HasLaser then
		if (self.LaserLastRespawn + self.LaserRespawnTime) < CurTime() then
			local effectdata = EffectData()

			effectdata:SetOrigin( self:GetOwner():GetShootPos() )
			effectdata:SetEntity( self.Weapon )
			util.Effect( "rg_reddot", effectdata )

			self.LaserLastRespawn = CurTime()
		end
	end
	if ( IsValid(self.Owner) ) then self.previousOwner = self.Owner; end
end

-- Secondary attack is used to set ironsights/change firemodes
-- TODO: clean this function up
SWEP.NextSecondaryAttack = 0
function SWEP:SecondaryAttack()

	if self.NextSecondaryAttack > CurTime() or self.OwnerIsNPC then return end
	self.NextSecondaryAttack = CurTime() + 0.3

	if self.Owner:KeyDown(IN_USE) then

	local NumberOfFireModes = table.getn(self.AvailableFireModes)
	if NumberOfFireModes < 2 then return end -- We need at least 2 firemodes to change firemodes!

		self:RevertFireMode()
		self.CurFireMode = math.fmod(self.CurFireMode, NumberOfFireModes) + 1 -- This just cycles through all available fire modes
		self:SetFireMode()

		if (SERVER) then
			if (self.AvailableFireModes[self.CurFireMode]) then
				local fireMode = self.AvailableFireModes[self.CurFireMode];
				if (fireMode == "Semi") then
					self.Owner:PrintMessage(4, "Semi-Automatic Fire")
				elseif (fireMode == "Auto") then
					self.Owner:PrintMessage(4, "Automatic Fire")
				elseif (fireMode == "Burst") then
					self.Owner:PrintMessage(4, "Burst Fire")
				end
			end
		end

		self.Weapon:EmitSound(sndCycleFireMode)
	-- All of this is more complicated than it needs to be. Oh well.
	elseif self.IronSightsPos then

		local NumberOfScopeZooms = table.getn(self.ScopeZooms)

		if self.UseScope and self.dt.scope then

			self.CurScopeZoom = self.CurScopeZoom + 1
			if self.CurScopeZoom <= NumberOfScopeZooms then

				self.dt.scopezoom = self.ScopeZooms[self.CurScopeZoom];
				self.Weapon:EmitSound(sndCycleZoom)

			else
				self:SetIronsights(false,self.Owner)
			end

		else

			local bIronsights = not self.dt.ironsights
			self:SetIronsights(bIronsights,self.Owner)

		end



	end

end


function SWEP:Reload()
	self:SetIronsights(false,self.Owner)
	if self.dt.silenced then
		self.Weapon:DefaultReload(ACT_VM_RELOAD_SILENCED)
	else
		self.Weapon:DefaultReload(ACT_VM_RELOAD)
	end

end
