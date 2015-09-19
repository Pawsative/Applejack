include("shared.lua")

function ENT:Draw()
	if not (self.Entity:GetOwner() == LocalPlayer() and EyePos() == LocalPlayer():EyePos()) then
		self.Entity:DrawModel()
	end
end
