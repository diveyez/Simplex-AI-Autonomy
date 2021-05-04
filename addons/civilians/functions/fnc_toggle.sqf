#include "script_component.hpp"

if (GVAR(isRunning)) then {
	// End
	GVAR(PFHID) call CBA_fnc_removePerFrameHandler;
	GVAR(PFHID) = nil;

	missionNamespace setVariable [QGVAR(isRunning),false,true];
	{[_x,true] call FUNC(remove)} forEach +GVAR(spawnPoints);
} else {
	// Start
	GVAR(playerlist) = [];
	GVAR(PFHID) = [FUNC(clockwork),0.5] call CBA_fnc_addPerFrameHandler;

	missionNamespace setVariable [QGVAR(isRunning),true,true];
};
