[QGVAR(pedSpawnRadius),"SLIDER",
	["Pedestrian spawn radius","Radius of ""spawn sector"" around players to spawn pedestrians"],
	[ELSTRING(main,SimplexAIAutonomy),"Civilians"],
	[150,1500,450,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(driverSpawnRadius),"SLIDER",
	["Driving vehicle spawn radius","Radius of ""spawn sector"" around players to spawn driving vehicles"],
	[ELSTRING(main,SimplexAIAutonomy),"Civilians"],
	[150,1500,550,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(parkedSpawnRadius),"SLIDER",
	["Parked vehicle spawn radius","Radius of ""spawn sector"" around players to spawn parked vehicles"],
	[ELSTRING(main,SimplexAIAutonomy),"Civilians"],
	[150,1500,500,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(pedCount),"SLIDER",
	["Pedestrians","Amount of pedestrians to spawn in every ""spawn sector"""],
	[ELSTRING(main,SimplexAIAutonomy),"Civilians"],
	[0,30,6,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(driverCount),"SLIDER",
	["Driving vehicles","Amount of driven/moving vehicles to spawn in every ""spawn sector"""],
	[ELSTRING(main,SimplexAIAutonomy),"Civilians"],
	[0,20,3,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(parkedCount),"SLIDER",
	["Parked vehicles","Amount of parked/unnoccupied vehicles to spawn in every ""spawn sector"""],
	[ELSTRING(main,SimplexAIAutonomy),"Civilians"],
	[0,20,5,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(unitClassesStr),"EDITBOX",
	["Unit classes","Civilian unit classes, leave empty for defaults"],
	[ELSTRING(main,SimplexAIAutonomy),"Civilians"],
	"[]",
	true,
	{missionNamespace setVariable [QGVAR(unitClasses),parseSimpleArray _this,true]},
	false
] call CBA_fnc_addSetting;

[QGVAR(vehClassesStr),"EDITBOX",
	["Vehicle classes","Vehicle classes, leave empty for defaults"],
	[ELSTRING(main,SimplexAIAutonomy),"Civilians"],
	"[]",
	true,
	{missionNamespace setVariable [QGVAR(vehClasses),parseSimpleArray _this,true]},
	false
] call CBA_fnc_addSetting;

[QGVAR(pedSpawnDelay),"SLIDER",
	["Pedestrian spawn delay","Delay between each pedestrian being spawned"],
	[ELSTRING(main,SimplexAIAutonomy),"Civilians: Experimental"],
	[0,5,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(driverSpawnDelay),"SLIDER",
	["Driver spawn delay"," Delay between each driving vehicle being spawned"],
	[ELSTRING(main,SimplexAIAutonomy),"Civilians: Experimental"],
	[0,5,0.65,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(parkedSpawnDelay),"SLIDER",
	["Parked spawn delay","Delay between each parked vehicle being spawned"],
	[ELSTRING(main,SimplexAIAutonomy),"Civilians: Experimental"],
	[0,5,0.8,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(minPanicTime),"SLIDER",
	["Minimum panic time","Minimum amount time in seconds civilians will stay in a panicked state"],
	[ELSTRING(main,SimplexAIAutonomy),"Civilians: Experimental"],
	[30,1200,120,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;
