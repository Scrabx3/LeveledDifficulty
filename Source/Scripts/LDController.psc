Scriptname LDController extends Quest  

GlobalVariable[] Property Thresholds Auto

Function Maintenance()
  If (SKSE.GetPluginVersion("JContainers64") == -1)
    Debug.Trace("[LD] JContainers not loaded")
    LoadDefaults()
    return
  EndIf

  int obj = JValue.readFromFile("Data\\SKSE\\LvlDifficulty\\Settings.json")
  If(obj == 0 || !JValue.isMap(obj))
    Debug.Trace("[LD] Invalid json format, using default values")
    LoadDefaults()
    return
  EndIf

  String[] settings = new String[6]
  settings[0] = "" ; "VeryEasy" -> Always 0
  settings[1] = "Easy"
  settings[2] = "Normal"
  settings[3] = "Hard"
  settings[4] = "VeryHard"
  settings[5] = "Legendary"

  int i = 1
  While(i < settings.Length)
    Thresholds[i].Value = JMap.getInt(obj, settings[i], i * 10)
    i += 1
  EndWhile

  Update()
EndFunction
Function LoadDefaults()
  int i = 0
  While(i < thresholds.Length)
    Thresholds[i].Value = i * 10
    i += 1
  EndWhile
  Update()
EndFunction

Event OnStoryIncreaseLevel(int aiNewLevel)
  Update()
  RegisterForSingleUpdate(1)
EndEvent
Event OnUpdate()
  Stop()
EndEvent

Function Update()
  int lv = Game.GetPlayer().GetLevel()
  int i = thresholds.Length
  While(i > 0)
    i -= 1
    If (lv >= Thresholds[i].Value)
      Debug.Trace("[LD] Player Lv = " + lv + " / " + Thresholds[i].GetValueInt() + " Setting Difficulty to " + i)
      Utility.SetINIInt("iDifficulty:GamePlay", i)
      return
    EndIf
  EndWhile
  Debug.Trace("[LD] Unable to find Level Range for Level " + lv)
  Utility.SetINIInt("iDifficulty:GamePlay", 2)
EndFunction
