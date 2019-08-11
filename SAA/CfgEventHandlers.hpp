class Extended_PreInit_EventHandlers {
	class SAA_preInit {
		init = "call compile preprocessFileLineNumbers 'SAA\XEH_preInit.sqf'";
	};
};

class Extended_PostInit_EventHandlers {
	class SAA_postInit {
		init = "call compile preprocessFileLineNumbers 'SAA\XEH_postInit.sqf'";
	};
};
