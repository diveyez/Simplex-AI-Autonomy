#include "script_component.hpp"

private _group = _this;
if (isNull _group || {({alive _x} count units _group) isEqualTo 0}) exitWith {};

private _side = _group getVariable "SAA_side";
private _sideTargets = missionNamespace getVariable format ["SAA_targets_%1",_side];
private _targetsToReport = ((_group getVariable "SAA_targetsToReport") select {({alive _x} count crew _x) != 0}) - _sideTargets;
_group setVariable ["SAA_targetsToReport",[]];
if (_targetsToReport isEqualTo []) exitWith {};

// Report targets
missionNamespace setVariable [format ["SAA_targets_%1",_side],_sideTargets + _targetsToReport,true];
//{_x setVariable [format ["SAA_LKP_%1",_side],getPos _x,true]} forEach _targetsToReport;
SAA_DEBUG_2("%1 - new targets: %2",_side,_targetsToReport)

// Flares
if (SAA_setting_flaresEnabled && sunOrMoon < 1) then {
	[{
		for "_i" from 0 to (1 + round random 2) do {
			private _flare = createVehicle ["F_40mm_White",(selectRandom _this) getPos [random [20,40,60],random 360],[],0,"CAN_COLLIDE"];
			_flare setPosATL [(getPosATL _flare) # 0,(getPosATL _flare) # 1,180 + random 60];
			_flare setVelocity [0,0,-0.05];
		};
	},_targetsToReport,10 + round random 15] call CBA_fnc_waitAndExecute;
};

// Process how to handle new targets
([_group,_side,_targetsToReport] call SAA_fnc_analyzeAndCollect) params ["_canEngage","_enemyThreat","_immediateStrength","_respondingGroups"];

if !(_respondingGroups isEqualTo []) then {
	if (_canEngage && _enemyThreat <= _immediateStrength) then {
		[_respondingGroups] call SAA_fnc_orderAttack;
		SAA_DEBUG_1("Groups attacking: %1",_respondingGroups)
	} else {
		private _regroupPos = leader _group getPos [180 + round random 50,leader (_group getVariable "SAA_target") getDir leader _group];
		[_respondingGroups,_side,_regroupPos] call SAA_fnc_orderRegroup;
		SAA_DEBUG_1("Groups regrouping: %1",_respondingGroups)
	};
};

// Track engagement so targets can be eligible for re-detection
[{_this call SAA_fnc_trackEngagement},[_side,_respondingGroups,_targetsToReport],60] call CBA_fnc_waitAndExecute;
