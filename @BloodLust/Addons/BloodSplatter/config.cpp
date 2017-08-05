//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer

class CfgPatches
{
  class BloodSplatter
  {
    units[] = {};
      weapons[] = {};
        requiredAddons[] = { "CBA_xeh", "A3_UI_F", "A3_Data_F" };
        requiredVersion = 1.0;
        projectName = "BloodLust";
        author = "Gavin N. Alvesteffer";
        url = "http://steamcommunity.com/sharedfiles/filedetails/?id=667953829";
        version = 2.49;
      };
    };

    class Extended_PreInit_EventHandlers
    {
      class BloodSplatter_PreInit
      {
        init = "call compile preprocessFileLineNumbers '\BloodSplatter\Scripts\Init.sqf';";
      };
    };

    class Extended_InitPost_EventHandlers
    {
      class CAManBase
      {
        class BloodSplatter_Init
        {
          init = "[_this select 0] call BloodLust_InitUnit;";
        };
      };

      class AllVehicles
      {
        class BloodSplatter_Init
        {
          init = "[_this select 0] call BloodLust_InitVehicle;";
        };
      };
    };

    class Extended_Respawn_EventHandlers
    {
      class CAManBase
      {
        class BloodSplatter_Respawn
        {
          respawn = "_this call BloodLust_OnUnitRespawn;";
        };
      };
    };

    class CfgCoreData
    {
    	slopBlood="BloodSplatter\Models\Plane\BloodSplatter_Plane.p3d";
    	footStepBleeding0="BloodSplatter\Models\Plane\BloodSplatter_Plane.p3d";
    	footStepBleeding1="BloodSplatter\Models\Plane\BloodSplatter_Plane.p3d";
    };

    class CfgVehicles
    {
      class All;
      class AllVehicles : All {};
        class Land : AllVehicles {};
          class Static : All {};
            class Building : Static {};
              class NonStrategic : Building {};
                class Thing : All {};
                  class ThingX : Thing {};

                    class Man : Land
                    {
                      impactEffectsNoBlood = "ImpactEffectsBlood";
                    };

                    class BloodSplatter_Plane : NonStrategic
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Plane\BloodSplatter_Plane.p3d";
                      displayName = "Blood Splatter";
                      faction = "Default";
                      vehicleClass = "Misc";
                      hiddenSelections[] = { "BloodSplatter_Plane" };
                    };

                    class BloodSplatter_TinyPlane : NonStrategic
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\TinyPlane\BloodSplatter_TinyPlane.p3d";
                      displayName = "Blood Splatter";
                      faction = "Default";
                      vehicleClass = "Misc";
                      hiddenSelections[] = { "BloodSplatter_Plane" };
                    };

                    class BloodSplatter_SmallPlane : NonStrategic
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\SmallPlane\BloodSplatter_SmallPlane.p3d";
                      displayName = "Blood Splatter";
                      faction = "Default";
                      vehicleClass = "Misc";
                      hiddenSelections[] = { "BloodSplatter_Plane" };
                    };

                    class BloodSplatter_MediumPlane : NonStrategic
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\MediumPlane\BloodSplatter_MediumPlane.p3d";
                      displayName = "Blood Splatter";
                      faction = "Default";
                      vehicleClass = "Misc";
                      hiddenSelections[] = { "BloodSplatter_Plane" };
                    };

                    class BloodSplatter_LargePlane : NonStrategic
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\LargePlane\BloodSplatter_LargePlane.p3d";
                      displayName = "Blood Splatter";
                      faction = "Default";
                      vehicleClass = "Misc";
                      hiddenSelections[] = { "BloodSplatter_Plane" };
                    };

                    class BloodSplatter_SprayPlane : NonStrategic
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\SprayPlane\BloodSplatter_SprayPlane.p3d";
                      displayName = "Blood Spray";
                      faction = "Default";
                      vehicleClass = "Misc";
                      hiddenSelections[] = { "BloodSplatter_SprayPlane" };
                    };

                    class BloodSplatter_SmallSprayPlane : NonStrategic
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\SmallSprayPlane\BloodSplatter_SmallSprayPlane.p3d";
                      displayName = "Blood Spray";
                      faction = "Default";
                      vehicleClass = "Misc";
                      hiddenSelections[] = { "BloodSplatter_SprayPlane" };
                    };

                    class BloodSplatter_LeftHand : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_LeftHand.p3d";
                      weight = 5;
                    };

                    class BloodSplatter_LeftLowerArm : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_LeftLowerArm.p3d";
                      weight = 20;
                    };

                    class BloodSplatter_LeftLowerLegAndFoot : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_LeftLowerLegAndFoot.p3d";
                      weight = 40;
                    };

                    class BloodSplatter_LeftUpperArm : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_LeftUpperArm.p3d";
                      weight = 15;
                    };

                    class BloodSplatter_LeftUpperLeg : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_LeftUpperLeg.p3d";
                      weight = 35;
                    };

                    class BloodSplatter_Pelvis : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_Pelvis.p3d";
                      weight = 20;
                    };

                    class BloodSplatter_RightFoot : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_RightFoot.p3d";
                      weight = 15;
                    };

                    class BloodSplatter_RightHand : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_RightHand.p3d";
                      weight = 10;
                    };

                    class BloodSplatter_RightIndexFinger : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_RightIndexFinger.p3d";
                      weight = 3;
                    };

                    class BloodSplatter_RightMiddleFinger : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_RightMiddleFinger.p3d";
                      weight = 3;
                    };

                    class BloodSplatter_RightPinkyFinger : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_RightPinkyFinger.p3d";
                      weight = 3;
                    };

                    class BloodSplatter_RightRingFinger : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_RightRingFinger.p3d";
                      weight = 3;
                    };

                    class BloodSplatter_RightThumb : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_RightThumb.p3d";
                      weight = 3;
                    };

                    class BloodSplatter_RightUpperArm : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_RightUpperArm.p3d";
                      weight = 15;
                    };

                    class BloodSplatter_RightLowerArm : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_RightLowerArm.p3d";
                      weight = 15;
                    };

                    class BloodSplatter_RightUpperLeg : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_RightUpperLeg.p3d";
                      weight = 30;
                    };

                    class BloodSplatter_RightLowerLeg : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_RightLowerLeg.p3d";
                      weight = 30;
                    };

                    class BloodSplatter_Torso : Thing
                    {
                      scope = 1;
                      author = "Gavin N. Alvesteffer";
                      destrType = "DestructNo";
                      model = "\BloodSplatter\Models\Gibs\BloodSplatter_Torso.p3d";
                      weight = 50;
                    };
                  };

                  class RscXSliderH;
                  class RscTitle;
                  class RscControlsGroup;
                  class RscButtonMenuCancel;
                  class RscButtonMenuOK;
                  class RscButtonMenu;
                  class RscTextCheckBox;
                  class RscCheckBox;
                  class IGUIBack;
                  class RscSlider;
                  class RscFrame;
                  class RscShortcutButtonMain;
                  class RscShortcutButton;
                  class RscButton;
                  class RscListBox;
                  class RscCombo;
                  class RscEdit;
                  class RscPicture;
                  class RscStructuredText;
                  class RscText;
                  class RscHTML;
                  class VScrollbar;
                  class HScrollbar;
                  #include "Dialogs\BloodLust_SettingsManager.h"
                  #include "Dialogs\BloodLust_InterruptMenu.h"
