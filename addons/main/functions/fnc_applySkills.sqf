#include "script_component.hpp"

params ["_unit"];

if (!(_unit getVariable ["SAA_setSkills",true]) || !(side group _unit in [west,east,independent])) exitWith {};

_unit setSkill ["general",GVAR(skillsGeneral)];
_unit setSkill ["commanding",GVAR(skillsGeneral)];
_unit setSkill ["courage",[GVAR(skillsGeneral),1] select GVAR(skillsFullCourage)];
_unit setSkill ["aimingAccuracy",GVAR(skillsAccuracy)];
_unit setSkill ["aimingShake",GVAR(skillsHandling)];
_unit setSkill ["aimingSpeed",GVAR(skillsHandling)];
_unit setSkill ["reloadSpeed",GVAR(skillsHandling)];
_unit setSkill ["spotDistance",GVAR(skillsSpotting)];
_unit setSkill ["spotTime",GVAR(skillsSpotting)];
