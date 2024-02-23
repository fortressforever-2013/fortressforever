IncludeScript("base_id");
IncludeScript("base_respawnturret");
IncludeScript("base_location");

respawnturret_attackers = base_respawnturret:new({ team = attackers })
respawnturret_defenders = base_respawnturret:new({ team = defenders })

cornhealthkit = genericbackpack:new({
	health = 50,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	touchsound = "HealthKit.Touch"
})
cornarmorkit = genericbackpack:new({
	armor = 200,
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",
	touchsound = "ArmorKit.Touch"
})
cornammopack = genericbackpack:new({
	health = 35,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 70,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function cornammopack:dropatspawn() return false 
end

corngrenadepack = genericbackpack:new({
	health = 35,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 70,
	mancannons = 1,
	gren1 = 2,
	gren2 = 1,
	respawntime = 30,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function corngrenadepack:dropatspawn() return false 
end

detpack_wall_open = nil

function onroundreset()
	-- close the door
	if detpack_wall_open then
		-- there's no "close".. wtf
		OutputEvent("detpack_hole", "Toggle")
		detpack_wall_open = nil
	end
	-- Reset The Turrets
	respawnturret_attackers = base_respawnturret:new({ team = attackers })
	respawnturret_defenders = base_respawnturret:new({ team = defenders })
end

detpack_trigger = trigger_ff_script:new({})
function detpack_trigger:onexplode( trigger_entity )
	if IsDetpack( trigger_entity ) then
		ConsoleToAll("The door has been blown open!")
		OutputEvent("detpack_hole", "Toggle")
		detpack_wall_open = true			
	end
	return EVENT_ALLOWED
end

-- Don't want any body touching/triggering it except the detpack
function trigger_detpackable_door:allowed( trigger_entity ) return EVENT_DISALLOWED 
end

