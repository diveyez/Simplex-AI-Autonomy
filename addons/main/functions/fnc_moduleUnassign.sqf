#include "script_component.hpp"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	if (!local _logic) exitWith {};

	private _object = attachedTo _logic;
	deleteVehicle _logic;

	if (isNull _object) then {
		[{
			params ["_curatorSelected"];
			_curatorSelected params ["_objects","_groups"];

			if (_objects isEqualTo [] && {_groups isEqualTo []}) exitWith {[objNull,"Nothing selected"] call BIS_fnc_showCuratorFeedbackMessage;};

			{_groups pushBackUnique (group _x)} forEach _objects;

			if (_groups isEqualTo []) exitWith {[objNull,"No valid groups were selected"] call BIS_fnc_showCuratorFeedbackMessage;};

			{
				_x setVariable ["SAA_assignment",nil,true];
				_x setVariable ["SAA_available",nil,true];
			} forEach _groups;
		}] call FUNC(zeusSelection);
	} else {
		private _group = group _object;

		_group setVariable ["SAA_assignment",nil,true];
		_group setVariable ["SAA_available",nil,true];

		[_group,{
			{
				_x doFollow leader _this;
				_x enableAI "PATH";
			} forEach units _this;
		}] remoteExecCall ["call",leader _group];
	};
},_this] call CBA_fnc_directCall;
