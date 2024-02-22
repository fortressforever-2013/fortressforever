-----------------------------------------------------------------------------------------------------------------------------
-- INCLUDES
-----------------------------------------------------------------------------------------------------------------------------

IncludeScript("base_shutdown");
IncludeScript("base_location");

-----------------------------------------------------------------------------------------------------------------------------
-- CONSTANT!
-- I don't recommend changing this, as the in-game timer (above the FR door) will not change along with it.
-- Behaviour is undefined for values <= 10
-----------------------------------------------------------------------------------------------------------------------------

SECURITY_LENGTH = 40

-----------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------

location_blue_flagroom	= location_info:new({ text = "Flag Room", team = Team.kBlue })
location_blue_window	= location_info:new({ text = "Security Window", team = Team.kBlue })
location_blue_security	= location_info:new({ text = "Security Area", team = Team.kBlue })
location_blue_courtyard	= location_info:new({ text = "Main Courtyard", team = Team.kBlue })
location_blue_rampside	= location_info:new({ text = "Ramp Side", team = Team.kBlue })
location_blue_secside	= location_info:new({ text = "Security Side", team = Team.kBlue })
location_blue_frontdoor	= location_info:new({ text = "Front Door", team = Team.kBlue })
location_blue_water		= location_info:new({ text = "Water Area", team = Team.kBlue })
location_blue_spawn		= location_info:new({ text = "Team Respawn", team = Team.kBlue })

location_red_flagroom	= location_info:new({ text = "Flag Room", team = Team.kRed })
location_red_window		= location_info:new({ text = "Security Window", team = Team.kRed })
location_red_security	= location_info:new({ text = "Security Area", team = Team.kRed })
location_red_courtyard	= location_info:new({ text = "Main Courtyard", team = Team.kRed })
location_red_rampside	= location_info:new({ text = "Ramp Side", team = Team.kRed })
location_red_secside	= location_info:new({ text = "Security Side", team = Team.kRed })
location_red_frontdoor	= location_info:new({ text = "Front Door", team = Team.kRed })
location_red_water		= location_info:new({ text = "Water Area", team = Team.kRed })
location_red_spawn		= location_info:new({ text = "Team Respawn", team = Team.kRed })

location_yard			= location_info:new({ text = "Yard", team = Team.kUnassigned })


-----------------------------------------------------------------------------
-- TOUCH RESUP
-- Brush volume which gives players health, ammo, etc...
-- Pretty much taken from ff_.lua
-----------------------------------------------------------------------------

touch_resup = trigger_ff_script:new({ team = Team.kUnassigned })

function touch_resup:ontouch( touch_entity )
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

blue_touch_resup = touch_resup:new({ team = Team.kBlue })
red_touch_resup = touch_resup:new({ team = Team.kRed })

-----------------------------------------------------------------------------------------------------------------------------
-- WINDOWPACK
-- Team-specific packs which are located near the window where players can throw the flag out.
-----------------------------------------------------------------------------------------------------------------------------

windowpack = genericbackpack:new({
	health = 50,
	armor = 50,
	
	grenades = 200,
	nails = 200,
	shells = 200,
	rockets = 200,
	cells = 130,
	
	gren1 = 0,
	gren2 = 0,
	
	respawntime = 8,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})
function windowpack:dropatspawn() return false end

blue_windowpack = windowpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue } })
red_windowpack = windowpack:new({ touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed } })

-----------------------------------------------------------------------------
-- SPAWN PROTECTION
-- kills those who wander into the enemy spawn
-----------------------------------------------------------------------------

red_spawn_protection = not_red_trigger:new()
blue_spawn_protection = not_blue_trigger:new()

-----------------------------------------------------------------------------
-- OFFENSIVE AND DEFENSIVE SPAWNS
-- Medic, Spy, and Scout spawn in the offensive spawns, other classes spawn in the defensive spawn,
-- Copied from ff_session.lua
-----------------------------------------------------------------------------

red_o_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kEngineer))) end
red_d_only = function(self,player) return ((player:GetTeamId() == Team.kRed) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kEngineer) == false))) end

red_ospawn = { validspawn = red_o_only }
red_dspawn = { validspawn = red_d_only }

blue_o_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and ((player:GetClass() == Player.kScout) or (player:GetClass() == Player.kMedic) or (player:GetClass() == Player.kSpy) or (player:GetClass() == Player.kEngineer))) end
blue_d_only = function(self,player) return ((player:GetTeamId() == Team.kBlue) and (((player:GetClass() == Player.kScout) == false) and ((player:GetClass() == Player.kMedic) == false) and ((player:GetClass() == Player.kSpy) == false) and ((player:GetClass() == Player.kEngineer) == false))) end

blue_ospawn = { validspawn = blue_o_only }
blue_dspawn = { validspawn = blue_d_only }

-----------------------------------------------------------------------------
--  AND THEN, SOME MORE STUFF...
-----------------------------------------------------------------------------

red_window_clip = trigger_ff_clip:new({ clipflags = {
ClipFlags.kClipAllPlayers, ClipFlags.kClipAllProjectiles,
ClipFlags.kClipAllBullets,ClipFlags.kClipAllGrenades } })

blue_window_clip = trigger_ff_clip:new({ clipflags = {
ClipFlags.kClipAllPlayers, ClipFlags.kClipAllProjectiles,
ClipFlags.kClipAllBullets,ClipFlags.kClipAllGrenades } })

red_sec = red_security_trigger:new()
blue_sec = blue_security_trigger:new()

-- utility function for getting the name of the opposite team, 
-- where team is a string, like "red"
local function get_opposite_team(team)
	if team == "red" then return "blue" else return "red" end
end

local security_off_base = security_off
function security_off( team )
	security_off_base( team )

	OpenDoor(team.."_secdoor")
	local opposite_team = get_opposite_team(team)
	OutputEvent("sec_"..opposite_team.."_slayer", "Disable")

	AddSchedule("secup10"..team, SECURITY_LENGTH - 10, function()
		BroadCastMessage("#FF_"..team:upper().."_SEC_10")
	end)
	AddSchedule("beginclose"..team, SECURITY_LENGTH - 6, function()
		CloseDoor(team.."_secdoor")
	end)
end

local security_on_base = security_on
function security_on( team )
	security_on_base( team )

	CloseDoor(team.."_secdoor")
	local opposite_team = get_opposite_team(team)
	OutputEvent("sec_"..opposite_team.."_slayer", "Enable")
end

grp = bigpack:new({
materializesound="Item.Materialize",
gren1=4,gren2=4,model=
"models/items/backpack/backpack.mdl",
respawntime=1,touchsound="Backpack.Touch"})
function grp:dropatspawn() return false end
