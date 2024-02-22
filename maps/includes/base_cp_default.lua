-- base_cp_default.lua

-- if you want to customize these base cp defaults, copy all of this file's contents 
-- into your map's lua file, edit what you want, and then include base_cp.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- globals
-----------------------------------------------------------------------------


-- teams
TEAM1 = Team.kBlue
TEAM2 = Team.kRed
DISABLED_TEAM3 = Team.kYellow
DISABLED_TEAM4 = Team.kGreen

teams = { TEAM1, TEAM2 }
disabled_teams = { DISABLED_TEAM3, DISABLED_TEAM4 }

team_info = {

	[Team.kUnassigned] = {
		team_name = "neutral",
		enemy_team = Team.kUnassigned,
		touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen },
		skybeam_color = "128 128 128",
		respawnbeam_color = { [0] = 100, [1] = 100, [2] = 100 },
		color_index = 1,
		skin = "0",
		flag_visibility = "TurnOff",
		cc_touch_count = 0,
		ccalarmicon = "hud_secdown.vtf", ccalarmiconx = 0, ccalarmicony = 0, ccalarmiconwidth = 16, ccalarmiconheight = 16, ccalarmiconalign = 2,
		detcc_sentence = "HTD_DOORS",
		class_limits = {
			[Player.kScout] = 0,
			[Player.kSniper] = 0,
			[Player.kSoldier] = 0,
			[Player.kDemoman] = 0,
			[Player.kMedic] = 0,
			[Player.kHwguy] = 0,
			[Player.kPyro] = 0,
			[Player.kSpy] = 0,
			[Player.kEngineer] = 0,
			[Player.kCivilian] = -1,
		}
	},

	[TEAM1] = {
		team_name = "blue",
		enemy_team = TEAM2,
		touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue },
		skybeam_color = "64 64 255",
		respawnbeam_color = { [0] = 100, [1] = 100, [2] = 100 },
		color_index = 2,
		skin = "0",
		flag_visibility = "TurnOn",
		cc_touch_count = 0,
		ccalarmicon = "hud_secup_blue.vtf", ccalarmiconx = 60, ccalarmicony = 5, ccalarmiconwidth = 16, ccalarmiconheight = 16, ccalarmiconalign = 2,
		detcc_sentence = "CZ_BCC_DET",
		class_limits = {
			[Player.kScout] = 0,
			[Player.kSniper] = 0,
			[Player.kSoldier] = 0,
			[Player.kDemoman] = 0,
			[Player.kMedic] = 0,
			[Player.kHwguy] = 0,
			[Player.kPyro] = 0,
			[Player.kSpy] = 0,
			[Player.kEngineer] = 0,
			[Player.kCivilian] = -1,
		}
	},

	[TEAM2] = {
		team_name = "red",
		enemy_team = TEAM1,
		touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed },
		skybeam_color = "255 64 64",
		respawnbeam_color = { [0] = 100, [1] = 100, [2] = 100 },
		color_index = 0,
		skin = "1",
		flag_visibility = "TurnOn",
		cc_touch_count = 0,
		ccalarmicon = "hud_secup_red.vtf", ccalarmiconx = 60, ccalarmicony = 5, ccalarmiconwidth = 16, ccalarmiconheight = 16, ccalarmiconalign = 3,
		detcc_sentence = "CZ_RCC_DET",
		class_limits = {
			[Player.kScout] = 0,
			[Player.kSniper] = 0,
			[Player.kSoldier] = 0,
			[Player.kDemoman] = 0,
			[Player.kMedic] = 0,
			[Player.kHwguy] = 0,
			[Player.kPyro] = 0,
			[Player.kSpy] = 0,
			[Player.kEngineer] = 0,
			[Player.kCivilian] = -1,
		}
	}
}


-- command points
CP_COUNT = 5

command_points = {
		[1] = { cp_number = 1, defending_team = Team.kUnassigned, cap_requirement = { [TEAM1] = 1000, [TEAM2] = 1000 }, cap_status = { [TEAM1] = 0, [TEAM2] = 0 }, cap_speed = { [TEAM1] = 0, [TEAM2] = 0 }, next_cap_zone_timer = { [TEAM1] = 0, [TEAM2] = 0 }, delay_before_retouch = { [TEAM1] = 4.0, [TEAM2] = 4.0 }, touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, former_touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, point_value = { [TEAM1] = 1, [TEAM2] = 5 }, score_timer_interval = { [TEAM1] = 30.00, [TEAM2] = 15.00 }, hudstatusicon = "hud_cp_1.vtf", hudposx = -40, hudposy = 56, hudalign = 4, hudwidth = 16, hudheight = 16 },
		[2] = { cp_number = 2, defending_team = Team.kUnassigned, cap_requirement = { [TEAM1] = 1000, [TEAM2] = 1000 }, cap_status = { [TEAM1] = 0, [TEAM2] = 0 }, cap_speed = { [TEAM1] = 0, [TEAM2] = 0 }, next_cap_zone_timer = { [TEAM1] = 0, [TEAM2] = 0 }, delay_before_retouch = { [TEAM1] = 4.0, [TEAM2] = 4.0 }, touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, former_touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, point_value = { [TEAM1] = 2, [TEAM2] = 4 }, score_timer_interval = { [TEAM1] = 26.25, [TEAM2] = 18.75 }, hudstatusicon = "hud_cp_2.vtf", hudposx = -20, hudposy = 56, hudalign = 4, hudwidth = 16, hudheight = 16 },
		[3] = { cp_number = 3, defending_team = Team.kUnassigned, cap_requirement = { [TEAM1] = 1000, [TEAM2] = 1000 }, cap_status = { [TEAM1] = 0, [TEAM2] = 0 }, cap_speed = { [TEAM1] = 0, [TEAM2] = 0 }, next_cap_zone_timer = { [TEAM1] = 0, [TEAM2] = 0 }, delay_before_retouch = { [TEAM1] = 4.0, [TEAM2] = 4.0 }, touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, former_touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, point_value = { [TEAM1] = 3, [TEAM2] = 3 }, score_timer_interval = { [TEAM1] = 22.50, [TEAM2] = 22.50 }, hudstatusicon = "hud_cp_3.vtf", hudposx =   0, hudposy = 56, hudalign = 4, hudwidth = 16, hudheight = 16 },
		[4] = { cp_number = 4, defending_team = Team.kUnassigned, cap_requirement = { [TEAM1] = 1000, [TEAM2] = 1000 }, cap_status = { [TEAM1] = 0, [TEAM2] = 0 }, cap_speed = { [TEAM1] = 0, [TEAM2] = 0 }, next_cap_zone_timer = { [TEAM1] = 0, [TEAM2] = 0 }, delay_before_retouch = { [TEAM1] = 4.0, [TEAM2] = 4.0 }, touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, former_touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, point_value = { [TEAM1] = 4, [TEAM2] = 2 }, score_timer_interval = { [TEAM1] = 18.75, [TEAM2] = 26.25 }, hudstatusicon = "hud_cp_4.vtf", hudposx =  20, hudposy = 56, hudalign = 4, hudwidth = 16, hudheight = 16 },
	 [CP_COUNT] = { cp_number = 5, defending_team = Team.kUnassigned, cap_requirement = { [TEAM1] = 1000, [TEAM2] = 1000 }, cap_status = { [TEAM1] = 0, [TEAM2] = 0 }, cap_speed = { [TEAM1] = 0, [TEAM2] = 0 }, next_cap_zone_timer = { [TEAM1] = 0, [TEAM2] = 0 }, delay_before_retouch = { [TEAM1] = 4.0, [TEAM2] = 4.0 }, touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, former_touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, point_value = { [TEAM1] = 5, [TEAM2] = 1 }, score_timer_interval = { [TEAM1] = 15.00, [TEAM2] = 30.00 }, hudstatusicon = "hud_cp_5.vtf", hudposx =  40, hudposy = 56, hudalign = 4, hudwidth = 16, hudheight = 16 }
}


-- scoring
POINTS_FOR_COMPLETE_CONTROL = 100
CC_DESTROY_POINTS = 15


-- zones
CAP_ZONE_TIMER_INTERVAL = 0.2
CAP_ZONE_NOTOUCH_SPEED = 10
PLAYER_TOUCHING_CP_ZONE = {}
ENTITY_TOUCHING_CC = {}


-- flags
ENABLE_FLAGS = false
FLAG_CARRIER_SPEED = 0.75
FLAG_RETURN_TIME = 0
flags = { team_info[TEAM1].team_name .. "_flag", team_info[TEAM2].team_name .. "flag" }


-- teleporting
ENABLE_CC_TELEPORTERS = true
ENABLE_CP_TELEPORTERS = true


-- command center
ENABLE_CC = true


-- complete control
ENABLE_COMPLETE_CONTROL_POINTS = true
ENABLE_COMPLETE_CONTROL_RESET = true
ENABLE_COMPLETE_CONTROL_RESPAWN = true
COMPLETE_CONTROL_RESPAWN_DELAY = 1


-- door names (prefixes will automatically be added based on the trigger's team)
doors = { "_flagroom_door_top" , "_flagroom_door_bottom", "_base_door_01_left", "_base_door_01_right", "_base_door_02_left", "_base_door_02_right" }


-- cp capture sounds
good_cap_sounds = {
	[1] = "CZ_GOTCP1",
	[2] = "CZ_GOTCP2",
	[3] = "CZ_GOTCP3",
	[4] = "CZ_GOTCP4",
	[5] = "CZ_GOTCP5"
}
bad_cap_sounds = {
	[1] = "CZ_LOSTCP1",
	[2] = "CZ_LOSTCP2",
	[3] = "CZ_LOSTCP3",
	[4] = "CZ_LOSTCP4",
	[5] = "CZ_LOSTCP5"
}


-- cp status background icons
icons = {
	[TEAM1] = { teamicon = "hud_cp_" .. team_info[TEAM1].team_name .. ".vtf", lockicon = "hud_cp_locked.vtf" },
	[TEAM2] = { teamicon = "hud_cp_" .. team_info[TEAM2].team_name .. ".vtf", lockicon = "hud_cp_locked.vtf" },
	[Team.kUnassigned] = { teamicon = "hud_cp_neutral.vtf" }
}


-- cp cap status icons
cp_zone_icons = {
	[TEAM1] = { hudicon = "hud_flag_" .. team_info[TEAM1].team_name .. ".vtf", hudx = 5, hudy = 162, hudwidth = 48, hudheight = 48, hudalign = 1, hudposy_offset = -20 },
	[TEAM2] =  { hudicon =  "hud_flag_" .. team_info[TEAM2].team_name .. ".vtf", hudx = 5, hudy = 162, hudwidth = 48, hudheight = 48, hudalign = 1, hudposy_offset =  20 }
}


-- All of the CP ammo and armor (mainly used for removing all ammo and armor when command points reset)
cp_ammo_and_armor_names = {
	"cp_cp1_ammo",
	"cp_cp2_ammo",
	"cp_cp3_ammo",
	"cp_cp4_ammo",
	"cp_cp5_ammo",

	-- backwards compatiblity - use "cp_*" names in your map instead!
	"cz2_cp1_ammo",
	"cz2_cp2_ammo",
	"cz2_cp3_ammo",
	"cz2_cp4_ammo",
	"cz2_cp5_ammo",

	"cp_cp1_armor",
	"cp_cp2_armor",
	"cp_cp3_armor",
	"cp_cp4_armor",
	"cp_cp5_armor",

	-- backwards compatiblity - use "cp_*" names in your map instead!
	"cz2_cp1_armor",
	"cz2_cp2_armor",
	"cz2_cp3_armor",
	"cz2_cp4_armor",
	"cz2_cp5_armor",
}

cap_resupply = {
	health = 100,
	armor = 100,
	nails = 100,
	shells = 100,
	cells = 100,
	grenades = 50,
	rockets = 50,
	detpacks = 0,
	mancannons = 1,
	gren1 = 2,
	gren2 = 1
}

