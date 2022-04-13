//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer

BloodLust_IsInitialized = false;

// Core.
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Configuration.sqf";
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\CBASettings.sqf";
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Helpers.sqf";
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\EventHooks.sqf";
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Core\Init.sqf";

// Multiplayer.
if(isMultiplayer || BloodLust_IsMultiplayerCoreEnabledInSingleplayer) then
{
    call compile preprocessFileLineNumbers "BloodSplatter\Scripts\MultiplayerCompatibility.sqf";
};

// Effects.
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Effects\GoreMist.sqf";
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Effects\Refraction.sqf";

// Cleanup.
call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Cleanup.sqf";

// Indicate that BloodLust is ready for other mods/missions/etc to handle any special BloodLust handling.
BloodLust_IsInitialized = true;
