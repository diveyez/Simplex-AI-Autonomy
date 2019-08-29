#include "script_component.hpp"

if (isServer) then {
	["SAA_assignment",{_this call SAA_fnc_assignmentDialogConfirm}] call CBA_fnc_addEventHandler;

	["SAA_addWaypoint",{_this call SAA_fnc_addWaypoint}] call CBA_fnc_addEventHandler;

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
		[{_this call SAA_fnc_trackEngagement},[_side,_respondingGroups,_newTargets],60] call CBA_fnc_waitAndExecute;
	}] call CBA_fnc_addEventHandler;
};

["SAA_checkForUnknownTargets",{
	params ["_group","_targets"];
	_group setVariable ["SAA_unknownTargets",_targets select {_group knowsAbout _x < 0.5},true];
}] call CBA_fnc_addEventHandler;
