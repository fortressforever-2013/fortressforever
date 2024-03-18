--[[
================================================================================================================
== base_chatcommands.lua
== -- Allows maps to use player chat as commands to perform
== -- various functions
================================================================================================================
== Instructions
== -- To add commands:
=~~ Code: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
chatbase_addcommand( "commandname", "Command description", "command example" )
function chat_commandname( player, parameter1, parameter2, ... )
	-- perform some task
end
=~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
== -- The description and example parameters are both optional
== -- Do NOT put the command prefix in either the example or the commandname parameters
== -- The player parameter will always get sent to chat_commandname functions, but the others are optional
== -- Parameters are sent by players in this format !commandname param1 param2 ...
== -- 
== -- To add player settings:
=~~ Code: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
chatbase_addplayersetting( "settingname", default_value, "Setting description" )
=~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
== -- The description is optional
== --
== -- To get a setting value for a player:
=~~ Code: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
chatbase_getplayersetting( player, "settingname" )
=~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
== -- 
== -- To set a setting value for a player:
=~~ Code: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
chatbase_setplayersetting( player, "settingname", value )
=~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
== --
== -- Settings:
== -- -- The settings below should be copied, pasted, and altered into your maps .lua if you want to 
== -- -- change any of them
================================================================================================================
]]--

-- chat command settings
CHAT_COMMAND_PREFIX = "!"						-- Command prefix, all commands must start with this string
CHAT_COMMAND_HIDECHATSTRING = true 				-- Determines if the chat string is shown if it executes a command
CHAT_COMMAND_DISABLE_PERIODIC_NOTIFY = false	-- If false, the server will notify players that chat commands
												-- are enabled for the map ONLY IF non-default chat commands exist
CHAT_COMMAND_PERIODIC_NOTIFY_REPEAT = 0			-- Number of times to repeat the notification (set to -1 for infinite)
CHAT_COMMAND_PERIODIC_NOTIFY_PERIOD = 60		-- Time between notifications (in seconds)

-- theme settings
-- 0 = orange	1 = blue	2 = red		3 = yellow		4 = green
-- 5 = white	6 = black	7 = gray	8 = purple		9 = teal	
CHAT_COMMAND_COLOR_MAIN 			= 0  		-- used most often
CHAT_COMMAND_COLOR_HIGHLIGHT1 		= 5  		-- used to emphasize something
CHAT_COMMAND_COLOR_HIGHLIGHT2 		= 5  		-- used to emphasize something
CHAT_COMMAND_COLOR_HIGHLIGHT3 		= 5  		-- used to emphasize something
CHAT_COMMAND_COLOR_ERROR			= 2  		-- used for error messages

-- chat command debug settings
CHAT_COMMAND_DEBUG = false
CHAT_COMMAND_DEBUG_PREFIX = "[lua-chatcommands] "

--[[
=====================================
== GLOBAL VARS
=====================================
== Do NOT edit these unless you know
== exactly what you're doing
=====================================
]]--

-- chat commands global table
chatbase_commands = {}
chatbase_players = {}
chatbase_settings = {}

chatbase_defaultcommands = {"help","disablenotify"}

--[[
=====================================
== CHAT COMMAND FUNCTIONS
=====================================
== 
=====================================
]]--

-------------------------------------
-- Setup
-------------------------------------

function chatbase_addcommand( command, description, example )
	chatbase_debug( "Adding command "..tostring(command).." with desc "..tostring(description).." and example "..tostring(example) )
	chatbase_commands[command] = {}
	chatbase_commands[command].description = description
	chatbase_commands[command].example = example
end

function chatbase_addplayersetting( setting, default, description )
	chatbase_debug( "Adding setting "..tostring(setting).." with default "..tostring(default).." and desc "..tostring(description) )
	chatbase_settings[setting] = {}
	chatbase_settings[setting].default = default
	chatbase_settings[setting].description = description
end

-------------------------------------
-- Utilities
-------------------------------------

function chatbase_customcommandsexist()
	-- check that non-default commands exist
	chatbase_debug("Checking if custom commands exist")
	local nondefexist = false
	for command,values in pairs(chatbase_commands) do
		local found = false
		chatbase_debug("Checking command "..tostring(command))
		for i,defcommand in pairs(chatbase_defaultcommands) do
			chatbase_debug("  -> Against default command "..tostring(defcommand))
			if defcommand == command then
				chatbase_debug("Command "..tostring(command).." is default")
				found = true
			end
		end
		if not found then
			chatbase_debug("Command "..tostring(command).." is not default")
			nondefexist = true
			break;
		end
	end
	
	chatbase_debug("Custom commands exist: "..tostring(nondefexist))
	return nondefexist;
end

-------------------------------------
-- Notifications
-------------------------------------

function chatbase_setupnotify()
	chatbase_debug("setupnotify called")
	-- if notifications are completely disabled, return early
	if CHAT_COMMAND_DISABLE_PERIODIC_NOTIFY then return end
	chatbase_debug("setupnotify got past disabled check")
	
	-- if only default commands exist, then theres no reason to notify
	if not chatbase_customcommandsexist() then return end
	chatbase_debug("setupnotify got past custom commands check")
	
	-- call a function that will notify anyone that meets the requirements every NOTIFY_PERIOD
	AddScheduleRepeating( "chatbase_notifyenabled", CHAT_COMMAND_PERIODIC_NOTIFY_PERIOD, chatbase_notifyenabled )
end

-- wait 10 seconds to setup notification, just to be safe that all commands are registered
AddSchedule("chatbase_setupnotify", 10, chatbase_setupnotify)

function chatbase_notifyenabled()
	chatbase_debug("notifyenabled called")
	-- if notifications are completely disabled, return early
	if CHAT_COMMAND_DISABLE_PERIODIC_NOTIFY then return end
	chatbase_debug("notifyenabled got past disabled check")
	
	-- if only default commands exist, then theres no reason to notify
	if not chatbase_customcommandsexist() then return end
	chatbase_debug("notifyenabled got past custom commands check")
	
	-- notify any players that deserve it
	for i,v in pairs(chatbase_players) do
		chatbase_debug("checking player ID "..i)
		local player = CastToPlayer(v.player)
		if IsPlayer(player) then
			chatbase_debug("--> IsPlayer")
			-- only notify if they havent set their setting to disable notifications
			if v.settings["disablenotify"] ~= true then
				chatbase_debug("--> disablenotify not true | REPEAT: "..CHAT_COMMAND_PERIODIC_NOTIFY_REPEAT.." numtimesnotified: "..tostring(v.settings["numtimesnotified"]))
				-- check repeat type
				if CHAT_COMMAND_PERIODIC_NOTIFY_REPEAT == 0 and v.settings["numtimesnotified"] == 0 then
					-- only show once
					v.settings["numtimesnotified"] = v.settings["numtimesnotified"]+1
					chatbase_notifyplayer(player)
				end
				if CHAT_COMMAND_PERIODIC_NOTIFY_REPEAT > 0 and v.settings["numtimesnotified"] <= CHAT_COMMAND_PERIODIC_NOTIFY_REPEAT then
					-- repeat a set number of times
					v.settings["numtimesnotified"] = v.settings["numtimesnotified"]+1
					chatbase_notifyplayer(player)
				end
				if CHAT_COMMAND_PERIODIC_NOTIFY_REPEAT < 0 then
					-- repeat infinitely (var is set to a negative number)
					v.settings["numtimesnotified"] = v.settings["numtimesnotified"]+1
					chatbase_notifyplayer(player)
				end
			end
		end
	end
end

function chatbase_notifyplayer(player)
	if not IsPlayer(player) then chatbase_error("function chatbase_notifyplayer: Notifying a nonplayer"); return; end
	ChatToPlayer(player, "^"..CHAT_COMMAND_COLOR_MAIN.."Chat commands are enabled for this map. Type "..CHAT_COMMAND_PREFIX.."help to see what is available")
end

-------------------------------------
-- Player Table Functions
-------------------------------------

function chatbase_addplayer(player)
	if not IsPlayer(player) then chatbase_error("function chatbase_addplayer: Trying to add a nonplayer"); return; end
	
	-- add an entry for the player
	chatbase_players[player:GetId()] = {}
	chatbase_players[player:GetId()].player = player
	chatbase_players[player:GetId()].settings = {}
	for setting,values in pairs(chatbase_settings) do
		chatbase_players[player:GetId()].settings[setting] = values.default
	end
end

function chatbase_removeplayer(player)
	-- param could be a player or a playerid
	if tonumber(player) then player = GetPlayerByID(player) end
	if not IsPlayer(player) then chatbase_error("function chatbase_removeplayer: Trying to remove a nonplayer"); return; end
	
	-- clear their entry
	chatbase_players[player:GetId()] = nil
end

-------------------------------------
-- Player Settings Functions
-------------------------------------

function chatbase_getplayersetting( player, setting )
	-- param could be a player or a playerid
	if tonumber(player) then player = GetPlayerByID(player) end
	if not IsPlayer(player) then chatbase_error("function chatbase_getplayersetting: Trying to get setting of a nonplayer"); return nil; end
	
	if chatbase_players[player:GetId()] ~= nil then
		return chatbase_players[player:GetId()].settings[setting]
	else
		chatbase_error("function chatbase_getplayersetting: Player not found in the table");
		return nil
	end
end

function chatbase_setplayersetting( player, setting, value )
	-- param could be a player or a playerid
	if tonumber(player) then player = GetPlayerByID(player) end
	if not IsPlayer(player) then chatbase_error("function chatbase_setplayersetting: Trying to set setting of a nonplayer"); return false; end
	
	if chatbase_players[player:GetId()] ~= nil then
		chatbase_players[player:GetId()].settings[setting] = value;
		return true
	else
		chatbase_error("function chatbase_setplayersetting: Player not found in the table");
		return false
	end
end

-------------------------------------
-- Debug/Messaging
-------------------------------------

function chatbase_error( str )
	ConsoleToAll(CHAT_COMMAND_DEBUG_PREFIX.."[ERROR] "..str)
end

function chatbase_debug( str )
	if CHAT_COMMAND_DEBUG then ConsoleToAll(CHAT_COMMAND_DEBUG_PREFIX..str) end
end

--[[
=====================================
== DEFAULT COMMAND IMPLEMENTATION
=====================================
== 
=====================================
]]--

chatbase_addcommand( "help", "Display a list of all available commands" )
function chat_help( player )
	ChatToPlayer( player, "^"..CHAT_COMMAND_COLOR_MAIN.."Chat Commands:")
	for command,values in pairs(chatbase_commands) do
		local command_text = "^"..CHAT_COMMAND_COLOR_HIGHLIGHT1..CHAT_COMMAND_PREFIX..command
		if values.description ~= nil then
			command_text = command_text.. " ^"..CHAT_COMMAND_COLOR_MAIN.."- ".."^"..CHAT_COMMAND_COLOR_HIGHLIGHT2..values.description
		end
		if values.example ~= nil then
			command_text = command_text.. " ^"..CHAT_COMMAND_COLOR_MAIN.."(example: "..CHAT_COMMAND_PREFIX..values.example..")"
		end
		ChatToPlayer( player, command_text )
	end
end

if not CHAT_COMMAND_DISABLE_PERIODIC_NOTIFY then

chatbase_addcommand( "disablenotify", "Disables the periodic notification that chat commands are enabled" )
function chat_disablenotify( player )
	chatbase_setplayersetting( player, "disablenotify", true )
	ChatToPlayer(player, "^"..CHAT_COMMAND_COLOR_MAIN.."Periodic \"chat commands are enabled\" notifications disabled")
end

end

--[[
=====================================
== DEFAULT SETTING IMPLEMENTATION
=====================================
== 
=====================================
]]--

chatbase_addplayersetting( "disablenotify", false, "Disables periodic notifications that chat commands are enabled" )
chatbase_addplayersetting( "numtimesnotified", 0, "Number of times the player has been notified that chat commands are enabled" )

--[[
=====================================
== CALLBACKS
=====================================
== 
=====================================
]]--

-- player_onchat()
---- handle chat commands

-- save parent player_onchat
local base_player_onchat = player_onchat

function player_onchat( player, chatstring )

	-- call parent onchat function if it exists
	if base_player_onchat ~= nil then base_player_onchat(player,chatstring) end
	
	local player = CastToPlayer( player )

	-- string.gsub call removes all control characters (newlines, return carriages, etc)
	-- string.sub call removes the playername: part of the string, leaving just the message
	local message = string.sub( string.gsub( chatstring, "%c", "" ), string.len(player:GetName())+3 )
	
	chatbase_debug("Message: "..message)
	
	local prefix = string.sub(message,1,string.len(CHAT_COMMAND_PREFIX))
	
	chatbase_debug("Prefix: "..prefix)
	
	-- if the first character of the string doesn't match the prefix, then we don't care about it
	if prefix ~= CHAT_COMMAND_PREFIX then return true; end
	
	-- strip the prefix character
	message = string.sub( message, 1+string.len(CHAT_COMMAND_PREFIX) )
	
	chatbase_debug("Message: "..message)

	-- if there is no message at all, return
	if string.match(message, "%a+") == nil then return true end

	-- get command and parameters
	local command = string.lower( string.match(message, "%a+") )
	local paramstring = string.sub(message, string.len(command)+2)
	local params = explode(" ", paramstring)
	-- loop through all params and convert any numbers to actual numbers
	for i,param in pairs(params) do
		-- tonumber() returns nil if it can't convert to a number
		if tonumber(param) ~= nil then
			param = tonumber(param)
		end
		chatbase_debug("  Param "..i..": "..param)
	end
	-- insert the player as the first param always
	table.insert( params, 1, player )
	
	-- find function to call
	local func, finderror = findfunction("chat_"..command)

	if func ~= nil then
		if CHAT_COMMAND_DEBUG then ConsoleToAll(CHAT_COMMAND_DEBUG_PREFIX.."Function for "..command.." found"); end
		-- translates to chat_<command>( <arg1>, <arg2>, ... ) e.g. chat_help() or chat_set( "varname", 5 )
		func(unpack(params))
	else
		ChatToPlayer(player, "^"..CHAT_COMMAND_COLOR_ERROR.."Unexpected error while executing command")
		chatbase_error("Command function find error for "..command.."("..paramstring.."):".. finderror)
		return true
	end
	
	if CHAT_COMMAND_HIDECHATSTRING then
		return false
	else
		return true
	end
end

-- player_connected()
---- keep track of players

-- save parent player_connected
local base_player_connected = player_connected

function player_connected( player )

	-- call parent onchat function if it exists
	if base_player_connected ~= nil then base_player_connected(player) end
	
	local player = CastToPlayer( player )

	chatbase_addplayer( player )
end

-- player_disconnected()
---- keep track of players

-- save parent player_disconnected
local base_player_disconnected = player_disconnected

function player_disconnected( player )

	-- call parent onchat function if it exists
	if base_player_disconnected ~= nil then base_player_disconnected(player) end
	
	local player = CastToPlayer( player )
	
	chatbase_removeplayer( player )
end

--[[
=====================================
== HELPERS
=====================================
== 
=====================================
]]--

-- Find a function with the given string name in the global table
function findfunction(x)
  assert(type(x) == "string")
  local f=_G
  for v in x:gmatch("[^%.]+") do
    if type(f) ~= "table" then
       return nil, "looking for '"..v.."' expected table, not "..type(f)
    end
    f=f[v]
  end
  if type(f) == "function" then
    return f
  else
    return nil, "expected function, not "..type(f)
  end
end

-- Explode a string by the given divider
function explode(div,str)
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end
