#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         HKLCF

 Script Function:
	This is the main function of ePokeMMMOBot.

#ce ----------------------------------------------------------------------------

#include "Config.au3"
#include "ImageSearch.au3"
#include "Pixel.au3"

$StatusX = @DesktopWidth / 2
$StatusY = 0

Global $Paused
HotKeySet('{HOME}', 'Pause')
HotKeySet('{END}', 'Quit')
$InBattle = 0
$Searching = 0
$Battle = 0
$Potion = 0

Pause()

Func Pause()
   $Paused = Not $Paused
   While $Paused
	  Sleep(100)
	  ToolTip('Press HOME to Start or END to Exit.', $StatusX, $StatusY)
   WEnd
   ToolTip('ePokeMMOBot', $StatusX, $StatusY)
EndFunc

Func Quit()
	Exit 0
EndFunc

$X = 0
$Y = 0
$X1 = 0
$Y1 = 0
$X2 = 0
$Y2 = 0
$X3 = 0
$Y3 = 0
$X4 = 0
$Y4 = 0

If $F12 = 1 Then
   Send("{F12}")
   $F12 = 0
EndIf

Func _WinWaitActivate()
   WinWait("PokeMMO")
   If Not WinActive("PokeMMO") Then
	  WinActivate("PokeMMO")
   Else
	  WinWaitActive("PokeMMO")
	  WinMove("PokeMMO", "", 0, 0, $ResolutionW, $ResolutionH)
	  InGame()
   EndIf
EndFunc

While $InBattle = 0
   _WinWaitActivate()
WEnd

Func InGame()
   Switch $HatColor
	  Case 'Red'
		 $HatColorCode = '0xF86848'
	  Case 'Blue'
		 $HatColorCode = '0x0000FF'
	  Case 'Green'
		 $HatColorCode = '0x00C800'
	  Case 'Black'
		 $HatColorCode = '0x323232'
	  Case 'Cyan'
		 $HatColorCode = '0x408080'
	  Case 'Yellow'
		 $HatColorCode = '0xFFFF00'
	  Case 'Female'
		 $HatColorCode = '0xE8E8F8'
   EndSwitch
   $Searching = PixelSearch($HatX, $HatY, $HatX, $HatY + 1, $HatColorCode)
   If Not @error Then
	  If $Fishing = 'Yes' Then
		 Fishing()
	  Else
		 Walking()
	  EndIf
   Else
	  If $AutoHP = 'Yes' Then
		 HealthCheck()
	  Else
		 Battle()
	  EndIf
   EndIf
EndFunc

Func Fishing()
   Send("{F2}")
   Sleep(Random(50, 100))
EndFunc

Func Walking()
   $Step = 0
   While 1
      If $Step <= $WalkStep Then
		 If $WalkMode = 'Horizontal' Then
			Send("{LEFT down}")
		 Else
			Send("{UP down}")
		 EndIf
		 Sleep(Random(50, 100))
		 If $WalkMode = 'Horizontal' Then
			Send("{LEFT up}")
		 Else
			Send("{UP up}")
		 EndIf
		 Sleep(Random(50, 100))
		 $Step = $Step + 1
	  Else
		 ExitLoop
	  EndIf
   WEnd
   $Step = 0
   While 1
	  If $Step <= $WalkStep Then
		 If $WalkMode = 'Horizontal' Then
			Send("{RIGHT down}")
		 Else
			Send("{DOWN down}")
		 EndIf
		 Sleep(Random(50, 100))
		 If $WalkMode = 'Horizontal' Then
			Send("{RIGHT up}")
		 Else
			Send("{DOWN up}")
		 EndIf
		 Sleep(Random(50, 100))
		 $Step = $Step + 1
	  Else
		 ExitLoop
	  EndIf
   WEnd
   Sleep(Random(50, 100))
   $Step = 0
   InGame()
EndFunc

Func HealthCheck()
   $Searching = PixelSearch($HPX, $HPY, $HPX, $HPY + 1, 0xFFFFFF, 10)
   If Not @error Then
	  Potion()
   Else
	  Battle()
   EndIf
EndFunc

Func Potion()
   $Searching = PixelSearch($HPX, $HPY, $HPX, $HPY, 0xFFFFFF, 10)
   If Not @error Then
	  $Potion = _ImageSearch('images/bag.bmp', 0, $X, $Y, 0)
	  If $Potion = 1 Then
		 MouseClick("left", $X, $Y)
		 Sleep(Random(100, 250))
		 $Potion = _ImageSearch('images/potion.bmp', 0, $X, $Y, 0)
		 If $Potion = 1 Then
			MouseClick("left", $X, $Y)
			Sleep(Random(100, 250))
			MouseClick("left", 495, 500)
		 EndIf
	  EndIf
   EndIf
   InGame()
EndFunc

Func Battle()
   $Searching = PixelSearch($DialogueBoxX, $DialogueBoxY, $DialogueBoxX, $DialogueBoxY + 1, 0xE0E8E8) ;Looking for white in dialogue box
   If Not @error Then
	  $CheckDead = _ImageSearch('images/hp.bmp', 0, $X, $Y, 0)
	  $CheckDead2 = _ImageSearch('images/hp_gray.bmp', 0, $X, $Y, 0)
	  If $CheckDead Or $CheckDead2 = 1 Then
		 Send("{TAB}")
		 Send("{ENTER}")
	  EndIf
	  $Battle = _ImageSearch('images/fight.bmp', 0, $X, $Y, 0)
	  If $Battle = 1 Then
		 MouseClick("left", $X, $Y)
		 Sleep(Random(300, 500))
		 $Check1PP = _ImageSearchArea('images/pp.bmp',0, $AttackSlot1X1, $AttackSlot1Y1, $AttackSlot1X2, $AttackSlot1Y2, $X1, $Y1, 0)
		 $Check1PP2 = _ImageSearchArea('images/pp_gray.bmp',0, $AttackSlot1X1, $AttackSlot1Y1, $AttackSlot1X2, $AttackSlot1Y2, $X1, $Y1, 0)
		 $Check2PP = _ImageSearchArea('images/pp.bmp',0, $AttackSlot2X1, $AttackSlot2Y1, $AttackSlot2X2, $AttackSlot2Y2, $X2, $Y2, 0)
		 $Check2PP2 = _ImageSearchArea('images/pp_gray.bmp',0, $AttackSlot2X1, $AttackSlot2Y1, $AttackSlot2X2, $AttackSlot2Y2, $X2, $Y2, 0)
		 $Check3PP = _ImageSearchArea('images/pp.bmp',0, $AttackSlot3X1, $AttackSlot3Y1, $AttackSlot3X2, $AttackSlot3Y2, $X3, $Y3, 0)
		 $Check3PP2 = _ImageSearchArea('images/pp_gray.bmp',0, $AttackSlot3X1, $AttackSlot3Y1, $AttackSlot3X2, $AttackSlot3Y2, $X3, $Y3, 0)
		 $Check4PP = _ImageSearchArea('images/pp.bmp',0, $AttackSlot4X1, $AttackSlot4Y1, $AttackSlot4X2, $AttackSlot4Y2, $X4, $Y4, 0)
		 $Check4PP2 = _ImageSearchArea('images/pp_gray.bmp',0, $AttackSlot4X1, $AttackSlot4Y1, $AttackSlot4X2, $AttackSlot4Y2, $X4, $Y4, 0)
		 $AttackSlot1X = $X
		 $AttackSlot1Y = $Y
		 $AttackSlot2X = $X + 300
		 $AttackSlot2Y = $Y
		 $AttackSlot3X = $X
		 $AttackSlot3Y = $Y + 50
		 $AttackSlot4X = $X + 300
		 $AttackSlot4Y = $Y + 50
		 If $AttackSlot1 = 'Yes' And $Check1PP = 0 And $Check1PP2 = 0 Then
			MouseClick("left", $AttackSlot1X, $AttackSlot1Y)
			Sleep(Random(1000, 3000))
		 ElseIf $AttackSlot2 = 'Yes' And $Check2PP = 0 And $Check2PP2 = 0 Then
			MouseClick("left", $AttackSlot2X, $AttackSlot2Y)
			Sleep(Random(1000, 3000))
		 ElseIf $AttackSlot3 = 'Yes' And $Check3PP = 0 And $Check3PP2 = 0 Then
			MouseClick("left", $AttackSlot3X, $AttackSlot3Y)
			Sleep(Random(1000, 3000))
		 ElseIf $AttackSlot4 = 'Yes' And $Check4PP = 0 And $Check4PP2 = 0 Then
			MouseClick("left", $AttackSlot4X, $AttackSlot4Y)
			Sleep(Random(1000, 3000))
		 Else
;~ 			RunAway()
			SwitchPokemon()
		 EndIf
		 InGame()
	  EndIf
   EndIf
EndFunc

Func RunAway()
   $GoBack = _ImageSearch('images/goback.bmp', 0, $X, $Y, 0)
   If $GoBack = 1 Then
	  MouseClick("left", $X, $Y)
	  Sleep(Random(300, 500))
	  $RunAway = _ImageSearch('images/run.bmp', 0, $X, $Y, 0)
	  If $RunAway = 1 Then
		 MouseClick("left", $X, $Y)
		 Sleep(Random(300, 500))
	  EndIf
   EndIf
   InGame()
EndFunc

Func SwitchPokemon()
   $GoBack = _ImageSearch('images/goback.bmp', 0, $X, $Y, 0)
   If $GoBack = 1 Then
	  MouseClick("left", $X, $Y)
	  Sleep(Random(300, 500))
	  $SwitchPokemon = _ImageSearch('images/pokemon.bmp', 0, $X, $Y, 0)
	  If $SwitchPokemon = 1 Then
		 MouseClick("left", $X, $Y)
		 Sleep(Random(300, 500))
		 MouseClick("left", $X , $Y - 100)
		 Sleep(Random(300, 500))
		 Send("{TAB}")
		 Send("{TAB}")
		 Send("{ENTER}")
	  EndIf
   EndIf
   InGame()
EndFunc