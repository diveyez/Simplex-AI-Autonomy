class CfgFunctions {
	class SAA {
		tag = "SAA";
		class functions {
			file = "SAA\functions";
			class addWaypoint {};
			class analyzeAndCollect {};
			class assignGroups {};
			class assignmentDialog {};
			class assignmentDialogConfirm {};
			class checkTargets {};
			class cleanupTargets {};
			class clearWaypoints {};
			class garrison {};
			class getAmmoUsageFlags {};
			class getTypes {};
			class orderAttack {};
			class orderRegroup {};
			class patrol {};
			class reportTargets {};
			class returnToOrigin {};
			class startStateMachine {};
			class theNudge {};
			class trackEngagement {};
			class zeusEH {};
			class zeusModules {};
			class zeusSelection {};
		};
	};

	class SAA_CDS {
		tag = "SAA_CDS";
		class functions {
			file = "SAA\CDS\functions";
			class cacheValue {};
			class cancel {};
			class confirm {};
			class dialog {};
			class getCurrentValue {};
			class setDescription {};
			class setEnableCondition {};
			class setOnValueChanged {};
			class setValues {};
		};
	};
};
