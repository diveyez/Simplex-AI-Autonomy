#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = COMPONENT;
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {
			"A3_ui_f",
			"saa_main"
		};
		author = "Simplex Team";
		url = "https://github.com/SceptreOfficial/Simplex-AI-Autonomy";
		VERSION_CONFIG;
	};
};

#include "CfgEventHandlers.hpp"
#include "gui.hpp"
