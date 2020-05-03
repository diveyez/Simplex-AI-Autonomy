class CfgVehicles {
	class Logic;
	class Module_F : Logic {
		class ModuleDescription;
	};

	class SAA_Module_Base: Module_F {
		category = "SAA_Modules";
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

	class SAA_Module_AssignFree : SAA_Module_Base {
		displayName = "Assign Free";
		icon = ICON_FREE;
		function = QFUNC(moduleAssign);
		scopeCurator = 2;
		SAA_assignment = "FREE";
	};

	class SAA_Module_AssignGarrison : SAA_Module_Base {
		displayName = "Assign Garrison";
		icon = ICON_GARRISON;
		function = QFUNC(moduleAssign);
		scopeCurator = 2;
		SAA_assignment = "GARRISON";
	};

	class SAA_Module_AssignPatrol : SAA_Module_Base {
		displayName = "Assign Patrol";
		icon = ICON_PATROL;
		function = QFUNC(moduleAssign);
		scopeCurator = 2;
		SAA_assignment = "PATROL";
	};

	class SAA_Module_AssignQRF : SAA_Module_Base {
		displayName = "Assign QRF";
		icon = ICON_QRF;
		function = QFUNC(moduleAssign);
		scopeCurator = 2;
		SAA_assignment = "QRF";
	};

	class SAA_Module_AssignSentry : SAA_Module_Base {
		displayName = "Assign Sentry";
		icon = ICON_SENTRY;
		function = QFUNC(moduleAssign);
		scopeCurator = 2;
		SAA_assignment = "SENTRY";
	};
};
