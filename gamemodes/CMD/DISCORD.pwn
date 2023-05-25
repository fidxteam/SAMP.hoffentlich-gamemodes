forward DCC_DM(str[]);
public DCC_DM(str[])
{
    new DCC_Channel:PM;
	PM = DCC_GetCreatedPrivateChannel();
	DCC_SendChannelMessage(PM, str);
	return 1;
}

forward DCC_DM_EMBED(str[], pin, id[]);
public DCC_DM_EMBED(str[], pin, id[])
{
    new DCC_Channel:PM, query[2000];
	PM = DCC_GetCreatedPrivateChannel();

	new DCC_Embed:embed = DCC_CreateEmbed(.title="HOFFENTLICH ROLEPLAY");
	new str1[1000], str2[1000];

	format(str1, sizeof str1, "```\nHallo!\nSelamat UCP anda berhasil terverifikasi,\nGunakan PIN di bawah ini Untuk Register InGame!```");
	DCC_SetEmbedDescription(embed, str1);
	format(str1, sizeof str1, "UCP");
	format(str2, sizeof str2, "\n```%s```", str);
	DCC_AddEmbedField(embed, str1, str2, bool:1);
	format(str1, sizeof str1, "PIN");
	format(str2, sizeof str2, "\n```%d```", pin);
	DCC_AddEmbedField(embed, str1, str2, bool:1);
	DCC_SetEmbedColor(embed, 0xff0000);
	new y, m, d, timestamp[20];
   	getdate(y, m , d);
    format(timestamp, sizeof(timestamp), "%02i%02i%02i", y, m, d);
    DCC_SetEmbedTimestamp(embed, timestamp);
    DCC_SetEmbedFooter(embed, "HOFFENTLICH Roleplay");
	DCC_SendChannelEmbedMessage(PM, embed);

	mysql_format(g_SQL, query, sizeof query, "INSERT INTO `playerucp` (`ucp`, `verifycode`, `DiscordID`) VALUES ('%e', '%d', '%e')", str, pin, id);
	mysql_tquery(g_SQL, query);
	return 1;
}

forward DCC_PM_EMBED(str[], pin, id[]);
public DCC_PM_EMBED(str[], pin, id[])
{
    new DCC_Channel:PM, query[2000];
	PM = DCC_GetCreatedPrivateChannel();

	new DCC_Embed:embed = DCC_CreateEmbed(.title="HOFFENTLICH ROLEPLAY");
	new str1[1000], str2[1000];

	format(str1, sizeof str1, "```\nHallo!\nNih pin ucp lu!```");
	DCC_SetEmbedDescription(embed, str1);
	format(str1, sizeof str1, "UCP");
	format(str2, sizeof str2, "\n```%s```", str);
	DCC_AddEmbedField(embed, str1, str2, bool:1);
	format(str1, sizeof str1, "PIN");
	format(str2, sizeof str2, "\n```%d```", pin);
	DCC_AddEmbedField(embed, str1, str2, bool:1);
	DCC_SetEmbedColor(embed, 0xff0000);
	new y, m, d, timestamp[20];
   	getdate(y, m , d);
    format(timestamp, sizeof(timestamp), "%02i%02i%02i", y, m, d);
    DCC_SetEmbedTimestamp(embed, timestamp);
    DCC_SetEmbedFooter(embed, "HOFFENTLICH Roleplay");
	DCC_SendChannelEmbedMessage(PM, embed);

	return 1;
}
forward CheckDiscordUCP(DiscordID[], Nama_UCP[]);
public CheckDiscordUCP(DiscordID[], Nama_UCP[])
{
	new rows = cache_num_rows();
	new DCC_Role:WARGA, DCC_Guild:guild, DCC_User: user, dc[1000];
	new verifycode = RandomEx(111111, 988888);
	if(rows > 0)
	{
		return SendDiscordMessage(7, "**[INFO]:** Nama UCP account tersebut sudah terdaftar");
	}
	else 
	{
		guild = DCC_FindGuildById("937318318979829771");
		WARGA = DCC_FindRoleById("1054319497206575124");
		user = DCC_FindUserById(DiscordID);
		DCC_SetGuildMemberNickname(guild, user, Nama_UCP);
		DCC_AddGuildMemberRole(guild, user, WARGA);

		format(dc, sizeof(dc),  "**<!> HOFFENTLICH BOT**\n<:emoji_83:1087750758285447220> UCP **%s** telah terverifikasi", Nama_UCP);
		SendDiscordMessage(7, dc);
		DCC_CreatePrivateChannel(user, "DCC_DM_EMBED", "sds", Nama_UCP, verifycode, DiscordID);
	}
	return 1;
}

forward ReffCheckDiscordUCP(DiscordID[], Nama_UCP[]);
public ReffCheckDiscordUCP(DiscordID[], Nama_UCP[])
{
	new rows = cache_num_rows();
	new DCC_Role:WARGA, DCC_Guild:guild, DCC_User: user, dc[1000];
	new verifycode = RandomEx(111111, 988888);
	if(rows > 0)
	{
		return SendDiscordMessage(12, "**[INFO]:** Nama UCP account tersebut sudah terdaftar");
	}
	else
	{
		guild = DCC_FindGuildById("937318318979829771");
		WARGA = DCC_FindRoleById("1054319497206575124");
		user = DCC_FindUserById(DiscordID);
		DCC_SetGuildMemberNickname(guild, user, Nama_UCP);
		DCC_AddGuildMemberRole(guild, user, WARGA);

		format(dc, sizeof(dc),  "__**<!> HOFFENTLICH BOT**__\n:white_check_mark: UCP **%s** berhasil terverifikasi kembali", Nama_UCP);
		SendDiscordMessage(12, dc);
		DCC_CreatePrivateChannel(user, "DCC_DM_EMBED", "sds", Nama_UCP, verifycode, DiscordID);
	}
	return 1;
}

forward CheckDiscordID(DiscordID[], Nama_UCP[]);
public CheckDiscordID(DiscordID[], Nama_UCP[])
{
	new rows = cache_num_rows(), ucp[200], dc[1000], DCC_User:user, DCC_Guild:guild, DCC_Role:WARGA;
	if(rows > 0)
	{
		cache_get_value_name(0, "ucp", ucp);
		format(dc, sizeof(dc),  "**[INFO]:** Kamu sudah mendaftar UCP sebelumnya dengan nama **%s**", ucp);
		guild = DCC_FindGuildById("937318318979829771");
		WARGA = DCC_FindRoleById("1054319497206575124");
		user = DCC_FindUserById(DiscordID);
		DCC_SetGuildMemberNickname(guild, user, ucp);
		DCC_AddGuildMemberRole(guild, user, WARGA);
		return SendDiscordMessage(7, dc);
	}
	else 
	{
		new characterQuery[178];
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `ucp` = '%s'", Nama_UCP);
		mysql_tquery(g_SQL, characterQuery, "CheckDiscordUCP", "ss", DiscordID, Nama_UCP);
	}
	return 1;
}

forward Dcbener(DiscordID[], Nama_UCP[]);
public Dcbener(DiscordID[], Nama_UCP[])
{
	new rows = cache_num_rows(), ucp[200], pin, ID[210], dc[1000], pm[1000], DCC_User:user, DCC_Guild:guild, DCC_Role:WARGA;
	if(rows > 0)
	{
		cache_get_value_name(0, "ucp", ucp);
		cache_get_value_name_int(0, "verifycode", pin);
		cache_get_value_name(0, "DiscordID", ID);
		format(dc, sizeof(dc),  "**[INFO]:** Cek pm gua", ucp);
		user = DCC_FindUserById(DiscordID);
		format(pm, sizeof(pm),  "**USER PIN:**\n**UCP: %s\nPIN: %d\nID Discord: <@%s>**", ucp, pin, ID);
		DCC_CreatePrivateChannel(user, "DCC_PM_EMBED", "sds", Nama_UCP, pin, DiscordID);

		return SendDiscordMessage(14, dc);
	}
	return 1;
}
forward ReffCheckDiscordID(DiscordID[], Nama_UCP[]);
public ReffCheckDiscordID(DiscordID[], Nama_UCP[])
{
	new rows = cache_num_rows(), ucp[200], dc[1000], DCC_User:user, DCC_Guild:guild, DCC_Role:WARGA;
	if(rows > 0)
	{
		cache_get_value_name(0, "ucp", ucp);
		format(dc, sizeof(dc),  "**[INFO]:** Kamu sudah mendaftar UCP sebelumnya dengan nama **%s**", ucp);
		guild = DCC_FindGuildById("937318318979829771");
		WARGA = DCC_FindRoleById("1054319497206575124");
		user = DCC_FindUserById(DiscordID);
		DCC_SetGuildMemberNickname(guild, user, ucp);
		DCC_AddGuildMemberRole(guild, user, WARGA);
		return SendDiscordMessage(12, dc);
	}
	else
	{
		new characterQuery[178];
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `ucp` = '%s'", Nama_UCP);
		mysql_tquery(g_SQL, characterQuery, "ReffCheckDiscordUCP", "ss", DiscordID, Nama_UCP);
	}
	return 1;
}

forward CheckPIN(Nama_UCP[]);
public CheckPIN(Nama_UCP[])
{
	new rows = cache_num_rows(), ucp[20], dc[1000], pin, ID[210];
	if(rows > 0)
	{
		cache_get_value_name(0, "ucp", ucp);
		cache_get_value_name_int(0, "verifycode", pin);
		cache_get_value_name(0, "DiscordID", ID);

		format(dc, sizeof(dc),  "**USER PIN:**\n**UCP: %s\nPIN: %d\nID Discord: <@%s>**", ucp, pin, ID);
		return SendDiscordMessage(8, dc);
	}
	else 
	{
		SendDiscordMessage(8, "UCP not registered goblok");
	}
	return 1;
}

/*forward Delete(Nama_UCP[]);
public Delete(Nama_UCP[])
{
	new rows = cache_num_rows(), ucp[2000], dc[2000];
	if(rows > 0)
	{
		format(dc, sizeof(dc),  "**UCP: %s Berhasil Di Hapus.**", ucp);
		new characterQuery[178];
	    mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "DELETE * FROM `playerucp` WHERE `ucp` = '%s'", Nama_UCP);
		return SendDiscordMessage(8, dc);
	}
	else
	{
		SendDiscordMessage(8, "UCP not registered goblok");
	}
	return 1;
}*/

DCMD:online(user, channel, params[])
{
 
	new DCC_Embed:embed = DCC_CreateEmbed(.title= "HOFFENTLICH ROLEPLAY");
	new str1[1000], str2[1000];

	format(str1, sizeof str1, "WARGA YANG BERADA DI KOTA SAAT INI %d WARGA DAN SILAHKAN KAMU MASUK KOTA UNTUK MERAMAIKAN KOTA", Iter_Count(Player));
	DCC_SetEmbedDescription(embed, str1);
	DCC_SetEmbedColor(embed, 0x87cefa);
	new yearss, monthh, dayy, timestamp[20];
   	getdate(yearss, monthh , dayy);
    format(timestamp, sizeof(timestamp), "%02i%02i%02i", yearss, monthh, dayy);
    DCC_SetEmbedTimestamp(embed, timestamp);
    DCC_SetEmbedFooter(embed, "HOFFENTLICH ROLEPLAY");
	DCC_SendChannelEmbedMessage(channel, embed);
}

DCMD:setpin(user, channel, params[])
{
 	if(channel != DCC_FindChannelById("1077369037903904900"))
		return DCC_SendChannelMessage(channel, "Salah Channel Goblok!");
    if(isnull(params))
		return DCC_SendChannelMessage(channel, "**<!>**: !setpin [namaUCP] [PIN]");

	/*new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT password FROM playerucp WHERE ucp='%s'", params);
	mysql_tquery(g_SQL, characterQuery, "ChangeUCPpin", "ss", params, params);*/
	new rows = cache_num_rows(), dc[2000];
	if(rows > 0)
	{
	    new characterQuery[178];
	    format(dc, sizeof(dc),  "**UCP: %s Berhasil Di Ganti PIN.**", params);
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "UPDATE playerucp SET verifycode='%s', WHERE ucp='%s'", params, params);
		return SendDiscordMessage(8, dc);
	}
	else
	{
	    SendDiscordMessage(8, "UCP not registered goblok");
	}
	return 1;
}

/*forward ChangeUCPpin(Nama_UCP[], PIN[]);
public ChangeUCPpin(Nama_UCP[], PIN[])
{
	if(cache_num_rows() > 0)
	{
	    new characterQuery[178], dc[2000];
	    format(dc, sizeof(dc),  "**UCP: %s Berhasil Di Ganti PIN.**", Nama_UCP);
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "UPDATE playerucp SET verifycode='%s', WHERE ucp='%s'", PIN, Nama_UCP);
		return SendDiscordMessage(8, dc);
	}
	else
	{
	    SendDiscordMessage(8, "UCP not registered goblok");
	}
    return 1;
}*/

DCMD:register(user, channel, params[])
{
	new id[21];
    if(channel != DCC_FindChannelById("1077369031306248252"))
		return 1;
    if(isnull(params)) 
		return DCC_SendChannelMessage(channel, "**<!>**: !register NamaUCP");
	if(!IsValidNameUCP(params))
		return DCC_SendChannelMessage(channel, "`gunakan nama UCP bukan nama IC!`");
	
	DCC_GetUserId(user, id, sizeof id);

	new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `DiscordID` = '%s'", id);
	mysql_tquery(g_SQL, characterQuery, "CheckDiscordID", "ss", id, params);
	return 1;
}

DCMD:reffucp(user, channel, params[])
{
	new id[21];
    if(channel != DCC_FindChannelById("1077369036591079444"))
		return 1;
    if(isnull(params))
		return DCC_SendChannelMessage(channel, "**<!>**: !reffucp NamaUCP");
	if(!IsValidNameUCP(params))
		return DCC_SendChannelMessage(channel, "**Gunakan nama UCP bukan nama IC!**");

	DCC_GetUserId(user, id, sizeof id);

	new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `DiscordID` = '%s'", id);
	mysql_tquery(g_SQL, characterQuery, "ReffCheckDiscordID", "ss", id, params);
	return 1;
}

DCMD:checkpin(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1077369033818636389"))
		return DCC_SendChannelMessage(channel, "Salah Channel Goblok!");
    if(isnull(params)) 
		return DCC_SendChannelMessage(channel, "**<!>**: !checkpin NamaUCP");

	/*new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `ucp` = '%s'", params);
	mysql_tquery(g_SQL, characterQuery, "CheckPIN", "s", params);*/
	new id[21];
	DCC_GetUserId(user, id, sizeof id);

	new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `DiscordID` = '%s'", id);
	mysql_tquery(g_SQL, characterQuery, "Dcbener", "ss", id, params);
	return 1;
}

DCMD:deleteucp(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1077369035097911466"))
		return DCC_SendChannelMessage(channel, "Salah Channel Goblok!");
    if(isnull(params))
		return DCC_SendChannelMessage(channel, "**<!>**: !deleteucp NamaUCP");
		
	/*new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `ucp` = '%s'", params);
	mysql_tquery(g_SQL, characterQuery, "Delete", "s", params);*/
	new rows = cache_num_rows(), dc[2000];
	if(rows > 0)
	{
		format(dc, sizeof(dc),  "**UCP: %s Berhasil Di Hapus.**", params);
		new characterQuery[178];
	    mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "DELETE * FROM `playerucp` WHERE `ucp` = '%s'", params);
		return SendDiscordMessage(8, dc);
	}
	else
	{
		SendDiscordMessage(8, "UCP not registered goblok");
	}
	return 1;
}

DCMD:ochat(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1077432499694735443"))
		return DCC_SendChannelMessage(channel, "Salah Channel Banh :v!");
    if(isnull(params))
		return DCC_SendChannelMessage(channel, "**<!>**: !ochat Isi pesan");

    SendClientMessageToAllEx(COLOR_WHITE, "DC:%s", params);
}
DCMD:update(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1077368953388662815"))
		return DCC_SendChannelMessage(channel, "Salah Channel Banh :v!");
    if(isnull(params))
		return DCC_SendChannelMessage(channel, "**<!>**: !update Isi updatean");

    new DCC_Embed:embed = DCC_CreateEmbed(.title="UPDATE HOFFENTLICH");
	new str1[1000], str2[1000];

	//format(str1, sizeof str1, params);
	DCC_DeleteMessage(1);
	format(str1, sizeof str1, "**%s**", params);
	DCC_SetEmbedDescription(embed, str1);
	DCC_SetEmbedColor(embed, 0xff0000);
	new y, m, d, timestamp[20];
   	getdate(y, m , d);
    format(timestamp, sizeof(timestamp), "%02i%02i%02i", y, m, d);
    DCC_SetEmbedTimestamp(embed, timestamp);
    DCC_SetEmbedFooter(embed, "HOFFENTLICH ROLEPLAY");
	DCC_SendChannelEmbedMessage(channel, embed);
}
DCMD:p(user, channel, params[])
{
    if(user != DCC_FindUserById("927893335673303080")) return DCC_SendChannelMessage(channel, "Kamu bukan John Smith");
    
	     DCC_DeleteMessage(1);
    		DCC_SendChannelMessage(channel, params);

    
	return 1;
}


DCMD:checkp(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1077432499694735443"))
		return DCC_SendChannelMessage(channel, "Salah Channel Goblok!");
    if(isnull(params)) 
		return DCC_SendChannelMessage(channel, "**<!>**: !checkp NAMA CHARACTER");

	new characterQuery[1780];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `players` WHERE `username` = '%s'", params);
	mysql_tquery(g_SQL, characterQuery, "CheckPlayer", "s", params);
	return 1;
}

forward CheckPlayer(Username[]);
public CheckPlayer(Username[])
{
	new rows = cache_num_rows(), ucp[2000], level, uid, duek, bmoney, redm, skin, comp, mat, band, marju, vip, vipt, boost, boostt, reg[1000], lastlogin[1000], j1, j2, fac;
	if(rows > 0)
	{
		new DCC_Channel:CH, str1[10000], str2[10000];

		CH = DCC_FindChannelById("1077432499694735443");

		cache_get_value_name(0, "ucp", ucp);
		cache_get_value_name_int(0, "level", level);
		cache_get_value_name_int(0, "reg_id", uid);
		cache_get_value_name_int(0, "money", duek);
		cache_get_value_name_int(0, "redmoney", redm);
		cache_get_value_name_int(0, "skin", skin);
		cache_get_value_name_int(0, "bmoney", bmoney);
		cache_get_value_name_int(0, "vip", vip);
		cache_get_value_name_int(0, "vip_time", vipt);
		cache_get_value_name_int(0, "boost", boost);
		cache_get_value_name_int(0, "boost_time", boostt);
		cache_get_value_name(0, "reg_date", reg);
		cache_get_value_name(0, "last_login", lastlogin);
		cache_get_value_name_int(0, "job", j1);
    	cache_get_value_name_int(0, "job2", j2);
    	cache_get_value_name_int(0, "faction", fac);
    	cache_get_value_name_int(0, "component", comp);
    	cache_get_value_name_int(0, "material", mat);
    	cache_get_value_name_int(0, "marijuana", marju);
    	cache_get_value_name_int(0, "bandage", band);

		new DCC_Embed:embed = DCC_CreateEmbed(.title = "Account Players");

		format(str1, sizeof str1, "**Name UCP:**");
		format(str2, sizeof str2, "```\n%s```", ucp);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Name Character:");
		format(str2, sizeof str2, "```\n%s```", Username);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**UID:**");
		format(str2, sizeof str2, "```\n%d```", uid);
		DCC_AddEmbedField(embed, str1, str2, false);
		format(str1, sizeof str1, "**Level:**");
		format(str2, sizeof str2, "```\n%d```", level);
		DCC_AddEmbedField(embed, str1, str2, false);
		format(str1, sizeof str1, "**Vip:**");
		format(str2, sizeof str2, "```\n%s```", GetVipName(vip));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**Vip Time:**");
		format(str2, sizeof str2, "```\n%d```", vipt);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**Roleplay Booster:**");
		format(str2, sizeof str2, "```\n%s```", GetBoost(boost));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "**Booster Time:**");
		format(str2, sizeof str2, "```\n%d```", boostt);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Money:");
		format(str2, sizeof str2, "```\n%s```", FormatMoney(duek));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Bank Money:");
		format(str2, sizeof str2, "```\n%s```", FormatMoney(bmoney));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Red Money:");
		format(str2, sizeof str2, "```\n%s```", FormatMoney(redm));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Register Date:");
		format(str2, sizeof str2, "```\n%s```", reg);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Last Login:");
		format(str2, sizeof str2, "```\n%s```", lastlogin);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Faction:");
		format(str2, sizeof str2, "```\n%s```", GetFacName(fac));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Job:");
		format(str2, sizeof str2, "```\n%s```", GetJobName(j1));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Job 2:");
		format(str2, sizeof str2, "```\n%s```", GetJobName(j2));
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Bandage:");
		format(str2, sizeof str2, "```\n%d```", band);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Component:");
		format(str2, sizeof str2, "```\n%d```", comp);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Material:");
		format(str2, sizeof str2, "```\n%d```", mat);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "Marijuana:");
		format(str2, sizeof str2, "```\n%d```", marju);
		DCC_AddEmbedField(embed, str1, str2, true);
		format(str1, sizeof str1, "https://assets.open.mp/assets/images/skins/%d.png", skin);
		DCC_SetEmbedImage(embed, str1);
		DCC_SetEmbedColor(embed, 0xff0000);
		new y, m, d, timestamp[200];
    	getdate(y, m , d);
	    format(timestamp, sizeof(timestamp), "%02i%02i%02i", y, m, d);
	    DCC_SetEmbedTimestamp(embed, timestamp);
	    DCC_SetEmbedFooter(embed, "HOFFENTLICH Roleplay");

		DCC_SendChannelEmbedMessage(CH, embed);
	}
	else 
	{
		new DCC_Channel:CH;
		CH = DCC_FindChannelById("931205241280528454");
		DCC_SendChannelMessage(CH, "<!> Username tersebut tidak ada di database");
	}
	return 1;
}

DCMD:players(user, channel, params[])
{
    if(channel != DCC_FindChannelById("1077369065053638816"))
		return 1;
	foreach(new i : Player)
	{
		new DCC_Embed:embed = DCC_CreateEmbed(.title = "HOFFENTLICH Roleplay");
		new str1[100], str2[100], name[MAX_PLAYER_NAME+1];
		GetPlayerName(i, name, sizeof(name));

		format(str1, sizeof str1, "**🔴 IP Address**");
		format(str2, sizeof str2, "\nHOFFENTLICH.zanfvnky.xyz:7777");
		DCC_AddEmbedField(embed, str1, str2, false);
		format(str1, sizeof str1, "**📍 Website**");
		format(str2, sizeof str2, "\ncomming soon");
		DCC_AddEmbedField(embed, str1, str2, false);
		format(str1, sizeof str1, "**👦 Players**");
		format(str2, sizeof str2, "\n%d Online", Iter_Count(Player));
		DCC_AddEmbedField(embed, str1, str2, false);
		format(str1, sizeof str1, "**📁 Gamemode**");
		format(str2, sizeof str2, "\nLRP v7");
		DCC_AddEmbedField(embed, str1, str2, false);
		format(str1, sizeof str1, "__[ID]\tName\tLevel\tPing__\n");
		format(str2, sizeof str2, "**%i\t%s\t%i\t%i**\n", i, name, GetPlayerScore(i), GetPlayerPing(i));
		DCC_AddEmbedField(embed, str1, str2, false);

		DCC_SendChannelEmbedMessage(channel, embed);
		return 1;
	}
	return 1;
}
