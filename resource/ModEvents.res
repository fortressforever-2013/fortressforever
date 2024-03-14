//=========== (C) Copyright 1999 Valve, L.L.C. All rights reserved. ===========
//
// The copyright to the contents herein is the property of Valve, L.L.C.
// The contents may be used and/or copied only with the written permission of
// Valve, L.L.C., or in accordance with the terms and conditions stipulated in
// the agreement/contract under which the contents have been supplied.
//=============================================================================

// No spaces in event names, max length 32
// All strings are case sensitive
//
// valid data key types are:
//	string: a zero terminated string
//	bool	: unsigned int, 1 bit
//	byte	: unsigned int, 8 bit
//	short: signed int, 16 bit
//	long	: signed int, 32 bit
//	float	: float, 32 bit
//	local: any data, but not networked to clients
//
// following key names are reserved:
//	local	: if set to 1, event is not networked to clients
//	unreliable: networked, but unreliable
//	suppress	: never fire this event
//	time	: firing server time
//	eventid	: holds the event ID

"ffevents"
{
	"player_sayteam"
	{
		"userid" "short"
		"text" "string"
	}
	"player_death"	// a game event, name may be 32 charaters long
	{
		// this extents the original player_death by a new 
		// field "headshot", all other fields remains the same
		"userid"	"short"
		"attacker"	"short"
		"weapon"	"string" 	// weapon name killer used 
		"damagetype" "long"	// damage type
		"killassister" "short"
		"killersglevel"	"short"
	}
	
	// From here down are events necessary for bot support.
	"player_changeclass"
	{		
		"userid"	"short"
		"oldclass"	"short"
		"newclass"	"short"
	}

	"build_dispenser"
	{
		"userid"	"short"	// who built it
	}

	"build_sentrygun"
	{
		"userid"	"short"
	}

	"build_detpack"
	{
		"userid"	"short"
	}

	"build_mancannon"
	{
		"userid"	"short"
	}
	
	"detpack_detonated"
	{
		"userid"	"short"
	}

	"sentrygun_killed"
	{
		"userid"	"short" // owner
		"attacker"	"short"
		"weapon"	"string"
		"attackerpos"	"string"
		"killedsglevel"	"short"
		"killersglevel"	"short"
	}

	"dispenser_killed"
	{
		"userid"	"short" // owner
		"attacker"	"short"
		"weapon"	"string"
		"killersglevel"	"short"
	}
	
	"mancannon_detonated"
	{
		"userid"	"short" // owner
	}
	
	"mancannon_killed"
	{
		"userid"	"short" // owner
		"attacker"	"short"
		"weapon"	"string"
		"killersglevel"	"short"
	}
	
	"sentrygun_upgraded"
	{
		"userid"	"short" // upgrader
		"sgownerid"	"short" // owner
		"level"		"short"
	}

	"disguised"
	{
		"userid"	"short"
		"team"		"short"
		"class"		"short"
	}
	
	"disguise_lost"
	{
		"userid"	"short"
		"attackerid" "short"
	}
	
	"cloak_lost"
	{
		"userid"	"short"
		"attackerid" "short"
	}
	
	"uncloaked"
	{
		"userid"	"short"
	}
	
	"cloaked"
	{
		"userid"	"short"
	}
	
	"dispenser_enemyused"
	{
		"userid"	"short" // owner
		"enemyid"	"short"
	}
	
	"dispenser_detonated"
	{
		"userid"	"short"
	}
	
	"dispenser_dismantled"
	{
		"userid"	"short"
	}
	
	"dispenser_sabotaged"
	{
		"userid"	"short" // owner
		"saboteur"	"short" // who done it?
	}
	
	"sentry_detonated"
	{
		"userid"	"short"
		"level"		"short"
	}
	
	"sentry_dismantled"
	{
		"userid"	"short"
		"level"		"short"
	}
	
	"sentry_sabotaged"
	{
		"userid"	"short" // owner
		"saboteur"	"short" // who done it?
	}
	"player_additem"
	{
		"userid"	"short"
		"item"		"string"
	}
	"player_removeitem"
	{
		"userid"	"short"
		"item"		"string"
	}
	"player_removeallitems"
	{
		"userid"	"short"
	}
	"ff_restartround"
	{
	}
	"objective_event"
	{
		"userid"		"short" 	// entity index of the player
		//"eventname"	"string"
		"eventtext"	"string"
	}
	"luaevent"
	{
		"userid"		"short" 	// entity index of the first player
		"userid2"	"short" 	// entity index of the 2nd player
		"eventname"	"string" 	// name for the event - like flag_cap, flag_drop, etc - something stats programs could use

		// These next ones are just brainstorming...
		"key0"		"string"
		"value0"		"string"
		"key1"		"string"
		"value1"		"string"
		"key2"		"string"
		"value2"		"string"
	}
}