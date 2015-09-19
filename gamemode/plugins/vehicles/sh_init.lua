--[[
	~ Vehicles Plugin / SH ~
	~ Applejack ~
--]]
local PLUGIN = PLUGIN or GAMEMODE:GetPlugin("Vehicles") or {}; -- Allows this file to be hot reloaded (which needs to be done a lot when editing car data)
local nocarmaps = {"rp_tb_city45_v02"}
if (table.HasValue(nocarmaps,game.GetMap():lower())) then
	PLUGIN.Abort = true;
	return;
end
PLUGIN.Name = "Vehicles";
--[[
	Credit goes to NoVa for VU-Mod, which I have sliced and diced and rewritten and prodded into this.
--]]
local function HandleRollercoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER ) 
end

local cat = "Applejack Vehicles";
local class = "prop_vehicle_jeep";

--[[ ORDINARY CARS ]]--
list.Set( "Vehicles", "Jeep", { 	
	Name = "2 Seater Jeep", 
	Class = "prop_vehicle_jeep_old",
	Category = cat,
	Author = "Nova[X]",
	Information = "A two-seater Jeep",
	Ownable = true,
	Model = "models/buggy.mdl",
	Horn = {Sound = "vu_horn_simple.wav", Pitch = 90},
	Passengers  = { { Pos = Vector(16,37,19), Ang = Angle(0,0,0) } },
	SeatType = "Seat_Jeep", ----if were not hideing the seat you probably want to choose a seat.
	HideSeats = false, -----Hide the passenger seats?
	CustomViews = {
		FirstPerson = Vector(0,0,0),
	},
	KeyValues = {
					vehiclescript	=	"scripts/vehicles/jeep_test.txt"
				}
} );
list.Set( "Vehicles", "trabbi", { 	
	-- Required information
	Name = "Trabbi", 
	Class = class,
	Category = cat,
	Ownable = true,

	-- Optional information
	Author = "Kuno86",
	Information = "Trabbi, a HL2 car converted to be drivable.",
	Model = "models/trabbi.mdl",
	Passengers  = {
		{ Pos = Vector(16,2,12), Ang = Angle(0,0,0) }
	},
	Customexits = { Vector(-60,-5,12), Vector(60,-5,12),Vector(0,0,90)},
	SeatType = "Seat_Jeep",
	HideSeats = true,
	Horn = {Sound = "vu_horn_old.wav", Pitch = 90},
	CustomViews = {
		FirstPerson = Vector(0,2,10),
		ThirdPerson = {Out = 120 , Up = 30},
		RearView = Vector(0,-65,52);
	},
	
	KeyValues = {
					vehiclescript	=	"scripts/vehicles/trabbi.txt"
				},
	Doors = {
		{topleft=Vector( 27,-8,56),bottomright=Vector( 37,26,14)},
		{topleft=Vector(-27,-8,56),bottomright=Vector(-37,26,14)}
	}
} );

list.Set( "Vehicles", "tideslkw", { 	
	-- Required information
	Name = "Truck", 
	Class = class,
	Category = cat,
	Ownable = true,

	-- Optional information
	Author = "Kuno86",
	Information = "Tides Truck",
	Model = "models/tideslkw.mdl",
	Passengers  = {
		{ Pos = Vector(21,-78,40), Ang = Angle(0,0,0) }
	},
	Customexits = { Vector(-90,-78,40),Vector(90,-78,40), Vector(0,0,90) },
	HideSeats = true,
	SeatType = "Seat_Jeep",
	CustomViews = {
		FirstPerson = Vector(0,0,12),
		ThirdPerson = {Out = 120 , Up = 30},
		RearView = Vector(0,0,120);
		},
	
	Horn = {Sound = "vu_horn_old.wav", Pitch = 90},
	KeyValues = {
					vehiclescript	=	"scripts/vehicles/tideslkw.txt"
				},
	Doors = {
		{topleft=Vector( 37,74,85),bottomright=Vector( 45,109,23)},
		{topleft=Vector(-37,74,85),bottomright=Vector(-45,109,23)}
	}
} );

list.Set( "Vehicles", "citron7cv", { 	
	-- Required information
	Name = "Citroen 7CV", 
	Class = class,
	Category = cat,
	Ownable = true,

	-- Optional information
	Author = "Kuno86",
	Information = "Citroen 7CV",
	Model = "models/citron7cv.mdl",
	Passengers  = {
		{ Pos = Vector(16,9,20), Ang = Angle(0,0,0) },
		{ Pos = Vector(0,44,20), Ang = Angle(0,0,0) },
	},
	Horn = {Sound = "vu_horn_old.wav", Pitch = 90},
	Customexits = { Vector(-90,36,22), Vector(82,36,22), Vector(22,24,90) ,Vector(2,100,30) },
	SeatType = "Seat_Jeep",
	HideSeats = true,
	CustomViews = {
		FirstPerson = Vector(0,2,8),
		ThirdPerson = {Out = 120 , Up = 30},
		--RearView = Vector(48,-15,7)
		RearView = Vector(0,-65,60);
	},
	
	KeyValues = {
					vehiclescript	=	"scripts/vehicles/citron7cv.txt"
				},
	Doors = {
		{topleft=Vector( 25,-20,64),bottomright=Vector( 37,17,24)},
		{topleft=Vector(-25,-20,64),bottomright=Vector(-37,17,24)},
		{topleft=Vector( 25,-47,64),bottomright=Vector( 37,-24,24)},
		{topleft=Vector(-25,-47,64),bottomright=Vector(-37,-24,24)}
	}
} );

list.Set( "Vehicles", "copcar", { 	
	-- Required information
	Name = "Police Car", 
	Class = class,
	Category = cat,
	Ownable = true,

	-- Optional information
	Author = "Kuno86",
	Information = "Standard Police Cruiser !!!!TODO: THIS IS NOT FINISHED YET!!!!",
	Model = "models/copcar.mdl",
	Passengers  = {
		{ Pos = Vector( -2, 25,5), Ang = Angle(0,0,0) },
		{ Pos = Vector( -2,65,5), Ang = Angle(0,0,0) },
		{ Pos = Vector(-24,65,5), Ang = Angle(0,0,0) },
		{ Pos = Vector(-46,65,5), Ang = Angle(0,0,0) },
	}, 
	Customexits = {Vector(-80,5,10), Vector(80,5,10), Vector(0,0,90) },
	CustomViews = {
		FirstPerson = Vector(0,0,12),
		ThirdPerson = {Out = 120 , Up = 30},
		RearView = Vector(-20,-120,53);
	},
	Horn = {Sound = "vu_horn_simple.wav", Pitch = 90},
	SeatType = "Seat_Jeep",
	KeyValues = {
					vehiclescript	=	"scripts/vehicles/copcar.txt"
				}
} );

if 	util.IsValidModel( "models/vehicle.mdl" ) then	
	list.Set( "Vehicles", "Jalopy", { 	
		Name = "Jalopy", 
		Class = class,
		Category = cat,
		Ownable = true,
		Author = "Nova[X]",
		Information = "Jalopy, With a working passenger seat!",
		Model = "models/vehicle.mdl",
		CustomViews = {
			FirstPerson = Vector(0,0,12),
			ThirdPerson = {Out = 120 , Up = 30},
		},
		AdjustSitPos = Vector(77,40,35),
		Passengers  = {{ Pos = Vector(22,24,22), Ang = Angle(0,0,0) } }, -------Set Up passenger seats!
		Customexits = { Vector(-90,36,22), Vector(82,36,22), Vector(22,24,90) ,Vector(2,100,30) },
		SeatType = "Seat_Jeep",
		HideSeats = true, -----Hide the passenger seats?
		KeyValues = {vehiclescript	=	"scripts/vehicles/jalopy.txt"}
	});
end

--[[ Varient vehicles - IE Those with skins ]]--
local v;
v = { 	
	-- Required information
	Name = "Corvette C6 (Blue)", 
	Class = class,
	Category = cat,
	-- Optional information
	RPName = "Generic Blue Corvette C6";
	Ownable = true,
	Author = "Athos",
	Information = "A Blue Corvette C6",
	Model = "models/corvette/corvette.mdl",
	CustomViews = {
		FirstPerson = Vector(0,0,0),
		ThirdPerson = {Out = 120 , Up = 30},
		RearView = Vector(0,-105,60);
	},
	Customexits = {  Vector(-80,19,10),Vector(80,19,10), Vector(0,0,90)},
	Horn = {Sound = "vu_horn_simple.wav", Pitch = 90},
	Passengers  = {{ Pos = Vector(22,19,10), Ang = Angle(0,0,0) } }, -------Set Up passenger seats!
	SeatType = "Seat_Jeep", ----if were not hideing the seat you probably want to choose a seat.
	HideSeats = true, -----Hide the passenger seats?
	Doors = {
		{topleft=Vector( 34,-43,60),bottomright=Vector( 52,22,13)},
		{topleft=Vector(-34,-43,60),bottomright=Vector(-52,23,13)}
	},
	KeyValues = {
					vehiclescript	=	"scripts/vehicles/corvette_blue.txt"
				}
}
list.Set( "Vehicles", "Corvette_Blue", v );
v = table.Copy(v);
v.Name = "Corvette C6 (Yellow)";
v.RPName = "Pimpin' Yellow Corvette C6";
v.Skin = 2;
v.Information = "A Yellow Corvette C6";
v.KeyValues.vehiclescript	=	"scripts/vehicles/corvette_yellow.txt";
list.Set( "Vehicles", "Corvette_Yellow", v );

v = table.Copy(v);
v.Name = "Corvette C6 (Silver)";
v.RPName = "Exclusive Silver Corvette C6";
v.Skin	= 1;
v.Information = "A Silver Corvette C6";
v.KeyValues.vehiclescript	=	"scripts/vehicles/corvette_silver.txt";
list.Set( "Vehicles", "Corvette_Silver", v );

v = { 	
	-- Required information
	Name = "Golf GTI (White)", 
	Class = class,
	Category = cat,
	Ownable = true,
	-- Optional information
	RPName = "Generic White Golf GTI";
	Author = "Athos",
	Information = "A white Golf GTI",
	Model = "models/golf/golf.mdl",
	CustomViews = {
		FirstPerson = Vector(0,0,0),
		ThirdPerson = {Out = 120 , Up = 30},
		RearView = Vector(0,-95,65);
	},
	Passengers  = {
		{ Pos = Vector(19,5,10), Ang = Angle(0,0,0) },
		{ Pos = Vector(18,58,15), Ang = Angle(0,0,0) },
		{ Pos = Vector(-18,58,15), Ang = Angle(0,0,0) }
	}, 
	Customexits = {Vector(-80,5,10), Vector(80,5,10), Vector(0,0,160) },
	Horn = {Sound = "vu_horn_simple.wav", Pitch = 90},
	SeatType = "Seat_Jeep",
	HideSeats = true, 
	KeyValues = {
					vehiclescript	=	"scripts/vehicles/golf_white.txt"
				},
	Doors = {
		{topleft=Vector( 31,-28,70),bottomright=Vector( 51,38,14)},
		{topleft=Vector(-31,-28,70),bottomright=Vector(-51,38,14)}
	}

};

list.Set( "Vehicles", "Golf_White", v )

v = table.Copy(v);
v.Name 		= "Golf GTI (Green)";
v.Information = "A green Golf GTI";
v.RPName 	= "Groovy Green Golf GTI";
v.Skin		= 2;
v.KeyValues.vehiclescript = "scripts/vehicles/golf_green.txt";
list.Set( "Vehicles", "Golf_Green", v )

v = table.Copy(v);
v.Name 		= "Golf GTI (Blue)";
v.Information = "A blue Golf GTI";
v.RPName 	= "Rare Blue Golf GTI";
v.Skin		= 1;
v.KeyValues.vehiclescript = "scripts/vehicles/golf_blue.txt";
list.Set( "Vehicles", "Golf_Blue", v )

--[[ Seats ]]--
local seatkv = {vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
				 limitview		=	"0"}
local seatview = { ThirdPerson = { Out = 80 , Up = 25 }, FirstPerson = Vector(0,0,0)};
local seatexit = { Vector(0,-50,10),Vector(50,0,10),Vector(-50,0,10),Vector(0,50,10),Vector(0,0,100),Vector(0,0,-50),Vector(0,0,50) }
local seathand = { HandleAnimation = HandleRollercoasterAnimation }
class = "prop_vehicle_prisoner_pod";

list.Set( "Vehicles", "Seat_Jeep", { 	
	Name = "Jeep Seat", 
	Class = class,
	Category = cat,
	Author = "Nova[X]",
	Information = "Classic Jeep passenger Seat",
	Model = "models/nova/jeep_seat.mdl",
	CustomViews = seatview,
	KeyValues = seatkv,
	Customexits = seatexit,
	Members = seathand
});

list.Set( "Vehicles", "Seat_Airboat", { 	
	Name = "Airboat Seat", 
	Class = class,
	Category = cat,
	Author = "Nova[X]",
	Information = "Airboat passenger Seat",
	Model = "models/nova/airboat_seat.mdl",
	CustomViews = seatview,
	KeyValues = seatkv,
	Customexits = seatexit,
	Members = seathand
});

list.Set( "Vehicles", "Chair_Wood", {
 	Name = "Wood Chair", 
	Class = class,
	Category = cat,
	Author = "Nova[X]",
	Information = "Good Ol' Wodden chair",
	Model = "models/nova/chair_wood01.mdl",
	CustomViews = seatview,
	KeyValues = seatkv,
	Customexits = seatexit,
	Members = seathand
});

list.Set( "Vehicles", "Chair_Office2", { 	
	Name = "Office Chair big", 
	Class = class,
	Category = cat,
	Author = "Nova[X]",
	Information = "Big and Comfortable office chair",
	Model = "models/nova/chair_office02.mdl",
	CustomViews = seatview,
	KeyValues = seatkv,
	Customexits = seatexit,
	Members = seathand
} );

list.Set( "Vehicles", "Chair_Office1", { 	
	Name = "Office Chair small", 
	Class = class,
	Category = cat,
	Author = "Nova[X]",
	Information = "Just a Basic office chair",
	Model = "models/nova/chair_office01.mdl",
	CustomViews = seatview,
	KeyValues = seatkv,
	Customexits = seatexit,
	Members = seathand
});

list.Set( "Vehicles", "Chair_Plastic", { 	
	Name = "Plastic Chair", 
	Class = class,
	Category = cat,
	Author = "Nova[X]",
	Information = "Cheap plastic chair",
	Model = "models/nova/chair_plastic01.mdl",
	CustomViews = seatview,
	KeyValues = seatkv,
	Customexits = seatexit,
	Members = seathand
} );
