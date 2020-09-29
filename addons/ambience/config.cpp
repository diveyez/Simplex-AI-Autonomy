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
			"SAA_main"
		};
		VERSION_CONFIG;
	};
};

#include "CfgEventHandlers.hpp"
