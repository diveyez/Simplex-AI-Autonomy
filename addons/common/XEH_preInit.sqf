#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
#include "cba_settings.sqf"

///////////////////////////////////////////////////////////////////////////////////////////////////
// Misc

if (isServer) then {
	[QGVAR(addWaypointServer),{
		params ["_WP","_behaviour","_combatMode","_speed","_formation"];
		_WP setWaypointBehaviour _behaviour;
		_WP setWaypointCombatMode _combatMode;
		_WP setWaypointSpeed _speed;
		_WP setWaypointFormation _formation;	
	}] call CBA_fnc_addEventHandler;

	[QGVAR(transferGroupsServer),{
		params ["_owner","_groups"];
		if (_owner isEqualType objNull) then {_owner = owner _owner};
		{_x setGroupOwner _owner} forEach _groups;
	}] call CBA_fnc_addEventHandler;
};

[QGVAR(transferGroups),FUNC(transferGroups)] call CBA_fnc_addEventHandler;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Headless clients

if (isNil QGVAR(headlessClients)) then {
	GVAR(headlessClients) = [];
};

if (isServer) then {
	[QGVAR(headlessClientJoined),{
		params ["_entity"];
		GVAR(headlessClients) pushBackUnique _entity;
		publicVariable QGVAR(headlessClients);
	}] call CBA_fnc_addEventHandler;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
// Remote execution

[QGVAR(execute),{
	params ["_args",["_fnc",{},["",{}]]];

	if (_fnc isEqualType "") exitWith {
		_args call (missionNamespace getVariable [_fnc,{}]);
	};

	if (_fnc isEqualType {}) exitWith {
		_args call _fnc;
	};
}] call CBA_fnc_addEventHandler;

///////////////////////////////////////////////////////////////////////////////////////////////////
// AI Sub-skills

["CAManBase","initPost",{
	params ["_unit"];
	if (GVAR(applySubSkills) && local _unit) then {
		_unit call FUNC(applySubSkills);
	};
}] call CBA_fnc_addClassEventHandler;

["CAManBase","Local",{
	params ["_unit","_local"];
	if (GVAR(applySubSkills) && _local) then {
		_unit call FUNC(applySubSkills);
	};
}] call CBA_fnc_addClassEventHandler;

///////////////////////////////////////////////////////////////////////////////////////////////////

ADDON = true;
