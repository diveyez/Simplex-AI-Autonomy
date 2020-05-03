#include "script_component.hpp"

private _group = _this;

if (_group getVariable ["SAA_cached",false]) exitWith {};
_group setVariable ["SAA_cached",true];

private _assignment = _group getVariable "SAA_assignment";
private _extraParams = switch (_assignment) do {
	case "GARRISON" : {[false,_group getVariable "SAA_garrisonType"]};
	case "PATROL" : {[_group getVariable "SAA_routeStyle",_group getVariable "SAA_routeType",_group getVariable "SAA_patrolRadius"]};
	default {[]};
};

private _vehicles = [];
private _groupUnits = [];
private _groupVehicles = [];
private _cachePosition = getPos leader _group;

{
	if (alive _x) then {
		if (_x in _x) then {
			_groupUnits pushBack [typeOf _x,getPosASL _x,getDirVisual _x];
			deleteVehicle _x;
		} else {
			_vehicles pushBackUnique vehicle _x;
		};
	} else {
		if (_x in _x) then {
			deleteVehicle _x;
		} else {
			vehicle _x deleteVehicleCrew _x;
		};
	};
} forEach units _group;

{
	private _vehicle = _x;
	private _vehicleUnits = [];

	{
		_x params ["_unit","_role"];

		if (alive _unit && _unit in units _group) then {
			_vehicleUnits pushBack [typeOf _unit,_role];
		};

		_vehicle deleteVehicleCrew _unit;
	} forEach fullCrew _vehicle;

	if !(_vehicleUnits isEqualTo []) then {
		_groupVehicles pushBack [typeOf _vehicle,getPosASL _vehicle,getDirVisual _vehicle,_vehicleUnits];
		deleteVehicle _vehicle;
	};
} forEach _vehicles;

private _cacheArray = [_cachePosition,[
	_assignment,
	_group getVariable "SAA_side",
	_group getVariable "SAA_origin",
	_group getVariable "SAA_requestDistance",
	_group getVariable "SAA_responseDistance",
	_extraParams
],_groupUnits,_groupVehicles,(waypoints _group) apply {[
	waypointPosition _x,0,waypointType _x,
	waypointBehaviour _x,waypointCombatMode _x,
	waypointSpeed _x,waypointFormation _x,
	waypointStatements _x,waypointTimeout _x,
	waypointCompletionRadius _x
]}];

SAA_cachedGroups pushBack _cacheArray;

deleteGroup _group;
