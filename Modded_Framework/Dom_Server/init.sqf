/*
	File: init.sqf
	Author: Dom
	Description: Begins initialisation for serverside stuff
*/

private _databaseSetup = ["DT_DB"] call MYSQL_fnc_DBinit;
if !(_databaseSetup) exitWith {diag_log "Database setup failed - check RPT and ExtDB3 Logs"};

addMissionEventHandler ["HandleDisconnect",{_this call server_fnc_onClientDisconnect; false}];
addMissionEventHandler ["EntityKilled", {_this call server_fnc_entityKilled}];

["resetPositions:[]:[]",1] call MySQL_fnc_DBasync;
["resetVehicles",1] call MySQL_fnc_DBasync;
([format["selectPersisVars:%1",0],2] call MySQL_fnc_DBasync) params [
	["_threat","Green",[""]],
	["_mayor","Aquarium",[""]],
	["_tax",[0,0,0],[[]]],
	["_bank",0,[0]],
	["_announcement","",[""]]
];
_tax params ["_atmTax","_itemTax","_vehTax"];
gov_bank = _bank;

call DB_fnc_initBuildings;
[0] call DB_fnc_fetchData;
call DB_fnc_populateCompanies;

[(30 + round(random 20))] call server_fnc_spawnAnimal;
[(getMarkerPos "Mine_Marker"),20] call server_fnc_respawnRock;

//vars here
jail_bombPlanted = false;
publicVariable "jail_bombPlanted";
jail_deviceSet = false;
publicVariable "jail_deviceSet";
threat_level = _threat;
publicVariable "threat_level";
mayor = _mayor;
publicVariable "mayor";
PD_announcement = _announcement;
publicVariable "PD_announcement";
PD_otherBOLOs = [];
publicVariable "PD_otherBOLOs";
PD_vehBOLOs = [];
publicVariable "PD_vehBOLOs";
dealer_positions = [];
publicVariable "dealer_positions";
//rebel_use = true;
//publicVariable "rebel_use";
//rebel_started = false;
//publicVariable "rebel_started";
//rebel_time = time;
//publicVariable "rebel_time";
fire_handle = -1;
server_fires = [];
farming_handle = -1;
server_crops = [];
fishing_handle = -1;
server_nets = [];
spike_handle = -1;
server_spikes = [];

mod_list = [];
{
	mod_list pushBack (configName _x);
} forEach ("true" configClasses (configFile >> "CfgPatches"));
publicVariable "mod_list";
mod_list = nil;

call server_fnc_monitorServer;