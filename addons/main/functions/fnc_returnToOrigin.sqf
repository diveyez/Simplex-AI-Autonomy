#include "script_component.hpp"

params ["_group"];

private _assignment = _group getVariable "SAA_assignment";

if (isNil "_assignment") exitWith {};

(_group getVariable "SAA_origin") params ["_originPos","_originDir"];

_group call FUNC(clearWaypoints);

switch (_assignment) do {
	case "FREE" : {
		{([_group] + _x) call FUNC(addWaypoint)} forEach (_group getVariable "SAA_waypointsCache");
	};
	case "GARRISON" : {
		[_group,_originPos,0,"MOVE","AWARE","GREEN","NORMAL","WEDGE",["true",
			"(group this) call " + QFUNC(garrison)
		],[0,0,0],15] call FUNC(addWaypoint);
	};
	case "PATROL" : {
		switch (_group getVariable "SAA_routeType") do {
			case 0 : {_group call FUNC(patrol);};
			case 1 : {{([_group] + _x) call FUNC(addWaypoint)} forEach (_group getVariable "SAA_waypointsCache");};
		};
	};
	case "QRF" : {
		[_group,_originPos,0,"MOVE","AWARE","GREEN","NORMAL","WEDGE",["true","
			(group this) setFormDir ((group this) getVariable 'SAA_origin') # 1;
		"],[0,0,0],0] call FUNC(addWaypoint);

		// Have air units land and turn off engines - then set status to open
		if (({vehicle _x isKindOf "Air"} count units _group) != 0) then {
			private _landWP = [_group,_originPos,0,"SCRIPTED","AWARE","GREEN","NORMAL","WEDGE",["true",""],[0,0,0],50] call FUNC(addWaypoint);
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

						_group call " + QFUNC(mountQRF) + ";
					};
				},group this,8] call CBA_fnc_waitAndExecute;
			"],[0,0,0],250] call FUNC(addWaypoint);
		};
	};
	case "SENTRY" : {
		// Try to get units facing the same way they were originally
		[_group,_originPos getPos [12,_originDir - 180],0,"MOVE","AWARE","GREEN","NORMAL","WEDGE",["true","
			(group this) setFormDir ((group this) getVariable 'SAA_origin') # 1;
		"],[0,0,0],0] call FUNC(addWaypoint);
		[_group,_originPos,0,"MOVE","AWARE","GREEN","NORMAL","WEDGE",["true","
			(group this) setFormDir ((group this) getVariable 'SAA_origin') # 1;
		"],[0,0,0],0] call FUNC(addWaypoint);
	};
};
