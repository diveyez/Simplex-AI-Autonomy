#include "script_component.hpp"
#define COMPLETION_RADIUS_VEHICLE 200

params ["_respondingGroups","_side","_regroupPos"];

{
	private _group = _x;
	private _target = _group getVariable "SAA_target";
	private _targetPos = getPos _target;

	_group setVariable ["SAA_available",false];
	[_group,true] call SAA_fnc_clearWaypoints;
	{_x disableAI "AUTOCOMBAT"} forEach units _group;

	// Mount up
	private _completionRadius = 10;
	if (leader _group distance2D _target >= 400) then {
		private _vehicles = [];
		private _infantry = [];
		{
			if !(_x in _x) then {
				private _vehicle = vehicle _x;
				private _driver = driver _vehicle;

				if (alive _driver && _driver in units _group) then {
					_vehicles pushBackUnique _vehicle;
					if (_vehicle isKindOf "Helicopter") then {
						_vehicle flyInHeight 140;
						_group reveal _target;
					};
				};
			} else {
				_infantry pushBack _x
			};
		} forEach units _group;
		if !(_vehicles isEqualTo []) then {
			_completionRadius = COMPLETION_RADIUS_VEHICLE;

			{
				private _openVehicle = selectRandom (_vehicles select {_x emptyPositions "Cargo" > 0});
				if (!isNil "_openVehicle") then {
					_x assignAsCargo _openVehicle;
					[_x] orderGetIn true;
				};
			} forEach _infantry;
		};
	};

	// Regroup and attack
	_group setVariable ["SAA_regroupComplete",false];
	[_group,_regroupPos,20,"MOVE","AWARE","GREEN","NORMAL","WEDGE",["
		group this getVariable 'SAA_regroupComplete'
	","
		{
			_x enableAI 'AUTOCOMBAT';
			if (!(_x in _x) && {(assignedVehicleRole _x) # 0 == 'cargo'}) then {
				unassignVehicle _x;
				[_x] orderGetIn false;
			};
		} forEach units group this;
	"],[0,0,0],50] call SAA_fnc_addWaypoint;
	[_group,_targetPos,0,"SAD","AWARE","YELLOW","NORMAL","WEDGE",["
		(group this) getVariable 'SAA_available'
	","
		(group this) call SAA_fnc_returnToOrigin;
	"],[0,0,0],10] call SAA_fnc_addWaypoint;
	_group call SAA_fnc_theNudge;
} forEach _respondingGroups;

[{
	params ["_respondingGroups","_regroupPos"];
	(_respondingGroups select {(leader _x distance2D _regroupPos) > 150 || ({alive _x} count units _x) != 0}) isEqualTo []
},{
	{_x setVariable ["SAA_regroupComplete",true]} forEach (_this # 0);
},[_respondingGroups,_regroupPos],120 + round random 30,{
	{_x setVariable ["SAA_regroupComplete",true]} forEach (_this # 0);
}] call CBA_fnc_waitUntilAndExecute;
