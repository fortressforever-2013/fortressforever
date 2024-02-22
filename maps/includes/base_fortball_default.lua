-- base_fortball_default.lua

-- if you want to customize these base fortball defaults, copy all of this file's contents 
-- into your map's lua file, edit what you want, and then include base_fortball.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay");
IncludeScript("base_location");

-- set genericbackpack's disallow touch flags for not letting goalies pick up anything
genericbackpack.disallowtouchflags = {AllowFlags.kCivilian}

-----------------------------------------------------------------------------
-- global overrides
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
			[Player.kCivilian] = 0,
		},
	},
	[TEAM1] = {
		team_name = "blue",
		enemy_team = TEAM2,
		class_limits = {
			[Player.kScout] = 0,
			[Player.kSniper] = -1,
			[Player.kSoldier] = 0,
			[Player.kDemoman] = 0,
			[Player.kMedic] = 0,
			[Player.kHwguy] = 0,
			[Player.kPyro] = 0,
			[Player.kSpy] = 0,
			[Player.kEngineer] = 0,
			[Player.kCivilian] = 1,
		},
	},
	[TEAM2] = {
		team_name = "red",
		enemy_team = TEAM1,
		class_limits = {
			[Player.kScout] = 0,
			[Player.kSniper] = -1,
			[Player.kSoldier] = 0,
			[Player.kDemoman] = 0,
			[Player.kMedic] = 0,
			[Player.kHwguy] = 0,
			[Player.kPyro] = 0,
			[Player.kSpy] = 0,
			[Player.kEngineer] = 0,
			[Player.kCivilian] = 1,
		},
	},
}

-- objectives
objective_entities = { [TEAM1] = nil, [TEAM2] = nil }
goal_entities = { [TEAM1] = nil, [TEAM2] = nil }
ball_carrier = nil
BALL_ALWAYS_ENEMY_OBJECTIVE = true

-- scoring
POINTS_PER_GOAL = 10
POINTS_PER_INITIALTOUCH = 100
POINTS_PER_GOALIE_RETURN = 50
POINTS_PER_GOALIE_ATTACK = 10
BALL_RETURN_TIME = 15
BALL_THROW_SPEED = 2048
GOALIE_SPEED = 2.0
THE_WALL_TIMER_DISABLE = 12.5
THE_WALL_TIMER_WARN = 2.5

-- goalie sounds
goalie_sound_loop = "ff_waterpolo.psychotic_goalie"
goalie_sound_idle = "NPC_BlackHeadcrab.Talk"
goalie_sound_pain = "NPC_BlackHeadcrab.ImpactAngry"
goalie_sound_kill = "NPC_BlackHeadcrab.Telegraph"

