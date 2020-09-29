#include "script_component.hpp"

[{
	params ["_logic","_synced"];

	private _posASL = getPosASL _logic;
	deleteVehicle _logic;

	([_posASL] call EFUNC(CDS,dialogMarker)) params ["_pos","_isRectangle","_width","_height","_direction","_useDefaultValue","_tempMarker"];
	GVAR(tempMarker) = _tempMarker;

	["Populate Area",[
		["CHECKBOX","Rectangle",_isRectangle,_useDefaultValue,{
			params ["_bool"];
			GVAR(tempMarker) setMarkerShapeLocal (["ELLIPSE","RECTANGLE"] select _bool);
		}],
		["EDITBOX","Width",_width,_useDefaultValue,{
			params ["_text"];
			GVAR(tempMarker) setMarkerSizeLocal [abs parseNumber _text,abs parseNumber (2 call EFUNC(CDS,getCurrentValue))];
		}],
		["EDITBOX","Height",_height,_useDefaultValue,{
			params ["_text"];
			GVAR(tempMarker) setMarkerSizeLocal [abs parseNumber (1 call EFUNC(CDS,getCurrentValue)),abs parseNumber _text];
		}],
		["SLIDER","Direction",[[0,360,0],_direction],_useDefaultValue,{
			params ["_direction"];
			GVAR(tempMarker) setMarkerDirLocal _direction;
		}],
		["EDITBOX","Unit classes",str ["C_Man_casual_2_F","C_Man_casual_3_F","C_man_w_worker_F","C_man_polo_2_F","C_Man_casual_1_F","C_man_polo_4_F"],false],
		["EDITBOX","Vehicle classes",str ["C_Truck_02_fuel_F","C_Truck_02_box_F","C_Truck_02_covered_F","C_Offroad_01_repair_F","C_Van_01_box_F","C_Offroad_01_F","C_Offroad_01_covered_F","C_SUV_01_F"],false],
		["SLIDER","Pedestrians",[[0,100,0],0],false],
		["SLIDER","Driving vehicles",[[0,50,0],0],false],
		["SLIDER","Parked vehicles",[[0,50,0],0],false],
		["COMBOBOX",["Locality","Spawns groups on specified machine"],[["Local","Server"] + (EGVAR(main,headlessClients) apply {"HC: " + str _x}),0],false]
	],{
		deleteMarkerLocal GVAR(tempMarker);

		params ["_values","_pos"];
		_values params ["_isRectangle","_width","_height","_direction","_unitClasses","_vehClasses","_pedCount","_driverCount","_parkedCount","_localitySelection"];
		_width = abs parseNumber _width;
		_height = abs parseNumber _height;
		_unitClasses = parseSimpleArray _unitClasses;
		_vehClasses = parseSimpleArray _vehClasses;

		private _populateParams = [[_pos,_width,_height,_direction,_isRectangle],_unitClasses,_vehicleClasses,[_pedCount,_driverCount,_parkedCount]];

		if (_localitySelection > 0) then {
			[QGVAR(localityExec),[_localitySelection,_populateParams,QFUNC(populate)]] call CBA_fnc_serverEvent;
		} else {
			_populateParams call FUNC(populate);
		};

		[objNull,"Area populated"] call BIS_fnc_showCuratorFeedbackMessage;
	},{deleteMarkerLocal GVAR(tempMarker)},_pos] call EFUNC(CDS,dialog);
},_this] call CBA_fnc_directCall;
