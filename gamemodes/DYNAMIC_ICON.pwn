#define MAX_ICON 100

enum E_ICON
{
    Float:iconX,
    Float:iconY,
    Float:iconZ,
    iconType,
    iconInt,
    iconWorld
}
new IconData[MAX_ICON][E_ICON];
new Iterator:Icon<MAX_ICON>;

Icon_Save(id)
{
    new cQuery[1280];
    format(cQuery, sizeof(cQuery), "UPDATE icon SET type='%d', posx='%f', posz='%f', world='%d', interior='%d' WHERE ID='%d'",
    IconData[id][iconType],
    IconData[id][iconX],
    IconData[id][iconY],
    IconData[id][iconZ],
    IconData[id][iconWorld],
    IconData[id][iconInt],
    id
    );
    return mysql_tquery(g_SQL, cQuery);
}

IPRP::LoadIcon()
{
    new rows;

    cache_get_row_count(rows);
 	if(rows)
  	{
		new bid, i = 0;
		while(i < rows)
		{
            cache_get_value_name_int(i, "id", bid);
			cache_get_value_name_float(i, "posx", IconData[bid][iconX]);
			cache_get_value_name_float(i, "posy", IconData[bid][iconY]);
			cache_get_value_name_float(i, "posz", IconData[bid][iconZ]);
            cache_get_value_name_int(i, "type", IconData[bid][iconType]);
            cache_get_value_name_int(i, "interior", IconData[bid][iconInt]);
            cache_get_value_name_int(i, "world", IconData[bid][iconWorld]);
            CreateDynamicMapIcon(IconData[bid][iconX],IconData[bid][iconY],IconData[bid][iconZ], IconData[bid][iconType], -1, IconData[bid][iconWorld], IconData[bid][iconInt], -1);
            Iter_Add(Icon, bid);
            i++;
        }
        printf("[MySQL Dynamic Icon] Number Of Loaded: %d.", i);
    }
}

CMD:createicon(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);
    
    new icon = Iter_Free(Icon);
    if(icon == -1) return Error(playerid, "You cant create more icon!");
    new type;
    if(sscanf(params, "d", type)) return Usage(playerid, "/createicon [Id Icon]");
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    IconData[icon][iconX] = x;
    IconData[icon][iconY] = y;
    IconData[icon][iconZ] = z;
    IconData[icon][iconType] = type;
    IconData[icon][iconWorld] = GetPlayerVirtualWorld(playerid);
    IconData[icon][iconInt] = GetPlayerInterior(playerid);

    CreateDynamicMapIcon(IconData[icon][iconX],IconData[icon][iconY],IconData[icon][iconZ], IconData[icon][iconType], -1, IconData[icon][iconWorld], IconData[icon][iconInt], -1);
    Iter_Add(Icon, icon);

    new query[512];
    mysql_format(g_SQL, query, sizeof(query), "INSERT INTO icon SET id='%d', posx='%f', posy='%f', posz='%f', type='%d', world='%d', interior='%d'", icon, IconData[icon][iconX], IconData[icon][iconY], IconData[icon][iconZ], IconData[icon][iconType], IconData[icon][iconWorld], IconData[icon][iconInt]);
    mysql_tquery(g_SQL, query, "OnIconCreated", "ii", playerid, icon);
    return 1;
}

IPRP::OnIconCreated(playerid, id)
{
    Icon_Save(id);
    Servers(playerid, "You has created icon ID: %d.", id);
    return 1;
}

CMD:editicon(playerid, params[])
{
    static
        did,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", did, type, string))
    {
        Usage(playerid, "/editicon [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location");
        return 1;
    }
    if((did < 0 || did > MAX_ICON))
        return Error(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Icon, did)) return Error(playerid, "The icon you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, IconData[did][iconX], IconData[did][iconY], IconData[did][iconZ]);
        DestroyDynamicMapIcon(IconData[did][iconType]);
        CreateDynamicMapIcon(IconData[did][iconX],IconData[did][iconY],IconData[did][iconZ], IconData[did][iconType], -1, IconData[did][iconWorld], IconData[did][iconInt], -1);
        Icon_Save(did);

        SendAdminMessage(COLOR_RED, "%s Changes Location ICON ID: %d.", pData[playerid][pAdminname], did);
    }
    return 1;
}

CMD:deleteicon(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	new id, query[512];
	if(sscanf(params, "i", id)) return Usage(playerid, "/deleteicon [id]");
	if(!Iter_Contains(Icon, id)) return Error(playerid, "Invalid Icon ID.");

	DestroyDynamicMapIcon(IconData[id][iconType]);
	
    IconData[id][iconWorld] = 0;
    IconData[id][iconInt] = 0;
	Iter_Remove(Icon, id);
	
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM icon WHERE id=%d", id);
	mysql_tquery(g_SQL, query);
	SendAdminMessage(COLOR_RED, "Admin %s has deleted Icon ID %d", pData[playerid][pAdminname], id);
	return 1;
}
