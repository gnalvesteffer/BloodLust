// CBA Settings System Documentation: https://github.com/CBATeam/CBA_A3/wiki/CBA-Settings-System

_categoryBloodSpraying = "Blood Spraying";
_categoryBloodSplatter = "Blood Splatter";
_categoryBleeding = "Bleeding";
_categoryBloodSmearing = "Blood Smearing";
_categoryBloodPooling = "Blood Pooling";
_categoryBloodTrails = "Blood Trails";
_categoryObliteration = "Obliteration";
_categoryPerformance = "Performance";
_categoryVehicleCollision = "Vehicles";
_categoryDevelopment = "Development";

_authorityAny = 0;
_authorityServer = 1;

BloodLust_CBASettings =
[
    ["BloodLust_IsSplatteringEnabledForUnitsInVehicles", _categoryBloodSplatter, "Enable Blood Splattering For Vehicle Crew", "CHECKBOX", false, {}, _authorityAny, "Toggles if blood splattering and bleeding is enabled for units in vehicles."],
    ["BloodLust_IsUnderCharacterBloodSplatterEnabled", _categoryBloodSplatter, "Spawn Large Splatter Under Character", "CHECKBOX", true, {}, _authorityAny, "Toggles larger blood splatters that spawn under characters when hit, making hits messier."],
    ["BloodLust_BloodSplatterAngleJitterAmount", _categoryBloodSplatter, "Blood Splatter Angle Jitter", "SLIDER", [0, 360, 360, 0, false], { }, _authorityAny, "Skews the bleed splatter rotation. Angle is in degrees."],
    ["BloodLust_MaxBloodSplatters", _categoryBloodSplatter, "Blood Splatter Limit", "SLIDER", [100, 10000, 500, 0, false], { }, _authorityAny, "Limits the total number of blood splatters that can be present at any given time. Decrease this value for improved performance."],
    ["BloodLust_BloodSplatterJitterAmount", _categoryBloodSplatter, "Blood Splatter Placement Jitter", "SLIDER", [0, 25, 0, 2, false], { }, _authorityAny, "Scatters the position of blood splatters. Decrease this value for splatters to spawn closer to the path of the projectile."],
    ["BloodLust_BloodSplatterProbability", _categoryBloodSplatter, "Blood Splatter Probability", "SLIDER", [0, 1, 1, 2, true], { }, _authorityAny, "Probability that a blood splatter will spawn from a hit. Value between 0-1."],
    ["BloodLust_ExplosionDamageThreshold", _categoryBloodSplatter, "Explosive Damage Threshold", "SLIDER", [0, 10, 0.2, 2, false], { }, _authorityAny, "Minimum damage required for an explosion to emit blood splatters."],
    ["BloodLust_BloodSplatterIterations", _categoryBloodSplatter, "Max Blood Splatters Per Hit", "SLIDER", [1, 25, 1, 0, false], { }, _authorityAny, "Maximum blood splatters a single projectile can emit when hitting a unit. Influenced by BloodSplatterIterationCaliberMultiplier."],
    ["BloodLust_ExplosionBloodSplatterIterationMultiplier", _categoryBloodSplatter, "Max Blood Splatters To Spawn From Explosions", "SLIDER", [0, 200, 30, 0, false], { }, _authorityAny, "The amount of blood splatters emitted from an explosion, based on the severity of the explosion."],
    ["BloodLust_BloodSplatterGroundMaxDistance", _categoryBloodSplatter, "Max Spawn Distance (Ground)", "SLIDER", [0, 25, 1.5, 2, false], { }, _authorityAny, "Limits the distance that blood splatters can be spawned from a unit on to the ground (in meters)."],
    ["BloodLust_BloodSplatterIntersectionMaxDistance", _categoryBloodSplatter, "Max Spawn Distance (Surface)", "SLIDER", [0, 25, 4, 2, false], { }, _authorityAny, "Limits the distance that blood splatters can be spawned from a unit on to a surface."],
    ["BloodLust_BloodSplatterIterationCaliberMultiplier", _categoryBloodSplatter, "Projectile Caliber Factor", "SLIDER", [0.00, 10.00, 0.30, 2, false], { }, _authorityAny, "Determines how many blood splatters a projectile emits based on its caliber. Tweak this value along with the 'Max Blood Splatters Per Hit' setting. The higher the caliber, the closer to the number of 'Max Blood Splatters Per Hit' are spawned."],
    ["BloodLust_BloodSplatterIntersectionBlackList", _categoryBloodSplatter, "Surface Intersection Classnames To Avoid", "EDITBOX", "['#particlesource', 'dummyweapon.p3d', 'BloodSplatter_Plane', 'BloodSplatter_SprayPlane', 'WeaponHolderSimulated', 'WeaponHolder', 'Thing', 'Man', 'AllVehicles', 'Default']", { params ["_value"]; BloodLust_BloodSplatterIntersectionBlackList = parseSimpleArray _value; }, _authorityAny, "Class names of objects that blood splatters can not be placed on."],
    ["BloodLust_IsBleedingEnabled", _categoryBleeding, "Enable Bleeding", "CHECKBOX", true, {}, _authorityAny, "Toggles the bleeding effect. Set to false to disable bleeding, which may improve performance."],
    ["BloodLust_IsBleedingTiedToUnitState", _categoryBleeding, "Use Unit's Bleeding State", "CHECKBOX", false, {}, _authorityAny, "Toggles if the bleeding effect is tied to the unit's bleeding state instead of adhering to a fixed duration."],
    ["BloodLust_MaxBleedSplatters", _categoryBleeding, "Bleed Droplet Limit", "SLIDER", [100, 10000, 500, 0, false], { }, _authorityAny, "Limits the total number of bleed splatters that can be present at any given time. Decrease this value for improved performance."],
    ["BloodLust_BleedDuration", _categoryBleeding, "Bleed Duration", "SLIDER", [0, 60 * 60, 20, 2, false], { }, _authorityAny, "Amount of time in seconds that the bleeding effect lasts from a single hit."],
    ["BloodLust_BleedFrequencySlowdownAmount", _categoryBleeding, "Bleed Interval Slowdown", "SLIDER", [0, 30, 0.25, 4, false], { }, _authorityAny, "Increases the interval between bleed splatters during bleeding as bleeding progresses. The longer bleeding progresses, the more this slowdown is reached per bleed iteration. Value is in seconds."],
    ["BloodLust_BleedFrequencyVariance", _categoryBleeding, "Bleed Interval Variance", "SLIDER", [0, 30, 0.033, 4, false], { }, _authorityAny, "Maximum variation added to the BleedFrequency. Increasing this value will cause bleeding to have a more varied delay between each splatter."],
    ["BloodLust_BleedFrequency", _categoryBleeding, "Bleed Interval", "SLIDER", [0, 30, 0.016, 4, false], { }, _authorityAny, "Maximum duration in seconds between each bleed splatter spawn during the bleeding effect. Decrease this value for more frequent bleeding."],
    ["BloodLust_BleedSplatterJitterAmount", _categoryBleeding, "Droplet Placement Jitter", "SLIDER", [0, 25, 0.15, 2, false], { }, _authorityAny, "Scatters the bleed splatter positions. Decrease this value to make bleeding spawn closer to the position the unit was hit."],
    ["BloodLust_BleedSoundAudibleDistance", _categoryBleeding, "Droplet Sound Distance", "SLIDER", [0, 100, 10, 2, false], { }, _authorityAny, "Maximum distance the bleed dripping sounds can be heard."],
    ["BloodLust_BleedSoundAudibleVolume", _categoryBleeding, "Droplet Sound Volume", "SLIDER", [0, 100, 4, 2, false], { }, _authorityAny, "Volume of bleed dripping sound. Increase this value if the bleeding sounds are too quiet."],
    ["BloodLust_BleedSmearDuration", _categoryBloodSmearing, "Blood Smear Duration", "SLIDER", [0, 60 * 60, 10, 2, false], { }, _authorityAny, "Duration in seconds which bleeding can cause smears."],
    ["BloodLust_BleedSmearFrequencySlowdownAmount", _categoryBloodSmearing, "Blood Smear Interval Slowdown", "SLIDER", [0, 30, 0.5, 4, false], { }, _authorityAny, "Increasing interval between blood smears during bleeding as bleeding progresses. The longer bleeding progresses, the more this slowdown is reached per bleed iteration. Value is in seconds."],
    ["BloodLust_BleedSmearSpacing", _categoryBloodSmearing, "Blood Smear Spacing", "SLIDER", [0, 1, 0.01, 2, false], { }, _authorityAny, "Meters that a unit must move from the previous blood smear in order for another smear to be created."],
    ["BloodLust_IsBloodPoolingEnabled", _categoryBloodPooling, "Enable Blood Pooling", "CHECKBOX", false, {}, _authorityAny, "Toggles blood pooling on dead units."],
    ["BloodLust_BloodPoolFramerate", _categoryBloodPooling, "Blood Pool Framerate", "SLIDER", [1, 500, 15, 0, false], { }, _authorityAny, "Frames per second for blood pool animations."],
    ["BloodLust_IsBloodTrailEnabled", _categoryBloodTrails, "Enable Blood Trails", "CHECKBOX", true, {}, _authorityAny, "Toggles if blood trails are enabled."],
    ["BloodLust_BloodTrailCancelDistance", _categoryBloodTrails, "Blood Trail Cancel Distance", "SLIDER", [0, 100, 2, 0, false], { }, _authorityAny, "Performance: maximum meters between trails that when met, will cancel further trails from being processed for the affected blood trail. This is to prevent really long trails from being processed which can lag the game."],
    ["BloodLust_BloodTrailDuration", _categoryBloodTrails, "Blood Trail Duration", "SLIDER", [0, 60 * 60, 3, 2, false], { }, _authorityAny, "Duration in seconds that a blood trail is allowed to form."],
    ["BloodLust_BloodTrailProbability", _categoryBloodTrails, "Blood Trail Probability", "SLIDER", [0, 1, 0.75, 2, true], { }, _authorityAny, "Probability of a blood trail occurring."],
    ["BloodLust_BloodTrailSpacing", _categoryBloodTrails, "Blood Trail Spacing", "SLIDER", [0, 1, 0.075, 2, false], { }, _authorityAny, "Distance in meters between trails."],
    ["BloodLust_BloodTrailTriggeringSelections", _categoryBloodTrails, "Triggering Body Parts", "EDITBOX", "['head']", { params ["_value"]; BloodLust_BloodTrailTriggeringSelections = parseSimpleArray _value; }, _authorityAny, "Unit selections/body parts that will trigger a blood trail to form when hit."],
    ["BloodLust_IsVaporizationEnabled", _categoryObliteration, "Enable Obliteration", "CHECKBOX", true, {}, _authorityServer, "Toggles the obliteration effect. Set to false if you don't want to see units exploding to bits."],
    ["BloodLust_IsVaporizationEnabledOnPlayer", _categoryObliteration, "Enable Obliteration For Player", "CHECKBOX", true, {}, _authorityServer, "Toggles the obliteration effect on the player. Set to false to prevent the player from exploding to bits."],
    ["BloodLust_IsFallingVaporizationEnabled", _categoryObliteration, "Enable Falling Obliteration", "CHECKBOX", true, {}, _authorityServer, "Toggles obliteration of units when they're killed from falling."],
    ["BloodLust_IsVehicleCrewVaporizationEnabled", _categoryObliteration, "Enable Vehicle Crew Obliteration", "CHECKBOX", true, {}, _authorityServer, "Toggles the obliteration of a vehicle's crew when their vehicle explodes."],
    ["BloodLust_IsVaporizedGibCamSwitchEnabled", _categoryObliteration, "Switch Camera To Gib On Player Obliteration", "CHECKBOX", false, {}, _authorityAny, "Toggles the camera switch to a gib upon obliteration of the player."],
    ["BloodLust_IsVaporizedHeatWaveEnabled", _categoryObliteration, "Enable Obliteration Heat Wave", "CHECKBOX", true, {}, _authorityAny, "Toggles the heat wave effect on obliterated objects."],
    ["BloodLust_VaporizedBloodSplatterJitterAmount", _categoryObliteration, "Blood Splatter Placement Jitter", "SLIDER", [0, 100, 10, 2, false], { }, _authorityAny, "Amount of jitter in obliterated blood splatter placement. Increase this value to make splatters appear more scattered."],
    ["BloodLust_FallingVaporizationGibSpeedScalar", _categoryObliteration, "Falling Obliteration Gib Speed Factor", "SLIDER", [0, 10, 0.2, 2, false], { }, _authorityAny, "A percentage of the unit's speed, affecting the speed of gibs which are created from the falling obliteration effect."],
    ["BloodLust_FallingVaporizationSpeedThreshold", _categoryObliteration, "Falling Obliteration Speed Threshold", "SLIDER", [0, 1000, 20, 2, false], { }, _authorityServer, "The speed a unit must be moving/falling in order to obliterate upon death."],
    ["BloodLust_GibBleedDuration", _categoryObliteration, "Gib Bleed Duration", "SLIDER", [0, 60, 3, 2, false], { }, _authorityAny, "Duration in seconds which a gib can emit blood."],
    ["BloodLust_MaxGibs", _categoryObliteration, "Gib Limit", "SLIDER", [0, 1000, 30, 0, false], { }, _authorityAny, "Limits the total number of gibs (meat chunks and body parts) that can be present at any given time. Decrease this value for improved performance. Set to 0 to disable gibs/body parts on obliteration."],
    ["BloodLust_ExplosionGibForceMultiplier", _categoryObliteration, "Gib-Speed Explosive Force Factor", "SLIDER", [0, 10, 0.3, 2, false], { }, _authorityAny, "Controls how much an explosive force affects obliteration gib speeds."],
    ["BloodLust_VaporizationDamageThreshold", _categoryObliteration, "Required Damage Threshold", "SLIDER", [0, 100, 1, 2, false], { }, _authorityServer, "Minimum amount of damage required to obliterate a unit."],
    ["BloodLust_VaporizedBloodSplatterIterations", _categoryObliteration, "Total Blood Splatters To Spawn On Obliteration", "SLIDER", [0, 100, 10, 0, false], { }, _authorityAny, "Number of blood splatters spawned when a unit is obliterated. Increase this value for a more dramatic effect."],
    ["BloodLust_VaporizationAmmoClassnames", _categoryObliteration, "Obliteration-Triggering Ammo Classnames", "EDITBOX", "['MissileCore', 'RocketCore', 'TimeBombCore', 'GrenadeCore', 'ShellCore', 'BombCore']", { params ["_value"]; BloodLust_VaporizationAmmoClassnames = parseSimpleArray _value; }, _authorityServer, "The ammo class names which can cause obliteration. Ammo class names can be found under CfgAmmo."],
    ["BloodLust_IsBloodSprayEnabled", _categoryBloodSpraying, "Enable Blood Spraying", "CHECKBOX", true, {}, _authorityAny, "Toggles the blood spray effect that causes animated splashes of blood to emit from exit wounds. Set to false to improve performance, or if the textures aren't loading efficiently on your system."],
    ["BloodLust_IsArterialBloodSprayEnabled", _categoryBloodSpraying, "Enable Arterial Blood Spraying", "CHECKBOX", true, {}, _authorityAny, "Toggles the arterial blood spray effect during bleeding."],
    ["BloodLust_BloodSprayFramerate", _categoryBloodSpraying, "Blood Spray Framerate", "SLIDER", [1, 500, 90, 0, false], { }, _authorityAny, "Frames per second displayed for the blood spray animations that occur when a unit is hit. Adjust this value to slow-down or speed-up the animation."],
    ["BloodLust_BloodSprayJitterAmount", _categoryBloodSpraying, "Blood Spray Jitter", "SLIDER", [0, 1, 0.25, 2, true], { }, _authorityAny, "The angle spread of blood sprays from gun shot wounds."],
    ["BloodLust_MaxBloodSprays", _categoryBloodSpraying, "Blood Spray Limit", "SLIDER", [0, 500, 20, 0, false], { }, _authorityAny, "Limits the total number of blood sprays that can be present at any given time. Decrease this value for improved performance."],
    ["BloodLust_BloodSprayProbability", _categoryBloodSpraying, "Blood Spray Probability", "SLIDER", [0, 1, 0.5, 0.2, true], { }, _authorityAny, "The probability that blood sprays will emit from a hit. Value between 0-1."],
    ["BloodLust_BloodSpraySoundAudibleDistance", _categoryBloodSpraying, "Blood Spray Sound Distance", "SLIDER", [0, 100, 7, 2, false], { }, _authorityAny, "Maximum distance the blood spray sounds can be heard."],
    ["BloodLust_BloodSpraySoundAudibleVolume", _categoryBloodSpraying, "Blood Spray Sound Volume", "SLIDER", [0, 100, 1.5, 2, false], { }, _authorityAny, "Volume of blood spray sound. Increase this value if the blood spray sounds are too quiet."],
    ["BloodLust_BloodSprayIterations", _categoryBloodSpraying, "Blood Sprays To Spawn On Hit", "SLIDER", [1, 50, 1, 0, false], { }, _authorityAny, "Amount of blood sprays that will emit from a hit. Decrease this value for improved performance."],
    ["BloodLust_ArterialBloodSprayDuration", _categoryBloodSpraying, "Arterial Blood Spray Duration", "SLIDER", [0, 60 * 60, 5, 2, false], { }, _authorityAny, "Duration which arterial blood sprays emit during bleeding (should be less than the bleeding duration)."],
    ["BloodLust_ArterialBloodSprayFramerate", _categoryBloodSpraying, "Arterial Blood Spray Framerate", "SLIDER", [1, 500, 80, 0, false], { }, _authorityAny, "Frames per second displayed for the arterial blood spray animations. Adjust this value to slow-down or speed-up the animation."],
    ["BloodLust_MaxArterialBloodSprays", _categoryBloodSpraying, "Arterial Blood Spray Limit", "SLIDER", [0, 500, 20, 0, false], {}, _authorityAny, "Limits the total number of arterial blood sprays(blood sprays that occur during bleeding) that can be present at any given time.Decrease this value for improved performance."],
    ["BloodLust_ArterialBloodSprayProbability", _categoryBloodSpraying, "Arterial Blood Spray Probability", "SLIDER", [0, 1, 0.75, 2, true], { }, _authorityAny, "Probability that an arterial blood spray will spawn during a bleed iteration."],
    ["BloodLust_IsUnitVehicleCollisionEffectsEnabled", _categoryVehicleCollision, "Enable Unit-Vehicle Collision Effects", "CHECKBOX", true, {}, _authorityServer, "Toogles collision sounds when a unit is hit by a vehicle."],
    ["BloodLust_UnitVehicleVaporizationProbability", _categoryVehicleCollision, "Unit-Vehicle Collision Obliteration Probability", "SLIDER", [0, 1, 0.25, 2, true], { }, _authorityServer, "The probability that a unit will be vaporized upon a high-speed impact with a vehicle."],
    ["BloodLust_UnitVehicleVaporizationCollisionSpeed", _categoryVehicleCollision, "Unit-Vehicle Collision Obliteration-Triggering Speed", "SLIDER", [0, 1000, 30, 2, false], { }, _authorityServer, "The speed in meters per second which a vehicle must collide with a unit to cause them to vaporize."],
    ["BloodLust_IsCleanUpEnabled", _categoryPerformance, "Enable Cleanup", "CHECKBOX", true, {}, _authorityAny, "Toggles clean-up of blood. Improves performance."],
    ["BloodLust_IsBloodLustEnabledForDeadUnits", _categoryPerformance, "Process Dead Units", "CHECKBOX", true, {}, _authorityAny, "Toggles if dead units should have BloodLust effects applied to them. Disable this to help improve performance by avoiding further effect creation for dead units."],
    ["BloodLust_CleanUpDelay", _categoryPerformance, "Cleanup Interval", "SLIDER", [0, 60 * 60, 30, 2, false], { }, _authorityAny, "Delay in seconds between each clean-up iteration."],
    ["BloodLust_CleanUpDistance", _categoryPerformance, "Cleanup-Trigger Distance", "SLIDER", [10, 10000, 100, 0, false], { }, _authorityAny, "The distance in meters that the player must move for clean-up to occur. Smaller distances will improve performance but may degrade immersion."],
    ["BloodLust_BloodLustActivationDistance", _categoryPerformance, "Processing Distance", "SLIDER", [10, 100000, 300, 0, false], { }, _authorityAny, "Maximum distance (meters) that units are processed by BloodLust. Decrease this value for improved performance."],
    ["BloodLust_IsBloodLustEnabled", _categoryDevelopment, "Enable BloodLust", "CHECKBOX", true, {}, _authorityAny, "Toggles BloodLust."],
    ["BloodLust_IsMultiplayerCoreEnabledInSingleplayer", _categoryDevelopment, "Enable MP Compatibility Patches In SP", "CHECKBOX", false, {}, _authorityAny, "Toggles the multiplayer compatability patches in singleplayer."]
];

{
    _variableName = _x select 0;
    _category = _x select 1;
    _title = _x select 2;
    _settingType = _x select 3;
    _settingInfo = _x select 4;
    _onValueChanged = _x select 5;
    _authority = _x select 6;
    _description = _x select 7;

    [
        _variableName,
        _settingType,
        [_title, _description],
        ["BloodLust", _category],
        _settingInfo,
        _authority,
        _onValueChanged,
        false
    ] call CBA_fnc_addSetting;
} foreach BloodLust_CBASettings;