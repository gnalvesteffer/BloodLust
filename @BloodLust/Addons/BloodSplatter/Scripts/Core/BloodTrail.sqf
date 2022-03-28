BloodLust_StartBloodTrail =
{
    params
    [
        "_unit",
        "_selection",
        "_duration"
    ];

    if (!isNil { _unit getVariable "BloodLust_PreviousBloodTrailPosition" }) exitWith {}; // blood trail already exists for unit + selection.
    _unit setVariable [format ["BloodLust_PreviousBloodTrailSelectionPosition-%1", _selection], [_unit, _selection] call BloodLust_GetSelectionWorldPositionASL];

    [
        {
            _args = _this select 0;
            _handle = _this select 1;
            _unit = _args select 0;
            _selection = _args select 1;
            _startTime = _args select 2;
            _duration = _args select 3;
            _previousSelectionPosition = _unit getVariable format ["BloodLust_PreviousBloodTrailSelectionPosition-%1", _selection];
            _currentSelectionPosition = [_unit, _selection] call BloodLust_GetSelectionWorldPositionASL;
            _trailLength = _currentSelectionPosition distance _previousSelectionPosition;
            _endTime = _startTime + _duration;

            if (time >= _endTime || _trailLength >= BloodLust_BloodTrailCancelDistance) exitWith
            {
                [_handle] call CBA_fnc_removePerFrameHandler;
            };

            if (alive _unit) exitWith {}; // Wait until unit is dead.

            // Create blood trails between previous and current selection position
            _previousPosition = _previousSelectionPosition;
            _iterations = floor (_trailLength / BloodLust_BloodTrailSpacing);
            if (_iterations > 0) then
            {
                for "_iteration" from 0 to _iterations do
                {
                    _currentPosition = [_previousSelectionPosition, _currentSelectionPosition, _iteration / _iterations] call BIS_fnc_lerpVector;
                    if (!(_currentPosition isEqualTo _previousPosition)) then
                    {
                        _splatterAngle = ([_currentPosition, _previousPosition] call BIS_fnc_dirTo) + 90;
                        _splatter =
                        [
                            _unit,
                            _currentPosition,
                            [0, 0, -1],
                            BloodLust_BloodSplatterIntersectionMaxDistance,
                            _splatterAngle,
                            selectRandom BloodLust_BloodTrailTextures,
                            call BloodLust_CreateBleedSplatterObject
                        ] call BloodLust_CreateBloodSplatter;
                        _previousPosition = _currentPosition;
                    };
                };
            };

            _unit setVariable [format ["BloodLust_PreviousBloodTrailSelectionPosition-%1", _selection], _currentSelectionPosition];
        },
        0.1,
        [
            _unit,
            _selection,
            time,
            _duration
        ]
    ] call CBA_fnc_addPerFrameHandler;
};
