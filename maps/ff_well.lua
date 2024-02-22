
-- ff_well.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf")
IncludeScript("base_teamplay")
IncludeScript("base_location")
IncludeScript("base_respawnturret")

-----------------------------------------------------------------------------
-- global overrides
-----------------------------------------------------------------------------
POINTS_PER_CAPTURE = 10
FLAG_RETURN_TIME = 60
-----------------------------------------------------------------------------
-- Locations
-----------------------------------------------------------------------------
location_blue_frupper = location_info:new({ text = "Flag Room Catwalks", team = Team.kBlue })
location_red_frupper = location_info:new({ text = "Flag Room Catwalks", team = Team.kRed })

location_blue_frlower = location_info:new({ text = "Lower Flag Room", team = Team.kBlue })
location_red_frlower = location_info:new({ text = "Lower Flag Room", team = Team.kRed })

location_blue_frwater = location_info:new({ text = "Flag Room Water", team = Team.kBlue })
location_red_frwater = location_info:new({ text = "Flag Room Water", team = Team.kRed })

location_blue_ladder = location_info:new({ text = "Battlements Ladder", team = Team.kBlue })
location_red_ladder = location_info:new({ text = "Battlements Ladder", team = Team.kRed })

location_blue_concexit = location_info:new({ text = "Conc Route Exit", team = Team.kBlue })
location_red_concexit = location_info:new({ text = "Conc Route Exit", team = Team.kRed })

location_blue_canal = location_info:new({ text = "Yard Canal", team = Team.kBlue })
location_red_canal = location_info:new({ text = "Yard Canal", team = Team.kRed })


-----------------------------------------------------------------------------
-- Doors
-----------------------------------------------------------------------------


blue_door1_trigger = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_door1_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_door1_trigger:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_door1_left", "Open") 
      OutputEvent("blue_door1_right", "Open") 
   end 
end 


blue_door2_trigger = trigger_ff_script:new({ team = Team.kBlue }) 

function blue_door2_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function blue_door2_trigger:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("blue_door2_left", "Open") 
      OutputEvent("blue_door2_right", "Open") 
   end 
end

red_door1_trigger = trigger_ff_script:new({ team = Team.kRed }) 

function red_door1_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_door1_trigger:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_door1_left", "Open") 
      OutputEvent("red_door1_right", "Open") 
   end 
end 


red_door2_trigger = trigger_ff_script:new({ team = Team.kRed }) 

function red_door2_trigger:allowed( touch_entity ) 
   if IsPlayer( touch_entity ) then 
             local player = CastToPlayer( touch_entity ) 
             return player:GetTeamId() == self.team 
   end 

        return EVENT_DISALLOWED 
end 

function red_door2_trigger:ontrigger( touch_entity ) 
   if IsPlayer( touch_entity ) then 
      OutputEvent("red_door2_left", "Open") 
      OutputEvent("red_door2_right", "Open") 
   end 
end


-----------------------------------------------------------------------------
-- backpacks
-----------------------------------------------------------------------------

wellpackgeneric = genericbackpack:new({
	health = 20,
	armor = 15,
	grenades = 60,
	nails = 60,
	shells = 60,
	rockets = 60,
	cells = 60,
	mancannons = 1,
	gren1 = 1,
	gren2 = 1,
	respawntime = 35,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	botgoaltype = Bot.kBackPack_Ammo
})

function wellpackgeneric:dropatspawn() return false end

-----------------------------------------------------------------------------
-- Grates
-----------------------------------------------------------------------------

base_grate_trigger = trigger_ff_script:new({ team = Team.kUnassigned, team_name = "neutral" })

function base_grate_trigger:onexplode( explosion_entity )
	if IsDetpack( explosion_entity ) then
		local detpack = CastToDetpack( explosion_entity )

		-- GetTemId() might not exist for buildables, they have their own seperate shit and it might be named differently
		if detpack:GetTeamId() ~= self.team then
			OutputEvent( self.team_name .. "_grate", "Kill" )
			OutputEvent( self.team_name .. "_grate_wall", "Kill" )
			if self.team_name == "red" then BroadCastMessage("#FF_RED_GRATEBLOWN") end
			if self.team_name == "blue" then BroadCastMessage("#FF_BLUE_GRATEBLOWN") end
		end
	end

	-- I think this is needed so grenades and other shit can blow up here. They won't fire the events, though.
	return EVENT_ALLOWED
end

red_grate_trigger = base_grate_trigger:new({ team = Team.kRed, team_name = "red" })
blue_grate_trigger = base_grate_trigger:new({ team = Team.kBlue, team_name = "blue" })


-----------------------------------------------------------------------------
-- Buttons
-----------------------------------------------------------------------------

blue_fr_button = func_button:new({}) 
function blue_fr_button:ondamage() OutputEvent( "blue_fr_grate_r", "Open" ) end 
function blue_fr_button:ondamage() OutputEvent( "blue_fr_grate_l", "Open" ) end 
function blue_fr_button:ontouch() OutputEvent( "blue_fr_grate_r", "Open" ) end 
function blue_fr_button:ontouch() OutputEvent( "blue_fr_grate_l", "Open" ) end 

red_fr_button = func_button:new({}) 
function red_fr_button:ondamage() OutputEvent( "red_fr_grate_r", "Open" ) end 
function red_fr_button:ondamage() OutputEvent( "red_fr_grate_l", "Open" ) end 
function red_fr_button:ontouch() OutputEvent( "red_fr_grate_r", "Open" ) end 
function red_fr_button:ontouch() OutputEvent( "red_fr_grate_l", "Open" ) end 

blue_fd_button = func_button:new({}) 
function blue_fd_button:ondamage() OutputEvent( "blue_door0", "Open" ) end 
function blue_fd_button:ontouch() OutputEvent( "blue_door0", "Open" ) end 

red_fd_button = func_button:new({}) 
function red_fd_button:ondamage() OutputEvent( "red_door0", "Open" ) end  
function red_fd_button:ontouch() OutputEvent( "red_door0", "Open" ) end 

