#include "script_component.hpp"

if (isServer) then {
	GVAR(aircraftPFHID) = [{
		if (random 1 > GVAR(aircraftChance)) exitWith {};

		[{
			private _player = selectRandom (allPlayers select {!(_x isKindOf "HeadlessClient_F")});

			if (isNil "_player") exitWith {};

			private _startPos = _player getPos [GVAR(aircraftSpawnDistance),random 360];
			private _endPos = _startPos getPos [GVAR(aircraftSpawnDistance) * 2,_startPos getDir _player];

			[selectRandomWeighted GVAR(aircraftClassesWeighted),_startPos,_endPos,GVAR(aircraftAltitude)] call FUNC(spawnAircraft);
		},[],random GVAR(aircraftMaxTime)] call CBA_fnc_waitAndExecute;
	},GVAR(aircraftMinTime),[]] call CBA_fnc_addPerFrameHandler;
};
