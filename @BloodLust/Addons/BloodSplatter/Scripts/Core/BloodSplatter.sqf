BloodLust_BloodSplatters = [];

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
    _splatter = _this select 6;

    if (isNil "_splatter") then
    {
        _splatter = call BloodLust_CreateBloodSplatterObject;
    };

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

BloodLust_CreateMediumBloodSplatterObject =
{
    if(call BloodLust_IsMaxBloodSplattersReached) then
    {
        call BloodLust_RemoveOldBloodSplatter;
    };

    _splatter = objNull;
    if(isMultiplayer) then
    {
        _splatter = "BloodSplatter_MediumPlane" createVehicleLocal [0, 0, 0];
    }
    else
    {
        _splatter = createSimpleObject ["BloodSplatter_MediumPlane", [0, 0, 0]];
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

BloodLust_GetSplatterTextures =
{
    _unit             = _this select 0;
    _selections       = _this select 1;
    _splatterTextures = [];

    if("head" in _selections) then
    {
        _textureSetIndex = (_unit getHitIndex 2) call BloodLust_GetSplatterTextureSetIndexFromDamage;
        if(_textureSetIndex != -1) then
        {
            _splatterTextures = _splatterTextures + (BloodLust_HeadSplatterTextures select _textureSetIndex);
        };
    };
    if("spine1" in _selections) then
    {
        _textureSetIndex = (_unit getHitIndex 4) call BloodLust_GetSplatterTextureSetIndexFromDamage;
        if(_textureSetIndex != -1) then
        {
            _splatterTextures = _splatterTextures + (BloodLust_Spine1SplatterTextures select _textureSetIndex);
        };
    };
    if("spine2" in _selections) then
    {
        _textureSetIndex = (_unit getHitIndex 5) call BloodLust_GetSplatterTextureSetIndexFromDamage;
        if(_textureSetIndex != -1) then
        {
            _splatterTextures = _splatterTextures + (BloodLust_Spine2SplatterTextures select _textureSetIndex);
        };
    };
    if("spine3" in _selections) then
    {
        _textureSetIndex = (_unit getHitIndex 6) call BloodLust_GetSplatterTextureSetIndexFromDamage;
        if(_textureSetIndex != -1) then
        {
            _splatterTextures = _splatterTextures + (BloodLust_Spine3SplatterTextures select _textureSetIndex);
        };
    };
    if("body" in _selections) then
    {
        _textureSetIndex = (_unit getHitIndex 7) call BloodLust_GetSplatterTextureSetIndexFromDamage;
        if(_textureSetIndex != -1) then
        {
            _splatterTextures = _splatterTextures + (BloodLust_BodySplatterTextures select _textureSetIndex);
        };
    };
    if("leftarm" in _selections) then
    {
        _textureSetIndex = (_unit getHitIndex 9) call BloodLust_GetSplatterTextureSetIndexFromDamage;
        if(_textureSetIndex != -1) then
        {
            _splatterTextures = _splatterTextures + (BloodLust_ArmSplatterTextures select _textureSetIndex);
        };
    };
    if("leftforearm" in _selections) then
    {
        _textureSetIndex = (_unit getHitIndex 9) call BloodLust_GetSplatterTextureSetIndexFromDamage;
        if(_textureSetIndex != -1) then
        {
            _splatterTextures = _splatterTextures + (BloodLust_ArmSplatterTextures select _textureSetIndex);
        };
    };
    if("rightarm" in _selections) then
    {
        _textureSetIndex = (_unit getHitIndex 9) call BloodLust_GetSplatterTextureSetIndexFromDamage;
        if(_textureSetIndex != -1) then
        {
            _splatterTextures = _splatterTextures + (BloodLust_ArmSplatterTextures select _textureSetIndex);
        };
    };
    if("rightforearm" in _selections) then
    {
        _textureSetIndex = (_unit getHitIndex 9) call BloodLust_GetSplatterTextureSetIndexFromDamage;
        if(_textureSetIndex != -1) then
        {
            _splatterTextures = _splatterTextures + (BloodLust_ArmSplatterTextures select _textureSetIndex);
        };
    };
    if("leftleg" in _selections) then
    {
        _textureSetIndex = (_unit getHitIndex 10) call BloodLust_GetSplatterTextureSetIndexFromDamage;
        if(_textureSetIndex != -1) then
        {
            _splatterTextures = _splatterTextures + (BloodLust_LegSplatterTextures select _textureSetIndex);
        };
    };
    if("leftupleg" in _selections) then
    {
        _textureSetIndex = (_unit getHitIndex 10) call BloodLust_GetSplatterTextureSetIndexFromDamage;
        if(_textureSetIndex != -1) then
        {
            _splatterTextures = _splatterTextures + (BloodLust_LegSplatterTextures select _textureSetIndex);
        };
    };
    if("rightleg" in _selections) then
    {
        _textureSetIndex = (_unit getHitIndex 10) call BloodLust_GetSplatterTextureSetIndexFromDamage;
        if(_textureSetIndex != -1) then
        {
            _splatterTextures = _splatterTextures + (BloodLust_LegSplatterTextures select _textureSetIndex);
        };
    };
    if("rightupleg" in _selections) then
    {
        _textureSetIndex = (_unit getHitIndex 10) call BloodLust_GetSplatterTextureSetIndexFromDamage;
        if(_textureSetIndex != -1) then
        {
            _splatterTextures = _splatterTextures + (BloodLust_LegSplatterTextures select _textureSetIndex);
        };
    };
    if("leftfoot" in _selections) then
    {
        _textureSetIndex = (_unit getHitIndex 10) call BloodLust_GetSplatterTextureSetIndexFromDamage;
        if(_textureSetIndex != -1) then
        {
            _splatterTextures = _splatterTextures + (BloodLust_LegSplatterTextures select _textureSetIndex);
        };
    };
    if("rightfoot" in _selections) then
    {
        _textureSetIndex = (_unit getHitIndex 10) call BloodLust_GetSplatterTextureSetIndexFromDamage;
        if(_textureSetIndex != -1) then
        {
            _splatterTextures = _splatterTextures + (BloodLust_LegSplatterTextures select _textureSetIndex);
        };
    };

    _splatterTextures;
};

//Returns the index of the splatter texture set (small, medium, large) depending on the damage of a body part.
BloodLust_GetSplatterTextureSetIndexFromDamage =
{
    _damage = _this;
    _textureSetIndex = -1;

    if(_damage <= 0.33) then
    {
       _textureSetIndex = 2;
    }
    else
    {
        if(_damage <= 0.66) then
        {
            _textureSetIndex = 1;
        }
        else
        {
            if(_damage <= 1) then
            {
                _textureSetIndex = 0;
            };
        };
    };

    _textureSetIndex;
};

BloodLust_IsClassInIntersectionBlackList =
{
    _class = _this select 0;
    _model = _this select 1;
    _return = false;
    if(isNil "_model") then
    {
        _model = "lolnope.exe";
    };

    if(_model in BloodLust_BloodSplatterIntersectionBlackList || _class in BloodLust_BloodSplatterIntersectionBlackList) then
    {
        _return = true;
    }
    else
    {
        {
            if(_class isKindOf _x) exitWith
            {
                _return = true;
            };
        } foreach BloodLust_BloodSplatterIntersectionBlackList;
    };

    _return;
};

BloodLust_IsMaxBloodSplattersReached =
{
    _return = false;
    if(count BloodLust_BloodSplatters >= BloodLust_MaxBloodSplatters) then
    {
        _return = true;
    };
    _return;
};

BloodLust_RemoveOldBloodSplatter =
{
    if(count BloodLust_BloodSplatters > 0) then
    {
        _splatter = BloodLust_BloodSplatters select 0;
        deleteVehicle _splatter;
        BloodLust_BloodSplatters deleteAt 0;
    };
};