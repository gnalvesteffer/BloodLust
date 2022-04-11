BloodLust_CreateBloodPoolObject =
{
    if(call BloodLust_IsMaxBloodSplattersReached) then
    {
        call BloodLust_RemoveOldBloodSplatter;
    };

    _pool = call BloodLust_CreateMediumBloodSplatterObject;

    BloodLust_BloodSplatters pushBack _pool;
    [selectRandom BloodLust_BloodPoolTextures, BloodLust_BloodPoolFramerate, false, false, _pool, {}] call BloodLust_AnimateObjectTexture;
    _pool;
};