class CfgVehicles {
	class Logic;
	class Module_F : Logic {
		class ModuleDescription;
	};

	class SAA_Civ_Module_Base: Module_F {
		category = "SAA_Civ_Modules";
		author = "Simplex Team";
		displayName = "";
		icon = "";
		portrait = "";
		side = 7;
		scope = 1;
		scopeCurator = 1;
		curatorCanAttach = 1;
		function = "";
		functionPriority = 1;
		isGlobal = 1;
		isTriggerActivated = 0;
		isDisposable = 0;
	};

	class SAA_Civ_Module_AddPanic : SAA_Civ_Module_Base {
		displayName = "Add Panic Feature";
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\danger_ca.paa";
		function = QFUNC(moduleAddPanic);
		scopeCurator = 2;
	};

	class SAA_Civ_Module_BlacklistArea : SAA_Civ_Module_Base {
		displayName = "Blacklist Area";
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
		function = QFUNC(moduleBlacklistArea);
		scopeCurator = 2;
	};

	class SAA_Civ_Module_Populate : SAA_Civ_Module_Base {
		displayName = "Populate Area";
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa";
		function = QFUNC(modulePopulate);
		scopeCurator = 2;
	};

	class SAA_Civ_Module_Toggle : SAA_Civ_Module_Base {
		displayName = "Toggle Ambient Civilians";
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\intel_ca.paa";
		function = QFUNC(moduleToggle);
		scopeCurator = 2;
	};
};
