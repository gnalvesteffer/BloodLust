//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer

BloodLust_SettingsManager_Properties =
[
    ["BloodLust_MaxArterialBloodSprays", "number", "Limits the total number of arterial blood sprays that can be present at any given time. Decrease this value for improved performance."],
    ["BloodLust_MaxBloodSprays", "number", "Limits the total number of blood sprays that can be present at any given time. Decrease this value for improved performance."],
    ["BloodLust_MaxBloodSplatters", "number", "Limits the total number of blood splatters that can be present at any given time. Decrease this value for improved performance."],
    ["BloodLust_MaxBleedSplatters", "number", "Limits the total number of bleed splatters that can be present at any given time. Decrease this value for improved performance."],
    ["BloodLust_MaxGibs", "number", "Limits the total number of gibs (meat chunks and body parts) that can be present at any given time. Decrease this value for improved performance."],
    ["BloodLust_BloodSplatterIterationCaliberMultiplier", "number", "Determines how many blood splatters a projectile emits based on its caliber. Increase this value for more splatters."],
    ["BloodLust_BloodSplatterIterations", "number", "Maximum blood splatters a single projectile can emit when hitting a unit. Influenced by BloodSplatterIterationCaliberMultiplier."],
    ["BloodLust_VaporizedBloodSplatterIterations", "number", "Number of blood splatters spawned when a unit is vaporized. Increase this value for a more dramatic effect."],
    ["BloodLust_VaporizedBloodSplatterJitterAmount", "number", "Amount of jitter in vaporized blood splatter placement. Increase this value to make splatters appear more scattered."],
    ["BloodLust_VaporizationDamageThreshold", "number", "Minimum amount of damage required to vaporize a unit."],
    ["BloodLust_IsVaporizationEnabled", "bool", "Toggles the vaporization effect. Set to false if you don't want to see units exploding to bits."],
    ["BloodLust_IsVaporizationEnabledOnPlayer", "bool", "Toggles the vaporization effect on the player. Set to false to prevent the player from exploding to bits."],
    ["BloodLust_BloodSplatterGroundMaxDistance", "number", "Limits the distance that blood splatters can be spawned from a unit on to the ground."],
    ["BloodLust_BloodSplatterIntersectionMaxDistance", "number", "Limits the distance that blood splatters can be spawned from a unit on to a surface."],
    ["BloodLust_BloodSplatterJitterAmount", "number", "Scatters the position of blood splatters. Decrease this value for splatters to spawn closer to the path of the projectile."],
    ["BloodLust_BloodLustActivationDistance", "number", "Maximum distance that units are processed by BloodLust. Decrease this value for improved performance."],
    ["BloodLust_IsBleedingEnabled", "bool", "Toggles the bleeding effect. Set to false to disable bleeding, which may improve performance."],
    ["BloodLust_BleedDuration", "number", "Amount of time in seconds that the bleeding effect lasts from a single hit."],
    ["BloodLust_BleedFrequency", "number", "Maximum duration in seconds between each bleed splatter spawn during the bleeding effect. Decrease this value for more frequent bleeding."],
    ["BloodLust_BleedFrequencyVariance", "number", "Maximum variation added to the BleedFrequency. Increasing this value will cause bleeding to have a more varied delay between each splatter."],
    ["BloodLust_BleedSplatterJitterAmount", "number", "Scatters the bleed splatter positions. Decrease this value to make bleeding spawn closer to the position the unit was hit."],
    ["BloodLust_BloodSplatterAngleJitterAmount", "number", "Skews the bleed splatter rotation. Angle is in degrees."],
    ["BloodLust_BleedSoundAudibleVolume", "number", "Volume of bleed dripping sound. Increase this value if the bleeding sounds are too quiet."],
    ["BloodLust_BleedSoundAudibleDistance", "number", "Maximum distance the bleed dripping sounds can be heard."],
    ["BloodLust_IsBloodSprayEnabled", "bool", "Toggles the blood spray effect that causes animated splashes of blood to emit from exit wounds. Set to false to improve performance, or if the textures aren't loading efficiently on your system."],
    ["BloodLust_BloodSprayFramerate", "number", "Frames per second displayed for the blood spray animations. Adjust this value to slow-down or speed-up the animation."],
    ["BloodLust_IsGibbingEnabled", "bool", "Toggles the gibbing effect which causes meat chunks to emit from a hit. Setting this to false may increase performance."],
    ["BloodLust_GibIterations", "number", "Maximum amount of gibs/meat chunks which can emit from a single hit."],
    ["BloodLust_GibSpeed", "number", "Maximum speed a gib/meat chunk can emit from a hit."],
    ["BloodLust_GibProbability", "number", "Probability that a gib/meat chunk will emit from a hit. Value between 0-1."],
    ["BloodLust_GibbingProjectileSpeedThreshold", "number", "The minimum projectile speed in meters per second required to cause gibs to emit from a hit."],
    ["BloodLust_VaporizationGibIterations", "number", "The total gibs that will spawn upon the vaporization of a unit. Decrease this value for improved performance."],
    ["BloodLust_VaporizationAmmoClassnames", "parse", "The ammo class names which can cause gibbing. Ammo class names can be found under CfgAmmo."],
    ["BloodLust_BloodSplatterIntersectionBlackList", "parse", "Class names of objects that blood splatters can not be placed on."],
    ["BloodLust_BloodSprayProbability", "number", "The probability that blood sprays will emit from a hit. Value between 0-1."],
    ["BloodLust_BloodSprayIterations", "number", "Amount of blood sprays that will emit from a hit. Decrease this value for improved performance."],
    ["BloodLust_BloodSplatterProbability", "number", "Probability that a blood splatter will spawn from a hit. Value between 0-1."],
    ["BloodLust_GibBleedDuration", "number", "Duration in seconds which a gib can emit blood."],
    ["BloodLust_GibCaliberThreshold", "number", "Minimum ammo caliber required to cause gibs to emit."],
    ["BloodLust_IsCleanUpEnabled", "bool", "Toggles clean-up of blood. Improves performance."],
    ["BloodLust_CleanUpDistance", "number", "The distance, in meters, the player must move for clean-up to occur. Smaller distances will improve performance but may degrade immersion."],
    ["BloodLust_CleanUpDelay", "number", "Delay in seconds between each clean-up iteration."],
    ["BloodLust_IsUnitVehicleCollisionEffectsEnabled", "bool", "Toogles collision sounds when a unit is hit by a vehicle."],
    ["BloodLust_UnitVehicleVaporizationCollisionSpeed", "number", "The speed in meters per second which a vehicle must collide with a unit to cause them to vaporize."],
    ["BloodLust_UnitVehicleVaporizationProbability", "number", "The probability that a unit will be vaporized upon a high-speed impact with a vehicle."],
    ["BloodLust_ExplosionBloodSplatterIterationMultiplier", "number", "The amount of blood splatters emitted from an explosion, based on the severity of the explosion."],
    ["BloodLust_IsVaporizedHeatWaveEnabled", "bool", "Toggles the heat wave effect on vaporized objects."],
    ["BloodLust_BleedSmearSpacing", "number", "Meters that a unit must move from the previous blood smear in order for another smear to be created."],
    ["BloodLust_ArterialBloodSprayFramerate", "number", "Frames per second displayed for the arterial blood spray animations. Adjust this value to slow-down or speed-up the animation."],
    ["BloodLust_ArterialBloodSprayProbability", "number", "Probability that an arterial blood spray will spawn during a bleed iteration."],
    ["BloodLust_IsArterialBloodSprayEnabled", "bool", "Toggles the arterial blood spray effect during bleeding."],
    ["BloodLust_ArterialBloodSprayDuration", "number", "Duration which arterial blood sprays emit during bleeding (should be less than the bleeding duration)."],
    ["BloodLust_IsMultiplayerCoreEnabledInSingleplayer", "bool", "Toggles the multiplayer compatability core in singleplayer (mainly used for testing or development purposes)."],
    ["BloodLust_BloodSpraySoundAudibleVolume", "number", "Volume of blood spray sound. Increase this value if the blood spray sounds are too quiet."],
    ["BloodLust_BloodSpraySoundAudibleDistance", "number", "Maximum distance the blood spray sounds can be heard."],
    ["BloodLust_IsBloodSpraySoundEnabled", "bool", "Toggles the blood spray sound."],
    ["BloodLust_BleedSmearDuration", "number", "Duration in seconds which bleeding can cause smears."],
    ["BloodLust_IsBloodLustEnabled", "bool", "Toggles BloodLust."],
    ["BloodLust_IsVehicleCrewVaporizationEnabled", "bool", "Toggles the vaporization of a vehicle's crew when the vehicle explodes."],
    ["BloodLust_IsVaporizedGibCamSwitchEnabled", "bool", "Toggles the camera switch to a gib upon vaporization of the player."],
    ["BloodLust_IsFallingVaporizationEnabled", "bool", "Toggles vaporization of units when they're killed from falling."],
    ["BloodLust_FallingVaporizationSpeedThreshold", "number", "Velocity magnitude which a unit must be moving/falling in order to vaporize upon death."],
    ["BloodLust_FallingVaporizationGibSpeedScalar", "number", "A percentage of the unit's speed, affecting the speed of gibs which are created from the falling vaporization effect."],
    ["BloodLust_ExplosionDamageThreshold", "number", "Minimum damage required for an explosion to emit blood splatters."],
    ["BloodLust_UnitVehicleCollisionSounds", "parse", "TODO: Add description text."],
    ["BloodLust_VaporizationSounds", "parse", "TODO: Add description text."],
    ["BloodLust_BloodSpraySounds", "parse", "TODO: Add description text."],
    ["BloodLust_BloodSplatterSounds", "parse", "TODO: Add description text."],
    ["BloodLust_HitSounds", "parse", "TODO: Add description text."],
    ["BloodLust_HeadSplatterTextures", "parse", "TODO: Add description text."],
    ["BloodLust_Spine1SplatterTextures", "parse", "TODO: Add description text."],
    ["BloodLust_Spine2SplatterTextures", "parse", "TODO: Add description text."],
    ["BloodLust_Spine3SplatterTextures", "parse", "TODO: Add description text."],
    ["BloodLust_BodySplatterTextures", "parse", "TODO: Add description text."],
    ["BloodLust_ArmSplatterTextures", "parse", "TODO: Add description text."],
    ["BloodLust_LegSplatterTextures", "parse", "TODO: Add description text."],
    ["BloodLust_LargeVaporizationBloodSplatters", "parse", "TODO: Add description text."],
    ["BloodLust_VaporizationBloodSplatters", "parse", "TODO: Add description text."],
    ["BloodLust_SprayTextures", "parse", "TODO: Add description text."],
    ["BloodLust_BleedTextures", "parse", "TODO: Add description text."],
    ["BloodLust_SmearTextures", "parse", "TODO: Add description text."],
    ["BloodLust_BleedSounds", "parse", "TODO: Add description text."],
    ["BloodLust_HeadGibClassnames", "parse", "TODO: Add description text."],
    ["BloodLust_Spine1GibClassnames", "parse", "TODO: Add description text."],
    ["BloodLust_Spine2GibClassnames", "parse", "TODO: Add description text."],
    ["BloodLust_Spine3GibClassnames", "parse", "TODO: Add description text."],
    ["BloodLust_BodyGibClassnames", "parse", "TODO: Add description text."],
    ["BloodLust_ArmGibClassnames", "parse", "TODO: Add description text."],
    ["BloodLust_LegGibClassnames", "parse", "TODO: Add description text."],
    ["BloodLust_VaporizationGibClassnames", "parse", "TODO: Add description text."],
    ["BloodLust_IsBloodPoolingEnabled", "bool", "Toggles blood pooling on dead units."],
    ["BloodLust_BloodPoolFramerate", "number", "Frames per second for blood pool animations."],
    ["BloodLust_BloodPoolTextures", "parse", "Blood pool texture sets."],
    ["BloodLust_IsTexturePreloadingEnabled", "bool", "Toggles the preloading of textures. May reduce flickering of animated textures, but will result in a possible blood splatter anomaly at the start of the mission."],
    ["BloodLust_ExplosionGibForceMultiplier", "number", "Controls how much an explosive force affects vaporization gib speeds."],
    ["BloodLust_BloodSprayJitterAmount", "number", "The angle spread of blood sprays from gun shot wounds."],
    ["BloodLust_IsBloodSplashingEnabled", "bool", "Toggles blood droplets splashing out from blood sprays."],
    ["BloodLust_BloodSplashProjectileSpeedContribution", "number", "Scales how much the speed of the projectile affects blood splashing force."],
    ["BloodLust_BloodSplashDuration", "number", "The duration in seconds that a blood splash should be processed."],
    ["BloodLust_BloodSplashProbability", "number", "The probability that blood will splash from a blood spray."],
    ["BloodLust_BloodSplashDropletsPerIteration", "number", "The number of blood droplets to spawn per blood splash iteration."],
    ["BloodLust_BloodSplashDropletInterval", "number", "The minimum delay in seconds before the next group of blood droplets can spawn."],
    ["BloodLust_BloodSplashJitterAmount", "number", "The amount of positional jitter of blood droplets."],
    ["BloodLust_BloodSplashMinimumDistanceBetweenDroplets", "number", "Distance in meters that a blood droplet has to be from the previous droplet in order to spawn."],
    ["BloodLust_BloodSplashDropletTextureSpeedThreshold", "number", "The speed that a blood splash must be for a blood droplet texture to be used. Smear textures will be used instead when a splash is slower than this."],
    ["BloodLust_IsBloodLustEnabledForDeadUnits", "bool", "Toggles if dead units should have BloodLust effects applied to them."]
];

BloodLust_SettingsManager_OnLoad =
{
    setAccTime 0;
    (findDisplay 49) closeDisplay 1;
    ctrlSetText [1001, format ["BloodLust v%1 Settings | Press Escape to exit.", getNumber (configFile >> "CfgPatches" >> "BloodSplatter" >> "version")]];
    ((findDisplay 76542) displayCtrl 1650) ctrlSetStructuredText parseText "<a href='http://www.bitdungeon.org/arma/bloodlust/credits.html'>Credits</a>";
    _properties = [BloodLust_SettingsManager_Properties, [], {_x select 0}, "ASCEND"] call BIS_fnc_sortBy;
    {
        lbAdd [1500, _x select 0];
    } foreach _properties;
    lbSetCurSel [1500, 0];
};

BloodLust_SettingsManager_OnUnload =
{
    setAccTime 1;
};

BloodLust_SettingsManager_GetCurrentPropertyKey =
{
    lbText [1500, lbCurSel 1500];
};

BloodLust_SettingsManager_GetCurrentValue =
{
    _GetPropertyType =
    {
        _queryPropertyKey = _this;
        _return = "";
        {
            if((_x select 0) == _queryPropertyKey) exitWith
            {
                _return = (_x select 1);
            };
        } foreach BloodLust_SettingsManager_Properties;
        _return;
    };

    _propertyKey = call BloodLust_SettingsManager_GetCurrentPropertyKey;
    _propertyType = _propertyKey call _GetPropertyType;
    _return = ctrlText 1400;

    switch(_propertyType) do
    {
        case "number":
        {
            _return = parseNumber _return;
        };
        case "bool":
        {
            if((_return select [0, 1]) == "t") then
            {
                _return = true;
            }
            else
            {
                _return = false;
            }
        };
        case "parse":
        {
            _return = call compile _return;
        };
    };
    _return;
};

BloodLust_SettingsManager_GetPropertyValue =
{
    _propertyKey = _this;
    _propertyValue = profileNamespace getVariable _propertyKey;
    if(isNil "_propertyValue") then
    {
        _propertyValue = call compile format["%1", _propertyKey];
    };
    _propertyValue;
};

BloodLust_SettingsManager_GetPropertyDescription =
{
    _propertyKey = _this;
    _return = "";
    {
        if((_x select 0) == _propertyKey) exitWith
        {
            _return = (_x select 2);
        };
    } foreach BloodLust_SettingsManager_Properties;
    _return;
};

BloodLust_SettingsManager_SaveValue =
{
    _currentPropertyKey = call BloodLust_SettingsManager_GetCurrentPropertyKey;
    if(_currentPropertyKey == "") exitWith {};
    _value = call BloodLust_SettingsManager_GetCurrentValue;
    profileNamespace setVariable [_currentPropertyKey, _value];
    saveProfileNamespace;
    call compile format["%1 = %2", _currentPropertyKey, _value];
    player globalChat format ["%1 := %2", _currentPropertyKey, _value];
};

BloodLust_SettingsManager_ResetValues =
{
    {
        profileNamespace setVariable [_x select 0, nil];
    } foreach BloodLust_SettingsManager_Properties;
    saveProfileNamespace;
    call compile preprocessFileLineNumbers "BloodSplatter\Scripts\Configurables.sqf";
    call BloodLust_SettingsManager_PropertySelectionChanged;
    player globalChat "BloodLust settings reset.";
};

BloodLust_SettingsManager_ExportSettings =
{
    _settings = [];
    {
        _settingKey = _x select 0;
        _settingValue = _settingKey call BloodLust_SettingsManager_GetPropertyValue;
        _settings pushBack [_settingKey, _settingValue];
    } foreach BloodLust_SettingsManager_Properties;
    _output = str _settings;
    copyToClipboard _output;
    player globalChat "BloodLust settings copied to clipboard.";
    _output;
};

BloodLust_SettingsManager_ImportSettings =
{
    _settings = call compile copyFromClipboard;
    {
        _key = _x select 0;
        _value = _x select 1;
        call compile format["%1 = %2", _key, _value];
        profileNamespace setVariable [_key, _value];
    } foreach _settings;
    saveProfileNamespace;
    player globalChat "BloodLust settings imported.";
};

BloodLust_SettingsManager_PropertySelectionChanged =
{
    _propertyKey = call BloodLust_SettingsManager_GetCurrentPropertyKey;
    _propertyValue = _propertyKey call BloodLust_SettingsManager_GetPropertyValue;
    _propertyDescription = _propertyKey call BloodLust_SettingsManager_GetPropertyDescription;
    ctrlSetText [1400, str _propertyValue];
    ctrlSetText [1100, _propertyDescription];
    player globalChat format ["%1: %2", _propertyKey, _propertyDescription];
};
