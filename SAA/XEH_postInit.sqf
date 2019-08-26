#include "script_component.hpp"

if (isServer) then {
	private _stateMachine = [{allGroups select {!isNil {_x getVariable "SAA_assignment"}}},true] call CBA_statemachine_fnc_create;
	[_stateMachine,{_this call SAA_fnc_checkTargets},{},{},"CheckTargets"] call CBA_statemachine_fnc_addState;
	SAA_stateMachine = _stateMachine;
	publicVariable "SAA_stateMachine";

	["SAA_assignment",SAA_fnc_assignmentDialogConfirm] call CBA_fnc_addEventHandler;
};
