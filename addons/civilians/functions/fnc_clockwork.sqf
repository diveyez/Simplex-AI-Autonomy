#include "script_component.hpp"

if (GVAR(playerlist) isEqualTo []) exitWith {
	GVAR(playerlist) = allPlayers select {!(_x isKindOf "HeadlessClient_F")};

	if (GVAR(playerList) isEqualTo []) then {
		{[_x,true] call FUNC(remove)} forEach +GVAR(spawnPoints);
	};
};

private _player = GVAR(playerlist) deleteAt 0;
private _active = [];
private _inactive = [];
private _isolated = [];

if (alive _player) then {
	private _nearestDistances = [1e39,1e39,1e39];
	private _nearestSpawnPoints = [objNull,objNull,objNull];

	{
		private _spawnRadius = triggerArea _x # 0;
		private _type = _x getVariable QGVAR(type);
		private _distance = _x distance2D _player;

		if (_distance < (_nearestDistances # _type)) then {
			_nearestDistances set [_type,_distance];
			_nearestSpawnPoints set [_type,_x];
		};

		switch true do {
			case (_distance <= (_spawnRadius * 1.15)) : {_active pushBackUnique _x};
			case (_distance >= (_spawnRadius * 2)) : {_isolated pushBackUnique _x};
			default {_inactive pushBackUnique _x};
		};
	} forEach +GVAR(spawnPoints);

	{
		private _nearestDist = _nearestDistances # _forEachIndex;

		switch true do {
			case (_nearestDist >= _x) : {// Create new since none nearby
				_active pushBackUnique ([getPos _player,_x,_forEachIndex] call FUNC(create));
			};
			case (_nearestDist >= (_x / 2)) : {// Sequential creation
				private _nearest = _nearestSpawnPoints # _forEachIndex;
				
				_active pushBackUnique (
					[_nearest getPos [_x,_nearest getDir _player],_x,_forEachIndex] call FUNC(create)
				);
			};
		};
	} forEach [GVAR(pedSpawnRadius),GVAR(driverSpawnRadius),GVAR(parkedSpawnRadius)];
};

{// Active
	_x setVariable [QGVAR(expiring),nil];
	_x setVariable [QGVAR(expiration),nil];
} forEach _active;

{// Inactive
	if (_x getVariable [QGVAR(expiration),CBA_missionTime + 10] < CBA_missionTime) then {
		_x call FUNC(remove);
	} else {
		if !(_x getVariable [QGVAR(expiring),false]) then {
			_x setVariable [QGVAR(expiring),true];
			_x setVariable [QGVAR(expiration),CBA_missionTime + 10];
		};
	};
} forEach (_inactive - _active);

{// Isolated
	[_x,true] call FUNC(remove);
} forEach (_isolated - (_active + _inactive));
