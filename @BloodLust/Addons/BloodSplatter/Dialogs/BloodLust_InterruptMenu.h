//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer
//Credits to Greenfist for his guidance with the interrupt menu button.

class RscDisplayInterrupt
{
	class Controls
	{
		class BloodLustSettingsButton: RscButtonMenu
		{
			idc = 265411;
			action = "createDialog 'BloodLust_SettingsManager';";
			default = 1;
			text = "BloodLust Settings";
			x = 0.805374 * safezoneW + safezoneX;
			y = 0.143 * safezoneH + safezoneY;
			w = 0.186204 * safezoneW;
			h = 0.034 * safezoneH;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0.75,0.2,0.2,0.8};
		};
	};
};

class RscDisplayMPInterrupt
{
	class Controls
	{
		class BloodLustSettingsButton: RscButtonMenu
		{
			idc = 265412;
			action = "createDialog 'BloodLust_SettingsManager';";
			default = 1;
			text = "BloodLust Settings";
			x = 0.805374 * safezoneW + safezoneX;
			y = 0.143 * safezoneH + safezoneY;
			w = 0.186204 * safezoneW;
			h = 0.034 * safezoneH;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0.75,0.2,0.2,0.8};
		};
	};
};
