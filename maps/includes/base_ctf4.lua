
-- base_ctf4.lua

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_ctf")

-----------------------------------------------------------------------------
-- map level handlers
-----------------------------------------------------------------------------
function startup()
	SetGameDescription( "4-way CTF" )
	
	-- set up team limits
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, 0)
	SetPlayerLimit(Team.kGreen, 0)
	
	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
end

--flaginfo runs whenever the player spawns or uses the flaginfo command.
--Right now it just refreshes the HUD items; this ensures that players who just joined the server have the right information
function flaginfo( player_entity )
	flaginfo_base(player_entity) --see base_teamplay.lua
end