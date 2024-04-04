-- ff_aardvark.lua

-----------------------------------------------------------------------------
-- number of snipers allowed per team
-----------------------------------------------------------------------------
SNIPER_LIMIT = 1;

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_shutdown");
IncludeScript("base_location");
-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10;
FLAG_RETURN_TIME = 60;
SECURITY_LENGTH = 30;

-----------------------------------------------------------------------------
-- unique aardvark locations
-----------------------------------------------------------------------------
location_redspawn = location_info:new({ text = "Respawn", team = Team.kRed })
location_redsec = location_info:new({ text = "Laser Control", team = Team.kRed })
location_redfr = location_info:new({ text = "Flag Room", team = Team.kRed })
location_redgen = location_info:new({ text = "Generator Room", team = Team.kRed })
location_redbasement = location_info:new({ text = "Basement", team = Team.kRed })
location_redwater = location_info:new({ text = "Perilous Passage", team = Team.kRed })
location_redcor = location_info:new({ text = "Utility Corridors", team = Team.kRed })
location_redlift = location_info:new({ text = "Lift", team = Team.kRed })
location_redfd = location_info:new({ text = "Front Door", team = Team.kRed })
location_redramp = location_info:new({ text = "Top Main Ramp", team = Team.kRed })
location_redrampon = location_info:new({ text = "Main Ramp", team = Team.kRed })
location_redhallspawn = location_info:new({ text = "Respawn-Side Hallway", team = Team.kRed })
location_redhallwater = location_info:new({ text = "Lift-Side Hallway", team = Team.kRed })
location_redtoilet = location_info:new({ text = "Toilet", team = Team.kRed })
location_redshame = location_info:new({ text = "Tunnel of Shame", team = Team.kRed })
location_redoven = location_info:new({ text = "OVEN", team = Team.kRed })

location_bluespawn = location_info:new({ text = "Respawn", team = Team.kBlue })
location_bluesec = location_info:new({ text = "Laser Control", team = Team.kBlue })
location_bluefr = location_info:new({ text = "Flag Room", team = Team.kBlue })
location_bluegen = location_info:new({ text = "Generator Room", team = Team.kBlue })
location_bluebasement = location_info:new({ text = "Basement", team = Team.kBlue })
location_bluewater = location_info:new({ text = "Perilous Passage", team = Team.kBlue })
location_bluecor = location_info:new({ text = "Utility Corridors", team = Team.kBlue })
location_bluelift = location_info:new({ text = "Lift", team = Team.kBlue })
location_bluefd = location_info:new({ text = "Front Door", team = Team.kBlue })
location_blueramp = location_info:new({ text = "Top Main Ramp", team = Team.kBlue })
location_bluerampon = location_info:new({ text = "Main Ramp", team = Team.kBlue })
location_bluehallspawn = location_info:new({ text = "Respawn-Side Hallway", team = Team.kBlue })
location_bluehallwater = location_info:new({ text = "Lift-Side Hallway", team = Team.kBlue })
location_bluetoilet = location_info:new({ text = "Toilet", team = Team.kBlue })
location_blueshame = location_info:new({ text = "Tunnel of Shame", team = Team.kBlue })
location_blueoven = location_info:new({ text = "OVEN", team = Team.kBlue })

location_midmap = location_info:new({ text = "Outside", team = NO_TEAM })

-----------------------------------------------------------------------------
-- set class limits
-----------------------------------------------------------------------------
local startup_base = startup or function() end
function startup()
	startup_base()

	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kSniper, SNIPER_LIMIT)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kSniper, SNIPER_LIMIT)
end

-----------------------------------------------------------------------------
-- custom aardvark packs
-----------------------------------------------------------------------------
aardvarkpack = genericbackpack:new({
	health = 60,
	armor = 60,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 0,
	gren1 = 1,
	gren2 = 1,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

aardvarkpack_metal = genericbackpack:new({
	health = 0,
	armor = 0,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	respawntime = 6,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function aardvarkpack:dropatspawn() return false end
function aardvarkpack_metal:dropatspawn() return false end

-----------------------------------------------------------------------------
-- backpack entity setup (modified for aardvarkpack)
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
		   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf}),
		   aardvarkpack:new({touchflags = tf}),
		   aardvarkpack_metal:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack, blue_aardvarkpack, blue_aardvarkpack_metal = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack ,red_grenadebackpack, red_aardvarkpack, red_aardvarkpack_metal = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})
yellow_healthkit, yellow_armorkit, yellow_ammobackpack, yellow_bigpack, yellow_grenadebackpack, yellow_aardvarkpack, yellow_aardvarkpack_metal = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kYellow})
green_healthkit, green_armorkit, green_ammobackpack, green_bigpack, green_grenadebackpack, green_aardvarkpack, green_aardvarkpack_metal = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kGreen})

-----------------------------------------------------------------------------
-- aardvark resupply (bagless)
-----------------------------------------------------------------------------
aardvarkresup = trigger_ff_script:new({ team = Team.kUnassigned })

function aardvarkresup:ontouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		if player:GetTeamId() == self.team then
			player:AddHealth( 400 )
			player:AddArmor( 400 )
			player:AddAmmo( Ammo.kNails, 400 )
			player:AddAmmo( Ammo.kShells, 400 )
			player:AddAmmo( Ammo.kRockets, 400 )
			player:AddAmmo( Ammo.kCells, 400 )
		end
	end
end

blue_aardvarkresup = aardvarkresup:new({ team = Team.kBlue })
red_aardvarkresup = aardvarkresup:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- aardvark security
-----------------------------------------------------------------------------
red_aardvarksec = red_security_trigger:new()
blue_aardvarksec = blue_security_trigger:new()

-- utility function for getting the name of the opposite team, 
-- where team is a string, like "red"
local function get_opposite_team(team)
	if team == "red" then return "blue" else return "red" end
end

local security_off_base = security_off
function security_off( team )
	security_off_base( team )

	OpenDoor(team.."_aardvarkdoorhack")
	local opposite_team = get_opposite_team(team)
	OutputEvent("sec_"..opposite_team.."_slayer", "Disable")

	AddSchedule("secup10"..team, SECURITY_LENGTH - 10, function()
		BroadCastMessage("#FF_"..team:upper().."_SEC_10")
	end)
end

local security_on_base = security_on
function security_on( team )
	security_on_base( team )

	CloseDoor(team.."_aardvarkdoorhack")
	local opposite_team = get_opposite_team(team)
	OutputEvent("sec_"..opposite_team.."_slayer", "Enable")
end

-----------------------------------------------------------------------------
-- respawn shields
-----------------------------------------------------------------------------
blue_slayer = not_red_trigger:new()
red_slayer = not_blue_trigger:new()
sec_blue_slayer = not_red_trigger:new()
sec_red_slayer = not_blue_trigger:new()

