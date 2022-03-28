BloodLust_Gibs = [];

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

BloodLust_GetGibClassnames =
{
    _unit          = _this select 0;
    _selections    = _this select 1;
    _gibClassnames = [];

    if("head" in _selections) then
    {
        if((_unit getHitIndex 2) call BloodLust_GetSplatterTextureSetIndexFromDamage != -1) then
        {
            _gibClassnames = _gibClassnames + BloodLust_HeadGibClassnames;
        };
    };
    if("spine1" in _selections) then
    {
        if((_unit getHitIndex 4) call BloodLust_GetSplatterTextureSetIndexFromDamage != -1) then
        {
            _gibClassnames = _gibClassnames + BloodLust_Spine1GibClassnames;
        };
    };
    if("spine2" in _selections) then
    {
        if((_unit getHitIndex 5) call BloodLust_GetSplatterTextureSetIndexFromDamage != -1) then
        {
            _gibClassnames = _gibClassnames + BloodLust_Spine2GibClassnames;
        };
    };
    if("spine3" in _selections) then
    {
        if((_unit getHitIndex 6) call BloodLust_GetSplatterTextureSetIndexFromDamage != -1) then
        {
            _gibClassnames = _gibClassnames + BloodLust_Spine3GibClassnames;
        };
    };
    if("body" in _selections) then
    {
        if((_unit getHitIndex 7) call BloodLust_GetSplatterTextureSetIndexFromDamage != -1) then
        {
            _gibClassnames = _gibClassnames + BloodLust_BodyGibClassnames;
        };
    };
    if("leftarm" in _selections) then
    {
        if((_unit getHitIndex 9) call BloodLust_GetSplatterTextureSetIndexFromDamage != -1) then
        {
            _gibClassnames = _gibClassnames + BloodLust_ArmGibClassnames;
        };
    };
    if("leftforearm" in _selections) then
    {
        if((_unit getHitIndex 9) call BloodLust_GetSplatterTextureSetIndexFromDamage != -1) then
        {
            _gibClassnames = _gibClassnames + BloodLust_ArmGibClassnames;
        };
    };
    if("rightarm" in _selections) then
    {
        if((_unit getHitIndex 9) call BloodLust_GetSplatterTextureSetIndexFromDamage != -1) then
        {
            _gibClassnames = _gibClassnames + BloodLust_ArmGibClassnames;
        };
    };
    if("rightforearm" in _selections) then
    {
        if((_unit getHitIndex 9) call BloodLust_GetSplatterTextureSetIndexFromDamage != -1) then
        {
            _gibClassnames = _gibClassnames + BloodLust_ArmGibClassnames;
        };
    };
    if("leftleg" in _selections) then
    {
        if((_unit getHitIndex 10) call BloodLust_GetSplatterTextureSetIndexFromDamage != -1) then
        {
            _gibClassnames = _gibClassnames + BloodLust_LegGibClassnames;
        };
    };
    if("leftupleg" in _selections) then
    {
        if((_unit getHitIndex 10) call BloodLust_GetSplatterTextureSetIndexFromDamage != -1) then
        {
            _gibClassnames = _gibClassnames + BloodLust_LegGibClassnames;
        };
    };
    if("rightleg" in _selections) then
    {
        if((_unit getHitIndex 10) call BloodLust_GetSplatterTextureSetIndexFromDamage != -1) then
        {
            _gibClassnames = _gibClassnames + BloodLust_LegGibClassnames;
        };
    };
    if("rightupleg" in _selections) then
    {
        if((_unit getHitIndex 10) call BloodLust_GetSplatterTextureSetIndexFromDamage != -1) then
        {
            _gibClassnames = _gibClassnames + BloodLust_LegGibClassnames;
        };
    };
    if("leftfoot" in _selections) then
    {
        if((_unit getHitIndex 10) call BloodLust_GetSplatterTextureSetIndexFromDamage != -1) then
        {
            _gibClassnames = _gibClassnames + BloodLust_LegGibClassnames;
        };
    };
    if("rightfoot" in _selections) then
    {
        if((_unit getHitIndex 10) call BloodLust_GetSplatterTextureSetIndexFromDamage != -1) then
        {
            _gibClassnames = _gibClassnames + BloodLust_LegGibClassnames;
        };
    };

    _gibClassnames;
};

BloodLust_IsMaxGibsReached =
{
    _return = false;
    if(count BloodLust_Gibs >= BloodLust_MaxGibs) then
    {
        _return = true;
    };
    _return;
};

BloodLust_RemoveOldGib =
{
    if(count BloodLust_Gibs > 0) then
    {
        _gib = BloodLust_Gibs select 0;
        deleteVehicle _gib;
        BloodLust_Gibs deleteAt 0;
    };
};
