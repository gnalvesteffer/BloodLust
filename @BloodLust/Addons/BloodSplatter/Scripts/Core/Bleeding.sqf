BloodLust_BleedSplatters = [];

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

    _selectionName = selectRandom (_selections select { _x select [0, 3] != "Hit" });
    if (isNil "_selectionName") exitWith {};

    _endTime           = time + _duration;
    _arterialBloodSprayEndTime = time + BloodLust_ArterialBloodSprayDuration;
    _initialUnitDamage = damage _target;
    _bleedSmearEndTime = time + BloodLust_BleedSmearDuration;
    _target setVariable [format ["BloodLust_NextBleedTime_%1", _selectionName], [0] call BloodLust_GetNextBleedTime];
    _target setVariable [format ["BloodLust_NextSmearTime_%1", _selectionName], [0] call BloodLust_GetNextSmearTime];

    [
        BloodLust_BleedingFrameHandler,
        0,
        [
            _target,
            _initialUnitDamage,
            _velocity,
            _selectionName,
            _bulletVectorDir,
            _bulletVectorUp,
            _endTime,
            _arterialBloodSprayEndTime,
            _bleedSmearEndTime
        ]
    ] call CBA_fnc_addPerFrameHandler;
};

BloodLust_BleedingFrameHandler =
{
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
    _nextSmearTime = _target getVariable [format ["BloodLust_NextSmearTime_%1", _selectionName], 0];
    _splatterAngle = random 360;
    _bleedProgress = 1 - ((_endTime - time) / _endTime);
    _smearProgress = 1 - ((_bleedSmearEndTime - time) / _bleedSmearEndTime);
    _isBleedingFinished = 
        (BloodLust_IsBleedingTiedToUnitState && !isBleeding _target) || 
        (!BloodLust_IsBleedingTiedToUnitState && (time >= _endTime || (damage _target < _initialUnitDamage))) ||
        (_target getVariable ["BloodLust_IsVaporized", false]);

    if(_isBleedingFinished) exitWith
    {
        {
            [_target] call _x;
        } foreach BloodLust_OnUnitBleedPostEventHandlers;
        [_this select 1] call CBA_fnc_removePerFrameHandler;
    };

    if (!BloodLust_IsSplatteringEnabledForUnitsInVehicles && vehicle _target != _target) exitWith {}; // unit is in vehicle

    _selectionPosition = _target selectionPosition [_selectionName, "HitPoints"];
    _hitPointPosition = AGLToASL(_target modelToWorld _selectionPosition);
    _projectileDirection = vectorNormalized _projectileVelocity;
    _intersectionEndPosition = AGLToASL((_target modelToWorld _selectionPosition) vectorAdd (_projectileDirection vectorMultiply 0.3));
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
        !_isObjectInIntersectionBlackList;
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

    if(count _surfaceIntersections == 0) then
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

    if(count _surfaceIntersections > 0 && time <= _bleedSmearEndTime) then // Perform bleed smearing.
    {
        if (time >= _nextSmearTime) then
        {
            _previousSmearPosition = _target getVariable [format ["BloodLust_PreviousBleedSmearPosition_%1", _selectionName], [0, 0, 0]];
            _surfaceIntersection = _surfaceIntersections select 0;
            _surfacePosition = _surfaceIntersection select 0;
            _surfaceNormal = _surfaceIntersection select 1;
            _splatterPosition = _surfacePosition vectorAdd (_surfaceNormal vectorMultiply 0.01);

            if(_splatterPosition distance _previousSmearPosition >= BloodLust_BleedSmearSpacing) then
            {
                _splatterAngle = ([_splatterPosition, _previousSmearPosition] call BIS_fnc_dirTo) + 90;
                _splatter = call BloodLust_CreateBloodSmearObject;
                _splatter setObjectTexture [0, selectRandom BloodLust_SmearTextures];
                _splatter setPosASL _splatterPosition;
                [_splatter, _surfaceNormal, _splatterAngle] call BloodLust_RotateObjectAroundNormal;

                {
                    [_splatter] call _x;
                } foreach BloodLust_OnSmearSplatterCreatedEventHandlers;

                _target setVariable [format ["BloodLust_PreviousBleedSmearPosition_%1", _selectionName], _splatterPosition];
                _target setVariable [format ["BloodLust_NextBleedTime_%1", _selectionName], [_bleedProgress] call BloodLust_GetNextBleedTime];
                _target setVariable [format ["BloodLust_NextSmearTime_%1", _selectionName], [_smearProgress] call BloodLust_GetNextSmearTime];
            };
        };
    }
    else // Perform bleed droplet or blood pooling.
    {
        if (time >= _nextBleedTime) then
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

            if(_surfaceDistance > 0.3) then // Perform bleed droplet because blood is dropping far enough from surface / bleeding is not in contact with a surface.
            {
                _splatterPosition = _surfacePosition vectorAdd (_surfaceNormal vectorMultiply 0.01);
                _splatter = call BloodLust_CreateTinyBleedSplatterObject;
                _splatter setObjectTexture [0, selectRandom BloodLust_BleedTextures];
                _splatter setPosASL _splatterPosition;
                [_splatter, _surfaceNormal, _splatterAngle] call BloodLust_RotateObjectAroundNormal;

                {
                    [_splatter] call _x;
                } foreach BloodLust_OnBleedSplatterCreatedEventHandlers;

                [selectRandom BloodLust_BleedSounds, _splatter, false, _splatterPosition, _surfaceDistance / (BloodLust_BleedSoundAudibleVolume max 1), 1, BloodLust_BleedSoundAudibleDistance] call BloodLust_PlaySound;
                _target setVariable [format ["BloodLust_NextBleedTime_%1", _selectionName], [_bleedProgress] call BloodLust_GetNextBleedTime];
                _target setVariable [format ["BloodLust_NextSmearTime_%1", _selectionName], [_smearProgress] call BloodLust_GetNextSmearTime];

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
            else // Perform blood pool because bleeding is occurring in contact with surface.
            {
                if(BloodLust_IsBloodPoolingEnabled) then 
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
    };
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

BloodLust_GetNextBleedTime =
{
    params ["_bleedProgress"];
    (
        time +
        (BloodLust_BleedFrequency + (random BloodLust_BleedFrequencyVariance)) +
        (_bleedProgress * BloodLust_BleedFrequencySlowdownAmount)
    );
};

BloodLust_GetNextSmearTime =
{
    params ["_smearProgress"];
    (
        time +
        (BloodLust_BleedFrequency + (random BloodLust_BleedFrequencyVariance)) +
        (_smearProgress * BloodLust_BleedSmearFrequencySlowdownAmount)
    );
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

BloodLust_IsMaxBleedSplattersReached =
{
    _return = false;
    if(count BloodLust_BleedSplatters >= BloodLust_MaxBleedSplatters) then
    {
        _return = true;
    };
    _return;
};

BloodLust_RemoveOldBleedSplatter =
{
    if(count BloodLust_BleedSplatters > 0) then
    {
        _splatter = BloodLust_BleedSplatters select 0;
        BloodLust_BleedSplatters deleteAt 0;
        deleteVehicle _splatter;
    };
};