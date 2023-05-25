#define MAX_GARAGE 100
#define GARAGE_NAME_SIZE 24

#define MAX_GARAGE 100
#define GARAGE_NAME_SIZE 24

enum garageData
{
	garageID,
	garageOwner,
	garagePrice,
	garageFee,
	garageName[GARAGE_NAME_SIZE],
	garageOwnerName[MAX_PLAYER_NAME],
	bool:garageExists,
	Float:garagePos[4],
	garageInterior,
	garageWorld,
	STREAMER_TAG_PICKUP:garagePickup,
	STREAMER_TAG_3D_TEXT_LABEL:garageText3D,
	//STREAMER_TAG_CP:garageCP,
	garageVault,
};

new GarageData[MAX_GARAGE][garageData];

stock Garage_Delete(garid)
{
	if (garid != -1 && GarageData[garid][garageExists])
	{
	    new
	        string[64];

		format(string, sizeof(string), "DELETE FROM `garage` WHERE `garageID` = '%d'", GarageData[garid][garageID]);
		mysql_tquery(g_SQL, string);

        if (IsValidDynamicPickup(GarageData[garid][garagePickup]))
	        DestroyDynamicPickup(GarageData[garid][garagePickup]);

	    if (IsValidDynamic3DTextLabel(GarageData[garid][garageText3D]))
	        DestroyDynamic3DTextLabel(GarageData[garid][garageText3D]);

/*		if(IsValidDynamicCP(GarageData[garid][garageCP]))
		    DestroyDynamicCP(GarageData[garid][garageCP]);*/

	    GarageData[garid][garageExists] = false;
	   	GarageData[garid][garageID] = 0;
	}
	return 1;
}

Garage_IsOwner(playerid, garid)
{
	if (pData[playerid][pID] == -1)
	    return 0;

    if ((GarageData[garid][garageExists] && GarageData[garid][garageOwner] != 0) && GarageData[garid][garageOwner] == pData[playerid][pID])
		return 1;

	return 0;
}

Garage_GetCount(playerid)
{
	new
		count;

	for (new i = 0; i != MAX_GARAGE; i ++)
	{
		if (GarageData[i][garageExists] && Garage_IsOwner(playerid, i))
   		{
   		    count++;
		}
	}
	return count;
}

Garage_Nearest(playerid)
{
    for (new i = 0; i != MAX_GARAGE; i ++) if (GarageData[i][garageExists] && IsPlayerInRangeOfPoint(playerid, 5.0, GarageData[i][garagePos][0], GarageData[i][garagePos][1], GarageData[i][garagePos][2]))
	{
		if (GetPlayerInterior(playerid) == GarageData[i][garageInterior] && GetPlayerVirtualWorld(playerid) == GarageData[i][garageWorld])
			return i;
	}
	return -1;
}

stock Garage_Refresh(garid)
{
	if (garid != -1 && GarageData[garid][garageExists])
	{
	    if (IsValidDynamicPickup(GarageData[garid][garagePickup]))
	        DestroyDynamicPickup(GarageData[garid][garagePickup]);

	    if (IsValidDynamic3DTextLabel(GarageData[garid][garageText3D]))
	        DestroyDynamic3DTextLabel(GarageData[garid][garageText3D]);

/*		if(IsValidDynamicCP(GarageData[garid][garageCP]))
		    DestroyDynamicCP(GarageData[garid][garageCP]);*/
		new
	        string[256];

		if(!GarageData[garid][garageOwner])
		{
		    format(string, sizeof(string), "[ID:%d]\n{FFFFFF}This Garage is For Sell\nPrice: {FF0000}%s\n{FFFFFF}Use {00FFFF}/buygarage {FFFFFF}To Purchase.", garid, FormatMoney(GarageData[garid][garagePrice]));
		}
		else
		{
			format(string, sizeof(string), "[ID:%d]\n{FFFFFF}%s\n{FFFFFF}Owner: %s\n{FFFFFF}Garage Fee: {FFFF00}$%d\n{FFFFFF}Use {FF0000}Press [Y]{FFFFFF} For Access.", garid, GarageData[garid][garageName], GarageData[garid][garageOwnerName], GarageData[garid][garageFee]);
		}
		//GarageData[garid][garageCP] = CreateDynamicCP(GarageData[garid][garagePos][0], GarageData[garid][garagePos][1], GarageData[garid][garagePos][2], 2.5, -1, -1, -1, 3.0);
		GarageData[garid][garagePickup] = CreateDynamicPickup(19134, 23, GarageData[garid][garagePos][0], GarageData[garid][garagePos][1], GarageData[garid][garagePos][2], GarageData[garid][garageWorld], GarageData[garid][garageInterior]);
       	GarageData[garid][garageText3D] = CreateDynamic3DTextLabel(string, COLOR_RED,  GarageData[garid][garagePos][0], GarageData[garid][garagePos][1], GarageData[garid][garagePos][2], 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0,  GarageData[garid][garageWorld], GarageData[garid][garageInterior]);
		return 1;
	}
	return 0;
}

stock Garage_Save(garid)
{
	new
	    query[512];

	format(query, sizeof(query), "UPDATE `garage` SET `garageX` = '%.4f', `garageY` = '%.4f', `garageZ` = '%.4f', `garageA` = '%.4f', `garageExterior` = '%d', `garageExteriorVW` = '%d', `garagePrice` = '%d', `garageFee` = '%d', `garageName` = '%s', `garageOwner` = '%d', `garageOwnerName` = '%s', `garageVault` = '%d' WHERE `garageID` = '%d'",
		GarageData[garid][garagePos][0],
		GarageData[garid][garagePos][1],
		GarageData[garid][garagePos][2],
		GarageData[garid][garagePos][3],
		GarageData[garid][garageInterior],
		GarageData[garid][garageWorld],
		GarageData[garid][garagePrice],
		GarageData[garid][garageFee],
		GarageData[garid][garageName],
		GarageData[garid][garageOwner],
		GarageData[garid][garageOwnerName],
		GarageData[garid][garageVault],
		GarageData[garid][garageID]
	);
	return mysql_tquery(g_SQL, query);
}

IPRP::Garage_Load()
{
	new rows = cache_num_rows();
 	if(rows)
  	{
    	for(new i; i < rows; i++)
		{
		    GarageData[i][garageExists] = true;
		    cache_get_value_name_int(i,"garageID",GarageData[i][garageID]);
		    cache_get_value_name_float(i,"garageX",GarageData[i][garagePos][0]);
		    cache_get_value_name_float(i,"garageY",GarageData[i][garagePos][1]);
		    cache_get_value_name_float(i,"garageZ",GarageData[i][garagePos][2]);
		    cache_get_value_name_float(i,"garageA",GarageData[i][garagePos][3]);

            cache_get_value_name_int(i,"garageExterior",GarageData[i][garageInterior]);
            cache_get_value_name_int(i,"garageExteriorVW",GarageData[i][garageWorld]);
            cache_get_value_name_int(i,"garagePrice",GarageData[i][garagePrice]);
            cache_get_value_name_int(i,"garageFee",GarageData[i][garageFee]);
            cache_get_value_name_int(i,"garageVault",GarageData[i][garageVault]);
            cache_get_value_name(i,"garageName",GarageData[i][garageName]);
            cache_get_value_name(i,"garageOwnerName",GarageData[i][garageOwnerName]);
            cache_get_value_name_int(i,"garageOwner",GarageData[i][garageOwner]);
			Garage_Refresh(i);
		}
		printf("[GARAGE] Loaded %d Garage's from the database.", rows);
	}
	return 1;
}

function OnGarageCreated(garid)
{
    if (garid == -1 || !GarageData[garid][garageExists])
		return 0;

	GarageData[garid][garageID] = cache_insert_id();
 	Garage_Save(garid);

	return 1;
}

stock ShowGarageLocation(playerid)
{
	new string[8000];
	format(string, sizeof(string), "Name\tFee\tDistance\tLocation\n");
	for (new i = 0; i < MAX_GARAGE; i ++) if (GarageData[i][garageExists])
	{
        format(string, sizeof(string), "%s%s\t{00FF00}%s\t{FFFFFF}%0.2f Meter\n", string, GarageData[i][garageName], FormatMoney(GarageData[i][garageFee]), GetPlayerDistanceFromPoint(playerid, GarageData[i][garagePos][0], GarageData[i][garagePos][1], GarageData[i][garagePos][2]), GetLocation(GarageData[i][garagePos][0], GarageData[i][garagePos][1], GarageData[i][garagePos][2]));
	}
	ShowPlayerDialog(playerid, DIALOG_TRACKPARK, DIALOG_STYLE_TABLIST_HEADERS, "Garage Location", string, "Select", "Cancel");
	return 1;
}

stock ShowGaragedVehicle(playerid)
{
	new bool:found = false, msg2[5120];
	format(msg2, sizeof(msg2), "Model\tPlate\n");
 	foreach(new i : PVehicles)
	{
	    if(pvData[i][cGaraged] == pData[playerid][pGarage])
	    {
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				format(msg2, sizeof(msg2), "%s%s\t%s\n", msg2, GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate]);
				found = true;
			}
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_GARAGETAKE, DIALOG_STYLE_TABLIST_HEADERS, "Garaged Vehicle", msg2, "Take", "Close");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Garaged Vehicle", "Tidak ada kendaraanmu di garage ini.", "Close", "");
	return 1;
}

stock SaveGarageVehicle(vid)
{
	new query[256];
	mysql_format(g_SQL, query, sizeof(query), "UPDATE `vehicle` SET `park` = '%d' WHERE `id` = '%d'", pvData[vid][cGaraged], pvData[vid][cID]);
	return mysql_tquery(g_SQL, query);
}

/* Related Commands */
CMD:buygarage(playerid, params[])
{
	static
		id = -1;

	if(pData[playerid][pID] == -1)
	    return Error(playerid, "Your database ID value is '-1', you must relogin first for doing any Transactions");

	if ((id = Garage_Nearest(playerid)) != -1)
	{
		if (Garage_GetCount(playerid) >= MAX_GARAGE)
			return Error(playerid, "You can only own %d Garage!", MAX_GARAGE);

		if (GarageData[id][garageOwner] != 0)
		    return Error(playerid, "This garage is already owned..");

		if (GarageData[id][garagePrice] > GetPlayerMoney(playerid))
		    return Error(playerid, "You don't have enough money!");

	    GarageData[id][garageOwner] = pData[playerid][pID];
		format(GarageData[id][garageOwnerName], 64, pData[playerid][pName]);

		Garage_Refresh(id);
		Garage_Save(id);

	    GivePlayerMoney(playerid, -GarageData[id][garagePrice]);
		SendClientMessageEx(playerid, COLOR_SERVER, "PROPERTY: {FFFFFF}You've successfully buy a Garage for {009000}%s", FormatMoney(GarageData[id][garagePrice]));
	}
	return 1;
}

CMD:garasi(playerid, params[])
{
	new
		id = -1;

	if ((id = Garage_Nearest(playerid)) != -1)
	{
	    ShowPlayerDialog(playerid, DIALOG_GARAGE, DIALOG_STYLE_LIST, "Garage Menu", "Store Vehicle\nTake Vehicle", "Select", "Cancel");
	    pData[playerid][pGarage] = id;
	}
	else
	    Error(playerid, "Kamu tidak berada dekat Garage manapun!");

	return 1;
}

CMD:mygarage(playerid, params[])
{
	new
	    id;

	if((id = Garage_Nearest(playerid)) != -1 && Garage_IsOwner(playerid, id))
	{
	    new str[312];
	    format(str, sizeof(str), "Withdraw all cash ({009000}%s{FFFFFF})\n{FFFFFF}Set Garage Name\nSet Garage Fee", FormatMoney(GarageData[id][garageVault]));
	    ShowPlayerDialog(playerid, DIALOG_GARAGEOWNER, DIALOG_STYLE_LIST, "Garage Access", str, "Select", "Cancel");
		pData[playerid][pGarage] = id;
	}
	return 1;
}

/* Related admin commands */
CMD:destroygarage(playerid, params[])
{
	static
	    id = 0;

    if (pData[playerid][pAdmin] < 6)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/destroygarage [garage id]");

	if ((id < 0 || id >= MAX_GARAGE) || !GarageData[id][garageExists])
	    return SendErrorMessage(playerid, "You have specified an invalid Garage ID.");

	Garage_Delete(id);
	SendServerMessage(playerid, "You have successfully destroyed Garage ID: %d.", id);
	return 1;
}

CMD:editgarage(playerid, params[])
{
	static
	    id,
	    type[2400],
	    string[1280];

	if (pData[playerid][pAdmin] < 6)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "ds[24]S()[128]", id, type, string))
 	{
	 	SendSyntaxMessage(playerid, "/editgarage [id] [name]");
	    SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, price");
		return 1;
	}
	if ((id < 0 || id >= MAX_GARAGE) || !GarageData[id][garageExists])
	    return SendErrorMessage(playerid, "You have specified an invalid Garage ID.");

	if (!strcmp(type, "location", true))
	{
		GetPlayerPos(playerid, GarageData[id][garagePos][0], GarageData[id][garagePos][1], GarageData[id][garagePos][2]);
		GetPlayerFacingAngle(playerid, GarageData[id][garagePos][3]);

		GarageData[id][garageInterior] = GetPlayerInterior(playerid);
		GarageData[id][garageWorld] = GetPlayerVirtualWorld(playerid);

		DestroyDynamicPickup(GarageData[id][garagePickup]);
		Garage_Refresh(id);
		Garage_Save(id);

		SendAdminMessage(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the location of Garage ID: %d.", pData[playerid][pAdminname], id);
	}
	else if (!strcmp(type, "price", true))
	{
	    new price;

	    if (sscanf(string, "d", price))
	        return SendSyntaxMessage(playerid, "/editgarage [id] [price] [new price]");

	    GarageData[id][garagePrice] = price;

		Garage_Refresh(id);
		Garage_Save(id);

		SendAdminMessage(COLOR_LIGHTRED, "[ADMIN]: %s has adjusted the price of Garage ID: %d to %s.",pData[playerid][pAdminname], id, FormatMoney(price));
	}
	else if(!strcmp(type, "owner", true))
    {
		new otherid;
        if(sscanf(string, "d", otherid))
            return Usage(playerid, "/editgarage [id] [owner] [playerid] (use '-1' to no owner/ reset)");
		if(otherid == -1)
			return format(GarageData[id][garageOwnerName], MAX_PLAYER_NAME, "-");

        GarageData[id][garageOwner] = pData[playerid][pID];
		format(GarageData[id][garageOwnerName], 64, pData[playerid][pName]);

		new query[1280];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE garage SET garageOwnerName='%s', garageOwner='%d' WHERE garageID='%d'", GarageData[id][garageOwnerName], GarageData[id][garageOwner], id);
		mysql_tquery(g_SQL, query);

		Garage_Save(id);
		Garage_Refresh(id);
        SendAdminMessage(COLOR_RED, "%s has adjusted the owner of garageID: %d to %s", pData[playerid][pAdminname], id, pData[otherid][pName]);
    }
	return 1;
}
CMD:creategarage(playerid, params[])
{
	static
	    price,
	    id;

    if (pData[playerid][pAdmin] < 5)
	    return Error(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", price))
	    return Usage(playerid, "/createpgarage [price]");

	id = Garage_Create(playerid, price);

	if (id == -1)
	    return Error(playerid, "You can't add more garage!");

	Servers(playerid, "You have successfully created Garage ID: %d.", id);
	return 1;
}

stock Garage_Create(playerid, price)
{
    new
	    Float:x,
	    Float:y,
	    Float:z,
	    Float:angle;

	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i < MAX_GARAGE; i ++) if (!GarageData[i][garageExists])
		{
			GarageData[i][garageExists] = true;
			format(GarageData[i][garageName], 32, "Unknown Garage");
			GarageData[i][garagePos][0] = x;
			GarageData[i][garagePos][1] = y;
			GarageData[i][garagePos][2] = z;
			GarageData[i][garagePos][3] = angle;
			GarageData[i][garagePrice] = price;
			GarageData[i][garageFee] = 5;
			GarageData[i][garageOwner] = 0;
			GarageData[i][garageVault] = 0;
			GarageData[i][garageInterior] = GetPlayerInterior(playerid);
			GarageData[i][garageWorld] = GetPlayerVirtualWorld(playerid);

			Garage_Refresh(i);
			mysql_tquery(g_SQL, "INSERT INTO `garage` (`garageExterior`) VALUES(0)", "OnGarageCreated", "d", i);

			return i;
		}
	}
	return -1;
}

CMD:asellgarage(playerid, params[])
{
	new id = -1;

    if (pData[playerid][pAdmin] < 6)
	    return SendErrorMessage(playerid, "You don't have permission to use this command.");

	if (sscanf(params, "d", id))
	    return SendSyntaxMessage(playerid, "/asellgarage [Garage ID]");

	if ((id < 0 || id >= MAX_GARAGE) || !GarageData[id][garageExists])
	    return SendErrorMessage(playerid, "You have specified an invalid Garage ID.");

	GarageData[id][garageOwner] = 0;

	Garage_Refresh(id);
	Garage_Save(id);

	SendServerMessage(playerid, "You have sold Garage ID: %d.", id);
	return 1;
}

CMD:garage(playerid, params[])
{
	new bool:found = false, str[512];
	format(str, sizeof(str), "Model\tGarage Name\tGarage ID\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cOwner] == pData[playerid][pID])
		{
			if(pvData[i][cGaraged] != -1)
			{
				format(str, sizeof(str), "%s%s\t%s\t%d\n", str, GetVehicleModelName(pvData[i][cModel]), GarageData[pvData[i][cGaraged]][garageName], pvData[i][cGaraged]);
				found = true;
			}
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Garaged Vehicle", str, "Close", "");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Garaged Vehicle", "Tidak ada kendaraan anda yang berada di Garage!", "Close", "");
}

