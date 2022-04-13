//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer

BloodLust_IsInitialized = false;

//Core.
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Configuration.sqf";
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\CBASettings.sqf";
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Helpers.sqf";
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\EventHooks.sqf";
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Core\Init.sqf";
if(isMultiplayer || BloodLust_IsMultiplayerCoreEnabledInSingleplayer) then
{
    call compile preprocessFileLineNumbers "BloodSplatter\Scripts\CoreMultiplayer.sqf";
    call compile preprocessFileLineNumbers "BloodSplatter\Scripts\ConfigurablesMultiplayer.sqf"; //Server can override client settings in this script.
};

//Effects.
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Effects\GoreMist.sqf";
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Effects\Refraction.sqf";

// Cleanup.
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Cleanup.sqf";

//A flag that BloodLust is ready for others to add their event handlers and stuff.
BloodLust_IsInitialized = true;
