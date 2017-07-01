//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer

_VaporizedUnitMessage =
{
	_unit = _this select 0;
	_damage = _this select 1;
	_isUnitVaporized = _unit getVariable ["BloodLust_IsVaporized", false];
    if(_isUnitVaporized) then
    {
       player globalChat (format ["Oh dear, %1 exploded :O", name _unit]);
    };
};

BloodLust_OnUnitExplosionPostEventHandlers pushBack _VaporizedUnitMessage;
