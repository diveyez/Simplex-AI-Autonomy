/*-----------------------------------------------------------------------------------------------//
Authors: Sceptre
Sets the condition to enable the use of a control.

Parameters:
0: Control index <SCALAR>
1: New condition <CODE>

Returns:
Nothing
//-----------------------------------------------------------------------------------------------*/
#include "..\defines.hpp"

disableSerialization;
params [["_index",0,[0]],["_enableCondition",{true},[{}]]];

private _ctrl = findDisplay DISPLAY_IDD displayCtrl ((uiNamespace getVariable "SAA_CDS_controls") # _index);
private _ctrlInfo = _ctrl getVariable "SAA_CDS_ctrlInfo";

_ctrlInfo set [4,_enableCondition];
_ctrl setVariable ["SAA_CDS_ctrlInfo",_ctrlInfo];

