#include "\x\cba\addons\main\script_macros_common.hpp"
#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)
#ifdef DISABLE_COMPILE_CACHE
	#undef PREP
	#define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
	#undef PREP
	#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

// Custom macros

#define SAA_LOG(MESSAGE) 										private _logMessage = format ["SAA %1",MESSAGE]; diag_log _logMessage; systemChat _logMessage;

#define SAA_DEBUG(MESSAGE) 										if (SAA_setting_enableDebug) then {SAA_LOG(FORMAT_1("Debug: %1",MESSAGE))};
#define SAA_DEBUG_1(MESSAGE,ARG1) 								SAA_DEBUG(FORMAT_1(MESSAGE,ARG1))
#define SAA_DEBUG_2(MESSAGE,ARG1,ARG2) 							SAA_DEBUG(FORMAT_2(MESSAGE,ARG1,ARG2))
#define SAA_DEBUG_3(MESSAGE,ARG1,ARG2,ARG3) 					SAA_DEBUG(FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define SAA_DEBUG_4(MESSAGE,ARG1,ARG2,ARG3,ARG4) 				SAA_DEBUG(FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define SAA_DEBUG_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) 			SAA_DEBUG(FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))
#define SAA_ERROR(MESSAGE) 										SAA_LOG(FORMAT_1("Error: %1",MESSAGE))
#define SAA_ERROR_1(MESSAGE,ARG1) 								SAA_ERROR(FORMAT_1(MESSAGE,ARG1))
#define SAA_ERROR_2(MESSAGE,ARG1,ARG2) 							SAA_ERROR(FORMAT_2(MESSAGE,ARG1,ARG2))
#define SAA_ERROR_3(MESSAGE,ARG1,ARG2,ARG3) 					SAA_ERROR(FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define SAA_ERROR_4(MESSAGE,ARG1,ARG2,ARG3,ARG4) 				SAA_ERROR(FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define SAA_ERROR_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) 			SAA_ERROR(FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))
#define SAA_WARNING(MESSAGE) 									SAA_LOG(FORMAT_1("Warning: %1",MESSAGE))
#define SAA_WARNING_1(MESSAGE,ARG1) 							SAA_ERROR(FORMAT_1(MESSAGE,ARG1))
#define SAA_WARNING_2(MESSAGE,ARG1,ARG2) 						SAA_ERROR(FORMAT_2(MESSAGE,ARG1,ARG2))
#define SAA_WARNING_3(MESSAGE,ARG1,ARG2,ARG3) 					SAA_ERROR(FORMAT_3(MESSAGE,ARG1,ARG2,ARG3))
#define SAA_WARNING_4(MESSAGE,ARG1,ARG2,ARG3,ARG4) 				SAA_ERROR(FORMAT_4(MESSAGE,ARG1,ARG2,ARG3,ARG4))
#define SAA_WARNING_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5) 		SAA_ERROR(FORMAT_5(MESSAGE,ARG1,ARG2,ARG3,ARG4,ARG5))

#define ICON_FREE "z\SAA\addons\main\data\free.paa"
#define ICON_GARRISON "z\SAA\addons\main\data\garrison.paa"
#define ICON_PATROL "z\SAA\addons\main\data\patrol.paa"
#define ICON_QRF "z\SAA\addons\main\data\qrf.paa"
#define ICON_SENTRY "z\SAA\addons\main\data\sentry.paa"
#define ICON_OCCUPY "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa"
#define ICON_OCCUPYMANAGE "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa"
#define ICON_TOGGLECACHING "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\download_ca.paa"
#define ICON_UNASSIGN "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa"

#define SMOKE_TYPES [ \
	["SmokeShell","SmokeShellMuzzle"], \
	["SmokeShellBlue","SmokeShellBlueMuzzle"], \
	["SmokeShellGreen","SmokeShellGreenMuzzle"], \
	["SmokeShellYellow","SmokeShellYellowMuzzle"], \
	["SmokeShellRed","SmokeShellRedMuzzle"] \
]
