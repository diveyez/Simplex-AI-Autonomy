#include "script_component.hpp"

params ["_ownerID","_groups","_assignment","_requestDistance","_responseDistance","_extraParams"];

// Save loadouts
{
	if (!local _x) then {
		{_x setVariable ["SAA_loadout",getUnitLoadout _x]} forEach units _x;
	};
} forEach _groups;

["SAA_transferGroups",[_ownerID,_groups]] call CBA_fnc_serverEvent;

[{
	private _groups = _this # 0;
	{!local _x} count _groups isEqualTo 0 || {
	{!isNull _x} count _groups isEqualTo 0 || {
	{({alive _x} count units _x) != 0} count _groups isEqualTo 0
}}},{
	// Apply loadouts
	{
		{
			private _loadout = _x getVariable "SAA_loadout";
			if (!isNil "_loadout") then {
				_x setUnitLoadout _loadout;
				_x setVariable ["SAA_loadout",nil];
			};
		} forEach units _x;
	} forEach (_this # 0);

	_this call FUNC(assignGroups);
},[_groups,_assignment,_requestDistance,_responseDistance,_extraParams]] call CBA_fnc_waitUntilAndExecute;
