--[[
	~ $$$ Money $$$ *
	~ Applejack ~
--]]


ITEM.Name			= "Dollar";
ITEM.Plural			= "Dollars";
ITEM.Size			= 0;
ITEM.Cost			= 1;
ITEM.Model			= "models/props/cs_assault/Money.mdl";
ITEM.Batch			= 1000;
ITEM.Store			= false;
ITEM.Description	= "A wad of money.";

local function updatefunc(ply)
	if (not ply:IsValid()) then return end
	ply:GiveMoney(ply._TMPMoneyUpdate);
	ply._TMPMoneyUpdate	= nil;
end

function ITEM:onUpdate(ply,amount)
	if amount > 0 then
		if ply._TMPMoneyUpdate then
			ply._TMPMoneyUpdate	= ply._TMPMoneyUpdate + amount;
		else
			ply._TMPMoneyUpdate	= amount;
			timer.Simple(0.1, function()
				updatefunc(ply);
			end)
		end
		return true -- Never put this in a player's inventory
	end
end