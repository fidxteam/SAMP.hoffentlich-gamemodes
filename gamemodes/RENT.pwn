//#include <YSI_Coding\y_hooks>

#define MAX_RENTAL 20

enum RentalVariabel
{
	Float:rentalPosX,
	Float:rentalPosY,
	Float:rentalPosZ,
	Float:rentalPosA,

	// Hooked by RentalRefresh
	rentalPickup,
	Text3D:rentalLabel,
};

new RentalData[MAX_RENTAL][RentalVariabel];
new Iterator:Rental<MAX_RENTAL>;

GetClosestRent(playerid, Float: range = 3.0)
{
	new id = -1, Float: dist = range, Float: tempdist;
	foreach(new i : Rental)
	{
	    tempdist = GetPlayerDistanceFromPoint(playerid, RentalData[i][rentalPosX], RentalData[i][rentalPosY], RentalData[i][rentalPosZ]);

	    if(tempdist > range) continue;
		if(tempdist <= dist)
		{
			dist = tempdist;
			id = i;
		}
	}
	return id;
}
CMD:editrental(playerid, params[])
{
    static
        did,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", did, type, string))
    {
        Usage(playerid, "/editrental [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location");
        return 1;
    }
    if((did < 0 || did > MAX_RENTAL))
        return Error(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Rental, did)) return Error(playerid, "The rent you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, RentalData[did][rentalPosX], RentalData[did][rentalPosY], RentalData[did][rentalPosZ]);
		GetPlayerFacingAngle(playerid, RentalData[did][rentalPosA]);
		DestroyDynamic3DTextLabel(RentalData[did][rentalLabel]);
    	DestroyDynamicPickup(RentalData[did][rentalPickup]);
		new tstr[218];
		format(tstr, sizeof(tstr), "[ID: %d]\n"WHITE_E"Rental Point\n"WHITE_E"Use "YELLOW_E"/rentveh\n"WHITE_E"to Rental vehicle", did);
		RentalData[did][rentalLabel] = CreateDynamic3DTextLabel(tstr, COLOR_RIKO, RentalData[did][rentalPosX], RentalData[did][rentalPosY], RentalData[did][rentalPosZ], 5.0);
    	RentalData[did][rentalPickup] = CreateDynamicPickup(1239, 23, RentalData[did][rentalPosX], RentalData[did][rentalPosY], RentalData[did][rentalPosZ]);
        RentalSave(did);
		RentalRefresh(did);

        SendAdminMessage(COLOR_RED, "%s Changes Location Rental ID: %d.", pData[playerid][pAdminname], did);
    }
    return 1;
}

CMD:createrental(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
	
	new query[512];
	new rentalid = Iter_Free(Rental);

	if(rentalid == -1)
		return Error(playerid, "You cant create more rental point");

	if((rentalid < 0 || rentalid >= MAX_RENTAL))
        return Error(playerid, "You have already input 15 rental point in this server.");


	GetPlayerPos(playerid, RentalData[rentalid][rentalPosX], RentalData[rentalid][rentalPosY], RentalData[rentalid][rentalPosZ]);
	GetPlayerFacingAngle(playerid, RentalData[rentalid][rentalPosA]);

	new tstr[218];
	format(tstr, sizeof(tstr), "[ID: %d]\n"WHITE_E"Rental Point\n"WHITE_E"Use "YELLOW_E"/rentveh\n"WHITE_E"to Rental vehicle", rentalid);
	RentalData[rentalid][rentalLabel] = CreateDynamic3DTextLabel(tstr, COLOR_RIKO, RentalData[rentalid][rentalPosX], RentalData[rentalid][rentalPosY], RentalData[rentalid][rentalPosZ], 5.0);
    RentalData[rentalid][rentalPickup] = CreateDynamicPickup(1239, 23, RentalData[rentalid][rentalPosX], RentalData[rentalid][rentalPosY], RentalData[rentalid][rentalPosZ]);

	Iter_Add(Rental, rentalid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO rental SET ID='%d', posx='%f', posy='%f', posz='%f', posa='%f'", rentalid, RentalData[rentalid][rentalPosX], RentalData[rentalid][rentalPosY], RentalData[rentalid][rentalPosZ], RentalData[rentalid][rentalPosA]);
	mysql_tquery(g_SQL, query, "OnRentalCreated", "i", rentalid);
	return 1;
}

CMD:deleterental(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

	new bid;

	if(sscanf(params, "d", bid))
		return Usage(playerid, "/deleterental [id]");

	if(bid < 0 || bid >= MAX_RENTAL)
        return Error(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Rental, bid))
		return Error(playerid, "The rental point you specified ID of doesn't exist.");

	RentalReset(bid);
		
	DestroyDynamic3DTextLabel(RentalData[bid][rentalLabel]);

    DestroyDynamicPickup(RentalData[bid][rentalPickup]);
		
	RentalData[bid][rentalPosX] = 0;
	RentalData[bid][rentalPosY] = 0;
	RentalData[bid][rentalPosZ] = 0;
	RentalData[bid][rentalPosA] = 0;
	RentalData[bid][rentalLabel] = Text3D:INVALID_3DTEXT_ID;
	RentalData[bid][rentalPickup] = -1;
		
	Iter_Remove(Rental, bid);
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM rental WHERE ID=%d", bid);
	mysql_tquery(g_SQL, query);
    SendAdminMessage(COLOR_RED, "%s has delete rental point ID: %d.", pData[playerid][pAdminname], bid);
    return 1;
}

CMD:gotorental(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

	new bid;

	if(sscanf(params, "d", bid))
		return Usage(playerid, "/gotorental [id]");

	if(bid < 0 || bid >= MAX_RENTAL)
        return Error(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Rental, bid))
		return Error(playerid, "The rental point you specified ID of doesn't exist.");

	SetPlayerPos(playerid, RentalData[bid][rentalPosX], RentalData[bid][rentalPosY], RentalData[bid][rentalPosZ]);
	SetPlayerFacingAngle(playerid, RentalData[bid][rentalPosA]);
		
    SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to rental point id %d", bid);
    return 1;
}

CMD:rentveh(playerid, params[])
{
	new rentalid;
	new id = -1;
	id = GetClosestRent(playerid);

	if(id > -1)
	{
	/*if(!IsPlayerInRangeOfPoint(playerid, 3.0, RentalData[rentalid][rentalPosX], RentalData[rentalid][rentalPosY], RentalData[rentalid][rentalPosZ])) return Error(playerid, "Anda harus berada di Rental Point!");
	{*/
		new str[1024];
	    format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t"LG_E"$50 / one days\n%s\t"LG_E"$50 / one days\n%s\t"LG_E"$50 / one days\n%s\t"LG_E"$50 / one days\n%s\t"LG_E"$50 / one days",
	    GetVehicleModelName(462),
		GetVehicleModelName(481),
		GetVehicleModelName(586),
		GetVehicleModelName(426),
		GetVehicleModelName(547)
		);

		ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLE, DIALOG_STYLE_LIST, "Rent Vehicle", str, "Rent", "Close");
	}
	return 1;
}

/* ============ [ Stock goes here ] ============ */

RentalSave(id)
{
	new cQuery[2248];
	format(cQuery, sizeof(cQuery), "UPDATE rental SET posx='%f', posy='%f', posz='%f', posa='%f' WHERE ID='%d'",
	RentalData[id][rentalPosX],
	RentalData[id][rentalPosY],
	RentalData[id][rentalPosZ],
	RentalData[id][rentalPosA],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}

RentalRefresh(id)
{
	if(id != -1)
	{		
		if(IsValidDynamic3DTextLabel(RentalData[id][rentalLabel]))
            DestroyDynamic3DTextLabel(RentalData[id][rentalLabel]);

        if(IsValidDynamicPickup(RentalData[id][rentalPickup]))
            DestroyDynamicPickup(RentalData[id][rentalPickup]);
		
		new tstr[218];
		format(tstr, sizeof(tstr), "[ID: %d]\n"WHITE_E"Rental Point\n"WHITE_E"Use "YELLOW_E"/rentveh\n"WHITE_E"to Rental vehicle", id);
		RentalData[id][rentalLabel] = CreateDynamic3DTextLabel(tstr, COLOR_RIKO, RentalData[id][rentalPosX], RentalData[id][rentalPosY], RentalData[id][rentalPosZ], 5.0);
        RentalData[id][rentalPickup] = CreateDynamicPickup(1239, 23, RentalData[id][rentalPosX], RentalData[id][rentalPosY], RentalData[id][rentalPosZ]);

		printf("DEBUG: RentalRefresh Called on Rental Point ID %d", id);
	}
}

RentalReset(id)
{
	DestroyDynamicPickup(RentalData[id][rentalPickup]);
	RentalRefresh(id);
}

GetRentalVehicleCost(carid)
{
	//RENT VEHICLE
    if(carid == 481) return 50;  //Bmx
	if(carid == 586) return 50; //Wayfare
	if(carid == 462) return 50; //Faggio
	if(carid == 426) return 50; //Premier
	if(carid == 547) return 50; //Primo
 	return -1;
}

IPRP::OnVehicleRentalRespawn(i)
{
	pvData[i][cVeh] = CreateVehicle(pvData[i][cModel], pvData[i][cPosX], pvData[i][cPosY], pvData[i][cPosZ], pvData[i][cPosA], pvData[i][cColor1], pvData[i][cColor2], 60000);
	SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
	SetVehicleVirtualWorld(pvData[i][cVeh], pvData[i][cVw]);
	LinkVehicleToInterior(pvData[i][cVeh], pvData[i][cInt]);
	SetVehicleFuel(pvData[i][cVeh], pvData[i][cFuel]);
	if(pvData[i][cHealth] < 350.0)
	{
		SetValidVehicleHealth(pvData[i][cVeh], 350.0);
	}
	else
	{
		SetValidVehicleHealth(pvData[i][cVeh], pvData[i][cHealth]);
	}
	UpdateVehicleDamageStatus(pvData[i][cVeh], pvData[i][cDamage0], pvData[i][cDamage1], pvData[i][cDamage2], pvData[i][cDamage3]);
	if(pvData[i][cVeh] != INVALID_VEHICLE_ID)
    {
        if(pvData[i][cPaintJob] != -1)
        {
            ChangeVehiclePaintjob(pvData[i][cVeh], pvData[i][cPaintJob]);
        }
		for(new z = 0; z < 17; z++)
		{
			if(pvData[i][cMod][z]) AddVehicleComponent(pvData[i][cVeh], pvData[i][cMod][z]);
		}
		if(pvData[i][cLocked] == 1)
		{
			SwitchVehicleDoors(pvData[i][cVeh], true);
		}
		else
		{
			SwitchVehicleDoors(pvData[i][cVeh], false);
		}
	}
	return 1;
}

IPRP::OnRentalCreated(rentalid)
{
	RentalRefresh(rentalid);
	RentalSave(rentalid);
	return 1;
}

IPRP::LoadRental()
{
    static bid;
	
	new rows = cache_num_rows();
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "ID", bid);
			cache_get_value_name_float(i, "posx", RentalData[bid][rentalPosX]);
			cache_get_value_name_float(i, "posy", RentalData[bid][rentalPosY]);
			cache_get_value_name_float(i, "posz", RentalData[bid][rentalPosZ]);
			cache_get_value_name_float(i, "posa", RentalData[bid][rentalPosA]);
			new tstr[218];
			format(tstr, sizeof(tstr), "[ID: %d]\n"WHITE_E"Rental Point\n"WHITE_E"Use "YELLOW_E"/rentveh\n"WHITE_E"to Rental vehicle", bid);
			RentalData[bid][rentalLabel] = CreateDynamic3DTextLabel(tstr, COLOR_RIKO, RentalData[bid][rentalPosX], RentalData[bid][rentalPosY], RentalData[bid][rentalPosZ], 5.0);
    		RentalData[bid][rentalPickup] = CreateDynamicPickup(1239, 23, RentalData[bid][rentalPosX], RentalData[bid][rentalPosY], RentalData[bid][rentalPosZ]);
			RentalRefresh(bid);
			Iter_Add(Rental, bid);
		}
		printf("[Dynamic Rental] Number of Loaded: %d.", rows);
	}
}


ptask PlayerRentalUpdate[1000](playerid)
{
	foreach(new vid : Rental)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, RentalData[vid][rentalPosX], RentalData[vid][rentalPosY], RentalData[vid][rentalPosZ]))
		{
			pData[playerid][pInRental] = vid;
			/*Info(playerid, "DEBUG MESSAGE: Kamu berada di dekat Dealer ID %d", vid);*/
		}
	}
	return 1;
}
