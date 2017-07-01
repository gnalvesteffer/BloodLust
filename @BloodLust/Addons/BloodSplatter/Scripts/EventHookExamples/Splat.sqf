//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer

//Make units go splat when they hit the ground at high speed.
BloodLust_OnUnitKilledPostEventHandlers pushBack
{
    _unit = _this select 0;
    _killer = _this select 1;
    _isUnitOnFoot = vehicle _unit == _unit;
    _unitVelocity = velocity _unit;
    _unitVelocityMagnitude = vectorMagnitude _unitVelocity;
    if(_unit == _killer && _isUnitOnFoot && _unitVelocityMagnitude >= 20) then
    {
        [_unit, _unitVelocityMagnitude * 0.2] call BloodLust_VaporizeUnit;
    };
};
