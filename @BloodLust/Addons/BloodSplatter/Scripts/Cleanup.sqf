BloodLust_CleanUpPlayerPosition = position (vehicle player);
[{
    if(BloodLust_IsCleanUpEnabled && (vehicle player) distance BloodLust_CleanUpPlayerPosition >= BloodLust_CleanUpDistance) then
    {
        BloodLust_CleanUpPlayerPosition = position (vehicle player);
        call BloodLust_CleanUp;
    };
}, BloodLust_CleanUpDelay, []] call CBA_fnc_addPerFrameHandler;
