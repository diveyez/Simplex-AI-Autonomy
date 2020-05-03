#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

//-----------------------------------------------------------------------------------------------//

["SAA_setting_flaresEnabled","CHECKBOX",
	["Enable flares","Enable flares on detection"],
	"Simplex AI Autonomy",
	true, // _valueInfo
	true, // _isGlobal
	{},
	false // _needRestart
] call CBA_fnc_addSetting;

["SAA_setting_smokeEnabled","CHECKBOX",
	["Enable smoke","Enable smoke grenades on detection"],
	"Simplex AI Autonomy",
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SAA_setting_smokeColorWEST","LIST",
	["Side smoke color - WEST","Default smoke color used for side"],
	"Simplex AI Autonomy",
	[[0,1,2,3,4],["White","Blue","Green","Yellow","Red"],0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SAA_setting_smokeColorEAST","LIST",
	["Side smoke color - EAST","Default smoke color used for side"],
	"Simplex AI Autonomy",
	[[0,1,2,3,4],["White","Blue","Green","Yellow","Red"],0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SAA_setting_smokeColorGUER","LIST",
	["Side smoke color - GUER","Default smoke color used for side"],
	"Simplex AI Autonomy",
	[[0,1,2,3,4],["White","Blue","Green","Yellow","Red"],0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SAA_setting_enableDebug","CHECKBOX",
	"Enable debug",
	["Simplex AI Autonomy","Development"],
	false,
	false,
	{},
	false
] call CBA_fnc_addSetting;

["SAA_setting_cachingEnabled","CHECKBOX",
	"Enable simple caching",
	["Simplex AI Autonomy","Caching"],
	true,
	true,
	{},
	true
] call CBA_fnc_addSetting;

["SAA_setting_cachingDistance","EDITBOX",
	"Caching distance from player",
	["Simplex AI Autonomy","Caching"],
	"1800",
	true,
	{missionNamespace setVariable ["SAA_cachingDistance",parseNumber _this,true]},
	false
] call CBA_fnc_addSetting;

//-----------------------------------------------------------------------------------------------//

["ModuleCurator_F","init",{
	[_this # 0,"CuratorWaypointDeleted",{
		params ["_curator","_group"];

		if (!isNil {_group getVariable "SAA_assignment"}) then {
			if ((_group getVariable "SAA_assignment") == "FREE" && _group getVariable "SAA_available") exitWith {};

			if ((_group getVariable "SAA_garrisonType") in [1,2]) then {
				_group setVariable ["SAA_available",false,true];
			} else {
				_group setVariable ["SAA_available",true,true];
			};

			["SAA_returnToOrigin",_group,_group] call CBA_fnc_targetEvent;
			SAA_WARNING_1("A waypoint has been deleted. Attempting to reset group: %1",_group)
		};
	}] call CBA_fnc_addBISEventHandler;
}] call CBA_fnc_addClassEventHandler;

GVAR(headlessClients) = [];

if (isServer) then {
	["SAA_headlessClientJoined",{
		params ["_headlessClient"];

		if (_headlessClient in GVAR(headlessClients)) exitWith {};

		GVAR(headlessClients) pushBack _headlessClient;
		publicVariable QGVAR(headlessClients);
	}] call CBA_fnc_addEventHandler;
};

ADDON = true;
