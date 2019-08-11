#include "script_component.hpp"

private _group = _this;
private _targets = (leader _group) targets [true];
if (_targets isEqualTo []) exitWith {};

private _targetsToReport = _group getVariable "SAA_targetsToReport";
private _sideTargets = switch (side _group) do {
	case east : {SAA_targets_EAST};
	case independent : {SAA_targets_GUER};
	case west : {SAA_targets_WEST};
	default {[]};
};

private _newtargets = (_targets - _sideTargets - _targetsToReport) select {
	(_group knowsAbout _x) > 0.5 && {!(vehicle _x isKindOf "Air") && !(vehicle _x isKindOf "Ship") && ({alive _x} count crew _x) != 0}
};
if (_newTargets isEqualTo []) exitWith {};

_targetsToReport append _newTargets;
_group setVariable ["SAA_targetsToReport",_targetsToReport];

// Report all new targets after a short period of time
if (!(_targetsToReport isEqualTo []) && _group getVariable ["SAA_notReporting",true]) then {
	_group setVariable ["SAA_notReporting",false];
	[{
		_this setVariable ["SAA_notReporting",nil];
		_this call SAA_fnc_reportTargets;
	},_group,8 + round random 6] call CBA_fnc_waitAndExecute;
};

// Reveal the area around new targets for accurate intel
{
	{
		_group reveal _x;
		false
	} count (_x nearEntities 25);
	false
} count _newTargets;
