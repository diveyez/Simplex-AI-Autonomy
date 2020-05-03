#include "script_component.hpp"

params ["_list","_checkAT"];

private _infantry = [];
private _tanks = [];
private _cars = [];
private _helis = [];
private _ATInfantry = [];

if (_checkAT) then {
	{
		private _veh = vehicle _x;
		if (_veh isKindOf "CAManBase" || {_veh isKindOf "StaticWeapon"}) then {
			_infantry pushBack _x;
			private _mag = secondaryWeaponMagazine _x;
			if !(_mag isEqualTo []) then {
				private _ammoFlags = (_mag # 0) call FUNC(getAmmoUsageFlags);
				if ("128" in _ammoFlags || "512" in _ammoFlags) then {_ATInfantry pushBack _x};
			};
		} else {
			if (_veh isKindOf "Tank" || {_veh isKindOf "Wheeled_APC_F"}) exitWith {_tanks pushBack _x};
			if (_veh isKindOf "Car") exitWith {_cars pushBack _x};
			if (_veh isKindOf "Helicopter") exitWith {_helis pushBack _x};
		};
	} forEach _list;
} else {
	{
		private _veh = vehicle _x;
		if (_veh isKindOf "CAManBase" || {_veh isKindOf "StaticWeapon"}) then {
			_infantry pushBack _x;
		} else {
			if (_veh isKindOf "Tank" || {_veh isKindOf "Wheeled_APC_F"}) exitWith {_tanks pushBack _x};
			if (_veh isKindOf "Car") exitWith {_cars pushBack _x};
			if (_veh isKindOf "Helicopter") exitWith {_helis pushBack _x};
		};
	} forEach _list;
};

[_infantry,_tanks,_cars,_helis,_ATInfantry]
