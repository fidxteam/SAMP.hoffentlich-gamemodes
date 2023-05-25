new AyamFillPrice = 100;
CreateJoinPemotongPoint()
{
    //JOBS
    new strings[128];
    CreateDynamicPickup(1239, 23, 921.77, -1287.54, 14.40, -1, -1, -1, 50);
    format(strings, sizeof(strings), "[PEMOTONG JOBS]\n{ffffff}Jadilah Pekerja Pemotong Ayam disini\n{7fffd4}/getjob /accept job");
    CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 921.77, -1287.54, 14.40, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Kurir
}

CMD:aboutayam(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_AYAM, DIALOG_STYLE_LIST, "Butcher Menu", "Lokasi Jual Ayam\nLokasi Ambil Ayam", "Select", "Close");
    return 1;
}

CMD:ambilayam(playerid, params[])
{
    if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, -2107.4541,-2400.1042,31.4123))
        {
            if(Ayammati < 1) return ErrorMsg(playerid, "Gada ayam hidup");
            new total = pData[playerid][AyamHidup];
            if(total > 50) return Error(playerid, "Ayam Hidup terlalu penuh di Inventory! Maximal 50.");
            if(pData[playerid][pPemotongStatus] == 1) return Error(playerid, "Anda Masih Proses Ayam");
            if(pData[playerid][AyamHidup] == 1) return Error(playerid, "Anda sudah membawa Ayam Hidup!");
            {
                TogglePlayerControllable(playerid, 0);
                Info(playerid, "Anda sedang mengambil ayam mentah!");
                ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 1, 1, 1);
                pData[playerid][pPemotongStatus] += 1;
                ayamjob[playerid] = SetTimerEx("getchicken", 500, true, "id", playerid);
                PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Mengambil...");
                PlayerTextDrawShow(playerid, ActiveTD[playerid]);
                ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
            } 
        }
        else return Error(playerid, "Kamu Tidak Di Tempat Pengolah Ayam.");
    }
    else Error(playerid, "Anda bukan Bekerja Pemotong Ayam.");
    return 1;
}

/*function getchicken(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(pData[playerid][AyamHidup] == 50) return Error(playerid, "Anda sudah membawa 50 Ayam Hidup!");
    if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
    {
        if(pData[playerid][pActivityTime] >= 100)
        {
            if(IsPlayerInRangeOfPoint(playerid, 2.0, -2107.4541,-2400.1042,31.4123))
            {
                    Info(playerid, "Anda telah berhasil mengambil Ayam Hidup.");
                    TogglePlayerControllable(playerid, 1);
                    InfoTD_MSG(playerid, 8000, "~g~Ayam Hidup +1");
                    pData[playerid][AyamHidup] += 1;
                    KillTimer(pData[playerid][pPemotong]);
                    pData[playerid][pActivityTime] = 0;
                    HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
                    PlayerTextDrawHide(playerid, ActiveTD[playerid]);
                    //pData[playerid][pEnergy] -= 3;
                    ClearAnimations(playerid);            
            }
            else
            {
                KillTimer(pData[playerid][pPemotong]);
                pData[playerid][pActivityTime] = 0;
                HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
                PlayerTextDrawHide(playerid, ActiveTD[playerid]);
                return 1;
            }
        }
        else if(pData[playerid][pActivityTime] < 100)
        {
            {
                pData[playerid][pActivityTime] += 5;
                SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
                ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 1, 1, 1);
            }
        }
    }
    return 1;
}*/

forward getchicken(playerid);
public getchicken(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(pData[playerid][pActivityTime] >= 100)
    {
        Info(playerid, "Anda telah berhasil mengambil Ayam Hidup.");
        TogglePlayerControllable(playerid, 1);
        InfoTD_MSG(playerid, 800, "~g~Ayam Hidup +1");
        KillTimer(ayamjob[playerid]);
        pData[playerid][pActivityTime] = 0;
        Ayammati -= 1;
        pData[playerid][pPemotongStatus] -= 1;
        pData[playerid][AyamHidup] = 1;
        HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
        PlayerTextDrawHide(playerid, ActiveTD[playerid]);
        pData[playerid][pEnergy] -= 1;
        ClearAnimations(playerid);
        return 1;
    }
    else if(pData[playerid][pActivityTime] < 100)
    {
        pData[playerid][pActivityTime] += 5;
        SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
        ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 1, 1, 1, 1, 1);
    }
    return 1;
}

/*CMD:potongayam(playerid, params[])
{
    new total = pData[playerid][AyamPotong];
    if(total > 50) return Error(playerid, "Ayam Potong terlalu penuh di Inventory! Maximal 50.");
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, -2110.3020,-2408.2725,31.3098)) return Error(playerid, "Kamu Tidak Di Tempat Pengolah Ayam.");
    if(pData[playerid][pPemotongStatus] == 1) return Error(playerid, "Anda Masih Proses Ayam");
    if(pData[playerid][AyamPotong] == 50) return Error(playerid, "Anda sudah membawa 50 Ayam Potong!");
    if(pData[playerid][AyamHidup] < 1) return Error(playerid, "Kamu Tidak Mengambil Ayam Hidup.");  
    TogglePlayerControllable(playerid, 0);
    Info(playerid, "Anda sedang Memotong Ayam!");
    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
    pData[playerid][pPemotongStatus] += 1;
    pData[playerid][pPemotong] = SetTimerEx("frychicken", 1100, true, "id", playerid, 1);
    PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Memotong...");
    PlayerTextDrawShow(playerid, ActiveTD[playerid]);
    ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
    return 1;
}*/

CMD:potongayam(playerid, params[])
{
    if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
    {
        if(pData[playerid][pPemotongStatus] == 1) return Error(playerid, "Anda Masih potong Ayam");
        if(!IsPlayerInRangeOfPoint(playerid, 5.0, -2110.3020,-2408.2725,31.3098)) return Error(playerid, "Kamu Tidak Di Tempat Pemotongan Ayam.");
        if(pData[playerid][AyamPotong] == 1) return Error(playerid, "Anda sudah membawa Ayam Potong!");
        if(pData[playerid][AyamHidup] < 1) return Error(playerid, "Kamu Tidak Mengambil Ayam Hidup.");
        if(GetPlayerWeapon(playerid) != WEAPON_KNIFE) return Error(playerid, "You need holding a knife(pisau)!");
        {
            pData[playerid][pPemotongStatus] += 1;

            TogglePlayerControllable(playerid, 0);
            Info(playerid, "Anda sedang Memotong Ayam!");
            ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
            ayamjob[playerid] = SetTimerEx("frychicken", 1100, true, "id", playerid);
            PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Memotong...");
            PlayerTextDrawShow(playerid, ActiveTD[playerid]);
            ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
        }
    }
    else return Error(playerid, "anda bukan pekerja Pemotong Ayam!");
    return 1;
}


/*function frychicken(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(pData[playerid][AyamPotong] == 50) return Error(playerid, "Anda sudah membawa 50 Ayam Potong!");
    if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
    {
        if(pData[playerid][pActivityTime] >= 100)
        {
            if(IsPlayerInRangeOfPoint(playerid, 5.0, -2111.8376,-2410.1389,31.2962))
            {
                    Info(playerid, "Anda telah berhasil Memotong.");
                    TogglePlayerControllable(playerid, 1);
                    InfoTD_MSG(playerid, 8000, "~r~Ayam Hidup -1\n~g~Ayam Potong +5!");
                    pData[playerid][AyamPotong] += 5;
                    pData[playerid][AyamHidup] -= 1;
                    KillTimer(pData[playerid][pPemotong]);
                    pData[playerid][pActivityTime] = 0;
                    HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
                    PlayerTextDrawHide(playerid, ActiveTD[playerid]);
                    pData[playerid][pEnergy] -= 2;
                    ClearAnimations(playerid);
                    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
            }
            else
            {
                KillTimer(pData[playerid][pPemotong]);
                pData[playerid][pActivityTime] = 0;
                HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
                PlayerTextDrawHide(playerid, ActiveTD[playerid]);
                return 1;
            }
        }
        else if(pData[playerid][pActivityTime] < 100)
        {
            if(IsPlayerInRangeOfPoint(playerid, 5.0, -2111.8376,-2410.1389,31.2962))
            {
                pData[playerid][pActivityTime] += 5;
                SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
                ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
            }
        }
    }
    return 1;
}*/

forward frychicken(playerid);
public frychicken(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(pData[playerid][pActivityTime] >= 100)
    {
        Info(playerid, "Anda telah berhasil Memotong.");
        TogglePlayerControllable(playerid, 1);
        InfoTD_MSG(playerid, 800, "~r~Ayam Hidup = 0\n~g~Ayam Potong = 1!");
        KillTimer(ayamjob[playerid]);
        pData[playerid][pActivityTime] = 0;
        pData[playerid][AyamPotong] = 1;
        pData[playerid][AyamHidup] = 0;
        pData[playerid][pPemotongStatus] -= 1;
        HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
        PlayerTextDrawHide(playerid, ActiveTD[playerid]);
        pData[playerid][pEnergy] -= 2;
        ClearAnimations(playerid);
        return 1;
    }
    else if(pData[playerid][pActivityTime] < 100)
    {
        pData[playerid][pActivityTime] += 5;
        SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
        ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
    }
    return 1;
}


/*CMD:packingayam(playerid, params[])
{
    new total = pData[playerid][AyamFillet];
    if(total > 50) return Error(playerid, "Ayam Fillet terlalu penuh di Inventory! Maximal 50.");
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2117.5095,-2414.5049,31.2266)) return Error(playerid, "Kamu Tidak Di Tempat Pengolah Ayam.");
    if(pData[playerid][AyamFillet] == 50) return Error(playerid, "Anda sudah membawa 50 Ayam Fillet!");
    if(pData[playerid][AyamPotong] < 3)
    return Error(playerid, "Anda Butuh 3 Ayam Potong.");
    TogglePlayerControllable(playerid, 0);
    Info(playerid, "Anda sedang Membungkus Ayam!");
    ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
    pData[playerid][pPemotongStatus] += 1;
    pData[playerid][pPemotong] = SetTimerEx("packingchicken", 1000, true, "id", playerid, 1);
    PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Membungkus...");
    PlayerTextDrawShow(playerid, ActiveTD[playerid]);
    ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
    return 1;
}*/

CMD:packingayam(playerid, params[])
{
    if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
    {
        if(pData[playerid][pPemotongStatus] == 1) return Error(playerid, "Anda masih packing ayam");
        if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2117.5095,-2414.5049,31.2266)) return Error(playerid, "Kamu Tidak Di Tempat Packing Ayam.");
        if(pData[playerid][AyamPotong] < 1) return Error(playerid, "Anda Tidak Punya Ayam Potong.");
        if(pData[playerid][AyamFillet] == 1) return Error(playerid, "Anda sudah membawa Ayam Fillet!");
        {
            pData[playerid][pPemotongStatus] += 1;

            TogglePlayerControllable(playerid, 0);
            Info(playerid, "Anda sedang Membungkus Ayam!");
            ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
            ayamjob[playerid] = SetTimerEx("packingchicken", 1000, true, "id", playerid);
            PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Membungkus...");
            PlayerTextDrawShow(playerid, ActiveTD[playerid]);
            ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
        }
    }
    else return Error(playerid, "anda bukan pekerja Pemotong Ayam!");
    return 1;
}

/*function packingchicken(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(pData[playerid][AyamFillet] == 50) return Error(playerid, "Anda sudah membawa 50 Ayam Fillet!");
    if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
    {
        if(pData[playerid][pActivityTime] >= 100)
        {
            if(IsPlayerInRangeOfPoint(playerid, 3.0, -2117.5095,-2414.5049,31.2266))
            {
                    Info(playerid, "Anda telah berhasil Mengpacking Ayam Potong.");
                    TogglePlayerControllable(playerid, 1);
                    InfoTD_MSG(playerid, 8000, "~r~Ayam Potong -3\n~g~Ayam Fillet +1");
                    pData[playerid][AyamFillet] += 1;
                    pData[playerid][AyamPotong] -= 3;
                    KillTimer(pData[playerid][pPemotong]);
                    pData[playerid][pActivityTime] = 0;
                    HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
                    PlayerTextDrawHide(playerid, ActiveTD[playerid]);
                    pData[playerid][pEnergy] -= 2;
                    ClearAnimations(playerid);
            }
            else
            {
                KillTimer(pData[playerid][pPemotong]);
                pData[playerid][pActivityTime] = 0;
                HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
                PlayerTextDrawHide(playerid, ActiveTD[playerid]);
                return 1;
            }
        }
        else if(pData[playerid][pActivityTime] < 100)
        {
            {
                pData[playerid][pActivityTime] += 5;
                SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
                ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
            }
        }
    }
    return 1;
}*/

forward packingchicken(playerid);
public packingchicken(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(pData[playerid][pActivityTime] >= 100)
    {
        Info(playerid, "Anda telah berhasil Mengpacking Ayam Potong.");
        TogglePlayerControllable(playerid, 1);
        //InfoTD_MSG(playerid, 800, "~r~Ayam Potong -3\n~g~Ayam Fillet +1");
        KillTimer(ayamjob[playerid]);
        pData[playerid][pActivityTime] = 0;
        GivePlayerMoneyEx(playerid, 30);
        pData[playerid][AyamPotong] = 0;
        Ayampaket += 3;
        pData[playerid][pPemotongStatus] -= 1;
        HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
        PlayerTextDrawHide(playerid, ActiveTD[playerid]);
        pData[playerid][pEnergy] -= 2;
        ClearAnimations(playerid);
        return 1;
    }
    else if(pData[playerid][pActivityTime] < 100)
    {
        pData[playerid][pActivityTime] += 5;
        SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
        ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
    }
    return 1;
}

CMD:jualayam(playerid, params[])
{

	if(!IsPlayerInRangeOfPoint(playerid, 3.5, 921.7545,-1299.1313,14.0938))
		return Error(playerid, "Kamu Tidak Berada Di Gudang Ayam!");
	
	if(pData[playerid][AyamFillet] < 1) return Error(playerid, "You dont have ayam!");
	new pay = pData[playerid][AyamFillet] * AyamFillPrice;
	new total = pData[playerid][AyamFillet];
	//GivePlayerMoneyEx(playerid, pay);
	AyamFill += total;
	Server_MinMoney(pay);

	Info(playerid, "You selling "RED_E"%d kg "WHITE_E"ayam to "GREEN_E"%s", total, FormatMoney(pay));
	pData[playerid][AyamFillet] = 0;
	return 1;
}

/*CMD:jualayam(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 901.1880,-1203.3790,16.9832)) return Error(playerid, "Kamu Tidak Di Area Industry.");
    if(pData[playerid][AyamFillet] < 1) return Error(playerid, "Kamu Tidak Memiliki Ayam Fillet.");

    GivePlayerMoneyEx(playerid, 50);

    pData[playerid][pAyambungkus] -= 1;
    Info(playerid, "Anda menjual Ayam Seharga "GREEN_E"$1500");
    return 1;
}*/


