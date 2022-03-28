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

BloodLust_GetSelectionWorldPositionASL =
{
    params ["_unit", "_selection"];
    _selectionModelPosition = _unit selectionPosition _selection;
    AGLToASL (_unit modelToWorld _selectionModelPosition);
}