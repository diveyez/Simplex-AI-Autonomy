#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

[QGVAR(pedSpawnRadius),"SLIDER",
	["Pedestrian spawn radius","Radius of ""spawn sector"" around players to spawn pedestrians"],
	["Simplex AI Autonomy","Civilians"],
	[150,1500,450,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(driverSpawnRadius),"SLIDER",
	["Driving vehicle spawn radius","Radius of ""spawn sector"" around players to spawn driving vehicles"],
	["Simplex AI Autonomy","Civilians"],
	[150,1500,550,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(parkedSpawnRadius),"SLIDER",
	["Parked vehicle spawn radius","Radius of ""spawn sector"" around players to spawn parked vehicles"],
	["Simplex AI Autonomy","Civilians"],
	[150,1500,500,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(pedCount),"SLIDER",
	["Pedestrians","Amount of pedestrians to spawn in every ""spawn sector"""],
	["Simplex AI Autonomy","Civilians"],
	[0,30,6,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(driverCount),"SLIDER",
	["Driving vehicles","Amount of driven/moving vehicles to spawn in every ""spawn sector"""],
	["Simplex AI Autonomy","Civilians"],
	[0,20,3,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(parkedCount),"SLIDER",
	["Parked vehicles","Amount of parked/unnoccupied vehicles to spawn in every ""spawn sector"""],
	["Simplex AI Autonomy","Civilians"],
	[0,20,5,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(unitClassesStr),"EDITBOX",
	["Unit classes","Civilian unit classes, leave empty for defaults"],
	["Simplex AI Autonomy","Civilians"],
	"[]",
	true,
	{missionNamespace setVariable [QGVAR(unitClasses),parseSimpleArray _this,true]},
	false
] call CBA_fnc_addSetting;

[QGVAR(vehClassesStr),"EDITBOX",
	["Vehicle classes","Vehicle classes, leave empty for defaults"],
	["Simplex AI Autonomy","Civilians"],
	"[]",
	true,
	{missionNamespace setVariable [QGVAR(vehClasses),parseSimpleArray _this,true]},
	false
] call CBA_fnc_addSetting;

[QGVAR(pedSpawnDelay),"SLIDER",
	["Pedestrian spawn delay","Delay between each pedestrian being spawned"],
	["Simplex AI Autonomy","Civilians: Experimental"],
	[0,5,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(driverSpawnDelay),"SLIDER",
	["Driver spawn delay"," Delay between each driving vehicle being spawned"],
	["Simplex AI Autonomy","Civilians: Experimental"],
	[0,5,0.65,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(parkedSpawnDelay),"SLIDER",
	["Parked spawn delay","Delay between each parked vehicle being spawned"],
	["Simplex AI Autonomy","Civilians: Experimental"],
	[0,5,0.8,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(minPanicTime),"SLIDER",
	["Minimum panic time","Minimum amount time in seconds civilians will stay in a panicked state"],
	["Simplex AI Autonomy","Civilians: Experimental"],
	[30,1200,120,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

GVAR(blacklist) = []; // Blacklist areas (Can be of type: marker, trigger, location, area array)
GVAR(spawnPoints) = [];
GVAR(runner) = objNull;
GVAR(isRunning) = false;

if (isServer) then {
	if (isNil QGVAR(brainEFID)) then {
		GVAR(brainList) = [];
		GVAR(brainIndex) = 0;
		GVAR(brainEFID) = addMissionEventHandler ["EachFrame",{call FUNC(brain)}];
	};

	// Handle HC disconnect
	addMissionEventHandler ["HandleDisconnect",{
		params ["_unit"];

		if (isNull GVAR(runner)) exitWith {false};

		if (_unit isEqualTo GVAR(runner) && GVAR(isRunning)) then {
			missionNamespace setVariable [QGVAR(isRunning),false,true];
			missionNamespace setVariable [QGVAR(runner),objNull,true];
		};

		false
	}];

	[QGVAR(toggle),{
		params [["_localitySelection",0,[0]]];

		// End on HC
		if (!isNull GVAR(runner)) exitWith {
			[] remoteExecCall [QFUNC(toggle),owner GVAR(runner)];
			missionNamespace setVariable [QGVAR(runner),objNull,true];
		};

		// End on server
		if (GVAR(isRunning)) exitWith {
			[] call FUNC(toggle);
		};

		if (_localitySelection > count EGVAR(main,headlessClients)) exitWith {
			diag_log "Headless client(s) disconnected during selection. Cancelling occupation.";
		};

		// Server exec
		if (_localitySelection == 0) exitWith {
			missionNamespace setVariable [QGVAR(runner),objNull,true];
			[] call FUNC(toggle);
		};

		// HC exec
		if (_localitySelection > 0) then {
			private _headlessClient = EGVAR(main,headlessClients) # (_localitySelection - 1);
			missionNamespace setVariable [QGVAR(runner),_headlessClient,true];
			
			private _headlessClientID = owner _headlessClient;
			[] remoteExecCall [QFUNC(toggle),_headlessClientID];
		};
	}] call CBA_fnc_addEventHandler;

	[QGVAR(localityExec),{
		params ["_localitySelection","_params","_fncVar"];

		if (_localitySelection > (count EGVAR(main,headlessClients) + 1)) exitWith {
			diag_log ("Headless client(s) disconnected during selection. Cancelling execution of " + _fncVar);
		};

		if (_localitySelection == 1) exitWith {
			_params call (missionNamespace getVariable _fncVar);
		};

		if (_localitySelection > 1) then {
			private _headlessClientID = owner (EGVAR(main,headlessClients) # (_localitySelection - 2));
			_params remoteExecCall [_fncVar,_headlessClientID];
		};
	}] call CBA_fnc_addEventHandler;

	[QGVAR(addBlacklist),{
		params [["_area",[],["",objNull,locationNull,[]],5]];

		_area = [_area] call CBA_fnc_getArea;

		if (_area isEqualTo []) exitWith {};

		GVAR(blacklist) pushBack _area;
		publicVariable QGVAR(blacklist);
	}] call CBA_fnc_addEventHandler;
};


ADDON = true;
