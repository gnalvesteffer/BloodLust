//Adds BloodLust effects to unit.
BloodLust_InitUnit =
{
    _unit = _this select 0;

    _hitPartEventHandlerIndex = _unit addEventHandler ["HitPart",
    {
        if(!BloodLust_IsBloodLustEnabled || count _this > 1) exitWith {}; //Probably an explosion -- let the explosion handler deal with this.

        _unit = (_this select 0) select 0;

        if (!BloodLust_IsBloodLustEnabledForDeadUnits && !alive _unit) exitWith {};
        if (!BloodLust_IsSplatteringEnabledForUnitsInVehicles && vehicle _unit != _unit) exitWith {};

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
        };
    };

    if(random 1 <= BloodLust_BloodSplatterProbability) then
    {
        _splatterTextures = [_target, _selections] call BloodLust_GetSplatterTextures;
        if(count _splatterTextures == 0) exitWith {};
        _splatterJitter =
        [
            BloodLust_BloodSplatterJitterAmount - (random (BloodLust_BloodSplatterJitterAmount * 2)),
            BloodLust_BloodSplatterJitterAmount - (random (BloodLust_BloodSplatterJitterAmount * 2)),
            BloodLust_BloodSplatterJitterAmount - (random (BloodLust_BloodSplatterJitterAmount * 2))
        ];

        // Splatter that spawns under the character.
        if (BloodLust_IsUnderCharacterBloodSplatterEnabled) then
        {
            [
                _target,
                _hitPosition,
                _splatterJitter,
                BloodLust_BloodSplatterIntersectionMaxDistance,
                (direction _bullet + 90) + random BloodLust_BloodSplatterAngleJitterAmount,
                selectRandom _splatterTextures,
                call BloodLust_CreateMediumBloodSplatterObject
            ] call BloodLust_CreateBloodSplatter;
        };

        // Blood Trail creation on death.
        if (BloodLust_IsBloodTrailEnabled && random 1 <= BloodLust_BloodTrailProbability) then
        {
            {
                if (BloodLust_BloodTrailTriggeringSelections find _x != -1) exitWith
                {
                    [_target, _x, BloodLust_BloodTrailDuration] call BloodLust_StartBloodTrail;
                }
            } forEach _selections;
        };

        for "_i" from 1 to _bloodSplatterIterations do
        {
            // Intersecting surface splatter.
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