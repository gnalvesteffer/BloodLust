//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer

BloodLust_BloodSplatters = [];
BloodLust_BleedSplatters = [];
BloodLust_Gibs = [];
BloodLust_ArterialBloodSprays = [];
BloodLust_BloodSprays = [];

BloodLust_InitVehicle =
{
    _vehicle = _this select 0;
    _vehicle addEventHandler ["Killed",
    {
        if(!BloodLust_IsBloodLustEnabled) exitWith {};
        {
            _this call _x;
        } foreach BloodLust_OnVehicleKilledPreEventHandlers;

        _this call BloodLust_OnVehicleKilled;

        {
            _this call _x;
        } foreach BloodLust_OnVehicleKilledPostEventHandlers;
    }];
};

BloodLust_OnVehicleKilled =
{
    _vehicle   = _this select 0;
    _killer = _this select 1;

    if(BloodLust_IsVehicleCrewVaporizationEnabled) then
    {
        [_vehicle] call BloodLust_VehicleCrewVaporization;
    };
};

BloodLust_VehicleCrewVaporization =
{
    _vehicle = _this select 0;
    _fuelExplosionPower = getNumber (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "fuelExplosionPower");
    if(_fuelExplosionPower >= 1) then
    {
        _crew = crew _vehicle;
        {
            [_x, _fuelExplosionPower] call BloodLust_VaporizeUnit;
        } foreach _crew;
    };
};

//Adds BloodLust effects to unit.
BloodLust_InitUnit =
{
    _unit = _this select 0;

    _hitPartEventHandlerIndex = _unit addEventHandler ["HitPart",
    {
        if(!BloodLust_IsBloodLustEnabled || count _this > 1) exitWith {}; //Probably an explosion -- let the explosion handler deal with this.

        _unit = (_this select 0) select 0;

        if(!BloodLust_IsBloodLustEnabledForDeadUnits && !alive _unit) exitWith {};

        if((position _unit) distance (positionCameraToWorld [0, 0, 0]) <= BloodLust_BloodLustActivationDistance) then
        {
            {
                _this call _x;
            } foreach BloodLust_OnUnitHitPartPreEventHandlers;

            _this call BloodLust_OnUnitHitPart;

            {
                _this call _x;
            } foreach BloodLust_OnUnitHitPartPostEventHandlers;
        };
    }];

    _explosionEventHandlerIndex = _unit addEventHandler ["Explosion",
    {
        if(!BloodLust_IsBloodLustEnabled) exitWith {};
        _unit = _this select 0;
        if((position _unit) distance (positionCameraToWorld [0, 0, 0]) <= BloodLust_BloodLustActivationDistance) then
        {
            {
                _this call _x;
            } foreach BloodLust_OnUnitExplosionPreEventHandlers;

            _this call BloodLust_OnUnitExplosion;

            {
                _this call _x;
            } foreach BloodLust_OnUnitExplosionPostEventHandlers;
        };
    }];

    _killedEventHandlerIndex = _unit addEventHandler ["Killed",
    {
        if(!BloodLust_IsBloodLustEnabled) exitWith {};
        {
            _this call _x;
        } foreach BloodLust_OnUnitKilledPreEventHandlers;

        _this call BloodLust_OnUnitKilled;

        {
            _this call _x;
        } foreach BloodLust_OnUnitKilledPostEventHandlers;
    }];

    _hitEventHandlerIndex = _unit addEventHandler ["Hit",
    {
        if(!BloodLust_IsBloodLustEnabled) exitWith {};

        _unit = _this select 0;

        if(!BloodLust_IsBloodLustEnabledForDeadUnits && !alive _unit) exitWith {};

        if((position _unit) distance (positionCameraToWorld [0, 0, 0]) <= BloodLust_BloodLustActivationDistance) then
        {
            {
                _this call _x;
            } foreach BloodLust_OnUnitHitPreEventHandlers;

            _this call BloodLust_OnUnitHit;

            {
                _this call _x;
            } foreach BloodLust_OnUnitHitPostEventHandlers;
        };
    }];

    _unit setVariable ["BloodLust_HitPartEventHandlerIndex", _hitPartEventHandlerIndex];
    _unit setVariable ["BloodLust_ExplosionEventHandlerIndex", _explosionEventHandlerIndex];
    _unit setVariable ["BloodLust_KilledEventHandlerIndex", _killedEventHandlerIndex];
    _unit setVariable ["BloodLust_HitEventHandlerIndex", _hitEventHandlerIndex];
};

BloodLust_OnUnitHit =
{
    _unit = _this select 0;
    _causedBy = _this select 1;
    _damage = _this select 2;

    if(BloodLust_IsUnitVehicleCollisionEffectsEnabled) then
    {
        _isUnitHitByVehicle = [_unit, _causedBy] call BloodLust_IsUnitHitByVehicle;
        if(_isUnitHitByVehicle) then
        {
            [_unit, vehicle _causedBy, _damage] call BloodLust_UnitHitByVehicle;
        };
    };

    if(BloodLust_IsFallingVaporizationEnabled) then
    {
        [_unit, _causedBy] call BloodLust_UnitFallVaporization;
    };
};

BloodLust_OnUnitExplosion =
{
    _unit = _this select 0;
    _damage = _this select 1;

    if(_unit getVariable ["BloodLust_IsVaporized", false]) exitWith {};

    if(BloodLust_IsVaporizationEnabled && _damage >= BloodLust_VaporizationDamageThreshold) exitWith
    {
        [_unit, _damage * BloodLust_ExplosionGibForceMultiplier] call BloodLust_VaporizeUnit;
    };

    if(_damage >= BloodLust_ExplosionDamageThreshold) then
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

BloodLust_OnUnitKilled =
{
    _unit   = _this select 0;
    _killer = _this select 1;

    if(BloodLust_IsFallingVaporizationEnabled) then
    {
        _isUnitVaporized = [_unit, _killer] call BloodLust_UnitFallVaporization;
    };
};

//Pass event args from "HitPart" event.
//Example: _this call OnUnitHitPart;
BloodLust_OnUnitHitPart =
{
    _hitSelections = _this;
    _unit = (_hitSelections select 0) select 0;

    if(_unit getVariable ["BloodLust_IsVaporized", false]) exitWith {};

    _hitSelectionsFiltered = _hitSelections select
    {
        _return    = false;
        _ammoClass = (_x select 6) select 4;
        if(_ammoClass != "") then
        {
            _return = true;
        };
        _return;
    };

    _hitSelection = _hitSelectionsFiltered select 0;
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
    _ammoDamage   = _ammo select 0;
    _ammoCaliber =  getNumber(configFile >> "CfgAmmo" >> (_ammo select 4) >> "caliber");
    _bloodSplatterIterations = ((BloodLust_BloodSplatterIterationCaliberMultiplier * _ammoCaliber) * BloodLust_BloodSplatterIterations) max 1;

    if(BloodLust_IsBloodSprayEnabled && (random 1) <= BloodLust_BloodSprayProbability) then
    {
        for "_i" from 1 to BloodLust_BloodSprayIterations do
        {
            _sprayJitter =
            [
                BloodLust_BloodSprayJitterAmount - (random (BloodLust_BloodSprayJitterAmount * 2)),
                BloodLust_BloodSprayJitterAmount - (random (BloodLust_BloodSprayJitterAmount * 2)),
                BloodLust_BloodSprayJitterAmount - (random (BloodLust_BloodSprayJitterAmount * 2))
            ];

            [_hitPosition, (vectorDir _bullet) vectorAdd _sprayJitter, (vectorUp _bullet) vectorAdd _sprayJitter] call BloodLust_CreateBloodSpray;

            if(BloodLust_IsBloodSplashingEnabled) then
            {
                [_hitPosition, (vectorDir _bullet) vectorAdd _sprayJitter, (vectorMagnitude _velocity) * BloodLust_BloodSplashProjectileSpeedContribution, BloodLust_BloodSplashDuration] call BloodLust_CreateBloodSplash;
            };
        };
    };

    if(random 1 <= BloodLust_BloodSplatterProbability) then
    {
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
                vectorNormalized _velocity vectorAdd _splatterJitter,
                BloodLust_BloodSplatterIntersectionMaxDistance,
                (direction _bullet + 90) + random BloodLust_BloodSplatterAngleJitterAmount,
                selectRandom _splatterTextures
            ] call BloodLust_CreateBloodSplatter;
        };
    };

    if(BloodLust_IsGibbingEnabled && _ammoCaliber >= BloodLust_GibCaliberThreshold && _bullet call BloodLust_GetVelocityMagnitude >= BloodLust_GibbingProjectileSpeedThreshold && ((random 1) <= BloodLust_GibProbability)) then
    {
        for "_i" from 0 to ((floor(random(BloodLust_GibIterations))) max 1) do
        {
            [BloodLust_BloodSplatterJitterAmount, _hitSelection] call BloodLust_CreateGib;
        };
    };

    if(BloodLust_IsBleedingEnabled && alive _unit) then
    {
       {
           [_hitSelection, BloodLust_BleedDuration, BloodLust_BleedFrequency, BloodLust_BleedFrequencyVariance] call BloodLust_MakeUnitBleed;
       } foreach _hitSelectionsFiltered;
    };
};

BloodLust_UnitFallVaporization =
{
    _unit = _this select 0;
    _killer = _this select 1;
    _isUnitOnFoot = vehicle _unit == _unit;
    _unitVelocityMagnitude = vectorMagnitude (velocity _unit);
    _isUnitVaporized = false;
    if(_unit == _killer && _isUnitOnFoot && _unitVelocityMagnitude >= BloodLust_FallingVaporizationSpeedThreshold) then
    {
        [_unit, _unitVelocityMagnitude * BloodLust_FallingVaporizationGibSpeedScalar] call BloodLust_VaporizeUnit;
        _isUnitVaporized = true;
    };
    _isUnitVaporized;
};

BloodLust_IsUnitHitByVehicle =
{
    _unit = _this select 0;
    _damageSourceUnit = _this select 1;
    _vehicle = vehicle _damageSourceUnit; //ToDo: Received report that this statement can cause an error: Type string received, expected object.
    _vehicleSize = sizeOf (typeOf _vehicle);
    _isUnitOnFoot = vehicle _unit == _unit;
    _isDamageSourceVehicle = _vehicle != _damageSourceUnit;
    _isUnitNearVehicle = _unit distance _vehicle <= _vehicleSize;
    _return = _isUnitOnFoot && _isDamageSourceVehicle && _isUnitNearVehicle && _vehicle call BloodLust_GetVelocityMagnitude >= 15;
    _return;
};

BloodLust_UnitHitByVehicle =
{
    _unit = _this select 0;
    _vehicle = _this select 1;
    _damage = _this select 2;
    _vehicleSpeed = _vehicle call BloodLust_GetVelocityMagnitude;

    [selectRandom BloodLust_UnitVehicleCollisionSounds, _vehicle, false, getPosASL _vehicle, (_vehicle call BloodLust_GetVelocityMagnitude) * 0.5, 1.2 - (random 0.4), 50] call BloodLust_PlaySound;
    if(_vehicleSpeed >= BloodLust_UnitVehicleVaporizationCollisionSpeed && random 1 <= BloodLust_UnitVehicleVaporizationProbability) then
    {
        [_unit, log _vehicleSpeed] call BloodLust_VaporizeUnit;
    }
    else
    {
        [_unit, BloodLust_UnitVehicleCollisionBleedDuration, 0.1] call BloodLust_AttachBleeding;
    };
};

BloodLust_CreateBloodPoolObject =
{
    if(!BloodLust_IsBloodPoolingEnabled) exitWith {};

    if(call BloodLust_IsMaxBloodSplattersReached) then
    {
        call BloodLust_RemoveOldBloodSplatter;
    };

    _pool = objNull;
    if(isMultiplayer) then
    {
        _pool = "BloodSplatter_MediumPlane" createVehicleLocal [0, 0, 0];
    }
    else
    {
        _pool = createSimpleObject ["BloodSplatter_MediumPlane", [0, 0, 0]];
    };

    BloodLust_BloodSplatters pushBack _pool;
    [selectRandom BloodLust_BloodPoolTextures, BloodLust_BloodPoolFramerate, false, false, _pool, {}] call BloodLust_AnimateObjectTexture;
    _pool;
};

BloodLust_CreateGib =
{
    _jitterAmount   = _this select 0;
    _hitSelection   = _this select 1;
    _target         = _hitSelection select 0;
    _shooter        = _hitSelection select 1;
    _bullet         = _hitSelection select 2;
    _hitPosition    = _hitSelection select 3;
    _velocity       = _hitSelection select 4;
    _selections     = _hitSelection select 5;
    _ammo           = _hitSelection select 6;
    _direction      = _hitSelection select 7;
    _radius         = _hitSelection select 8;
    _surface        = _hitSelection select 9;
    _isDirectHit    = _hitSelection select 10;
    _normalVelocity = vectorNormalized _velocity;
    _jitter         = [_jitterAmount - (random (_jitterAmount * 2)), _jitterAmount - (random (_jitterAmount * 2)), _jitterAmount - (random (_jitterAmount * 2))];
    _gibClassnames  = [_target, _selections] call BloodLust_GetGibClassnames;

    if(count _gibClassnames == 0) exitWith {};
    _gibClassname = selectRandom _gibClassnames;

    if(call BloodLust_IsMaxGibsReached) then
    {
        call BloodLust_RemoveOldGib;
    };

    _gib = _gibClassname call BloodLust_CreateGibObject;
    _gib setVariable ["BloodLust_SourceUnit", _target];
    _gib setVariable ["BloodLust_SourceHitSelection", _hitSelection];
    _gib setDir (random 360);
    _gib setPosASL _hitPosition;
    _gib setVelocity ((_normalVelocity vectorAdd _jitter) vectorMultiply BloodLust_GibSpeed);

    [_gib, 0.5, BloodLust_GibBleedDuration] call BloodLust_ReduceBounciness;
    [_gib, BloodLust_GibBleedDuration, 0.1] call BloodLust_AttachBleeding;

    {
        [_gib] call _x;
    } foreach BloodLust_OnGibCreatedEventHandlers;

    _gib;
};

BloodLust_ReduceBounciness =
{
    _object = _this select 0;
    _reductionAmount = _this select 1;
    _duration = _this select 2;
    _startTime = time;
    _endTime = _startTime + _duration;

    [{
        _args = _this select 0;
        _object = _args select 0;
        _reductionAmount = _args select 1;
        _endTime = _args select 2;

        if(time >= _endTime) then
        {
            [_this select 1] call CBA_fnc_removePerFrameHandler;
        }
        else
        {
            if(isTouchingGround _object) then
            {
                _objectVelocity = velocity _object;
                _zVelocityAmount = 1 - _reductionAmount;
                _object setVelocity [_objectVelocity select 0, _objectVelocity select 1, (_objectVelocity select 2) * _zVelocityAmount];
            };
        };
    }, 0, [_object, _reductionAmount, _endTime]] call CBA_fnc_addPerFrameHandler;
};

BloodLust_AttachBleeding =
{
    _object   = _this select 0;
    _duration = _this select 1;
    _minimumSpeed = _this select 2;
    _endTime = time + _duration;

    [{
        _args = _this select 0;
        _object = _args select 0;
        _endTime = _args select 1;
        _minimumSpeed = _args select 2;
        _previousBleedTime = _object getVariable ["BloodLust_PreviousBleedTime", -1];

        if (time >= _endTime) then
        {
            [_this select 1] call CBA_fnc_removePerFrameHandler;
        }
        else
        {
            if(time > _previousBleedTime) then
            {
                _surfaceIntersection = [getPosASL _object, _object, vehicle _object] call BloodLust_GetSurfaceIntersection;
                _surfaceDistance     = _surfaceIntersection select 0;
                _surfaceNormal       = _surfaceIntersection select 1;
                _surfacePosition    = _surfaceIntersection select 2;
                _surfaceIsIntersecting = _surfaceIntersection select 3;

                if(_surfaceIsIntersecting && _surfaceDistance <= 0.05 && _object call BloodLust_GetVelocityMagnitude >= _minimumSpeed) then
                {
                    _splatterPosition = _surfacePosition vectorAdd (_surfaceNormal vectorMultiply 0.01);
                    _splatter = call BloodLust_CreateBleedSplatterObject;
                    _splatter setDir (random 360);
                    _splatter setObjectTexture [0, selectRandom BloodLust_BleedTextures];
                    _splatter setPosASL _splatterPosition;
                    _splatter setVectorUp _surfaceNormal;
                    _object setVariable ["BloodLust_PreviousBleedTime", time];

                    {
                        [_splatter] call _x;
                    } foreach BloodLust_OnBleedSplatterCreatedEventHandlers;
                };
            };
        };
    }, 0, [_object, _endTime, _minimumSpeed]] call CBA_fnc_addPerFrameHandler;
};

BloodLust_AttachSmearBleeding =
{
    _object   = _this select 0;
    _duration = _this select 1;
    _minimumSpeed = _this select 2;
    _endTime = time + _duration;

    [{
        _args = _this select 0;
        _object = _args select 0;
        _endTime = _args select 1;
        _minimumSpeed = _args select 2;
        _previousBleedTime = _object getVariable ["BloodLust_PreviousBleedTime", -1];

        if (time >= _endTime) then
        {
            [_this select 1] call CBA_fnc_removePerFrameHandler;
        }
        else
        {
            if(time > _previousBleedTime) then
            {
                _surfaceIntersection = [getPosASL _object, _object, vehicle _object] call BloodLust_GetSurfaceIntersection;
                _surfaceDistance     = _surfaceIntersection select 0;
                _surfaceNormal       = _surfaceIntersection select 1;
                _surfacePosition    = _surfaceIntersection select 2;
                _surfaceIsIntersecting = _surfaceIntersection select 3;

                if(_surfaceIsIntersecting && _surfaceDistance <= 0.05 && _object call BloodLust_GetVelocityMagnitude >= _minimumSpeed) then
                {
                    _splatterPosition = _surfacePosition vectorAdd (_surfaceNormal vectorMultiply 0.01);
                    _splatter = call BloodLust_CreateBleedSplatterObject;
                    _splatter setDir (random 360);
                    _splatter setObjectTexture [0, selectRandom BloodLust_SmearTextures];
                    _splatter setPosASL _splatterPosition;
                    _splatter setVectorUp _surfaceNormal;
                    _object setVariable ["BloodLust_PreviousBleedTime", time];

                    {
                        [_splatter] call _x;
                    } foreach BloodLust_OnBleedSplatterCreatedEventHandlers;
                };
            };
        };
    }, 0, [_object, _endTime, _minimumSpeed]] call CBA_fnc_addPerFrameHandler;
};

BloodLust_VaporizeUnit =
{
    _unit = _this select 0;
    _gibForce = _this select 1;

    if(_unit getVariable ["BloodLust_IsVaporized", false]) exitWith {};

    _unit setVariable ["BloodLust_IsVaporized", true];
    _unit removeEventHandler ["HitPart", _unit getVariable ["BloodLust_HitPartEventHandlerIndex", -1]];
    _unit removeEventHandler ["Hit", _unit getVariable ["BloodLust_HitEventHandlerIndex", -1]];
    _unit removeEventHandler ["Explosion", _unit getVariable ["BloodLust_ExplosionEventHandlerIndex", -1]];
    _unit setDamage 1;
    _unit call BloodLust_GoreMistEffect;
    hideObject _unit;
    [selectRandom BloodLust_VaporizationSounds, _unit, false, getPosASL _unit, 30, 1.2 - (random 0.4), 100] call BloodLust_PlaySound;

    if(BloodLust_IsVaporizedHeatWaveEnabled) then
    {
        [_unit, 5] call BloodLust_RefractionEffect;
    };

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
        _bloodSplatters pushBack _splatter;
        if(BloodLust_IsVaporizedHeatWaveEnabled) then
        {
            [_splatter, 15] call BloodLust_RefractionEffect;
        };
    };

    {
        [_unit, _gibForce, _gibs, _bloodSplatters] call _x;
    } foreach BloodLust_OnUnitVaporizedEventHandlers;
};

BloodLust_MakeUnitBleed =
{
    _hitSelection      = _this select 0;
    _duration          = _this select 1;
    _target            = _hitSelection select 0;
    _shooter           = _hitSelection select 1;
    _bullet            = _hitSelection select 2;
    _hitPosition       = _hitSelection select 3;
    _velocity          = _hitSelection select 4;
    _selections        = _hitSelection select 5;
    _ammo              = _hitSelection select 6;
    _direction         = _hitSelection select 7;
    _radius            = _hitSelection select 8;
    _surface           = _hitSelection select 9;
    _isDirectHit       = _hitSelection select 10;
    _bulletVectorDir = vectorDir _bullet;
    _bulletVectorUp = vectorUp _bullet;

    if(count _selections == 0) exitWith {};

    _selectionName     = selectRandom _selections;
    _endTime           = time + _duration;
    _arterialBloodSprayEndTime = time + BloodLust_ArterialBloodSprayDuration;
    _initialUnitDamage = damage _target;
    _bleedSmearEndTime = time + BloodLust_BleedSmearDuration;
    _target setVariable [format ["BloodLust_NextBleedTime_%1", _selectionName], call BloodLust_GetNextBleedTime];

    [{
        _args = _this select 0;
        _target = _args select 0;
        _initialUnitDamage = _args select 1;
        _projectileVelocity = _args select 2;
        _selectionName = _args select 3;
        _bulletVectorDir = _args select 4;
        _bulletVectorUp = _args select 5;
        _endTime = _args select 6;
        _arterialBloodSprayEndTime = _args select 7;
        _bleedSmearEndTime = _args select 8;
        _nextBleedTime = _target getVariable [format ["BloodLust_NextBleedTime_%1", _selectionName], 0];
        _splatterAngle = random 360;

        if((time >= _endTime) || (_target getVariable ["BloodLust_IsVaporized", false]) || ((damage _target) < _initialUnitDamage)) exitWith
        {
            {
                [_target] call _x;
            } foreach BloodLust_OnUnitBleedPostEventHandlers;
            [_this select 1] call CBA_fnc_removePerFrameHandler;
        };

        _hitPointPosition = AGLToASL(_target modelToWorld (_target selectionPosition [_selectionName, "HitPoints"]));
        _intersectionEndPosition = AGLToASL((_target modelToWorld ((_target selectionPosition [_selectionName, "HitPoints"]))) vectorAdd ((vectorNormalized _projectileVelocity) vectorMultiply 0.3));
        _surfaceIntersections = lineIntersectsSurfaces
        [
            _hitPointPosition,
            _intersectionEndPosition,
            _target,
            vehicle _target,
            true,
            10,
            "VIEW",
            "NONE"
        ] select {
            _intersectingObject  = _x select 2;
            _isObjectInIntersectionBlackList = [typeOf _intersectingObject, (getModelInfo _intersectingObject) select 0] call BloodLust_IsClassInIntersectionBlackList;
            _return = !_isObjectInIntersectionBlackList;
            _return;
        };

        {
            [
                _target,
                _initialUnitDamage,
                _projectileVelocity,
                _selectionName,
                _bulletVectorDir,
                _bulletVectorUp,
                _endTime,
                _arterialBloodSprayEndTime,
                _nextBleedTime,
                _hitPointPosition,
                _intersectionEndPosition,
                _surfaceIntersections
            ] call _x;
        } foreach BloodLust_OnUnitBleedPreEventHandlers;

        if(count _surfaceIntersections == 0 && time >= _nextBleedTime) then
        {
            _intersectionEndPosition = AGLToASL(_target modelToWorld ((_target selectionPosition [_selectionName, "HitPoints"]) vectorAdd [0, 0, -0.15]));
            _surfaceIntersections = lineIntersectsSurfaces
            [
                _hitPointPosition,
                _intersectionEndPosition,
                _target,
                vehicle _target,
                true,
                10,
                "VIEW",
                "NONE"
            ] select {
                _intersectingObject  = _x select 2;
                _isObjectInIntersectionBlackList = [typeOf _intersectingObject, (getModelInfo _intersectingObject) select 0] call BloodLust_IsClassInIntersectionBlackList;
                _return = !_isObjectInIntersectionBlackList;
                _return;
            };
        };

        if(count _surfaceIntersections > 0 && time <= _bleedSmearEndTime) then
        {
            _previousSmearPosition = _target getVariable [format ["BloodLust_PreviousBleedSmearPosition_%1", _selectionName], [0, 0, 0]];
            _surfaceIntersection = _surfaceIntersections select 0;
            _surfacePosition = _surfaceIntersection select 0;
            _surfaceNormal = _surfaceIntersection select 1;
            _splatterPosition = _surfacePosition vectorAdd (_surfaceNormal vectorMultiply 0.01);

            if(_splatterPosition distance _previousSmearPosition >= BloodLust_BleedSmearSpacing) then
            {
                _splatterAngle = direction _target - ([_splatterPosition, _previousSmearPosition] call BIS_fnc_dirTo);
                _splatter = call BloodLust_CreateBloodSmearObject;
                _splatter setObjectTexture [0, selectRandom BloodLust_SmearTextures];
                _splatter setPosASL _splatterPosition;
                [_splatter, _surfaceNormal, _splatterAngle] call BloodLust_RotateObjectAroundNormal;

                {
                    [_splatter] call _x;
                } foreach BloodLust_OnSmearSplatterCreatedEventHandlers;

                _target setVariable [format ["BloodLust_PreviousBleedSmearPosition_%1", _selectionName], _splatterPosition];
                _target setVariable [format ["BloodLust_NextBleedTime_%1", _selectionName], call BloodLust_GetNextBleedTime];
            };
        }
        else
        {
            if(time >= _nextBleedTime) then
            {
                _jitter =
                [
                    BloodLust_BleedSplatterJitterAmount - (random (BloodLust_BleedSplatterJitterAmount * 2)),
                    BloodLust_BleedSplatterJitterAmount - (random (BloodLust_BleedSplatterJitterAmount * 2)),
                    BloodLust_BleedSplatterJitterAmount - (random (BloodLust_BleedSplatterJitterAmount * 2))
                ];
                _splatterPosition    = (AGLtoASL(_target modelToWorldVisual (_target selectionPosition [_selectionName, "HitPoints"]))) vectorAdd _jitter;
                _surfaceIntersection = [_splatterPosition, _target, vehicle _target] call BloodLust_GetSurfaceIntersection;
                _surfaceDistance     = _surfaceIntersection select 0;
                _surfaceNormal       = _surfaceIntersection select 1;
                _surfacePosition     = _surfaceIntersection select 2;

                if(_surfaceDistance > 0.3) then
                {
                    _splatterPosition = _surfacePosition vectorAdd (_surfaceNormal vectorMultiply 0.01);
                    _splatter = call BloodLust_CreateBleedSplatterObject;
                    _splatter setObjectTexture [0, selectRandom BloodLust_BleedTextures];
                    _splatter setPosASL _splatterPosition;
                    [_splatter, _surfaceNormal, _splatterAngle] call BloodLust_RotateObjectAroundNormal;

                    {
                        [_splatter] call _x;
                    } foreach BloodLust_OnBleedSplatterCreatedEventHandlers;

                    [selectRandom BloodLust_BleedSounds, _splatter, false, _splatterPosition, _surfaceDistance / (BloodLust_BleedSoundAudibleVolume max 1), 1, BloodLust_BleedSoundAudibleDistance] call BloodLust_PlaySound;
                    _target setVariable [format ["BloodLust_NextBleedTime_%1", _selectionName], call BloodLust_GetNextBleedTime];

                    if(BloodLust_IsArterialBloodSprayEnabled && time <= _arterialBloodSprayEndTime && random 1 <= BloodLust_ArterialBloodSprayProbability) then
                    {
                        _arterialBloodSprayPosition = _hitPointPosition;
                        _arterialBloodSprayDirection = vectorNormalized (((_bulletVectorDir vectorAdd _jitter)) vectorCrossProduct (vectorDir _target));
                        _arterialBloodSprayUp = vectorNormalized (((_bulletVectorUp vectorAdd _jitter)) vectorCrossProduct (vectorUp _target));
                        [
                            _arterialBloodSprayPosition,
                            _arterialBloodSprayDirection,
                            _arterialBloodSprayUp
                        ] call BloodLust_CreateArterialBloodSpray;
                    };
                }
                else
                {
                    _hasBloodPool = _target getVariable ["BloodLust_HasBloodPool", false];
                    _unitSpeed = _target call BloodLust_GetVelocityMagnitude;
                    if(!_hasBloodPool && !alive _target && _unitSpeed < 1) then
                    {
                        _target setVariable ["BloodLust_HasBloodPool", true];
                        _bloodPool = call BloodLust_CreateBloodPoolObject;
                        _bloodPool setPosASL (_surfacePosition vectorAdd (_surfaceNormal vectorMultiply 0.01));
                        [_bloodPool, _surfaceNormal, _splatterAngle] call BloodLust_RotateObjectAroundNormal;
                    };
                };
            };
        };
    }, 0, [_target, _initialUnitDamage, _velocity, _selectionName, _bulletVectorDir, _bulletVectorUp, _endTime, _arterialBloodSprayEndTime, _bleedSmearEndTime]] call CBA_fnc_addPerFrameHandler;
};

BloodLust_OnBloodSprayAnimationEnd =
{
    _bloodSprayObject = param [0];
    BloodLust_BloodSprays = BloodLust_BloodSprays - [_bloodSprayObject];
};

BloodLust_OnArterialBloodSprayAnimationEnd =
{
    _bloodSprayObject = param [0];
    BloodLust_ArterialBloodSprays = BloodLust_ArterialBloodSprays - [_bloodSprayObject];
};

BloodLust_CreateArterialBloodSpray =
{
    _positionASL = _this select 0;
    _vectorDir = _this select 1;
    _vectorUp = _this select 2;
    if(call BloodLust_IsMaxArterialBloodSpraysReached) exitWith {};

    _spray = objNull;
    if(isMultiplayer) then
    {
        _spray = "BloodSplatter_SmallSprayPlane" createVehicleLocal [0, 0, 0];
    }
    else
    {
        _spray = createSimpleObject ["BloodSplatter_SmallSprayPlane", [0, 0, 0]];
    };

    BloodLust_ArterialBloodSprays pushBack _spray;
    _spray setPosASL _positionASL;
    _spray setVectorDirAndUp [_vectorDir, _vectorUp];
    _spray setPosASL (AGLToASL(_spray modelToWorld [0, 0.3, 0]));
    [selectRandom BloodLust_SprayTextures, BloodLust_ArterialBloodSprayFramerate, false, true, _spray, BloodLust_OnArterialBloodSprayAnimationEnd] call BloodLust_AnimateObjectTexture;
    if(BloodLust_IsBloodSpraySoundEnabled) then
    {
        [selectRandom BloodLust_BloodSpraySounds, _spray, false, getPosASL _spray, BloodLust_BloodSpraySoundAudibleVolume, 1.2 - (random 0.4), BloodLust_BloodSpraySoundAudibleDistance * 0.5] call BloodLust_PlaySound;
    };

    _spray;
};

BloodLust_CreateBloodSpray =
{
    _positionASL = _this select 0;
    _vectorDir = _this select 1;
    _vectorUp = _this select 2;
    if(isNil "_positionASL" || isNil "_vectorDir" || isNil "_vectorUp") exitWith {};
    if(call BloodLust_IsMaxBloodSpraysReached) exitWith {};

    _spray = objNull;
    if(isMultiplayer) then
    {
        _spray = "BloodSplatter_SprayPlane" createVehicleLocal [0, 0, 0];
    }
    else
    {
        _spray = createSimpleObject ["BloodSplatter_SprayPlane", [0, 0, 0]];
    };

    BloodLust_BloodSprays pushBack _spray;
    _spray setPosASL _positionASL;
    _spray setVectorDirAndUp [_vectorDir, _vectorUp];
    _spray setPosASL (AGLToASL(_spray modelToWorld [0, 0.9, 0]));
    [selectRandom BloodLust_SprayTextures, BloodLust_BloodSprayFramerate, false, true, _spray, BloodLust_OnBloodSprayAnimationEnd] call BloodLust_AnimateObjectTexture;
    if(BloodLust_IsBloodSpraySoundEnabled) then
    {
        [selectRandom BloodLust_BloodSpraySounds, _spray, false, getPosASL _spray, BloodLust_BloodSpraySoundAudibleVolume, 1.2 - (random 0.4), BloodLust_BloodSpraySoundAudibleDistance] call BloodLust_PlaySound;
    };

    _spray;
};

BloodLust_CreateBloodSplash =
{
    _splashStartPosition = param [0];
    _splashDirectionVector = param [1];
    _splashForce = param [2];
    _splashDuration = param [3];
    _startTime = time;
    _endTime = _startTime + _splashDuration;

    [
        {
            _arguments = _this getVariable "params";
            _splashStartPosition = _arguments select 0;
            _splashDirectionVector = _arguments select 1;
            _splashForce = _arguments select 2;
            _splashDuration = _arguments select 3;
            _startTime = _arguments select 4;
            _endTime = _arguments select 5;
            _lastSplatterPositionASL = _this getVariable ["LastSplatterPositionASL", _splashStartPosition];
            _currentSplashTime = time - _startTime;
            _currentSplashGravity = [0, 0, -9.81] vectorMultiply _currentSplashTime;
            _halfDropletJitterAmount = BloodLust_BloodSplashJitterAmount / 2;

            for[{_dropletIndex = 0}, {_dropletIndex < BloodLust_BloodSplashDropletsPerIteration}, {_dropletIndex = _dropletIndex + 1}] do
            {
                _currentSplashAngleJitter =
                [
                    _halfDropletJitterAmount - (random BloodLust_BloodSplashJitterAmount),
                    _halfDropletJitterAmount - (random BloodLust_BloodSplashJitterAmount),
                    _halfDropletJitterAmount - (random BloodLust_BloodSplashJitterAmount)
                ];
                _currentSplashForceVector = ((vectorNormalized (_splashDirectionVector vectorAdd _currentSplashAngleJitter)) vectorMultiply (_splashForce * _currentSplashTime + (_dropletIndex * BloodLust_BloodSplashDropletInterval))) vectorAdd _currentSplashGravity;

                _splatterPlacement = [_lastSplatterPositionASL, _currentSplashForceVector, BloodLust_BloodSplatterIntersectionMaxDistance, BloodLust_BloodSplatterGroundMaxDistance] call BloodLust_GetCalculatedSplatterPlacement;
                _splatterPosition = _splatterPlacement select 0;
                _splatterNormal = _splatterPlacement select 1;

                if(_splatterPosition distance _lastSplatterPositionASL < BloodLust_BloodSplashMinimumDistanceBetweenDroplets) exitWith {};

                _splatterAngle = ((_splashDirectionVector select 0) atan2 (_splashDirectionVector select 1)) + 90;

                _splatter = call BloodLust_CreateTinyBleedSplatterObject;
                if(vectorMagnitude _currentSplashForceVector >= BloodLust_BloodSplashDropletTextureSpeedThreshold) then
                {
                    _splatter setObjectTexture [0, selectRandom BloodLust_BleedTextures];
                }
                else
                {
                    _splatter setObjectTexture [0, selectRandom BloodLust_SmearTextures];
                };
                _splatter setPosASL _splatterPosition;
                [_splatter, _splatterNormal, _splatterAngle] call BloodLust_RotateObjectAroundNormal;

                [selectRandom BloodLust_BleedSounds, _splatter, false, _splatterPosition, vectorMagnitude (_splatterPosition vectorDiff _splashStartPosition), 1, BloodLust_BleedSoundAudibleDistance] call BloodLust_PlaySound;

                _this setVariable ["LastSplatterPositionASL", _splatterPosition];
            };

            _nextSplatterTime = time + (BloodLust_BloodSplashDropletInterval * BloodLust_BloodSplashDropletsPerIteration);
        },
        0,
        [
            _splashStartPosition,
            _splashDirectionVector,
            _splashForce,
            _splashDuration,
            _startTime,
            _endTime
        ],
        {
            _nextSplatterTime = 0;
        },
        {},
        {
            time >= _nextSplatterTime && random 1 <= BloodLust_BloodSplashProbability;
        },
        {
            _arguments = _this getVariable "params";
            _endTime = _arguments select 5;
            time >= _endTime;
        },
        ["_nextSplatterTime"]
    ] call CBA_fnc_createPerFrameHandlerObject;
};

//Returns: [3D position of splatter, 3D surface normal, is the splatter on a surface (true = surface, false = ground), intersecting object]
BloodLust_GetCalculatedSplatterPlacement =
{
    _sourcePositionASL = param [0];
    _directionVector = param [1];
    _maxSurfaceIntersectionDistance = param [2];
    _maxGroundIntersectionDistance = param [3, _maxSurfaceIntersectionDistance];

    _placementPosition = [0, 0, 0];
    _placementNormal = [0, 0, 0];
    _placementIsOnSurface = false;
    _placementObject = objNull;

    _endPosition = _sourcePositionASL vectorAdd (_directionVector vectorMultiply _maxSurfaceIntersectionDistance);

    _surfaceIntersections = lineIntersectsSurfaces
    [
        _sourcePositionASL,
        _endPosition,
        objNull,
        objNull,
        true,
        10,
        "VIEW",
        "NONE"
    ] select {
        _intersectingObject  = _x select 2;
        _isObjectInIntersectionBlackList = [typeOf _intersectingObject, (getModelInfo _intersectingObject) select 0] call BloodLust_IsClassInIntersectionBlackList;
        _return = !_isObjectInIntersectionBlackList;
        _return;
    };

    if(count _surfaceIntersections > 0) then
    {
        _surfaceIntersection = _surfaceIntersections select 0;
        _placementPosition = _surfaceIntersection select 0;
        _placementNormal = _surfaceIntersection select 1;
        _placementObject = _surfaceIntersection select 2;
        _placementIsOnSurface = true;
    }
    else
    {
        _endPosition = _sourcePositionASL vectorAdd (_directionVector vectorMultiply _maxGroundIntersectionDistance);
        _surfaceIntersection = [_endPosition, objNull, objNull] call BloodLust_GetSurfaceIntersection;
        _placementPosition = _surfaceIntersection select 2;
        _placementNormal = _surfaceIntersection select 1;
        _placementObject = _surfaceIntersection select 4;
        _placementIsOnSurface = !(isNull _placementObject);
    };

    _placementPosition = _placementPosition vectorAdd (_placementNormal vectorMultiply (random 0.01));

    [_placementPosition, _placementNormal, _placementIsOnSurface, _placementObject];
};

BloodLust_AssignSplatterToBuilding =
{
    _splatter = param [0, objNull];
    _surfaceObject = param [1, objNull];

    if(_surfaceObject isKindOf "Building") then
    {
        _surfaceObjectSplatters = _surfaceObject getVariable ["BloodLust_BloodSplatters", []];
        _surfaceObject setVariable ["BloodLust_BloodSplatters", _surfaceObjectSplatters + [_splatter]];
        _isKilledEventHandlerAssignedToSurfaceObject = _surfaceObject getVariable ["BloodLust_IsKilledEventHandlerAssigned", false];
        if(!_isKilledEventHandlerAssignedToSurfaceObject) then
        {
            _surfaceObject setVariable ["BloodLust_IsKilledEventHandlerAssigned", true];
            _surfaceObject addEventHandler ["Killed",
            {
                _object = _this select 0;
                _attachedSplatters = _object getVariable ["BloodLust_BloodSplatters", []];
                {
                    BloodLust_BloodSplatters = BloodLust_BloodSplatters - [_x];
                    deleteVehicle _x;
                } foreach _attachedSplatters;
            }];
        };
    };
};

BloodLust_CreateBloodSplatter =
{
    _object = _this select 0;
    _positionASL = _this select 1;
    _normalDirection = _this select 2;
    _intersectionDistance = _this select 3;
    _splatterAngle = _this select 4;
    _splatterTexture = _this select 5;
    _splatter = call BloodLust_CreateBloodSplatterObject;
    _splatterPosition = [0, 0, 0];
    _splatterNormal = [0, 0, 0];
    _intersectionEndPositionASL = _positionASL vectorAdd (_normalDirection vectorMultiply _intersectionDistance);
    _surfaceIntersections = lineIntersectsSurfaces
    [
        _positionASL,
        _intersectionEndPositionASL,
        _object,
        vehicle _object,
        true,
        10,
        "VIEW",
        "NONE"
    ] select {
        _intersectingObject  = _x select 2;
        _isObjectInIntersectionBlackList = [typeOf _intersectingObject, (getModelInfo _intersectingObject) select 0] call BloodLust_IsClassInIntersectionBlackList;
        _return = !_isObjectInIntersectionBlackList;
        _return;
    };

    if(count _surfaceIntersections > 0) then
    {
        _surfaceIntersection = _surfaceIntersections select 0;
        _splatterPosition = _surfaceIntersection select 0;
        _splatterNormal = _surfaceIntersection select 1;
        _surfaceObject = _surfaceIntersection select 2;
        _surfaceIntersectionGround = [_positionASL vectorAdd (_normalDirection vectorMultiply BloodLust_BloodSplatterGroundMaxDistance), _object, vehicle _object] call BloodLust_GetSurfaceIntersection;
        _surfaceDistance = _surfaceIntersectionGround select 0;
        if(_surfaceDistance > 0.1) then
        {
            [_splatter, _surfaceObject] call BloodLust_AssignSplatterToBuilding;
        };
    }
    else
    {
        _surfaceIntersection = [_positionASL vectorAdd (_normalDirection vectorMultiply BloodLust_BloodSplatterGroundMaxDistance), _object, vehicle _object] call BloodLust_GetSurfaceIntersection;
        _splatterNormal = _surfaceIntersection select 1;
        _splatterPosition = _surfaceIntersection select 2;
    };

    _splatter setObjectTexture [0, _splatterTexture];
    _splatter setPosASL (_splatterPosition vectorAdd (_splatterNormal vectorMultiply 0.01));
    [_splatter, _splatterNormal, _splatterAngle] call BloodLust_RotateObjectAroundNormal;

    {
        [_splatter] call _x;
    } foreach BloodLust_OnBloodSplatterCreatedEventHandlers;
};

BloodLust_CreateBloodSplatterObject =
{
    if(call BloodLust_IsMaxBloodSplattersReached) then
    {
        call BloodLust_RemoveOldBloodSplatter;
    };

    _splatter = objNull;
    if(isMultiplayer) then
    {
        _splatter = "BloodSplatter_Plane" createVehicleLocal [0, 0, 0];
    }
    else
    {
        _splatter = createSimpleObject ["BloodSplatter_Plane", [0, 0, 0]];
    };

    BloodLust_BloodSplatters pushBack _splatter;
    _splatter;
};

BloodLust_CreateLargeBloodSplatterObject =
{
    if(call BloodLust_IsMaxBloodSplattersReached) then
    {
        call BloodLust_RemoveOldBloodSplatter;
    };

    _splatter = objNull;
    if(isMultiplayer) then
    {
        _splatter = "BloodSplatter_LargePlane" createVehicleLocal [0, 0, 0];
    }
    else
    {
        _splatter = createSimpleObject ["BloodSplatter_LargePlane", [0, 0, 0]];
    };

    BloodLust_BloodSplatters pushBack _splatter;
    _splatter;
};

BloodLust_CreateBloodSmearObject =
{
    if(call BloodLust_IsMaxBleedSplattersReached) then
    {
        call BloodLust_RemoveOldBleedSplatter;
    };

    _smear = objNull;
    if(isMultiplayer) then
    {
        _smear = "BloodSplatter_SmallPlane" createVehicleLocal [0, 0, 0];
    }
    else
    {
        _smear = createSimpleObject ["BloodSplatter_SmallPlane", [0, 0, 0]];
    };

    BloodLust_BleedSplatters pushBack _smear;
    _smear;
};

BloodLust_CreateBleedSplatterObject =
{
    if(call BloodLust_IsMaxBleedSplattersReached) then
    {
        call BloodLust_RemoveOldBleedSplatter;
    };

    _splatter = objNull;
    if(isMultiplayer) then
    {
        _splatter = "BloodSplatter_SmallPlane" createVehicleLocal [0, 0, 0];
    }
    else
    {
        _splatter = createSimpleObject ["BloodSplatter_SmallPlane", [0, 0, 0]];
    };

    BloodLust_BleedSplatters pushBack _splatter;
    _splatter;
};

BloodLust_CreateTinyBleedSplatterObject =
{
    if(call BloodLust_IsMaxBleedSplattersReached) then
    {
        call BloodLust_RemoveOldBleedSplatter;
    };

    _splatter = objNull;
    if(isMultiplayer) then
    {
        _splatter = "BloodSplatter_TinyPlane" createVehicleLocal [0, 0, 0];
    }
    else
    {
        _splatter = createSimpleObject ["BloodSplatter_TinyPlane", [0, 0, 0]];
    };

    BloodLust_BleedSplatters pushBack _splatter;
    _splatter;
};

BloodLust_CreateGibObject =
{
    _classname = _this;
    if(call BloodLust_IsMaxGibsReached) then
    {
        call BloodLust_RemoveOldGib;
    };
    _gib = _classname createVehicleLocal [0,0,0];
    BloodLust_Gibs pushBack _gib;
    _gib;
};

BloodLust_CleanUp =
{
    _playerPosition = position (vehicle player);

    {
        if(_x distance _playerPosition >= BloodLust_CleanUpDistance) then
        {
            BloodLust_BloodSplatters = BloodLust_BloodSplatters - [_x];
            deleteVehicle _x;
        };
    } foreach BloodLust_BloodSplatters;

    {
        if(_x distance _playerPosition >= BloodLust_CleanUpDistance) then
        {
            BloodLust_BleedSplatters = BloodLust_BleedSplatters - [_x];
            deleteVehicle _x;
        };
    } foreach BloodLust_BleedSplatters;

    {
        if(_x distance _playerPosition >= BloodLust_CleanUpDistance) then
        {
            BloodLust_Gibs = BloodLust_Gibs - [_x];
            deleteVehicle _x;
        };
    } foreach BloodLust_Gibs;
};
