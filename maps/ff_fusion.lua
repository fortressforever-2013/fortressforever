-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base_idzone")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- global overrides that you can do what you want with
-----------------------------------------------------------------------------

FORT_POINTS_PER_INITIAL_TOUCH = 200
FORT_POINTS_PER_PERIOD = 50
FORT_POINTS_PER_DEFEND = 100

POINTS_PER_INITIAL_TOUCH = 1
POINTS_PER_PERIOD = 1

DELAY_BEFORE_PERIOD_POINTS = 2
PERIOD_TIME = 1
INITIAL_ROUND_PERIOD = 60
ROUND_SETUP_PERIOD = 17

DEFENSE_PERIOD_TIME = 60
POINTS_PER_DEFENSE_PERIOD = 1

DEFAULT_POINTS_TO_CAP = 10
NUMBER_OF_CAP_POINTS = 3
DELAY_BEFORE_TEAMSWITCH = 3
DELAY_AFTER_CAP = 3

ZONE_COLOR = "purple"

-----------------------------------------------------------------------------
-- Zone-controlling outputs
-----------------------------------------------------------------------------

function oncap_outputs() 
	
	OutputEvent( "shake"..phase, "StartShake" )
	OutputEvent( "shakebreak"..phase, "Playsound" )
	AddSchedule( "Partition_On", 4, OutputEvent,"cp"..phase.."_partition", "TurnOn")
	AddSchedule( "Partition_Enabled", 4, OutputEvent,"cp"..phase.."_partition", "Enable")
	AddSchedule( "Partition_Door_On", 4, OutputEvent, "cp"..phase.."_partition_door", "TurnOff")
	AddSchedule( "Partition_Door_Enable", 4, OutputEvent, "cp"..phase.."_partition_door", "Disable")
	AddSchedule( "Areaportal_On", 4, OutputEvent, "cp"..phase.."_areaportal_door", "Open")
	AddSchedule( "Areaportal_Partition_On", 4, OutputEvent, "cp"..phase.."_areaportal", "Close")
	AddSchedule( "alarm_voice", 2, OutputEvent, "voice1", "PlaySound")
	AddSchedule( "alarm_text", 2, schedulemessagetoall, "Zone Captured!")
	AddSchedule( "stop_voice", 2.5, OutputEvent, "voice1", "StopSound")
	AddSchedule( "alarm_voices", 2.5, OutputEvent, "voice2", "PlaySound")
	AddSchedule( "stop_voices", 2.975, OutputEvent, "voice2", "StopSound")
	AddSchedule( "35 second warning", 7, schedulemessagetoall, "Gate Opens in 35 seconds!")
	AddSchedule( "35 second warning_sound" , 7 , schedulesound, "misc.bloop" ) 
	AddSchedule( "dooropen5sec_sound", 37, schedulecountdown, "5")
	AddSchedule( "dooropen4sec_sound", 38, schedulecountdown, "4")
	AddSchedule( "dooropen3sec_sound", 39, schedulecountdown, "3")
	AddSchedule( "dooropen2sec_sound", 40, schedulecountdown, "2")
	AddSchedule( "dooropen1sec_sound", 41, schedulecountdown, "1")
	AddSchedule("alarm_events", 42, OutputEvent, "breakglass"..phase, "Break")
	AddSchedule("alarm_sounds", 42, OutputEvent, "breakalarm"..phase, "PlaySound")
		
	
	if phase == 1 then
		defender_door_trigger1 = id_door:new({ team = attackers, door = "defender_door1" })
		defender_door_trigger2 = id_door:new({ team = attackers, door = "defender_door2" })
	end
	if phase == 2 then
		defender_door_trigger3 = id_door:new({ team = attackers, door = "defender_door3" })
		defender_door_trigger4 = id_door:new({ team = attackers, door = "defender_door4" })
	end
end
function oncap_outputs_nextphase() 
	RespawnAllPlayers()
	
end
function onreset_outputs()
	OutputEvent( "breakalarm"..phase, "Playsound" )
	OutputEvent( "shake"..phase, "StartShake" )
	OutputEvent( "shakebreak"..phase, "Playsound" )
	AddSchedule( "alarm_voice", 2, OutputEvent, "voice1", "PlaySound")
	AddSchedule( "alarm_text", 2, schedulemessagetoall, "Zone Captured!")
	AddSchedule( "stop_voice", 2.5, OutputEvent, "voice1", "StopSound")
	AddSchedule( "alarm_voices", 2.5, OutputEvent, "voice2", "PlaySound")
	AddSchedule( "stop_voices", 2.97, OutputEvent, "voice2", "StopSound")
end

function zone_on_outputs()

		-- use for entities that have two copies per zone (e.g. rotate1 and rotate2)
		two1 = phase * 2 - 1
		two2 = phase * 2
		-- use for entities that have three copies per zone (e.g. rotate1, rotate2, and rotate3)
		three1 = phase * 3 - 2
		three2 = phase * 3 - 1
		three3 = phase * 3
		-- use for entities that have three copies per zone (e.g. rotate1, rotate2, rotate3 and rotate4)
		four1 = phase * 4 - 3
		four2 = phase * 4 - 2
		four3 = phase * 4 - 1
		four4 = phase * 4
	
	-- outputs
	OutputEvent( "alarm"..phase, "PlaySound" )
	OutputEvent( "light"..phase, "TurnOn" )
	OutputEvent( "spot"..phase, "LightOn" )
	OutputEvent( "rotate"..two1, "Start" )
	OutputEvent( "rotate"..two2, "Start" )
	OutputEvent( "Tesla"..phase, "DoSpark" )
end

function zone_off_outputs()

		-- use for entities that have two copies per zone (e.g. rotate1 and rotate2)
		two1 = phase * 2 - 1
		two2 = phase * 2
		-- use for entities that have three copies per zone (e.g. rotate1, rotate2, and rotate3)
		three1 = phase * 3 - 2
		three2 = phase * 3 - 1
		three3 = phase * 3
		-- use for entities that have three copies per zone (e.g. rotate1, rotate2, rotate3 and rotate4)
		four1 = phase * 4 - 3
		four2 = phase * 4 - 2
		four3 = phase * 4 - 1
		four4 = phase * 4
	
	-- outputs
	OutputEvent( "alarm"..phase, "StopSound" )
	OutputEvent( "light"..phase, "TurnOff" )
	OutputEvent( "spot"..phase, "LightOff" )
	OutputEvent( "rotate"..two1, "Stop" )
	OutputEvent( "rotate"..two2, "Stop" )
end

function openstartdoor()
	-- unlock them doors
	attacker_door_trigger1 = id_door:new({ team = attackers, door = "attacker_door1" })
	attacker_door_trigger2 = id_door:new({ team = attackers, door = "attacker_door2" })
	
	-- open the first door
	OutputEvent( "attacker_door1", "Open" )
	OutputEvent( "attacker_door2", "Open" )
end

function onswitch()
	-- reset doors to open for the right team
	defender_door_trigger1 = id_door:new({ team = defenders, door = "defender_door1" })
	defender_door_trigger2 = id_door:new({ team = defenders, door = "defender_door2" })
	defender_door_trigger3 = id_door:new({ team = defenders, door = "defender_door3" })
	defender_door_trigger4 = id_door:new({ team = defenders, door = "defender_door4" })
	defender_door_trigger5 = id_door:new({ team = defenders, door = "defender_door5" })
	defender_door_trigger6 = id_door:new({ team = defenders, door = "defender_door6" })
	defender_door_trigger7 = id_door:new({ team = defenders, door = "defender_door7" })
	defender_door_trigger8 = id_door:new({ team = defenders, door = "defender_door8" })
	
	-- lock them doors
	attacker_door_trigger1 = id_door:new({ team = Team.kUnassigned, door = "attacker_door1" })
	attacker_door_trigger2 = id_door:new({ team = Team.kUnassigned, door = "attacker_door2" })
	
	OutputEvent( "point_template", "ForceSpawn" )
end

function onswitch_bluetodef()
	-- switch the lights
	OutputEvent( "defender_light1", "TurnOff" )
	OutputEvent( "defender_spotlight1", "LightOff" )
	
	OutputEvent( "defender_light2", "TurnOn" )
	OutputEvent( "defender_spotlight2", "LightOn" )

	OutputEvent( "cp1_partition", "TurnOff" )
	OutputEvent( "cp1_partition", "Disable" )
	OutputEvent( "cp2_partition", "TurnOff" )
	OutputEvent( "cp2_partition", "Disable" )

	OutputEvent( "cp1_areaportal", "Open" )
	OutputEvent( "cp1_areaportal_door", "Close" )
	OutputEvent( "cp2_areaportal", "Open" )
	OutputEvent( "cp2_areaportal_door", "Close" )
	
	OutputEvent( "cp1_partition_door", "TurnOn")
	OutputEvent( "cp1_partition_door", "Enable")
	OutputEvent( "cp2_partition_door", "TurnOn")
	OutputEvent( "cp2_partition_door", "Enable")
	
	-- switch them packs, for real this time; this is a workaround due to how the touchflags are set in base.lua
	local num_packs = 9
	for i=1,num_packs do
		entity = GetEntityByName( "gen_pack_defender"..i )
		local info = CastToInfoScript( entity )
		info:SetTouchFlags({ AllowFlags.kBlue})
	end
end

function onswitch_redtodef()
	-- switch the lights
	OutputEvent( "defender_light1", "TurnOn" )
	OutputEvent( "defender_spotlight1", "LightOn" )
	
	OutputEvent( "defender_light2", "TurnOff" )
	OutputEvent( "defender_spotlight2", "LightOff" )

	OutputEvent( "cp1_partition", "TurnOff" )
	OutputEvent( "cp1_partition", "Disable" )
	OutputEvent( "cp2_partition", "TurnOff" )
	OutputEvent( "cp2_partition", "Disable" )
	
	OutputEvent( "cp1_areaportal", "Open" )
	OutputEvent( "cp1_areaportal_door", "Close" )
	OutputEvent( "cp2_areaportal", "Open" )
	OutputEvent( "cp2_areaportal_door", "Close" )

	OutputEvent( "cp1_partition_door", "TurnOn")
	OutputEvent( "cp1_partition_door", "Enable")
	OutputEvent( "cp2_partition_door", "TurnOn")
	OutputEvent( "cp2_partition_door", "Enable")
	
	
	-- switch them packs, for real this time; this is a workaround due to how the touchflags are set in base.lua
	local num_packs = 9
	for i=1,num_packs do
		entity = GetEntityByName( "gen_pack_defender"..i )
		local info = CastToInfoScript( entity )
		info:SetTouchFlags({ AllowFlags.kRed})
	end
end

-----------------------------------------------------------------------------
-- backpacks, doors, etc. etc. 
-----------------------------------------------------------------------------

gen_pack = genericbackpack:new({
	health = 30,
	armor = 25,
	grenades = 20,
	nails = 50,
	shells = 300,
	rockets = 15,
	gren1 = 1,
	gren2 = 0,
	cells = 120,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function gen_pack:dropatspawn() return false 
end

gen_pack_defender1 = gen_pack:new({ touchflags = {AllowFlags.kRed} })
gen_pack_defender2 = gen_pack:new({ touchflags = {AllowFlags.kRed} })
gen_pack_defender3 = gen_pack:new({ touchflags = {AllowFlags.kRed} })
gen_pack_defender4 = gen_pack:new({ touchflags = {AllowFlags.kRed} })
gen_pack_defender5 = gen_pack:new({ touchflags = {AllowFlags.kRed} })
gen_pack_defender6 = gen_pack:new({ touchflags = {AllowFlags.kRed} })
gen_pack_defender7 = gen_pack:new({ touchflags = {AllowFlags.kRed} })
gen_pack_defender8 = gen_pack:new({ touchflags = {AllowFlags.kRed} })
gen_pack_defender9 = gen_pack:new({ touchflags = {AllowFlags.kRed} })

-----------------------------------------------------------------------------
-- No Fucking Annoyances
-----------------------------------------------------------------------------
noannoyances = trigger_ff_script:new({})

function noannoyances:onbuild( build_entity )
	return EVENT_DISALLOWED 
end

function noannoyances:onexplode( explode_entity )
	if IsGrenade( explode_entity ) then
		return EVENT_DISALLOWED
	end
	return EVENT_ALLOWED
end

function noannoyances:oninfect( infect_entity )
	return EVENT_DISALLOWED 
end

no_annoyances = noannoyances
spawn_protection = noannoyances

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

attacker_door_trigger1 = id_door:new({ team = Team.kUnassigned, door = "attacker_door1" })
attacker_door_trigger2 = id_door:new({ team = Team.kUnassigned, door = "attacker_door2" })
defender_door_trigger1 = id_door:new({ team = defenders, door = "defender_door1" })
defender_door_trigger2 = id_door:new({ team = defenders, door = "defender_door2" })
defender_door_trigger3 = id_door:new({ team = defenders, door = "defender_door3" })
defender_door_trigger4 = id_door:new({ team = defenders, door = "defender_door4" })
defender_door_trigger5 = id_door:new({ team = defenders, door = "defender_door5" })
defender_door_trigger6 = id_door:new({ team = defenders, door = "defender_door6" })

defender_spawn = base_defender_spawn:new({phase=1})
defender_spawn2 = base_defender_spawn:new({phase=2})
defender_spawn3 = base_defender_spawn:new({phase=3})
attacker_spawn = base_attacker_spawn:new({phase=1})
attacker_spawn2 = base_attacker_spawn:new({phase=2})
attacker_spawn3 = base_attacker_spawn:new({phase=3})

------------------------------------------------------------------
--Elevator
------------------------------------------------------------------

-- keeps track of elevator goings on
local elev_collection = Collection()

elev_trigger_add = trigger_ff_script:new({ }) 

-- registers attackers as they hit the top
function elev_trigger_add:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		elev_collection:AddItem( player )
	end
end

elev_trigger_remove = trigger_ff_script:new({ }) 

function elev_trigger_remove:onendtouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		elev_collection:RemoveItem( player )
	end
end

function elev_trigger_remove:oninactive( trigger_entity )
	elev_collection:RemoveAllItems()
end

elev_trigger = trigger_ff_script:new({ }) 

function elev_trigger:allowed( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		for playerx in elev_collection.items do
			playerx = CastToPlayer(playerx)
			if playerx:GetId() == player:GetId() then
				return EVENT_DISALLOWED
			end
		end
	end
	return EVENT_ALLOWED
end

function elev_trigger:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		--local player = CastToPlayer( trigger_entity )
		OutputEvent( "elev2", "Open" )
	end
end
