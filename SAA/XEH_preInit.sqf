SAA_AI_GROUPS = [];
SAA_targets_EAST = [];
SAA_targets_GUER = [];
SAA_targets_WEST = [];

// Temp CBA setting vars //call SAA_fnc_CBASettings;
SAA_setting_flaresEnabled = true;
SAA_setting_debug = true;

["ModuleCurator_F","init",{
	params ["_zeus"];
	_zeus call SAA_fnc_zeusEH;
}] call CBA_fnc_addClassEventHandler;
