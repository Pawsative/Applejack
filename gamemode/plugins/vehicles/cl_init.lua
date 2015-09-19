--[[
	~ Vehicles Plugin / CL ~
	~ Applejack ~
--]]

include("sh_init.lua");
if (PLUGIN.Abort) then return end
local lpl = 			LocalPlayer()
local gpstext =			Color(255,220,0,255)
local divider = 		Color(255,220,0,50)
local carnametext = 	Color(255,220,0,20)
local alphablack =		Color(0, 0, 0, 200)
local color_purple = 	Color(150, 075, 200, 255)
local color_orange =	Color(255, 125, 000, 255)
local color_yellow =	Color(250, 230, 070, 255)

surface.CreateFont("textsmall", {
    font = "DIN Light",
    size = 16,
    weight = 2,
    antialias = true
})

surface.CreateFont("compasscard", {
    font = "DIN Medium",
    size = 24,
    weight = 2,
    antialias = true
})

local gpspoints = {
	[90] = "^",
	[135] = "<",
	[180] = "<<",
	[225] = "<<<",
	[270] = "v",
	[315] = ">>>",
	[0] = ">>",
	[45] = ">",
}
local pointscard = {
	[0] = "N",
	[45] = "NE",
	[90] = "E",
	[135] = "SE",
	[180] = "S",
	[225] = "SW",
	[270] = "W",
	[315] = "NW",
}
function PLUGIN:LoadData()
	lpl = LocalPlayer()
end
--[[
local function traceview(start, endpos, filter)
	local tr = util.TraceLine{ start = start, endpos = endpos, filter = filter}
	return tr.HitPos;
end
usermessage.Hook("ClearViewMod",function()
	lpl.ViewMod = {};
end);
usermessage.Hook("ViewModFP",function(msg)
	lpl.ViewMod.FirstPos = msg:ReadVector();
end);
usermessage.Hook("ViewModTP",function(msg)
	local num = msg:ReadChar();
	local enttab = {};
	for i = 1,num do
		table.insert(enttab,msg:ReadEntity());
	end
	lpl.ViewMod.Filter = enttab;
	lpl.ViewMod.ThirdOut = msg:ReadShort();
	lpl.ViewMod.ThirdUp = msg:ReadShort();
end);
--]]
local views,lastname;

function PLUGIN:CalcView(ply, origin, angles, fov)
	local car = ply:GetVehicle();
	local name = car:GetNWString("VehicleName");
	if (not IsValid(car)) then return
	elseif (name ~= lastname) then
		views = nil;
		lastname = name;
		local vtable = list.Get("Vehicles")[name];
		if (not vtable) then return end
		views = vtable.CustomViews;
	elseif (not views) then return end

	local view = {angles = angles, fov = fov};
	if (ply:KeyDown(IN_DUCK) and views.RearView) then
		local angles = car:GetAngles();
		angles.y = angles.y - 90;
		angles.p = angles.p + 30;
		view.angles = angles--view.angles.y - 180;
		view.origin = car:LocalToWorld(views.RearView);--origin + angles:Forward() * views.RearView.x + angles:Right() * views.RearView.y + angles:Up() * views.RearView.z;
		return view;
	elseif (views.FirstPerson) then
		view.origin = origin + angles:Forward() * views.FirstPerson.x + angles:Right() * views.FirstPerson.y + angles:Up() * views.FirstPerson.z;
		return view;
	end

--[[
	if (not (ply:InVehicle() and ply.ViewMod)) then return end
	local view,viewmod = {angles = angles, fov = fov},ply.ViewMod;
	if (gmod_vehicle_viewmode:GetInt() == 1) then
		if (viewmod.ThirdOut and viewmod.ThirdUp) then
			view.origin = traceview(ply:GetVehicle():GetPos(), origin - angles:Forward() * viewmod.ThirdOut + angles:Up() * viewmod.ThirdUp, viewmod.Filter);
			return view;
		end
	elseif (viewmod.FirstPos) then
		local pos = viewmod.FirstPos
		view.origin = origin + angles:Forward() * pos.x + angles:Right() * pos.y + angles:Up() * pos.z;
		return view;
	end
--]]
end

local AntiCmdSpam = CurTime()
function PLUGIN:PlayerBindPress( ply, bind, pressed )
	if (not ply:InVehicle() or AntiCmdSpam > CurTime()) then return end
	local cmd
	if (bind == "+reload") then
		cmd = "HonkHorn";
	elseif (bind == "+attack2") then
		cmd = "UnLockCar";
	elseif (bind == "+attack") then
		cmd = "LockCar";
	elseif (bind == "+duck" and pressed) then -- Disable third person switching
		return false;
	end
	if (cmd) then
		AntiCmdSpam = CurTime() + 0.5;
		RunConsoleCommand(cmd);
	end
end

function PLUGIN:HUDPaint()
    if ( GAMEMODE:IsUsingCamera() ) then return end
    -- GPS
    if not lpl._GPS then return end
    local yaw, top, height, car = EyeAngles().y,8,28,false
    --Compass and environment
    local car = {}
    for ent in pairs(cider.entity.stored) do
     --   print(ent:IsVehicle())
        if IsValid(ent) and ent:GetClass() == "prop_vehicle_jeep" then
            --print"car"
            table.insert(car, ent)
            height = height + 12
        end
    end
    draw.RoundedBox(8,ScrW()/2-110,top,220,height,alphablack)
    draw.RoundedBox(0,ScrW()/2-1,top,2,height,divider)
    --draw.DrawText("|","compasscard",ScrW()/2,top,gpstext,1)
    for i = 0,359,15 do
        if not pointscard[i] then
           pointscard[i] = "."
        end
    end

    for k,v in pairs(pointscard) do
        if math.sin((yaw+k)/180*math.pi) > 0 then
            local text,color,alphaformula
            local cosd = math.cos((yaw+k)/180*math.pi)

            if type(v) ~= "table" then
                text = v
                alphaformula = math.Clamp(1-math.abs(cosd),0,1)
                color = Color(255,220,0,255*alphaformula)
            else
                text = v[1]
                color = v[2]
            end
            draw.DrawText(tostring(text),"compasscard",-92*cosd+ScrW()/2,top+0.6*math.sin((yaw+k)/180*math.pi),color,1)
        end
    end
    for _,ent in ipairs(car) do
        local gyaw = yaw - (ent:GetPos()-lpl:GetPos()):Angle().y
       -- draw.DrawText("|","compasscard",ScrW()/2,top+12,gpstext,1)
        for i = 0,359,15 do
            if not gpspoints[i] then
                gpspoints[i] = ""
            end
        end
        local ox = ScrW()*.5
        local oy = ScrH()*.5
        for k,v in pairs(gpspoints) do
            if math.sin((gyaw+k)/180*math.pi) > 0 then
                local text,alphaformula,color
                local cosd = math.cos((gyaw+k)/180*math.pi)
                if type(v) ~= "table" then
                    text = v
                    alphaformula = math.Clamp(1-math.abs(cosd),0,1)
                    color = Color(255,220,0,255*alphaformula)
                else
                    text = v[1]
                    color = v[2]
                end
                if k == 45 or k == 135 then
                    color = Color(180,255,0,255*alphaformula)
                elseif k == 315 or k == 225 then
                    color = Color(255,180,0,255*alphaformula)
                elseif k == 270 then
                    color = Color(255,0,0,255*alphaformula)
                elseif k == 90 then
                    color = Color(0,255,0,255*alphaformula)
                end
                draw.DrawText(tostring(text),"textsmall",-92*cosd+ScrW()/2,top+22+0.6*math.sin((gyaw+k)/180*math.pi),color,1)
            end
        end
        local name,text = ent:GetNWString("DisplayName"),""
        if not name or name == "" then
            name = "car"
        end
        if cider.entity.isOwned(ent) then
            text = cider.entity.getOwner(ent).."'s "
        else
            text = "A "
        end
        draw.DrawText(text..name,"textsmall",ScrW()/2,top+22,carnametext,1)
        top = top + 12
    end
end

function PLUGIN:AdjustESPLines(lines,tent,pos,distance,lookingat)
	if not IsValid(lpl) then
		lpl = LocalPlayer()
		if not IsValid(lpl) then
			return
		end
	end
	if tent:GetClass() == "prop_vehicle_jeep" and not lpl:InVehicle() then
		local name,text = tent:GetNWString("DisplayName"),""
		if not name or name == "" then
			name = "car"
		end
		if cider.entity.isOwned(tent) then
			text = cider.entity.getOwner(tent).."'s "
		else
			text = "A "
		end

		-- Draw the information and get the new y position.
		lines:Add("Name",text..name,color_purple,1)
		if lookingat then
			local status = cider.entity.getStatus(tent)
			if status ~= "" then
				lines:Add("Status",status,color_yellow,2)
			end
			local ang = tent:GetAngles()
			local text = ""
			if ang.r > 10 or ang.r < -10 then
				if bit.band(tent:GetDTInt(3) , OBJ_LOCKED) == OBJ_LOCKED then
					text = "Press 'use' to flip this car";
				else
					text = "This car must be locked before it can be flipped";
				end
				lines:Add("FlipStatus",text,color_orange,3)
			end
		end
	end
end