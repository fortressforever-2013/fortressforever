-- if no lua scripts are found for the map (ff_xxx.bsp) then this file will be loaded
IncludeScript("base_ctf");

function startup()
	enabled_teams = { Team.kBlue, Team.kRed }
	SetPlayerLimit(Team.kBlue, 0)
	SetPlayerLimit(Team.kRed, 0)
	SetPlayerLimit(Team.kYellow, -1)
	SetPlayerLimit(Team.kGreen, -1)
	
	-- disable civilians
	for index, iteam in ipairs( enabled_teams ) do
		local team = GetTeam(iteam)
		team:SetClassLimit(Player.kCivilian, -1)
	end
	
	ConsoleToAll("No map lua found! Loaded default")
end