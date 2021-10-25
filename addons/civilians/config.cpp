#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = COMPONENT;
		author = "Simplex Team";
		authors[] = {"Simplex Team"};
		url = "https://github.com/SceptreOfficial/Simplex-AI-Autonomy";
		units[] = {
			QGVAR(Module_AddPanic),
			QGVAR(Module_BlacklistArea),
			QGVAR(Module_Populate),
			QGVAR(Module_ToggleAircraft),
			QGVAR(Module_ToggleCivilians)
		};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {"saa_main"};
		VERSION_CONFIG;
	};
};

#include "CfgEventHandlers.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgVehicles.hpp"
