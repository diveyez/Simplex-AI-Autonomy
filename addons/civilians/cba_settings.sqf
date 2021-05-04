///////////////////////////////////////////////////////////////////////////////////////////////////
// Ambient Aircraft

[QGVAR(aircraftEnabled),"CHECKBOX",
	[LSTRING(SettingName_aircraftEnabled),LSTRING(SettingInfo_aircraftEnabled)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientAircraft)],
	true,
	true,
	{},
	true
] call CBA_fnc_addSetting;

[QGVAR(aircraftChance),"SLIDER",
	[LSTRING(SettingName_aircraftChance),LSTRING(SettingInfo_aircraftChance)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientAircraft)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftMinTime),"SLIDER",
	[LSTRING(SettingName_aircraftMinTime),LSTRING(SettingInfo_aircraftMinTime)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientAircraft)],
	[30,1800,180,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftMaxTime),"SLIDER",
	[LSTRING(SettingName_aircraftMaxTime),LSTRING(SettingInfo_aircraftMaxTime)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientAircraft)],
	[30,1800,480,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftAltitude),"SLIDER",
	[LSTRING(SettingName_aircraftAltitude),LSTRING(SettingInfo_aircraftAltitude)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientAircraft)],
	[150,1500,600,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftSpawnDistance),"SLIDER",
	[LSTRING(SettingName_aircraftSpawnDistance),LSTRING(SettingInfo_aircraftSpawnDistance)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientAircraft)],
	[1000,3000,2750,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftTTL),"SLIDER",
	[LSTRING(SettingName_aircraftTTL),LSTRING(SettingInfo_aircraftTTL)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientAircraft)],
	[0,600,300,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftClassesStr),"EDITBOX",
	[LSTRING(SettingName_aircraftClassesStr),LSTRING(SettingInfo_aircraftClassesStr)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientAircraft)],
	"[""C_Heli_Light_01_civil_F"",1,""C_Plane_Civil_01_F"",1,""B_Plane_CAS_01_Cluster_F"",1,""B_Plane_Fighter_01_Cluster_F"",1]",
	true,
	{missionNamespace setVariable [QGVAR(aircraftClasses),parseSimpleArray _this,true]},
	false
] call CBA_fnc_addSetting;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Ambient Civilians

[QGVAR(autoStart),"CHECKBOX",
	[LSTRING(SettingName_autoStart),LSTRING(SettingInfo_autoStart)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientCivilians)],
	false,
	true,
	{},
	true
] call CBA_fnc_addSetting;

[QGVAR(pedSpawnRadius),"SLIDER",
	[LSTRING(SettingName_pedSpawnRadius),LSTRING(SettingInfo_pedSpawnRadius)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientCivilians)],
	[150,1500,450,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(driverSpawnRadius),"SLIDER",
	[LSTRING(SettingName_driverSpawnRadius),LSTRING(SettingInfo_driverSpawnRadius)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientCivilians)],
	[150,1500,550,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(parkedSpawnRadius),"SLIDER",
	[LSTRING(SettingName_parkedSpawnRadius),LSTRING(SettingInfo_parkedSpawnRadius)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientCivilians)],
	[150,1500,500,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(pedestrianCount),"SLIDER",
	[LSTRING(SettingName_pedestrianCount),LSTRING(SettingInfo_pedestrianCount)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientCivilians)],
	[0,30,6,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(driverCount),"SLIDER",
	[LSTRING(SettingName_driverCount),LSTRING(SettingInfo_driverCount)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientCivilians)],
	[0,20,3,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(parkedCount),"SLIDER",
	[LSTRING(SettingName_parkedCount),LSTRING(SettingInfo_parkedCount)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientCivilians)],
	[0,20,5,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(unitClassesStr),"EDITBOX",
	[LSTRING(SettingName_unitClassesStr),LSTRING(SettingInfo_unitClassesStr)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientCivilians)],
	"",
	true,
	{missionNamespace setVariable [QGVAR(unitClasses),_this splitString ", ",true]},
	false
] call CBA_fnc_addSetting;

[QGVAR(vehClassesStr),"EDITBOX",
	[LSTRING(SettingName_vehClassesStr),LSTRING(SettingInfo_vehClassesStr)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_AmbientCivilians)],
	"",
	true,
	{missionNamespace setVariable [QGVAR(vehClasses),_this splitString ", ",true]},
	false
] call CBA_fnc_addSetting;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Civilians: Experimental

[QGVAR(pedSpawnDelay),"SLIDER",
	[LSTRING(SettingName_pedSpawnDelay),LSTRING(SettingInfo_pedSpawnDelay)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_CiviliansExperimental)],
	[0,5,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(driverSpawnDelay),"SLIDER",
	[LSTRING(SettingName_driverSpawnDelay),LSTRING(SettingInfo_driverSpawnDelay)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_CiviliansExperimental)],
	[0,5,0.65,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(parkedSpawnDelay),"SLIDER",
	[LSTRING(SettingName_parkedSpawnDelay),LSTRING(SettingInfo_parkedSpawnDelay)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_CiviliansExperimental)],
	[0,5,0.8,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(minPanicTime),"SLIDER",
	[LSTRING(SettingName_minPanicTime),LSTRING(SettingInfo_minPanicTime)],
	[LSTRING(SettingParent),LSTRING(SettingCategory_CiviliansExperimental)],
	[30,1200,120,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;
