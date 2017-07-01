//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer

_HighDamageVaporization =
{
	_selection = _this select 0;
	_target = _selection select 0;
	_ammo = _selection select 6;
	_hitValue = _ammo select 0;

	if(_hitValue >= 50) then
	{
		[_unit, _damage] call BloodLust_VaporizeUnit;
	};
};

BloodLust_OnUnitHitPartPostEventHandlers pushBack _HighDamageVaporization;
