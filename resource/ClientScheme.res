///////////////////////////////////////////////////////////
// Fortress Forever scheme resource file
//
// sections:
//		Colors			- All the colors used by the scheme
//		BaseSettings		- contains settings for app to use to draw controls
//		Fonts			- list of all the fonts used by app
//		Borders			- description of all the borders
//		CustomFontFiles		- defines fonts to be loaded which are not part of the system
//
// P.S. Advise you turn off wordwrap xP
///////////////////////////////////////////////////////////
Scheme
{
	/////////////////////////// COLORS ///////////////////////////
	Colors
	{
		/////////////// HUD Colours ///////////////
		"HUD_Tone_Bright"		"225 235 255 235"
		"HUD_Tone_Default"		"199 219 255 215"
		"HUD_Tone_Dim"			"199 219 255 120"
		
		"HUD_BG_Bright"			"109 124 142 185"
		"HUD_BG_Default"		"109 124 142 115"
		"HUD_BG_Dim"			"109 124 142 50"
		
		"HUD_Surface_Bright"	"82 92 104 210"
		"HUD_Surface_Default"	"75 85 95 200"
		"HUD_Surface_Dim"		"75 85 95 50"
		
		"HUD_Border_Bright"		"255 255 255 255"
		"HUD_Border_Default"	"245 245 245 230"
		"HUD_Border_Dim"		"245 245 245 50"

		"Hud_Status_Bright"		"255 255 255 255"
		"Hud_status_Default"	"109 124 142 200"
		"Hud_Status_Dim"		"109 124 142 100"
		
		"ArmorIncColor"			"255 220 0 255"
		"ArmorLowColor"			"255 0 0 255"
		"ArmorDmgColor"			"255 0 0 255"
		
		"HealthIncColor"		"255 220 0 255"
		"HealthIncAbove100Color"	"0 255 0 255"
		"HealthLowColor"		"255 0 0 255"
		"HealthDmgColor"		"255 0 0 255"

		"KeyStatePressed"		"0 255 0 255"
		
		/////////////// VGUI Colours ///////////////
		"UI_Tone_Default"		"199 219 255 255"
		"UI_Tone_Dim"			"109 124 142 115"
		"UI_Tone_Dark"			"75 85 95 115"
		
		"UI_BG_Highlight"		"225 235 255 45"
		"UI_BG_Dim"				"0 0 0 165"
		"UI_BG_Dark"			"0 0 0 90"
		
		//"UI_Slider_Text"			"127 140 127 255"
		"UI_Slider_Text"			"0 255 0 255"
		"UI_Slider_Nob"				"108 108 108 255"
		"UI_Slider_Track"			"31 31 31 255"
		"UI_Slider_DisabledText1"	"117 117 117 255"
		"UI_Slider_DisabledText2"	"30 30 30 255"
		
		/////////////// Team Colours ///////////////
		"BlueTeamColor"			"56 100 171 196"
		"RedTeamColor"			"188 0 0 196"
		"YellowTeamColor"		"202 173 33 196"
		"GreenTeamColor"		"68 144 65 196"
		
		/////////////// Misc. Colours ///////////////
		"Red"				"255 0 0 255"
		"Yellow"			"255 255 0 255"
		"Blue"				"0 255 0 255"
		"Cyan"				"0 255 255 255"
		"Green"				"0 255 0 255"
		"Magenta"			"255 0 255 255"
		
		"White"				"255 255 255 255"
		"Black"				"0 0 0 255"
		
		"Blank"				"0 0 0 0"
		
		"Normal"			"109 124 142 115"
		"Dark"				"50 50 50 180"	
	}
	
	/////////////////////////// BASE SETTINGS ///////////////////////////
	BaseSettings
	{
		HudItem.Foreground		"HUD_Tone_Default"
		HudItem.Background		"HUD_BG_Default"
		
		"TeamColorHud.BackgroundAlpha"	"0 0 0 150"
		
		"FgColor"				"HUD_Tone_Default"
		"BgColor"				"Blank"

		"Panel.FgColor"			"HUD_Tone_Default"
		"Panel.BgColor"			"Blank"
		
		"BrightFg"				"HUD_Tone_Bright"

		"DamagedBg"				"Blank"
		"DamagedFg"				"Red"
		"BrightDamagedFg"		"Red"
		
		"ZoomReticleColor"		"Green"

		/////////////// Weapon Selection Colours ///////////////
		"SelectionNumberFg"			"HUD_Tone_Bright"
		"SelectionTextFg"			"HUD_Tone_Bright"
		"SelectionEmptyBoxBg"		"HUD_BG_Dim"
		"SelectionBoxBg"			"HUD_BG_Dim"
		"SelectionSelectedBoxBg" 	"HUD_BG_Dim"
		
		/////////////// VGUI Colour Specification ///////////////
		Border.Bright			"UI_Tone_Dark"		// the lit side of a control
		Border.Dark				"UI_Tone_Dark"		// the dark/unlit side of a control
		Border.Selection		"Blank"			// the additional border color for displaying the default/selected button

		Button.TextColor			"UI_Tone_Default"
		Button.BgColor				"Blank"
		Button.ArmedTextColor		"UI_Tone_Default"
		Button.ArmedBgColor			"UI_BG_Highlight"
		Button.DepressedTextColor	"UI_Tone_Default"
		Button.DepressedBgColor		"UI_BG_Highlight"

		CheckButton.TextColor			"UI_Tone_Default"
		CheckButton.SelectedTextColor	"UI_Tone_Default"
		CheckButton.BgColor				"UI_BG_Dim"
		CheckButton.Border1				"Border.Dark" 		// the left checkbutton border
		CheckButton.Border2				"Border.Bright"		// the right checkbutton border
		CheckButton.Check				"UI_Tone_Default"	// color of the check itself

		ComboBoxButton.ArrowColor		"UI_Tone_Default"
		ComboBoxButton.ArmedArrowColor	"UI_Tone_Default"
		ComboBoxButton.BgColor			"UI_BG_Dim"
		ComboBoxButton.DisabledBgColor	"Blank"

		Frame.BgColor						"Blank"
		Frame.OutOfFocusBgColor				"Blank"
		Frame.FocusTransitionEffectTime		"0.0"			// time it takes for a window to fade in/out on focus/out of focus
		Frame.TransitionEffectTime			"0.0"			// time it takes for a window to fade in/out on open/close
		Frame.AutoSnapRange					"0"
		FrameGrip.Color1					"Blank"
		FrameGrip.Color2					"Blank"
		FrameTitleButton.FgColor			"Blank"
		FrameTitleButton.BgColor			"Blank"
		FrameTitleButton.DisabledFgColor	"Blank"
		FrameTitleButton.DisabledBgColor	"Blank"
		FrameSystemButton.FgColor			"Blank"
		FrameSystemButton.BgColor			"Blank"
		FrameSystemButton.Icon				""
		FrameSystemButton.DisabledIcon		""
		FrameTitleBar.TextColor				"UI_Tone_Default"
		FrameTitleBar.BgColor				"Blank"
		FrameTitleBar.DisabledTextColor		"UI_Tone_Default"
		FrameTitleBar.DisabledBgColor		"Blank"

		GraphPanel.FgColor			"UI_Tone_Default"
		GraphPanel.BgColor			"UI_BG_Dim"
		
		Label.TextDullColor			"UI_Tone_Default"
		Label.TextColor				"UI_Tone_Default"
		Label.TextBrightColor		"UI_Tone_Default"
		Label.SelectedTextColor		"UI_Tone_Default"
		Label.BgColor				"Blank"
		Label.DisabledFgColor1		"Blank"
		Label.DisabledFgColor2		"UI_Tone_Dark"

		ListPanel.TextColor					"UI_Tone_Default"
		ListPanel.BgColor					"UI_BG_Dim"
		ListPanel.SelectedTextColor			"Black"
		ListPanel.SelectedBgColor			"UI_BG_Highlight"
		ListPanel.SelectedOutOfFocusBgColor	"UI_BG_Highlight"
		ListPanel.EmptyListInfoTextColor	"UI_Tone_Default"

		Menu.TextColor				"UI_Tone_Default"
		Menu.BgColor				"UI_BG_Dim"
		Menu.ArmedTextColor			"UI_Tone_Default"
		Menu.ArmedBgColor			"UI_BG_Highlight"
		Menu.TextInset				"6"

		Chat.TypingText				"UI_Tone_Default"

		Panel.FgColor				"UI_Tone_Dim"
		Panel.BgColor				"blank"
		
		HTML.BgColor				"0 0 0 255"

		ProgressBar.FgColor			"UI_Tone_Default"
		ProgressBar.BgColor			"UI_BG_Dim"

		PropertySheet.TextColor				"UI_Tone_Default"
		PropertySheet.SelectedTextColor		"UI_Tone_Default"
		PropertySheet.TransitionEffectTime	"0.25"			// time to change from one tab to another

		RadioButton.TextColor			"UI_Tone_Default"
		RadioButton.SelectedTextColor	"UI_Tone_Default"

		RichText.TextColor				"UI_Tone_Default"
		RichText.BgColor				"Blank"
		RichText.SelectedTextColor		"UI_Tone_Default"
		RichText.SelectedBgColor		"Blank"

		ScrollBarButton.FgColor				"UI_Tone_Default"
		ScrollBarButton.BgColor				"Blank"
		ScrollBarButton.ArmedFgColor		"UI_Tone_Default"
		ScrollBarButton.ArmedBgColor		"Blank"
		ScrollBarButton.DepressedFgColor	"UI_Tone_Default"
		ScrollBarButton.DepressedBgColor	"Blank"

		ScrollBarSlider.FgColor			"Blank"			// nob color
		ScrollBarSlider.BgColor			"Blank"			// slider background color

		SectionedListPanel.HeaderTextColor				"UI_Tone_Default"
		SectionedListPanel.HeaderBgColor				"Blank"
		SectionedListPanel.DividerColor					"Black"
		SectionedListPanel.TextColor					"UI_Tone_Default"
		SectionedListPanel.BrightTextColor				"UI_Tone_Default"
		SectionedListPanel.BgColor						"UI_BG_Dark"
		SectionedListPanel.SelectedTextColor			"Black"
		SectionedListPanel.SelectedBgColor				"UI_BG_Highlight"
		SectionedListPanel.OutOfFocusSelectedTextColor	"Black"
		SectionedListPanel.OutOfFocusSelectedBgColor	"UI_BG_Highlight"
		
		Slider.TextColor				"UI_Slider_Text"
		Slider.NobColor					"UI_Slider_Nob"
		Slider.TrackColor				"UI_Slider_Track"
		Slider.DisabledTextColor1		"UI_Slider_DisabledText1"
		Slider.DisabledTextColor2		"UI_Slider_DisabledText1"

		TextEntry.TextColor					"UI_Tone_Default"
		TextEntry.BgColor					"UI_BG_Dim"
		TextEntry.CursorColor				"UI_Tone_Default"
		TextEntry.DisabledTextColor			"UI_Tone_Default"
		TextEntry.DisabledBgColor			"Blank"
		TextEntry.SelectedTextColor			"Black"
		TextEntry.SelectedBgColor			"UI_BG_Highlight"
		TextEntry.OutOfFocusSelectedBgColor	"UI_BG_Highlight"
		TextEntry.FocusEdgeColor			"UI_BG_Dim"

		ToggleButton.SelectedTextColor		"UI_Tone_Default"

		Tooltip.TextColor			"UI_BG_Dim"
		Tooltip.BgColor				"UI_BG_Highlight"

		TreeView.BgColor			"UI_BG_Dim"

		WizardSubPanel.BgColor		"Blank"

		// Top-left corner of the main screen title
		"Main.Title1.X"				"76" //76
		"Main.Title1.Y"				"194" //184
		"Main.Title1.Color"			"White"

		// Top-left corner of the menu on the main screen
		"Main.Menu.X"				"76"
		"Main.Menu.Y"				"250" //240

		// Blank space to leave beneath the menu on the main screen
		"Main.BottomBorder"			"40"
	
		"FFButton.BgColor"			"HUD_Surface_Default"	
		"FFButton.BgColorArmed"		"HUD_Surface_Bright"
		"FFButton.BgColorPressed"	"HUD_Surface_Bright"
		"FFButton.BgColorDisabled"	"HUD_Surface_Dim"
		
		"FFButton.FgColor"			"HUD_Border_Default"
		"FFButton.FgColorArmed"		"HUD_Border_Bright"
		"FFButton.FgColorPressed"	"HUD_Border_Bright"
		"FFButton.FgColorDisabled"	"HUD_Border_Dim"
	}
	
	/////////////////////////// FONTS ///////////////////////////
	Fonts
	{
		// fonts are used in order that they are listed
		"DebugFixed"
		{
			"1"
			{
				"name"		"Courier New"
				"tall"		"14"
				"weight"	"400"
				"antialias"	"1"
			}
		}
		// fonts are used in order that they are listed
		"DebugFixedSmall"
		{
			"1"
			{
				"name"		"Courier New"
				"tall"		"14"
				"weight"	"400"
				"antialias"	"1"
			}
		}
		// fonts listed later in the order will only be used if they fulfill a range not already filled
		// if a font fails to load then the subsequent fonts will replace

		"Default" // death messages, not sure bout what else
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"13" [$LINUX]
				"tall"		"9"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"1 599"
				"additive"	"0"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"16" [$LINUX]
				"tall"		"12"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"600 767"
				"additive"	"0"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"18" [$LINUX]
				"tall"		"14"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"768 1023"
				"additive"	"0"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"24" [$LINUX]
				"tall"		"20"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1024 1199"
				"additive"	"0"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"28" [$LINUX]
				"tall"		"24"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1200 10000"
				"additive"	"0"
			}
		}

		"Default_Shadow" // death messages, not sure bout what else
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"13" [$LINUX]
				"tall"		"9"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"1 599"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"16" [$LINUX]
				"tall"		"12"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"600 767"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"18" [$LINUX]
				"tall"		"14"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"768 1023"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"24" [$LINUX]
				"tall"		"20"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1024 1199"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"28" [$LINUX]
				"tall"		"24"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1200 10000"
				"additive"	"0"
				"dropshadow"	"1"
			}
		}
		
		"DefaultBG" // used for testing shoks crosshair thing
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"9"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"1 599"
				"blur"		"3"
				"additive"	"0"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"600 767"
				"blur"		"3"
				"additive"	"0"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"768 1023"
				"blur"		"3"
				"additive"	"0"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1024 1199"
				"blur"		"3"
				"additive"	"0"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1200 10000"
				"blur"		"3"
				"additive"	"0"
			}
		}
		
		HudQuickmenu
		{
			"1"
			{
				"name"		"FortressForever - HUD Glyphs"
				"tall"		"16"
				"weight"	"0"
				"antialias"	"1"
				"yres"		"1 599"
			}
			"2"
			{
				"name"		"FortressForever - HUD Glyphs"
				"tall"		"18"
				"weight"	"0"
				"antialias"	"1"
				"yres"		"600 767"
			}
			"3"
			{
				"name"		"FortressForever - HUD Glyphs"
				"tall"		"24"
				"weight"	"0"
				"antialias"	"1"
				"yres"		"768 1023"
			}
			"4"
			{
				"name"		"FortressForever - HUD Glyphs"
				"tall"		"32"
				"weight"	"0"
				"antialias"	"1"
				"yres"		"1024 1199"
			}
			"5"
			{
				"name"		"FortressForever - HUD Glyphs"
				"tall"		"40"
				"weight"	"0"
				"antialias"	"1"
				"yres"		"1200 10000"
			}
		}
		HudNumbers2
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"32"
				"weight"	"0"
				"antialias"	"1"
				"yres"		"1 599"
			}
			"2"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"35"
				"weight"	"0"
				"antialias"	"1"
				"yres"		"600 767"
			}
			"3"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"37"
				"weight"	"0"
				"antialias"	"1"
				"yres"		"768 1023"
			}
			"4"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"43"
				"weight"	"0"
				"antialias"	"1"
				"yres"		"1024 1199"
			}
			"5"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"47"
				"weight"	"0"
				"antialias"	"1"
				"yres"		"1200 10000"
				"additive"	"1"
			}
		}
		"DefaultSmall"	// doesn't appear to be used
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"0"
				"range"		"0x0000 0x017F"
				"yres"		"480 599"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"13"
				"weight"	"0"
				"range"		"0x0000 0x017F"
				"yres"		"600 767"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"0"
				"range"		"0x0000 0x017F"
				"yres"		"768 1023"
				"antialias"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"0"
				"range"		"0x0000 0x017F"
				"yres"		"1024 1199"
				"antialias"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"0"
				"range"		"0x0000 0x017F"
				"yres"		"1200 6000"
				"antialias"	"1"
			}
			"6"
			{
				"name"		"Arial"
				"tall"		"12"
				"range"	"0x0000 0x00FF"
				"weight"	"0"
			}
		}
		"DefaultSmall_Shadow"	// doesn't appear to be used
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"0"
				"range"		"0x0000 0x017F"
				"yres"		"480 599"
				"dropshadow"	"1"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"13"
				"weight"	"0"
				"range"		"0x0000 0x017F"
				"yres"		"600 767"
				"dropshadow"	"1"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"0"
				"range"		"0x0000 0x017F"
				"yres"		"768 1023"
				"antialias"	"1"
				"dropshadow"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"0"
				"range"		"0x0000 0x017F"
				"yres"		"1024 1199"
				"antialias"	"1"
				"dropshadow"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"0"
				"range"		"0x0000 0x017F"
				"yres"		"1200 6000"
				"antialias"	"1"
				"dropshadow"	"1"
			}
			"6"
			{
				"name"		"Arial"
				"tall"		"12"
				"range"	"0x0000 0x00FF"
				"weight"	"0"
				"dropshadow"	"1"
			}
		}
		"DefaultVerySmall"	// doesn't appear to be used
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"		"480 599"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"13"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"		"600 767"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"		"768 1023"
				"antialias"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"		"1024 1199"
				"antialias"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"		"1200 6000"
				"antialias"	"1"
			}
			"6"
			{
				"name"		"Verdana"
				"tall"		"12"
				"range"	"0x0000 0x00FF"
				"weight"	"0"
			}
			"7"
			{
				"name"		"Arial"
				"tall"		"11"
				"range"	"0x0000 0x00FF"
				"weight"	"0"
			}
		}
		"DefaultVerySmall_Shadow"	// doesn't appear to be used
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"		"480 599"
				"dropshadow"	"1"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"13"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"		"600 767"
				"dropshadow"	"1"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"		"768 1023"
				"antialias"	"1"
				"dropshadow"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"		"1024 1199"
				"antialias"	"1"
				"dropshadow"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"0"
				"range"		"0x0000 0x017F" //	Basic Latin, Latin-1 Supplement, Latin Extended-A
				"yres"		"1200 6000"
				"antialias"	"1"
				"dropshadow"	"1"
			}
			"6"
			{
				"name"		"Verdana"
				"tall"		"12"
				"range"	"0x0000 0x00FF"
				"weight"	"0"
				"dropshadow"	"1"
			}
			"7"
			{
				"name"		"Arial"
				"tall"		"11"
				"range"	"0x0000 0x00FF"
				"weight"	"0"
				"dropshadow"	"1"
			}
		}
		Crosshairs
		{
			"1"
			{
				"name"		"HalfLife2"
				"tall"		"40"
				"weight"	"0"
				"antialias"	"0"
				"additive"	"1"
				"yres"		"1 10000"
			}
		}
		QuickInfo
		{
			"1"
			{
				"name"		"HL2cross"
				"tall"		"28"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		HudNumbers
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"32"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		HudNumbersGlow
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"32"
				"weight"	"0"
				"blur"		"4"
				"scanlines"	"2"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		HudNumbersSmall
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"16"
				"weight"	"1000"
				"additive"	"1"
				"antialias"	"1"
			}
		}
		HudSelectionNumbers
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"11"
				"weight"	"700"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		
		"HudHintCenterIcon"
		{
			"1"
			{
				"name"		"FortressForever - Hud Glyphs"
				"tall"		"32"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		
		"HudHintCenterIconGlow"
		{
			"1"
			{
				"name"		"FortressForever - Hud Glyphs"
				"tall"		"32"
				"weight"	"0"
				"blur"		"4"
				"scanlines" "2"
				"antialias" "1"
				"additive"	"1"
			}
		}
		
		HudAddHealth
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"16"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"0"
				"dropshadow" "1" 
			}
		}

		HudTeamScore
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"15"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"0"
				"dropshadow" "1" 
			}
		}

		HudPlayerScore
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"16"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"0"
				"dropshadow" "1" 
			}
		}
		HudPlayerScoreDesc
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"12"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"0"
				"dropshadow" "1"
			}
		}
		
		HudPlayerScoreBG
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"18"
				"weight"	"1000"
				"antialias"	"1"
				"blur"		"5"
				"additive"	"0"
			}
		}

		HudPlayerScoreDescBG
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"1000"
				"antialias"	"1"
				"blur"		"5"
				"additive"	"0"
			}
		}
		
		HudBonusScore
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"12"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"0"
				"dropshadow" "1" 
			}
		}

		HudBonusScoreDesc
		{
			"1"
			{
				"name"		"FortressForever - HUD Font CAPS"
				"tall"		"10"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"0"
				"dropshadow" "1"
			}
		}
		
		HUD_HintText
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"13" [$LINUX]
				"tall"		"9"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"1 599"
				"additive"	"0"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"16" [$LINUX]
				"tall"		"12"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"600 767"
				"additive"	"0"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"18" [$LINUX]
				"tall"		"14"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"768 1023"
				"additive"	"0"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"24" [$LINUX]
				"tall"		"20"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1024 1199"
				"additive"	"0"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"28" [$LINUX]
				"tall"		"24"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1200 10000"
				"additive"	"0"
			}
		}
		
		HudHintTextLarge
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"32"
				"weight"	"1000"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		HudHintTextSmall
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"32"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		
		BudgetLabel
		{
			"1"
			{
				"name"		"Courier New"
				"tall"		"14"
				"weight"	"400"
				"outline"	"1"
			}
		}
		DebugOverlay
		{
			"1"
			{
				"name"		"Courier New"
				"tall"		"14"
				"weight"	"400"
				"outline"	"1"
			}
		}
		"CloseCaption_Normal"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"26"
				"weight"	"500"
				"dropshadow"	"1"
			}
		}
		"CloseCaption_Italic"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"26"
				"weight"	"500"
				"italic"	"1"
				"dropshadow"	"1"
			}
		}
		"CloseCaption_Bold"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"26"
				"weight"	"900"
				"dropshadow"	"1"
			}
		}
		"CloseCaption_BoldItalic"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"26"
				"weight"	"900"
				"italic"	"1"
				"dropshadow"	"1"
			}
		}
	
		// this is the symbol font
		"Marlett"
		{
			"1"
			{
				"name"		"Marlett"
				"tall"		"14"
				"weight"	"0"
				"symbol"	"1"
			}
		}
		"Trebuchet24"
		{
			"1"
			{
				"name"		"Trebuchet MS"
				"tall"		"24"
				"weight"	"900"
				"range"		"0x0000 0x007F"	//	Basic Latin
				"antialias"	"1"
				"additive"	"1"
			}
		}
		"Trebuchet18"
		{
			"1"
			{
				"name"		"Trebuchet MS"
				"tall"		"18"
				"weight"	"900"
			}
		}
		"ClientTitleFont" // Main Title above resume game etc..
		{
			"1"
			{
				"name"	"FortressForever - HUD Font"
				"tall"	"32"
				"weight"	"0"
				"additive"	"0"
				"antialias"	"1"
				"yres"		"480 599"
			}
	
			"2"
			{
				"name"	"FortressForever - HUD Font"
				"tall"	"48"
				"weight"	"0"
				"additive"	"0"
				"antialias"	"1"
				"yres"		"600 767"
			}
			"3"
			{
				"name"	"FortressForever - HUD Font"
				"tall"	"64"
				"weight"	"0"
				"additive"	"0"
				"antialias"	"1"
				"yres"		"768 1023"
			}
			"4"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"80"
				"weight"	"0"
				"yres"		"1024 1199"
				"antialias"	"1"
			}
			"5"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"96"
				"weight"	"0"
				"yres"		"1200 6000"
				"antialias"	"1"
			}
		}
		CreditsLogo
		{
			"1"
			{
				"name"		"HalfLife2"
				"tall"		"128"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		CreditsText
		{
			"1"
			{
				"name"		"Trebuchet MS"
				"tall"		"20"
				"weight"	"900"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		CreditsOutroLogos
		{
			"1"
			{
				"name"		"HalfLife2"
				"tall"		"48"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		CreditsOutroText
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"9"
				"weight"	"900"
				"antialias"	"1"
			}
		}
		CenterPrintText
		{
			// note that this scales with the screen resolution
			"1"
			{
				"name"		"Trebuchet MS"
				"tall"		"18"
				"weight"	"900"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		
		"BuildStateFont"
		{
		  	"1"
		  	{
				"name"    	"Verdana"
				"tall"		"18" [$LINUX]
				"tall"    	"12"
				"weight"  	"700"
				"yres"  	"480 599"
				"dropshadow"  	"1"
		 	}
			"2"
			{
				"name"   	"Verdana"
				"tall"		"19" [$LINUX]
				"tall"    	"13"
				"weight"  	"700"
				"yres"  	"600 767"
				"dropshadow"  	"1"
			}
			"3"
			{
				"name"    	"Verdana"
				"tall"		"20" [$LINUX]
				"tall"    	"14"
				"weight"  	"700"
				"yres"  	"768 1023"
				"dropshadow"  	"1"
			}
			"4"
			{
				"name"    	"Verdana"
				"tall"		"26" [$LINUX]
				"tall"    	"20"
				"weight"  	"700"
				"yres"  	"1024 1199"
				"dropshadow"  	"1"
			}
			"5"
			{
				"name"    	"Verdana"
				"tall"		"30" [$LINUX]
				"tall"    	"24"
				"weight"  	"700"
				"yres"  	"1200 10000"
				"dropshadow"  	"1"
			}
		}
		
		///////////////////////////NEW STUFF/////////////////////////////

		

		HudSelectionText	//Text below weapon selection glyphs
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"9"
				"weight"	"500"
				"antialias"	"1"
				"yres"		"1 599"
			}
			"2"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"11"
				"weight"	"500"
				"antialias"	"1"
				"yres"		"600 767"
			}
			"3"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"13"
				"weight"	"600"
				"antialias"	"1"
				"yres"		"768 1023"
			}
			"4"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"16"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1024 1199"
			}
			"5"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"17"
				"weight"	"1000"
				"antialias"	"1"
				"yres"		"1200 10000"
			}
		}
		"MenuTitle" // class menu title, flythrough title etc
		{
			
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"18"
				"weight"	"500"
				"antialias"	"1"
				"yres"		"1 599"
			}
			"2"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"18"
				"weight"	"500"
				"antialias"	"1"
				"yres"		"600 767"
			}
			"3"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"24"
				"weight"	"600"
				"antialias"	"1"
				"yres"		"768 1023"
			}
			"4"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"36"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1024 1199"
			}
			"5"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"48"
				"weight"	"1000"
				"antialias"	"1"
				"yres"		"1200 10000"
			}
		}
		ClassMenu	// class selection text
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"12"
				"weight"	"300"
				"antialias" "1"
				"yres"		"1 599"
			}
			"2"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"14"
				"weight"	"500"
				"antialias"	"1"
				"yres"		"600 767"
			}
			"3"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"16"
				"weight"	"500"
				"antialias"	"1"
				"yres"		"768 1023"
			}
			"4"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"24"
				"weight"	"1000"
				"antialias"	"1"
				"yres"		"1024 1199"
			}
			"5"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"30"
				"weight"	"1000"
				"antialias"	"1"
				"yres"		"1200 10000"
			}
		}
		"HUD_BackGround"	// hud shape glyphs
		{
			"1"
			{
				"name"		"FortressForever - HUD Glyphs"
				"tall"		"31"
				"antialias"	"1"
			}
		}
		"HUD_ForeGround"	// hud shape glyphs
		{
			"1"
			{
				"name"		"FortressForever - HUD Glyphs"
				"tall"		"31"	
				"antialias"	"1"
			}
		}
		"HUD_NumSmall"
		{
			"1"
			{
				"name"		"FortressForever - HUD Glyphs"
				"tall"		"10"
				"antialias"	"1"
				
			}
		}
		"HUD_NumLarge"
		{
			"1"
			{
				"name"		"FortressForever - HUD Glyphs"
				"tall"		"20"
				"antialias"	"1"
				
			}
		}
		"HUD_TextSmall"	// font used when you disguise
		{
			"1"
			{
				"name"		"FortressForever - HUD Font" // Tahoma
				"tall"		"10"
				"antialias"	"1"
			}
		}
		"HUD_TextSmall_Shadow"	// font used when you disguise
		{
			"1"
			{
				"name"		"FortressForever - HUD Font" // Tahoma
				"tall"		"10"
				"antialias"	"1"
				"dropshadow"	"1"
			}
		}
		"HUD_TextRoundInfo"
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"13"
				"antialias"	"1"
				"additive"	"0"
			}
		}	
		"WeaponIcons" // selected weapon's foreground
		{
			"1"
			{
				"name"		"FortressForever - Item Glyphs"
				"tall"		"46" [$LINUX]
				"tall"		"64"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		"WeaponIconsSelected" // selected weapon's background
		{
			"1"
			{
				"name"		"FortressForever - Item Glyphs"
				"tall"		"46" [$LINUX]
				"tall"		"64"
				"weight"	"0"
				"antialias"	"1"
				"blur"		"5"
				"scanlines"	"2"
				"additive"	"1"
			}
		}
		"WeaponIconsClassSelect" // weapon icons on class menu
		{
			"1"
			{
				"name"		"FortressForever - Item Glyphs"
				"tall"		"40" [$LINUX]
				"tall"		"50"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		"WeaponIconsHUD" // weapon icon on the bottom right, over the hud glyph
		{
			"1"
			{
				"name"		"FortressForever - Item Glyphs"
				"tall"		"30" [$LINUX]
				"tall"		"38"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		"WeaponIconsSmall"
		{
			"1"
			{
				"name"		"FortressForever - Item Glyphs"
				"tall"		"28"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		"AmmoIconsSmall" // ammo icons
		{
			"1"
			{
				"name"		"FortressForever - Item Glyphs"
				"tall"		"12" [$LINUX]
				"tall"		"16"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		"StatusGlyphs" // status effect glyphs
		{
			"1"
			{
				"name"		"FortressForever - Status Glyphs"
				"tall"		"36" [$LINUX]
				"tall"		"48"
				"weight"	"0" 
				"antialias"	"1"
				"additive"	"1"
			}
		}
		"StatusGlyphsSmall" // weapons that are *not* selected
		{
			"1"
			{
				"name"		"FortressForever - Status Glyphs"
				"tall"		"12" [$LINUX]
				"tall"		"20"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		"GrenadeIcons" // grenade icons
		{
			"1"
			{
				"name"		"FortressForever - Status Glyphs"
				"tall"		"12" [$LINUX]
				"tall"		"18"
				"weight"	"0"
				"antialias"	"1"
				//"dropshadow" "1"
			}
		}
		"GrenadeAmmoIcons" // grenade ammo icons (show up when one picks up a grenade pack)
		{
			"1"
			{
				"name"		"FortressForever - Status Glyphs"
				"tall"		"20" [$LINUX]
				"tall"		"28"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"1"
			}
		}
		"ClassGlyphs"	// icons on hud when you disguise and such
		{
			"1"
			{
				"name"		"FortressForever - Hud Glyphs"
				"tall"		"22" [$LINUX]
				"tall"		"26"
				"weight"	"0"
				"antialias"	"1"
				"additive"	"0"
			}
		}
		
		"TeamMenuTitles_small"
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"8"	// 6
				"weight"	"0"
				"antialias"	"1"
			}
		}
		"TeamMenuTitles"
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"10"	// 6
				"weight"	"0"
				"antialias"	"1"
			}
		}

		"TeamMenuTitles_large"
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"12"	// 6
				"weight"	"0"
				"antialias"	"1"
			}
		}

		"TeamMenuTitles_small"
		{
			"1"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"8"	// 6
				"weight"	"0"
				"antialias"	"1"
			}
		}

		"Tahoma8"	// after you've joined server-map information titles and shit, now replaced
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"8"	// 6
				"weight"	"0"
				"antialias"	"1"
			}
		}
		"Tahoma12"
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"12"	// 6
				"weight"	"0"
				"antialias"	"1"
			}
	
		}
		"Tahoma16"	// Scoreboard listing of map and server name?
		{
			"1"
			{
				"name"		"Tahoma"
				"tall"		"16" // 12
				"weight"	"700"
				"antialias"	"1"
			}
		}
		"Scoreboard"	// Column titles and player list
		{
			"1"
			{
				"name"	"FortressForever - HUD Font"
				"tall"	"12"
				"weight"	"0"
				"dropshadow"	"1"
				"antialias"	"1"
				"yres"		"1 599"
			}
	
			"2"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"14"
				"weight"	"0"
				"antialias"	"1"
				"dropshadow"	"1"
				"yres"		"600 767"
			}
			"3"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"16"
				"weight"	"0"
				"antialias"	"1"
				"dropshadow"	"1"
				"yres"		"768 1023"
			}
			"4"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"24"
				"weight"	"0"
				"antialias"	"1"
				"dropshadow"	"1"
				"yres"		"1024 1199"
			}
			"5"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"30"
				"weight"	"0"
				"antialias"	"1"
				"dropshadow"	"1"
				"yres"		"1200 9999"
			}
		}
		"Scoreboard_Header"	// Main Scoreboard titles
		{
			"1"
			{
				"name"	"FortressForever - HUD Font"
				"tall"	"14"
				"weight"	"0"
				"dropshadow"	"1"
				"antialias"	"1"
				"yres"		"1 599"
			}
			"2"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"16"
				"weight"	"0"
				"antialias"	"1"
				"dropshadow"	"1"
				"yres"		"600 767"
			}
			"3"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"18"
				"weight"	"0"
				"antialias"	"1"
				"dropshadow"	"1"
				"yres"		"768 1023"
			}
			"4"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"24"
				"weight"	"0"
				"antialias"	"1"
				"dropshadow"	"1"
				"yres"		"1024 1199"
			}
			"5"
			{
				"name"		"FortressForever - HUD Font"
				"tall"		"32"
				"weight"	"0"
				"antialias"	"1"
				"dropshadow"	"1"
				"yres"		"1200 9999"
			}
		}
		
		"LuaText_Default" // used for Lua hud timers, text, etc
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"15" [$LINUX]
				"tall"		"9"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"1 599"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"18" [$LINUX]
				"tall"		"12"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"600 767"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"20" [$LINUX]
				"tall"		"14"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"768 1023"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"26" [$LINUX]
				"tall"		"20"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1024 1199"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"30" [$LINUX]
				"tall"		"24"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1200 10000"
				"additive"	"0"
				"dropshadow"	"1"
			}
		}
		"LuaText1"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"9"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"1 599"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"600 767"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"768 1023"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1024 1199"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1200 10000"
				"additive"	"0"
				"dropshadow"	"1"
			}
		}
		"LuaText2"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"12"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"1 599"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"600 767"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"768 1023"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1024 1199"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"30"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1200 10000"
				"additive"	"0"
				"dropshadow"	"1"
			}
		}
		"LuaText3"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"14"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"1 599"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"600 767"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"768 1023"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"30"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1024 1199"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"36"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1200 10000"
				"additive"	"0"
				"dropshadow"	"1"
			}
		}
		"LuaText4"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"20"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"1 599"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"600 767"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"30"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"768 1023"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"36"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1024 1199"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"40"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1200 10000"
				"additive"	"0"
				"dropshadow"	"1"
			}
		}
		"LuaText5"
		{
			"1"
			{
				"name"		"Verdana"
				"tall"		"24"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"1 599"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"2"
			{
				"name"		"Verdana"
				"tall"		"30"
				"weight"	"700"
				"antialias"	"1"
				"yres"		"600 767"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"3"
			{
				"name"		"Verdana"
				"tall"		"36"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"768 1023"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"4"
			{
				"name"		"Verdana"
				"tall"		"40"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1024 1199"
				"additive"	"0"
				"dropshadow"	"1"
			}
			"5"
			{
				"name"		"Verdana"
				"tall"		"48"
				"weight"	"900"
				"antialias"	"1"
				"yres"		"1200 10000"
				"additive"	"0"
				"dropshadow"	"1"
			}
		}
	}
	
	/////////////////////////// BORDERS ///////////////////////////
	Borders
	{
		BaseBorder
		{
			"inset" "0 0 1 1"
			Left
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 0"
				}
			}
		}
		
		TitleButtonBorder
		{
			"inset" "0 0 1 1"
			Left
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}
		}

		TitleButtonDisabledBorder
		{
			"inset" "0 0 1 1"
			Left
			{
				"1"
				{
					"color" "BgColor"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "BgColor"
					"offset" "1 0"
				}
			}
			Top
			{
				"1"
				{
					"color" "BgColor"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "BgColor"
					"offset" "0 0"
				}
			}
		}

		TitleButtonDepressedBorder
		{
			"inset" "1 1 1 1"
			Left
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 0"
				}
			}
		}

		ScrollBarButtonBorder
		{
			"inset" "1 0 0 0"
			Left
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}
		}

		ScrollBarButtonDepressedBorder
		{
			"inset" "2 2 0 0"
			Left
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 0"
				}
			}
		}
		
		ButtonBorder
		{
			"inset" "0 0 0 0"
			Left
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "1 1"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}
		}

		ScoreBoardItemBorder
		{
			"inset" "0 0 0 0"
			Left
			{
				"1"
				{
					"color" "White"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "White"
					"offset" "0 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "White"
					"offset" "1 1"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "White"
					"offset" "0 0"
				}
			}
		}

		FrameBorder
		{
			"inset" "0 0 1 1"
			Left
			{
				"1"
				{
					"color" "ControlBG"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "ControlBG"
					"offset" "0 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "ControlBG"
					"offset" "0 1"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "ControlBG"
					"offset" "0 0"
				}
			}
		}

		TabBorder
		{
			"inset" "0 0 1 1"
			Left
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 0"
				}
			}
		}

		TabActiveBorder
		{
			"inset" "0 0 1 0"
			Left
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 0"
				}
			}

			Right
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "ControlBG"
					"offset" "6 2"
				}
			}
		}


		ToolTipBorder
		{
			"inset" "0 0 1 0"
			Left
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}

			Right
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}
		}

		// this is the border used for default buttons (the button that gets pressed when you hit enter)
		ButtonKeyFocusBorder
		{
			"inset" "0 0 0 0"
			Left
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "1 1"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}
		}

		ButtonDepressedBorder
		{
			"inset" "0 0 0 0"
			Left
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "1 1"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}
		}

		ComboBoxBorder
		{
			"inset" "0 0 1 1"
			Left
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 0"
				}
			}
		}

		MenuBorder
		{
			"inset" "1 1 1 1"
			Left
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 1"
				}
			}

			Right
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "1 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}
		}
		BrowserBorder
		{
			"inset" "0 0 0 0"
			Left
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}

			Right
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 0"
				}
			}

			Top
			{
				"1"
				{
					"color" "Border.Dark"
					"offset" "0 0"
				}
			}

			Bottom
			{
				"1"
				{
					"color" "Border.Bright"
					"offset" "0 0"
				}
			}
		}
	}
		
	/////////////////////////// CUSTOM FONT FILES ///////////////////////////
	CustomFontFiles
	{
		"1"		"resource/HUDGlyphs.ttf"
		"2"		"resource/ItemGlyphs.ttf"
		"3"		"resource/StatusGlyphs.ttf"
		"4"		"resource/Crosshairs.ttf"
		"5"		"resource/HALFLIFE2.ttf"
		"6"		"resource/HL2crosshairs.ttf"
		"7"		"resource/HUDfont.ttf"
		"8"		"resource/HUDfont_caps.ttf"
	}
}
