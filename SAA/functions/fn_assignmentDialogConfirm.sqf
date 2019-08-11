#include "script_component.hpp"

params ["_dialogResults","_args"];
_args params ["_assignment","_groups"];

reverse _dialogResults;
_dialogResults params ["_transferToServer","_responseDistance","_requestDistance"];
private _extraParams = switch (_assignment) do {
	case "GARRISON" : {_dialogResults # 3};
	case "PATROL" : {[_dialogResults # 3,_dialogResults # 4,_dialogResults # 5]};
	default {[]};
};

if (_transferToServer) exitWith {
	// Save loadout
	{
		if (!local _x) then {
			{_x setVariable ["SAA_loadout",getUnitLoadout _x];} forEach units _x;
			_x setGroupOwner 2;
		};
	} forEach _groups;

	[{
		private _groups = _this # 0;
		{!local _x} count _groups isEqualTo 0 || {
		{!isNull _x} count _groups isEqualTo 0 || {
		{({alive _x} count units _x) != 0} count _groups isEqualTo 0
	}}},{
		// Apply loadout
		{
			{
				_x setUnitLoadout (_x getVariable "SAA_loadout");
				_x setVariable ["SAA_loadout",nil];
			} forEach units _x;
		} forEach (_this # 0);

		_this call SAA_fnc_assignGroups;
	},[_groups,_assignment,_requestDistance,_responseDistance,_extraParams]] call CBA_fnc_waitUntilAndExecute;
};

private _ownersAndGroups = []; // [ownerID,[groups]]
{
	private _owner = groupOwner _x;
	private _index = (_ownersAndGroups apply {_x # 0}) find _owner;
	if (_index != -1) then {
		((_ownersAndGroups select _index) select 1) pushBack _x;
	} else {
		_ownersAndGroups pushBack [_owner,[_x]];
	};
} forEach _groups;

{
	[_x # 1,_assignment,_requestDistance,_responseDistance,_extraParams] remoteExecCall ["SAA_fnc_assignGroups",_x # 0];
} forEach _ownersAndGroups;
