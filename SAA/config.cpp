#include "script_component.hpp"

class CfgPatches {
	class SAA {
		name = COMPONENT;
		author = "Sceptre";
		authors[] = {"Sceptre"};
		url = "https://github.com/SceptreOfficial/Simplex-AI-Autonomy";
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {
			"cba_ai",
			"cba_common",
			"cba_events",
			"cba_settings",
			"cba_statemachine",
			"cba_xeh",
			"zen_common",
			"zen_custom_modules"
		};
		VERSION_CONFIG;
	};
};


#include "CDS\gui.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgFunctions.hpp"
#include "CfgSounds.hpp"
