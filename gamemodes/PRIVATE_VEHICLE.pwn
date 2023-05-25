
//Private Vehicle Player System Define

#define MAX_PRIVATE_VEHICLE 10000
#define MAX_PLAYER_VEHICLE 3
#define MAX_PESAWAT 13
//new Float: VehicleFuel[MAX_VEHICLES] = 100.0;
new bool:VehicleHealthSecurity[MAX_VEHICLES] = false, Float:VehicleHealthSecurityData[MAX_VEHICLES] = 1000.0;
new AdminVehicle[MAX_VEHICLES char];
new Rentalveh[MAX_VEHICLES char];

enum PesawatVariabel
{
	pStatus,
};

new PeData[MAX_PESAWAT][PesawatVariabel];

enum pvdata
{
	cID,
	cOwner,
	cModel,
	cColor1,
	cColor2,
	cPaintJob,
	cTogkandang,
	cNeon,
	cTogNeon,
	cLocked,
	cInsu,
	cClaim,
	cClaimTime,
	cPlate[15],
	cPlateTime,
	cTicket,
	cPrice,
	Float:cHealth,
	cFuel,
	Float:cPosX,
	Float:cPosY,
	Float:cPosZ,
	Float:cPosA,
	cDamage0,
	cDamage1,
	cDamage2,
	cDamage3,
	cInt,
	cVw,
	cMod[17],
	cLumber,
	cMetal,
	cAyamhidup,
	cCoal,
	cProduct,
	cGasOil,
	cBox,
	cRent,
	cVeh,
	cKandang,
	cBreaken,
	cBreaking,
	cCooldown,
	//cGaraged,
	cPark,
	cDeath,
	cStolen,
	cUpgrade[4],
	cTurboMode,
	cBrakeMode,
	cImpounded,
	cImpoundPrice,
	//Vehicle Storage
	cTrunk,
	bool:LoadedStorage,
	bool:PurchasedvToy,
	vtoySelected,
	vehSirenObject,
	vehSirenOn,
};
new pvData[MAX_PRIVATE_VEHICLE][pvdata],
Iterator:PVehicles<MAX_PRIVATE_VEHICLE + 1>;
//Iterator:PIven<MAX_PLAYER_INVENTORY + 1>;

new pesawat[13];

AddPesawat()
{
    pesawat[0] = AddStaticVehicleEx(519,-1364.916,-492.718,14.171,199.512,1,1,VEHICLE_RESPAWN);
    pesawat[1] = AddStaticVehicleEx(519,-1433.117,-539.563,14.171,204.500,1,1,VEHICLE_RESPAWN);
    pesawat[2] = AddStaticVehicleEx(519,-1254.930,-109.385,14.148,143.836,1,1,VEHICLE_RESPAWN);
    pesawat[3] = AddStaticVehicleEx(519,-1215.210,-158.092,14.148,129.247,1,1,VEHICLE_RESPAWN);
    pesawat[4] = AddStaticVehicleEx(-1,0.000,0.000,0.000,0.000,-1,-1,VEHICLE_RESPAWN);
    pesawat[5] = AddStaticVehicleEx(519,1548.585,1246.153,10.812,349.532,1,1,VEHICLE_RESPAWN);
    pesawat[6] = AddStaticVehicleEx(519,1571.485,1251.212,10.812,329.480,1,1,VEHICLE_RESPAWN);
    pesawat[7] = AddStaticVehicleEx(519,1566.386,1292.564,10.812,62.245,1,1,VEHICLE_RESPAWN);
    pesawat[8] = AddStaticVehicleEx(519,1553.947,1347.885,10.873,89.691,1,1,VEHICLE_RESPAWN);
    pesawat[9] = AddStaticVehicleEx(519,1982.361,-2320.949,13.546,63.194,1,1,VEHICLE_RESPAWN);
    pesawat[10] = AddStaticVehicleEx(519,1979.467,-2289.825,13.546,100.868,1,1,VEHICLE_RESPAWN);
    pesawat[11] = AddStaticVehicleEx(519,1941.362,-2300.476,13.546,179.084,1,1,VEHICLE_RESPAWN);
    pesawat[12] = AddStaticVehicleEx(519,1908.298,-2375.594,13.546,184.193,1,1,VEHICLE_RESPAWN);
}

IsAPesawat(carid)
{
	for(new v = 0; v < sizeof(pesawat); v++) {
	    if(carid == pesawat[v]) return 1;
	}
	return 0;
}
//Private Vehicle Player System Native
new const g_arrVehicleNames[212][] = {
	"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
	"Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
	"Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
	"Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
	"Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
	"Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
	"Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
	"Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
	"Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
	"FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
	"Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
	"Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
	"Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
	"Fortune", "Cadrona", "SWAT Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
	"Blade", "Streak", "Freight", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
	"Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
	"Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
	"Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
	"Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
	"Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD Car", "SFPD Car", "LVPD Car",
	"Police Rancher", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
	"Boxville", "Tiller", "Utility Trailer"
};

GetEngineStatus(vehicleid)
{
	static
	engine,
	lights,
	alarm,
	doors,
	bonnet,
	boot,
	objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(engine != 1)
		return 0;

	return 1;
}

GetLightStatus(vehicleid)
{
	static
	engine,
	lights,
	alarm,
	doors,
	bonnet,
	boot,
	objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(lights != 1)
		return 0;

	return 1;
}

ReturnAnyVehiclePark(slot, i)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_PRIVATE_VEHICLE) return -1;
	foreach(new id : PVehicles)
	{
	    if(pvData[id][cPark] == i && pvData[id][cPark] > -1)
	    {
     		tmpcount++;
       		if(tmpcount == slot)
       		{
        		return id;
  			}
	    }
	}
	return -1;
}

GetAnyVehiclePark(i)
{
	new tmpcount;
	foreach(new id : PVehicles)
	{
	    if(pvData[id][cPark] == i)
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}

Vehicle_HaveAccess(playerid, carid)
{
	if(pData[playerid][pID] == -1)
		return 0;

	if((Iter_Contains(PVehicles, carid) && pvData[carid][cOwner] != 0) && pvData[carid][cOwner] == pData[playerid][pID])
		return 1;

	return 0;
}

GetVehicleRelativePos(vehicleid, &Float:x, &Float:y, &Float:z, Float:xoff= 0.0, Float:yoff= 0.0, Float:zoff= 0.0)
{
    new Float:rot;
    GetVehicleZAngle(vehicleid, rot);
    rot = 360 - rot;
    GetVehiclePos(vehicleid, x, y, z);
    x = floatsin(rot, degrees) * yoff + floatcos(rot, degrees) * xoff + x;
    y = floatcos(rot, degrees) * yoff - floatsin(rot, degrees) * xoff + y;
    z = zoff + z;

    return 1;
}

IPRP::AlarmOff(vehicleid)
{
	SwitchVehicleAlarm(vehicleid, false);
	KillTimer(FlashTime[vehicleid]);
	SwitchVehicleLight(vehicleid, false);
}

Vehicle_Inside(playerid)
{
	new carid;

	if (IsPlayerInAnyVehicle(playerid) && (carid = Vehicle_GetID(GetPlayerVehicleID(playerid))) != -1)
	    return carid;

	return -1;
}

stock Vehicle_GetID(vehicleid)
{
	foreach(new i : PVehicles) if (pvData[i][cVeh] == vehicleid)
	{
	    return i;
	}
	return -1;
}

stock RespawnVehicle(vehicleid)
{
	new id = Vehicle_GetID(vehicleid);

	if (id != -1)
	{
	    Vehicle_GetStatus(id);

	    if(IsValidVehicle(pvData[id][cVeh]))
			DestroyVehicle(pvData[id][cVeh]);

	    OnPlayerVehicleRespawn(id);
	}
	else
	{
		SetVehicleToRespawn(vehicleid);
	}
	return 1;
}

GetHoodStatus(vehicleid)
{
	static
	engine,
	lights,
	alarm,
	doors,
	bonnet,
	boot,
	objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(bonnet != 1)
		return 0;

	return 1;
}

GetTrunkStatus(vehicleid)
{
	static
	engine,
	lights,
	alarm,
	doors,
	bonnet,
	boot,
	objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if(boot != 1)
		return 0;

	return 1;
}

GetVehicleModelByName(const name[])
{
	if(IsNumeric(name) && (strval(name) >= 400 && strval(name) <= 611))
		return strval(name);

	for (new i = 0; i < sizeof(g_arrVehicleNames); i ++)
	{
		if(strfind(g_arrVehicleNames[i], name, true) != -1)
		{
			return i + 400;
		}
	}
	return 0;
}
Vehicle_Nearest(playerid, Float:range = 5.5)
{
	new Float:fX,
		Float:fY,
		Float:fZ;

	foreach(new i : PVehicles)
	{
		if(pvData[i][cVeh] != INVALID_VEHICLE_ID)
		{
			GetVehiclePos(pvData[i][cVeh], fX, fY, fZ);

			if(IsPlayerInRangeOfPoint(playerid, range, fX, fY, fZ)) 
			{
				return i;
			}
		}
	}
	return -1;
}

Vehicle_Facnear(playerid, Float:range = 5.5)
{
	new Float:fX,
		Float:fY,
		Float:fZ;

	foreach(new i : Player)
	{
			GetVehiclePos(SAPDVeh[i], fX, fY, fZ);

			if(IsPlayerInRangeOfPoint(playerid, range, fX, fY, fZ))
			{
				return i;
			}
	}
	return -1;
}
Vehicle_Nearest2(playerid)
{
	foreach(new i : PVehicles)
	{
		if(pvData[i][cVeh] != INVALID_VEHICLE_ID && IsPlayerInAnyVehicle(playerid) && pvData[i][cVeh] == GetPlayerVehicleID(playerid))
		{
			return i;
		}
	}
	return -1;
}

GetVehicleOwner(carid)
{
	foreach(new i : Player)
	{
		if(pvData[carid][cOwner] == pData[i][pID])
		{
			return i;
		}
	}
	return INVALID_PLAYER_ID;
}


GetVehicleOwnerName(carid)
{
	static Oname[MAX_PLAYER_NAME];
	foreach(new i : Player)
	{
		if(pvData[carid][cOwner] == pData[i][pID])
		{
			format(Oname, MAX_PLAYER_NAME, pData[i][pName]);
		}
	}
	return Oname;
}
Vehicle_IsOwner(playerid, carid)
{
	if(!pData[playerid][IsLoggedIn] || pData[playerid][pID] == -1)
		return 0;

	if((Iter_Contains(PVehicles, carid) && pvData[carid][cOwner] != 0) && pvData[carid][cOwner] == pData[playerid][pID])
		return 1;

	return 0;
}

Vehicle_GetStatus(carid)
{
	if(IsValidVehicle(pvData[carid][cVeh]) && pvData[carid][cVeh] != INVALID_VEHICLE_ID)
	{
		GetVehicleHealth(pvData[carid][cVeh], pvData[carid][cHealth]);
		pvData[carid][cFuel] = GetVehicleFuel(pvData[carid][cVeh]);
		GetVehiclePos(pvData[carid][cVeh], pvData[carid][cPosX], pvData[carid][cPosY], pvData[carid][cPosZ]);
		GetVehicleZAngle(pvData[carid][cVeh],pvData[carid][cPosA]);
	}
	return 1;
}

CountParkedVeh(id)
{
	if(id > -1)
	{
		new count = 0;
		foreach(new i : PVehicles)
		{
			if(pvData[i][cPark] == id)
				count++;
		}
		return count;
	}
	return 0;
}

SetValidVehicleHealth(vehicleid, Float:health) {
	VehicleHealthSecurity[vehicleid] = true;
	SetVehicleHealth(vehicleid, health);
	return 1;
}

ValidRepairVehicle(vehicleid) {
	VehicleHealthSecurity[vehicleid] = true;
	RepairVehicle(vehicleid);
	return 1;
}


//Private Vehicle Player System Function

function OnPlayerVehicleRespawn(i)
{
	if(pvData[i][cClaim] == 0 && pvData[i][cPark] < 0 && pvData[i][cStolen] == 0)
	{
		pvData[i][cVeh] = CreateVehicle(pvData[i][cModel], pvData[i][cPosX], pvData[i][cPosY], pvData[i][cPosZ], pvData[i][cPosA], pvData[i][cColor1], pvData[i][cColor2], -1);
		SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
		SetVehicleVirtualWorld(pvData[i][cVeh], pvData[i][cVw]);
		LinkVehicleToInterior(pvData[i][cVeh], pvData[i][cInt]);
		SetVehicleFuel(pvData[i][cVeh], pvData[i][cFuel]);
		pvData[i][cTrunk] = 1;
	}
	if(IsValidVehicle(pvData[i][cVeh]))
	{
		if(pvData[i][cHealth] < 350.0)
		{
			SetValidVehicleHealth(pvData[i][cVeh], 350.0);
		}
		else
		{
			SetValidVehicleHealth(pvData[i][cVeh], pvData[i][cHealth]);
		}
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
	
	OnLoadVehicleStorage(i);
	MySQL_LoadVehicleStorage(i);
	/*if(pvData[i][cClaim] != 0)
	{
		SetTimerEx("RespawnPV", 3000, false, "d", pvData[i][cVeh]);
	}*/
	//SwitchVehicleEngine(pvData[i][cVeh], false);
    return 1;
}

function OnLoadVehicleStorage(i)
{
	if(IsValidVehicle(pvData[i][cVeh]))
	{
		if(IsAPickup(pvData[i][cVeh]))
		{
			if(pvData[i][cLumber] > -1)
			{
				for(new lid; lid < pvData[i][cLumber]; lid++)
				{
					if(!IsValidDynamicObject(LumberObjects[pvData[i][cVeh]][lid]))
					{
						LumberObjects[pvData[i][cVeh]][lid] = CreateDynamicObject(19793, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
						AttachDynamicObjectToVehicle(LumberObjects[pvData[i][cVeh]][lid], pvData[i][cVeh], LumberAttachOffsets[lid][0], LumberAttachOffsets[lid][1], LumberAttachOffsets[lid][2], 0.0, 0.0, LumberAttachOffsets[lid][3]);
					}
				}
			}
			else if(pvData[i][cLumber] == -1)
			{
				for(new a; a < LUMBER_LIMIT; a++)
				{
					if(IsValidDynamicObject(LumberObjects[pvData[i][cVeh]][a]))
					{
						DestroyDynamicObject(LumberObjects[pvData[i][cVeh]][a]);
						LumberObjects[pvData[i][cVeh]][a] = -1;
					}
				}
			}
		}
		if(pvData[i][cKandang] == 1)
		{
		    Kandang[pvData[i][cVeh]] = CreateDynamicObject(925,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
    		AttachDynamicObjectToVehicle(Kandang[pvData[i][cVeh]], pvData[i][cVeh], 0.000, -1.500, 1.099, 0.000, 0.000, 0.000);
    		
		}
		if(pvData[i][cTogNeon] == 1)
		{
			if(pvData[i][cNeon] != 0)
			{
				SetVehicleNeonLights(pvData[i][cVeh], true, pvData[i][cNeon], 0);
			}
		}

		if(pvData[i][cMetal] > 0)
		{

			LogStorage[pvData[i][cVeh]][ 0 ] = pvData[i][cMetal];
		}
		else
		{
			LogStorage[pvData[i][cVeh]][ 0 ] = 0;
		}

		if(pvData[i][cCoal] > 0)
		{
			LogStorage[pvData[i][cVeh]][ 1 ] = pvData[i][cCoal];
		}
		else
		{
			LogStorage[pvData[i][cVeh]][ 1 ] = 0;
		}

		if(pvData[i][cProduct] > 0)
		{
			VehProduct[pvData[i][cVeh]] = pvData[i][cProduct];
		}
		else
		{
			VehProduct[pvData[i][cVeh]] = 0;
		}

		if(pvData[i][cGasOil] > 0)
		{
			VehGasOil[pvData[i][cVeh]] = pvData[i][cGasOil];
		}
		else
		{
			VehGasOil[pvData[i][cVeh]] = 0;
		}

		if(pvData[i][cBox] > 0)
		{

			BoxStorage[pvData[i][cVeh]][ 0 ] = pvData[i][cBox];
		}
		else
		{
			BoxStorage[pvData[i][cVeh]][ 0 ] = 0;
		}
	}
}

IPRP::LoadPlayerVehicle(playerid)
{
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `vehicle` WHERE `owner` = %d", pData[playerid][pID]);
	mysql_query(g_SQL, query, true);
	new count = cache_num_rows(), tempString[56];
	if(count > 0)
	{
		for(new z = 0; z < count; z++)
		{
			new i = Iter_Free(PVehicles);
			cache_get_value_name_int(z, "id", pvData[i][cID]);
			cache_get_value_name_int(z, "owner", pvData[i][cOwner]);
			cache_get_value_name_int(z, "locked", pvData[i][cLocked]);
			cache_get_value_name_int(z, "insu", pvData[i][cInsu]);
			cache_get_value_name_int(z, "claim", pvData[i][cClaim]);
			cache_get_value_name_int(z, "claim_time", pvData[i][cClaimTime]);
			cache_get_value_name_float(z, "x", pvData[i][cPosX]);
			cache_get_value_name_float(z, "y", pvData[i][cPosY]);
			cache_get_value_name_float(z, "z", pvData[i][cPosZ]);
			cache_get_value_name_float(z, "a", pvData[i][cPosA]);
			cache_get_value_name_float(z, "health", pvData[i][cHealth]);
			cache_get_value_name_int(z, "fuel", pvData[i][cFuel]);
			cache_get_value_name_int(z, "interior", pvData[i][cInt]);
			cache_get_value_name_int(z, "vw", pvData[i][cVw]);
			cache_get_value_name_int(z, "upb", pvData[i][cUpgrade][0]);
			cache_get_value_name_int(z, "upe", pvData[i][cUpgrade][1]);
			cache_get_value_name_int(z, "upt", pvData[i][cUpgrade][2]);
			cache_get_value_name_int(z, "upbr", pvData[i][cUpgrade][3]);
			cache_get_value_name_int(z, "damage0", pvData[i][cDamage0]);
			cache_get_value_name_int(z, "damage1", pvData[i][cDamage1]);
			cache_get_value_name_int(z, "damage2", pvData[i][cDamage2]);
			cache_get_value_name_int(z, "damage3", pvData[i][cDamage3]);
			cache_get_value_name_int(z, "color1", pvData[i][cColor1]);
			cache_get_value_name_int(z, "color2", pvData[i][cColor2]);
			cache_get_value_name_int(z, "paintjob", pvData[i][cPaintJob]);
			cache_get_value_name_int(z, "neon", pvData[i][cNeon]);
			cache_get_value_name_int(z, "kandang", pvData[i][cKandang]);
			pvData[i][cTogNeon] = 0;
			cache_get_value_name_int(z, "impound", pvData[i][cImpounded]);
			cache_get_value_name_int(z, "impoundprice", pvData[i][cImpoundPrice]);
			cache_get_value_name_int(z, "price", pvData[i][cPrice]);
			cache_get_value_name_int(z, "model", pvData[i][cModel]);
			cache_get_value_name(z, "plate", tempString);
			format(pvData[i][cPlate], 16, tempString);
			cache_get_value_name_int(z, "plate_time", pvData[i][cPlateTime]);
			cache_get_value_name_int(z, "ticket", pvData[i][cTicket]);

			cache_get_value_name_int(z, "mod0", pvData[i][cMod][0]);
			cache_get_value_name_int(z, "mod1", pvData[i][cMod][1]);
			cache_get_value_name_int(z, "mod2", pvData[i][cMod][2]);
			cache_get_value_name_int(z, "mod3", pvData[i][cMod][3]);
			cache_get_value_name_int(z, "mod4", pvData[i][cMod][4]);
			cache_get_value_name_int(z, "mod5", pvData[i][cMod][5]);
			cache_get_value_name_int(z, "mod6", pvData[i][cMod][6]);
			cache_get_value_name_int(z, "mod7", pvData[i][cMod][7]);
			cache_get_value_name_int(z, "mod8", pvData[i][cMod][8]);
			cache_get_value_name_int(z, "mod9", pvData[i][cMod][9]);
			cache_get_value_name_int(z, "mod10", pvData[i][cMod][10]);
			cache_get_value_name_int(z, "mod11", pvData[i][cMod][11]);
			cache_get_value_name_int(z, "mod12", pvData[i][cMod][12]);
			cache_get_value_name_int(z, "mod13", pvData[i][cMod][13]);
			cache_get_value_name_int(z, "mod14", pvData[i][cMod][14]);
			cache_get_value_name_int(z, "mod15", pvData[i][cMod][15]);
			cache_get_value_name_int(z, "mod16", pvData[i][cMod][16]);
			cache_get_value_name_int(z, "lumber", pvData[i][cLumber]);
			cache_get_value_name_int(z, "metal", pvData[i][cMetal]);
			cache_get_value_name_int(z, "coal", pvData[i][cCoal]);
			cache_get_value_name_int(z, "product", pvData[i][cProduct]);
			cache_get_value_name_int(z, "gasoil", pvData[i][cGasOil]);
			cache_get_value_name_int(z, "box", pvData[i][cBox]);
			cache_get_value_name_int(z, "rental", pvData[i][cRent]);
			cache_get_value_name_int(z, "park", pvData[i][cPark]);
			cache_get_value_name_int(z, "broken", pvData[i][cStolen]);
			cache_get_value_name_int(z, "trunk", pvData[i][cTrunk]);
			cache_get_value_name_int(z, "ayamhidup", pvData[i][cAyamhidup]);
			Iter_Add(PVehicles, i);
			if(pvData[i][cClaim] == 0 && pvData[i][cDeath] == 0 && pvData[i][cPark] == -1 && pvData[i][cStolen] == 0)
			{
				pvData[i][cVeh] = CreateVehicle(pvData[i][cModel], pvData[i][cPosX], pvData[i][cPosY], pvData[i][cPosZ], pvData[i][cPosA], pvData[i][cColor1], pvData[i][cColor2], -1);
				SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
				SetVehicleVirtualWorld(pvData[i][cVeh], pvData[i][cVw]);
				LinkVehicleToInterior(pvData[i][cVeh], pvData[i][cInt]);
				SetVehicleFuel(pvData[i][cVeh], pvData[i][cFuel]);
				pvData[i][cTrunk] = 1;
				pvData[i][cTurboMode] = pvData[i][cUpgrade][2];
				pvData[i][cBrakeMode] = pvData[i][cUpgrade][3];
				if(IsValidVehicle(pvData[i][cVeh]))
				{
					if(pvData[i][cHealth] < 350.0)
					{
						SetValidVehicleHealth(pvData[i][cVeh], 350.0);
					}
					else
					{
						SetValidVehicleHealth(pvData[i][cVeh], pvData[i][cHealth]);
					}
					if(pvData[i][cPaintJob] != -1)
					{
						ChangeVehiclePaintjob(pvData[i][cVeh], pvData[i][cPaintJob]);
					}
					UpdateVehicleDamageStatus(pvData[i][cVeh], pvData[i][cDamage0], pvData[i][cDamage1], pvData[i][cDamage2], pvData[i][cDamage3]);
					for(new ss = 0; ss < 17; ss++)
					{
						if(pvData[i][cMod][ss]) AddVehicleComponent(pvData[i][cVeh], pvData[i][cMod][ss]);
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
				pvData[i][cBreaken] = INVALID_PLAYER_ID;
				pvData[i][cBreaking] = 0;
				SetTimer("OnLoadVehicleStorage", 1000, true);
				MySQL_LoadVehicleStorage(i);
				MySQL_LoadVehicleToys(i);

			}
			else
			{
				pvData[i][cVeh] = 0;
			}
		}
		printf("[P_VEHICLE] Loaded player vehicle from: %s(%d)", pData[playerid][pName], playerid);
	}
	return 1;
}

Vehicle_Save(vehicleid)
{
	Vehicle_GetStatus(vehicleid);
	new cQuery[3000];
	format(cQuery, sizeof(cQuery), "UPDATE vehicle SET locked='%d', insu='%d', claim='%d', claim_time='%d', x='%f', y='%f', z='%f', a='%f', health='%f', fuel='%d', interior='%d', vw='%d', damage0='%d', damage1='%d', damage2='%d', damage3='%d', color1='%d', color2='%d', paintjob='%d', neon='%d', price='%d', model='%d', plate='%d', plate_time='%d', ticket='%d', mod0='%d', mod1='%d', mod2='%d', mod3='%d', mod4='%d', mod5='%d', mod6='%d', mod7='%d', mod8='%d', mod9='%d', mod10='%d', mod11='%d', mod12='%d', mod13='%d', mod14='%d', mod15='%d', mod16='%d', lumber='%d', metal='%d', coal='%d', product='%d', gasoil='%d', box='%d', rental='%d', park='%d', broken='%d', ayamhidup='%d', trunk='%d' WHERE id='%d'",

		pvData[vehicleid][cLocked],
		pvData[vehicleid][cInsu],
		pvData[vehicleid][cClaim],
		pvData[vehicleid][cClaimTime],
		pvData[vehicleid][cPosX],
		pvData[vehicleid][cPosY],
		pvData[vehicleid][cPosZ],
		pvData[vehicleid][cPosA],
		pvData[vehicleid][cHealth],
		pvData[vehicleid][cFuel],
		pvData[vehicleid][cInt],
		pvData[vehicleid][cVw],
		pvData[vehicleid][cColor1],
		pvData[vehicleid][cColor2],
		pvData[vehicleid][cPaintJob],
		pvData[vehicleid][cNeon],
		pvData[vehicleid][cPrice],
		pvData[vehicleid][cModel],
		pvData[vehicleid][cPlate],
		pvData[vehicleid][cPlateTime],
		pvData[vehicleid][cTicket],
		pvData[vehicleid][cMod][0],
		pvData[vehicleid][cMod][1],
		pvData[vehicleid][cMod][2],
		pvData[vehicleid][cMod][3],
		pvData[vehicleid][cMod][4],
		pvData[vehicleid][cMod][5],
		pvData[vehicleid][cMod][6],
		pvData[vehicleid][cMod][7],
		pvData[vehicleid][cMod][8],
		pvData[vehicleid][cMod][9],
		pvData[vehicleid][cMod][10],
		pvData[vehicleid][cMod][11],
		pvData[vehicleid][cMod][12],
		pvData[vehicleid][cMod][13],
		pvData[vehicleid][cMod][14],
		pvData[vehicleid][cMod][15],
		pvData[vehicleid][cMod][16],
		pvData[vehicleid][cLumber],
		pvData[vehicleid][cMetal],
		pvData[vehicleid][cCoal],
		pvData[vehicleid][cProduct],
		pvData[vehicleid][cGasOil],
		pvData[vehicleid][cBox],
		pvData[vehicleid][cRent],
		pvData[vehicleid][cPark],
		pvData[vehicleid][cStolen],
		pvData[vehicleid][cAyamhidup],
		pvData[vehicleid][cTrunk],
		pvData[vehicleid][cID]	
	);
	return mysql_tquery(g_SQL, cQuery);	
}

function EngineStatus(playerid, vehicleid)
{
	if(!GetEngineStatus(vehicleid))
	{
		foreach(new ii : PVehicles)
		{
			if(vehicleid == pvData[ii][cVeh])
			{
				if(pvData[ii][cTicket] >= 2000)
					return Error(playerid, "Kendaraan ini sudah ditilang oleh Polisi! /v insu - untuk memeriksa");
			}
		}
		new Float: f_vHealth;
		GetVehicleHealth(vehicleid, f_vHealth);
		if(f_vHealth < 350.0) return Error(playerid, "Kendaraan tidak dapat Menyala, Sudah rusak!");
		if(GetVehicleFuel(vehicleid) <= 0.0) return Error(playerid, "Kendaraan tidak dapat Menyala, Bensin habis!");

		new rand = random(3);
		if(rand == 0)
		{
		    new strings[640];
			SwitchVehicleEngine(vehicleid, true);
			format(strings, sizeof(strings), "ENGINE : ON");
			PlayerTextDrawSetString(playerid, VEHFIVEM[playerid][0], strings);
		}
		if(rand == 1)
		{
			new strings[640];
			SwitchVehicleEngine(vehicleid, true);
			format(strings, sizeof(strings), "ENGINE : ON");
			PlayerTextDrawSetString(playerid, VEHFIVEM[playerid][0], strings);
		}
		if(rand == 2)
		{
			new strings[640];
			SwitchVehicleEngine(vehicleid, true);
			format(strings, sizeof(strings), "ENGINE : ON");
			PlayerTextDrawSetString(playerid, VEHFIVEM[playerid][0], strings);
		}
	}
	else
	{
		//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mematikan mesin kendaraan %s.", ReturnName(playerid, 0), GetVehicleNameByVehicle(GetPlayerVehicleID(playerid)));
		SwitchVehicleEngine(vehicleid, false);
		//Info(playerid, "Engine turn off..");
		new strings[640];
		format(strings, sizeof(strings), "ENGINE : OFF");
		PlayerTextDrawSetString(playerid, VEHFIVEM[playerid][0], strings);
	}
	return 1;
}

function RemovePlayerVehicle(playerid)
{
	foreach(new i : PVehicles)
	{
		if(pvData[i][cOwner] == pData[playerid][pID])
		{
			Vehicle_GetStatus(i);
			new cQuery[2248]/*, color1, color2, paintjob*/;
			pvData[i][cOwner] = -1;
			//GetVehicleColor(pvData[i][cVeh], color1, color2);
			//paintjob = GetVehiclePaintjob(pvData[i][cVeh]);
			//pvData[i][VehicleOwned] = false;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE `vehicle` SET ");
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`x`='%f', ", cQuery, pvData[i][cPosX]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`y`='%f', ", cQuery, pvData[i][cPosY]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`z`='%f', ", cQuery, pvData[i][cPosZ]+0.1);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`a`='%f', ", cQuery, pvData[i][cPosA]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`health`='%f', ", cQuery, pvData[i][cHealth]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`fuel`=%d, ", cQuery, pvData[i][cFuel]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`interior`=%d, ", cQuery, pvData[i][cInt]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`price`=%d, ", cQuery, pvData[i][cPrice]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`vw`=%d, ", cQuery, pvData[i][cVw]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`model`=%d, ", cQuery, pvData[i][cModel]);
			if(pvData[i][cLocked] == 1)
				mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`locked`=1, ", cQuery);
			else
				mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`locked`=0, ", cQuery);
			/*if(pvData[i][VehicleAlarm])
				mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`alarm` = 1, ", cQuery);
			else
				mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`alarm` = 0, ", cQuery);*/
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`insu`='%d', ", cQuery, pvData[i][cInsu]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`claim`='%d', ", cQuery, pvData[i][cClaim]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`claim_time`='%d', ", cQuery, pvData[i][cClaimTime]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`plate`='%e', ", cQuery, pvData[i][cPlate]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`plate_time`='%d', ", cQuery, pvData[i][cPlateTime]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`ticket`='%d', ", cQuery, pvData[i][cTicket]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`color1`=%d, ", cQuery, pvData[i][cColor1]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`color2`=%d, ", cQuery, pvData[i][cColor2]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`paintjob`=%d, ", cQuery, pvData[i][cPaintJob]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`neon`=%d, ", cQuery, pvData[i][cNeon]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`kandang`=%d, ", cQuery, pvData[i][cKandang]);
			new tempString[56];
			for(new z = 0; z < 17; z++)
			{
				format(tempString, sizeof(tempString), "mod%d", z);
				mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`%s`=%d, ", cQuery, tempString, pvData[i][cMod][z]);
			}
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`lumber`=%d, ", cQuery, pvData[i][cLumber]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`metal`=%d, ", cQuery, pvData[i][cMetal]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`coal`=%d, ", cQuery, pvData[i][cCoal]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`product`=%d,", cQuery, pvData[i][cProduct]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`gasoil`=%d,", cQuery, pvData[i][cGasOil]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`box`=%d, ", cQuery, pvData[i][cBox]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`park`=%d,", cQuery, pvData[i][cPark]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`broken`=%d,", cQuery, pvData[i][cStolen]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`rental`=%d,", cQuery, pvData[i][cRent]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`trunk`=%d ", cQuery, pvData[i][cTrunk]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%sWHERE `id` = %d", cQuery, pvData[i][cID]);
			mysql_query(g_SQL, cQuery, true);

			if(pvData[i][cNeon] != 0)
			{
				SetVehicleNeonLights(pvData[i][cVeh], false, pvData[i][cNeon], 0);
			}
			/*if(IsAPickup(pvData[i][cVeh]))
			{
				for(new a; a < LUMBER_LIMIT; a++)
				{
					if(IsValidDynamicObject(LumberObjects[pvData[i][cVeh]][a]))
					{
						DestroyDynamicObject(LumberObjects[pvData[i][cVeh]][a]);
						LumberObjects[pvData[i][cVeh]][a] = -1;
					}
				}
			}*/
			if(pvData[i][cVeh] != 0)
			{
				DisableVehicleSpeedCap(GetPlayerVehicleID(playerid));
				if(IsValidVehicle(pvData[i][cVeh])) DestroyVehicle(pvData[i][cVeh]);
				pvData[i][cVeh] = INVALID_VEHICLE_ID;
			}
			Iter_SafeRemove(PVehicles, i, i);
		}
	}
	return 1;
}

function OnVehCreated(playerid, oid, pid, model, color1, color2, Float:x, Float:y, Float:z, Float:a)
{
	new i = Iter_Free(PVehicles);
	new price = GetVehicleCost(model);
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cPrice] = price;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "NoHave");
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cMetal] = 0;
	pvData[i][cCoal] = 0;
	pvData[i][cProduct] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cBox] = 0;
	pvData[i][cRent] = 0;
	pvData[i][cPark] = -1;
	pvData[i][cStolen] = 0;
	for(new j = 0; j < 17; j++)
		pvData[i][cMod][j] = 0;
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Anda telah membuat kendaraan kepada %s dengan (model=%d, color1=%d, color2=%d)", pData[oid][pName], model, color1, color2);
	new str[150];
	format(str,sizeof(str),"[Vehicle]: %s membuat kendaraan id %d ke %s!", GetRPName(playerid), model, GetRPName(oid));
	LogServer("Admin", str);
	return 1;
}

function OnRentalVeh(playerid, pid, model, color1, color2, Float:x, Float:y, Float:z, Float:a, rental)
{
	new i = Iter_Free(PVehicles);
	new price = GetVehicleCost(model);
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cPrice] = price;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "NoHave");
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cMetal] = 0;
	pvData[i][cCoal] = 0;
	pvData[i][cProduct] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cBox] = 0;
	pvData[i][cRent] = rental;
	pvData[i][cPark] = -1;
	pvData[i][cStolen] = 0;
	for(new j = 0; j < 17; j++)
		pvData[i][cMod][j] = 0;
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Anda merental kendaraan (model=%d, color1=%d, color2=%d)", model, color1, color2);
	new str[150];
	/*format(str,sizeof(str),"[Vehicle]: %s membuat kendaraan id %d ke %s!", GetRPName(playerid), model, GetRPName(oid));
	LogServer("Admin", str);*/
	return 1;
}
function OnVehStarterpack(playerid, pid, model, color1, color2, Float:x, Float:y, Float:z, Float:a)
{
	new i = Iter_Free(PVehicles);
	new price = GetVehicleCost(model);
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cPrice] = price;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "NoHave");
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x + 2;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cMetal] = 0;
	pvData[i][cCoal] = 0;
	pvData[i][cProduct] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cBox] = 0;
	pvData[i][cRent] = 0;
	pvData[i][cPark] = -1;
	pvData[i][cStolen] = 0;
	for(new j = 0; j < 17; j++)
		pvData[i][cMod][j] = 0;
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Kamu telah mengambil Startepack kota, 1 Faggio & $500");
	return 1;
}

function OnVehKompensasi(playerid, pid, model, color1, color2, Float:x, Float:y, Float:z, Float:a)
{
	new i = Iter_Free(PVehicles);
	new price = GetVehicleCost(model);
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cPrice] = price;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "NoHave");
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x + 2;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cMetal] = 0;
	pvData[i][cCoal] = 0;
	pvData[i][cProduct] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cBox] = 0;
	pvData[i][cRent] = 0;
	pvData[i][cPark] = -1;
	pvData[i][cStolen] = 0;
	for(new j = 0; j < 17; j++)
		pvData[i][cMod][j] = 0;
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Kamu telah mengambil Bonus kota, 1 Faggio & $3000");
	return 1;
}

function OnVehBuyPV(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a)
{
	new i = Iter_Free(PVehicles);
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "NoHave");
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cMetal] = 0;
	pvData[i][cCoal] = 0;
	pvData[i][cProduct] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cBox] = 0;
	pvData[i][cRent] = 0;
	pvData[i][cPark] = -1;
	pvData[i][cStolen] = 0;
	for(new j = 0; j < 17; j++)
		pvData[i][cMod][j] = 0;
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Anda telah membeli kendaraan seharga %s dengan model %s(%d)", FormatMoney(GetVehicleCost(model)), GetVehicleModelName(model), model);
	new str[150];
	format(str,sizeof(str),"[VEH]: %s membeli kendaraan seharga %s model %s(%d)!", GetRPName(playerid), FormatMoney(GetVehicleCost(model)), GetVehicleModelName(model), model);
	LogServer("Property", str);
	pData[playerid][pBuyPvModel] = 0;
	return 1;
}

function OnVehBuyVIPPV(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a)
{
	new i = Iter_Free(PVehicles);
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "NoHave");
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cMetal] = 0;
	pvData[i][cCoal] = 0;
	pvData[i][cProduct] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cBox] = 0;
	pvData[i][cRent] = 0;
	pvData[i][cPark] = -1;
	pvData[i][cStolen] = 0;
	for(new j = 0; j < 17; j++)
		pvData[i][cMod][j] = 0;
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Anda telah membeli kendaraan VIP seharga %d gold dengan model %s(%d)", GetVipVehicleCost(model), GetVehicleModelName(model), model);
	new str[150];
	format(str,sizeof(str),"[VEH]: %s membeli kendaraan VIP seharga %d gold model %s(%d)!", GetRPName(playerid), GetVehicleCost(model), GetVehicleModelName(model), model);
	LogServer("Property", str);
	return 1;
}

function OnVehRentPV(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a, rental)
{
	new i = Iter_Free(PVehicles);
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "NoHave");
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cMetal] = 0;
	pvData[i][cCoal] = 0;
	pvData[i][cProduct] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cBox] = 0;
	pvData[i][cRent] = rental;
	pvData[i][cPark] = -1;
	pvData[i][cStolen] = 0;
	for(new j = 0; j < 17; j++)
		pvData[i][cMod][j] = 0;
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Anda telah menyewa kendaraan seharga $500 / one days dengan model %s(%d)", GetVehicleModelName(model), model);
	new str[150];
	format(str,sizeof(str),"[VEH]: %s menyewa kendaraan seharga $500 /one days model %s(%d)!", GetRPName(playerid), GetVehicleModelName(model), model);
	LogServer("Property", str);
	pData[playerid][pBuyPvModel] = 0;
	return 1;
}

function OnVehKandangPV(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a, rental)
{
	new i = Iter_Free(PVehicles);
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cKandang] = 1;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "NoHave");
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cMetal] = 0;
	pvData[i][cCoal] = 0;
	pvData[i][cProduct] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cBox] = 0;
	pvData[i][cRent] = rental;
	pvData[i][cPark] = -1;
	pvData[i][cStolen] = 0;
	for(new j = 0; j < 17; j++)
		pvData[i][cMod][j] = 0;
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Anda telah menyewa kendaraan seharga $500 / one days dengan model %s(%d)", GetVehicleModelName(model), model);
	new str[150];
	format(str,sizeof(str),"[VEH]: %s menyewa kendaraan seharga $500 /one days model %s(%d)!", GetRPName(playerid), GetVehicleModelName(model), model);
	LogServer("Property", str);
	pData[playerid][pBuyPvModel] = 0;
	return 1;
}
function OnVehRentBike(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a, rental)
{
	new i = Iter_Free(PVehicles);
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "NoHave");
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cMetal] = 0;
	pvData[i][cCoal] = 0;
	pvData[i][cProduct] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cBox] = 0;
	pvData[i][cRent] = rental;
	pvData[i][cPark] = -1;
	pvData[i][cStolen] = 0;
	for(new j = 0; j < 17; j++)
		pvData[i][cMod][j] = 0;
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Kamu telah menyewa kendaraan seharga %s /one days dengan model %s(%d)", FormatMoney(GetVehicleRentalCost(model)), GetVehicleModelName(model), model);
	pData[playerid][pBuyPvModel] = 0;
	new str[150];
	format(str,sizeof(str),"[VEH]: %s menyewa kendaraan seharga %s /one days model %s(%d)!", GetRPName(playerid), FormatMoney(GetVehicleCost(model)), GetVehicleModelName(model), model);
	LogServer("Property", str);
	return 1;
}

function OnVehRentBoat(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a, rental)
{
	new i = Iter_Free(PVehicles);
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 100;
	format(pvData[i][cPlate], 16, "NoHave");
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cMetal] = 0;
	pvData[i][cCoal] = 0;
	pvData[i][cProduct] = 0;
	pvData[i][cGasOil] = 0;
	pvData[i][cBox] = 0;
	pvData[i][cRent] = rental;
	pvData[i][cPark] = -1;
	pvData[i][cStolen] = 0;
	for(new j = 0; j < 17; j++)
		pvData[i][cMod][j] = 0;
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Kamu telah menyewa kapal seharga %s /one days dengan model %s(%d)", FormatMoney(GetVehicleRentalCost(model)), GetVehicleModelName(model), model);
	new str[150];
	format(str,sizeof(str),"[VEH]: %s menyewa kapal seharga %s /one days model %s(%d)!", GetRPName(playerid), FormatMoney(GetVehicleCost(model)), GetVehicleModelName(model), model);
	LogServer("Property", str);
	pData[playerid][pBuyPvModel] = 0;
	return 1;
}

function RespawnPV(vehicleid)
{
	SetVehicleToRespawn(vehicleid);
	SetValidVehicleHealth(vehicleid, 1000);
	SetVehicleFuel(vehicleid, 100);
	return 1;
}

/*GetVehicleStorage(vehicleid, item)
{
	static const StorageLimit[][] = {
	   //Snack  Sprunk  Medicine  Medkit  Bandage  Seed  Material  Component  Marijuana
	    {30,    30,     50,  	  5,  	  10,  	   500,  500,  	   500, 	 250}
	};

	return StorageLimit[pvData[vehicleid][cTrunk] - 1][item];
}*/

enum e_pvtoy_data
{
vtoy_modelid,
vtoy_model,
Float:vtoy_x,
Float:vtoy_y,
Float:vtoy_z,
Float:vtoy_rx,
Float:vtoy_ry,
Float:vtoy_rz
}
new vtData[MAX_PRIVATE_VEHICLE][6][e_pvtoy_data];


// Private Vehicle Player System Commands


CMD:kandang(playerid, params[])
{
    	new carid = -1,
					found = 0;

	if((carid = Vehicle_Nearest2(playerid)) != -1)
	{
	    if(pvData[carid][cKandang] == 1)
	    {
	        pvData[carid][cTogkandang] = 1;
			    Kandang[pvData[carid][cVeh]] = CreateDynamicObject(925,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
	    		AttachDynamicObjectToVehicle(Kandang[pvData[carid][cVeh]], pvData[carid][cVeh], 0.000, -1.500, 1.099, 0.000, 0.000, 0.000);
	    		SuccesMsg(playerid, "Memasang kandang ayam pada mobil");
		}
		else
		{
		    ErrorMsg(playerid, "Mobil kamu tidak mempunyai fitur kandang");
		}
	}

}

CMD:aeject(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return Error(playerid, "Anda bukan Admin!");

	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new otherid;
		if(sscanf(params, "u", otherid))
			return Usage(playerid, "/aeject [playerid id/name]");

		if(IsPlayerInVehicle(otherid, vehicleid))
		{
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah menendang %s dari kendaraannya.", ReturnName(playerid));
			Servers(otherid, "{ff0000}%s {ffffff}telah menendang anda dari kendaraan", pData[playerid][pAdminname]);
			RemovePlayerFromVehicle(otherid);
		}
		else
		{
			Error(otherid, "Player/Target tidak berada didalam Kendaraan");
		}
	}
	else
	{
		Error(playerid, "Anda tidak berada didalam kendaraan");
	}
	return 1;
}

CMD:limitspeed(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new Float:speed;
		if(sscanf(params, "f", speed))
			return Usage(playerid, "/limitspeed [speed - 0 to disable]");

		if(speed > 0.0)
		{
			Info(playerid, "Set Vehicle Limit Speed to %f", speed);
			SetVehicleSpeedCap(GetPlayerVehicleID(playerid), speed);
		}
		else if(speed < 1.0)
		{
			Info(playerid, "You disable this Vehicle Speed");
			DisableVehicleSpeedCap(GetPlayerVehicleID(playerid));
		}
	}
	return 1;
}

CMD:eject(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new otherid;
		if(sscanf(params, "u", otherid))
			return Usage(playerid, "/eject [playerid id/name]");

		if(IsPlayerInVehicle(otherid, vehicleid))
		{
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah menendang %s dari kendaraannya.", ReturnName(playerid), ReturnName(otherid));
			Servers(otherid, "%s telah menendang anda dari kendaraan", pData[playerid][pName]);
			RemovePlayerFromVehicle(otherid);
		}
		else
		{
			Error(otherid, "Player/Target tidak berada didalam Kendaraan");
		}
	}
	else
	{
		Error(playerid, "Anda tidak berada didalam kendaraan");
	}
	return 1;
}

CMD:unimpound(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -710.501281, 2605.660156, 1006.108398) && !IsPlayerInRangeOfPoint(playerid, 3.0, -1469.6188, 2600.2039, 19.6310))
	   return Error(playerid, "You're not at LSPD Unimpound point!");

    ShowImpoundedVehicle(playerid);
    return 1;
}

CMD:impound(playerid, params[])
{
	new
		price,
		vehicleid = GetPlayerVehicleID(playerid);

    if (pData[playerid][pFaction] != 1)
		return Error(playerid, "You must be a police officer.");

    if (sscanf(params, "d", price))
        return SendSyntaxMessage(playerid, "/impound [price]");

	if (price < 1 || price > 1000)
	    return Error(playerid, "The price can't be above $1,000 or below $1.");

	if (GetVehicleModel(vehicleid) != 525)
	    return Error(playerid, "You are not driving a tow truck.");

	if (!IsPlayerInRangeOfPoint(playerid, 7.0, 1273.339843, -1667.482543, 13.589))
		return Error(playerid, "You are not in range of impound point.");

 	vehicleid = Vehicle_GetID(GetVehicleTrailer(vehicleid));

	if (vehicleid == -1)
	    return Error(playerid, "You can't tow this vehicle.");

	pvData[vehicleid][cImpounded] = 1;
	pvData[vehicleid][cImpoundPrice] = price;

    Vehicle_GetStatus(vehicleid);

    new zquery[64];
	format(zquery, 64, "DELETE FROM `trunk` WHERE `ID` = '%d'", pvData[vehicleid][cID]);
	mysql_tquery(g_SQL, zquery);

	if(IsValidVehicle(pvData[vehicleid][cVeh]))
		DestroyVehicle(pvData[vehicleid][cVeh]);

	pvData[vehicleid][cVeh] = 0;

	SendFactionMessage(1, COLOR_RADIO, "DISPATCH: %s has impounded a %s for %s.", ReturnName(playerid), GetVehicleModelName(pvData[vehicleid][cModel]), FormatMoney(price));
 	DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));

	return 1;
}

CMD:createpv(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new model, color1, color2, otherid;
	if(sscanf(params, "uddd", otherid, model, color1, color2)) return Usage(playerid, "/createpv [name/playerid] [model] [color1] [color2]");

	if(color1 < 0 || color1 > 255) { Error(playerid, "Color Number can't be below 0 or above 255 !"); return 1; }
	if(color2 < 0 || color2 > 255) { Error(playerid, "Color Number can't be below 0 or above 255 !"); return 1; }
	if(model < 400 || model > 611) { Error(playerid, "Vehicle Number can't be below 400 or above 611 !"); return 1; }
	if(otherid == INVALID_PLAYER_ID) return Error(playerid, "Invalid player ID!");
	new count = 0, limit = MAX_PLAYER_VEHICLE + pData[otherid][pVip];
	foreach(new ii : PVehicles)
	{
		if(pvData[ii][cOwner] == pData[otherid][pID])
			count++;
	}
	if(count >= limit)
	{
		Error(playerid, "This player have too many vehicles, sell a vehicle first!");
		return 1;
	}
	new cQuery[1024];
	new Float:x,Float:y,Float:z, Float:a;
	GetPlayerPos(otherid,x,y,z);
	GetPlayerFacingAngle(otherid,a);
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[otherid][pID], model, color1, color2, x, y, z, a);
	mysql_tquery(g_SQL, cQuery, "OnVehCreated", "ddddddffff", playerid, otherid, pData[otherid][pID], model, color1, color2, x, y, z, a);
	return 1;
}

CMD:deletepv(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new vehid;
	if(sscanf(params, "d", vehid)) return Usage(playerid, "/deletepv [vehid] | /apv - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");

	foreach(new i : PVehicles)			
	{
		if(vehid == pvData[i][cVeh])
		{
			Servers(playerid, "Your deleted private vehicle id %d (database id: %d).", vehid, pvData[i][cID]);
			new str[150];
			format(str,sizeof(str),"[VEH]: %s menghapus kendaraan id %d (database id: %d)!", GetRPName(playerid), vehid, pvData[i][cID]);
			LogServer("Admin", str);
			new query[128], xuery[128];
			mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[i][cID]);
			mysql_tquery(g_SQL, query);

			mysql_format(g_SQL, xuery, sizeof(xuery), "DELETE FROM vstorage WHERE owner = '%d'", pvData[i][cID]);
			mysql_tquery(g_SQL, xuery);
			pvData[pvData[i][cVeh]][LoadedStorage] = false;

			if(IsValidVehicle(pvData[i][cVeh])) DestroyVehicle(pvData[i][cVeh]);
			pvData[i][cVeh] = INVALID_VEHICLE_ID;
			Iter_SafeRemove(PVehicles, i, i);
		}
	}
	return 1;
}

/*CMD:deletepv(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	new otherid;
	if(sscanf(params, "u", otherid)) return Usage(playerid, "/gotopv [name/playerid]");
	if(otherid == INVALID_PLAYER_ID) return Error(playerid, "Invalid playerid");
	
	new bool:found = false, msg2[512], Float:fx, Float:fy, Float:fz;
	format(msg2, sizeof(msg2), "ID\tModel\tLocation\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cOwner] == pData[otherid][pID])
		{
			GetVehiclePos(pvData[i][cVeh], fx, fy, fz);
			format(msg2, sizeof(msg2), "%s%d\t%s\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), GetLocation(fx, fy, fz));
			found = true;
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_DELETEVEH, DIALOG_STYLE_TABLIST_HEADERS, "Delete Vehicles", msg2, "Delete", "Close");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles", "Player ini tidak memeliki kendaraan", "Close", "");
			
	return 1;
}

CMD:gotopv(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	new otherid;
	if(sscanf(params, "u", otherid)) return Usage(playerid, "/gotopv [name/playerid]");
	if(otherid == INVALID_PLAYER_ID) return Error(playerid, "Invalid playerid");
	
	new bool:found = false, msg2[512], Float:fx, Float:fy, Float:fz;
	format(msg2, sizeof(msg2), "ID\tModel\tLocation\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cOwner] == pData[otherid][pID])
		{
			GetVehiclePos(pvData[i][cVeh], fx, fy, fz);
			format(msg2, sizeof(msg2), "%s%d\t%s\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), GetLocation(fx, fy, fz));
			found = true;
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_GOTOVEH, DIALOG_STYLE_TABLIST_HEADERS, "Goto Vehicles", msg2, "Goto", "Close");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles", "Player ini tidak memeliki kendaraan", "Close", "");
			
	return 1;
}

CMD:getpv(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	new otherid;
	if(sscanf(params, "u", otherid)) return Usage(playerid, "/getpv [name/playerid]");
	if(otherid == INVALID_PLAYER_ID) return Error(playerid, "Invalid playerid");
	
	new bool:found = false, msg2[512], Float:fx, Float:fy, Float:fz;
	format(msg2, sizeof(msg2), "ID\tModel\tLocation\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cOwner] == pData[otherid][pID])
		{
			GetVehiclePos(pvData[i][cVeh], fx, fy, fz);
			format(msg2, sizeof(msg2), "%s%d\t%s\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), GetLocation(fx, fy, fz));
			found = true;
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_GETVEH, DIALOG_STYLE_TABLIST_HEADERS, "Get Vehicles", msg2, "Get", "Close");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles", "Player ini tidak memeliki kendaraan", "Close", "");
			
	return 1;
}*/

	CMD:pvlist(playerid, params[])
	{
		if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);

		new count = 0, created = 0;
		foreach(new i : PVehicles)
		{
			count++;
			if(IsValidVehicle(pvData[i][cVeh]))
			{
				created++;
			}
		}
		Info(playerid, "Foreach total: %d, Created: %d", count, created);
		return 1;
	}

	CMD:ainsu(playerid, params[])
	{
		if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);

		new otherid;
		if(sscanf(params, "u", otherid)) return Usage(playerid, "/ainsu [name/playerid]");
		if(otherid == INVALID_PLAYER_ID || !IsPlayerConnected(otherid)) return Error(playerid, "Invalid playerid");

		new bool:found = false, msg2[512];
		format(msg2, sizeof(msg2), "ID\tInsurance\tClaim Time\tTicket\n");
		foreach(new i : PVehicles)
		{
			if(pvData[i][cOwner] == pData[otherid][pID])
			{
				if(pvData[i][cClaimTime] != 0)
				{
					format(msg2, sizeof(msg2), "%s\t%d\t%s - %d\t%s\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh], pvData[i][cInsu], ReturnTimelapse(gettime(), pvData[i][cClaimTime]), FormatMoney(pvData[i][cTicket]));
					found = true;
				}
				else
				{
					format(msg2, sizeof(msg2), "%s\t%d\t%s - %d\tClaimed\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh], pvData[i][cInsu], FormatMoney(pvData[i][cTicket]));
					found = true;
				}
			}
		}
		if(found)
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Insurance Vehicles", msg2, "Close", "");
		else
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles", "Player tidak memeliki kendaraan", "Close", "");
		return 1;
	}
	//Cek Kendaraan Player
	CMD:apv(playerid, params[])
	{
		if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);

		new otherid;
		if(sscanf(params, "u", otherid)) return Usage(playerid, "/apv [name/playerid]");
		if(otherid == INVALID_PLAYER_ID) return Error(playerid, "Invalid playerid");

		new bool:found = false, msg2[512];
		format(msg2, sizeof(msg2), "ID\tModel\tPlate Time\tRental\n");
		foreach(new i : PVehicles)
		{
			if(IsValidVehicle(pvData[i][cVeh]))
			{
				if(pvData[i][cOwner] == pData[otherid][pID])
				{
					if(strcmp(pvData[i][cPlate], "NoHave"))
					{
						if(pvData[i][cRent] != 0)
						{
							format(msg2, sizeof(msg2), "%s%d\t%s(id: %d)\t%s(%s)\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh], pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]), ReturnTimelapse(gettime(), pvData[i][cRent]));
							found = true;
						}
						else
						{
							format(msg2, sizeof(msg2), "%s%d\t%s(id: %d)\t%s(%s)\tOwned\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh], pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]));
							found = true;
						}
					}
					else
					{
						if(pvData[i][cRent] != 0)
						{
							format(msg2, sizeof(msg2), "%s%d\t%s(id: %d)\t%s(None)\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh], pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cRent]));
							found = true;
						}
						else
						{
							format(msg2, sizeof(msg2), "%s%d\t%s(id: %d)\t%s(None)\tOwned\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh], pvData[i][cPlate]);
							found = true;
						}
					}
				}
			}
		}
		if(found)
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Player Vehicles", msg2, "Close", "");
		else
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles", "Player ini tidak memeliki kendaraan", "Close", "");
		
	/*new bool:found = false, msg2[512], Float:fx, Float:fy, Float:fz;
	format(msg2, sizeof(msg2), "ID\tModel\tPlate\tPlate Time\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cOwner] == pData[otherid][pID])
		{
			if(strcmp(pvData[i][cPlate], "NoHave"))
			{
				GetVehiclePos(pvData[i][cVeh], fx, fy, fz);
				format(msg2, sizeof(msg2), "%s%d\t%s(id: %d)\t%s\t%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh], pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]));
				found = true;
			}
			else
			{
				GetVehiclePos(pvData[i][cVeh], fx, fy, fz);
				format(msg2, sizeof(msg2), "%s%d\t%s(id: %d)\t%s\tNone\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh], pvData[i][cPlate]);
				found = true;
			}
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Vehicles Plate", msg2, "Close", "");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles Plate", "Anda tidak memeliki kendaraan", "Close", "");*/
		return 1;
}

CMD:aveh(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0, false);

	if(vehicleid == INVALID_VEHICLE_ID)
		return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
	
	Servers(playerid, "Vehicle ID near on you id: %d (Model: %s(%d))", vehicleid, GetVehicleName(vehicleid), GetVehicleModel(vehicleid));
	return 1;
}

forward Carbobol(playerid, vid);
public Carbobol(playerid, vid)
{
    foreach(new i : PVehicles)
	{
		if(vid == pvData[i][cVeh])
		{
				new nearid = GetNearestVehicleToPlayer(playerid, 5.0, false);
				if(vid == nearid)
				{
					new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
					if(pvData[i][cRent] != 0) return Error(playerid, "You can't give rental vehicle!");
					foreach(new ii : PVehicles)
					{
						if(pvData[ii][cOwner] == pData[playerid][pID])
							count++;
					}

					pvData[i][cOwner] = pData[playerid][pID];
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "UPDATE vehicle SET owner='%d' WHERE id='%d'", pData[playerid][pID], pvData[i][cID]);
					mysql_tquery(g_SQL, query);
					return 1;
				}
				else return Error(playerid, "Anda harus berada di dekat kendaraan yang anda curi!");
		}
	}
	pData[playerid][pCarbobol] = INVALID_VEHICLE_ID;
		    KillTimer(TimerLoading[playerid]);
			LoadingPlayerBar[playerid] = 0;
			HideProgressBar(playerid);
			SetTimerEx(ProgressTimer[playerid], 300, false, "d", playerid);
			TogglePlayerControllable(playerid, 1);
			pData[playerid][pProsesbobol] = 0;
			KillTimer(pData[playerid][pTimerbobol]);
}
CMD:bobolkendaraan(playerid, params[])
{
	if(Inventory_Count(playerid, "Lockpick") < 1) return ErrorMsg(playerid, "Lu gada lockpick");
	
	new vid = GetNearestVehicleToPlayer(playerid, 5.0, false);

	if(vid == INVALID_VEHICLE_ID)
		return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
	
	foreach(new i : Player)
	{
		SendClientMessageEx(i, -1, "Terjadi pencurian kendaraan %s id: %d, cek /mypv apakah itu kendaraan mu", GetVehicleName(vid), vid);
	}
	new dc[1000];
				format(dc, sizeof(dc),  "**%s Mencuri kendaraan Ucp: %s**", pData[playerid][pName], pData[playerid][pUCP]);
				SendDiscordMessage(15, dc);
	pData[playerid][pCarbobol] = vid;
	pData[playerid][pProsesbobol] = 1;
	ShowProgressbar(playerid, "Membobol kendaraan...", 180);
	pData[playerid][pTimerbobol] = SetTimerEx("Carbobol", 180000, false, "dd", playerid, vid);
	Inventory_Remove(playerid, "Lockpick", 1);
}

CMD:sendveh(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);
	
	new otherid, vehid, Float:x, Float:y, Float:z;
	if(sscanf(params, "ud", otherid, vehid)) return Usage(playerid, "/sendveh [playerid/name] [vehid] | /apv - for find vehid");
	
	if(!IsPlayerConnected(otherid)) return Error(playerid, "Player id not online!");
	if(!IsValidVehicle(vehid)) return Error(playerid, "Invalid veh id");
	
	GetPlayerPos(otherid, x, y, z);
	SetVehiclePos(vehid, x, y, z+0.5);
	SetVehicleVirtualWorld(vehid, GetPlayerVirtualWorld(otherid));
	LinkVehicleToInterior(vehid, GetPlayerInterior(otherid));
	Servers(playerid, "Your has send vehicle id %d to player %s(%d) | Location: %s.", vehid, pData[otherid][pName], otherid, GetLocation(x, y, z));
	return 1;
}

CMD:getveh(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new vehid, Float:posisiX, Float:posisiY, Float:posisiZ;
	if(sscanf(params, "d", vehid)) return Usage(playerid, "/getveh [vehid] | /apv - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");
	if(!IsValidVehicle(vehid)) return Error(playerid, "Invalid veh id");
	GetPlayerPos(playerid, posisiX, posisiY, posisiZ);
	Servers(playerid, "Your get spawn vehicle to %s (vehicle id: %d).", GetLocation(posisiX, posisiY, posisiZ), vehid);
	SetVehiclePos(vehid, posisiX, posisiY, posisiZ+0.5);
	SetVehicleVirtualWorld(vehid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(vehid, GetPlayerInterior(playerid));
	return 1;
}

CMD:gotoveh(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new vehid, Float:posisiX, Float:posisiY, Float:posisiZ;
	if(sscanf(params, "d", vehid)) return Usage(playerid, "/gotoveh [vehid] | /apv - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");
	if(!IsValidVehicle(vehid)) return Error(playerid, "Invalid id");
	
	GetVehiclePos(vehid, posisiX, posisiY, posisiZ);
	Servers(playerid, "Your teleport to %s (vehicle id: %d).", GetLocation(posisiX, posisiY, posisiZ), vehid);
	SetPlayerPosition(playerid, posisiX, posisiY, posisiZ+3.0, 4.0, 0);
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInFamily] = -1;	
	return 1;
}

CMD:respawnveh(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new vehid, Float:posisiX, Float:posisiY, Float:posisiZ;
	if(sscanf(params, "d", vehid)) return Usage(playerid, "/respawnveh [vehid] | /apv - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");
	if(!IsValidVehicle(vehid)) return Error(playerid, "Invalid id");
	GetVehiclePos(vehid, posisiX, posisiY, posisiZ);
	if(IsVehicleEmpty(vehid))
	{
		SetTimerEx("RespawnPV", 3000, false, "d", vehid);
		Servers(playerid, "Your respawned vehicle location %s (vehicle id: %d).", GetLocation(posisiX, posisiY, posisiZ), vehid);
		new str[150];
		format(str,sizeof(str),"[VEH]: %s merespawn kendaraan id %d lokasi di %s!", GetRPName(playerid), vehid, GetLocation(posisiX, posisiY, posisiZ));
		LogServer("Admin", str);
	}
	else Error(playerid, "This Vehicle in used by someone.");
	return 1;
}

CMD:mypv(playerid, params[])
{
	if(!GetOwnedVeh(playerid)) return Error(playerid, "You don't have any Vehicle.");
	new vid, _tmpstring[128], count = GetOwnedVeh(playerid), CMDSString[512], status[30], status1[30];
	CMDSString = "";
	strcat(CMDSString,"No\tName\tPlate\tStatus\n",sizeof(CMDSString));
	Loop(itt, (count + 1), 1)
	{
		vid = ReturnPlayerVehID(playerid, itt);
		if(pvData[vid][cPark] != -1)
		{
			status = "{3BBD44}Parked";
		}
		else if(pvData[vid][cClaim] != 0)
		{
			status = "{D2D2AB}Insurance";
		}
		else if(pvData[vid][cStolen] != 0)
		{
			status = "{DB881A}Rusak";
		}
		else
		{
			status = "{FFFF00}Spawned";
		}
		
		if(pvData[vid][cRent] != 0)
		{
			status1 = "{BABABA}(Rental)";
		}
		else 
		{
			status1 = "";
		}

		if(itt == count)
		{
			format(_tmpstring, sizeof(_tmpstring), "{ffffff}%d.\t%s%s{ffffff}\t%s\t%s\n", itt, GetVehicleModelName(pvData[vid][cModel]), status1, pvData[vid][cPlate], status);
		}
		else format(_tmpstring, sizeof(_tmpstring), "{ffffff}%d.\t%s%s{ffffff}\t%s\t%s\n", itt, GetVehicleModelName(pvData[vid][cModel]), status1, pvData[vid][cPlate], status);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_MYVEH, DIALOG_STYLE_TABLIST_HEADERS, "My Vehicle", CMDSString, "Select", "Cancel");
	return 1;
}

CMD:landing(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(IsPlayerInAnyVehicle(playerid))
	{
		if(!IsEngineVehicle(vehicleid))
			return Error(playerid, "Kamu tidak berada didalam kendaraan.");

			if(GetVehicleModel(vehicleid) != 519)
				return Error(playerid, "Khusus pesawat saaf");

				new Float:POS[3], otherid;
			//	pData[playerid][pTiket] -= 1;
				GetPlayerPos(playerid, POS[0], POS[1], POS[2]);
				SetPlayerPos(playerid, POS[0] + 2.0, POS[1], POS[2]);
	}
}

alias:engine("en")
CMD:engine(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new pvid;
	pvid = Vehicle_Inside(playerid);

	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(!IsEngineVehicle(vehicleid))
			return Error(playerid, "Kamu tidak berada didalam kendaraan.");
			
			if(GetVehicleModel(vehicleid) == 519)
				return Error(playerid, "Gunakan cmd /takeoff");

		if(GetEngineStatus(vehicleid))
		{
			EngineStatus(playerid, vehicleid);
			
		}
		else
		{
			//Info(playerid, "Anda mencoba menyalakan mesin kendaraan..");
			//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mencoba menghidupkan mesin kendaraan %s.", ReturnName(playerid, 0), GetVehicleNameByVehicle(GetPlayerVehicleID(playerid)));
			InfoTD_MSG(playerid, 4000, "Start Engine...");
		
			SetTimerEx("EngineStatus", 3000, false, "id", playerid, vehicleid);
		}
	}
	else return Error(playerid, "Anda harus mengendarai kendaraan!");
	return 1;
}

CMD:takeoff(playerid, carid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new pvid;
	pvid = Vehicle_Inside(playerid);

	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(!IsEngineVehicle(vehicleid))
			return Error(playerid, "Kamu tidak berada didalam kendaraan.");

		

		if(GetEngineStatus(vehicleid))
		{
			EngineStatus(playerid, vehicleid);
			foreach(new i: Player)
			{
					if(vehicleid == pesawat[0])
				    {
				    	if(IsPlayerInVehicle(i, pesawat[0]) && pData[i][pFaction] != 8)
				    	{
							pData[i][pTiket] -= 1;
						}
					}
					if(vehicleid == pesawat[1])
				    {
				    	if(IsPlayerInVehicle(i, pesawat[1]) && pData[i][pFaction] != 8)
				    	{
							pData[i][pTiket] -= 1;
						}
					}
					if(vehicleid == pesawat[2])
				    {
				    	if(IsPlayerInVehicle(i, pesawat[2]) && pData[i][pFaction] != 8)
				    	{
							pData[i][pTiket] -= 1;
						}
					}
					if(vehicleid == pesawat[3])
				    {
				    	if(IsPlayerInVehicle(i, pesawat[3]) && pData[i][pFaction] != 8)
				    	{
							pData[i][pTiket] -= 1;
						}
					}
					if(vehicleid == pesawat[4])
				    {
				    	if(IsPlayerInVehicle(i, pesawat[4]) && pData[i][pFaction] != 8)
				    	{
							pData[i][pTiket] -= 1;
						}
					}
					if(vehicleid == pesawat[5])
				    {
				    	if(IsPlayerInVehicle(i, pesawat[5]) && pData[i][pFaction] != 8)
				    	{
							pData[i][pTiket] -= 1;
						}
					}
					if(vehicleid == pesawat[6])
				    {
				    	if(IsPlayerInVehicle(i, pesawat[6]) && pData[i][pFaction] != 8)
				    	{
							pData[i][pTiket] -= 1;
						}
					}
					if(vehicleid == pesawat[7])
				    {
				    	if(IsPlayerInVehicle(i, pesawat[7]) && pData[i][pFaction] != 8)
				    	{
							pData[i][pTiket] -= 1;
						}
					}
					if(vehicleid == pesawat[8])
				    {
				    	if(IsPlayerInVehicle(i, pesawat[8]) && pData[i][pFaction] != 8)
				    	{
							pData[i][pTiket] -= 1;
						}
					}
					if(vehicleid == pesawat[9])
				    {
				    	if(IsPlayerInVehicle(i, pesawat[9]) && pData[i][pFaction] != 8)
				    	{
							pData[i][pTiket] -= 1;
						}
					}
					if(vehicleid == pesawat[10])
				    {
				    	if(IsPlayerInVehicle(i, pesawat[10]) && pData[i][pFaction] != 8)
				    	{
							pData[i][pTiket] -= 1;
						}
					}
					if(vehicleid == pesawat[11])
				    {
				    	if(IsPlayerInVehicle(i, pesawat[11]) && pData[i][pFaction] != 8)
				    	{
							pData[i][pTiket] -= 1;
						}
					}
					if(vehicleid == pesawat[12])
				    {
				    	if(IsPlayerInVehicle(i, pesawat[12]) && pData[i][pFaction] != 8)
				    	{
							pData[i][pTiket] -= 1;
						}
					}
   			}
		}
		else
		{
			//Info(playerid, "Anda mencoba menyalakan mesin kendaraan..");
			//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mencoba menghidupkan mesin kendaraan %s.", ReturnName(playerid, 0), GetVehicleNameByVehicle(GetPlayerVehicleID(playerid)));
			InfoTD_MSG(playerid, 4000, "Start Engine...");
			SetTimerEx("EngineStatus", 3000, false, "id", playerid, vehicleid);
		}
	}
	else return Error(playerid, "Anda harus mengendarai kendaraan!");
	return 1;
}
CMD:eng(playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new pvid;
	pvid = Vehicle_Inside(playerid);

	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(!IsEngineVehicle(vehicleid))
			return Error(playerid, "Kamu tidak berada didalam kendaraan.");

		if(pvid != -1 && !Vehicle_HaveAccess(playerid, pvid))
		return ShowMessage(playerid, "~r~ERROR: ~w~Kamu tidak memiliki akses kendaraan ini!", 2);

		if(GetEngineStatus(vehicleid))
		{
			EngineStatus(playerid, vehicleid);
		}
		else
		{
			//Info(playerid, "Anda mencoba menyalakan mesin kendaraan..");
			//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mencoba menghidupkan mesin kendaraan %s.", ReturnName(playerid, 0), GetVehicleNameByVehicle(GetPlayerVehicleID(playerid)));
			InfoTD_MSG(playerid, 4000, "Start Engine...");
			SetTimerEx("EngineStatus", 3000, false, "id", playerid, vehicleid);
		}
	}
	else return Error(playerid, "Anda harus mengendarai kendaraan!");
	return 1;
}

CMD:light(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{	
		if(!IsEngineVehicle(vehicleid))
			return Error(playerid, "Kamu tidak berada didalam kendaraan.");
		
		switch(GetLightStatus(vehicleid))
		{
			case false:
			{
				SwitchVehicleLight(vehicleid, true);
			}
			case true:
			{
				SwitchVehicleLight(vehicleid, false);
			}
		}
	}
	else return Error(playerid, "Anda harus mengendarai kendaraan!");
	return 1;
}

forward Lampulock(vid);
public Lampulock(vid)
{
    SwitchVehicleLight(vid, false);
}
CMD:hood(playerid, params[])
{
    if(IsPlayerInAnyVehicle(playerid)) 
		return Error(playerid, "Kamu harus keluar dari kendaraan.");

    new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);

    if(vehicleid == INVALID_VEHICLE_ID)
       	return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    switch (GetHoodStatus(vehicleid))
    {
     	case false:
      	{
      		SwitchVehicleBonnet(vehicleid, true);
       		InfoTD_MSG(playerid, 4000, "Vehicle Hood ~g~OPEN");
       	}
       	case true:
       	{
       		SwitchVehicleBonnet(vehicleid, false);
       		InfoTD_MSG(playerid, 4000, "Vehicle Hood ~r~CLOSED");
       	}
    }
	return 1;
}
CMD:trunk(playerid, params[])
{
   	if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Kamu harus keluar dari kendaraan.");

   	new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);

   	if(vehicleid == INVALID_VEHICLE_ID)
   		return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");

   	switch (GetTrunkStatus(vehicleid))
   	{
   		case false:
   		{
   			SwitchVehicleBoot(vehicleid, true);
   			Info(playerid, "Vehicle Trunk "GREEN_E"OPEN.");
   		}
   		case true:
   		{
   			SwitchVehicleBoot(vehicleid, false);
   			Info(playerid, "Vehicle Trunk "RED_E"CLOSED.");
   		}
   	}
	return 1;
}

CMD:lock(playerid, params[])
{
   	static
   	carid = -1;

   	if((carid = Vehicle_Nearest(playerid)) != -1)
   	{
   		if(Vehicle_IsOwner(playerid, carid))
   		{
   			if(!pvData[carid][cLocked])
   			{
   				pvData[carid][cLocked] = 1;

   				InfoTD_MSG(playerid, 4000, "Vehicle ~r~Locked!");
   				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

   				SwitchVehicleDoors(pvData[carid][cVeh], true);
   			}
   			else
   			{

   				pvData[carid][cLocked] = 0;
   				InfoTD_MSG(playerid, 4000, "Vehicle ~g~Unlocked!");
   				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

   				SwitchVehicleDoors(pvData[carid][cVeh], false);
   			}
   		}
		//else SendErrorMessage(playerid, "You are not in range of anything you can lock.");
   	}
   	 
   	else Error(playerid, "Kamu tidak berada didekat Kendaraan apapun yang ingin anda kunci.");
	return 1;
}
CMD:neon(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		if(!IsEngineVehicle(vehicleid))
			return Error(playerid, "Kamu tidak berada didalam kendaraan.");
		
		new carid = -1;
		if((carid = Vehicle_Nearest(playerid)) != -1)
		{
			if(Vehicle_IsOwner(playerid, carid))
			{
				if(pvData[carid][cTogNeon] == 0)
				{
					if(pvData[carid][cNeon] != 0)
					{
						SetVehicleNeonLights(pvData[carid][cVeh], true, pvData[carid][cNeon], 0);
						InfoTD_MSG(playerid, 4000, "Vehicle Neon ~g~ON");
						pvData[carid][cTogNeon] = 1;
					}
					else
					{
						SetVehicleNeonLights(pvData[carid][cVeh], false, pvData[carid][cNeon], 0);
						pvData[carid][cTogNeon] = 0;
					}
				}
				else
				{
					SetVehicleNeonLights(pvData[carid][cVeh], false, pvData[carid][cNeon], 0);
					InfoTD_MSG(playerid, 4000, "Vehicle Neon ~r~OFF");
					pvData[carid][cTogNeon] = 0;
				}
			}
		}
	}
	else return Error(playerid, "Anda harus mengendarai kendaraan!");
	return 1;
}

CMD:myinsu(playerid, params[])
{
	new bool:found = false, msg2[512];
	format(msg2, sizeof(msg2), "ID\tModel\tInsurance\tClaim Time\tTicket\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cOwner] == pData[playerid][pID])
		{
			if(pvData[i][cClaimTime] != 0)
			{
				format(msg2, sizeof(msg2), "%s\t%d\t%s\t%d\t%s\t{ff0000}%s\n", msg2, pvData[i][cID], GetVehicleModelName(pvData[i][cModel]), pvData[i][cInsu], ReturnTimelapse(gettime(), pvData[i][cClaimTime]), FormatMoney(pvData[i][cTicket]));
				found = true;
			}
			else
			{
				format(msg2, sizeof(msg2), "%s\t%d\t%s\t%d\tClaimed\t{ff0000}%s\n", msg2, pvData[i][cVeh], GetVehicleModelName(pvData[i][cModel]), pvData[i][cInsu], FormatMoney(pvData[i][cTicket]));
				found = true;
			}
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "My Vehicles", msg2, "Close", "");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles", "Anda tidak memeliki kendaraan", "Close", "");
	return 1;
}

CMD:unrentpv(playerid, params[])
{		
	for(new r = 0; r < sizeof(unrentVehicle); r ++)
	{
		new vehid;
		if(!IsPlayerInRangeOfPoint(playerid, 3.0, 545.7528, -1293.4164, 17.2422) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1689.7552, -2311.7261, 13.5469) && !IsPlayerInRangeOfPoint(playerid, 3.0, 804.9299, -1362.8210, 13.5469) && !IsPlayerInRangeOfPoint(playerid, 3.0, 1757.7032, -1864.0552, 13.5743)) return Error(playerid, "You must in showroom/dealer!");
		if(sscanf(params, "d", vehid)) return Usage(playerid, "/unrentpv [vehid] | /mypv - for find vehid");
		if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");

		foreach(new i : PVehicles)			
		{
			if(vehid == pvData[i][cVeh])
			{
				if(pvData[i][cOwner] == pData[playerid][pID])
				{
					if(pvData[i][cRent] != 0)
					{
						Info(playerid, "You has unrental the vehicle id %d (database id: %d).", vehid, pvData[i][cID]);
						new str[150];
						format(str,sizeof(str),"[VEH]: %s unrental kendaraan id %d (database id: %d)!", GetRPName(playerid), vehid, pvData[i][cID]);
						LogServer("Property", str);
						new query[128], xuery[128];
						mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[i][cID]);
						mysql_tquery(g_SQL, query);

						mysql_format(g_SQL, xuery, sizeof(xuery), "DELETE FROM vstorage WHERE owner = '%d'", pvData[i][cID]);
						mysql_tquery(g_SQL, xuery);
						if(IsValidVehicle(pvData[i][cVeh])) DestroyVehicle(pvData[i][cVeh]);
						pvData[i][cVeh] = INVALID_VEHICLE_ID;
						Iter_SafeRemove(PVehicles, i, i);
					}
					else return Error(playerid, "This is not rental vehicle! use /sellpv for sell owned vehicle.");
				}
				else return Error(playerid, "ID kendaraan ini bukan punya mu! gunakan /v my(/mypv) untuk mencari ID.");
			}
		}
		return 1;
	}	
	return 1;
}

CMD:givepv(playerid, params[])
{
	new vehid, otherid;
	if(sscanf(params, "ud", otherid, vehid)) return Usage(playerid, "/givepv [playerid/name] [vehid] | /v my(mypv) - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");

	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
		return Error(playerid, "The specified player is disconnected or not near you.");
	
	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				new nearid = GetNearestVehicleToPlayer(playerid, 5.0, false);
				if(vehid == nearid)
				{
					new count = 0, limit = MAX_PLAYER_VEHICLE + pData[otherid][pVip];
					if(pvData[i][cRent] != 0) return Error(playerid, "You can't give rental vehicle!");
					foreach(new ii : PVehicles)
					{
						if(pvData[ii][cOwner] == pData[otherid][pID])
							count++;
					}
					if(count >= limit)
					{
						Error(playerid, "This player have too many vehicles, sell a vehicle first!");
						return 1;
					}
					Info(playerid, "Anda memberikan kendaraan %s(%d) anda kepada %s.", GetVehicleName(vehid), GetVehicleModel(vehid), ReturnName(otherid));
					Info(otherid, "%s Telah memberikan kendaraan %s(%d) kepada anda.(/mypv)", ReturnName(playerid), GetVehicleName(vehid), GetVehicleModel(vehid));
					new str[150];
					format(str,sizeof(str),"[VEH]: %s memberikan kendaraan model %s(%d) ke %s!", GetRPName(playerid), GetVehicleName(vehid), GetVehicleModel(vehid), GetRPName(otherid));
					LogServer("Property", str);
					pvData[i][cOwner] = pData[otherid][pID];
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "UPDATE vehicle SET owner='%d' WHERE id='%d'", pData[otherid][pID], pvData[i][cID]);
					mysql_tquery(g_SQL, query);
					return 1;
				}
				else return Error(playerid, "Anda harus berada di dekat kendaraan yang anda jual!");
			}
			else return Error(playerid, "ID kendaraan ini bukan punya mu! gunakan /v my(/mypv) untuk mencari ID.");
		}
	}
	return 1;
}

GetDistanceToCar(playerid, veh, Float: posX = 0.0, Float: posY = 0.0, Float: posZ = 0.0) 
{
	new
	Float: Floats[2][3];

	if(posX == 0.0 && posY == 0.0 && posZ == 0.0) {
		if(!IsPlayerInAnyVehicle(playerid)) GetPlayerPos(playerid, Floats[0][0], Floats[0][1], Floats[0][2]);
		else GetVehiclePos(GetPlayerVehicleID(playerid), Floats[0][0], Floats[0][1], Floats[0][2]);
	}
	else 
	{
		Floats[0][0] = posX;
		Floats[0][1] = posY;
		Floats[0][2] = posZ;
	}
	GetVehiclePos(veh, Floats[1][0], Floats[1][1], Floats[1][2]);
	return floatround(floatsqroot((Floats[1][0] - Floats[0][0]) * (Floats[1][0] - Floats[0][0]) + (Floats[1][1] - Floats[0][1]) * (Floats[1][1] - Floats[0][1]) + (Floats[1][2] - Floats[0][2]) * (Floats[1][2] - Floats[0][2])));
}

GetClosestCar(playerid, exception = INVALID_VEHICLE_ID) 
{

	new
	Float: Distance,
	target = -1,
	Float: vPos[3];

	if(!IsPlayerInAnyVehicle(playerid)) GetPlayerPos(playerid, vPos[0], vPos[1], vPos[2]);
	else GetVehiclePos(GetPlayerVehicleID(playerid), vPos[0], vPos[1], vPos[2]);

	for(new v; v < MAX_VEHICLES; v++) if(GetVehicleModel(v) >= 400) 
	{
		if(v != exception && (target < 0 || Distance > GetDistanceToCar(playerid, v, vPos[0], vPos[1], vPos[2]))) 
		{
			target = v;
            Distance = GetDistanceToCar(playerid, v, vPos[0], vPos[1], vPos[2]); // Before the rewrite, we'd be running GetPlayerPos 2000 times...
        }
    }
    return target;
}

CMD:tow(playerid, params[]) 
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		new carid = GetPlayerVehicleID(playerid);
		if(IsATowTruck(carid))
		{
			new closestcar = GetClosestCar(playerid, carid);

			if(GetDistanceToCar(playerid, closestcar) <= 8 && !IsTrailerAttachedToVehicle(carid)) 
			{
				/*for(new x;x<sizeof(SAGSVehicles);x++)
				{
					if(SAGSVehicles[x] == closestcar) return Error(playerid, "You cant tow faction vehicle.");
					Info(playerid, "You has towed the vehicle in trailer.");
					AttachTrailerToVehicle(closestcar, carid);
					return 1;
				}
				for(new xx;xx<sizeof(SAPDVehicles);xx++)
				{
					if(SAPDVehicles[xx] == closestcar) return Error(playerid, "You cant tow faction vehicle.");
					Info(playerid, "You has towed the vehicle in trailer.");
					AttachTrailerToVehicle(closestcar, carid);
					return 1;
				}
				for(new y;y<sizeof(SAMDVehicles);y++)
				{
					if(SAMDVehicles[y] == closestcar) return Error(playerid, "You cant tow faction vehicle.");
					Info(playerid, "You has towed the vehicle in trailer.");
					AttachTrailerToVehicle(closestcar, carid);
					return 1;
				}
				for(new yy;yy<sizeof(SANAVehicles);yy++)
				{
					if(SANAVehicles[yy] == closestcar) return Error(playerid, "You cant tow faction vehicle.");
					Info(playerid, "You has towed the vehicle in trailer.");
					AttachTrailerToVehicle(closestcar, carid);
					return 1;
				}*/
				Info(playerid, "You has towed the vehicle in trailer.");
				AttachTrailerToVehicle(closestcar, carid);
				return 1;
			}
		}
		else
		{
			Error(playerid, "Anda harus mengendarai Tow truck.");
			return 1;
		}
	}
	else
	{
		Error(playerid, "Anda harus mengendarai Tow truck.");
		return 1;
	}
	return 1;
}

CMD:untow(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
		{
			Info(playerid, "You has untowed the vehicle trailer.");
			DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
		}
		else
		{
			Error(playerid, "Tow penderek kosong!");
		}
	}
	else
	{
		Error(playerid, "Anda harus mengendarai Tow truck.");
		return 1;
	}
	return 1;
}

GetOwnedVeh(playerid)
{
	new tmpcount;
	foreach(new vid : PVehicles)
	{
	    if(pvData[vid][cOwner] == pData[playerid][pID])
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}

ReturnPlayerVehID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > MAX_PLAYER_VEHICLE) return -1;
	foreach(new vid : PVehicles)
	{
	    if(pvData[vid][cOwner] == pData[playerid][pID])
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return vid;
  			}
	    }
	}
	return -1;
}

ReturnPlayerVehStolen(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > MAX_PLAYER_VEHICLE) return -1;
	foreach(new vid : PVehicles)
	{
	    if(pvData[vid][cOwner] == pData[playerid][pID])
	    {
			if(pvData[vid][cStolen] > 0)
			{
				tmpcount++;
				if(tmpcount == hslot)
				{
					return vid;
				}
			}
	    }
	}
	return -1;
}

GetVehicleStolen(playerid)
{
	new tmpcount;
	foreach(new vid : PVehicles)
	{
	    if(pvData[vid][cOwner] == pData[playerid][pID])
	    {
			if(pvData[vid][cStolen] > 0)
			{
				tmpcount++;
			}
		}
	}
	return tmpcount;
}

CMD:buysparepart(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1294.1837, -1267.9083, 20.6199))
		return 0;

	ShowPlayerDialog(playerid, DIALOG_SPAREPART, DIALOG_STYLE_TABLIST, "Sparepart Shop", "Sparepart\t{3BBD44}$1.000\n{ffffff}Vehicle Repair\t( Membutuhkan Sparepart )", "Select", "Close");
	return 1;
}

CMD:vstorage(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You must exit from the vehicle.");

	new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

	new id = Vehicle_Nearest(playerid);

	if(x == INVALID_VEHICLE_ID)
		return Error(playerid, "You not in near any vehicles.");

	static
		carid;
	carid = -1;
	if((carid = Vehicle_Nearest(playerid)) != -1)
	{
		if(carid != -1 && Vehicle_HaveAccess(playerid, id))
		{
			foreach(new i: PVehicles)
			if(x == pvData[i][cVeh])
			{
				new vehid = pvData[i][cVeh];

				if(pvData[vehid][LoadedStorage] == false)
				{
					MySQL_CreateVehicleStorage(i);
					pvData[vehid][LoadedStorage] = true;
				}
				else Trunk_OpenStorage(playerid, vehid);
			}
		}
	}
	return 1;
}
