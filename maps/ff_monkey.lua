-- ff_monkey.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base_ctf")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------

POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60

function startup()
	SetGameDescription("Capture the Flag")
	
	-- set up team limits on each team
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)

	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
end

-----------------------------------------------------------------------------
-- Pickups
-----------------------------------------------------------------------------

monkeypackgeneric = genericbackpack:new({
	health = 20,
	armor = 15,
	grenades = 60,
	nails = 60,
	shells = 60,
	rockets = 60,
	cells = 60,
	mancannons = 1,
	gren1 = 1,
	gren2 = 1,
	respawntime = 35,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function monkeypackgeneric:dropatspawn() return false end

redmonkeypack = genericbackpack:new({
	health = 200,
	armor = 200,
	grenades = 200,
	nails = 200,
	shells = 200,
	rockets = 200,
	cells = 200,
	respawntime = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	botgoaltype = Bot.kBackPack_Ammo
})

function redmonkeypack:dropatspawn() return false end

redmonkeypacktoo = genericbackpack:new({
	health = 20,
	armor = 15,
	grenades = 10,
	nails = 30,
	shells = 30,
	rockets = 10,
	cells = 30,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	botgoaltype = Bot.kBackPack_Ammo
})

function redmonkeypacktoo:dropatspawn() return false end

bluemonkeypack = genericbackpack:new({
	health = 200,
	armor = 200,
	grenades = 200,
	nails = 200,
	shells = 200,
	rockets = 200,
	cells = 200,
	respawntime = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	botgoaltype = Bot.kBackPack_Ammo
})

function bluemonkeypack:dropatspawn() return false end

bluemonkeypacktoo = genericbackpack:new({
	health = 20,
	armor = 15,
	grenades = 10,
	nails = 30,
	shells = 30,
	rockets = 10,
	cells = 30,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	botgoaltype = Bot.kBackPack_Ammo
})

function bluemonkeypacktoo:dropatspawn() return false end

redmonkeygrenades = genericbackpack:new({
	detpacks = 1,
	mancannons = 1,
	gren1 = 4,
	gren2 = 4,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kRed},
	respawntime = 30,
	botgoaltype = Bot.kBackPack_Ammo
})

function redmonkeygrenades:dropatspawn() return false end

bluemonkeygrenades = genericbackpack:new({
	detpacks = 1,
	mancannons = 1,
	gren1 = 4,
	gren2 = 4,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kBlue},
	respawntime = 30,
	botgoaltype = Bot.kBackPack_Ammo
})

function bluemonkeygrenades:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_blue_front_door	= location_info:new({ text = "Front Door", team = Team.kBlue })
location_blue_right_front_door	= location_info:new({ text = "Right Front Door", team = Team.kBlue })
location_blue_left_front_door	= location_info:new({ text = "Left Front Door", team = Team.kBlue })
location_blue_ramp_room		= location_info:new({ text = "Great Hall", team = Team.kBlue })
location_blue_T_route		= location_info:new({ text = "'T' Route", team = Team.kBlue })
location_blue_upper_spawn	= location_info:new({ text = "Upper Spawn", team = Team.kBlue })
location_blue_lower_spawn	= location_info:new({ text = "Lower Spawn", team = Team.kBlue })
location_blue_lower_route	= location_info:new({ text = "Lower Route", team = Team.kBlue })
location_blue_water_route	= location_info:new({ text = "Water Route", team = Team.kBlue })
location_blue_flag_room		= location_info:new({ text = "Flag Room", team = Team.kBlue })
location_blue_pit	= location_info:new({ text = "Flag Room Pit", team = Team.kBlue })
location_blue_flag_room_catwalk	= location_info:new({ text = "Flag Room Catwalks", team = Team.kBlue })
location_blue_water_tunnel	= location_info:new({ text = "Water Tunnel", team = Team.kBlue })
location_blue_yard		= location_info:new({ text = "Yard", team = Team.kBlue })

location_red_front_door		= location_info:new({ text = "Front Door", team = Team.kRed })
location_red_right_front_door	= location_info:new({ text = "Right Front Door", team = Team.kRed })
location_red_left_front_door	= location_info:new({ text = "Left Front Door", team = Team.kRed })
location_red_ramp_room		= location_info:new({ text = "Great Hall", team = Team.kRed })
location_red_T_route		= location_info:new({ text = "'T' Route", team = Team.kRed })
location_red_upper_spawn	= location_info:new({ text = "Upper Spawn", team = Team.kRed })
location_red_lower_spawn	= location_info:new({ text = "Lower Spawn", team = Team.kRed })
location_red_lower_route	= location_info:new({ text = "Lower Route", team = Team.kRed })
location_red_water_route	= location_info:new({ text = "Water Route", team = Team.kRed })
location_red_flag_room		= location_info:new({ text = "Flag Room", team = Team.kRed })
location_red_pit	= location_info:new({ text = "Flag Room Pit", team = Team.kRed })
location_red_flag_room_catwalk	= location_info:new({ text = "Flag Room Catwalks", team = Team.kRed })
location_red_water_tunnel	= location_info:new({ text = "Water Tunnel", team = Team.kRed })
location_red_yard		= location_info:new({ text = "Yard", team = Team.kRed })

location_river	= location_info:new({ text = "River", team = Team.kUnassigned })
location_midmap	= location_info:new({ text = "Midmap", team = Team.kUnassigned })
location_bridge	= location_info:new({ text = "Bridge", team = Team.kUnassigned })

-----------------------------------------------------------------------------
-- OFFENSIVE AND DEFENSIVE SPAWNS
-----------------------------------------------------------------------------

red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kDemoman))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false))) end

red_ospawn = { validspawn = red_o_only }
red_dspawn = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kDemoman))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false))) end

blue_ospawn = { validspawn = blue_o_only }
blue_dspawn = { validspawn = blue_d_only }

-----------------------------------------------------------------------------
-- respawn shields
-----------------------------------------------------------------------------

KILL_KILL_KILL = trigger_ff_script:new({ team = Team.kUnassigned })

function KILL_KILL_KILL:allowed( activator )
	local player = CastToPlayer( activator )
	if player then
		if player:GetTeamId() == self.team then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

blue_slayer = KILL_KILL_KILL:new({ team = Team.kBlue })
red_slayer = KILL_KILL_KILL:new({ team = Team.kRed })
