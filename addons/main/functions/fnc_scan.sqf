#include "script_component.hpp"

private _group = _this;
private _leaderPos = getPos leader _group;

if (_group getVariable ["SAA_allowCaching",true] && {SAA_setting_cachingEnabled && {(allPlayers findIf {_leaderPos distance _x < SAA_cachingDistance}) isEqualTo -1}}) exitWith {
	_group call FUNC(cacheGroup);
};

// Disable LAMBS_danger
if !(_group getVariable ["lambs_danger_disableGroupAI",false]) then {
	_group setVariable ["lambs_danger_disableGroupAI",true,true];
	{_x setVariable ["lambs_danger_disableAI",true,true]} forEach units _group;
};

private _targets = (leader _group) targets [true];

if (_targets isEqualTo []) exitWith {};

private _targetsToReport = _group getVariable "SAA_targetsToReport";
private _sideTargets = missionNamespace getVariable [format ["SAA_targets_%1",side _group],[]];
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
		_this call FUNC(reportTargets);
	},_group,8 + round random 6] call CBA_fnc_waitAndExecute;
};

// Reveal the area around new targets for accurate intel
{
	{_group reveal _x} forEach (_x nearEntities 25);
} forEach _newTargets;

nil
