
//Private Vehicle Player System Define

#define MAX_PRIVATE_VEHICLE 1000
#define MAX_PLAYER_VEHICLE 3
//new Float: VehicleFuel[MAX_VEHICLES] = 100.0;
new bool:VehicleHealthSecurity[MAX_VEHICLES] = false, Float:VehicleHealthSecurityData[MAX_VEHICLES] = 1000.0;
new AdminVehicle[MAX_PLAYERS char];

enum pvdata
{
	cID,
	cOwner,
	cModel,
	cColor1,
	cColor2,
	cPaintJob,
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
	cCoal,
	cProduct,
	cGasOil,
	cBox,
	cRent,
	cVeh,
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

Vehicle_Save(vehicleid)
{
	Vehicle_GetStatus(vehicleid);
	new cQuery[3000];
	format(cQuery, sizeof(cQuery), "UPDATE vehicle SET locked='%d', insu='%d', claim='%d', claim_time='%d', x='%f', y='%f', z='%f', a='%f', health='%f', fuel='%d', interior='%d', vw='%d', damage0='%d', damage1='%d', damage2='%d', damage3='%d', color1='%d', color2='%d', paintjob='%d', neon='%d', price='%d', model='%d', plate='%d', plate_time='%d', ticket='%d', mod0='%d', mod1='%d', mod2='%d', mod3='%d', mod4='%d', mod5='%d', mod6='%d', mod7='%d', mod8='%d', mod9='%d', mod10='%d', mod11='%d', mod12='%d', mod13='%d', mod14='%d', mod15='%d', mod16='%d', lumber='%d', metal='%d', coal='%d', product='%d', gasoil='%d', box='%d', rental='%d', park='%d', broken='%d', trunk='%d' WHERE id='%d'",

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
		pvData[vehicleid][cTrunk],
		pvData[vehicleid][cID]
	);
	return mysql_tquery(g_SQL, cQuery);
}

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
/*
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
*/

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

/*
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
}*/
Vehicle_IsOwner(playerid, carid)
{
	if(!pData[playerid][IsLoggedIn] || pData[playerid][pID] == -1)
		return 0;

	if((Iter_Contains(PVehicles, carid) && pvData[carid][cOwner] != 0) && pvData[carid][cOwner] == pData[playerid][pID])
		return 1;

	return 0;
}

Vehicle_HaveAccess(playerid, carid)
{
	if(pData[playerid][pID] == -1)
		return 0;

	if((Iter_Contains(PVehicles, carid) && pvData[carid][cOwner] != 0) && pvData[carid][cOwner] == pData[playerid][pID] || pData[playerid][pVehKey] == pvData[carid][cID])
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

Vehicle_GetStatus(carid)
{
	if(IsValidVehicle(pvData[carid][cVeh]) && pvData[carid][cVeh] != INVALID_VEHICLE_ID)
	{
		GetVehicleDamageStatus(pvData[carid][cVeh], pvData[carid][cDamage0], pvData[carid][cDamage1], pvData[carid][cDamage2], pvData[carid][cDamage3]);
		GetVehicleHealth(pvData[carid][cVeh], pvData[carid][cHealth]);
		pvData[carid][cFuel] = GetVehicleFuel(pvData[carid][cVeh]);
		GetVehiclePos(pvData[carid][cVeh], pvData[carid][cPosX], pvData[carid][cPosY], pvData[carid][cPosZ]);
		GetVehicleZAngle(pvData[carid][cVeh],pvData[carid][cPosA]);
	}
	return 1;
}
/*
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
*/
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

IPRP::OnPlayerVehicleRespawn(i)
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
	pvData[i][cBreaken] = INVALID_PLAYER_ID;
	pvData[i][cBreaking] = 0;
	SetTimer("OnLoadVehicleStorage", 1000, true);
    return 1;
}

IPRP::OnLoadVehicleStorage(i)
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
			cache_get_value_name_int(z, "park", pvData[i][cGaraged]);
			cache_get_value_name_int(z, "broken", pvData[i][cStolen]);
			cache_get_value_name_int(z, "trunk", pvData[i][cTrunk]);
			Iter_Add(PVehicles, i);
			if(pvData[i][cClaim] == 0 && pvData[i][cDeath] == 0 && pvData[i][cGaraged] == -1 && pvData[i][cStolen] == 0)
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

IPRP::EngineStatus(playerid, vehicleid)
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
			SwitchVehicleEngine(vehicleid, true);
			InfoTD_MSG(playerid, 4000, "Vehicle Engine ~g~ON");
		}
		if(rand == 1)
		{
			SwitchVehicleEngine(vehicleid, true);
			InfoTD_MSG(playerid, 4000, "Vehicle Engine ~g~ON");
		}
		if(rand == 2)
		{
			SwitchVehicleEngine(vehicleid, true);
			InfoTD_MSG(playerid, 4000, "Vehicle Engine ~g~ON");
		}
	}
	else
	{
		//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mematikan mesin kendaraan %s.", ReturnName(playerid, 0), GetVehicleNameByVehicle(GetPlayerVehicleID(playerid)));
		SwitchVehicleEngine(vehicleid, false);
		//Info(playerid, "Engine turn off..");
		InfoTD_MSG(playerid, 4000, "Vehicle Engine ~r~OFF");
	}
	return 1;
}

IPRP::RemovePlayerVehicle(playerid)
{
	foreach(new i : PVehicles)
	{
		if(pvData[i][cOwner] == pData[playerid][pID])
		{
			Vehicle_GetStatus(i);
			new cQuery[22480];
			pvData[i][cOwner] = -1;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "UPDATE `vehicle` SET ");
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`x`='%f', ", cQuery, pvData[i][cPosX]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`y`='%f', ", cQuery, pvData[i][cPosY]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`z`='%f', ", cQuery, pvData[i][cPosZ]+0.1);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`a`='%f', ", cQuery, pvData[i][cPosA]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`health`='%f', ", cQuery, pvData[i][cHealth]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`fuel`=%d, ", cQuery, pvData[i][cFuel]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`interior`=%d, ", cQuery, pvData[i][cInt]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`price`=%d, ", cQuery, pvData[i][cPrice]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`impound`=%d, ", cQuery, pvData[i][cImpounded]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`impoundprice`=%d, ", cQuery, pvData[i][cImpoundPrice]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`vw`=%d, ", cQuery, pvData[i][cVw]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`model`=%d, ", cQuery, pvData[i][cModel]);
			if(pvData[i][cLocked] == 1)
				mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`locked`=1, ", cQuery);
			else
				mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`locked`=0, ", cQuery);
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
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`upb`=%d, ", cQuery, pvData[i][cUpgrade][0]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`upe`=%d, ", cQuery, pvData[i][cUpgrade][1]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`upt`=%d, ", cQuery, pvData[i][cUpgrade][2]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`upbr`=%d, ", cQuery, pvData[i][cUpgrade][3]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`damage0`=%d, ", cQuery, pvData[i][cDamage0]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`damage1`=%d, ", cQuery, pvData[i][cDamage1]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`damage2`=%d, ", cQuery, pvData[i][cDamage2]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`damage3`=%d, ", cQuery, pvData[i][cDamage3]);
			new tempString[560];
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
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`park`=%d,", cQuery, pvData[i][cGaraged]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`broken`=%d,", cQuery, pvData[i][cStolen]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`rental`=%d,", cQuery, pvData[i][cRent]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%s`trunk`=%d ", cQuery, pvData[i][cTrunk]);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "%sWHERE `id` = %d", cQuery, pvData[i][cID]);
			mysql_query(g_SQL, cQuery, true);

			if(pvData[i][cNeon] != 0)
			{
				SetVehicleNeonLights(pvData[i][cVeh], false, pvData[i][cNeon], 0);
			}
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

IPRP::OnVehCreated(playerid, oid, pid, model, color1, color2, Float:x, Float:y, Float:z, Float:a)
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
	pvData[i][cHealth] = 4500;
	pvData[i][cFuel] = 1500;
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
	pvData[i][cGaraged] = -1;
	pvData[i][cUpgrade][0] = 0;
	pvData[i][cUpgrade][1] = 0;
	pvData[i][cUpgrade][2] = 0;
	pvData[i][cUpgrade][3] = 0;
	pvData[i][cBrakeMode] = 0;
	pvData[i][cTurboMode] = 0;
	pvData[i][cStolen] = 0;
	pvData[i][cImpounded] = 0;
	pvData[i][cImpoundPrice] = 0;
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

IPRP::OnVehStarterpack(playerid, pid, model, color1, color2, Float:x, Float:y, Float:z, Float:a)
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
	pvData[i][cHealth] = 4500;
	pvData[i][cFuel] = 1500;
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
	pvData[i][cGaraged] = -1;
	pvData[i][cUpgrade][0] = 0;
	pvData[i][cUpgrade][1] = 0;
	pvData[i][cUpgrade][2] = 0;
	pvData[i][cUpgrade][3] = 0;
	pvData[i][cBrakeMode] = 0;
	pvData[i][cTurboMode] = 0;
	pvData[i][cStolen] = 0;
	pvData[i][cImpounded] = 0;
	pvData[i][cImpoundPrice] = 0;
	for(new j = 0; j < 17; j++)
		pvData[i][cMod][j] = 0;
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Kamu telah mengambil Startepack kota, 1 Faggio & $500");
	return 1;
}

IPRP::OnVehBuyPV(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a)
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
	pvData[i][cHealth] = 4500;
	pvData[i][cFuel] = 1500;
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
	pvData[i][cGaraged] = -1;
	pvData[i][cUpgrade][0] = 0;
	pvData[i][cUpgrade][1] = 0;
	pvData[i][cUpgrade][2] = 0;
	pvData[i][cUpgrade][3] = 0;
	pvData[i][cBrakeMode] = 0;
	pvData[i][cTurboMode] = 0;
	pvData[i][cStolen] = 0;
	pvData[i][cImpounded] = 0;
	pvData[i][cImpoundPrice] = 0;
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

IPRP::OnVehBuyVIPPV(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a)
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
	pvData[i][cHealth] = 4500;
	pvData[i][cFuel] = 1500;
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
	pvData[i][cGaraged] = -1;
	pvData[i][cUpgrade][0] = 0;
	pvData[i][cUpgrade][1] = 0;
	pvData[i][cUpgrade][2] = 0;
	pvData[i][cUpgrade][3] = 0;
	pvData[i][cBrakeMode] = 0;
	pvData[i][cTurboMode] = 0;
	pvData[i][cStolen] = 0;
	pvData[i][cImpounded] = 0;
	pvData[i][cImpoundPrice] = 0;
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

IPRP::OnVehRentPV(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a, rental)
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
	pvData[i][cHealth] = 4500;
	pvData[i][cFuel] = 1500;
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
	pvData[i][cGaraged] = -1;
	pvData[i][cUpgrade][0] = 0;
	pvData[i][cUpgrade][1] = 0;
	pvData[i][cUpgrade][2] = 0;
	pvData[i][cUpgrade][3] = 0;
	pvData[i][cBrakeMode] = 0;
	pvData[i][cTurboMode] = 0;
	pvData[i][cStolen] = 0;
	pvData[i][cImpounded] = 0;
	pvData[i][cImpoundPrice] = 0;
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

IPRP::OnVehRentBike(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a, rental)
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
	pvData[i][cHealth] = 4500;
	pvData[i][cFuel] = 1500;
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
	pvData[i][cGaraged] = -1;
	pvData[i][cUpgrade][0] = 0;
	pvData[i][cUpgrade][1] = 0;
	pvData[i][cUpgrade][2] = 0;
	pvData[i][cUpgrade][3] = 0;
	pvData[i][cBrakeMode] = 0;
	pvData[i][cTurboMode] = 0;
	pvData[i][cStolen] = 0;
	pvData[i][cImpounded] = 0;
	pvData[i][cImpoundPrice] = 0;
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

IPRP::OnVehRentBoat(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a, rental)
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
	pvData[i][cHealth] = 4500;
	pvData[i][cFuel] = 1500;
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
	pvData[i][cGaraged] = -1;
	pvData[i][cUpgrade][0] = 0;
	pvData[i][cUpgrade][1] = 0;
	pvData[i][cUpgrade][2] = 0;
	pvData[i][cUpgrade][3] = 0;
	pvData[i][cBrakeMode] = 0;
	pvData[i][cTurboMode] = 0;
	pvData[i][cStolen] = 0;
	pvData[i][cImpounded] = 0;
	pvData[i][cImpoundPrice] = 0;
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

IPRP::RespawnPV(vehicleid)
{
	SetVehicleToRespawn(vehicleid);
	SetValidVehicleHealth(vehicleid, 1000);
	SetVehicleFuel(vehicleid, 1000);
	return 1;
}
// Private Vehicle Player System Commands
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
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 85.0160, 1070.5106, -48.9141) && !IsPlayerInRangeOfPoint(playerid, 3.0, -1469.6188, 2600.2039, 19.6310))
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

	if (!IsPlayerInRangeOfPoint(playerid, 7.0, 1552.9539,-1609.6826,13.3828))
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

CMD:unstuck(playerid, params[])
{
	new carid = -1;
    if((carid = Vehicle_Nearest(playerid)) != -1)
    {
    	if(Vehicle_IsOwner(playerid, carid))
    	{
    		if(IsValidVehicle(pvData[carid][cVeh]))
    		{
    			DestroyVehicle(pvData[carid][cVeh]);
				pvData[carid][cVeh] = INVALID_VEHICLE_ID;
				{
					new Float:posisiX, Float:posisiY, Float:posisiZ;
					SetVehiclePos(carid, posisiX, posisiY, posisiZ+0.5);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
					OnPlayerVehicleRespawn(carid);
					GameTextForPlayer(playerid, "~w~Vehicle ~y~Unstucked", 2000, 3);
				}
    		}
    	}
    }
    return 1;
}
	
/*CMD:mypv(playerid, params[])
{
	new bool:found = false, msg2[512];
	format(msg2, sizeof(msg2), "Model\tPlate\tInsurance\tStatus\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cOwner] == pData[playerid][pID] && pvData[i][cRent] == 0)
		{
		    if(pvData[i][cClaim] == 1)
		    {
				format(msg2, sizeof(msg2), "%s%s (Insurance)\t%s\t%d\t%s\n", msg2, GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], pvData[i][cInsu], (pvData[i][cLocked] == 0) ? ("{00FF00}Unlocked") : ("{FF0000}Locked"));
			}
			else if(pvData[i][cImpounded] == 1)
		    {
				format(msg2, sizeof(msg2), "%s%s (Impound)\t%s\t%d\t%s\n", msg2, GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], pvData[i][cInsu], (pvData[i][cLocked] == 0) ? ("{00FF00}Unlocked") : ("{FF0000}Locked"));
			}
			else if(pvData[i][cGaraged] != -1)
			{
				format(msg2, sizeof(msg2), "%s%s (Garage ID %d)\t%s\t%d\t%s\n", msg2, GetVehicleModelName(pvData[i][cModel]), pvData[i][cGaraged], pvData[i][cPlate], pvData[i][cInsu], (pvData[i][cLocked] == 0) ? ("{00FF00}Unlocked") : ("{FF0000}Locked"));
			}
			else if(pvData[i][cStolen] >= 1)
			{
				format(msg2, sizeof(msg2), "%s%s (Damaged)\t%s\t%d\t%s\n", msg2, GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], pvData[i][cInsu], (pvData[i][cLocked] == 0) ? ("{00FF00}Unlocked") : ("{FF0000}Locked"));
			}
			else
			{
				format(msg2, sizeof(msg2), "%s%s(ID:%d)\t%s\t%d\t%s\n", msg2, GetVehicleModelName(pvData[i][cModel]), pvData[i][cVeh], pvData[i][cPlate], pvData[i][cInsu], (pvData[i][cLocked] == 0) ? ("{00FF00}Unlocked") : ("{FF0000}Locked"));
			}
			found = true;
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_VEHMENU, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle List", msg2, "Select", "Close");
	else
		ShowMessage(playerid, "~r~ERROR: ~w~Kamu tidak memiliki kendaraan!", 3);
	return 1;
}*/

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
			status = "{3BBD44}(Parked)";
		}
		else if(pvData[vid][cClaim] != 0)
		{
			status = "{D2D2AB}(Insurance)";
		}
		else if(pvData[vid][cStolen] != 0)
		{
			status = "{DB881A}(Damaged)";
		}
		else
		{
			status = "{FFFF00}(Spawned)";
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

		new vehicleid;
    	vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);

    	if(vehicleid == INVALID_VEHICLE_ID)
    		return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");

    	switch (GetTrunkStatus(vehicleid))
    	{
    		case false:
    		{
    			SwitchVehicleBoot(vehicleid, true);
    			Info(playerid, "trunk "GREEN_E"dibuka.");
			}
    		case true:
    		{
    			SwitchVehicleBoot(vehicleid, false);
    			Info(playerid, "Vehicle trunk "RED_E"ditutup.");
    		}
    	}
    	return 1;
}

CMD:lock(playerid, params[])
{
	new
		carid = -1;

	if(IsPlayerInAnyVehicle(playerid))
	{
		if((carid = Vehicle_Nearest(playerid)) != -1)
		{
			if(Vehicle_HaveAccess(playerid, carid))
			{
				if(!pvData[carid][cLocked])
				{
					pvData[carid][cLocked] = 1;

					ShowMessage(playerid, "Vehicle ~r~Locked", 3);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

					SwitchVehicleDoors(pvData[carid][cVeh], true);
				}
				else
				{

					pvData[carid][cLocked] = 0;
					ShowMessage(playerid, "Vehicle ~g~Unlocked", 3);
					SwitchVehicleAlarm(pvData[carid][cVeh], true);
					SetTimerEx("AlarmOff", 1000, false, "d", pvData[carid][cVeh]);

					SwitchVehicleDoors(pvData[carid][cVeh], false);
				}
			}
		}
	}
	else
	{
		new bool:found = false, msg2[512];
		format(msg2, sizeof(msg2), "Model\tStatus\n");
  		foreach(new i : PVehicles)
		{
			if(IsValidVehicle(pvData[i][cVeh]))
			{
				if(Vehicle_HaveAccess(playerid, i))
				{
					format(msg2, sizeof(msg2), "%s%s\t%s\n", msg2, GetVehicleModelName(pvData[i][cModel]), (pvData[i][cLocked] == 1) ? ("{FF0000}Locked") : ("{00FF00}Unlocked"));
					found = true;
				}
			}
		}
		if(found)
			ShowPlayerDialog(playerid, DIALOG_LOCKVEH, DIALOG_STYLE_TABLIST_HEADERS, "Vehicle Lock", msg2, "Select", "Close");
		else
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicle Lock", "You don't have any vehicle spawned.", "Close", "");
	}
	return 1;
}

CMD:sharekey(playerid, params[])
{

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "You must be inside your own vehicle!");

	new otherid, carid;
	if(sscanf(params, "u", otherid))
		return SendSyntaxMessage(playerid, "/sharekey [playerid/name]");

	if(!IsPlayerConnected(otherid) || !IsPlayerNearPlayer(playerid, otherid, 4.0))
		return SendErrorMessage(playerid, "The specified player is disconnected or not near you.");

	if(pData[otherid][pVehKey] != -1)
	    return SendErrorMessage(playerid, "Player tersebut sudah memiliki Kunci kendaraan lain!");

	if ((carid = Vehicle_Inside(playerid)) != -1 && Vehicle_IsOwner(playerid, carid) && pvData[carid][cRent] == 0)
	{
		pData[otherid][pVehKey] = pvData[carid][cID];

	    SendServerMessage(playerid, "Kamu telah memberikan kunci kendaraan {00FFFF}%s {FFFFFF}kepada {FFFF00}%s", GetVehicleModelName(pvData[carid][cModel]), ReturnName(otherid));
	    SendServerMessage(otherid, "Kamu telah diberikan kunci kendaraan {00FFFF}%s {FFFFFF}oleh {FFFF00}%s", GetVehicleModelName(pvData[carid][cModel]), ReturnName(playerid));
	}
	else SendErrorMessage(playerid, "You are not inside any of your vehicles.");
	return 1;
}

CMD:revokekey(playerid, params[])
{

	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
	    return SendErrorMessage(playerid, "You must be inside your own vehicle!");

	new otherid, carid;
	if(sscanf(params, "u", otherid))
		return SendSyntaxMessage(playerid, "/revokekey [playerid/name]");

	if(!IsPlayerConnected(otherid) || !IsPlayerNearPlayer(playerid, otherid, 4.0))
		return SendErrorMessage(playerid, "The specified player is disconnected or not near you.");

	if ((carid = Vehicle_Inside(playerid)) != -1 && Vehicle_IsOwner(playerid, carid))
	{
		if(pData[otherid][pVehKey] != pvData[carid][cID])
		    return SendErrorMessage(playerid, "Player tersebut memang tidak memiliki kunci kendaraan ini!");

		pData[otherid][pVehKey] = -1;

	    SendServerMessage(playerid, "Kamu telah mengambil kunci kendaraan {00FFFF}%s {FFFFFF}dari {FFFF00}%s", GetVehicleModelName(pvData[carid][cModel]), ReturnName(otherid));
	    SendServerMessage(otherid, "Kunci kendaraan {00FFFF}%s {FFFFFF}telah diambil oleh {FFFF00}%s", GetVehicleModelName(pvData[carid][cModel]), ReturnName(playerid));
	}
	else SendErrorMessage(playerid, "You are not inside any of your vehicles.");
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
		if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1778.9250, -1885.2721, 13.3885) && !IsPlayerInRangeOfPoint(playerid, 3.0, 805.4545, -1350.5482, 13.5469)) return Error(playerid, "You must in showroom/dealer!");
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

						mysql_format(g_SQL, xuery, sizeof(xuery), "DELETE FROM trunk WHERE Owner = '%d'", pvData[i][cID]);
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
	if(sscanf(params, "ud", otherid, vehid)) return Usage(playerid, "/givepv [playerid/name] [vehid] | /mypv - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");
	new count = 0, limit = MAX_PLAYER_VEHICLE + pData[otherid][pVip];

	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");

	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				count++;
				if(count >= limit)
				{
					Error(playerid, "This player have too many vehicles, sell a vehicle first!");
					return 1;
				}
				new nearid = GetNearestVehicleToPlayer(playerid, 5.0, false);
				if(vehid == nearid)
				{
					if(pvData[i][cRent] != 0) return Error(playerid, "You can't give rental vehicle!");
					Info(playerid, "Anda memberikan kendaraan %s(%d) anda kepada %s.", GetVehicleName(vehid), GetVehicleModel(vehid), ReturnName(otherid));
					Info(otherid, "%s Telah memberikan kendaraan %s(%d) kepada anda.(/mypv)", ReturnName(playerid), GetVehicleName(vehid), GetVehicleModel(vehid));
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
			new query[128], xuery[128];
			mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[i][cID]);
			mysql_tquery(g_SQL, query);
			for(new z = 0; z < 4; z++)
			{
				vtData[pvData[i][cVeh]][z][vtoy_modelid] = 0;
				vtData[pvData[i][cVeh]][z][vtoy_x] = 0.0;
				vtData[pvData[i][cVeh]][z][vtoy_y] = 0.0;
				vtData[pvData[i][cVeh]][z][vtoy_z] = 0.0;
				vtData[pvData[i][cVeh]][z][vtoy_rx] = 0.0;
				vtData[pvData[i][cVeh]][z][vtoy_ry] = 0.0;
				vtData[pvData[i][cVeh]][z][vtoy_rz] = 0.0;
				DestroyObject(vtData[pvData[i][cVeh]][z][vtoy_model]);
			}
			mysql_format(g_SQL, xuery, sizeof(xuery), "DELETE FROM vtoys WHERE Owner = '%d'", pvData[i][cID]);
			mysql_tquery(g_SQL, xuery);
			pvData[pvData[i][cVeh]][PurchasedvToy] = false;
			if(IsValidVehicle(pvData[i][cVeh])) DestroyVehicle(pvData[i][cVeh]);
			pvData[i][cVeh] = INVALID_VEHICLE_ID;

			mysql_format(g_SQL, xuery, sizeof(xuery), "DELETE FROM trunk WHERE Owner = '%d'", pvData[i][cID]);
			mysql_tquery(g_SQL, xuery);
			pvData[pvData[i][cVeh]][LoadedStorage] = false;

			Iter_SafeRemove(PVehicles, i, i);
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

CMD:breakvehicle(playerid, params[])
{
	new id = Vehicle_Nearest(playerid);
	if(id == -1)
	    return Error(playerid, "You're not in range of any Vehicle!");

	new Float:cX, Float:cY, Float:cZ;
	new Float:dX, Float:dY, Float:dZ;

	GetVehicleModelInfo(pvData[id][cModel], VEHICLE_MODEL_INFO_FRONTSEAT, cX, cY, cZ);
	GetVehicleRelativePos(pvData[id][cVeh], dX, dY, dZ, -cX - 0.5, cY, cZ);

	if(!IsPlayerInRangeOfPoint(playerid, 1.2, dX, dY, dZ))
		return Error(playerid, "You are not near the front door! (driver door)");

	if(pvData[id][cBreaken] != INVALID_PLAYER_ID)
	    return Error(playerid, "This vehicle is already breaked by someone!");

	if(Vehicle_IsOwner(playerid, id))
	    return Error(playerid, "You can't break your own vehicle!");

	if(!pvData[id][cLocked])
	    return Error(playerid, "This vehicle is already unlocked!");

	pData[playerid][pBreaking] = true;
	SendServerMessage(playerid, "Punch the driver door until the vehicle unlocked!");
	pvData[id][cBreaking] = 0;
	pData[playerid][pTargetPv] = id;
	pvData[id][cBreaken] = playerid;
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
