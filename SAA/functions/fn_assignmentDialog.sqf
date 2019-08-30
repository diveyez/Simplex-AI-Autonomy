#include "script_component.hpp"
#define DIALOG_CONFIRM \
	["SAA_assignment",_this] call CBA_fnc_serverEvent; \
	[objNull,"Assignment Confirmed"] call BIS_fnc_showCuratorFeedbackMessage;

#define DIALOG_CANCEL [objNull,"Assignment Cancelled"] call BIS_fnc_showCuratorFeedbackMessage;
#define DEFAULT_DIALOG_OPTIONS \
	["SLIDER",["Assistance request distance","Group(s) will request assistance from other groups within this distance"],[[0,10000,0],800]], \
	["SLIDER",["Max assistance response distance","Group(s) will only respond to assistance requests that are within this distance"],[[0,10000,0],800]], \
	["CHECKBOX",["Transfer to server","Transfers group locality to the server"],true,false]

params [["_assignment","",[""]],["_input",grpNull,[grpNull,[]]]];

private _groups = if (_input isEqualType []) then {_input} else {[_input]};

switch (_assignment) do {
	case "FREE" : {
		["Assign Free Group(s)",[
			DEFAULT_DIALOG_OPTIONS
		],{DIALOG_CONFIRM},{DIALOG_CANCEL},[_assignment,_groups]] call SAA_CDS_fnc_dialog;
	};
	case "GARRISON" : {
		["Assign Garrison Group(s)",[
			["COMBOBOX","Garrison type",[[
				["Responsive","Units garrison until engaged or requested"],
				["Repositioning","Units move around the area when engaged. Will not respond to requests"],
				["Static","Units remain stationary. Will not respond to requests"]
			],0],true,{
				if ((_this # 0) in [1,2]) then {
					[3,{false}] call SAA_CDS_fnc_setEnableCondition;
				} else {
					[3,{true}] call SAA_CDS_fnc_setEnableCondition;
				};
			}],
			["CHECKBOX",["Teleport to positions","Teleports units into garrison positions"],true],
			DEFAULT_DIALOG_OPTIONS
		],{DIALOG_CONFIRM},{DIALOG_CANCEL},[_assignment,_groups]] call SAA_CDS_fnc_dialog;
	};
	case "PATROL" : {
		["Assign Patrol Group(s)",[
			["EDITBOX","Patrol Radius","100"],
			["COMBOBOX","Patrol route type",[["Random","Cyclical"],0],true,{
				[2,[{true},{false}] select ((_this # 0) isEqualTo 0)] call SAA_CDS_fnc_setEnableCondition;
			}],
			["COMBOBOX","Patrol route style",[["Clockwise Circle","Counter-Clockwise Circle"/*,"Terrain High Points"*/],0]],
			DEFAULT_DIALOG_OPTIONS
		],{DIALOG_CONFIRM},{DIALOG_CANCEL},[_assignment,_groups]] call SAA_CDS_fnc_dialog;
	};
	case "QRF" : {
		["Assign QRF Group(s)",[
			["SLIDER",["Assistance request distance","Group(s) will request assistance from other groups within this distance"],[[0,5000,0],600]],
			["SLIDER",["Max assistance response distance","QRF respond to all requests"],[[0,5000,0],5000],true,{},{false}],
			["CHECKBOX",["Transfer to server","Transfers group locality to the server"],true,false]
		],{DIALOG_CONFIRM},{DIALOG_CANCEL},[_assignment,_groups]] call SAA_CDS_fnc_dialog;
	};
	case "SENTRY" : {
		["Assign Sentry Group(s)",[
			DEFAULT_DIALOG_OPTIONS
		],{DIALOG_CONFIRM},{DIALOG_CANCEL},[_assignment,_groups]] call SAA_CDS_fnc_dialog;
	};
};
