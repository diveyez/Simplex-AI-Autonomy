///////////////////////////////////////////////////////////////////////////////////////////////////
// Development

[QGVAR(debug),"CHECKBOX",
	[LSTRING(SettingName_debug),LSTRING(SettingInfo_debug)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_Development)],
	false,
	false,
	{},
	false
] call CBA_fnc_addSetting;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Caching

[QGVAR(cachingEnabled),"CHECKBOX",
	[LSTRING(SettingName_cachingEnabled),LSTRING(SettingInfo_cachingEnabled)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_Caching)],
	true,
	true,
	{},
	true
] call CBA_fnc_addSetting;

[QGVAR(cachingDefault),"CHECKBOX",
	[LSTRING(SettingName_cachingDefault),LSTRING(SettingInfo_cachingDefault)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_Caching)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(cachingDistance),"SLIDER",
	[LSTRING(SettingName_cachingDistance),LSTRING(SettingInfo_cachingDistance)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_Caching)],
	[0,10000,1800,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Spotting

[QGVAR(flaresEnabled),"CHECKBOX",
	[LSTRING(SettingName_flaresEnabled),LSTRING(SettingInfo_flaresEnabled)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_Spotting)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(flaresChance),"SLIDER",
	[LSTRING(SettingName_flaresChance),LSTRING(SettingInfo_flaresChance)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_Spotting)],
	[0,1,0.8,0,true],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(smokeEnabled),"CHECKBOX",
	[LSTRING(SettingName_smokeEnabled),LSTRING(SettingInfo_smokeEnabled)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_Spotting)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(smokeChance),"SLIDER",
	[LSTRING(SettingName_smokeChance),LSTRING(SettingInfo_smokeChance)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_Spotting)],
	[0,1,0.5,0,true],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(smokeColorWEST),"LIST",
	[LSTRING(SettingName_smokeColorWEST),LSTRING(SettingInfo_smokeColorWEST)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_Spotting)],
	[[0,1,2,3,4],[LLSTRING(White),LLSTRING(Blue),LLSTRING(Green),LLSTRING(Yellow),LLSTRING(Red)],0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(smokeColorEAST),"LIST",
	[LSTRING(SettingName_smokeColorEAST),LSTRING(SettingInfo_smokeColorEAST)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_Spotting)],
	[[0,1,2,3,4],[LLSTRING(White),LLSTRING(Blue),LLSTRING(Green),LLSTRING(Yellow),LLSTRING(Red)],0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(smokeColorGUER),"LIST",
	[LSTRING(SettingName_smokeColorGUER),LSTRING(SettingInfo_smokeColorGUER)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_Spotting)],
	[[0,1,2,3,4],[LLSTRING(White),LLSTRING(Blue),LLSTRING(Green),LLSTRING(Yellow),LLSTRING(Red)],0],
	true,
	{},
	false
] call CBA_fnc_addSetting;
