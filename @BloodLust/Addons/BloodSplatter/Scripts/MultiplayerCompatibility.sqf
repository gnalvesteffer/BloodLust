//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer
//Overrides and adds certain functionality for multiplayer compatibility.

BloodLust_InitUnit =
{
    _unit = _this select 0;
    [_unit] call BloodLust_AddUnitEventHandlers;
};

BloodLust_OnUnitRespawn =
{
    _unit = _this select 0;
    _corpse = _this select 1;
    [_unit] remoteExec ["BloodLust_AddUnitEventHandlers"];
};

BloodLust_AddUnitEventHandlers =
{
    _unit = _this select 0;
    _unit setVariable ["BloodLust_HitPartEventHandlerIndex", _unit addEventHandler ["HitPart",
    {
        _this remoteExec ["BloodLust_OnUnitHitPart"]; //HitPart only triggers on the machine where the unit is local, which is why it is being broadcasted here.
    }]];
    _unit setVariable ["BloodLust_ExplosionEventHandlerIndex", _unit addEventHandler ["Explosion",
    {
        _this remoteExec ["BloodLust_OnUnitExplosion"]; //Explosion only triggers on the machine where the unit is local, which is why it is being broadcasted here.
    }]];
};