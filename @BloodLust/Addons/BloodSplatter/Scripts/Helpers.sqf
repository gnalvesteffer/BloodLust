//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer

//Returns: [vectorDir, vectorUp]
BloodLust_RotateAroundNormal =
{
    _normal = param [0];
    _angle = param [1];
    [[sin _angle, cos _angle, sin _angle * cos _angle] vectorCrossProduct _normal, _normal];
};

BloodLust_RotateObjectAroundNormal =
{
    _object = param [0];
    _normal = param [1];
    _angle = param [2];

    _object setVectorDirAndUp ([_normal, _angle] call BloodLust_RotateAroundNormal);
};

BloodLust_GetSurfaceIntersection =
{
    _positionASL = _this select 0;
    _ignoreObject1   = _this select 1;
    _ignoreObject2   = _this select 2;
    _surfaceDistance = 0;
    _surfaceNormal   = [0, 0, 0];
    _surfacePosition = [0, 0, 0];
    _isIntersecting = false;
    _intersectingObject = objNull;
    _intersections = lineIntersectsSurfaces [
        _positionASL,
        _positionASL vectorAdd [0, 0, -100],
        _ignoreObject1,
        _ignoreObject2,
        true,
        10,
        "GEOM",
        "FIRE"
    ];
    _filteredIntersections = _intersections select {
        !([(typeOf (_x select 2)), (getModelInfo (_x select 2)) select 0] call BloodLust_IsClassInIntersectionBlackList);
    };

    if(count _filteredIntersections > 0) then
    {
        _intersection    = _filteredIntersections select 0;
        _surfacePosition = _intersection select 0;
        _surfaceNormal   = _intersection select 1;
        _intersectingObject = _intersection select 2;
        _surfaceDistance = (_positionASL select 2) - (_surfacePosition select 2);
        _isIntersecting = true;
    };

    [_surfaceDistance, _surfaceNormal, _surfacePosition, _isIntersecting, _intersectingObject];
};

BloodLust_GetNextBleedTime =
{
    _return = time + (BloodLust_BleedFrequency + (random BloodLust_BleedFrequencyVariance));
    _return;
};

BloodLust_GetVelocityMagnitude =
{
    _object = param [0];
    _return = vectorMagnitude (velocity _object);
    _return;
};

BloodLust_IsObjectCompletelyOnSurface =
{
    _object                      = _this select 0;
    _normal                      = _this select 1;
    _checkDistance               = _this select 2;
    _boundingBoxScale = _this select 3;
    _boundingBoxDimensionsHalf   = (_object call BIS_fnc_boundingBoxDimensions) vectorMultiply _boundingBoxScale;
    _isObjectCompletelyOnSurface = true;
    _positions                   =
    [
        AGLToASL(_object modelToWorldVisual [-(_boundingBoxDimensionsHalf select 0), _boundingBoxDimensionsHalf select 1, 0]),
        AGLToASL(_object modelToWorldVisual [_boundingBoxDimensionsHalf select 0, _boundingBoxDimensionsHalf select 1, 0]),
        AGLToASL(_object modelToWorldVisual [-(_boundingBoxDimensionsHalf select 0), -(_boundingBoxDimensionsHalf select 1), 0]),
        AGLToASL(_object modelToWorldVisual [_boundingBoxDimensionsHalf select 0, -(_boundingBoxDimensionsHalf select 1), 0])
    ];

    {
        _isIntersecting = lineIntersects [_x vectorAdd (_normal vectorMultiply 0.1), _x vectorDiff (_normal vectorMultiply _checkDistance)];
        if(!_isIntersecting) exitWith
        {
            _isObjectCompletelyOnSurface = false;
        }
    } foreach _positions;
    _isObjectCompletelyOnSurface;
};

BloodLust_AnimateObjectTexture =
{
    _textures = _this select 0;
    _frameRate = _this select 1;
    _isLoop = _this select 2;
    _deleteObjectAfterEndOfAnimation = _this select 3;
    _object = _this select 4;
    _deletionFunction = _this select 5;
    _startTime = time;
    _duration = (count _textures) / _frameRate;
    _durationPerFrame = _duration / (count _textures);

    [{
        _args = _this select 0;
        _eventHandlerId = _this select 1;
        _textures = _args select 0;
        _frameRate = _args select 1;
        _isLoop = _args select 2;
        _deleteObjectAfterEndOfAnimation = _args select 3;
        _object = _args select 4;
        _startTime = _args select 5;
        _durationPerFrame = _args select 6;
        _deletionFunction = _args select 7;
        _frameIndex = (floor((time - _startTime) / _durationPerFrame)) min ((count _textures) - 1);
        _currentFrameIndex = _object getVariable ["BloodLust_CurrentFrameIndex", _frameIndex];

        if(isNull _object) then
        {
            [_eventHandlerId] call CBA_fnc_removePerFrameHandler;
        }
        else
        {
            if(_currentFrameIndex >= ((count _textures) - 1)) then
            {
                if(_isLoop) then
                {
                    _object setVariable ["BloodLust_CurrentFrameIndex", 0];
                }
                else
                {
                    if(_deleteObjectAfterEndOfAnimation) then
                    {
                        _object call _deletionFunction;
                        deleteVehicle _object;
                    };
                    [_eventHandlerId] call CBA_fnc_removePerFrameHandler;
                };
            }
            else
            {
                if(_frameIndex != _currentFrameIndex) then
                {
                    _object setObjectTexture [0, _textures select _currentFrameIndex];
                };
                _object setVariable ["BloodLust_CurrentFrameIndex", _frameIndex];
            };
        };
    }, 1 / _frameRate, [_textures, _frameRate, _isLoop, _deleteObjectAfterEndOfAnimation, _object, _startTime, _durationPerFrame, _deletionFunction]] call CBA_fnc_addPerFrameHandler;
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

BloodLust_IsMaxBloodSplattersReached =
{
    _return = false;
    if(count BloodLust_BloodSplatters >= BloodLust_MaxBloodSplatters) then
    {
        _return = true;
    };
    _return;
};

BloodLust_IsMaxArterialBloodSpraysReached =
{
    _return = false;
    if(count BloodLust_ArterialBloodSprays >= BloodLust_MaxArterialBloodSprays) then
    {
        _return = true;
    };
    _return;
};

BloodLust_RemoveOldArterialBloodSpray =
{
    if(count BloodLust_ArterialBloodSprays > 0) then
    {
        _spray = BloodLust_ArterialBloodSprays select 0;
        deleteVehicle _spray;
        BloodLust_ArterialBloodSprays deleteAt 0;
    };
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

BloodLust_IsMaxBloodSpraysReached =
{
    _return = false;
    if(count BloodLust_BloodSprays >= BloodLust_MaxBloodSprays) then
    {
        _return = true;
    };
    _return;
};

BloodLust_RemoveOldBloodSpray =
{
    if(count BloodLust_BloodSprays > 0) then
    {
        _spray = BloodLust_BloodSprays select 0;
        deleteVehicle _spray;
        BloodLust_BloodSprays deleteAt 0;
    };
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

//Because playSound3D is broadcasted to everyone, this will ensure that only one machine executes the broadcast.
BloodLust_PlaySound =
{
    _soundPath = param [0];
    _object = param [1];
    _isInside = param [2];
    _position = param [3];
    _volume = param [4];
    _pitch = param [5];
    _distance = param [6];

    if(local _object) then
    {
        playSound3D [_soundPath, _object, _isInside, _position, _volume, _pitch, _distance];
    };
};
