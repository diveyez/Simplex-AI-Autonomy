#include "script_component.hpp"

[{
	params ["_group"];

	if ({alive _x} count units _group isEqualTo 0) exitWith {};

	[{
		params ["_group","_oldPos"];

		if ({alive _x} count units _group isEqualTo 0) exitWith {};

		if (_oldPos distance getPos leader _group < 20 && count (waypoints _group) != 0) then {
			private _currentWP = [_group,currentWaypoint _group];
			_currentWP setWaypointPosition [waypointPosition _currentWP,25];
			units _group doFollow leader _group;
			SAA_DEBUG_1("Nudging %1",_group)
		};
	},[_group,getPos leader _group],25] call CBA_fnc_waitAndExecute;
},_this,15] call CBA_fnc_waitAndExecute;
