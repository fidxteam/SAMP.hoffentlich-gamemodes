/*

[=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====--]
[                                                                                                               |  
|       ███╗   ███╗███████╗██████╗ ██████╗  █████╗ ████████╗██╗    ██╗   ██╗ ██████╗ ██╗ ██████╗███████╗        ]
[       ████╗ ████║██╔════╝██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██║    ██║   ██║██╔═══██╗██║██╔════╝██╔════╝        |
|       ██╔████╔██║█████╗  ██████╔╝██████╔╝███████║   ██║   ██║    ██║   ██║██║   ██║██║██║     █████╗          ]
[       ██║╚██╔╝██║██╔══╝  ██╔══██╗██╔═══╝ ██╔══██║   ██║   ██║    ╚██╗ ██╔╝██║   ██║██║██║     ██╔══╝          |
|       ██║ ╚═╝ ██║███████╗██║  ██║██║     ██║  ██║   ██║   ██║     ╚████╔╝ ╚██████╔╝██║╚██████╗███████╗        ]
[       ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝   ╚═╝   ╚═╝      ╚═══╝   ╚═════╝ ╚═╝ ╚═════╝╚══════╝        |
|                                                                                                               ]
[---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---=====---====|
                           [ ALL VOICE SYSTEM BY ADMINISTRATOR TEAM MERPATI OFFICIAL ]

*/

#define FILTERSCRIPT

#include <a_samp>
#include <core>
#include <float>
#include <sampvoice>
#include <dini>
#include <sscanf2>
#include <Pawn.CMD>
#include <a_mysql>
#include <textdraw-streamer>

// DIALOG DEFINE
enum
{
    DIALOG_RADIOSETTINGS,
    DIALOG_SETFREQ,
    DIALOG_SETSFX,
    DIALOG_SHOPELE
}

// PLAYER DATA
enum E_PLAYERS
{
    pID,
    pName[MAX_PLAYER_NAME],
    pMoney,
    bool: IsLoggedIn,
    bool: dataTerload,
    pRadio,
    pTogRadio,
    pTogMic,
    pBukaradio,
    pFreqRadio,
    pSfxTurnOn,
    pSfxTurnOff
};
new pData[MAX_PLAYERS][E_PLAYERS];
new PlayerText:RadioTD[MAX_PLAYERS][4];
new PlayerText:VOICE_1[MAX_PLAYERS];
new PlayerText:VOICE_2[MAX_PLAYERS];
new PlayerText:VOICE_3[MAX_PLAYERS];

// ---=== HANDLE ===---
#include    "MERPATIVOICE\DEFINE.pwn"
#include    "MERPATIVOICE\FUNCTIONS.pwn"
#include    "MERPATIVOICE\COMMANDS.pwn"
#include    "MERPATIVOICE\DIALOGS.pwn"

main()
{

}
 
public OnFilterScriptInit()
{
    voiceData = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DATA);
    if(mysql_errno(voiceData) != 0)
    {
        print("[MySQL]: Koneksi ke database mengalami kegagalan.");
    } else {
        print("[MySQL]: Sukses terhubung ke database.");
    }

    print("                                                                  ");
    print("[-|-----=====-----=====-----=====-----=====-----=====-----=====|-]");
    print("                                                                  ");
    print("                                                                  ");
    print("                                                                  ");
    print("             [ALL SYSTEM VOICE LOADED, BY TEAM MERPATI]           "); // Disini
    print("                                                                  ");
    print("                                                                  ");
    print("                                                                  ");  
    print("[-|=====-----=====-----=====-----=====-----=====-----=====-----|-]");
    print("                                                                  ");

    for(new i = 0; i < MAX_FREQUENSI; i++)
    {
        radioStream[i] = SvCreateGStream(0xDB881AFF, "RadioStream");
    }   
    return 1;
}

public SV_VOID:OnPlayerActivationKeyPress(SV_UINT:playerid, SV_UINT:keyid) 
{
    if(keyid == 0x42 && pData[playerid][pFreqRadio] >= 1 && pData[playerid][pTogMic] == 1 && pData[playerid][pTogRadio] == 1)
    {
        SfxSoundTurnOn(pData[playerid][pFreqRadio]);
        //if(pData[playerid][pSfxTurnOn] == 1) PlaySoundToFrequensi(pData[playerid][pFreqRadio], "http://20.213.160.211/music/micon.ogg");
    	ApplyAnimation(playerid, "ped", "phone_talk", 4.1, 1, 1, 1, 1, 1, 1);
        if(!IsPlayerAttachedObjectSlotUsed(playerid, 9)) SetPlayerAttachedObject(playerid, 9, 19942, 2, 0.0300, 0.1309, -0.1060, 118.8998, 19.0998, 164.2999);
        SvAttachSpeakerToStream(radioStream[pData[playerid][pFreqRadio]], playerid);
    } 	

    if (keyid == 0x42 && localStream[playerid]) SvAttachSpeakerToStream(localStream[playerid], playerid); // Local Stream
}

public SV_VOID:OnPlayerActivationKeyRelease(SV_UINT:playerid, SV_UINT:keyid)
{
    if(keyid == 0x42 && pData[playerid][pFreqRadio] >= 1 && pData[playerid][pTogMic] == 1 && pData[playerid][pTogRadio] == 1)
    {
        SfxSoundTurnOff(pData[playerid][pFreqRadio]);
        if(pData[playerid][pSfxTurnOff] == 1) PlaySoundToFrequensi(pData[playerid][pFreqRadio], "http://20.213.160.211/music/micoff.ogg");
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
        SvDetachSpeakerFromStream(radioStream[pData[playerid][pFreqRadio]], playerid);
        if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
    }

    if (keyid == 0x42 && localStream[playerid]) SvDetachSpeakerFromStream(localStream[playerid], playerid); // Local Stream
}

public OnPlayerConnect(playerid)
{
    CreateIniTextDraw(playerid);
    if (SvGetVersion(playerid) == SV_NULL)
    {
    	Error(playerid, "Tidak dapat menemukan plugin sampvoice.");
    }
    else if (SvHasMicro(playerid) == SV_FALSE)
    {
    	Error(playerid, "Mikrofon tidak dapat ditemukan.");
    }
    else if ((localStream[playerid] = SvCreateDLStreamAtPlayer(20.0, SV_INFINITY, playerid)))
    {
    	Info(playerid, "Tekan B Untuk Berkomunikasi Di Sekitar Player. (Pengguna PC)");
        SvAddKey(playerid, 0x42);
    }

    GetPlayerName(playerid, pData[playerid][pName], MAX_PLAYER_NAME);
    pData[playerid][IsLoggedIn] = true;     
	return 1;
}

public OnPlayerSpawn(playerid)
{
    new Query[90];
    format(Query, sizeof(Query), "SELECT * FROM `voicedata` WHERE `pUsername` = '%s' LIMIT 1", GetPlayerNameEx(playerid));
    mysql_tquery(voiceData, Query, "CheckDataVoicePlayer", "d", playerid);
}

public ClickDynamicPlayerTextdraw(playerid, PlayerText:playertextid)
{
	if(playertextid == RadioTD[playerid][1])
	{
	    ShowPlayerDialog(playerid, DIALOG_SETFREQ, DIALOG_STYLE_INPUT, "Set Frequensi Radio", "Masukkan Frequensi Radio Yang Ingin Kamu Hubungkan (Maksimal 1 - 9999)", "Hubungkan", "Tutup");
	}
	if(playertextid == RadioTD[playerid][2])
	{
	    if(pData[playerid][pTogMic] == 0)
        {
            if(pData[playerid][pTogRadio] == 0) return Error(playerid, "Radio anda sedang mati, Gunakan /togradio untuk menghidupkan radio anda.");
            if(pData[playerid][pFreqRadio] == 0) return Error(playerid, "Frequensi Anda Masih Berada Di {ff0000}(0){FFFFFF}, Tidak dapat menghidupkan Mic Radio");

            new msgRadio[256];
            format(msgRadio, sizeof msgRadio, "{008000}[MIC]: {FFFFFF}Mic Radio Aktif, terhubung ke Frequensi: {ff0000}(%d).", pData[playerid][pFreqRadio]);
            SendClientMessage(playerid, -1, msgRadio);

            pData[playerid][pTogMic] = 1;
        }
        else if(pData[playerid][pTogMic] == 1)
        {
            if(pData[playerid][pTogRadio] == 0) return Error(playerid, "Radio anda sedang mati, Gunakan /togradio untuk menghidupkan radio anda.");
            if(pData[playerid][pFreqRadio] == 0) return Error(playerid, "Frequensi Anda Masih Berada Di {ff0000}(0){FFFFFF}, Tidak dapat menghidupkan Mic Radio");

            new msgRadio[256];
            format(msgRadio, sizeof msgRadio, "{008000}[MIC]: {FFFFFF}Mic Radio NonAktif, terhubung ke Frequensi: {ff0000}(%d).", pData[playerid][pFreqRadio]);
            SendClientMessage(playerid, -1, msgRadio);

            pData[playerid][pTogMic] = 0;
        }
	}
}

CreateIniTextDraw(playerid)
{
    VOICE_1[playerid] = CreatePlayerTextDraw(playerid, 126.000000, 439.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, VOICE_1[playerid], 4);
	PlayerTextDrawLetterSize(playerid, VOICE_1[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, VOICE_1[playerid], 2.500000, 2.500000);
	PlayerTextDrawSetOutline(playerid, VOICE_1[playerid], 1);
	PlayerTextDrawSetShadow(playerid, VOICE_1[playerid], 0);
	PlayerTextDrawAlignment(playerid, VOICE_1[playerid], 1);
	PlayerTextDrawColor(playerid, VOICE_1[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, VOICE_1[playerid], 255);
	PlayerTextDrawBoxColor(playerid, VOICE_1[playerid], 255);
	PlayerTextDrawUseBox(playerid, VOICE_1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, VOICE_1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, VOICE_1[playerid], 0);

	VOICE_2[playerid] = CreatePlayerTextDraw(playerid, 126.000000, 434.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, VOICE_2[playerid], 4);
	PlayerTextDrawLetterSize(playerid, VOICE_2[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, VOICE_2[playerid], 2.500000, 2.500000);
	PlayerTextDrawSetOutline(playerid, VOICE_2[playerid], 1);
	PlayerTextDrawSetShadow(playerid, VOICE_2[playerid], 0);
	PlayerTextDrawAlignment(playerid, VOICE_2[playerid], 1);
	PlayerTextDrawColor(playerid, VOICE_2[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, VOICE_2[playerid], 255);
	PlayerTextDrawBoxColor(playerid, VOICE_2[playerid], 255);
	PlayerTextDrawUseBox(playerid, VOICE_2[playerid], 1);
	PlayerTextDrawSetProportional(playerid, VOICE_2[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, VOICE_2[playerid], 0);

	VOICE_3[playerid] = CreatePlayerTextDraw(playerid, 126.000000, 429.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, VOICE_3[playerid], 4);
	PlayerTextDrawLetterSize(playerid, VOICE_3[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, VOICE_3[playerid], 2.500000, 2.500000);
	PlayerTextDrawSetOutline(playerid, VOICE_3[playerid], 1);
	PlayerTextDrawSetShadow(playerid, VOICE_3[playerid], 0);
	PlayerTextDrawAlignment(playerid, VOICE_3[playerid], 1);
	PlayerTextDrawColor(playerid, VOICE_3[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, VOICE_3[playerid], 255);
	PlayerTextDrawBoxColor(playerid, VOICE_3[playerid], 255);
	PlayerTextDrawUseBox(playerid, VOICE_3[playerid], 1);
	PlayerTextDrawSetProportional(playerid, VOICE_3[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, VOICE_3[playerid], 0);
	
	RadioTD[playerid][0] = CreatePlayerTextDraw(playerid, 400.000000, 300.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, RadioTD[playerid][0], 5);
	PlayerTextDrawLetterSize(playerid, RadioTD[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, RadioTD[playerid][0], 150.000000, 200.000000);
	PlayerTextDrawSetOutline(playerid, RadioTD[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, RadioTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, RadioTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, RadioTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, RadioTD[playerid][0], 0);
	PlayerTextDrawBoxColor(playerid, RadioTD[playerid][0], 255);
	PlayerTextDrawUseBox(playerid, RadioTD[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, RadioTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, RadioTD[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, RadioTD[playerid][0], 2967);
	PlayerTextDrawSetPreviewRot(playerid, RadioTD[playerid][0], 100.000000, 180.000000, 0.000000, 0.699999);
	PlayerTextDrawSetPreviewVehCol(playerid, RadioTD[playerid][0], 1, 1);

	RadioTD[playerid][1] = CreatePlayerTextDraw(playerid, 499.000000, 300.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, RadioTD[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, RadioTD[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, RadioTD[playerid][1], 10.000000, 50.000000);
	PlayerTextDrawSetOutline(playerid, RadioTD[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, RadioTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, RadioTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, RadioTD[playerid][1], -256);
	PlayerTextDrawBackgroundColor(playerid, RadioTD[playerid][1], 0);
	PlayerTextDrawBoxColor(playerid, RadioTD[playerid][1], 255);
	PlayerTextDrawUseBox(playerid, RadioTD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, RadioTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, RadioTD[playerid][1], 1);

	RadioTD[playerid][2] = CreatePlayerTextDraw(playerid, 480.000000, 390.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, RadioTD[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid, RadioTD[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, RadioTD[playerid][2], 30.000000, 20.000000);
	PlayerTextDrawSetOutline(playerid, RadioTD[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, RadioTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, RadioTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, RadioTD[playerid][2], -256);
	PlayerTextDrawBackgroundColor(playerid, RadioTD[playerid][2], 0);
	PlayerTextDrawBoxColor(playerid, RadioTD[playerid][2], 255);
	PlayerTextDrawUseBox(playerid, RadioTD[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, RadioTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, RadioTD[playerid][2], 1);

	RadioTD[playerid][3] = CreatePlayerTextDraw(playerid, 496.000000, 372.000000, "911");
	PlayerTextDrawFont(playerid, RadioTD[playerid][3], 2);
	PlayerTextDrawLetterSize(playerid, RadioTD[playerid][3], 0.250000, 1.500000);
	PlayerTextDrawTextSize(playerid, RadioTD[playerid][3], 30.000000, 20.000000);
	PlayerTextDrawSetOutline(playerid, RadioTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, RadioTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, RadioTD[playerid][3], 2);
	PlayerTextDrawColor(playerid, RadioTD[playerid][3], 255);
	PlayerTextDrawBackgroundColor(playerid, RadioTD[playerid][3], 0);
	PlayerTextDrawBoxColor(playerid, RadioTD[playerid][3], 255);
	PlayerTextDrawUseBox(playerid, RadioTD[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, RadioTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, RadioTD[playerid][3], 0);
}


public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_NO))
	{
	    if(pData[playerid][pTogRadio] == 1)
		{
		 	if(pData[playerid][pBukaradio] == 1)
			{
			    pData[playerid][pBukaradio] = 0;
		        PlayerTextDrawHide(playerid, RadioTD[playerid][0]);
				PlayerTextDrawHide(playerid, RadioTD[playerid][1]);
				PlayerTextDrawHide(playerid, RadioTD[playerid][2]);
				PlayerTextDrawHide(playerid, RadioTD[playerid][3]);
				CancelSelectTextDraw(playerid);
			}
			else if(pData[playerid][pBukaradio] == 0)
			{
		        new fradio[128];
		        format(fradio, sizeof fradio, "%d", pData[playerid][pFreqRadio]);
		        PlayerTextDrawSetString(playerid, RadioTD[playerid][3], fradio);
	            pData[playerid][pBukaradio] = 1;
		        PlayerTextDrawShow(playerid, RadioTD[playerid][0]);
				PlayerTextDrawShow(playerid, RadioTD[playerid][1]);
				PlayerTextDrawShow(playerid, RadioTD[playerid][2]);
				PlayerTextDrawShow(playerid, RadioTD[playerid][3]);
				SelectTextDraw(playerid, 0xFF0000FF);
			}
		}
	}

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if (localStream[playerid])
    {
        SvDeleteStream(localStream[playerid]);
        localStream[playerid] = SV_NULL;
    }   

    printf("[MySql]: Berhasil Menyimpan Data Player %s Dengan ID %d", GetPlayerNameEx(playerid), pData[playerid][pID]);

    pData[playerid][pTogRadio] = 0;
    SavePlayerDataVoice(playerid);
    ResetDataVoicePlayer(playerid);

    pData[playerid][dataTerload] = false;
    pData[playerid][IsLoggedIn] = false;
    return 1;
}

public OnFilterScriptExit()
{
    for(new i = 0; i < MAX_FREQUENSI; i++)
    {
        SvDeleteStream(radioStream[i]);
    }	
	return 1;
}

CMD:radio(playerid, params[])
{
    if(pData[playerid][pTogRadio] == 0)
		{
			if(pData[playerid][pFreqRadio] >= 1)
			{
	            new msgTogRadio[256];
	            format(msgTogRadio, sizeof msgTogRadio, ""WARNA_KUNING"[RADIO]: "WARNA_PUTIH"Radio anda telah berhasil {7FFF00}dihidupakan{FFFFFF}, dan anda telah kembali terhubung ke Frequensi: {FF0000}(%d).", pData[playerid][pFreqRadio]);
	            SendClientMessage(playerid, -1, msgTogRadio);
				ConnectToFrequensi(playerid, pData[playerid][pFreqRadio], false);
	            pData[playerid][pTogRadio] = 1;
			}
	        else
	        {
	            Info(playerid, "Radio anda berhasil Dihidupkan.");
	            pData[playerid][pTogRadio] = 1;
	        }
	        pData[playerid][pBukaradio] = 1;
	        new fradio[128];
	        format(fradio, sizeof fradio, "%d", pData[playerid][pFreqRadio]);
	        PlayerTextDrawSetString(playerid, RadioTD[playerid][3], fradio);

	        PlayerTextDrawShow(playerid, RadioTD[playerid][0]);
			PlayerTextDrawShow(playerid, RadioTD[playerid][1]);
			PlayerTextDrawShow(playerid, RadioTD[playerid][2]);
			PlayerTextDrawShow(playerid, RadioTD[playerid][3]);
			SelectTextDraw(playerid, 0xFF0000FF);
		}
		else if(pData[playerid][pTogRadio] == 1)
		{
			if(pData[playerid][pFreqRadio] >= 1)
			{
	            new msgTogRadio[256];
	            format(msgTogRadio, sizeof msgTogRadio, ""WARNA_KUNING"[RADIO]: "WARNA_PUTIH"Radio anda telah berhasil {FF0000}dimatikan{FFFFFF}, dan anda telah terputus dari Frequensi: {ff0000}(%d).", pData[playerid][pFreqRadio]);
				SendClientMessage(playerid, -1, msgTogRadio);
	            DisconnectToFrequensi(playerid, pData[playerid][pFreqRadio], true);
	            pData[playerid][pTogRadio] = 0;
			}
	        else
	        {
	            Info(playerid, "Radio anda berhasil Dimatikan.");
	            pData[playerid][pTogRadio] = 0;
	        }
	        pData[playerid][pBukaradio] = 0;
	        PlayerTextDrawHide(playerid, RadioTD[playerid][0]);
			PlayerTextDrawHide(playerid, RadioTD[playerid][1]);
			PlayerTextDrawHide(playerid, RadioTD[playerid][2]);
			PlayerTextDrawHide(playerid, RadioTD[playerid][3]);
			CancelSelectTextDraw(playerid);
		}
}
