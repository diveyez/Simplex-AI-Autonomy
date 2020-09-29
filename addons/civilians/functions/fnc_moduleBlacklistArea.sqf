#include "script_component.hpp"

[{
	params ["_logic","_synced"];

	private _posASL = getPosASL _logic;
	deleteVehicle _logic;

	([_posASL] call EFUNC(CDS,dialogMarker)) params ["_pos","_isRectangle","_width","_height","_direction","_useDefaultValue","_tempMarker"];
	GVAR(tempMarker) = _tempMarker;

	["Blacklist Area",[
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
		}]
	],{
		deleteMarkerLocal GVAR(tempMarker);

		params ["_values","_pos"];
		_values params ["_isRectangle","_width","_height","_direction"];
		_width = abs parseNumber _width;
		_height = abs parseNumber _height;
		
		[QGVAR(addBlacklist),[[_pos,_width,_height,_direction,_isRectangle]]] call CBA_fnc_serverEvent;

		[objNull,"Blacklist added"] call BIS_fnc_showCuratorFeedbackMessage;
	},{deleteMarkerLocal GVAR(tempMarker)},_pos] call EFUNC(CDS,dialog);
},_this] call CBA_fnc_directCall;
