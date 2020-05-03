#include "script_component.hpp"

params ["_groups","_assignment","_requestDistance","_responseDistance","_extraParams",["_customOrigin",[]]];

_assignment = toUpper _assignment;

if (isNil "SAA_EFID") then {
	[] call FUNC(start);
};

{
	// Mod compatibility
	_x setVariable ["lambs_danger_disableGroupAI",true,true];
	{_x setVariable ["lambs_danger_disableAI",true,true]} forEach units _x;
	_x setVariable ["Vcm_Disable",true,true];

	// SAA stuff
	_x allowFleeing 0;
	{
		_x setSkill ["general",1];
		_x setSkill ["commanding",1];
		_x setSkill ["courage",1];
	} forEach units _x;
	_x setVariable ["SAA_assignment",_assignment,true];
	_x setVariable ["SAA_requestDistance",_requestDistance,true];
	_x setVariable ["SAA_responseDistance",_responseDistance,true];

	if (_customOrigin isEqualTo []) then {
		_x setVariable ["SAA_origin",[getPos leader _x,getDir leader _x],true];
	} else {
		_x setVariable ["SAA_origin",_customOrigin,true];
	};

	_x setVariable ["SAA_side",side _x,true];
	_x setVariable ["SAA_targetsToReport",[],true];
	_x setVariable ["SAA_target",objNull,true];

	switch (_assignment) do {
		case "FREE" : {
			_x setVariable ["SAA_available",true,true];
		};

		case "GARRISON" : {
			_extraParams params ["_teleport","_garrisonType"];

			if (_garrisonType in [1,2]) then {
				_x setVariable ["SAA_available",false,true];
			} else {
				_x setVariable ["SAA_available",true,true];
			};

			_x setVariable ["SAA_garrisonType",_garrisonType,true];
			[FUNC(garrison),[_x,_teleport],2] call CBA_fnc_waitAndExecute; // Delay for locality transfer issue
		};

		case "PATROL" : {
			_extraParams params ["_routeStyle","_routeType","_patrolRadius"];

			_x setVariable ["SAA_available",true,true];

			_x setVariable ["SAA_patrolRadius",_patrolRadius,true];
			_x setVariable ["SAA_routeType",_routeType,true];
			_x setVariable ["SAA_routeStyle",_routeStyle,true];
			_x call FUNC(patrol);
		};

		case "QRF" : {
			_x setVariable ["SAA_available",true,true];

			if ((_x getVariable "SAA_origin") # 0 distance leader _x > 20) then {
				_x call FUNC(returnToOrigin);
			} else {
				[FUNC(mountQRF),_x,2] call CBA_fnc_waitAndExecute; // Delay for locality transfer issue
			};
		};

		case "SENTRY" : {
			_x setVariable ["SAA_available",true,true];

			if ((_x getVariable "SAA_origin") # 0 distance leader _x > 20) then {
				_x call FUNC(returnToOrigin);
			};
		};
	};
} forEach _groups;

SAA_DEBUG_2("%1 Groups Added: %2",_assignment,_groups)

["SAA_groupsAssigned",[_groups,_assignment]] call CBA_fnc_globalEvent;
