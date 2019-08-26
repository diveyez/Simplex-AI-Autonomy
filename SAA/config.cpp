#include "script_component.hpp"

class CfgPatches {
	class SAA {
		name = COMPONENT;
		author = "Sceptre";
		authors[] = {"Sceptre"};
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
			"cba_ai",
			"cba_common",
			"cba_events",
			"cba_settings",
			"cba_statemachine",
			"cba_xeh",
		};
		VERSION_CONFIG;
	};
};


#include "CDS\gui.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgFunctions.hpp"
#include "CfgSounds.hpp"
#include "CfgVehicles.hpp"
