///////////////////////////////////////////////////////////////////////////////////////////////////
// AI Sub-skills

[QGVAR(applySubSkills),"CHECKBOX",
	[LSTRING(SettingName_applySubSkills),LSTRING(SettingInfo_applySubSkills)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AISubSkills)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillGeneral),"SLIDER",
	[LSTRING(SettingName_skillGeneral),LSTRING(SettingInfo_skillGeneral)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillCommanding),"SLIDER",
	[LSTRING(SettingName_skillCommanding),LSTRING(SettingInfo_skillCommanding)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillCourage),"SLIDER",
	[LSTRING(SettingName_skillCourage),LSTRING(SettingInfo_skillCourage)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillAimingAccuracy),"SLIDER",
	[LSTRING(SettingName_skillAimingAccuracy),LSTRING(SettingInfo_skillAimingAccuracy)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillAimingShake),"SLIDER",
	[LSTRING(SettingName_skillAimingShake),LSTRING(SettingInfo_skillAimingShake)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillAimingSpeed),"SLIDER",
	[LSTRING(SettingName_skillAimingSpeed),LSTRING(SettingInfo_skillAimingSpeed)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillReloadSpeed),"SLIDER",
	[LSTRING(SettingName_skillReloadSpeed),LSTRING(SettingInfo_skillReloadSpeed)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillSpotDistance),"SLIDER",
	[LSTRING(SettingName_skillSpotDistance),LSTRING(SettingInfo_skillSpotDistance)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillSpotTime),"SLIDER",
	[LSTRING(SettingName_skillSpotTime),LSTRING(SettingInfo_skillSpotTime)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AISubSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

///////////////////////////////////////////////////////////////////////////////////////////////////
