--[[
	~ Cleanmap Plugin ~
	~ Applejack ~
--]]

PLUGIN.Name = "Clean Map";

-- A table of entity classes that will be removed when the map is loaded.
PLUGIN.EntitiesToDelete = {
	all = {
		"weapon_",
		"item_",
	};
	rp_evocity_v2d = {
		"prop_physics",
		"func_breakable",
		"trigger_teleport",
	};
	rp_christmastown = {
		"func_button",
		"prop_physics",
		"prop_ragdoll"
	}
}
PLUGIN.SpecificEntitiesToDelete = {
	rp_tb_city45_v02n = {
		func_movelinear = {
			{Vector(2804.8884, 1413.8890, 182.0313), 512}
		}
	},
	rp_evocity_v2d = {
		func_brush = {
			{ Vector(-5379.9902, -9377, 129.96),512},
			{ Vector(-6768, -9501, 900),128},
			{ Vector(10933.5, -12424, -989),600},
			{ Vector(11170, -12988, -989),256}
		},
		func_button= {
			{ Vector(-6761.5, -9453, 890),12},
			{ Vector(-5198.1099,-9421.5098,109.47),26},
			{ Vector(10868.5, -12423, -989),200},
			{ Vector(11071.5, -12986.5, -995.63),20},
			{ Vector(3586.3799, -6770.4902, 185.6400),20},
			{ Vector(-7725.75, -8550, -333.1), 500},
			{ Vector(-7905.9272, -9158.8262, 0880.0267), 256},
		},
		func_physbox_multiplayer = {
			{ Vector(2924.5828, 4572.7065, 64.9668) , 16}
		},
		func_door_rotating={
			{ Vector(-7828, -8961, 1788),30}
		},
		func_door = {
			{ Vector(2976.7786, 7141.4360, 0189.1867) , 1000 },
		}
	}
}
PLUGIN.EntitiesToSpawn = {
	rp_evocity_v2d = {
	/*																     --	14157.5742,
		{"prop_physics","models/props_buildings/building_002a.mdl",		Angle(00,  00, -90), Vector(-6020.0000, 14502.7637,  437.4147)},
		{"prop_physics","models/props_buildings/building_002a.mdl",		Angle(00,  00,  90), Vector(-6020.0000, 11693.2842,  443.3592)},

		{"prop_physics","models/props_wasteland/interior_fence002c.mdl",Angle(00,  90,  90), Vector(-7810.2871, -8611.6387, -312.6482)},
		{"prop_physics","models/props_wasteland/interior_fence002d.mdl",Angle(90, 180, 180), Vector(-672.8117, 5315.9014, 391.4228)},
		{"prop_physics","models/props_wasteland/interior_fence002d.mdl",Angle(90, 180, 180), Vector(-672.8117, 5058.7207, 391.4228)},
		{"prop_physics","models/props_wasteland/interior_fence002d.mdl",Angle(90, 180, 180), Vector(-672.8117, 4801.54, 391.4228)},
		{"prop_physics","models/props_wasteland/interior_fence002d.mdl",Angle(90, 180, 180), Vector(-672.8117, 4544.3594, 391.4228)},
		{"prop_physics","models/props_wasteland/interior_fence002d.mdl",Angle(90, 180, 180), Vector(-672.8117, 4287.1787, 391.4228)},
		{"prop_physics","models/props_wasteland/interior_fence002d.mdl",Angle(90, 180, 180), Vector(-672.8117, 4029.998, 391.4228)},
		{"prop_physics","models/props_wasteland/interior_fence002d.mdl",Angle(90, 180, 180), Vector(-672.8117, 3772.8174, 391.4228)},
		{"prop_physics","models/props_wasteland/interior_fence002d.mdl",Angle(90, 180, 180), Vector(-672.8117, 3515.6367, 391.4228)},
		{"prop_physics","models/props_wasteland/interior_fence002d.mdl",Angle(90, 180, 180), Vector(-672.8117, 3258.4561, 391.4228)},
		{"prop_physics","models/props_wasteland/interior_fence002d.mdl",Angle(90, 180, 180), Vector(-672.8117, 3001.2754, 391.4228)},
	*/
	}
}
PLUGIN.KillBoxes = {
	rp_evocity_v2d = {
		{
			bottom = Vector(-9608.0000,  15352.0000, -06.0000),
			top		= Vector(-6020.0000,  11256.0000, 950.0000)
		},
		{
			top = Vector(-7887.8901,-8729.5391,-945.4652),
			bottom = Vector(-7751.4458,-8618.6855,-1121.1049)
		},
		{
			top = Vector(-7675.9687,-8429.2139,-184.214),
			bottom = Vector(-7484.3008,-8745.4541,-375.9687)
		}
	}
}
local function killfunc(tab,size)
	local box, entlist, ent;
	for i = 1,size do
		box = tab[i];
		entlist = ents.FindInBox(box.bottom,box.top);
		for j = 1, #entlist do
			ent = entlist[j];
			if (ent:IsPlayer() and ent:Alive()) then
				ent:SetVelocity( ent:GetVelocity()*-2);
				ent:Kill();
			end
		end
	end
end
-- Called when the map has loaded all the entities.
function PLUGIN:InitPostEntity()
	local mapname = string.lower(game.GetMap());
	local iclass,next,pos;
	for _, ent in ipairs(ents.GetAll()) do
		iclass = ent:GetClass();
		next = false;
		for _, class in ipairs(self.EntitiesToDelete.all) do
			if (string.find(iclass, class)) then
				ent:Remove();
				next = true;
				break;
			end
		end
		if (not next and self.EntitiesToDelete[mapname]) then
			for _, class in ipairs(self.EntitiesToDelete[mapname]) do
				if (string.find(iclass, class)) then
					ent:Remove();
					next = true;
					break;
				end
			end
		end
		if (not next and self.SpecificEntitiesToDelete[mapname] and self.SpecificEntitiesToDelete[mapname][iclass]) then
			pos = ent:GetPos();
			for _,data in ipairs(self.SpecificEntitiesToDelete[mapname][iclass]) do
				if (pos:Distance( data[1] ) <= (data[2] or 32)) then
					ent:Remove();
					break;
				end
			end
		end
	end
	if (self.KillBoxes[mapname]) then
		timer.Create("Killboxes",0.1,0, function()
			killfunc(self.KillBoxes[mapname],#self.KillBoxes[mapname]);
		end)
	end
	--Spawn stuff for the map
	if (not self.EntitiesToSpawn[mapname]) then return end
	local filtr = ents.Create("filter_activator_name");
	if (not IsValid(filtr)) then
		error"Applejack (Cleanmap): Damage filter is not valid!";
	end
	filtr:SetKeyValue("targetname","aj_cm");
	filtr:SetKeyValue("negated","1");
	filtr:Spawn();
	for k,v in ipairs(self.EntitiesToSpawn[mapname]) do
		ent = ents.Create(v[1]);
		if (not IsValid(ent)) then
			ErrorNoHalt("["..os.date().."] Applejack Cleanmap Plugin: "..v[1].." is not a valid entity!\n");
		else
			ent:SetModel (v[2]);
			ent:SetAngles(v[3]);
			ent:SetPos   (v[4]);
			ent.PhysgunDisabled = true;
			ent.m_tblToolsAllowed = {};
			ent:Spawn();
			local phys = ent:GetPhysicsObject();
			if (IsValid(phys)) then
				phys:EnableMotion(false);
			else
				ErrorNoHalt("Applejack (Cleanmap): Model has no physics! "..v[1].."\n");
			end
			ent:Fire("setdamagefilter", "aj_cm", 0);
			hook.Call("PropSpawned", GAMEMODE, v[2], ent);
			cider.propprotection.GiveToWorld(ent);
			GAMEMODE.entities[ent] = ent;
		end
	end
end