#include "script_component.hpp"

params ["_targets","_side"];

private _sideTargets = missionNamespace getVariable format ["SAA_targets_%1",_side];
missionNamespace setVariable [format ["SAA_targets_%1",_side],_sideTargets - _targets,true];
