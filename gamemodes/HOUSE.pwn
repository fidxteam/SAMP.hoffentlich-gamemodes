//House System
#define MAX_HOUSES	1000
#define LIMIT_PER_PLAYER 3
#define Loop(%0,%1,%2) for(new %0 = %2; %0 < %1; %0++)

enum houseinfo
{
	hOwner[MAX_PLAYER_NAME],
	hOwnerID,
	hAddress[128],
	hPrice,
	hType,
	hLocked,
	hMoney,
	hWeapon[10],
	hAmmo[10],
	hRedMoney,//---
	hSnack,
	hSprunk,
	hMedicine,
	hMedkit,
	hBandage,
	hSeed,
	hMaterial,
	hMarijuana,
	hComponent, //---
	hInt,
	Float:hExtposX,
	Float:hExtposY,
	Float:hExtposZ,
	Float:hExtposA,
	Float:hIntposX,
	Float:hIntposY,
	Float:hIntposZ,
	Float:hIntposA,
	Float:hWeight,
	hVisit,
	//Not Saved
	STREAMER_TAG_PICKUP:hPickup,
	STREAMER_TAG_PICKUP:hPickup2,
	hMapIcon,
	STREAMER_TAG_CP:hCP,
	STREAMER_TAG_3D_TEXT_LABEL:hLabel
};

new hData[MAX_HOUSES][houseinfo],
	Iterator: Houses<MAX_HOUSES>;
	
Player_OwnsHouse(playerid, houseid)
{
	return (hData[houseid][hOwnerID] == pData[playerid][pID]) || (!strcmp(hData[houseid][hOwner], pData[playerid][pName], true));
}

Player_HouseCount(playerid)
{
	#if LIMIT_PER_PLAYER != 0
    new count;
	foreach(new i : Houses)
	{
		if(Player_OwnsHouse(playerid, i)) count++;
	}

	return count;
	#else
	return 0;
	#endif
}


HouseReset(houseid)
{
	format(hData[houseid][hOwner], MAX_PLAYER_NAME, "-");
	hData[houseid][hOwnerID] = 0;
	hData[houseid][hLocked] = 1;
    hData[houseid][hMoney] = 0;
    hData[houseid][hRedMoney] = 0;
	hData[houseid][hSnack] = 0;
	hData[houseid][hSprunk] = 0;
	hData[houseid][hMedicine] = 0;
	hData[houseid][hMedkit] = 0;
	hData[houseid][hBandage] = 0;
	hData[houseid][hSeed] = 0;
	hData[houseid][hMaterial] = 0;
	hData[houseid][hMarijuana] = 0;
	hData[houseid][hComponent] = 0;
	hData[houseid][hWeapon] = 0;
	hData[houseid][hAmmo] = 0;
	hData[houseid][hVisit] = 0;
	House_Type(houseid);
	
	for (new i = 0; i < 10; i ++)
    {
        hData[houseid][hWeapon][i] = 0;

		hData[houseid][hAmmo][i] = 0;
    }
}
	
/*GetHouseOwnerID(houseid)
{
	foreach(new i : Player)
	{
		if(!strcmp(hData[houseid][hOwner], pData[i][pName], true)) return i;
	}
	return INVALID_PLAYER_ID;
}*/

House_WeaponStorage(playerid, houseid)
{
    if(houseid == -1)
        return 0;

    static
        string[320];

    string[0] = 0;

    for (new i = 0; i < 5; i ++)
    {
        if(!hData[houseid][hWeapon][i])
            format(string, sizeof(string), "%sEmpty Slot\n", string);

        else
            format(string, sizeof(string), "%s%s (Ammo: %d)\n", string, ReturnWeaponName(hData[houseid][hWeapon][i]), hData[houseid][hAmmo][i]);
    }
    ShowPlayerDialog(playerid, HOUSE_WEAPONS, DIALOG_STYLE_LIST, "Weapon Storage", string, "Select", "Cancel");
    return 1;
}

Gudang_OpenStorage(playerid)
{

    new
        items[1],
        string[10 * 32];

        format(string, sizeof(string), "Weapon Storage\nMoney Safe\nFood & Drink\nDrugs\nOther");

    ShowPlayerDialog(playerid, GUDANG_STORAGE, DIALOG_STYLE_LIST, "House Storage", string, "Select", "Cancel");
    return 1;
}

Gudang_WeaponStorage(playerid)
{

    static
        string[320];


            format(string, sizeof(string), "%s (Ammo: %d)\n%s (Ammo: %d)\n%s (Ammo: %d)\n%s (Ammo: %d)", ReturnWeaponName(pData[playerid][pGudanggun1]), pData[playerid][pGudangamo1], ReturnWeaponName(pData[playerid][pGudanggun2]), pData[playerid][pGudangamo2], ReturnWeaponName(pData[playerid][pGudanggun3]), pData[playerid][pGudangamo3], ReturnWeaponName(pData[playerid][pGudanggun4]), pData[playerid][pGudangamo4]);
    ShowPlayerDialog(playerid, GUDANG_WEAPONS, DIALOG_STYLE_LIST, "Weapon Storage", string, "Select", "Cancel");
    return 1;
}
House_OpenStorage(playerid, houseid)
{
    if(houseid == -1)
        return 0;

    new
        items[1],
        string[10 * 32];

    for (new i = 0; i < 5; i ++) if(hData[houseid][hWeapon][i]) 
	{
        items[0]++;
    }
    if(!Player_OwnsHouse(playerid, houseid))
        format(string, sizeof(string), "Weapon Storage (%d/5)", items[0]);

    else
        format(string, sizeof(string), "Weapon Storage (%d/5)\nMoney Safe\nFood & Drink\nDrugs\nOther", items[0]);

    ShowPlayerDialog(playerid, HOUSE_STORAGE, DIALOG_STYLE_LIST, "House Storage", string, "Select", "Cancel");
    return 1;
}

GetOwnedHouses(playerid)
{
	new tmpcount;
	foreach(new hid : Houses)
	{
	    if(!strcmp(hData[hid][hOwner], pData[playerid][pName], true) || (hData[hid][hOwnerID] == pData[playerid][pID]))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}
ReturnPlayerHousesID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;
	foreach(new hid : Houses)
	{
	    if(!strcmp(pData[playerid][pName], hData[hid][hOwner], true) || (hData[hid][hOwnerID] == pData[playerid][pID]))
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return hid;
  			}
	    }
	}
	return -1;
}

House_Save(houseid)
{
	new cQuery[1536];
	format(cQuery, sizeof(cQuery), "UPDATE houses SET owner='%s', ownerid='%d', address='%s', price='%d', type='%d', locked='%d', money='%d'",
	hData[houseid][hOwner],
	hData[houseid][hOwnerID],
	hData[houseid][hAddress],
	hData[houseid][hPrice],
	hData[houseid][hType],
	hData[houseid][hLocked],
	hData[houseid][hMoney]
	);
	
	for (new i = 0; i < 10; i ++) 
	{
        format(cQuery, sizeof(cQuery), "%s, houseWeapon%d='%d', houseAmmo%d='%d'", cQuery, i + 1, hData[houseid][hWeapon][i], i + 1, hData[houseid][hAmmo][i]);
    }
	
	format(cQuery, sizeof(cQuery), "%s, houseint='%d', extposx='%f', extposy='%f', extposz='%f', extposa='%f', intposx='%f', intposy='%f', intposz='%f', intposa='%f', visit='%d', redmoney='%d', snack='%d', sprunk='%d', medicine='%d', medkit='%d', bandage='%d', seed='%d', material='%d', marijuana='%d', component='%d' WHERE ID='%d'",

        cQuery,
        hData[houseid][hInt],
        hData[houseid][hExtposX],
        hData[houseid][hExtposY],
		hData[houseid][hExtposZ],
		hData[houseid][hExtposA],
		hData[houseid][hIntposX],
		hData[houseid][hIntposY],
		hData[houseid][hIntposZ],
		hData[houseid][hIntposA],
		hData[houseid][hVisit],
		hData[houseid][hRedMoney],
		hData[houseid][hSnack],
		hData[houseid][hSprunk],
		hData[houseid][hMedicine],
		hData[houseid][hMedkit],
		hData[houseid][hBandage],
		hData[houseid][hSeed],
		hData[houseid][hMaterial],
		hData[houseid][hMarijuana],
		hData[houseid][hComponent],
        houseid
    );
	return mysql_tquery(g_SQL, cQuery);
}

House_Type(houseid)
{
	if(hData[houseid][hType] == 1)
	{
	    switch(random(3))
		{
			/*case 0:
			{
				hData[houseid][hIntposX] = 845.89;
				hData[houseid][hIntposY] = -2048.00;
				hData[houseid][hIntposZ] = 1476.91;
				hData[houseid][hIntposA] = 92.60;
				hData[houseid][hInt] = 1;
			}
			case 1:
			{
				hData[houseid][hIntposX] = 337.61;
				hData[houseid][hIntposY] = 1854.10;
				hData[houseid][hIntposZ] = 1002.08;
				hData[houseid][hIntposA] = 265.14;
				hData[houseid][hInt] = 1;
			}
			case 2:
			{
				hData[houseid][hIntposX] = 338.29;
				hData[houseid][hIntposY] = 1794.87;
				hData[houseid][hIntposZ] = 1002.17;
				hData[houseid][hIntposA] = 269.09;
				hData[houseid][hInt] = 1;
			}*/
			case 0:
			{
				hData[houseid][hIntposX] = -2169.9414;
				hData[houseid][hIntposY] = -2135.5444;
				hData[houseid][hIntposZ] = 1501.1005;
				hData[houseid][hIntposA] = 355.0665;
				hData[houseid][hInt] = 1;
			}
			case 1:
			{
				hData[houseid][hIntposX] = -1562.0221;
				hData[houseid][hIntposY] = -253.1878;
				hData[houseid][hIntposZ] = 1501.0166;
				hData[houseid][hIntposA] = 99.1287;
				hData[houseid][hInt] = 1;
			}
			case 2:
			{
				hData[houseid][hIntposX] = 2206.9346;
				hData[houseid][hIntposY] = -402.6815;
				hData[houseid][hIntposZ] = 1502.0081;
				hData[houseid][hIntposA] = 187.1214;
				hData[houseid][hInt] = 1;
			}
			/*case 3:
			{
				hData[houseid][hIntposX] = 260.82;
				hData[houseid][hIntposY] = 1237.48;
				hData[houseid][hIntposZ] = 1084.25;
				hData[houseid][hIntposA] = 9.24;
				hData[houseid][hInt] = 9;
			}
			case 4:
			{
				hData[houseid][hIntposX] = 22.90;
				hData[houseid][hIntposY] = 1403.32;
				hData[houseid][hIntposZ] = 1084.43;
				hData[houseid][hIntposA] = 0.24;
				hData[houseid][hInt] = 5;
			}
			case 5:
			{
				hData[houseid][hIntposX] = 226.17;
				hData[houseid][hIntposY] = 1239.99;
				hData[houseid][hIntposZ] = 1082.14;
				hData[houseid][hIntposA] = 84.87;
				hData[houseid][hInt] = 2;
			}*/
		}
	}
	if(hData[houseid][hType] == 2)
	{
	    switch(random(5))
		{
			/*case 0:
			{
				hData[houseid][hIntposX] = 736.03;
				hData[houseid][hIntposY] = 1672.08;
				hData[houseid][hIntposZ] = 501.08;
				hData[houseid][hIntposA] = 356.23;
				hData[houseid][hInt] = 1;
			}
			case 1:
			{
				hData[houseid][hIntposX] = 338.78;
				hData[houseid][hIntposY] = 1734.95;
				hData[houseid][hIntposZ] = 1002.08;
				hData[houseid][hIntposA] = 268.46;
				hData[houseid][hInt] = 1;
			}
			case 2:
			{
				hData[houseid][hIntposX] = 351.59;
				hData[houseid][hIntposY] = 1669.31;
				hData[houseid][hIntposZ] = 1002.17;
				hData[houseid][hIntposA] = 176.03;
				hData[houseid][hInt] = 1;
			}*/
			case 0:
			{
				hData[houseid][hIntposX] = -1412.7211;
				hData[houseid][hIntposY] = -232.9857;
				hData[houseid][hIntposZ] = 1501.0168;
				hData[houseid][hIntposA] = 4.4778;
				hData[houseid][hInt] = 1;
			}
			case 1:
			{
				hData[houseid][hIntposX] = 2180.8127;
				hData[houseid][hIntposY] = -567.4024;
				hData[houseid][hIntposZ] = 1502.0050;
				hData[houseid][hIntposA] = 179.2413;
				hData[houseid][hInt] = 1;
			}
			case 2:
			{
				hData[houseid][hIntposX] = 2195.6079;
				hData[houseid][hIntposY] = -738.6234;
				hData[houseid][hIntposZ] = 1502.0032;
				hData[houseid][hIntposA] = 90.5592;
				hData[houseid][hInt] = 1;
			}
			case 3:
			{
				hData[houseid][hIntposX] = -1498.7766;
				hData[houseid][hIntposY] = -1824.8872;
				hData[houseid][hIntposZ] = 1501.0964;
				hData[houseid][hIntposA] = 95.5258;
				hData[houseid][hInt] = 1;
			}
			case 4:
			{
				hData[houseid][hIntposX] = -675.0117;
				hData[houseid][hIntposY] = -2166.2661;
				hData[houseid][hIntposZ] = 1501.0964;
				hData[houseid][hIntposA] = 183.5265;
				hData[houseid][hInt] = 1;
			}
		}
	}
	if(hData[houseid][hType] == 3)
	{
	    switch(random(2))
		{
			/*case 0:
			{
				hData[houseid][hIntposX] = 1855.38;
				hData[houseid][hIntposY] = -1709.12;
				hData[houseid][hIntposZ] = 1720.06;
				hData[houseid][hIntposA] = 273.58;
				hData[houseid][hInt] = 1;
			}
			case 1:
			{
				hData[houseid][hIntposX] = 4577.82;
				hData[houseid][hIntposY] = -2527.82;
				hData[houseid][hIntposZ] = 5.28;
				hData[houseid][hIntposA] = 262.63;
				hData[houseid][hInt] = 1;
			}
			case 2:
			{
				hData[houseid][hIntposX] = 1263.68;
				hData[houseid][hIntposY] = -605.30;
				hData[houseid][hIntposZ] = 1001.08;
				hData[houseid][hIntposA] = 189.50;
				hData[houseid][hInt] = 1;
			}
			case 3:
			{
				hData[houseid][hIntposX] = 1224.34;
				hData[houseid][hIntposY] = -749.22;
				hData[houseid][hIntposZ] = 1085.72;
				hData[houseid][hIntposA] = 265.59;
				hData[houseid][hInt] = 1;
			}*/
			case 0:
			{
				hData[houseid][hIntposX] = -1036.6294;
				hData[houseid][hIntposY] = -2205.9368;
				hData[houseid][hIntposZ] = 1501.0859;
				hData[houseid][hIntposA] = 358.7049;
				hData[houseid][hInt] = 1;
			}
			case 1:
			{
				hData[houseid][hIntposX] = -407.2897;
				hData[houseid][hIntposY] = -2086.1821;
				hData[houseid][hIntposZ] = 1501.0964;
				hData[houseid][hIntposA] = 1.5718;
				hData[houseid][hInt] = 1;
			}
			/*case 2:
			{
				hData[houseid][hIntposX] = 139.83;
				hData[houseid][hIntposY] = 1366.16;
				hData[houseid][hIntposZ] = 1083.85;
				hData[houseid][hIntposA] = 354.86;
				hData[houseid][hInt] = 5;
			}
			case 3:
			{
				hData[houseid][hIntposX] = 234.04;
				hData[houseid][hIntposY] = 1063.92;
				hData[houseid][hIntposZ] = 1084.21;
				hData[houseid][hIntposA] = 351.12;
				hData[houseid][hInt] = 6;
			}*/
		}
	}
	if(hData[houseid][hType] == 4)
	{
	    switch(random(2))
		{
			case 0:
			{
				hData[houseid][hIntposX] = 266.49;
				hData[houseid][hIntposY] = 305.02;
				hData[houseid][hIntposZ] = 999.14;
				hData[houseid][hIntposA] = 272.65;
				hData[houseid][hInt] = 2;
			}
			case 1:
			{
				hData[houseid][hIntposX] = 266.49;
				hData[houseid][hIntposY] = 305.02;
				hData[houseid][hIntposZ] = 999.14;
				hData[houseid][hIntposA] = 272.65;
				hData[houseid][hInt] = 2;
			}
		}
	}	

	new query[374];
	mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET intposx='%f', intposy='%f', intposz='%f', intposa='%f', houseint='%d' WHERE ID='%d'", hData[houseid][hIntposX], hData[houseid][hIntposY], hData[houseid][hIntposZ], hData[houseid][hIntposA], hData[houseid][hInt], houseid);
	mysql_tquery(g_SQL, query);
}

House_Refresh(houseid)
{
    if(houseid != -1)
    {
        if(IsValidDynamic3DTextLabel(hData[houseid][hLabel]))
            DestroyDynamic3DTextLabel(hData[houseid][hLabel]);

        if(IsValidDynamicPickup(hData[houseid][hPickup]))
            DestroyDynamicPickup(hData[houseid][hPickup]);

		if(IsValidDynamicPickup(hData[houseid][hPickup2]))
            DestroyDynamicPickup(hData[houseid][hPickup2]);

		if(IsValidDynamicMapIcon(hData[houseid][hMapIcon]))
			DestroyDynamicMapIcon(hData[houseid][hMapIcon]);
			
		if(IsValidDynamicCP(hData[houseid][hCP]))
            DestroyDynamicCP(hData[houseid][hCP]);

        static
        string[255];
		
		new type[128];
		if(hData[houseid][hType] == 1)
		{
			type= "Small";
		}
		else if(hData[houseid][hType] == 2)
		{
			type= "Medium";
		}
		else if(hData[houseid][hType] == 3)
		{
			type= "Large";
		}
		else if(hData[houseid][hType] == 4)
		{
			type= "Very Small";
		}
		else
		{
			type= "Unknown";
		}

        if(strcmp(hData[houseid][hOwner], "-") || hData[houseid][hOwnerID] != 0)
		{
			format(string, sizeof(string), "[ID: %d]\n{FFFFFF}House Location {FFFF00}%s\n{FFFFFF}House Type {FFFF00}%s\n"WHITE_E"Owned by %s\nPress '{FF0000}ENTER{FFFFFF}' to enter", houseid, GetLocation(hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]), type, hData[houseid][hOwner]);
			hData[houseid][hPickup] = CreateDynamicPickup(19522, 23, hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]+0.2, 0, 0, _, 50.0);
			hData[houseid][hPickup2] = CreateDynamicPickup(19130, 23, hData[houseid][hIntposX], hData[houseid][hIntposY], hData[houseid][hIntposZ]+0.2, houseid, hData[houseid][hInt], _, 50.0);
			hData[houseid][hMapIcon] = CreateDynamicMapIcon(hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ], 32, 1, -1, -1, -1, 45.0);
		}
        else
        {
            format(string, sizeof(string), "[ID: %d]\n{00FF00}This house for sell\n{FFFFFF}House Location: {FFFF00}%s\n{FFFFFF}House Type: {FFFF00}%s\n{FFFFFF}House Price: {FFFF00}%s\n"WHITE_E"Type /buyhouse to purchase", houseid, GetLocation(hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]), type, FormatMoney(hData[houseid][hPrice]));
            hData[houseid][hPickup] = CreateDynamicPickup(19524, 23, hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]+0.2, 0, 0, _, 50.0);
			hData[houseid][hPickup2] = CreateDynamicPickup(19130, 23, hData[houseid][hIntposX], hData[houseid][hIntposY], hData[houseid][hIntposZ]+0.2, houseid, hData[houseid][hInt], _, 50.0);
			hData[houseid][hMapIcon] = CreateDynamicMapIcon(hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ], 31, 1, -1, -1, -1, 45.0);
		}
		//hData[houseid][hCP] = CreateDynamicCP(hData[houseid][hIntposX], hData[houseid][hIntposY], hData[houseid][hIntposZ], 1.0, houseid, hData[houseid][hInt], -1, 3.0);
        hData[houseid][hLabel] = CreateDynamic3DTextLabel(string, COLOR_GREEN, hData[houseid][hExtposX], hData[houseid][hExtposY], hData[houseid][hExtposZ]+0.5, 5.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
    }
    return 1;
}

IPRP::LoadHouses()
{
    static
        str[128],
		hid;
		
	new rows = cache_num_rows(), owner[128], address[128];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "ID", hid);
			cache_get_value_name(i, "owner", owner);
			format(hData[hid][hOwner], 128, owner);
			cache_get_value_name_int(i, "ownerid", hData[hid][hOwnerID]);
			cache_get_value_name(i, "address", address);
			format(hData[hid][hAddress], 128, address);
			cache_get_value_name_int(i, "price", hData[hid][hPrice]);
			cache_get_value_name_int(i, "type", hData[hid][hType]);
			cache_get_value_name_float(i, "extposx", hData[hid][hExtposX]);
			cache_get_value_name_float(i, "extposy", hData[hid][hExtposY]);
			cache_get_value_name_float(i, "extposz", hData[hid][hExtposZ]);
			cache_get_value_name_float(i, "extposa", hData[hid][hExtposA]);
			cache_get_value_name_float(i, "intposx", hData[hid][hIntposX]);
			cache_get_value_name_float(i, "intposy", hData[hid][hIntposY]);
			cache_get_value_name_float(i, "intposz", hData[hid][hIntposZ]);
			cache_get_value_name_float(i, "intposa", hData[hid][hIntposA]);
			cache_get_value_name_int(i, "houseint", hData[hid][hInt]);
			cache_get_value_name_int(i, "money", hData[hid][hMoney]);
			cache_get_value_name_int(i, "locked", hData[hid][hLocked]);
			cache_get_value_name_int(i, "visit", hData[hid][hVisit]);
			cache_get_value_name_int(i, "redmoney", hData[hid][hRedMoney]);
			cache_get_value_name_int(i, "snack", hData[hid][hSnack]);
			cache_get_value_name_int(i, "sprunk", hData[hid][hSprunk]);
			cache_get_value_name_int(i, "medicine", hData[hid][hMedicine]);
			cache_get_value_name_int(i, "medkit", hData[hid][hMedkit]);
			cache_get_value_name_int(i, "bandage", hData[hid][hBandage]);
			cache_get_value_name_int(i, "seed", hData[hid][hSeed]);
			cache_get_value_name_int(i, "material", hData[hid][hMaterial]);
			cache_get_value_name_int(i, "marijuana", hData[hid][hMarijuana]);
			cache_get_value_name_int(i, "component", hData[hid][hComponent]);

			for (new j = 0; j < 10; j ++)
			{
				format(str, 24, "houseWeapon%d", j + 1);
				cache_get_value_name_int(i, str, hData[hid][hWeapon][j]);

				format(str, 24, "houseAmmo%d", j + 1);
				cache_get_value_name_int(i, str, hData[hid][hAmmo][j]);
			}
			House_Refresh(hid);
			Iter_Add(Houses, hid);
		}
		printf("[Houses]: %d Loaded.", rows);
	}
}

GetHouseStorage(houseid, item)
{
	static const StorageLimit[][] = {
	   //Snack  Sprunk  Medicine  Medkit  Bandage  Seed  Material  Component  Marijuana
	    {30,    30,     25,  	  5,  	  10,  	   250,  250,  	   250, 	 100},// Small
		{50,    50,     35,  	  15,  	  25,  	   300,  300,  	   300, 	 200},// Medium
		{75,    75,     50,  	  30,  	  50,  	   450,  450,  	   450, 	 300},// Large
		{20,    20,     15,  	  3,  	  5,  	   150,  150,  	   150, 	 50}// Very Small
	};

	return StorageLimit[hData[houseid][hType] - 1][item];
}

//----------[ House Commands ]--------
//House System
CMD:createhouse(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);
	
	new hid = Iter_Free(Houses), address[128];
	if(hid == -1) return ErrorMsg(playerid, "You cant create more door!");
	new price, type, query[512];
	if(sscanf(params, "dd", price, type)) return Usage(playerid, "/createhouse [price] [type, 1.small 2.medium 3.Big 4. V Small]");
	format(hData[hid][hOwner], 128, "-");
	hData[hid][hOwnerID] = 0;
	GetPlayerPos(playerid, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]);
	GetPlayerFacingAngle(playerid, hData[hid][hExtposA]);
	hData[hid][hPrice] = price;
	hData[hid][hType] = type;
	address = GetLocation(hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]);
	format(hData[hid][hAddress], 128, address);
	hData[hid][hLocked] = 1;
	hData[hid][hMoney] = 0;
	hData[hid][hRedMoney] = 0;
	hData[hid][hVisit] = 0;
	
	for (new i = 0; i < 10; i ++) 
	{
        hData[hid][hWeapon][i] = 0;
        hData[hid][hAmmo][i] = 0;
    }

	Iter_Add(Houses, hid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO houses SET ID='%d', owner='%s', ownerid='%d', price='%d', type='%d', extposx='%f', extposy='%f', extposz='%f', extposa='%f', address='%s'", hid, hData[hid][hOwner], hData[hid][hOwnerID], hData[hid][hPrice], hData[hid][hType], hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ], hData[hid][hExtposA], hData[hid][hAddress]);
	mysql_tquery(g_SQL, query, "OnHousesCreated", "ii", playerid, hid);
	return 1;
}

function OnHousesCreated(playerid, hid)
{
	House_Type(hid);
    House_Refresh(hid);
	Servers(playerid, "House [%d] berhasil di buat!", hid);
	new str[150];
	format(str,sizeof(str),"[House]: %s membuat house id %d!", GetRPName(playerid), hid);
	LogServer("Admin", str);
	return 1;
}

CMD:gotohouse(playerid, params[])
{
	new hid;
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);
		
	if(sscanf(params, "d", hid))
		return Usage(playerid, "/gotohouse [id]");
	if(!Iter_Contains(Houses, hid)) return ErrorMsg(playerid, "The doors you specified ID of doesn't exist.");
	SetPlayerPosition(playerid, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ], hData[hid][hExtposA]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
	SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to house id %d", hid);
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInFamily] = -1;
	return 1;
}

CMD:typehouses(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);
	
	new count = 0;
	foreach(new hid : Houses)
	{
		if(hData[hid][hType] == 1)
		{
			House_Type(hid);
			House_Refresh(hid);
			House_Save(hid);
		}
		if(hData[hid][hType] == 2)
		{
			House_Type(hid);
			House_Refresh(hid);
			House_Save(hid);
		}
		if(hData[hid][hType] == 3)
		{
			House_Type(hid);
			House_Refresh(hid);
			House_Save(hid);
		}
		if(hData[hid][hType] == 4)
		{
			House_Type(hid);
			House_Refresh(hid);
			House_Save(hid);
		}
		count++;
	}
	Servers(playerid, "Anda telah me reset house interior type sebanyak %d rumah.", count);
	return 1;
}

CMD:edithouse(playerid, params[])
{
    static
        hid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pServerModerator] < 1)
			return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", hid, type, string))
    {
        Usage(playerid, "/edithouse [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, interior, locked, owner, ownerid, price, type, reset, delete");
        return 1;
    }
    if((hid < 0 || hid >= MAX_HOUSES))
        return ErrorMsg(playerid, "You have specified an invalid ID.");
	if(!Iter_Contains(Houses, hid)) return ErrorMsg(playerid, "The doors you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]);
		GetPlayerFacingAngle(playerid, hData[hid][hExtposA]);

		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET extposx='%f', extposy='%f', extposx='%f', extposx='%f' WHERE ID='%d'", hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ], hData[hid][hExtposA], hid);
		mysql_tquery(g_SQL, query);

		House_Refresh(hid);

        SendAdminMessage(COLOR_LRED, "%s has adjusted the location of house ID: %d.", pData[playerid][pAdminname], hid);
    }
    else if(!strcmp(type, "interior", true))
    {
        GetPlayerPos(playerid, hData[hid][hIntposX], hData[hid][hIntposY], hData[hid][hIntposZ]);
		GetPlayerFacingAngle(playerid, hData[hid][hIntposA]);
		hData[hid][hInt] = GetPlayerInterior(playerid);

		new query[300];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET intposx='%f', intposy='%f', intposz='%f', intposa='%f', houseint='%d' WHERE ID='%d'", hData[hid][hIntposX], hData[hid][hIntposY], hData[hid][hIntposZ], hData[hid][hIntposA], hData[hid][hInt], hid);
		mysql_tquery(g_SQL, query);

		House_Refresh(hid);

       /*foreach (new i : Player)
        {
            if(pData[i][pEntrance] == EntranceData[id][entranceID])
            {
                SetPlayerPos(i, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);
                SetPlayerFacingAngle(i, EntranceData[id][entranceInt][3]);

                SetPlayerInterior(i, EntranceData[id][entranceInterior]);
                SetCameraBehindPlayer(i);
            }
        }*/
        SendAdminMessage(COLOR_RED, "%s has adjusted the interior spawn of house ID: %d.", pData[playerid][pAdminname], hid);
    }
    else if(!strcmp(type, "locked", true))
    {
        new locked;

        if(sscanf(string, "d", locked))
            return Usage(playerid, "/edithouse [id] [locked] [0/1]");

        if(locked < 0 || locked > 1)
            return ErrorMsg(playerid, "You must specify at least 0 or 1.");

        hData[hid][hLocked] = locked;
		
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET locked='%d' WHERE ID='%d'", locked, hid);
		mysql_tquery(g_SQL, query);

		House_Refresh(hid);

        if(locked) {
            SendAdminMessage(COLOR_RED, "%s has locked house ID: %d.", pData[playerid][pAdminname], hid);
        }
        else {
            SendAdminMessage(COLOR_RED, "%s has unlocked house ID: %d.", pData[playerid][pAdminname], hid);
        }
    }
    else if(!strcmp(type, "price", true))
    {
        new price;

        if(sscanf(string, "d", price))
            return Usage(playerid, "/edithouse [id] [Price] [Amount]");

        hData[hid][hPrice] = price;

		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET price='%d' WHERE ID='%d'", price, hid);
		mysql_tquery(g_SQL, query);

		House_Refresh(hid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the price of house ID: %d to %d.", pData[playerid][pAdminname], hid, price);
    }
	else if(!strcmp(type, "type", true))
    {
        new htype;

        if(sscanf(string, "d", htype))
            return Usage(playerid, "/edithouse [id] [Type] [1.small 2.medium 3.Big 4. Very Small]");

        hData[hid][hType] = htype;
		House_Type(hid);
		
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET type='%d' WHERE ID='%d'", htype, hid);
		mysql_tquery(g_SQL, query);

		House_Refresh(hid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the type of house ID: %d to %d.", pData[playerid][pAdminname], hid, htype);
    }
    else if(!strcmp(type, "owner", true))
    {
		new otherid;
        if(sscanf(string, "d", otherid))
            return Usage(playerid, "/edithouse [id] [owner] [playerid] (use '-1' to no owner/ reset)");
		if(otherid == -1)
			return format(hData[hid][hOwner], MAX_PLAYER_NAME, "-");

        format(hData[hid][hOwner], MAX_PLAYER_NAME, pData[otherid][pName]);
		hData[hid][hOwnerID] = pData[otherid][pID];
  
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET owner='%s', ownerid='%d' WHERE ID='%d'", hData[hid][hOwner], hData[hid][hOwnerID], hid);
		mysql_tquery(g_SQL, query);

		House_Refresh(hid);
        SendAdminMessage(COLOR_RED, "%s has adjusted the owner of house ID: %d to %s", pData[playerid][pAdminname], hid, pData[otherid][pName]);
    }
    else if(!strcmp(type, "reset", true))
    {
        HouseReset(hid);
		House_Save(hid);
		House_Refresh(hid);
        SendAdminMessage(COLOR_RED, "%s has reset house ID: %d.", pData[playerid][pAdminname], hid);
    }
	else if(!strcmp(type, "delete", true))
	{
		HouseReset(hid);
		
		DestroyDynamic3DTextLabel(hData[hid][hLabel]);
        DestroyDynamicPickup(hData[hid][hPickup]);
		DestroyDynamicMapIcon(hData[hid][hMapIcon]);
        DestroyDynamicCP(hData[hid][hCP]);
		
		hData[hid][hExtposX] = 0;
		hData[hid][hExtposY] = 0;
		hData[hid][hExtposZ] = 0;
		hData[hid][hExtposA] = 0;
		hData[hid][hPrice] = 0;
		hData[hid][hInt] = 0;
		hData[hid][hIntposX] = 0;
		hData[hid][hIntposY] = 0;
		hData[hid][hIntposZ] = 0;
		hData[hid][hIntposA] = 0;
		hData[hid][hLabel] = Text3D: INVALID_3DTEXT_ID;
		hData[hid][hPickup] = -1;
		
		Iter_Remove(Houses, hid);
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM houses WHERE ID=%d", hid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete house ID: %d.", pData[playerid][pAdminname], hid);
		new str[150];
		format(str,sizeof(str),"[House]: %s menghapus house id %d!", GetRPName(playerid), hid);
		LogServer("Admin", str);
	}
    return 1;
}

CMD:tarokoran(playerid, params[])
{
	if(pData[playerid][pPaperduty] == 0) return ErrorMsg(playerid, "Anda tidak berkerja sebagai pengantar koran");
	foreach(new hid : Houses)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
		{
		    if(pData[playerid][pKoran] < 1) return ErrorMsg(playerid, "Lu gk punya koran");
	
			if(pData[playerid][pKoran] == 6)
			{
			    pData[playerid][pKoran1] = hid;
			    pData[playerid][pKoran] -= 1;
			    Info(playerid, "Koran tersisa %d/6", pData[playerid][pKoran]);
			}
			if(pData[playerid][pKoran] == 5)
			{
			    if(hid == pData[playerid][pKoran1]) return InfoMsg(playerid, "Ganti rumah");
			    pData[playerid][pKoran2] = hid;
			    pData[playerid][pKoran] -= 1;
			    Info(playerid, "Koran tersisa %d/6", pData[playerid][pKoran]);
			}
			if(pData[playerid][pKoran] == 4)
			{
			    if(hid == pData[playerid][pKoran1]) return InfoMsg(playerid, "Ganti rumah");
			    if(hid == pData[playerid][pKoran2]) return InfoMsg(playerid, "Ganti rumah");
			    pData[playerid][pKoran3] = hid;
			    pData[playerid][pKoran] -= 1;
			    Info(playerid, "Koran tersisa %d/6", pData[playerid][pKoran]);
			}
			if(pData[playerid][pKoran] == 3)
			{
			    if(hid == pData[playerid][pKoran1]) return InfoMsg(playerid, "Ganti rumah");
			    if(hid == pData[playerid][pKoran2]) return InfoMsg(playerid, "Ganti rumah");
			    if(hid == pData[playerid][pKoran3]) return InfoMsg(playerid, "Ganti rumah");
			    pData[playerid][pKoran4] = hid;
			    pData[playerid][pKoran] -= 1;
			    Info(playerid, "Koran tersisa %d/6", pData[playerid][pKoran]);
			}
			if(pData[playerid][pKoran] == 2)
			{
			    if(hid == pData[playerid][pKoran1]) return InfoMsg(playerid, "Ganti rumah");
			    if(hid == pData[playerid][pKoran2]) return InfoMsg(playerid, "Ganti rumah");
			    if(hid == pData[playerid][pKoran3]) return InfoMsg(playerid, "Ganti rumah");
			    if(hid == pData[playerid][pKoran4]) return InfoMsg(playerid, "Ganti rumah");
			    pData[playerid][pKoran5] = hid;
			    pData[playerid][pKoran] -= 1;
			    Info(playerid, "Koran tersisa %d/6", pData[playerid][pKoran]);
			}
			if(pData[playerid][pKoran] == 1)
			{
			    if(hid == pData[playerid][pKoran1]) return InfoMsg(playerid, "Ganti rumah");
			    if(hid == pData[playerid][pKoran2]) return InfoMsg(playerid, "Ganti rumah");
			    if(hid == pData[playerid][pKoran3]) return InfoMsg(playerid, "Ganti rumah");
			    if(hid == pData[playerid][pKoran4]) return InfoMsg(playerid, "Ganti rumah");
			    if(hid == pData[playerid][pKoran5]) return InfoMsg(playerid, "Ganti rumah");
			 
			     pData[playerid][pKoran] = 0;
		        SendClientMessageEx(playerid, -1, "Ikuti checkpoint untuk mengambil gaji dan selesai berkerja");
		        SetPlayerRaceCheckpoint(playerid, 1, 614.9992, -1349.9445, 13.6311, 614.9992, -1349.9445, 13.6311, 5.0);
			}
		}
	}
}

CMD:buyhouse(playerid, params[])
{
    foreach(new hid : Houses)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
			{
				if(hData[hid][hPrice] > GetPlayerMoney(playerid)) return ErrorMsg(playerid, "Not enough money, you can't afford this houses.");
				if(strcmp(hData[hid][hOwner], "-")) return ErrorMsg(playerid, "Someone already owns this house.");
				if(pData[playerid][pVip] == 1)
				{
				    #if LIMIT_PER_PLAYER > 0
					if(Player_HouseCount(playerid) + 1 > 2) return ErrorMsg(playerid, "You can't buy any more houses.");
					#endif
				}
				else if(pData[playerid][pVip] == 2)
				{
				    #if LIMIT_PER_PLAYER > 0
					if(Player_HouseCount(playerid) + 1 > 3) return ErrorMsg(playerid, "You can't buy any more houses.");
					#endif
				}
				else if(pData[playerid][pVip] == 3)
				{
				    #if LIMIT_PER_PLAYER > 0
					if(Player_HouseCount(playerid) + 1 > 4) return ErrorMsg(playerid, "You can't buy any more houses.");
					#endif
				}
				else
				{
					#if LIMIT_PER_PLAYER > 0
					if(Player_HouseCount(playerid) + 1 > 1) return ErrorMsg(playerid, "You can't buy any more houses.");
					#endif
				}
				GivePlayerMoneyEx(playerid, -hData[hid][hPrice]);
				Server_AddMoney(hData[hid][hPrice]);
				GetPlayerName(playerid, hData[hid][hOwner], MAX_PLAYER_NAME);
				hData[hid][hVisit] = gettime();
				House_Refresh(hid);
				House_Save(hid);
			}
		}
}
CMD:lockhouse(playerid, params[])
{
	foreach(new hid : Houses)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
		{
			if(!Player_OwnsHouse(playerid, hid)) return ErrorMsg(playerid, "You don't own this house.");
			if(!hData[hid][hLocked])
			{
				hData[hid][hLocked] = 1;
				
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET locked='%d' WHERE ID='%d'", hData[hid][hLocked], hid);
				mysql_tquery(g_SQL, query);

				InfoTD_MSG(playerid, 4000, "You have ~r~locked~w~ your house!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
			else
			{
				hData[hid][hLocked] = 0;
				
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET locked='%d' WHERE ID='%d'", hData[hid][hLocked], hid);
				mysql_tquery(g_SQL, query);

				InfoTD_MSG(playerid, 4000,"You have ~g~unlocked~w~ your house!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
		}
	}
	return 1;
}

CMD:givehouse(playerid, params[])
{
	new hid, otherid;
	if(sscanf(params, "ud", otherid, hid)) return Usage(playerid, "/givehouse [playerid/name] [id] | /myhouse - for show info");
	if(hid == -1) return ErrorMsg(playerid, "Invalid id");
	
	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
        return ErrorMsg(playerid, "The specified player is disconnected or not near you.");
	
	if(!Player_OwnsHouse(playerid, hid)) return ErrorMsg(playerid, "You dont own this id house.");
	
	if(pData[otherid][pVip] == 1)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_HouseCount(otherid) + 1 > 2) return ErrorMsg(playerid, "Target player cant own any more houses.");
		#endif
	}
	else if(pData[otherid][pVip] == 2)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_HouseCount(otherid) + 1 > 3) return ErrorMsg(playerid, "Target player cant own any more houses.");
		#endif
	}
	else if(pData[otherid][pVip] == 3)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_HouseCount(otherid) + 1 > 4) return ErrorMsg(playerid, "Target player cant own any more houses.");
		#endif
	}
	else if(pData[otherid][pVip] == 4)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_HouseCount(otherid) + 1 > 5) return ErrorMsg(playerid, "Target player cant own any more houses.");
		#endif
	}
	else if(pData[otherid][pVip] == 5)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_HouseCount(otherid) + 1 > 6) return ErrorMsg(playerid, "Target player cant own any more houses.");
		#endif
	}
	else if(pData[otherid][pVip] == 6)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_HouseCount(otherid) + 1 > 7) return ErrorMsg(playerid, "Target player cant own any more houses.");
		#endif
	}
	else
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_HouseCount(otherid) + 1 > 1) return ErrorMsg(playerid, "Target player cant own any more houses.");
		#endif
	}
	GetPlayerName(otherid, hData[hid][hOwner], MAX_PLAYER_NAME);
	hData[hid][hOwnerID] = pData[otherid][pID];
	hData[hid][hVisit] = gettime();
	
	House_Refresh(hid);
	
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET owner='%s', ownerid='%d', visit='%d' WHERE ID='%d'", hData[hid][hOwner], hData[hid][hOwnerID], hData[hid][hVisit], hid);
	mysql_tquery(g_SQL, query);

	Info(playerid, "Anda memberikan rumah id: %d kepada %s", hid, ReturnName(otherid));
	Info(otherid, "%s memberikan rumah id: %d kepada anda", hid, ReturnName(playerid));
	new str[150];
	format(str,sizeof(str),"[HOUSE]: %s memberikan house id %d ke %s!", GetRPName(playerid), hid, GetRPName(otherid));
	LogServer("Property", str);
	new dc[10000];
    format(dc, sizeof(dc),  "```\n[GIVE HOUSE] %s[UCP: %s] memberikan house [ID: %d] kepada %s[UCP: %s]```", GetRPName(playerid), pData[playerid][pUCP], hid, GetRPName(otherid), pData[otherid][pUCP]);
    SendDiscordMessage(11, dc);
	return 1;
}

CMD:sellhouse(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2082.9756, 2675.5081, 1500.9647)) return ErrorMsg(playerid, "Anda harus berada di City Hall!");
	if(GetOwnedHouses(playerid) == -1) return ErrorMsg(playerid, "You don't have a houses.");
	//if(!Player_OwnsBusiness(playerid, id)) return ErrorMsg(playerid, "You don't own this business.");
	new hid, _tmpstring[128], count = GetOwnedHouses(playerid), CMDSString[1024];
	CMDSString = "";
	new lock[128];
	Loop(itt, (count + 1), 1)
	{
	    hid = ReturnPlayerHousesID(playerid, itt);
		if(hData[hid][hLocked] == 1)
		{
			lock = "{FF0000}Locked";
		
		}
		else
		{
			lock = "{00FF00}Unlocked";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s{FFFF2A})\n", itt, hData[hid][hAddress], lock);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s{FFFF2A})\n", itt, hData[hid][hAddress], lock);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_SELL_HOUSES, DIALOG_STYLE_LIST, "Sell Houses", CMDSString, "Sell", "Cancel");
	return 1;
}

CMD:myhouse(playerid)
{
	if(GetOwnedHouses(playerid) == -1) return ErrorMsg(playerid, "You don't have a houses.");
	//if(!Player_OwnsBusiness(playerid, id)) return ErrorMsg(playerid, "You don't own this business.");
	new hid, _tmpstring[128], count = GetOwnedHouses(playerid), CMDSString[1024];
	CMDSString = "";
	new lock[128];
	Loop(itt, (count + 1), 1)
	{
	    hid = ReturnPlayerHousesID(playerid, itt);
		if(hData[hid][hLocked] == 1)
		{
			lock = "{FF0000}Dikunci";
		
		}
		else
		{
			lock = "{00FF00}Dibuka";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s)\n", itt, hData[hid][hAddress], lock);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s)\n", itt, hData[hid][hAddress], lock);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_MY_HOUSES, DIALOG_STYLE_LIST, "{0000FF}My Houses", CMDSString, "Select", "Cancel");
	return 1;
}

CMD:gudang(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 2075.6333, -2032.8124, 13.5469))
	{
		Gudang_OpenStorage(playerid);
	}
    return 1;
}

CMD:hm(playerid, params[])
{
	if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) 
		if(pData[playerid][pFaction] != 1)
			return ErrorMsg(playerid, "Kamu bukan pemilik rumah.");
	House_OpenStorage(playerid, pData[playerid][pInHouse]);
    return 1;
}
/*
CMD:tdhinven(playerid, params[])
{
	if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse]))
		if(pData[playerid][pFaction] != 1)
			return ErrorMsg(playerid, "Kamu bukan pemilik rumah.");
	pData[playerid][pDirumah] = 1;
	Hinventory_Show(playerid, pData[playerid][pInHouse]);
    return 1;
}
//hinventory
#define MAX_HINVENTORY 20

//Inventory
enum hinventoryData {
	bool:hinvExists,
	hinvID,
	hinvItem[32],
	hinvModelColor,
	hinvModel,
	hinvQuantity,
	hinvSenjata,
	Float:hinvJangka,
	hinvWeapon,
	hinvAmmo,
	hinvSlot
};
new HInventoryData[MAX_PLAYERS][MAX_HINVENTORY][hinventoryData];
new bool:HInventoryOpen[MAX_PLAYERS];

function OnHInventoryAdd(playerid, itemid)
{
    HInventoryData[playerid][itemid][hinvID] = cache_insert_id();
    return 1;
}
function LoadHInventory(hid)
{
	new rows = cache_num_rows();
    for (new i = 0; i < rows && i < MAX_HINVENTORY; i ++) {
	        HInventoryData[hid][i][hinvExists] = true;
	        cache_get_value_name_int(i, "hinvID", HInventoryData[hid][i][hinvID]);
	        cache_get_value_name_int(i, "hinvModel", HInventoryData[hid][i][hinvModel]);
	        cache_get_value_name_int(i, "hinvSlot", HInventoryData[hid][i][hinvSlot]);
	        cache_get_value_name_int(i, "hinvQuantity", HInventoryData[hid][i][hinvQuantity]);
	        cache_get_value_name_float(i, "hinvJangka", HInventoryData[hid][i][hinvJangka]);
	        cache_get_value_name_int(i, "hinvSenjata", HInventoryData[hid][i][hinvSenjata]);
	        cache_get_value_name(i, "hinvItem", HInventoryData[hid][i][hinvItem], 64);
	        for (new id = 0; id < sizeof(g_aInventoryItems); id ++) if(!strcmp(g_aInventoryItems[id][e_InventoryItem], HInventoryData[hid][i][hinvItem], true))
			{

					hData[hid][hWeight] += float(HInventoryData[hid][i][hinvQuantity])*g_aInventoryItems[id][e_InventoryWeight];
			}
    }
    return 1;
}

stock HInventory_GetInventoryID(hid ,item[])
{
	for (new i = 0; i < MAX_HINVENTORY; i ++)
	{
		if (!HInventoryData[hid][i][hinvExists])
			continue;

		if (!strcmp(HInventoryData[hid][i][hinvItem], item)) return HInventoryData[hid][i][hinvID];
	}
	return -1;
}
stock HInventory_GetItemID(hid, item[])
{
	for (new i = 0; i < MAX_HINVENTORY; i ++)
	{
		if (!HInventoryData[hid][i][hinvExists])
			continue;

		if (!strcmp(HInventoryData[hid][i][hinvItem], item)) return i;
	}
	return -1;
}

stock HInventory_GetFreeID(hid)
{
	for (new i = 0; i < MAX_HINVENTORY; i ++)
	{
		if (!HInventoryData[hid][i][hinvExists])
			return i;
	}
	return -1;
}
stock HInventory_Add(playerid, hid, item[], model, quantity = 1, jangka = 100, senjata = 0, color = 0,weapon = 0, ammo = 0)
{
	new
		itemid = HInventory_GetItemID(hid, item),
		string[318],
		value_str[218];

	if(hData[hid][hWeight] >= 20000.00) {Error(playerid, "Tas kamu tidak kuat menampung lebih banyak item lagi."); return -2;}
	if (itemid == -1)
	{
		itemid = HInventory_GetFreeID(hid);

		if (itemid != -1)
		{
			new Float:Weights;
			for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if(!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
			{
				Weights = float(quantity)*g_aInventoryItems[i][e_InventoryWeight];
			}
			if(hData[hid][hWeight]+Weights >= 20000.00) {Error(playerid, "Tas kamu tidak kuat menampung lebih banyak item lagi."); return 1;}
			hData[hid][hWeight] += Weights;
			HInventoryData[hid][itemid][hinvExists] = true;
			HInventoryData[hid][itemid][hinvModel] = model;
			if(strcmp(item,"Colt45",true) == 0 || strcmp(item,"Desert_Eagle",true) == 0 || strcmp(item,"Silenced_Pistol",true) == 0 || strcmp(item,"Shotgun",true) == 0 || strcmp(item,"Ak47",true) == 0 || strcmp(item,"Mp5",true) == 0)
			{
                HInventoryData[hid][itemid][hinvSenjata] = 1;
			}
			HInventoryData[hid][itemid][hinvQuantity] = quantity;
			HInventoryData[hid][itemid][hinvWeapon] = weapon;
			HInventoryData[hid][itemid][hinvAmmo] = ammo;
			HInventoryData[hid][itemid][hinvSlot] = itemid;
            HInventoryData[hid][itemid][hinvJangka] = jangka;

			format(HInventoryData[hid][itemid][hinvItem], 64, "%s", item);
			format(string, sizeof(string), "INSERT INTO `hinventory` (`ID`, `hinvItem`, `hinvModel`, `hinvQuantity`, `hinvSlot`) VALUES('%d', '%s', '%d', '%d', '%d')", hid, item, model, quantity, itemid);
			mysql_tquery(g_SQL, string, "OnHInventoryAdd", "dd", hid, itemid);

			if(InventoryOpen[playerid])
			{
			    PlayerTextDrawShow(playerid, DropName[playerid][itemid]);
				PlayerTextDrawShow(playerid, DropModel[playerid][itemid]);
				UpdateInventoryTD(playerid, itemid);
				Hinventory_BarUpdate(hid);
				Geledah_BarUpdate(playerid, pData[playerid][pOranggeledah]);
			}
			return itemid;
		}
		return -1;
	}
	else
	{
		format(string, sizeof(string), "UPDATE `hinventory` SET `hinvQuantity` = `hinvQuantity` + %d WHERE `ID` = '%d' AND `hinvID` = '%d'", quantity, hid, HInventoryData[hid][itemid][hinvID]);
		mysql_tquery(g_SQL, string);

		HInventoryData[hid][itemid][hinvQuantity] += quantity;
		format(value_str, sizeof(value_str), "%dx", HInventoryData[hid][itemid][hinvQuantity]);
		PlayerTextDrawSetString(playerid, DropValue[playerid][itemid], value_str);
		PlayerTextDrawSetString(playerid, DropName[playerid][itemid], HInventoryData[hid][itemid][hinvItem]);
		PlayerTextDrawShow(playerid, DropName[playerid][itemid]);
		PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][itemid], model);
		for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if(!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
		{
			hData[hid][hWeight] += quantity*g_aInventoryItems[i][e_InventoryWeight];
		}
		if(InventoryOpen[playerid])
		{
			Hinventory_BarUpdate(playerid);
		}
	}
	return itemid;
}
function Hinventory_Show(playerid, hid)
{
	if (!IsPlayerConnected(playerid))
        return 0;

    static
        str[1080],
        string[128],
        value_str[128];

    format(str, sizeof(str), "Item Name\tItem Quantity\n");
    //Show Background
    for(new inv = 0; inv<20; inv++) PlayerTextDrawShow(playerid, InvBox[playerid][inv]);
    //
    for(new inv = 0; inv<4; inv++) PlayerTextDrawShow(playerid, Hiasan[playerid][inv]);
    //Show Text
    for(new inv = 0; inv<26; inv++) PlayerTextDrawShow(playerid, InvenTD[playerid][inv]);
    for(new inv = 0; inv<22; inv++) PlayerTextDrawShow(playerid, DropTD[playerid][inv]);
    //Set UI Color
    //PlayerTextDrawColor(playerid, BarWeight[playerid], 1687547311);
	new nama[128];
	format(nama, sizeof nama, "%s", pData[playerid][pName]);
	PlayerTextDrawSetString(playerid, InvNama[playerid], nama);
	PlayerTextDrawShow(playerid, InvNama[playerid]);
    //Show Ammount, Use, Give, Drop, Close
    PlayerTextDrawShow(playerid, Latar[playerid]);
    PlayerTextDrawShow(playerid, ClickAmmount[playerid]);
	PlayerTextDrawShow(playerid, ClickUse[playerid]);
	PlayerTextDrawShow(playerid, ClickGive[playerid]);
	PlayerTextDrawShow(playerid, ClickDrop[playerid]);
	PlayerTextDrawShow(playerid, ClickClose[playerid]);
	PlayerTextDrawSetString(playerid, Ammount[playerid], "Ammount");
	PlayerTextDrawShow(playerid, Ammount[playerid]);
	//Show Weight
	AmmountInventory[playerid] = 1;
	SelectTextDraw(playerid, 0xFF0000FF);
	InventoryOpen[playerid] = true;
	GeledahOpen[playerid] = true;

    new
        count = 0,
        id = Item_Nearest(playerid),
        otherid[1080];

    for (new i = 0; i < MAX_INVENTORY; i ++)
    {
        if(InventoryData[playerid][i][invSenjata] != 0)
        {
        	format(value_str, sizeof(value_str), "%dx", InventoryData[playerid][i][invQuantity]);
        	new Float:dura;

		    /*dura = InventoryData[playerid][i][invJangka] * 37.0/100;
			PlayerTextDrawTextSize(playerid,InvDura[playerid][i], dura, 2.0); *///Seusain in aja size nya sama di textdraw nya
/*
		}
		else
        {
        	format(value_str, sizeof(value_str), "%dx", InventoryData[playerid][i][invQuantity]);
		}
        if(InventoryData[playerid][i][invWeapon] != 0) format(value_str, sizeof(value_str), "%d", InventoryData[playerid][i][invAmmo]);
		PlayerTextDrawSetString(playerid, InvName[playerid][i], InventoryData[playerid][i][invItem]);
		PlayerTextDrawSetString(playerid, InvValue[playerid][i], value_str);
        if (!InventoryData[playerid][i][invExists]) PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][i], 19300);
        else
        {
        	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][i], InventoryData[playerid][i][invModel]);
        	PlayerTextDrawShow(playerid, InvName[playerid][i]);
        	PlayerTextDrawShow(playerid, InvBox[playerid][i]);
        	PlayerTextDrawShow(playerid, InvLine[playerid][i]);
	    	PlayerTextDrawShow(playerid, InvValue[playerid][i]);
        }
        if(InventoryData[playerid][i][invSenjata] != 0)
        {
            //PlayerTextDrawShow(playerid, InvDura[playerid][i]);
		}
        PlayerTextDrawShow(playerid, InvModel[playerid][i]);
        //geledah
        //geledah
		  
	    	if(HInventoryData[hid][i][hinvSenjata] != 0)
	        {
	        	format(value_str, sizeof(value_str), "%dx", HInventoryData[hid][i][hinvQuantity]);
	        	new Float:dura;

			    /*dura = InventoryData[playerid][i][invJangka] * 37.0/100;
				PlayerTextDrawTextSize(playerid,InvDura[playerid][i], dura, 2.0); *///Seusain in aja size nya sama di textdraw nya
/*
			}
			else
	        {
	        	format(value_str, sizeof(value_str), "%dx", HInventoryData[hid][i][hinvQuantity]);
			}
	        if(HInventoryData[hid][i][hinvWeapon] != 0) format(value_str, sizeof(value_str), "%d", HInventoryData[hid][i][hinvAmmo]);
			PlayerTextDrawSetString(playerid, DropName[playerid][i], HInventoryData[hid][i][hinvItem]);
			PlayerTextDrawSetString(playerid, DropValue[playerid][i], value_str);
	        if (!HInventoryData[hid][i][hinvExists]) PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][i], 19300);
	        else
	        {
	        	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][i], HInventoryData[hid][i][hinvModel]);
	        	PlayerTextDrawShow(playerid, DropName[playerid][i]);
		    	PlayerTextDrawShow(playerid, DropValue[playerid][i]);
	        }
			new nama[128];
			format(nama, sizeof nama, "%d", hid);
			PlayerTextDrawSetString(playerid, DropTD[playerid][1], nama);
	        PlayerTextDrawShow(playerid, DropModel[playerid][i]);
    }
    format(string, sizeof(string), "%.3f/100KG", pData[playerid][pWeight]);
    PlayerTextDrawSetString(playerid, InvWeight[playerid], string);
    PlayerTextDrawShow(playerid, InvWeight[playerid]);
    format(string, sizeof(string), "%.3f/20000KG", hData[hid][hWeight]);
    PlayerTextDrawSetString(playerid, InvBerat[playerid], string);
    PlayerTextDrawShow(playerid, InvBerat[playerid]);
    Inventory_BarUpdate(playerid);
   	Hinventory_BarUpdate(playerid, hid);
	return 1;
}

stock Hinventory_BarUpdate(playerid, hid)
{
	new value = floatround(hData[hid][hWeight]);
	if(value < 0) value = 0, hData[hid][hWeight] = 0;
	PlayerTextDrawTextSize(playerid, BarBerat[playerid], value * 192 / 50, 5.000000);
	PlayerTextDrawShow(playerid, BarBerat1[playerid]);
	PlayerTextDrawShow(playerid, BarBerat[playerid]);
}*/
