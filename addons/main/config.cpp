#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = COMPONENT;
		author = "Simplex Team";
		authors[] = {"Simplex Team"};
		url = "https://github.com/SceptreOfficial/Simplex-AI-Autonomy";
		units[] = {
			"SAA_Module_AssignFree",
			"SAA_Module_AssignGarrison",
			"SAA_Module_AssignPatrol",
			"SAA_Module_AssignQRF",
			"SAA_Module_AssignSentry"
		};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {
			"A3_Modules_F",
			"A3_Modules_F_Curator",
			"cba_ai",
			"cba_common",
			"cba_events",
			"cba_main",
			"cba_settings",
			"cba_statemachine",
			"cba_xeh"
		};
		VERSION_CONFIG;
	};
};

#include "CfgEventHandlers.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgSounds.hpp"
#include "CfgVehicles.hpp"
