#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = COMPONENT;
		author = "Simplex Team";
		authors[] = {"Simplex Team"};
		url = "https://github.com/SceptreOfficial/Simplex-AI-Autonomy";
		units[] = {};
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
