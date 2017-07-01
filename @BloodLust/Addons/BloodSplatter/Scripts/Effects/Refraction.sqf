//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer

//Usage: [_object, _duration] call BloodLust_RefractionEffect;
BloodLust_RefractionEffect =
{
    _object = _this select 0;
    _duration = _this select 1;
    if(isNil "_object") exitWith {};

    _source = "#particlesource" createVehicleLocal getPos _object;
    _source attachTo [_object];
    _source setParticleParams
    [
        ["\A3\data_f\ParticleEffects\Universal\Refract",1,0,1],
        "",
        "billboard",
        0,
        _duration,
        [0,0,0],
        [0,0,2],
        0,10.30,1,-0.1,
        [0,6],
        [[0.0, 0, 0, 0.3], [0.0, 0, 0, 0.15], [0.0, 0, 0, 0.05], [0.0, 0, 0, 0.0]],
        [0.01],
        0.01,
        0.08,
        "",
        "",
        _object,
        0,
        true,
        0.5,
        [[0.5,0,0,1]]
    ];
     _source setDropInterval 1;
     _endTime = time + _duration;
    [{
        _args = _this select 0;
        _source = _args select 0;
        _endTime = _args select 1;
        if(time >= _endTime) then
        {
            deleteVehicle _source;
            [_this select 1] call CBA_fnc_removePerFrameHandler;
        };
    }, 0, [_source, _endTime]] call CBA_fnc_addPerFrameHandler;
};
