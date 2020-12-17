#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
#include "cba_settings.sqf"

//-----------------------------------------------------------------------------------------------//

["ModuleCurator_F","init",{
	[_this # 0,"CuratorWaypointDeleted",{
		params ["_curator","_group"];

		if (!isNil {_group getVariable "SAA_assignment"}) then {
			if ((_group getVariable "SAA_assignment") == "FREE" && _group getVariable "SAA_available") exitWith {};

			if ((_group getVariable "SAA_garrisonType") in [1,2]) then {
				_group setVariable ["SAA_available",false,true];
			} else {
				_group setVariable ["SAA_available",true,true];
			};

			["SAA_returnToOrigin",_group,_group] call CBA_fnc_targetEvent;
			SAA_WARNING_1("A waypoint has been deleted. Attempting to reset group: %1",_group)
		};
	}] call CBA_fnc_addBISEventHandler;
}] call CBA_fnc_addClassEventHandler;

if (isNil QGVAR(headlessClients)) then {
	GVAR(headlessClients) = [];
};

if (isServer) then {
	["SAA_headlessClientJoined",{
		params ["_headlessClient"];

		if (_headlessClient in GVAR(headlessClients)) exitWith {};

		GVAR(headlessClients) pushBack _headlessClient;
		publicVariable QGVAR(headlessClients);
	}] call CBA_fnc_addEventHandler;

	[QGVAR(localityExec),{
		params ["_localitySelection","_params","_fncVar"];

		if (_localitySelection > (count GVAR(headlessClients) + 1)) exitWith {
			diag_log ("Headless client(s) disconnected during selection. Cancelling execution of " + _fncVar);
		};

		if (_localitySelection == 1) exitWith {
			_params call (missionNamespace getVariable _fncVar);
		};

		if (_localitySelection > 1) then {
			private _headlessClientID = owner (GVAR(headlessClients) # (_localitySelection - 2));
			_params remoteExecCall [_fncVar,_headlessClientID];
		};
	}] call CBA_fnc_addEventHandler;
};

//-----------------------------------------------------------------------------------------------//

// Occupation density presets
GVAR(presets) = profileNamespace getVariable [QGVAR(presets),[[
	["CSAT",[[
		[["O_Soldier_TL_F","O_soldier_AR_F","O_Soldier_GL_F","O_soldier_LAT_F"],[2,6]],
		[["O_Soldier_GL_F","O_Soldier_F"],[3,6]]
	],[
		[["O_Soldier_TL_F","O_soldier_AR_F","O_Soldier_GL_F","O_soldier_LAT_F"],[5,10]]
	],[
		[["O_Soldier_GL_F","O_Soldier_F"],[3,6]],
		[["O_MRAP_02_gmg_F","O_soldier_AR_F","O_soldier_LAT_F"],[0,2]]
	],[
		[["O_MRAP_02_gmg_F","O_soldier_AR_F","O_soldier_LAT_F"],[0,2]],
		[["O_Truck_03_transport_F","O_Soldier_SL_F","O_soldier_LAT_F","O_soldier_M_F","O_soldier_AR_F","O_Soldier_A_F","O_medic_F","O_Soldier_SL_F","O_soldier_LAT_F","O_soldier_M_F","O_Soldier_TL_F","O_soldier_AR_F","O_Soldier_A_F","O_medic_F"],[0,1]]
	]]]
],[
	["NATO",[[
		[["B_Soldier_TL_F","B_soldier_AR_F","B_Soldier_GL_F","B_soldier_LAT_F"],[2,6]],
		[["B_Soldier_GL_F","B_Soldier_F"],[3,6]]
	],[
		[["B_Soldier_TL_F","B_soldier_AR_F","B_Soldier_GL_F","B_soldier_LAT_F"],[5,10]]
	],[
		[["B_Soldier_GL_F","B_Soldier_F"],[3,6]],
		[["B_MRAP_01_gmg_F","B_soldier_AR_F","B_soldier_LAT_F"],[0,2]]
	],[
		[["B_MRAP_01_gmg_F","B_soldier_AR_F","B_soldier_LAT_F"],[0,2]],
		[["B_Truck_01_transport_F","B_Soldier_SL_F","B_soldier_LAT_F","B_soldier_M_F","B_soldier_AR_F","B_Soldier_A_F","B_medic_F","B_Soldier_SL_F","B_soldier_LAT_F","B_soldier_M_F","B_Soldier_TL_F","B_soldier_AR_F","B_Soldier_A_F","B_medic_F"],[0,1]]
	]]]
],[]]];

//-----------------------------------------------------------------------------------------------//
// AI Sub-skills

["CAManBase","initPost",{
	params ["_unit"];
	if (GVAR(applySubSkills) && local _unit) then {
		_unit call FUNC(applySubSkills);
	};
}] call CBA_fnc_addClassEventHandler;

["CAManBase","Local",{
	params ["_unit","_local"];
	if (GVAR(applySubSkills) && _local) then {
		_unit call FUNC(applySubSkills);
	};
}] call CBA_fnc_addClassEventHandler;

//-----------------------------------------------------------------------------------------------//

ADDON = true;
