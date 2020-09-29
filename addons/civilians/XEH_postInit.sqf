#include "script_component.hpp"

if (isClass (configFile >> "CfgPatches" >> "ace_interact_menu")) then {
	["CAManBase",1,["ACE_SelfActions"],
		[QGVAR(shoo),"""Go away!""","\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa",{
			"ace_gestures_point" call ace_gestures_fnc_playSignal;
			
			private _dir = getDirVisual _player;
			private _center = _player getPos [18,_dir];
			private _area = [_center,10,18,_dir,false];

			{
				if (side _x isEqualTo civilian && {_x inArea _area}) then {
					[_x,_x getPos [150 + random 150,_dir + random [-60,0,60]]] remoteExecCall ["doMove",_x];
				};
			} forEach (_center nearEntities 20);
		},{true}] call ace_interact_menu_fnc_createAction,
	true] call ace_interact_menu_fnc_addActionToClass;
};
