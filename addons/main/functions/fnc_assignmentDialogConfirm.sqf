#include "script_component.hpp"

params ["_dialogResults","_args"];
_args params ["_assignment","_groups"];

reverse _dialogResults;
_dialogResults params ["_transferLocalitySelection","_responseDistance","_requestDistance"];

private _extraParams = switch (_assignment) do {
	case "GARRISON" : {[_dialogResults # 3,_dialogResults # 4]};
	case "PATROL" : {[_dialogResults # 3,_dialogResults # 4,parseNumber (_dialogResults # 5)]};
	default {[]};
};

if (_transferLocalitySelection > (count GVAR(headlessClients) + 1)) exitWith {
	SAA_ERROR("Headless client(s) disconnected during selection. Cancelling assignment.");
};

// Server transfer
if (_transferLocalitySelection == 1) exitWith {
	[2,_groups,_assignment,_requestDistance,_responseDistance,_extraParams] call FUNC(transferGroups);
};

// HC transfer
if (_transferLocalitySelection > 1) exitWith {
	private _headlessClientID = owner (GVAR(headlessClients) # (_transferLocalitySelection - 2));
	[_headlessClientID,_groups,_assignment,_requestDistance,_responseDistance,_extraParams] remoteExecCall [QFUNC(transferGroups),_headlessClientID];
};

// Keep current localities
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
	[_x # 1,_assignment,_requestDistance,_responseDistance,_extraParams] remoteExecCall [QFUNC(assignGroups),_x # 0];
} forEach _ownersAndGroups;
