--[[
Name: "sv_propprotection.lua".
	~ Applejack ~
--]]
------------------------------------
--	Simple Prop Protection
--	By Spacetech
-- 	http://code.google.com/p/simplepropprotection
------------------------------------
cider.propprotection = {}
cider.propprotection.Props = {}
cider.propprotection.WeirdTraces = {
	"wire_winch",
	"wire_hydraulic",
	"slider",
	"hydraulic",
	"winch",
	"muscle"
}

function cider.propprotection.SetupSettings()
	if(!sql.TableExists("spropprotectiona")) then
		sql.Query("CREATE TABLE IF NOT EXISTS spropprotectiona(toggle INTEGER NOT NULL, admin INTEGER NOT NULL, pgr INTEGER NOT NULL, awp INTEGER NOT NULL, dpd INTEGER NOT NULL, dae INTEGER NOT NULL, delay INTEGER NOT NULL);")
		sql.Query("CREATE TABLE IF NOT EXISTS spropprotectionafriends(steamid TEXT NOT NULL PRIMARY KEY, bsteamid TEXT);")
		sql.Query("INSERT INTO spropprotectiona(toggle, admin, pgr, awp, dpd, dae, delay) VALUES(1, 1, 1, 0, 1, 1, 120)")
	end
	local c = sql.QueryRow("SELECT * FROM spropprotectiona LIMIT 1")
	return c
end

cider.propprotection.Config = cider.propprotection.SetupSettings()

function cider.propprotection.AdminReloadPlayer(ply)
	if(!ply or !ply:IsValid()) then
		return
	end
	for k,v in pairs(cider.propprotection.Config) do
		local stuff = k
		if(stuff == "toggle") then
			stuff = "check"
		end
		ply:ConCommand("sppa_"..stuff.." "..v.."\n")
	end
end

function cider.propprotection.AdminReload()
	if(ply) then
		cider.propprotection.AdminReloadPlayer(ply)
	else
		for k,v in pairs(player.GetAll()) do
			cider.propprotection.AdminReloadPlayer(v)
		end
	end
end

function cider.propprotection.LoadFriends(ply)
	local PData = ply:GetPData("SPPFriends", "")
	if(PData ~= "") then
		for k,v in pairs(string.Explode(";", PData)) do
			local String = string.Trim(v)
			if(String ~= "") then
				table.insert(cider.propprotection[ply:SteamID()], String)
			end
		end
	end
end
function cider.propprotection.PlayerMakePropSpawner(ply,ent)
	if not IsValid(ent) then error("PlayerMakePropSpawner passed no ent!",2) end
	ent._PSpawned	= ply:Nick()
	ent._PSpawnedObj= ply
end
function cider.propprotection.ClearSpawner(ent)
	if not IsValid(ent) then error("ClearSpawner passed no ent!",2) end
	ent._PSpawned	= nil
	ent._PSpawnedObj= nil
end
function cider.propprotection.PlayerMakePropOwner(ply, ent, spawned)
	if(ent:GetClass() == "transformer" and ent.spawned and !ent.Part) then
		for k,v in pairs(transpiece[ent]) do
			v.Part = true
			cider.propprotection.PlayerMakePropOwner(ply, v, spawned)
		end
	end
	if(ent:IsPlayer()) then
		return false
	end
	cider.propprotection.Props[ent:EntIndex()] = {
		Ent 			= ent,
		Owner 			= ply,
		SteamID			= ply:SteamID()
	}
	ent._POwner			= ply:Nick()
	ent._POwnerObj		= ply
	if spawned then
		cider.propprotection.PlayerMakePropSpawner(ply,ent)
	end
	--gamemode.Call("CPPIAssignOwnership", ply, ent)
	return true
end
local a = "-- %-15s: %-68s --"
local function f(p,b,c)
	p:PrintMessage(HUD_PRINTCONSOLE,string.format(a,b,c))
end
local b = "Vector(%09.4f, %09.4f, %09.4f)";
local function makepos(a)
	return string.format(b,a.x,a.y,a.z);
end
local c = "Angle(%4i, %4i, %4i)";
local function makeang(b)
	return string.format(c,b.p,b.y,b.r);
end
concommand.Add("sppa_info",function(p)
	local ent = p:GetEyeTrace().Entity
	if not IsValid(ent) then
		p:Notify("No entity.",0)
		return
	elseif not p:HasAccess("m") then
		p:Notify("You do not have access to that.",1)
		return
	end
	--p:Notify(( tostring( ent ).."["..ent:GetModel().."]"),0)
	if ent:IsPlayer() then
		p:Notify(ent:Name()..": "..ent:SteamID().." ("..ent:IPAddress()..")",0)
	elseif ent._POwner and ent._POwner ~= "" then
		local word = tostring( ent ).." is owned by "..ent._POwner
		if ent._PSpawned and ent._PSpawned ~= "" then
			word = word.." and was spawned by "..ent._PSpawned
		end
		word = word..". ("..ent:GetModel()..")"
		p:Notify(word,0)

		if p:HasAccess("D") then
			p:PrintMessage(HUD_PRINTCONSOLE, "-------------------------------------------------------------------------------------------" )
			p:PrintMessage(HUD_PRINTCONSOLE, "--                                       Prop info                                       --" )
			p:PrintMessage(HUD_PRINTCONSOLE, "-------------------------------------------------------------------------------------------" )
			f(p,"Info",tostring( ent ) )
			f(p,"Model",'"'..tostring( ent:GetModel() )..'"' )
			p:PrintMessage(HUD_PRINTCONSOLE, "-------------------------------------------------------------------------------------------" )
			f(p, "Position",makepos(ent:GetPos()))
			f(p, "Angle",makeang(ent:GetAngles()))
			local r,g,b,a = ent:GetColor()
			f(p,"Colour","Color("..r..", "..g..", "..b..", "..a..")" )
			f(p,"Material",tostring( ent:GetMaterial() ) )
			f(p,"Size",tostring( ent:OBBMaxs() - ent:OBBMins() ) )
			f(p,"Radius",tostring( ent:BoundingRadius() ) )

			local ph = ent:GetPhysicsObject()
			if IsValid(ph) and p:HasAccess("H") then
				p:PrintMessage(HUD_PRINTCONSOLE, "-------------------------------------------------------------------------------------------" )
				p:PrintMessage(HUD_PRINTCONSOLE, "--                                        PhysObj                                        --" )
				p:PrintMessage(HUD_PRINTCONSOLE, "-------------------------------------------------------------------------------------------" )
				f(p,"Mass",tostring(ph:GetMass()))
				f(p,"Inertia",tostring(ph:GetInertia()))
				f(p,"Velocity",tostring(ph:GetVelocity()))
				f(p,"Angle Velocity",tostring(ph:GetAngleVelocity()))
				f(p,"Rot Damping",tostring(ph:GetRotDamping()))
				f(p,"Speed Damping",tostring(ph:GetSpeedDamping()))
			end
			p:PrintMessage(HUD_PRINTCONSOLE, "-------------------------------------------------------------------------------------------" )
		end
	else
		p:Notify(tostring(ent).." is unowned!",0)
	end
end)

function cider.propprotection.GiveToWorld(ent)
	if(ent:GetClass() == "transformer" and ent.spawned and !ent.Part) then
		for k,v in pairs(transpiece[ent]) do
			v.Part = true
			cider.propprotection.GiveToWorld( v)
		end
	end
	if(ent:IsPlayer()) then
		return false
	end
	ent._POwner = "World"
	--gamemode.Call("CPPIAssignOwnership", ply, ent)
	return true
end

if(cleanup) then
	local Clean = cleanup.Add
	function cleanup.Add(Player, Type, Entity)
		if(Entity) then
			local Check = Player:IsPlayer()
			local Valid = Entity:IsValid()
		    if(Check and Valid) then
		        cider.propprotection.PlayerMakePropOwner(Player, Entity)
		    end
		end
	    Clean(Player, Type, Entity)
	end
end

local Meta = FindMetaTable("Player")
if Meta and Meta.AddCount then
	local Backup = Meta.AddCount
	function Meta:AddCount(Type, Entity)
		cider.propprotection.PlayerMakePropOwner(self, Entity, true)
		Backup(self, Type, Entity)
	end
	function Meta:TakeCount(str,ent)
		if ( !self:IsValid() ) then return end
		local key = self:UniqueID()
		local tab = g_SBoxObjects[ key ]
		if ( !tab || !tab[ str ] ) then
			return
		end
		for k,v in ipairs(tab[ str ]) do
			if v == ent then
				table.remove(tab[ str ],k)
				break
			end
		end
		self:GetCount(str)
		cider.propprotection.GiveToWorld(ent)
		cider.propprotection.ClearSpawner(ent)
	end
end

function cider.propprotection.CheckConstraints(ply, ent)
	for k,v in pairs(constraint.GetAllConstrainedEntities(ent) or {}) do
		if(v and v:IsValid()) then
			if(!cider.propprotection.PlayerCanTouch(ply, v)) then
				return false
			end
		end
	end
	return true
end

function cider.propprotection.IsFriend(ply, ent)
	local Players = player.GetAll()
	if(table.Count(Players) == 1) then
		return true
	end
	for k,v in pairs(Players) do
		if(v and v:IsValid() and v ~= ply) then
	        if(cider.propprotection.Props[ent:EntIndex()].SteamID == v:SteamID()) then
                if(table.HasValue(cider.propprotection[v:SteamID()], ply:SteamID())) then
					return true
				else
					return false
				end
            end
		end
	end
end

function cider.propprotection.PlayerCanTouch(ply, ent)
	if(tonumber(cider.propprotection.Config["toggle"]) == 0 or ent:GetClass() == "worldspawn" or ent.SPPOwnerless) then
		return true
	end

	if(string.find(ent:GetClass(), "stone_") == 1 or string.find(ent:GetClass(), "rock_") == 1 or string.find(ent:GetClass(), "stargate_") == 0 or string.find(ent:GetClass(), "dhd_") == 0 or ent:GetClass() == "flag" or ent:GetClass() == "item") then
		if(!ent._POwner or ent._POwner == "") then
			ent._POwner = "World"
		end
		if(ply:GetActiveWeapon():GetClass() ~= "weapon_physgun" and ply:GetActiveWeapon():GetClass() ~= "gmod_tool") then
			return true
		end
	end

	if (!ent._POwner or ent._POwner == "") and !ent:IsPlayer() then
		cider.propprotection.PlayerMakePropOwner(ply, ent)
		ply:Notify("You now own this prop",0)
		return true
	end

	if(ent._POwner == "World") then
		if(ply:IsAdmin() and tonumber(cider.propprotection.Config["awp"]) == 1 and tonumber(cider.propprotection.Config["admin"]) == 1) then
			return true
		end
	elseif(ply:IsAdmin() and tonumber(cider.propprotection.Config["admin"]) == 1) then
		return true
	end

	if(cider.propprotection.Props[ent:EntIndex()]) then
		if(cider.propprotection.Props[ent:EntIndex()].SteamID == ply:SteamID() or cider.propprotection.IsFriend(ply, ent)) then
			return true
		end
	else
		for k,v in pairs(g_SBoxObjects) do
			for b, j in pairs(v) do
				for _, e in pairs(j) do
					if(k == ply:SteamID() and e == ent) then
						cider.propprotection.PlayerMakePropOwner(ply, ent)
						ply:Notify("You now own this prop",0)
						return true
					end
				end
			end
		end
	end
	if(game.GetMap() == "gm_construct" and ent._POwner == "World") then
		return true
	end
	return false
end

function cider.propprotection.DRemove(SteamID, PlayerName)
	for k,v in pairs(cider.propprotection.Props) do
		if(v.SteamID == SteamID and v.Ent:IsValid() and not GAMEMODE.entities[v.Ent]) then
			v.Ent:Remove()
			cider.propprotection.Props[k] = nil
		end
	end
	player.NotifyAll(tostring(PlayerName).."'s props have been cleaned up",0)
end

function cider.propprotection.PlayerInitialSpawn(ply)
	ply:SetNWString("SPPSteamID", string.gsub(ply:SteamID(), ":", "_"))
	cider.propprotection[ply:SteamID()] = {}
	cider.propprotection.LoadFriends(ply)
	cider.propprotection.AdminReload(ply)
	local TimerName = "cider.propprotection.DRemove: "..ply:SteamID()
	if(timer.Exists(TimerName)) then
		timer.Stop(TimerName)
	end
end
hook.Add("PlayerInitialSpawn", "cider.propprotection.PlayerInitialSpawn", cider.propprotection.PlayerInitialSpawn)

function cider.propprotection.Disconnect(ply)
	if(tonumber(cider.propprotection.Config["dpd"]) == 1) then
		if(ply:IsAdmin() and tonumber(cider.propprotection.Config["dae"]) == 0) then
			return
		end
		timer.Create("cider.propprotection.DRemove: "..ply:SteamID(), tonumber(cider.propprotection.Config["delay"]), 1, function()
			cider.propprotection.DRemove(ply:SteamID(), ply:Nick())
		end)
	end
end
hook.Add("PlayerDisconnected", "cider.propprotection.Disconnect", cider.propprotection.Disconnect)

function cider.propprotection.PhysGravGunPickup(ply, ent)
	if(!ent or !ent:IsValid()) then
		return
	end
	if(ent:IsPlayer() and ply:IsAdmin() and tonumber(cider.propprotection.Config["admin"]) == 1) then
		return
	end
	if(!ent:IsValid() or !cider.propprotection.PlayerCanTouch(ply, ent)) then
		return false
	end
end
hook.Add("GravGunPunt", "cider.propprotection.GravGunPunt", cider.propprotection.PhysGravGunPickup)
hook.Add("GravGunPickupAllowed", "cider.propprotection.GravGunPickupAllowed", cider.propprotection.PhysGravGunPickup)
hook.Add("PhysgunPickup", "cider.propprotection.PhysgunPickup", cider.propprotection.PhysGravGunPickup)

function cider.propprotection.CanTool(ply, tr, mode)
	if(tr.HitWorld) then
		return
	end
	local ent = tr.Entity
	if(!ent:IsValid() or ent:IsPlayer()) then
		return false
	end
	if(!cider.propprotection.PlayerCanTouch(ply, ent)) then
		return false
	elseif(mode == "nail") then
		local Trace = {}
		Trace.start = tr.HitPos
		Trace.endpos = tr.HitPos + (ply:GetAimVector() * 16.0)
		Trace.filter = {ply, tr.Entity}
		local tr2 = util.TraceLine(Trace)
		if(tr2.Hit and IsValid(tr2.Entity) and !tr2.Entity:IsPlayer()) then
			if(!cider.propprotection.PlayerCanTouch(ply, tr2.Entity)) then
				return false
			end
		end
	elseif(table.HasValue(cider.propprotection.WeirdTraces, mode)) then
		local Trace = {}
		Trace.start = tr.HitPos
		Trace.endpos = Trace.start + (tr.HitNormal * 16384)
		Trace.filter = {ply}
		local tr2 = util.TraceLine(Trace)
		if(tr2.Hit and IsValid(tr2.Entity) and !tr2.Entity:IsPlayer()) then
			if(!cider.propprotection.PlayerCanTouch(ply, tr2.Entity)) then
				return false
			end
		end
	elseif(mode == "remover") then
		if(ply:KeyDown(IN_ATTACK2) or ply:KeyDownLast(IN_ATTACK2)) then
			if(!cider.propprotection.CheckConstraints(ply, ent)) then
				return false
			end
		end
	end
end
hook.Add("CanTool", "cider.propprotection.CanTool", cider.propprotection.CanTool)
--[[
function cider.propprotection.EntityTakeDamageFireCheck(ent)
    if(!ent or !ent:IsValid()) then
		return
	end
	if(ent:IsOnFire()) then
		ent:Extinguish()
	end
end

function cider.propprotection.EntityTakeDamage(ent, inflictor, attacker, amount, dmginfo)
	if(tonumber(cider.propprotection.Config["edmg"]) == 0) then
		return
	end
    if(!ent:IsValid() or ent:IsPlayer() or !attacker:IsPlayer()) then
		return
	end
	if(!cider.propprotection.PlayerCanTouch(attacker, ent)) then
		dmginfo:SetDamage(0)
		timer.Simple(0.1, cider.propprotection.EntityTakeDamageFireCheck, ent)
	end
end
hook.Add("EntityTakeDamage", "cider.propprotection.EntityTakeDamage", cider.propprotection.EntityTakeDamage)

function cider.propprotection.PlayerUse(ply, ent)
	if(ent:IsValid() and tonumber(cider.propprotection.Config["use"]) == 1) then
		if(!cider.propprotection.PlayerCanTouch(ply, ent) and ent._POwner ~= "World") then
			return false
		end
	end
end
hook.Add("PlayerUse", "cider.propprotection.PlayerUse", cider.propprotection.PlayerUse)--]]

function cider.propprotection.OnPhysgunReload(weapon, ply)
	if(tonumber(cider.propprotection.Config["pgr"]) == 0) then
		return
	end
	local tr = util.TraceLine(util.GetPlayerTrace(ply))
	if(!tr.HitNonWorld or !tr.Entity:IsValid() or tr.Entity:IsPlayer()) then
		return
	end
	if(!cider.propprotection.PlayerCanTouch(ply, tr.Entity)) then
		return false
	end
end
hook.Add("OnPhysgunReload", "cider.propprotection.OnPhysgunReload", cider.propprotection.OnPhysgunReload)

function cider.propprotection.EntityRemoved(ent)
	cider.propprotection.Props[ent:EntIndex()] = nil
end
hook.Add("EntityRemoved", "cider.propprotection.EntityRemoved", cider.propprotection.EntityRemoved)

function cider.propprotection.PlayerSpawnedSENT(ply, ent)
	cider.propprotection.PlayerMakePropOwner(ply, ent, true)
end
hook.Add("PlayerSpawnedSENT", "cider.propprotection.PlayerSpawnedSENT", cider.propprotection.PlayerSpawnedSENT)

function cider.propprotection.PlayerSpawnedVehicle(ply, ent)
	cider.propprotection.PlayerMakePropOwner(ply, ent, true)
end
hook.Add("PlayerSpawnedVehicle", "cider.propprotection.PlayerSpawnedVehicle", cider.propprotection.PlayerSpawnedVehicle)

function cider.propprotection.CDP(ply, cmd, args)
	if(!ply:IsAdmin()) then
		return
	end
	for k,v in pairs(cider.propprotection.Props) do
		local Found = false
		for k2,v2 in pairs(player.GetAll()) do
			if(v.SteamID == v2:SteamID()) then
				Found = true
			end
		end
		if(!Found) then
			local Ent = v.Ent
			if(Ent and Ent:IsValid() and not GAMEMODE.entities[Ent]) then
				Ent:Remove()
			end
			cider.propprotection.Props[k] = nil
		end
	end
	player.NotifyAll("Disconnected players props have been cleaned up",0)
end
concommand.Add("sppa_cdp", cider.propprotection.CDP)

function cider.propprotection.CleanupPlayerProps(ply)
	for k,v in pairs(cider.propprotection.Props) do
		if(v.SteamID == ply:SteamID()) then
			local Ent = v.Ent
			if (not Ent.NoClear or Ent:GetClass():find"cider") then
				if(Ent and Ent:IsValid() and not GAMEMODE.entities[Ent] ) then
					Ent:Remove()
				end
				cider.propprotection.Props[k] = nil
			end
		end
	end
end

function cider.propprotection.CleanupProps(ply, cmd, args)
	local EntIndex = args[1]
	if(!EntIndex or EntIndex == "") then
		cider.propprotection.CleanupPlayerProps(ply)
		ply:Notify("Your props have been cleaned up",0)
	elseif(ply:IsAdmin()) then
		for k,v in pairs(player.GetAll()) do
			if(tonumber(EntIndex) == v:EntIndex()) then
				cider.propprotection.CleanupPlayerProps(v)
				player.NotifyAll(v:Nick().."'s props have been cleaned up",0)
			end
		end
	end
end
concommand.Add("sppa_cleanupprops", cider.propprotection.CleanupProps)

function cider.propprotection.ApplyFriends(ply, cmd, args)
	local Players = player.GetAll()
	if(table.Count(Players) > 1) then
		local ChangedFriends = false
		for k,v in pairs(Players) do
			local PlayersSteamID = v:SteamID()
			local PData = ply:GetPData("SPPFriends", "")
			if(tonumber(ply:GetInfo("sppa_friend_"..v:GetNWString("SPPSteamID"))) == 1) then
				if(!table.HasValue(cider.propprotection[ply:SteamID()], PlayersSteamID)) then
					ChangedFriends = true
					table.insert(cider.propprotection[ply:SteamID()], PlayersSteamID)
					if(PData == "") then
						ply:SetPData("SPPFriends", PlayersSteamID..";")
					else
						ply:SetPData("SPPFriends", PData..PlayersSteamID..";")
					end
				end
			else
				if(table.HasValue(cider.propprotection[ply:SteamID()], PlayersSteamID)) then
					for k2,v2 in pairs(cider.propprotection[ply:SteamID()]) do
						if(v2 == PlayersSteamID) then
							ChangedFriends = true
							table.remove(cider.propprotection[ply:SteamID()], k2)
							ply:SetPData("SPPFriends", string.gsub(PData, PlayersSteamID..";", ""))
						end
					end
				end
			end
		end--[[
		if(ChangedFriends) then
			local Table = {}
			for k,v in pairs(cider.propprotection[ply:SteamID()]) do
				for k2,v2 in pairs(player.GetAll()) do
					if(v == v2:SteamID()) then
						table.insert(Table, v2)
					end
				end
			end
			gamemode.Call("CPPIFriendsChanged", ply, Table)
		end--]]
	end
	ply:Notify("Your friends have been updated",0)
end
concommand.Add("sppa_applyfriends", cider.propprotection.ApplyFriends)

function cider.propprotection.ClearFriends(ply, cmd, args)
	local PData = ply:GetPData("SPPFriends", "")
	if(PData ~= "") then
		for k,v in pairs(string.Explode(";", PData)) do
			local String = string.Trim(v)
			if(String ~= "") then
				ply:ConCommand("sppa_friend_"..string.gsub(String, ":", "_").." 0\n")
			end
		end
		ply:SetPData("SPPFriends", "")
	end
	for k,v in pairs(cider.propprotection[ply:SteamID()]) do
		ply:ConCommand("sppa_friend_"..string.gsub(v, ":", "_").." 0\n")
	end
	cider.propprotection[ply:SteamID()] = {}
	ply:Notify("Your friends have been cleared",0)
end
concommand.Add("sppa_clearfriends", cider.propprotection.ClearFriends)

function cider.propprotection.ApplySettings(ply, cmd, args)
	if(!ply:IsAdmin()) then
		return
	end

	local toggle = tonumber(ply:GetInfo("sppa_check") or 1)
	local admin = tonumber(ply:GetInfo("sppa_admin") or 1)
--	local use = tonumber(ply:GetInfo("sppa_use") or 1)
--	local edmg = tonumber(ply:GetInfo("sppa_edmg") or 1)
	local pgr = tonumber(ply:GetInfo("sppa_pgr") or 1)
	local awp = tonumber(ply:GetInfo("sppa_awp") or 1)
	local dpd = tonumber(ply:GetInfo("sppa_dpd") or 1)
	local dae = tonumber(ply:GetInfo("sppa_dae") or 1)
	local delay = math.Clamp(tonumber(ply:GetInfo("sppa_delay") or 120), 1, 500)

	sql.Query("UPDATE spropprotectiona SET toggle = "..toggle..", admin = "..admin..", pgr = "..pgr..", awp = "..awp..", dpd = "..dpd..", dae = "..dae..", delay = "..delay)

	cider.propprotection.Config = sql.QueryRow("SELECT * FROM spropprotectiona LIMIT 1")

	timer.Simple(2, cider.propprotection.AdminReload)

	ply:Notify("Admin settings have been updated",0)
end
concommand.Add("sppa_apply", cider.propprotection.ApplySettings)

function cider.propprotection.WorldOwner()
	local WorldEnts = 0
	for _,v in ipairs(ents.GetAll()) do
		if(!v:IsPlayer() and !v._POwner) then
			v._POwner = "World"
			WorldEnts = WorldEnts + 1
		end
	end
	Msg("=================================================\n")
	Msg("Simple Prop Protection (Ajack): "..tostring(WorldEnts).." props belong to world\n")
	Msg("=================================================\n")
end
hook.Add("InitPostEntity","GrabWorldEnts",cider.propprotection.WorldOwner)