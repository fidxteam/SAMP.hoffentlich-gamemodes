/*


         TASK OPTIMIZED LUNARPRIDE

*/

task onlineTimer[1000]()
{	
	new kandang[128], kandangg2[128], kandangg3[128], kandangg4[128], kandangg5[128];
	format(kandang, sizeof(kandang), "[Kandang ayam]\n{FFFFFF}KEY [ H ] Masukkan ayam dan Klakson Ayam ke mobil, Jumlah: %d", kandang1);
    UpdateDynamic3DTextLabelText(kandangcp, COLOR_LBLUE, kandang);
    format(kandangg2, sizeof(kandangg2), "[Kandang ayam]\n{FFFFFF}KEY [ H ] Masukkan ayam dan Klakson Ayam ke mobil, Jumlah: %d", kandang2);
    UpdateDynamic3DTextLabelText(kandangcp2, COLOR_LBLUE, kandangg2);
    format(kandangg3, sizeof(kandangg3), "[Kandang ayam]\n{FFFFFF}KEY [ H ] Masukkan ayam dan Klakson Ayam ke mobil, Jumlah: %d", kandang3);
    UpdateDynamic3DTextLabelText(kandangcp3, COLOR_LBLUE, kandangg3);
    format(kandangg4, sizeof(kandangg4), "[Kandang ayam]\n{FFFFFF}KEY [ H ] Masukkan ayam dan Klakson Ayam ke mobil, Jumlah: %d", kandang4);
    UpdateDynamic3DTextLabelText(kandangcp4, COLOR_LBLUE, kandangg4);
    format(kandangg5, sizeof(kandangg5), "[Kandang ayam]\n{FFFFFF}KEY [ H ] Masukkan ayam dan Klakson Ayam ke mobil, Jumlah: %d", kandang5);
    UpdateDynamic3DTextLabelText(kandangcp5, COLOR_LBLUE, kandangg5);
	if(EventStarted == 1)
	{
	    if(killred == 200 || killblue == 200)
	    {
	        KillTimer(Anjaytdm);
	        foreach(new i : Player)
			{
				if(IsAtEvent[i] == 1)
				{
				     SetPlayerVirtualWorld(i, 0);
		    		ResetPlayerWeapons(i);
			    	SetPlayerPos(i, pData[i][pCox], pData[i][pCoy], pData[i][pCoz]);
			    	SetPlayerInterior(i, pData[i][pCoint]);
	    			SetPlayerFacingAngle(i, pData[i][pCoa]);
			    	Info(i, "Tdm selesai");
			    	if(killred > killblue)
			    	{
			    	    if(GetPlayerTeam(i) == 1)
						{
						    GivePlayerMoneyEx(i, 10 * killred);
							SendClientMessageEx(i, -1, "Kalian menang, hadiah = %d di kali 10 = %d dollar", killred, killred*10);
						}
						if(GetPlayerTeam(i) == 2)
						{
						    GivePlayerMoneyEx(i, 2 * killred);
							SendClientMessageEx(i, -1, "Kalian kalah, hadiah = %d di kali 2 = %d dollar", killred, killred * 2);
						}
					}
					if(killblue > killred)
			    	{
			    	    if(GetPlayerTeam(i) == 2)
						{
						    GivePlayerMoneyEx(i, 10 * killred);
							SendClientMessageEx(i, -1, "Kalian menang, hadiah = %d di kali 10 = %d dollar", killred, killred*10);
						}
						if(GetPlayerTeam(i) == 1)
						{
						    GivePlayerMoneyEx(i, 2 * killred);
							SendClientMessageEx(i, -1, "Kalian kalah, hadiah = %d di kali 2 = %d dollar", killred, killred * 2);
						}
					}
					TextDrawHideForPlayer(i, VintageDM[0]);
					TextDrawHideForPlayer(i, VintageDM[1]);
					TextDrawHideForPlayer(i, VintageDM[2]);
					TextDrawHideForPlayer(i, VintageDM[3]);
					TextDrawHideForPlayer(i, VintageDM[4]);
					for(new p = 0; p < 3; p++)
					{
						PlayerTextDrawHide(i, DMVintage[i][p]);
					}
					SetPlayerTeam(i, 0);
					SetPlayerHealthEx(i, 100.0);
					IsAtEvent[i] = 0;
					EventCreated = 0;
					EventStarted = 0;
					killred = 0;
					killblue = 0;
					RedTeam = 0;
    				BlueTeam = 0;
				 }
			}
		}
	}
	//Date and Time Textdraw
	new datestring[64];
	new hours,
	minutes,
	seconds,
	days,
	months,
	playerid,
	years;
	new MonthName[12][] =
	{
		"January", "February", "March", "April", "May", "June",
		"July",	"August", "September", "October", "November", "December"
	};
	getdate(years, months, days);
 	gettime(hours, minutes, seconds);
	format(datestring, sizeof datestring, "%s%d %s %s%d", ((days < 10) ? ("0") : ("")), days, MonthName[months-1], (years < 10) ? ("0") : (""), years);
	TextDrawSetString(TextDate, datestring);
	format(datestring, sizeof datestring, "%s%d:%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes, (seconds < 10) ? ("0") : (""), seconds);
	TextDrawSetString(TextTime, datestring);
	new red[128], blue[128];
	format(red, sizeof red, "%d", killred);
	TextDrawSetString(VintageDM[3], red);
	format(blue, sizeof blue, "%d", killblue);
	TextDrawSetString(VintageDM[4], blue);
	//Phone Time
	foreach(new i: Player)
	{
		format(datestring, sizeof datestring, "%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
		PlayerTextDrawSetString(i, jam[i], datestring);
		format(datestring, sizeof datestring, "%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
		PlayerTextDrawSetString(i, Lockhp[i][13], datestring);
		format(datestring, sizeof datestring, "%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
		PlayerTextDrawSetString(i, TDPhone[i][13], datestring);
		format(datestring, sizeof datestring, "%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
		PlayerTextDrawSetString(i, TDPhone[i][18], datestring);
		format(datestring, sizeof datestring, "%s%d %s %s%d", ((days < 10) ? ("0") : ("")), days, MonthName[months-1], (years < 10) ? ("0") : (""), years);
		PlayerTextDrawSetString(i, Lockhp[i][23], datestring);
		format(datestring, sizeof datestring, "%s%d %s %s%d", ((days < 10) ? ("0") : ("")), days, MonthName[months-1], (years < 10) ? ("0") : (""), years);
		PlayerTextDrawSetString(i, TDPhone[i][21], datestring);
	}
	//VEH FIVEM
	format(datestring, sizeof datestring, "%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes);
	PlayerTextDrawSetString(playerid, VEHFIVEM[playerid][6], datestring);
	
	// Increase server uptime
	up_seconds ++;
	if(up_seconds == 60)
	{
	    up_seconds = 0, up_minutes ++;
	    if(up_minutes == 60)
	    {
	        up_minutes = 0, up_hours ++;
	        if(up_hours == 24) up_hours = 0, up_days ++;
			new tstr[128], r = RandomEx(1, 500);
			format(tstr, sizeof(tstr), ""BLUE_E"UPTIME: "WHITE_E"The server has been online for %s.", Uptime());
			SendClientMessageToAll(COLOR_WHITE, tstr);
			Component += r;
			Material += r;
			GasOil += r;
			Apotek += r;
			Product += r;
			Food += r;
			Marijuana += r;
			ObatMyr += r;

			// Sync Server
			mysql_tquery(g_SQL, "OPTIMIZE TABLE `bisnis`,`houses`,`toys`,`vehicle`,`players`,`doors`,`familys`,`lockers`,`gstations`,`deslership`,`workshop`,`garage`,`trunk`,`farm`");
		}
	}
	return 1;
}

ptask PlayerDelay[1000](playerid)
{
	if(pData[playerid][IsLoggedIn] == false) return 0;
	NgecekCiter(playerid);
		//VIP Expired Checking
	if(pData[playerid][pVip] > 0)
	{
		if(pData[playerid][pVipTime] != 0 && pData[playerid][pVipTime] <= gettime())
		{
			Info(playerid, "Maaf, Level VIP player anda sudah habis! sekarang anda adalah player biasa!");
			pData[playerid][pVip] = 0;
			pData[playerid][pVipTime] = 0;
		}
	}
    // Booster Expired Checking
    if(pData[playerid][pBooster] > 0)
    {
	    if(pData[playerid][pBoostTime] != 0 && pData[playerid][pBoostTime] <= gettime())
        {
            Info(playerid, "Maaf, Booster player anda sudah habis! sekarang anda adalah player biasa!");
            pData[playerid][pBooster] = 0;
			pData[playerid][pBoostTime] = 0;
        }
    }
	//ID Card Expired Checking
	if(pData[playerid][pIDCard] > 0)
	{
		if(pData[playerid][pIDCardTime] != 0 && pData[playerid][pIDCardTime] <= gettime())
		{
			Info(playerid, "Masa berlaku ID Card anda telah habis, silahkan perpanjang kembali!");
			pData[playerid][pIDCard] = 0;
			pData[playerid][pIDCardTime] = 0;
		}
	}

	if(pData[playerid][pExitJob] != 0 && pData[playerid][pExitJob] <= gettime())
	{
		Info(playerid, "Now you can exit from your current job!");
		pData[playerid][pExitJob] = 0;
	}
	if(pData[playerid][pDriveLic] > 0)
	{
		if(pData[playerid][pDriveLicTime] != 0 && pData[playerid][pDriveLicTime] <= gettime())
		{
			Info(playerid, "Masa berlaku Driving anda telah habis, silahkan perpanjang kembali!");
			pData[playerid][pDriveLic] = 0;
			pData[playerid][pDriveLicTime] = 0;
		}
	}
	if(pData[playerid][pWeaponLic] > 0)
	{
		if(pData[playerid][pWeaponLicTime] != 0 && pData[playerid][pWeaponLicTime] <= gettime())
		{
			Info(playerid, "Masa berlaku License Weapon anda telah habis, silahkan perpanjang kembali!");
			pData[playerid][pWeaponLic] = 0;
			pData[playerid][pWeaponLicTime] = 0;
		}
	}
	//jail
    if(pData[playerid][pJailTime] > 0)
	{
        static
        hours,
		minutes,
		seconds,
		str[1280];

        pData[playerid][pJailTime]--;

		GetElapsedTime(pData[playerid][pJailTime], hours, minutes, seconds);

		format(str, sizeof(str), "~g~Prison Time:~w~ %02d:%02d:%02d", hours, minutes, seconds);
		PlayerTextDrawSetString(playerid, JAILTD[playerid], str);

		if(!pData[playerid][pJailTime])
		{
		    pData[playerid][pJail] = 0;

			SetPlayerPos(playerid, 1529.6,-1691.2,13.3);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);

			SendServerMessage(playerid, "You have been released from jail.");
		    PlayerTextDrawHide(playerid, JAILTD[playerid]);
		}
    }
	if(pData[playerid][pJail] && pData[playerid][pJailTime] > 0 && !IsPlayerInRangeOfPoint(playerid, 20.0, -310.64, 1894.41, 34.05) && pData[playerid][pAdmin] < 1)
	{
		SetPlayerPositionEx(playerid, -310.64, 1894.41, 34.05, 178.17, 2000);
		SetPlayerInterior(playerid, 3);
	}
    //Player JobTime Delay
	if(pData[playerid][pJobTime] > 0)
	{
		pData[playerid][pJobTime]--;
	}
	if(pData[playerid][pSideJobTime] > 0)
	{
		pData[playerid][pSideJobTime]--;
	}

		// Duty Delay
	if(pData[playerid][pDutyHour] > 0)
	{
		pData[playerid][pDutyHour]--;
	}
		// Get Loc timer
	if(pData[playerid][pSuspectTimer] > 0)
	{
		pData[playerid][pSuspectTimer]--;
	}
	if(pData[playerid][pDelayIklan] > 0)
	{
		pData[playerid][pDelayIklan]--;
	}
		//Warn Player Check
	if(pData[playerid][pWarn] >= 20)
	{
		new ban_time = gettime() + (5 * 86400), query[512], PlayerIP[16], giveplayer[24];
		GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
		GetPlayerName(playerid, giveplayer, sizeof(giveplayer));
		pData[playerid][pWarn] = 0;
			//SetPlayerPosition(playerid, 227.46, 110.0, 999.02, 360.0000, 10);
		BanPlayerMSG(playerid, playerid, "20 Total Warning", true);
		SendClientMessageToAllEx(COLOR_RED, "Server: "GREY2_E"Player %s(%d) telah otomatis dibanned permanent dari server. [Reason: 20 Total Warning]", giveplayer, playerid);

		mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', 'Server Ban', '20 Total Warning', %i, %d)", giveplayer, PlayerIP, gettime(), ban_time);
		mysql_tquery(g_SQL, query);
		KickEx(playerid);
	}
	if(pData[playerid][pBreaking])
    {
	    new vvid = pData[playerid][pTargetPv];
	    if(IsValidVehicle(pvData[vvid][cVeh]))
	    {
			new Float:cX, Float:cY, Float:cZ;
			new Float:dX, Float:dY, Float:dZ;

		    GetVehicleModelInfo(pvData[vvid][cModel], VEHICLE_MODEL_INFO_FRONTSEAT, cX, cY, cZ);
		    GetVehicleRelativePos(pvData[vvid][cVeh], dX, dY, dZ, -cX - 0.5, cY, cZ);

	        if(!IsPlayerInRangeOfPoint(playerid, 1.2, dX, dY, dZ))
	        {
			    SendServerMessage(playerid, "You were failed for breaking vehicle, you're not in range of the vehicle!");
			    pvData[vvid][cCooldown] = 0;
			    pvData[vvid][cBreaken] = INVALID_PLAYER_ID;
			    pData[playerid][pBreaking] = false;
			    pData[playerid][pTargetPv] = -1;
		    }
        }
    }
    return 1;
}

ptask FarmDetect[1000](playerid)
{
	if(pData[playerid][IsLoggedIn] == true)
	{
		if(pData[playerid][pPlant] >= 20)
		{
			pData[playerid][pPlant] = 0;
			pData[playerid][pPlantTime] = 600;
		}
		if(pData[playerid][pPlantTime] > 0)
		{
			pData[playerid][pPlantTime]--;
			if(pData[playerid][pPlantTime] < 1)
			{
				pData[playerid][pPlantTime] = 0;
				pData[playerid][pPlant] = 0;
			}
		}
		new pid = GetClosestPlant(playerid);
		if(pid != -1)
		{
			if(IsPlayerInDynamicCP(playerid, PlantData[pid][PlantCP]) && pid != -1)
			{
				new type[24], mstr[128];
				if(PlantData[pid][PlantType] == 1)
				{
					type = "Potato";
				}
				else if(PlantData[pid][PlantType] == 2)
				{
					type = "Wheat";
				}
				else if(PlantData[pid][PlantType] == 3)
				{
					type = "Orange";
				}
				else if(PlantData[pid][PlantType] == 4)
				{
					type = "Marijuana";
				}
				if(PlantData[pid][PlantTime] > 1)
				{
					format(mstr, sizeof(mstr), "~w~Plant Type: ~g~%s ~n~~w~Plant Time: ~r~%s", type, ConvertToMinutes(PlantData[pid][PlantTime]));
					InfoTD_MSG(playerid, 1000, mstr);
				}
				else
				{
					format(mstr, sizeof(mstr), "~w~Plant Type: ~g~%s ~n~~w~Plant Time: ~g~Now", type);
					InfoTD_MSG(playerid, 1000, mstr);
				}
			}
		}
	}
	return 1;
}

ptask playerTimer[1000](playerid)
{
	if(pData[playerid][IsLoggedIn] == true)
	{
		pData[playerid][pPaycheck] ++;
		pData[playerid][pSeconds] ++, pData[playerid][pCurrSeconds] ++;
		if(pData[playerid][pOnDuty] >= 1)
		{
			pData[playerid][pOnDutyTime]++;
		}
		if(pData[playerid][pTaxiDuty] >= 1)
		{
			pData[playerid][pTaxiTime]++;
		}
		if(pData[playerid][pSeconds] == 60)
		{
			new scoremath = ((pData[playerid][pLevel])*5);

			pData[playerid][pMinutes]++, pData[playerid][pCurrMinutes] ++;
			pData[playerid][pSeconds] = 0, pData[playerid][pCurrSeconds] = 0;

			switch(pData[playerid][pMinutes])
			{				
				case 40:
				{
					if(pData[playerid][pPaycheck] >= 3600)
					{
						Info(playerid, "Waktunya mengambil paycheck!");
						Servers(playerid, "{ffff00}silahkan pergi ke bank atau ATM terdekat untuk mengambil paycheck.");
						PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
					}
				}
				case 15:
				{
			   	    if(pData[playerid][pBooster] == 1)
					{
						AddPlayerSalary(playerid, "Bonus Boost ( RP Booster )", 500);
					}
				}
				case 45:
				{
	                if(pData[playerid][pBooster] == 1)
                    {
				         pData[playerid][pPaycheck] = 3601;
                    }
		            if(pData[playerid][pPaycheck] >= 3600)
				     {
							Info(playerid, "Waktunya mengambil paycheck!");
							Servers(playerid, "{ffff00}silahkan pergi ke bank atau ATM terdekat untuk mengambil paycheck.");
							PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
				     }
				}
				case 55:
				{
				    if(GetPlayerMoney(playerid) > 1000000)
					{
						
						GivePlayerMoney(playerid, -50000);
					}
					else
					if(pData[playerid][pBankMoney] > 1000000)
					{
						pData[playerid][pBankMoney] -= 50000;
					}
				}
				case 60:
				{
					if(pData[playerid][pPaycheck] >= 3600)
					{
						Info(playerid, "Waktunya mengambil paycheck!");
						Servers(playerid, "{ffff00}silahkan pergi ke bank atau ATM terdekat untuk mengambil paycheck.");
						PlayerPlaySound(playerid, 1139, 0.0, 0.0, 0.0);
					}

					pData[playerid][pHours] ++;
					pData[playerid][pLevelUp] += 1;
					pData[playerid][pMinutes] = 0;
					UpdatePlayerData(playerid);
					if(pData[playerid][pLevelUp] >= scoremath)
					{
						new mstr[128];
						pData[playerid][pLevel] += 1;
						pData[playerid][pHours] ++;
						SetPlayerScore(playerid, pData[playerid][pLevel]);
						format(mstr,sizeof(mstr),"~g~Level Up!~n~~w~Sekarang anda level ~r~%d", pData[playerid][pLevel]);
						GameTextForPlayer(playerid, mstr, 6000, 1);
						PlayerTextDrawShow(playerid, LevelTD[playerid][0]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][1]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][2]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][3]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][4]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][5]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][6]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][7]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][8]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][9]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][10]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][11]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][12]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][13]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][14]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][15]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][16]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][17]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][18]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][19]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][20]);
						PlayerTextDrawShow(playerid, LevelTD[playerid][21]);
						new tdlv[128];
						format(tdlv, sizeof tdlv, "%d", pData[playerid][pLevel]);
						PlayerTextDrawSetString(playerid, LevelTD[playerid][12], tdlv);
						
						format(tdlv, sizeof tdlv, "%d", pData[playerid][pLevel] + 1);
						PlayerTextDrawSetString(playerid, LevelTD[playerid][20], tdlv);
						
						format(tdlv, sizeof tdlv, "%d/%d", pData[playerid][pLevelUp], scoremath);
						PlayerTextDrawSetString(playerid, LevelTD[playerid][21], tdlv);
						
						SetTimerEx("Tutuplevel", 5000, false, "i", playerid);
					}
				}
			}
			if(pData[playerid][pCurrMinutes] == 60)
			{
				pData[playerid][pCurrMinutes] = 0;
				pData[playerid][pCurrHours] ++;
			}
		}
	}
	return 1;
}

forward Tutuplevel(playerid);
public Tutuplevel(playerid)
{
    PlayerTextDrawHide(playerid, LevelTD[playerid][0]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][1]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][2]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][3]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][4]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][5]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][6]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][7]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][8]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][9]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][10]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][11]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][12]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][13]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][14]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][15]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][16]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][17]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][18]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][19]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][20]);
		PlayerTextDrawHide(playerid, LevelTD[playerid][21]);
}

