#include "script_component.hpp"

private _stateMachine = [{SAA_AI_GROUPS},true] call CBA_statemachine_fnc_create;
[_stateMachine,SAA_fnc_checkTargets,{},{},"CheckTargets"] call CBA_statemachine_fnc_addState;

SAA_stateMachine = _stateMachine;
publicVariable "SAA_stateMachine";
