CMD:despawnpg(playerid, params[])
{
	// Pedagang Vehicle
	if(IsPlayerInRangeOfPoint(playerid, 8.0, 1185.0110, -885.9691, 43.1506))
	{
		if(pData[playerid][pFaction] != 5)
	        return Error(playerid, "You must be at pedagang officer faction!.");
	        
		new vehicleid = GetPlayerVehicleID(playerid);
        if(!IsEngineVehicle(vehicleid))
			return Error(playerid, "Kamu tidak berada didalam kendaraan.");

    	DestroyVehicle(PDGVeh[playerid]);
		pData[playerid][pSpawnPg] = 0;
    	GameTextForPlayer(playerid, "~w~This Is Vehicles ~r~Despawned", 3500, 3);
    }
    return 1;
}
CMD:spawnpg(playerid, params[])
{
    // Pedagang Vehicle
	if(IsPlayerInRangeOfPoint(playerid, 8.0, 1185.0110, -885.9691, 43.1506))
	{
		if(pData[playerid][pFaction] != 5)
	        return Error(playerid, "You must be at pedagang officer faction!.");

		if(pData[playerid][pSpawnPg] == 1) return Error(playerid,"Anda sudah mengeluarkan 1 kendaraan.!");

	    new Zan[10000], String[10000];
	    strcat(Zan, "Vehicles Name\tType\n");
		format(String, sizeof(String), "Pedagang\tCars\n");// 596
		strcat(Zan, String);
		format(String, sizeof(String), "Pizza Boys\tCars\n");// 597
		strcat(Zan, String);/*
		format(String, sizeof(String), "Helicopter\tCars\n");// 598
		strcat(Zann, String);
		format(String, sizeof(String), "Helicopter 2\tCars\n"); // 599
		strcat(Zann, String);
		format(String, sizeof(String), "Premier\tSport Cars\n"); // 599
		strcat(Zann, String);*/
		ShowPlayerDialog(playerid,DIALOG_PEDAGANG_GARAGE, DIALOG_STYLE_TABLIST_HEADERS,"Static Vehicles Pedagang", Zan, "Spawn","Cancel");
	}
	return 1;
}

// STATISTIC VEHICLE SAMD //
#include <YSI_Coding\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_PEDAGANG_GARAGE)
	{
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1185.0110, -885.9691, 43.1506))
				{
					PDGVeh[playerid] = CreateVehicle(423, 1179.4480, -876.8039, 43.4117, 99.9119, 0, 1, 120000, 1);
					//AddVehicleComponent(SAPDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned PEDAGANG Vehicles '"YELLOW_E"/despawnpg"WHITE_E"' to despawn vehicles");
			}
			case 1:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1185.0110, -885.9691, 43.1506))
				{
					PDGVeh[playerid] = CreateVehicle(448, 1179.4480, -876.8039, 43.4117, 99.9119, 0, 3, 120000, 1);
					//AddVehicleComponent(SAPDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned PEDAGANG Vehicles '"YELLOW_E"/despawnpg"WHITE_E"' to despawn vehicles");
			}/*
			case 2:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1131.5339, -1332.3248, 13.5797))
				{
					SAMDVeh[playerid] = CreateVehicle(563, 1162.8176, -1313.8239, 32.2215, 270.7216, 0, 1,120000, 0);
					//AddVehicleComponent(SAPDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned SAMD Vehicles '"YELLOW_E"/despawnmd"WHITE_E"' to despawn vehicles");
			}
			case 3:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1131.5339, -1332.3248, 13.5797))
				{
					SAMDVeh[playerid] = CreateVehicle(487, 1162.8176, -1313.8239, 32.2215, 270.7216,0,1,120000,0);
				}
				Info(playerid, "You have succefully spawned SAMD Vehicles '"YELLOW_E"/despawnmd"WHITE_E"' to despawn vehicles");
			}
			case 4:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1131.5339, -1332.3248, 13.5797))
				{
					SAMDVeh[playerid] = CreateVehicle(426, 1120.0265, -1317.1208, 13.8679, 271.4225,0,1,120000,0);
					AddVehicleComponent(SAMDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned SAMD Vehicles '"YELLOW_E"/despawnmd"WHITE_E"' to despawn vehicles");
			}*/
		}
		pData[playerid][pSpawnPg] = 1;
		PutPlayerInVehicle(playerid, PDGVeh[playerid], 0);
	}
    return 1;
}

/*CMD:callsign(playerid, params[])
{
    new vehicleid;
    vehicleid = GetPlayerVehicleID(playerid);
	new string[32];
	if(!IsPlayerInAnyVehicle(playerid))
		return Error(playerid, "You're not in a vehicle.");

	if (pData[playerid][pFaction] != 1 && pData[playerid][pFaction] != 3)
		return Error(playerid, "You must be a SAPD or SAMD!");

	if(vehiclecallsign[GetPlayerVehicleID(playerid)] == 1)
	{
 		Delete3DTextLabel(vehicle3Dtext[vehicleid]);
	    vehiclecallsign[vehicleid] = 0;
	    SendClientMessage(playerid, COLOR_RED, "CALLSIGN: {FFFFFF}Callsign removed.");
	    return 1;
	}
	if(sscanf(params, "s[32]",string))
		return SendSyntaxMessage(playerid, "/callsign [callsign]");

	if(vehiclecallsign[GetPlayerVehicleID(playerid)] == 0)
	{
		vehicle3Dtext[vehicleid] = Create3DTextLabel(string, COLOR_WHITE, 0.0, 0.0, 0.0, 10.0, 0, 1);
		Attach3DTextLabelToVehicle(vehicle3Dtext[vehicleid], vehicleid, 0.0, -2.8, 0.0);
		vehiclecallsign[vehicleid] = 1;
		SendClientMessage(playerid, COLOR_RED, "CALLSIGN: {FFFFFF}Type {FFFF00}/callsign {FFFFFF}again to remove.");
	}
	return 1;
}*/
