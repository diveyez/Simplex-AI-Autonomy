#include "script_component.hpp"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	private _pos = getPos _logic;
	deleteVehicle _logic;

	GVAR(blackListTempMarkers) = GVAR(blacklist) apply {
		private _marker = str _x + str CBA_missionTime;
		createMarkerLocal [_marker,_x # 0];
		_marker setMarkerShapeLocal (["ELLIPSE","RECTANGLE"] select (_x # 4));
		_marker setMarkerSizeLocal [_x # 1,_x # 2];
		_marker setMarkerDirLocal (_x # 3);
		_marker setMarkerBrushLocal "FDiagonal";
		_marker setMarkerColorLocal "ColorWhite";
		_marker setMarkerAlphaLocal 0.5;
		_marker
	};

	[[36,21],[
		[[0,0,36,1],"STRUCTUREDTEXT","<t align='center'>Blacklist Area</t>",EGVAR(SDF,profileRGBA)],
		[[0,1,36,19],"MAP2","",[[_pos,100,100,0,false],"SOLID"]],
		[[0,20,18,1],"BUTTON","CANCEL",{{
			{deleteMarkerLocal _x} forEach GVAR(blackListTempMarkers);
		} call EFUNC(SDF,close)}],
		[[18,20,18,1],"BUTTON","CONFIRM",{[{
			{deleteMarkerLocal _x} forEach GVAR(blackListTempMarkers);

			params ["_values","_pos"];
			_values params ["","_area"];

			[QGVAR(addBlacklist),[_area]] call CBA_fnc_serverEvent;

			[objNull,"Blacklist added"] call BIS_fnc_showCuratorFeedbackMessage;
		},true] call EFUNC(SDF,close)}]
	]] call EFUNC(SDF,dialog);
},_this] call CBA_fnc_directCall;
