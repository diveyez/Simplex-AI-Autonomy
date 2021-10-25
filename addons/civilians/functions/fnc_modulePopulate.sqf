#include "script_component.hpp"
#define UNIT_CLASSES ["C_Man_casual_2_F","C_Man_casual_3_F","C_man_w_worker_F","C_man_polo_2_F","C_Man_casual_1_F","C_man_polo_4_F"]
#define VEH_CLASSES ["C_Truck_02_fuel_F","C_Truck_02_box_F","C_Truck_02_covered_F","C_Offroad_01_repair_F","C_Van_01_box_F","C_Offroad_01_F","C_Offroad_01_covered_F","C_SUV_01_F"]

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

	[[36,20],[
		[[0,0,36,1],"STRUCTUREDTEXT",format ["<t align='center'>%1</t>",LLSTRING(Module_Populate)],EGVAR(SDF,profileRGBA)],
		[[18,1,18,19],"MAP2","",[[_pos,100,100,0,false],"SOLID"]],
		[[6,1,12,1],"EDITBOX","Units",str UNIT_CLASSES,false],
		[[6,2,12,1],"EDITBOX","Vehicles",str VEH_CLASSES,false],
		[[6,3,12,1],"SLIDER","Pedestrians",[[0,100,0],0],false],
		[[6,4,12,1],"SLIDER","Driving",[[0,50,0],0],false],
		[[6,5,12,1],"SLIDER","Parked",[[0,50,0],0],false],
		[[6,6,12,1],"COMBOBOX","Locality",[[LLSTRING(Local),LLSTRING(Server)] + (EGVAR(common,headlessClients) apply {LLSTRING(HC) + str _x}),0],false],
		[[0,1,6,1],"TEXT",LLSTRING(SettingName_unitClassesStr)],
		[[0,2,6,1],"TEXT",LLSTRING(SettingName_vehClassesStr)],
		[[0,3,6,1],"TEXT",LLSTRING(SettingName_pedestrianCount)],
		[[0,4,6,1],"TEXT",LLSTRING(SettingName_driverCount)],
		[[0,5,6,1],"TEXT",LLSTRING(SettingName_parkedCount)],
		[[0,6,6,1],"TEXT",[LLSTRING(Locality),LLSTRING(LocalityGroupsInfo)]],
		[[0,19,9,1],"BUTTON",localize "STR_SDF_CANCEL",{{
			{deleteMarkerLocal _x} forEach GVAR(blackListTempMarkers);
		} call EFUNC(SDF,close)}],
		[[9,19,9,1],"BUTTON",localize "STR_SDF_CONFIRM",{[{
			{deleteMarkerLocal _x} forEach GVAR(blackListTempMarkers);

			params ["_values","_pos"];
			_values params ["","_area","_unitClasses","_vehClasses","_pedestrians","_drivers","_parked","_localitySelection"];

			_unitClasses = parseSimpleArray _unitClasses;
			_vehClasses = parseSimpleArray _vehClasses;

			private _params = [_area,_unitClasses,_vehClasses,[_pedestrians,_drivers,_parked],[],{},[],false,[0,0.3,0.4]];

			if (_localitySelection > 0) then {
				[QGVAR(localityExec),[_localitySelection,_params,QFUNC(populate)]] call CBA_fnc_serverEvent;
			} else {
				_params call FUNC(populate);
			};

			[objNull,LLSTRING(Module_Populate_AreaPopulated)] call BIS_fnc_showCuratorFeedbackMessage;
		},true] call EFUNC(SDF,close)}]
	]] call EFUNC(SDF,dialog);
},_this] call CBA_fnc_directCall;
