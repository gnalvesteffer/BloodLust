//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer

_UnitVehicleExplosion =
{
    _unit = _this select 0;
    _vehicle = vehicle _unit;
    _isUnitInVehicle = _vehicle != _unit;
    if(_isUnitInVehicle && damage _vehicle == 1) then
    {
        _fuelExplosionPower = getNumber (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "fuelExplosionPower");
        if(_fuelExplosionPower >= 1) then
        {
            [_unit, _fuelExplosionPower] call BloodLust_VaporizeUnit;
        };
    };
};

BloodLust_OnUnitKilledPostEventHandlers pushBack _UnitVehicleExplosion;
