#include "script_component.hpp"
#define ASSIGNMENT_SELECTION(ASSIGNMENT) \
	params ["_posASL","_obj"]; \
	if (isNull _obj) then { \
		[{ \
			(_this select 0) params ["_objects","_groups"]; \
			if (_objects isEqualTo [] && {_groups isEqualTo []}) exitWith {[objNull,"Nothing selected"] call BIS_fnc_showCuratorFeedbackMessage;}; \
			{_groups pushBackUnique (group _x)} forEach _objects; \
			_groups = (_groups select {side _x in [west,east,independent] && isNil {_x getVariable "SAA_assignment"}}) - (allPlayers apply {group _x}); \
			if (_groups isEqualTo []) exitWith {[objNull,"No valid groups were selected"] call BIS_fnc_showCuratorFeedbackMessage;}; \
			[ASSIGNMENT,_groups] call SAA_fnc_assignmentDialog; \
		}] call SAA_fnc_zeusSelection; \
	} else { \
		private _group = group _obj; \
		if !(side _group in [west,east,independent]) exitWith {}; \
		if !(isNil {_group getVariable "SAA_assignment"}) exitWith {}; \
		[ASSIGNMENT,_group] call SAA_fnc_assignmentDialog; \
	};

["Simplex AI Autonomy","Assign Free",{ASSIGNMENT_SELECTION("FREE")}] call zen_custom_modules_fnc_register;
["Simplex AI Autonomy","Assign Garrison",{ASSIGNMENT_SELECTION("GARRISON")}] call zen_custom_modules_fnc_register;
["Simplex AI Autonomy","Assign Patrol",{ASSIGNMENT_SELECTION("PATROL")}] call zen_custom_modules_fnc_register;
["Simplex AI Autonomy","Assign QRF",{ASSIGNMENT_SELECTION("QRF")}] call zen_custom_modules_fnc_register;
["Simplex AI Autonomy","Assign Sentry",{ASSIGNMENT_SELECTION("SENTRY")}] call zen_custom_modules_fnc_register;
