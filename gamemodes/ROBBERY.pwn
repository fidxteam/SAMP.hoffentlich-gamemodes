CreateCarStealingPoint()
{
	new strings[2000];
    CreateDynamicPickup(1239, 23, -1449.502319, -1530.669311, 101.757812, -1);
	format(strings, sizeof(strings), "[CAR STEALING]\n{FFFFFF}Type /carsteal to rob car.");
	CreateDynamic3DTextLabel(strings, COLOR_RED, -1449.502319, -1530.669311, 101.757812, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); //cars steal
}

//stealcar
new RobCarDelay[MAX_PLAYERS];
new RobCar1;
new RobCar2;
new RobCar3;
new CarRob1 = 411;
new CarRob2 = 477;
new CarRob3 = 560;
new AtCarsRobs[MAX_PLAYERS];

CMD:carsteal(playerid)
{
	if(!IsPlayerInRangeOfPoint(playerid, 4.0, -1449.502319, -1530.669311, 101.757812)) return ErrorMsg(playerid, "Anda tidak di tempat car stealing");
	if(RobCarDelay[playerid] > 0) return ErrorMsg(playerid, "Anda sedang cooldown");
	//if(pData[playerid][pFaction] = -1) return Error(playerid, "You must exit faction!");
	/*new count;
	foreach(new i : Player)
	{
	    if(pData[playerid][pOnDuty] == 1)
	    {
	        count++;
		}
	}
	if(count < 2)
	{
	    return Error(playerid, "Ada setidaknya 2 SAPD bertugas untuk mencuri mobil.");
	}*/
	new dc[1000];
				format(dc, sizeof(dc),  "**%s Mencoba carsteal Ucp: %s**", pData[playerid][pName], pData[playerid][pUCP]);
				SendDiscordMessage(15, dc);
	new qr[1000];
	format(qr, sizeof(qr), "Name Car\t\tStatus\n");
	format(qr, sizeof(qr), "%sInfernus\t\t%s\nZR-350\t\t%s\nSultan\t\t%s", qr,
	(RobCar1 > 0) ? (""RED_E"Not Ready") : (""GREEN_E"Ready"),
	(RobCar2 > 0) ? (""RED_E"Not Ready") : (""GREEN_E"Ready"),
	(RobCar3 > 0) ? (""RED_E"Not Ready") : (""GREEN_E"Ready"));
	ShowPlayerDialog(playerid, DIALOG_ROBCARS, DIALOG_STYLE_TABLIST, "Rob Cars", qr, "Select", "Quit");
	return 1;
}
