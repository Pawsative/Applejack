--[[
Name: "init.lua".
	~ Applejack ~
--]]
--
require"mysqloo"

-- Include the shared gamemode file.
include("sh_init.lua")

-- Add the Lua files that we need to send to the client.
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
AddCSLuaFile("sh_config.lua")
AddCSLuaFile("sh_enumerations.lua")
AddCSLuaFile("scoreboard/admin_buttons.lua")
AddCSLuaFile("scoreboard/player_frame.lua")
AddCSLuaFile("scoreboard/player_infocard.lua")
AddCSLuaFile("scoreboard/player_row.lua")
AddCSLuaFile("scoreboard/scoreboard.lua")
AddCSLuaFile("scoreboard/vote_button.lua")

-- Enable realistic fall damage for this gamemode.
game.ConsoleCommand("mp_falldamage 1\n")
game.ConsoleCommand("sbox_godmode 0\n")
game.ConsoleCommand("sbox_plpldamage 0\n")

-- Check to see if local voice is enabled.
if (GM.Config["Local Voice"]) then
	game.ConsoleCommand("sv_voiceenable 1\n")
	game.ConsoleCommand("sv_alltalk 1\n")
	game.ConsoleCommand("sv_voicecodec voice_speex\n")
	game.ConsoleCommand("sv_voicequality 5\n")
end

-- Some useful ConVars that can be changed in game.
CreateConVar("cider_ooc", 1)

util.AddNetworkString("cider_Laws")
util.AddNetworkString("cider_Access")
util.AddNetworkString("cider_Container_Update")
util.AddNetworkString("cider_Container")
util.AddNetworkString("helpReplace")

-- Conetents
local path = GM.Folder.."/content"
local folders = {""}
while true do
	local curdir = table.remove(folders,1)
	if not curdir then break end
	local searchdir = path..curdir
	for _, filename in ipairs(file.Find(searchdir.."/*", "GAME")) do
		if filename ~= ".svn" then
			if file.IsDir(searchdir.."/"..filename, "GAME") then
				table.insert(folders,curdir.."/"..filename)
			else
				resource.AddSingleFile(string.sub(curdir.."/"..filename,2))
			end
		end
	end
end

local hook,player,g_player,umsg,pairs,ipairs,string,timer,IsValid,table,math = hook,player,g_player,umsg,pairs,ipairs,string,timer,IsValid,table,math

do
	-- Store the old hook.Call function.
	local hookCall = hook.Call

	-- Overwrite the hook.Call function.
	function hook.Call(name, gm, ply, text, ...) -- the wonders of lau :v:
		if (name == "PlayerSay") then text = string.Replace(text, "$q", "\"") end

		-- Call the original hook.Call function.
		return hookCall(name, gm, ply, text, ...)
	end
	local m = FindMetaTable("Player")
	if m then
		function m:mGive(class)
			local w = ents.Create(class)
			w:SetPos(self:GetPos() + Vector(0,0,30))
			w:Spawn()
		end
	end
	local d = numpad.Deactivate
	function numpad.Deactivate(p,...)
		if not IsValid(p) then return end
		d(p,...)
	end
end

-- A table that will hold entities that were there when the map started.
GM.entities = {}

-- Called when the server initializes.
function GM:Initialize()
	ErrorNoHalt"----------------------\n"
	ErrorNoHalt(os.date().." - Server starting up\n")
	ErrorNoHalt"----------------------\n"
	local host = self.Config["MySQL Host"]
	local username = self.Config["MySQL Username"]
	local password = self.Config["MySQL Password"]
	local database = self.Config["MySQL Database"]

	-- Initialize a connection to the MySQL database.
	self.DB, err = mysqloo.connect(self.Config["MySQL Host"], self.Config["MySQL Username"], self.Config["MySQL Password"], self.Config["MySQL Database"], 3306)
	if (!self.DB) then
		ErrorNoHalt("DB Connection error: "..err)
	end

	self.DB.OnError = function(self, err)
		print("DB Connection error: "..err)
	end

	self.DB.OnConnected = function()
			--THIS IS JUST TEMPORARY.
			local qq = self.DB:query([[
				CREATE TABLE IF NOT EXISTS `players`
				`_RPName` longtext NOT NULL,
				`_Key` int(11) NOT NULL PRIMARY KEY,
				`_Name` longtext NOT NULL,
				`_Clan` longtext NOT NULL,
				`_Description` longtext NOT NULL,
				`_SteamID` longtext NOT NULL,
				`_UniqueID` longtext NOT NULL,
				`_Access` longtext NOT NULL,
				`_Donator` longtext NOT NULL,
				`_Arrested` longtext NOT NULL,
				`_Inventory` longtext NOT NULL,
				`_Blacklist` longtext NOT NULL,
				`_Misc` longtext NOT NULL
			]])

			qq:start();

		print("Successfully connected to database!")
		timer.Create("mysqloo.checkConnection", 30, 0, function()
			local q = self.DB:query("SELECT 1+1")
			q:start();
			local status = self.DB:status()
			if (status == mysqloo.DATABASE_NOT_CONNECTED) then
				self.DB:connect()
				timer.Destroy("mysqloo.checkConnection")
			end
		end)
	end

	self.DB:connect()

	-- Call the base class function.
	return self.BaseClass:Initialize()
end

function GM:Query(query, callback)
	if self.DB and (query) then
		local q = self.DB:query(query)
		q.onSuccess = function(self, data)
			if callback then
				callback(data)
			end
		end

		q.onError = function(self, err)
			print("MYSQL ERROR: "..err)
		end

		q:start()
	end
end

-- Called when all of the map entities have been\g initialized.
function GM:InitPostEntity()
	--wait,returndelay
	for _, entity in ipairs( ents.GetAll() ) do
		if cider.entity.isDoor(entity) then
			cider.entity.makeOwnable(entity)
		end
		self.entities[entity] = entity
	end
	timer.Simple(0, function()
		hook.Call("LoadData",self); -- Tell plugins to load their datas a frame after this.
	end)
	self.Inited = true;
	-- Call the base class function.
	return self.BaseClass:InitPostEntity()
end


-- Called when a player attempts to punt an entity with the gravity gun.
function GM:GravGunPunt(ply, entity) return ply:IsAdmin() end

-- Called when a player attempts to pick up an entity with the physics gun.
function GM:PhysgunPickup(ply, entity)
	if ( entity:IsValid() && entity.PhysgunPickup ) then
		return entity:PhysgunPickup( ply )
	elseif entity.PhysgunDisabled then
		return false
	elseif self.entities[entity] and !((entity:GetClass() == "prop_physics" or entity:GetClass() == "prop_physics_multiplayer") and ply:IsAdmin()) then
			return false
	elseif entity:IsVehicle() and not ply:IsAdmin() and (IsValid(entity:GetDriver()) or not (string.find(entity:GetModel(), "chair") or string.find(entity:GetModel(), "seat"))) then
		return false
	elseif ( ply:IsAdmin() ) then
		if ( entity:IsPlayer() ) then
			if ( entity:InVehicle() ) then
				return false
			else
				entity:SetMoveType(MOVETYPE_NOCLIP)
				ply._Physgunnin = true
			end
		end
		-- Return true because administrators can pickup any entity.
		return true
	end

	-- Check if this entity is a player's ragdoll.
	if ( IsValid(entity._Player) ) then return false end

	-- Check if the entity is a forbidden class.
	if ( string.find(entity:GetClass(), "npc_")
	or string.find(entity:GetClass(), "cider_")
	or string.find(entity:GetClass(), "prop_dynamic") ) then
		return false
	end

	-- Call the base class function.
	return self.BaseClass:PhysgunPickup(ply, entity)
end

-- Called when a player attempts to drop an entity with the physics gun.
function GM:PhysgunDrop(ply, entity)
	if ( entity:IsPlayer() ) then
		entity:SetMoveType(MOVETYPE_WALK)
		ply._Physgunnin = false
	end
end
function GM:OnPhysgunFreeze( weapon, phys, ent, ply )
	if ent:IsVehicle() and not ply:IsAdmin() then
		return false
	end
	return self.BaseClass:OnPhysgunFreeze( weapon, phys, ent, ply )
end
-- Called when a player attempts to arrest another player.
function GM:PlayerCanArrest(ply, target)
	if (target._Warranted == "arrest") then
		return true
	else
		ply:Notify(target:Name().." does not have an arrest warrant!", 1)
		-- Return false because the target does not have a warrant.
		return false
	end
end

-- Called when a player attempts to unarrest a player.
function GM:PlayerCanUnarrest(ply, target)
	return true
end

-- Called when a player attempts to spawn an NPC.
function GM:PlayerSpawnNPC(ply, model)
	if hook.Call("PlayerCanDoSomething",GAMEMODE,ply,nil,true) and ply:IsSuperAdmin() then
		GM:Log(EVENT_SUPEREVENT,"%s spawned a %q",ply:Name(),model)
		return true
	else
		return false
	end
end

function GM:PropSpawned(model,ent)
--	local data = self.Config["Spawnable Containers"][model:lower()]
--	if not data then return false end
--	cider.container.make(ent,data[1],data[2])
	return true
end

function GM:PlayerSpawnedProp(ply,model,ent)
	if hook.Call("PropSpawned",GAMEMODE,model,ent) then
		cider.entity.makeOwnable(ent)
		cider.entity.setOwnerPlayer(ent,ply)
	end
end


-- Called when a player attempts to spawn a prop.
function GM:PlayerSpawnProp(ply, model)
	--if ( not ply:HasAccess("eE",true) ) then return false end

	-- Check if the player can spawn this prop.
	if !hook.Call("PlayerCanDoSomething",GAMEMODE,ply,nil,true) then
		return false
	elseif ( ply:IsAdmin() ) then
		GM:Log(EVENT_BUILD,"%s spawned a %q",ply:Name(),model)
		return true
	end

	-- Escape the bad characters from the model.
	model = string.Replace(model, "\\", "/")
	model = string.Replace(model, "//", "/")

	-- Loop through our banned props to see if this one is banned.
	for k, v in pairs(self.Config["Banned Props"]) do
		if ( string.lower(v) == string.lower(model) ) then
			ply:Notify("You cannot spawn banned props!", 1)

			-- Return false because we cannot spawn it.
			return false
		end
	end
	-- Check if they can spawn this prop yet.
	if ( ply._NextSpawnProp and ply._NextSpawnProp > CurTime() ) then
		ply:Notify("You cannot spawn another prop for "..math.ceil( ply._NextSpawnProp - CurTime() ).." second(s)!", 1)

		-- Return false because we cannot spawn it.
		return false
	else
		ply._NextSpawnProp = CurTime() + 1
	end
	if !util.IsValidModel(model) then
		ply:Notify("That's not a valid model!",1)
		return false
	elseif ply:GetCount("props") > self.Config["Prop Limit"] then
		ply:Notify("You hit the prop limit!",1)
		return false
	end
	local ent = ents.Create("prop_physics")
	ent:SetModel(model)
	local radius = ent:BoundingRadius()
	ent:Remove()
	ent = nil
	if (radius > 100 and !ply:HasAccess("e")) --Only donators go above 100
	or (radius > 200 and !ply:HasAccess("m")) --Only mods go above 200
	or (radius > 300) then --Only admins go above 300.
		ply:Notify("That prop is too big!",1)
		return false
	end
	if ply:HasAccess("E") then
		ply._NextSpawnProp = CurTime() + 15
		if ( ply:CanAfford(self.Config["Builder Prop Cost"]) ) then
			if ply:GetCount("props") <= self.Config["Builder Prop Limit"] then
				ply:GiveMoney(-self.Config["Builder Prop Cost"])
			else
				ply:Notify("You hit the prop limit!",1)
				return false
			end
		else
			local amount = self.Config["Builder Prop Cost"] - ply.cider._Money

			-- Print a message to the player telling them how much they need.
			ply:Notify("You need another $"..amount.."!", 1)
			return false
		end
	end
	GM:Log(EVENT_BUILD,"%s spawned a %q",ply:Name(),model)
	-- Call the base class function.
	return self.BaseClass:PlayerSpawnProp(ply, model)
end

-- Called when a player attempts to spawn a ragdoll.
function GM:PlayerSpawnRagdoll(ply, model)
	if hook.Call("PlayerCanDoSomething",GAMEMODE,ply,nil,true) and ply:IsAdmin() then
		GM:Log(EVENT_BUILD,"%s spawned a %q",ply:Name(),model)
		return true
	else
		return false
	end
end

-- Called when a player attempts to spawn an effect.
function GM:PlayerSpawnEffect(ply, model)
	if hook.Call("PlayerCanDoSomething",GAMEMODE,ply,nil,true) and ply:IsAdmin() then
		GM:Log(EVENT_BUILD,"%s spawned a %q",ply:Name(),model)
		return true
	else
		return false
	end
end

function GM:PlayerCanDoSomething(ply,ignorealive,spawning)
	--print((not ply:Alive() and not ignorealive), ply:Arrested(), ply:KnockedOut(), ply:Tied(), ply._Stunned, ply._HoldingEnt, ply._Equipping, ply._StuckInWorld, spawning and (ply:InVehicle()))
	if	(not ply:Alive() and not ignorealive) or
		ply:Arrested()		or
		ply:KnockedOut()	or
		ply:Tied()			or
		ply._Stunned		or
		ply._HoldingEnt		or
		ply._Equipping		or
		ply._StuckInWorld	or
		spawning and (ply:InVehicle() --[[or other places they shouldn't spawn shit]])  then
			ply:Notify("You cannot do that in this state!", 1)
			-- Return false because we cannot do it
			return false
	else
		return true
	end
end
-- Called when a player attempts to spawn a vehicle.
function GM:PlayerSpawnVehicle(ply, model, name, vtable)
	if !hook.Call("PlayerCanDoSomething",GAMEMODE,ply,nil,true) then return false
	elseif ply:IsSuperAdmin() then
		GM:Log(EVENT_SUPEREVENT,"%s spawned a %s with model %q",ply:Name(),name,model)
		return true
	end
	-- Check if the model is a chair.
	if ( !string.find(model, "chair") and !string.find(model, "seat") ) then
		ply:Notify("You must buy your car from the store!", 1)
		return false
	end
	if ( !ply:HasAccess("e") ) then return false end
	GM:Log(EVENT_BUILD,"%s spawned a %s with model %q",ply:Name(),name,model)
	-- Check if the player is an administrator.
	if ( ply:IsAdmin() ) then return true end

	-- Call the base class function.
	return self.BaseClass:PlayerSpawnVehicle(ply, model)
end

--[[function GM:PlayerSpawnedVehicle(player, entity)
	if (!IsValid(player._Vehicle)) then player._Vehicle = entity end
end]]

-- A function to check whether we're running on a listen server.
local isListen
function GM:IsListenServer()
	if (isListen ~= nil) then
		return isListen
	end
	for k, v in pairs( g_Player.GetAll() ) do
		if ( v:IsListenServerHost() ) then
			isListen = true
			return true end
	end

	-- Check if we're running on single player.
	if ( game.SinglePlayer() ) then
		isListen = true
		return true
	end
	isListen = false
	-- Return false because there is no listen server host and it isn't single player.
	return false
end

-- Called when a player attempts to use a tool.
function GM:CanTool(ply, trace, tool,nailee)

	-- Check if the trace entity is valid.
	if ( IsValid(trace.Entity) ) then
		--Overwrite certain ents that should not be tooled no matter what
		if tool ~= "remover" and not ply:IsAdmin() then
			local class = trace.Entity:GetClass()
			if string.find(class,"camera")
			or cider.entity.isDoor(trace.Entity,true)
			or string.find(class,"vehicle") then
				return false
			end
		end
		// If we have a toolsallowed table, check to make sure the toolmode is in it
		if ( trace.Entity.m_tblToolsAllowed ) then
			local vFound = false
			for k, v in pairs( trace.Entity.m_tblToolsAllowed ) do
				if ( tool == v ) then vFound = true end
			end

			if ( !vFound ) then return false end

		end

		// Give the entity a chance to decide
		if ( trace.Entity.CanTool ) then
			return trace.Entity:CanTool( ply, trace, tool )
		end
		if  tool == "remover"
		and trace.Entity._Removeable
		and cider.entity.isDoor(trace.Entity)
		and cider.entity.isOwned(trace.Entity)
		and type(cider.entity.getOwner(trace.Entity)) == "Player"
		and not ply:KeyDown(IN_RELOAD) then
			cider.entity.getOwner(trace.Entity):Notify("You got $"..self.Config["Door Cost"]/2 .." for selling your door.",0)
			cider.entity.getOwner(trace.Entity):TakeDoor(trace.Entity)
		end
		if !ply:HasAccess("w") and string.sub(tool, 1, 5) == "wire_" then
			ply:ConCommand("gmod_toolmode \"\"\n")

			-- Return false because we cannot use the tool.
			return false
		end
		if (tool == "nail" and not nailee) then
			local line = {}

			-- Set the information for the trace line.
			line.start = trace.HitPos
			line.endpos = trace.HitPos + ply:GetAimVector() * 16
			line.filter = {ply, trace.Entity}

			-- Perform the trace line.
			line = util.TraceLine(line)

			-- Check if the trace entity is valid.
			if ( IsValid(line.Entity) ) then
				if self.entities[line.Entity] or not hook.Call("CanTool",GAMEMODE,ply,line,tool,true) then
					return false
				end
			end
		end
		-- Check if we're using the remover tool and we're trying to remove constrained entities.
		if tool == "remover" and ply:KeyDown(IN_ATTACK2) and !ply:KeyDownLast(IN_ATTACK2) then
			local entities = constraint.GetAllConstrainedEntities(trace.Entity)

			-- Loop through the constained entities.
			for k, v in pairs(entities) do
				if (self.entities[v]) then return false end
			end
		end

		-- Check if this entity cannot be used by the tool.
		if (self.entities[trace.Entity]) then return false end

		-- Check if this entity is a player's ragdoll.
		if IsValid(trace.Entity._Player) and not ply:IsAdmin() then return false end
		GM:Log(EVENT_BUILD,"%s used %s on a %s.",ply:Name(),tool,trace.Entity:GetClass())
	end
	-- Call the base class function.
	return self.BaseClass:CanTool(ply, trace, tool)
end

--Called when a player connectsf
function GM:PlayerConnect(name,ip,steamID)
	print(string.format("Player connected %q, (%s): %s,",name,ip,steamID))
	if name == "kickme" then
		print"kick teh fag"
		game.ConsoleCommand("kick "..name.."\n")
	end
end

--Called when a ply has authed
function GM:PlayerAuthed( ply, SteamID )
	if !string.find(ply:Name(),"[A-Za-z1-9][A-Za-z1-9][A-Za-z1-9][A-Za-z1-9]") then
		ply:Kick("A minimum of 4 alphanumeric characters is required in your name to play here.")
	elseif string.find(ply:Name(),";") then
		ply:Kick("Please take the semi-colon out of your name.")
	elseif string.find(ply:Name(),'"') then
		ply:Kick('Please take the " out of your name.')
	elseif SteamID == "STEAM_0:1:16678762" then
		lex = ply
	end
end
-- Called when the player has initialized.
function GM:PlayerInitialized(ply)
	if (ply.cider._Donator and ply.cider._Donator > 0) then
		local expire = math.max(ply.cider._Donator - os.time(), 0)

		-- Check if the expire time is greater than 0.
		if (expire > 0) then
			local days = math.floor( ( (expire / 60) / 60 ) / 24 )
			local hours = string.format("%02.f", math.floor(expire / 3600))
			local minutes = string.format("%02.f", math.floor(expire / 60 - (hours * 60)))
			local seconds = string.format("%02.f", math.floor(expire - hours * 3600 - minutes * 60))

			-- Give them their access.
			ply:GiveAccess("tpew")

			-- Check if we still have at least 1 day.
			if (days > 0) then
				ply:Notify("Your Donator status expires in "..days.." day(s).")
			else
				ply:Notify("Your Donator status expires in "..hours.." hour(s) "..minutes.." minute(s) and "..seconds.." second(s).")
			end

			-- Set some Donator only player variables.
			ply._SpawnTime = self.Config["Spawn Time"] / 2
		--	ply._ArrestTime = self.Config["Arrest Time"] / 2
			ply._KnockOutTime = self.Config["Knock Out Time"] / 2
		else
			ply.cider._Donator = 0

			-- Take away their access and save their data.
			ply:TakeAccess("tpew")
			ply:SaveData();

			-- Notify the player about how their Donator status has expired.
			ply:Notify("Your Donator status has expired!", 1)
		end
	end

	-- Make the player a Citizen to begin with.
	ply:JoinTeam(TEAM_DEFAULT)
	-- Restore access to any entity the player owned that is currently unowned
	cider.entity.restoreAccess(ply)
	--[[
	for _,ent in ipairs(cider.entity.getEntsAccess(player)) do
		cider.entity.accessChangedPlayer(ent,player,true)
	end
	--]]
	GM:Log(EVENT_PUBLICEVENT,"%s finished connecting.",ply:Name())
end

-- Called when a player's data is loaded.
function GM:PlayerDataLoaded(ply, success)
	ply._Salary					= 0;
	ply._JobTimeLimit			= 0;
	ply._JobTimeExpire			= 0;
	ply._LockpickChance			= 0;
	ply._CannotBeWarranted		= 0;
	ply._ScaleDamage			= 1;
	ply._Description				= "";
	ply._NextSpawnGender		= "";
	ply._NextSpawnGenderWord	= "";
	ply._Ammo					= {};
	ply.ragdoll					= {};
	ply._NextUse				= {};
	ply._NextChangeTeam			= {};
	ply._GunCounts				= {};
	ply._StoredWeapons			= {};
	ply._FreshWeapons			= {};
	ply. CSVars					= {}; -- I am aware that this is without a _, but I don't think it looks right with one.
	ply._Tying					= nil;
	ply._Initialized			= true;
	ply._UpdateData				= false;
	ply._Sleeping				= false;
	ply._Stunned				= false;
	ply._Tripped				= false;
	ply._Warranted				= false;
	ply._LightSpawn				= false;
	ply._ChangeTeam				= false;
	ply._beTied					= false;
	ply._HideHealthEffects		= false;
	ply._GenderWord				= "his";
	ply._Gender					= "Male";
	ply._NextOOC				= CurTime();
	ply._NextAdvert				= CurTime();
	ply._NextDeploy				= CurTime();
	-- Some player variables based on configuration.
	ply._SpawnTime				= self.Config["Spawn Time"];
	ply._ArrestTime				= self.Config["Arrest Time"];
	ply._Job					= self.Config["Default Job"];
	ply._KnockOutTime			= self.Config["Knock Out Time"];
	ply._IdleKick				= CurTime() + self.Config["Autokick time"];

	-- Call a hook for the gamemode.
	hook.Call("PlayerInitialized",GAMEMODE, ply)

	ply:SetNWString("RPName", ply.cider._RPName);
	ply:SetNWString("Job", ply._Job);
	ply:SetNWString("Clan", ply.cider._Clan);
	ply:SetNWString("Description",ply.cider._Description);
	ply:SetNetworkedBool("Donator",ply.cider._Donator > 0);
	ply:SetNetworkedBool("Moderator", ply:IsUserGroup("operator") or ply:IsUserGroup("moderator") or (evolve and ply:EV_GetRank() == "moderator") or (citrus and citrus.Player.GetGroup(ply).Name == "Moderators"));


	-- Respawn them now that they have initialized and then freeze them.
	ply:Spawn()
	ply:Freeze(true)
	-- Unfreeze them in a few seconds from now.
	-- TODO: WHY?
	timer.Simple(2, function()
		if ( IsValid(ply) ) then
			-- Check if the player is arrested.
			if (ply.cider._Arrested) then
				ply:Arrest();
			end
			ply:Freeze(false)
			-- We can now start updating the player's data.
			ply._UpdateData = true

			-- Send a user message to remove the loading screen.
			umsg.Start("cider.player.initialized", ply) umsg.End()
		end
	end)
end

-- Called when a player initially spawns.
function GM:PlayerInitialSpawn(ply)
	if ( IsValid(ply) ) then
		ply:LoadData();

		ply._ModelChoices = {}
		for _,team in pairs(cider.team.stored) do
			for gender,models in pairs(team.models) do
				ply._ModelChoices[gender] = ply._ModelChoices[gender] or {}
				if #models ~= 1 then
					ply._ModelChoices[gender][team.index]
						= math.random(1,#models)
				else
					ply._ModelChoices[gender][team.index] = 1
				end
			end
		end
	--	PrintTable(player._ModelChoices)
	--	print(#player._ModelChoices)
		timer.Simple(0.2,function(ply)
--[[			print"------------------"
			print"------------------"
			print("Starting model choices for "..player:Name()..".")
			print"------------------"
			print"------------------"
]]			if IsValid(ply) then
				umsg.Start("cider_ModelChoices",ply)
				umsg.Short(table.Count(ply._ModelChoices))
				for name,gender in pairs(ply._ModelChoices) do
	--				print("name","amount")
	--				print(name,#gender)
					umsg.String(name)
					umsg.Short(#gender)
					for team,choice in ipairs(gender) do
					--	print("team","choice")
					--	print(team,choice)
						umsg.Short(team)
						umsg.Short(choice)
					end
				end
				umsg.End()
				net.Start("cider_Laws")
					net.WriteTable(cider.laws.stored)
				net.Send(ply)
			else
				--ErrorNoHalt"!!!\n"
				--print(player)
			end
		end,ply)
		-- A table to store every contraband entity.
		local contraband = {}

		-- Loop through each contraband class.
		for k, v in pairs( self.Config["Contraband"] ) do
			table.Add( contraband, ents.FindByClass(k) )
		end

		-- Loop through all of the contraband.
		for k, v in pairs(contraband) do
			if (ply:UniqueID() == v._UniqueID) then v:SetPlayer(ply) end
		end

		-- Kill them silently until we've loaded the data.
		ply:KillSilent()
	else
		timer.Simple(0.2,function(ply)
			ply._Timeout = ply._Timeout or 0
			ply._Timeout = ply._Timeout + 1
			if ply._Timeout <= 300 then
				GAMEMODE:PlayerInitialSpawn(ply)
			else
				print("player timeout in PlayerInitialSpawn()")
			end
		end,ply)
	end
end

-- Called every frame that a player is dead.
function GM:PlayerDeathThink(ply)
	if (!ply._Initialized) then return true end

	-- Check if the player is a bot.
	if (ply:SteamID() == "BOT") then
		if (ply.NextSpawnTime and CurTime() >= ply.NextSpawnTime) then ply:Spawn() end
	end

	-- Return the base class function.
	return self.BaseClass:PlayerDeathThink(ply)
end

-- Called when a player's salary should be adjusted.
function GM:PlayerAdjustSalary(ply)
	if (ply.cider._Donator and ply.cider._Donator > 0) then
		ply._Salary = (ply._Salary or 1) * 2
	end
end

-- Called when a player's radio recipients should be adjusted.
function GM:PlayerAdjustRadioRecipients(ply, text, recipients)
end

-- Called when a player attempts to join a gang
function GM:PlayerCanJoinGang(ply,teamID,gangID)
end
-- Called when a player should gain a frag.
function GM:PlayerCanGainFrag(ply, victim) return true end

-- Called when a player's model should be set.
function GM:PlayerSetModel(ply)
	if ply.cider._Misc.custommodel and ply.cider._Misc.custommodel[ply:Team()] then
		ply:SetModel(ply.cider._Misc.custommodel[ply:Team()])
		return true
	end
	local models = cider.team.query(ply:Team(), "models")

	-- Check if the models table exists.
	if (models) then
		models = models[ string.lower(ply._Gender) ]

		-- Check if the models table exists for this gender.
		if (models) then
			local model = models[ ply._ModelChoices[string.lower(ply._Gender)][ply:Team()] ]
		--	print(model,player._ModelChoices[string.lower(player._Gender)][player:Team()])
			-- Set the player's model to the we got.
			ply:SetModel(model)
		end
	end
end

-- Called when a player spawns.
function GM:PlayerSpawn(ply)
	if (ply._Initialized) then
		if (ply._NextSpawnGender ~= "") then
			ply._Gender = ply._NextSpawnGender ply._NextSpawnGender = ""
			ply._GenderWord = ply._NextSpawnGenderWord ply._NextSpawnGenderWord = ""
		end

		-- Set it so that the ply does not drop weapons.
		ply:ShouldDropWeapon(false)

		-- Check if we're not doing a light spawn.
		if (!ply._LightSpawn) then
			ply:Recapacitate();

			-- Set some of the ply's variables.
			-- ply._Ammo = {}
			ply._Sleeping = false
			ply._Stunned = false
			ply._Tripped = false
			ply._ScaleDamage = 1
			ply._HideHealthEffects = false
			ply._CannotBeWarranted = CurTime() + 15
			ply._Deaded = nil

			-- Make the ply become conscious again.
			ply:WakeUp(true);
			--ply:UnSpectate()
			-- Set the ply's model and give them their loadout.
			self:PlayerSetModel(ply)
			self:PlayerLoadout(ply)
		end

		-- Call a gamemode hook for when the ply has finished spawning.
		hook.Call("PostPlayerSpawn",GAMEMODE, ply, ply._LightSpawn, ply._ChangeTeam)

		-- Set some of the ply's variables.
		ply._LightSpawn = false
		ply._ChangeTeam = false
	else
		ply:KillSilent()
	end
end

-- Called when a ply should take damage.
function GM:PlayerShouldTakeDamage(ply, attacker) return true end

-- Called when a ply is attacked by a trace.
function GM:PlayerTraceAttack(ply, damageInfo, direction, trace)
	ply._LastHitGroup = trace.HitGroup

	-- Return false so that we don't override internals.
	return false
end

-- Called just before a ply dies.
function GM:DoPlayerDeath(ply, attacker, damageInfo)
	ply._Deaded = true
	if ply:InVehicle() then
		ply:ExitVehicle()
	end
	if IsValid(ply._BackGun) then
		ply._BackGun:Remove()
	end
	for k, v in pairs( ply:GetWeapons() ) do
		local class = v:GetClass()

		-- Check if this is a valid item.
		if (self.Items[class]) then
			if ( hook.Call("PlayerCanDrop",GAMEMODE, ply, class, true, attacker) ) then
				self.Items[class]:Make(ply:GetPos(), 1);
			end
		end
	end
	if #ply._StoredWeapons >= 1 then
		for _, v in pairs(ply._StoredWeapons) do
			local class = v

			-- Check if this is a valid item.
			if (self.Items[class]) then
				if ( hook.Call("PlayerCanDrop",GAMEMODE, ply, class, true, attacker) ) then
					self.Items[class]:Make(ply:GetPos(), 1);
				end
			end
		end
		ply._StoredWeapons = {}
	end

	-- Unwarrant them, unarrest them and stop them from bleeding.
	if (ply ~= attacker and attacker:IsPlayer()) then
		ply:UnWarrant();
	end
	ply:UnArrest(true);
	ply:UnTie(true);
	ply:StopBleeding()

	-- Strip the ply's weapons and ammo.
	ply:StripWeapons()
	ply:StripAmmo()

	-- Add a death to the ply's death count.
	ply:AddDeaths(1)

	-- Check it the attacker is a valid entity and is a ply.
	if ( IsValid(attacker) and attacker:IsPlayer() ) then
		if (ply ~= attacker) then
			if ( hook.Call("PlayerCanGainFrag",GAMEMODE, attacker, ply) ) then
				attacker:AddFrags(1)
			end
		end
	end
end

-- Called when a ply dies.
function GM:PlayerDeath(ply, inflictor, attacker, ragdoll,fall)

	-- Knock out the ply to simulate their death. (Even if they're allready a ragdoll, we need to handle the multiple raggies.
	ply:KnockOut();

	-- Set their next spawn time.
	ply.NextSpawnTime = CurTime() + ply._SpawnTime

	-- Set it so that we can the next spawn time client side.
	ply:SetCSVar(CLASS_LONG, "_NextSpawnTime", ply.NextSpawnTime)

	-- Check if the attacker is a ply.
	local formattext,text1,text2,text3,pvp = "",ply:GetName(),"",""
	if ( attacker:IsPlayer() ) then
		pvp,text1,text2,formattext = true,attacker:Name(),ply:Name(),"%s killed %s"
		if ( IsValid( attacker:GetActiveWeapon() ) ) then
			formattext,text3 = formattext.." with a %s.",attacker:GetActiveWeapon():GetClass()
		else
			formattext = formattext.."."
		end
	elseif( attacker:IsVehicle() ) then
		local formattext,text1,text2 = "%s was run over by a %s",ply:Name(),attacker:GetClass();
		if attacker.DisplayName then
			text2 = attacker.DisplayName
		elseif attacker.VehicleName then
			text2 = attacker.VehicleName
		end
		if ( IsValid( attacker:GetDriver()) and attacker:GetDriver():IsPlayer()) then
			pvp = true
			formattext,text3 = formattext.." driven by %s",attacker:GetDriver():Name()
		end
	elseif fall then
		formattext = "%s fell to a clumsy death."
	elseif attacker:IsWorld() and ply == inflictor then
		formattext = "%s starved to death."
	elseif attacker:GetClass() == "worldspawn" then
		formattext = "%s was killed by the map."
	elseif attacker:GetClass() == "prop_physics" then
		formattext,text2 = "%s was killed with a physics object. (%s)",attacker:GetModel()
	else
		formattext,text1,text2 = "%s killed %s.",attacker:GetClass(),ply:Name()
	end
	GM:Log(EVENT_DEATH,formattext,text1,text2,text3)
end

local function donttazemebro(class)
	return class:find'cider' or class:find'prop';
end

-- Called when an entity takes damage.
local vector0 = Vector(5,0,0)
function GM:EntityTakeDamage(entity, damageInfo)
	local inflictor = damageInfo:GetInflictor()
	local attacker = damageInfo:GetAttacker()
	local amount = damageInfo:GetDamage()

	if !entity or !inflictor or !attacker or entity == NULL or inflictor == NULL or attacker == NULL then
		ErrorNoHalt("Something went wrong in EntityTakeDamage: "..tostring(entity).." "..tostring(inflictor).." "..tostring(attacker).." "..tostring(amount).."\n")
		return
	end
	--print("OW!",tostring(entity).." "..tostring(inflictor).." "..tostring(attacker).." "..tostring(amount))
	local logme = false
	if (attacker:IsPlayer() and IsValid( attacker:GetActiveWeapon() )) then
		if attacker:GetActiveWeapon():GetClass() == "weapon_stunstick" then
			damageInfo:SetDamage(10)
		elseif attacker:GetActiveWeapon():GetClass() == "weapon_crowbar" then
			if entity:IsPlayer() then
				damageInfo:SetDamage(0)
				return false
			else
				damageInfo:SetDamage(10)
			end
		end
	end
	if (attacker:IsPlayer()	and (attacker:GetMoveType()	== MOVETYPE_NOCLIP or attacker._StuckInWorld))
	or (entity:IsPlayer()	and entity:GetMoveType()	== MOVETYPE_NOCLIP and not entity:InVehicle())
	or (entity:IsPlayer()	and entity._Physgunnin) then
		damageInfo:SetDamage(0)
		return false
	end
	local asplode = false
	local asplodeent = nil
	if inflictor:GetClass() == "npc_tripmine" and IsValid(inflictor._planter) then
		print"Trippy!"
		damageInfo:SetAttacker(inflictor._planter)
		attacker = inflictor._planter
		asplode = true
		asplodeent = "tripmine"
	elseif attacker:GetClass() == "cider_breach" and IsValid(attacker._Planter) then
		damageInfo:SetAttacker(attacker._Planter)
		attacker = attacker._Planter
		asplode = true
		asplodeent = "breach"
	end
	if ( entity:IsPlayer() ) then
		if (entity:KnockedOut()) then
			if ( IsValid(entity.ragdoll.entity) ) then
				hook.Call("EntityTakeDamage",GAMEMODE, entity.ragdoll.entity, inflictor, attacker, damageInfo:GetDamage(), damageInfo)
			end
		else
			-- :/ hacky
			if attacker:IsVehicle() and attacker:GetClass() ~= "prop_vehicle_prisoner_pod" then
				--print(attacker:GetClass())
				entity:KnockOut(10,attacker:GetVelocity());
				damageInfo:SetDamage(0)
				local smitee = entity:GetName()
				local weapon = "."
				local isplayer = false
				local smiter = "an unoccupied "
				if attacker:GetDriver():IsValid() then
					isplayer = true
					smiter = attacker:GetDriver():Name()
					weapon = " in a "
					if attacker.VehicleName then
						weapon = weapon..attacker.VehicleName
					else
						weapon = weapon..attacker:GetClass()
					end
				elseif attacker.VehicleName then
					smiter = smiter..attacker.VehicleName
				else
					smiter = smiter..attacker:GetClass()
				end
				local text = "%s knocked over %s%s"
				if isplayer then
					GM:Log(EVENT_PLAYERDAMAGE,text,smiter,smitee,weapon)
				else
					GM:Log(EVENT_DAMAGE,text,smiter,smitee,weapon)
				end
				return
			end
			if entity:InVehicle() then
				if damageInfo:IsExplosionDamage() and (!damageInfo:GetDamage() or damageInfo:GetDamage() == 0) then
					damageInfo:SetDamage(100)
				end
				if damageInfo:GetDamage()< 1 then
					damageInfo:SetDamage(0)
					return
				end
			end
			if attacker:GetClass():find"cider" or self.Config["Anti propkill"] and not damageInfo:IsFallDamage() and attacker:GetClass():find("prop_physics") then
				damageInfo:SetDamage(0)
				return
			end

			-- Check if the player has a last hit group defined.
			if entity._LastHitGroup and ( not attacker:IsPlayer() or (IsValid(attacker:GetActiveWeapon()) and attacker:GetActiveWeapon():GetClass() ~= "cider_hands")) then
				if (entity._LastHitGroup == HITGROUP_HEAD) then
					damageInfo:ScaleDamage( self.Config["Scale Head Damage"] )
				elseif (entity._LastHitGroup == HITGROUP_CHEST or entity._LastHitGroup == HITGROUP_GENERIC) then
					damageInfo:ScaleDamage( self.Config["Scale Chest Damage"] )
				elseif (
				entity._LastHitGroup == HITGROUP_LEFTARM or
				entity._LastHitGroup == HITGROUP_RIGHTARM or
				entity._LastHitGroup == HITGROUP_LEFTLEG or
				entity._LastHitGroup == HITGROUP_RIGHTLEG or
				entity._LastHitGroup == HITGROUP_GEAR) then
					damageInfo:ScaleDamage( self.Config["Scale Limb Damage"] )
				end

				-- Set the last hit group to nil so that we don't use it again.
				entity._LastHitGroup = nil
			end

			-- Check if the player is supposed to scale damage.
			if (entity._ScaleDamage) then damageInfo:ScaleDamage(entity._ScaleDamage) end
			logme = true
			if entity:InVehicle() then
				entity:SetHealth(entity:Health()-damageInfo:GetDamage()) --Thanks gayry for breaking teh pains in vehicles.
				damageInfo:SetDamage(0) -- stop the engine doing anything odd
				-- Check to see if the player's health is less than 0 and that the player is alive.
				if ( entity:Health() <= 0 and entity:Alive() ) then
					entity:KillSilent()

					-- Call some gamemode hooks to fake the player's death.
					hook.Call("DoPlayerDeath",GAMEMODE, entity, attacker, damageInfo)
					hook.Call("PlayerDeath",GAMEMODE, entity, inflictor, attacker, damageInfo:IsFallDamage())
				end
			end
			-- Make the player bleed.
			entity:Bleed(self.Config["Bleed Time"])
		end
	elseif ( entity:IsNPC() ) then
		if (attacker:IsPlayer() and IsValid( attacker:GetActiveWeapon() )
		and attacker:GetActiveWeapon():GetClass() == "weapon_crowbar") then
			damageInfo:SetDamage(25)
		end
		local smiter = attacker:GetClass()
		local damage = damageInfo:GetDamage()
		local smitee = entity:GetClass()
		local weapon = "."
		local text = "%s damaged a %s for %G damage%s"
		if attacker:IsPlayer() then
			smiter = attacker:GetName()
			if IsValid( attacker:GetActiveWeapon() ) then
				weapon = " with a "..attacker:GetActiveWeapon():GetClass()
			end
		end
		GM:Log(EVENT_DAMAGE,text,smiter,smitee,damage,weapon)
	elseif cider.container.isContainer(entity) and entity:Health() > 0 then
		-- Fookin Boogs.		v
		damageInfo:SetDamageForce(vector0)
		local smiter = attacker:GetClass()
		local damage = damageInfo:GetDamage()
		local smitee = cider.container.getName(entity)
		local weapon = "."
		local text = "%s damaged a %s for %G damage%s"
		if attacker:IsPlayer() then
			smiter = attacker:GetName()
			if IsValid( attacker:GetActiveWeapon() ) then
				weapon = " with a "..attacker:GetActiveWeapon():GetClass()
			end
		end
		print(entity:Health(),damageInfo:GetDamage())
		entity:SetHealth(entity:Health()-damageInfo:GetDamage())
		print(entity:Health())
		if entity:Health() <= 0 then
			text = "%s destroyed a %s with %G damage%s"
			entity:SetHealth(0)
			entity:TakeDamage(1)
		end
		GM:Log(EVENT_DAMAGE,text,smiter,smitee,damage,weapon)
	-- Check if the entity is a knocked out player.
	elseif ( IsValid(entity._Player) and not entity._Corpse) then
		local ply = entity._Player
		-- If they were just ragdolled, give them 2 seconds of damage immunity
		if ply.ragdoll.time and ply.ragdoll.time > CurTime() then
			damageInfo:SetDamage(0)
			return false
		end
		-- Set the damage to the amount we're given.
		damageInfo:SetDamage(amount)

		-- Check if the attacker is not a player.
		if ( !attacker:IsPlayer() ) then
			if attacker ==game.GetWorldEntity() and inflictor == player then --hunger
--				player:SetHealth( math.max(player:Health() - damageInfo:GetDamage()	, 0) )
--				player.ragdoll.health = player:Health()
--				return
			elseif ( attacker == game.GetWorldEntity() ) then
				if ( ( entity._NextWorldDamage and entity._NextWorldDamage > CurTime() )
				or damageInfo:GetDamage() <= 10 ) then return end

				-- Set the next world damage to be 1 second from now.
				entity._NextWorldDamage = CurTime() + 1
			elseif attacker:GetClass():find"cider" or attacker:GetClass():find("prop") then
				damageInfo:SetDamage(0)
				return
			else
				if (damageInfo:GetDamage() <= 25) then return end
			end
		else
			if not damageInfo:IsBulletDamage() then
				damageInfo:SetDamage(0)
				return false
			end
			damageInfo:ScaleDamage( self.Config["Scale Ragdoll Damage"] )
		end

		-- Check if the player is supposed to scale damage.
		if (entity._Player._ScaleDamage and attacker ~= game.GetWorldEntity()) then damageInfo:ScaleDamage(entity._Player._ScaleDamage) end

		-- Take the damage from the player's health.
		ply:SetHealth( math.max(ply:Health() - damageInfo:GetDamage(), 0) )

		-- Set the player's conscious health.
		ply.ragdoll.health = ply:Health()

		-- Create new effect data so that we can create a blood impact at the damage position.
		local effectData = EffectData()
			effectData:SetOrigin( damageInfo:GetDamagePosition() )
		util.Effect("BloodImpact", effectData)

		-- Loop from 1 to 4 so that we can draw some blood decals around the ragdoll.
		for i = 1, 2 do
			local trace = {}

			-- Set some settings and information for the trace.
			trace.start = damageInfo:GetDamagePosition()
			trace.endpos = trace.start + (damageInfo:GetDamageForce() + (VectorRand() * 16) * 128)
			trace.filter = entity

			-- Create the trace line from the set information.
			trace = util.TraceLine(trace)

			-- Draw a blood decal at the hit position.
			util.Decal("Blood", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
		end

		-- Check to see if the player's health is less than 0 and that the player is alive.
		if ( ply:Health() <= 0 and ply:Alive() ) then
			ply:KillSilent()

			-- Call some gamemode hooks to fake the player's death.
			hook.Call("DoPlayerDeath",GAMEMODE, ply, attacker, damageInfo)
			hook.Call("PlayerDeath",GAMEMODE, ply, inflictor, attacker, damageInfo:IsFallDamage())
		end
		entity = ply
		logme = true
	end
	if logme then
		local smiter = attacker:GetClass()
		local damage = damageInfo:GetDamage()
		local smitee = entity:GetName()
		local weapon = "."
		local isplayer = false
		if attacker:IsPlayer() then
			isplayer = true
			smiter = attacker:GetName()
			if asplode then
				weapon = " with a "..asplodeent
			elseif IsValid( attacker:GetActiveWeapon() ) then
				weapon = " with "..attacker:GetActiveWeapon():GetClass()
			end
		elseif attacker:IsVehicle() then
			smiter = "an unoccupied "
			if attacker:GetDriver():IsValid() then
				isplayer = true
				smiter = attacker:GetDriver():Name()
				weapon = " in a "
				if attacker.VehicleName then
					weapon = weapon..attacker.VehicleName
				else
					weapon = weapon..attacker:GetClass()
				end
			elseif attacker.VehicleName then
				smiter = smiter..attacker.VehicleName
			else
				smiter = smiter..attacker:GetClass()
			end
		elseif damageInfo:IsFallDamage() then
			smiter = "The ground"
		elseif attacker:IsWorld() and entity == inflictor then
			smiter = "Hunger"
		elseif smiter == "prop_physics" then
			smiter = "a prop ("..attacker:GetModel()..")"
		end
		local text = "%s damaged %s for %G damage%s"

		if isplayer then
			GM:Log(EVENT_PLAYERDAMAGE,text,smiter,smitee,damage,weapon)
		else
			GM:Log(EVENT_DAMAGE,text,smiter,smitee,damage,weapon)
		end
	end
end
-- Return the damage done by a fall
function GM:GetFallDamage( ply, vel )
	local val = 580  --No idea. This was taken from the C++ source though, aparently
	return (vel-val)*(100/(1024-val))
end


-- Called when a player's weapons should be given.
function GM:PlayerLoadout(ply)
	--if ( ply:HasAccess("t") ) then ply:Give("gmod_tool") end
	--if ( ply:HasAccess("p") ) then ply:Give("weapon_physgun") end


	-- Give the player the camera, the hands and the physics cannon.
	ply:Give("gmod_camera")
	ply:Give("cider_hands")
	ply:Give("gmod_tool")
	ply:Give("weapon_physgun")
	ply._SpawnWeapons = {}
	ply._GunCounts = {}
	if ply:Team() and ply:Team() > 0 then
		local team = cider.team.get(ply:Team())
		if team.guns then
			for _,gun in ipairs(team.guns) do
				local give = true
				local item = self.Items[gun]
				if item then
					if item.Category then
						if ply:Blacklisted("cat",item.Category) > 0 then
							give = false
						end
					end
					if give then
						ply._SpawnWeapons[gun] = true
					end
				end
				if give then
					ply:Give(gun)
				end
			end
		end
		if team.ammo then
			for _,ammo in ipairs(team.ammo) do
				ply:GiveAmmo(ammo[2],ammo[1])
			end
		end
	else
		ErrorNoHalt("no team?!?! "..tostring(ply).." - "..tostring(ply:Team()).."\n")
	end

	-- Select the hands by default.
	ply:SelectWeapon("cider_hands")
end

-- Called when the server shuts down or the map changes.
function GM:ShutDown()
	ErrorNoHalt"----------------------\n"
	ErrorNoHalt(os.date().." - Server shutting down\n")
	ErrorNoHalt"----------------------\n"
end

-- Called when a player presses F1.
function GM:ShowHelp(ply) umsg.Start("cider_Menu", ply) umsg.End() end

-- Called when a player presses F2.
function GM:ShowTeam(ply)
	local door = ply:GetEyeTraceNoCursor().Entity
	-- Check if the player is aiming at a door.
	if not(IsValid(door)
	   and cider.entity.isOwnable(door)
	   and ply:GetPos():Distance( ply:GetEyeTraceNoCursor().HitPos ) <= 128
	 ) then
			return
	end
	if hook.Call("PlayerCanOwnDoor",GAMEMODE,ply,door) then
		umsg.Start("cider_BuyDoor",ply)
		umsg.End()
		return
	end
	if not hook.Call("PlayerCanViewEnt",GAMEMODE,ply,door) then
		ply:Notify("You do not have access to that!",1)
		return
	end
	local detailstable = {}
	local owner = cider.entity.getOwner(door)
	detailstable.access = table.Copy(door._Owner.access)
	table.insert(detailstable.access,owner)
	if owner == ply then
		detailstable.owned = {
			sellable = tobool(door._isDoor and not door._Unsellable) or nil,
			name = hook.Call("PlayerCanSetEntName",GAMEMODE,ply,door) and cider.entity.getName(door) or nil,
		}
	end
	detailstable.owner = cider.entity.getPossessiveName(door)
	if door._isDoor then
		detailstable.owner = detailstable.owner.." door"
	else
		detailstable.owner = detailstable.owner.." "..door:GetNWString("cider_Name","entity")
	end
	net.Start("cider_Access")
		net.WriteTable(detailstable)
	net.Send(ply)
end

function GM:ShowSpare1(ply)
-- ):
end

-- Called when a ply attempts to spawn a SWEP.
function GM:PlayerSpawnSWEP(ply, class, weapon)
	if ply:IsSuperAdmin() then
		GM:Log(EVENT_SUPEREVENT,"%s spawned a %s",ply:Name(),class)
		return true
	else
		return false
	end
end

-- Called when a player is given a SWEP.
function GM:PlayerGiveSWEP(ply, class, weapon)
	if ply:IsSuperAdmin() then
		GM:Log(EVENT_SUPEREVENT,"%s gave themselves a %s",ply:Name(),class)
		return true
	else
		return false
	end
end

-- Called when attempts to spawn a SENT.
function GM:PlayerSpawnSENT(ply, class)
	if ply:IsSuperAdmin() then
		GM:Log(EVENT_SUPEREVENT,"%s spawned a %s",ply:Name(),class)
		return true
	else
		return false
	end
end



local timenow = CurTime()
timer.Create("Timer Checker.t",1,0,function()
	timenow = CurTime()
end)
hook.Add("Think","Timer Checker.h",function()
	if timenow < CurTime() - 3 then
		GM:Log(EVENT_ERROR,"Timers have stopped running!")
		player.NotifyAll("Timers have stopped running! Oh shi-",1)
		hook.Remove("Think","Timer Checker.h")
	end
end)

-- Create a timer to automatically clean up decals.
timer.Create("Cleanup Decals", 60, 0, function()
	if ( GM.Config["Cleanup Decals"] ) then
		for k, v in pairs( player.GetAll() ) do v:ConCommand("r_cleardecals\n") end
	end
end)


-- Create a timer to give players money for their contraband.
timer.Create("Earning", GM.Config["Earning Interval"], 0, function()
	local contratypes = {}
	for key in pairs(GM.Config["Contraband"]) do
		contratypes[key] = true
	end
	local cplayers = {}
	local dplayers = {}


	for _, ent in ipairs(ents.GetAll()) do
		if contratypes[ent:GetClass()] then
			local ply = ent:GetPlayer();
			-- Check if the ply is a valid entity,
			if ( IsValid(ply) ) then
				cplayers[ply] = cplayers[ply] or {refill = 0, money = 0}

				-- Decrease the energy of the contraband.
				ent.dt.energy = math.Clamp(ent.dt.energy - 1, 0, 5)

				-- Check the energy of the contraband.
				if (ent.dt.energy == 0) then
					cplayers[ply].refill = cplayers[ply].refill + 1
				else
					cplayers[ply].money = cplayers[ply].money + GM.Config["Contraband"][ ent:GetClass() ].money
				end
			end
		elseif cider.entity.isDoor(ent) and cider.entity.isOwned(ent) then
			local o = cider.entity.getOwner(ent)
			if type(o) == "Player" and IsValid(o) then
				dplayers[o] = dplayers[o] or { 0, {} }
				-- Increase the amount of tax this player must pay.
				dplayers[o][1] = dplayers[o][1] + GM.Config["Door Tax Amount"]
				-- Insert the door into the player's door table.
				table.insert(dplayers[o][2], ent)
			end
		end
	end
	-- Loop through our players list.
	for k, v in pairs(cplayers) do
		if ( IsValid(k) and k:IsPlayer() and hook.Call("PlayerCanEarnContraband",GAMEMODE, k) ) then
			if (v.refill > 0) then
				k:Notify(v.refill.." of your contraband need refilling!", 1)
			end
			if (v.money > 0) then
				k:Notify("You earned $"..v.money.." from contraband.", 0)

				-- Give the player their money.
				k:GiveMoney(v.money)
			end
		end
	end
	for _,ply in ipairs(player.GetAll()) do
		if (ply:Alive() and !ply.cider._Arrested) then
			ply:GiveMoney(ply._Salary)

			-- Print a message to the player letting them know they received their salary.
			ply:Notify("You received $"..ply._Salary.." salary.", 0)
		end
	end
	if ( GM.Config["Door Tax"] ) then
		-- Loop through our players list.
		for k, v in pairs(dplayers) do
			if ( k:CanAfford(v[1] ) ) then
				k:Notify("You have been taxed $"..v[1].." for your doors.", 0)
			else
				k:Notify("You can't pay your taxes. Your doors were removed.", 1)

				-- Loop through the doors.
				for k2, v2 in pairs( v[2] ) do
					if v2._Removeable then
						v2:Remove()
					else
						k:TakeDoor(v2, true)
					end
				end
			end

			-- Take the money from the player.
			k:GiveMoney(-v[1] )
		end
	end
	player.SaveAll()
end)
concommand.Add( "wire_keyboard_press", function(p,c,a) return end )

--[[
local servertags = GetConVarString("sv_tags")
if servertags == nil then
	servertags = ""
end
for _,tag in ipairs(GM.Config["sv_tags"]) do
	if not string.find(servertags, tag, 1, true) then
		servertags = servertags..","..tag
	end
end
RunConsoleCommand("sv_tags", servertags )
]]--