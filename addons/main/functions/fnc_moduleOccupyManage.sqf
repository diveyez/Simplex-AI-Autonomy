#include "script_component.hpp"

params ["_logic","_synced"];

if (!local _logic) exitWith {};
	
[{
	params ["_logic","_synced"];
	
	private _posASL = getPosASL _logic;
	deleteVehicle _logic;

	([_posASL] call EFUNC(CDS,dialogMarker)) params ["_pos","_isRectangle","_width","_height","_direction","_useDefaultValue","_tempMarker"];
	GVAR(tempMarker) = _tempMarker;
	GVAR(density) = [[],[],[],[]];

	["Density Config Management",[
		["COMBOBOX","Side",[[["OPFOR","","",[1,0,0,1]],["BLUFOR","","",[0,0,1,1]],["INDEPENDENT","","",[0,1,0,1]]],0],false,{
			params ["_sideSelection"];

			private _classesTree = [];
			private _cfgFactions = configFile >> "CfgFactionClasses";
			private _factionHash = [uiNamespace getVariable QGVAR(sideHash),_sideSelection] call CBA_fnc_hashGet;

			{
				private _categoryHash = [_factionHash,_x] call CBA_fnc_hashGet;
				_classesTree pushBack [
					getText (_cfgFactions >> _x >> "displayName"),"",0,([_categoryHash] call CBA_fnc_hashKeys) apply {[_x,"",0,[_categoryHash,_x] call CBA_fnc_hashGet]}
				];
			} forEach ([_factionHash] call CBA_fnc_hashKeys);

			_classesTree sort true;

			[1,[_classesTree,6,-1,-1,0,2]] call EFUNC(CDS,setValueData);
			[6,[(GVAR(presets) # _sideSelection) apply {_x # 0},0]] call EFUNC(CDS,setValueData);
		}],
		["CARGOBOX2","Classes",[[],6,-1,-1,0,2]],
		["SLIDER","Min",[[0,25,0],1]],
		["SLIDER","Max",[[0,25,0],5]],
		["BUTTON2","GROUPS",["Add group config",{
			[1 call EFUNC(CDS,getCurrentValue),2 call EFUNC(CDS,getCurrentValue),3 call EFUNC(CDS,getCurrentValue)] params ["_classes","_min","_max"];
			5 call EFUNC(CDS,getCurrentValue) params ["_densitySelection","_groupSelection"];

			private _cfgVehicles = configFile >> "CfgVehicles";
			
			(GVAR(density) # _densitySelection) pushBack [+_classes,[_min,_max]];

			[5,[_densitySelection],[format ["MIN: %2 / MAX: %3 : %1",_classes apply {getText (_cfgVehicles >> _x >> "displayName")},_min,_max]]] call EFUNC(CDS,treeAdd);
		},"Remove group config",{
			5 call EFUNC(CDS,getCurrentValue) params ["_densitySelection","_groupSelection"];

			(GVAR(density) # _densitySelection) deleteAt _groupSelection;

			[5,[_densitySelection,_groupSelection]] call EFUNC(CDS,treeDelete);
		}]],
		["TREE","Density config",[[
			["Patrol Density","",[]],
			["Garrison Density","",[]],
			["Sentry Density","",[]],
			["QRF Density","",[]]
		],4,true]],
		["COMBOBOX","Presets",[[],0],false,{
			params ["_presetSelection"];

			if (_presetSelection == -1) exitWith {};
			
			[7,GVAR(presets) # (0 call EFUNC(CDS,getCurrentValue)) # _presetSelection # 0] call EFUNC(CDS,setValueData);
		}],
		["EDITBOX","Name",""],
		["BUTTON2","PRESETS1",["Load",{
			[0 call EFUNC(CDS,getCurrentValue),6 call EFUNC(CDS,getCurrentValue)] params ["_sideSelection","_presetSelection"];

			if (_presetSelection == -1) exitWith {};

			private _cfgVehicles = configFile >> "CfgVehicles";

			GVAR(density) = +(GVAR(presets) # _sideSelection # _presetSelection # 1);
			
			[5,[[
				["Patrol Density","",[]],
				["Garrison Density","",[]],
				["Sentry Density","",[]],
				["QRF Density","",[]]
			],4,true]] call EFUNC(CDS,setValueData);

			{
				private _densitySelection = _forEachIndex;
				
				{
					_x params ["_classes","_minMax"];
					_minMax params ["_min","_max"];

					[5,[_densitySelection],[format ["MIN: %2 / MAX: %3 : %1",_classes apply {getText (_cfgVehicles >> _x >> "displayName")},_min,_max]]] call EFUNC(CDS,treeAdd);
				} forEach _x;
			} forEach GVAR(density);
		},"Delete",{
			[0 call EFUNC(CDS,getCurrentValue),6 call EFUNC(CDS,getCurrentValue)] params ["_sideSelection","_presetSelection"];

			if (_presetSelection == -1) exitWith {};

			(GVAR(presets) # _sideSelection) deleteAt _presetSelection;
			[6,[(GVAR(presets) # _sideSelection) apply {_x # 0},0]] call EFUNC(CDS,setValueData);

			profileNamespace setVariable [QGVAR(presets),GVAR(presets)];
			saveProfileNamespace;
		}]],
		["BUTTON2","PRESETS2",["Overwrite",{
			[0 call EFUNC(CDS,getCurrentValue),6 call EFUNC(CDS,getCurrentValue),7 call EFUNC(CDS,getCurrentValue)] params ["_sideSelection","_presetSelection","_name"];

			if (_presetSelection == -1) exitWith {};

			(GVAR(presets) # _sideSelection) set [_presetSelection,[_name,+GVAR(density)]];
			[6,[(GVAR(presets) # _sideSelection) apply {_x # 0},_presetSelection]] call EFUNC(CDS,setValueData);

			profileNamespace setVariable [QGVAR(presets),GVAR(presets)];
			saveProfileNamespace;
		},"Save new",{
			[0 call EFUNC(CDS,getCurrentValue),6 call EFUNC(CDS,getCurrentValue),7 call EFUNC(CDS,getCurrentValue)] params ["_sideSelection","_presetSelection","_name"];

			(GVAR(presets) # _sideSelection) pushBack [_name,+GVAR(density)];
			[6,[(GVAR(presets) # _sideSelection) apply {_x # 0},count (GVAR(presets) # _sideSelection) - 1]] call EFUNC(CDS,setValueData);

			profileNamespace setVariable [QGVAR(presets),GVAR(presets)];
			saveProfileNamespace;
		}]],
		["CHECKBOX","Occupy area",false,true,{
			params ["_bool"];
			GVAR(tempMarker) setMarkerAlphaLocal ([0,1] select _bool);
		}],
		["CHECKBOX","Rectangle",_isRectangle,_useDefaultValue,{
			params ["_bool"];
			GVAR(tempMarker) setMarkerShapeLocal (["ELLIPSE","RECTANGLE"] select _bool);
		},{10 call EFUNC(CDS,getCurrentValue)}],
		["EDITBOX","Width",_width,_useDefaultValue,{
			params ["_text"];
			GVAR(tempMarker) setMarkerSizeLocal [abs parseNumber _text,abs parseNumber (13 call EFUNC(CDS,getCurrentValue))];
		},{10 call EFUNC(CDS,getCurrentValue)}],
		["EDITBOX","Height",_height,_useDefaultValue,{
			params ["_text"];
			GVAR(tempMarker) setMarkerSizeLocal [abs parseNumber (12 call EFUNC(CDS,getCurrentValue)),abs parseNumber _text];
		},{10 call EFUNC(CDS,getCurrentValue)}],
		["SLIDER","Direction",[[0,360,0],_direction],_useDefaultValue,{
			params ["_direction"];
			GVAR(tempMarker) setMarkerDirLocal _direction;
		},{10 call EFUNC(CDS,getCurrentValue)}],
		["SLIDER","Patrol density coefficient",[[0,1,2],1],false,{},{10 call EFUNC(CDS,getCurrentValue)}],
		["SLIDER","Garrison density coefficient",[[0,1,2],1],false,{},{10 call EFUNC(CDS,getCurrentValue)}],
		["SLIDER","Sentry density coefficient",[[0,1,2],1],false,{},{10 call EFUNC(CDS,getCurrentValue)}],
		["SLIDER","QRF density coefficient",[[0,1,2],1],false,{},{10 call EFUNC(CDS,getCurrentValue)}],
		["SLIDER",["Assistance request distance","Group(s) will request assistance from other groups within this distance"],[[0,10000,0],800],false,{},{10 call EFUNC(CDS,getCurrentValue)}],
		["SLIDER",["Max assistance response distance","Group(s) will only respond to assistance requests that are within this distance"],[[0,10000,0],800],false,{},{10 call EFUNC(CDS,getCurrentValue)}],
		["SLIDER",["QRF request distance","Group(s) will request assistance from other groups within this distance"],[[0,10000,0],1600],false,{},{10 call EFUNC(CDS,getCurrentValue)}],
		["SLIDER",["QRF response distance","Group(s) will only respond to assistance requests that are within this distance"],[[0,10000,0],1600],false,{},{10 call EFUNC(CDS,getCurrentValue)}],
		["EDITBOX",["Patrol radius random","Random patrol radii in format: [min,mid,max]"],"[125,200,250]",false,{},{10 call EFUNC(CDS,getCurrentValue)}],
		["COMBOBOX",["Locality","Spawns groups on specified machine"],[["Local","Server"] + (SAA_main_headlessClients apply {"HC: " + str _x}),0],false,{},{10 call EFUNC(CDS,getCurrentValue)}]
	],{
		deleteMarkerLocal GVAR(tempMarker);

		params ["_values","_pos"];
		_values params [
			"_sideSelection","_classes","_min","_max","_b1","_treePath","_presetSelection","_presetName",
			"_b2","_b3","_doOccupy","_isRectangle","_width","_height","_direction","_patrolCoef",
			"_garrisonCoef","_sentryCoef","_QRFCoef","_requestDistance","_responseDistance","_QRFRequestDistance",
			"_QRFResponseDistance","_patrolRadiusRandom","_localitySelection"
		];

		if (!_doOccupy) exitWith {};

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
