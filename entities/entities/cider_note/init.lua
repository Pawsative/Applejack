--[[
Name: "cl_init.lua".
	~ Applejack ~
--]]

include("sh_init.lua");

-- Add the files that need to be sent to the client.
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("sh_init.lua");

-- This is called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_lab/clipboard.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	-- Get the physics object of the entity.
	local physicsObject = self:GetPhysicsObject();

	-- Check if the physics object is a valid entity.
	if ( IsValid(physicsObject) ) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end
end

-- A function to set the text of the note.
function ENT:SetText(text)
	self._Text = {};

	-- A variable to define the current position in the text.
	local position = 1;

	-- Do a while loop to store our text.
	while (string.sub(text, position, position + 30) != "") do
		table.insert( self._Text, string.sub(text, position, position + 30) );

		-- Increase the position.
		position = position + 31;
	end

	-- Loop through our text.
	for k, v in pairs(self._Text) do self:SetNetworkedString("cider_Text_"..k, v); end
end