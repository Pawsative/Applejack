--[[
	~ Lockpick SWep ~
	~ Applejack ~
--]]

if (SERVER) then
	AddCSLuaFile("shared.lua");
else
	SWEP.PrintName = "Lockpick";
	SWEP.Slot = 3;
	SWEP.SlotPos = 3;
	SWEP.DrawAmmo = false;
	SWEP.IconLetter = "c"
	SWEP.DrawCrosshair = true;
	
	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.IconLetter, "TitleFont2", x + 0.5*wide, y --[[+ tall*0.2]], Color(255, 220, 0, 255), TEXT_ALIGN_CENTER )
		self:PrintWeaponInfo(x + wide + 20, y + tall*0.95, alpha)
	end
end

-- Define some shared variables.
SWEP.Author	= "Lexi";
SWEP.Instructions = "Primary Fire: Attempt to pick Lock.";
SWEP.Contact = "";
SWEP.Purpose = "Unlocking locked things";

-- Set the view model and the world model to nil.
SWEP.ViewModel = "models/weapons/v_crowbar.mdl";
SWEP.WorldModel = "models/weapons/w_crowbar.mdl";

-- Set whether it's spawnable by players and by administrators.
SWEP.Spawnable = false;
SWEP.AdminSpawnable = false;
  
-- Set the primary fire settings.
SWEP.Primary.Delay = 0.75;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "";

-- Set the secondary fire settings.
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = 0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo	= "";



local fiddlesounds = {
	--[[ -- Metal thump noises
	"physics/metal/metal_box_impact_bullet1.wav",
	"physics/metal/metal_box_impact_bullet2.wav",
	"physics/metal/metal_box_impact_bullet3.wav",
	"physics/metal/metal_computer_impact_bullet1.wav",
	"physics/metal/metal_computer_impact_bullet2.wav",
	"physics/metal/metal_computer_impact_bullet3.wav",
	"physics/metal/metal_computer_impact_hard1.wav",
	"physics/metal/metal_computer_impact_hard2.wav",
	"physics/metal/metal_computer_impact_hard3.wav",
	"physics/metal/metal_computer_impact_soft1.wav",
	"physics/metal/metal_computer_impact_soft2.wav",
	"physics/metal/metal_computer_impact_soft3.wav",
	"physics/metal/metal_sheet_impact_bullet2.wav",
	"physics/metal/metal_solid_impact_bullet1.wav",
	"physics/metal/metal_solid_impact_bullet2.wav",
	"physics/metal/metal_solid_impact_bullet3.wav",
	--]]
	"physics/metal/weapon_footstep1.wav",
	"physics/metal/weapon_footstep2.wav",
	"physics/metal/weapon_impact_soft1.wav",
	"physics/metal/weapon_impact_soft2.wav",
	"physics/metal/weapon_impact_soft3.wav",
}

local unlocksounds = {
	--[[
	"physics/metal/sawblade_stick1.wav",
	"physics/metal/sawblade_stick2.wav",
	"physics/metal/sawblade_stick3.wav",
	--]]
	"physics/metal/weapon_impact_hard1.wav",
	"physics/metal/weapon_impact_hard2.wav",
}

local breaksounds = {
	"physics/plastic/plastic_box_break1.wav"
}
local thumpsounds = {
	"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav",
}

-- Called when the SWEP is initialized.
function SWEP:Initialize()
	self:SetWeaponHoldType("melee");
	if (SERVER) then
		 -- TODO: Remove this is sounds are not precached.
		for _,sound in pairs(fiddlesounds) do
			Sound(sound);
		end
		for _,sound in pairs(unlocksounds) do
			Sound(sound);
		end
		for _,sound in pairs(breaksounds) do
			Sound(sound);
		end
		for _,sound in pairs(thumpsounds) do
			Sound(sound);
		end
	end
end

-- Allows me to send the client sounds
function SWEP:DoSound(tabn,sn)
	local tab;
	if (tabn == 0) then
		tab = fiddlesounds;
	elseif (tabn == 1) then
		tab = unlocksounds;
	elseif (tabn == 2) then	
		tab = breaksounds
	elseif (tabn == 3) then
		tab = thumpsounds;
	end
	if (not tab) then
		error("Invalid table specified: " .. tabn,2);
	elseif (not sn) then
		sn = math.random(#tab);
	end
	if (SERVER and IsValid(self.Owner)) then
		umsg.Start("dosnd",self.Owner);
		umsg.Char(tabn);
		umsg.Char(sn);
		umsg.End();
	end
	self:EmitSound(tab[sn]);	
end

if (CLIENT) then
	usermessage.Hook("dosnd", function(m)
		local wpn = LocalPlayer():GetActiveWeapon()
		if (IsValid(wpn) and wpn:GetClass() == "cider_lockpick") then
			wpn:DoSound(m:ReadChar(), m:ReadChar());
		end
	end)
else
	umsg.PoolString("dosnd");
end

-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay);
	

	-- Set the animation of the owner to one of them attacking.
	-- self.Owner:SetAnimation(PLAYER_ATTACK1);


	local tr = self.Owner:GetEyeTrace();
	local owner = self.Owner;
	if (owner:GetShootPos():Distance(tr.HitPos) > 128) then
		self:SendWeaponAnim(ACT_VM_MISSCENTER);
		self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav");
		return;
	end
	self:SendWeaponAnim(ACT_VM_HITCENTER);
	if (CLIENT) then return end
	local ent = tr.Entity;
	if (not gamemode.Call("PlayerCanLockpick", owner, ent)) then
		owner:Notify("You can't lockpick this!", 1);
		self:DoSound(3)
		return;
	elseif (not (ent._Locked or (ent:IsPlayer() and ent:Arrested()))) then
		owner:Notify("That's not locked!", 1);
		return;
	end
	ent._LockpickingCount = ent._LockpickingCount or 0;
	-- Announce that we have started lockpicking, if we have.
	if (ent._LockpickingCount == 0) then
		owner:Emote("starts fiddling about with the lock");
	end
	owner._LockpickChance = owner._LockpickChance or 0;
	-- An entity can specify the max hits it takes to unlock them
	local maxhits = ent._LockpickHits or GM.Config["Maximum Lockpick Hits"];
	-- Padlocks double the number of hits
	if (ent:GetNWBool("Padlocked")) then
		maxhits = maxhits * 2;
	end
	-- I'm not sure why, but it's still really easy to lockpick things with a high chance. Let's force it harder.
	maxhits = maxhits * 11;
	-- Update the count
	ent._LockpickingCount = ent._LockpickingCount + (1 / maxhits);
	-- Tell me wtf is going on with this silly system
	--print("current num: " .. ent._LockpickingCount .. ", adding: : " .. 1 / maxhits);
	-- Give the pick a chance of breaking
	if (math.random() < owner._LockpickChance) then
		-- Tell the world with text'n'noise
		self:DoSound(2)
		owner:Emote("manages to snap "..owner._GenderWord.." lockpick off in the lock.");
		-- Reset the lock
		ent._LockpickingCount = 0;
		-- Reset the break chance
		owner._LockpickChance = 0;
		-- Remove the lockpick from the player
		owner:StripWeapon("cider_lockpick");
		owner:SelectWeapon("cider_hands");
		-- End the picking
		return;
	-- Check if we have NOT managed to pick the lock
	elseif (math.random() > ent._LockpickingCount) then
		-- Make a fiddling with the lock sound
		self:DoSound(0)
		return;
	end
	-- We have successfully picked the lock! Tell people.
	owner:Emote("opens the lock with a final thrust, slightly damaging " .. owner._GenderWord .." lockpick")
	self:DoSound(1)
	-- Reset the lock
	ent._LockpickingCount = 0;
	-- Add to the lockpicker's pick break chance and tell them.
	owner._LockpickChance = owner._LockpickChance + GM.Config["Lockpick Break Chance"];
	--owner:Notify("Your lockpick was damaged while picking the lock.");
	-- Since we can now pick the cuffs on players to unarrest them, we need to treat them differently.
	if (ent:IsPlayer()) then 
		ent:UnArrest();
		ent:Emote("pulls off the unlocked handcuffs and throws them away hard enough to break them.");
		GM:Log(EVENT_EVENT, "%s picked the lock on %s handcuffs", owner:Name(), ent:Name());
		return;
	end
	--Actually unlock it the entity
	ent:UnLock();
	-- ent:EmitSound("doors/door_latch3.wav");
	local event, addon, entname = "","",ent._eName or "entity";
	if (cider.entity.isOwned(ent)) then
		event = cider.entity.getPossessiveName(ent);
	else
		event = "an unowned";
	end
	if (ent._isDoor) then
		addon = cider.entity.getDoorName(ent);
		if (addon ~= "") then
			addon = ": "..addon;
		end
	else
		local name = gamemode.Call("GetEntityName", ent);
		if (name and name ~= "") then
			addon = ": "..name;
		end
	end
	GM:Log(EVENT_EVENT, "%s picked the lock on %s %s%s.", owner:GetName(), event, entname, addon);
end