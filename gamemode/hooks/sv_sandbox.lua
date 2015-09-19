--[[
	~ Sandbox Hooks (SV) ~
	~ Applejack ~
--]]
--[[
	This file is for the base gamemodes' hooks.
	As such, there is no need to document them as they are all standard.
--]]
local function vt(p)
	if (IsValid(p)) then
		p:SetCollisionGroup(COLLISION_GROUP_PLAYER);
	end
end
-- TODO: Is this strictly necessary?
function GM:PlayerEnteredVehicle(ply, vehicle, role)
	timer.Simple(FrameTime() * 2, function()
		vt(ply);
	end)
end

function GM:PlayerSwitchFlashlight(ply, on)
	-- Do not let the player use their flashlight while arrested, unconsious or tied.
	return not (ply:Arrested() or ply:KnockedOut() or ply:Tied());
end

-- Called when the player presses their use key (normally e) on a usable entity.
-- What specifies that an entity is usable is so far unknown, for instance some physics props are usable and others are not.
-- This hook is called once per tick while the player holds the use key down on some entities. Keep this in mind if you are going to notify them of something.
function GM:PlayerUse(ply, ent)
	if (ply:KnockedOut()) then
		-- If you're unconsious, you can't use things.
		return false
	elseif (ply:Arrested() or ply:Tied() or ply._Stunned) then
		-- Prevent spam
		if (not ply._NextNotify or CurTime() > ply._NextNotify) then
			ply:Notify("You cannot use that while in this state!", 1);
			ply._NextNotify = CurTime() + 1;
		end
		-- If you're arrested, tied, or stunned you can't use things. (no hands!)
		return false;
	elseif (cider.entity.isDoor(ent) and not gamemode.Call("PlayerCanUseDoor", ply, ent)) then
		-- If the hook says you can't open the door then don't let you. (Prevents doors that should be locked from glitching open)
		return false;
	end
	-- Let sandbox/base deal with everything else~
	return self.BaseClass:PlayerUse(ply, ent);
end

function GM:PlayerCanJoinTeam(ply, teamid)
	local teamdata = cider.team.get(teamid);
	if (not teamdata) then
		return false; -- If it's not a valid team (by our standards) then don't join it.
	end
	teamid = teamdata.index;
	-- Run a series of checks
	if ((ply._NextChangeTeam[teamid] or 0) > CurTime()) then
		ply:Notify("You must wait " .. string.ToMinutesSeconds(ply._NextChangeTeam[teamid] - CurTime()) .. " before you can become a " .. teamdata.name .. "!", 1);
		return false;
	elseif (ply:Warranted()) then
		ply:Notify("You cannot change teams while warranted!", 1);
		return false;
	elseif (ply:Arrested()) then
		ply:Notify("You cannot change teams while arrested!", 1);
		return false;
	elseif (ply:Tied()) then
		ply:Notify("You cannot change teams while tied up!", 1);
		return false
	elseif (not gamemode.Call("PlayerCanDoSomething", ply, true)) then
		return false;
	end
	-- Ask the shared hook which handles the complex gang related tings.
	return self:PlayerCanJoinTeamShared(ply, teamid);
end

function GM:PlayerDisconnected(ply)
	GM:Log(EVENT_PUBLICEVENT, "%s (%s) disconnected.", ply:Name(), ply:SteamID())
	cider.entity.saveAccess(ply)
	ply:HolsterAll()
	-- Get rid of any inconvenient ragdolls
	ply:WakeUp(true)
	ply:SaveData()
	-- Call the base class function.
	self.BaseClass:PlayerDisconnected(ply)
end

-- Called when a player says something.
-- TODO: Move to command library
function GM:PlayerSay(ply, text, public)
	if string.find(text,"@@@@") then
		RunConsoleCommand("kickid", ply:UserID(), "Spam")
	end
	--print(ply, text,text:sub(-7), public)
	-- This is a terrible solution. OH WELL LOL
	if (text:sub(-7) == '" "0.00') then
		text = text:sub(1,-8);
		--print(text);
	end
	-- Fix Valve's errors. DODO: srsly?
	text = text:gsub(" ' ", "'"):gsub(" : ", ":");

	-- The OOC commands have shortcuts.
	if (text:sub(1,2) == "//") then
		text = text:sub(3):Trim();
		if (text == "") then
			return "";
		end
		text = self.Config['Command Prefix'] .. "ooc " .. text;
	elseif (text:sub(1,3) == ".//") then
		text = text:sub(4):Trim();
		if (text == "") then
			return "";
		end
		text = self.Config['Command Prefix'] .. "looc " .. text;
	end
	if ( string.sub(text, 1, 1) == self.Config["Command Prefix"] ) then
		--TODO: Rewrite with gmatch chunks
		text = text:sub(2)
		local args = string.Explode(" ", text)
		local j,tab,quote = 1,{},false
		for i = 1,#args do
			local text = args[i]
			if quote then
				tab[j] = tab[j] .. " "
			else
				if text:sub(1,1) == '"' then
					quote = true
					text = text:sub(2)
				end
				tab[j] = ""
			end
			if text:sub(-1) == '"' then
				quote = false
				text = text:sub(1,-2)
			end
			tab[j] = tab[j] .. text
			if not quote then
				j = j + 1
			end
		end
		cider.command.consoleCommand(ply,_,tab)
	else
		if ( gamemode.Call("PlayerCanSayIC", ply, text) ) then
			if (ply:Arrested()) then
				cider.chatBox.addInRadius(ply, "arrested", text, ply:GetPos(), self.Config["Talk Radius"])
			elseif ply:Tied() then
				cider.chatBox.addInRadius(ply, "tied", text, ply:GetPos(), self.Config["Talk Radius"])
			else
				cider.chatBox.addInRadius(ply, "ic", text, ply:GetPos(), self.Config["Talk Radius"])
			end
			GM:Log(EVENT_TALKING,"%s: %s",ply:Name(),text)
		end
	end
	-- Return an empty string so the text doesn't show.
	return ""
end

-- Called when a player attempts suicide.
function GM:CanPlayerSuicide(ply)
	return false;
end

local function utwin(ply, ent)
	if (IsValid(ply)) then
		ply:Emote("somehow manages to cut through the rope and puts " .. ply._GenderWord .. " knife away, job done.");
		ply._Untying = false;
	end if (IsValid(ent)) then
		ent:Emote("shakes the remains of the rope from " .. ent._GenderWord .. " wrists and rubs them");
		ent:UnTie();
		ent._beUnTied = false;
	end
	gamemode.Call("PlayerUnTied", ply, ent);
end

local function utfail(ply, ent)
	if (IsValid(ent) and ent:Alive()) then
		ent:Emote("manages to dislodge " .. ply:Name() .. "'s attempts.");
		ent._beUnTied = false;
	end if (IsValid(ply) and ply:Alive()) then
		ply:Emote("swears and gives up.");
		ply._UnTying = false;
	end
end

local function uttest(ply, ent, ppos, epos)
	return IsValid(ply) and ply:Alive() and ply:GetPos() == ppos and IsValid(ent) and ent:Alive() and ent:GetPos() == epos;
end

-- Called when a player presses a key.
function GM:KeyPress(ply, key)
	ply._IdleKick = CurTime() + self.Config["Autokick time"]
	if (key == IN_JUMP) then
		if( ply._StuckInWorld) then
			ply:HolsterAll()
			-- Spawn them lightly now that we holstered their weapons.
			local health = ply:Health()
			ply:LightSpawn();
			ply:SetHealth(health) -- Stop people abusing map glitches
		elseif( ply:KnockedOut() and (ply._KnockoutPeriod or 0) <= CurTime() and ply:Alive()) then
			ply:WakeUp();
		end
	elseif (key == IN_USE) then
		-- Grab what's infront of us.
		local ent = ply:GetEyeTraceNoCursor().Entity
		if (not IsValid(ent)) then
			return;
		elseif (IsValid(ent._Player)) then
			ent = ent._Player;
		end
		if (ent:IsPlayer()
		and ply:KeyDown(IN_SPEED)
		and gamemode.Call("PlayerCanUntie", ply, ent)
		and ent:GetPos():Distance(ply:GetPos()) < 200) then
			ply:Emote("starts ineffectually sawing at " .. ent:Name() .. "'s bonds with a butter knife");
			timer.Conditional(ply:UniqueID() .. " untying timer", self.Config['UnTying Timeout'], uttest, utwin, utfail, ply, ent, ply:GetPos(), ent:GetPos());
			ply._UnTying = true;
			ent._beUnTied = true;
		--[[~ Open mah doors ~]]--
		elseif cider.entity.isDoor(ent) and ent:GetClass() ~= "prop_door_rotating" and gamemode.Call("PlayerCanUseDoor", ply, ent) then
			cider.entity.openDoor(ent,0);
		--[[~ Crank dem Containers Boi ~]]--
		elseif cider.container.isContainer(ent) and gamemode.Call("PlayerCanUseContainer", ply, ent) then
			--[[
				tab = {
					contents = {
						cider_usp45 = 2,
						chinese_takeout = 4,
						money = 20000, -- Money is now an item for containers, so put the player's money in the inventory window. (It's not in there by default)
						boxed_pocket = 5
					},
					meta = {
						io = 3, -- READ_ONLY = 0, TAKE_ONLY = 1, PUT_ONLY = 2, TAKE_PUT = 3
						filter = {money,weapon_crowbar}, -- Only these can be put in here, if nil then ignore, but empty means nothing.
						size = 40, -- Max space for the container
						entindex = 64, -- You'll probably want it for something
					}
				}
			--]]
			local contents, io, filter = cider.container.getContents(ent, ply, true);
			local tab = {
				contents = contents,
				meta = {
					io = io,
					filter = filter, -- Only these can be put in here, if nil then ignore, but empty means nothing.
					size = cider.container.getLimit(ent), -- Max space for the container
					entindex = ent:EntIndex(), -- You'll probably want it for something
					name = cider.container.getName(ent) or "Container"
				}
			}
			net.Start("cider_Container")
				net.WriteTable(tab)
			net.Send(ply)
		end
	end
end

function GM:SetPlayerSpeed(ply)
	if (ply:GetNWBool("Incapacitated") or not ply:Recapacitate()) then
		ply:Incapacitate();
	end
end