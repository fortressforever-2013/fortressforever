"Resource/UI/ClassMenu.res"
{
	"class"
	{
		ControlName	"CClassMenu"
		fieldName	"class"
		xpos	"0"
		ypos	"0"
		wide	"f0"
		tall		"480"
		autoResize	"0"
		pinCorner	"0"
		visible	"1"
		enabled	"1"
		tabPosition	"0"
	}

	"ClassPreview"
	{
		"ControlName"	"ModelPanel"
		"fieldName"		"ClassPreview"
		"xpos"			"c+20"
		"ypos"			"150"
		"wide"			"316"
		"tall"			"350"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
	}

	"FullSection"
	{
		"ControlName"	"Section"
		"fieldName"		"FullSection"
		"xpos"			"64"	// 12
		"ypos"			"0"
		"wide"			"616"	// 616
		"tall"			"75"	// 75
		"autoResize"	"0"		// 0
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"TeamMenuTitles_small"
	}
	"ChangeClassSection"
	{
		"ControlName"	"Section"
		"fieldName"		"ChangeClassSection"
		"xpos"			"96"	// 12
		"ypos"			"73"
		"wide"			"180"	// 616
		"tall"			"270"	// 75
		"autoResize"	"0"	// 0
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"TeamMenuTitles_small"
	}
	"WeaponsSection"
	{
		"ControlName"	"Section"
		"fieldName"		"WeaponsSection"
		"xpos"			"280"	// 12
		"ypos"			"73"
		"wide"			"125"	// 616
		"tall"			"270"	// 75
		"autoResize"	"0"		// 0
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"MenuTitle"
		"titleText"		"Weapons"
	}
	"GrenadesSection"
	{
		"ControlName"	"Section"
		"fieldName"		"GrenadesSection"
		"xpos"			"409"	// 12
		"ypos"			"73"
		"wide"			"205"	// 616
		"tall"			"80"	// 75
		"autoResize"	"0"		// 0
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"MenuTitle"
		"titleText"		"Grenades"
	}

	"ClassInfoSection"
	{
		"ControlName"	"Section"
		"fieldName"		"ClassInfoSection"
		"xpos"			"96"	// 12
		"ypos"			"347"
		"wide"			"309"	// 616
		"tall"			"80"	// 75
		"autoResize"	"0"	// 0
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"ClassMenu"
		"titleText"		"Class Information"
	}

	"ClassInfo"
	{
		"ControlName"	"Label"
		"fieldName"		"ClassInfo"
		"xpos"			"128"
		"ypos"			"116"
		"wide"			"400"
		"tall"			"380"
		"autoResize"	"3"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"text"		"Special Abilities: Test
Second Line: Test word wrap word wrap word wrap word wrap"
	}

	"ClassRoleSection"
	{
		"ControlName"	"Section"
		"fieldName"		"ClassRoleSection"
		"xpos"			"409"	// 12
		"ypos"			"397"
		"wide"			"205"	// 616
		"tall"			"30"	// 75
		"autoResize"	"0"	// 0
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
	}

	"ClassRole"
	{
		"ControlName"		"Label"
		"fieldName"			"ClassRole"
		"xpos"				"409"
		"ypos"				"397"
		"wide"				"205"
		"tall"				"30"
		"autoResize"		"0"
		"pinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"center"
		"dulltext"			"0"
		"brighttext"		"0"
		"font"				"MenuTitle"
	}

	"joinClass"
	{
		ControlName	"Label"
		fieldName	"joinClass"
		xpos	"108"
		ypos	"76"
		wide	"160"
		tall	"24"
		autoResize	"0"
		pinCorner	"0"
		visible	"1"
		enabled	"1"
		labelText	"#FF_CHANGECLASS"
		textAlignment	"west"
		dulltext	"0"
		brighttext	"1"
		"font"		"MenuTitle"
	}

	"scout"
	{
		"ControlName"		"Button"
		"fieldName"			"ScoutButton"
		"xpos"				"116"
		"ypos"				"116"
		"wide"				"68"
		"tall"				"20"
		"autoResize"		"0"
		"pinCorner"			"2"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"3"
		"labelText"			"#FF_MENU_SCOUT"
		"font"				"ClassMenu"
		"textAlignment"		"west"
		"dulltext"			"0"
		"brighttext"		"0"
		"command"			"class scout"
	}
	"SniperButton"
	{
		"ControlName"		"Button"
		"fieldName"			"SniperButton"
		"xpos"				"196"
		"ypos"				"116"
		"wide"				"68"
		"tall"				"20"
		"autoResize"		"0"
		"pinCorner"			"2"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"4"
		"labelText"			"#FF_MENU_SNIPER"
		"font"				"ClassMenu"
		"textAlignment"		"west"
		"dulltext"			"0"
		"brighttext"		"0"
		"command"			"class sniper"
	}

	"SoldierButton"
	{
		"ControlName"		"Button"
		"fieldName"			"SoldierButton"
		"xpos"				"116"
		"ypos"				"148"
		"wide"				"68"
		"tall"				"20"
		"autoResize"		"0"
		"pinCorner"			"2"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"5"
		"labelText"			"#FF_MENU_SOLDIER"
		"font"				"ClassMenu"
		"textAlignment"		"west"
		"dulltext"			"0"
		"brighttext"		"0"
		"command"			"class soldier"
	}
	
	"DemomanButton"
	{
		"ControlName"		"Button"
		"fieldName"			"DemomanButton"
		"xpos"				"196"
		"ypos"				"148"
		"wide"				"68"
		"tall"				"20"
		"autoResize"		"0"
		"pinCorner"			"2"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"1"
		"labelText"			"#FF_MENU_DEMOMAN"
		"font"				"ClassMenu"
		"textAlignment"		"west"
		"dulltext"			"0"
		"brighttext"		"0"
		"command"			"class demoman"
	}
	"MedicButton"
	{
		"ControlName"		"Button"
		"fieldName"			"MedicButton"
		"xpos"				"116"
		"ypos"				"180"
		"wide"				"68"
		"tall"				"20"
		"autoResize"		"0"
		"pinCorner"			"2"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"2"
		"labelText"			"#FF_MENU_MEDIC"
		"font"				"ClassMenu"
		"textAlignment"		"west"
		"dulltext"			"0"
		"brighttext"		"0"
		"command"			"class medic"
	}
	"HwguyButton"
	{
		"ControlName"		"Button"
		"fieldName"			"HwguyButton"
		"xpos"				"196"
		"ypos"				"180"
		"wide"				"68"
		"tall"				"20"
		"autoResize"		"0"
		"pinCorner"			"2"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"labelText"			"#FF_MENU_HWGUY"
		"font"				"ClassMenu"
		"textAlignment"		"west"
		"dulltext"			"0"
		"brighttext"		"0"
		"Command"			"class hwguy"
	}
	"PyroButton"
	{
		"ControlName"		"Button"
		"fieldName"			"PyroButton"
		"xpos"				"116"
		"ypos"				"212"
		"wide"				"68"
		"tall"				"20"
		"autoResize"		"0"
		"pinCorner"			"2"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"labelText"			"#FF_MENU_PYRO"
		"font"				"ClassMenu"
		"textAlignment"		"west"
		"dulltext"			"0"
		"brighttext"		"0"
		"Command"			"class pyro"
	}
	"SpyButton"
	{
		"ControlName"		"Button"
		"fieldName"			"SpyButton"
		"xpos"				"196"
		"ypos"				"212"
		"wide"				"68"
		"tall"				"20"
		"autoResize"		"0"
		"pinCorner"			"2"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"labelText"			"#FF_MENU_SPY"
		"font"				"ClassMenu"
		"textAlignment"		"west"
		"dulltext"			"0"
		"brighttext"		"0"
		"Command"			"class spy"
	}
	"EngineerButton"
	{
		"ControlName"		"Button"
		"fieldName"			"EngineerButton"
		"xpos"				"116"
		"ypos"				"244"
		"wide"				"68"
		"tall"				"20"
		"autoResize"		"0"
		"pinCorner"			"2"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"labelText"			"#FF_MENU_ENGINEER"
		"font"				"ClassMenu"
		"textAlignment"		"west"
		"dulltext"			"0"
		"brighttext"		"0"
		"Command"			"class engineer"
	}
	"CivilianButton"
	{
		"ControlName"		"Button"
		"fieldName"			"CivilianButton"
		"xpos"				"196"
		"ypos"				"244"
		"wide"				"68"
		"tall"				"20"
		"autoResize"		"0"
		"pinCorner"			"2"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"labelText"			"#FF_MENU_CIVILIAN"
		"font"				"ClassMenu"
		"textAlignment"		"west"
		"dulltext"			"0"
		"brighttext"		"0"
		"Command"			"class civilian"
	}

	"RandomButton"
	{
		"ControlName"	"Button"
		"fieldName"		"RandomButton"
		"xpos"			"116"
		"ypos"			"276"
		"wide"			"148"
		"tall"			"20"
		"autoResize"		"0"
		"pinCorner"		"2"
		"visible"			"1"
		"enabled"		"1"
		"tabPosition"		"0"
		"labelText"		"#FF_MENU_RANDOM"
		"font"			"ClassMenu"
		"textAlignment"	"west"
		"dulltext"		"0"
		"brighttext"		"0"
		"Command"		"class random"
	}
	"CancelButton"
	{
		ControlName		"Button"
		fieldName		"CancelButton"
		xpos			"116"
		ypos			"308"
		wide			"148"
		tall				"20"
		autoResize		"0"
		pinCorner		"2"
		visible		"1"
		enabled		"1"
		tabPosition	"0"
		labelText	"#FF_MENU_CANCEL"
		textAlignment	"west"
		dulltext		"0"
		brighttext	"0"
		Command	"vguicancel"
	}
}