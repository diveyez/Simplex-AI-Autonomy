#include "script_component.hpp"

params ["_side","_respondingGroups","_targets"];

_respondingGroups = _respondingGroups select {({alive _x} count units _x) != 0 && !(_x getVariable ["SAA_available",false])};

if (_respondingGroups isEqualTo []) exitWith {
	["SAA_cleanupTargets",[_side,_targets]] call CBA_fnc_serverEvent;
	SAA_DEBUG_1("Engagement - No groups to respond to targets: %1",_targets)
};

[{
	(_this getVariable "params") params ["_side","_respondingGroups","_targets"];

	_respondingGroups = _respondingGroups select {({alive _x} count units _x) != 0 && !(_x getVariable ["SAA_available",false])};

	// Stop if no more responding groups
	if (_respondingGroups isEqualTo []) exitWith {
		["SAA_cleanupTargets",[_side,_targets]] call CBA_fnc_serverEvent;
		_this setVariable ["exit_condition",{true}];
		SAA_DEBUG_1("Engagement - No groups to respond to targets: %1",_targets);
	};

	// Forget about dead or empty targets
	private _deadTargets = _targets select {({alive _x} count crew _x) isEqualTo 0};
	if !(_deadTargets isEqualTo []) then {
		["SAA_cleanupTargets",[_side,_deadTargets]] call CBA_fnc_serverEvent;
		_targets = _targets - _deadTargets;
		SAA_DEBUG_1("Engagement - Dead or empty targets: %1",_deadTargets);
	};

	// Stop if no more targets
	if (_targets isEqualTo []) exitWith {
		{_x setVariable ["SAA_available",true,true]} forEach _respondingGroups;
		_this setVariable ["exit_condition",{true}];
		SAA_DEBUG("Engagement - No more targets");
	};

	// Handle unknown targets
	private _previousUnknownTargets = _this getVariable ["SAA_unknownTargets",[]];
	private _latestUnknownTargets = [];
	{_unknownTargets append (_x getVariable ["SAA_unknownTargets",[]])} forEach _respondingGroups;
	_this setVariable ["SAA_unknownTargets",_unknownTargets];

	{["SAA_checkForUnknownTargets",[_x,_targets],_x] call CBA_fnc_targetEvent} forEach _respondingGroups;

	if (!(_previousUnknownTargets isEqualTo []) && !(_latestUnknownTargets isEqualTo [])) then {
		private _unknownTargets = _previousUnknownTargets arrayIntersect _latestUnknownTargets;
		_targets = _targets - _unknownTargets;
		["SAA_cleanupTargets",[_side,_unknownTargets]] call CBA_fnc_serverEvent;
		SAA_DEBUG_1("Engagement - Targets considered unknown: %1",_unknownTargets);
	};

	// Stop if no more targets
	if (_targets isEqualTo []) exitWith {
		{_x setVariable ["SAA_available",true,true]} forEach _respondingGroups;
		_this setVariable ["exit_condition",{true}];
		SAA_DEBUG("Engagement - No more targets");
	};

	private _knownTargets = _targets - _latestUnknownTargets;

	// Evaluate manpower
	// TODO: Like 'analyzeAndCollect' except use only 'responding groups' vs 'known targets'
	// If engagement is fucked, end it so targets can be revaluated normally

	SAA_DEBUG_2("Engagement - Continues: %1 -VS- %2",_respondingGroups,_knownTargets);

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

			if (_expectedPos isEqualTo [0,0,0]) exitWith {};
			
			_currentWP setWaypointPosition [_expectedPos,20];

			// Throw smokes
			if (SAA_setting_smokeEnabled) then {
				private _distance = _expectedPos distance leader _group;
				if (_distance < 450 && _distance > 20) then {
					private _smokeCount = 0;
					private _smokeType = switch (_side) do {
						case west : {SMOKE_TYPES # SAA_setting_smokeColorWEST};
						case east : {SMOKE_TYPES # SAA_setting_smokeColorEAST};
						case independent : {SMOKE_TYPES # SAA_setting_smokeColorGUER};
						default {SMOKE_TYPES # 0};
					};

					{
						if (alive _x && {_x in _x && _smokeCount <= 2 && random 1 < 0.5}) then {
							[_x,_smokeType # 0,_smokeType # 1,_expectedPos] call FUNC(throwGrenade);
							_smokeCount = _smokeCount + 1;
						};
					} forEach units _group;
				};
			};
		};
	} forEach _respondingGroups;

	_this setVariable ["params",[_side,_respondingGroups,_targets]];
},60,[_side,_respondingGroups,_targets]] call CBA_fnc_createPerFrameHandlerObject;
