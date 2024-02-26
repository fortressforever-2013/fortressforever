-- ff_destroy.lua
-- caesium 01/2009

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
-- locations
-----------------------------------------------------------------------------
location_redfd = location_info:new({ text = "Foyer", team = Team.kRed })
location_redramp = location_info:new({ text = "Main Ramps", team = Team.kRed })
location_redspawn = location_info:new({ text = "Respawn", team = Team.kRed })
location_redtopramp = location_info:new({ text = "Top Main Ramps", team = Team.kRed })
location_redbalc = location_info:new({ text = "Balcony", team = Team.kRed })
location_redsec = location_info:new({ text = "Security Control", team = Team.kRed })
location_redfr = location_info:new({ text = "Flag Room", team = Team.kRed })
location_redresup = location_info:new({ text = "Resupply", team = Team.kRed })

location_bluefd = location_info:new({ text = "Foyer", team = Team.kBlue })
location_blueramp = location_info:new({ text = "Main Ramps", team = Team.kBlue })
location_bluespawn = location_info:new({ text = "Respawn", team = Team.kBlue })
location_bluetopramp = location_info:new({ text = "Top Main Ramps", team = Team.kBlue })
location_bluebalc = location_info:new({ text = "Balcony", team = Team.kBlue })
location_bluesec = location_info:new({ text = "Security Control", team = Team.kBlue })
location_bluefr = location_info:new({ text = "Flag Room", team = Team.kBlue })
location_blueresup = location_info:new({ text = "Resupply", team = Team.kBlue })

location_midmap = location_info:new({ text = "Outside", team = NO_TEAM })

-----------------------------------------------------------------------------
-- bagless resupply
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
-- security
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
-- lasers and respawn shields
-----------------------------------------------------------------------------
blue_slayer = not_red_trigger:new()
red_slayer = not_blue_trigger:new()
sec_blue_slayer = not_red_trigger:new()
sec_red_slayer = not_blue_trigger:new()

-----------------------------------------------------------------------------
-- custom packs
-----------------------------------------------------------------------------
aardvarkpack_fr = genericbackpack:new({
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

aardvarkpack_ramp = genericbackpack:new({
	health = 50,
	armor = 50,
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

aardvarkpack_sec = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 0,
	gren1 = 1,
	gren2 = 1,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function aardvarkpack_fr:dropatspawn() return false end
function aardvarkpack_ramp:dropatspawn() return false end
function aardvarkpack_sec:dropatspawn() return false end

-----------------------------------------------------------------------------
-- backpack entity setup (modified for aardvarkpacks)
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
		   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf}),
		   aardvarkpack_fr:new({touchflags = tf}),
		   aardvarkpack_ramp:new({touchflags = tf}),
		   aardvarkpack_sec:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack, blue_aardvarkpack_fr, blue_aardvarkpack_ramp, blue_aardvarkpack_sec = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack, red_grenadebackpack, red_aardvarkpack_fr, red_aardvarkpack_ramp, red_aardvarkpack_sec = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})
yellow_healthkit, yellow_armorkit, yellow_ammobackpack, yellow_bigpack, yellow_grenadebackpack, yellow_aardvarkpack_fr, yellow_aardvarkpack_ramp, yellow_aardvarkpack_sec = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kYellow})
green_healthkit, green_armorkit, green_ammobackpack, green_bigpack, green_grenadebackpack, green_aardvarkpack_fr, green_aardvarkpack_ramp, green_aardvarkpack_sec = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kGreen})

-----------------------------------------------------------------------------
-- bouncepads for lifts
-----------------------------------------------------------------------------
base_jump = trigger_ff_script:new({ pushz = 0 })

function base_jump:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		local playerVel = player:GetVelocity()
		playerVel.z = self.pushz
		player:SetVelocity( playerVel )
	end
end

lift_red = base_jump:new({ pushz = 600 })
lift_blue = base_jump:new({ pushz = 600 })