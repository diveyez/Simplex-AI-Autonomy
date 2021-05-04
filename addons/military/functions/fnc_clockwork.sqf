#include "script_component.hpp"

// List iteration
if (GVAR(list) isEqualTo []) exitWith {
	GVAR(list) = allGroups select {local _x && {!isNil {_x getVariable QGVAR(assignment)}}};
	GVAR(list) append GVAR(cache);
};

private _item = GVAR(list) deleteAt 0;

// Item evalutation
if (
	_item isEqualType grpNull && 
	{!isNull _item && !isNil {_item getVariable QGVAR(assignment)}} &&
	{{alive _x} count units _item > 0}
) then {
	private _leaderPos = getPos leader _group;

	if (
		_group getVariable [QGVAR(allowCaching),true] && 
		{GVAR(cachingEnabled)} && 
		{allPlayers findIf {_leaderPos distance _x < GVAR(cachingDistance)} isEqualTo -1}
	) exitWith {
		_group call FUNC(cache);
	};
	
	_item call FUNC(scan);
};

if (_item isEqualType []) then {
	private _cachePos = _item # 1;

	if (
		!GVAR(cachingEnabled) || 
		{allPlayers findIf {!(_x isKindOf "HeadlessClient_F") && {_cachePos distance getPosASL _x < GVAR(cachingDistance)}} != -1}
	) then {
		_item call FUNC(uncache);
	};
};
