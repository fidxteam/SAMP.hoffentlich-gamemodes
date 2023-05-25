CMD:prosesborax(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 3.0, -347.8703,-1045.7944,59.8125))
	{
		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda tidak dapat melakukannya sekarang");
		if(Inventory_Count(playerid, "Borax") < 1) return ErrorMsg(playerid, "Lu gk punya borax, coba cek di Inventory ( otot y )");
			
	    TogglePlayerControllable(playerid, 0);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		pData[playerid][pProsesBorax] = SetTimerEx("Proses", 1000, true, "id", playerid, 3);
		PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Proses...");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
	}
	else return Error(playerid, "Anda tidak ditempat proses borax");
	return 1;
}

function Proses(playerid, type)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pProsesBorax])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, -347.8703,-1045.7944,59.8125))
			{
				if(pData[playerid][pActivityTime] >= 100)
				{
					Info(playerid, "Anda berhasil memproses Borax");
					Inventory_Remove(playerid, "Borax", 1);
					Inventory_Add(playerid, "Paket_Borax", 1578, 2);
					TogglePlayerControllable(playerid, 1);
					KillTimer(pData[playerid][pProsesBorax]);
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					pData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
				}
				else
				{
					KillTimer(pData[playerid][pProsesBorax]);
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					return 1;
				}
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
            if(IsPlayerInRangeOfPoint(playerid, 3.0, -347.8703,-1045.7944,59.8125))
			{
				pData[playerid][pActivityTime] += 5;
				SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
			}
		}
	}
	return 1;
}

CMD:jualborax(playerid, params[])
{
	if(pData[playerid][pFamily] == -1)
        return Error(playerid, "You must in family to use this command!");
 	    
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1513.2206,21.2324,24.1406))
		return Error(playerid, "Anda harus di tempat penjualan borax");
		
	if(Inventory_Count(playerid, "Paket_Borax") < 1)
		return Error(playerid, "Anda tidak memiliki paket Borax");

	pData[playerid][pRedMoney] += 500;
    Inventory_Remove(playerid, "Paket_Borax", 1);
	SendClientMessage(playerid, COLOR_LBLUE, "INFO: "WHITE_E"Anda telah menjual Borax dan mendapatkan "GREEN_E"$500");

    ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	return 1;
}


CMD:borax(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 106,-1079.7341,-973.8702,129.2188))
	{
	    if(Inventory_Count(playerid, "Borax") >= 20) return Error(playerid, "Anda sudah membawa 20 borax!");
		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda tidak dapat melakukannya sekarang");
		
	    TogglePlayerControllable(playerid, 0);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		pData[playerid][pGetBorax] = SetTimerEx("Borax", 1000, true, "id", playerid, 3);
		PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Mengambil...");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
	}
	else return Error(playerid, "Anda tidak ditempat ladang borax");
	return 1;
}

function Borax(playerid, type)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pGetBorax])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
			{
				if(pData[playerid][pActivityTime] >= 100)
				{
					Info(playerid, "Anda berhasil mengambil borax");
					Inventory_Add(playerid, "Borax", 19473, 1);
					TogglePlayerControllable(playerid, 1);
					KillTimer(pData[playerid][pGetBorax]);
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					pData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
				}
				else
				{
					KillTimer(pData[playerid][pGetBorax]);
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					return 1;
				}
			}
		else if(pData[playerid][pActivityTime] < 100)
		{
            if(IsPlayerInRangeOfPoint(playerid, 106,-1079.7341,-973.8702,129.2188))
			{
				pData[playerid][pActivityTime] += 5;
				SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
				ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1);
			}
		}
	}
	return 1;
}
