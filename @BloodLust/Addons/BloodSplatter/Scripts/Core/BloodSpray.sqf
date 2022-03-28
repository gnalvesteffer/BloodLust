BloodLust_ArterialBloodSprays = [];
BloodLust_BloodSprays = [];

BloodLust_CreateArterialBloodSpray =
{
    _positionASL = _this select 0;
    _vectorDir = _this select 1;
    _vectorUp = _this select 2;
    if(call BloodLust_IsMaxArterialBloodSpraysReached) exitWith {};

    _spray = objNull;
    if(isMultiplayer) then
    {
        _spray = "BloodSplatter_SmallSprayPlane" createVehicleLocal [0, 0, 0];
    }
    else
    {
        _spray = createSimpleObject ["BloodSplatter_SmallSprayPlane", [0, 0, 0]];
    };

    BloodLust_ArterialBloodSprays pushBack _spray;
    _spray setPosASL _positionASL;
    _spray setVectorDirAndUp [_vectorDir, _vectorUp];
    _spray setPosASL (AGLToASL(_spray modelToWorld [0, 0.3, 0]));
    [selectRandom BloodLust_SprayTextures, BloodLust_ArterialBloodSprayFramerate, false, true, _spray, BloodLust_OnArterialBloodSprayAnimationEnd] call BloodLust_AnimateObjectTexture;
    if(BloodLust_IsBloodSpraySoundEnabled) then
    {
        [selectRandom BloodLust_BloodSpraySounds, _spray, false, getPosASL _spray, BloodLust_BloodSpraySoundAudibleVolume, 1.2 - (random 0.4), BloodLust_BloodSpraySoundAudibleDistance * 0.5] call BloodLust_PlaySound;
    };

    _spray;
};

BloodLust_CreateBloodSpray =
{
    _positionASL = _this select 0;
    _vectorDir = _this select 1;
    _vectorUp = _this select 2;
    if(isNil "_positionASL" || isNil "_vectorDir" || isNil "_vectorUp") exitWith {};
    if(call BloodLust_IsMaxBloodSpraysReached) exitWith {};

    _spray = objNull;
    if(isMultiplayer) then
    {
        _spray = "BloodSplatter_SprayPlane" createVehicleLocal [0, 0, 0];
    }
    else
    {
        _spray = createSimpleObject ["BloodSplatter_SprayPlane", [0, 0, 0]];
    };

    BloodLust_BloodSprays pushBack _spray;
    _spray setPosASL _positionASL;
    _spray setVectorDirAndUp [_vectorDir, _vectorUp];
    _spray setPosASL (AGLToASL(_spray modelToWorld [0, 0.9, 0]));
    [selectRandom BloodLust_SprayTextures, BloodLust_BloodSprayFramerate, false, true, _spray, BloodLust_OnBloodSprayAnimationEnd] call BloodLust_AnimateObjectTexture;
    if(BloodLust_IsBloodSpraySoundEnabled) then
    {
        [selectRandom BloodLust_BloodSpraySounds, _spray, false, getPosASL _spray, BloodLust_BloodSpraySoundAudibleVolume, 1.2 - (random 0.4), BloodLust_BloodSpraySoundAudibleDistance] call BloodLust_PlaySound;
    };

    _spray;
};

BloodLust_OnBloodSprayAnimationEnd =
{
    _bloodSprayObject = param [0];
    BloodLust_BloodSprays = BloodLust_BloodSprays - [_bloodSprayObject];
};

BloodLust_OnArterialBloodSprayAnimationEnd =
{
    _bloodSprayObject = param [0];
    BloodLust_ArterialBloodSprays = BloodLust_ArterialBloodSprays - [_bloodSprayObject];
};

BloodLust_IsMaxArterialBloodSpraysReached =
{
    _return = false;
    if(count BloodLust_ArterialBloodSprays >= BloodLust_MaxArterialBloodSprays) then
    {
        _return = true;
    };
    _return;
};

BloodLust_RemoveOldArterialBloodSpray =
{
    if(count BloodLust_ArterialBloodSprays > 0) then
    {
        _spray = BloodLust_ArterialBloodSprays select 0;
        deleteVehicle _spray;
        BloodLust_ArterialBloodSprays deleteAt 0;
    };
};

BloodLust_IsMaxBloodSpraysReached =
{
    _return = false;
    if(count BloodLust_BloodSprays >= BloodLust_MaxBloodSprays) then
    {
        _return = true;
    };
    _return;
};

BloodLust_RemoveOldBloodSpray =
{
    if(count BloodLust_BloodSprays > 0) then
    {
        _spray = BloodLust_BloodSprays select 0;
        deleteVehicle _spray;
        BloodLust_BloodSprays deleteAt 0;
    };
};
