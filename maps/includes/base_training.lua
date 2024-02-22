-- base_training.lua

-- contains common useful functionality for maps that include training elements.

IncludeScript("base_teamplay")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- helper functions
-----------------------------------------------------------------------------

function restoreEntityByName(name)
	local e = GetInfoScriptByName(name)
	if e ~= nil then e:Restore() end
end

-----------------------------------------------------------------------------
-- glass
-----------------------------------------------------------------------------

breakable_glass = info_ff_script:new({ })

function breakable_glass:spawn() end

function breakable_glass:OnBreak()
	if self.BotSignal ~= nil then
		bot.signal(self.BotSignal.."_OnBreak")
	end	
end

function breakable_glass:ondamage() end

-----------------------------------------------------------------------------
-- Class specific trainer spawns
-----------------------------------------------------------------------------
training_spawn = info_ff_script:new({
	name="Trainer",
	model="",
	botteam=Team.kYellow,
	botclass=0,
	botgoaltype=Bot.kTrainerSpawn,
})

function training_spawn:spawn()
	info_ff_script.spawn(self)
	
	local info = CastToInfoScript(entity)
	info:SpawnBot(self.name, self.botteam, self.botclass);
end

scout_trainer = training_spawn:new({ name="Scout Instructor", botclass=Player.kScout, })
sniper_trainer = training_spawn:new({ name="Sniper Instructor", botclass=Player.kSniper, })
soldier_trainer = training_spawn:new({ name="Soldier Instructor", botclass=Player.kSoldier, })
demoman_trainer = training_spawn:new({ name="Demo-man Instructor", botclass=Player.kDemoman, })
medic_trainer = training_spawn:new({ name="Medic Instructor", botclass=Player.kMedic, })
hwguy_trainer = training_spawn:new({ name="HwGuy Instructor", botclass=Player.kHwguy, })
pyro_trainer = training_spawn:new({ name="Pyro Instructor", botclass=Player.kPyro, })
engineer_trainer  = training_spawn:new({ name="Engineer Instructor", botclass=Player.kEngineer, })
spy_trainer  = training_spawn:new({ name="Spy Instructor", botclass=Player.kSpy, })
civilian_trainer  = training_spawn:new({ name="Civilian Instructor", botclass=Player.kCivilian, })

random_target  = training_spawn:new({ name="Target", botclass=Player.kRandom, })

-----------------------------------------------------------------------------
-- Training buttons
-----------------------------------------------------------------------------

train_button = func_button:new({})
function train_button:allowed() return true end
function train_button:ondamage() end
function train_button:ontouch() end
function train_button:onuse()

	if self.restoreentity ~= nil then
		local e = GetInfoScriptByName(self.restoreentity)
		if e ~= nil then
			e:Restore()
		else
			ConsoleToAll("Could not restore " .. self.restoreentity)
		end
	end

	bot.signal(entity:GetName())
	
	ConsoleToAll(entity:GetName() .. " onuse")
end

function train_button:onfailuse() 
	ConsoleToAll("button failuse") 
end

-----------------------------------------------------------------------------
-- Fake weapon pickups
-----------------------------------------------------------------------------

fakeweapon_spawn = info_ff_script:new({
	model = "models/items/backpack/backpack.mdl",
	weaponname = "ff_weapon_crowbar",
	ammo = {},
	touchsound = "HealthKit.Touch",
	materializesound = "Item.Materialize",
	respawntime = 5,
	removeOnSpawn = false,
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function fakeweapon_spawn:spawn()

	-- temporary override
	--self.model = "models/items/backpack/backpack.mdl"

	info_ff_script.spawn(self)
	
	local info = CastToInfoScript(entity)	
	if self.removeOnSpawn then
		info:Remove()
	end	
end

function fakeweapon_spawn:precache( )
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)
	--PrecacheModel(self.model)
end

function fakeweapon_spawn:materialize( )
	entity:EmitSound(self.materializesound)
end

function fakeweapon_spawn:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		
		local dispensed = 0		
		
		if self.weaponclass ~= nil and not player:OwnsWeaponType(self.weaponclass) then
			player:GiveWeapon(self.weaponclass)
			dispensed = dispensed + 1
		end
		
		if self.weaponclass2 ~= nil and not player:OwnsWeaponType(self.weaponclass2) then
			player:GiveWeapon(self.weaponclass2)
			dispensed = dispensed + 1
		end
			
		-- give player some health and armor
		if self.health ~= nil and self.health ~= 0 then player:AddHealth(self.health) end
		if self.armor ~= nil and self.armor ~= 0 then player:AddArmor(self.armor) end

		-- give the player some ammo
		if self.nails ~= nil and self.nails ~= 0 then player:AddAmmo(Ammo.kNails, self.nails) end
		if self.shells ~= nil and self.shells ~= 0 then player:AddAmmo(Ammo.kShells, self.shells) end
		if self.rockets ~= nil and self.rockets ~= 0 then player:AddAmmo(Ammo.kRockets, self.rockets) end
		if self.cells ~= nil and self.cells ~= 0 then player:AddAmmo(Ammo.kCells, self.cells) end
		if self.detpacks ~= nil and self.detpacks ~= 0 then player:AddAmmo(Ammo.kDetpack, self.detpacks) end
		if self.mancannons ~= nil and self.mancannons ~= 0 then player:AddAmmo(Ammo.kManCannon, self.mancannons) end
		if self.gren1 ~= nil and self.gren1 ~= 0 then player:AddAmmo(Ammo.kGren1, self.gren1) end
		if self.gren2 ~= nil and self.gren2 ~= 0 then player:AddAmmo(Ammo.kGren2, self.gren2) end
		
		if dispensed > 0 then
			local item = CastToInfoScript(entity);
			item:EmitSound(self.touchsound)
			
			-- Do this or don't call Respawn?
			--item:SetStartOrigin(item:GetOrigin())
			--item:SetStartAngles(item:GetAngles())
			
			--item:Remove()
			--item:Respawn(self.respawntime);
		end
		
	end
end

function fakeweapon_spawn:add_weapon( weaponname )
	ConsoleToAll("fakeweapon_spawn:add_weapon " .. weaponname)
	self.weaponclass2 = weaponname
end

-----------------------------------------------------------------------------
-- Weapon pickup variations.
-----------------------------------------------------------------------------

weapon_assaultcannon = fakeweapon_spawn:new({ model = "models/weapons/assaultcannon/w_assaultcannon.mdl", weaponclass = "ff_weapon_assaultcannon", shells = 400 })
weapon_autorifle = fakeweapon_spawn:new({ model = "models/weapons/autorifle/w_autorifle.mdl", weaponclass = "ff_weapon_autorifle", shells = 400 })
weapon_crowbar = fakeweapon_spawn:new({ model = "models/weapons/crowbar/w_crowbar.mdl", weaponclass = "ff_weapon_crowbar", })
weapon_flamethrower = fakeweapon_spawn:new({ model = "models/weapons/flamethrower/w_flamethrower.mdl", weaponclass = "ff_weapon_flamethrower", cells = 400 })
weapon_grenadelauncher = fakeweapon_spawn:new({ model = "models/weapons/grenadelauncher/w_grenadelauncher.mdl", weaponclass = "ff_weapon_grenadelauncher", rockets = 400 })
weapon_incendiarycannon = fakeweapon_spawn:new({ model = "models/weapons/incendiarycannon/w_incendiarycannon.mdl", weaponclass = "ff_weapon_ic", rockets = 400 })
weapon_knife = fakeweapon_spawn:new({ model = "models/weapons/knife/w_knife.mdl", weaponclass = "ff_weapon_knife" })
weapon_medkit = fakeweapon_spawn:new({ model = "models/weapons/medkit/w_medkit.mdl", weaponclass = "ff_weapon_medkit" })
weapon_nailgun = fakeweapon_spawn:new({ model = "models/weapons/nailgun/w_nailgun.mdl", weaponclass = "ff_weapon_nailgun", nails = 400 })
weapon_pipelauncher = fakeweapon_spawn:new({ model = "models/weapons/pipelauncher/w_pipelauncher.mdl", weaponclass = "ff_weapon_pipelauncher", rockets = 400 })
weapon_railgun = fakeweapon_spawn:new({ model = "models/weapons/railgun/w_railgun.mdl", weaponclass = "ff_weapon_railgun", nails = 400 })
weapon_rpg = fakeweapon_spawn:new({ model = "models/weapons/rpg/w_rpg.mdl", weaponclass = "ff_weapon_rpg", rockets = 400 })
weapon_shotgun = fakeweapon_spawn:new({ model = "models/weapons/shotgun/w_shotgun.mdl", weaponclass = "ff_weapon_shotgun", shells = 400 })
weapon_sniperrifle = fakeweapon_spawn:new({ model = "models/weapons/sniperrifle/w_sniperrifle.mdl", weaponclass = "ff_weapon_sniperrifle", nails = 400 })
weapon_spanner = fakeweapon_spawn:new({ model = "models/weapons/spanner/w_spanner.mdl", weaponclass = "ff_weapon_spanner" })
weapon_supernailgun = fakeweapon_spawn:new({ model = "models/weapons/supernailgun/w_supernailgun.mdl", weaponclass = "ff_weapon_supernailgun", nails = 400 })
weapon_supershotgun = fakeweapon_spawn:new({ model = "models/weapons/supershotgun/w_supershotgun.mdl", weaponclass = "ff_weapon_supershotgun", shells = 400 })
weapon_tommygun = fakeweapon_spawn:new({ model = "models/weapons/tommygun/w_tommygun.mdl", weaponclass = "ff_weapon_tommygun", shells = 400 })
weapon_tranq = fakeweapon_spawn:new({ model = "models/weapons/tranq/w_tranq.mdl", weaponclass = "ff_weapon_tranq", nails = 400 })
weapon_umbrella = fakeweapon_spawn:new({ model = "models/weapons/umbrella/w_umbrella.mdl", weaponclass = "ff_weapon_umbrella" })

grenade_pack = fakeweapon_spawn:new({ model = "models/items/backpack/backpack.mdl", gren1 = 4, gren2 = 4 })

weapon_sentry = fakeweapon_spawn:new({ weaponclass = "ff_weapon_deploysentrygun" })
weapon_dispenser = fakeweapon_spawn:new({ weaponclass = "ff_weapon_deploydispenser" })

-----------------------------------------------------------------------------
-- class scanner triggers
-----------------------------------------------------------------------------

function perform_player_scan(player, expectedclass, respawnturret)
	
	if expectedclass ~= player:GetClass() then
		BroadCastMessage("Wrong Class")
		respawnturret.killplayer = true
	else
		--BroadCastMessage("Wrong Class")
	end
end

scanner_class = trigger_ff_script:new({ })

function scanner_class:ontouch( touch_entity )	
	if IsPlayer( touch_entity ) then
		local p = CastToPlayer( touch_entity )
		if not p:IsBot() then
			AddSchedule("perform_player_scan", 0, perform_player_scan, p, self.class, self.turret)
		end
	end	
end

function scanner_class:onendtouch() 
	RemoveSchedule("perform_player_scan")
end

scout_scanner = scanner_class:new({ class=Player.kScout, })
sniper_scanner = scanner_class:new({ class=Player.kSniper, })
soldier_scanner = scanner_class:new({ class=Player.kSoldier, })
demoman_scanner = scanner_class:new({ class=Player.kDemoman, })
medic_scanner = scanner_class:new({ class=Player.kMedic, })
hwguy_scanner = scanner_class:new({ class=Player.kHwguy, })
pyro_scanner = scanner_class:new({ class=Player.kPyro, })
engineer_scanner  = scanner_class:new({ class=Player.kEngineer, })
spy_scanner  = scanner_class:new({ class=Player.kSpy, })
civilian_scanner  = scanner_class:new({ class=Player.kCivilian, })

-----------------------------------------------------------------------------
-- class turrets
-----------------------------------------------------------------------------

scanner_turret = respawnturret:new({ team = Team.kGreen })
function scanner_turret:deploydelay( target_entity ) return 0.5 end

function scanner_turret:validtarget( target_entity ) 
	--local entity = GetEntity(ent_id)
	
	if self.killplayer then 
		local player = CastToPlayer( target_entity )
		if player ~= nil and not player:IsBot() then
			return true
		end
	end
	
	if not AreTeamsAllied(self.team, target_entity:GetTeamId()) then return true end
	
	return false
end

scout_turret = scanner_turret:new({ class=Player.kScout, })
sniper_turret = scanner_turret:new({ class=Player.kSniper, })
soldier_turret = scanner_turret:new({ class=Player.kSoldier, })
demoman_turret = scanner_turret:new({ class=Player.kDemoman, })
medic_turret = scanner_turret:new({ class=Player.kMedic, })
hwguy_turret = scanner_turret:new({ class=Player.kHwguy, })
pyro_turret = scanner_turret:new({ class=Player.kPyro, })
engineer_turret  = scanner_turret:new({ class=Player.kEngineer, })
spy_turret  = scanner_turret:new({ class=Player.kSpy, })
civilian_turret  = scanner_turret:new({ class=Player.kCivilian, })

-----------------------------------------------------------------------------
-- class holograms
-----------------------------------------------------------------------------

base_hologram = info_ff_script:new({ model = "models/player/pyro/pyro.mdl", renderfx = RenderFx.kHologram })

scout_hologram = base_hologram:new({ model = "models/player/scout/scout.mdl" })
sniper_hologram = base_hologram:new({ model = "models/player/sniper/sniper.mdl" })
soldier_hologram = base_hologram:new({ model = "models/player/soldier/soldier.mdl" })
demoman_hologram = base_hologram:new({ model = "models/player/demoman/demoman.mdl" })
medic_hologram = base_hologram:new({ model = "models/player/medic/medic.mdl" })
hwguy_hologram = base_hologram:new({ model = "models/player/hwguy/hwguy.mdl" })
pyro_hologram = base_hologram:new({ model = "models/player/pyro/pyro.mdl" })
engineer_hologram = base_hologram:new({ model = "models/player/engineer/engineer.mdl" })
spy_hologram = base_hologram:new({ model = "models/player/spy/spy.mdl" })

-----------------------------------------------------------------------------
-- Beams
-----------------------------------------------------------------------------

base_beam = baseclass:new({ startstate="on",startcolor="0 255 0" })
function base_beam:spawn()

	if startstate == "on" then
		OutputEvent( entity:GetName(), "TurnOn" )
	else
		OutputEvent( entity:GetName(), "TurnOff" )
	end
	
	if startstate ~= nil then
		OutputEvent( entity:GetName(), "Color", startcolor )
	end
	
end

function base_beam:turnon()
	OutputEvent( entity:GetName(), "TurnOn" )
end

function base_beam:turnoff()
	OutputEvent( entity:GetName(), "TurnOff" )
end

function base_beam:setcolor(newcolor)
	if newcolor ~= nil then
		OutputEvent( entity:GetName(), "Color", newcolor )
	end
end

-----------------------------------------------------------------------------
-- training room triggers
-----------------------------------------------------------------------------
training_room = trigger_ff_script:new({ })

function training_room:allowed() 

--  	if self.restrictClass ~= nil then
--  		entity:EmitSound(self.speakOnceOnEnter)
--  	end

	return EVENT_ALLOWED 
end

function training_room:ontrigger() 
	--ConsoleToAll("training_room:ontrigger() ")	
end

function training_room:ontouch( touch_entity ) 
	if IsPlayer( touch_entity ) then
		local p = CastToPlayer( touch_entity )
		if not p:IsBot() then
			bot.signal(entity:GetName())
		end
	end	
	
	------------------
	ConsoleToAll(entity:GetName() .. " ontouch")
	------------------
end

function training_room:onendtouch() 
	------------------
	ConsoleToAll(entity:GetName() .. " onendtouch")
	------------------
end

function training_room:onfailtouch() 
end

function training_room:onexplode() 
	return EVENT_ALLOWED 
end

function training_room:onbuild() 
	return EVENT_ALLOWED
end

function training_room:onfailuse() 
end

function training_room:onuse() 
	
end

function training_room:onactive() 
end

function training_room:oninactive() 
end

function training_room:onremoved() 

end

function training_room:onrestored() 
end

function training_room:spawn() 
	
end

-----------------------------------------------------------------------------
-- current training status
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
-- bot helper functions
-----------------------------------------------------------------------------
function restore_entity(entname)
	local info = GetInfoScriptByName(entname)
	if info ~= nil then
		info:Restore()
	end
end

function remove_entity(entname)
	local info = GetInfoScriptByName(entname)
	if info ~= nil then
		info:Remove()
	end
end

function update_grenadecount(entname, g1, g2)
	local info = GetInfoScriptByName(entname)
	if info ~= nil then
		info.gren1 = tonumber(g1)
		info.gren2 = tonumber(g2)
	end
end

function vec_tostring(v)
	return string.format("%f %f %f", v.x, v.y, v.z)
end

bot = {}

bot.spawnAtEntity = function(spawnent, name, team, class)
	local info = GetInfoScriptByName(spawnent)
	if info ~= nil then
		info:SpawnBot(name, team, class);
	end		
end

bot.sendMsg = function(botname, msg, d1, d2, d3)
	local p = GetPlayerByName(botname)
	if p ~= nil then
		p:SendBotMessage(msg, d1, d2, d3)
	else
		ConsoleToAll("bot.sendMsg: player not found: " .. botname)
	end
end

bot.signal = function(signalname)
	SendBotSignal(signalname)
end

bot.moveTo = function(botname, targetentity)
	local e = GetEntityByName(targetentity)
	if e ~= nil then
		local epos = e:GetOrigin()
		local eface = e:GetAbsFacing()
		-- convert epos to string
		bot.sendMsg(botname, "run_to", vec_tostring(epos), vec_tostring(eface))
	end
end

bot.setIdlePoint = function(botname, targetentity)
	local e = GetEntityByName(targetentity)
	if e ~= nil then
		local epos = e:GetOrigin()
		local eface = e:GetAbsFacing()
		-- convert epos to string
		bot.sendMsg(botname, "set_idle_position", vec_tostring(epos), vec_tostring(eface))
	end
end

bot.leaveGame = function(botname)
	bot.sendMsg(botname, "leave_game")
end

--  teleportTo(botname, targetEntName)
--  	local p = GetPlayerByName(botname)
--  	local e = GetEntityByName(targetentity)
--  	if p ~= nil and e ~= nil then
--  		p:SetOrigin(e:GetOrigin())
--  		p:SetAngles(e:GetAngles())
--  	else
--  		ConsoleToAll("teleportTo: player not found: " .. botname)
--  	end
--  end

function player_giveweapon(weaponname, as)
	local c = Collection()
	c:GetByFilter({ CF.kHumanPlayers })
 	for temp in c.items do
		local player = CastToPlayer( temp )
		local autoselect = false
		if as == "true" then autoselect = true end
 		player:GiveWeapon(weaponname, autoselect)
	end
end

function player_giveammo(ammoname, amount)
	local c = Collection()
	c:GetByFilter({ CF.kHumanPlayers })
 	for temp in c.items do
		local player = CastToPlayer( temp )
		if ammoname == "nails" then player:AddAmmo(Ammo.kNails, tonumber(amount)) end
		if ammoname == "shells" then player:AddAmmo(Ammo.kShells, tonumber(amount)) end
		if ammoname == "rockets" then player:AddAmmo(Ammo.kRockets, tonumber(amount)) end
		if ammoname == "cells" then player:AddAmmo(Ammo.kCells, tonumber(amount)) end
		if ammoname == "detpack" then player:AddAmmo(Ammo.kDetpack, tonumber(amount)) end
		if ammoname == "mancannon" then player:AddAmmo(Ammo.kManCannon, tonumber(amount)) end
		if ammoname == "gren1" then player:AddAmmo(Ammo.kGren1, tonumber(amount)) end
		if ammoname == "gren2" then player:AddAmmo(Ammo.kGren2, tonumber(amount)) end
	end
end
function player_removeweapon(weaponname)
	local c = Collection()
	c:GetByFilter({ CF.kHumanPlayers })
 	for temp in c.items do
		local player = CastToPlayer( temp )
 		player:RemoveWeapon(weaponname)
	end
end

function player_givedetpack()
	local c = Collection()
	c:GetByFilter({ CF.kHumanPlayers })
 	for temp in c.items do
		local player = CastToPlayer( temp )
 		player:AddAmmo(Ammo.kDetpack, 1)
	end
end

function player_givemancannon()
	local c = Collection()
	c:GetByFilter({ CF.kHumanPlayers })
 	for temp in c.items do
		local player = CastToPlayer( temp )
 		player:AddAmmo(Ammo.kManCannon, 1)
	end
end

function player_givegren1()
	local c = Collection()
	c:GetByFilter({ CF.kHumanPlayers })
 	for temp in c.items do
		local player = CastToPlayer( temp )
 		player:AddAmmo(Ammo.kGren1, 4)
	end
end

function player_givegren2()
	local c = Collection()
	c:GetByFilter({ CF.kHumanPlayers })
 	for temp in c.items do
		local player = CastToPlayer( temp )
 		player:AddAmmo(Ammo.kGren2, 4)
	end
end

function player_removehealth(playername, amt)
	p = GetPlayerByName(playername)
	if p ~= nil then
		p:AddHealth(-tonumber(amt))
	else
		ConsoleToAll("player_removehealth: Unable to find " .. playername)
	end
end

function player_removearmor(playername, amt)
	p = GetPlayerByName(playername)
	if p ~= nil then
		p:RemoveArmor(tonumber(amt))
	else
		ConsoleToAll("player_removehealth: Unable to find " .. playername)
	end
end

function player_forcerespawn(playername, amt)
	p = GetPlayerByName(playername)
	if p ~= nil then
		ApplyToPlayer(p, { AT.kRespawnPlayers })
	else
		ConsoleToAll("player_forcerespawn: Unable to find " .. playername)
	end
end

function broadcast_message(message)
	BroadCastMessage(message)
end

function training_intro(classname)
	if classname == "Scout" then
		BroadCastSound("training.fem_scout_ovr")
	elseif classname == "Sniper" then
		BroadCastSound("training.fem_sniper_ovr")
	elseif classname == "Soldier" then
		BroadCastSound("training.fem_soldier_ovr")
	elseif classname == "Demoman" then
		BroadCastSound("training.fem_demo_ovr")
	elseif classname == "Medic" then
		BroadCastSound("training.fem_medic_ovr")
	elseif classname == "HwGuy" then
		BroadCastSound("training.fem_hwguy_ovr")
	elseif classname == "Pyro" then
		BroadCastSound("training.fem_pyro_ovr")
	elseif classname == "Spy" then
		BroadCastSound("training.fem_spy_ovr")
	elseif classname == "Engineer" then
		BroadCastSound("training.fem_engy_ovr")
	end
end

function section_complete(sectionname, room)
	BroadCastSound("training.section_complete")
end

function training_complete(classname)
	if classname == "Scout" then
		BroadCastSound("training.fem_scout_comp")
	elseif classname == "Sniper" then
		BroadCastSound("training.fem_sniper_comp")
	elseif classname == "Soldier" then
		BroadCastSound("training.fem_soldier_comp")
	elseif classname == "Demoman" then
		BroadCastSound("training.fem_demo_comp")
	elseif classname == "Medic" then
		BroadCastSound("training.fem_medic_comp")
	elseif classname == "HwGuy" then
		BroadCastSound("training.fem_hwguy_comp")
	elseif classname == "Pyro" then
		BroadCastSound("training.fem_pyro_comp")
	elseif classname == "Spy" then
		BroadCastSound("training.fem_spy_comp")
	elseif classname == "Engineer" then
		BroadCastSound("training.fem_engy_comp")
	end
end

function training_classname(classId)
	if classId == Player.kScout then return "Scout" end
	if classId == Player.kSniper then return "Sniper" end
	if classId == Player.kSoldier then return "Soldier" end
	if classId == Player.kDemoman then return "Demoman" end
	if classId == Player.kMedic then return "Medic" end
	if classId == Player.kHwguy then return "HwGuy" end
	if classId == Player.kPyro then return "Pyro" end
	if classId == Player.kSpy then return "Spy" end
	if classId == Player.kEngineer then return "Engineer" end
	if classId == Player.kCivilian then return "Civilian" end
end


