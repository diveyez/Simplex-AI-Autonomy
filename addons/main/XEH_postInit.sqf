#include "script_component.hpp"

if (isServer) then {
	["SAA_assignment",FUNC(assignmentDialogConfirm)] call CBA_fnc_addEventHandler;

	["SAA_addWaypointServer",{
		params ["_WP","_behaviour","_combatMode","_speed","_formation"];

		_WP setWaypointBehaviour _behaviour;
		_WP setWaypointCombatMode _combatMode;
		_WP setWaypointSpeed _speed;
		_WP setWaypointFormation _formation;
	}] call CBA_fnc_addEventHandler;

	["SAA_reportTargets",{
		params ["_side","_targets"];
		private _sideTargets = missionNamespace getVariable [format ["SAA_targets_%1",_side],[]];
		_sideTargets append _targets;
		missionNamespace setVariable [format ["SAA_targets_%1",_side],_sideTargets,true];
		SAA_DEBUG_2("%1 - new targets: %2",_side,_targets)
	}] call CBA_fnc_addEventHandler;

	["SAA_cleanupTargets",{
		params ["_side","_targets"];
		private _sideTargets = missionNamespace getVariable [format ["SAA_targets_%1",_side],[]];
		missionNamespace setVariable [format ["SAA_targets_%1",_side],_sideTargets - _targets,true];
	}];

	["SAA_engagementStarted",{
		params ["_side","_respondingGroups","_newTargets"];
		[FUNC(trackEngagement),[_side,_respondingGroups,_newTargets],60] call CBA_fnc_waitAndExecute;
	}] call CBA_fnc_addEventHandler;

	["SAA_transferGroups",{
		params ["_ownerID","_groups"];
		{_x setGroupOwner _ownerID} forEach _groups;
	}] call CBA_fnc_addEventHandler;

	addMissionEventHandler ["HandleDisconnect",{
		params ["_unit"];

		if (_unit in GVAR(headlessClients)) then {
			GVAR(headlessClients) deleteAt (GVAR(headlessClients) find _unit);
			publicVariable QGVAR(headlessClients);
		};

		false
	}];

	if (isNil "SAA_EFID") then {
		[] call FUNC(start);
	};
};

["SAA_checkForUnknownTargets",{
	params ["_group","_targets"];
	_group setVariable ["SAA_unknownTargets",_targets select {_group knowsAbout _x < 0.5},true];
}] call CBA_fnc_addEventHandler;

["SAA_returnToOrigin",FUNC(returnToOrigin)] call CBA_fnc_addEventHandler;

if (!isServer && !hasInterface) then {
	["SAA_headlessClientJoined",[player]] call CBA_fnc_serverEvent;
};
