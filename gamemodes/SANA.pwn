CMD:despawnsana(playerid, params[])
{
	// Sana Vehicle
	if(IsPlayerInRangeOfPoint(playerid, 8.0, 743.5262, -1332.2343, 13.8414) || IsPlayerInRangeOfPoint(playerid, 8.0, 741.9764,-1371.2441,25.8835))
	{
		if(pData[playerid][pFaction] != 4)
	        return Error(playerid, "You must be at Sana officer faction!.");
	        
		new vehicleid = GetPlayerVehicleID(playerid);
        if(!IsEngineVehicle(vehicleid))
			return Error(playerid, "Kamu tidak berada didalam kendaraan.");

    	DestroyVehicle(SANAVeh[playerid]);
		pData[playerid][pSpawnSana] = 0;
    	GameTextForPlayer(playerid, "~w~SANA Vehicles ~r~Despawned", 3500, 3);
    }
    return 1;
}
CMD:spawnsana(playerid, params[])
{
    // Sana Vehicle
	if(IsPlayerInRangeOfPoint(playerid, 8.0, 743.5262, -1332.2343, 13.8414))
	{
		if(pData[playerid][pFaction] != 4)
	        return Error(playerid, "You must be at Sana officer faction!.");

		if(pData[playerid][pSpawnSana] == 1) return Error(playerid,"Anda sudah mengeluarkan 1 kendaraan.!");

	    new Zanv[10000], String[10000];
	    strcat(Zanv, "Vehicles Name\tType\n");
		format(String, sizeof(String), "Sanew\tCars\n");// 596
		strcat(Zanv, String);
		format(String, sizeof(String), "Sanew\tMotorcycle\n");// 597
		strcat(Zanv, String);
		format(String, sizeof(String), "Helicopter\tMotor Mabur\n");// 598
		strcat(Zanv, String);/*
		format(String, sizeof(String), "Helicopter 2\tCars\n"); // 599
		strcat(Zann, String);
		format(String, sizeof(String), "Premier\tSport Cars\n"); // 599
		strcat(Zann, String);*/
		ShowPlayerDialog(playerid,DIALOG_SANA_GARAGE, DIALOG_STYLE_TABLIST_HEADERS,"Static Vehicles San Andreas Agency", Zanv, "Spawn","Cancel");
	}
	return 1;
}

// STATISTIC VEHICLE SANA //
#include <YSI_Coding\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_SANA_GARAGE)
	{
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 743.5262, -1332.2343, 13.8414))
				{
					SANAVeh[playerid] = CreateVehicle(582, 751.3419,-1345.3467,13.8993,265.8653, 0, 1, 120000, 1);
					//AddVehicleComponent(SAPDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned SANA Vehicles '"YELLOW_E"/despawnsana"WHITE_E"' to despawn vehicles");
			}
			case 1:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 743.5262, -1332.2343, 13.8414))
				{
					SANAVeh[playerid] = CreateVehicle(586, 751.3419,-1345.3467,13.8993,265.8653, 0, 1, 120000, 1);
					//AddVehicleComponent(SAPDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned SANA Vehicles '"YELLOW_E"/despawnsana"WHITE_E"' to despawn vehicles");
			}
			case 2:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 743.5262, -1332.2343, 13.8414))
				{
					SANAVeh[playerid] = CreateVehicle(488, 741.9764, -1371.2441, 25.8835, 359.9998, 0, 1, 120000, 1);
					//AddVehicleComponent(SAPDVeh[playerid], 1098);
				}
				Info(playerid, "You have succefully spawned SANA Vehicles '"YELLOW_E"/despawnsana"WHITE_E"' to despawn vehicles");
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
		pData[playerid][pSpawnSana] = 1;
		PutPlayerInVehicle(playerid, SANAVeh[playerid], 0);
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
