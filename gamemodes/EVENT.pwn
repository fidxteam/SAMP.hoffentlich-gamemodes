// TDM

CMD:createtdm(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pEventModerator] < 1)
			return PermissionError(playerid);

    if(EventCreated > 0)
    	return Error(playerid, "Event sudah pernah dibuat");

	foreach(new i : Player)
	{
    	Info(i, "Event tdm dibuat, gunakan /jointdm untuk join ( gc sebelum waktu habis, 20 detik )");
    	Info(i, "Simpan senjata mu dulu di bagasi atau tempat penyimpanan lainnya sebelum memasukin tdm");
	}
	SetTimer("Cdtdm", 15000, false);
    EventCreated = 1;
    EventLocked = 0;
    return 1;
}

forward Cdtdm();
public Cdtdm()
{
	foreach(new i : Player)
	{
	    Info(i, "5 detik lagi");
	}
	SetTimer("Mulaitdm", 5000, false);
}
forward Mulaitdm();
public Mulaitdm()
{
    EventLocked = 1;
    foreach(new i : Player)
    {
        if(IsAtEvent[i] == 1)
        {
            ResetPlayerWeapons(i);
				GivePlayerWeaponEx(i, 24, 500);
				GivePlayerWeaponEx(i, 25, 500);
				GivePlayerWeaponEx(i, 30, 500);
			Info(i, "Gasken perang");
		}
	}
	Anjaytdm = SetTimer("Endtdm", 300000, false);
}

forward Endtdm();
public Endtdm()
{
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
			if(killblue == killred)
	    	{
	    	    if(GetPlayerTeam(i) == 2)
				{
				    GivePlayerMoneyEx(i, 5 * killred);
					SendClientMessageEx(i, -1, "Kalian seri, hadiah = %d di kali 5 = %d dollar", killred, killred*5);
				}
				if(GetPlayerTeam(i) == 1)
				{
				    GivePlayerMoneyEx(i, 5 * killred);
					SendClientMessageEx(i, -1, "Kalian seri, hadiah = %d di kali 5 = %d dollar", killred, killred * 5);
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
			SetPlayerHealthEx(i, 100.0);
			SetPlayerTeam(i, 0);
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

CMD:leavetdm(playerid, params[])
{
	if(IsAtEvent[playerid] == 0)
    	return Error(playerid, "Anda tidak berada di TDM");

    if(IsAtEvent[playerid] == 1 && EventStarted == 1)
    	return Error(playerid, "Anda tidak dapat keluar saat Match Dimulai");

    IsAtEvent[playerid] = 0;
    Servers(playerid, "Anda berhasil keluar dari Event TDM");
    SetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
    return 1;
}

CMD:starttdm(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pEventModerator] < 1)
			return PermissionError(playerid);

    if(EventCreated < 1)
    	return Error(playerid, "Belum ada event TDM yang sedang dibuat");

    if(EventLocked == 0)
    	return Error(playerid, "Event sudah dibuka");

    if(EventStarted == 1)
    	return Error(playerid, "Event Sedang dimulai");

    if(BlueTeam == 0)
    	return Error(playerid, "Suatu Pemain dalam tim biru belum mencukupi");

    if(RedTeam == 0)
    	return Error(playerid, "Suatu Pemain dalam tim merah belum mencukupi");

    Count = 6;
    countTimer = SetTimer("pCountDown", 1000, 1);
    EventStarted = 1;

    foreach(new ii : Player)
    {
    	if(IsAtEvent[ii] == 1)
    	{
    		showCD[ii] = 1;
    	}
    }
    return 1;
}

CMD:tdmhelp(playerid)
{
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pEventModerator] < 1)
			return PermissionError(playerid);

    Usage(playerid, "/settdminfo /tdmpos /endtdm /starttdm /locktdm /announceevent");
    return 1;
}

CMD:endtdm(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pEventModerator] < 1)
			return PermissionError(playerid);

    if(EventCreated < 1)
    	return Error(playerid, "Belum ada event TDM yang sedang dibuat");

    EventStarted = 0;
    EventInt = 0;
    EventWorld = 0;
    EventHP = 100;
    EventArmour = 0;
    EventLocked = 1;
    EventWeapon1 = 0;
    EventWeapon2 = 0;
    EventWeapon3 = 0;
    EventWeapon4 = 0;
    EventWeapon5 = 0;
    BlueX = 0;
    BlueY = 0;
    BlueZ = 0;
    RedX = 0;
    RedY = 0;
    RedZ = 0;
    RedTeam = 0;
    BlueTeam = 0;
    MaxBlueTeam = 0;
    MaxRedTeam = 0;
    foreach(new ii : Player)
    {
    	if(IsAtEvent[ii] == 1)
    	{
    		IsAtEvent[ii] = 0;
    	}
    }
    Servers(playerid, "Berhasil End TDM");
    return 1;
}

CMD:jointdm(playerid, params[])
{
	if(EventCreated < 1)
    	return Error(playerid, "Belum ada event TDM yang sedang dibuat");

    if(EventLocked == 1)
    	return Error(playerid, "Event di kunci");

    if(IsAtEvent[playerid] == 1)
    	return Error(playerid, "Anda sudah berada di TDM");

    if(IsPlayerInAnyVehicle(playerid))
    	return Error(playerid, "Harap turun dari kendaraan sebelum bergabung kedalam Event");

    if(pData[playerid][pSideJob] > 1)
    	return Error(playerid, "Selesaikan terlebih dahulu Pekerjaan mu");

    if(pData[playerid][pOnDuty] > 1)
    	return Error(playerid, "Harap off duty terlebih dahulu");

    UpdatePlayerData(playerid);
     new
		Float:x,
		Float:y,
		Float:z,
		Float:r;

	pData[playerid][pCoint] = GetPlayerInterior(playerid);
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, r);
	pData[playerid][pCox] = x;
	pData[playerid][pCoy] = y;
	pData[playerid][pCoz] = z;
	pData[playerid][pCoa] = r;
    new string[512];
    format(string, sizeof(string),"Team\tPlayer\n{ff0000}Red\t{7fff00}(%d)\n{7fffd4}Blue\t{7fff00}(%d)", RedTeam, BlueTeam);
    ShowPlayerDialog(playerid, DIALOG_TDM, DIALOG_STYLE_TABLIST_HEADERS, "Team Deathmatch", string, "Select","");
    return 1;
}

CMD:settdminfo(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pEventModerator] < 1)
			return PermissionError(playerid);

    if(EventCreated < 1)
    	return Error(playerid, "Belum ada event TDM yang sedang dibuat");
		
	new name[64], string[128];
	if(sscanf(params, "s[64]S()[128]", name, string))
    {
        Usage(playerid, "/settdminfo [name] [id/amount]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF}[health] [armor] [maxplayer] [prize] [weapon1], [weapon2], [weapon3], [weapon4] [weapon5]");
        return 1;
    }
    if(!strcmp(name, "health", true))
    {
    	new health;
        if(sscanf(string, "d", health))
            return Usage(playerid, "/settdminfo [health] [amount]");

        EventHP = health;
        SendAdminMessage(COLOR_RED, "%s set Health tdm to %d.", pData[playerid][pAdminname], health);
    }
    if(!strcmp(name, "prize", true))
    {
    	new health;
        if(sscanf(string, "d", health))
            return Usage(playerid, "/settdminfo [prize] [amount]");

        EventPrize = health;
        SendAdminMessage(COLOR_RED, "%s set Prize tdm to %d.", pData[playerid][pAdminname], health);
    }
    if(!strcmp(name, "armor", true))
    {
    	new armor;
        if(sscanf(string, "d", armor))
            return Usage(playerid, "/settdminfo [armor] [amount]");

        EventArmour = armor;
        SendAdminMessage(COLOR_RED, "%s set Armour tdm to %d.", pData[playerid][pAdminname], armor);
    }
    if(!strcmp(name, "maxplayer", true))
    {
    	new armor;
        if(sscanf(string, "d", armor))
            return Usage(playerid, "/settdminfo [maxplayer] [amount]");

        MaxRedTeam = armor;
        MaxBlueTeam = armor;
        SendAdminMessage(COLOR_RED, "%s set maxplayer tdm to %d.", pData[playerid][pAdminname], armor);
    }
	if(!strcmp(name, "weapon1", true))
    {
    	new weaponid;
        if(sscanf(string, "d", weaponid))
            return Usage(playerid, "/settdminfo [weapon1] [weapon id]");

        if(weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
        return Error(playerid, "You have specified an invalid weapon.");

        EventWeapon1 = weaponid;
        SendAdminMessage(COLOR_RED, "%s set weapon 1 tdm to %d.", pData[playerid][pAdminname], ReturnWeaponName(weaponid));
    }
    if(!strcmp(name, "weapon2", true))
    {
    	new weaponid;
        if(sscanf(string, "d", weaponid))
            return Usage(playerid, "/settdminfo [weapon2] [weapon id]");

        if(weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
        return Error(playerid, "You have specified an invalid weapon.");

        EventWeapon2 = weaponid;
        SendAdminMessage(COLOR_RED, "%s set weapon 2 tdm to %d.", pData[playerid][pAdminname], ReturnWeaponName(weaponid));
    }
    if(!strcmp(name, "weapon3", true))
    {
    	new weaponid;
        if(sscanf(string, "d", weaponid))
            return Usage(playerid, "/settdminfo [weapon3] [weapon id]");

        if(weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
        return Error(playerid, "You have specified an invalid weapon.");

        EventWeapon3 = weaponid;
        SendAdminMessage(COLOR_RED, "%s set weapon 3 tdm to %d.", pData[playerid][pAdminname], ReturnWeaponName(weaponid));
    }
    if(!strcmp(name, "weapon4", true))
    {
		new weaponid;
        if(sscanf(string, "d", weaponid))
            return Usage(playerid, "/settdminfo [weapon4] [weapon id]");

        if(weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
        return Error(playerid, "You have specified an invalid weapon.");

        EventWeapon4 = weaponid;
        SendAdminMessage(COLOR_RED, "%s set weapon 4 tdm to %d.", pData[playerid][pAdminname], ReturnWeaponName(weaponid));
    }
    if(!strcmp(name, "weapon5", true))
    {
    	new weaponid;
        if(sscanf(string, "d", weaponid))
            return Usage(playerid, "/settdminfo [weapon5] [weapon id]");

        if(weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
        return Error(playerid, "You have specified an invalid weapon.");

        EventWeapon5 = weaponid;
        SendAdminMessage(COLOR_RED, "%s set weapon 5 tdm to %d.", pData[playerid][pAdminname], ReturnWeaponName(weaponid));
    }
    return 1;
}

CMD:announceevent(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pEventModerator] < 1)
			return PermissionError(playerid);

    if(EventCreated < 1)
    	return Error(playerid, "Belum ada event TDM yang sedang dibuat");

    SendClientMessageToAll(-1, "{ffff00}[ANNOUNCEMENT]{7fff00} Event dibuka! /jointdm untuk masuk!");
    return 1;
}

CMD:locktdm(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pEventModerator] < 1)
			return PermissionError(playerid);

    if(EventCreated < 1)
    	return Error(playerid, "Belum ada event TDM yang sedang dibuat");

    
    if(EventLocked == 1)
    {
    	EventLocked = 0;
    	Servers(playerid, "Event berhasil dibuka!");
    }
    else if(EventLocked == 0)
    {
    	EventLocked = 1;
    	Servers(playerid, "Event berhasil dikunci!");
    }
    return 1;
}

CMD:tdmpos(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		if(pData[playerid][pEventModerator] < 1)
			return PermissionError(playerid);

    if(EventCreated < 1)
    	return Error(playerid, "Belum ada event TDM yang sedang dibuat");
		
	new name[64];
	if(sscanf(params, "s[64]", name))
    {
        Usage(playerid, "/tdmpos [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} [Red], [Blue]");
        return 1;
    }
    if(!strcmp(name, "red", true))
    {
    	GetPlayerPos(playerid, RedX, RedY, RedZ);
    	EventInt = GetPlayerInterior(playerid);
    	EventWorld = GetPlayerVirtualWorld(playerid);
        SendAdminMessage(COLOR_RED, "%s set red pos to %0.2f %0.2f %0.2f .", pData[playerid][pAdminname], RedX, RedY, RedZ);
    }
    if(!strcmp(name, "blue", true))
    {
    	GetPlayerPos(playerid, BlueX, BlueY, BlueZ);
    	EventInt = GetPlayerInterior(playerid);
    	EventWorld = GetPlayerVirtualWorld(playerid);
        SendAdminMessage(COLOR_RED, "%s set blue pos to %0.2f %0.2f %0.2f .", pData[playerid][pAdminname], BlueX, BlueY, BlueZ);
    }
    return 1;
}
