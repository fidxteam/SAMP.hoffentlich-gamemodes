//=========[ Anticheat ]
new AntiCheatKontol = 1;
#define MAX_ANTICHEAT_WARNINGS   	3

public OnPlayerTeleport(playerid, Float:distance)
{
	if((AntiCheatKontol) && pData[playerid][pAdmin] < 1)
	{
	    if(!IsPlayerInRangeOfPoint(playerid, 3.0, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]))
	    {
		    pData[playerid][pACWarns]++;

		    if(pData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
		    {
	    	    SendAnticheat(COLOR_YELLOW, ""RED_E"%s"WHITE_E"[%i] is possibly teleport hacking (distance: %.1f).", ReturnName(playerid), playerid, distance);
			}
			else
			{
		    	SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dikick otomatis oleh %s, Alasan: Teleport hacks", ReturnName(playerid), SERVER_BOT);
		    	KickEx(playerid);
			}
		}
	}

	return 1;
}

public OnPlayerAirbreak(playerid)
{
	if((AntiCheatKontol) && pData[playerid][pAdmin] < 1)
	{
	    pData[playerid][pACWarns]++;

	    if(pData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
	    {
	        SendAnticheat(COLOR_YELLOW, ""RED_E"%s"WHITE_E"[%i] is possibly using airbreak hacks.", ReturnName(playerid), playerid);
		}
	}
	return 1;
}

NgecekCiter(playerid)
{
	if(gettime() > pData[playerid][pACTime])
	{
	    // Speedhacking
		if((AntiCheatKontol) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetVehicleSpeed(GetPlayerVehicleID(playerid)) > 450 && pData[playerid][pAdmin] < 1)
		{
		    pData[playerid][pACWarns]++;

		    if(pData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
		    {
                SendAnticheat(COLOR_YELLOW, ""RED_E"%s"WHITE_E"[%i] is possibly speedhacking, speed: %.1f km/h.", ReturnName(playerid), playerid, GetVehicleSpeed(GetPlayerVehicleID(playerid)));
			}
			else
			{
                SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dikick otomatis oleh %s, Alasan: Speed hacks", ReturnName(playerid), SERVER_BOT);
		    	KickEx(playerid);
			}
		}

		// Jetpack
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK && pData[playerid][pAdmin] < 1 && !pData[playerid][pJetpack])
		{
            SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dikick otomatis oleh %s, Alasan: Jetpack hacks", ReturnName(playerid), SERVER_BOT);
		    KickEx(playerid);
		}

		// Flying hacks
		if((AntiCheatKontol) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			switch(GetPlayerAnimationIndex(playerid))
			{
			    case 958, 1538, 1539, 1543:
			    {
			        new
			            Float:z,
			            Float:vx,
			            Float:vy,
			            Float:vz;

					GetPlayerPos(playerid, z, z, z);
                    GetPlayerVelocity(playerid, vx, vy, vz);

                    if((z > 20.0) && (0.9 <= floatsqroot((vx * vx) + (vy * vy) + (vz * vz)) <= 1.9) && pData[playerid][pAdmin] < 1)
                    {
                        SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dikick otomatis oleh %s, Alasan: Flying hacks", ReturnName(playerid), SERVER_BOT);
                        KickEx(playerid);
					}
				}
			}
		}

			// Armor hacks
		if(!IsAtEvent[playerid])
		{
		    new
   				Float:armor;

			GetPlayerArmour(playerid, armor);

  			if(!(gettime() - pData[playerid][pLastUpdate] > 5))
  			{
				if(floatround(armor) > floatround(pData[playerid][pArmour]) && gettime() > pData[playerid][pACTime] && gettime() > pData[playerid][pArmorTime] && pData[playerid][pAdmin] < 1)
				{
		            pData[playerid][pACWarns]++;
	    	        pData[playerid][pArmorTime] = gettime() + 10;

				    if(pData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
				    {
                        SendAnticheat(COLOR_YELLOW, ""RED_E"%s"WHITE_E"[%i] is possibly Armor hacks, (old: %.2f, new: %.2f)", ReturnName(playerid), playerid, pData[playerid][pArmour], armor);
					}
					else
					{
                        SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dikick otomatis oleh %s, Alasan: Armor hacks", ReturnName(playerid), SERVER_BOT);
                        KickEx(playerid);
					}
				}
			}

			pData[playerid][pArmour] = armor;
		}
	}

	// Ammo hacks
	if(!IsAtEvent[playerid])
	{
	    new
			weapon,
			ammo;

		GetPlayerWeaponData(playerid, 8, weapon, ammo);

		if((16 <= weapon <= 18) && ammo <= 0)
		{
			RemovePlayerWeapon(playerid, weapon);
		}
	}

	// Warping into vehicles while locked
	/*if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetVehicleParams(GetPlayerVehicleID(playerid), VEHICLE_DOORS) && (!IsVehicleOwner(playerid, GetPlayerVehicleID(playerid)) && pData[playerid][pVehicleKeys] != GetPlayerVehicleID(playerid)))
    {
        new
            Float:x,
            Float:y,
            Float:z;
        GetPlayerPos(playerid, x, y, z);
        SetPlayerPos(playerid, x, y, z + 1.0);
        GameTextForPlayer(playerid, "~r~This vehicle is locked!", 3000, 3);
    }*/
}

RemovePlayerWeapon(playerid, weaponid)
{
	// Reset the player's weapons.
	ResetPlayerWeapons(playerid);
	// Set the armed slot to zero.
	SetPlayerArmedWeapon(playerid, 0);
	// Set the weapon in the slot to zero.
	pData[playerid][pACTime] = gettime() + 2;
	pData[playerid][pGuns][g_aWeaponSlots[weaponid]] = 0;
	// Set the player's weapons.
	SetWeapons(playerid);
}
