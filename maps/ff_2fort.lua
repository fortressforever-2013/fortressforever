IncludeScript("base_ctf");
IncludeScript("base_location");
IncludeScript("base_respawnturret");

-----------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-- Q: wow clover, there sure are alot of them!
-- A: hell yes there are.
-----------------------------------------------------------------------------------------------------------------------------
blue_location_ulobby	= location_info:new({ text = "Upper Lobby", team = Team.kBlue })
blue_location_llobby	= location_info:new({ text = "Lower Lobby", team = Team.kBlue })
blue_location_ch	= location_info:new({ text = "Covered Hallway", team = Team.kBlue })
blue_location_bspawn	= location_info:new({ text = "Battlements Spawn", team = Team.kBlue })
blue_location_lspawn	= location_info:new({ text = "Lobby Spawn", team = Team.kBlue })
blue_location_rr	= location_info:new({ text = "#FF_LOCATION_RAMPROOM", team = Team.kBlue })
blue_location_crates	= location_info:new({ text = "Crate Tunnel", team = Team.kBlue })
blue_location_ulift	= location_info:new({ text = "Upper Elevator Room", team = Team.kBlue })
blue_location_llift	= location_info:new({ text = "Lower Elevator Room", team = Team.kBlue })
blue_location_cod	= location_info:new({ text = "Corner of Eternal Despair", team = Team.kBlue })
blue_location_fd	= location_info:new({ text = "#FF_LOCATION_FRONTDOOR", team = Team.kBlue })
blue_location_grate	= location_info:new({ text = "Grate Room", team = Team.kBlue })
blue_location_uspiral	= location_info:new({ text = "Upper Spiral", team = Team.kBlue })
blue_location_mspiral	= location_info:new({ text = "Mid Spiral", team = Team.kBlue })
blue_location_lspiral	= location_info:new({ text = "Lower Spiral", team = Team.kBlue })
blue_location_waccess 	= location_info:new({ text = "Water Access", team = Team.kBlue })
blue_location_wtunnel 	= location_info:new({ text = "Water Tunnel", team = Team.kBlue })
blue_location_bfr	= location_info:new({ text = "Basement - Flagroom", team = Team.kBlue })
blue_location_bsteam	= location_info:new({ text = "Basement - Steam Corridor", team = Team.kBlue })
blue_location_bmf	= location_info:new({ text = "Basement - Mainframe", team = Team.kBlue })
blue_location_blobby	= location_info:new({ text = "Basement - Lobby", team = Team.kBlue })
blue_location_blift 	= location_info:new({ text = "Basement - Elevator Side", team = Team.kBlue })
blue_location_bresup 	= location_info:new({ text = "Basement - Resupply", team = Team.kBlue })
blue_location_batts 	= location_info:new({ text = "#FF_LOCATION_BATTLEMENTS", team = Team.kBlue })

neutral_location_yard	= location_info:new({ text = "#FF_LOCATION_YARD", team = Team.kUnassigned })
neutral_location_ywater	= location_info:new({ text = "Yard - Water", team = Team.kUnassigned })

red_location_ulobby	= location_info:new({ text = "Upper Lobby", team = Team.kRed })
red_location_llobby	= location_info:new({ text = "Lower Lobby", team = Team.kRed })
red_location_ch		= location_info:new({ text = "Covered Hallway", team = Team.kRed })
red_location_bspawn	= location_info:new({ text = "Battlements Spawn", team = Team.kRed })
red_location_lspawn	= location_info:new({ text = "Lobby Spawn", team = Team.kRed })
red_location_rr		= location_info:new({ text = "#FF_LOCATION_RAMPROOM", team = Team.kRed })
red_location_crates	= location_info:new({ text = "Crate Tunnel", team = Team.kRed })
red_location_ulift	= location_info:new({ text = "Upper Elevator Room", team = Team.kRed })
red_location_llift	= location_info:new({ text = "Lower Elevator Room", team = Team.kRed })
red_location_cod	= location_info:new({ text = "Corner of Eternal Despair", team = Team.kRed })
red_location_fd		= location_info:new({ text = "#FF_LOCATION_FRONTDOOR", team = Team.kRed })
red_location_grate	= location_info:new({ text = "Grate Room", team = Team.kRed })
red_location_uspiral	= location_info:new({ text = "Upper Spiral", team = Team.kRed })
red_location_mspiral	= location_info:new({ text = "Mid Spiral", team = Team.kRed })
red_location_lspiral	= location_info:new({ text = "Lower Spiral", team = Team.kRed })
red_location_waccess 	= location_info:new({ text = "Water Access", team = Team.kRed })
red_location_wtunnel 	= location_info:new({ text = "Water Tunnel", team = Team.kRed })
red_location_bfr	= location_info:new({ text = "Basement - Flagroom", team = Team.kRed })
red_location_bsteam	= location_info:new({ text = "Basement - Steam Corridor", team = Team.kRed })
red_location_bmf	= location_info:new({ text = "Basement - Mainframe", team = Team.kRed })
red_location_blobby	= location_info:new({ text = "Basement - Lobby", team = Team.kRed })
red_location_blift 	= location_info:new({ text = "Basement - Elevator Side", team = Team.kRed })
red_location_bresup 	= location_info:new({ text = "Basement - Resupply", team = Team.kRed })
red_location_batts 	= location_info:new({ text = "#FF_LOCATION_BATTLEMENTS", team = Team.kRed })

-----------------------------------------------------------------------------------------------------------------------------
-- bag for respawns
-----------------------------------------------------------------------------------------------------------------------------
ff_2fort_genericpack = genericbackpack:new({
	health = 400,
	armor = 400,
	
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 400,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 2,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_2fort_genericpack:dropatspawn() return false end
blue_2fort_genericpack = ff_2fort_genericpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_2fort_genericpack = ff_2fort_genericpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

-----------------------------------------------------------------------------------------------------------------------------
-- grenpack
-----------------------------------------------------------------------------------------------------------------------------
ff_2fort_grenpack = genericbackpack:new({
	health = 0,
	armor = 0,
	
	grenades = 0,
	nails = 0,
	shells = 0,
	rockets = 0,
	cells = 0,
	
	gren1 = 2,
	gren2 = 2,
	
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_2fort_grenpack:dropatspawn() return false end
blue_2fort_grenpack = ff_2fort_grenpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_2fort_grenpack = ff_2fort_grenpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

-----------------------------------------------------------------------------------------------------------------------------
-- bag by water exit that anyone can use
-----------------------------------------------------------------------------------------------------------------------------
ff_2fort_waterpack = genericbackpack:new({
	health = 50,
	armor = 50,
	
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 80,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_2fort_waterpack:dropatspawn() return false end
blue_2fort_waterpack = ff_2fort_waterpack:new({})
red_2fort_waterpack = ff_2fort_waterpack:new({})

-----------------------------------------------------------------------------------------------------------------------------
-- bag used in mid spiral and bottom lift resupply to stagger resources
-- tweak the respawntime of this bag to control offence/defence balance
-----------------------------------------------------------------------------------------------------------------------------
ff_2fort_spiralpack = genericbackpack:new({
	health = 50,
	armor = 50,
	
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function ff_2fort_spiralpack:dropatspawn() return false end
blue_2fort_spiralpack = ff_2fort_spiralpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_2fort_spiralpack = ff_2fort_spiralpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

-----------------------------------------------------------------------------
-- SPAWNS
-----------------------------------------------------------------------------
red_spiral = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSniper) or (player:GetClass() == Player.kSpy))) end
red_balc = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSniper) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kSoldier) or (player:GetClass() == Player.kHwguy) or (player:GetClass() == Player.kDemoman) or (player:GetClass() == Player.kPyro) or (player:GetClass() == Player.kEngineer))) end

red_spiralspawn = { validspawn = red_spiral }
red_balcspawn = { validspawn = red_balc }

blue_spiral = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSniper) or (player:GetClass() == Player.kSpy))) end
blue_balc = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSniper) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kSoldier) or (player:GetClass() == Player.kHwguy) or (player:GetClass() == Player.kDemoman) or (player:GetClass() == Player.kPyro) or (player:GetClass() == Player.kEngineer))) end

blue_spiralspawn = { validspawn = blue_spiral }
blue_balcspawn = { validspawn = blue_balc }
