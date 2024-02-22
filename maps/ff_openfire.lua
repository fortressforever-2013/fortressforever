-- ff_openfire.lua
-- based on aardvark 15/09/07

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
-- unique openfire locations
-----------------------------------------------------------------------------
location_redspawn = location_info:new({ text = "Respawn", team = Team.kRed })
location_redsec = location_info:new({ text = "Fire Control", team = Team.kRed })
location_redfr = location_info:new({ text = "Flag Room", team = Team.kRed })
location_redwater = location_info:new({ text = "Perilous Passage", team = Team.kRed })
location_redfrontdoor = location_info:new({ text = "Front Door Corridor", team = Team.kRed })
location_redbalcony = location_info:new({ text = "Balcony", team = Team.kRed })

location_bluespawn = location_info:new({ text = "Respawn", team = Team.kBlue })
location_bluesec = location_info:new({ text = "Fire Control", team = Team.kBlue })
location_bluefr = location_info:new({ text = "Flag Room", team = Team.kBlue })
location_bluewater = location_info:new({ text = "Perilous Passage", team = Team.kBlue })
location_bluefrontdoor = location_info:new({ text = "Front Door Corridor", team = Team.kBlue })
location_bluebalcony = location_info:new({ text = "Balcony", team = Team.kBlue })

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
-- custom openfire pack
-----------------------------------------------------------------------------
aardvarkpack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 400,
	nails = 400,
	shells = 400,
	rockets = 400,
	cells = 130,
	respawntime = 8,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function aardvarkpack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- backpack entity setup (modified for aardvarkpack)
-----------------------------------------------------------------------------
function build_backpacks(tf)
	return healthkit:new({touchflags = tf}),
		   armorkit:new({touchflags = tf}),
		   ammobackpack:new({touchflags = tf}),
		   bigpack:new({touchflags = tf}),
		   grenadebackpack:new({touchflags = tf}),
		   aardvarkpack:new({touchflags = tf})
end

blue_healthkit, blue_armorkit, blue_ammobackpack, blue_bigpack, blue_grenadebackpack, blue_aardvarkpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kBlue})
red_healthkit, red_armorkit, red_ammobackpack, red_bigpack ,red_grenadebackpack, red_aardvarkpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kRed})
yellow_healthkit, yellow_armorkit, yellow_ammobackpack, yellow_bigpack, yellow_grenadebackpack, yellow_aardvarkpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kYellow})
green_healthkit, green_armorkit, green_ammobackpack, green_bigpack, green_grenadebackpack, green_aardvarkpack = build_backpacks({AllowFlags.kOnlyPlayers,AllowFlags.kGreen})

-----------------------------------------------------------------------------
-- SPAWNS
-----------------------------------------------------------------------------
red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kSniper))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kSniper) == false))) end

redspawn_balc = { validspawn = red_o_only }
redspawn_fr = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kSniper))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kSniper) == false))) end

bluespawn_balc = { validspawn = blue_o_only }
bluespawn_fr = { validspawn = blue_d_only }
