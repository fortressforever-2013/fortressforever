IncludeScript( "base_ctf" );
IncludeScript( "base_location" );
IncludeScript( "base_respawnturret" );

POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------
-- Blue
-----------------------------------------------------------------------------
location_blue_yard = location_info:new({ text = "Yard", team = Team.kBlue })
location_blue_middle_level = location_info:new({ text = "Middle Level", team = Team.kBlue })
location_blue_top_level = location_info:new({ text = "Top Level", team = Team.kBlue })
location_blue_pit = location_info:new({ text = "Pit", team = Team.kBlue })
location_blue_mid_wraparound = location_info:new({ text = "Mid Wraparound", team = Team.kBlue })
location_blue_left_wraparound = location_info:new({ text = "Left Wraparound", team = Team.kBlue })
location_blue_right_wraparound = location_info:new({ text = "Right Wraparound", team = Team.kBlue })
location_blue_left_sideramp = location_info:new({ text = "Left Sideramp", team = Team.kBlue })
location_blue_right_sideramp = location_info:new({ text = "Right Sideramp", team = Team.kBlue })
location_blue_roof = location_info:new({ text = "Roof", team = Team.kBlue })
location_blue_upper_respawn = location_info:new({ text = "Upper Respawn", team = Team.kBlue })
location_blue_lower_respawn = location_info:new({ text = "Lower Respawn", team = Team.kBlue })
location_blue_hole = location_info:new({ text = "Hole in the Wall", team = Team.kBlue })
location_blue_left_vent = location_info:new({ text = "Left Vent", team = Team.kBlue })
location_blue_right_vent = location_info:new({ text = "Right Vent", team = Team.kBlue })
location_blue_airduct = location_info:new({ text = "Air Duct", team = Team.kBlue })
location_blue_window = location_info:new({ text = "Window", team = Team.kBlue })
-----------------------------------------------------------------------------
-- Red
-----------------------------------------------------------------------------
location_red_yard = location_info:new({ text = "Yard", team = Team.kRed })
location_red_middle_level = location_info:new({ text = "Middle Level", team = Team.kRed })
location_red_top_level = location_info:new({ text = "Top Level", team = Team.kRed })
location_red_pit = location_info:new({ text = "Pit", team = Team.kRed })
location_red_mid_wraparound = location_info:new({ text = "Mid Wraparound", team = Team.kRed })
location_red_left_wraparound = location_info:new({ text = "Left Wraparound", team = Team.kRed })
location_red_right_wraparound = location_info:new({ text = "Right Wraparound", team = Team.kRed })
location_red_left_sideramp = location_info:new({ text = "Left Sideramp", team = Team.kRed })
location_red_right_sideramp = location_info:new({ text = "Right Sideramp", team = Team.kRed })
location_red_roof = location_info:new({ text = "Roof", team = Team.kRed })
location_red_upper_respawn = location_info:new({ text = "Upper Respawn", team = Team.kRed })
location_red_lower_respawn = location_info:new({ text = "Lower Respawn", team = Team.kRed })
location_red_hole = location_info:new({ text = "Hole in the Wall", team = Team.kRed })
location_red_left_vent = location_info:new({ text = "Left Vent", team = Team.kRed })
location_red_right_vent = location_info:new({ text = "Right Vent", team = Team.kRed })
location_red_airduct = location_info:new({ text = "Air Duct", team = Team.kRed })
location_red_window = location_info:new({ text = "Window", team = Team.kRed })

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 400 )
	player:AddArmor( 400 )
	
	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kDetpack, 1 )
	player:AddAmmo( Ammo.kManCannon, 1 )
	
	-- give demo 1 mirv, and only 1 mirv
	if player:GetClass() == Player.kDemoman then 
		player:RemoveAmmo( Ammo.kGren2, 4 )
		player:AddAmmo( Ammo.kGren2, 1 )
	end
end

-----------------------------------------------------------------------------
-- Red Doors
-----------------------------------------------------------------------------
-- Spawn 1
-----------------------------------------------------------------------------
red_spawn1door_trigger = trigger_ff_script:new({ team = Team.kRed }) 

function red_spawn1door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_spawn1door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_spawn1door_left", "Open") 
      OutputEvent("red_spawn1door_right", "Open") 
   end 
end 

-----------------------------------------------------------------------------
-- Spawn 2
-----------------------------------------------------------------------------
red_spawn2door_trigger = trigger_ff_script:new({ team = Team.kRed }) 

function red_spawn2door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_spawn2door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_spawn2door_left", "Open") 
      OutputEvent("red_spawn2door_right", "Open") 
   end 
end 

-----------------------------------------------------------------------------
-- Elevator
-----------------------------------------------------------------------------
red_elevdoor_trigger = trigger_ff_script:new({ team = Team.kRed }) 

function red_elevdoor_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_elevdoor_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_elevdoor_bottom", "Open") 
      OutputEvent("red_elevdoor_top", "Open") 
   end 
end 

-----------------------------------------------------------------------------
-- Blue Doors
-----------------------------------------------------------------------------
-- Spawn 1
-----------------------------------------------------------------------------
blue_spawn1door_trigger = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_spawn1door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_spawn1door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_spawn1door_left", "Open") 
      OutputEvent("blue_spawn1door_right", "Open") 
   end 
end 

-----------------------------------------------------------------------------
-- Spawn 2
-----------------------------------------------------------------------------
blue_spawn2door_trigger = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_spawn2door_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_spawn2door_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_spawn2door_left", "Open") 
      OutputEvent("blue_spawn2door_right", "Open") 
   end 
end 

-----------------------------------------------------------------------------
-- Elevator
-----------------------------------------------------------------------------
blue_elevdoor_trigger = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_elevdoor_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_elevdoor_trigger:ontrigger( touch_entity )
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_elevdoor_bottom", "Open") 
      OutputEvent("blue_elevdoor_top", "Open") 
   end 
end 

-----------------------------------------------------------------------------
-- Ammo/Health Kit (backpack-based)
-----------------------------------------------------------------------------
healthbackpack = genericbackpack:new({
	health = 50,
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 50,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function healthbackpack:dropatspawn() return false end

-----------------------------------------------------------------------------
-- 4|4 Grenade Pack
-----------------------------------------------------------------------------
fullgrenadebackpack = genericbackpack:new({
	gren1 = 4,
	gren2 = 4,
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 50,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	respawntime = 30,
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Grenades
})

function grenadebackpack:dropatspawn() return false end