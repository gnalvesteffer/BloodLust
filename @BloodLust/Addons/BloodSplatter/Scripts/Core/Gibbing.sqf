BloodLust_Gibs = [];

BloodLust_CreateGibObject =
{
    _classname = _this;
    if(call BloodLust_IsMaxGibsReached) then
    {
        call BloodLust_RemoveOldGib;
    };
    _gib = _classname createVehicleLocal [0,0,0];
    BloodLust_Gibs pushBack _gib;
    _gib;
};

BloodLust_IsMaxGibsReached =
{
    _return = false;
    if(count BloodLust_Gibs >= BloodLust_MaxGibs) then
    {
        _return = true;
    };
    _return;
};

BloodLust_RemoveOldGib =
{
    if(count BloodLust_Gibs > 0) then
    {
        _gib = BloodLust_Gibs select 0;
        deleteVehicle _gib;
        BloodLust_Gibs deleteAt 0;
    };
};
