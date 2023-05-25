stock ShowPlayerJail(playerid, targetid)
{
	new query[512], list[2024], admin[32], reason[37], date[40], time;
	mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM jailrecord WHERE owner = '%d' ORDER BY id ASC", pData[targetid][pID]);
	mysql_query(g_SQL, query);
	new rows = cache_num_rows();
	if(rows)
	{
	    format(list, sizeof(list), "Admin\tReason\tMinute\tDate\n");
		for(new i; i < rows; ++i)
	    {
	        cache_get_value_name(i, "admin", admin);
	        cache_get_value_name_int(i, "time", time);
	        cache_get_value_name(i, "date", date);
	        cache_get_value_name(i, "reason", reason);

	        format(list, sizeof(list), "%s%s\t%s\t%d\t%s\n", list, admin, reason, time, date);
		}
		new title[56];
		format(title, sizeof(title), "%s Jail Records", GetName(targetid));
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, title, list, "Close", "");
	}
	else
	{
	    SendServerMessage(playerid, "There is no jail records to display.");
	}
	return 1;
}

CMD:unjail(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new targetid, reason[64];
	if(sscanf(params, "us[64]", targetid, reason))
	    return SendSyntaxMessage(playerid, "/release [playerid] [reason]");

	if(targetid == INVALID_PLAYER_ID)
	    return Error(playerid, "Invalid player ID!");

	if(pData[targetid][pJailTime] <= 0)
	    return Error(playerid, "That player is not jailed!");

	if(pData[targetid][pArrest])
	    return Error(playerid, "You can't release Prisoned Player! (IC Jail)");

	pData[targetid][pJailTime] = 0;
	PlayerTextDrawHide(targetid, JAILTD[targetid]);
	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s has been unjail from admin jail by %s", GetName(targetid), pData[playerid][pName]);
	SendClientMessageToAllEx(COLOR_LIGHTRED, "Reason: %s", reason);
	SetPlayerPos(targetid, 1543.8755,-1675.7900,13.5573);
	SetPlayerInterior(targetid, 0);
	SetPlayerVirtualWorld(targetid, 0);
	return 1;
}

CMD:showjail(playerid, params[])
{
    ShowPlayerJail(playerid, playerid);
    return 1;
}

IPRP::OnOfflineJailed(playerid, reason[], minutes, pname[])
{
	new count = cache_num_rows(), name[32], id, query[256];
	if(count > 0)
	{
		cache_get_value_name(0, "username", name);
		cache_get_value_name_int(0, "reg_id", id);

		format(query,sizeof(query),"UPDATE `players` SET `jail_time` = '%d' WHERE `username` = '%s'", minutes*60, pname);
		mysql_tquery(g_SQL, query);

		new qquery[512];
		mysql_format(g_SQL, qquery, sizeof(qquery), "INSERT INTO jailrecord(owner, time, admin, reason, date) VALUES ('%d', '%d', '%s', '%s', CURRENT_TIMESTAMP())", id, minutes, pData[playerid][pName], reason);
		mysql_tquery(g_SQL, qquery);

		SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s has Offline Jailed %s for %d minutes", pData[playerid][pName], name, minutes);
		SendClientMessageToAllEx(COLOR_LIGHTRED, "Reason: %s", reason);
	}
	else
	{
	    SendErrorMessage(playerid, "That name is doesn't exists on the database!");
	}
	return 1;
}

IPRP::OnOfflineFc(playerid, posx, posa, pname[])
{
	new count = cache_num_rows(), name[32], id, query[256];
	if(count > 0)
	{
		cache_get_value_name(0, "username", name);
		cache_get_value_name_int(0, "reg_id", id);

		format(query,sizeof(query),"UPDATE players SET posx='%f',posy='-2332.70',posz='13.54',posa='%f' WHERE username='%s'", posx, posa, pname);
		mysql_tquery(g_SQL, query);

	
	}
	else
	{
	    SendErrorMessage(playerid, "That name is doesn't exists on the database!");
	}
	return 1;
}

IPRP::OnOfflineAdmin(playerid, pname[])
{
	new count = cache_num_rows(), name[32], id, query[256];
	if(count > 0)
	{
		cache_get_value_name(0, "username", name);
		cache_get_value_name_int(0, "reg_id", id);

		format(query,sizeof(query),"UPDATE players SET adminname='None',admin='0' WHERE username='%s'", pname);
		mysql_tquery(g_SQL, query);


	}
	else
	{
	    SendErrorMessage(playerid, "That name is doesn't exists on the database!");
	}
	return 1;
}

IPRP::OnOfflineFac(playerid, pname[])
{
	new count = cache_num_rows(), name[32], id, query[256];
	if(count > 0)
	{
		cache_get_value_name(0, "username", name);
		cache_get_value_name_int(0, "reg_id", id);

		format(query,sizeof(query),"UPDATE players SET faction='0',factionrank='0' WHERE username='%s'", pname);
		mysql_tquery(g_SQL, query);


	}
	else
	{
	    SendErrorMessage(playerid, "That name is doesn't exists on the database!");
	}
	return 1;
}
CMD:deletefaction(playerid, params[])
{
	if(pData[playerid][pAdmin] < 25)
	    return PermissionError(playerid);

	new minutes, name[32], reason[64];
	if(sscanf(params, "s[32]", name))
	    return SendSyntaxMessage(playerid, "/deleteadmin [Character_Name]");


	new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `players` WHERE `username` = '%s' LIMIT 1", name);
	mysql_tquery(g_SQL, characterQuery, "OnOfflineFac", "ds", playerid, name);
	return 1;
}
CMD:deleteadmin(playerid, params[])
{
	if(pData[playerid][pAdmin] < 25)
	    return PermissionError(playerid);

	new minutes, name[32], reason[64];
	if(sscanf(params, "s[32]", name))
	    return SendSyntaxMessage(playerid, "/deleteadmin [Character_Name]");


	new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `players` WHERE `username` = '%s' LIMIT 1", name);
	mysql_tquery(g_SQL, characterQuery, "OnOfflineAdmin", "ds", playerid, name);
	return 1;
}
CMD:ojail(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
	    return PermissionError(playerid);

	new minutes, name[32], reason[64];
	if(sscanf(params, "s[32]ds[64]", name, minutes, reason))
	    return SendSyntaxMessage(playerid, "/ojail [Character_Name] [time in minute] [reason]");

	if(minutes < 1)
	    return SendErrorMessage(playerid, "Invalid minute!");

	new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `players` WHERE `username` = '%s' LIMIT 1", name);
	mysql_tquery(g_SQL, characterQuery, "OnOfflineJailed", "dsds", playerid, reason, minutes, name);
	return 1;
}

CMD:fixfc(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
	    return PermissionError(playerid);

	new minutes, name[32], reason[64];
	if(sscanf(params, "s[32]", name))
	    return SendSyntaxMessage(playerid, "/fixfc [Character_Name");

	new Float:posx, Float:posy, Float:posz, Float:posa;
	posx = 1642.09;
	posy = -2332.70;
	posz = 13.54;
	posa = 4.46;
	new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `players` WHERE `username` = '%s' LIMIT 1", name);
	mysql_tquery(g_SQL, characterQuery, "OnOfflineFc", "dffs", playerid, posx, posa, name);
	return 1;
}
CMD:jail(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new
		minutes, targetid, reason[640];

	if(sscanf(params, "uds[64]", targetid, minutes, reason))
	    return SendSyntaxMessage(playerid, "/jail [playerid] [time in minute] [reason]");

	if(targetid == INVALID_PLAYER_ID)
	    return SendErrorMessage(playerid, "Invalid player ID!");

	if(minutes < 1)
	    return SendErrorMessage(playerid, "Invalid Minute!");
	    
    if(targetid != playerid && pData[targetid][pAdmin] > 25)
        return ErrorMsg(playerid, "You can't spectate admin higher than you.");

	pData[targetid][pJailTime] = minutes* 60;
	SendClientMessageToAllEx(COLOR_LIGHTRED, "AdmCmd: %s has been Jailed %s for %d Minutes.", pData[playerid][pName], GetName(targetid), minutes);
	SendClientMessageToAllEx(COLOR_LIGHTRED, "Reason: %s", reason);
    SetPlayerPositionEx(targetid, -310.64, 1894.41, 34.05, 178.17, 2000);
    SetPlayerInterior(targetid, 3);
    PlayerTextDrawShow(targetid, JAILTD[targetid]);
	SetPlayerVirtualWorld(targetid, (playerid + 100));
 	SetPlayerFacingAngle(targetid, 0.0);
	SetCameraBehindPlayer(targetid);
	UpdatePlayerData(targetid);
	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO jailrecord(owner, time, admin, reason, date) VALUES ('%d', '%d', '%s', '%s', CURRENT_TIMESTAMP())", pData[targetid][pID], minutes, pData[playerid][pName], reason);
	mysql_tquery(g_SQL, query);

	return 1;
}
