--[[
Name: "sh_events.lua".
	~ Applejack ~
--]]
----EVENTS----
--- New format: Name, Description, Potential access.
--- Potential access: Pm = police or moderators. 
--- To save hastle, m = admin or moderator 
--- Events with the same name will appear under the same tab.
EVENT_EVENT_TYPE =		GM:RegisterLogCategegoryMaster("Event",  "Events that you have access to",	color_white)
EVENT_DEBUG_TYPE =		GM:RegisterLogCategegoryMaster("Debug",  "Debug messages.",					color_white)
EVENT_ERROR_TYPE =		GM:RegisterLogCategegoryMaster("Errors", "Errors and warnings.",			color_white)

EVENT_SUPEREVENT =		GM:RegisterLogSubCategory(EVENT_EVENT_TYPE, "s")
EVENT_ADMINEVENT =		GM:RegisterLogSubCategory(EVENT_EVENT_TYPE, "a")
EVENT_EVENT =			GM:RegisterLogSubCategory(EVENT_EVENT_TYPE, "m")
EVENT_POLICEEVENT =		GM:RegisterLogSubCategory(EVENT_EVENT_TYPE, "Pm")
EVENT_PUBLICEVENT =		GM:RegisterLogSubCategory(EVENT_EVENT_TYPE, "b")
------
EVENT_DEBUG =			GM:RegisterLogSubCategory(EVENT_DEBUG_TYPE, "D")
EVENT_SQLDEBUG =		GM:RegisterLogSubCategory(EVENT_DEBUG_TYPE, "Q")
------
EVENT_DEBUGERROR =		GM:RegisterLogSubCategory(EVENT_ERROR_TYPE, "D")
EVENT_ERROR =			GM:RegisterLogSubCategory(EVENT_ERROR_TYPE, "b")


EVENT_ALL =				 GM:RegisterLogCategory("All", "Every event on the server",							"b",color_white				 );
EVENT_TALKING =			 GM:RegisterLogCategory("Speech", "People talking (Super spammy)",					"S",Color(095, 120, 255, 255));
EVENT_BUILD =			 GM:RegisterLogCategory("Building", "People spawning props/using tools",			"m",Color(090, 230, 020, 255));
EVENT_PICKUP =			 GM:RegisterLogCategory("Pickups", "People picking things up.",						"b",Color(150, 180, 020, 255));
EVENT_COMMAND = 		 GM:RegisterLogCategory("Commands", "Every raw command used",						"s",Color(200, 200, 150, 255));
EVENT_ITEM =		 	 GM:RegisterLogCategory("Items", "All actions to do with items, use/make/drop etc",	"m",Color(255, 125, 000, 255));
EVENT_PLAYERDAMAGE =	 GM:RegisterLogCategory("Damage (PVP)", "Only PVP damage",							"m",Color(200, 025, 025, 255));
EVENT_DAMAGE =			 GM:RegisterLogCategory("Damage", "People being injured/killed",					"m",Color(200, 100, 025, 255));
EVENT_DEATH =			 GM:RegisterLogCategory("Deaths", "People dying",									"m",Color(255, 000, 000, 255));
EVENT_ENTITY =			 GM:RegisterLogCategory("Entities", "Events relating to entities",					"m",Color(064, 236, 148, 255));
EVENT_TEAM =			 GM:RegisterLogCategory("Teams", "Events revolving around teams",					"b",Color(085, 175, 019, 255));