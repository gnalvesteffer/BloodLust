BloodLust_InitVehicle =
{
    _vehicle = _this select 0;
    _vehicle addEventHandler ["Killed",
    {
        if(!BloodLust_IsBloodLustEnabled) exitWith {};
        {
            _this call _x;
        } foreach BloodLust_OnVehicleKilledPreEventHandlers;

        _this call BloodLust_OnVehicleKilled;

        {
            _this call _x;
        } foreach BloodLust_OnVehicleKilledPostEventHandlers;
    }];
};

BloodLust_OnVehicleKilled =
{
    _vehicle   = _this select 0;
    _killer = _this select 1;

    if(BloodLust_IsVehicleCrewVaporizationEnabled) then
    {
        [_vehicle] call BloodLust_VehicleCrewVaporization;
    };
};

BloodLust_VehicleCrewVaporization =
{
    _vehicle = _this select 0;
    _fuelExplosionPower = getNumber (configfile >> "CfgVehicles" >> (typeOf _vehicle) >> "fuelExplosionPower");
    if(_fuelExplosionPower >= 1) then
    {
        _crew = crew _vehicle;
        {
            [_x, _fuelExplosionPower] call BloodLust_VaporizeUnit;
        } foreach _crew;
    };
};