--[[
Name: "cl_init.lua".
	~ Applejack ~
--]]

include("sh_init.lua");
include("scoreboard/scoreboard.lua");

-- Set some information for the gamemode.
GM.topTextGradient = {};
GM.variableQueue = {};
GM.moneyAlerts = {};
GM.ammoCount = {};
--Take some shit out of _G for speed
local	ents, player, pairs, ipairs, draw, math, string, CurTime, ErrorNoHalt, Color, hook, ScrW, ScrH, tonumber, util =
		ents, player, pairs, ipairs, draw, math, string, CurTime, ErrorNoHalt, Color, hook, ScrW, ScrH, tonumber, util
-- Define a fuckton of colours for efficient GC
--Solid Colours
color_green =			Color(050, 255, 050, 255)
color_red =				Color(255, 050, 050, 255)
color_orange =			Color(255, 125, 000, 255)
color_brightgreen =		Color(125, 255, 050, 255)
color_purpleblue =		Color(125, 050, 255, 255)
color_purple = 			Color(150, 075, 200, 255)
color_lightblue =		Color(075, 150, 255, 255)
color_pink =			Color(255, 075, 150, 255)
color_darkgray =		Color(025, 025, 025, 255)
color_lightgray =		Color(150, 150, 150, 255)
color_yellow =			Color(250, 230, 070, 255)
--Alpha'd
color_red_alpha =		Color(255, 050, 050, 200)
color_orange_alpha =	Color(240, 190, 060, 200)
color_lightblue_alpha =	Color(100, 100, 255, 200)
color_darkgray_alpha =	Color(025, 025, 025, 150)
color_black_alpha =		Color(000, 000, 000, 200)
local lpl = 			LocalPlayer()
local startupmenu = 	CreateClientConVar("cider_startupmenu", "1", true)
local debugshix = 		CreateClientConVar("cider_spammeplz", "1", true)


-- Add a usermessage to recieve a money alert.
usermessage.Hook("MoneyAlert", function(msg)
	local alert, amount;
	alert = {
		add = 1,
		alpha = 255,
	};
	amount = msg:ReadLong();

	if (amount < 0) then
		alert.color = color_red;
		alert.text = string.Comma(tostring(amount));
	else
		alert.color = color_green;
		alert.text = "+"..amount;
	end
	table.insert(GAMEMODE.moneyAlerts, alert);
end);

-- Add a usermessage to recieve a notification.
usermessage.Hook("Notification", function(msg)
	local message = msg:ReadString();
	local class = msg:ReadChar();
	if message == "" then return end
	-- The sound of the notification.
	local sound = "ambient/water/drip2.wav"; -- 'drip' generic notification

	-- Check the class of the message.
	if (class == 1) then
		sound = "buttons/button10.wav"; -- 'failure' buzzer
	elseif (class == 2) then
		sound = "buttons/button17.wav"; -- 'bip' notification
	elseif (class == 3) then
		sound = "buttons/bell1.wav"; 	-- 'bing' hint notification
	elseif (class == 4) then
		sound = "buttons/button15.wav"; -- 'tic' undo notification
	end

	-- Play the sound to the local player.
	surface.PlaySound(sound);

	-- Add the notification using Garry's system.
	GAMEMODE:AddNotify(message, class, 10);
	LocalPlayer():PrintMessage(HUD_PRINTCONSOLE, message);
end);

function GM:PlayerNoClip(player)
	return player:IsAdmin()
end

function GM:OnAchievementAchieved( ply, achid )
	cider.chatBox.chatText(ply:EntIndex(), ply:Name(), achievements.GetName( achid ), "achievement");
end

-- Override the weapon pickup function.
function GM:HUDWeaponPickedUp(...) end

-- Override the item pickup function.
function GM:HUDItemPickedUp(...) end

-- Override the ammo pickup function.
function GM:HUDAmmoPickedUp(...) end

-- Called when all of the map entities have been initialized.
function GM:InitPostEntity()
	timer.Simple(0, function()
		hook.Call("LoadData",self); -- Tell plugins to load their datas a frame after this.
	end)
	self.Inited = true;
	-- Call the base class function.
	return self.BaseClass:InitPostEntity()
end

-- ????????????
function GM:ForceDermaSkin()
end

-- Called when an entity is created.
function GM:OnEntityCreated(entity)
	if (lpl == entity) then
		for k, v in pairs(self.variableQueue) do lpl[k] = v; end
	end

	-- Call the base class function.
	return self.BaseClass:OnEntityCreated(entity);
end

-- Called when a player presses a bind.
function GM:PlayerBindPress(player, bind, press)
	if ( !self.playerInitialized and string.find(bind, "+jump") ) then
		RunConsoleCommand("retry");
	end
	-- Call the base class function.
	return self.BaseClass:PlayerBindPress(player, bind, press);
end

-- Check if the local player is using the camera.
function GM:IsUsingCamera()
	if (IsValid( lpl:GetActiveWeapon() )
	and lpl:GetActiveWeapon():GetClass() == "gmod_camera") then
		return true;
	else
		return false;
	end
end

-- Hook into when the server sends us a variable for the local player.
usermessage.Hook("CSVar", function(message)
	local class = message:ReadChar();
	local key = message:ReadString();

	-- Create the variable which we'll store our received variable in.
	local variable = nil;

	-- Check if we can get what class of variable it is.
	if (class == CLASS_STRING) then
		variable = message:ReadString();
	elseif (class == CLASS_LONG) then
		variable = message:ReadLong();
	elseif (class == CLASS_SHORT) then
		variable = message:ReadShort();
	elseif (class == CLASS_BOOL) then
		variable = message:ReadBool();
	elseif (class == CLASS_VECTOR) then
		variable = message:ReadVector();
	elseif (class == CLASS_ENTITY) then
		variable = message:ReadEntity();
	elseif (class == CLASS_ANGLE) then
		variable = message:ReadAngle();
	elseif (class == CLASS_CHAR) then
		variable = message:ReadChar();
	elseif (class == CLASS_FLOAT) then
		variable = message:ReadFloat();
	end

	-- Check if the local player is a valid entity.
	if ( IsValid( lpl ) ) then
		lpl[key] = variable;

		-- Set the variable queue variable to nil so that we don't overwrite it later on.
		GAMEMODE.variableQueue[key] = nil;
	else
		GAMEMODE.variableQueue[key] = variable;
	end
end);

-- A function to override whether a HUD element should draw.
function GM:HUDShouldDraw(name)
	if (!self.playerInitialized) then
		if (name ~= "CHudGMod") then return false; end
	elseif (name == "CHudHealth" or name == "CHudBattery" or name == "CHudSuitPower"
		or  name == "CHudAmmo" or name == "CHudSecondaryAmmo") then
			return false;
		end

	-- Call the base class function.
	return self.BaseClass:HUDShouldDraw(name);
end

-- A function to adjust the width of something by making it slightly more than the width of a text.
function GM:AdjustMaximumWidth(font, text, width, addition, extra)
	surface.SetFont(font);

	-- Get the width of the text.
	local textWidth = surface.GetTextSize( tostring( string.gsub(text, "&", "U") ) ) + (extra or 0);

	-- Check if the width of the text is greater than our current width.
	if (textWidth > width) then width = textWidth + (addition or 0); end

	-- Return the new width.
	return width;
end

-- A function to draw a bar with a maximum and a variable.
function GM:DrawBar(font, x, y, width, height, color, text, maximum, variable, bar)
	draw.RoundedBox( 2, x, y, width, height, color_black_alpha );
	draw.RoundedBox( 0, x + 2, y + 2, width - 4, height - 4, color_darkgray_alpha );
	draw.RoundedBox( 0, x + 2, y + 2, math.Clamp( ( (width - 4) / maximum ) * variable, 0, width - 4 ), height - 4, color );

	-- Set the font of the text to this one.
	surface.SetFont(font);

	-- Adjust the x and y positions so that they don't screw up.
	x = math.floor( x + (width / 2) );
	y = math.floor(y + 1);

	-- Draw text on the bar.
	draw.DrawText(text, font, x + 1, y + 1, color_black, 1);
	draw.DrawText(text, font, x, y, color_white, 1);

	-- Check if a bar table was specified.
	if (bar) then bar.y = bar.y - (height + 4); end
end

-- Get the bouncing position of the screen's center.
function GM:GetScreenCenterBounce(bounce)
	return ScrW() / 2, (ScrH() / 2) + 32 + ( math.sin( CurTime() ) * (bounce or 8) );
end

--[
-- Give the player a first-person view of their corpse
local pingpong = CurTime()
function GM:CalcView( pl, origin, angles, fov )
	-- Get their ragdoll
	local ragdoll = lpl:GetNetworkedEntity("Ragdoll")
	if pingpong <= CurTime() then
		pingpong = CurTime() + 5
		--print(ragdoll,pl)
	end
	-- Check if it's valid
	if( !IsValid(ragdoll) ) then
		return self.BaseClass:CalcView(pl,origin,angles,fov)
	end
	--find the eyes
	local eyes = ragdoll:GetAttachment( ragdoll:LookupAttachment( "eyes" ) );
	-- setup our view
	if !eyes then
		return self.BaseClass:CalcView(pl,origin,angles,fov)
	end
	local view = {
		origin = eyes.Pos,
		angles = eyes.Ang,
		fov = 90,
	};
	return view;
end
--]]
function GM:HUDDrawTargetID()
     return false
end
function GM:AdjustPosForStupidEnts(ent,pos)
	if ent:IsPlayer() then
		if ent:InVehicle() then
			pos.z = pos.z + 32
		else
			pos.z = pos.z + 55
		end
	elseif ent:GetClass() == "prop_vehicle_jeep" then
		pos = pos + ent:GetUp() * 32
	end
	return pos
end
-- Called when shit should be drawn.
local ESPLines = {lines = {}}
ESPLines.__index = ESPLines
function ESPLines:New()
	local ret = {lines = {}}
	setmetatable(ret,self)
	--ret.__index = self
	return ret
end
function ESPLines:Add(lineID,lineText,lineColour,lineWeight)
	if not(lineID and lineText and lineColour and lineWeight) then
		error("Incorrectly formatted line added!",2)
	elseif lineWeight < 1 then
		error("lineWeight cannot be lower than 1!",2)
	end
	self.lines[lineID] = { text = lineText, color = lineColour, weight = lineWeight}
end
function ESPLines:Remove(lineID)
	self.lines[lineID] = nil
end
function ESPLines:Get(lineID)
	return self.lines[lineID]
end
function ESPLines:AdjustWeight(lineID,lineWeight)
	self.lines[lineID].weight = lineWeight
end
function ESPLines:ShiftWeightDown(amount,threshhold)
	if amount <= 0 then
		error("Don't do this.",2)
	end
	for id,line in pairs(self.lines) do
		if line.weight > threshhold then
			line.weight = line.weight + amount
		end
	end
end
function ESPLines:GetAll()
	local weightadd = 0
	local weighted = {}
	for id,line in pairs(self.lines) do
		if weighted[line.weight] then
			weightadd = weightadd + 1
		end
		weighted[line.weight+weightadd] = {text = line.text, color = line.color}
	end
	return weighted
end
local vehiclelist = {}
function GM:Tick()
	vehiclelist = {}
	for _,v in ipairs(ents.GetAll()) do
		if v:IsVehicle() then
			table.insert(vehiclelist,v)
		end
	end
end
function GM:HUDPaintESP()
	--Comments added due to request. Some things are fairly obvious, but it'd be nice if Garry did this with his stuff ¬_¬
	if ( lpl:Alive() and not lpl._Sleeping ) then  --I hope this is obvious
		local trace = lpl:GetEyeTrace() -- Send a trace down the center of the player's screen to see what they're looking at
		local ent -- Set up an empty variable
		if trace.Hit and not trace.HitWorld then -- if they're looking at something and it isn't the map
			ent = trace.Entity -- Set the variable we just made to the thing they're looking at
		end
		local fadeDistance = self.Config["Talk Radius"] * 2; -- Set the distance that text will be completely faded to twice the talk radius
		for _,tent in ipairs(ents.GetAll() ) do -- Go through every entity on the map (props, players, items etc)
			if (tent:IsValid()) then -- WHAT THE FUCK GARRY, WHAT HTE FUCK
			-- We are now in a loop, and there is only one entity handled at a time.
			local class = tent:GetClass() -- Get the entity's class (like prop_physics)
			local pos = tent:GetPos(); -- Get the entities position in the world
			pos = self:AdjustPosForStupidEnts(tent,pos) -- Some entities like players and cars act weird. This function fixes it
			local screenpos = pos:ToScreen() -- Translate the world position into a screen X,Y position
			local dist = pos:Distance(lpl:GetPos()) -- Caclulate the distance we are away from the entity for quicker usage later
			if screenpos.visible and (dist <= fadeDistance or self:IsUsingCamera()) then -- Check if the screen X,Y position is on the screen (we don't want to draw it if it's not) and that the entity isn't too far away, or if the player is using the camera.
				local tr,lookingat = {} -- Set up a table in tr for the next trace, and set up an empty (and therefor false) variable called lookingat
				if ent == tent then -- If we're looking at the entity, we want the old behavior
					screenpos.x,screenpos.y = self:GetScreenCenterBounce(); -- Get the bouncing up and down text
					lookingat = true -- Tell the rest of the stuff we're looking at something
				elseif tent == lpl and EyePos() == lpl:EyePos() then -- Else, check if the entity is us, and if we're looking from the same place as it is (ie not in any kind of thirdperson)
					tr.Hit = true -- Make it look like a trace was here that hit something
					tr.HitWorld = true -- Say that it hit the world (which means it isn't drawn)
				else -- Otherwise
					tr = { --Set up the trace intial table
						start  = EyePos(), -- Run the trace from where the player is looking from. This can be the 'thirdperson' cheat, or a camera or in a car. This lets you see your own details
						endpos = pos, -- End at the position of the entity we want
						filter = lpl, -- Make sure it doesn't hit us on the way there
						mask   = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER -- This hitmask lets it go through windows but not anything else ;D
					}
					tr.filter = table.Add({tr.filter},vehiclelist) -- make sure players are visable in cars
					tr = util.TraceLine(tr) -- Run the trace and get some results
				end
				-- Calculate the alpha from the distance. (Used a lot later)
				local alpha = math.Clamp(255 - ( (255 / fadeDistance) * ( dist ) ), 0, 255);
				-- Get the x and y position.
				local x, y = screenpos.x, screenpos.y --Also used a lot later.
				if lookingat or not (tr.Hit and (tr.HitWorld or tr.Entity ~= tent)) then--If we are looking at something, or if the trace a) didn't hit anything, b) hit something that wasn't the world and wasn't another entity then...
					local lines = ESPLines:New()
					-- Check if the entity is a player.
					if (tent:GetColor() ~= 0 and tent:IsPlayer() and tent:Alive() and not IsValid(tent:GetNWEntity("Ragdoll")))
					or (IsValid( tent:GetNetworkedEntity("Player")) and tent:GetNetworkedEntity("Player") ~= lpl) then
						local player = tent
						if IsValid( tent:GetNetworkedEntity("Player") ) then
							player = tent:GetNetworkedEntity("Player");
						end
						-- Draw the player's name.
						local addon = ""
						if tent:GetNWBool("cider_Corpse") then
							addon = "'s corpse"
						elseif !player:Alive() then
							addon = " (dead)"
						end
						lines:Add("Name",player:Name()..addon,team.GetColor( player:Team() ),1)
						local statuslines = 0
						if player:GetNetworkedBool("Arrested") then
							lines:Add("Status"..statuslines,"(Arrested)",color_red,2+statuslines)
							statuslines = statuslines + 1
						elseif player:GetNetworkedBool("Tied") then
							lines:Add("Status"..statuslines,"(Tied)",color_lightblue,2+statuslines)
							statuslines = statuslines + 1
							lines:Add("Status"..statuslines,"Press 'use' + 'sprint' to untie",color_white,2+statuslines)
							statuslines = statuslines + 1
						end
						if (player:GetNetworkedString("Warrant") ~= "") then
							-- Check the class of the warrant.
							if (player:GetNetworkedString("Warrant") == "search") then
								lines:Add("Status"..statuslines,"(Search Warrant)",color_lightblue,2+statuslines)
							elseif (player:GetNetworkedString("Warrant") == "arrest") then
								lines:Add("Status"..statuslines,"(Arrest Warrant)",color_red,2+statuslines)
							end
							statuslines = statuslines + 1
						end
						-- Check if they have details set
						if player:GetNetworkedString("Details") ~= "" then
							lines:Add("Status"..statuslines,"Details: "..player:GetNetworkedString("Details"),color_white,2+statuslines)
							statuslines = statuslines + 1
						end
						if lookingat then
							-- Check if the player is in a clan.
							if (player:GetNetworkedString("Clan") ~= "") then
								lines:Add("Status"..statuslines,"Clan: "..player:GetNetworkedString("Clan"),color_white,2+statuslines)
								statuslines = statuslines + 1
							end

							-- Draw the player's job.
							lines:Add("Status"..statuslines,"Job: "..player:GetNetworkedString("Job"),color_white,2+statuslines)
							statuslines = statuslines + 1
						end
					elseif (tent.ESPPaint) then
						tent:ESPPaint(lines, pos, distance, lookingat);
					elseif tent:GetNWBool"cider_Container" and lookingat then
						lines:Add("Name","A "..tent:GetNWString"Name",color_purpleblue,1)
						local status = cider.entity.getStatus(tent)
						if status ~= "" then
							lines:Add("Status",status,color_yellow,2)
						end
					elseif ( cider.entity.isDoor(tent) and lookingat) then
						local owner = cider.entity.getOwner(tent)
						if owner then
							local name = tent:GetNetworkedString("Name","Door")
							if not name or name == "" then
								name = "Door"
							end
							if owner == "Nobody" then -- Door is for sale
								owner = "For Sale - Press F2"
								if bit.band(tent:GetDTInt(3) , OBJ_SEALED) == OBJ_SEALED then
									owner = ""
								end
							end
							lines:Add("Name",name,color_purpleblue,1)
							local status = cider.entity.getStatus(tent)
							if status ~= "" then
								lines:Add("Status",status,color_yellow,2)
							end
							lines:Add("Owner",owner,color_white,2 + (status ~= 0 and 1 or 0))
						end
					elseif ( class == "cider_note" ) then
						local wrapped = {};
						if lookingat then
							local text = "";
							for i = 1, 10 do
								local line = tent:GetNetworkedString("cider_Text_"..i);

								-- Check if this line exists.
								if (line ~= "") then
									line = string.Replace(line, " ' ", "'");
									line = string.Replace(line, " : ", ":");

									-- Add the line to our text.
									text = text..line;
								end
							end
							-- Wrap the text into our table.
							cider.chatBox.wrapText(text, "ChatFont", 256, nil, wrapped);
						end

						lines:Add("Name","Note",color_lightblue,1)

						if lookingat then
							-- Loop through our text
							local i = 0
							for k, v in ipairs(wrapped) do
								lines:Add("text"..i,v,color_white,2+i)
								i = i + 1
							end
						end
					elseif class == "C_BaseEntity" and lookingat then --  func_buttons show up as C_BaseEntity for some reason.
						local name = tent:GetNetworkedString("Name")
						if not name or name == "" then
							name = "A Button"
						end
						lines:Add("Name",name,color_purpleblue,1)
					end
					hook.Call("AdjustESPLines",GAMEMODE,lines,tent,pos,distance,lookingat)
					local parsed = lines:GetAll()
					for _,line in pairs(parsed) do
						y = GAMEMODE:DrawInformation(line.text, "ChatFont", x, y, line.color, alpha);
					end
				end
			end
		end
		end
	end
end

-- Called when screen space effects should be rendered.
function GM:RenderScreenspaceEffects()
	if lpl == NULL then
		lpl = LocalPlayer()
	end
	local modify = {};
	local color = 0.8;
	local addr = 0

	-- Check if the player is low on health or stunned.
	if lpl._Stunned then
		color = 0.4
		DrawMotionBlur(0.1,1,0)
	elseif (lpl:Health() < 50 and !lpl._HideHealthEffects) then
		if ( lpl:Alive() ) then
			color = math.Clamp(color - ( ( 50 - lpl:Health() ) * 0.025 ), 0, color);
		else
			color = 1.13;
			addr = 1
		end
		-- Draw the motion blur.
		DrawMotionBlur(math.Clamp(1 - ( ( 50 - lpl:Health() ) * 0.025 ), 0.1, 1), 1, 0);
	end

	-- Set some color modify settings.
	modify["$pp_colour_addr"] = addr;
	modify["$pp_colour_addg"] = 0;
	modify["$pp_colour_addb"] = 0;
	modify["$pp_colour_brightness"] = 0;
	modify["$pp_colour_contrast"] = 1;
	modify["$pp_colour_colour"] = color;
	modify["$pp_colour_mulr"] = 0;
	modify["$pp_colour_mulg"] = 0;
	modify["$pp_colour_mulb"] = 0;
	if lpl._Sleeping then
		modify["$pp_colour_contrast"]= 0
	end

	-- Draw the modified color.
	DrawColorModify(modify);
end

-- Called when the scoreboard should be drawn.
function GM:HUDDrawScoreBoard()
	self.BaseClass:HUDDrawScoreBoard(player);

	-- Check if the player hasn't initialized yet.
	if (!self.playerInitialized) then
		draw.RoundedBox( 2, 0, 0, ScrW(), ScrH(), color_black );

		-- Set the font of the text to Chat Font.
		surface.SetFont("ChatFont");

		-- Get the size of the loading text.
		local width, height = surface.GetTextSize("Loading!");

		-- Get the x and y position.
		local x, y = self:GetScreenCenterBounce();

		-- Draw a rounded box for the loading text to go on.
		draw.RoundedBox( 2, (ScrW() / 2) - (width / 2) - 8, (ScrH() / 2) - 8, width + 16, 30, color_darkgray );

		-- Draw the loading text in the middle of the screen.
		draw.DrawText("Loading!", "ChatFont", ScrW() / 2, ScrH() / 2, color_white, 1, 1);

		-- Let them know how to rejoin if they are stuck.
		draw.DrawText("Press 'Jump' to rejoin if you are stuck on this screen!", "ChatFont", ScrW() / 2, ScrH() / 2 + 32, Color(255, 50, 25, 255), 1, 1);
	end
end

-- Draw Information.
function GM:DrawInformation(text, font, x, y, color, alpha, left, callback, shadow)
	surface.SetFont(font);

	-- Get the width and height of the text.
	local width, height = surface.GetTextSize(text);
	if alpha then color.a = alpha end
	-- Check if we shouldn't left align it, if we have a callback, and if we should draw a shadow.
	if (!left) then x = x - (width / 2); end
	if (callback) then x, y = callback(x, y, width, height); end
	if (shadow) then draw.DrawText(text, font, x + 1, y + 1, Color(0, 0, 0, color.a)); end

	-- Draw the text on the player.
	draw.DrawText(text, font, x, y, color);

	-- Return the new y position.
	return y + height + 8;
end

-- Draw the player's information.
function GM:DrawPlayerInformation()
	local width = 0;
	local height = 0;

	-- Create a table to store the text.
	local text = {};
	local information = {};

	-- Insert the player's information into the text table.
	table.insert( text, {"Name: "..lpl:GetNetworkedString("RPName"), "gui/silkicons/wrench"} );
	table.insert( text, {"Money: $"..string.Comma((lpl._Money or 0)), "gui/silkicons/star"} );
	table.insert( text, {"Job: "..lpl:GetNetworkedString("Job"), "gui/silkicons/wrench"} );
	table.insert( text, {"Salary: $"..(lpl._Salary or 0), "gui/silkicons/folder_go"} );
	table.insert( text, {"Gender: "..(lpl._Gender or "Male"), "gui/silkicons/heart"} );
	table.insert( text, {"Description: "..lpl:GetNetworkedString("Description"), "gui/silkicons/status_offline"});
	table.insert( text, {"Clan: "..lpl:GetNetworkedString("Clan"), "gui/silkicons/group"} );


	-- Loop through each of the text and adjust the width.
	for k, v in pairs(text) do
		if (string.Explode( ":", v[1] )[2] ~= " ") then
			if ( v[2] ) then
				width = self:AdjustMaximumWidth("ChatFont", v[1], width, nil, 24);
			else
				width = self:AdjustMaximumWidth("ChatFont", v[1], width);
			end

			-- Insert this text into the information table.
			table.insert(information, v);
		end
	end

	-- Add 16 to the width and set the height of the box.
	width = width + 16;
	height = (18 * #information) + 14;

	-- The position of the information box.
	local x = 8;
	local y = ScrH() - height - 8;

	-- Draw a rounded box to put the information text onto.
	draw.RoundedBox( 2, x, y, width, height, color_black_alpha );

	-- Increase the x and y position by 8.
	x = x + 8;
	y = y + 8;

	-- Draw the information on the box.
	for k, v in pairs(information) do
		if ( v[2] ) then
			self:DrawInformation(v[1], "ChatFont", x + 24, y, color_white, 255, true);

			-- Draw the icon that respresents the text.
			surface.SetTexture( surface.GetTextureID( v[2] ) );
			surface.SetDrawColor(255, 255, 255, 255);
			surface.DrawTexturedRect(x, y - 1, 16, 16);
		else
			self:DrawInformation(v[1], "ChatFont", x, y, color_white, 255, true);
		end


		-- Increase the y position.
		y = y + 18;
	end

	-- Return the width and height of the box.
	return width, height;
end

-- Draw the health bar.
function GM:DrawHealthBar(bar)
	local health = math.Clamp(lpl:Health(), 0, 100);

	-- Draw the health and ammo bars.
	self:DrawBar("Default", bar.x, bar.y, bar.width, bar.height, color_red_alpha, "Health: "..health, 100, health, bar);
end
-- Draw the timer bar.
function GM:DrawTimerBar(bar)
	local percento = math.Clamp((tonumber(lpl._JobTimeExpire-CurTime())/tonumber(lpl._JobTimeLimit))*100, 0, 100);
	lpl._NextEnter = lpl._NextEnter or CurTime()
	self:DrawBar("Default", bar.x, bar.y, bar.width, bar.height, color_orange_alpha, "Time Left: "..string.ToMinutesSeconds(math.floor(tonumber(lpl._JobTimeExpire)-CurTime())), 100, percento, bar);
end

-- Draw the ammo bar.
function GM:DrawAmmoBar(bar)
	local weapon = lpl:GetActiveWeapon();

	-- Check if the weapon is valid.
	if ( IsValid(weapon) ) then
		if ( !self.ammoCount[ weapon:GetClass() ] ) then
			self.ammoCount[ weapon:GetClass() ] = weapon:Clip1();
		end

		-- Check if the weapon's first clip is bigger than the amount we have stored for clip one.
		if ( weapon:Clip1() > self.ammoCount[ weapon:GetClass() ] ) then
			self.ammoCount[ weapon:GetClass() ] = weapon:Clip1();
		end

		-- Get the amount of ammo the weapon has in it's first clip.
		local clipOne = weapon:Clip1();
		local clipMaximum = self.ammoCount[ weapon:GetClass() ];
		local clipAmount = lpl:GetAmmoCount( weapon:GetPrimaryAmmoType() );

		-- Check if the maximum clip if above 0.
		if (clipMaximum > 0) then
			self:DrawBar("Default", bar.x, bar.y, bar.width, bar.height, color_lightblue_alpha, "Ammo: "..clipOne.." ["..clipAmount.."]", clipMaximum, clipOne, bar);
		end
	end
end

-- Called when the bottom bars should be drawn.
function GM:DrawBottomBars(bar) end

-- Called when the top text should be drawn.
function GM:DrawTopText(text)
	-- Check if the player is warranted.
	if (lpl:GetNetworkedString("Warrant") ~= "") then
		local _WarrantExpireTime = lpl._WarrantExpireTime;

		-- Text which is extended to the notice.
		local extension = ".";

		-- Check if the warrant expire time exists.
		if (_WarrantExpireTime) then
			local seconds = math.floor( _WarrantExpireTime - CurTime() );

			-- Check if the amount of seconds is greater than 0.
			if (seconds > 0) then
				if (seconds > 60) then
					extension = " which expires in "..math.ceil(seconds / 60).." minute(s).";
				else
					extension = " which expires in "..seconds.." second(s).";
				end
			end
		end

		-- Check the class of the warrant.
		if (lpl:GetNetworkedString("Warrant") == "search") then
			text.y = self:DrawInformation("You have a search warrant"..extension, "ChatFont", text.x, text.y, color_brightgreen, 255, true, function(x, y, width, height)
				return x - width - 8, y;
			end);
		elseif (lpl:GetNetworkedString("Warrant") == "arrest") then
			text.y = self:DrawInformation("You have an arrest warrant"..extension, "ChatFont", text.x, text.y, color_brightgreen, 255, true, function(x, y, width, height)
				return x - width - 8, y;
			end);
		end
	end

	-- Check if the player is arrested.
	if ( lpl:Arrested() ) then
		local _UnarrestTime = lpl._UnarrestTime or 0;

		-- Check if the unarrest time is greater than the current time.
		if ( _UnarrestTime > CurTime() ) then
			local seconds = math.floor( _UnarrestTime - CurTime() );
			-- Check if the amount of seconds is greater than 0.
			if (seconds > 0) then
				if (seconds > 60) then
					text.y = self:DrawInformation("You will be unarrested in "..math.ceil(seconds / 60).." minute(s).", "ChatFont", text.x, text.y, color_lightblue, 255, true, function(x, y, width, height)
						return x - width - 8, y;
					end);
				else
					text.y = self:DrawInformation("You will be unarrested in "..seconds.." second(s).", "ChatFont", text.x, text.y, color_lightblue, 255, true, function(x, y, width, height)
						return x - width - 8, y;
					end);
				end
			else
				text.y = self:DrawInformation("ur arrested but has no unarrest time (arrus is zero)", "ChatFont", text.x, text.y, color_lightblue, 255, true, function(x, y, width, height)
						return x - width - 8, y;
					end);
			end
		else
			text.y = self:DrawInformation("ur arrested but has no unarrest time (arrus below ctim)", "ChatFont", text.x, text.y, color_lightblue, 255, true, function(x, y, width, height)
						return x - width - 8, y;
					end);
		end
	end
	if lpl:Tied() then
		text.y = self:DrawInformation("You have been tied up!", "ChatFont", text.x, text.y, color_lightblue, 255, true, function(x, y, width, height)
			return x - width - 8, y;
		end);
	end
	-- Check if the player is wearing kevlar.
	if (lpl._ScaleDamage == 0.5) then
		text.y = self:DrawInformation("You are wearing kevlar which reduces damage by 50%.", "ChatFont", text.x, text.y, color_pink, 255, true, function(x, y, width, height)
			return x - width - 8, y;
		end);
	end
end

-- Called every time the HUD should be painted.

function GM:HUDPaint()
	self:HUDPaintESP()
	if ( !self:IsUsingCamera() ) then
		self:DrawInformation(self.Config["Website URL"], "ChatFont", ScrW(), ScrH(), color_white, 255, true, function(x, y, width, height)
			return x - width - 8, y - height - 8;
		end);

		-- Loop through the money alerts.
		for k, v in pairs(self.moneyAlerts) do
			v.alpha = math.Clamp(v.alpha - 1, 0, 255);
			v.add = v.add + 1;

			-- Draw the money alert.
			self:DrawInformation(v.text, "ChatFont", ScrW(), ScrH() - 24 - v.add, v.color, v.alpha, true, function(x, y, width, height)
				return x - width - 8, y - height - 8;
			end);

			-- Check if the alpha is 0.
			if (v.alpha == 0) then self.moneyAlerts[k] = nil; end
		end

		-- Get the size of the information box.
		local width, height = self:DrawPlayerInformation();

		-- A table to store the bar and text information.
		local bar = {x = width + 16, y = ScrH() - 24, width = 144, height = 16};
		local text = {x = ScrW(), y = 8};

		-- Draw the player's health and ammo bars.
		--if lpl:Health() < 80 then
		self:DrawHealthBar(bar);
		--end
		self:DrawAmmoBar(bar);
		if lpl._JobTimeExpire and tonumber(lpl._JobTimeExpire) > CurTime() then
			self:DrawTimerBar(bar)
		end
		-- Call a hook to let plugins know that we're now drawing bars and text.
		hook.Call("DrawBottomBars",GAMEMODE, bar);
		hook.Call("DrawTopText",GAMEMODE, text);

		-- Set the position of the chat box.
		cider.chatBox.position = {x = 8, y = math.min(bar.y + 20, ScrH() - height - 8) - 40};

		-- Get the player's next spawn time.
		local _NextSpawnTime = lpl._NextSpawnTime or 0;

		-- Check if the next spawn time is greater than the current time.
		local x,y = self:GetScreenCenterBounce()
		y = y + 16
		if ( !lpl:Alive() and _NextSpawnTime > CurTime() ) then
			local seconds = math.floor( _NextSpawnTime - CurTime() );

			-- Check if the amount of seconds is greater than 0.
			if (seconds > 0) then
				self:DrawInformation("You must wait "..seconds.." second(s) to spawn.", "ChatFont", x, y, color_white, 255);
			end
		elseif lpl:KnockedOut() and lpl:Alive() then
			local _BecomeConsciousTime = lpl._KnockoutPeriod or 0;
			text = "ERROR"
			-- Check if the unknock out time is greater than the current time.
			if ( _BecomeConsciousTime > CurTime() ) then
				local seconds = math.floor( _BecomeConsciousTime - CurTime() );

				-- Check if the amount of seconds is greater than 0.
			--	if (seconds > 0) then
					text = "You will be able to get up in "..seconds.." second(s)."
			--	end
			elseif lpl._Sleeping then
				text = "Press 'Jump' to wake up."
			elseif lpl:Alive() then
				text = "Press 'Jump' to get up."
			end
			self:DrawInformation(text, "ChatFont", x, y, color_white, 255);
		elseif (lpl._GoToSleepTime or 0) > CurTime() then
			local seconds = math.floor( (lpl._GoToSleepTime or 0) - CurTime() );
			if seconds > 0 then
				self:DrawInformation("You will fall asleep in "..seconds.." second(s).", "ChatFont", x, y,  color_white, 255);
			end
		elseif (lpl._Tying or 0 )> CurTime() then
			local seconds = math.floor( lpl._Tying - CurTime() )
			if seconds > 0 then
				self:DrawInformation("You will finish the knots in "..seconds.." second(s).", "ChatFont", x, y,  color_white, 255);
			end
		elseif lpl._BeTied then
			self:DrawInformation("You are being tied up!", "ChatFont", x, y, color_white, 255);
		end

		-- Get whether the player is stuck in the world.
		local stuckInWorld = lpl._StuckInWorld;

		-- Check whether the player is stuck in the world.
		if (stuckInWorld) then
			self:DrawInformation("You are stuck! Press 'Jump' to holster your weapons and respawn.", "ChatFont", ScrW() / 2, (ScrH() / 2) - 16, Color(255, 50, 25, 255), 255);
		end

		-- Loop through every player.
		for k, v in pairs( g_Player.GetAll() ) do hook.Call("PlayerHUDPaint",GAMEMODE, v); end

		-- Call the base class function.
		self.BaseClass:HUDPaint();
	end
end

-- Called to check if a player can use voice.
function GM:PlayerCanVoice(player)
	do return false end
	if !player:IsValid() or !lpl:IsValid() then return false end
	if ( player:Alive()
	and player:GetPos():Distance( lpl:GetPos() ) <= self.Config["Talk Radius"]
	and !player:GetNetworkedBool("Arrested")
	and !player:KnockedOut() ) then
		return true;
	else
		return false;
	end
end

-- Stop players bypassing my post proccesses with theirs
function GM:PostProcessPermitted() return LocalPlayer():IsAdmin() end

-- Called every frame.
function GM:Think()
	if ( self.Config["Local Voice"] ) then
		for k, v in pairs( player.GetAll() ) do
			if ( hook.Call("PlayerCanVoice",GAMEMODE, v) ) then
				if ( v:IsMuted() ) then v:SetMuted(); end
			else
				if ( !v:IsMuted() ) then v:SetMuted(); end
			end
		end
	end

	-- Call the base class function.
	return self.BaseClass:Think();
end

-- Called when a player begins typing.
function GM:StartChat(team) return true; end

-- Called when a player says something or a message is received from the server.
function GM:ChatText(index, name, text, filter)
	if ( filter == "none" or filter == "joinleave" or (filter == "chat" and name == "Console") ) then
		cider.chatBox.chatText(index, name, text, filter);
	end

	-- Return true because we handle this our own way.
	return true;
end

local function iHasInitializedyay()
	if IsValid(LocalPlayer()) then
		GAMEMODE.playerInitialized = true
		if startupmenu:GetBool() then
			cider.menu.toggle()
		end
	else
		timer.Simple(0.2,iHasInitializedyay)
	end
end
-- Hook into when the player has initialized.
usermessage.Hook("cider.player.initialized", iHasInitializedyay);
--[[		umsg.Start("cider_ModelChoices")
		umsg.Short(#player._ModelChoices)
		for name,gender in pairs(player._ModelChoices) do
			umsg.String(name)
			umsg.Short(#gender)
			for team,choice in ipairs(gender) do
				umsg.Short(team)
				umsg.Short(choice)
			end
		end
		umsg.End()]]
	local errors = 0
	local maxerrors = GM.Config["Model Choices Timeout"]
	local function CheckForInitalised(tab)

		if errors >= maxerrors then
			ErrorNoHalt"Something is very wrong - reconnecting!"
			RunConsoleCommand("retry");
		elseif errors == maxerrors/2 then
			ErrorNoHalt("Critical error! You have ".. maxerrors/2 .." seconds before your client reconnects!\n")
			ErrorNoHalt("LocalPlayer() is not a valid entity after "..errors.." seconds of gameplay!")
			ErrorNoHalt("LocalPlayer(): "..tostring(LocalPlayer()).."\n")
			ErrorNoHalt("---------------------------\n")
		end
		if !IsValid(LocalPlayer()) then
			errors = errors + 1
		--	ErrorNoHalt("LocalPlayer is invalid! ("..errors.."/"..maxerrors..")\n")
			return timer.Simple(1, function()
				CheckForInitalised(tab)
			end)
		end
		--if errors > 0 then ErrorNoHalt"Nevermind it works now...\n" end
		LocalPlayer()._ModelChoices = tab
	end
usermessage.Hook("cider_ModelChoices",function(msg)
	local tab = {}
	local length = msg:ReadShort() or 0
	for i=1, length do
		local gender = msg:ReadString() or ""
		tab[gender] = {}
		local leng = msg:ReadShort()
		for j = 1, leng do
			tab[gender][msg:ReadShort() or 0] = msg:ReadShort() or 0
		end
	end
	CheckForInitalised(tab)
end)

function GM:Initialize()
	ErrorNoHalt(os.date().." - Finished connecting\n")
	-- Call the base class function.
	return self.BaseClass:Initialize()
end

function GM:ForceDermaSkin()
	return self.BaseClass:ForceDermaSkin()
end

include("scoreboard/scoreboard.lua")

local CiderScoreboard = nil

-- Create the scoreboard.
function GM:CreateScoreboard()
	if ScoreBoard then
		ScoreBoard:Remove()
		ScoreBoard = nil
	end

	CiderScoreboard = vgui.Create("ScoreBoard")
end

-- Show the scoreboard.
function GM:ScoreboardShow()
	GAMEMODE.ShowScoreboard = true
	gui.EnableScreenClicker(true)

	if not CiderScoreboard then
		self:CreateScoreboard()
	end

	CiderScoreboard:SetVisible(true)
	CiderScoreboard:UpdateScoreboard(true)
end

-- Hide the scoreboard.
function GM:ScoreboardHide()
	GAMEMODE.ShowScoreboard = false
	gui.EnableScreenClicker(false)
	CiderScoreboard:SetVisible(false)
end