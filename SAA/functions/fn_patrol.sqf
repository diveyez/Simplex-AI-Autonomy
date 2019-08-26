params ["_group"];

private _originPos = (_group getVariable "SAA_origin") # 0;
private _patrolRadius = _group getVariable "SAA_patrolRadius";

switch (_group getVariable "SAA_routeType") do {
	case 0 : {
		private _vehicle = vehicle (leader _group);
		private "_position";
		for "_i" from 0 to 99 do {
			_position = _originPos getPos [_patrolRadius * (1 - abs random [-1,0,1]),random 360]; // inverted normal distribution, random radius
			//_position = _originPos getPos [_patrolRadius * sqrt (1 - abs random [-1,0,1]), random 360]; // inverted normal distribution, random area
			if (!surfaceIsWater _position) exitWith {};
		};

		{deleteWaypoint [_group,0]} forEach (waypoints _group);
		[_group,_position,0,"MOVE","SAFE","GREEN","LIMITED",["FILE","STAG COLUMN"] select (random 1 < 0.5),["true","
			(group this) call SAA_fnc_patrol;
		"],[4,6,8],15] call SAA_fnc_addWaypoint;
		_group call SAA_fnc_theNudge;
	};
	case 1 : { // For initial setup only
		switch (_group getVariable "SAA_routeStyle") do {
			case 0 : { // Clockwise Circle
				private _formation = ["FILE","STAG COLUMN"] select (random 1 < 0.5);
				private _dir = 60;
				for "_i" from 0 to 6 do {
					private _position = _originPos getPos [_patrolRadius,_dir];
					_dir = _dir + 60;
					if (_i != 6) then {
						private _WP = [_group,_position,0,"MOVE","SAFE","GREEN","LIMITED",_formation,["true",""],[4,6,8],10] call SAA_fnc_addWaypoint;
						if (_i isEqualTo 0) then {
							_group call SAA_fnc_theNudge;
						};
					} else {
						[_group,_position,0,"CYCLE","SAFE","GREEN","LIMITED",_formation,["true",""],[4,6,8],10] call SAA_fnc_addWaypoint;
					};
				};
			};
			case 1 : { // Counter-Clockwise Circle
				private _formation = ["FILE","STAG COLUMN"] select (random 1 < 0.5);
				private _dir = 300;
				for "_i" from 0 to 6 do {
					private _position = _originPos getPos [_patrolRadius,_dir];
					_dir = _dir - 60;
					if (_i != 6) then {
						private _WP = [_group,_position,0,"MOVE","SAFE","GREEN","LIMITED",_formation,["true",""],[4,6,8],10] call SAA_fnc_addWaypoint;
						if (_i isEqualTo 0) then {
							_group call SAA_fnc_theNudge;
						};
					} else {
						[_group,_position,0,"CYCLE","SAFE","GREEN","LIMITED",_formation,["true",""],[4,6,8],10] call SAA_fnc_addWaypoint;
					};
				};
			};
		};

		_group setVariable ["SAA_waypointsCache",(waypoints _group) apply {[
			waypointPosition _x,0,waypointType _x,
			waypointBehaviour _x,waypointCombatMode _x,
			waypointSpeed _x,waypointFormation _x,
			waypointStatements _x,waypointTimeout _x,
			waypointCompletionRadius _x
		]}];
	};
};

