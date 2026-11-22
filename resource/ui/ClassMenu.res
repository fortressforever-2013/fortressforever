"Resource/UI/ClassMenu.res"
{
	"class"
	{
		ControlName	"CClassMenu"
		fieldName	"class"
		xpos	"76"
		ypos	"0"
		wide	"552"
		tall	"448"
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
		"xpos"			"c"
		"ypos"			"60"
		"wide"			"316"
		"tall"			"350"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"model"	"models/error.mdl"
	}
	"FullSection"
	{
		"ControlName"	"Section"
		"fieldName"		"FullSection"
		"xpos"			"0" 	// 12
		"ypos"			"0"
		"wide"			"640" 	// 616
		"tall"			"480"	// 75
		"autoResize"	"0" 	// 0
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"TeamMenuTitles_small"
		"titleText"		""
	}
	"ChangeClassSection"
	{
		"ControlName"	"Section"
		"fieldName"		"ChangeClassSection"
		"xpos"			"18" 	// 12
		"ypos"			"73"
		"wide"			"180" 	// 616
		"tall"			"270"	// 75
		"autoResize"	"0" 	// 0
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"TeamMenuTitles_small"
		"titleText"		""
	}
	"WeaponsSection"
	{
		"ControlName"	"Section"
		"fieldName"		"WeaponsSection"
		"xpos"			"202" 	// 12
		"ypos"			"73"
		"wide"			"125" 	// 616
		"tall"			"270"	// 75
		"autoResize"	"0" 	// 0
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
		"xpos"			"331" 	// 12
		"ypos"			"73"
		"wide"			"205" 	// 616
		"tall"			"80"	// 75
		"autoResize"	"0" 	// 0
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
		"xpos"			"18" 	// 12
		"ypos"			"347"
		"wide"			"309" 	// 616
		"tall"			"80"	// 75
		"autoResize"	"0" 	// 0
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"ClassMenu"
		"titleText"		"Class Information"
	}

	"ClassInfo"
	{
		"ControlName"	"RichText"
		"fieldName"		"ClassInfo"
		"xpos"			"178" 	// 12
		"ypos"			"367"
		"wide"			"130" 	// 616
		"tall"			"52"	// 75
		"autoResize"	"0" 	// 0
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"text"			"Special Abilities: Test
Second Line: Test word wrap word wrap word wrap word wrap"
		"border" 		"0"
	}

	"ClassRoleSection"
	{
		"ControlName"	"Section"
		"fieldName"		"ClassRoleSection"
		"xpos"			"331" 	// 12
		"ypos"			"397"
		"wide"			"205"	// 616
		"tall"			"30"	// 75
		"autoResize"	"0" 	// 0
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
	}

	"ClassRole"
	{
		"ControlName"		"Label"
		"fieldName"			"ClassRole"
		"xpos"				"331"
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
		xpos	"28"
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

	"ClassPreview"
	{
		"ControlName"	"ModelPanel"
		"fieldName"		"ClassPreview"
		"xpos"			"c+6"
		"ypos"			"60"
		"wide"			"316"
		"tall"			"350"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"model"	"error.mdl"
	}
	"ClassInfo"
	{
		ControlName	"RichText"
		fieldName	"ClassInfo"
		xpos	"174"
		ypos	"116"
		wide	"400"
		tall	"380"
		autoResize	"0"
		pinCorner	"0"
		visible	"0"
		enabled	"0"
		tabPosition	"0"
		border	"0"
	}

	"ScoutButton"
	{
		"ControlName"		"Button"
		"fieldName"			"ScoutButton"
		"xpos"				"32"
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
		"xpos"				"112"
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
		"xpos"				"32"
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
		"xpos"				"112"
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
		"xpos"				"32"
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
		"xpos"				"112"
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
		"xpos"				"32"
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
		"xpos"				"112"
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
		"xpos"				"32"
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
		"xpos"				"112"
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
		"ControlName"		"Button"
		"fieldName"			"RandomButton"
		"xpos"				"32"
		"ypos"				"276"
		"wide"				"148"
		"tall"				"20"
		"autoResize"		"0"
		"pinCorner"			"2"
		"visible"			"1"
		"enabled"			"1"
		"tabPosition"		"0"
		"labelText"			"#FF_MENU_RANDOM"
		"font"				"ClassMenu"
		"textAlignment"		"west"
		"dulltext"			"0"
		"brighttext"		"0"
		"Command"			"class random"
	}
	"CancelButton"
	{
		ControlName	"Button"
		fieldName	"CancelButton"
		xpos	"32"
		ypos	"308"
		wide	"148"
		tall	"20"
		autoResize	"0"
		pinCorner	"2"
		visible	"1"
		enabled	"1"
		tabPosition	"0"
		labelText	"#FF_MENU_CANCEL"
		textAlignment	"west"
		dulltext	"0"
		brighttext	"0"
		Command	"vguicancel"
	}
}