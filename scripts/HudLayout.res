///////////////////////////////////////////////////////////
// Fortress Forever HUD Layout resource file
//
// This file is cross-referenced and shares resources with;
//
//	resource/clientscheme.res	- HUD Colours & Font definitions
//	scripts/ff_hud_textures.txt	- Glyph definitions for the HUD font
//	scripts/HudAnimations.txt	- Animations for stuff like low ammo, etc.
//
///////////////////////////////////////////////////////////

"scripts/HudLayout.res"
{
	HudLocation	// hudlocation
	{
		"fieldName"	"HudLocation"
		
		"visible" 	"1"
		"enabled" 	"1"
		
		"xpos"		"3"	
		"ypos"		"447"
		"wide"		"640"	//256
		"tall"		"480"	//32
		
		"text1_xpos"	"4"
		"text1_ypos"	"20" //19
		
		"TextFont"		"HUD_TextSmall_Shadow"
		"TextColor"		"HUD_Tone_Default"	// Ignored: locations are colour coded
		
		"ForegroundTexture"	"locationBoxFG1"
		"BackgroundTexture"	"locationBoxBG1"
	}
	HudLocation2
	{
		"fieldName"	"HudLocation2"
		
		"visible"		"1"
		"enabled"	"1"		
		"pinCorner"	"3"		

		"xpos"		"85"	//85 x pos controlled by HudLocation
		"ypos"		"447"
		"wide"		"640"	//256
		"tall"		"480"	//32
		
		"ForegroundTexture"	"locationBoxFG2"
		"BackgroundTexture"	"locationBoxBG2"
	}
	
	HudHealth
	{
		"fieldName"	"HudHealth"

		"visible"		"1"
		"enabled"	"1"

		"xpos"		"3"
		"ypos"		"431"
		"wide"		"128"
		"tall"		"32"

		"digit_xpos"	"44"
		"digit_ypos"	"8"

		"NumberFont"	"HUD_NumLarge"
		"NumberColor"	"HUD_Tone_Default"
		
		"ForegroundTexture"	"healthBoxFG"
		"BackgroundTexture"	"healthBoxBG"
	}
	
	HudPlayerAddHealth
	{
		"fieldName"	"HudPlayerAddHealth"

		"visible"		"1"
		"enabled"	"1"
		"xpos"		"3"
		"ypos"		"406"
		"wide"		"128"
		"tall"		"32"

		"HealthFont_xpos"	"32"
		"HealthFont_ypos"	"8"

		"HealthFont"		"HudAddHealth"
		"TextColor"	"255 255 255 255" //black 
		"HealthFontBG"	"HudPlayerScoreBG" 
		
		"ForegroundTexture"	"playerScoreBoxFG1" 
		"BackgroundTexture"	"playerScoreBoxBG1" 
	}
	
	HudArmor
	{
		"fieldName"	"HudArmor"
		
		"visible"		"1"
		"enabled"	"1"

		"xpos"		"87"
		"ypos"		"431"
		"wide"		"128"
		"tall"		"32"

		"digit_xpos"	"38"
		"digit_ypos"	"18"

		"NumberFont"	"HUD_NumSmall"
		"NumberColor"	"HUD_Tone_Default"
		
		"ForegroundTexture"	"armourBoxFG"
		"BackgroundTexture"	"armourBoxBG"
	}
	
	HudPlayerAddArmor
	{
		"fieldName"	"HudPlayerAddArmor"

		"visible"		"1"
		"enabled"	"1"
				
		"xpos"		"87"
		"ypos"		"406"
		"wide"		"128"
		"tall"		"32"

		"ArmorFont_xpos"	"32"
		"ArmorFont_ypos"	"18"

		"ArmorFont"		"HudAddHealth"
		"TextColor"	"255 255 255 255" //black 
		"ArmorFontBG"	"HudPlayerScoreBG" 
		
		"ForegroundTexture"	"playerScoreBoxFG1" 
		"BackgroundTexture"	"playerScoreBoxBG1" 
	}
	
	// Added by AfterShock - for displaying weapon icon in bottom right
	HudWeaponInfo 
	{
		"fieldName"	"HudWeaponInfo" 

		"visible"		"1" 
		"enabled"	"1" 

		// xpos and ypos define where the top left corner of the panel will be 
		"xpos"		"r124" //x pos controlled by HudAmmoInfo2
		"ypos"		"447" 
		"zpos"		"2"
		"wide"		"640" // This stuff is proportional, so 640x480 is actually the size of the whole screen at any resolution.  Unless, that is, you have a non-4:3 monitor.  Vgui is a pain in the ass to get right then. 
		"tall"		"480" 

		"ammo_xpos"	"5"	// Note that these positions are relative to the position of the panel 
		"ammo_ypos"	"18"	// i.e. 0,0 is the top left corner of the panel 

		"TextFont"	"HudNumbers" 
		"TextColor"	"HUD_Tone_Default" 

		"IconFont"	"WeaponIconsHUD"	// Defines which Font to look in for the icons 
		"AmmoFont"	"AmmoIconsSmall"	// Defines which Font to look in for the icons 
	}

	HudAmmoInfo // should be weapon item glyphs in lower right
	{
		"fieldName"	"HudAmmoInfo"
		
		"visible"		"1"
		"enabled"	"1"
		
		"xpos"		"r124" //x pos controlled by HudAmmoInfo2
		"ypos"		"447"
		"wide"		"640" //128
		"tall"		"480" //64
		
		"text1_xpos"	"0"
		"text1_ypos"	"0"

		"TextFont"	"HudNumbers"
		"TextColor"	"HUD_Tone_Default"
		"IconFont"	"weaponglyphssmall"
		
		"ForegroundTexture"	"weaponBoxFG1"
		"BackgroundTexture"	"weaponBoxBG1"
	}
	HudAmmoInfo2
	{
		"fieldName"	"HudAmmoInfo2"
		
		"visible"		"1"
		"enabled"	"1"
		
		"xpos"		"r42" 
		"ypos"		"447"
		"wide"		"640" //128
		"tall"		"480" //64
		
		"ForegroundTexture"	"weaponBoxFG2"
		"BackgroundTexture"	"weaponBoxBG2"
	}
	
	HudAmmo
	{
		"fieldName"	"HudAmmo"

		"visible"		"1"
		"enabled"		"1"

		"xpos"		"r152" //488
		"ypos"		"447"
		"wide"		"640" //128
		"tall"		"480" //32
		"digit_xpos"	"4"
		"digit_ypos"	"19"
		
		"NumberFont"	"HUD_NumSmall"
		"NumberColor"	"HUD_Tone_Default"
		
		"ForegroundTexture"	"ammoCarriedBoxFG"
		"BackgroundTexture"	"ammoCarriedBoxBG"
	}

	HudAmmoClip
	{
		"fieldName"	"HudAmmoClip"
		
		"visible"		"1"
		"enabled"	"1"
		
		"xpos"		"r149" //491
		"ypos"		"430"
		"wide"		"640" //128
		"tall"		"480" //32

		"digit_xpos"	"16"
		"digit_ypos"	"8"

		"NumberFont"	"HUD_NumLarge"
		"NumberColor"	"HUD_Tone_Default"
		
		"ForegroundTexture"	"ammoLoadedBoxFG"
		"BackgroundTexture"	"ammoLoadedBoxBG"
	}
	
	HudGrenade1
	{
		"fieldName"	"HudGrenade1"
		
		"visible"		"1"
		"enabled"	"1"
		
		"xpos"		"r91" //549
		"ypos"		"414"
		"wide"		"640" //128
		"tall"		"480" //32

		"digit_xpos"	"33"
		"digit_ypos"	"18"
		
		"icon_xpos"	"10"
		"icon_ypos"	"25"
		"icon_font"	"StatusGlyphsSmall"
		"icon_color"	"HUD_Tone_Default"
		
		"NumberFont"	"HUD_NumSmall"
		"NumberColor"	"HUD_Tone_Default"
		
		"ForegroundTexture"	"grenPrimaryBoxFG"
		"BackgroundTexture"	"grenPrimaryBoxBG"
	}

	HudGrenade2 // far right glyph
	{
		"fieldName"	"HudGrenade2"
		
		"visible"		"1"
		"enabled"	"1"
		
		"xpos"		"r47" //593
		"ypos"		"414"
		"wide"		"640" //128
		"tall"		"480" //32

		"digit_xpos"	"35"
		"digit_ypos"	"18"
		
		"icon_xpos"	"10"
		"icon_ypos"	"25"
		"icon_font"	"StatusGlyphsSmall"
		"icon_color"	"HUD_Tone_Default"
		
		"NumberFont"	"HUD_NumSmall"
		"NumberColor"	"HUD_Tone_Default"
		
		"ForegroundTexture"	"grenSecondaryBoxFG"
		"BackgroundTexture"	"grenSecondaryBoxBG"
	}

	HudRoundInfo	// top center item glyph, fucked by non 4:3 aspect ratio, new settings seem to stay in center, but text needs fixin
	{
		"fieldName"	"HudRoundInfo"
		
		"visible"		"1"
		"enabled"	"1"
		
		"xpos"		"c-60" //256
		"ypos"		"1"
		"wide"		"120" //128, 120
		"tall"		"128" //128
		
	
		"MapNameFont"	"HUD_TextRoundInfo"
		"MapNameColor"	"HUD_Tone_Default"
		"MapNameX"	"32" //32
		"MapNameY"	"3"
		//"center_x"		"1"	// center text horizontally
		//"RightJustify"	"1"

		"TimerFont"		"HUD_TextRoundInfo"
		"TimerColor"		"HUD_Tone_Default"
		"TimerX"		"43" //45
		"TimerY"		"18"
		
		"ForegroundTexture"	"RoundInfoBoxFG"
		"BackgroundTexture"	"RoundInfoBoxBG"
	}
	
	HudTeamScores
	{
		"fieldName"	"HudTeamScores" 

		"visible"	"1" 
		"enabled"	"1" 

		// xpos and ypos define where the top left corner of the panel will be 
		"xpos"	"c-120" // Right in the middle of the damn screen 
		//"xpos"	"130" // Right in the middle of the damn screen 
		"ypos"	"7" 
		"wide"	"640" // This stuff is proportional, so 640x480 is actually the size of the whole screen at any resolution.  Unless, that is, you have a non-4:3 monitor.  Vgui is a pain in the ass to get right then. 
		"tall"	"480" 

		"TeamScoreBlue_xpos"	"0"	// Note that these positions are relative to the position of the panel 
		"TeamScoreBlue_ypos"	"0"	// i.e. 0,0 is the top left corner of the panel 
		"TeamScoreRed_xpos"	"200"	// Note that these positions are relative to the position of the panel 
		"TeamScoreRed_ypos"	"0"		// i.e. 0,0 is the top left corner of the panel 
		"TeamScoreYellow_xpos"	"5"	// Note that these positions are relative to the position of the panel 
		"TeamScoreYellow_ypos"	"22"	// i.e. 0,0 is the top left corner of the panel 
		"TeamScoreGreen_xpos"	"195"	// Note that these positions are relative to the position of the panel 
		"TeamScoreGreen_ypos"	"22"	// i.e. 0,0 is the top left corner of the panel 

		"TeamScoreBlueFont"	"HudTeamScore" 
		"TeamScoreRedFont"	"HudTeamScore" 
		"TeamScoreYellowFont"	"HudTeamScore" 
		"TeamScoreGreenFont"	"HudTeamScore" 

		"TextColor"	"Black" 

		"ForegroundTexture"	"TeamScoreBoxFG1" 
		"BackgroundTexture"	"TeamScoreBoxBG1" 
	}

	HudPlayerTotalScore
	{
		"fieldName"	"HudPlayerTotalScore" 

		"visible"	"1" 
		"enabled"	"1" 

		// xpos and ypos define where the top left corner of the panel will be 
		"xpos"	"0" // Right in the middle of the damn screen 20
		"ypos"	"0" //20
		"wide"	"640" // This stuff is proportional, so 640x480 is actually the size of the whole screen at any resolution.  Unless, that is, you have a non-4:3 monitor.  Vgui is a pain in the ass to get right then. 
		"tall"	"480" 

		"TotalDescFont_xpos"	"5"	// Note that these positions are relative to the position of the panel 
		"TotalDescFont_ypos"	"3"	// i.e. 0,0 is the top left corner of the panel 
		"TotalScoreFont_xpos"	"5"	// Note that these positions are relative to the position of the panel 
		"TotalScoreFont_ypos"	"15"	// i.e. 0,0 is the top left corner of the panel 

		"TotalScoreFont"	"HudPlayerScore" 
		"TotalDescFont"	"HudPlayerScoreDesc" 

		"TotalScoreFontBG"	"HudPlayerScoreBG" 
		"TotalDescFontBG"	"HudPlayerScoreDescBG" 

		"TextColor"	"Black" 

		"ForegroundTexture"	"playerScoreBoxFG1" 
		"BackgroundTexture"	"playerScoreBoxBG1" 
	}
	HudPlayerLatestScore
	{
		"fieldName"	"HudPlayerLatestScore" 
		"visible"	"1" 
		"enabled"	"1" 

		// xpos and ypos define where the top left corner of the panel will be 
		"xpos"	"0" // Right in the middle of the damn screen 
		"ypos"	"0" // 
		"wide"	"640" // This stuff is proportional, so 640x480 is actually the size of the whole screen at any resolution.  Unless, that is, you have a non-4:3 monitor.  Vgui is a pain in the ass to get right then. 
		"tall"	"480" 

		"DescFont_xpos"	"13"	// Note that these positions are relative to the position of the panel 
		"DescFont_ypos"	"33"	// i.e. 0,0 is the top left corner of the panel 
		"ScoreFont_xpos"	"8"	// Note that these positions are relative to the position of the panel 
		"ScoreFont_ypos"	"43"	// i.e. 0,0 is the top left corner of the panel 

		"ScoreFont"	"HudBonusScore" 
		"DescFont"	"HudBonusScoreDesc" 

		"ScoreFontBG"	"HudPlayerScoreBG" 
		"DescFontBG"	"HudPlayerScoreDescBG" 

		"TextColor"	"255 255 255 255" //black 

		"ForegroundTexture"	"playerScoreBoxFG1" 
		"BackgroundTexture"	"playerScoreBoxBG1" 
	}

	HudOverpressure
	{
		"fieldName"	"HudOverpressure"
		
		"visible"		"1"
		"enabled"	"1"

		"xpos"		"3"
		"ypos"		"404"
		"wide"		"128"
		"tall"		"128"

		"text1_xpos"		"34"
		"text1_ypos"		"12"
		
		"image1_xpos"	"3"
		"image1_ypos"	"4"
		
		"bar_width"		"75"
		"bar_height"		"24"

		"TextFont"		"HUD_TextSmall"
		"TextColor"		"HUD_Tone_Default" //overridden by teamcolor of disguise

		"ForegroundTexture"	"CooldownBoxFG"
		"BackgroundTexture"	"CooldownBoxBG"
	}
	
	HudCellCount
	{
		"fieldName"		"HudCellCount"
		
		"visible"		"1"
		"enabled"		"1"

		"xpos"			"r198"
		"ypos"			"447"
		"xpos"			"3"
		"ypos"			"404"
		"wide"			"128"
		"tall"			"128"

		"text_xpos"		"19"
		"text_ypos"		"19"
		
		"image_xpos"		"3"
		"image_ypos"		"18"

		"IconFont"		"AmmoIconsSmall"

		"TextFont"		"HUD_TextRoundInfo"
		"TextColor"		"HUD_Tone_Default"

		"ForegroundTexture"	"CellCountBoxFG"
		"BackgroundTexture"	"CellCountBoxBG"
	}

	HudJetpackFuelBar
	{
		"fieldName"	"HudJetpackFuelBar"
		
		"visible"		"1"
		"enabled"	"1"

		"xpos"		"3"
		"ypos"		"404"
		"wide"		"128"
		"tall"		"128"

		"text1_xpos"		"34"
		"text1_ypos"		"12"
		
		"image1_xpos"	"3"
		"image1_ypos"	"4"
		
		"bar_width"		"75"
		"bar_height"		"24"

		"DisguiseFont"	"ClassGlyphs"

		"TextFont"		"HUD_TextSmall"
		"TextColor"		"HUD_Tone_Default" //overridden by teamcolor of disguise

		"ForegroundTexture"	"CooldownBoxFG"
		"BackgroundTexture"	"CooldownBoxBG"
	}

	HudSpyDisguise
	{
		"fieldName"	"HudSpyDisguise"
		
		"visible"		"1"
		"enabled"	"1"

		"xpos"		"3"
		"ypos"		"404"
		"wide"		"128"
		"tall"		"128"

		"text1_xpos"		"34"
		"text1_ypos"		"12"
		
		"image1_xpos"	"3"
		"image1_ypos"	"4"
		
		"bar_width"		"75"
		"bar_height"		"24"

		"DisguiseFont"	"ClassGlyphs"

		"TextFont"		"HUD_TextSmall"
		"TextColor"		"HUD_Tone_Default" //overridden by teamcolor of disguise

		"ForegroundTexture"	"CooldownBoxFG"
		"BackgroundTexture"	"CooldownBoxBG"
	}
	
	HudSpyDisguise2
	{
		"fieldName"	"HudSpyDisguise2"
		
		"visible"		"1"
		"enabled"	"1"

		"xpos"		"82"
		"ypos"		"404"
		"wide"		"128"
		"tall"		"128"
		
		"image1_xpos"	"2"
		"image1_ypos"	"4"

		"WeaponFont"	"WeaponIconsHUD"
		"WeaponColor"	"HUD_Tone_Default"

		"ForegroundTexture"	"SpyDisguiseBoxFG2"
		"BackgroundTexture"	"SpyDisguiseBoxBG2"
	}
	
	HudSpyDisguise3
	{
		"fieldName"	"HudSpyDisguise3"
		
		"visible"		"1"
		"enabled"	"1"

		"xpos"		"82"
		"ypos"		"431"
		"wide"		"128"
		"tall"		"128"

		"ForegroundTexture"	"SpyDisguiseBoxFG3"
		"BackgroundTexture"	"SpyDisguiseBoxBG3"
	}

	HudHintCenter
	{
		"fieldName"	"HudHintCenter"
		
		"visible"		"1"
		"enabled"	"1"

		"xpos"		"c-130"
		"ypos"		"404"

		"wide"		"260"
		"tall"		"70"

		"text1_xpos"		"34"
		"text1_ypos"		"10"

		"text1_wide"		"220"
		"text1_tall"		"40"
		
		"image1_xpos"	"4"
		"image1_ypos"	"8"

		"IconFont"		"HudHintCenterIcon"
		"IconFontGlow"	"HudHintCenterIconGlow"

		"TextFont"		"HUD_TextSmall"
		"TextColor"		"HUD_Tone_Default"
		"BGBoxColor"	"Dark"
		

		// The buttons
		"B_wide"		"20"
		"B_tall"			"10"
		
		"NextB_xpos"	"235"
		"NextB_ypos"	"55"

		"PrevB_xpos"	"5"
		"PrevB_ypos"	"55"
		
		// The hint index thingy
		"index_xpos"		"9"
		"index_ypos"		"45"
		

		"SmallBoxSize" "36"	//32
		"LargeBoxWide" "112"
		"LargeBoxTall" "80"
		"BoxGap" "8"
		"SelectionNumberXPos" "4"
		"SelectionNumberYPos" "4"
		"SelectionGrowTime"	"0.4"
		"TextYPos" "64"
	}


	HudGrenade1Timer
	{
		"fieldName"	"HudGrenade1Timer"

		"visible" "1"
		"enabled" "1"

		"xpos"	"c-123"
		"ypos"	"414"
		"wide"	"256"
		"tall"	"32"		
		
		"bar_xpos" "69"
		"bar_ypos" "4"
		"bar_width"	"118"
		"bar_height"	"13"
		"bar_color" 	"HUD_Tone_Default"
		
		"icon_xpos"		"10"
		"icon_ypos"		"25"
		
		//"icon_color" 	"0 0 0 255"

		"ForegroundTexture"	"Gren1TimerFGBox"
		"BackgroundTexture"	"Gren1TimerBGBox"
	}
	
	HudGrenade2Timer
	{
		"fieldName"		"HudGrenade2Timer"

		"visible" "1"
		"enabled" "1"

		"xpos"	"c-123"
		"ypos"	"434"
		"wide"	"256"
		"tall"	"32"

		"bar_xpos" "69"
		"bar_ypos"	"16"
		"bar_width"	"118"
		"bar_height"	"13"
		"bar_color" 	"HUD_Tone_Default"
		
		"icon_xpos"			"8"
		"icon_ypos"			"24"

		//"icon_color" 	"0 0 0 255"
		
		"ForegroundTexture"	"Gren2TimerFGBox"
		"BackgroundTexture"	"Gren2TimerBGBox"
	}
	
	//
	// you are entering untamed land!
	//

	HudBuildTimer
	{
		"fieldName"	"HudBuildTimer"
		"xpos"	"c-123"
		"ypos"	"r132"
		"wide"	"256"
		"tall"	"32"
		"visible" "1"
		"enabled" "1"

		"text_xpos" "256"
		"text_ypos" "0"
		
		"icon_xpos" "40"
		"icon_ypos" "8"
		"icon_width" "16"
		"icon_height" "16"
		
		"bar_xpos" "64"
		"bar_ypos" "8"
		"bar_width" "128"
		"bar_height" "16"
		"bar_color" "HUD_Tone_Default"
	}
	
	//HudGrenade1Timer
	//{
	//	"fieldName"		"HudGrenade1Timer"
	//	"xpos"	"140"
	//	"ypos"	"r56"
	//	"wide"	"192"
	//	"tall"	"20"
	//	"visible" "1"
	//	"enabled" "1"
//
//		"text_xpos" "0"
//		"text_ypos" "0"
//		
//		"icon_xpos" "4"
//		"icon_ypos" "4"
//		"icon_width" "20"
//		"icon_height" "20"
//		
//		"bar_xpos" "16"
//		"bar_ypos" "4"
//		"bar_width" "128"
//		"bar_height" "12"	
//		"bar_color" "HUD_Tone_Default"
//	}
//	
//	HudGrenade2Timer
//	{
//		"fieldName"	"HudGrenade2Timer"
//		"xpos"	"140"
//		"ypos"	"r32"
//		"wide"	"192"
//		"tall"	"20"
//		"visible" "1"
//		"enabled" "1"
//
//		"text_xpos" "0"
//		"text_ypos" "0"
//		
//		"icon_xpos" "4"
//		"icon_ypos" "4"
//		"icon_width" "20"
//		"icon_height" "20"
//		
//		"bar_xpos" "16"
//		"bar_ypos" "4"
//		"bar_width" "128"
//		"bar_height" "12"	
//		"bar_color" "HUD_Tone_Default"
//	}
	
	HudBuildState
	{
		"fieldName"		"HudBuildState"
		"xpos"	"r210"
		"ypos"	"360"
		"wide"	"210"
		"tall"	"50"
		"visible" "1"
		"enabled" "1"

		"text1_xpos" "24"
		"text1_ypos" "3"
		"text2_xpos" "24"
		"text2_ypos" "29"
		
		"icon1_xpos" "0"
		"icon1_ypos" "0"
		"icon1_width" "20"
		"icon1_height" "20"
		
		"icon2_xpos" "0"
		"icon2_ypos" "25"
		"icon2_width" "20"
		"icon2_height" "20"
	}


	HudBuildStateSentry
	{
		"fieldName"		"HudBuildStateSentry"
		"PaintBackgroundType"	"2"
	}

	HudKeyState
	{
		"fieldName"	"HudKeyState"
		"xpos"	"c-32"
		"ypos"	"r172"
		"wide"	"64"
		"tall"	"64"
	}

	HudAmmoSecondary
	{
		"fieldName" "HudAmmoSecondary"
		"xpos"	"r76"
		"ypos"	"432"
		"wide"	"60"
		"tall"	"36"
		"visible" "1"
		"enabled" "1"

		"PaintBackgroundType"	"2"

		"digit_xpos" "10"
		"digit_ypos" "2"

		"TextColor" "HUD_Tone_Default"
	}
	
	HudSuitPower
	{
		"fieldName" "HudSuitPower"
		"visible" "1"
		"enabled" "1"
		"xpos"	"16"
		"ypos"	"396"
		"wide"	"102"
		"tall"	"26"
		
		"AuxPowerLowColor" "255 0 0 220"
		"AuxPowerHighColor" "255 220 0 220"
		"AuxPowerDisabledAlpha" "70"

		"BarInsetX" "8"
		"BarInsetY" "15"
		"BarWidth" "92"
		"BarHeight" "4"
		"BarChunkWidth" "6"
		"BarChunkGap" "3"

		"text_xpos" "8"
		"text_ypos" "4"
		"text2_xpos" "8"
		"text2_ypos" "22"
		"text2_gap" "10"

		"PaintBackgroundType"	"2"
	}
	
	HudFlashlight
	{
		"fieldName" "HudFlashlight"
		"visible" "0"
		"enabled" "1"
		"xpos"	"16"
		"ypos"	"370"
		"wide"	"102"
		"tall"	"20"
		
		"text_xpos" "8"
		"text_ypos" "6"
		"TextColor"	"255 170 0 220"

		"PaintBackgroundType"	"2"
	}
	
	HudDamageIndicator
	{
		"fieldName"	"HudDamageIndicator"
		"visible" 		"1"
		"enabled" 		"1"
		"DmgColorLeft"	"255 0 0 0"
		"DmgColorRight" 	"255 0 0 0"
		
		"dmg_xmargin"	"40"
		"dmg_ymargin"	"40"

		"dmg_depth"			"40"
		"dmg_outerlength"	"300"
		"dmg_innerlength"	"240"
	}

	HudHitIndicator
	{
		"fieldName"	"HudHitIndicator"
		"visible" 	"1"
		"enabled" 	"1"
		"zpos"		"2" 	// draw above crosshair
	}
	
	HudZoom
	{
		"fieldName" "HudZoom"
		"visible" "1"
		"enabled" "1"
		"Circle1Radius" "66"
		"Circle2Radius"	"74"
		"DashGap"	"16"
		"DashHeight" "4"
		"BorderThickness" "88"
	}

	HudWeaponSelection
	{
		"fieldName" "HudWeaponSelection"
		"ypos" 	"16"
		"visible" "1"
		"enabled" "1"
		"SmallBoxSize" "36"	//32
		"LargeBoxWide" "112"
		"LargeBoxTall" "80"
		"BoxGap" "8"
		"SelectionNumberXPos" "4"
		"SelectionNumberYPos" "4"
		"SelectionGrowTime"	"0.4"
		"TextYPos" "64"
	}

	HudCrosshair
	{
		"fieldName" "HudCrosshair"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	HudDeathNotice
	{
		"fieldName" "HudDeathNotice"
		"visible" "1"
		"enabled" "1"
		"xpos"	"r640" 
		"ypos"	 "0"
		"wide"	"640"
		"tall"	"480"
		
		"HighlightColor" 	"0 0 0 180"
		"HighlightBorderColor" 	"HUD_Tone_Default"
		"ObjectiveNoticeColor" 	"0 0 0 180"

		"LineHeight"	"22"
		"RightJustify"	"1"

		"TextFont"	"Default"
	}

	HudVehicle
	{
		"fieldName" "HudVehicle"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	ScorePanel
	{
		"fieldName" "ScorePanel"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	HudTrain
	{
		"fieldName" "HudTrain"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	HudMOTD
	{
		"fieldName" "HudMOTD"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	HudMessage
	{
		"fieldName" "HudMessage"
		"visible" "1"
		"enabled" "1"
		"wide"	 "1280"
		"tall"	 "720"
	}

	HudMenu
	{
		"fieldName" "HudMenu"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
		"zpos" "1"
		"TextFont""Default"
		"ItemFont""Default"
		"ItemFontPulsing""Default"
	}

	HudCloseCaption
	{
		"fieldName" "HudCloseCaption"
		"visible"	"1"
		"enabled"	"1"
		"xpos"		"c-250"
		"ypos"		"276"
		"wide"		"500"
		"tall"		"136"

		"BgAlpha"	"128"

		"GrowTime"		"0.25"
		"ItemHiddenTime"	"0.2"	// Nearly same as grow time so that the item doesn't start to show until growth is finished
		"ItemFadeInTime"	"0.15"	// Once ItemHiddenTime is finished, takes this much longer to fade in
		"ItemFadeOutTime"	"0.3"
	}

	HudChat
	{
		"fieldName" "HudChat"
		"visible" "1"
		"enabled" "1"
		"xpos"	"0"
		"ypos"	"200"
		"wide"	 "520"
		"tall"	 "200"
	}

	HudHistoryResource
	{
		"fieldName" "HudHistoryResource"
		"visible" "1"
		"enabled" "1"
		"xpos"	"r252"
		"ypos"	"40"
		"wide"	 "248"
		"tall"	 "320"

		"history_gap"	"24"
		"icon_inset"	"28"
		"text_inset"	"26"
		"NumberFont"	"HudNumbersSmall"
	}

	HudGeiger
	{
		"fieldName" "HudGeiger"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	HUDQuickInfo
	{
		"fieldName" "HUDQuickInfo"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	HudWeapon
	{
		"fieldName" "HudWeapon"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
		"Iconfont"	"WeaponIconsSmall"
	}
	HudAnimationInfo
	{
		"fieldName" "HudAnimationInfo"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	HudPredictionDump
	{
		"fieldName" "HudPredictionDump"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"
		"tall"	 "480"
	}

	HudHintDisplay
	{
		"fieldName"	"HudHintDisplay"
		"visible"	"0"
		"enabled" "1"
		"xpos"	"r120"
		"ypos"	"r340"
		"wide"	"100"
		"tall"	"200"
		"text_xpos"	"8"
		"text_ypos"	"8"
		"text_xgap"	"8"
		"text_ygap"	"8"
		"TextColor"	"255 170 0 220"

		"PaintBackgroundType"	"2"
	}

	HudSquadStatus
	{
		"fieldName"	"HudSquadStatus"
		"visible"	"1"
		"enabled" "1"
		"xpos"	"r120"
		"ypos"	"380"
		"wide"	"104"
		"tall"	"46"
		"text_xpos"	"8"
		"text_ypos"	"34"
		"SquadIconColor"	"255 220 0 160"
		"IconInsetX"	"8"
		"IconInsetY"	"0"
		"IconGap"		"24"

		"PaintBackgroundType"	"2"
	}

	HudPoisonDamageIndicator
	{
		"fieldName"	"HudPoisonDamageIndicator"
		"visible"	"0"
		"enabled" "1"
		"xpos"	"16"
		"ypos"	"346"
		"wide"	"136"
		"tall"	"38"
		"text_xpos"	"8"
		"text_ypos"	"8"
		"text_ygap" "14"
		"TextColor"	"255 170 0 220"
		"PaintBackgroundType"	"2"
	}
	HudCredits
	{
		"fieldName"	"HudCredits"
		"TextFont"	"Default"
		"visible"	"1"
		"xpos"	"0"
		"ypos"	"0"
		"wide"	"640"
		"tall"	"480"
		"TextColor"	"255 255 255 192"
	}
	HudSpeedometer
	{
		"fieldName"	"HudSpeedometer"
		"xpos"	"r65"
		"ypos"	"r95"
		"wide"	"65"
		"tall"	"50"
		"PaintBackgroundType" "2"
		"AvgSpeedFont_xpos" "0"
		"AvgSpeedFont_ypos" "0"
		"SpeedFont_xpos" "0"
		"SpeedFont_ypos" "15"
		"TextColor"	"HUD_Tone_Default"
	}
	HudRadialMenu
	{
		"fieldName"	"HudRadialMenu"
		"visible" 	"1"
		"enabled" 	"1"
	}
	HudCrosshairInfo
	{
		"fieldName"	"HudCrosshairInfo"
		"visible" 	"1"
		"enabled" 	"1"
		
		// Position when hud_centerid = 0
		"text1_xpos" 	"20"
		"text1_ypos" 	"280"
	}
	HudSentryGunStatus
	{
		"fieldName"	"HudSentryGunStatus"
		"visible"	"0"
		"enabled"	"0"
		"xpos"		"16"
		"ypos"		"400"
		"wide"		"0"
		"tall"		"0"
		"PaintBackgroundType"	"2"
	}
	HudBuildableMessages
	{
		"fieldName"	"HudBuildableMessages"
		"visible"	"0"
		"enabled"	"0"
		"xpos"		"0"
		// Don't mess with the Y value
		// Everything else gets overridden except the Y value...
		"ypos"		"300"
		"wide"		"0"
		"tall"		"0"

		"PaintBackgroundType"	"2"
	}
	HudLua
	{
		"fieldName"	"HudLua"
		"visible" "1"
		"enabled" "0"
		"xpos" "0"
		"ypos" "0"
		"wide" "640"
		"tall" "480"

		"PaintBackgroundType" 	"2"

		"TextColor"	"255 170 0 220"
	}
	HudHint
	{
		"fieldName"		"HudHint"
		"visible" "1"
		"enabled" "0"
		"xpos" "430"
		"ypos" "200"
		"wide" "200"
		"tall" "100"

		"PaintBackgroundType" 	"2"

		"TextColor"	"255 170 0 220"
	}
	
	HudStatusIcons
	{
		"fieldName"		"HudStatusIcons"
		"visible" "1"
		"enabled" "1"
		"xpos"	"16"
		"ypos"	"300"
		"wide"	"60"
		"tall"	"200"

		"TextColor"	"255 170 0 220"
	}
	HudRadar
	{
		"fieldName"		"HudRadar"
		"visible" "0"
		"enabled" "1"
	}
	HudRadioTag
	{
		"fieldName"		"HudRadioTag"
		"visible" "0"
		"enabled" "1"
	}
	HudObjectiveIcon
	{
		"fieldName"		"HudObjectiveIcon"
		"visible" "0"
		"enabled" "1"
	}
	HudGameMessage
	{
		"fieldName"	"HudGameMessage"
		"visible"	"0"
		"enabled"	"0"
		"xpos"	"c-200"
		"ypos"	"120"
		"wide"	"400"
		"tall"	"300"
		"PaintBackgroundType" 	"1"
	}

	HudSuit
	{
		"fieldName"		"HudSuit"
		"xpos"	"140"
		"ypos"	"432"
		"wide"	"108"
		"tall"	"36"
		"visible" "1"
		"enabled" "1"

		"PaintBackgroundType"	"2"

		
		"text_xpos" "8"
		"text_ypos" "20"
		"digit_xpos" "50"
		"digit_ypos" "2"
	}
	
	HudVoiceSelfStatus
	{
		"fieldName" "HudVoiceSelfStatus"
		"visible" "1"
		"enabled" "1"
		"xpos" "r43"
		"ypos" "355"
		"wide" "24"
		"tall" "24"
	}

	HudVoiceStatus
	{
		"fieldName" "HudVoiceStatus"
		"visible" "1"
		"enabled" "1"
		"xpos" "r200"
		"ypos" "0"
		"wide" "100"
		"tall" "400"

		"item_tall"	"24"
		"item_wide"	"100"

		"item_spacing" "2"

		"icon_ypos"	"0"
		"icon_xpos"	"0"
		"icon_tall"	"24"
		"icon_wide"	"24"

		"text_xpos"	"26"
	}
	HudRadio
	{
		"fieldName""HudRadio"
		"TextFont""Default"
		"visible""1"
		"xpos""10"
		"ypos""c"
		"wide""Default"
		"tall""Default"
		"text_ygap""2"
		"TextColor""255 255 255 192"
		"PaintBackgroundType""0"
	}

	HudHintKeyDisplay
	{
		"fieldName"	"HudHintKeyDisplay"
		"visible"	"0"
		"enabled" 	"1"
		"xpos"		"r120"	[$WIN32]
		"ypos"		"r340"	[$WIN32]
		"xpos"		"r148"	[$X360]
		"ypos"		"r338"	[$X360]
		"wide"		"100"
		"tall"		"200"
		"text_xpos"	"8"
		"text_ypos"	"8"
		"text_xgap"	"8"
		"text_ygap"	"8"
		"TextColor"	"255 170 0 220"

		"PaintBackgroundType"	"2"
	}
	
	HUDAutoAim
	{
		"fieldName" "HUDAutoAim"
		"visible" "1"
		"enabled" "1"
		"wide"	 "640"	[$WIN32]
		"tall"	 "480"	[$WIN32]
		"wide"	 "960"	[$X360]
		"tall"	 "720"	[$X360]
	}

	HudCommentary
	{
		"fieldName" "HudCommentary"
		"xpos"	"c-190"
		"ypos"	"350"
		"wide"	"380"
		"tall"	"40"
		"visible" "1"
		"enabled" "1"
		
		"PaintBackgroundType"	"2"
		
		"bar_xpos"	"50"
		"bar_ypos"	"20"
		"bar_height"	"8"
		"bar_width"	"320"
		"speaker_xpos"	"50"
		"speaker_ypos"	"8"
		"count_xpos_from_right"	"10"	// Counts from the right side
		"count_ypos"	"8"
		
		"icon_texture"	"vgui/hud/icon_commentary"
		"icon_xpos"	"0"
		"icon_ypos"	"0"		
		"icon_width"	"40"
		"icon_height"	"40"
	}
	
	HudHDRDemo
	{
		"fieldName" "HudHDRDemo"
		"xpos"	"0"
		"ypos"	"0"
		"wide"	"640"
		"tall"	"480"
		"visible" "1"
		"enabled" "1"
		
		"Alpha"	"255"
		"PaintBackgroundType"	"2"
		
		"BorderColor"	"0 0 0 255"
		"BorderLeft"	"16"
		"BorderRight"	"16"
		"BorderTop"		"16"
		"BorderBottom"	"64"
		"BorderCenter"	"0"
		
		"TextColor"		"255 255 255 255"
		"LeftTitleY"	"422"
		"RightTitleY"	"422"
	}

	AchievementNotificationPanel	
	{
		"fieldName"	"AchievementNotificationPanel"
		"visible"		"1"
		"enabled"	"1"
		"xpos"		"0"
		"ypos"		"180"
		"wide"		"f10"	[$WIN32]
		"wide"		"f60"	[$X360]
		"tall"		"100"
	}
}
