#include "script_component.hpp"

params ["_group"];

(_group getVariable "SAA_origin") params ["_originPos","_originDir"];

switch (_group getVariable "SAA_assignment") do {
	case "FREE" : {
		{([_group] + _x) call SAA_fnc_addWaypoint;} forEach (_group getVariable "SAA_waypointsCache");
	};
	case "GARRISON" : {
		[_group,_originPos,0,"MOVE","AWARE","GREEN","NORMAL","WEDGE",["true","
			(group this) call SAA_fnc_garrison;
		"],[0,0,0],15] call SAA_fnc_addWaypoint;
	};
	case "PATROL" : {
		switch (_group getVariable "SAA_routeType") do {
			case 0 : {_group call SAA_fnc_patrol;};
			case 1 : {
				{
					_x params ["_pos","type","_behaviour","_combatMode","_speed","_formation","_statements","_timeout","_completionRadius"];
					[_group,_pos,0,_type,_behaviour,_combatMode,_speed,_formation,_statements,_timeout,_completionRadius] call SAA_fnc_addWaypoint;
				} forEach (_group getVariable "SAA_waypointsCache");
			};
		};
	};
	case "QRF" : {
		[_group,_originPos,0,"MOVE","AWARE","GREEN","NORMAL","WEDGE",["true","
			(group this) setFormDir ((group this) getVariable 'SAA_origin') # 1;
		"],[0,0,0],0] call SAA_fnc_addWaypoint;

		// Have air units land and turn off engines - then set status to open
		if (({vehicle _x isKindOf "Air"} count units _group) != 0) then {
			private _landWP = [_group,_originPos,0,"SCRIPTED","AWARE","GREEN","NORMAL","WEDGE",["true",""],[0,0,0],50] call SAA_fnc_addWaypoint;
			_landWP setWaypointScript "A3\functions_f\waypoints\fn_wpLand.sqf";
			[_group,_originPos,0,"MOVE","","","","",["true","
				[{
					params ['_group'];
					if (_group getVariable 'SAA_available') then {
						{
							if (vehicle _x isKindOf 'Air' && {driver vehicle _x in units _group}) then {
								vehicle _x engineOn false;
							};
						} forEach (units _group);
					};
				},group this,8] call CBA_fnc_waitAndExecute;
			"],[0,0,0],250] call SAA_fnc_addWaypoint;
		};
	};
	case "SENTRY" : {
		// Try to get units facing the same way they were originally
		[_group,_originPos getPos [12,_originDir - 180],0,"MOVE","AWARE","GREEN","NORMAL","WEDGE",["true","
					(group this) setFormDir ((group this) getVariable 'SAA_origin') # 1;
		"],[0,0,0],0] call SAA_fnc_addWaypoint;
		[_group,_originPos,0,"MOVE","AWARE","GREEN","NORMAL","WEDGE",["true","
			(group this) setFormDir ((group this) getVariable 'SAA_origin') # 1;
		"],[0,0,0],0] call SAA_fnc_addWaypoint;
	};
};
