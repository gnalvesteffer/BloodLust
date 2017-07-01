//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer

/*
    If you are putting BloodLust on a server and want to change
    the settings that get applied to your clients, you will have
    to modify this file and repack the addon.
*/

if(isNil "BloodLust_IsServerSettingsBroadcastedMP") then
{
    BloodLust_VaporizationDamageThresholdMP = 1;
    BloodLust_ExplosionDamageThresholdMP = 0.2;
    BloodLust_IsVaporizationEnabledMP = true;
    BloodLust_IsVaporizationGibsEnabledMP = false; //May cause bad performance.
};

//Broadcast the server's values to all clients.
if(isServer) then
{
    BloodLust_IsServerSettingsBroadcastedMP = true;
    publicVariable "BloodLust_IsServerSettingsBroadcastedMP";
    publicVariable "BloodLust_VaporizationDamageThresholdMP";
    publicVariable "BloodLust_ExplosionDamageThresholdMP";
    publicVariable "BloodLust_IsVaporizationEnabledMP";
    publicVariable "BloodLust_IsVaporizationGibsEnabledMP";
};
