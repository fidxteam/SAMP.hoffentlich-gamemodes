CMD:despawnpd(playerid, params[])
{
	// Sapd Vehicle
	if(IsPlayerInRangeOfPoint(playerid, 8.0, 1260.391601, -1661.296752, 13.576869) || IsPlayerInRangeOfPoint(playerid, 8.0, 1569.1587,-1641.0361,28.5788)
	|| IsPlayerInRangeOfPoint(playerid, 8.0, 1260.391601, -1661.296752, 13.576869) || IsPlayerInRangeOfPoint(playerid, 8.0, 1569.1587,-1641.0361,28.5788))
	{
		if(pData[playerid][pFaction] != 1)
	        return Error(playerid, "You must be at police officer faction!.");
	        
		new vehicleid = GetPlayerVehicleID(playerid);
        if(!IsEngineVehicle(vehicleid))
			return Error(playerid, "Kamu tidak berada didalam kendaraan.");

    	DestroyVehicle(SAPDVeh[playerid]);
		pData[playerid][pSpawnSapd] = 0;
    	GameTextForPlayer(playerid, "~w~SAPD Vehicles ~r~Despawned", 3500, 3);
    }
    return 1;
}
CMD:spawnpd(playerid, params[])
{
    // Sapd Vehicle
	if(IsPlayerInRangeOfPoint(playerid, 8.0, 1260.391601, -1661.296752, 13.576869) || IsPlayerInRangeOfPoint(playerid, 8.0, 1569.1587,-1641.0361,28.5788)
	|| IsPlayerInRangeOfPoint(playerid, 8.0, 1260.391601, -1661.296752, 13.576869) || IsPlayerInRangeOfPoint(playerid, 8.0, 1569.1587,-1641.0361,28.5788))
	{
		if(pData[playerid][pFaction] != 1)
	        return Error(playerid, "You must be at police officer faction!.");

		if(pData[playerid][pSpawnSapd] == 1) return Error(playerid,"Anda sudah mengeluarkan 1 kendaraan.!");

	    new ZENN[10000], String[10000];
	    strcat(ZENN, "Vehicles Name\tType\n");
		format(String, sizeof(String), "Police Ls\tCars\n");// 596
		strcat(ZENN, String);
		format(String, sizeof(String), "Police Sf\tCars\n");// 597
		strcat(ZENN, String);
		format(String, sizeof(String), "Police Lv\tCars\n");// 598
		strcat(ZENN, String);
		format(String, sizeof(String), "Police Copcarru\tCars\n"); // 599
		strcat(ZENN, String);
		format(String, sizeof(String), "Police S.W.A.T\tCars\n"); // 601
		strcat(ZENN, String);
		format(String, sizeof(String), "Police Enforcer\tCars\n"); // 427
		strcat(ZENN, String);
		format(String, sizeof(String), "Police F.B.I Truck\tCars\n"); // 528
		strcat(ZENN, String);
		format(String, sizeof(String), "Police Infernus\tSport Cars\n"); // 411
		strcat(ZENN, String);
		format(String, sizeof(String), "Police Sultan\tUnique Cars\n"); // 560
		strcat(ZENN, String);
		format(String, sizeof(String), "Police Sanchez\tMotorcycle\n"); // 468
		strcat(ZENN, String);
		format(String, sizeof(String), "Police FCR-900\tMotorcycle\n");  // 521
		strcat(ZENN, String);
		format(String, sizeof(String), "Police HPV-1000\tMotorcycle\n");  // 523
		strcat(ZENN, String);
		format(String, sizeof(String), "Police NRG-500\tMotorcyle\n");// 596
		strcat(ZENN, String);
		format(String, sizeof(String), "Police TowTruck\tTruck\n");// 596
		strcat(ZENN, String);
		format(String, sizeof(String), "Police Maverick\tHelicopter\n"); // 497
		strcat(ZENN, String);
		ShowPlayerDialog(playerid,DIALOG_SAPD_GARAGE, DIALOG_STYLE_TABLIST_HEADERS,"Static Vehicles SA:PD", ZENN, "Spawn","Cancel");
	}
	return 1;
}

// STATISTIC VEHICLE SAPD //
#include <YSI_Coding\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_SAPD_GARAGE)
	{
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1260.391601, -1661.296752, 13.576869))
				{
					SAPDVeh[playerid] = CreateVehicle(596, 1262.82, -1661.20, 13.57, 254.72, 0, 1, 120000, 0);
					AddVehicleComponent(SAPDVeh[playerid], 1098);
					SetVehicleHealth ( SAPDVeh[playerid], 10000 ) ;
					AddVehicleComponent(SAPDVeh[playerid], 1010);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 1:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1260.391601, -1661.296752, 13.576869))
				{
					SAPDVeh[playerid] = CreateVehicle(597, 1262.82, -1661.20, 13.57, 254.72, 0, 1, 120000, 0);
					AddVehicleComponent(SAPDVeh[playerid], 1098);
					SetVehicleHealth ( SAPDVeh[playerid], 10000 ) ;
					AddVehicleComponent(SAPDVeh[playerid], 1010);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 2:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1260.391601, -1661.296752, 13.576869))
				{
					SAPDVeh[playerid] = CreateVehicle(598, 1262.82, -1661.20, 13.57, 254.72, 0, 1,120000, 0);
					AddVehicleComponent(SAPDVeh[playerid], 1098);
					SetVehicleHealth ( SAPDVeh[playerid], 10000 ) ;
					AddVehicleComponent(SAPDVeh[playerid], 1010);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 3:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1260.391601, -1661.296752, 13.576869))
				{
					SAPDVeh[playerid] = CreateVehicle(599, 1262.82, -1661.20, 13.57, 254.72,0,1,120000,0);
					SetVehicleHealth ( SAPDVeh[playerid], 10000 ) ;
					AddVehicleComponent(SAPDVeh[playerid], 1010);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 4:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1260.391601, -1661.296752, 13.576869))
				{
					SAPDVeh[playerid] = CreateVehicle(601, 1262.82, -1661.20, 13.57, 254.72,0,1,120000,0);
					SetVehicleHealth ( SAPDVeh[playerid], 10000 ) ;
					AddVehicleComponent(SAPDVeh[playerid], 1010);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 5:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1260.391601, -1661.296752, 13.576869))
				{
					SAPDVeh[playerid] = CreateVehicle(427, 1262.82, -1661.20, 13.57, 254.72,0,1,120000,0);
					SetVehicleHealth ( SAPDVeh[playerid], 10000 ) ;
					AddVehicleComponent(SAPDVeh[playerid], 1010);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 6:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1260.391601, -1661.296752, 13.576869))
				{
					SAPDVeh[playerid] = CreateVehicle(528, 1262.82, -1661.20, 13.57, 254.72,0,1,120000,0);
					SetVehicleHealth ( SAPDVeh[playerid], 10000 ) ;
					AddVehicleComponent(SAPDVeh[playerid], 1010);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 7:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1260.391601, -1661.296752, 13.576869))
				{
					SAPDVeh[playerid] = CreateVehicle(411, 1262.82, -1661.20, 13.57, 254.72,0,1,120000,0);
					AddVehicleComponent(SAPDVeh[playerid], 1098);
					SetVehicleHealth ( SAPDVeh[playerid], 10000 ) ;
					AddVehicleComponent(SAPDVeh[playerid], 1010);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 8:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1260.391601, -1661.296752, 13.576869))
				{
					SAPDVeh[playerid] = CreateVehicle(560, 1262.82, -1661.20, 13.57, 254.72,0,1,120000,0);
					AddVehicleComponent(SAPDVeh[playerid], 1029);
					AddVehicleComponent(SAPDVeh[playerid], 1030);
					AddVehicleComponent(SAPDVeh[playerid], 1031);
					AddVehicleComponent(SAPDVeh[playerid], 1033);
					AddVehicleComponent(SAPDVeh[playerid], 1139);
					AddVehicleComponent(SAPDVeh[playerid], 1140);
					AddVehicleComponent(SAPDVeh[playerid], 1170);
					SetVehicleHealth ( SAPDVeh[playerid], 10000 ) ;
					AddVehicleComponent(SAPDVeh[playerid], 1010);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 9:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1260.391601, -1661.296752, 13.576869))
				{
					SAPDVeh[playerid] = CreateVehicle(468, 1262.82, -1661.20, 13.57, 254.72,3,4,120000,0);
					SetVehicleHealth ( SAPDVeh[playerid], 10000 ) ;
					AddVehicleComponent(SAPDVeh[playerid], 1010);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 10:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1260.391601, -1661.296752, 13.576869))
				{
					SAPDVeh[playerid] = CreateVehicle(521, 1262.82, -1661.20, 13.57, 254.72,3,4,120000,0);
					SetVehicleHealth ( SAPDVeh[playerid], 10000 ) ;
					AddVehicleComponent(SAPDVeh[playerid], 1010);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 11:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1260.391601, -1661.296752, 13.576869))
				{
					SAPDVeh[playerid] = CreateVehicle(523, 1262.82, -1661.20, 13.57, 254.72,3,4,120000,0);
					SetVehicleHealth ( SAPDVeh[playerid], 10000 ) ;
					AddVehicleComponent(SAPDVeh[playerid], 1010);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 12:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1260.391601, -1661.296752, 13.576869))
				{
					SAPDVeh[playerid] = CreateVehicle(522, 1262.82, -1661.20, 13.57, 254.72,3,4,120000,0);
					SetVehicleHealth ( SAPDVeh[playerid], 10000 ) ;
					AddVehicleComponent(SAPDVeh[playerid], 1010);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 13:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1260.391601, -1661.296752, 13.576869))
				{
					SAPDVeh[playerid] = CreateVehicle(525, 1262.82, -1661.20, 13.57, 254.72,3,4,120000,0);
					SetVehicleHealth ( SAPDVeh[playerid], 10000 ) ;
					AddVehicleComponent(SAPDVeh[playerid], 1010);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
			case 14:
			{
				if(IsPlayerInRangeOfPoint(playerid,2.0, 1260.391601, -1661.296752, 13.576869))
				{
					SAPDVeh[playerid] = CreateVehicle(497, 1279.416381, -1643.896972, 42.478420, 258.82,3,4,120000,0);
					SetVehicleHealth ( SAPDVeh[playerid], 10000 );
					AddVehicleComponent(SAPDVeh[playerid], 1010);
				}
				Info(playerid, "You have succefully spawned SAPD Vehicles '"YELLOW_E"/despawnpd"WHITE_E"' to despawn vehicles");
			}
		}
		pData[playerid][pSpawnSapd] = 1;
		PutPlayerInVehicle(playerid, SAPDVeh[playerid], 0);
	}
    return 1;
}

CMD:callsign(playerid, params[])
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
}
