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
    if (BloodLust_MaxGibs > 0) then
    {
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
        _largeSplatter setPosASL (_unitSurfacePosition vectorAdd (_unitSurfaceNormal vectorMultiply 0.05));
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

BloodLust_IsAmmoInVaporizationWhitelist =
{
    _ammoClass = _this;
    _return    = false;

    {
        if(_ammoClass == _x || _ammoClass isKindOf _x) exitWith
        {
            _return = true;
        };
    } foreach BloodLust_VaporizationAmmoClassnames;

    _return;
};
