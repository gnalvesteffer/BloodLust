BloodLust_PreloadTextures =
{
	_textures = _this;
	_preloadObject = "BloodSplatter_Plane" createVehicleLocal [0, 0, 0];
	_preloadObject setPosASL ((position player) vectorAdd [0, 0, -2]);
	{
		_preloadObject setObjectTexture [0, _x];
	} foreach _textures;
	deleteVehicle _preloadObject;
};

for [{_i = 0}, {_i < 3}, {_i = _i + 1}] do
{
	{
		_x spawn BloodLust_PreloadTextures;
	} foreach BloodLust_HeadSplatterTextures;

	{
		_x spawn BloodLust_PreloadTextures;
	} foreach BloodLust_Spine1SplatterTextures;

	{
		_x spawn BloodLust_PreloadTextures;
	} foreach BloodLust_Spine2SplatterTextures;

	{
		_x spawn BloodLust_PreloadTextures;
	} foreach BloodLust_Spine3SplatterTextures;

	{
		_x spawn BloodLust_PreloadTextures;
	} foreach BloodLust_BodySplatterTextures;

	{
		_x spawn BloodLust_PreloadTextures;
	} foreach BloodLust_ArmSplatterTextures;

	{
		_x spawn BloodLust_PreloadTextures;
	} foreach BloodLust_LegSplatterTextures;

	{
		_x spawn BloodLust_PreloadTextures;
	} foreach BloodLust_BloodPoolTextures;

	{
		_x spawn BloodLust_PreloadTextures;
	} foreach BloodLust_SprayTextures;

	BloodLust_LargeVaporizationBloodSplatters spawn BloodLust_PreloadTextures;
	BloodLust_VaporizationBloodSplatters spawn BloodLust_PreloadTextures;
	BloodLust_BleedTextures spawn BloodLust_PreloadTextures;
	BloodLust_SmearTextures spawn BloodLust_PreloadTextures;
}
