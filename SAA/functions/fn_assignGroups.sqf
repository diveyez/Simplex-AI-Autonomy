#include "script_component.hpp"

params ["_groups","_assignment","_requestDistance","_responseDistance","_extraParams"];

{
	_x allowFleeing 0;
	_x setVariable ["SAA_assignment",_assignment,true];
	_x setVariable ["SAA_requestDistance",_requestDistance,true];
	_x setVariable ["SAA_responseDistance",_responseDistance,true];
	_x setVariable ["SAA_origin",[getPos leader _x,getDir leader _x],true];
	_x setVariable ["SAA_side",side _x,true];
	_x setVariable ["SAA_targetsToReport",[],true];
	_x setVariable ["SAA_target",objNull,true];

	switch (_assignment) do {
		case "FREE" : {_x setVariable ["SAA_available",true,true];};
		case "GARRISON" : {
			_extraParams params ["_teleport","_garrisonType"];

			if (_garrisonType in [1,2]) then {
				_x setVariable ["SAA_available",false,true];
			} else {
				_x setVariable ["SAA_available",true,true];
			};

			_x setVariable ["SAA_garrisonType",_garrisonType,true];
			[{_this call SAA_fnc_garrison},[_x,_teleport],2] call CBA_fnc_waitAndExecute; // Delay for locality transfer issue
		};
		case "PATROL" : {
			_extraParams params ["_routeStyle","_routeType","_patrolRadius"];

			_x setVariable ["SAA_available",true,true];

			_x setVariable ["SAA_patrolRadius",parseNumber _patrolRadius,true];
			_x setVariable ["SAA_routeType",_routeType,true];
			_x setVariable ["SAA_routeStyle",_routeStyle,true];
			_x call SAA_fnc_patrol;
		};
		case "QRF" : {
			_x setVariable ["SAA_available",true,true];

			[{
				private _vehicles = [];
				private _infantry = [];
				{
					if (vehicle _x isKindOf "Car" || vehicle _x isKindOf "Tank") then {_vehicles pushBackUnique (vehicle _x)};
					if (_x in _x) then {_infantry pushBack _x};
				} forEach units _this;
				if (_vehicles isEqualTo []) exitWith {};
				{
					private _openVehicle = selectRandom (_vehicles select {_x emptyPositions "Cargo" > 0});
					if (!isNil "_openVehicle") then {
						_x assignAsCargo _openVehicle;
						[_x] orderGetIn true;
					};
				} forEach _infantry;
			},_x,2] call CBA_fnc_waitAndExecute; // Delay for locality transfer issue
		};
		case "SENTRY" : {_x setVariable ["SAA_available",true,true];};
	};
} forEach _groups;

SAA_DEBUG_2("%1 Groups Added: %2",_assignment,_groups)
