"Resource/UI/TeamMenu.res"{
	"ServerInfo"{
		"ControlName"	"Section"
		"fieldName"	"ServerInfo"
		"xpos"	"20"	//12
		"ypos"	"12"
		"wide"	"600"	//616
		"tall"	"80"	//75
		"autoResize"	"0"	//0
		"pinCorner"	"0"
		"visible"	"1"
		"enabled"	"1"
		"tabPosition"	"0"
		"font"	"TeamMenuTitles_small"
		"titleText"	"#TITLE_SERVERINFO"
	}
	"ServerInfoButton"{
		"ControlName"	"FFButton"
		"fieldName"	"ServerInfoButton"
		"xpos"	"34"
		"ypos"	"34"
		"wide"	"188"	
		"tall"	"48"
		"autoResize"	"0"
		"pinCorner"	"2"
		"visible"	"1"
		"enabled"	"1"
		"tabPosition"	"3"
		"font"	"TeamMenuTitles"
		"labelText"	"VIEW SERVER INFORMATION"
		"textAlignment"	"center"
		"dulltext"	"0"
		"brighttext"	"0"
		"command"	"serverinfo"
		"default"	"1"
	}
	"ServerInfoHost"{
		"ControlName"	"HTML"
		"fieldName"	"ServerInfoHost"
		"xpos"	"242"	//20
		"ypos"	"34"
		"wide"	"360"	//600
		"tall"	"48"	//51
		"autoResize"	"0"	//0
		"pinCorner"	"0"
		"visible"	"1"
		"enabled"	"1"
		"wrap"	"1"
		//"border"	""
		"tabPosition"	"0"
	}
	"TeamSelection"{
		"ControlName"	"Section"
		"fieldName"	"TeamSelection"
		"xpos"	"20"	//12
		"ypos"	"100"
		"wide"	"600"	//616
		"tall"	"167"
		"autoResize"	"0"	//0
		"pinCorner"	"0"
		"visible"	"1"
		"enabled"	"1"
		"tabPosition"	"0"
		"font"	"TeamMenuTitles_large"
		"titleText"	"#TITLE_TEAMSELECTION"
	}
//	"MapScreenshot"{
//		"ControlName"	"Section"
//		"fieldName"	"MapScreenshot"
//		"xpos"	"12" //12
//		"ypos"	"276"
//		"wide"	"190" //187
//		"tall"	"187"
//		"autoResize"	"0" //0
//		"pinCorner"	"0"
//		"visible"	"1"
//		"enabled"	"1"
//		"tabPosition"	"0"
//		"font"	"TeamMenuTitles_small"
//		"titleText"	"#TITLE_MAPSCREENSHOT"
//	}

	"MapScreenshotButton"{
		"ControlName"	"Section" //"Button"
		"fieldName"	"MapScreenshotButton"
		"xpos"	"20"
		"ypos"	"276"
		"wide"	"182" //190
		"tall"	"187"
		"autoResize"	"0"
		"pinCorner"	"0"
		"visible"	"1"
		"enabled"	"1"
		"tabPosition"	"0"
		"font"	"TeamMenuTitles_large"
		"labelText"	"#TITLE_MAPSCREENSHOT"
		"textAlignment"	"center"
		//"dulltext"	"0"
		//"brighttext"	"0"
		"Command"	"map shot"
	}
	"ImagePanel"{
		"ControlName"	"ImagePanel"
		"fieldName"	"ImagePanelLogo"
		"xpos"	"30"
		"ypos"	"290"
		"wide"	"160"
		"tall"	"160"
		"autoResize"	"0"
		"pinCorner"	"0"
		"visible"	"1"
		"enabled"	"1"
		"tabPosition"	"0"
		"image"	"loading_screen_map"
		"scaleImage"	"1"
	}

	//"MapInfo"{
	//	"ControlName"	"Section"
	//	"fieldName"	"MapInfo"
	//	"xpos"	"212"
	//	"ypos"	"280"
	//	"wide"	"175"
	//	"tall"	"50"
	//	"autoResize"	"1" //0
	//	"pinCorner"	"0"
	//	"visible"	"1"
	//	"enabled"	"1"
	//	"tabPosition"	"0"
	//	"font"	"TeamMenuTitles_small"
	//	"titleText"	"#TITLE_MAPINFO"
	//}
	//"ServerVars"{
	//	"ControlName"	"Section"
	//	"fieldName"	"ServerVars"
	//	"xpos"	"400"
	//	"ypos"	"280"
	//	"wide"	"227"
	//	"tall"	"50"
	//	"autoResize"	"0" //0
	//	"pinCorner"	"0"
	//	"visible"	"1"
	//	"enabled"	"1"
	//	"tabPosition"	"0"
	//	"font"	"TeamMenuTitles_small"
	//	"titleText"	"#TITLE_SERVERVARS"
	//}
	"MapDescription"{	//objectives
		"ControlName"	"Section"
		"fieldName"	"MapDescription"
		"xpos"	"212" //212
		"ypos"	"276" //342
		"wide"	"408" //416
		"tall"	"187" //125
		"autoResize"	"0" //0
		"pinCorner"	"0"
		"visible"	"1"
		"enabled"	"1"
		"tabPosition"	"0"
		"font"	"TeamMenuTitles_small"
		"titleText"	"#TITLE_MAPDESCRIPTION"
	}
	"MapDescriptionHead"{
		"ControlName"	"Label"
		"fieldName"	"MapDescriptionHead"
		"xpos"	"220" //220
		"ypos"	"294" //360
		"wide"	"400" //399
		"tall"	"16"
		"autoResize"	"0" //0
		"pinCorner"	"0"
		"visible"	"1"
		"enabled"	"1"
		"wrap"	"1"
		"tabPosition"	"0"
	}
	"MapDescriptionText"{
		"ControlName"	"RichText"
		"fieldName"	"MapDescriptionText"
		"xpos"	"220" //220
		"ypos"	"310" //376
		"wide"	"392" //400
		"tall"	"143" //81
		"autoResize"	"0" //0
		"pinCorner"	"0"
		"visible"	"1"
		"enabled"	"1"
		"wrap"	"0"
		"border"	"0"
		"tabPosition"	"0"
	}
	"team"{
		"ControlName"	"CTeamMenu"
		"fieldName"	"teammenu"
		"xpos"	"c-320"	//0
		"ypos"	"0"
		"wide"	"640" //640
		"tall"	"480"
		"autoResize"	"0" //0
		"pinCorner"	"0"
		"visible"	"1"
		"enabled"	"1"
		"tabPosition"	"0"
	}
	"BlueTeamButton"{
		"ControlName"	"TeamButton"
		"fieldName"	"BlueTeamButton"
		"xpos"	"76" //76
		"ypos"	"114" //112
		"wide"	"110"
		"tall"	"110"
		"autoResize"	"0" //0
		"pinCorner"	"2"
		"visible"	"1"
		"enabled"	"1"
		"tabPosition"	"3"
		"font"	"TeamMenuTitles"
		"labelText"	"#FF_MENU_BLUE"
		"textAlignment"	"west"
		"dulltext"	"0"
		"brighttext"	"0"
		"command"	"team blue"
	}
	"RedTeamButton"{
		"ControlName"	"TeamButton"
		"fieldName"	"RedTeamButton"
		"xpos"	"76" //76
		"ypos"	"114"
		"wide"	"110"
		"tall"	"110"
		"autoResize"	"0" //0
		"pinCorner"	"2"
		"visible"	"1"
		"enabled"	"1"
		"tabPosition"	"4"
		"font"	"TeamMenuTitles"
		"labelText"	"#FF_MENU_RED"
		"textAlignment"	"west"
		"dulltext"	"0"
		"brighttext"	"0"
		"command"	"team red"
	}
	"YellowTeamButton"{
		"ControlName"	"TeamButton"
		"fieldName"	"YellowTeamButton"
		"xpos"	"76"
		"ypos"	"114"
		"wide"	"110"
		"tall"	"110"
		"autoResize"	"0"
		"pinCorner"	"2"
		"visible"	"1"
		"enabled"	"1"
		"tabPosition"	"5"
		"font"	"TeamMenuTitles"
		"labelText"	"#FF_MENU_YELLOW"
		"textAlignment"	"west"
		"dulltext"	"0"
		"brighttext"	"0"
		"command"	"team yellow"
	}
	"GreenTeamButton"{
		"ControlName"	"TeamButton"
		"fieldName"	"GreenTeamButton"
		"xpos"	"76"
		"ypos"	"114"
		"wide"	"110"
		"tall"	"110"
		"autoResize"	"0"
		"pinCorner"	"2"
		"visible"	"1"
		"enabled"	"1"
		"tabPosition"	"1"
		"font"	"TeamMenuTitles"
		"labelText"	"#FF_MENU_GREEN"
		"textAlignment"	"west"
		"dulltext"	"0"
		"brighttext"	"0"
		"command"	"team green"
	}
	"AutoAssignButton"{
		"ControlName"	"FFButton"
		"fieldName"	"AutoAssignButton"
		"xpos"	"76"
		"ypos"	"234"
		"wide"	"96"	
		"tall"	"20"
		"autoResize"	"0"
		"pinCorner"	"2"
		"visible"	"1"
		"enabled"	"1"
		"tabPosition"	"3"
		"font"	"TeamMenuTitles"
		"labelText"	"#FF_MENU_AUTOTEAM"
		"textAlignment"	"center"
		"dulltext"	"0"
		"brighttext"	"0"
		"command"	"team auto"
		"default"	"1"
	}
	"SpectateButton"{
		"ControlName"	"FFButton"
		"fieldName"	"SpectateButton"
		"xpos"	"76"
		"ypos"	"234"
		"wide"	"96"	
		"tall"	"20"
		"autoResize"	"0"
		"pinCorner"	"2"
		"visible"	"1"
		"enabled"	"1"
		"tabPosition"	"0"
		"font"	"TeamMenuTitles"
		"labelText"	"#FF_MENU_SPECTATOR"
		"textAlignment"	"center"
		"dulltext"	"0"
		"brighttext"	"0"
		"Command"	"team spec"
	}
	"FlythroughButton"{
		"ControlName"	"FFButton"
		"fieldName"	"FlythroughButton"
		"xpos"	"76"
		"ypos"	"234"
		"wide"	"96"
		"tall"	"20"
		"autoResize"	"0"
		"pinCorner"	"2"
		"visible"	"1"
		"enabled"	"1"
		"tabPosition"	"6"
		"font"	"TeamMenuTitles"
		"labelText"	"#FF_MENU_MAPGUIDE"
		"textAlignment"	"center"
		"dulltext"	"0"
		"brighttext"	"0"
		"Command"	"mapguide"
	}
}