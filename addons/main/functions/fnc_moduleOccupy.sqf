#include "script_component.hpp"

[{
	params ["_logic","_synced"];
	
	private _posASL = getPosASL _logic;
	deleteVehicle _logic;

	if (isNil QGVAR(presets)) exitWith {
		systemChat "No density presets!";
	};

	([_posASL] call EFUNC(CDS,dialogMarker)) params ["_pos","_isRectangle","_width","_height","_direction","_useDefaultValue","_tempMarker"];
	GVAR(tempMarker) = _tempMarker;
	GVAR(density) = [[],[],[],[]];

	["Occupy",[
		["COMBOBOX","Side",[[["OPFOR","","",[1,0,0,1]],["BLUFOR","","",[0,0,1,1]],["INDEPENDENT","","",[0,1,0,1]]],0],false,{
			params ["_sideSelection"];
			[1,[(GVAR(presets) # _sideSelection) apply {_x # 0},0]] call EFUNC(CDS,setValueData);
		}],
		["COMBOBOX","Presets",[[],0],false,{
			params ["_presetSelection"];

			[2,[[
				["Patrol Density","",[]],
				["Garrison Density","",[]],
				["Sentry Density","",[]],
				["QRF Density","",[]]
			],4,true]] call EFUNC(CDS,setValueData);

			if (_presetSelection == -1) exitWith {
				GVAR(density) = [[],[],[],[]];
			};
			
			private _sideSelection = 0 call EFUNC(CDS,getCurrentValue);
			private _cfgVehicles = configFile >> "CfgVehicles";
			private _tvCtrl = 2 call EFUNC(CDS,getControl);

			GVAR(density) = +(GVAR(presets) # _sideSelection # _presetSelection # 1);

			{
				private _densitySelection = _forEachIndex;
				
				{
					_x params ["_classes","_minMax"];
					_minMax params ["_min","_max"];

					[2,[_densitySelection],[format ["MIN: %2 / MAX: %3 : %1",_classes apply {getText (_cfgVehicles >> _x >> "displayName")},_min,_max]]] call EFUNC(CDS,treeAdd);
				} forEach _x;

				_tvCtrl tvExpand [_forEachIndex];
			} forEach GVAR(density);
		}],
		["TREE","Density Config",[[
			["Patrol Density","",[]],
			["Garrison Density","",[]],
			["Sentry Density","",[]],
			["QRF Density","",[]]
		],4,true]],
		["CHECKBOX","Rectangle",_isRectangle,_useDefaultValue,{
			params ["_bool"];
			GVAR(tempMarker) setMarkerShapeLocal (["ELLIPSE","RECTANGLE"] select _bool);
		}],
		["EDITBOX","Width",_width,_useDefaultValue,{
			params ["_text"];
			GVAR(tempMarker) setMarkerSizeLocal [abs parseNumber _text,abs parseNumber (5 call EFUNC(CDS,getCurrentValue))];
		}],
		["EDITBOX","Height",_height,_useDefaultValue,{
			params ["_text"];
			GVAR(tempMarker) setMarkerSizeLocal [abs parseNumber (4 call EFUNC(CDS,getCurrentValue)),abs parseNumber _text];
		}],
		["SLIDER","Direction",[[0,360,0],_direction],_useDefaultValue,{
			params ["_direction"];
			GVAR(tempMarker) setMarkerDirLocal _direction;
		}],
		["SLIDER","Patrol density coefficient",[[0,1,2],1],false],
		["SLIDER","Garrison density coefficient",[[0,1,2],1],false],
		["SLIDER","Sentry density coefficient",[[0,1,2],1],false],
		["SLIDER","QRF density coefficient",[[0,1,2],1],false],
		["SLIDER",["Assistance request distance","Group(s) will request assistance from other groups within this distance"],[[0,10000,0],800],false],
		["SLIDER",["Max assistance response distance","Group(s) will only respond to assistance requests that are within this distance"],[[0,10000,0],800],false],
		["SLIDER",["QRF request distance","Group(s) will request assistance from other groups within this distance"],[[0,10000,0],1600],false],
		["SLIDER",["QRF response distance","Group(s) will only respond to assistance requests that are within this distance"],[[0,10000,0],1600],false],
		["EDITBOX",["Patrol radius random","Random patrol radii in format: [min,mid,max]"],"[125,200,250]",false],
		["COMBOBOX",["Locality","Spawns groups on specified machine"],[["Local","Server"] + (GVAR(headlessClients) apply {"HC: " + str _x}),0],false]
	],{
		deleteMarkerLocal GVAR(tempMarker);

		params ["_values","_pos"];
		_values params [
			"_sideSelection","_presetSelection","_treePath","_isRectangle",
			"_width","_height","_direction","_patrolCoef",
			"_garrisonCoef","_sentryCoef","_QRFCoef","_requestDistance",
			"_responseDistance","_QRFRequestDistance","_QRFResponseDistance","_patrolRadiusRandom",
			"_localitySelection"
		];
		
		+GVAR(density) params ["_patrolDensity","_garrisonDensity","_sentryDensity","_QRFDensity"];

		_width = abs parseNumber _width;
		_height = abs parseNumber _height;
		_patrolRadiusRandom = parseSimpleArray _patrolRadiusRandom;
		private _side = [east,west,independent] # _sideSelection;
		private _occupyParams = [
			[_pos,_width,_height,_direction,_isRectangle],
			_side,
			_patrolDensity,
			_garrisonDensity,
			_sentryDensity,
			_QRFDensity,
			[_patrolCoef,_garrisonCoef,_sentryCoef,_QRFCoef],
			_requestDistance,
			_responseDistance,
			_QRFRequestDistance,
			_QRFResponseDistance,
			_patrolRadiusRandom,
			player
		];

		if (_localitySelection > 0) then {
			[QGVAR(localityExec),[_localitySelection,_occupyParams,QFUNC(occupy)]] call CBA_fnc_serverEvent;
		} else {
			_occupyParams call FUNC(occupy);
		};

		GVAR(density) = nil;
	},{deleteMarkerLocal GVAR(tempMarker);},_pos] call EFUNC(CDS,dialog);
},_this] call CBA_fnc_directCall;
