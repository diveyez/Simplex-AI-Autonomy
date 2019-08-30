#include "script_component.hpp"

//-----------------------------------------------------------------------------------------------//

["SAA_setting_flaresEnabled","CHECKBOX",
	["Give UAV Terminal on drone request","Gives CAS Drone requesters a UAV terminal if they don't have one"],
	"Simplex AI Autonomy",
	true, // _valueInfo
	true, // _isGlobal
	{},
	false // _needRestart
] call CBA_fnc_addSetting;

["SAA_setting_enableDebug","CHECKBOX",
	"Enable Debug",
	["Simplex AI Autonomy","Development"],
	false, // _valueInfo
	false, // _isGlobal
	{},
	false // _needRestart
] call CBA_fnc_addSetting;

//-----------------------------------------------------------------------------------------------//

["ModuleCurator_F","init",{
	params ["_zeus"];

	_zeus addEventHandler ["CuratorWaypointDeleted",{
		params ["_curator","_group"];

		if (!isNil {_group getVariable "SAA_assignment"}) then {
			if ((_group getVariable "SAA_assignment") == "FREE" && _group getVariable "SAA_available") exitWith {};

			if ((_group getVariable "SAA_garrisonType") in [1,2]) then {
				_group setVariable ["SAA_available",false,true];
			} else {
				_group setVariable ["SAA_available",true,true];
			};

			["SAA_returnToOrigin",_group] call CBA_fnc_serverEvent;
			SAA_WARNING_1("A waypoint has been deleted. Attempting to reset group: %1",_group)
		};
	}];
}] call CBA_fnc_addClassEventHandler;
