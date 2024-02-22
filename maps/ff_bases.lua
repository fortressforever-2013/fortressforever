-- ff_bases.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base")
IncludeScript("base_ctf")
IncludeScript("base_location")
IncludeScript("base_respawnturret")
-----------------------------------------------------------------------------

function precache()
	PrecacheSound( "Backpack.Touch" )
	PrecacheSound( "misc.thunder" )
end

-----------------------------------------------------------------------------
-- Doors
-----------------------------------------------------------------------------
blue_only = bluerespawndoor
red_only = redrespawndoor


-----------------------------------------------------------------------------
-- Computer Explodeded
-----------------------------------------------------------------------------
fr_computer = trigger_ff_script:new({ team = Team.kUnassigned })
function fr_computer:onexplode( explosion_entity )
	if IsDetpack( explosion_entity ) then
		local detpack = CastToDetpack(explosion_entity)
		if detpack:GetTeamId() ~= self.team then
			local points = 5
			local team = detpack:GetTeam()
			team:AddScore(points)

			local player = detpack:GetOwner()
			player:AddFortPoints(points * 100, "Destroyed Computer" )

			SmartSound(player, "misc.thunder", "misc.thunder", "misc.thunder")
			SmartMessage(player, "You Destroyed the Enemy Command Centre!", "Your Team Destroyed the Enemy Command Centre!", "Your Command Centre has been Destroyed!")

			if team:GetTeamId() == Team.kBlue then
				SpeakAll( "CZ_RCC_DET" )
			elseif team:GetTeamId() == Team.kRed then
				SpeakAll( "CZ_BCC_DET" )
			end
		end
	end

	return EVENT_ALLOWED
end

blue_computer = fr_computer:new({ team = Team.kBlue })
red_computer = fr_computer:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- Backpacks
-----------------------------------------------------------------------------
blue_gen_pack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 0,
	nails = 300,
	shells = 300,
	rockets = 300,
	gren1 = 1,
	gren2 = 0,
	cells = 130,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}})

blue_fr_gen_pack = genericbackpack:new({
	health = 30,
	armor = 30,
	grenades = 0,
	nails = 300,
	shells = 300,
	rockets = 300,
	gren1 = 0,
	gren2 = 0,
	cells = 130,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}})
	
red_gen_pack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 0,
	nails = 300,
	shells = 300,
	rockets = 300,
	gren1 = 1,
	gren2 = 0,
	cells = 130,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}})
	
red_fr_gen_pack = genericbackpack:new({
	health = 30,
	armor = 30,
	grenades = 0,
	nails = 300,
	shells = 300,
	rockets = 300,
	gren1 = 0,
	gren2 = 0,
	cells = 130,
	respawntime = 20,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}})

-----------------------------------------------------------------------------
-- Locations
-- Switched all "Left"/"Right" so that it's from defenders pov so it makes sense to say "INCOMING RIGHT RAMP"/etc (caesium)
-----------------------------------------------------------------------------

location_midmap = location_info:new({ text = "Midmap", team = Team.kUnassigned })
location_water = location_info:new({ text = "Water", team = Team.kUnassigned })

location_blue_bments = location_info:new({ text = "Battlements", team = Team.kBlue })
location_red_bments = location_info:new({ text = "Battlements", team = Team.kRed })

location_blue_balcony = location_info:new({ text = "Balcony", team = Team.kBlue })
location_red_balcony = location_info:new({ text = "Balcony", team = Team.kRed })

location_blue_frontdoor = location_info:new({ text = "Front Door", team = Team.kBlue })
location_red_frontdoor = location_info:new({ text = "Front Door", team = Team.kRed })

location_blue_frontdoor_ramp = location_info:new({ text = "Front Door Ramp", team = Team.kBlue })
location_red_frontdoor_ramp = location_info:new({ text = "Front Door Ramp", team = Team.kRed })

location_blue_midramps = location_info:new({ text = "Mid Ramps", team = Team.kBlue })
location_red_midramps = location_info:new({ text = "Mid Ramps", team = Team.kRed })

location_blue_midramps_left = location_info:new({ text = "Right Ramp", team = Team.kBlue })
location_red_midramps_left = location_info:new({ text = "Right Ramp", team = Team.kRed })

location_blue_midramps_right = location_info:new({ text = "Left Ramp", team = Team.kBlue })
location_red_midramps_right = location_info:new({ text = "Left Ramp", team = Team.kRed })

location_blue_flagroom = location_info:new({ text = "Flag Room", team = Team.kBlue })
location_red_flagroom = location_info:new({ text = "Flag Room", team = Team.kRed })

location_blue_sniperdeck = location_info:new({ text = "Sniper Deck", team = Team.kBlue })
location_red_sniperdeck = location_info:new({ text = "Sniper Deck", team = Team.kRed })

location_blue_ramproom = location_info:new({ text = "Main Room", team = Team.kBlue })
location_red_ramproom = location_info:new({ text = "Main Room", team = Team.kRed })

location_blue_lower = location_info:new({ text = "Lower Level", team = Team.kBlue })
location_red_lower = location_info:new({ text = "Lower Level", team = Team.kRed })

location_blue_upper = location_info:new({ text = "Upper Level", team = Team.kBlue })
location_red_upper = location_info:new({ text = "Upper Level", team = Team.kRed })

location_blue_airlift = location_info:new({ text = "Air Lift", team = Team.kBlue })
location_red_airlift = location_info:new({ text = "Air Lift", team = Team.kRed })

location_blue_lowerladder = location_info:new({ text = "Lower Ladder to Ramp Room", team = Team.kBlue })
location_red_lowerladder = location_info:new({ text = "Lower Ladder to Ramp Room", team = Team.kRed })

location_blue_rightcorridoor = location_info:new({ text = "Left Corridor", team = Team.kBlue })
location_red_rightcorridoor = location_info:new({ text = "Left Corridor", team = Team.kRed })

location_blue_leftcorridoor = location_info:new({ text = "Right Corridor", team = Team.kBlue })
location_red_leftcorridoor = location_info:new({ text = "Right Corridor", team = Team.kRed })

location_blue_rightresupply = location_info:new({ text = "Left Respawn", team = Team.kBlue })
location_red_rightresupply = location_info:new({ text = "Left Respawn", team = Team.kRed })

location_blue_leftresupply = location_info:new({ text = "Right Respawn", team = Team.kBlue })
location_red_leftresupply = location_info:new({ text = "Right Respawn", team = Team.kRed })

location_blue_leftspawn = location_info:new({ text = "Left Respawn", team = Team.kBlue })
location_red_leftspawn = location_info:new({ text = "Left Respawn", team = Team.kRed })

location_blue_secret = location_info:new({ text = "Secret Passage", team = Team.kBlue })
location_red_secret = location_info:new({ text = "Secret Passage", team = Team.kRed })

location_blue_flagroom_passage = location_info:new({ text = "Flagroom Hole Access Passage", team = Team.kBlue })
location_red_flagroom_passage = location_info:new({ text = "Flagroom Hole Access Passage", team = Team.kRed })

location_blue_flagroom_ramp = location_info:new({ text = "Flag Room Ramp", team = Team.kBlue })
location_red_flagroom_ramp = location_info:new({ text = "Flag Room Ramp", team = Team.kRed })

location_blue_water_entry = location_info:new({ text = "Water Entrance", team = Team.kBlue })
location_red_water_entry = location_info:new({ text = "Water Entrance", team = Team.kRed })

location_blue_water_exit = location_info:new({ text = "Water Exit", team = Team.kBlue })
location_red_water_exit = location_info:new({ text = "Water Exit", team = Team.kRed })

location_blue_water_access = location_info:new({ text = "Water Access", team = Team.kBlue })
location_red_water_access = location_info:new({ text = "Water Access", team = Team.kRed })

-----------------------------------------------------------------------------
-- spawn
-----------------------------------------------------------------------------

function player_spawn( player_entity ) 
	local player = CastToPlayer( player_entity ) 

	player:AddHealth( 400 )
	player:AddArmor( 400 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )

   -- end of default player_spawn
   player:RemoveAmmo( Ammo.kManCannon, 1 )
end

-----------------------------------------------------------------------------
-- Respawns
-----------------------------------------------------------------------------

spawn_red_offence = function(self,player)
	return ((player:GetTeamId() == Team.kRed)
	and ((player:GetClass() == Player.kScout)
	or (player:GetClass() == Player.kMedic)
	or (player:GetClass() == Player.kSpy)))
end

spawn_red_defence = function(self,player)
	return ((player:GetTeamId() == Team.kRed)
	and (((player:GetClass() == Player.kScout) == false)
	and ((player:GetClass() == Player.kMedic) == false)
	and ((player:GetClass() == Player.kSpy) == false)))
end


spawn_blue_offence = function(self,player)
	return ((player:GetTeamId() == Team.kBlue)
	and ((player:GetClass() == Player.kScout)
	or (player:GetClass() == Player.kMedic)
	or (player:GetClass() == Player.kSpy)))
end

spawn_blue_defence = function(self,player)
	return ((player:GetTeamId() == Team.kBlue)
	and (((player:GetClass() == Player.kScout) == false)
	and ((player:GetClass() == Player.kMedic) == false)
	and ((player:GetClass() == Player.kSpy) == false)))
end

bluespawn_offence = { validspawn = spawn_blue_offence }
bluespawn_defence = { validspawn = spawn_blue_defence }
redspawn_offence = { validspawn = spawn_red_offence }
redspawn_defence = { validspawn = spawn_red_defence }

-----------------------------------------------------------------------------
-- Basecap (no mancannon)
-----------------------------------------------------------------------------
bases_cap = basecap:new({
	mancannons = 0,
})

-- red cap point
red_cap = bases_cap:new({team = Team.kRed,
					   item = {"blue_flag","yellow_flag","green_flag"}})

-- blue cap point					   
blue_cap = bases_cap:new({team = Team.kBlue,
						item = {"red_flag","yellow_flag","green_flag"}})
