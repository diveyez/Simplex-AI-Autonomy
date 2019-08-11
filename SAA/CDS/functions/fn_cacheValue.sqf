/*-----------------------------------------------------------------------------------------------//
Authors: Sceptre
Gets or sets a cached value.

Parameters:
-

Returns:
Cached value or nothing
//-----------------------------------------------------------------------------------------------*/
#include "..\defines.hpp"

disableSerialization;
params ["_type","_description","_values","_setCachedValue"];

private _titleText = uiNamespace getVariable "SAA_CDS_titleText";

if (isNil "SAA_CDS_valueCache") then {
	SAA_CDS_valueCache = [] call CBA_fnc_createNamespace;
};

private _ID = switch (_type) do {
	case "SLIDER";
	case "COMBOBOX" : {str [_titleText,_description,_type,_values # 0]};
	default {str [_titleText,_description,_type,_values]};
};

if (!_setCachedValue) exitWith {SAA_CDS_valueCache getVariable [_ID,_values]};

SAA_CDS_valueCache setVariable [_ID,_values];
