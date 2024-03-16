"Resource/UI/TextWindow.res"
{
	"info"
	{
		"ControlName"	"CTextWindow"
		"fieldName"		"TextWindow"
		"xpos"			"c-320"		// 0
		"ypos"			"0"
		"wide"			"640"
		"tall"			"480"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"0"
		"enabled"		"1"
		"tabPosition"	"0"
	}
		
	"MOTD"
	{
		"ControlName"	"Section"
		"fieldName"		"MOTD"
		"xpos"			"20" 	// 12
		"ypos"			"12"
		"wide"			"600" 	// 616
		"tall"			"463"	// 75
		"autoResize"	"0" 	// 0
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"TeamMenuTitles_small"
		"titleText"		""
	}
	
	"HTMLMessage"
	{
		"ControlName"	"HTML"
		"fieldName"		"HTMLMessage"
		"xpos"			"36"
		"ypos"			"56"
		"wide"			"568"
		"tall"			"376"
		"autoResize"	"0"
		"pinCorner"		"0"
		"visible"		"1"
		"enabled"		"1"
	}
	
	"TextMessage"
	{
		"ControlName"		"TextEntry"
		"fieldName"			"TextMessage"
		"xpos"				"36"
		"ypos"				"56"
		"wide"				"568"
		"tall"				"376"
		"autoResize"		"0"
		"pinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"textAlignment"		"northwest"
		"textHidden"		"0"
		"editable"			"0"
		"maxchars"			"-1"
		"NumericInputOnly"	"0"
	}
	
	"MessageTitle"
	{
		"ControlName"		"Label"
		"fieldName"			"MessageTitle"
		"xpos"				"46"
		"ypos"				"14"
		"wide"				"450"
		"tall"				"48"
		"autoResize"		"0"
		"pinCorner"			"0"
		"visible"			"1"
		"enabled"			"1"
		"labelText"			"Message Title"
		"textAlignment"		"west"
		"dulltext"			"0"
		"brighttext"		"0"
		"font"				"MenuTitle"
	}
	
	"ok"
	{
		"ControlName"		"FFButton"
		"fieldName"			"ok"
		"xpos"				"40"
		"ypos"				"444"
		"wide"				"128"
		"tall"				"20"
		"autoResize"		"0"
		"pinCorner"			"2"
		"visible"			"1"
		"enabled"			"1"
		"labelText"			"#PropertyDialog_OK"
		"textAlignment"		"center"
		"dulltext"			"0"
		"brighttext"		"0"
		"command"			"okay"
		"default"			"1"
	}
}