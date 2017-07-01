//Blood Lust -- Blood splatter mod.
//Copyright (C) 2016  Gavin N. Alvesteffer

class BloodLust_SettingsManager
{
    idd = 76542;
    movingEnable = true;
    moving = 1;
    enableDisplay = 1;
    onLoad = "[] spawn BloodLust_SettingsManager_OnLoad;";
    onUnload = "[] spawn BloodLust_SettingsManager_OnUnload;";

    class Controls
    {
    	class Background: IGUIBack
        {
        	idc = 2200;
        	x = 0.307264 * safezoneW + safezoneX;
        	y = 0.225 * safezoneH + safezoneY;
        	w = 0.385472 * safezoneW;
        	h = 0.583 * safezoneH;
        };
        class PropertyList: RscListBox
        {
        	idc = 1500;
        	onLBSelChanged = "call BloodLust_SettingsManager_PropertySelectionChanged;";
        	x = 0.321238 * safezoneW + safezoneX;
        	y = 0.2789 * safezoneH + safezoneY;
        	w = 0.36138 * safezoneW;
        	h = 0.308 * safezoneH;
        };
        class ValueLabel: RscText
        {
        	idc = 1000;
        	text = "Value:";
        	x = 0.321245 * safezoneW + safezoneX;
        	y = 0.6751 * safezoneH + safezoneY;
        	w = 0.28303 * safezoneW;
        	h = 0.034 * safezoneH;
        };
        class ValueEditBox: RscEdit
        {
        	idc = 1400;
        	x = 0.321245 * safezoneW + safezoneX;
        	y = 0.721 * safezoneH + safezoneY;
        	w = 0.28303 * safezoneW;
        	h = 0.034 * safezoneH;
        };
        class DialogTitleLabel: RscText
        {
        	idc = 1001;
        	text = "";
        	x = 0.311986 * safezoneW + safezoneX;
        	y = 0.23622 * safezoneH + safezoneY;
        	w = 0.26983 * safezoneW;
        	h = 0.033 * safezoneH;
        };
        class SaveValueButton: RscButton
        {
        	idc = 1600;
        	action = "call BloodLust_SettingsManager_SaveValue;";
        	text = "Save Value";
        	x = 0.611722 * safezoneW + safezoneX;
        	y = 0.721 * safezoneH + safezoneY;
        	w = 0.0670333 * safezoneW;
        	h = 0.034 * safezoneH;
        };
        class ResetValuesButton: RscButton
        {
        	idc = 1601;
        	action = "call BloodLust_SettingsManager_ResetValues;";
        	text = "Reset";
        	x = 0.586731 * safezoneW + safezoneX;
        	y = 0.236 * safezoneH + safezoneY;
        	w = 0.0289104 * safezoneW;
        	h = 0.033 * safezoneH;
        };
        class ImportSettingsButton: RscButton
        {
        	idc = 1602;
        	action = "call BloodLust_SettingsManager_ImportSettings;";
        	text = "Import";
        	x = 0.62046 * safezoneW + safezoneX;
        	y = 0.236 * safezoneH + safezoneY;
        	w = 0.0289104 * safezoneW;
        	h = 0.033 * safezoneH;
        };
        class ExportSettingsButton: RscButton
        {
        	idc = 1603;
        	action = "call BloodLust_SettingsManager_ExportSettings;";
        	text = "Export";
        	x = 0.654189 * safezoneW + safezoneX;
        	y = 0.236 * safezoneH + safezoneY;
        	w = 0.0289104 * safezoneW;
        	h = 0.033 * safezoneH;
        };
        class DescriptionText: RscText
        {
        	idc = 1100;
            lineSpacing = 1;
            style = 16; //ST_MULTI
        	x = 0.321719 * safezoneW + safezoneX;
        	y = 0.599 * safezoneH + safezoneY;
        	w = 0.36138 * safezoneW;
        	h = 0.066 * safezoneH;
        	colorBackground[] = {-1,-1,-1,0};
        };
        class StructuredTextArea: RscStructuredText
        {
        	idc = 1650;
        	x = 0.311986 * safezoneW + safezoneX;
        	y = 0.764 * safezoneH + safezoneY;
        	w = 0.356561 * safezoneW;
        	h = 0.033 * safezoneH;
        };
    };
};
