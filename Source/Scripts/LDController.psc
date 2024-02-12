Scriptname LDController extends Quest  

int[] thresholds
Function Maintenance()
  thresholds = new int[6]
  If (SKSE.GetPluginVersion("JContainers") == -1)
    LoadDefaults()
    return
  EndIf

  int obj = JValue.readFromFile("SKSE\\LvlDifficulty\\Settings.json")
  If(obj == 0 || !JValue.isMap(obj))
    LoadDefaults()
    return
  EndIf

  String[] settings = new String[6]
  settings[0] = "VeryEasy"
  settings[1] = "Easy"
  settings[2] = "Normal"
  settings[3] = "Hard"
  settings[4] = "VeryHard"
  settings[5] = "Legendary"

  int i = 0
  While(i < settings.Length)
    thresholds[i] = JMap.getInt(obj, settings[i], i * 10)
    i += 1
  EndWhile

  Update()
EndFunction
Function LoadDefaults()
  Debug.Trace("[LD] JContainers not loaded or invalid json format, using default values")
  int i = 0
  While(i < thresholds.Length)
    thresholds[i] = i * 10
    i += 1
  EndWhile
  Update()
EndFunction

Event OnStoryIncreaseLevel(int aiNewLevel)
  Debug.Trace("[LD] Player reached level = " + aiNewLevel)
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
    If(lv >= thresholds[i])
      Debug.Trace("[LD] Lv = " + lv + " / " + thresholds[i] + " => Setting Difficulty to " + i)
      Utility.SetINIInt("iDifficulty:GamePlay", i)
      return
    EndIf
  EndWhile
  Debug.Trace("[LD] Unable to find Level Range for Level " + lv)
EndFunction
