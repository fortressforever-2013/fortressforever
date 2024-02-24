
-- base.lua


-----------------------------------------------------------------------------
-- This file is loaded automatically whenever a map is loaded.
-- Do not change this file.
-----------------------------------------------------------------------------

require "util.utils"
Class = require "util.class"
Collection = require "util.collection"

-----------------------------------------------------------------------------
-- defines
-----------------------------------------------------------------------------
-- Events
EVENT_ALLOWED = true
EVENT_DISALLOWED = false


-----------------------------------------------------------------------------
-- set a cvar, but check to make sure it's not already set correctly
-----------------------------------------------------------------------------
function set_cvar( cvarname, value )
	if GetConvar( cvarname ) ~= value then
		SetConvar( cvarname, value )
	end
end


-----------------------------------------------------------------------------
-- Output Events
-----------------------------------------------------------------------------
function OpenDoor(name) OutputEvent( name, "Open" ) end
function CloseDoor(name) OutputEvent( name, "Close" ) end
function ToggleDoor(name) OutputEvent( name, "Toggle" ) end


-----------------------------------------------------------------------------
-- baseclass (everything derives from this guy)
-----------------------------------------------------------------------------
baseclass = { }
function baseclass:new (o)
	-- create object if user does not provide one
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end


-----------------------------------------------------------------------------
-- set up pairs and ipairs for iterating the global entity list
--
-- Example usage:
--
--   for ent_id, ent in pairs(GlobalEntityList) do
--     print(ent_id, ent)
--   end
--
-- Note: The order of iteration is always arbitrary
-----------------------------------------------------------------------------
local GlobalEntityListIterator = function()
	local entity = GlobalEntityList:FirstEntity()
	return function()
		local cur_ent = entity
		entity = GlobalEntityList:NextEntity(cur_ent)
		if cur_ent then
			return cur_ent:GetId(), cur_ent
		else
			return nil
		end
	end
end

local ipairs_base = ipairs
ipairs = function(t)
	if t == GlobalEntityList then
		return GlobalEntityListIterator()
	end
	return ipairs_base(t)
end

local pairs_base = pairs
pairs = function(t)
	if t == GlobalEntityList then
		return GlobalEntityListIterator()
	end
	return pairs_base(t)
end


-----------------------------------------------------------------------------
-- make luabind's class_info function safer
-- (don't crash if class_info() is called on non-luabind objects)
-----------------------------------------------------------------------------
local class_info_base = class_info
class_info = function(obj)
	local obj_type = type(obj)
	if obj_type == "userdata" and getmetatable(obj).__luabind_class then
		return class_info_base(obj)
	end
	return {}
end


-----------------------------------------------------------------------------
-- reset everything
-----------------------------------------------------------------------------
function RespawnAllPlayers()
	ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips, AT.kAllowRespawn, AT.kReturnDroppedItems })
end


-----------------------------------------------------------------------------
-- lowercase c "Broadcast" functions, because uppercase C "BroadCast" functions are lame
-----------------------------------------------------------------------------
function BroadcastMessage( message )
	BroadCastMessage( message )
end

function BroadcastMessageToPlayer( player, message )
	BroadCastMessageToPlayer( player, message )
end

function BroadcastSound( soundname )
	BroadCastSound( soundname )
end

function BroadcastSoundToPlayer( player, soundname )
	BroadCastSoundToPlayer( player, soundname )
end


-----------------------------------------------------------------------------
-- trigger_ff_script
-----------------------------------------------------------------------------
trigger_ff_script = baseclass:new({})
function trigger_ff_script:allowed() return EVENT_ALLOWED end
function trigger_ff_script:ontouch() end
function trigger_ff_script:ontrigger() end
function trigger_ff_script:onendtouch() end
function trigger_ff_script:onfailtouch() end
function trigger_ff_script:onexplode() return EVENT_ALLOWED end
function trigger_ff_script:onbuild() return EVENT_ALLOWED end
function trigger_ff_script:onfailuse() end
function trigger_ff_script:onuse() end
function trigger_ff_script:onactive() end
function trigger_ff_script:oninactive() end
function trigger_ff_script:onremoved() end
function trigger_ff_script:onrestored() end

function trigger_ff_script:spawn() 
	
	-- notify the bot if this is a goal type
	local info = CastToTriggerScript(entity)
	if(info ~= nil) then
		if self.botgoaltype and self.team then
		   info:SetBotGoalInfo(self.botgoaltype, self.team)
		end		
	end
end


-----------------------------------------------------------------------------
-- trigger_ff_clip
-----------------------------------------------------------------------------
trigger_ff_clip = baseclass:new({})
function trigger_ff_clip:spawn()
	local clip = CastToTriggerClip(entity)
	if (clip ~= nil) then
		if self.clipflags then
			clip:SetClipFlags(self.clipflags)
		end
	end
end


-----------------------------------------------------------------------------
-- func_button
-----------------------------------------------------------------------------
func_button = baseclass:new({})
function func_button:allowed() return true end
function func_button:ondamage() end
function func_button:ontouch() end
function func_button:onuse() end
function func_button:onfailuse() end


-----------------------------------------------------------------------------
-- info_ff_script
-----------------------------------------------------------------------------
info_ff_script = baseclass:new({ model = "models/items/healthkit.mdl" })
function info_ff_script:onreturn() end
function info_ff_script:ondrop() end
function info_ff_script:onownerdie() end
function info_ff_script:onownerforcerespawn() end
function info_ff_script:onownerfeign() end
function info_ff_script:onactive() end
function info_ff_script:oninactive() end
function info_ff_script:onremoved() end
function info_ff_script:onrestored() end
function info_ff_script:onexplode() end
function info_ff_script:dropatspawn() return false end
function info_ff_script:usephysics() return false end
function info_ff_script:hasshadow() return true end

-- anims must be named certain things...
function info_ff_script:hasanimation() return false end 

-- For when this object is carried, these offsets are used to place
-- the info_ff_script relative to the objects GetAbsOrigin()
function info_ff_script:attachoffset()
	local offset = Vector( 0, 0, 0 )
	return offset
end

function info_ff_script:precache()
	PrecacheModel(self.model)
end

function info_ff_script:spawn()
	-- set model and skin
	local info = CastToInfoScript( entity )
	info:SetModel(self.model)
	if self.modelskin then
		info:SetSkin(self.modelskin)
	end

	-- setup touch flags
	if self.touchflags ~= nil then info:SetTouchFlags(self.touchflags) end
	if self.disallowtouchflags ~= nil then info:SetDisallowTouchFlags(self.disallowtouchflags) end

	-- notify the bot if this is a goal type
	if(info ~= nil) then
		if self.botgoaltype then
		   info:SetBotGoalInfo(self.botgoaltype)
		end
	end
	
	if self.renderfx ~= nil then
		info:SetRenderFx(self.renderfx)
	end
end
function info_ff_script:gettouchsize( mins, maxs ) end
function info_ff_script:getphysicssize( mins, maxs ) end
function info_ff_script:getbloatsize() return 12 end


-----------------------------------------------------------------------------
-- info_ff_teamspawn
-----------------------------------------------------------------------------
info_ff_teamspawn = baseclass:new({})
function info_ff_teamspawn:validspawn() return true end

function NormalizeInt(x)
	if x == nil then return end
	if type( x ) ~= "number" then return end
	
	if x == 0 then return x end
	
	if ( x > 0 and x < 1 ) then return math.ceil(x) end
	
	if ( math.ceil( x ) - x ) > 0.5 then return math.ceil( x )
	else return math.floor( x ) end
end