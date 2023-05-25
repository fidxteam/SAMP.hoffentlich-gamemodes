CreateReflenishJobPoint()
{
	//JOBS
	new strings[1280];
	CreateDynamicPickup(1239, 23, 1433.51, -968.358, 37.6965, -1);
	format(strings, sizeof(strings), "[REFLENISH JOBS]\n{FFFFFF}/getjob to join job");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1433.51, -968.358, 37.6965, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); //Reflenish
}

CreateLoadMoney()
{
	//JOBS
	new strings[1280];
	CreateDynamicPickup(1239, 23, 1429.63, -961.982, 36.6329, -1);
	format(strings, sizeof(strings), "[REFLENISH JOBS]\n{FFFFFF}/loadmoney to take bankmoney");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1429.63, -961.982, 36.6329, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); //Reflenish
}

function Reflenish(playerid)
{
    if(pData[playerid][pReflenish] != 1) return 0;
	{
	    if(pData[playerid][pActivityTime] >= 100)
	    {
	    	InfoTD_MSG(playerid, 8000, "Load BankMoney Done!");
	    	TogglePlayerControllable(playerid, 1);
	    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pEnergy] -= 8;
			pData[playerid][pActivityTime] = 0;
			pData[playerid][pReflenish] = 0;
	    	SetPVarInt(playerid, "Reflenish", gettime() + 3000);
	    	new carid = -1;
	    	if((carid = Vehicle_Nearest2(playerid)) != -1)
            {
				pvData[carid][cDepositor] += 5;
            }
		}
 		else if(pData[playerid][pActivityTime] < 100)
		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

CMD:loadmoney(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
	if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
    {
	    if(GetVehicleModel(vehicleid) != 609 && GetVehicleModel(vehicleid) != 498)
			return Error(playerid, "You must be inside a boxville.");
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 1429.63, -961.982, 36.6329))
		{
			if(VehDepositor[vehicleid] > 2) return Error(playerid, "Bank Money is full in this vehicle.");
			if(GetPVarInt(playerid, "Reflenish") > gettime())
			    return Error(playerid, "Delays Load Money, please wait.");
            pData[playerid][pActivity] = SetTimerEx("Reflenish", 300, true, "i", playerid);
            pData[playerid][pReflenish] = 1;
            PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Loadbankmoney...");
            PlayerTextDrawShow(playerid, ActiveTD[playerid]);
            ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
         }
		 else return Error(playerid, "Anda Harus Di Dekat LoadMoney!");
    }
    else return Error(playerid, "You are not reflenish jobs.");
    return 1;
}

CMD:unloadmoney(playerid, params[])
{
    new carid = -1;
	if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
	{
		new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0, false);
		if(vehicleid == INVALID_VEHICLE_ID) return Error(playerid, "You not in near any vehicles.");
		if(VehDepositor[vehicleid] == 0) return Error(playerid, "Bank Money is empty in this vehicle.");
		if(GetVehicleModel(vehicleid) != 609 && GetVehicleModel(vehicleid) != 498) return Error(playerid, "You must be inside a boxville.");
  		if((carid = Vehicle_Nearest(playerid)) != -1)
		{
				pvData[carid][cDepositor] -= 1;
				Info(playerid, "Anda Mengambil Bank Money Di Dalam Kendaraan Anda.");
		}
		VehDepositor[vehicleid] -= 1;
		pData[playerid][pDepositor] += 1;
		SetPlayerAttachedObject(playerid, 9, 1550, 1, 0.116999, -0.170999, -0.016000, -3.099997, 87.800018, -179.400009, 0.602000, 0.640000, 0.625000, 0, 0);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	}
	else return Error(playerid, "You are not reflenish jobs.");
    return 1;
}

CMD:fillatm(playerid, params[])
{
    new id = -1;
	id = GetClosestATM(playerid);
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
	{
        if(AtmData[id][atmMoney] > 22) return Error(playerid, "Atm Masih Memiliki Money.");
		if(id > -1)
		{
		    if(pData[playerid][pDepositor] < 0) return Error(playerid, "Kamu tidak mempunyai BankMoney di tas mu!.");
		    pData[playerid][pActivity] = SetTimerEx("Fill", 600, true, "id", playerid, id);
            PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Fill Money...");
            pData[playerid][pFill] = 1;
		}
	}
	else return Error(playerid, "You are not reflenish jobs.");
	return 1;
}
			
function Fill(playerid, id)
{
    if(pData[playerid][pFill] != 1) return 0;
	{
	    if(pData[playerid][pActivityTime] >= 100)
	    {
	    	InfoTD_MSG(playerid, 8000, "Fill Atm Done!");
	    	TogglePlayerControllable(playerid, 1);
	    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pEnergy] -= 8;
			pData[playerid][pActivityTime] = 0;
	    	pData[playerid][pJobTime] += 380;
			Server_AddMoney(256000);
			AddPlayerSalary(playerid, "Jobs(Reflenish)", 800);
			Info(playerid, "Kamu Telah Mendepositkan Uang Atm Sebesar "GREEN_E"$2,560.00.");
			pData[playerid][pDepositor] -= 1;
			AtmData[id][atmMoney] += 80;
			pData[playerid][pFill] = 0;
			RemovePlayerAttachedObject(playerid, 9);
		}
 		else if(pData[playerid][pActivityTime] < 100)
		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		}
	}
	return 1;
}
