#include "script_component.hpp"

params ["_side","_respondingGroups","_targets"];

_respondingGroups = _respondingGroups select {({alive _x} count units _x) != 0 && !(_x getVariable "SAA_available")};

if (_respondingGroups isEqualTo []) exitWith {
	[_targets,_side] call SAA_fnc_cleanupTargets;
	SAA_DEBUG_1("Engagement - No groups to respond to targets: %1",_targets)
};

[{
	(_this getVariable "params") params ["_side","_respondingGroups","_targets"];

	_respondingGroups = _respondingGroups select {({alive _x} count units _x) != 0 && !(_x getVariable "SAA_available")};

	// Stop if no more responding groups
	if (_respondingGroups isEqualTo []) exitWith {
		[_targets,_side] call SAA_fnc_cleanupTargets;
		_this setVariable ["exit_condition",{true}];
		SAA_DEBUG_1("Engagement - No groups to respond to targets: %1",_targets)
	};

	// Forget about dead or empty targets
	private _deadTargets = _targets select {({alive _x} count crew _x) isEqualTo 0};
	if !(_deadTargets isEqualTo []) then {
		[_deadTargets,_side] call SAA_fnc_cleanupTargets;
		_targets = _targets - _deadTargets;
		SAA_DEBUG_1("Engagement - Dead or empty targets: %1",_deadTargets)
	};

	// Stop if no more targets
	if (_targets isEqualTo []) exitWith {
		{_x setVariable ["SAA_available",true]} forEach _respondingGroups;
		_this setVariable ["exit_condition",{true}];
		SAA_DEBUG("Engagement - No more targets")
	};

	// Check if unknown targets are still unknown after the next check; If so, clean them up for redetection
	private _lastUnknownTargets = _this getVariable ["SAA_unknownTargets",[]];
	if !(_lastUnknownTargets isEqualTo []) then {
		private _remainingUnknownTargets = _lastUnknownTargets select {
			private _target = _x;
			({_x knowsAbout _target > 0.5} count _respondingGroups) isEqualTo 0
		};
		if !(_remainingUnknownTargets isEqualTo []) then {
			_targets = _targets - _remainingUnknownTargets;
			[_remainingUnknownTargets,_side] call SAA_fnc_cleanupTargets;
			SAA_DEBUG_1("Engagement - Targets considered unknown: %1"_remainingUnknownTargets)
		};
	};

	// Stop if no more targets
	if (_targets isEqualTo []) exitWith {
		{_x setVariable ["SAA_available",true]} forEach _respondingGroups;
		_this setVariable ["exit_condition",{true}];
		SAA_DEBUG("Engagement - No more targets")
	};

	// Check for new unknown targets
	private _unknownTargets = _targets select {
		private _target = _x;
		{
			_x knowsAbout _target > 0.5
			//if (_x knowsAbout _target > 0.5) then {
			//	_target setVariable [format ["SAA_LKP_%1",_side],getPos _target,true];
			//	true
			//} else {
			//	false
			//};
		} count _respondingGroups isEqualTo 0
	};
	_this setVariable ["SAA_unknownTargets",_unknownTargets];
	private _knownTargets = _targets - _unknownTargets;

	{
		private _target = _x getVariable "SAA_target";
		if (!alive _target && !(_knownTargets isEqualTo [])) then {
			_target = selectRandom _knownTargets;
			_x setVariable ["SAA_target",_target];
		};

		// Update WP position
		private _currentWP = [_x,currentWaypoint _x];
		if (waypointType _currentWP == "SAD") then {
			private _expectedPos = (leader _x) getHideFrom _target;
			_expectedPos set [2,0];
			if !(_expectedPos isEqualTo [0,0,0]) then {_currentWP setWaypointPosition [_expectedPos,20];};
		};
	} forEach _respondingGroups;

	_this setVariable ["params",[_side,_respondingGroups,_targets]];
},90,[_side,_respondingGroups,_targets]] call CBA_fnc_createPerFrameHandlerObject;
