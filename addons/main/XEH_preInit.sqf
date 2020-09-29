#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

//-----------------------------------------------------------------------------------------------//

["SAA_setting_flaresEnabled","CHECKBOX",
	["Enable flares","Enable flares on detection"],
	["Simplex AI Autonomy","Main"],
	true, // _valueInfo
	true, // _isGlobal
	{},
	false // _needRestart
] call CBA_fnc_addSetting;

["SAA_setting_smokeEnabled","CHECKBOX",
	["Enable smoke","Enable smoke grenades on detection"],
	["Simplex AI Autonomy","Main"],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SAA_setting_smokeColorWEST","LIST",
	["Side smoke color - WEST","Default smoke color used for side"],
	["Simplex AI Autonomy","Main"],
	[[0,1,2,3,4],["White","Blue","Green","Yellow","Red"],0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SAA_setting_smokeColorEAST","LIST",
	["Side smoke color - EAST","Default smoke color used for side"],
	["Simplex AI Autonomy","Main"],
	[[0,1,2,3,4],["White","Blue","Green","Yellow","Red"],0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

["SAA_setting_smokeColorGUER","LIST",
	["Side smoke color - GUER","Default smoke color used for side"],
	["Simplex AI Autonomy","Main"],
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

[QGVAR(skillsApply),"CHECKBOX",
	["Automatically apply skills","Applies on spawn and locality transfer. Set ""SAA_setSkills"" variable false on unit to disable."],
	["Simplex AI Autonomy","AI Sub-skills"],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillsFullCourage),"CHECKBOX",
	["Full courage","True to always have full courage, false to follow ""general"" skill"],
	["Simplex AI Autonomy","AI Sub-skills"],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillsGeneral),"SLIDER",
	["Skills: General","Applies to: General, commanding, courage"],
	["Simplex AI Autonomy","AI Sub-skills"],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillsAccuracy),"SLIDER",
	["Skills: Accuracy","Applies to: Aiming accuracy"],
	["Simplex AI Autonomy","AI Sub-skills"],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillsHandling),"SLIDER",
	["Skills: Handling","Applies to: Aiming shake, aiming speed, reload speed"],
	["Simplex AI Autonomy","AI Sub-skills"],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(skillsSpotting),"SLIDER",
	["Skills: Spotting","Applies to: Spot distance, spot time"],
	["Simplex AI Autonomy","AI Sub-skills"],
	[0,1,0.5,2],
	true,
	{},
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

if (isNil QGVAR(headlessClients)) then {
	GVAR(headlessClients) = [];
};

if (isServer) then {
	["SAA_headlessClientJoined",{
		params ["_headlessClient"];

		if (_headlessClient in GVAR(headlessClients)) exitWith {};

		GVAR(headlessClients) pushBack _headlessClient;
		publicVariable QGVAR(headlessClients);
	}] call CBA_fnc_addEventHandler;

	[QGVAR(localityExec),{
		params ["_localitySelection","_params","_fncVar"];

		if (_localitySelection > (count GVAR(headlessClients) + 1)) exitWith {
			diag_log ("Headless client(s) disconnected during selection. Cancelling execution of " + _fncVar);
		};

		if (_localitySelection == 1) exitWith {
			_params call (missionNamespace getVariable _fncVar);
		};

		if (_localitySelection > 1) then {
			private _headlessClientID = owner (GVAR(headlessClients) # (_localitySelection - 2));
			_params remoteExecCall [_fncVar,_headlessClientID];
		};
	}] call CBA_fnc_addEventHandler;
};

//-----------------------------------------------------------------------------------------------//

// Occupation density presets
GVAR(presets) = profileNamespace getVariable [QGVAR(presets),[[
	["CSAT",[[
		[["O_Soldier_TL_F","O_soldier_AR_F","O_Soldier_GL_F","O_soldier_LAT_F"],[2,6]],
		[["O_Soldier_GL_F","O_Soldier_F"],[3,6]]
	],[
		[["O_Soldier_TL_F","O_soldier_AR_F","O_Soldier_GL_F","O_soldier_LAT_F"],[5,10]]
	],[
		[["O_Soldier_GL_F","O_Soldier_F"],[3,6]],
		[["O_MRAP_02_gmg_F","O_soldier_AR_F","O_soldier_LAT_F"],[0,2]]
	],[
		[["O_MRAP_02_gmg_F","O_soldier_AR_F","O_soldier_LAT_F"],[0,2]],
		[["O_Truck_03_transport_F","O_Soldier_SL_F","O_soldier_LAT_F","O_soldier_M_F","O_soldier_AR_F","O_Soldier_A_F","O_medic_F","O_Soldier_SL_F","O_soldier_LAT_F","O_soldier_M_F","O_Soldier_TL_F","O_soldier_AR_F","O_Soldier_A_F","O_medic_F"],[0,1]]
	]]]
],[
	["NATO",[[
		[["B_Soldier_TL_F","B_soldier_AR_F","B_Soldier_GL_F","B_soldier_LAT_F"],[2,6]],
		[["B_Soldier_GL_F","B_Soldier_F"],[3,6]]
	],[
		[["B_Soldier_TL_F","B_soldier_AR_F","B_Soldier_GL_F","B_soldier_LAT_F"],[5,10]]
	],[
		[["B_Soldier_GL_F","B_Soldier_F"],[3,6]],
		[["B_MRAP_01_gmg_F","B_soldier_AR_F","B_soldier_LAT_F"],[0,2]]
	],[
		[["B_MRAP_01_gmg_F","B_soldier_AR_F","B_soldier_LAT_F"],[0,2]],
		[["B_Truck_01_transport_F","B_Soldier_SL_F","B_soldier_LAT_F","B_soldier_M_F","B_soldier_AR_F","B_Soldier_A_F","B_medic_F","B_Soldier_SL_F","B_soldier_LAT_F","B_soldier_M_F","B_Soldier_TL_F","B_soldier_AR_F","B_Soldier_A_F","B_medic_F"],[0,1]]
	]]]
],[]]];

//-----------------------------------------------------------------------------------------------//
// AI Sub-skills

["CAManBase","initPost",{
	params ["_unit"];
	if (GVAR(skillsApply) && local _unit) then {
		_unit call FUNC(applySkills);
	};
}] call CBA_fnc_addClassEventHandler;

["CAManBase","Local",{
	params ["_unit","_local"];
	if (GVAR(skillsApply) && _local) then {
		_unit call FUNC(applySkills);
	};
}] call CBA_fnc_addClassEventHandler;

//-----------------------------------------------------------------------------------------------//

ADDON = true;
