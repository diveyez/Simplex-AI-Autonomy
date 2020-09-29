#include "script_component.hpp"

if (isNil QGVAR(queue)) then {
	GVAR(queue) = [_this];

	[{
		params ["_args","_PFHID"];

		if (isNil QGVAR(queue) || {GVAR(queue) isEqualTo []}) exitWith {
			GVAR(queue) = nil;
			_PFHID call CBA_fnc_removePerFrameHandler;
		};

		private _item = GVAR(queue) # 0;
		GVAR(queue) deleteAt 0;
		_item call FUNC(processQueueItem);
	},0.3] call CBA_fnc_addPerFrameHandler;
} else {
	GVAR(queue) pushBack _this;
};
