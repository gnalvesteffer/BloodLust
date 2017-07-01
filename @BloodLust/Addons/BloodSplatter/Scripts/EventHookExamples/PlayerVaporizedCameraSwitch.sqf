//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer

_PlayerVaporizedCameraSwitch =
{
    _unit = _this select 0;
    _gibForce = _this select 1;
    _gibs = _this select 2;
    _bloodSplatters = _this select 3;

    if(_unit == player) then
    {
        _focusedGib = selectRandom _gibs;
        _focusedGib switchCamera "External";
    };
};

BloodLust_OnUnitVaporizedEventHandlers pushBack _PlayerVaporizedCameraSwitch;
