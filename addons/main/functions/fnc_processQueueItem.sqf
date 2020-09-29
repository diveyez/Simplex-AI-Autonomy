#include "script_component.hpp"

params ["_assignmentType","_details"];
_details params ["_area","_side","_config","_settings"];
_settings params ["_requestDistance","_responseDistance","_QRFRequestDistance","_QRFResponseDistance","_patrolRadiusRandom"];

switch (_assignmentType) do {
	case 0 : {
		private "_randPos";
		while {
			_randPos = [_area,false] call CBA_fnc_randPosArea;
			surfaceIsWater _randPos
		} do {};

		private _group = [_randPos,_side,_config] call FUNC(spawnGroup);
		_group setVariable ["SAA_allowCaching",false,true];
		[{_this setVariable ["SAA_allowCaching",nil,true]},_group,6] call CBA_fnc_waitAndExecute;

		private _dir = random 360;
		_group setFormDir _dir;
		leader _group setDir _dir;

		[[_group],"PATROL",_requestDistance,_responseDistance,[0,0,round random _patrolRadiusRandom]] call SAA_main_fnc_assignGroups;
	};
	case 1 : {
		private "_randPos";
		while {
			_randPos = [_area,false] call CBA_fnc_randPosArea;
			private _buildingPositions = [];
			{_buildingPositions append ([_x] call CBA_fnc_buildingPositions)} forEach (nearestObjects [_randPos,["Building"],70,true]);
			surfaceIsWater _randPos && !(_buildingPositions isEqualTo [])
		} do {};

		private _group = [_randPos,_side,_config] call FUNC(spawnGroup);
		_group setVariable ["SAA_allowCaching",false,true];
		[{_this setVariable ["SAA_allowCaching",nil,true]},_group,6] call CBA_fnc_waitAndExecute;

		private _dir = random 360;
		_group setFormDir _dir;
		leader _group setDir _dir;

		[[_group],"GARRISON",_requestDistance,_responseDistance,[true,round random [0,1,2]]] call SAA_main_fnc_assignGroups;
	};
	case 2 : {
		private "_randPos";
		while {
			_randPos = [_area,false] call CBA_fnc_randPosArea;

			private _places = (selectBestPlaces [_randPos,150,"hills - forest - sea",60,40]) apply {[getTerrainHeightASL (_x # 0),_x # 0]};
			_places sort false;
			_places resize 5;

			private _tallestPlaces = [];

			{
				private _places = (selectBestPlaces [_x # 1,50,"hills - forest - sea",80,20]) apply {[getTerrainHeightASL (_x # 0),_x # 0]};
				_places sort false;
				_tallestPlaces pushBack (_places # 0 # 1);
			} forEach _places;

			private _tallPos = selectRandom _tallestPlaces;

			// Find road
			if (isNil "_tallPos" || random 1 < 0.4) then {
				private _roads = (_randPos nearRoads 325) select {
					private _road = _x;
					_blacklist findIf {_road inArea _x} isEqualTo -1
				};

				private _road = [_randPos,_roads] call FUNC(getNearest);
				private _dir = random 360;
				private _noRoad = if (!isNull _road) then {
					_randPos = getPos _road;

					private _connectedRoads = roadsConnectedTo _road;
					if !(_connectedRoads isEqualTo []) then {
						_dir = _road getDir (_connectedRoads # 0);
					};

					false
				} else {true};
			} else {
				_randPos = +_tallPos;
			};

			surfaceIsWater _randPos
		} do {};

		private _group = [_randPos,_side,_config] call FUNC(spawnGroup);
		_group setVariable ["SAA_allowCaching",false,true];
		[{_this setVariable ["SAA_allowCaching",nil,true]},_group,6] call CBA_fnc_waitAndExecute;

		private _dir = random 360;
		_group setFormDir _dir;
		leader _group setDir _dir;

		[[_group],"SENTRY",_requestDistance,_responseDistance] call SAA_main_fnc_assignGroups;
	};
	case 3 : {
		private "_randPos";
		while {
			_randPos = [_area,false] call CBA_fnc_randPosArea;

			private _places = (selectBestPlaces [_randPos,150,"hills - forest - sea",60,40]) apply {[getTerrainHeightASL (_x # 0),_x # 0]};
			_places sort false;
			_places resize 5;

			private _tallestPlaces = [];

			{
				private _places = (selectBestPlaces [_x # 1,50,"hills - forest - sea",80,20]) apply {[getTerrainHeightASL (_x # 0),_x # 0]};
				_places sort false;
				_tallestPlaces pushBack (_places # 0 # 1);
			} forEach _places;

			private _tallPos = selectRandom _tallestPlaces;

			// Find road
			if (isNil "_tallPos" || random 1 < 0.4) then {
				private _roads = (_randPos nearRoads 325) select {
					private _road = _x;
					_blacklist findIf {_road inArea _x} isEqualTo -1
				};

				private _road = [_randPos,_roads] call FUNC(getNearest);
				private _dir = random 360;
				private _noRoad = if (!isNull _road) then {
					_randPos = getPos _road;

					private _connectedRoads = roadsConnectedTo _road;
					if !(_connectedRoads isEqualTo []) then {
						_dir = _road getDir (_connectedRoads # 0);
					};

					false
				} else {true};
			} else {
				_randPos = +_tallPos;
			};

			surfaceIsWater _randPos
		} do {};

		private _group = [_randPos,_side,_config] call FUNC(spawnGroup);
		_group setVariable ["SAA_allowCaching",false,true];
		[{_this setVariable ["SAA_allowCaching",nil,true]},_group,6] call CBA_fnc_waitAndExecute;

		private _dir = random 360;
		_group setFormDir _dir;
		leader _group setDir _dir;
		
		[[_group],"QRF",_QRFRequestDistance,_QRFResponseDistance] call SAA_main_fnc_assignGroups;
	};
};
