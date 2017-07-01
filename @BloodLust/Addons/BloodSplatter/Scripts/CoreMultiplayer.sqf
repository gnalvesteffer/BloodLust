//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer
//Overrides and adds certain functionality for multiplayer compatibility.

BloodLust_InitUnit =
{
    _unit = _this select 0;
    [_unit] call BloodLust_AddUnitEventHandlers;
};

BloodLust_OnUnitRespawn =
{
    _unit = _this select 0;
    _corpse = _this select 1;
    [_unit] remoteExec ["BloodLust_AddUnitEventHandlers"];
};

BloodLust_AddUnitEventHandlers =
{
    _unit = _this select 0;
    _unit setVariable ["BloodLust_FiredEventHandlerIndex", _unit addEventHandler ["Fired",
    {
        _this call BloodLust_OnUnitFired;
    }]];
    _unit setVariable ["BloodLust_HitPartEventHandlerIndex", _unit addEventHandler ["HitPart",
    {
        _this remoteExec ["BloodLust_OnUnitHitPart"]; //HitPart only triggers on the machine where the unit is local, which is why it is being broadcasted here.
    }]];
    _unit setVariable ["BloodLust_ExplosionEventHandlerIndex", _unit addEventHandler ["Explosion",
    {
        _this remoteExec ["BloodLust_OnUnitExplosion"]; //Explosion only triggers on the machine where the unit is local, which is why it is being broadcasted here.
    }]];
};

BloodLust_OnUnitExplosion =
{
    _this call
    {
        _unit = _this select 0;
        _damage = _this select 1;

        if(_unit getVariable ["BloodLust_IsVaporized", false]) exitWith {};

        if(BloodLust_IsVaporizationEnabledMP && _damage >= BloodLust_VaporizationDamageThresholdMP) exitWith
        {
            [_unit, _damage] call BloodLust_VaporizeUnit;
            _unit removeEventHandler ["Fired", _unit getVariable ["BloodLust_FiredEventHandlerIndex", -1]];
            _unit removeEventHandler ["HitPart", _unit getVariable ["BloodLust_HitPartEventHandlerIndex", -1]];
            _unit removeEventHandler ["Explosion", _unit getVariable ["BloodLust_ExplosionEventHandlerIndex", -1]];
        };

        if(alive _unit && _damage >= BloodLust_ExplosionDamageThresholdMP) then
        {
            _splatterCount = _damage * BloodLust_ExplosionBloodSplatterIterationMultiplier;
            for [{_i = 0}, {_i < _splatterCount}, {_i = _i + 1}] do
            {
                _jitter =
                [
                    BloodLust_VaporizedBloodSplatterJitterAmount - (random (BloodLust_VaporizedBloodSplatterJitterAmount * 2)),
                    BloodLust_VaporizedBloodSplatterJitterAmount - (random (BloodLust_VaporizedBloodSplatterJitterAmount * 2)),
                    BloodLust_VaporizedBloodSplatterJitterAmount - (random (BloodLust_VaporizedBloodSplatterJitterAmount * 2))
                ];
                _splatter =
                [
                    _unit,
                    getPosASL _unit,
                    vectorNormalized _jitter,
                    BloodLust_BloodSplatterIntersectionMaxDistance,
                    random 360,
                    selectRandom BloodLust_VaporizationBloodSplatters
                ] call BloodLust_CreateBloodSplatter;
            };
        };
    };
};

BloodLust_OnUnitFired =
{
    if(!hasInterface) exitWith {};

    _unit = _this select 0;
    _weapon = _this select 1;
    _muzzle = _this select 2;
    _mode = _this select 3;
    _ammo = _this select 4;
    _magazine = _this select 5;
    _projectile = _this select 6;

    if(!(isNull _projectile)) then
    {
        _unit setVariable
        [
            "BloodLust_LastFiredProjectileInfo",
            [
                getPosASL _projectile,
                velocity _projectile,
                vectorDir _projectile,
                vectorUp _projectile,
                direction _projectile
            ]
        ];
    };
};

BloodLust_OnUnitHitPart =
{
    _this call
    {
        if(!BloodLust_IsBloodLustEnabled || !hasInterface) exitWith {};

        _hitSelections = _this;
        _hitSelection = _this select 0;
        _target       = _hitSelection select 0;
        _shooter      = _hitSelection select 1;
        _bullet       = _hitSelection select 2;
        _hitPosition  = _hitSelection select 3;
        _velocity     = _hitSelection select 4;
        _selections   = _hitSelection select 5;
        _ammo         = _hitSelection select 6;
        _direction    = _hitSelection select 7;
        _radius       = _hitSelection select 8;
        _surface      = _hitSelection select 9;
        _isDirectHit  = _hitSelection select 10;
        _unitLastFiredProjectileInfo = _shooter getVariable ["BloodLust_LastFiredProjectileInfo", []];
        if((count _unitLastFiredProjectileInfo == 0) || ((position _target) distance (positionCameraToWorld [0, 0, 0]) > BloodLust_BloodLustActivationDistance)) exitWith {};

        _ammoCaliber =  getNumber(configFile >> "CfgAmmo" >> (_ammo select 4) >> "caliber");
        _bloodSplatterIterations = ((BloodLust_BloodSplatterIterationCaliberMultiplier * _ammoCaliber) * BloodLust_BloodSplatterIterations) max 1;
        _projectilePositionASL = _unitLastFiredProjectileInfo select 0;
        _projectileVelocity = _unitLastFiredProjectileInfo select 1;
        _projectileVectorDir = _unitLastFiredProjectileInfo select 2;
        _projectileVectorUp = _unitLastFiredProjectileInfo select 3;
        _projectileDirection = _unitLastFiredProjectileInfo select 4;

        if(BloodLust_IsBloodSprayEnabled) then
        {
            for "_i" from 1 to BloodLust_BloodSprayIterations do
            {
                _sprayJitter =
                [
                    BloodLust_BloodSplatterJitterAmount - (random (BloodLust_BloodSplatterJitterAmount * 2)),
                    BloodLust_BloodSplatterJitterAmount - (random (BloodLust_BloodSplatterJitterAmount * 2)),
                    BloodLust_BloodSplatterJitterAmount - (random (BloodLust_BloodSplatterJitterAmount * 2))
                ];
                [_hitPosition, _projectileVectorDir vectorAdd (_sprayJitter vectorMultiply 1), _projectileVectorUp vectorAdd (_sprayJitter vectorMultiply 1)] call BloodLust_CreateBloodSpray;
            };
        };

        for "_i" from 1 to _bloodSplatterIterations do
        {
            _splatterTextures = [_target, _selections] call BloodLust_GetSplatterTextures;
            if(count _splatterTextures == 0) exitWith {};
            _splatterJitter =
            [
                BloodLust_BloodSplatterJitterAmount - (random (BloodLust_BloodSplatterJitterAmount * 2)),
                BloodLust_BloodSplatterJitterAmount - (random (BloodLust_BloodSplatterJitterAmount * 2)),
                BloodLust_BloodSplatterJitterAmount - (random (BloodLust_BloodSplatterJitterAmount * 2))
            ];
            [
                _target,
                _hitPosition,
                vectorNormalized _projectileVelocity vectorAdd _splatterJitter,
                BloodLust_BloodSplatterIntersectionMaxDistance,
                (_projectileDirection + 90) + random BloodLust_BloodSplatterAngleJitterAmount,
                selectRandom _splatterTextures
            ] call BloodLust_CreateBloodSplatter;
        };

        if(BloodLust_IsBleedingEnabled && alive _target) then
        {
           {
               [_hitSelection, BloodLust_BleedDuration, BloodLust_BleedFrequency, BloodLust_BleedFrequencyVariance] call BloodLust_MakeUnitBleed;
           } foreach [_hitSelection];
        };
    };
};

BloodLust_VaporizeUnit =
{
    _this call
    {
        _unit = _this select 0;
        _gibForce = _this select 1;

        if(_unit getVariable ["BloodLust_IsVaporized", false]) exitWith {};
        if(local _unit) then
        {
            _unit setDamage 1;
        };

        _unit setVariable ["BloodLust_IsVaporized", true];
        _unit call BloodLust_GoreMistEffect;
        hideObject _unit;
        [selectRandom BloodLust_VaporizationSounds, _unit, false, getPosASL _unit, 30, 1.2 - (random 0.4), 100] call BloodLust_PlaySound;

        if(_unit distance (positionCameraToWorld [0, 0, 0]) <= BloodLust_BloodLustActivationDistance) then
        {
            if(BloodLust_IsVaporizedHeatWaveEnabled) then
            {
                [_unit, 5] call BloodLust_RefractionEffect;
            };

            if(BloodLust_IsVaporizationGibsEnabledMP) then
            {
                _gibSets = +BloodLust_VaporizationGibClassnames;
                _GetRandomGib =
                {
                    _spawnableGibs = [];
                    {
                        _gibSetIndex = _x select 0;
                        _spawnCount = _x select 2;
                        _spawnLimit = _x select 3;
                        if(_spawnCount < _spawnLimit) then
                        {
                            _spawnableGibs pushBack _x;
                        };
                    } foreach _gibSets;

                    if(count _spawnableGibs == 0) exitWith
                    {
                        nil;
                    };

                    _gibSet = selectRandom _spawnableGibs;
                    _gibSetIndex = _gibSet select 0;
                    _className = _gibSet select 1;
                    _spawnCount = _gibSet select 2;
                    _spawnLimit = _gibSet select 3;

                    (_gibSets select _gibSetIndex) set [2, _spawnCount + 1];
                    _className;
                };

                _gibs = [];
                for "_i" from 1 to BloodLust_VaporizationGibIterations do
                {
                    _gibClassname = call _GetRandomGib;
                    if(isNil "_gibClassname") exitWith {};

                    _jitter =
                    [
                        BloodLust_VaporizedBloodSplatterJitterAmount - (random (BloodLust_VaporizedBloodSplatterJitterAmount * 2)),
                        BloodLust_VaporizedBloodSplatterJitterAmount - (random (BloodLust_VaporizedBloodSplatterJitterAmount * 2)),
                        BloodLust_VaporizedBloodSplatterJitterAmount - (random (BloodLust_VaporizedBloodSplatterJitterAmount * 2))
                    ];
                    _gib = _gibClassname call BloodLust_CreateGibObject;
                    _gibs pushBack _gib;
                    _gib setVariable ["BloodLust_SourceUnit", _unit];
                    _gib setDir (random 360);
                    _gib setPosASL (getPosASL _unit);
                    _gib setVelocity (_jitter vectorMultiply _gibForce);
                    [_gib, BloodLust_GibBleedDuration, 0.1] call BloodLust_AttachSmearBleeding;

                    if(_unit == player && BloodLust_IsVaporizedGibCamSwitchEnabled) then
                    {
                        (selectRandom _gibs) switchCamera "External";
                    };

                    if(BloodLust_IsVaporizedHeatWaveEnabled) then
                    {
                        [_gib, 30] call BloodLust_RefractionEffect;
                    };

                    {
                        [_gib] call _x;
                    } foreach BloodLust_OnGibCreatedEventHandlers;
                };
            };

            _bloodSplatters = [];
            _unitSurfaceIntersection = [getPosASL _unit, _unit, vehicle _unit] call BloodLust_GetSurfaceIntersection;
            _unitSurfaceDistance = _unitSurfaceIntersection select 0;
            _unitSurfaceNormal = _unitSurfaceIntersection select 1;
            _unitSurfacePosition = _unitSurfaceIntersection select 2;
            _unitIsIntersecting = _unitSurfaceIntersection select 3;
            _unitSurfaceIntersectingObject = _unitSurfaceIntersection select 4;
            if(_unitIsIntersecting) then
            {
                _largeSplatter = call BloodLust_CreateLargeBloodSplatterObject;
                _largeSplatter setObjectTexture [0, selectRandom BloodLust_LargeVaporizationBloodSplatters];
                _largeSplatter setDir (random 360);
                _largeSplatter setVectorUp _unitSurfaceNormal;
                _largeSplatter setPosASL (_unitSurfacePosition vectorAdd (_unitSurfaceNormal vectorMultiply (random 0.01)));
                _bloodSplatters pushBack _largeSplatter;
                [_largeSplatter, _unitSurfaceIntersectingObject] call BloodLust_AssignSplatterToBuilding;
            };
            for "_i" from 1 to BloodLust_VaporizedBloodSplatterIterations do
            {
                _jitter =
                [
                    BloodLust_VaporizedBloodSplatterJitterAmount - (random (BloodLust_VaporizedBloodSplatterJitterAmount * 2)),
                    BloodLust_VaporizedBloodSplatterJitterAmount - (random (BloodLust_VaporizedBloodSplatterJitterAmount * 2)),
                    BloodLust_VaporizedBloodSplatterJitterAmount - (random (BloodLust_VaporizedBloodSplatterJitterAmount * 2))
                ];
                _splatter =
                [
                    _unit,
                    getPosASL _unit,
                    vectorNormalized _jitter,
                    BloodLust_BloodSplatterIntersectionMaxDistance,
                    random 360,
                    selectRandom BloodLust_VaporizationBloodSplatters
                ] call BloodLust_CreateBloodSplatter;
                if(!(isNil "_splatter")) then //There are instances where the splatter may be null in a multiplayer environment.
                {
                    _bloodSplatters pushBack _splatter;
                    if(BloodLust_IsVaporizedHeatWaveEnabled) then
                    {
                        [_splatter, 15] call BloodLust_RefractionEffect;
                    };
                };
            };
        };
    };
};
