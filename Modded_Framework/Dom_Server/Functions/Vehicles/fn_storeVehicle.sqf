/*
    File: fn_storeVehicle.sqf
    Author: Dom
    Description: Stores the vehicle in the clients garage, if impounded it sets it to '1' in DB
    [_vehicle,false] remoteExecCall ["DB_fnc_storeVehicle",2];
*/
params [
    ["_vehicle",objNull,[objNull]],
    ["_impound",false,[false]]
];
if (isNull _vehicle) exitWith {};

private _plate = _vehicle getVariable ["plate",""];
if (_plate isEqualTo "") exitWith {
    ["Error code 01: report to devs."] remoteExecCall ["DT_fnc_notify",remoteExecutedOwner]
};

getAllHitPointsDamage _vehicle params ["", "", "_damage"];

private _fuel = fuel _vehicle;
_impound = if (_impound) then {1} else {0}; //silly thing as DB doesn't like true/false

[format["storeVehicle:%1:%2:%3:%4",_fuel,_damage,_impound,_plate],1] call MySQL_fnc_DBasync;

deleteVehicle _vehicle;

["Vehicle saved."] remoteExecCall ["DT_fnc_notify",remoteExecutedOwner];
