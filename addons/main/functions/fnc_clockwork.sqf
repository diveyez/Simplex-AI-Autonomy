#include "script_component.hpp"

private _list = SAA_loopList;
private _index = SAA_loopIndex;

if (_list isEqualTo [] || {_index >= count _list}) exitWith {
	_list = allGroups select {local _x && {!isNil {_x getVariable "SAA_assignment"}}};
	_list append SAA_cachedGroups;
	SAA_loopList = _list;
	SAA_loopIndex = 0;
};

SAA_loopIndex = _index + 1;
private _item = _list # _index;

if (_item isEqualType grpNull && {!isNull _item && !isNil {_item getVariable "SAA_assignment"}}) then {
	_item call FUNC(scan);
};

if (_item isEqualType []) then {
	private _cachePosition = _item # 0;

	if (!SAA_setting_cachingEnabled || {(allPlayers findIf {!(_x isKindOf "HeadlessClient_F") && {_cachePosition distance _x < SAA_cachingDistance}}) != -1}) then {
		_item call FUNC(uncacheGroup);
	} else {
		//item call FUNC(simulateCachedGroup);
	};
};
