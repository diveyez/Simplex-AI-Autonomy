#include "script_component.hpp"

params ["_group"];

// TO-DO
/*
params [["_group",grpNull,[grpNull]],["_teleport",false,[false]]];

_group setVariable ["ZAAC_grpStatus",2];
_group enableAttack false;

private _startPos = getPos (leader _group);
private _units = (units _group) select {alive _x};
private _buildingsIndex = ((nearestObjects [_startPos,["Building"],50,true]) apply {_x buildingPos -1}) select {count _x > 0};

{
	_x setVariable ["ZAAC_garrisonDone",false];

	if (vehicle _x isKindOf "CAManBase") then {
		private "_position";
		if (count _buildingsIndex > 0) then {
			private _building = [_buildingsIndex # 0,selectRandom _buildingsIndex] select (random 1 < 0.5);
			_position = _building deleteAt (floor random (count _building));

			// Try not to pick positions already occupied
			private _obstructions = _position nearEntities ["CAManBase",2];
			if (count _obstructions > 0) then {
				while {
					if (_building isEqualTo []) then {
						_buildingsIndex = _buildingsIndex select {count _x > 0};
					};
					if (count _buildingsIndex > 0) then {
						_building = [_buildingsIndex # 0,selectRandom _buildingsIndex] select (random 1 < 0.5);
						_position = _building deleteAt (floor random (count _building));
						_obstructions = _position nearEntities ["CAManBase",2];
					};
					(count _buildingsIndex > 0) && (count _obstructions > 0)
				} do {};
			};

			if (_building isEqualTo []) then {
				_buildingsIndex = _buildingsIndex select {count _x > 0};
			};

			_x setUnitPos "UP";
		} else {
			// If no nearby buildings positions to occupy, send units to random positions in a 40m radius
			_position = _startPos getPos [40 * sqrt random 1, random 360];
		};

		if (_teleport) then {
			_x setPos _position;
			doStop _x;
			_x setVariable ["ZAAC_garrisonDone",true];
		} else {
			_x doMove _position;
			[_x,_position] spawn {
				params ["_unit","_pos"];
				waitUntil {unitReady _unit || {_unit distance _pos < 3}};
				doStop _unit;
				_unit setVariable ["ZAAC_garrisonDone",true];
			};
		};
	} else {
		// Handle vehicles
		doStop _x;
		_x setVariable ["ZAAC_garrisonDone",true];
	};
	false
} count _units;

switch (_group getVariable "ZAAC_grpRole") do {
	case "GARRISON" : {
		[{
			({[true,false] select (_x getVariable ["ZAAC_garrisonDone",true])} count (_this # 1)) isEqualTo 0
		},{
			(_this # 0) setVariable ["ZAAC_grpStatus",0];
		},[_group,_units]] call CBA_fnc_waitUntilAndExecute;
	};
	case "FORTIFY" : {
		[{
			({[true,false] select (_x getVariable ["ZAAC_garrisonDone",true])} count (_this # 1)) isEqualTo 0
		},{
			private _group = _this # 0;

			// Select an alive unit as leader
			private _leader = leader _group;
			if !(alive _leader) then {
				_leader = _units # 0;
				_group selectLeader _leader;
			};

			_group setVariable ["ZAAC_grpFortifyReact",false];
			private _EHID = (leader _group) addEventHandler ["FiredNear",{
				private _leader = _this # 0;
				(group _leader) setVariable ["ZAAC_grpFortifyReact",true];
				_leader removeEventHandler ["FiredNear",(group _leader) getVariable "ZAAC_grpFortifyEHID"];
			}];
			_group setVariable ["ZAAC_grpFortifyEHID",_EHID];
		},[_group,_units]] call CBA_fnc_waitUntilAndExecute;
	};
};
*/
