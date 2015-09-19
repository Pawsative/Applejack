--[[
Name: "cl_init.lua".
	~ Applejack ~
--]]

include("sh_init.lua")

-- This is called when the entity should draw.
function ENT:Draw() self.Entity:DrawModel(); end

-- Add a language text for when we undo the note.
language.Add("Undone_Note", "Undone Note");