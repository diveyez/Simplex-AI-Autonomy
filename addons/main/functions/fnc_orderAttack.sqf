#include "script_component.hpp"
#define COMPLETION_RADIUS_VEHICLE 200

params ["_respondingGroups"];

{
	private _group = _x;
	private _target = _group getVariable "SAA_target";
	private _targetPos = getPos _target;

	_group setVariable ["SAA_available",false,true];
	[_group,true] call FUNC(clearWaypoints);

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

	// Attack
	if ((random 1 < 0.5 && _completionRadius < COMPLETION_RADIUS_VEHICLE) || leader _group distance2D _targetPos < 400) then {
		[_group,_targetPos,0,"SAD","AWARE","YELLOW","NORMAL","WEDGE",["
			(group this) getVariable 'SAA_available'
		","
			['SAA_returnToOrigin',group this,group this] call CBA_fnc_targetEvent;
		"],[0,0,0],_completionRadius] call FUNC(addWaypoint);
		_group call FUNC(theNudge);
	} else {
		private _leader = leader _group;
		private _flankPos = _target getPos [200,(_target getDir _leader) + ([-90,90] select (random 1 < 0.5))];

		[_group,_flankPos,0,"MOVE","AWARE","GREEN","FULL","WEDGE",["true","
			{
				if (!(_x in _x) && {(assignedVehicleRole _x) # 0 == 'cargo'}) then {
					unassignVehicle _x;
					[_x] orderGetIn false;
				};
			} forEach units group this;
		"],[0,0,0],_completionRadius] call FUNC(addWaypoint);
		[_group,_targetPos,0,"SAD","AWARE","YELLOW","NORMAL","WEDGE",["
			(group this) getVariable 'SAA_available'
		","
			['SAA_returnToOrigin',group this,group this] call CBA_fnc_targetEvent;
		"],[0,0,0],10] call FUNC(addWaypoint);
		_group call FUNC(theNudge);
	};
} forEach _respondingGroups;