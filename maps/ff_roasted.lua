-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base_shutdown");

-----------------------------------------------------------------------------
-- custom packs   > modified from aardvark
-----------------------------------------------------------------------------
roasted_fr = genericbackpack:new({
	health = 0,
	armor = 0,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	gren1 = 0,
	gren2 = 0,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

roasted_upper = genericbackpack:new({
	health = 30,
	armor = 30,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

roasted_top = genericbackpack:new({
	health = 40,
	armor = 40,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 50,
	gren1 = 1,
	gren2 = 1,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

roasted_resup = genericbackpack:new({
	health = 100,
	armor = 300,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 200,
	gren1 = 0,
	gren2 = 0,
	respawntime = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function roasted_fr:dropatspawn() return false end
function roasted_upper:dropatspawn() return false end
function roasted_top:dropatspawn() return false end
function roasted_resup:dropatspawn() return false end

-----------------------------------------------------------------------------
-- backpack entity setup (modified for aardvarkpacks)
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
		   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf}),
		   roasted_fr:new({touchflags = tf}),
		   roasted_upper:new({touchflags = tf}),
		   roasted_top:new({touchflags = tf}),
		   roasted_resup:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack, blue_roasted_fr, blue_roasted_upper, blue_roasted_top, blue_roasted_resup = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack, red_grenadebackpack, red_roasted_fr, red_roasted_upper, red_roasted_top, red_roasted_resup = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})
yellow_healthkit, yellow_armorkit, yellow_ammobackpack, yellow_bigpack, yellow_grenadebackpack, yellow_roasted_fr, yellow_roasted_upper, yellow_roasted_top, yellow_roasted_resup = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kYellow})
green_healthkit, green_armorkit, green_ammobackpack, green_bigpack, green_grenadebackpack, green_roasted_fr, green_roasted_upper, green_roasted_top, green_roasted_resup = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kGreen})


-----------------------------------------------------------------------------
-- OFFENSIVE AND DEFENSIVE SPAWNS
-- Medic, Spy, and Scout spawn in the offensive spawns, other classes spawn in the defensive spawn,
-- Copied from ff_session.lua
-----------------------------------------------------------------------------

red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false))) end

red_ospawn = { validspawn = red_o_only }
red_dspawn = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false))) end

blue_ospawn = { validspawn = blue_o_only }
blue_dspawn = { validspawn = blue_d_only }


-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_midmap = location_info:new({ text = "Midmap", team = Team.kUnassigned })
location_water = location_info:new({ text = "Water", team = Team.kUnassigned })

location_blue_balcony = location_info:new({ text = "Balcony", team = Team.kBlue })
location_red_balcony = location_info:new({ text = "Balcony", team = Team.kRed })

location_blue_frontdoor = location_info:new({ text = "Front Door", team = Team.kBlue })
location_red_frontdoor = location_info:new({ text = "Front Door", team = Team.kRed })

location_blue_flagroom = location_info:new({ text = "Flag Room", team = Team.kBlue })
location_red_flagroom = location_info:new({ text = "Flag Room", team = Team.kRed })

location_blue_ramproom = location_info:new({ text = "Ramp Room", team = Team.kBlue })
location_red_ramproom = location_info:new({ text = "Ramp Room", team = Team.kRed })

location_blue_lower = location_info:new({ text = "Lower Level", team = Team.kBlue })
location_red_lower = location_info:new({ text = "Lower Level", team = Team.kRed })

location_blue_upper = location_info:new({ text = "Upper Level", team = Team.kBlue })
location_red_upper = location_info:new({ text = "Upper Level", team = Team.kRed })

location_blue_spawn = location_info:new({ text = "Respawn", team = Team.kBlue })
location_red_spawn = location_info:new({ text = "Respawn", team = Team.kRed })

location_blue_T = location_info:new({ text = "T Junction", team = Team.kBlue })
location_red_T = location_info:new({ text = "T Junction", team = Team.kRed })

location_blue_water_entry = location_info:new({ text = "Water Entrance", team = Team.kBlue })
location_red_water_entry = location_info:new({ text = "Water Entrance", team = Team.kRed })

location_blue_water_tunnel = location_info:new({ text = "Water Tunnel", team = Team.kBlue })
location_red_water_tunnel = location_info:new({ text = "Water Tunnel", team = Team.kRed })

