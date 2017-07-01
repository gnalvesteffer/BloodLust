//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer

BloodLust_IsInitialized = false;

//Core.
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Configurables.sqf";
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Helpers.sqf";
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\EventHooks.sqf";
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Core.sqf";
if(isMultiplayer || BloodLust_IsMultiplayerCoreEnabledInSingleplayer) then
{
    call compile preprocessFileLineNumbers "BloodSplatter\Scripts\CoreMultiplayer.sqf";
    call compile preprocessFileLineNumbers "BloodSplatter\Scripts\ConfigurablesMultiplayer.sqf"; //Server can override client settings in this script.
};

//Effects.
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Effects\GoreMist.sqf";
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Effects\Refraction.sqf";

//Dialogs.
call compile preprocessFileLineNumbers "BloodSplatter\Dialogs\BloodLust_SettingsManager.sqf";

//Preload textures.
if(BloodLust_IsTexturePreloadingEnabled) then
{
    execVM "BloodSplatter\Scripts\Preload.sqf";
};

//BloodLust Clean-up.
execVM "BloodSplatter\Scripts\Cleanup.sqf";

//A flag that BloodLust is ready for others to add their event handlers and stuff.
BloodLust_IsInitialized = true;
