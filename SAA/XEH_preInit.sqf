#include "script_component.hpp"

SAA_targets_EAST = [];
SAA_targets_GUER = [];
SAA_targets_WEST = [];

SAA_setting_flaresEnabled = true;
SAA_enableDebug = false;

["ModuleCurator_F","init",{
	params ["_zeus"];

	_zeus addEventHandler ["CuratorWaypointDeleted",{
		params ["_curator","_group"];

		if (!isNil {_group getVariable "SAA_assignment"}) then {
			if ((_group getVariable "SAA_assignment") == "FREE" && _group getVariable "SAA_available") exitWith {};

			_group setVariable ["SAA_available",true,true];
			[_group] remoteExecCall ["SAA_fnc_returnToOrigin",2];
			SAA_WARNING_1("A waypoint has been deleted. Attempting to reset group: %1",_group)
		};
	}];
}] call CBA_fnc_addClassEventHandler;
