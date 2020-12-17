[QGVAR(aircraftChance),"SLIDER",
	["Chance","Chance of aircraft spawning after random time has elapsed"],
	[ELSTRING(main,SimplexAIAutonomy),"Ambient Aircraft"],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftMinTime),"SLIDER",
	["Min time","Minimum time between spawn chances"],
	[ELSTRING(main,SimplexAIAutonomy),"Ambient Aircraft"],
	[30,1800,180,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftMaxTime),"SLIDER",
	["Max time","Maximum time between spawn chances"],
	[ELSTRING(main,SimplexAIAutonomy),"Ambient Aircraft"],
	[30,1800,480,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftAltitude),"SLIDER",
	["Altitude","Aircraft flying height"],
	[ELSTRING(main,SimplexAIAutonomy),"Ambient Aircraft"],
	[150,1500,600,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftSpawnDistance),"SLIDER",
	["Spawn distance","How far away should aircraft spawn/de-spawn from selected player"],
	[ELSTRING(main,SimplexAIAutonomy),"Ambient Aircraft"],
	[1000,3000,2750,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftTTL),"SLIDER",
	["Time to live","Aircraft will be deleted after set time (-1 to disable)"],
	[ELSTRING(main,SimplexAIAutonomy),"Ambient Aircraft"],
	[-1,600,300,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftClassesWeightedStr),"EDITBOX",
	["Aircraft classes weighted","Array of aircraft classes and weight/chance they will spawn (weighted array)"],
	[ELSTRING(main,SimplexAIAutonomy),"Ambient Aircraft"],
	"[""C_Heli_Light_01_civil_F"",1,""C_Plane_Civil_01_F"",1,""B_Plane_CAS_01_Cluster_F"",1,""B_Plane_Fighter_01_Cluster_F"",1]",
	true,
	{missionNamespace setVariable [QGVAR(aircraftClassesWeighted),parseSimpleArray _this,true]},
	false
] call CBA_fnc_addSetting;
