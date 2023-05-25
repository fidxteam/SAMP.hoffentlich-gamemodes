#define MAX_POINTT 300
#define TR_TIME 10000 // waktu refresh traffic
#define CD_TRD 500 // waktu couldown trade


enum trade_pdta
{
	Float:trdval
}
new Text:TDEditor_PTD;
new Graph:MY_GRAPH;
new pointData[MAX_POINTT][trade_pdta];

new Float:IncDec[][1] = {
	{1.010}, {2.000}, {-1.011}, {-2.013}, {1.234}, {-1.234}, {-0.124}, {0.124}
, {-7.234}, {7.087}
};

forward Int();
public Int()
{
    InitializeTD("Nothing");
    for(new i = 0; i < MAX_POINTT; i++)
    {
	    if(i == 0) pointData[i][trdval] = 1.0;
	    else if(i == MAX_POINTT - 1) pointData[i][trdval] = pointData[i-1][trdval];
	    else if(i > 150) pointData[i][trdval] = pointData[i-1][trdval] + 0.01;
	    else pointData[i][trdval] = pointData[i-1][trdval] + 1.0;
	}
    MY_GRAPH = GRAPHIC::Create(200.0, 250.0, 0, 0, 230, 230);
	GRAPHIC::XYAxisColor(MY_GRAPH, 0x000000FF, 0x000000FF);
	GRAPHIC::UseBackground(MY_GRAPH, 1);
	GRAPHIC::BackgroundColor(MY_GRAPH, 0x000000FF);
	SetTimer("ChangeVals", 1500, true);
}

forward InitializeTD(str[]);
public InitializeTD(str[])
{
	//TDEditor_PTD = TextDrawCreate(315.768646, 246.101257, str);
	TDEditor_PTD = TextDrawCreate(315.768646, 246.101257, str);
	TextDrawLetterSize( TDEditor_PTD, 0.398000, 1.590000);
	TextDrawTextSize(TDEditor_PTD, 0.000000, 200.000000);
	TextDrawAlignment(TDEditor_PTD, 2);
	TextDrawColor(TDEditor_PTD, -1);
	TextDrawUseBox(TDEditor_PTD, 1);
	TextDrawBoxColor( TDEditor_PTD, 255);
	TextDrawSetShadow(TDEditor_PTD, 0);
	TextDrawSetOutline(TDEditor_PTD, 0);
	TextDrawBackgroundColor(TDEditor_PTD, 255);
	TextDrawFont( TDEditor_PTD, 1);
	TextDrawSetProportional( TDEditor_PTD, 1);
	TextDrawSetShadow(TDEditor_PTD, 0);
}

// auto stop
new CountTRD = -1;
new countTimerTRD;
new showCDTRD[MAX_PLAYERS];
new CountTextTRD[60][60] =
{
	"~r~1",
	"~g~2",
	"~y~3",
	"~g~4",
	"~b~5",
	"~b~6",
	"~b~7",
	"~b~8",
	"~b~9",
	"~b~10",
	"~b~11",
	"~b~12",
	"~b~13",
	"~b~14",
	"~b~15",
	"~b~16",
	"~b~17",
	"~b~18",
	"~b~19",
	"~b~20",
	"~b~21",
	"~b~22",
	"~b~23",
	"~b~24",
	"~b~25",
	"~b~26",
	"~b~27",
	"~b~28",
	"~b~29",
	"~b~30",
	"~b~31",
	"~b~32",
	"~b~33",
	"~b~34",
	"~b~35",
	"~b~36",
	"~b~37",
	"~b~38",
	"~b~39",
	"~b~40",
	"~b~41",
	"~b~42",
	"~b~43",
	"~b~44",
	"~g~45",
	"~b~46",
	"~b~47",
	"~b~48",
	"~b~49",
	"~b~50",
	"~b~51",
	"~b~52",
	"~b~53",
	"~b~54",
	"~b~55",
	"~b~56",
	"~b~57",
	"~b~58",
	"~b~59",
	"~b~60"
};

IPRP::pCountDownTRD(playerid, params[])
{
	CountTRD--;
	if(0 >= CountTRD)
	{
		CountTRD = -1;
		KillTimer(countTimerTRD);
 		if(showCDTRD[playerid] == 1)
   		{
   			GameTextForPlayer(playerid, "~g~Trading Was Ended", 2500, 6);
   			PlayerPlaySound(playerid, 1057, 0, 0, 0);
				   //
   			showCDTRD[playerid] = 0;
   			new Float:diff;
			if(pData[playerid][buy] == 1) diff = pointData[MAX_POINTT-1][trdval] - pData[playerid][put];
			else if(pData[playerid][buy] == 2) diff = pData[playerid][put] - pointData[MAX_POINTT - 1][trdval];
			new multi = floatround(diff);
			GivePlayerMoneyEx(playerid, multi*pData[playerid][moneyput]);
			new mstr[256];
			format(mstr, 256, "{ffff66}[BINORY] You have earned {00ff00}$%i.", multi*pData[playerid][moneyput]);
			SendClientMessage(playerid, -1, mstr);
			pData[playerid][moneyput] = 0;
			pData[playerid][put] = 0;
			pData[playerid][buy] = 0;
		}
	}
	else
	{
		if(showCDTRD[playerid] == 1)
   		{
			GameTextForPlayer(playerid, CountTextTRD[CountTRD-1], 2500, 6);
			PlayerPlaySound(playerid, 1056, 0, 0, 0);
		}
	}
	return 1;
}
//

// command
CMD:trade(playerid, params[])
{
    if(pData[playerid][pPhone] < 1)
		return Error(playerid, "Anda belum memiliki Ponsel");

	if(pData[playerid][pPhoneStatus] < 1)
		return Error(playerid, "Ponsel anda sedang mati");

	if(pData[playerid][pBinory] < 1)
		return Error(playerid, "Anda belum memiliki Binory App, harap download!");

    if(pData[playerid][pLevel] < 10)
		return Error(playerid, "You must level 10 to trading!");

    if(pData[playerid][pTrdCD] >= gettime())
		return Error(playerid, "You've must wait %d seconds to trade again", pData[playerid][pTrdCD] - gettime());

	// auto stop

	new money, bbuy[24], mstr[256];
	if(sscanf(params, "is[24]", money, bbuy)) return SendClientMessage(playerid, -1, "{4db8ff}[USAGE] {ffffff}/trade [MONEY] [Buy/Sell]");
	if(money < 0) return Error(playerid, "hanya angka positif, angka negatif tidak diperbolehkan.");
    if(money > 1000) return Error(playerid, "Anda tidak bisa melebihi limit");
    if(pData[playerid][pMoney] < money)
		return Error(playerid, "Kamu tidak memiliki uang sebesar itu untuk melakukan trading");

	// auto stop
	if(CountTRD != -1) return Error(playerid, "Trading sedang berlangsung, harap tunggu sampai");

	CountTRD = 60;
	countTimerTRD = SetTimer("pCountDownTRD", 1000, 1);

	showCDTRD[playerid] = 1;


	if(!strcmp(bbuy, "buy", true, 3))
	{
	    pData[playerid][moneyput] = money;
		pData[playerid][put] = pointData[MAX_POINTT - 1][trdval];
		GivePlayerMoneyEx(playerid, -money);
		pData[playerid][buy] = 1; // buy
		format(mstr, 256, "{ffff66}[BINORY] {ffffff}Anda telah melakukan pembelian di {00ff00}$%f", pData[playerid][put]);
		SendClientMessage(playerid, -1, mstr);
	}
	else if(!strcmp(bbuy, "sell", true, 4))
	{
	    pData[playerid][moneyput] = money;
		pData[playerid][put] = pointData[MAX_POINTT - 1][trdval];
		GivePlayerMoneyEx(playerid, -money);
		pData[playerid][buy] = 2; // sell
		format(mstr, 256, "{ffff66}[BINORY] {ffffff}Anda telah melakukan penjualan di {00ff00}$%f", pData[playerid][put]);
		SendClientMessage(playerid, -1, mstr);
	}
	else SendClientMessage(playerid, -1, "ERROR");
	pData[playerid][pTrdCD] = gettime() + CD_TRD;
	return 1;
}


CMD:tradechart(playerid, params[])
{
    if(pData[playerid][pPhone] < 1)
		return Error(playerid, "Anda belum memiliki Ponsel");

	if(pData[playerid][pPhoneStatus] < 1)
		return Error(playerid, "Ponsel anda sedang mati");

	if(pData[playerid][pBinory] < 1)
		return Error(playerid, "Anda belum memiliki Binory App, harap download!");

    if(pData[playerid][pLevel] < 20)
		return Error(playerid, "You must level 20 to trading!");

	if(pData[playerid][showing] == 0)
	{
	    GRAPHIC::ShowForPlayer(playerid, MY_GRAPH);
	    TextDrawShowForPlayer(playerid, TDEditor_PTD);
		pData[playerid][showing] = 1;
	}
	else
	{
	    GRAPHIC::HideForPlayer(playerid, MY_GRAPH);
	    TextDrawHideForPlayer(playerid, TDEditor_PTD);
		pData[playerid][showing] = 0;
	}
	return 1;
}

forward ChangeVals();
public ChangeVals()
{
    GRAPHIC::RemoveTD(MAX_POINTT);
	GRAPHIC::Destroy(MY_GRAPH);
    MY_GRAPH = GRAPHIC::Create(200.0, 250.0, 0, 0, 230, 230);
    GRAPHIC::XYAxisColor(MY_GRAPH, 0x000000FF, 0x000000FF);


	GRAPHIC::UseBackground(MY_GRAPH, 1);
	GRAPHIC::BackgroundColor(MY_GRAPH, 0x000000FF);
	new Float:exps;
	new Float:oldshit = pointData[MAX_POINTT-1][trdval];
	for(new i = 0; i < MAX_POINTT; i++)
	{
		exps = IncDec[random(sizeof(IncDec))][0];
	    if(i == MAX_POINTT - 1) pointData[i][trdval] = pointData[i][trdval] + exps;
	    else pointData[i][trdval] = pointData[i+1][trdval];
	    if(pointData[i][trdval] < 0.0) pointData[i][trdval] = 0.0;
	    if(pointData[i][trdval] > 229.0) pointData[i][trdval] = 229.0;
	    if(i < 0 || i > MAX_POINTT-1) continue;
	    GRAPHIC::AddPoint(MY_GRAPH, i,  pointData[i][trdval], 0xFFFFFFFF);
	}
	new Float:newshit = pointData[MAX_POINTT - 1][trdval];
	new Float:diff = newshit - oldshit;
	new mstr[256];
	if(diff >= 0) format(mstr, 256, "      New: %f     Diff:~g~%f", newshit, diff);
	else format(mstr, 256, "      New: %f     Diff:~r~%f", newshit, diff);
	//TextDrawDestroy(TDEditor_PTD);
	//InitializeTD(mstr);
	TextDrawSetString(TDEditor_PTD, mstr);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
	        if(pData[i][showing] == 1)
			{
			    GRAPHIC::ShowForPlayer(i, MY_GRAPH);
				//TextDrawHideForPlayer(i, TDEditor_PTD);
				TextDrawShowForPlayer(i, TDEditor_PTD);
			}
	    }
	}
	GRAPHIC::ResetTD();
}
