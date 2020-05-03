#include "script_component.hpp"

params ["_cachePosition","_data","_groupUnits","_groupVehicles","_waypointsCache"];
_data params ["_assignment","_side","_origin","_requestDistance","_responseDistance","_extraParams"];

SAA_cachedGroups deleteAt ((SAA_cachedGroups apply {_x # 0}) find _cachePosition);

private _group = createGroup [_side,true];
private _spawns = [];

{
	_x params ["_type","_posASL","_dir"];

	private _unit = _group createUnit [_type,ASLtoAGL _posASL,[],0,"NONE"];
	_unit allowDamage false;
	_spawns pushBack _unit;
	_unit setDir _dir;
} forEach _groupUnits;

{
	_x params ["_type","_posASL","_dir","_units"];

	private _vehicle = createVehicle [_type,[0,0,999 + round random 999],[],0,"CAN_COLLIDE"];
	_vehicle allowDamage false;
	_spawns pushBack _vehicle;
	_vehicle setDir _dir;
	_vehicle setVehiclePosition [ASLToAGL _posASL,[],0,"NONE"];
	
	{
		_x params ["_type","_role"];

		private _unit = _group createUnit [_type,[0,0,0],[],0,"NONE"];
		_unit moveInAny _vehicle;
	} forEach _units;

	_group addVehicle _vehicle;
} forEach _groupVehicles;

[{{_x allowDamage true} forEach _this},_spawns,3] call CBA_fnc_waitAndExecute;

[[_group],_assignment,_requestDistance,_responseDistance,_extraParams,_origin] call FUNC(assignGroups);

if (_assignment == "FREE") then {
	[{
		params ["_group","_waypointsCache"];

		{([_group] + _x) call FUNC(addWaypoint)} forEach _waypointsCache;
	},[_group,_waypointsCache],5] call CBA_fnc_waitAndExecute;
};
