//-----------------------------------------------------------------------------------------------//
// Core

["SAA_setting_flaresEnabled","CHECKBOX",
	["Enable flares","Enable flares on detection"],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_Core)],
	true, // _valueInfo
	true, // _isGlobal
	{},
	false // _needRestart
] call CBA_fnc_addSetting;

["SAA_setting_smokeEnabled","CHECKBOX",
	["Enable smoke","Enable smoke grenades on detection"],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_Core)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SAA_setting_smokeColorWEST","LIST",
	["Side smoke color - WEST","Default smoke color used for side"],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_Core)],
	[[0,1,2,3,4],["White","Blue","Green","Yellow","Red"],0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SAA_setting_smokeColorEAST","LIST",
	["Side smoke color - EAST","Default smoke color used for side"],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_Core)],
	[[0,1,2,3,4],["White","Blue","Green","Yellow","Red"],0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SAA_setting_smokeColorGUER","LIST",
	["Side smoke color - GUER","Default smoke color used for side"],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_Core)],
	[[0,1,2,3,4],["White","Blue","Green","Yellow","Red"],0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

//-----------------------------------------------------------------------------------------------//
// Development

["SAA_setting_enableDebug","CHECKBOX",
	"Enable debug",
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_Development)],
	false,
	false,
	{},
	false
] call CBA_fnc_addSetting;

//-----------------------------------------------------------------------------------------------//
// Caching

["SAA_setting_cachingEnabled","CHECKBOX",
	"Enable simple caching system",
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_Caching)],
	true,
	true,
	{},
	true
] call CBA_fnc_addSetting;

["SAA_setting_cachingDefault","CHECKBOX",
	["Default caching flag","If true, groups will be flagged to be cached by default"],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_Caching)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SAA_setting_cachingDistance","EDITBOX",
	"Caching distance from player",
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_Caching)],
	"1800",
	true,
	{missionNamespace setVariable ["SAA_cachingDistance",parseNumber _this,true]},
	false
] call CBA_fnc_addSetting;

//-----------------------------------------------------------------------------------------------//
// AI Sub-skills

[QGVAR(applySubSkills),"CHECKBOX",
	[LSTRING(SettingDisplayName_applySubSkills),LSTRING(SettingDescription_applySubSkills)],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_AISubSkills)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillGeneral),"SLIDER",
	[LSTRING(SettingDisplayName_skillGeneral),LSTRING(SettingDescription_skillGeneral)],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillCommanding),"SLIDER",
	[LSTRING(SettingDisplayName_skillCommanding),LSTRING(SettingDescription_skillCommanding)],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillCourage),"SLIDER",
	[LSTRING(SettingDisplayName_skillCourage),LSTRING(SettingDescription_skillCourage)],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillAimingAccuracy),"SLIDER",
	[LSTRING(SettingDisplayName_skillAimingAccuracy),LSTRING(SettingDescription_skillAimingAccuracy)],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillAimingShake),"SLIDER",
	[LSTRING(SettingDisplayName_skillAimingShake),LSTRING(SettingDescription_skillAimingShake)],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillAimingSpeed),"SLIDER",
	[LSTRING(SettingDisplayName_skillAimingSpeed),LSTRING(SettingDescription_skillAimingSpeed)],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillReloadSpeed),"SLIDER",
	[LSTRING(SettingDisplayName_skillReloadSpeed),LSTRING(SettingDescription_skillReloadSpeed)],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillSpotDistance),"SLIDER",
	[LSTRING(SettingDisplayName_skillSpotDistance),LSTRING(SettingDescription_skillSpotDistance)],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillSpotTime),"SLIDER",
	[LSTRING(SettingDisplayName_skillSpotTime),LSTRING(SettingDescription_skillSpotTime)],
	[LSTRING(SimplexAIAutonomy),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

//-----------------------------------------------------------------------------------------------//
