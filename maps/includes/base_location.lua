
-- base_location.lua

-----------------------------------------------------------------------------
-- Include this file to add base location functionality to your map
-- DO NOT ALTER THIS FILE
-----------------------------------------------------------------------------
location_info = trigger_ff_script:new({ text = "Unknown", team = Team.kUnassigned })

function location_info:ontouch( touch_entity )

	-- set the location of the player
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		player:SetLocation(entity:GetId(), self.text, self.team)
	end
end

-- Locations were randomly screwing up when you move between them. I removed this and it appears to have completely fixed it.
-- I am not familiar with all this though, so someone who knows btr should check it over please (caesium).
--function location_info:onendtouch( touch_entity )
	-- remove the location from the player
--	if IsPlayer( touch_entity ) then
--		local player = CastToPlayer( touch_entity )
--		player:RemoveLocation(entity:GetId())
--	end
--end

-----------------------------------------------------------------------------
-- Some common locations
-- PREFIX locations with the word "location_" (or just follow the same style as below!)
-----------------------------------------------------------------------------
location_attic = location_info:new({ text = "#FF_LOCATION_ATTIC", team = Team.kUnassigned })
location_blue_attic = location_info:new({ text = "#FF_LOCATION_ATTIC", team = Team.kBlue })
location_red_attic = location_info:new({ text = "#FF_LOCATION_ATTIC", team = Team.kRed })
location_yellow_attic = location_info:new({ text = "#FF_LOCATION_ATTIC", team = Team.kYellow })
location_green_attic = location_info:new({ text = "#FF_LOCATION_ATTIC", team = Team.kGreen })

location_base = location_info:new({ text = "#FF_LOCATION_BASE", team = Team.kUnassigned })
location_blue_base = location_info:new({ text = "#FF_LOCATION_BASE", team = Team.kBlue })
location_red_base = location_info:new({ text = "#FF_LOCATION_BASE", team = Team.kRed })
location_yellow_base = location_info:new({ text = "#FF_LOCATION_BASE", team = Team.kYellow })
location_green_base = location_info:new({ text = "#FF_LOCATION_BASE", team = Team.kGreen })

location_balcony = location_info:new({ text = "#FF_LOCATION_BALCONY", team = Team.kUnassigned })
location_blue_balcony = location_info:new({ text = "#FF_LOCATION_BALCONY", team = Team.kBlue })
location_red_balcony = location_info:new({ text = "#FF_LOCATION_BALCONY", team = Team.kRed })
location_yellow_balcony = location_info:new({ text = "#FF_LOCATION_BALCONY", team = Team.kYellow })
location_green_balcony = location_info:new({ text = "#FF_LOCATION_BALCONY", team = Team.kGreen })

location_battlements = location_info:new({ text = "#FF_LOCATION_BATTLEMENTS", team = Team.kUnassigned })
location_blue_battlements = location_info:new({ text = "#FF_LOCATION_BATTLEMENTS", team = Team.kBlue })
location_red_battlements = location_info:new({ text = "#FF_LOCATION_BATTLEMENTS", team = Team.kRed })
location_yellow_battlements = location_info:new({ text = "#FF_LOCATION_BATTLEMENTS", team = Team.kYellow })
location_green_battlements = location_info:new({ text = "#FF_LOCATION_BATTLEMENTS", team = Team.kGreen })

location_bunker = location_info:new({ text = "#FF_LOCATION_BUNKER", team = Team.kUnassigned })
location_blue_bunker = location_info:new({ text = "#FF_LOCATION_BUNKER", team = Team.kBlue })
location_red_bunker = location_info:new({ text = "#FF_LOCATION_BUNKER", team = Team.kRed })
location_yellow_bunker = location_info:new({ text = "#FF_LOCATION_BUNKER", team = Team.kYellow })
location_green_bunker = location_info:new({ text = "#FF_LOCATION_BUNKER", team = Team.kGreen })

location_button = location_info:new({ text = "#FF_LOCATION_BUTTON", team = Team.kUnassigned })
location_blue_button = location_info:new({ text = "#FF_LOCATION_BUTTON", team = Team.kBlue })
location_red_button = location_info:new({ text = "#FF_LOCATION_BUTTON", team = Team.kRed })
location_yellow_button = location_info:new({ text = "#FF_LOCATION_BUTTON", team = Team.kYellow })
location_green_button = location_info:new({ text = "#FF_LOCATION_BUTTON", team = Team.kGreen })

location_cappoint = location_info:new({ text = "#FF_LOCATION_CAPPOINT", team = Team.kUnassigned })
location_blue_cappoint = location_info:new({ text = "#FF_LOCATION_CAPPOINT", team = Team.kBlue })
location_red_cappoint = location_info:new({ text = "#FF_LOCATION_CAPPOINT", team = Team.kRed })
location_yellow_cappoint = location_info:new({ text = "#FF_LOCATION_CAPPOINT", team = Team.kYellow })
location_green_cappoint = location_info:new({ text = "#FF_LOCATION_CAPPOINT", team = Team.kGreen })

location_elevator = location_info:new({ text = "#FF_LOCATION_ELEVATOR", team = Team.kUnassigned })
location_blue_elevator = location_info:new({ text = "#FF_LOCATION_ELEVATOR", team = Team.kBlue })
location_red_elevator = location_info:new({ text = "#FF_LOCATION_ELEVATOR", team = Team.kRed })
location_yellow_elevator = location_info:new({ text = "#FF_LOCATION_ELEVATOR", team = Team.kYellow })
location_green_elevator = location_info:new({ text = "#FF_LOCATION_ELEVATOR", team = Team.kGreen })

location_flagroom = location_info:new({ text = "#FF_LOCATION_FLAGROOM", team = Team.kUnassigned })
location_blue_flagroom = location_info:new({ text = "#FF_LOCATION_FLAGROOM", team = Team.kBlue })
location_red_flagroom = location_info:new({ text = "#FF_LOCATION_FLAGROOM", team = Team.kRed })
location_yellow_flagroom = location_info:new({ text = "#FF_LOCATION_FLAGROOM", team = Team.kYellow })
location_green_flagroom = location_info:new({ text = "#FF_LOCATION_FLAGROOM", team = Team.kGreen })

location_frontdoor = location_info:new({ text = "#FF_LOCATION_FRONTDOOR", team = Team.kUnassigned })
location_blue_frontdoor = location_info:new({ text = "#FF_LOCATION_FRONTDOOR", team = Team.kBlue })
location_red_frontdoor = location_info:new({ text = "#FF_LOCATION_FRONTDOOR", team = Team.kRed })
location_yellow_frontdoor = location_info:new({ text = "#FF_LOCATION_FRONTDOOR", team = Team.kYellow })
location_green_frontdoor = location_info:new({ text = "#FF_LOCATION_FRONTDOOR", team = Team.kGreen })

location_lift = location_info:new({ text = "#FF_LOCATION_LIFT", team = Team.kUnassigned })
location_blue_lift = location_info:new({ text = "#FF_LOCATION_LIFT", team = Team.kBlue })
location_red_lift = location_info:new({ text = "#FF_LOCATION_LIFT", team = Team.kRed })
location_yellow_lift = location_info:new({ text = "#FF_LOCATION_LIFT", team = Team.kYellow })
location_green_lift = location_info:new({ text = "#FF_LOCATION_LIFT", team = Team.kGreen })

location_loft = location_info:new({ text = "#FF_LOCATION_LOFT", team = Team.kUnassigned })
location_blue_loft = location_info:new({ text = "#FF_LOCATION_LOFT", team = Team.kBlue })
location_red_loft = location_info:new({ text = "#FF_LOCATION_LOFT", team = Team.kRed })
location_yellow_loft = location_info:new({ text = "#FF_LOCATION_LOFT", team = Team.kYellow })
location_green_loft = location_info:new({ text = "#FF_LOCATION_LOFT", team = Team.kGreen })

location_pit = location_info:new({ text = "#FF_LOCATION_PIT", team = Team.kUnassigned })
location_blue_pit = location_info:new({ text = "#FF_LOCATION_PIT", team = Team.kBlue })
location_red_pit = location_info:new({ text = "#FF_LOCATION_PIT", team = Team.kRed })
location_yellow_pit = location_info:new({ text = "#FF_LOCATION_PIT", team = Team.kYellow })
location_green_pit = location_info:new({ text = "#FF_LOCATION_PIT", team = Team.kGreen })

location_plank = location_info:new({ text = "#FF_LOCATION_PLANK", team = Team.kUnassigned })
location_blue_plank = location_info:new({ text = "#FF_LOCATION_PLANK", team = Team.kBlue })
location_red_plank = location_info:new({ text = "#FF_LOCATION_PLANK", team = Team.kRed })
location_yellow_plank = location_info:new({ text = "#FF_LOCATION_PLANK", team = Team.kYellow })
location_green_plank = location_info:new({ text = "#FF_LOCATION_PLANK", team = Team.kGreen })

location_ramp = location_info:new({ text = "#FF_LOCATION_RAMP", team = Team.kUnassigned })
location_blue_ramp = location_info:new({ text = "#FF_LOCATION_RAMP", team = Team.kBlue })
location_red_ramp = location_info:new({ text = "#FF_LOCATION_RAMP", team = Team.kRed })
location_yellow_ramp = location_info:new({ text = "#FF_LOCATION_RAMP", team = Team.kYellow })
location_green_ramp = location_info:new({ text = "#FF_LOCATION_RAMP", team = Team.kGreen })

location_ramp_bottom = location_info:new({ text = "#FF_LOCATION_RAMP_BOTTOM", team = Team.kUnassigned })
location_blue_ramp_bottom = location_info:new({ text = "#FF_LOCATION_RAMP_BOTTOM", team = Team.kBlue })
location_red_ramp_bottom = location_info:new({ text = "#FF_LOCATION_RAMP_BOTTOM", team = Team.kRed })
location_yellow_ramp_bottom = location_info:new({ text = "#FF_LOCATION_RAMP_BOTTOM", team = Team.kYellow })
location_green_ramp_bottom = location_info:new({ text = "#FF_LOCATION_RAMP_BOTTOM", team = Team.kGreen })

location_ramp_top = location_info:new({ text = "#FF_LOCATION_RAMP_TOP", team = Team.kUnassigned })
location_blue_ramp_top = location_info:new({ text = "#FF_LOCATION_RAMP_TOP", team = Team.kBlue })
location_red_ramp_top = location_info:new({ text = "#FF_LOCATION_RAMP_TOP", team = Team.kRed })
location_yellow_ramp_top = location_info:new({ text = "#FF_LOCATION_RAMP_TOP", team = Team.kYellow })
location_green_ramp_top = location_info:new({ text = "#FF_LOCATION_RAMP_TOP", team = Team.kGreen })

location_ramproom = location_info:new({ text = "#FF_LOCATION_RAMPROOM", team = Team.kUnassigned })
location_blue_ramproom = location_info:new({ text = "#FF_LOCATION_RAMPROOM", team = Team.kBlue })
location_red_ramproom = location_info:new({ text = "#FF_LOCATION_RAMPROOM", team = Team.kRed })
location_yellow_ramproom = location_info:new({ text = "#FF_LOCATION_RAMPROOM", team = Team.kYellow })
location_green_ramproom = location_info:new({ text = "#FF_LOCATION_RAMPROOM", team = Team.kGreen })

location_respawn = location_info:new({ text = "#FF_LOCATION_RESPAWN", team = Team.kUnassigned })
location_blue_respawn = location_info:new({ text = "#FF_LOCATION_RESPAWN", team = Team.kBlue })
location_red_respawn = location_info:new({ text = "#FF_LOCATION_RESPAWN", team = Team.kRed })
location_yellow_respawn = location_info:new({ text = "#FF_LOCATION_RESPAWN", team = Team.kYellow })
location_green_respawn = location_info:new({ text = "#FF_LOCATION_RESPAWN", team = Team.kGreen })

location_roof = location_info:new({ text = "#FF_LOCATION_ROOF", team = Team.kUnassigned })
location_blue_roof = location_info:new({ text = "#FF_LOCATION_ROOF", team = Team.kBlue })
location_red_roof = location_info:new({ text = "#FF_LOCATION_ROOF", team = Team.kRed })
location_yellow_roof = location_info:new({ text = "#FF_LOCATION_ROOF", team = Team.kYellow })
location_green_roof = location_info:new({ text = "#FF_LOCATION_ROOF", team = Team.kGreen })

location_security = location_info:new({ text = "#FF_LOCATION_SECURITY", team = Team.kUnassigned })
location_blue_security = location_info:new({ text = "#FF_LOCATION_SECURITY", team = Team.kBlue })
location_red_security = location_info:new({ text = "#FF_LOCATION_SECURITY", team = Team.kRed })
location_yellow_security = location_info:new({ text = "#FF_LOCATION_SECURITY", team = Team.kYellow })
location_green_security = location_info:new({ text = "#FF_LOCATION_SECURITY", team = Team.kGreen })

location_sniper_perch = location_info:new({ text = "#FF_LOCATION_SNIPER_PERCH", team = Team.kUnassigned })
location_blue_sniper_perch = location_info:new({ text = "#FF_LOCATION_SNIPER_PERCH", team = Team.kBlue })
location_red_sniper_perch = location_info:new({ text = "#FF_LOCATION_SNIPER_PERCH", team = Team.kRed })
location_yellow_sniper_perch = location_info:new({ text = "#FF_LOCATION_SNIPER_PERCH", team = Team.kYellow })
location_green_sniper_perch = location_info:new({ text = "#FF_LOCATION_SNIPER_PERCH", team = Team.kGreen })

location_spiral = location_info:new({ text = "#FF_LOCATION_SPIRAL", team = Team.kUnassigned })
location_blue_spiral = location_info:new({ text = "#FF_LOCATION_SPIRAL", team = Team.kBlue })
location_red_spiral = location_info:new({ text = "#FF_LOCATION_SPIRAL", team = Team.kRed })
location_yellow_spiral = location_info:new({ text = "#FF_LOCATION_SPIRAL", team = Team.kYellow })
location_green_spiral = location_info:new({ text = "#FF_LOCATION_SPIRAL", team = Team.kGreen })

location_switch = location_info:new({ text = "#FF_LOCATION_SWITCH", team = Team.kUnassigned })
location_blue_switch = location_info:new({ text = "#FF_LOCATION_SWITCH", team = Team.kBlue })
location_red_switch = location_info:new({ text = "#FF_LOCATION_SWITCH", team = Team.kRed })
location_yellow_switch = location_info:new({ text = "#FF_LOCATION_SWITCH", team = Team.kYellow })
location_green_switch = location_info:new({ text = "#FF_LOCATION_SWITCH", team = Team.kGreen })

location_t = location_info:new({ text = "#FF_LOCATION_T", team = Team.kUnassigned })
location_blue_t = location_info:new({ text = "#FF_LOCATION_T", team = Team.kBlue })
location_red_t = location_info:new({ text = "#FF_LOCATION_T", team = Team.kRed })
location_yellow_t = location_info:new({ text = "#FF_LOCATION_T", team = Team.kYellow })
location_green_t = location_info:new({ text = "#FF_LOCATION_T", team = Team.kGreen })

location_train_tunnel = location_info:new({ text = "#FF_LOCATION_TRAIN_TUNNEL", team = Team.kUnassigned })
location_blue_train_tunnel = location_info:new({ text = "#FF_LOCATION_TRAIN_TUNNEL", team = Team.kBlue })
location_red_train_tunnel = location_info:new({ text = "#FF_LOCATION_TRAIN_TUNNEL", team = Team.kRed })
location_yellow_train_tunnel = location_info:new({ text = "#FF_LOCATION_TRAIN_TUNNEL", team = Team.kYellow })
location_green_train_tunnel = location_info:new({ text = "#FF_LOCATION_TRAIN_TUNNEL", team = Team.kGreen })

location_underground = location_info:new({ text = "#FF_LOCATION_UNDERGROUND", team = Team.kUnassigned })
location_blue_underground = location_info:new({ text = "#FF_LOCATION_UNDERGROUND", team = Team.kBlue })
location_red_underground = location_info:new({ text = "#FF_LOCATION_UNDERGROUND", team = Team.kRed })
location_yellow_underground = location_info:new({ text = "#FF_LOCATION_UNDERGROUND", team = Team.kYellow })
location_green_underground = location_info:new({ text = "#FF_LOCATION_UNDERGROUND", team = Team.kGreen })

location_waterroute = location_info:new({ text = "#FF_LOCATION_WATERROUTE", team = Team.kUnassigned })
location_blue_waterroute = location_info:new({ text = "#FF_LOCATION_WATERROUTE", team = Team.kBlue })
location_red_waterroute = location_info:new({ text = "#FF_LOCATION_WATERROUTE", team = Team.kRed })
location_yellow_waterroute = location_info:new({ text = "#FF_LOCATION_WATERROUTE", team = Team.kYellow })
location_green_waterroute = location_info:new({ text = "#FF_LOCATION_WATERROUTE", team = Team.kGreen })

location_yard = location_info:new({ text = "#FF_LOCATION_YARD", team = Team.kUnassigned })
location_blue_yard = location_info:new({ text = "#FF_LOCATION_YARD", team = Team.kBlue })
location_red_yard = location_info:new({ text = "#FF_LOCATION_YARD", team = Team.kRed })
location_yellow_yard = location_info:new({ text = "#FF_LOCATION_YARD", team = Team.kYellow })
location_green_yard = location_info:new({ text = "#FF_LOCATION_YARD", team = Team.kGreen })

-- Generic Invade/Defend Locations

location_attackerspawn = location_info:new({ text = "#FF_LOCATION_ATTACKER_SPAWN", team = Team.kUnassigned })

location_defenderspawn = location_info:new({ text = "#FF_LOCATION_DEFENDER_SPAWN", team = Team.kUnassigned })

location_commandpointone = location_info:new({ text = "#FF_LOCATION_COMMAND_POINT_ONE", team = Team.kUnassigned })

location_commandpointtwo = location_info:new({ text = "#FF_LOCATION_COMMAND_POINT_TWO", team = Team.kUnassigned })

location_commandpointthree = location_info:new({ text = "#FF_LOCATION_COMMAND_POINT_THREE", team = Team.kUnassigned })

location_commandpointfour = location_info:new({ text = "#FF_LOCATION_COMMAND_POINT_FOUR", team = Team.kUnassigned })

location_detpack_hole = location_info:new({ text = "#FF_LOCATION_DETPACK_HOLE", team = Team.kUnassigned })

