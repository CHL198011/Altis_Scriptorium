#include "\Dom_Code\script_macros.hpp"
/*
	File: fn_notify.sqf
	Author: DomT602 (domt602@gmail.com)
	Description: Processes the given notification, places it into the notification array and monitors the notification
*/
params [
	["_message","",[""]],
	["_colour","blue",[""]],
	["_time",10,[0]]
];

private _colourCode = call {
	if (_colour isEqualTo "green") exitWith {"#1ea83c"};
	if (_colour isEqualTo "orange") exitWith {"#d1780c"};
	if (_colour isEqualTo "red") exitWith {"#d11414"};
	if (_colour isEqualTo "blue") exitWith {"#1e2adb"};
	if (_colour isEqualTo "grey") exitWith {"#696a7a"}; //add new colours below
};

_message = toString((toArray _message) apply {[_x, 110] select (_x isEqualTo 38)});
_message = format["<t size='1.3' color='%1'>%2",_colourCode,_message];

for "_i" from 15 to 1 step -1 do {
	DT_notif_array set [_i,DT_notif_array select (_i - 1)];
};

DT_notif_count = DT_notif_count + 1;
private _id = DT_notif_count;

DT_notif_array set [0,[_message,_id]];

call DT_fnc_showNotifs;

[
	{
		params [
			["_id",-1,[0]]
		];

		{
			_x params [
				"",
				["_oldID",-1,[0]]
			];
			if (_oldID isEqualTo _id) exitWith {
				DT_notif_array set [_forEachIndex,["",-1]];
				call DT_fnc_showNotifs;
			};
		} forEach DT_notif_array;
	},
	_id,
	_time
] call CBA_fnc_waitAndExecute;