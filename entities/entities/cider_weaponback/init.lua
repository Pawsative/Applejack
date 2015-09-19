AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')
function ENT:Think()
	if not(IsValid(self.ply) and self.ply:IsPlayer() and self.ply:Alive()) then
		self:Remove()
	end
end