--[[
	~ Base Weapon ~
	~ Applejack ~
--]]

include("item.lua");
ITEM.Weapon		= true;
ITEM.NoVehicles	= true;
local function conditional(ply,pos)
	return ply:IsValid() and ply:GetPos() == pos;
end
local function success(ply,_,self)
	if (not ply:IsValid()) then return end
	ply:Emote(GM.Config["Weapon Timers"]["Equip Message"]["Final"]:format(self.WeaponType, ply._GenderWord));
	ply._Equipping					= false;
	ply._FreshWeapons[self.UniqueID]= true;
	ply:Give(					self.UniqueID	);
	ply:SelectWeapon(			self.UniqueID	);
	cider.inventory.update(ply, self.UniqueID,-1);
	if self.OnEquip then
		self:OnEquip(ply);
	end
end

local function failure(ply)
	if (not ply:IsValid()) then return end
	ply:Emote(GM.Config["Weapon Timers"]["Equip Message"]["Abort"]:format(ply._GenderWord));
	ply._Equipping = false;
end

function ITEM:onUse(ply)
	if (ply:HasWeapon(self.UniqueID)) then
		ply:SelectWeapon(self.UniqueID);
		return false;
	end
	if (self.Ammo and not tobool(ply:GetAmmoCount(self.Ammo))) then
		ply:Notify("You don't have enough ammunition for this weapon!",1);
		return false;
	end
	if (not (self.WeaponType and GM.Config[self.WeaponType])) then
		ply:Give(self.UniqueID);
		ply:SelectWeapon(self.UniqueID);
		return true;
	end
	if (ply._NextDeploy > CurTime()) then
		ply:Notify("You must wait another "..string.ToMinutesSeconds(ply._NextDeploy - CurTime()).." before equipping another weapon!",1);
		return false;
	end
	ply._GunCounts[self.WeaponType]	= ply._GunCounts[self.WeaponType] or 0;
	if (ply._GunCounts[self.WeaponType] >= GM.Config[self.WeaponType]) then
		ply:Notify("You have too many "..self.WeaponType.." weapons equipped!", 1);
		return false
	end
	ply._Equipping	= true;
	local pos = ply:GetPos()
	timer.Simple(GM.Config["Weapon Timers"]["equiptime"][self.WeaponType], function()
		if (ply:IsValid() and ply:GetPos() == pos) then
			if (not ply:IsValid()) then return end
			ply:Emote(GM.Config["Weapon Timers"]["Equip Message"]["Final"]:format(self.WeaponType, ply._GenderWord));
			ply._Equipping					= false;
			ply._FreshWeapons[self.UniqueID]= true;
			ply:Give(					self.UniqueID	);
			ply:SelectWeapon(			self.UniqueID	);
			cider.inventory.update(ply, self.UniqueID,-1);
			if self.OnEquip then
				self:OnEquip(ply);
			end
		end
	end)
	ply:Emote(GM.Config["Weapon Timers"]["Equip Message"]["Start"]:format(ply._GenderWord));
	return false -- Removing the weapon from your inventory is handled in the timer
end
