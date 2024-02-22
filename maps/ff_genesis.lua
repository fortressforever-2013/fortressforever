----------------------------------------------------------------------------- 
-- includes 
----------------------------------------------------------------------------- 

IncludeScript("base_adzone") 
IncludeScript("base_location") 
IncludeScript("base_respawnturret") 

----------------------------------------------------------------------------- 
-- global overrides that you can do what you want with 
----------------------------------------------------------------------------- 

ZONE_COLOR = "green" 
USE_ZONE_AREA = true
NUM_DEFENDER_ONLY_PACKS = 3 

----------------------------------------------------------------------------- 
-- Zone-controlling outputs 
----------------------------------------------------------------------------- 

function zone_on_outputs()
	-- outputs
	OutputEvent( "alarm1", "PlaySound" )
	OutputEvent( "light1", "TurnOn" )
	OutputEvent( "spot1", "LightOn" )
	OutputEvent( "rotate1", "Start" )
	OutputEvent( "rotate2", "Start" )
	OutputEvent( "Tesla1", "DoSpark" )
end

function zone_off_outputs()
	OutputEvent( "alarm1", "StopSound" )
	OutputEvent( "light1", "TurnOff" )
	OutputEvent( "spot1", "LightOff" )
	OutputEvent( "rotate1", "Stop" )
	OutputEvent( "rotate2", "Stop" )
end

function openstartdoor() 
   -- unlock them doors 
   attacker_door_trigger2 = id_door:new({ team = attackers, door = "attacker_door2" }) 
   attacker_door_trigger3 = id_door:new({ team = attackers, door = "attacker_door3" }) 
    
   -- open the first door 
   OutputEvent( "attacker_door2", "Open" ) 
   OutputEvent( "attacker_door3", "Open" ) 
end 

function onswitch() 
   -- reset doors to open for the right team 
   attacker_door_trigger1 = id_door:new({ team = attackers, door = "attacker_door1" }) 
   attacker_door_trigger4 = id_door:new({ team = attackers, door = "attacker_door4" }) 
   attacker_door_trigger5 = id_door:new({ team = attackers, door = "attacker_door5" }) 
   attacker_door_trigger6 = id_door:new({ team = attackers, door = "attacker_door6" }) 
   defender_door_trigger1 = id_door:new({ team = defenders, door = "defender_door1" }) 
   defender_door_trigger2 = id_door:new({ team = defenders, door = "defender_door2" }) 
    
   -- lock them doors 
   attacker_door_trigger2 = id_door:new({ team = Team.kUnassigned, door = "attacker_door2" }) 
   attacker_door_trigger3 = id_door:new({ team = Team.kUnassigned, door = "attacker_door3" }) 
end 

function onswitch_bluetodef() 
   -- switch the lights 
   OutputEvent( "defender_light1", "TurnOff" ) 
   OutputEvent( "defender_spotlight1", "LightOff" ) 
    
   OutputEvent( "defender_light2", "TurnOn" ) 
   OutputEvent( "defender_spotlight2", "LightOn" ) 
end 

function onswitch_redtodef() 
   -- switch the lights 
   OutputEvent( "defender_light1", "TurnOn" ) 
   OutputEvent( "defender_spotlight1", "LightOn" ) 
    
   OutputEvent( "defender_light2", "TurnOff" ) 
   OutputEvent( "defender_spotlight2", "LightOff" ) 
end 

------------------------------------------------------------------ 
--Resup Doors 
------------------------------------------------------------------ 
neutral_door_trigger1 = trigger_ff_script:new({}) 

function neutral_door_trigger1:ontouch( trigger_entity ) 
   OutputEvent( "neutral_door1", "Open" ) 
end 

id_door = trigger_ff_script:new({ team = Team.kUnassigned, door = nil }) 

function id_door:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      local player = CastToPlayer( touch_entity ) 
      return player:GetTeamId() == self.team 
   end 

   return EVENT_DISALLOWED 
end 

function id_door:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent(self.door, "Open") 
   end 
end 

attacker_door_trigger1 = id_door:new({ team = attackers, door = "attacker_door1" }) 
attacker_door_trigger2 = id_door:new({ team = Team.kUnassigned, door = "attacker_door2" }) 
attacker_door_trigger3 = id_door:new({ team = Team.kUnassigned, door = "attacker_door3" }) 
attacker_door_trigger4 = id_door:new({ team = attackers, door = "attacker_door4" }) 
attacker_door_trigger5 = id_door:new({ team = attackers, door = "attacker_door5" }) 
attacker_door_trigger6 = id_door:new({ team = attackers, door = "attacker_door6" }) 
defender_door_trigger1 = id_door:new({ team = defenders, door = "defender_door1" }) 
defender_door_trigger2 = id_door:new({ team = defenders, door = "defender_door2" })

-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------

location_a_spawn = location_info:new({ text = "Attacker's Spawn"})
location_a_spawn2 = location_info:new({ text = "Attacker's Spawn"})
location_a_spawn3 = location_info:new({ text = "Attacker's Gate Room"})

location_a_bottom = location_info:new({ text = "Secondary Attacker Route"})
location_a_bottom2 = location_info:new({ text = "Secondary Attacker Route"})

location_gate = location_info:new({ text = "Attacker's Gate"})
location_lower = location_info:new({ text = "Lower Hallway"})
location_gate_balcony = location_info:new({ text = "Overhanging Defensive Balcony"})
location_side_balcony = location_info:new({ text = "Side Defensive Balcony"})

location_elevator = location_info:new({ text = "Elevator Shaft"})

location_lab = location_info:new({ text = "Center Laboratory"})

location_building = location_info:new({ text = "Defense Building"})
location_main = location_info:new({ text = "Main Area"})
location_main_top = location_info:new({ text = "Top Balcony"})

location_cap = location_info:new({ text = "Capture Area"})
location_d_spawn = location_info:new({ text = "Defense Spawn"})