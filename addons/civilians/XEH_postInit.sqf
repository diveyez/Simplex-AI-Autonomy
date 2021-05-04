#include "script_component.hpp"

// "Go Away" action
if (isClass (configFile >> "CfgPatches" >> "ace_interact_menu")) then {
	["CAManBase",1,["ACE_SelfActions"],
		[QGVAR(shoo),LLSTRING(GoAwayAction),"\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa",{
			"ace_gestures_point" call ace_gestures_fnc_playSignal;
			
			private _dir = getDirVisual _player;
			private _center = _player getPos [18,_dir];
			private _area = [_center,10,18,_dir,false];

			{
				if (side _x isEqualTo civilian && {_x inArea _area}) then {
					[QGVAR(doMove),[_x,_x getPos [150 + random 150,_dir + random [-60,0,60]]],_x] call CBA_fnc_targetEvent;
				};
			} forEach (_center nearEntities 20);
		},{true}] call ace_interact_menu_fnc_createAction,
	true] call ace_interact_menu_fnc_addActionToClass;
};

// Ambient aircraft
if (isServer && GVAR(aircraftEnabled)) then {
	GVAR(aircraftPFHID) = [{
		if (random 1 > GVAR(aircraftChance)) exitWith {};

		[{
			private _player = selectRandom (allPlayers select {!(_x isKindOf "HeadlessClient_F")});

			if (isNil "_player") exitWith {};

			private _startPos = _player getPos [GVAR(aircraftSpawnDistance),random 360];
			private _endPos = _startPos getPos [GVAR(aircraftSpawnDistance) * 2,_startPos getDir _player];

			[selectRandomWeighted GVAR(aircraftClasses),_startPos,_endPos,GVAR(aircraftAltitude)] call FUNC(spawnAircraft);
		},[],random GVAR(aircraftMaxTime)] call CBA_fnc_waitAndExecute;
	},GVAR(aircraftMinTime),[]] call CBA_fnc_addPerFrameHandler;
};

// Ambient civ auto-start
if (isServer && GVAR(autoStart)) then {
	[{
		[QGVAR(toggle)] call CBA_fnc_localEvent;
	},[],5] call CBA_fnc_waitAndExecute;
};
