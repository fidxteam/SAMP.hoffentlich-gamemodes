function Robb(playerid)
{
    if(pData[playerid][pRobSystem] != 1) return 0;
	{
	    if(pData[playerid][pActivityTime] >= 100)
	    {
	    	InfoTD_MSG(playerid, 8000, "Robbing done!");
	    	TogglePlayerControllable(playerid, 1);
	    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pEnergy] -= 15;
			pData[playerid][pRobSystem] = 0;
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
	    	InRob[playerid] = 0;
	    	GiveMoneyRob(playerid, 1, 28500);
	    	SetPVarInt(playerid, "Robb", gettime() + 3600);
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

CMD:robbery(playerid, params[])
{
    new id = -1;
	id = GetClosestATM(playerid);
	new bid = -1;
	bid = GetClosestBiz(playerid);
	new Float:x, Float:y, Float:z, String[100];
	GetPlayerPos(playerid, x, y, z);
	
	if(pData[playerid][pLevel] < 5)
			return ErrorMsg(playerid, "You must level 5 to use this!");
		//return ErrorMsg(playerid, "You_must_level_10_to_use_this!")

	if(IsPlayerConnected(playerid))
	{
        if(isnull(params))
		{
            Usage(playerid, "USAGE: /robbery [name]");
            Info(playerid, "Names: atm, biz, bank");
            return 1;
        }
		if(strcmp(params,"biz",true) == 0)
		{
            if(pData[playerid][pInBiz] >= 0 && IsPlayerInRangeOfPoint(playerid, 2.5, bData[pData[playerid][pInBiz]][bPointX], bData[pData[playerid][pInBiz]][bPointY], bData[pData[playerid][pInBiz]][bPointZ]))
			{
	    		if(GetPVarInt(playerid, "Robb") > gettime())
					return ErrorMsg(playerid, "Delays Rob, please wait.");
                if(GetPlayerWeapon(playerid) != WEAPON_SHOTGUN) return ErrorMsg(playerid, "You Need Shotgun.");
                 
                if(pData[playerid][pFamily] <= 0) return ErrorMsg(playerid, "You Must Join Family!");
				Info(playerid, "You're in robbery please wait...");
				SendAdminMessage(COLOR_RIKO, "* %s Has Robbery Bisnis Pliss Admin Spec", pData[playerid][pName]);
				foreach(new i : Player)
				{
					if(pData[i][pPhone] == bData[pData[playerid][pInBiz]][bPh])
					{
						SCM(i, COLOR_RED, "[WARNING]"WHITE_E" Alarm Berbunyi Di bisnis anda!");
					}
				}
                SendFactionMessage(1, COLOR_RED, "**[Warning]{FFFFFF} Alarm Berbunyi Di bisnis [LOCATION: %s, BIZ ID: %d]", GetLocation(x, y, z), bid);
				new dc[1000];
				format(dc, sizeof(dc),  "**%s Merampok biz Ucp: %s**", pData[playerid][pName], pData[playerid][pUCP]);
				SendDiscordMessage(15, dc);
				pData[playerid][pActivity] = SetTimerEx("Robb", 10000, true, "i", playerid);
				pData[playerid][pRobSystem] = 1;
    			
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Robbing...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				TogglePlayerControllable(playerid, 0);
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant",	4.0, 1, 0, 0, 0, 0, 1);
				InRob[playerid] = 1;
			}
        }
		else if(strcmp(params,"atm",true) == 0)
		{
			if(id > -1)
			{
				if(GetPVarInt(playerid, "Robb") > gettime())
					return ErrorMsg(playerid, "Delays Rob, please wait.");
                if(GetPlayerWeapon(playerid) != WEAPON_BAT) return ErrorMsg(playerid, "You Need baseball.");
                if(pData[playerid][pFamily] <= 0) return ErrorMsg(playerid, "You Must Join Family!");
				Info(playerid, "You're in robbery please wait...");
				SendAdminMessage(COLOR_RIKO, "* %s Has Robbery Atm Pliss Admin Spec", pData[playerid][pName]);
				SendFactionMessage(playerid, COLOR_RED, "**[Warning]{FFFFFF} Telah Terjadi Pembobolan Atm di [Location: %s, ATMID: %d]", GetLocation(x, y, z), id);
				SendFactionMessage(playerid, COLOR_RED, String);
				new dc[1000];
				format(dc, sizeof(dc),  "**%s Merampok atm Ucp: %s**", pData[playerid][pName], pData[playerid][pUCP]);
				SendDiscordMessage(15, dc);

				pData[playerid][pActivity] = SetTimerEx("Robb", 8000, true, "i", playerid);
				pData[playerid][pRobSystem] = 1;
    			
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Robbing...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				TogglePlayerControllable(playerid, 0);
				ApplyAnimation(playerid,"SWORD", "sword_4", 4.0, 1, 0, 0, 0, 0, 1);
				InRob[playerid] = 1;
			}
		}
		if(strcmp(params,"bank",true) == 0)
		{
            if(IsPlayerInRangeOfPoint(playerid, 2.5, 1412.1685,-999.0665,10.8763))
			{
	    		if(GetPVarInt(playerid, "Robb") > gettime())
					return ErrorMsg(playerid, "Delays Rob, please wait.");
                if(GetPlayerWeapon(playerid) != WEAPON_SHOTGUN) return ErrorMsg(playerid, "You Need Shotgun.");
                if(pData[playerid][pFamily] <= 0) return ErrorMsg(playerid, "You Must Join Family!");

				Info(playerid, "You're in robbery please wait...");
				SendAdminMessage(COLOR_RIKO, "* %s Has Robbery Bank Pliss Admin Spec", pData[playerid][pName]);
				
                SendFactionMessage(playerid, COLOR_RED, "**[Warning]{FFFFFF} Telah Terjadi Perampokan diBank!");
                SendClientMessageToAll(COLOR_RED, "**[Warning]{FFFFFF} Telah Terjadi Perampokan Di Bank Harap Menjauh!");
                new dc[1000];
				format(dc, sizeof(dc),  "**%s Merampok bank Ucp: %s**", pData[playerid][pName], pData[playerid][pUCP]);
				SendDiscordMessage(15, dc);

				pData[playerid][pActivity] = SetTimerEx("Robb", 12000, true, "i", playerid);
				pData[playerid][pRobSystem] = 1;
				Server_MinMoney(1000000);

				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Robbing...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				TogglePlayerControllable(playerid, 0);
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant",	4.0, 1, 0, 0, 0, 0, 1);
				InRob[playerid] = 1;
			}
        }
	}
	return 1;
}
