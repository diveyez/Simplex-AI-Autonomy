#include "script_component.hpp"

[{
	params ["_logic","_synced"];

	private _obj = attachedTo _logic;
	deleteVehicle _logic;

	if (isNull _obj) then {
		[{
			params ["_curatorSelected","_args"];
			
			{
				if (side _x == civilian) then {
					{_x call FUNC(addPanic)} forEach units _x;
				};
			} forEach (_curatorSelected # 1); // groups
		}] call EFUNC(common,zeusSelection);
	} else {
		if (side group _obj == civilian) then {
			_obj call FUNC(addPanic);
			[objNull,"PANIC FEATURE ADDED"] call BIS_fnc_showCuratorFeedbackMessage;
		} else {
			[objNull,"NOT A CIVILIAN"] call BIS_fnc_showCuratorFeedbackMessage;
		};
	};
},_this] call CBA_fnc_directCall;
