#include "script_component.hpp"

///////////////////////////////////////////////////////////////////////////////////////////////////
// Headless Clients

if (isServer) then {
	addMissionEventHandler ["HandleDisconnect",{
		params ["_entity"];

		if (_entity in GVAR(headlessClients)) then {
			GVAR(headlessClients) deleteAt (GVAR(headlessClients) find _entity);
			publicVariable QGVAR(headlessClients);
		};

		false
	}];
};

if (!isServer && !hasInterface) then {
	[QGVAR(headlessClientJoined),player] call CBA_fnc_serverEvent;
};

///////////////////////////////////////////////////////////////////////////////////////////////////
// Throw grenade feature

[QGVAR(throwGrenade),FUNC(throwGrenade)] call CBA_fnc_addEventHandler;

///////////////////////////////////////////////////////////////////////////////////////////////////