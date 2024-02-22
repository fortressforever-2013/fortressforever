
-- ff_dustbowl.lua

-- includes
IncludeScript("base_ad");
IncludeScript("base_location");

-- set teams
ATTACKERS = Team.kBlue
DEFENDERS = Team.kRed

dbhealthkit = genericbackpack:new({
	health = 50,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	touchsound = "HealthKit.Touch"
})
dbarmorkit = genericbackpack:new({
	armor = 200,
	model = "models/items/armour/armour.mdl",
	materializesound = "Item.Materialize",
	touchsound = "ArmorKit.Touch"
})
dbammopack = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 15,
	cells = 130,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbammopack:dropatspawn() return false end

dbgrenadepackone = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	mancannons = 1,
	gren1 = 2,
	gren2 = 2,
	armor = 100,
	health = 300,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbgrenadepackone:dropatspawn() return false end

dbgrenadepacktwo = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	mancannons = 1,
	gren1 = 2,
	gren2 = 2,
	armor = 100,
	health = 100,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbgrenadepacktwo:dropatspawn() return false end

dbammotypeone = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 130,
	armor = 50,
	health = 40,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbammotypeone:dropatspawn() return false end

dbammotypetwo = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 200,
	armor = 25,
	health = 50,
	respawntime = 6,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbammotypetwo:dropatspawn() return false end

dbammotypethree = genericbackpack:new({
	grenades = 30,
	nails = 150,
	shells = 50,
	rockets = 30,
	cells = 200,
	armor = 100,
	health = 75,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbammotypethree:dropatspawn() return false end

dbammotypefour = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 200,
	armor = 100,
	health = 100,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbammotypefour:dropatspawn() return false end

dbammotypefive = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 200,
	armor = 100,
	health = 100,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbammotypefive:dropatspawn() return false end

dbammotypesix = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 130,
	armor = 50,
	health = 50,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbammotypesix:dropatspawn() return false end

dbammotypeseven = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 200,
	armor = 75,
	health = 75,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbammotypeseven:dropatspawn() return false end

dbammotypeeight = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 200,
	armor = 300,
	health = 100,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbammotypeeight:dropatspawn() return false end

dbammotypenine = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 200,
	armor = 30,
	health = 30,
	respawntime = 6,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbammotypenine:dropatspawn() return false end

dbammotypeten = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 150,
	armor = 10,
	health = 20,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbammotypeten:dropatspawn() return false end

dbammotypeeleven = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 200,
	armor = 0,
	health = 20,
	respawntime = 4,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbammotypeeleven:dropatspawn() return false end

dbammotypetwelve = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 100,
	rockets = 20,
	cells = 130,
	armor = 100,
	health = 0,
	respawntime = 3,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbammotypetwelve:dropatspawn() return false end

dbammotypethirteen = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 100,
	armor = 25,
	health = 25,
	respawntime = 5,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbammotypethirteen:dropatspawn() return false end

dbammotypefourteen = genericbackpack:new({
	grenades = 20,
	nails = 50,
	shells = 50,
	rockets = 20,
	cells = 200,
	armor = 0,
	health = 0,
	respawntime = 4,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"
})

function dbammotypefourteen:dropatspawn() return false end
