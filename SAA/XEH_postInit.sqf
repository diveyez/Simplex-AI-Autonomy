if (isServer) then {
	call SAA_fnc_startStateMachine;

	["SAA_assignment",SAA_fnc_assignmentDialogConfirm] call CBA_fnc_addEventHandler;

	/*
	["SAA_startStateMachine",{
		if (isNil "SAA_stateMachine") then {
			call SAA_fnc_startStateMachine;
		};
	}] call CBA_fnc_addEventHandler;
	["SAA_endStateMachine",{
		[SAA_stateMachine] call CBA_statemachine_fnc_delete;
		SAA_stateMachine = nil;
		publicVariable "SAA_stateMachine";
	}] call CBA_fnc_addEventHandler;
	*/
};

if (!hasInterface) exitWith {};

call SAA_fnc_zeusModules;
