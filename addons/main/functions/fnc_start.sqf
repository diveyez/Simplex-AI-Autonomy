#include "script_component.hpp"

SAA_cachedGroups = [];
SAA_loopList = [];
SAA_loopIndex = 0;
SAA_EFID = addMissionEventHandler ["EachFrame",{call FUNC(clockwork)}];
