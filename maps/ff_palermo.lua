-- ff_palermo.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------

IncludeScript("base_id");
IncludeScript("base_respawnturret");
IncludeScript("base_location");

-----------------------------------------------------------------------------
-- globals
-----------------------------------------------------------------------------

DEFENDERS_OBJECTIVE_ONCAP = true
DEFENDERS_OBJECTIVE_ONCARRIER = false --set to true to follow flag when carried
DEFENDERS_OBJECTIVE_ONFLAG = false --set to true to follow flag ALWAYS

-- custom startup
local startup_base = startup

function startup()
    startup_base()

    -- palermo specific stuff
	-- lower trigger_hurt damage in water
	OutputEvent( "trigger_hurt", "SetDamage", "42" )
end

palammopack = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 70,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})
palgrenadepackone = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	mancannons = 1,
	gren1 = 2,
	gren2 = 1,
	armor = 50,
	health = 25,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})
attackers_palgrenadepackone = idbackpack:new({
	team = attackers,
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	mancannons = 1,
	gren1 = 2,
	gren2 = 1,
	armor = 50,
	health = 25,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})
palammotypeone = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 75,
	armor = 50,
	health = 25,
	respawntime = 7,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})
attackers_palammotypeone = idbackpack:new({
	team = attackers,
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 75,
	armor = 50,
	health = 25,
	respawntime = 7,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

--This is called from base_id to do map-specific stuff
function onroundreset()
	-- close the holes
	OutputEvent("cp1_detpack_hole", "Enable")
	OutputEvent("cp4_detpack_hole", "Enable")
	--re-enable detpack relays
	OutputEvent("cp1_detpack_relay", "Enable")
	OutputEvent("cp4_detpack_relay", "Enable")
	-- Reset The Turrets(?) and Bags
	respawnturret_attackers = base_respawnturret:new({ team = attackers })
	respawnturret_defenders = base_respawnturret:new({ team = defenders })

	attackers_palammotypeone.team = attackers
	attackers_palgrenadepackone.team = attackers
end

bellbutton = func_button:new({}) 
function bellbutton:ondamage() return true end  

---------------------------
--Detpack shit
---------------------------

detpack_trigger = trigger_ff_script:new({ prefix = "" })

function detpack_trigger:onexplode( trigger_entity )
	if IsDetpack( trigger_entity ) then
		local detpack = CastToDetpack( trigger_entity )
		if detpack:GetTeamId() == attackers then
			--This triggers a logic_relay in the map, which opens the hole and can trigger any other effect.
			OutputEvent( self.prefix .. "_detpack_relay", "Trigger" )
		end
	end
	return EVENT_ALLOWED
end

--The detpack trigger names. Only attakers can activate them.
--Prefix is used so each detpack area can have a different effect.
cp1_detpack_trigger = detpack_trigger:new({ prefix = "cp1" })
cp4_detpack_trigger = detpack_trigger:new({ prefix = "cp4" })

---------------------------------------------------
--Respawn the player if they go too far out to sea.
---------------------------------------------------
out_of_bounds = trigger_ff_script:new({})

function out_of_bounds:allowed( touch_entity ) 
	if IsPlayer( touch_entity ) then 
		local player = CastToPlayer( touch_entity ) 
		return EVENT_ALLOWED
	end
	return EVENT_DISALLOWED 
end 

function out_of_bounds:ontrigger( triggering_entity ) 
	if IsPlayer( triggering_entity ) then 
		local player = CastToPlayer( triggering_entity ) 
		ApplyToPlayer( player, { AT.kRespawnPlayers } )
	end
end

cp1_detpack_trigger_hint = trigger_ff_script:new({})

function cp1_detpack_trigger_hint:ontrigger( triggering_entity ) 
	if IsPlayer( triggering_entity ) then 
		local player = CastToPlayer( triggering_entity ) 
		DisplayMessage( player, "A demoman on the attacking team can open this passage by laying a detpack here." )
	end
end

cp4_detpack_trigger_hint = cp1_detpack_trigger_hint 
------------------------------------------
--return the flag if it goes in the water.
------------------------------------------
--hijacking this base_id function to add in the last line
function setup_return_timer()
	RemoveSchedule( "timer_tobase_schedule" )
	current_timer = FLAG_RETURN_TIME
	
	AddScheduleRepeatingNotInfinitely( "timer_return_schedule", 1, timer_schedule, current_timer)

	--five seconds should be enough time to check.
	AddSchedule( "water_check", 5, check_flag_position)
end


function check_flag_position()
	local flag = GetInfoScriptByName(current_flag)
	local o = flag:GetOrigin()

	-- -256 is Palermo's sea level
	if o.z < -256 then
		flag:Return()
		BroadCastMessage("The flag was lost at sea and has returned.")
	end
end