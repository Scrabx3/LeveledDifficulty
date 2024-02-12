Scriptname LDPlayerScr extends ReferenceAlias  

LDController Property Controller Auto

Event OnInit()
  OnPlayerLoadGame()
EndEvent
Event OnPlayerLoadGame()
  Controller.Maintenance()
EndEvent
