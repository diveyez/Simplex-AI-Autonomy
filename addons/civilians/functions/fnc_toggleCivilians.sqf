#include "script_component.hpp"

if (GVAR(ambientCivilians)) then {
	// End
	GVAR(PFHID) call CBA_fnc_removePerFrameHandler;
	GVAR(PFHID) = nil;

	missionNamespace setVariable [QGVAR(ambientCivilians),false,true];
	{[_x,true,true] call FUNC(remove)} forEach +GVAR(spawnPoints);
} else {
	// Start
	GVAR(playerlist) = [];
	GVAR(PFHID) = [FUNC(clockwork),0.5] call CBA_fnc_addPerFrameHandler;

	missionNamespace setVariable [QGVAR(ambientCivilians),true,true];
};
