#include "script_component.hpp"
#include "XEH_PREP.hpp"

// Compile unit hash for occupation dialog
private _sideHash = [[],[[],[[],[]] call CBA_fnc_hashCreate] call CBA_fnc_hashCreate] call CBA_fnc_hashCreate;
private _cfgSubCategories = configFile >> "CfgEditorSubcategories";

{
	if (getNumber (_x >> "scope") == 2) then {
		private _class = configName _x;

		if (_class isKindOf "CAManBase" || _class isKindOf "LandVehicle") then {
			private _side = getNumber (_x >> "side");

			if !(_side in [0,1,2]) exitWith {};

			private _faction = getText (_x >> "faction");
			private _category = getText (_cfgSubCategories >> getText (_x >> "editorSubcategory") >> "displayName");
			private _displayName = getText (_x >> "displayName");
			private _factionHash = [_sideHash,_side] call CBA_fnc_hashGet;
			private _categoryHash = [_factionHash,_faction] call CBA_fnc_hashGet;
			private _classes = [_categoryHash,_category] call CBA_fnc_hashGet;

			_classes pushBack [_displayName,_class];
			
			[_categoryHash,_category,_classes] call CBA_fnc_hashSet;
			[_factionHash,_faction,_categoryHash] call CBA_fnc_hashSet;
			[_sideHash,_side,_factionHash] call CBA_fnc_hashSet;
		};
	};
} forEach configProperties [configFile >> "CfgVehicles","isClass _x"];

uiNamespace setVariable [QGVAR(sideHash),_sideHash];
