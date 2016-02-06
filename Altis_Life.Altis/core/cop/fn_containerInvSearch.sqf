#include "..\..\script_macros.hpp"
/*
	File: fn_vehInvSearch.sqf
	Author: Bryan "Tonic" Boardwine

	Description:
	Searches the vehicle for illegal items.
*/
private["_container","_containerInfo","_value"];
_container = [_this,0,Objnull,[Objnull]] call BIS_fnc_param;
if(isNull _container) exitWith {};

_containerInfo = _container GVAR ["Trunk",[]];
if(EQUAL(count _containerInfo,0)) exitWith {hint localize "STR_Cop_ContainerEmpty"};

_value = 0;
{
	_var = SEL(_x,0);
	_val = SEL(_x,1);

	if(EQUAL(ITEM_ILLEGAL(_var),1)) then {
		if(!(EQUAL(ITEM_SELLPRICE(_var),-1))) then {
			ADD(_value,(round(_val * ITEM_SELLPRICE(_var) / 2)));
		};
	};
} foreach (SEL(_containerInfo,0));

if(_value > 0) then {
	[0,"STR_NOTF_ContainerContraband",true,[[_value] call life_fnc_numberText]] remoteExecCall ["life_fnc_broadcast",RCLIENT];
	ADD(BANK,_value);
	_vehicle SVAR ["Trunk",[[],0],true];
	[_vehicle] remoteExecCall ["TON_fnc_updateHouseTrunk",2];
} else {
	hint localize "STR_Cop_NoIllegalCOntainer";
};