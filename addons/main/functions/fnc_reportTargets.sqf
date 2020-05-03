#include "script_component.hpp"

private _group = _this;

if (isNull _group || {({alive _x} count units _group) isEqualTo 0}) exitWith {};

private _side = _group getVariable "SAA_side";
private _sideTargets = missionNamespace getVariable [format ["SAA_targets_%1",_side],[]];
private _newTargets = ((_group getVariable "SAA_targetsToReport") select {({alive _x} count crew _x) != 0}) - _sideTargets;

_group setVariable ["SAA_targetsToReport",[]];

if (_newTargets isEqualTo []) exitWith {};

// Report targets
["SAA_reportTargets",[_side,_newTargets]] call CBA_fnc_serverEvent;

// Process how to handle new targets
([_group,_side,_newTargets] call FUNC(analyzeAndCollect)) params ["_canEngage","_enemyThreat","_immediateStrength","_respondingGroups"];

private _target = _group getVariable "SAA_target";

if !(_respondingGroups isEqualTo []) then {
	if (_canEngage && _enemyThreat <= _immediateStrength) then {
		// Attack
		[_respondingGroups] call FUNC(orderAttack);
		SAA_DEBUG_1("Groups attacking: %1",_respondingGroups)
	} else {
		// Regroup
		private _regroupPos = leader _group getPos [180 + round random 50,leader _target getDir leader _group];
		[_respondingGroups,_side,_regroupPos] call FUNC(orderRegroup);
		SAA_DEBUG_1("Groups regrouping: %1",_respondingGroups);
	};
};

// Track engagement so targets can be eligible for re-detection
["SAA_engagementStarted",[_side,_respondingGroups,_newTargets]] call CBA_fnc_serverEvent;

// Flares
if (SAA_setting_flaresEnabled && sunOrMoon < 1) then {
	[{
		for "_i" from 0 to (1 + round random 2) do {
			private _flare = createVehicle ["F_40mm_White",(selectRandom _this) getPos [random [20,40,60],random 360],[],0,"CAN_COLLIDE"];
			_flare setPosATL [getPosATL _flare # 0,getPosATL _flare # 1,180 + random 60];
			_flare setVelocity [0,0,-0.05];
		};
	},_newTargets,10 + round random 15] call CBA_fnc_waitAndExecute;
};

// Throw smokes
if (SAA_setting_smokeEnabled) then {
	private _distance = leader _target distance leader _group;
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
				[_x,_smokeType # 0,_smokeType # 1,getPos leader _target] call FUNC(throwGrenade);
				_smokeCount = _smokeCount + 1;
			};
		} forEach units _group;
	};
};
