#include "script_component.hpp"
#define DIALOG_CONFIRM \
	["SAA_assignment",_this] call CBA_fnc_serverEvent; \
	[objNull,"Assignment Confirmed"] call BIS_fnc_showCuratorFeedbackMessage;

#define DIALOG_CANCEL [objNull,"Assignment Cancelled"] call BIS_fnc_showCuratorFeedbackMessage;
#define DEFAULT_DIALOG_OPTIONS \
	["SLIDER",["Assistance request distance","Group(s) will request assistance from other groups within this distance"],[[0,10000,0],800],false], \
	["SLIDER",["Max assistance response distance","Group(s) will only respond to assistance requests that are within this distance"],[[0,10000,0],800],false], \
	["COMBOBOX",["Transfer locality","Transfers group locality to specified machine"],[["Keep current locality","Transfer to Server"] + (GVAR(headlessClients) apply {"HC: " + str _x}),0],false]

params [["_assignment","",[""]],["_input",grpNull,[grpNull,[]]]];

private _groups = if (_input isEqualType []) then {_input} else {[_input]};

switch (_assignment) do {
	case "FREE" : {
		["Assign Free Group(s)",[
			DEFAULT_DIALOG_OPTIONS
		],{DIALOG_CONFIRM},{DIALOG_CANCEL},[_assignment,_groups]] call EFUNC(CDS,dialog);
	};
	case "GARRISON" : {
		["Assign Garrison Group(s)",[
			["COMBOBOX","Garrison type",[[
				["Responsive","Units garrison until engaged or requested"],
				["Repositioning","Units move around the area when engaged. Will not respond to requests"],
				["Static","Units remain stationary. Will not respond to requests"]
			],0],false,{
				if ((_this # 0) in [1,2]) then {
					[3,false] call EFUNC(CDS,setEnableCondition);
				} else {
					[3,true] call EFUNC(CDS,setEnableCondition);
				};
			}],
			["CHECKBOX",["Teleport to positions","Teleports units into garrison positions"],false,false],
			DEFAULT_DIALOG_OPTIONS
		],{DIALOG_CONFIRM},{DIALOG_CANCEL},[_assignment,_groups]] call EFUNC(CDS,dialog);
	};
	case "PATROL" : {
		["Assign Patrol Group(s)",[
			["EDITBOX","Patrol Radius","100",false],
			["COMBOBOX","Patrol route type",[["Random","Cyclical"],0],false,{
				[2,(_this # 0) isEqualTo 1] call EFUNC(CDS,setEnableCondition);
			}],
			["COMBOBOX","Patrol route style",[["Clockwise Circle","Counter-Clockwise Circle"],0],false],
			DEFAULT_DIALOG_OPTIONS
		],{DIALOG_CONFIRM},{DIALOG_CANCEL},[_assignment,_groups]] call EFUNC(CDS,dialog);
	};
	case "QRF" : {
		["Assign QRF Group(s)",[
			DEFAULT_DIALOG_OPTIONS
		],{DIALOG_CONFIRM},{DIALOG_CANCEL},[_assignment,_groups]] call EFUNC(CDS,dialog);
	};
	case "SENTRY" : {
		["Assign Sentry Group(s)",[
			DEFAULT_DIALOG_OPTIONS
		],{DIALOG_CONFIRM},{DIALOG_CANCEL},[_assignment,_groups]] call EFUNC(CDS,dialog);
	};
};