BloodLust_CleanUp =
{
    _playerPosition = position (vehicle player);

    {
        if(_x distance _playerPosition >= BloodLust_CleanUpDistance) then
        {
            BloodLust_BloodSplatters = BloodLust_BloodSplatters - [_x];
            deleteVehicle _x;
        };
    } foreach BloodLust_BloodSplatters;

    {
        if(_x distance _playerPosition >= BloodLust_CleanUpDistance) then
        {
            BloodLust_BleedSplatters = BloodLust_BleedSplatters - [_x];
            deleteVehicle _x;
        };
    } foreach BloodLust_BleedSplatters;

    {
        if(_x distance _playerPosition >= BloodLust_CleanUpDistance) then
        {
            BloodLust_Gibs = BloodLust_Gibs - [_x];
            deleteVehicle _x;
        };
    } foreach BloodLust_Gibs;
};

// Cleanup Loop.
BloodLust_CleanUpPlayerPosition = position (vehicle player);
[{
    if(BloodLust_IsCleanUpEnabled && (vehicle player) distance BloodLust_CleanUpPlayerPosition >= BloodLust_CleanUpDistance) then
    {
        BloodLust_CleanUpPlayerPosition = position (vehicle player);
        call BloodLust_CleanUp;
    };
}, BloodLust_CleanUpDelay, []] call CBA_fnc_addPerFrameHandler;
