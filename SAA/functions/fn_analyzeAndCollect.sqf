#include "script_component.hpp"
#define ASSISTANCE_MULTIPLIER 1.3
#define QRF_MULTIPLIER 0.65
#define RATING_HELI 7
#define RATING_TANK 6
#define RATING_CAR 3

params ["_group","_side","_targets"];

private _canEngage = true;
private _respondingGroups = [];
private _strength = 0;

// Calculate enemy threat and assist ratios
([_targets,false] call SAA_fnc_getTypes) params ["_enemyInfantry","_enemyTanks","_enemyCars"];
private _enemyThreat = count _enemyInfantry + count _enemyTanks * RATING_TANK + count _enemyCars * RATING_CAR;
private _assistRatio = _enemyThreat * ASSISTANCE_MULTIPLIER;
private _QRFRatio = _assistRatio * QRF_MULTIPLIER;
//private _vehicleRatio = _assistRatio * 0.3;

// Add the reporting group if it's free
if (_group getVariable "SAA_available") then {
	_respondingGroups pushBack _group;
	_group setVariable ["SAA_target",selectRandom _targets,true];
	([units _group,true] call SAA_fnc_getTypes) params ["_infantry","_tanks","_cars","_helis","_groupAT"];
	_strength = _strength + count _infantry + count _tanks * RATING_TANK + count _cars * RATING_CAR + count _helis * RATING_HELI;
	_canEngage = count _groupAT >= count _enemyTanks;
};

// Get the nearest available groups and units
private _leader = leader _group;
private _availableGroups = (allGroups select {
	!isNil {_x getVariable "SAA_assignment"} && {
	(_x getVariable "SAA_side") isEqualTo _side && {
	_x getVariable "SAA_available"
}}}) - [_group];

if (_availableGroups isEqualTo []) exitWith {[_canEngage,_enemyThreat,0,_respondingGroups]};

private _requestDistance = _group getVariable "SAA_requestDistance";
private _nearbyGroups = _availableGroups select {
	private _distance = leader _x distance2D _leader;
	_distance <= _requestDistance && {_distance <= (_x getVariable "SAA_responseDistance")}
};

if (_nearbyGroups isEqualTo []) exitWith {[_canEngage,_enemyThreat,0,_respondingGroups]};

private _nearestGroups = _nearbyGroups apply {[leader _x distance2D _leader,_x]};
_nearestGroups sort true;
_nearestGroups = _nearestGroups apply {_x # 1};

private _nearestUnits = [];
private _immUnits = [];
{
	_nearestUnits append (units _x);

	if (leader _x distance2D _leader < 400) then {
		_immUnits append (units _x);
		_x setBehaviour "AWARE";
		_x setSpeedMode "NORMAL";
	};
} forEach _nearestGroups;

([_nearestUnits,true] call SAA_fnc_getTypes) params ["_nearestInfantry","_nearestTanks","_nearestCars","_nearestHelis","_nearestAT"];

// Calculate immediate strength
private _immInfantry = _nearestInfantry arrayIntersect _immUnits;
private _immTanks = _nearestTanks arrayIntersect _immUnits;
private _immCars = _nearestCars arrayIntersect _immUnits;
private _immHelis = _nearestHelis arrayIntersect _immUnits;
private _immAT = _nearestAT arrayIntersect _immUnits;
private _immediateStrength = count _immInfantry + count _immTanks * RATING_TANK + count _immCars * RATING_CAR + count _immHelis * RATING_HELI + (count _immAT * RATING_TANK * 0.75);

// Add any needed AT units
if !(_enemyTanks isEqualTo []) then {
	{
		if !(_nearestAT isEqualTo []) then {
			private _grp = group (_nearestAT deleteAt 0);
			private _idx = _respondingGroups pushBackUnique _grp;
			if (_idx != -1) then {
				_grp setVariable ["SAA_target",_x,true];
				([units _grp,false] call SAA_fnc_getTypes) params ["_infantry","_tanks","_cars","_helis"];
				_strength = _strength + count _infantry + count _tanks * RATING_TANK + count _cars * RATING_CAR + count _helis * RATING_HELI;
				if (!_canEngage) then {_canEngage = leader _grp distance _leader < 400;};
			};
		};
		if !(_nearestTanks isEqualTo []) then {
			private _grp = group (_nearestTanks deleteAt 0);
			private _idx = _respondingGroups pushBackUnique _grp;
			if (_idx != -1) then {
				_grp setVariable ["SAA_target",_x,true];
				([units _grp,false] call SAA_fnc_getTypes) params ["_infantry","_tanks","_cars","_helis"];
				_strength = _strength + count _infantry + count _tanks * RATING_TANK + count _cars * RATING_CAR + count _helis * RATING_HELI;
				if (!_canEngage) then {_canEngage = leader _grp distance _leader < 400;};
			};
		};
	} forEach _enemyTanks;
};

// Add nearest QRF until ratio satisfied
private _availableQRF = _availableGroups select {(_x getVariable "SAA_assignment") == "QRF"};
if !(_availableQRF isEqualTo []) then {
	private _nearestQRF = _availableQRF apply {[leader _x distance2D _leader,_x]};
	_nearestQRF sort true;

	{
		if (_strength >= _QRFRatio) exitWith {};
		private _idx = _respondingGroups pushBackUnique _x;
		if (_idx != -1) then {
			_x setVariable ["SAA_target",selectRandom _targets,true];
			([units _x,false] call SAA_fnc_getTypes) params ["_infantry","_tanks","_cars","_helis"];
			_strength = _strength + count _infantry + count _tanks * RATING_TANK + count _cars * RATING_CAR + count _helis * RATING_HELI;
		};
	} forEach (_nearestQRF apply {_x # 1});
};

// Add any extra needed groups until ratio satisfied
if !(_nearestGroups isEqualTo []) then {
	{
		if (_strength >= _assistRatio) exitWith {};
		private _idx = _respondingGroups pushBackUnique _x;
		if (_idx != -1) then {
			_x setVariable ["SAA_target",selectRandom _targets,true];
			([units _x,false] call SAA_fnc_getTypes) params ["_infantry","_tanks","_cars","_helis"];
			_strength = _strength + count _infantry + count _tanks * RATING_TANK + count _cars * RATING_CAR + count _helis * RATING_HELI;
		};
	} forEach _nearestGroups;
};

// Return
[_canEngage,_enemyThreat,_immediateStrength,_respondingGroups]
