//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma dynamic 50000000
#include <a_samp>
#undef MAX_PLAYERS
#define MAX_PLAYERS	500
#include <crashdetect>
#include <gvar.inc>
#include <a_mysql>
#include <a_http>
#include <a_objects>
#include <a_actor>
#include <a_zones>
#include <foreach>
#include <progress2>
#include <Pawn.CMD>
#include <selection>
#include <FiTimestamp>
#include <a_graphfunc>
//#include <mapandreas>
#include <textdraw-streamer>
#include <ui_progressbar>
#include <Notifikasi>
#include <irc>
#include <chattd>
#include <animated-textdraw>
#define ENABLE_3D_TRYG_YSI_SUPPORT
#include <streamer>
#include <EVF2>
#include <GPS>
#include <notiftweet>
//#include "actor_robbery.inc"
#include <mSelection>
#include <YSI\y_timers>
#include <YSI\y_ini>
#include <sscanf2>
#include <cuff>
//#include <wep-config>
#include <3DTryg>
#include <Dini>
#include <yom_buttons>
#include <geoiplite>
#include <garageblock>
#include <sampvoice>
#include <timerfix.inc>
//#include <nex-ac>
//#include <compat>
#define DCMD_PREFIX '!'
#include <discord-cmd>
#include <discord-connector>
#include <tp>
#include <loadingbar>

//-----[ Modular ]-----
#include "DEFINE.pwn"

#define IPRP::%0(%1) forward %0(%1); public %0(%1)
#define GRP::%0(%1) forward %0(%1); public %0(%1)

#pragma warning disable 213
#pragma warning disable 217
#pragma warning disable 204
#pragma warning disable 219
#pragma warning disable 209
#pragma warning disable 203
#pragma warning disable 202
#pragma warning disable 200
#pragma warning disable 216
#pragma warning disable 232
new olahh[MAX_PLAYERS];
new ayamjob[MAX_PLAYERS];
new pasien;
new Mobilisi[MAX_PLAYERS];
new Sedangngisi[MAX_PLAYERS];
//tdm
new kandangcp;
new kandangcp2;
new kandangcp3;
new kandangcp4;
new kandangcp5;
new kandang;
new Anjaytdm;
new killred;
new killblue;
//callsign
new Bus[MAX_PLAYERS];
new vehiclecallsign[MAX_VEHICLES];
new kuncicar[MAX_VEHICLES];
new pintukiri[MAX_PLAYERS];
new pintukanan[MAX_PLAYERS];
new pintukanan2[MAX_PLAYERS];
new pintukiri2[MAX_PLAYERS];
new STREAMER_TAG_3D_TEXT_LABEL:vehicle3Dtext[MAX_VEHICLES];
//logo
new PlayerText:Textdraw0[MAX_PLAYERS];
new PlayerText:Textdraw1[MAX_PLAYERS];
new Ambiljob;
//rob
	#define KEY_AIM  128
new bool:ActorHandsup[MAX_ACTORS];
new robwarung;
new Text3D: Tesaje;
new bool:Warung;
new Robmulai;
#define MAX_ROBBERY_ACTORS		(50)

#define TYPE_SUCCESS        (0)
#define TYPE_FAILED         (1)
#define TYPE_UNFINISHED     (2)

#define MIN_MONEY_ROB       500
#define MAX_MONEY_ROB       5000
#define ROBBERY_WAIT_TIME   (5)

new Testrob;

forward OnPlayerStartRobbery(playerid, Actorrob, bool:robbed_recently);
forward OnPlayerFinishRobbery(playerid, Actorrob, robbedmoney, type);
forward OnPlayerRequestRobbery(playerid, Actorrob);



new pesawat12;
new Actorrob;
new Text3D: Testdoang;
new Testaja;
forward RunActorAnimationSequence(playerid, Actorrob, animation_pattern);
public RunActorAnimationSequence(playerid, Actorrob, animation_pattern) {
	switch(animation_pattern) {
		case 0: {
			ClearActorAnimations(Actorrob);
			ApplyActorAnimation(Actorrob, "SHOP", "SHP_Rob_HandsUp", 4.1, 0, 1, 1, 1, 0);
			
            Update3DTextLabelText(Text3D: Tesaje, 0xFFFFFFFF, "");
			//SetTimerEx("RunActorAnimationSequence", 10000, false, "iii", playerid, Actorrob, 1);

			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);

			for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++) {
				if(!IsPlayerConnected(i)) {
					continue;
				}
				PlayerPlaySound(i, 3401, x, y, z);
			}
		}
		case 1:
		{
			
				ClearActorAnimations(Actorrob);
				ApplyActorAnimation(Actorrob, "SHOP", "SHP_Rob_GiveCash", 4.1, 1, 1, 1, 1, 0);
				
				/*foreach(new i: Player)
				{
				    if(pData[i][pFaction] == 1)
				    {
						InfoMsg(i, "Terjadi perampokan disekitar wilayah ls");
					}
				}*/
				SendFactionMessage(1, 0x0000FFFF, "Terjadi perampokan disekitar wilayah ls");
				

				SetTimerEx("RunActorAnimationSequence", 10000, false, "iii", playerid, Actorrob, 2);

		}
		case 2: {
		    Update3DTextLabelText(Text3D: Tesaje, 0xFFFFFFFF, "I..ini uangnya tuan");
				new value = 500 + random(50);
				GivePlayerMoneyEx(playerid, value);
				new string[128];
				format(string, sizeof(string), "Anda Mendapatkan Uang %s", FormatMoney(value));
				SuccesMsg(playerid, string);
			ClearActorAnimations(Actorrob);
			ApplyActorAnimation(Actorrob, "PED", "DUCK_cower", 4.1, 1, 1, 1, 1, 1);
			Warung = true;
            Delete3DTextLabel(Text3D: Tesaje);
			SetTimerEx("RunActorAnimationSequence", 1000 * 60 * ROBBERY_WAIT_TIME, false, "iii", playerid, Actorrob, 3);

			
		}
		case 3: {
			ClearActorAnimations(Actorrob);
			PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}
//dealer
new ramp[6];
new ddor[20];
new bool:ddstate;
new bool:rstate;
new Text3D:oclabel[2];

//flash
new FlashTime[MAX_VEHICLES];

//STATIC SAPD
new SAPDVeh[MAX_PLAYERS];
//STATIC SAMD
new SAMDVeh[MAX_PLAYERS];
//STATIC SANA
new SANAVeh[MAX_PLAYERS];
//STATIC PEDAGANG
new PDGVeh[MAX_PLAYERS];

//cctv
#define MAX_CCTVS 100
#define MAX_CCTVMENUS 10  //(This number should be MAX_CCTVS divided by 10  (round up))

//CameraInfo
new TotalCCTVS;
new CameraName[MAX_CCTVS][32];
new Float:CCTVLA[MAX_PLAYERS][3];  //CCTV LookAt
new Float:CCTVLAO[MAX_CCTVS][3];
new Float:CCTVRadius[MAX_PLAYERS]; //CCTV Radius
new Float:CCTVDegree[MAX_PLAYERS] = 0.0;
new Float:CCTVCP[MAX_CCTVS][4]; //CCTV CameraPos
new CurrentCCTV[MAX_PLAYERS] = -1;

//TextDraw
new Text:TD;



//Menus:
new Menu:CCTVMenu[MAX_CCTVMENUS];
new MenuType[MAX_CCTVMENUS];
new TotalMenus;
new PlayerMenu[MAX_PLAYERS];

enum LP
{
	Float:LX,
	Float:LY,
	Float:LZ,
	Float:LA,
	LInterior
}
new Spawned[MAX_PLAYERS];
new LastPos[MAX_PLAYERS][LP];

new KeyTimer[MAX_PLAYERS];

new Sopirbus, BusCP;

//model selection
new vtoylist = mS_INVALID_LISTID;

//-----[ Rob ]-----
new RobMember = 0;
new InRob[MAX_PLAYERS];

//HAULING TRAILER
new TrailerHauling[MAX_PLAYERS];

//pool
#define NO_BALL 403
#define CALA 0
#define POL 1
#define WHITE 14
#define BLACK 15
#define TABLE 16
#define POLYGONS 6

forward Float:GetVectorAngle(obj, obj2);
forward Float:GetVectorAngle_XY(Float:fx, Float:fy, Float:tx, Float:ty);
forward Float:GetVectorDistance_PL(playerid, obj);
forward Float:GetVectorDistance_OB(obj, obj2);
forward Float:GetDistance(Float:fx, Float:fy, Float:tx, Float:ty);
forward Float:GetDistancePointToLong(Float:px,Float:py, Float:px1,Float:py1, Float:px2,Float:py2);

forward OnEndBilliard();
forward OnBallInHole(ballid);
forward OnTimer();
forward BallProperties();
forward OnShowedTD(playerid);

enum GameEnum
{
	bool:Waiting,
	bool:Running,
	bool:WhiteInHole,
	bool:BlackInHole,
    Timer,
	Timer2,
	Player1,
	Player2,
	LastBall
};

new Game[GameEnum];

enum BallEnum
{
	ObjID,
	Float:bx,
	Float:by,
	Float:bz,
	Float:ba,
	Float:speed,
	TouchID
};
new Ball[17][BallEnum];

enum EnumVertices
{
	Float:vvx,
	Float:vvy
};
new Polygon[POLYGONS][2][EnumVertices];

enum PolygonInfo
{
	bool:Progress,
	Vertices
};
new PolyResult[POLYGONS][PolygonInfo];

enum EnumPlayer
{
	bool:Sighting,
	bool:AfterSighting,
	bool:Turn,
	BBall,
	Points,
	SelectLR,
	SelectUD,
	Float:pa,
	Text:T1,
	Text:T2,
	Text:T3,
	Text:T4,
	Text:T5,
	Text:T6,
	TDTimer
};
new Player[20][EnumPlayer];

new Float:Hole[6][4] =
{
	{2495.6413,-1670.6297, 2495.5415,-1670.7099}, // 1  12
	{2496.4323,-1670.6297, 2496.5825,-1670.6398}, // 2  3
	{2497.3632,-1670.6297, 2497.4433,-1670.7299}, // 4  5
	{2497.4633,-1671.5506, 2497.3732,-1671.6607}, // 6  7
	{2496.5725,-1671.6607, 2496.4323,-1671.6607}, // 8  9
	{2495.6315,-1671.6607, 2495.5415,-1671.5606}  // 10 11
};

new Char[2][] =
{
	{"(0)"},
	{"(-)"}
};
//-----[ Event ]-----
new EventCreated = 0, 
	EventStarted = 0, 
	EventPrize = 500;
new Float: RedX, 
	Float: RedY, 
	Float: RedZ, 
	EventInt, 
	EventWorld;
new Float: BlueX, 
	Float: BlueY, 
	Float: BlueZ;
new EventHP = 100,
	EventArmour = 0,
	EventLocked = 0;
new EventWeapon1, 
	EventWeapon2, 
	EventWeapon3, 
	EventWeapon4, 
	EventWeapon5;
new BlueTeam = 0, 
	RedTeam = 0;
new MaxRedTeam = 5, 
	MaxBlueTeam = 5;
new IsAtEvent[MAX_PLAYERS];

//new AntiBHOP[MAX_PLAYERS];

//-----[ Discord Connector ]-----
new pemainic;

/*ResetPlayerPhone(playerid){
	if (OnPhone[playerid]) SvDetachSpeakerFromStream(OnPhone[playerid], playerid);
	return 1;
}*/

//-----[ Selfie System ]-----
new takingselfie[MAX_PLAYERS];
new Float:Degree[MAX_PLAYERS];
const Float: Radius = 1.4; //do not edit this
const Float: Speed  = 1.25; //do not edit this
const Float: Height = 1.0; // do not edit this
new Float:lX[MAX_PLAYERS];
new Float:lY[MAX_PLAYERS];
new Float:lZ[MAX_PLAYERS];

new SelectCharPlace[MAX_PLAYERS];
//clothes
new const Bajucowo[][1] =
{
	1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33,
	34, 35, 36, 37, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 68, 72, 73,
	78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
	110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133,
	134, 135, 136, 137, 142, 143, 144, 146, 153, 154, 156, 158, 159, 160, 161, 162, 167, 168, 170,
	171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 188, 189, 190, 200, 202, 203,
	204, 206, 208, 209, 210, 212, 213, 217, 220, 221, 222, 223, 228, 229, 230, 234, 235, 236, 239, 240, 241,
	242, 247, 248, 249, 250, 253, 254, 255, 258, 259, 260, 261, 262, 268, 272, 273, 289, 290, 291, 292, 293,
	294, 296, 297, 299
};

new const Bajucewe[][1] =
{
	9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69, 75, 76, 77, 85, 88, 89, 90, 91, 92,
	93, 129, 130, 131, 138, 140, 141, 145, 148, 150, 151, 152, 157, 169, 178, 190, 191, 192, 193, 194, 195, 196,
	197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245,
	246, 251, 256, 257, 263, 298
};
new const Toysbeli[][1] =
{
	2894, 19007, 19008, 19009, 19010, 19011, 19012, 19013, 19014, 19015, 19016, 19017, 19018, 19019, 19020, 19021, 19022,
	19023, 19024, 19025, 19026, 19027, 19028, 19029, 19030, 19031, 19032, 19033, 19034, 19035, 19801, 18891, 18892, 18893,
	18894, 18895, 18896, 18897, 18898, 18899, 18900, 18901, 18902, 18903, 18904, 18905, 18906, 18907, 18908, 18909, 18910,
	18911, 18912, 18913, 18914, 18915, 18916, 18917, 18918, 18919, 18920, 19036, 19037, 19038, 19557, 11704, 19472, 18974,
	19163, 19064, 19160, 19352, 19528, 19330, 19331, 18921, 18922, 18923, 18924, 18925, 18926, 18927, 18928, 18929, 18930,
	18931, 18932, 18933, 18934, 18935, 18939, 18940, 18941, 18942, 18943, 18944, 18945, 18946, 18947, 18948, 18949, 18950,
	18951, 18953, 18954, 18960, 18961, 19098, 19096, 18964, 18967, 18968, 18969, 19106, 19113, 19114, 19115, 18970, 18638,
	19553, 19558, 19554, 18971, 18972, 18973, 19101, 19116, 19117, 19118, 19119, 19120, 18952, 18645, 19039, 19040, 19041,
	19042, 19043, 19044, 19045, 19046, 19047, 19053, 19421, 19422, 19423, 19424, 19274, 19518, 19077, 19517, 19317, 19318,
	19319, 19520, 1550, 19592, 19621, 19622, 19623, 19624, 19625, 19626, 19555, 19556, 19469, 19085, 19559, 19904, 19942,
	19944, 11745, 19773, 18639, 18640, 18641, 18635, 18633, 3028, 11745, 19142
};

//race
enum e_race_data
{
	raceStart,
	Float:racePos1[3],
	Float:racePos2[3],
	Float:racePos3[3],
	Float:racePos4[3],
	Float:racePos5[3],
	Float:raceFinish[3],
};
new RaceData[MAX_PLAYERS][e_race_data];

forward Bekuplayer(playerid);
public Bekuplayer(playerid)
{
	TogglePlayerControllable(playerid, 1);
}


/*forward Status();
public Status()
{
	new statuz[256];
	format(statuz, sizeof(statuz), "%d/%d Players [ #KBRP ] HOFFENTLICH ROLEPLAY", Iter_Count(Player), GetMaxPlayers());
	DCC_SetBotActivity(statuz);
}*/
forward Status();
public Status()
{
	new statuz[256];
	format(statuz, sizeof(statuz), "%d WARGA", Iter_Count(Player));
	DCC_SetBotActivity(statuz);
}
//fly
// Players Move Speed
#define MOVE_SPEED              100.0
#define ACCEL_RATE              0.03

// Players Mode
#define CAMERA_MODE_NONE    	0
#define CAMERA_MODE_FLY     	1

// Key state definitions
#define MOVE_FORWARD    		1
#define MOVE_BACK       		2
#define MOVE_LEFT       		3
#define MOVE_RIGHT      		4
#define MOVE_FORWARD_LEFT       5
#define MOVE_FORWARD_RIGHT      6
#define MOVE_BACK_LEFT          7
#define MOVE_BACK_RIGHT         8

// Enumeration for storing data about the player
enum noclipenum
{
	cameramode,
	flyobject,
	mode,
	lrold,
	udold,
	lastmove,
	Float:accelmul
}
new noclipdata[MAX_PLAYERS][noclipenum];

stock GetMoveDirectionFromKeys(ud, lr)
{
	new direction = 0;

    if(lr < 0)
	{
		if(ud < 0) 		direction = MOVE_FORWARD_LEFT; 	// Up & Left key pressed
		else if(ud > 0) direction = MOVE_BACK_LEFT; 	// Back & Left key pressed
		else            direction = MOVE_LEFT;          // Left key pressed
	}
	else if(lr > 0) 	// Right pressed
	{
		if(ud < 0)      direction = MOVE_FORWARD_RIGHT;  // Up & Right key pressed
		else if(ud > 0) direction = MOVE_BACK_RIGHT;     // Back & Right key pressed
		else			direction = MOVE_RIGHT;          // Right key pressed
	}
	else if(ud < 0) 	direction = MOVE_FORWARD; 	// Up key pressed
	else if(ud > 0) 	direction = MOVE_BACK;		// Down key pressed

	return direction;
}

//--------------------------------------------------

stock MoveCamera(playerid)
{
	new Float:FV[3], Float:CP[3];
	GetPlayerCameraPos(playerid, CP[0], CP[1], CP[2]);          // 	Cameras position in space
    GetPlayerCameraFrontVector(playerid, FV[0], FV[1], FV[2]);  //  Where the camera is looking at

	// Increases the acceleration multiplier the longer the key is held
	if(noclipdata[playerid][accelmul] <= 1) noclipdata[playerid][accelmul] += ACCEL_RATE;

	// Determine the speed to move the camera based on the acceleration multiplier
	new Float:speed = MOVE_SPEED * noclipdata[playerid][accelmul];

	// Calculate the cameras next position based on their current position and the direction their camera is facing
	new Float:X, Float:Y, Float:Z;
	GetNextCameraPosition(noclipdata[playerid][mode], CP, FV, X, Y, Z);
	MovePlayerObject(playerid, noclipdata[playerid][flyobject], X, Y, Z, speed);

	// Store the last time the camera was moved as now
	noclipdata[playerid][lastmove] = GetTickCount();
	return 1;
}

//--------------------------------------------------

stock GetNextCameraPosition(move_mode, Float:CP[3], Float:FV[3], &Float:X, &Float:Y, &Float:Z)
{
    // Calculate the cameras next position based on their current position and the direction their camera is facing
    #define OFFSET_X (FV[0]*6000.0)
	#define OFFSET_Y (FV[1]*6000.0)
	#define OFFSET_Z (FV[2]*6000.0)
	switch(move_mode)
	{
		case MOVE_FORWARD:
		{
			X = CP[0]+OFFSET_X;
			Y = CP[1]+OFFSET_Y;
			Z = CP[2]+OFFSET_Z;
		}
		case MOVE_BACK:
		{
			X = CP[0]-OFFSET_X;
			Y = CP[1]-OFFSET_Y;
			Z = CP[2]-OFFSET_Z;
		}
		case MOVE_LEFT:
		{
			X = CP[0]-OFFSET_Y;
			Y = CP[1]+OFFSET_X;
			Z = CP[2];
		}
		case MOVE_RIGHT:
		{
			X = CP[0]+OFFSET_Y;
			Y = CP[1]-OFFSET_X;
			Z = CP[2];
		}
		case MOVE_BACK_LEFT:
		{
			X = CP[0]+(-OFFSET_X - OFFSET_Y);
 			Y = CP[1]+(-OFFSET_Y + OFFSET_X);
		 	Z = CP[2]-OFFSET_Z;
		}
		case MOVE_BACK_RIGHT:
		{
			X = CP[0]+(-OFFSET_X + OFFSET_Y);
 			Y = CP[1]+(-OFFSET_Y - OFFSET_X);
		 	Z = CP[2]-OFFSET_Z;
		}
		case MOVE_FORWARD_LEFT:
		{
			X = CP[0]+(OFFSET_X  - OFFSET_Y);
			Y = CP[1]+(OFFSET_Y  + OFFSET_X);
			Z = CP[2]+OFFSET_Z;
		}
		case MOVE_FORWARD_RIGHT:
		{
			X = CP[0]+(OFFSET_X  + OFFSET_Y);
			Y = CP[1]+(OFFSET_Y  - OFFSET_X);
			Z = CP[2]+OFFSET_Z;
		}
	}
}
//--------------------------------------------------

stock CancelFlyMode(playerid)
{
	DeletePVar(playerid, "FlyMode");
	CancelEdit(playerid);
	TogglePlayerSpectating(playerid, false);

	DestroyPlayerObject(playerid, noclipdata[playerid][flyobject]);
	noclipdata[playerid][cameramode] = CAMERA_MODE_NONE;
	return 1;
}

//--------------------------------------------------

stock FlyMode(playerid)
{
	// Create an invisible object for the players camera to be attached to
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	noclipdata[playerid][flyobject] = CreatePlayerObject(playerid, 19300, X, Y, Z, 0.0, 0.0, 0.0);

	// Place the player in spectating mode so objects will be streamed based on camera location
	TogglePlayerSpectating(playerid, true);
	// Attach the players camera to the created object
	AttachCameraToPlayerObject(playerid, noclipdata[playerid][flyobject]);

	SetPVarInt(playerid, "FlyMode", 1);
	noclipdata[playerid][cameramode] = CAMERA_MODE_FLY;
	return 1;
}

//meteor

//hole
#define REMOVE_BULLET_TIME 	(30)
// use streamer (unlimited number of objects, bullets appear after about one second delay)
// remove line to disable


// max number of bullets (will throw an error if there are too many bullets creaded)
#define MAX_BULLETS			(500)

// object used for bullets. some people use 327. by default, a red pool ball is used. you can find some other small objects here: http://gta-sa-mp.de/forum/index.php?page=Objects&objPage=searchName&objSearch=ball
#define OBJECT_BULLET		(3106)



new bullets_pending;

//tentara

#define offsetz 12
#define dur 250

new r0pes[MAX_PLAYERS][50],Float:pl_pos[MAX_PLAYERS][5]; //cause pvar + array = sux

forward syncanim(playerid);
public syncanim(playerid)
{
	if(GetPVarInt(playerid,"roped") == 0) return 0;
	SetTimerEx("syncanim",dur,0,"i",playerid);
	ApplyAnimation(playerid,"ped","abseil",4.0,0,0,0,1,0);
	return 1;
}
//anim
#define DIALOG_INDEX			(10000)		// Default dialog index to start dialog IDs from
#define ANIM_SAVE_FILE			"SavedAnimations.txt"
#define MOUSE_HOVER_COLOUR      0xFFFF00FF	// Yellow

#define MAX_ANIMS				1812		// Total amount of animations (No brackets, because it's embedded in strings)
#define MAX_LIBRARY				(132)		// Total amount of libraries
#define MAX_LIBANIMS    		(294)		// Largest library
#define MAX_LIB_NAME     		(32)
#define MAX_ANIM_NAME    		(32)		// Same as LIBNAME but just for completion!
#define MAX_SEARCH_RESULTS		(20)		// The max amount of search results that can be shown
#define MAX_SEARCH_RESULT_LEN	(MAX_SEARCH_RESULTS * (MAX_LIB_NAME + 1 + MAX_ANIM_NAME))

#define BROWSE_MODE_NONE		(0)			// Player isn't browsing
#define BROWSE_MODE_BROWSING	(2)			// Player is browsing
#define BROWSE_MODE_CAMERA		(3)			// Player is moving the camera in browse mode


#define Msg                     SendClientMessage



// anm = 3 letter prefix for animation related vars.
enum E_ANIM_SETTINGS
{
	Float:anm_Speed,
	anm_Loop,
	anm_LockX,
	anm_LockY,
	anm_Freeze,
	anm_Time
}


new
	gAnimTotal[MAX_LIBRARY],

	gLibIndex[MAX_LIBRARY][MAX_LIB_NAME],

	gLibList[MAX_LIBRARY * (MAX_LIB_NAME+1)],
	gAnimList[MAX_LIBRARY][MAX_LIBANIMS * (MAX_ANIM_NAME+1)],

	gCurrentIdx[MAX_PLAYERS],
	gCurrentLib[MAX_PLAYERS][MAX_LIB_NAME],
	gCurrentAnim[MAX_PLAYERS][MAX_ANIM_NAME],
	gBrowseMode[MAX_PLAYERS],

	gAnimSettings[MAX_PLAYERS][E_ANIM_SETTINGS];

new
	PlayerText:guiBackground,
	PlayerText:guiArrowL,
	PlayerText:guiArrowR,
	PlayerText:guiAnimIdx,
	PlayerText:guiAnimLib,
	PlayerText:guiAnimName,
	PlayerText:guiCamera,
	PlayerText:guiExitBrowser;

EnterAnimationBrowser(playerid)
{
	new
		Float:x,
		Float:y,
		Float:z,
		Float:r;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, r);

	SetPlayerCameraPos(playerid,
		x + (5*floatsin(-r, degrees)),
		y + (5*floatcos(-r, degrees)), z);

	SetPlayerCameraLookAt(playerid, x, y, z, CAMERA_MOVE);

	if(!(0 < gCurrentIdx[playerid] < MAX_ANIMS))
		gCurrentIdx[playerid] = 1811;

	LoadPlayerTextDraws(playerid);
	ShowBrowserControls(playerid);
	UpdateBrowserControls(playerid);
	SelectTextDraw(playerid, MOUSE_HOVER_COLOUR);
	PlayCurrentAnimation(playerid);

	gBrowseMode[playerid] = BROWSE_MODE_BROWSING;
}
ExitAnimationBrowser(playerid)
{
	SetCameraBehindPlayer(playerid);
	HideBrowserControls(playerid);
	UnloadPlayerTextDraws(playerid);
	CancelSelectTextDraw(playerid);
	ClearAnimations(playerid);

	gBrowseMode[playerid] = BROWSE_MODE_NONE;
}

UpdateBrowserControls(playerid)
{
	new tmp[32];

	valstr(tmp, gCurrentIdx[playerid]);
	PlayerTextDrawSetString(playerid, guiAnimIdx, tmp);

	PlayerTextDrawSetString(playerid, guiAnimLib, gCurrentLib[playerid]);
	PlayerTextDrawSetString(playerid, guiAnimName, gCurrentAnim[playerid]);

	ShowBrowserControls(playerid);
}


PlayCurrentAnimation(playerid)
{
	ClearAnimations(playerid);
    ApplyAnimation(playerid,
		gCurrentLib[playerid],
		gCurrentAnim[playerid],
		gAnimSettings[playerid][anm_Speed],
		gAnimSettings[playerid][anm_Loop],
		gAnimSettings[playerid][anm_LockX],
		gAnimSettings[playerid][anm_LockY],
		gAnimSettings[playerid][anm_Freeze],
		gAnimSettings[playerid][anm_Time],
		1);
}



SaveCurrentAnimation(playerid, comment[])
{
	new
		File:file,
		line[156]; // Based on comment max len = 32

	if(!fexist(ANIM_SAVE_FILE))file = fopen(ANIM_SAVE_FILE, io_write);
	else file = fopen(ANIM_SAVE_FILE, io_append);

	format(line, 156, "ApplyAnimation(playerid, \"%s\", \"%s\", %.1f, %d, %d, %d, %d, %d); // %s\r\n",
		gCurrentLib[playerid],
		gCurrentAnim[playerid],
		gAnimSettings[playerid][anm_Speed],
		gAnimSettings[playerid][anm_Loop],
		gAnimSettings[playerid][anm_LockX],
		gAnimSettings[playerid][anm_LockY],
		gAnimSettings[playerid][anm_Freeze],
		gAnimSettings[playerid][anm_Time],
		comment);

	fwrite(file, line);
	fclose(file);
}

AnimSearch(query[], output[])
{
	new
		j,
		animlen,
		findpos,
		tmp[MAX_ANIM_NAME],
		items;

	for(new i; i < MAX_LIBRARY && items < MAX_SEARCH_RESULTS; i++)
	{
		while(j < strlen(gAnimList[i]))
		{
			if(gAnimList[i][j] == '\n')
			{
				animlen = strfind(gAnimList[i], "\n", false, j+1) - j;
				findpos = strfind(gAnimList[i], query, true, j+1);

				if(findpos != -1 && findpos - j < animlen)
				{
					if(animlen == -1)strmid(tmp, gAnimList[i], j+1, strlen(gAnimList[i]), MAX_ANIM_NAME);
					else strmid(tmp, gAnimList[i], j+1, j+animlen, MAX_ANIM_NAME);

					strcat(output, gLibIndex[i], MAX_SEARCH_RESULTS * MAX_ANIM_NAME);
					strcat(output, "~", MAX_SEARCH_RESULTS * MAX_ANIM_NAME);
					strcat(output, tmp, MAX_SEARCH_RESULTS * MAX_ANIM_NAME);
					strcat(output, "\n", MAX_SEARCH_RESULTS * MAX_ANIM_NAME);

					items++;
				}
			}
			j++;
		}
	}
	return items;
}


PreloadPlayerAnims(playerid)
{
   	PreloadAnimLib(playerid,"BOMBER");
   	PreloadAnimLib(playerid,"RAPPING");
   	PreloadAnimLib(playerid,"SHOP");
	PreloadAnimLib(playerid,"BEACH");
	PreloadAnimLib(playerid,"SMOKING");
   	PreloadAnimLib(playerid,"FOOD");
   	PreloadAnimLib(playerid,"ON_LOOKERS");
   	PreloadAnimLib(playerid,"DEALER");
	PreloadAnimLib(playerid,"CRACK");
	PreloadAnimLib(playerid,"CARRY");
	PreloadAnimLib(playerid,"COP_AMBIENT");
	PreloadAnimLib(playerid,"PARK");
	PreloadAnimLib(playerid,"INT_HOUSE");
	PreloadAnimLib(playerid,"FOOD");
	PreloadAnimLib(playerid,"PED");
}

ShowBrowserControls(playerid)
{
	PlayerTextDrawShow(playerid, guiBackground);
	PlayerTextDrawShow(playerid, guiArrowL);
	PlayerTextDrawShow(playerid, guiArrowR);
	PlayerTextDrawShow(playerid, guiAnimIdx);
	PlayerTextDrawShow(playerid, guiAnimLib);
	PlayerTextDrawShow(playerid, guiAnimName);
	PlayerTextDrawShow(playerid, guiCamera);
	PlayerTextDrawShow(playerid, guiExitBrowser);
}
HideBrowserControls(playerid)
{
	PlayerTextDrawHide(playerid, guiBackground);
	PlayerTextDrawHide(playerid, guiArrowL);
	PlayerTextDrawHide(playerid, guiArrowR);
	PlayerTextDrawHide(playerid, guiAnimIdx);
	PlayerTextDrawHide(playerid, guiAnimLib);
	PlayerTextDrawHide(playerid, guiAnimName);
	PlayerTextDrawHide(playerid, guiCamera);
	PlayerTextDrawHide(playerid, guiExitBrowser);
}

LoadPlayerTextDraws(playerid)
{
	guiBackground					=CreatePlayerTextDraw(playerid, 320.0, 336.0, "~n~");
	PlayerTextDrawAlignment			(playerid, guiBackground, 2);
	PlayerTextDrawBackgroundColor	(playerid, guiBackground, 255);
	PlayerTextDrawFont				(playerid, guiBackground, 2);
	PlayerTextDrawLetterSize		(playerid, guiBackground, 0.25, 9.8);
	PlayerTextDrawColor				(playerid, guiBackground, -1);
	PlayerTextDrawSetOutline		(playerid, guiBackground, 0);
	PlayerTextDrawSetProportional	(playerid, guiBackground, 1);
	PlayerTextDrawSetShadow			(playerid, guiBackground, 1);
	PlayerTextDrawUseBox			(playerid, guiBackground, 1);
	PlayerTextDrawBoxColor			(playerid, guiBackground, 80);
	PlayerTextDrawTextSize			(playerid, guiBackground, 0.0, 220.0);

	guiArrowL						=CreatePlayerTextDraw(playerid, 280.0, 350.0, "<");
	PlayerTextDrawTextSize			(playerid, guiArrowL, 20.0, 20.0);
	PlayerTextDrawAlignment			(playerid, guiArrowL, 2);
	PlayerTextDrawBackgroundColor	(playerid, guiArrowL, 255);
	PlayerTextDrawFont				(playerid, guiArrowL, 1);
	PlayerTextDrawLetterSize		(playerid, guiArrowL, 0.5, 3.0);
	PlayerTextDrawColor				(playerid, guiArrowL, -1);
	PlayerTextDrawSetOutline		(playerid, guiArrowL, 1);
	PlayerTextDrawSetProportional	(playerid, guiArrowL, 1);
	PlayerTextDrawSetShadow			(playerid, guiArrowL, 0);
	PlayerTextDrawSetSelectable		(playerid, guiArrowL, 1);

	guiArrowR						=CreatePlayerTextDraw(playerid, 360.0, 350.0, ">");
	PlayerTextDrawTextSize			(playerid, guiArrowR, 20.0, 20.0);
	PlayerTextDrawAlignment			(playerid, guiArrowR, 2);
	PlayerTextDrawBackgroundColor	(playerid, guiArrowR, 255);
	PlayerTextDrawFont				(playerid, guiArrowR, 1);
	PlayerTextDrawLetterSize		(playerid, guiArrowR, 0.5, 3.0);
	PlayerTextDrawColor				(playerid, guiArrowR, -1);
	PlayerTextDrawSetOutline		(playerid, guiArrowR, 1);
	PlayerTextDrawSetProportional	(playerid, guiArrowR, 1);
	PlayerTextDrawSetShadow			(playerid, guiArrowR, 0);
	PlayerTextDrawSetSelectable		(playerid, guiArrowR, 1);

	guiAnimIdx						=CreatePlayerTextDraw(playerid, 320.0, 355.0, "1800");
	PlayerTextDrawTextSize			(playerid, guiAnimIdx, 10.0, 20.0);
	PlayerTextDrawAlignment			(playerid, guiAnimIdx, 2);
	PlayerTextDrawBackgroundColor	(playerid, guiAnimIdx, 255);
	PlayerTextDrawFont				(playerid, guiAnimIdx, 2);
	PlayerTextDrawLetterSize		(playerid, guiAnimIdx, 0.3, 1.8);
	PlayerTextDrawColor				(playerid, guiAnimIdx, -1);
	PlayerTextDrawSetOutline		(playerid, guiAnimIdx, 0);
	PlayerTextDrawSetProportional	(playerid, guiAnimIdx, 1);
	PlayerTextDrawSetShadow			(playerid, guiAnimIdx, 1);
	PlayerTextDrawSetSelectable		(playerid, guiAnimIdx, 1);

	guiAnimLib						=CreatePlayerTextDraw(playerid, 320.0, 375.0, "ANIMATION LIBRARY");
	PlayerTextDrawAlignment			(playerid, guiAnimLib, 2);
	PlayerTextDrawBackgroundColor	(playerid, guiAnimLib, 255);
	PlayerTextDrawFont				(playerid, guiAnimLib, 2);
	PlayerTextDrawLetterSize		(playerid, guiAnimLib, 0.3, 1.8);
	PlayerTextDrawColor				(playerid, guiAnimLib, -1);
	PlayerTextDrawSetOutline		(playerid, guiAnimLib, 0);
	PlayerTextDrawSetProportional	(playerid, guiAnimLib, 1);
	PlayerTextDrawSetShadow			(playerid, guiAnimLib, 1);

	guiAnimName						=CreatePlayerTextDraw(playerid, 320.0, 390.0, "ANIMATION NAME");
	PlayerTextDrawAlignment			(playerid, guiAnimName, 2);
	PlayerTextDrawBackgroundColor	(playerid, guiAnimName, 255);
	PlayerTextDrawFont				(playerid, guiAnimName, 2);
	PlayerTextDrawLetterSize		(playerid, guiAnimName, 0.3, 1.8);
	PlayerTextDrawColor				(playerid, guiAnimName, -1);
	PlayerTextDrawSetOutline		(playerid, guiAnimName, 0);
	PlayerTextDrawSetProportional	(playerid, guiAnimName, 1);
	PlayerTextDrawSetShadow			(playerid, guiAnimName, 1);

	guiCamera						=CreatePlayerTextDraw(playerid, 320.0, 336.0, "Click for camera mode");
	PlayerTextDrawTextSize			(playerid, guiCamera, 10.0, 130.0);
	PlayerTextDrawAlignment			(playerid, guiCamera, 2);
	PlayerTextDrawBackgroundColor	(playerid, guiCamera, 255);
	PlayerTextDrawFont				(playerid, guiCamera, 2);
	PlayerTextDrawLetterSize		(playerid, guiCamera, 0.25, 1.5);
	PlayerTextDrawColor				(playerid, guiCamera, -1);
	PlayerTextDrawSetOutline		(playerid, guiCamera, 0);
	PlayerTextDrawSetProportional	(playerid, guiCamera, 1);
	PlayerTextDrawSetShadow			(playerid, guiCamera, 1);
	PlayerTextDrawSetSelectable		(playerid, guiCamera, 1);

	guiExitBrowser					=CreatePlayerTextDraw(playerid, 320.000000, 410.000000, "Exit");
	PlayerTextDrawTextSize			(playerid, guiExitBrowser, 10.0, 25.0);
	PlayerTextDrawAlignment			(playerid, guiExitBrowser, 2);
	PlayerTextDrawBackgroundColor	(playerid, guiExitBrowser, 255);
	PlayerTextDrawFont				(playerid, guiExitBrowser, 2);
	PlayerTextDrawLetterSize		(playerid, guiExitBrowser, 0.250000, 1.500000);
	PlayerTextDrawColor				(playerid, guiExitBrowser, -1);
	PlayerTextDrawSetOutline		(playerid, guiExitBrowser, 0);
	PlayerTextDrawSetProportional	(playerid, guiExitBrowser, 1);
	PlayerTextDrawSetShadow			(playerid, guiExitBrowser, 1);
	PlayerTextDrawSetSelectable		(playerid, guiExitBrowser, 1);
}

UnloadPlayerTextDraws(playerid)
{
	PlayerTextDrawDestroy(playerid, guiBackground);
	PlayerTextDrawDestroy(playerid, guiArrowL);
	PlayerTextDrawDestroy(playerid, guiArrowR);
	PlayerTextDrawDestroy(playerid, guiAnimIdx);
	PlayerTextDrawDestroy(playerid, guiAnimLib);
	PlayerTextDrawDestroy(playerid, guiAnimName);
	PlayerTextDrawDestroy(playerid, guiCamera);
	PlayerTextDrawDestroy(playerid, guiExitBrowser);
}


CMD:deltd(playerid, params[])
{
	for(new i;i<2048;i++)PlayerTextDrawHide(playerid, PlayerText:i);
	return 1;
}



//
enum
{
    //--[Dialog Graffity]--
	DIALOG_WELCOME,
	DIALOG_SELECT,
	DIALOG_INPUTGRAFF,
	DIALOG_DUTYFRAKSI,
	DIALOG_COLOR,
	DIALOG_HAPPY,
	DIALOG_LIST,
	BUY_SPRAYCAN,
	DIALOG_GOMENU,
	DIALOG_GDOBJECT,
	D_ANIM_LIBRARIES = DIALOG_INDEX,		// The list of animation libraries
	D_ANIM_LIST,							// The list of animations in a library
	D_ANIM_SEARCH,							// Search query dialog
	D_ANIM_SEARCH_RESULTS,					// Search results list
	D_ANIM_SETTINGS,						// Animation parameter setup
	D_ANIM_SPEED,							// Animation speed parameter input
	D_ANIM_TIME,							// Animation time parameter input
	D_ANIM_IDX,
    //tuning
    DIALOG_TUNING,
    DIALOG_TUNEBRAKE,
    DIALOG_TUNETURBO,
    DIALOG_VM,
    DIALOG_SAPD_GARAGE,
    DIALOG_SAMD_GARAGE,
    DIALOG_PEDAGANG_GARAGE,
    DIALOG_SANA_GARAGE,
    //DEALER
	DIALOG_BUYJOBCARSVEHICLE,
	DIALOG_BUYDEALERCARS_CONFIRM,
	DIALOG_BUYTRUCKVEHICLE,
	DIALOG_BUYMOTORCYCLEVEHICLE,
	DIALOG_BUYUCARSVEHICLE,
	DIALOG_BUYCARSVEHICLE,
	DIALOG_DEALER_MANAGE,
	DIALOG_DEALER_VAULT,
	DIALOG_DEALER_WITHDRAW,
	DIALOG_DEALER_DEPOSIT,
	DIALOG_DEALER_NAME,
	DIALOG_DEALER_RESTOCK,
	DIALOG_FIND_DEALER,
	//carsteal
	DIALOG_ROBCARS,
	DIALOG_PESAWAT,
	//player
	DIALOG_MAKE_CHAR,
	DIALOG_CHARLIST,
	DIALOG_VERIFYCODE,
	DIALOG_UNUSED,
    DIALOG_LOGIN,
    DIALOG_REGISTER,
    DIALOG_AGE,
	DIALOG_GENDER,
	DIALOG_EMAIL,
	DIALOG_PASSWORD,
	DIALOG_STATS,
	DIALOG_SETTINGS,
	DIALOG_HBEMODE,
	DIALOG_KTPSIM,
	DIALOG_DOKUMEN,
	DIALOG_PANELPAKAIAN,
	DIALOG_PANELKENDARAAN,
	DIALOG_CHANGEAGE,
	DIALOG_GOLDSHOP,
	DIALOG_TULANG,
	DIALOG_PTULANG,
	DIALOG_GOLDNAME,
	DIALOG_SELL_BISNISS,
	DIALOG_SELL_BISNIS,
	DIALOG_MY_BISNIS,
	BISNIS_MENU,
	BISNIS_INFO,
	BISNIS_NAME,
	BISNIS_VAULT,
	BISNIS_WITHDRAW,
	BISNIS_DEPOSIT,
	BISNIS_BUYPROD,
	BISNIS_EDITPROD,
	BISNIS_PRICESET,
	DIALOG_SELL_HOUSES,
	DIALOG_SELL_HOUSE,
	DIALOG_MY_HOUSES,
	HOUSE_INFO,
	GUDANG_STORAGE,
	GUDANG_WEAPONS,
	GUDANG_MONEY,
	GUDANG_FOODDRINK,
	GUDANG_DRUGS,
	GUDANG_OTHER,
	GUDANG_REALMONEY,
	GUDANG_REDMONEY,
	GUDANG_WITHDRAW_REALMONEY,
	GUDANG_DEPOSIT_REALMONEY,
	GUDANG_WITHDRAW_REDMONEY,
	GUDANG_DEPOSIT_REDMONEY,
	GUDANG_FOOD,
	GUDANG_FOOD_DEPOSIT,
	GUDANG_FOOD_WITHDRAW,
	GUDANG_DRINK,
	GUDANG_DRINK_DEPOSIT,
	GUDANG_DRINK_WITHDRAW,
	GUDANG_BANDAGE,
	GUDANG_BANDAGE_WITHDRAW,
	GUDANG_BANDAGE_DEPOSIT,
	GUDANG_MATERIAL,
	GUDANG_MATERIAL_DEPOSIT,
	GUDANG_MATERIAL_WITHDRAW,
	GUDANG_COMPONENT,
	GUDANG_COMPONENT_DEPOSIT,
	GUDANG_COMPONENT_WITHDRAW,
	HOUSE_STORAGE,
	HOUSE_WEAPONS,
	HOUSE_MONEY,
	HOUSE_REALMONEY,
	HOUSE_WITHDRAW_REALMONEY,
	HOUSE_DEPOSIT_REALMONEY,
	HOUSE_REDMONEY,
	HOUSE_WITHDRAW_REDMONEY,
	HOUSE_DEPOSIT_REDMONEY,
	HOUSE_FOODDRINK,
	HOUSE_FOOD,
	HOUSE_FOOD_DEPOSIT,
	HOUSE_FOOD_WITHDRAW,
	HOUSE_DRINK,
	HOUSE_DRINK_DEPOSIT,
	HOUSE_DRINK_WITHDRAW,
	HOUSE_DRUGS,
	HOUSE_MEDICINE,
	HOUSE_MEDICINE_DEPOSIT,
	HOUSE_MEDICINE_WITHDRAW,
	HOUSE_MEDKIT,
	HOUSE_MEDKIT_DEPOSIT,
	HOUSE_MEDKIT_WITHDRAW,
	HOUSE_BANDAGE,
	HOUSE_BANDAGE_DEPOSIT,
	HOUSE_BANDAGE_WITHDRAW,
	HOUSE_OTHER,
	HOUSE_SEED,
	HOUSE_SEED_DEPOSIT,
	HOUSE_SEED_WITHDRAW,
	HOUSE_MATERIAL,
	HOUSE_MATERIAL_DEPOSIT,
	HOUSE_MATERIAL_WITHDRAW,
	HOUSE_COMPONENT,
	HOUSE_COMPONENT_DEPOSIT,
	HOUSE_COMPONENT_WITHDRAW,
	HOUSE_MARIJUANA,
	HOUSE_MARIJUANA_DEPOSIT,
	HOUSE_MARIJUANA_WITHDRAW,
	DIALOG_FINDVEH,
	DIALOG_TRACKVEH,
	DIALOG_TRACKVEH2,
	DIALOG_TRACKPARKEDVEH,
	DIALOG_GOTOVEH,
	DIALOG_GETVEH,
	DIALOG_DELETEVEH,
	DIALOG_BUYPV,
	DIALOG_BUYVIPPV,
	DIALOG_BUYPLATE,
	DIALOG_BUYPVCP,
	DIALOG_BUYPVCP_BIKES,
	DIALOG_BUYPVCP_CARS,
	DIALOG_BUYPVCP_UCARS,
	DIALOG_BUYPVCP_JOBCARS,
	DIALOG_BUYPVCP_VIPCARS,
	DIALOG_BUYPVCP_CONFIRM,
	DIALOG_BUYPVCP_VIPCONFIRM,
	DIALOG_RENT_JOBCARS,
	DIALOG_RENT_KANDANGCONFIRM,
	DIALOG_RENT_JOBCARSCONFIRM,
	DIALOG_RENT_BOAT,
	DIALOG_RENT_BOATCONFIRM,
	DIALOG_RENT_BIKE,
	DIALOG_RENT_BIKECONFIRM,
	DIALOG_GARKOT,
	DIALOG_MY_VEHICLE,
	DIALOG_RENT_VEHICLE,
	DIALOG_RENT_VEHICLECONFIRM,
	//Inventory
	INVENTORY_MENU,
	INVENTORY_AMOUNT,
	INVENTORY_GIVE,
	INVENTORY_DROP,
	INVENTORY_PICKUP,
	//garage
	DIALOG_GARAGETAKE,
	DIALOG_GARAGENAME,
	DIALOG_GARAGEFEE,
	DIALOG_GARAGEOWNER,
	DIALOG_GARAGE,
	//---[ DIALOG FARM PRIVATE ]---
	FARM_MENU,
	FARM_SETNAME,
	DIALOG_MY_FARM,
	FARM_SETEMPLOYE,
	DIALOG_TRACK_FARM,
	FARM_SETOWNERCONFIRM,
	FARM_MONEY,
	FARM_MONEY2,
	FARM_SEEDS,
	FARM_SEEDS2,
	FARM_POTATO,
	FARM_POTATO2,
	FARM_WHEAT,
	FARM_WHEAT2,
	FARM_ORANGE,
	FARM_ORANGE2,
	//Vehicle Toys
	DIALOG_MMENU,
	DIALOG_VTOY,
	DIALOG_VTOYBUY,
	DIALOG_VTOYEDIT,
	DIALOG_VTOYPOSX,
	DIALOG_VTOYPOSY,
	DIALOG_VTOYPOSZ,
	DIALOG_VTOYPOSRX,
	DIALOG_VTOYPOSRY,
	DIALOG_VTOYPOSRZ,
	DIALOG_ENTER_VALUE,
	//toys
	VSELECT_POS,
	VTOYSET_VALUE,
	VTOYSET_COLOUR,
	VTOY_ACCEPT,
	DIALOG_TOY,
	DIALOG_TOYEDIT,
	DIALOG_TOYEDIT_ANDROID,
	DIALOG_TOYPOSISI,
	DIALOG_TOYPOSISIBUY,
	DIALOG_TOYBUY,
	DIALOG_TOYVIP,
	DIALOG_TOYPOSX,
	DIALOG_TOYPOSY,
	DIALOG_TOYPOSZ,
	DIALOG_TOYPOSRX,
	DIALOG_TOYPOSRY,
	DIALOG_TOYPOSRZ,
	DIALOG_TOYPOSSX,
	DIALOG_TOYPOSSY,
	DIALOG_TOYPOSSZ,
	DIALOG_HELP,
	DIALOG_GPS,
	DIALOG_BAD,
	DIALOG_BAD1,
	DIALOG_BAD2,
	DIALOG_BAD3,
	DIALOG_BAD4,
	DIALOG_SPAWNVEH,
	DIALOG_JOB,
	DIALOG_GPS_AYAM,
	DIALOG_GPS_JOB,
	DIALOG_GPS_PUBLIC,
	DIALOG_GPS_PROPERTIES,
	DIALOG_GPS_GENERAL,
	DIALOG_GPS_MISSION,
	DIALOG_TRACKBUSINESS,
	DIALOG_ELECTRONIC_TRACK,
	DIALOG_PAY,
	DIALOG_EDITBONE,
	FAMILY_SAFE,
	FAMILY_STORAGE,
	FAMILY_WEAPONS,
	FAMILY_MARIJUANA,
	FAMILY_WITHDRAWMARIJUANA,
	FAMILY_DEPOSITMARIJUANA,
	FAMILY_COMPONENT,
	FAMILY_WITHDRAWCOMPONENT,
	FAMILY_DEPOSITCOMPONENT,
	FAMILY_MATERIAL,
	FAMILY_WITHDRAWMATERIAL,
	FAMILY_DEPOSITMATERIAL,
	FAMILY_MONEY,
	FAMILY_WITHDRAWMONEY,
	FAMILY_DEPOSITMONEY,
	FAMILY_INFO,
	DIALOG_SERVERMONEY,
	DIALOG_SERVERMONEY_STORAGE,
	DIALOG_SERVERMONEY_WITHDRAW,
	DIALOG_SERVERMONEY_DEPOSIT,
	DIALOG_SERVERMONEY_REASON,
	DIALOG_LOCKERSAPD,
	DIALOG_DISNAKER,
	DIALOG_LOCKERSAAF,
	DIALOG_WEAPONSAPD,
	DIALOG_LOCKERSAGS,
	DIALOG_WEAPONSAGS,
	DIALOG_LOCKERSAMD,
	BANDAGE_WD,
	DIALOG_WEAPONSAMD,
	DIALOG_DRUGSSAMD,
	DIALOG_LOCKERSANEW,
	DIALOG_WEAPONSANEW,
	DIALOG_LOCKERPEDAGANG,
	DIALOG_GUDANGPEDAGANG,
	DIALOG_LOCKERVIP,
	DIALOG_SERVICE,
	DIALOG_SERVICE_COLOR,
	DIALOG_SERVICE_COLOR2,
	DIALOG_SERVICE_PAINTJOB,
	DIALOG_SERVICE_WHEELS,
	DIALOG_SERVICE_SPOILER,
	DIALOG_SERVICE_HOODS,
	DIALOG_SERVICE_VENTS,
	DIALOG_SERVICE_LIGHTS,
	DIALOG_SERVICE_EXHAUSTS,
	DIALOG_SERVICE_FRONT_BUMPERS,
	DIALOG_SERVICE_REAR_BUMPERS,
	DIALOG_SERVICE_ROOFS,
	DIALOG_SERVICE_SIDE_SKIRTS,
	DIALOG_SERVICE_BULLBARS,
	DIALOG_SERVICE_NEON,
	DIALOG_MENU_TRUCKER,
	DIALOG_SHIPMENTS,
	DIALOG_SHIPMENTS_VENDING,
	DIALOG_HAULING,
	DIALOG_RESTOCK,
	DIALOG_RESTOCK_VENDING,
	DIALOG_ARMS_GUN,
	DIALOG_ARMS_AMMO,
	DIALOG_PLANT,
	DIALOG_EDIT_PRICE,
	DIALOG_EDIT_PRICE1,
	DIALOG_EDIT_PRICE2,
	DIALOG_EDIT_PRICE3,
	DIALOG_EDIT_PRICE4,
	DIALOG_OFFER,
	DIALOG_MATERIAL,
	DIALOG_COMPONENT,
	//cctv
	DIALOG_SHOW_CCTV,
	DIALOG_AYAM,
	DIALOG_AYAMFILL,
	DIALOG_DRUGS,
	DIALOG_FOOD,
	DIALOG_FOOD_BUY,
	DIALOG_SEED_BUY,
	DIALOG_PRODUCT,
	DIALOG_GASOIL,
	DIALOG_APOTEK,
	DIALOG_MEDICINE,
	DIALOG_MEDKIT,
	DIALOG_BANDAGE,
	DIALOG_LOCKERSAAG,
	SAAG_MONEY,
	SAAG_WITHDRAWMONEY,
	SAAG_DEPOSITMONEY,
	SAAG_COMPO,
	SAAG_WITHDRAWCOMPO,
	SAAG_DEPOSITCOMPO,
	DIALOG_ATM,
	DIALOG_TRACKATM,
	DIALOG_ATMWITHDRAW,
	DIALOG_BANK,
	DIALOG_BANKDEPOSIT,
	DIALOG_BANKWITHDRAW,
	DIALOG_BANKREKENING,
	DIALOG_BANKTRANSFER,
	DIALOG_BANKCONFIRM,
	DIALOG_BANKSUKSES,
	DIALOG_BOOMBOX1,
	DIALOG_BOOMBOX,
	DIALOG_PHONE,
	PHONE_APP,
	PHONE_NOTIF,
	TWEET_APP,
	TWEET_SIGNUP,
	TWEET_CHANGENAME,
	TWEET_ACCEPT_CHANGENAME,
	DIALOG_TWEETMODE,
	DIALOG_PHONE_ADDCONTACT,
	DIALOG_PHONE_CONTACT,
	DIALOG_PHONE_NEWCONTACT,
	DIALOG_PHONE_INFOCONTACT,
	DIALOG_PHONE_SENDSMS,
	DIALOG_PHONE_TEXTSMS,
	DIALOG_SKINID,
	DIALOG_PHONE_DIALUMBER,
	DIALOG_TOGGLEPHONE,
	DIALOG_IBANK,
	DIALOG_REPORTS,
	DIALOG_ANSWER_REPORTS,
	DIALOG_ASKS,
	DIALOG_SALARY,
	DIALOG_PAYCHECK,
	DIALOG_SWEEPER,
	DIALOG_PAPER,
	DIALOG_BUS,
	DIALOG_FORKLIFT,
	DIALOG_MOWER,
	DIALOG_RUTE_SWEEPER,
	DIALOG_RUTE_BUS,
	DIALOG_BAGGAGE,
	DIALOG_HEALTH,
	DIALOG_OBAT,
	DIALOG_ISIKUOTA,
	DIALOG_DOWNLOAD,
	DIALOG_DOWNLOADD,
	DIALOG_KUOTA,
	DIALOG_STUCK,
	DIALOG_TDM,
	DIALOG_PICKUPVEH,
	DIALOG_TRACKPARK,
	DIALOG_RESPAWNPV,
	DIALOG_MY_WS,
	DIALOG_TRACKWS,
	WS_MENU,
	WS_SETNAME,
	WS_SETOWNER,
	WS_SETEMPLOYE,
	WS_SETEMPLOYEE,
	WS_SETOWNERCONFIRM,
	WS_SETMEMBER,
	WS_SETMEMBERE,
	WS_MONEY,
	WS_WITHDRAWMONEY,
	WS_DEPOSITMONEY,
	WS_COMPONENT,
	WS_COMPONENT2,
	WS_MATERIAL,
	WS_MATERIAL2,
	DIALOG_ACTORANIM,
	DIALOG_MY_VENDING,
	DIALOG_VENDING_INFO,
	DIALOG_VENDING_BUYPROD,
	DIALOG_VENDING_MANAGE,
	DIALOG_VENDING_NAME,
	DIALOG_VENDING_VAULT,
	DIALOG_VENDING_WITHDRAW,
	DIALOG_VENDING_DEPOSIT,
	DIALOG_VENDING_EDITPROD,
	DIALOG_VENDING_PRICESET,
	DIALOG_VENDING_RESTOCK,
	DIALOG_SPAWN_1,
	DIALOG_VEHMENU,
	DIALOG_LOCKVEH,
	DIALOG_VCONTROL,
	DIALOG_INSURANCE,
	DIALOG_UNIMPOUND,
	DIALOG_MYVEH,
	DIALOG_MYVEH_INFO,
	DIALOG_FAMILY_INTERIOR,
	DIALOG_SPAREPART,
	DIALOG_BUYPARTS,
	DIALOG_BUYPARTS_DONE,
	DIALOG_NONRPNAME,
	//TRUNK
	TRUNK_STORAGE,
	TRUNK_WEAPONS,
	TRUNK_MONEY,
	TRUNK_COMP,
	TRUNK_MATS,
	TRUNK_GAS,
	TRUNK_SPRUNK,
	TRUNK_SNACK,
	TRUNK_MARIJUANA,
	TRUNK_DEPOSITMONEY,
	TRUNK_WITHDRAWMONEY,
	TRUNK_DEPOSITCOMP,
	TRUNK_WITHDRAWCOMP,
	TRUNK_DEPOSITMATS,
	TRUNK_WITHDRAWMATS,
	TRUNK_DEPOSITMARIJUANA,
	TRUNK_WITHDRAWMARIJUANA,
	TRUNK_DEPOSITSPRUNK,
	TRUNK_DEPOSITSNACK,
	TRUNK_WITHDRAWSNACK,
	TRUNK_WITHDRAWSPRUNK,
 	TRUNK_WITHDRAWGAS,
 	TRUNK_DEPOSITGAS,
	
	//MDC
	DIALOG_TRACK_PH,
	DIALOG_TRACK_BIS,
	DIALOG_TRACK,
	DIALOG_INFO_BIS,
	DIALOG_INFO_HOUSE,
}

//-----[ Download System ]-----
new download[MAX_PLAYERS];

//-----[ Count System ]-----
new Count = -1;
new countTimer;
new showCD[MAX_PLAYERS];
new CountText[5][5] =
{
	"~r~1",
	"~g~2",
	"~y~3",
	"~g~4",
	"~b~5"
};

//-----[ Rob System ]-----
new robmoney;

//-----[ Server Uptime ]-----
new up_days,
	up_hours,
	up_minutes,
	up_seconds,
	WorldTime = 10,
	WorldWeather = 24;

//-----[ Faction Vehicle ]-----	
#define VEHICLE_RESPAWN 7200

new SAPDVehicles[75],
	SAGSVehicles[30],
	SAMDVehicles[30],
	SANAVehicles[30];

IsSAPDCar(carid)
{
	foreach(new i : Player)
	{
		    if(carid == SAPDVeh[i]) return 1;
	}
	return 0;
}

IsGovCar(carid)
{
	for(new v = 0; v < sizeof(SAGSVehicles); v++)
	{
	    if(carid == SAGSVehicles[v]) return 1;
	}
	return 0;
}

IsSAMDCar(carid)
{
	for(new v = 0; v < sizeof(SAMDVehicles); v++)
	{
	    if(carid == SAMDVehicles[v]) return 1;
	}
	return 0;
}

IsSANACar(carid)
{
	for(new v = 0; v < sizeof(SANAVehicles); v++)
	{
	    if(carid == SANAVehicles[v]) return 1;
	}
	return 0;
}

//-----[ Showroom Checkpoint ]-----	
new ShowRoomCPRent,
	BajuElCorona,
	Mejajahit,
	Dutyjahit,
	Segitigabermuda,
	Areaayam,
	Zonameka,
	ZonaGYM;

new DutyTimer;
new MalingKendaraan;

//-----[ Button ]-----	
new SAGSLobbyBtn[8],
	SAGSLobbyDoor[4],
	SAMCLobbyBtn[6],
	SAMCLobbyDoor[3];

//-----[ MySQL Connect ]-----	
new MySQL: g_SQL;

new TogOOC = 1;


//-----[ Player Data ]-----	
enum E_PLAYERS
{
	pID,
	pUCP[22],
	pExtraChar,
	pChar,
	pName[MAX_PLAYER_NAME],
	pAdminname[MAX_PLAYER_NAME],
	pIP[16],
	pVerifyCode,
	pPassword[65],
	pSalt[17],
	pEmail[40],
	pCs,
	pAdmin,
	pHelper,
	Text3D: pIdlabel,
	pLevel,
	pLevelUp,
	pBooster,
	pBoostTime,
	pVip,
	pVipTime,
	pGold,
	pRegDate[50],
	pLastLogin[50],
	pMoney,
	pRedMoney,
	STREAMER_TAG_3D_TEXT_LABEL:pMaskLabel,
	pBankMoney,
	Rudal,
	pMedicActor,
	Blackhole,
	pTotaltf,
	pTotalditf,
	pTotalwd,
	pTotalgaji,
	pBankRek,
	pBoombox,
	pPhone,
	pPhoneCredit,
	pContact,
	pPhoneBook,
	pSMS,
	pCall,
	pCallTime,
	pWT,
	pHours,
	pMinutes,
	pSeconds,
	pPaycheck,
	pSkin,
	pFacSkin,
	pGender,
	pAge[50],
	pTransferFarm,
	pInFarm,
	pInDoor,
	pInRental,
	pInDealer,
	pInHouse,
	pDirumah,
	pInBiz,
	pInVending,
	pRestock,
	pDealerMission,
	pInFamily,
	Float: pPosX,
	Float: pPosY,
	Float: pPosZ,
	Float: pPosA,
	pInt,
	pWorld,
	Float:pHealth,
    Float:pArmour,
    pCampid,
    pPaperduty,
    pKoran,
    pKoran1,
    pKoran2,
    pKoran3,
    pKoran4,
    pKoran5,
    pKoran6,
    pCamping,
    pBeli,
    pKantong,
    pInfo,
    pInfo1,
    pInfo2,
    pInfo3,
    pInfo4,
    pPencet,
	pHunger,
	pEnergy,
	pBladder,
	pHungerTime,
	pEnergyTime,
	pBladderTime,
	pSick,
	pRegen,
	pSehat,
	Namateks[128],
	pSickTime,
	pDarahorang,
	pBerhasiltest,
	pHospital,
	pHospitalTime,
	pInjured,
	STREAMER_TAG_3D_TEXT_LABEL: pGeledahLabel,
	STREAMER_TAG_3D_TEXT_LABEL: pInjuredLabel,
	pOnDuty,
	pOnDutyTime,
	pFaction,
	pFactionRank,
	pFactionLead,
	pTazer,
	pGuntazer,
	pKenatazer,
	pBroadcast,
	pNewsGuest,
	pFamily,
	pFamilyRank,
	pWorkshop,
	pTiket,
	pTipetiket,
	pOffertiket,
	pWorkshopRank,
	pWoRank,
	pWoInvite,
	pWoOffer,
	pJail,
	pJailTime,
	pArrest,
	pArrestTime,
	pLoginUcp,
	pSpawnSapd,
	pSpawnSamd,
	pSpawnPg,
	pSpawnSana,
	pWarn,
	pJob,
	pJob2,
	pJobTime,
	pExitJob,
	pMedicine,
	pMedkit,
	pMask,
	pHelmet,
	pSnack,
	pSprunk,
	pMineral,
	pAyam,
	pAyamhidup,
	pKarung,
	pBurger,
	pNasi,
	pGas,
	pDoor1,
	pDoor2,
	pDoor3,
	pDoor4,
	pBandage,
	pAreameka,
	pIdrepair,
	pTimerrepair,
	pSedangrepair,
	pOranggeledah,
	pMelacak,
	pLacak,
	pIdlacak,
	pNolacak,
	pKoma,
	pProseskain,
	pDapatkain,
	pMulaikain,
	pDutypenjahit,
	pGudanggun1,
    pGudangamo1,
    pGudanggun2,
    pGudangamo2,
    pGudanggun3,
    pGudangamo3,
    pGudanggun4,
    pGudangamo4,
    pGudangmoney,
    pGudangrmoney,
    pGudangsnack,
    pGudangminum,
    pGudangmedicin,
    pGudangbandage,
    pGudangmedkit,
    pGudangcompo,
    pGudangmate,
	pCarry,
	Float:pCox,
	Float:pCoy,
	Float:pCoz,
	Float:pCoa,
	pCoint,
	pCarbobol,
	pTimerbobol,
	pProsesbobol,
	pTali,
	pDutybus,
	pBus1,
	pDutysweep,
	pDutyfork,
	pDutymow,
	Robwarung,
	pGPS,
	pGpsActive,
	pTargetVehicle,
	pMaterial,
	pComponent,
	pBorax,
	pGetBorax,
	pPaketBorax,
	pProsesBorax,
	pFood,
	pSeed,
	pPotato,
	pWheat,
	pOrange,
	pPrice1,
	pPrice2,
	pPrice3,
	pPrice4,
	pMarijuana,
	pPlant,
	pPlantTime,
	pFishTool,
	pWorm,
	pFish,
	pInFish,
	pIDCard,
	pIDCardTime,
	pDriveLic,
	pDriveLicTime,
	pDriveLicApp,
	pBoatLic,
	pBoatLicTime,
	pWeaponLic,
	pWeaponLicTime,
	pFlyLic,
	pFlyLicTime,
	pGuns[13],
    pAmmo[13],
	pWeapon,
	//mypv
	pBreaking,
	pTargetPv,
	pVehKey,
	//wep
	pChainsaw,
	pFistCount,
	//race
	pRaceWith,
	pRaceFinish,
	pRaceIndex,
	//Not Save
	Cache:Cache_ID,
	bool: IsLoggedIn,
	LoginAttempts,
	LoginTimer,
	pSpawned,
	pSpawnList,
	pAdminDuty,
	pFreezeTimer,
	pFreeze,
	pMaskID,
	pMaskOn,
	STREAMER_TAG_3D_TEXT_LABEL:pNameTag,
	pSPY,
	Float:pValue,
	pToggleAtm,
	pTogPM,
	pTogLog,
	pTogAds,
	pTogWT,
	STREAMER_TAG_3D_TEXT_LABEL:pAdoTag,
	STREAMER_TAG_3D_TEXT_LABEL:pBTag,
	bool:pBActive,
	bool:pAdoActive,
	pFlare,
	bool:pFlareActive,
	pTrackCar,
	pBuyPvModel,
	pTrackHouse,
	pTrackBisnis,
	pTrackDealer,
	pTrackVending,
	pFacInvite,
	pFacOffer,
	pFamInvite,
	pFamOffer,
	pFarmInvite,
	pFarm,
	pFarmOffer,
	pFarmRank,
	pFindEms,
	pCuffed,
	toySelected,
	bool:PurchasedToy,
	pEditingItem,
	EditStatus,
	VehicleID,
	pProductModify,
	pEditingVendingItem,
	pVendingProductModify,
	pCurrSeconds,
	pCurrMinutes,
	pCurrHours,
	pSpec,
	playerSpectated,
	pFriskOffer,
	pDragged,
	pDraggedBy,
	pDragTimer,
	pHBEMode,
	pHelmetOn,
	pSeatBelt,
	pReportTime,
	pAskTime,
	//default
	PlayerBar:spfuelbar,
	PlayerBar:spdamagebar,
	PlayerBar:sphungrybar,
	PlayerBar:spenergybar,
	PlayerBar:activitybar,
	PlayerBar:DRINKPROGRESS,
	PlayerBar:FOODPROGRESS,
	PlayerBar:FUELBAR,
	PlayerBar:HEALTHBAR,
	pProducting,
	pProductingStatus,
	pCooking,
	pCookingStatus,
	pArmsDealer,
	pArmsDealerStatus,
	pMechanic,
	pMechanicStatus,
	pActivity,
	pActivityStatus,
	pActivityTime,
	pCheckingBis,
	pRobSystem,
	pCarSteal,
	//Jobs
	pSideJob,
	pSideJobTime,
	pSweeperTime,
	pForklifterTime,
	pBusTime,
	pMowerTime,
	pKoranTime,
	pAntarayamTime,
	pGetJob,
	pGetJob2,
	pTaxiDuty,
	pTaxiTime,
	pFare,
	pFareTimer,
	pTotalFare,
	Float:pFareOldX,
	Float:pFareOldY,
	Float:pFareOldZ,
	Float:pFareNewX,
	Float:pFareNewY,
	Float:pFareNewZ,
	pMechDuty,
	pMechVeh,
	pMechColor1,
	pMechColor2,
	EditingVtoys,
	//ATM
	EditingATMID,
	//lumber job
	EditingTreeID,
	CuttingTreeID,
	bool:CarryingLumber,
	//Miner job
	EditingOreID,
	MiningOreID,
	CarryingLog,
	LoadingPoint,
	//Vending
	EditingVending,
	//production
	CarryProduct,
	//trucker
	pMission,
	pHauling,
	pVendingRestock,
	bool: CarryingBox,
	//Farmer
	pHarvest,
	pHarvestID,
	pOffer,
	//Bank
	pTransfer,
	pTransferRek,
	pTransferName[128],
	//Gas Station
	pFill,
	pFillStatus,
	pFillTime,
	pFillPrice,
	//Gate
	gEditID,
	gEdit,
	// WBR
	pHead,
 	pPerut,
 	pLHand,
 	pRHand,
 	pLFoot,
 	pRFoot,
 	// Inspect Offer
 	pInsOffer,
 	// Obat System
 	pObat,
 	// Suspect
 	pSuspectTimer,
 	pSuspect,
 	// Phone On Off
 	pPhoneStatus,
 	// Kurir
 	pKurirEnd,
 	// Shareloc Offer
 	pLocOffer,
 	//binory
 	pBinory,
 	// Twitter
 	pTwitter,
	pTname[MAX_PLAYER_NAME],
	pTweet,
	pTogTweet,
	//pemotong ayam
	pPemotongStatus,
	timerambilayamhidup,
    timerpotongayam,
    timerpackagingayam,
    timerjualayam,
    AyamHidup,
	AyamPotong,
	AyamFillet,
	sedangambilayam,
    sedangpotongayam,
    sedangfilletayam,
    sedangjualayam,
 	// Kuota
 	pKuota,
 	// DUTY SYSTEM
 	pDutyHour,
 	// CHECKPOINT
 	pCP,
 	// ROBBERY
 	pRobTime,
 	pRobOffer,
 	pRobLeader,
 	pRobMember,
 	pMemberRob,
	pTrailer,
	// Smuggler
	bool:pTakePacket,
	pTrackPacket,
	// Garkot
	pPark,
	pLoc,
	pGarage,
	// WS
	pMenuType,
	pInWs,
	pTransferWS,
	//Baggage
	pBaggage,
	pDelayBaggage,
	pTrailerBaggage,
	//Anticheat
	pACWarns,
	pACTime,
	pJetpack,
	pArmorTime,
	pLastUpdate,
	//Checkpoint
	pCheckPoint,
	pBus,
	pSweeper,
	pMower,
	//SpeedCam
	pSpeedTime,
	pShowFooter,
	pFooterTimer,
	//Forklifter New System
	pForklifter,
	pForklifterLoad,
	pForklifterLoadStatus,
	pForklifterUnLoad,
	pForklifterUnLoadStatus,
	//Starterpack
	pStarterpack,
	pKompensasi,
	//Anim
	pLoopAnim,
	//Rob Car
	pLastChop,
	pLastChopTime,
	pIsStealing,
	//Sparepart
	pSparepart,
	//
	pUangKorup,
	//Senter
	pFlashlight,
	pUsedFlashlight,
	//Moderator
	pServerModerator,
	pEventModerator,
	pFactionModerator,
	pFamilyModerator,
	//
	pPaintball,
	pPaintball2,
	//
	pDelayIklan,
	//TRADE
	Float:put,
	moneyput,
	buy,
	pTrdCD,
	showing,
	pItemid,
	Float:pWeight,
	SPAWNMENU
};
new pData[MAX_PLAYERS][E_PLAYERS];
new g_MysqlRaceCheck[MAX_PLAYERS];

//-----[ Smuggler ]-----	

new STREAMER_TAG_3D_TEXT_LABEL:packetLabel,
	packetObj,
	Float:paX, 
	Float:paY, 
	Float:paZ;


//-----[ Forklifter Object ]-----	
new 
	VehicleObject[MAX_VEHICLES] = {-1, ...};

//-----[ Lumber Object Vehicle ]-----	
#define MAX_BOX 50
#define BOX_LIFETIME 100
#define BOX_LIMIT 5

enum    E_BOX
{
	boxDroppedBy[MAX_PLAYER_NAME],
	boxSeconds,
	boxObjID,
	boxTimer,
	boxType,
	STREAMER_TAG_3D_TEXT_LABEL: boxLabel
}
new BoxData[MAX_BOX][E_BOX],
	Iterator:Boxs<MAX_BOX>;

new
	BoxStorage[MAX_VEHICLES][BOX_LIMIT];

//-----[ Lumber Object Vehicle ]-----	
#define MAX_LUMBERS 50
#define LUMBER_LIFETIME 100
#define LUMBER_LIMIT 10

enum    E_LUMBER
{
	lumberDroppedBy[MAX_PLAYER_NAME],
	lumberSeconds,
	lumberObjID,
	lumberTimer,
	STREAMER_TAG_3D_TEXT_LABEL: lumberLabel
}
new LumberData[MAX_LUMBERS][E_LUMBER],
	Iterator:Lumbers<MAX_LUMBERS>;

new
	LumberObjects[MAX_VEHICLES][LUMBER_LIMIT],
	Kandang[MAX_VEHICLES];

	
new
	Float: LumberAttachOffsets[LUMBER_LIMIT][4] = {
	    {-0.223, -1.089, -0.230, -90.399},
		{-0.056, -1.091, -0.230, 90.399},
		{0.116, -1.092, -0.230, -90.399},
		{0.293, -1.088, -0.230, 90.399},
		{-0.123, -1.089, -0.099, -90.399},
		{0.043, -1.090, -0.099, 90.399},
		{0.216, -1.092, -0.099, -90.399},
		{-0.033, -1.090, 0.029, -90.399},
		{0.153, -1.089, 0.029, 90.399},
		{0.066, -1.091, 0.150, -90.399}
	};

//-----[ Ores Miner ]-----	
#define LOG_LIFETIME 100
#define LOG_LIMIT 10
#define MAX_LOG 100

enum    E_LOG
{
	bool:logExist,
	logType,
	logDroppedBy[MAX_PLAYER_NAME],
	logSeconds,
	logObjID,
	logTimer,
	STREAMER_TAG_3D_TEXT_LABEL:logLabel
}
new LogData[MAX_LOG][E_LOG];

new
	LogStorage[MAX_VEHICLES][2];

//-----[ Trucker ]-----	
new VehProduct[MAX_VEHICLES];
new VehGasOil[MAX_VEHICLES];

//-----[ Baggage ]-----	
new bool:DialogBaggage[10];
new bool:MyBaggage[MAX_PLAYERS][10];

//-----[ Type Checkpoint ]-----	
enum
{
	CHECKPOINT_NONE = 0,
	CHECKPOINT_FORKLIFTER,
	CHECKPOINT_DRIVELIC,
	CHECKPOINT_SWEEPER,
	CHECKPOINT_BAGGAGE,
	CHECKPOINT_MOWER,
	CHECKPOINT_MISC,
	CHECKPOINT_BUS
}

//-----[ Storage Limit ]-----	
enum
{
	LIMIT_SNACK,
	LIMIT_SPRUNK,
	LIMIT_MEDICINE,
	LIMIT_MEDKIT,
 	LIMIT_BANDAGE,
 	LIMIT_SEED,
	LIMIT_MATERIAL,
	LIMIT_COMPONENT,
	LIMIT_MARIJUANA
};

//-----[ eSelection Define ]-----	
#define 	SPAWN_SKIN_MALE 		1
#define 	SPAWN_SKIN_FEMALE 		2
#define 	SHOP_SKIN_MALE 			3
#define 	SHOP_SKIN_FEMALE 		4
#define 	VIP_SKIN_MALE 			5
#define 	VIP_SKIN_FEMALE 		6
#define 	SAPD_SKIN_MALE 			7
#define 	SAPD_SKIN_FEMALE 		8
#define 	SAPD_SKIN_WAR 			9
#define 	SAGS_SKIN_MALE 			10
#define 	SAGS_SKIN_FEMALE 		11
#define 	SAMD_SKIN_MALE 			12
#define 	SAMD_SKIN_FEMALE 		13
#define 	SANA_SKIN_MALE 			14
#define 	SANA_SKIN_FEMALE 		15
#define 	TOYS_MODEL 				16
#define 	VIPTOYS_MODEL 			17
#define 	SAAG_SKIN_MALE    		18

new SpawnSkinMale[] =
{
	1, 2, 3, 4, 5, 6, 7, 14, 100, 299
};

new SpawnSkinFemale[] =
{
	9, 10, 11, 12, 13, 31, 38, 39, 40, 41
};

new ShopSkinMale[] =
{
	1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33,
	34, 35, 36, 37, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 68, 72, 73,
	78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
	110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133,
	134, 135, 136, 137, 142, 143, 144, 146, 153, 154, 156, 158, 159, 160, 161, 162, 167, 168, 170,
	171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 188, 189, 190, 200, 202, 203,
	204, 206, 208, 209, 210, 212, 213, 217, 220, 221, 222, 223, 228, 229, 230, 234, 235, 236, 239, 240, 241,
	242, 247, 248, 249, 250, 253, 254, 255, 258, 259, 260, 261, 262, 268, 272, 273, 289, 290, 291, 292, 293,
	294, 296, 297, 299
};

new ShopSkinFemale[] =
{
	9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69, 75, 76, 77, 85, 88, 89, 90, 91, 92,
	93, 129, 130, 131, 138, 140, 141, 145, 148, 150, 151, 152, 157, 169, 178, 190, 191, 192, 193, 194, 195, 196,
	197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245,
	246, 251, 256, 257, 263, 298
};

new SAPDSkinWar[] =
{
	121, 285, 286, 287, 117, 118, 165, 166
};

new SAPDSkinMale[] =
{
	280, 281, 282, 283, 284, 288, 300, 301, 302, 303, 304, 305, 310, 311, 165, 166, 265, 266, 267
};

new SAAGSkinMale[] =
{
	50, 268
};

new SAPDSkinFemale[] =
{
	306, 307, 309, 148, 150
};

new SAGSSkinMale[] =
{
	171, 17, 71, 147, 187, 165, 166, 163, 164, 255, 295, 294, 303, 304, 305, 189, 253
};

new SAGSSkinFemale[] =
{
	9, 11, 76, 141, 150, 219, 169, 172, 194, 263
};

new SAMDSkinMale[] =
{
	70, 187, 303, 304, 305, 274, 275, 276, 277, 278, 279, 165, 71, 177
};

new SAMDSkinFemale[] =
{
	308, 76, 141, 148, 150, 169, 172, 194, 219
};

new SANASkinMale[] =
{
	171, 187, 189, 240, 303, 304, 305, 20, 59
};

new SANASkinFemale[] =
{
	172, 194, 211, 216, 219, 233, 11, 9
};

new ToysModel[] =
{
	19006, 19007, 19008, 19009, 19010, 19011, 19012, 19013, 19014, 19015, 19016, 19017, 19018, 19019, 19020, 19021, 19022,
	19023, 19024, 19025, 19026, 19027, 19028, 19029, 19030, 19031, 19032, 19033, 19034, 19035, 19801, 18891, 18892, 18893,
	18894, 18895, 18896, 18897, 18898, 18899, 18900, 18901, 18902, 18903, 18904, 18905, 18906, 18907, 18908, 18909, 18910,
	18911, 18912, 18913, 18914, 18915, 18916, 18917, 18918, 18919, 18920, 19036, 19037, 19038, 19557, 11704, 19472, 18974,
	19163, 19064, 19160, 19352, 19528, 19330, 19331, 18921, 18922, 18923, 18924, 18925, 18926, 18927, 18928, 18929, 18930,
	18931, 18932, 18933, 18934, 18935, 18939, 18940, 18941, 18942, 18943, 18944, 18945, 18946, 18947, 18948, 18949, 18950,
	18951, 18953, 18954, 18960, 18961, 19098, 19096, 18964, 18967, 18968, 18969, 19106, 19113, 19114, 19115, 18970, 18638,
	19553, 19558, 19554, 18971, 18972, 18973, 19101, 19116, 19117, 19118, 19119, 19120, 18952, 18645, 19039, 19040, 19041,
	19042, 19043, 19044, 19045, 19046, 19047, 19053, 19421, 19422, 19423, 19424, 19274, 19518, 19077, 19517, 19317, 19318,
	19319, 19520, 1550, 19592, 19621, 19622, 19623, 19624, 19625, 19626, 19555, 19556, 19469, 19085, 19559, 19904, 19942, 
	19944, 11745, 19773, 18639, 18640, 18641, 18635, 18633, 3028, 11745, 19142
};

new VipToysModel[] =
{
	19006, 19007, 19008, 19009, 19010, 19011, 19012, 19013, 19014, 19015, 19016, 19017, 19018, 19019, 19020, 19021, 19022,
	19023, 19024, 19025, 19026, 19027, 19028, 19029, 19030, 19031, 19032, 19033, 19034, 19035, 19801, 18891, 18892, 18893,
	18894, 18895, 18896, 18897, 18898, 18899, 18900, 18901, 18902, 18903, 18904, 18905, 18906, 18907, 18908, 18909, 18910,
	18911, 18912, 18913, 18914, 18915, 18916, 18917, 18918, 18919, 18920, 19036, 19037, 19038, 19557, 11704, 19472, 18974,
	19163, 19064, 19160, 19352, 19528, 19330, 19331, 18921, 18922, 18923, 18924, 18925, 18926, 18927, 18928, 18929, 18930,
	18931, 18932, 18933, 18934, 18935, 18939, 18940, 18941, 18942, 18943, 18944, 18945, 18946, 18947, 18948, 18949, 18950,
	18951, 18953, 18954, 18960, 18961, 19098, 19096, 18964, 18967, 18968, 18969, 19106, 19113, 19114, 19115, 18970, 18638,
	19553, 19558, 19554, 18971, 18972, 18973, 19101, 19116, 19117, 19118, 19119, 19120, 18952, 18645, 19039, 19040, 19041,
	19042, 19043, 19044, 19045, 19046, 19047, 19053, 19421, 19422, 19423, 19424, 19274, 19518, 19077, 19517, 19317, 19318,
	19319, 19520, 1550, 19592, 19621, 19622, 19623, 19624, 19625, 19626, 19555, 19556, 19469, 19085, 19559, 19904, 19942, 
	19944, 11745, 19773, 18639, 18640, 18641, 18635, 18633, 3028, 11745, 19142
};

new VipSkinMale[] =
{
	1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33,
	34, 35, 36, 37, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 68, 72, 73,
	78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
	110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133,
	134, 135, 136, 137, 142, 143, 144, 146, 147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 167, 168, 170,
	171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 200, 202, 203,
	204, 206, 208, 209, 210, 212, 213, 217, 220, 221, 222, 223, 228, 229, 230, 234, 235, 236, 239, 240, 241,
	242, 247, 248, 249, 250, 253, 254, 255, 258, 259, 260, 261, 262, 268, 272, 273, 289, 290, 291, 292, 293,
	294, 295, 296, 297, 299
};

new VipSkinFemale[] =
{
	9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69, 75, 76, 77, 85, 88, 89, 90, 91, 92,
	93, 129, 130, 131, 138, 140, 141, 145, 148, 150, 151, 152, 157, 169, 178, 190, 191, 192, 193, 194, 195, 196,
	197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245,
	246, 251, 256, 257, 263, 298
};



//-----[ Modular ]-----	
main() 
{
	SetTimer("onlineTimer", 1000, true);
	SetTimer("TDUpdates", 8000, true);
}

#include "COLOR.pwn"
#include "INVENTORY2.pwn"
#include "UCP.pwn"
#include "TEXTDRAW.pwn"
//#include "TEXTDRAWFIVEM.pwn"
#include "ANIMS.pwn"
#include "GARKOT.pwn"
#include "RENTAL.pwn"
#include "PRIVATE_VEHICLE.pwn"
//#include "PRIVATE_VEHICLE old.pwn"
//#include "GARAGE.pwn"
#include "BORAX.pwn"
#include "VSTORAGE.pwn"
#include "VTOYS.pwn"
#include "REPORT.pwn"
#include "ASK.pwn"
#include "QUIZ.pwn"
#include "WEAPON_ATTH.pwn"
#include "TOYS.pwn"
#include "HELMET.pwn"
#include "SERVER.pwn"
#include "DOOR.pwn"
#include "FAMILY.pwn"
#include "HOUSE.pwn"
#include "BISNIS.pwn"
#include "AUCTION.pwn"
#include "FARM.pwn"
#include "GRAFITY.pwn"
#include "GAS_STATION.pwn"
#include "RENT.pwn"
#include "DYNAMIC_ICON.pwn"
#include "DYNAMIC_LOCKER.pwn"
#include "NATIVE.pwn"
#include "MODSHOP.pwn"
#include "VOUCHER.pwn"
#include "SALARY.pwn"
#include "ATM.pwn"
#include "DEALER.pwn"
#include "ARMS_DEALER.pwn"
#include "GATE.pwn"
#include "VOTE.pwn"
#include "JAIL.pwn"
#include "ROBBERY.pwn"
#include "ROB.pwn"
//#include "WORKSHOP.pwn"
#include "DMV.pwn"
#include "ANTICHEAT.pwn"
#include "SPEEDCAM.pwn"
#include "ACTOR.pwn"
#include "VENDING.pwn"
#include "CONTACT.pwn"
#include "CALLPHONE.pwn"
#include "TOLL.pwn"
#include "JOB\JOB_PRODUCTION.pwn"
#include "JOB\JOB_PEMOTONGAYAM.pwn"
#include "JOB\JOB_FORKLIFT.pwn"
#include "JOB\JOB_SMUGGLER.pwn"
#include "JOB\JOB_SWEEPER.pwn"
#include "JOB\JOB_TRUCKER.pwn"
#include "JOB\JOB_BAGGAGE.pwn"
#include "JOB\JOB_LUMBER.pwn"
#include "JOB\JOB_FARMER.pwn"
#include "JOB\JOB_MINER.pwn"
//#include "JOB\JOB_REFLENISH.pwn"
#include "JOB\JOB_MOWER.pwn"
#include "JOB\JOB_TAXI.pwn"
#include "JOB\JOB_MECH.pwn"
#include "JOB\JOB_FISH.pwn"
//#include "JOB\JOB_BUS.pwn"

#include "CMD\FACTION.pwn"
#include "CMD\PLAYER.pwn"
#include "CMD\ADMIN.pwn"

#include "SAPD_TASER.pwn"
#include "SAPD_SPIKE.pwn"
#include "MDC.pwn"
#include "TRADE.pwn"
#include "PEDAGANGPV.pwn"
#include "SAPD.pwn"
#include "SAMD.pwn"
#include "SANA.pwn"
#include "DIALOG.pwn"
#include "MAPPING.pwn"

#include "CMD\ALIAS\ALIAS_PRIVATE_VEHICLE.pwn"
#include "CMD\ALIAS\ALIAS_PLAYER.pwn"
#include "CMD\ALIAS\ALIAS_BISNIS.pwn"
#include "CMD\ALIAS\ALIAS_ADMIN.pwn"
#include "CMD\ALIAS\ALIAS_HOUSE.pwn"

#include "EVENT.pwn"

#include "FUNCTION.pwn"

#include "TASK.pwn"

#include "CMD\DISCORD.pwn"

//------[ IPRP::]------
ShowDialogToPlayer(playerid, dialogid)
{
	    switch(dialogid)
	    {
	        case DIALOG_BANKWITHDRAW:
			{
                new mstr[512];
			    format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.\n\nType in the amount you want to withdraw below:", FormatMoney(pData[playerid][pBankMoney]));
			    ShowPlayerDialog(playerid, DIALOG_BANKWITHDRAW, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Withdraw", "Cancel");
			}
	        case DIALOG_BANKDEPOSIT:
			{
			    new mstr[512];
			    format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in bank account.\n\nType in the amount you want to deposit below:", FormatMoney(pData[playerid][pBankMoney]));
			    ShowPlayerDialog(playerid, DIALOG_BANKDEPOSIT, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Deposit", "Cancel");
			}
			case DIALOG_BANKREKENING:
			{
				ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Input Number Of The Money:", "Transfer", "Cancel");
			}
		}
	    return 1;
}

public DCC_OnMessageCreate(DCC_Message:message)
{
	new realMsg[100];
    DCC_GetMessageContent(message, realMsg, 100);
    new bool:IsBot;
    new DCC_Channel:g_Discord_Chat;
    g_Discord_Chat = DCC_FindChannelById("1059111144134017084");
    new DCC_Channel:channel;
 	DCC_GetMessageChannel(message, channel);
    new DCC_User:author;
	DCC_GetMessageAuthor(message, author);
    DCC_IsUserBot(author, IsBot);
    if(channel == g_Discord_Chat && !IsBot) //!IsBot will block BOT's message in game
    {
        new user_name[32 + 1], str[152];
       	DCC_GetUserName(author, user_name, 32);
        format(str,sizeof(str), "{8a6cd1}[DISCORD] {aa1bb5}%s: {ffffff}%s", user_name, realMsg);
        SendClientMessageToAll(-1, str);
    }

    return 1;
}

//pool
public OnShowedTD(playerid)
{
	TextDrawHideForPlayer(playerid,Player[playerid][T1]);
	TextDrawHideForPlayer(playerid,Player[playerid][T2]);
	Player[playerid][TDTimer] = 0;
}

stock SetObjectSpeed(sysobj, Float:speedy)
{
	MoveObject(Ball[sysobj][ObjID],Ball[sysobj][bx],Ball[sysobj][by],Ball[sysobj][bz],speedy);
}

stock CheckAllBalls()
{
	for(new i = 0; i < 16; i++)
	{
	    if(Ball[i][speed] != 0)
	        return 0;
	    else if(i == 15)
	    {
	        if(Ball[i][speed] == 0)
	            return 1;
	    }
	}
	return 0;
}

stock Float:GetVectorAngle(obj, obj2)
{
	new Float:vector[3];
	new Float:pos[6];
	GetObjectPos(obj,pos[0],pos[1],pos[2]);
	GetObjectPos(obj2,pos[3],pos[4],pos[5]);
	vector[0] = pos[3] - pos[0];
	vector[1] = pos[4] - pos[1];
	vector[2] = atan(-(vector[0] / vector[1]));
	if(vector[1] < 0)
	    vector[2] = vector[2] >= 180 ? vector[2] - 180 : vector[2] + 180;

	return vector[2];
}

stock Float:GetVectorAngle_XY(Float:fx, Float:fy, Float:tx, Float:ty)
{
	new Float:vector[3];
	vector[0] = tx - fx;
	vector[1] = ty - fy;
	vector[2] = atan(-(vector[0] / vector[1]));
	if(vector[1] < 0)
	    vector[2] = vector[2] >= 180 ? vector[2] - 180 : vector[2] + 180;

	return vector[2];
}

stock Float:GetVectorDistance_PL(playerid, obj)
{
    new Float:pos[6];
	GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
	GetObjectPos(obj,pos[3],pos[4],pos[5]);
	return floatsqroot(floatpower(pos[3] - pos[0],2) + floatpower(pos[4] - pos[1],2) + floatpower(pos[5] - pos[2],2));
}

stock Float:GetVectorDistance_OB(obj, obj2)
{
	new Float:pos[6];
	GetObjectPos(obj,pos[0],pos[1],pos[2]);
	GetObjectPos(obj2,pos[3],pos[4],pos[5]);
	return floatsqroot(floatpower(pos[3] - pos[0],2) + floatpower(pos[4] - pos[1],2) + floatpower(pos[5] - pos[2],2));
}

stock Float:GetDistance(Float:fx, Float:fy, Float:tx, Float:ty)
{
	return floatsqroot(floatpower(tx - fx,2) + floatpower(ty - fy,2));
}

stock Float:GetDistancePointToLong(Float:px,Float:py, Float:px1,Float:py1, Float:px2,Float:py2)
{
    new Float:vec[3];
	vec[0] = GetDistance(px1,py1,px2,py2);
	if((vec[1] = GetDistance(px,py,px1,py1)) < vec[0] && (vec[2] = GetDistance(px,py,px2,py2)) < vec[0])
	{
	    new Float:opt[2];
		opt[0] = (vec[0] + vec[1] + vec[2]) / 2;
	    opt[1] = floatsqroot(opt[0] * (opt[0] - vec[0]) * (opt[0] - vec[1]) * (opt[0] - vec[2]));
		opt[1] = ((opt[1] * 2) / vec[0]);
		return opt[1];
	}
	return 0.0;
}


stock PointInLong(Float:size, Float:px,Float:py, Float:px1,Float:py1, Float:px2,Float:py2)
{
	new Float:vec[3];
	vec[0] = GetDistance(px1,py1,px2,py2);
	if((vec[1] = GetDistance(px,py,px1,py1)) < vec[0] && (vec[2] = GetDistance(px,py,px2,py2)) < vec[0])
	{
	    new Float:opt[2];
		opt[0] = (vec[0] + vec[1] + vec[2]) / 2;
	    opt[1] = floatsqroot(opt[0] * (opt[0] - vec[0]) * (opt[0] - vec[1]) * (opt[0] - vec[2]));
		opt[1] = ((opt[1] * 2) / vec[0]) * 2;
		if(opt[1] < size)
		    return 1;
	}
	return 0;
}

stock CreatePolygon(Float:px1,Float:py1, Float:px2,Float:py2)
{
	for(new i = 0; i < POLYGONS; i++)
	{
	    if(PolyResult[i][Progress] == false)
	    {
			PolyResult[i][Progress] = true;
			PolyResult[i][Vertices] = 2;

			Polygon[i][0][vvx] = px1;
			Polygon[i][0][vvy] = py1;

			Polygon[i][1][vvx] = px2;
			Polygon[i][1][vvy] = py2;
			return i;
	    }
	}
	return 0;
}



stock PointInPolygon(Float:px, Float:py, polygonid)
{
	if(PolyResult[polygonid][Progress] == true)
	{
		for(new i = 0; i < PolyResult[polygonid][Vertices]; i++)
		{
			if(i == PolyResult[polygonid][Vertices] - 1)
			{
			    if(PointInLong(0.06,px,py,Polygon[polygonid][i][vvx],Polygon[polygonid][i][vvy],Polygon[polygonid][0][vvx],Polygon[polygonid][0][vvy]) == 1)
		        	return 1;
			}
			else
			{
				if(PointInLong(0.06,px,py,Polygon[polygonid][i][vvx],Polygon[polygonid][i][vvy],Polygon[polygonid][i + 1][vvx],Polygon[polygonid][i + 1][vvy]) == 1)
		      		return 1;
   			}
		}
	}
	return 0;
}

stock Release()
{
	for(new i = 0; i < 20; i++)
	{
	    TextDrawHideForPlayer(i,Player[i][T1]);
	    TextDrawHideForPlayer(i,Player[i][T2]);
	    TextDrawHideForPlayer(i,Player[i][T3]);
	    TextDrawHideForPlayer(i,Player[i][T4]);
	    TextDrawHideForPlayer(i,Player[i][T5]);
	    TextDrawHideForPlayer(i,Player[i][T6]);
	    TextDrawDestroy(Player[i][T1]);
     	TextDrawDestroy(Player[i][T2]);
     	TextDrawDestroy(Player[i][T3]);
     	TextDrawDestroy(Player[i][T4]);
     	TextDrawDestroy(Player[i][T5]);
     	TextDrawDestroy(Player[i][T6]);
	}
	if(Game[Running] == true || Game[Waiting] == true)
	{
		KillTimer(Game[Timer]);
		KillTimer(Game[Timer2]);
		for(new i = 0; i < 17; i++)
		{
	    	DestroyObject(Ball[i][ObjID]);
 	    }
	}
}
public OnEndBilliard()
{
	for(new i = 0; i < 17; i++)
	{
	    DestroyObject(Ball[i][ObjID]);
    }

   	Game[Waiting] = false;
 	Game[Running] = false;
 	Game[WhiteInHole] = false;
    Game[BlackInHole] = false;

	Player[Game[Player1]][Sighting] = false;
	TextDrawHideForPlayer(Game[Player1],Player[Game[Player1]][T1]);
	TextDrawHideForPlayer(Game[Player1],Player[Game[Player1]][T2]);
	TextDrawHideForPlayer(Game[Player1],Player[Game[Player1]][T3]);
	TextDrawHideForPlayer(Game[Player1],Player[Game[Player1]][T4]);
	TextDrawHideForPlayer(Game[Player1],Player[Game[Player1]][T5]);
	TextDrawHideForPlayer(Game[Player1],Player[Game[Player1]][T6]);

 	Player[Game[Player2]][Sighting] = false;
 	TextDrawHideForPlayer(Game[Player2],Player[Game[Player2]][T1]);
 	TextDrawHideForPlayer(Game[Player2],Player[Game[Player2]][T2]);
 	TextDrawHideForPlayer(Game[Player2],Player[Game[Player2]][T3]);
 	TextDrawHideForPlayer(Game[Player2],Player[Game[Player2]][T4]);
 	TextDrawHideForPlayer(Game[Player2],Player[Game[Player2]][T5]);
 	TextDrawHideForPlayer(Game[Player2],Player[Game[Player2]][T6]);
}

public OnBallInHole(ballid)
{
	if(ballid != WHITE)
	{
    	DestroyObject(Ball[ballid][ObjID]);
    	Ball[ballid][speed] = 0;
    }
    else
    {
	     Ball[WHITE][speed] = 0.2;
         SetObjectPos(Ball[WHITE][ObjID],2495.8618164063, -1671.1704101563, 13.209293525696);
	     StopObject(Ball[WHITE][ObjID]);
	     Ball[WHITE][bx] = 2495.8618164063;
	     Ball[WHITE][by] = -1671.1704101563;
	     Ball[WHITE][bz] = 13.209293525696;
    }

	Game[LastBall] = ballid;
	for(new i = 0; i < 16; i++)
	{
	    if(ballid == i)
	    {
	        if(ballid <= 6) //CALA
			{
			    if(Player[Game[Player1]][Turn] == true && Player[Game[Player1]][BBall] == NO_BALL)
			    {
			        Player[Game[Player1]][BBall] = CALA;
			        Player[Game[Player2]][BBall] = POL;
       			}
       			else if(Player[Game[Player2]][Turn] == true && Player[Game[Player2]][BBall] == NO_BALL)
       			{
       			    Player[Game[Player1]][BBall] = POL;
			        Player[Game[Player2]][BBall] = CALA;
       			}

				if(Player[Game[Player1]][BBall] == CALA)
				    Player[Game[Player1]][Points]--;

				else if(Player[Game[Player2]][BBall] == CALA)
				    Player[Game[Player2]][Points]--;

   			}

	        else if(6 < ballid <= 13) //POLOWKA
	        {
                if(Player[Game[Player1]][Turn] == true && Player[Game[Player1]][BBall] == NO_BALL)
			    {
			        Player[Game[Player1]][BBall] = POL;
			        Player[Game[Player2]][BBall] = CALA;
       			}
       			else if(Player[Game[Player2]][Turn] == true && Player[Game[Player2]][BBall] == NO_BALL)
       			{
       			    Player[Game[Player1]][BBall] = CALA;
			        Player[Game[Player2]][BBall] = POL;
				}

	            if(Player[Game[Player1]][BBall] == POL)
				    Player[Game[Player1]][Points]--;

				else if(Player[Game[Player2]][BBall] == POL)
				    Player[Game[Player2]][Points]--;
         	}

			else if(ballid == WHITE)
				Game[WhiteInHole] = true;

			else if(ballid == BLACK)
			    Game[BlackInHole] = true;

	        break;
	    }
	}
	if(ballid != WHITE && ballid != BLACK)
	{
		new str[80];
		format(str,sizeof(str),"%s %s %d~n~%s %s %d",GetName(Game[Player1]),Char[Player[Game[Player1]][BBall]],Player[Game[Player1]][Points], GetName(Game[Player2]),Char[Player[Game[Player2]][BBall]],Player[Game[Player2]][Points]);
		TextDrawSetString(Player[Game[Player1]][T3],str);
		TextDrawSetString(Player[Game[Player2]][T3],str);
		TextDrawShowForPlayer(Game[Player1],Player[Game[Player1]][T3]);
		TextDrawShowForPlayer(Game[Player2],Player[Game[Player2]][T3]);
	}
}

public BallProperties()
{
	for(new i = 0; i < 16; i++)
	{
		if(Ball[i][speed] > 0.1)
	   	{
    		Ball[i][speed] = Ball[i][speed] / 1.4;
     		SetObjectSpeed(i,Ball[i][speed]);
    	}
   		else
    	{
    	    Ball[i][speed] = 0;
	        StopObject(Ball[i][ObjID]);

	        if(CheckAllBalls() == 1)
	        {
	            KillTimer(Game[Timer]);
	            KillTimer(Game[Timer2]);

	            if(Game[LastBall] != - 1)
	            {
	                if(Game[LastBall] <= 6) //CALA
					{
					    if(Player[Game[Player1]][BBall] == CALA)
					    {
					        Player[Game[Player1]][Turn] = true;
				   			Player[Game[Player2]][Turn] = false;
					    }
					    else if(Player[Game[Player2]][BBall] == CALA)
					    {
					        Player[Game[Player1]][Turn] = false;
				   			Player[Game[Player2]][Turn] = true;
					    }
					}
				    else if(6 < Game[LastBall] <= 13) //POLOWKA
	                {
	                    if(Player[Game[Player1]][BBall] == POL)
					    {
					        Player[Game[Player1]][Turn] = true;
				   			Player[Game[Player2]][Turn] = false;
					    }
					    else if(Player[Game[Player2]][BBall] == POL)
					    {
					        Player[Game[Player1]][Turn] = false;
				   			Player[Game[Player2]][Turn] = true;
					    }
	                }
	            }
	            else //Jezeli zadna bila nie wpadla
	            {
					if(Player[Game[Player1]][Turn] == true)
					{
				    	Player[Game[Player1]][Turn] = false;
				   		Player[Game[Player2]][Turn] = true;
					}
					else if(Player[Game[Player2]][Turn] == true)
					{
				   		Player[Game[Player1]][Turn] = true;
				   		Player[Game[Player2]][Turn] = false;
					}
	            }

				TextDrawSetString(Player[Game[Player1]][T6],"Kolejka");
				TextDrawSetString(Player[Game[Player2]][T6],"Kolejka");
				TextDrawShowForPlayer(Game[Player1],Player[Game[Player1]][T6]);
				TextDrawShowForPlayer(Game[Player2],Player[Game[Player2]][T6]);

				if(Game[BlackInHole] == false)
				{
				    if(Game[WhiteInHole] == false)
				    {
    					if(Player[Game[Player1]][Turn] == true)
						{
				    		TextDrawSetString(Player[Game[Player1]][T5],GetName(Game[Player1]));
				    		TextDrawSetString(Player[Game[Player2]][T5],GetName(Game[Player1]));
						}
						else if(Player[Game[Player2]][Turn] == true)
						{
				    		TextDrawSetString(Player[Game[Player1]][T5],GetName(Game[Player2]));
				    		TextDrawSetString(Player[Game[Player2]][T5],GetName(Game[Player2]));
						}
					}
					else
					{
					    if(Player[Game[Player1]][Turn] == true)
			    		{
			        		Player[Game[Player1]][Turn] = false;
			        		Player[Game[Player2]][Turn] = true;
			        		TextDrawSetString(Player[Game[Player1]][T5],GetName(Game[Player2]));
				    		TextDrawSetString(Player[Game[Player2]][T5],GetName(Game[Player2]));
			    		}
			   			else if(Player[Game[Player2]][Turn] == true)
			    		{
			        		Player[Game[Player1]][Turn] = true;
			        		Player[Game[Player2]][Turn] = false;
			        		TextDrawSetString(Player[Game[Player1]][T5],GetName(Game[Player1]));
				    		TextDrawSetString(Player[Game[Player2]][T5],GetName(Game[Player1]));
			    		}
			    		Game[WhiteInHole] = false;
			    	
					}
					TextDrawShowForPlayer(Game[Player1],Player[Game[Player1]][T5]);
					TextDrawShowForPlayer(Game[Player2],Player[Game[Player2]][T5]);
				}
				else
				{
 	    	   		Game[Waiting] = true;

 	    	   		Player[Game[Player1]][Sighting] = false;
 	    	   		Player[Game[Player2]][Sighting] = false;
 	    	   		TextDrawHideForPlayer(Game[Player2],Player[Game[Player2]][T1]);
 	    			TextDrawHideForPlayer(Game[Player2],Player[Game[Player2]][T2]);

 	    			TextDrawSetString(Player[Game[Player1]][T4],"Rozgrywka");
 	    			TextDrawSetString(Player[Game[Player2]][T4],"Rozgrywka");
 	    			TextDrawShowForPlayer(Game[Player1],Player[Game[Player1]][T4]);
 	    			TextDrawShowForPlayer(Game[Player2],Player[Game[Player2]][T4]);

 	    			TextDrawSetString(Player[Game[Player1]][T3],"Wpadla czarna bila");
 	    			TextDrawSetString(Player[Game[Player2]][T3],"Wpadla czarna bila");
 	    			TextDrawShowForPlayer(Game[Player1],Player[Game[Player1]][T3]);
 	   				TextDrawShowForPlayer(Game[Player2],Player[Game[Player2]][T3]);

 	   				TextDrawSetString(Player[Game[Player1]][T6],"Wygrywa");
 	   				TextDrawSetString(Player[Game[Player2]][T6],"Wygrywa");
 	   				TextDrawShowForPlayer(Game[Player1],Player[Game[Player1]][T6]);
 	   				TextDrawShowForPlayer(Game[Player2],Player[Game[Player2]][T6]);
				    if(Player[Game[Player1]][Points] == 0 || Player[Game[Player2]][Points] == 0)
				    {
				        if(Player[Game[Player1]][Turn] == true)
				        {
				            TextDrawSetString(Player[Game[Player1]][T5],GetName(Game[Player1]));
			       		    TextDrawSetString(Player[Game[Player2]][T5],GetName(Game[Player1]));
				        }
				        else if(Player[Game[Player2]][Turn] == true)
				        {
				            TextDrawSetString(Player[Game[Player1]][T5],GetName(Game[Player2]));
			       		    TextDrawSetString(Player[Game[Player2]][T5],GetName(Game[Player2]));
				        }
				    }
				    else
				    {
      					if(Player[Game[Player1]][Turn] == true)
			   			{
			       			TextDrawSetString(Player[Game[Player1]][T5],GetName(Game[Player2]));
			       		    TextDrawSetString(Player[Game[Player2]][T5],GetName(Game[Player2]));
			    		}
			    		else if(Player[Game[Player2]][Turn] == true)
			    		{
			       			TextDrawSetString(Player[Game[Player1]][T5],GetName(Game[Player1]));
			       			TextDrawSetString(Player[Game[Player2]][T5],GetName(Game[Player1]));
			   			}
					}

					Player[Game[Player1]][Turn] = false;
			    	Player[Game[Player2]][Turn] = false;
			    	Game[BlackInHole] = false;

			    	TextDrawShowForPlayer(Game[Player1],Player[Game[Player1]][T5]);
 	    			TextDrawShowForPlayer(Game[Player2],Player[Game[Player1]][T5]);

 	    			SetTimer("OnEndBilliard",10000,0);
				}
				Game[LastBall] = -1;
				break;
	        }
		}
	}
}

public OnTimer()
{
	new temp[2];
	for(new i = 0; i < 16; i++)
	{
	    for(new j = 0; j < 16; j++)
	    {
	        if(i != j)
	        {
        		if(GetVectorDistance_OB(Ball[i][ObjID],Ball[j][ObjID]) < 0.09)
				{
			    	if(Ball[i][TouchID] != j && Ball[j][TouchID] != i)
			    	{
        				if(Ball[i][speed] > 0.1)
						{
        		    		new Float:pos[6];
        		    		GetObjectPos(Ball[i][ObjID],pos[0],pos[1],pos[2]);
        		    		GetObjectPos(Ball[j][ObjID],pos[3],pos[4],pos[5]);

        		    		Ball[j][TouchID] = i;
        		   		    Ball[i][TouchID] = j;
        		    		temp[0] = i;
        		    		temp[1] = j;

        		    		Ball[j][ba] = GetVectorAngle(Ball[i][ObjID],Ball[j][ObjID]);

        		    		Ball[j][speed] = Ball[i][speed];
        		    		if(Ball[i][speed] < 3)
        		    		{
        		       			Ball[i][ba] = GetVectorAngle(Ball[i][ObjID],Ball[j][ObjID]) + 180;
        		    			Ball[i][speed] = Ball[i][speed] / 1.15; //1.5
        		    			pos[0] += 5 * floatsin(-Ball[i][ba],degrees); //(Ball[i][speed] / 1.1)
        		    			pos[1] += 5 * floatcos(-Ball[i][ba],degrees); //(Ball[i][speed] / 1.1)
        		    			MoveObject(Ball[i][ObjID],pos[0],pos[1],pos[2],Ball[i][speed]);
        		   			}
        		    		else if(Ball[i][speed] >= 3)
        		    		{
        		        		Ball[i][speed] = Ball[i][speed] / 1.15; //2
        		        		pos[0] += 5 * floatsin(-Ball[i][ba],degrees); //Ball[i][speed] / 2) + random(25)
        		        		pos[1] += 5 * floatcos(-Ball[i][ba],degrees); //Ball[i][speed] / 2) - random(25)
        		        		MoveObject(Ball[i][ObjID],pos[0],pos[1],pos[2],Ball[i][speed]);
        		    		}

							Ball[j][speed] = Ball[j][speed] / 1.1;
							pos[3] += 5 * floatsin(-Ball[j][ba],degrees); //Ball[j][speed] / 1.3
							pos[4] += 5 * floatcos(-Ball[j][ba],degrees); //Ball[j][speed] / 1.3
							MoveObject(Ball[j][ObjID],pos[3],pos[4],pos[5],Ball[j][speed]);

			    			Ball[i][bx] = pos[0];
							Ball[i][by] = pos[1];
							Ball[i][bz] = Ball[WHITE][bz];
							Ball[j][bx] = pos[3];
							Ball[j][by] = pos[4];
							Ball[j][bz] = Ball[WHITE][bz];
						}
        		    }
        		}
        	}
		}
  		new Float:pos[5];
		GetObjectPos(Ball[i][ObjID],pos[0],pos[1],pos[2]);
		for(new h = 0; h < 6; h++)
		{
		    if(PointInLong(0.04,pos[0],pos[1],Hole[h][0],Hole[h][1],Hole[h][2],Hole[h][3]) == 1)
		    {
		        CallRemoteFunction("OnBallInHole","d",i);
		        break;
		    }
		}
		for(new k = 0; k < POLYGONS; k++)
  		{
  		    if(PointInPolygon(pos[0],pos[1],k) == 1)
  		    {
  		        new Float:tmp[4];
  		        tmp[0] = pos[0];
  		        tmp[1] = pos[1];
  		        tmp[2] = pos[0];
  		        tmp[3] = pos[1];
  		        pos[0] += floatsin(-Ball[i][ba] + 180,degrees) / 5;
				pos[1] += floatcos(-Ball[i][ba] + 180,degrees) / 5;

				new Float:angle[2];
				angle[0] = GetVectorAngle_XY(tmp[0],tmp[1],Polygon[k][0][vvx],Polygon[k][0][vvy]);
				if(angle[0] > 0)
				{
				    angle[1] = angle[0] + 180;
				    if(angle[1] > 360)
				        angle[1] = angle[1] - 360;
				}
				else
				{
                    angle[1] = GetVectorAngle_XY(tmp[0],tmp[1],Polygon[k][0][vvx],Polygon[k][0][vvy]);
					angle[0] = angle[1] + 180;
					if(angle[0] > 360)
					    angle[0] = angle[0] - 360;

					if(angle[1] < 0)
					    angle[1] = angle[0] + 180;
				}

				new Float:pstop = Ball[i][ba] + 180;
				if(pstop > 360)
				    pstop = pstop - 360;

				if(angle[0] < angle[1])
				{
				    if(angle[0] < pstop < angle[1])
						angle[0] = angle[0] + 90;

					else if(angle[1] < pstop < 360 || 0 < pstop < angle[0])
					{
						angle[0] = angle[1] + 90;
						if(angle[0] > 360)
				  			angle[0] = angle[0] - 360;
				    }
				}
				else if(angle[0] > angle[1])
				{
				    if(angle[0] > pstop > angle[1])
				        angle[0] = angle[1] + 90;

					else if(angle[1] > pstop > 0)
					{
					    angle[0] = angle[1] - 90;
					    if(angle[0] > 360)
			      			angle[0] = angle[0] - 360;
					}
					else if(360 > pstop > angle[0])
					{
					    angle[0] = angle[0] + 90;
					    if(angle[0] > 360)
			      			angle[0] = angle[0] - 360;
					}
				}

				new Float:sraka[2];
				sraka[0] = tmp[0];
				sraka[1] = tmp[1];

				sraka[0] += floatsin(-angle[0],degrees) / 50;
				sraka[1] += floatcos(-angle[0],degrees) / 50;

				tmp[0] += floatsin(-angle[0],degrees) / 7;
				tmp[1] += floatcos(-angle[0],degrees) / 7;
				SetObjectPos(Ball[i][ObjID],sraka[0],sraka[1],13.199293525696);

				new Float:ang;
				new Float:dist;
				ang = GetVectorAngle_XY(pos[0],pos[1],tmp[0],tmp[1]);
				dist = GetDistance(pos[0],pos[1],tmp[0],tmp[1]);

				pos[0] += (dist * floatsin(-ang,degrees)) * 2;
				pos[1] += (dist * floatcos(-ang,degrees)) * 2;


				new Float:ang2;
				ang2 = GetVectorAngle_XY(pos[0],pos[1],tmp[2],tmp[3]);
				ang2 = ang2 + 180;

				tmp[2] += 5 * floatsin(-ang2,degrees);
				tmp[3] += 5 * floatcos(-ang2,degrees);

				MoveObject(Ball[i][ObjID],tmp[2],tmp[3],13.199293525696,Ball[i][speed]);
				Ball[i][bx] = tmp[2];
				Ball[i][by] = tmp[3];
				if(ang2 > 360)
				    ang2 = ang2 - 360;

				Ball[i][ba] = ang2;
  		        break;
  		    }
  		}
	}
	Ball[temp[0]][TouchID] = -1;
	Ball[temp[1]][TouchID] = -1;
}
public OnGameModeInit()
{
	//
    CreateJoinPemotongPoint();
	//pool
	for(new i = 0; i < 20; i++)
	{
	    Player[i][T1] = TextDrawCreate(481.000000,353.000000," ");
    	TextDrawUseBox(Player[i][T1],1);
    	TextDrawTextSize(Player[i][T1],602.000000,0.000000);
    	TextDrawLetterSize(Player[i][T1],0.359999,1.100000);
    	TextDrawSetShadow(Player[i][T1],1);
    	TextDrawColor(Player[i][T1],227275519);
    	TextDrawBoxColor(Player[i][T1],227275314);

		Player[i][T2] = TextDrawCreate(475.000000,344.000000," ");
		TextDrawColor(Player[i][T2],4294967295);
	    TextDrawSetShadow(Player[i][T2],1);

	    Player[i][T3] = TextDrawCreate(481.000000,313.000000," ");
    	TextDrawUseBox(Player[i][T3],1);
    	TextDrawTextSize(Player[i][T3],635.000000,0.000000);
    	TextDrawLetterSize(Player[i][T3],0.359999,1.100000);
    	TextDrawSetShadow(Player[i][T3],1);
    	TextDrawColor(Player[i][T3],227275519);
    	TextDrawBoxColor(Player[i][T3],227275314);

		Player[i][T4] = TextDrawCreate(475.000000,304.000000," ");
		TextDrawColor(Player[i][T4],4294967295);
	    TextDrawSetShadow(Player[i][T4],1);

	    Player[i][T5] = TextDrawCreate(481.000000,273.000000," ");
    	TextDrawUseBox(Player[i][T5],1);
    	TextDrawTextSize(Player[i][T5],635.000000,0.000000);
    	TextDrawLetterSize(Player[i][T5],0.359999,1.100000);
    	TextDrawSetShadow(Player[i][T5],1);
    	TextDrawColor(Player[i][T5],227275519);
    	TextDrawBoxColor(Player[i][T5],227275314);

		Player[i][T6] = TextDrawCreate(475.000000,264.000000," ");
		TextDrawColor(Player[i][T6],4294967295);
	    TextDrawSetShadow(Player[i][T6],1);
	}
	//
	killred = 0;
	killblue = 0;
	SetTimer("Status", 1000, true);
	Int();
	new MySQLOpt: option_id = mysql_init_options();
	Testaja = 0;
	Robmulai = 0;
	//logo
    for (new i = 0; i < MAX_PLAYERS; i++) {
		if (IsPlayerConnected(i)) {
			GenerateInterface(i, false);
		}
	}
	
	//cctv
	AddCCTV("LS Grovestreet", 2491.7839, -1666.6194, 46.3232, 0.0);
	AddCCTV("LS Downtown", 1102.6440, -837.8973, 122.7000, 180.0);
	AddCCTV("SF Wang Cars", -1952.4282,285.9786,57.7031, 90.0);
	AddCCTV("SF Airport", -1275.8070, 52.9402, 82.9162, 0.0);
	AddCCTV("SF Crossroad", -1899.0861,731.0627,65.2969, 90.0);
	AddCCTV("SF Tower", -1753.6606,884.7520,305.8750, 150.0);
	AddCCTV("LV The Strip 1", 2137.2390, 2143.8286, 30.6719, 270.0);
	AddCCTV("LV The Strip 2", 1971.7627, 1423.9323, 82.1563, 270.0);
    AddCCTV("Mount Chiliad", -2432.5852, -1620.1143, 546.8554, 270.0);
	AddCCTV("Sherman Dam", -702.9260, 1848.8094, 116.0507, 0.0);
	AddCCTV("Desert", 35.1291, 2245.0901, 146.6797, 310.0);
	AddCCTV("Query", 588.1079,889.4715,-14.9023, 270.0);
	AddCCTV("Water", 635.6223,498.1748,20.3451, 90.0);
	//======================================================
    //======================================================

	//Creating Textdraw
	TD = TextDrawCreate(160, 400, "~y~Keys:~n~Arrow-Keys: ~w~Move The Camera~n~~y~Sprint-Key: ~w~Speed Up~n~~y~Crouch-Key: ~w~Exit Camera");
    TextDrawLetterSize(TD, 0.4, 0.9);
    TextDrawSetShadow(TD, 0);
    TextDrawUseBox(TD,1);
	TextDrawBoxColor(TD,0x00000055);
	TextDrawTextSize(TD, 380, 400);

	//Creating Menu's
	new Count, Left = TotalCCTVS;
	for(new menu; menu<MAX_CCTVMENUS; menu++)
	{
	    if(Left > 12)
	    {
	        CCTVMenu[menu] = CreateMenu("Choose Camera:", 1, 200, 100, 220);
	        TotalMenus++;
	        MenuType[menu] = 1;
	        for(new i; i<11; i++)
	        {
	        	AddMenuItem(CCTVMenu[menu], 0, CameraName[Count]);
	        	Count++;
	        	Left--;
			}
			AddMenuItem(CCTVMenu[menu], 0, "Next");
		}
		else if(Left<13 && Left > 0)
		{
		    CCTVMenu[menu] = CreateMenu("Choose Camera:", 1, 200, 100, 220);
		    TotalMenus++;
		    MenuType[menu] = 2;
		    new tmp = Left;
	        for(new i; i<tmp; i++)
	        {
	        	AddMenuItem(CCTVMenu[menu], 0, CameraName[Count]);
	        	Count++;
	        	Left--;
			}
		}
	}

	print("\n\n-----------------------------------------------");
	print(" Remote CCTV Filterscript by =>Sandra<= Loaded!");
	print("-----------------------------------------------\n\n");
	//tentara
//	MapAndreas_Init(MAP_ANDREAS_MODE_FULL);
	//anim
	new
	    lib[32],				// The library name.
	    anim[32],				// The animation name.
		tmplib[32]	= "NULL",	// The current library name to be compared.
		curlib		= -1;		// Current library the code writes to.

	for(new i = 1;i<MAX_ANIMS;i++) // Loop through all animation IDs.
	{
	    GetAnimationName(i, lib, 32, anim, 32);

	    // If the animation library just retrieved does not match the current
	    // library, the following animations are in a new library so advance
	    // the current library variable.
	    if(strcmp(lib, tmplib))
	    {
			curlib++;
			strcat(gLibList, lib);
			strcat(gLibList, "\n");
			tmplib = lib;
			strcat(gLibIndex[curlib], lib);
	    }

	    strcat(gAnimList[curlib], anim);
	    strcat(gAnimList[curlib], "\n");

		gAnimTotal[ curlib ]++; // Increase the total amount of animations in the current library.
	}

	for(new i;i<MAX_PLAYERS;i++)
	{
	    // Default animations to avoid crashes if a user uses
	    // /animparams before /animations.
	    gCurrentLib[i] = "RUNNINGMAN";
	    gCurrentAnim[i] = "DANCE_LOOP";
	    gCurrentIdx[i] = 1811;

		// Default speed so the user can use /animations
		// before needing to edit the speed in /animsettings
		gAnimSettings[i][anm_Speed] = 4.0;
		gAnimSettings[i][anm_Loop] = 1;
	}
	new

	    
		libtotal,
		animtotal,
		largest;

	for(new i;i<MAX_ANIMS;i++)
	{
	    GetAnimationName(i, lib, 32, anim, 32);
	    animtotal++;
	    if(strcmp(lib, tmplib))
	    {
	        printf("Found library: '%s' anims: %d", lib, animtotal);
	        libtotal++;

	        if(animtotal > largest) largest = animtotal;
	        animtotal = 0;

	        tmplib = lib;
	    }
	}
	printf("Total Libraries: %d Largest Libaray: %d", libtotal, largest);
	
	
	//rob




	Actorrob = CreateActor(11, 1285.86, -1368.83, 13.83, 79.23);
	Testdoang = CreateDynamic3DTextLabel("Test", COLOR_WHITE, 1285.86, -1368.83, 13.83, 5.0, -1);

	mysql_set_option(option_id, AUTO_RECONNECT, true);

	g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE, option_id);
	if (g_SQL == MYSQL_INVALID_HANDLE || mysql_errno(g_SQL) != 0)
	{
		print("MySQL connection failed. Server is shutting down.");
		SendRconCommand("exit");
		return 1;
	}
	print("MySQL connection is successful.");

	mysql_tquery(g_SQL, "SELECT * FROM `server`", "LoadServer", "");
	mysql_tquery(g_SQL, "SELECT * FROM `doors`", "LoadDoors", "");
	mysql_tquery(g_SQL, "SELECT * FROM `familys`", "LoadFamilys");
	mysql_tquery(g_SQL, "SELECT * FROM `houses`", "LoadHouses", "");
	mysql_tquery(g_SQL, "SELECT * FROM `bisnis`", "LoadBisnis", "");
	mysql_tquery(g_SQL, "SELECT * FROM `lockers`", "LoadLockers", "");
	mysql_tquery(g_SQL, "SELECT * FROM `gstations`", "LoadGStations", "");
	mysql_tquery(g_SQL, "SELECT * FROM `atms`", "LoadATM", "");
//	mysql_tquery(g_SQL, "SELECT * FROM `inventory`", "LoadIven", "");
	mysql_tquery(g_SQL, "SELECT * FROM `gates`", "LoadGates", "");
	mysql_tquery(g_SQL, "SELECT * FROM `dealership`", "LoadDealership", "");
	mysql_tquery(g_SQL, "SELECT * FROM `vouchers`", "LoadVouchers", "");
	mysql_tquery(g_SQL, "SELECT * FROM `trees`", "LoadTrees", "");
	mysql_tquery(g_SQL, "SELECT * FROM `ores`", "LoadOres", "");
	mysql_tquery(g_SQL, "SELECT * FROM `plants`", "LoadPlants", "");
	mysql_tquery(g_SQL, "SELECT * FROM `workshop`", "LoadWorkshop", "");
	mysql_tquery(g_SQL, "SELECT * FROM `parks`", "LoadPark", "");
	//mysql_tquery(g_SQL, "SELECT * FROM `garage`", "Garage_Load", "");
	mysql_tquery(g_SQL, "SELECT * FROM `speedcam`", "Speed_Load", "");
	mysql_tquery(g_SQL, "SELECT * FROM `actor`", "LoadActor", "");
	mysql_tquery(g_SQL, "SELECT * FROM `vending`", "LoadVending", "");
	mysql_tquery(g_SQL, "SELECT * FROM `trunk`", "LoadVehicleTrunk", "");
	mysql_tquery(g_SQL, "SELECT * FROM `farm`", "LoadFarm", "");
	mysql_tquery(g_SQL, "SELECT * FROM `icon`", "LoadIcon", "");
	mysql_tquery(g_SQL, "SELECT * FROM `rental`", "LoadRental", "");
	mysql_tquery(g_SQL, "SELECT * FROM `callphone`", "LoadCallPhone", "");
	mysql_tquery(g_SQL, "SELECT * FROM `dropped` ORDER BY `ID` ASC", "Dropped_Load", "");
	LoadModsPoint();
	ShowNameTags(false);
	EnableTirePopping(0);
	CreateTextDraw();
	CreateServerPoint();
	CreateJoinLumberPoint();
	CreateJoinTaxiPoint();
	//CreateJoinMechPoint();
	CreateJoinMinerPoint();
	CreateJoinProductionPoint();
	CreateJoinTruckPoint();
	CreateArmsPoint();
	//CreateReflenishJobPoint();
	//CreateLoadMoney();
	CreateJoinFarmerPoint();
	LoadTazerSAPD();
	CreateJoinSmugglerPoint();
	CreateJoinBaggagePoint();
	CreateCarStealingPoint();
	CreateMappingGreenland();
	new gm[32];
	format(gm, sizeof(gm), "%s", TEXT_GAMEMODE);
	SetGameModeText(gm);
	format(gm, sizeof(gm), "weburl %s", TEXT_WEBURL);
	SendRconCommand(gm);
	format(gm, sizeof(gm), "language %s", TEXT_LANGUAGE);
	SendRconCommand(gm);
	//SendRconCommand("hostname Xero Gaming Roleplay");
	SendRconCommand("mapname San Andreas");
	ManualVehicleEngineAndLights();
	EnableStuntBonusForAll(0);
	AllowInteriorWeapons(1);
	DisableInteriorEnterExits();
	LimitPlayerMarkerRadius(15.0);
	WasteDeAMXersTime();
    AntiDeAMX();
	DisableInteriorEnterExits();
	SetNameTagDrawDistance(8.0);
	ShowPlayerMarkers(0);
	WeatherRotator();
	SetTimer("WeatherRotator", 2400000, true);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	SetWorldTime(WorldTime);
	SetWeather(WorldWeather);
	BlockGarages(.text="NO ENTER");
	//Audio_SetPack("default_pack");	
	
	new strings[150];
	
	for(new i = 0; i < sizeof(rentVehicle); i ++)
	{
	    CreateDynamicPickup(1239, 23, rentVehicle[i][0], rentVehicle[i][1], rentVehicle[i][2], -1, -1, -1, 50);
		format(strings, sizeof(strings), "[Bike Rental]\n{FFFFFF}/rentbike");
		CreateDynamic3DTextLabel(strings, COLOR_LBLUE, rentVehicle[i][0], rentVehicle[i][1], rentVehicle[i][2], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // rent bike
	}

	for(new i = 0; i < sizeof(rentBoat); i ++)
	{
	    CreateDynamicPickup(1239, 23, rentBoat[i][0], rentBoat[i][1], rentBoat[i][2], -1, -1, -1, 50);
		format(strings, sizeof(strings), "[Boat Rental]\n{FFFFFF}/rentboat");
		CreateDynamic3DTextLabel(strings, COLOR_LBLUE, rentBoat[i][0], rentBoat[i][1], rentBoat[i][2], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // rent bike
	}

	for(new i = 0; i < sizeof(unrentVehicle); i ++)
	{
	    CreateDynamicPickup(1239, 23, unrentVehicle[i][0], unrentVehicle[i][1], unrentVehicle[i][2], -1, -1, -1, 50);
		format(strings, sizeof(strings), "[Unrent Vehicle]\n{FFFFFF}/unrentpv\n to unrent your vehicle");
		CreateDynamic3DTextLabel(strings, COLOR_LBLUE, unrentVehicle[i][0], unrentVehicle[i][1], unrentVehicle[i][2], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // rent bike
	}

	//-----[ Toll System ]-----	
	for(new i;i < sizeof(BarrierInfo);i ++)
	{
		new
		Float:X = BarrierInfo[i][brPos_X],
		Float:Y = BarrierInfo[i][brPos_Y];

		ShiftCords(0, X, Y, BarrierInfo[i][brPos_A]+90.0, 3.5);
		CreateDynamicObject(966,BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z],0.00000000,0.00000000,BarrierInfo[i][brPos_A]);
		Create3DTextLabel("Type {FF8000}/paytoll {FFFFFF}or press {FF8000}HORN {FFFFFF}to paid the toll.", COLOR_WHITE, BarrierInfo[i][brPos_X], BarrierInfo[i][brPos_Y], BarrierInfo[i][brPos_Z], 13.0, 0, 0);
		if(!BarrierInfo[i][brOpen])
		{
			gBarrier[i] = CreateDynamicObject(968,BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.8,0.00000000,90.00000000,BarrierInfo[i][brPos_A]+180);
			MoveObject(gBarrier[i],BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.7,BARRIER_SPEED,0.0,0.0,BarrierInfo[i][brPos_A]+180);
			MoveObject(gBarrier[i],BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.75,BARRIER_SPEED,0.0,90.0,BarrierInfo[i][brPos_A]+180);
		}
		else gBarrier[i] = CreateDynamicObject(968,BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.8,0.00000000,20.00000000,BarrierInfo[i][brPos_A]+180);
	}

    CreateDynamicPickup(1239, 23, 2878.13, 2329.80, 312.90, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Ticket purchase]\n{FFFFFF}Vip[$1800]/Low[$1200]");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 2878.13, 2329.80, 312.90, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // tiket
	
	CreateDynamicPickup(1239, 23, 361.82, 173.98, 1008.38, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Ticket purchase]\n{FFFFFF}Vip[$1800]/Low[$1200]");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 361.82, 173.98, 1008.38, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ID Card

	CreateDynamicPickup(1239, 23, -2082.9756, 2675.5081, 1500.9647, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[City Hall]\n{FFFFFF}/newidcard - create new ID Card\n/newage - Change Birthday\n/sellhouse - sell your house\n/sellbusiness - sell your bisnis");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, -2082.9756, 2675.5081, 1500.9647, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ID Card

    CreateDynamicPickup(1239, 23,2075.6333, -2032.8124, 13.5469, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[GUDANG]\n{FFFFFF}/gudang untuk mengambil/menyimpan barang");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 2075.6333, -2032.8124, 13.5469, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ID Card

	CreateDynamicPickup(1239, 23, -56.043235, 57.363063, 3.110269, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Kandang ayam]\n{FFFFFF}KEY [ H ] Masukkan ayam dan Klakson Ayam ke mobil, Jumlah: %d", kandang1);
	kandangcp = CreateDynamic3DTextLabel(strings, COLOR_LBLUE, -56.043235, 57.363063, 3.110269, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ayam
	
	CreateDynamicPickup(1239, 23,-2112.106201, -2414.923583, 31.252927, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Antar Ayam]\n{FFFFFF}Klakson Didalem mobil");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE,-2112.106201, -2414.923583, 31.252927, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ayam

    CreateDynamicPickup(1239, 23,-2115.072021, -2410.956787, 31.267492, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Restock Ayam]\n{FFFFFF}Key [ H ] - Untuk merestock ayam di pedagang");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE,-2115.072021, -2410.956787, 31.267492, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ayam
	//pemotong ayam
	format(strings, sizeof(strings), "[AYAM HIDUP]\n{FFFFFF}Gunakan /ambilayam Atau Y Untuk Ambil Ayam Hidup");
    CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -2107.4541,-2400.1042,31.4123, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
    CreateDynamicPickup(2992, 23, -2107.4541,-2400.1042,31.4123, -1, -1, -1, 5.0);

	format(strings, sizeof(strings), "[Pemotongan]\n{FFFFFF}Gunakan /potongayam Atau Y Untuk Memotong Ayam Hidup");
    CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -2110.5706,-2408.4841,31.3079, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
    CreateDynamicPickup(2992, 23, -2110.5706,-2408.4841,31.3079, -1, -1, -1, 5.0);

    format(strings, sizeof(strings), "[Packing Ayam]\n{FFFFFF}Gunakan /packingayam Atau Y Untuk Membungkus Ayam Potong");
    CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -2117.5095,-2414.5049,31.2266, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
    CreateDynamicPickup(2992, 23, -2117.5095,-2414.5049,31.2266, -1, -1, -1, 5.0);

	CreateDynamicPickup(1239, 23, -57.719161, 52.421863, 3.110269, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Kandang ayam]\n{FFFFFF}KEY [ H ] Masukkan ayam dan Klakson Ayam ke mobil, Jumlah: %d", kandang2);
	kandangcp2 = CreateDynamic3DTextLabel(strings, COLOR_LBLUE, -57.719161, 52.421863, 3.110269, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ayam
	
	CreateDynamicPickup(1239, 23, -59.442920, 47.451335, 3.1102, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Kandang ayam]\n{FFFFFF}KEY [ H ] Masukkan ayam dan Klakson ayam ke mobil, Jumlah: %d", kandang3);
	kandangcp3 = CreateDynamic3DTextLabel(strings, COLOR_LBLUE, -59.442920, 47.451335, 3.1102, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ayam
	
	CreateDynamicPickup(1239, 23, -65.415077, 41.589778, 3.11026, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Kandang ayam]\n{FFFFFF}KEY [ H ] Masukkan ayam dan Klakson ayam ke mobil, Jumlah: %d", kandang4);
	kandangcp4 = CreateDynamic3DTextLabel(strings, COLOR_LBLUE, -65.415077, 41.589778, 3.11026, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ayam
	
	CreateDynamicPickup(1239, 23, -67.112464, 36.589614, 3.11026, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Kandang ayam]\n{FFFFFF}KEY [ H ] Masukkan ayam dan Klakson ayam ke mobil, Jumlah: %d", kandang5);
	kandangcp5 = CreateDynamic3DTextLabel(strings, COLOR_LBLUE, -67.112464, 36.589614, 3.11026, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ayam

	CreateDynamicPickup(1239, 23, 1296.0533, -1264.1348, 13.5939, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Veh Insurance]\n{FFFFFF}/buyinsu - buy insurance\n/claimpv - claim insurance\n/sellpv - sell vehicle");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 1296.0533, -1264.1348, 13.5939, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Veh insurance

	CreateDynamicPickup(1239, 23, 1294.1837, -1267.9083, 20.6199, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Sparepart Shop]\n{FFFFFF}/buysparepart\n");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 1294.1837, -1267.9083, 20.6199, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Veh insurance
	
	CreateDynamicPickup(1239, 23, -2578.5625, -1383.2179, 1500.7570, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[License]\n{FFFFFF}/newdrivelic - create new license");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, -2578.5625, -1383.2179, 1500.7570, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Driving Lic
	
	CreateDynamicPickup(1239, 23, -710.553955, 2609.112792, 1006.108398, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Plate]\n{FFFFFF}/buyplate - create new plate");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, -710.553955, 2609.112792, 1006.108398, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Plate Kota LS
	
	CreateDynamicPickup(1239, 23, -710.501281, 2605.660156, 1006.108398, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Ticket]\n{FFFFFF}/payticket - to pay ticket\n[Unimpound]\n{FFFFFF}/unimpound - to unimpounded");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, -710.501281, 2605.660156, 1006.108398, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Ticket Kota Dilimore

    CreateDynamicPickup(1239, 23, 1273.339843, -1667.482543, 13.589, -1);
	CreateDynamic3DTextLabel("LSPD Impound Vehicle Point\n/impound", -1, 1552.9539,-1609.6826,13.3828, 10.0);

	CreateDynamicPickup(1239, 23, -1466.4567, 2600.2031, 19.6310, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Plate]\n{FFFFFF}/buyplate - create new plate");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, -1466.4567, 2600.2031, 19.6310, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Plate Kota Dilimore
	
	CreateDynamicPickup(1239, 23, -1469.6188, 2600.2039, 19.6310, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Ticket]\n{FFFFFF}/payticket - to pay ticket\n[Unimpound]\n[FFFFFF]/unimpound - to unimpounded");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, -1469.6188, 2600.2039, 19.6310, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Ticket Kota Ls
	
	CreateDynamicPickup(1239, 23, 1172.371704, -1361.600952, 13.953125, -1);
	format(strings, sizeof(strings), "[Spray Tags]\n{FFFFFF}/buy");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 1172.371704, -1361.600952, 13.953125, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // tags
	
	CreateDynamicPickup(1239, 23, 59.6879, 1067.4708, -50.9141, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Arrest Point]\n{FFFFFF}/arrest - arrest wanted player");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 59.6879, 1067.4708, -50.9141, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // arrest
	
	CreateDynamicPickup(1239, 23, -721.921508, 2595.538085, 1001.919677, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Prison Point]\n{FFFFFF}/arrest - penjaraain penjahat /release keluarkan dari penjara");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, -721.921508, 2595.538085, 1001.919677, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // arrest
	
	//redmoney
	CreateDynamicPickup(1210, 23, -814.395996, 2753.017333, 46.000000, -1, -1, -1, 50);
	format(strings, sizeof(strings), ""LB_E"[RED MONEY]\n"WHITE_E"use key'"YELLOW_E"[H]");
	CreateDynamic3DTextLabel(strings, ARWIN, -814.395996, 2753.017333, 46.000000, 5.0); // Vehicles Stats Sana

	// SANA GARAGE
	CreateDynamicPickup(1239, 23, 743.5262, -1332.2343, 13.8414, -1);
	format(strings, sizeof(strings), ""LB_E"Sana Vehicles\n"WHITE_E"use '"YELLOW_E"/spawnsana"WHITE_E"' to spawn vehicles");
	CreateDynamic3DTextLabel(strings, ARWIN, 743.5262, -1332.2343, 13.8414, 5.0); // Vehicles Stats Sana
	
 	// PEDAGANG GARAGE
	CreateDynamicPickup(1239, 23, 1185.0110, -885.9691, 43.1506, -1);
	format(strings, sizeof(strings), ""LB_E"Pedagang Vehicles\n"WHITE_E"use '"YELLOW_E"/spawnpg"WHITE_E"' to spawn vehicles\n"WHITE_E"use '"YELLOW_E"/despawnpg"WHITE_E"' to despawn vehicles");
	CreateDynamic3DTextLabel(strings, ARWIN, 1185.0110, -885.9691, 43.1506, 5.0); // Vehicles Stats Pedagang
	
	 // SAPD GARAGE
	CreateDynamicPickup(1239, 23, 1260.391601, -1661.296752, 13.576869, -1);
	format(strings, sizeof(strings), ""LB_E"Sapd Vehicles\n"WHITE_E"use '"YELLOW_E"KEY[H]"WHITE_E"' to spawn vehicles\n"WHITE_E"use '"YELLOW_E"KEY[H]"WHITE_E"' to despawn vehicles");
	CreateDynamic3DTextLabel(strings, ARWIN, 1260.391601, -1661.296752, 13.576869, 5.0); // Vehicles Stats Sapd

	 // SAMD GARAGE
	CreateDynamicPickup(1239, 23, 1131.5339, -1332.3248, 13.5797, -1);
	format(strings, sizeof(strings), ""LB_E"Samd Vehicles\n"WHITE_E"use '"YELLOW_E"/spawnmd"WHITE_E"' to spawn vehicles\n"WHITE_E"use '"YELLOW_E"/despawnmd"WHITE_E"' to despawn vehicles");
	CreateDynamic3DTextLabel(strings, ARWIN, 1131.5339, -1332.3248, 13.5797, 5.0); // Vehicles Stats Samd
	
	// SAPD DESPAWN HELICOPTER
	CreateDynamicPickup(1239, 23, 1569.1587,-1641.0361,28.5788, -1);
	format(strings, sizeof(strings), ""LB_E"Sapd Vehicles\n"WHITE_E"use '"YELLOW_E"/despawnpd"WHITE_E"' to despawn helicopter police");
	CreateDynamic3DTextLabel(strings, ARWIN, 1569.1587,-1641.0361,28.5788, 5.0);
	
	// SAMD DESPAWN HELICOPTER
	CreateDynamicPickup(1239, 23, 1162.8176, -1313.8239, 32.2215, -1);
	format(strings, sizeof(strings), ""LB_E"Samd Vehicles\n"WHITE_E"use '"YELLOW_E"/despawnmd"WHITE_E"' to despawn helicopter medical");
	CreateDynamic3DTextLabel(strings, ARWIN, 1162.8176, -1313.8239, 32.2215, 5.0);
	
	// SANA DESPAWN HELICOPTER
	CreateDynamicPickup(1239, 23, 741.9764,-1371.2441,25.8835, -1);
	format(strings, sizeof(strings), ""LB_E"Samd Vehicles\n"WHITE_E"use '"YELLOW_E"/despawnmd"WHITE_E"' to despawn helicopter agency");
	CreateDynamic3DTextLabel(strings, ARWIN, 741.9764,-1371.2441,25.8835, 5.0);
	
	CreateDynamicPickup(1239, 23, 1142.38, -1330.74, 13.62, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Hospital]\n{FFFFFF}/dropinjured");
	CreateDynamic3DTextLabel(strings, COLOR_PINK, 1142.38, -1330.74, 13.62, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // hospital
	
	//old bank
	/*CreateDynamicPickup(1239, 23, -2667.4021, 802.2328, 1500.9688, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[BANK]\n{FFFFFF}/newrek - create new rekening");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, -2667.4021, 802.2328, 1500.9688, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // bank

	CreateDynamicPickup(1239, 23, -2679.9041, 806.8085, 1500.9688, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[BANK]\n{FFFFFF}/bank - access rekening");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, -2679.9041, 806.8085, 1500.9688, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // bank
	*/
	//new bank
	CreateDynamicPickup(1239, 23, 1471.4177, -987.5884, 28.9282, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[BANK]\n{FFFFFF}/newrek - create new rekening");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 1471.4177, -987.5884, 28.9282, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // bank

	CreateDynamicPickup(1239, 23, 1462.6560,-987.5898,28.9282, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[BANK]\n{FFFFFF}/bank - access rekening");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 1462.6560,-987.5898,28.9282, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // bank
	
	CreateDynamicPickup(1239, 23, -192.3483, 1338.7361, 1500.9823, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[IKLAN]\n{FFFFFF}/ads - public ads");
	CreateDynamic3DTextLabel(strings, COLOR_ORANGE2, -192.3483, 1338.7361, 1500.9823, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // iklan

	CreateDynamicPickup(1241, 23, -1775.2911, -1994.0675, 1500.7853, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[MYRICOUS PRODUCTION]\n{FFFFFF}/mix");
	CreateDynamic3DTextLabel(strings, COLOR_ORANGE2, -1775.2911, -1994.0675, 1500.7853, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // racik obat
	
	CreateDynamicPickup(1240, 23, -1770.00, -1992.56, 1500.78, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[TEST DARAH]\n{FFFFFF}/testdarah");
	CreateDynamic3DTextLabel(strings, COLOR_ORANGE2, -1770.00, -1992.56, 1500.78, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // test darah

	CreateDynamicPickup(1239, 23, -427.3773, -392.3799, 16.5802, -1, -1, -1, 50);
	format(strings, sizeof(strings), "[Exchange Money]\n{FFFFFF}/washmoney");
	CreateDynamic3DTextLabel(strings, COLOR_ORANGE2, -427.3773, -392.3799, 16.5802, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // pencucian uang haram
	
	ZonaGYM = CreateDynamicRectangle(647.0001220703125, -1874.9999084472656, 675.0001220703125, -1859.9999084472656);
	Segitigabermuda = CreateDynamicRectangle( -109, -2003, 18, -1880);
	Zonameka = CreateDynamicRectangle(1820, 768, 1866, 821);
	Areaayam = CreateDynamicRectangle(  -98, 22, 2, 122);

	BajuElCorona = CreateDynamicCP(1944.04, -1981.57, 13.80, 1.0, -1, -1, -1, 5.0);
	CreateDynamicPickup(1210, 23, 1396.206909, -5.045751, 1000.853515, -1, -1, -1, 50);
	CreateDynamicPickup(19606, 23, 1268.606445, -2038.017944, 59.881599, -1, -1, -1, 50);
	Ambiljob = CreateDynamicCP(1141.065307, -2038.543090, 1069.093750, 1.0, -1, -1, -1, 100.0);
	new Pesawat12;
	Pesawat12 = CreateDynamicCP(1902.99, -2395.18, 13.54, 5.0, -1, -1, -1, 5.0);
	
	
	ShowRoomCPRent = CreateDynamicCP(545.7528, -1293.4164, 17.2422, 1.0, -1, -1, -1, 5.0);
	Mejajahit = CreateDynamicCP(2330.944580, -2080.416503, 18.147882, 3.0, -1, -1, -1, 100.0);
	Dutyjahit = CreateDynamicCP(2330.587402, -2072.886230, 18.147907, 3.0, -1, -1, -1, 100.0);
	CreateDynamicPickup(1239, 23, 545.75, -1293.41, 17.24, -1, -1, -1, 50);
	CreateDynamic3DTextLabel("{7fff00}Rental Vehicle\n{ffffff}Stand Here!"YELLOW_E"\n/unrentpv", COLOR_LBLUE, 545.7528, -1293.4164, 17.2422, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1);
	
	SAGSLobbyBtn[0] = CreateButton(-2688.83, 808.989, 1501.67, 180.0000);//bank
	SAGSLobbyBtn[1] = CreateButton(-2691.719238, 807.353333, 1501.422241, 0.000000); //bank
	SAGSLobbyBtn[2] = CreateButton(-2067.57, 2692.6, 1501.75, 90.0000);
	SAGSLobbyBtn[3] = CreateButton(-2067.81, 2692.64, 1501.64, -90.0000);
	SAGSLobbyBtn[4] = CreateButton(-2062.34, 2695.24, 1501.72, -90.0000);
	SAGSLobbyBtn[5] = CreateButton(-2062.09, 2695.21, 1501.7, 90.0000);
	SAGSLobbyBtn[6] = CreateButton(-2062.33, 2706.59, 1501.71, -90.0000);
	SAGSLobbyBtn[7] = CreateButton(-2062.08, 2706.69, 1501.73, 90.0000);
	SAGSLobbyDoor[0] = CreateDynamicObject(1569, -2689.33, 807.425, 1499.95, 0.000000, 0.000000, -179.877, -1, -1, -1, 300.00, 300.00);//Bank
	SAGSLobbyDoor[1] = CreateDynamicObject(1569, -2067.72, 2694.67, 1499.96, 0.000000, 0.000000, -89.6241, -1, -1, -1, 300.00, 300.00);
	SAGSLobbyDoor[2] = CreateDynamicObject(1569, -2062.2, 2693.16, 1499.98, 0.000000, 0.000000, 89.9741, -1, -1, -1, 300.00, 300.00);
	SAGSLobbyDoor[3] = CreateDynamicObject(1569, -2062.22, 2704.74, 1499.96, 0.000000, 0.000000, 90.2693, -1, -1, -1, 300.00, 300.00);

	SAMCLobbyBtn[0] = CreateButton(-1786.67, -1999.45, 1501.55, 90.0000);
	SAMCLobbyBtn[1] = CreateButton(-1786.89, -1999.48, 1501.56, -90.0000);
	SAMCLobbyBtn[2] = CreateButton(-1773.67, -1994.98, 1501.57, 180.0000);
	SAMCLobbyBtn[3] = CreateButton(-1773.71, -1995.25, 1501.56, 0.0000);
	SAMCLobbyBtn[4] = CreateButton(-1758.02, -1999.46, 1501.56, -90.0000);
	SAMCLobbyBtn[5] = CreateButton(-1757.81, -1999.46, 1501.57, 90.0000);
	SAMCLobbyDoor[0] = CreateDynamicObject(1569, -1786.8, -1997.48, 1499.77, 0.000000, 0.000000, -90.4041, -1, -1, -1, 300.00, 300.00);
	SAMCLobbyDoor[1] = CreateDynamicObject(1569, -1771.77, -1995.14, 1499.77, 0.000000, 0.000000, -179.415, -1, -1, -1, 300.00, 300.00);
	SAMCLobbyDoor[2] = CreateDynamicObject(1569, -1757.91, -1997.48, 1499.76, 0.000000, 0.000000, -91.6195, -1, -1, -1, 300.00, 300.00);
	
	//-----[ Sidejob Vehicle ]-----	
	AddSweeperVehicle();
	AddPaperVehicle();
//	AddBusVehicle();
	AddPesawat();
	//AddKurirVehicle();
	AddForVehicle();
	AddMowerVehicle();

	//-----[ Job Vehicle ]-----	
	AddBaggageVehicle();

	//-----[ DMV ]-----	
	AddDmvVehicle();
	
	//model selection
	vtoylist = LoadModelSelectionMenu("vtoylist.txt");
	//----[]----//
	/*//Anto
	SAPDVehicles[28] = AddStaticVehicleEx(596, 1602.5725, -1703.6426, 5.6302, 93.0517, 0, 1, VEHICLE_RESPAWN, 1); // (1-LINCOLN-1)
	SAPDVehicles[29] = AddStaticVehicleEx(596, 1602.6649, -1700.1345, 5.6098, 88.3226, 0, 1, VEHICLE_RESPAWN, 1); // (1-LINCOLN-2)
	SAPDVehicles[30] = AddStaticVehicleEx(596, 1602.5731, -1696.3154, 5.6185, 89.5375, 0, 1, VEHICLE_RESPAWN, 1); // (1-LINCOLN-3)
	SAPDVehicles[31] = AddStaticVehicleEx(596, 1602.4727, -1692.1736, 5.6305, 90.5782, 0, 1, VEHICLE_RESPAWN, 1); // (1-ADAM-1)
	SAPDVehicles[32] = AddStaticVehicleEx(596, 1602.6803, -1688.0616, 5.6028, 88.6160, 0, 1, VEHICLE_RESPAWN, 1); // (1-ADAM-2)
	SAPDVehicles[33] = AddStaticVehicleEx(596, 1602.3104, -1683.8103, 5.6366, 90.5165, 0, 1, VEHICLE_RESPAWN, 1); // (1-ADAM-3)
	SAPDVehicles[34] = AddStaticVehicleEx(598, 1595.3843, -1711.7159, 5.6531, 357.9430, 0, 1, VEHICLE_RESPAWN, 1); // (1-JOHN-1)
	SAPDVehicles[35] = AddStaticVehicleEx(598, 1591.6226, -1711.9098, 5.6791, 359.8374, 0, 1, VEHICLE_RESPAWN, 1); // (1-JOHN-2)
	SAPDVehicles[36] = AddStaticVehicleEx(598, 1587.3667, -1712.0635, 5.6635, 357.6382, 0, 1, VEHICLE_RESPAWN, 1); // (1-JOHN-3)
	SAPDVehicles[37] = AddStaticVehicleEx(598, 1583.3821, -1711.9270, 5.6450, 358.9687, 0, 1, VEHICLE_RESPAWN, 1); // (1-JOHN-4)
	SAPDVehicles[38] = AddStaticVehicleEx(597, 1578.5861, -1711.7607, 5.6610, 359.4702, 125, 1, VEHICLE_RESPAWN, 1); // (1-METRO-1)
	SAPDVehicles[39] = AddStaticVehicleEx(597, 1574.5916, -1711.4386, 5.6672, 0.9253, 125, 1, VEHICLE_RESPAWN, 1); // (1-METRO-2)
	SAPDVehicles[40] = AddStaticVehicleEx(597, 1570.4297, -1711.7886, 5.6851, 359.1385, 125, 1, VEHICLE_RESPAWN, 1); // (1-METRO-3)
	SAPDVehicles[41] = AddStaticVehicleEx(560, 1566.8059, -1711.5085, 5.5967, 0.3331, 0, 0, VEHICLE_RESPAWN, 1); // (1-STAFF-1)
	SAPDVehicles[42] = AddStaticVehicleEx(560, 1562.5171, -1711.5936, 5.5957, 0.7919, 0, 0, VEHICLE_RESPAWN, 1); // (1-STAFF-2)
	SAPDVehicles[43] = AddStaticVehicleEx(560, 1558.8313, -1711.4489, 5.5799, 359.7097, 0, 0, VEHICLE_RESPAWN, 1); // (1-STAFF-3)
	SAPDVehicles[44] = AddStaticVehicleEx(599, 1584.9136, -1667.7096, 6.1215, 269.2378, 0, 1, VEHICLE_RESPAWN, 1); // (1-ALPHA-1)
	SAPDVehicles[45] = AddStaticVehicleEx(599, 1584.7681, -1671.7507, 6.1155, 270.4269, 0, 1, VEHICLE_RESPAWN, 1); // (1-ALPHA-2)
	SAPDVehicles[46] = AddStaticVehicleEx(523, 1583.3853, -1674.4485, 5.4557, 271.5863, 0, 0, VEHICLE_RESPAWN, 1); // (1-MARRY-1)
	SAPDVehicles[47] = AddStaticVehicleEx(523, 1583.3677, -1675.9417, 5.4455, 266.5611, 0, 0, VEHICLE_RESPAWN, 1); // (1-MARRY-2)
	SAPDVehicles[48] = AddStaticVehicleEx(523, 1583.4041, -1676.8492, 5.4546, 262.9349, 0, 0, VEHICLE_RESPAWN, 1); // (1-MARRY-3)
	SAPDVehicles[49] = AddStaticVehicleEx(468, 1583.4658, -1678.7776, 5.5580, 275.8166, 0, 0, VEHICLE_RESPAWN, 1); // (1-UNION-1)
	SAPDVehicles[50] = AddStaticVehicleEx(468, 1583.3402, -1680.2417, 5.5736, 267.8846, 0, 0, VEHICLE_RESPAWN, 1); // (1-UNION-2)
	SAPDVehicles[51] = AddStaticVehicleEx(468, 1583.1974, -1681.5450, 5.5625, 270.1680, 0, 0, VEHICLE_RESPAWN, 1); // (1-UNION-3)
	SAPDVehicles[52] = AddStaticVehicleEx(426, 1528.7328, -1683.7745, 5.6337, 270.3810, 0, 0, VEHICLE_RESPAWN, 1); // (7-HENDRY-1)
	SAPDVehicles[53] = AddStaticVehicleEx(426, 1528.8241, -1687.8558, 5.6271, 269.6481, 0, 0, VEHICLE_RESPAWN, 1); // (7-HENDRY-2) 
	SAPDVehicles[54] = AddStaticVehicleEx(415, 1546.2323, -1684.3895, 5.6639, 89.7967, 0, 0, VEHICLE_RESPAWN, 1); // (6-HOTEL-1) 
	SAPDVehicles[55] = AddStaticVehicleEx(451, 1545.9630, -1680.3013, 5.5935, 89.8930, 0, 0, VEHICLE_RESPAWN, 1); // (6-HOTEL-2) 
	SAPDVehicles[56] = AddStaticVehicleEx(411, 1546.0787, -1676.0718, 5.6123, 89.5010, 0, 0, VEHICLE_RESPAWN, 1); // (6-HOTEL-3) 
	SAPDVehicles[57] = AddStaticVehicleEx(541, 1546.3257, -1672.0012, 5.5220, 87.7172, 0, 0, VEHICLE_RESPAWN, 1); // (6-HOTEL-4) 
	SAPDVehicles[58] = AddStaticVehicleEx(415, 1546.1973, -1667.8490, 5.6513, 89.1564, 0, 0, VEHICLE_RESPAWN, 1); // (6-HOTEL-5) 
	SAPDVehicles[59] = AddStaticVehicleEx(490, 1545.6974, -1663.2489, 5.9837, 89.4131, 0, 0, VEHICLE_RESPAWN, 1); // (6-DAVID-1) 
	SAPDVehicles[60] = AddStaticVehicleEx(490, 1545.6665, -1659.1666, 6.0187, 89.9371, 0, 0, VEHICLE_RESPAWN, 1); // (6-DAVID-2)
	SAPDVehicles[61] = AddStaticVehicleEx(427, 1545.1559, -1654.9792, 6.0160, 92.9525, 0, 0, VEHICLE_RESPAWN, 1); // (6-RESCUE-1)
	SAPDVehicles[62] = AddStaticVehicleEx(528, 1545.2665, -1651.0095, 5.9452, 89.8496, 0, 0, VEHICLE_RESPAWN, 1); // (6-RESCUE-2)
	SAPDVehicles[63] = AddStaticVehicleEx(528, 1538.9622, -1643.8527, 5.9334, 179.4513, 0, 0, VEHICLE_RESPAWN, 1); // (6-RESCUE-3)
	SAPDVehicles[64] = AddStaticVehicleEx(601, 1534.4694, -1644.1987, 5.6502, 181.0810, 0, 0, VEHICLE_RESPAWN, 1); // (6-RESISTOR-1)
	SAPDVehicles[65] = AddStaticVehicleEx(416, 1530.6296, -1644.6029, 6.0405, 179.5005, 1, 0, VEHICLE_RESPAWN, 1); // (6-RA-1)
	SAPDVehicles[66] = AddStaticVehicleEx(416, 1526.7708, -1644.4241, 6.0408, 180.6860, 1, 0, VEHICLE_RESPAWN, 1); // (6-RA-2)
	SAPDVehicles[67] = AddStaticVehicleEx(522, 1546.8297, -1645.6454, 5.4547, 136.2838, 0, 0, VEHICLE_RESPAWN, 1); // (6-RAPID-1)
	SAPDVehicles[68] = AddStaticVehicleEx(522, 1545.2856, -1644.6224, 5.4618, 135.7204, 0, 0, VEHICLE_RESPAWN, 1); // (6-RAPID-2)
	SAPDVehicles[69] = AddStaticVehicleEx(522, 1543.8486, -1642.8555, 5.4522, 130.9668, 0, 0, VEHICLE_RESPAWN, 1); // (6-RAPID-3)
	SAPDVehicles[70] = AddStaticVehicleEx(525, 1544.3879, -1608.7629, 13.2591, 271.1566, 1, 0, VEHICLE_RESPAWN, 1); // (1-TOM-1)
	SAPDVehicles[71] = AddStaticVehicleEx(525, 1544.3621, -1613.4329, 13.2622, 268.6892, 1, 0, VEHICLE_RESPAWN, 1); // (1-TOM-2)
	SAPDVehicles[72] = AddStaticVehicleEx(497, 1564.9788, -1656.4011, 28.5746, 86.3983, 0, 0, VEHICLE_RESPAWN, 1); // (6-AIR-1)
	SAPDVehicles[73] = AddStaticVehicleEx(497, 1564.4425, -1694.8608, 28.5880, 90.2365, 0, 0, VEHICLE_RESPAWN, 1); // (6-AIR-2)

	for(new x;x<sizeof(SAPDVehicles);x++)
	{
	    format(strings, sizeof(strings), "SAPD-%d", SAPDVehicles[x]);
	    SetVehicleNumberPlate(SAPDVehicles[x], strings);
	    SetVehicleToRespawn(SAPDVehicles[x]);
	}*/
	
	//-----[ SAGS Vehicle ]-----
	SAGSVehicles[0] = AddStaticVehicleEx(405, 1507.6377, -1747.9199, 13.5757, 0.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[1] = AddStaticVehicleEx(405, 1455.3049, -1748.5181, 13.3789, 0.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[2] = AddStaticVehicleEx(409, 1498.6385, -1744.0792, 13.2442, 91.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[3] = AddStaticVehicleEx(409, 1463.2329, -1743.9989, 13.2442, -91.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[4] = AddStaticVehicleEx(411, 1524.1866, -1846.0491, 13.3714, 0.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[5] = AddStaticVehicleEx(411, 1534.8187, -1845.9094, 13.3714, 0.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[6] = AddStaticVehicleEx(411, 1529.4353, -1845.9347, 13.3714, 0.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[7] = AddStaticVehicleEx(521, 1512.8479, -1846.1010, 13.0548, 0.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[8] = AddStaticVehicleEx(521, 1519.4961, -1846.0326, 13.0548, 0.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[9] = AddStaticVehicleEx(521, 1515.9736, -1845.9476, 13.0548, 0.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[10] = AddStaticVehicleEx(437, 1494.1495, -1845.1425, 13.5694, -91.0000, 0, 0, VEHICLE_RESPAWN);

	
	for(new x;x<sizeof(SAGSVehicles);x++)
	{
	    format(strings, sizeof(strings), "SAGS-%d", SAGSVehicles[x]);
	    SetVehicleNumberPlate(SAGSVehicles[x], strings);
	    SetVehicleToRespawn(SAGSVehicles[x]);
	}
	
	/*//-----[ SAMD Vehicle ]-----
	SAMDVehicles[0] = AddStaticVehicleEx(407, 1111.0358, -1328.3903, 13.6102, 0.0000, -1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[1] = AddStaticVehicleEx(407, 1098.1630, -1328.7020, 13.7072, 0.0000, -1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[2] = AddStaticVehicleEx(544, 1124.4944, -1327.0439, 13.9194, 0.0000, -1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[3] = AddStaticVehicleEx(416, 1116.0294, -1296.6489, 13.6160, 179.4438, 1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[4] = AddStaticVehicleEx(416, 1125.8785, -1296.2780, 13.6160, 179.4438, 1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[5] = AddStaticVehicleEx(416, 1121.1556, -1296.4138, 13.6160, 179.4438, 1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[6] = AddStaticVehicleEx(442, 1111.1719, -1296.7606, 13.4886, 185.0000, 0, 1, VEHICLE_RESPAWN, 1);
	SAMDVehicles[7] = AddStaticVehicleEx(426, 1136.0360, -1341.2158, 13.3050, 0.0000, 0, 1, VEHICLE_RESPAWN, 1);
	SAMDVehicles[8] = AddStaticVehicleEx(416, 1178.5963, -1338.9039, 14.1457, -91.0000, 1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[9] = AddStaticVehicleEx(586, 1130.7795, -1330.4045, 13.3639, 0.0000, 0, 1, VEHICLE_RESPAWN, 1);
	SAMDVehicles[10] = AddStaticVehicleEx(563, 1162.9077, -1313.8203, 32.1891, 270.6980, -1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[11] = AddStaticVehicleEx(487, 1163.0469, -1297.5098, 31.5550, 269.6279, -1, 3, VEHICLE_RESPAWN, 1);*/
	
	for(new x;x<sizeof(SAMDVehicles);x++)
	{
	    format(strings, sizeof(strings), "SAMD-%d", SAMDVehicles[x]);
	    SetVehicleNumberPlate(SAMDVehicles[x], strings);
	    SetVehicleToRespawn(SAMDVehicles[x]);
	}
	
	/*//-----[ SANA Vehicle ]-----
	SANAVehicles[0] = AddStaticVehicleEx(582, 781.4338, -1337.5022, 13.9482, 91.0000, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[1] = AddStaticVehicleEx(582, 758.7664, -1336.1642, 13.9482, 179.0212, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[2] = AddStaticVehicleEx(582, 764.4276, -1336.1959, 13.9482, 179.0212, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[3] = AddStaticVehicleEx(582, 770.3247, -1335.9663, 13.9482, 179.0212, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[4] = AddStaticVehicleEx(418, 737.3025, -1334.3344, 14.1711, 246.6513, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[5] = AddStaticVehicleEx(413, 736.4621, -1338.6304, 13.7490, -113.0000, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[6] = AddStaticVehicleEx(405, 737.4107, -1343.0820, 13.7357, -113.0000, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[7] = AddStaticVehicleEx(461, 749.7194, -1334.2122, 13.2465, 178.0000, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[8] = AddStaticVehicleEx(461, 753.8127, -1334.2727, 13.2465, 178.0000, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[9] = AddStaticVehicleEx(488, 741.9925, -1371.2443, 25.8111, 0.0000, -1, -1, VEHICLE_RESPAWN);
	
	for(new x;x<sizeof(SANAVehicles);x++)
	{
	    format(strings, sizeof(strings), "SANA-%d", SANAVehicles[x]);
	    SetVehicleNumberPlate(SANAVehicles[x], strings);
	    SetVehicleToRespawn(SANAVehicles[x]);
	}*/
	
	printf("[Objects]: %d Loaded.", CountDynamicObjects());
	return 1;
}

public OnGameModeExit()
{
	//fly
	for(new x; x<MAX_PLAYERS; x++)
	{
		if(noclipdata[x][cameramode] == CAMERA_MODE_FLY) CancelFlyMode(x);
	}
	//cctv
	TextDrawHideForAll(TD);
	TextDrawDestroy(TD);
	for(new i; i<TotalMenus; i++)
	{
		DestroyMenu(CCTVMenu[i]);
	}
	//
	new count = 0, count1 = 0, user = 0;
	foreach(new gsid : GStation)
	{
		if(Iter_Contains(GStation, gsid))
		{
			count++;
			GStation_Save(gsid);
		}
	}
	printf("[Gas Station]: %d Saved.", count);
	
	foreach(new pid : Plants)
	{
		if(Iter_Contains(Plants, pid))
		{
			count1++;
			Plant_Save(pid);
		}
	}
	foreach(new p : Player)
	{
		user++;
		UpdatePlayerData(p);
	}
	foreach(new v : PVehicles)
	{
		RemovePlayerVehicle(v);
	}
	printf("[AUTO GMX, PLAYER SAVED %s]", user);
	UnloadTazerSAPD();
	//Audio_DestroyTCPServer();
	mysql_close(g_SQL);
	return 1;
}

IPRP::SpawnTimer(playerid)
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, pData[playerid][pMoney]);
	SetPlayerScore(playerid, pData[playerid][pLevel]);
	SetPlayerHealth(playerid, pData[playerid][pHealth]);
	SetPlayerArmour(playerid, pData[playerid][pArmour]);
	pData[playerid][pSpawned] = 1;
	TogglePlayerControllable(playerid, 1);
	SetCameraBehindPlayer(playerid);
	AttachPlayerToys(playerid);
	SetWeapons(playerid);
	if(pData[playerid][pJailTime] > 0)
	{
	    if (pData[playerid][pJail])
	    {
	        SetPlayerPositionEx(playerid, -310.64, 1894.41, 34.05, 178.17, 2000);
	        SetPlayerInterior(playerid, 2);
	        SetPlayerVirtualWorld(playerid, pData[playerid][pID] + 10);
	        PlayerTextDrawShow(playerid, JAILTD[playerid]);
	        ResetPlayerWeapons(playerid);
	    }
	    else
	    {
		    SetPlayerPositionEx(playerid, -310.64, 1894.41, 34.05, 178.17, 2000);

		    SetPlayerInterior(playerid, 3);

		    SetPlayerVirtualWorld(playerid, (playerid + 100));
		    SetPlayerFacingAngle(playerid, 0.0);
            PlayerTextDrawShow(playerid, JAILTD[playerid]);
		    SetCameraBehindPlayer(playerid);
		}

	    SendServerMessage(playerid, "You have %d seconds of remaining jail time.", pData[playerid][pJailTime]);
	}
	if(pData[playerid][pArrestTime] > 0)
	{
		SetPlayerArrest(playerid, pData[playerid][pArrest]);
	}
	return 1;
}

//-----[ Button System ]-----	
IPRP::SAGSLobbyDoorClose()
{
	MoveDynamicObject(SAGSLobbyDoor[0], -2689.33, 807.425, 1499.95, 3);
	MoveDynamicObject(SAGSLobbyDoor[1], -2067.72, 2694.67, 1499.96, 3);
	MoveDynamicObject(SAGSLobbyDoor[2], -2062.2, 2693.16, 1499.98, 3);
	MoveDynamicObject(SAGSLobbyDoor[3], -2062.22, 2704.74, 1499.96, 3);
	return 1;
}

IPRP::SAMCLobbyDoorClose()
{
	MoveDynamicObject(SAMCLobbyDoor[0], -1786.8, -1997.48, 1499.77, 3);
	MoveDynamicObject(SAMCLobbyDoor[1], -1771.77, -1995.14, 1499.77, 3);
	MoveDynamicObject(SAMCLobbyDoor[2], -1757.91, -1997.48, 1499.76, 3);
	return 1;
}


public OnPlayerPressButton(playerid, buttonid)
{
	if(buttonid == SAGSLobbyBtn[0] || buttonid == SAGSLobbyBtn[1])
	{
	    if(pData[playerid][pFaction] == 2)
	    {
	        MoveDynamicObject(SAGSLobbyDoor[0], -2687.77, 807.428, 1499.95, 3, -1000.0, -1000.0, -1000.0);
			SetTimer("SAGSLobbyDoorClose", 5000, 0);
	    }
		else
	    {
	        Error(playerid, "Akses ditolak.");
			return 1;
		}
	}
	if(buttonid == SAGSLobbyBtn[2] || buttonid == SAGSLobbyBtn[3])
	{
	    if(pData[playerid][pFaction] == 2)
	    {
	        MoveDynamicObject(SAGSLobbyDoor[1], -2067.73, 2696.24, 1499.96, 3, -1000.0, -1000.0, -1000.0);
			SetTimer("SAGSLobbyDoorClose", 5000, 0);
	    }
		else
	    {
	        Error(playerid, "Akses ditolak.");
			return 1;
		}
	}
	if(buttonid == SAGSLobbyBtn[4] || buttonid == SAGSLobbyBtn[5])
	{
	    if(pData[playerid][pFaction] == 2)
	    {
	        MoveDynamicObject(SAGSLobbyDoor[2], -2062.2, 2691.63, 1499.98, 3, -1000.0, -1000.0, -1000.0);
			SetTimer("SAGSLobbyDoorClose", 5000, 0);
	    }
		else
	    {
	        Error(playerid, "Akses ditolak.");
			return 1;
		}
	}
	if(buttonid == SAGSLobbyBtn[6] || buttonid == SAGSLobbyBtn[7])
	{
	    if(pData[playerid][pFaction] == 2)
	    {
	        MoveDynamicObject(SAGSLobbyDoor[3], -2062.21, 2703.22, 1499.96, 3, -1000.0, -1000.0, -1000.0);
			SetTimer("SAGSLobbyDoorClose", 5000, 0);
	    }
		else
	    {
	        Error(playerid, "Akses ditolak.");
			return 1;
		}
	}
	if(buttonid == SAMCLobbyBtn[0] || buttonid == SAMCLobbyBtn[1])
	{
		if(pData[playerid][pFaction] == 3)
		{
			MoveDynamicObject(SAMCLobbyDoor[0], -1786.79, -1995.97, 1499.77, 3, -1000.0, -1000.0, -1000.0);
			SetTimer("SAMCLobbyDoorClose", 5000, 0);
		}
		else
	    {
	        Error(playerid, "Akses ditolak.");
			return 1;
		}
	}
	if(buttonid == SAMCLobbyBtn[2] || buttonid == SAMCLobbyBtn[3])
	{
		if(pData[playerid][pFaction] == 3)
		{
			MoveDynamicObject(SAMCLobbyDoor[1], -1770.25, -1995.13, 1499.77, 3, -1000.0, -1000.0, -1000.0);
			SetTimer("SAMCLobbyDoorClose", 5000, 0);
		}
		else
	    {
	        Error(playerid, "Akses ditolak.");
			return 1;
		}
	}
	if(buttonid == SAMCLobbyBtn[4] || buttonid == SAMCLobbyBtn[5])
	{
		if(pData[playerid][pFaction] == 3)
		{
			MoveDynamicObject(SAMCLobbyDoor[2], -1757.87, -1995.95, 1499.76, 3, -1000.0, -1000.0, -1000.0);
			SetTimer("SAMCLobbyDoorClose", 5000, 0);
		}
		else
	    {
	        Error(playerid, "Akses ditolak.");
			return 1;
		}
	}
	return 1;
}

forward Diusirpesawat(playerid);
public Diusirpesawat(playerid)
{
    new Float:POS[3], otherid;
				
				GetPlayerPos(playerid, POS[0], POS[1], POS[2]);
				SetPlayerPos(playerid, POS[0] + 2.0, POS[1], POS[2]);
    ErrorMsg(playerid, "Anda tidak mempunyai tiket pesawat");
					 
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
   
	if(!ispassenger)
	{
    	if(IsGovCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 2)
			{
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Anda bukan SAGS!");
			}
		}
		/*foreach(new i : Player)
			{
				if(vehicleid == SAPDVeh[i])
				{
						
				}
			}*/
	}
	//tentara
	foreach(new gsid : GStation)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.0, gsData[gsid][gsPosX], gsData[gsid][gsPosY], gsData[gsid][gsPosZ]))
			{
			    if(pData[playerid][pFill] != -1)
			    {
				    KillTimer(Sedangngisi[playerid]);
					//HideProgressBar(playerid);
					for(new i = 0; i < 8; i++)
						{
					 		PlayerTextDrawHide(playerid, FuelTD[playerid][i]);
						}
			        new gsid = pData[playerid][pFill];

					GStation_Refresh(gsid);
					Info(playerid,"Anda menaikin kendaraan pengisian berhenti total "RED_E"%s.", FormatMoney(pData[playerid][pFillPrice]*10));
					Mobilisi[playerid] = 0;
					KillTimer(pData[playerid][pFillTime]);
					pData[playerid][pFillStatus] = 0;
					pData[playerid][pFillPrice] = 0;
					pData[playerid][pFill] = -1;
				}
			}
		}
	//
	if(!ispassenger)
	{
	 /*
		if(IsSAPDCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 1)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Veh SAPD Dek!");
			}
		}
		if(IsGovCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 2)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Anda bukan SAGS!");
			}
		}
		if(IsSAMDCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 3)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Veh SAMD Dek!");
			}
		}
		if(IsSANACar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 4)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Veh SANEWS Dek!");
			}
		}
		if(IsPEGCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 5)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "Veh i-mart Dek!");
			}
		}*/
		
		if(IsAPesawat(vehicleid))
		{
		    if(pData[playerid][pFaction] != 8)
		    {
		        if(pData[playerid][pTiket] < 1)
		        	return SetTimerEx("Diusirpesawat", 1, false, "i", playerid);
			    if(vehicleid == pesawat[0])
			    {
			    	PutPlayerInVehicle(playerid, pesawat[0], 4);
				}
				if(vehicleid == pesawat[1])
			    {
			    	PutPlayerInVehicle(playerid, pesawat[1], 4);
				}
				if(vehicleid == pesawat[2])
			    {
			    	PutPlayerInVehicle(playerid, pesawat[2], 4);
				}
				if(vehicleid == pesawat[3])
			    {
			    	PutPlayerInVehicle(playerid, pesawat[3], 4);
				}
				if(vehicleid == pesawat[4])
			    {
			    	PutPlayerInVehicle(playerid, pesawat[4], 4);
				}
				if(vehicleid == pesawat[5])
			    {
			    	PutPlayerInVehicle(playerid, pesawat[5], 4);
				}
				if(vehicleid == pesawat[6])
			    {
			    	PutPlayerInVehicle(playerid, pesawat[6], 4);
				}
				if(vehicleid == pesawat[7])
			    {
			    	PutPlayerInVehicle(playerid, pesawat[7], 4);
				}
				if(vehicleid == pesawat[8])
			    {
			    	PutPlayerInVehicle(playerid, pesawat[8], 4);
				}
				if(vehicleid == pesawat[9])
			    {
			    	PutPlayerInVehicle(playerid, pesawat[9], 4);
				}
				if(vehicleid == pesawat[10])
			    {
			    	PutPlayerInVehicle(playerid, pesawat[10], 4);
				}
				if(vehicleid == pesawat[11])
			    {
			    	PutPlayerInVehicle(playerid, pesawat[11], 4);
				}
				if(vehicleid == pesawat[12])
			    {
			    	PutPlayerInVehicle(playerid, pesawat[12], 4);
				}
			}
			else
		    {
		        if(IsVehicleSeatOccupied(vehicleid,0))
		        {
				    if(vehicleid == pesawat[0])
				    {
				    	PutPlayerInVehicle(playerid, pesawat[0], 1);
					}
					if(vehicleid == pesawat[1])
				    {
				    	PutPlayerInVehicle(playerid, pesawat[1], 1);
					}
					if(vehicleid == pesawat[2])
				    {
				    	PutPlayerInVehicle(playerid, pesawat[2], 1);
					}
					if(vehicleid == pesawat[3])
				    {
				    	PutPlayerInVehicle(playerid, pesawat[3], 1);
					}
					if(vehicleid == pesawat[4])
				    {
				    	PutPlayerInVehicle(playerid, pesawat[4], 1);
					}
					if(vehicleid == pesawat[5])
				    {
				    	PutPlayerInVehicle(playerid, pesawat[5], 1);
					}
					if(vehicleid == pesawat[6])
				    {
				    	PutPlayerInVehicle(playerid, pesawat[6], 1);
					}
					if(vehicleid == pesawat[7])
				    {
				    	PutPlayerInVehicle(playerid, pesawat[7], 1);
					}
					if(vehicleid == pesawat[8])
				    {
				    	PutPlayerInVehicle(playerid, pesawat[8], 1);
					}
					if(vehicleid == pesawat[9])
				    {
				    	PutPlayerInVehicle(playerid, pesawat[9], 1);
					}
					if(vehicleid == pesawat[10])
				    {
				    	PutPlayerInVehicle(playerid, pesawat[10], 1);
					}
					if(vehicleid == pesawat[11])
				    {
				    	PutPlayerInVehicle(playerid, pesawat[11], 1);
					}
					if(vehicleid == pesawat[12])
				    {
				    	PutPlayerInVehicle(playerid, pesawat[12], 1);
					}
				}
			}
		}
		if(IsABaggageVeh(vehicleid))
		{
			if(pData[playerid][pJob] != 10 && pData[playerid][pJob2] != 10)
			{
				RemovePlayerFromVehicle(playerid);
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
                Error(playerid, "Kamu tidak bekerja sebagai Baggage Airport");
			}
		}
		if(IsADmvVeh(vehicleid))
        {
            if(!pData[playerid][pDriveLicApp])
            {
                RemovePlayerFromVehicle(playerid);
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
                Error(playerid, "Kamu tidak sedang mengikuti Tes Mengemudi");
			}
			else 
			{
				Info(playerid, "Silahkan ikuti Checkpoint yang ada di GPS mobil ini.");
				SetPlayerRaceCheckpoint(playerid, 1, dmvpoint1, dmvpoint1, 5.0);
			}
		}
		/*if(IsAKurirVeh(vehicleid))
		{
			if(pData[playerid][pJob] != 8 && pData[playerid][pJob2] != 8)
			{
				RemovePlayerFromVehicle(playerid);
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
                Error(playerid, "Kamu tidak bekerja sebagai Courier");
			}
		}*/
		/*foreach(new pv : PVehicles)
		{
			if(vehicleid == pvData[pv][cVeh])
			{
				if(IsABike(vehicleid) && pvData[pv][cLocked] == 1)
				{
					RemovePlayerFromVehicle(playerid);
					new Float:slx, Float:sly, Float:slz;
					GetPlayerPos(playerid, slx, sly, slz);
					SetPlayerPos(playerid, slx, sly, slz);
					Error(playerid, "This bike is locked by owner.");
				}
			}
		}*/
	}
	return 1;
}

//----[STOCK]----//

IPRP::UpgradeBody(playerid, i)
{
	pvData[i][cUpgrade][0] = 1;
	SendServerMessage(playerid, "You've successfully upgraded the body of vehicle!");
	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
	return 1;
}

IPRP::UpgradeEngine(playerid, i)
{
	pvData[i][cUpgrade][1] = 1;
	SendServerMessage(playerid, "You've successfully upgraded the engine of vehicle!");
	SetVehicleMaxHealth(i);
	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
	return 1;
}

IPRP::UpgradeBrake(playerid, i)
{
	pvData[i][cUpgrade][3]++;
	SendServerMessage(playerid, "You've successfully upgraded the brake of vehicle! | Brake level {FF0000}%s", GetUpgradeName(pvData[i][cUpgrade][3]));
	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
	return 1;
}

IPRP::UpgradeTurbo(playerid, i)
{
	//pvData[i][cUpgrade][2]++;
	SendServerMessage(playerid, "You've successfully upgraded the turbo of vehicle!");
	PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
	return 1;
}

stock Player_Near(playerid)
{
	foreach(new otherid : Player) if(IsPlayerConnected(otherid))
	{
		if(otherid == playerid) continue;
	    new Float:x, Float:y, Float:z;
	    GetPlayerPos(playerid, Float:x, Float:y, Float:z);
		if(IsPlayerInRangeOfPoint(otherid, 3, Float:x, Float:y, Float:z))
		{
			return otherid;
		}
		
	}
	return INVALID_PLAYER_ID;
}

stock GetVehicleSpeedKMH(vehicleid)
{
	new Float:speed_x, Float:speed_y, Float:speed_z, Float:temp_speed, round_speed;
	GetVehicleVelocity(vehicleid, speed_x, speed_y, speed_z);

	temp_speed = temp_speed = floatsqroot(((speed_x*speed_x) + (speed_y*speed_y)) + (speed_z*speed_z)) * 136.666667;

	round_speed = floatround(temp_speed);
	return round_speed;
}

stock SetVehicleMaxHealth(id)
{
	if(pvData[id][cUpgrade][1] == 1)
	{
	    SetVehicleHealth(pvData[id][cVeh], 2000);
	}
	else
	{
	    SetVehicleHealth(pvData[id][cVeh], 1000);
	}
	return 1;
}

stock SetVehicleSpeedKMH(vehicleid, Float:speed)
{
	if(speed <= 0) return true;
    new Float:cr[3];
    GetVehicleVelocity(vehicleid, cr[0], cr[1], cr[2]);
    new Float:test = floatsqroot(floatadd(floatadd(floatpower(cr[0], 2), floatpower(cr[1], 2)),  floatpower(cr[2], 2))) * 136.666667;
    new Float:dif =  speed / test;
    if(dif != 0 && test != 0) SetVehicleVelocity(vehicleid,cr[0]*dif,cr[1]*dif,cr[2]);// && GetPlayerPing(playerid) < 200
    return true;
}

stock SetVehSpeed(vehicleid, Float:speed)
{
	if(speed <= 0) return true;
    new Float:cr[3];
    GetVehicleVelocity(vehicleid, cr[0], cr[1], cr[2]);
    new Float:test = floatsqroot(floatadd(floatadd(floatpower(cr[0], 2), floatpower(cr[1], 2)),  floatpower(cr[2], 2))) * 100.0;
    new Float:dif =  speed / test;
    if(dif != 0 && test != 0) SetVehicleVelocity(vehicleid,cr[0]*dif,cr[1]*dif,cr[2]);// && GetPlayerPing(playerid) < 200
    return true;
}

stock const g_aWeatherRotations[] =
{
	14, 1, 7, 3, 5, 12, 9, 8, 15
};

IPRP::WeatherRotator()
{
	new index = random(sizeof(g_aWeatherRotations));

	SetWeather(g_aWeatherRotations[index]);
}

WasteDeAMXersTime()
{
    new b;
    #emit load.pri b
    #emit stor.pri b
}

AntiDeAMX()
{
    new a[][] =
    {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}

stock IsPlayerNearPlayer(playerid, targetid, Float:radius)
{
	static
		Float:fX,
		Float:fY,
		Float:fZ;

	GetPlayerPos(targetid, fX, fY, fZ);

	return (GetPlayerInterior(playerid) == GetPlayerInterior(targetid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(targetid)) && IsPlayerInRangeOfPoint(playerid, radius, fX, fY, fZ);
}

stock SetRaceCP(playerid, type, Float:x, Float:y, Float:z, Float:range)
{
	DisablePlayerRaceCheckpoint(playerid);
	SetPlayerRaceCheckpoint(playerid, type, x, y, z, 0, 0, 0, range);
}

stock GiveMoneyRob(playerid, small, big)
{
	new money;
	new moneys[100];
	money = small+random(big);
	pData[playerid][pRedMoney] += money;
	format(moneys, sizeof moneys, "You have succesfull Robery, Getting : {00FF7F}$%s", FormatMoney(money));
	SendClientMessage(playerid, 0xFFFFFF00, moneys);
}

stock SendTweetMessage(color, String[])
{
	foreach(new i : Player)
	{
		if(pData[i][pTogTweet] == 0)
		{
			SendClientMessageEx(i, color, String);
		}
	}
	return 1;
}

stock SGetName(playerid)
{
    new name[ 64 ];
    GetPlayerName(playerid, name, sizeof( name ));
    return name;
}

public OnPlayerText(playerid, text[])
{
	if(isnull(text)) return 0;
	new str[150];
	format(str,sizeof(str),"[CHAT] %s: %s", GetRPName(playerid), text);
	LogServer("Chat", str);
	printf(str);
	

	/*if(pData[playerid][pAdminDuty] == 1)
	{
		new lstr[200];
		format(lstr, sizeof(lstr), "{FF0000}%s : {FFFFFF}(( %s ))", ReturnName(playerid), text);
		ProxDetector(25, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
	}*/
	
	if(pData[playerid][pSpawned] == 0 && pData[playerid][IsLoggedIn] == false)
	{
	    Error(playerid, "You must be spawned or logged in to use chat.");
	    return 0;
	}
	if(!strcmp(text, "Serahkan semua uangnya", true))
	{
	    if(IsPlayerInRangeOfPoint(playerid, 5.0, 1283.24, -1370.01, 13.83))
		{
		   
		        new dc[1000];
				format(dc, sizeof(dc),  "**%s Mencoba merampok mixue Ucp: %s**", pData[playerid][pName], pData[playerid][pUCP]);
				SendDiscordMessage(15, dc);
		        SendClientMessageEx(playerid, -1, "%s:Diam!!! cepat serahkan semua uangnya atau nyawa anda lenyap ditangan saya", GetRPName(playerid));
		        Update3DTextLabelText(Text3D: Tesaje, COLOR_WHITE, "Penjaga: Ba...Baiklah Saya akan memberikan semua uangnya, tu..tunggu dulu saya akan ambil uangnya");
		  		//SendClientMessageEx(playerid, -1, "Kasir Muxie:Ba...Baiklah Saya akan memberikan semua uangnya, tu..tunggu dulu saya akan ambil uangnya");
		  		//SetTimerEx("RunActorAnimationSequence", 3000, false, "iii", playerid, Actorrob, 0);
		  		RunActorAnimationSequence(playerid, Actorrob, 1);

		}
	}
	//-----[ Auto RP ]-----	
	if(!strcmp(text, "rpgun", true) || !strcmp(text, "gunrp", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s lepaskan senjatanya dari sabuk dan siap untuk menembak kapan saja.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "E", true))
	{
	    foreach(new gsid : GStation)
		{
			if(IsPlayerInRangeOfPoint(playerid, 4.0, gsData[gsid][gsPosX], gsData[gsid][gsPosY], gsData[gsid][gsPosZ]))
			{
			    KillTimer(Sedangngisi[playerid]);
				//HideProgressBar(playerid);
				for(new i = 0; i < 8; i++)
					{
				 		PlayerTextDrawHide(playerid, FuelTD[playerid][i]);
					}
		        new gsid = pData[playerid][pFill];

				GStation_Refresh(gsid);
				InfoMsg(playerid,"Tangki kendaraan anda sudah terisi seharga "RED_E"%s.", FormatMoney(pData[playerid][pFillPrice]*10));
				Mobilisi[playerid] = 0;
				KillTimer(pData[playerid][pFillTime]);
				pData[playerid][pFillStatus] = 0;
				pData[playerid][pFillPrice] = 0;
				pData[playerid][pFill] = -1;
			}
		}
	}
	if(!strcmp(text, "L", true))
	{
	    static
	   	carid = -1;

	   	if((carid = Vehicle_Nearest(playerid)) != -1)
	   	{
	   		if(Vehicle_IsOwner(playerid, carid))
	   		{
	   			if(!pvData[carid][cLocked])
	   			{
	   				pvData[carid][cLocked] = 1;

	   				InfoTD_MSG(playerid, 4000, "Vehicle ~r~Locked!");
	   				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

	   				SwitchVehicleDoors(pvData[carid][cVeh], true);
	   				SwitchVehicleLight(pvData[carid][cVeh], true);
				   				SetTimerEx("Lampulock", 1500, false, "d", pvData[carid][cVeh]);
	   			}
	   			else
	   			{

	   				pvData[carid][cLocked] = 0;
	   				InfoTD_MSG(playerid, 4000, "Vehicle ~g~Unlocked!");
	   				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

	   				SwitchVehicleDoors(pvData[carid][cVeh], false);
	   				SwitchVehicleLight(pvData[carid][cVeh], true);
				   				SetTimerEx("Lampulock", 1500, false, "d", pvData[carid][cVeh]);
	   			}
	   		}
			//else SendErrorMessage(playerid, "You are not in range of anything you can lock.");
	   	}
	    if(pData[playerid][pFaction] == 1)
		{
		    foreach(new i : Player)
		    {
		        new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0, false);
		        if(vehicleid == SAPDVeh[i])
			   	{

			   			if(!kuncicar[vehicleid])
			   			{
			   				kuncicar[vehicleid] = 1;

			   				InfoTD_MSG(playerid, 4000, "Vehicle ~r~Locked!");
			   				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);


			   				SwitchVehicleDoors(vehicleid, true);
			   				SwitchVehicleLight(vehicleid, true);
				   				SetTimerEx("Lampulock", 1500, false, "d", vehicleid);
			   			}
			   			else
			   			{

			   				kuncicar[vehicleid] = 0;
			   				InfoTD_MSG(playerid, 4000, "Vehicle ~g~Unlocked!");
			   				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

			   				SwitchVehicleDoors(vehicleid, false);
			   				SwitchVehicleLight(vehicleid, true);
				   				SetTimerEx("Lampulock", 1500, false, "d", vehicleid);
			   			}
					//else SendErrorMessage(playerid, "You are not in range of anything you can lock.");
			   	}
			}
		}
	}
	if(!strcmp(text, "rpcrash", true) || !strcmp(text, "crashrp", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s kaget setelah kecelakaan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfish", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memancing dengan kedua tangannya.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfall", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s jatuh dan merasakan sakit.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpmad", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s merasa kesal dan ingin mengeluarkan amarah.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rprob", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s menggeledah sesuatu dan siap untuk merampok.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcj", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mencuri kendaraan seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpwar", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s berperang dengan sesorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpdie", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s pingsan dan tidak sadarkan diri.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfixmeka", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memperbaiki mesin kendaraan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcheckmeka", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memeriksa kondisi kendaraan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfight", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s ribut dan memukul seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcry", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sedang bersedih dan menangis.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rprun", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s berlari dan kabur.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpfear", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s merasa ketakutan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpdropgun", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s meletakkan senjata kebawah.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rptakegun", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s mengamnbil senjata.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpgivegun", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memberikan kendaraan kepada seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpshy", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s merasa malu.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpnusuk", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s menusuk dan membunuh seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpharvest", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memanen tanaman.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rplockhouse", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sedang mengunci rumah.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rplockcar", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s sedang mengunci kendaraan.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpnodong", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memulai menodong seseorang.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpeat", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s makan makanan yang ia beli.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpdrink", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s meminum minuman yang ia beli.", ReturnName(playerid));
		return 0;
	}
	if(text[0] == '@')
	{
		if(pData[playerid][pSMS] != 0)
		{
			if(pData[playerid][pPhoneCredit] < 1)
			{
				Error(playerid, "Anda tidak memiliki Credit!");
				return 0;
			}
			if(pData[playerid][pInjured] != 0)
			{
				Error(playerid, "Tidak dapat melakukan saat ini.");
				return 0;
			}
			new tmp[512];
			foreach(new ii : Player)
			{
				if(text[1] == ' ')
				{
			 		format(tmp, sizeof(tmp), "%s", text[2]);
				}
				else
				{
				    format(tmp, sizeof(tmp), "%s", text[1]);
				}
				if(pData[ii][pPhone] == pData[playerid][pSMS])
				{
					if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii))
					{
						Error(playerid, "Nomor ini tidak aktif!");
						return 0;
					}
					SendClientMessageEx(playerid, COLOR_YELLOW, "[SMS to %d]"WHITE_E" %s", pData[playerid][pSMS], tmp);
					SendClientMessageEx(ii, COLOR_YELLOW, "[SMS from %d]"WHITE_E" %s", pData[playerid][pPhone], tmp);
					PlayerPlaySound(ii, 6003, 0,0,0);
					pData[ii][pSMS] = pData[playerid][pPhone];
					
					pData[playerid][pPhoneCredit] -= 1;
					return 0;
				}
			}
		}
	}
	if(pData[playerid][pCall] != INVALID_PLAYER_ID)
	{
		// Anti-Caps
		if(GetPVarType(playerid, "Caps"))
			UpperToLower(text);
		new lstr[1024];
		format(lstr, sizeof(lstr), "[CellPhone] %s says: %s", ReturnName(playerid), text);
		ProxDetector(10, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
		SetPlayerChatBubble(playerid, text, COLOR_WHITE, 10.0, 3000);
		SendClientMessageEx(pData[playerid][pCall], COLOR_YELLOW, "[CELLPHONE] "WHITE_E"%s.", text);
		return 0;
	}
	else
	{
	    if(pData[playerid][pAdminDuty] == 1)
	    {
     		SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %s ))", GetRPName(playerid), text);
	        new adc[1000];
			format(adc, sizeof(adc),  "A:%s : (( %s ))", pData[playerid][pAdminname], text);
			SendDiscordMessage(2, adc);
		}
		else
		{
	    	/*SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s : %s", GetRPName(playerid), text);
	    	new dc[1000];
			format(dc, sizeof(dc),  "%s : %s", GetRPName(playerid), text);
			SendDiscordMessage(2, dc);*/
		}
		/*new Float: x, Float: y, Float: z;
		//new lstr[1024];

		GetPlayerPos(playerid, x, y, z);

		UpperToLower(text);*/
	 	//Error(playerid, "This server is voice only");
	 	
		/*else if(IsPlayerInRangeOfPoint(playerid, 50, 2184.32, -1023.32, 1018.68))
		{
			if(pData[playerid][pAdmin] < 1)
			{
				format(lstr, sizeof(lstr), "[OOC ZONE] %s: (( %s ))", ReturnName(playerid), text);
				ProxDetector(40, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
			}
			else if(pData[playerid][pAdmin] > 1 || pData[playerid][pHelper] > 1)
			{
				format(lstr, sizeof(lstr), "[OOC ZONE] %s: %s", pData[playerid][pAdminname], text);
				ProxDetector(40, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
			}
		}*/
		return 0;
	}
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if (result == -1)
    {
        //Error(playerid, "command '/%s' does not exist use '/help' for list command.", cmd);
        /*pData[playerid][pInfo] += 1;
        if(pData[playerid][pInfo] == 1)
		{
		    pData[playerid][pInfo1] = 1;
		}
		if(pData[playerid][pInfo] == 2)
		{
		    pData[playerid][pInfo2] = 1;
		}
		if(pData[playerid][pInfo] == 3)
		{
		    pData[playerid][pInfo3] = 1;
		}
		if(pData[playerid][pInfo] == 4)
		{
		    pData[playerid][pInfo4] = 1;
		}
		SetTimerEx("Notifshow", 100, false, "i", playerid);*/
		SyntaxMsg(playerid,"Unknown_Command_Please_/help");
        return 1;
    }
	new str[150];
	format(str,sizeof(str),"[CMD] %s: [%s] [%s]", GetRPName(playerid), cmd, params);
	LogServer("Command", str);
	printf(str);
    return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	return 1;
}


public OnPlayerConnect(playerid)
{	

    pData[playerid][pOranggeledah] = -1;
//	TextDrawShowForPlayer(playerid, TextTime);
	new PlayerIP[16], country[MAX_COUNTRY_LENGTH], city[MAX_CITY_LENGTH];
	g_MysqlRaceCheck[playerid]++;
	pemainic++;
	ResetVariables(playerid);
	pasien = -1;
//	ResetPlayerPhone(playerid);
	//rob
	EnablePlayerCameraTarget(playerid, 1);
		GenerateInterface(playerid);
	RemoveMappingGreenland(playerid);
	CreatePlayerTextDraws(playerid);
	CreatePlayerInventoryTD(playerid);
	CreateInventoryTD(playerid);
	pData[playerid][pKantong] = -1;
	/*LagiKerja[playerid] = false;
	Kurir[playerid] = false;
	angkatBox[playerid] = false;*/
	pData[playerid][pIdlabel] = CreateDynamic3DTextLabel("", COLOR_WHITE, 0.0, 0.0, -0.3, 1.0, .attachedplayer = playerid, .testlos = 0);
	SetPlayerMapIcon(playerid, 12, 1001.29,-1356.507,12.992, 51 , 0, MAPICON_LOCAL); // ICON TRUCKER
	
	//cctv
	Spawned[playerid] = 0;
    CurrentCCTV[playerid] = -1;
	//fly
    // Reset the data belonging to this player slot
	noclipdata[playerid][cameramode] 	= CAMERA_MODE_NONE;
	noclipdata[playerid][lrold]	   	 	= 0;
	noclipdata[playerid][udold]   		= 0;
	noclipdata[playerid][mode]   		= 0;
	noclipdata[playerid][lastmove]   	= 0;
	noclipdata[playerid][accelmul]   	= 0.0;
	//
	GetPlayerName(playerid, pData[playerid][pUCP], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
	InterpolateCameraPos(playerid, 1429.946655, -1597.120483, 41, 2098.130615, -1775.991210, 41.111639, 50000);
	InterpolateCameraLookAt(playerid, 247.605590, -1841.989990, 39.802570, 817.645996, -1645.395751, 29.292520, 15000);

	GetPlayerCountry(playerid, country, MAX_COUNTRY_LENGTH);
	GetPlayerCity(playerid, city, MAX_CITY_LENGTH);
	
	SetTimerEx("SafeLogin", 1000, 0, "i", playerid);
	
	//Prose Load Data
	new query[103];
	mysql_format(g_SQL, query, sizeof query, "SELECT * FROM `playerucp` WHERE `ucp` = '%e' LIMIT 1", pData[playerid][pUCP]);
	mysql_pquery(g_SQL, query, "OnPlayerDataLoaded", "dd", playerid, g_MysqlRaceCheck[playerid]);
	SetPlayerColor(playerid, COLOR_WHITE);

	foreach(new ii : Player)
	{
		if(pData[ii][pTogLog] == 0)
		{
			SendClientMessageEx(ii, -1, ""YELLOW_E"- {FFFFFF}%s {00FF00}connecting to server{FFFFFF}.", pData[playerid][pUCP]);
		}
	}
	
	pData[playerid][activitybar] = CreatePlayerProgressBar(playerid, 273.500000, 157.333541, 88.000000, 8.000000, 5930683, 100, 0);
	
	//HBE textdraw default
	pData[playerid][spdamagebar] = CreatePlayerProgressBar(playerid, 385.000000, 419.000000, 41.000000, 7.500000, -16776961, 1000.0, 0);
	pData[playerid][spfuelbar] = CreatePlayerProgressBar(playerid, 385.000000, 435.000000, 41.000000, 7.500000, -16776961, 1000.0, 0);
                
	pData[playerid][sphungrybar] = CreatePlayerProgressBar(playerid, 530.000000, 401.000000, 64.000000, 9.500000, 852308735, 100.0, 0);
	pData[playerid][spenergybar] = CreatePlayerProgressBar(playerid, 530.000000, 425.000000, 64.000000, 9.500000, 1687547391, 100.0, 0);
	
	//HBE textdraw Simple
	pData[playerid][HEALTHBAR] = CreatePlayerProgressBar(playerid, 504.000000, 417.500000, 48.000000, 5.000000, -21557249, 1000.0, 0);
	pData[playerid][FUELBAR] = CreatePlayerProgressBar(playerid, 504.000000, 434.500000, 48.000000, 5.000000, -21557249, 1000.0, 0);

	pData[playerid][FOODPROGRESS] = CreatePlayerProgressBar(playerid, 580.000000, 417.500000, 48.000000, 5.000000, -21557249, 100.0, 0);
	pData[playerid][DRINKPROGRESS] = CreatePlayerProgressBar(playerid, 580.000000, 434.500000, 48.000000, 5.000000, -21557249, 100.0, 0);
	
	
	pData[playerid][pInjuredLabel] = CreateDynamic3DTextLabel("", COLOR_ORANGE, 0.0, 0.0, -0.3, 10, .attachedplayer = playerid, .testlos = 1);
	
	pData[playerid][pGeledahLabel] = CreateDynamic3DTextLabel("", COLOR_ORANGE, 0.0, 0.0, -0.3, 10, .attachedplayer = playerid, .testlos = 1);

    if(pData[playerid][pHead] < 0) return pData[playerid][pHead] = 20;

    if(pData[playerid][pPerut] < 0) return pData[playerid][pPerut] = 20;

    if(pData[playerid][pRFoot] < 0) return pData[playerid][pRFoot] = 20;

    if(pData[playerid][pLFoot] < 0) return pData[playerid][pLFoot] = 20;

    if(pData[playerid][pLHand] < 0) return pData[playerid][pLHand] = 20;
   
    if(pData[playerid][pRHand] < 0) return pData[playerid][pRHand] = 20;
    
    SelectInventory[playerid] = -1;
	AmmountInventory[playerid] = 1;
	for(new i = 0; i<MAX_INVENTORY; i++)
	{
		InventoryData[playerid][i][invExists] = false;
		InventoryData[playerid][i][invModel] = 19300;
		InventoryData[playerid][i][invSlot] = -1;
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{

	pData[playerid][pOranggeledah] = -1;
    //
    	GenerateInterface(playerid, false);
	pemainic--;
	DestroyVehicle(Bus[playerid]);
	SetPlayerName(playerid, pData[playerid][pUCP]);
	//Pengganti IsValidTimer
	pData[playerid][pLoginUcp] = 0;
	pData[playerid][pProductingStatus] = 0;
	pData[playerid][pCookingStatus] = 0;
	pData[playerid][pMechanicStatus] = 0;
	pData[playerid][pActivityStatus] = 0;
	pData[playerid][pArmsDealerStatus] = 0;
	pData[playerid][pForklifterLoadStatus] = 0;
	pData[playerid][pForklifterUnLoadStatus] = 0;
	pData[playerid][pFillStatus] = 0;
	pData[playerid][pCheckingBis] = 0;
	pData[playerid][pHBEMode] = 1;
	pData[playerid][pTargetPv] = -1;
	pData[playerid][pProsesBorax] = 0;
	pData[playerid][pGetBorax] = 0;
	
	//cctv
	if(CurrentCCTV[playerid] > -1)
	{
	    KillTimer(KeyTimer[playerid]);
	    TextDrawHideForPlayer(playerid, TD);
	}
	CurrentCCTV[playerid] = -1;
	//tentara

	 
	//breaking
	if(pData[playerid][pBreaking])
	{
	    new vehid = pData[playerid][pTargetPv];
	    pvData[vehid][cBreaken] = INVALID_PLAYER_ID;
	    pvData[vehid][cBreaking] = 0;
	}

	DestroyDynamic3DTextLabel(pData[playerid][pInjuredLabel]);
	DestroyDynamic3DTextLabel(pData[playerid][pGeledahLabel]);
	if(pData[playerid][pMaskOn])
       Delete3DTextLabel(pData[playerid][pNameTag]);
	pData[playerid][pDriveLicApp] = 0;
	pData[playerid][pSpawnList] = 0;
	takingselfie[playerid] = 0;
	killgr(playerid);
	//KillTimer(Unload_Timer[playerid]);
	
	if(IsPlayerInAnyVehicle(playerid))
	{
        RemovePlayerFromVehicle(playerid);
    }
	for(new i; i <= 9; i++)
	{
		if(MyBaggage[playerid][i] == true)
		{
		    MyBaggage[playerid][i] = false;
		    DialogBaggage[i] = false;
			if(IsValidVehicle(pData[playerid][pTrailerBaggage]))
		    	DestroyVehicle(pData[playerid][pTrailerBaggage]);  //jika player disconnect maka trailer akan kembali seperti awal
		}
    }
    if(GetPVarType(playerid, "PlacedBB"))
    {
        DestroyDynamicObject(GetPVarInt(playerid, "PlacedBB"));
        DestroyDynamic3DTextLabel(STREAMER_TAG_3D_TEXT_LABEL:GetPVarInt(playerid, "BBLabel"));
        if(GetPVarType(playerid, "BBArea"))
        {
            foreach(new i : Player)
            {
                if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
                {
                    StopAudioStreamForPlayer(i);
                    SendClientMessage(i, COLOR_PURPLE, " The boombox creator has disconnected from the server.");
                }
            }
        }
    }
	//UpdateWeapons(playerid);
	g_MysqlRaceCheck[playerid]++;
	if(pData[playerid][IsLoggedIn] == true)
	{
		if(IsAtEvent[playerid] == 0)
		{
			UpdatePlayerData(playerid);
		}
		Report_Clear(playerid);
		Ask_Clear(playerid);
		RemovePlayerVehicle(playerid);
		Player_ResetMining(playerid);
		Player_ResetCutting(playerid);
		Player_RemoveLumber(playerid);
		Player_ResetHarvest(playerid);
		KillTazerTimer(playerid);
		if(IsValidVehicle(pData[playerid][pTrailer]))
			DestroyVehicle(pData[playerid][pTrailer]);

		pData[playerid][pTrailer] = INVALID_VEHICLE_ID;
		if(IsAtEvent[playerid] == 1)
		{
			if(GetPlayerTeam(playerid) == 1)
			{
				if(EventStarted == 1)
				{
					RedTeam -= 1;
					foreach(new ii : Player)
					{
						if(GetPlayerTeam(ii) == 2)
						{
							GivePlayerMoneyEx(ii, EventPrize);
							Servers(ii, "Selamat, Tim Anda berhasil memenangkan Event dan Mendapatkan Hadiah $%d per orang", EventPrize);
							SetPlayerPos(ii, pData[ii][pPosX], pData[ii][pPosY], pData[ii][pPosZ]);
							pData[playerid][pHospital] = 0;
							ClearAnimations(ii);
							BlueTeam = 0;
						}
						else if(GetPlayerTeam(ii) == 1)
						{
							Servers(ii, "Maaf, Tim anda sudah terkalahkan, Harap Coba Lagi lain waktu");
							SetPlayerPos(ii, pData[ii][pPosX], pData[ii][pPosY], pData[ii][pPosZ]);
							pData[playerid][pHospital] = 0;
							ClearAnimations(ii);
							RedTeam = 0;
						}
					}
				}
			}
			if(GetPlayerTeam(playerid) == 2)
			{
				if(EventStarted == 1)
				{
					BlueTeam -= 1;
					foreach(new ii : Player)
					{
						if(GetPlayerTeam(ii) == 1)
						{
							GivePlayerMoneyEx(ii, EventPrize);
							Servers(ii, "Selamat, Tim Anda berhasil memenangkan Event dan Mendapatkan Hadiah $%d per orang", EventPrize);
							SetPlayerPos(ii, pData[ii][pPosX], pData[ii][pPosY], pData[ii][pPosZ]);
							pData[playerid][pHospital] = 0;
							ClearAnimations(ii);
							BlueTeam = 0;
						}
						else if(GetPlayerTeam(ii) == 2)
						{
							Servers(ii, "Maaf, Tim anda sudah terkalahkan, Harap Coba Lagi lain waktu");
							SetPlayerPos(ii, pData[ii][pPosX], pData[ii][pPosY], pData[ii][pPosZ]);
							pData[playerid][pHospital] = 0;
							ClearAnimations(ii);
							BlueTeam = 0;
						}
					}
				}
			}
			SetPlayerTeam(playerid, 0);
			IsAtEvent[playerid] = 0;
			pData[playerid][pInjured] = 0;
			pData[playerid][pSpawned] = 1;
			UpdateDynamic3DTextLabelText(pData[playerid][pInjuredLabel], COLOR_ORANGE, "");
		}
		if(pData[playerid][pRobLeader] == 1)
		{
			foreach(new ii : Player) 
			{
				if(pData[ii][pMemberRob] > 1)
				{
					Servers(ii, "* Pemimpin Perampokan anda telah keluar! [ MISI GAGAL ]");
					pData[ii][pMemberRob] = 0;
					RobMember = 0;
					pData[ii][pRobLeader] = 0;
					ServerMoney += robmoney;
				}
			}
		}
		if(pData[playerid][pMemberRob] == 1)
		{
			pData[playerid][pMemberRob] = 0;
			foreach(new ii : Player) 
			{
				if(pData[ii][pRobLeader] > 1)
				{
					Servers(ii, "* Member berkurang 1");
					pData[ii][pMemberRob] -= 1;
					RobMember -= 1;
				}
			}
		}
	}
	
	if(IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
            DestroyDynamic3DTextLabel(pData[playerid][pAdoTag]);

    if(IsValidDynamic3DTextLabel(pData[playerid][pBTag]))
            DestroyDynamic3DTextLabel(pData[playerid][pBTag]);
			
	if(IsValidDynamicObject(pData[playerid][pFlare]))
            DestroyDynamicObject(pData[playerid][pFlare]);
    
    if(pData[playerid][pMaskOn] == 1)
            DestroyDynamic3DTextLabel(pData[playerid][pMaskLabel]);

    pData[playerid][pAdoActive] = false;

	if (pData[playerid][LoginTimer])
	{
		KillTimer(pData[playerid][LoginTimer]);
		pData[playerid][LoginTimer] = 0;
	}

	pData[playerid][IsLoggedIn] = false;
	
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	
	foreach(new ii : Player)
	{
		if(IsPlayerInRangeOfPoint(ii, 40.0, x, y, z))
		{
			switch(reason)
			{
				case 0:
				{
					SendClientMessageEx(ii, COLOR_RED, ""WHITE_E"%s "LG_E"disconnected from the server.{7fffd4}(FC/Crash/Timeout)", pData[playerid][pName]);
				}
				case 1:
				{
					SendClientMessageEx(ii, COLOR_RED, ""WHITE_E"%s "LG_E"disconnected from the server.{7fffd4}(Disconnected)", pData[playerid][pName]);
				}
				case 2:
				{
					SendClientMessageEx(ii, COLOR_RED, ""WHITE_E"%s "LG_E"disconnected from the server.{7fffd4}(Kick/Banned)", pData[playerid][pName]);
				}
			}
		}
	}
	new reasontext[526];
	switch(reason)
	{
	    case 0: reasontext = "Timeout/ Crash";
	    case 1: reasontext = "Quit";
	    case 2: reasontext = "Kicked/ Banned";
	}
    	
	new dc[1000];
	format(dc, sizeof(dc),  "%s has left the server.", pData[playerid][pName]);
//	SendDiscordMessage(0, dc);
	new DCC_Embed:embed = DCC_CreateEmbed(.title= dc);
	new str1[1000], str2[1000];

	//format(str1, sizeof str1, params);
	new DCC_Channel:channelid;
	channelid = DCC_FindChannelById("1077368936334635008");
	format(str1, sizeof str1, "Reason : %s\nInformasi %s\nRegister Id: %d\nIp : %s\nNama Ucp : %s", reasontext, pData[playerid][pName], pData[playerid][pID], pData[playerid][pIP], pData[playerid][pUCP]);
	DCC_SetEmbedDescription(embed, str1);
	DCC_SetEmbedColor(embed, 0xff0000);
	new yearss, monthh, dayy, timestamp[20];
   	getdate(yearss, monthh , dayy);
    format(timestamp, sizeof(timestamp), "%02i%02i%02i", yearss, monthh, dayy);
    DCC_SetEmbedTimestamp(embed, timestamp);
    DCC_SetEmbedFooter(embed, "HOFFENTLICH ROLEPLAY");
	DCC_SendChannelEmbedMessage(channelid, embed);
	return 1;
}


public OnPlayerSpawn(playerid)
{
	StopAudioStreamForPlayer(playerid);
	SetPlayerInterior(playerid, pData[playerid][pInt]);
	SetPlayerVirtualWorld(playerid, pData[playerid][pWorld]);
	SetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
	SetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 0);
	SetPlayerSpawn(playerid);
	LoadAnims(playerid);
	pData[playerid][pOffertiket] = -1;
	//cctv
	Spawned[playerid] = 1;
	pData[playerid][pDarahorang] = -1;
	//
	SetPlayerSkillLevel(playerid, WEAPON_COLT45, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SILENCED, 1);
	SetPlayerSkillLevel(playerid, WEAPON_DEAGLE, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SHOTGUN, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SAWEDOFF, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SHOTGSPA, 1);
	SetPlayerSkillLevel(playerid, WEAPON_UZI, 1);
	SetPlayerSkillLevel(playerid, WEAPON_MP5, 1);
	SetPlayerSkillLevel(playerid, WEAPON_AK47, 1);
	SetPlayerSkillLevel(playerid, WEAPON_M4, 1);
	SetPlayerSkillLevel(playerid, WEAPON_TEC9, 1);
	SetPlayerSkillLevel(playerid, WEAPON_RIFLE, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SNIPER, 1);
	return 1;
}

SetPlayerSpawn(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(pData[playerid][pGender] == 0)
		{
			TogglePlayerControllable(playerid,0);
			SetPlayerHealth(playerid, 100.0);
			SetPlayerArmour(playerid, 0.0);
			SetPlayerPos(playerid, 1716.1129, -1880.0715, -10.0);
			SetPlayerCameraPos(playerid,1429.946655, -1597.120483, 41);
			SetPlayerCameraLookAt(playerid,247.605590, -1841.989990, 39.802570);
			SetPlayerVirtualWorld(playerid, 0);
			ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Masukan tanggal lahir\n(Tgl/Bulan/Tahun)\nMisal : 15/04/1998", "Enter", "Batal");
		}
		else
		{
			SetPlayerColor(playerid, COLOR_WHITE);
			if(pData[playerid][pHBEMode] == 1) //simple
			{
			    for(new i = 0; i < 25; i++)
				{
					UpdatePlayerHBE(playerid);
					PlayerTextDrawShow(playerid, HBEFIVEM[playerid][i]);
					PlayerTextDrawShow(playerid, BarDarah[playerid]);
					PlayerTextDrawShow(playerid, BarArmor[playerid]);
					PlayerTextDrawShow(playerid, BarMakan[playerid]);
					PlayerTextDrawShow(playerid, BarMinum[playerid]);
					PlayerTextDrawShow(playerid, BarPusing[playerid]);
					PlayerTextDrawShow(playerid, VOICE_1[playerid]);
					PlayerTextDrawShow(playerid, VOICE_2[playerid]);
				}
			}
			else
			{

			}
			PlayerTextDrawShow(playerid, Logohope[playerid][4]);
			PlayerTextDrawShow(playerid, Logohope[playerid][5]);
			PlayerTextDrawShow(playerid, Logohope[playerid][6]);
			PlayerTextDrawShow(playerid, Logohope[playerid][7]);
			PlayerTextDrawShow(playerid, Logohope[playerid][8]);
			PlayerTextDrawShow(playerid, Logohope[playerid][9]);
			PlayerTextDrawShow(playerid, Logohope[playerid][10]);
			PlayerTextDrawShow(playerid, Logohope[playerid][11]);
			PlayerTextDrawShow(playerid, Logohope[playerid][12]);
			PlayerTextDrawShow(playerid, Logohope[playerid][13]);
			PlayerTextDrawShow(playerid, Logohope[playerid][14]);
			PlayerTextDrawShow(playerid, Logohope[playerid][15]);
			PlayerTextDrawShow(playerid, Logohope[playerid][16]);
			PlayerTextDrawShow(playerid, Logohope[playerid][17]);
			PlayerTextDrawShow(playerid, Logohope[playerid][18]);
			PlayerTextDrawShow(playerid, Logohope[playerid][19]);
			PlayerTextDrawShow(playerid, Logohope[playerid][20]);
			//TextDrawShowForPlayer(playerid, KKRP);
			for(new i = 0; i < 5; i++) 
			{
				TextDrawHideForPlayer(playerid, WelcomeTD[i]);
			}

			CheckPlayerSpawn3Titik(playerid);
			SetPlayerSkin(playerid, pData[playerid][pSkin]);
			if(pData[playerid][pOnDuty] >= 1)
			{
				SetPlayerSkin(playerid, pData[playerid][pFacSkin]);
				SetFactionColor(playerid);
			}
			if(pData[playerid][pAdminDuty] > 0)
			{
				SetPlayerColor(playerid, COLOR_RED);
			}
			SetTimerEx("SpawnTimer", 6000, false, "i", playerid);
		}
	}
}

public OnPlayerRequestClass(playerid, classid)
{
    SetPlayerCameraPos(playerid,1429.946655, -1597.120483, 41);
	SetPlayerCameraLookAt(playerid,247.605590, -1841.989990, 39.802570);
	InterpolateCameraPos(playerid, 1429.946655, -1597.120483, 41, 2098.130615, -1775.991210, 41.111639, 50000);
	InterpolateCameraLookAt(playerid, 247.605590, -1841.989990, 39.802570, 817.645996, -1645.395751, 29.292520, 15000);
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	/*Info(playerid, "{ff0000}Jangan di pencet spawn bang!!!");
	KickEx(playerid);*/
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	DeletePVar(playerid, "UsingSprunk");
	SetPVarInt(playerid, "GiveUptime", -1);
	pData[playerid][pSpawned] = 0;
	Player_ResetCutting(playerid);
	Player_RemoveLumber(playerid);
	Player_ResetMining(playerid);
	Player_ResetHarvest(playerid);
	
	//tentara

	
		
	//	DisablePlayerCheckpoint(playerid);


	 //
	pData[playerid][CarryProduct] = 0;
	pData[playerid][pProductingStatus] = 0;
	pData[playerid][pCookingStatus] = 0;
	pData[playerid][pMechanicStatus] = 0;
	pData[playerid][pActivityStatus] = 0;
	pData[playerid][pArmsDealerStatus] = 0;
	pData[playerid][pForklifterLoadStatus] = 0;
	pData[playerid][pForklifterUnLoadStatus] = 0;
	pData[playerid][pFillStatus] = 0;
	pData[playerid][pCheckingBis] = 0;
	
	KillTimer(pData[playerid][pActivity]);
	KillTimer(pData[playerid][pMechanic]);
	KillTimer(pData[playerid][pProducting]);
	KillTimer(pData[playerid][pCooking]);
	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
	PlayerTextDrawHide(playerid, ActiveTD[playerid]);
	pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
	pData[playerid][pActivityTime] = 0;
	
	pData[playerid][pMechDuty] = 0;
	pData[playerid][pTaxiDuty] = 0;
	pData[playerid][pMission] = -1;
	
	pData[playerid][pSideJob] = 0;
	DisablePlayerCheckpoint(playerid);
	DisablePlayerRaceCheckpoint(playerid);
	SetPlayerColor(playerid, COLOR_WHITE);
	RemovePlayerAttachedObject(playerid, 9);
	GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
	foreach(new ii : Player)
    {
        if(pData[ii][pAdmin] > 0)
        {
            SendDeathMessageToPlayer(ii, killerid, playerid, reason);
			new dc[1280];
   			new lokasi[MAX_ZONE_NAME];
   			GetPlayer2DZone(playerid, lokasi, MAX_ZONE_NAME);
			//SendFactionMessage(3, ARWIN, "[SAMD KILL LOGS] {ffffff}Player %s[%d] down please respond samd, location %s", GetRPName(playerid), playerid, lokasi);
			SendFactionMessage(1, COLOR_RED, "[SAPD KILL LOGS] {FFFFFF}%s[%d] killed by %s[%d] weapon %s, location %s", GetRPName(playerid), playerid, GetRPName(killerid), killerid, ReturnWeaponName(reason), lokasi);
			format(dc, sizeof(dc),  "%s[UCP: %s] :skull_crossbones: %s[UCP: %s] :gun: %s", GetRPName(killerid), pData[killerid][pUCP], GetRPName(playerid), pData[playerid][pUCP], ReturnWeaponName(reason));
			SendDiscordMessage(4, dc);	
			return 1;
        }
    }
    
   /* if(IsAtEvent[playerid] == 1)
    {
    	SetPlayerPos(playerid, 1474.65, -1736.36, 13.38);
    	SetPlayerVirtualWorld(playerid, 0);
    	SetPlayerInterior(playerid, 0);
    	ClearAnimations(playerid);
    	ResetPlayerWeaponsEx(playerid);
       	SetPlayerColor(playerid, COLOR_WHITE);
    	if(GetPlayerTeam(playerid) == 1)
    	{
    		Servers(playerid, "Anda sudah terkalahkan");
    		RedTeam -= 1;
    	}
    	else if(GetPlayerTeam(playerid) == 2)
    	{
    		Servers(playerid, "Anda sudah terkalahkan");
    		BlueTeam -= 1;
    	}
    	if(BlueTeam == 0)
    	{
    		foreach(new ii : Player)
    		{
    			if(GetPlayerTeam(ii) == 1)
    			{
    				GivePlayerMoneyEx(ii, EventPrize);
    				Servers(ii, "Selamat, Tim Anda berhasil memenangkan Event dan Mendapatkan Hadiah $%d per orang", EventPrize);
    				pData[playerid][pHospital] = 0;
    				ClearAnimations(ii);
    				BlueTeam = 0;
    			}
    			else if(GetPlayerTeam(ii) == 2)
    			{
    				Servers(ii, "Maaf, Tim anda sudah terkalahkan, Harap Coba Lagi lain waktu");
    				pData[playerid][pHospital] = 0;
    				ClearAnimations(ii);
    				BlueTeam = 0;
    			}
    		}
    	}
    	if(RedTeam == 0)
    	{
    		foreach(new ii : Player)
    		{
    			if(GetPlayerTeam(ii) == 2)
    			{
    				GivePlayerMoneyEx(ii, EventPrize);
    				Servers(ii, "Selamat, Tim Anda berhasil memenangkan Event dan Mendapatkan Hadiah $%d per orang", EventPrize);
    				pData[playerid][pHospital] = 0;
    				ClearAnimations(ii);
    				BlueTeam = 0;
    			}
    			else if(GetPlayerTeam(ii) == 1)
    			{
    				Servers(ii, "Maaf, Tim anda sudah terkalahkan, Harap Coba Lagi lain waktu");
    				pData[playerid][pHospital] = 0;
    				ClearAnimations(ii);
    				RedTeam = 0;
    			}
    		}
    	}
    	SetPlayerTeam(playerid, 0);
    	IsAtEvent[playerid] = 0;
    	pData[playerid][pInjured] = 0;
    	pData[playerid][pSpawned] = 1;
		UpdateDynamic3DTextLabelText(pData[playerid][pInjuredLabel], COLOR_ORANGE, "");
    }*/
    
    if(IsAtEvent[playerid] == 0)
    {
    	new asakit = RandomEx(0, 5);
    	new bsakit = RandomEx(0, 9);
    	new csakit = RandomEx(0, 7);
    	new dsakit = RandomEx(0, 6);
    	pData[playerid][pLFoot] -= dsakit;
    	pData[playerid][pLHand] -= bsakit;
    	pData[playerid][pRFoot] -= csakit;
    	pData[playerid][pRHand] -= dsakit;
    	pData[playerid][pHead] -= asakit;
    }
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ,Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	new weaponid = EditingWeapon[playerid];
    if(weaponid)
    {
        if(response == 1)
        {
            new enum_index = weaponid - 22, weaponname[18], string[340];
 
            GetWeaponName(weaponid, weaponname, sizeof(weaponname));
           
            WeaponSettings[playerid][enum_index][Position][0] = fOffsetX;
            WeaponSettings[playerid][enum_index][Position][1] = fOffsetY;
            WeaponSettings[playerid][enum_index][Position][2] = fOffsetZ;
            WeaponSettings[playerid][enum_index][Position][3] = fRotX;
            WeaponSettings[playerid][enum_index][Position][4] = fRotY;
            WeaponSettings[playerid][enum_index][Position][5] = fRotZ;
 
            RemovePlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid));
            SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][enum_index][Bone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, 1.0, 1.0, 1.0);
 
            Servers(playerid, "You have successfully adjusted the position of your %s.", weaponname);
           
            mysql_format(g_SQL, string, sizeof(string), "INSERT INTO weaponsettings (Owner, WeaponID, PosX, PosY, PosZ, RotX, RotY, RotZ) VALUES ('%d', %d, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f) ON DUPLICATE KEY UPDATE PosX = VALUES(PosX), PosY = VALUES(PosY), PosZ = VALUES(PosZ), RotX = VALUES(RotX), RotY = VALUES(RotY), RotZ = VALUES(RotZ)", pData[playerid][pID], weaponid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ);
            mysql_tquery(g_SQL, string);
        }
		else if(response == 0)
		{
			new enum_index = weaponid - 22;
			SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][enum_index][Bone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, 1.0, 1.0, 1.0);
		}
        EditingWeapon[playerid] = 0;
		return 1;
    }
	else
	{
		if(response == 1)
		{
			InfoTD_MSG(playerid, 4000, "~g~~h~Toy Position Updated~y~!");

			pToys[playerid][index][toy_x] = fOffsetX;
			pToys[playerid][index][toy_y] = fOffsetY;
			pToys[playerid][index][toy_z] = fOffsetZ;
			pToys[playerid][index][toy_rx] = fRotX;
			pToys[playerid][index][toy_ry] = fRotY;
			pToys[playerid][index][toy_rz] = fRotZ;
			pToys[playerid][index][toy_sx] = fScaleX;
			pToys[playerid][index][toy_sy] = fScaleY;
			pToys[playerid][index][toy_sz] = fScaleZ;
			
			MySQL_SavePlayerToys(playerid);
		}
		else if(response == 0)
		{
			InfoTD_MSG(playerid, 4000, "~r~~h~Selection Cancelled~y~!");

			SetPlayerAttachedObject(playerid,
				index,
				modelid,
				boneid,
				pToys[playerid][index][toy_x],
				pToys[playerid][index][toy_y],
				pToys[playerid][index][toy_z],
				pToys[playerid][index][toy_rx],
				pToys[playerid][index][toy_ry],
				pToys[playerid][index][toy_rz],
				pToys[playerid][index][toy_sx],
				pToys[playerid][index][toy_sy],
				pToys[playerid][index][toy_sz]);
		}
		SetPVarInt(playerid, "UpdatedToy", 1);
		TogglePlayerControllable(playerid, true);
	}
	return 1;
}

public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT: objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(pData[playerid][EditingTreeID] != -1 && Iter_Contains(Trees, pData[playerid][EditingTreeID]))
	{
	    if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingTreeID];
	        TreeData[etid][treeX] = x;
	        TreeData[etid][treeY] = y;
	        TreeData[etid][treeZ] = z;
	        TreeData[etid][treeRX] = rx;
	        TreeData[etid][treeRY] = ry;
	        TreeData[etid][treeRZ] = rz;

	        SetDynamicObjectPos(objectid, TreeData[etid][treeX], TreeData[etid][treeY], TreeData[etid][treeZ]);
	        SetDynamicObjectRot(objectid, TreeData[etid][treeRX], TreeData[etid][treeRY], TreeData[etid][treeRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[etid][treeLabel], E_STREAMER_X, TreeData[etid][treeX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[etid][treeLabel], E_STREAMER_Y, TreeData[etid][treeY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[etid][treeLabel], E_STREAMER_Z, TreeData[etid][treeZ] + 1.5);

		    Tree_Save(etid);
	        pData[playerid][EditingTreeID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingTreeID];
	        SetDynamicObjectPos(objectid, TreeData[etid][treeX], TreeData[etid][treeY], TreeData[etid][treeZ]);
	        SetDynamicObjectRot(objectid, TreeData[etid][treeRX], TreeData[etid][treeRY], TreeData[etid][treeRZ]);
	        pData[playerid][EditingTreeID] = -1;
	    }
	}
	if(pData[playerid][EditingOreID] != -1 && Iter_Contains(Ores, pData[playerid][EditingOreID]))
	{
	    if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingOreID];
	        OreData[etid][oreX] = x;
	        OreData[etid][oreY] = y;
	        OreData[etid][oreZ] = z;
	        OreData[etid][oreRX] = rx;
	        OreData[etid][oreRY] = ry;
	        OreData[etid][oreRZ] = rz;

	        SetDynamicObjectPos(objectid, OreData[etid][oreX], OreData[etid][oreY], OreData[etid][oreZ]);
	        SetDynamicObjectRot(objectid, OreData[etid][oreRX], OreData[etid][oreRY], OreData[etid][oreRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, OreData[etid][oreLabel], E_STREAMER_X, OreData[etid][oreX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, OreData[etid][oreLabel], E_STREAMER_Y, OreData[etid][oreY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, OreData[etid][oreLabel], E_STREAMER_Z, OreData[etid][oreZ] + 1.5);

		    Ore_Save(etid);
	        pData[playerid][EditingOreID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingOreID];
	        SetDynamicObjectPos(objectid, OreData[etid][oreX], OreData[etid][oreY], OreData[etid][oreZ]);
	        SetDynamicObjectRot(objectid, OreData[etid][oreRX], OreData[etid][oreRY], OreData[etid][oreRZ]);
	        pData[playerid][EditingOreID] = -1;
	    }
	}
	if(pData[playerid][EditingATMID] != -1 && Iter_Contains(ATMS, pData[playerid][EditingATMID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingATMID];
	        AtmData[etid][atmX] = x;
	        AtmData[etid][atmY] = y;
	        AtmData[etid][atmZ] = z;
	        AtmData[etid][atmRX] = rx;
	        AtmData[etid][atmRY] = ry;
	        AtmData[etid][atmRZ] = rz;

	        SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
	        SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_X, AtmData[etid][atmX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_Y, AtmData[etid][atmY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_Z, AtmData[etid][atmZ] + 0.3);

		    Atm_Save(etid);
	        pData[playerid][EditingATMID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingATMID];
	        SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
	        SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);
	        pData[playerid][EditingATMID] = -1;
	    }
	}
	if(pData[playerid][EditingVtoys] != -1)
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	    	new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0, false);
	        new vehid = pvData[vehicleid][cVeh];
	        new idxs = pvData[vehid][vtoySelected];
	        vtData[vehid][idxs][vtoy_x] = x;
	        vtData[vehid][idxs][vtoy_y] = y;
	        vtData[vehid][idxs][vtoy_z] = z;
	        vtData[vehid][idxs][vtoy_rx] = rx;
	        vtData[vehid][idxs][vtoy_ry] = ry;
	        vtData[vehid][idxs][vtoy_rz] = rz;

	        SetDynamicObjectPos(objectid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z]);
	        SetDynamicObjectRot(objectid, vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);

		    MySQL_SaveVehicleToys(vehicleid);
	        pData[playerid][EditingVtoys] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new vehid = pData[playerid][EditingVtoys];
	        new idxs = pvData[vehid][vtoySelected];
	        SetDynamicObjectPos(objectid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z]);
	        SetDynamicObjectRot(objectid, vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
	    	pData[playerid][EditingVtoys] = -1;
	    }
	}
	if(pData[playerid][EditingVending] != -1 && Iter_Contains(Vendings, pData[playerid][EditingVending]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new venid = pData[playerid][EditingVending];
	        VendingData[venid][vendingX] = x;
	        VendingData[venid][vendingY] = y;
	        VendingData[venid][vendingZ] = z;
	        VendingData[venid][vendingRX] = rx;
	        VendingData[venid][vendingRY] = ry;
	        VendingData[venid][vendingRZ] = rz;

	        SetDynamicObjectPos(objectid, VendingData[venid][vendingX], VendingData[venid][vendingY], VendingData[venid][vendingZ]);
	        SetDynamicObjectRot(objectid, VendingData[venid][vendingRX], VendingData[venid][vendingRY], VendingData[venid][vendingRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, VendingData[venid][vendingText], E_STREAMER_X, VendingData[venid][vendingX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, VendingData[venid][vendingText], E_STREAMER_Y, VendingData[venid][vendingY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, VendingData[venid][vendingText], E_STREAMER_Z, VendingData[venid][vendingZ] + 0.3);

		    Vending_Save(venid);
	        pData[playerid][EditingVending] = -1;
	    }
	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new venid = pData[playerid][EditingVending];
	        SetDynamicObjectPos(objectid, VendingData[venid][vendingX], VendingData[venid][vendingY], VendingData[venid][vendingZ]);
	        SetDynamicObjectRot(objectid, VendingData[venid][vendingRX], VendingData[venid][vendingRY], VendingData[venid][vendingRZ]);
	    	pData[playerid][EditingVending] = -1;
	    }
	}
	if(pData[playerid][gEditID] != -1 && Iter_Contains(Gates, pData[playerid][gEditID]))
	{
		new id = pData[playerid][gEditID];
		if(response == EDIT_RESPONSE_UPDATE)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
		}
		else if(response == EDIT_RESPONSE_CANCEL)
		{
			SetDynamicObjectPos(objectid, gPosX[playerid], gPosY[playerid], gPosZ[playerid]);
			SetDynamicObjectRot(objectid, gRotX[playerid], gRotY[playerid], gRotZ[playerid]);
			gPosX[playerid] = 0; gPosY[playerid] = 0; gPosZ[playerid] = 0;
			gRotX[playerid] = 0; gRotY[playerid] = 0; gRotZ[playerid] = 0;
			Servers(playerid, " You have canceled editing gate ID %d.", id);
			Gate_Save(id);
		}
		else if(response == EDIT_RESPONSE_FINAL)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
			if(pData[playerid][gEdit] == 1)
			{
				gData[id][gCX] = x;
				gData[id][gCY] = y;
				gData[id][gCZ] = z;
				gData[id][gCRX] = rx;
				gData[id][gCRY] = ry;
				gData[id][gCRZ] = rz;
				if(IsValidDynamic3DTextLabel(gData[id][gText])) DestroyDynamic3DTextLabel(gData[id][gText]);
				new str[64];
				format(str, sizeof(str), "Gate ID: %d", id);
				gData[id][gText] = CreateDynamic3DTextLabel(str, COLOR_WHITE, gData[id][gCX], gData[id][gCY], gData[id][gCZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
				
				pData[playerid][gEditID] = -1;
				pData[playerid][gEdit] = 0;
				Servers(playerid, " You have finished editing gate ID %d's closing position.", id);
				gData[id][gStatus] = 0;
				Gate_Save(id);
			}
			else if(pData[playerid][gEdit] == 2)
			{
				gData[id][gOX] = x;
				gData[id][gOY] = y;
				gData[id][gOZ] = z;
				gData[id][gORX] = rx;
				gData[id][gORY] = ry;
				gData[id][gORZ] = rz;
				
				pData[playerid][gEditID] = -1;
				pData[playerid][gEdit] = 0;
				Servers(playerid, " You have finished editing gate ID %d's opening position.", id);

				gData[id][gStatus] = 1;
				Gate_Save(id);
			}
		}
	}
	return 1;
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
	if(checkpointid == Mejajahit)
	{
	    PlayerTextDrawHide(playerid, OtotTD[playerid][0]);
		PlayerTextDrawHide(playerid, OtotTD[playerid][1]);
		PlayerTextDrawHide(playerid, OtotTD[playerid][2]);
		PlayerTextDrawHide(playerid, OtotTD[playerid][3]);
		PlayerTextDrawHide(playerid, OtotTD[playerid][4]);
		DeletePVar(playerid, "Mejajahit");
		
	}
	if(checkpointid == Dutyjahit)
	{
	    PlayerTextDrawHide(playerid, OtotTD[playerid][0]);
		PlayerTextDrawHide(playerid, OtotTD[playerid][1]);
		PlayerTextDrawHide(playerid, OtotTD[playerid][2]);
		PlayerTextDrawHide(playerid, OtotTD[playerid][3]);
		PlayerTextDrawHide(playerid, OtotTD[playerid][4]);
		DeletePVar(playerid, "Dutyjahit");

	}
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if(checkpointid == Ambiljob)
	{
	    callcmd::testjob(playerid, "");
	}
    if(checkpointid == BusCP)
	{
		Jembut(playerid, ":_For ~y~Spawn Bus", 5);
	}
	if(checkpointid == pData[playerid][LoadingPoint])
	{
	    if(GetPVarInt(playerid, "LoadingCooldown") > gettime()) return 1;
		new vehicleid = GetPVarInt(playerid, "LastVehicleID"), type[64], carid = -1;
		if(pData[playerid][CarryingLog] == 0)
		{
			type = "Metal";
		}
		else if(pData[playerid][CarryingLog] == 1)
		{
			type = "Coal";
		}
		else
		{
			type = "Unknown";
		}
		if(Vehicle_LogCount(vehicleid) >= LOG_LIMIT) return ErrorMsg(playerid, "You can't load any more ores to this vehicle.");
		if((carid = Vehicle_Nearest2(playerid)) != -1)
		{
			if(pData[playerid][CarryingLog] == 0)
			{
				pvData[carid][cMetal] += 1;
			}
			else if(pData[playerid][CarryingLog] == 1)
			{
				pvData[carid][cCoal] += 1;
			}
		}
		LogStorage[vehicleid][ pData[playerid][CarryingLog] ]++;
		Info(playerid, "MINING: Loaded %s.", type);
		ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
		Player_RemoveLog(playerid);
		return 1;
	}
	new Pesawat12;
	if(checkpointid == Pesawat12)
	{
	    if(pData[playerid][pFaction] == 8)
	    {
	    	PutPlayerInVehicle(playerid, pesawat[12], 1);
	  		SendClientMessageEx(playerid, -1, "Test");
		}
		else
	    {
	    	PutPlayerInVehicle(playerid, pesawat[12], 4);
	    	SendClientMessageEx(playerid, -1, "Test");
		}
	}
	if(checkpointid == Mejajahit)
	{
	    SetPVarInt(playerid, "Mejajahit", 1);
	    PlayerTextDrawShow(playerid, OtotTD[playerid][0]);
		PlayerTextDrawShow(playerid, OtotTD[playerid][1]);
		PlayerTextDrawShow(playerid, OtotTD[playerid][2]);
		PlayerTextDrawShow(playerid, OtotTD[playerid][3]);
		PlayerTextDrawShow(playerid, OtotTD[playerid][4]);
		new jahit[128];
		format(jahit, sizeof jahit, "to_make_fabric.");
		PlayerTextDrawSetString(playerid, OtotTD[playerid][4], jahit);
	}
	if(checkpointid == Dutyjahit)
	{
	    SetPVarInt(playerid, "Dutyjahit", 1);
	    PlayerTextDrawShow(playerid, OtotTD[playerid][0]);
		PlayerTextDrawShow(playerid, OtotTD[playerid][1]);
		PlayerTextDrawShow(playerid, OtotTD[playerid][2]);
		PlayerTextDrawShow(playerid, OtotTD[playerid][3]);
		PlayerTextDrawShow(playerid, OtotTD[playerid][4]);
		new jahit[128];
		format(jahit, sizeof jahit, "to_duty_seamstress.");
		PlayerTextDrawSetString(playerid, OtotTD[playerid][4], jahit);
	}
	if(checkpointid == ShowRoomCPRent)
	{
		new str[1024];
		format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days",
		GetVehicleModelName(414), 
		GetVehicleModelName(455), 
		GetVehicleModelName(456),
		GetVehicleModelName(498),
		GetVehicleModelName(499),
		GetVehicleModelName(609),
		GetVehicleModelName(478),
		GetVehicleModelName(422),
		GetVehicleModelName(543),
		GetVehicleModelName(554),
		GetVehicleModelName(525),
		GetVehicleModelName(438),
		GetVehicleModelName(420),
		GetVehicleModelName(422)
		);
		
		ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARS, DIALOG_STYLE_TABLIST_HEADERS, "Rent Job Cars", str, "Rent", "Close");
	}
	if(checkpointid == BajuElCorona)
	{
	    ShowPlayerDialog(playerid, DIALOG_SKINID, DIALOG_STYLE_INPUT, "Pakaian", "Masukkan ID Skin Yang Mau Digunakan!", "Dial", "Back");
	}
	return 1;
}

forward Cpbus(playerid);
public Cpbus(playerid)
{
	new money = 40 + random(5);
	GivePlayerMoneyEx(playerid, money);
	new str[128];
	PlayerTextDrawSetPreviewModel(playerid, NotifItems[playerid][6], 1212);
	for(new i = 0; i < 7; i++)
	{
		 PlayerTextDrawShow(playerid, NotifItems[playerid][i]);
	}
	format(str, sizeof(str), "%s", FormatMoney(money));
	PlayerTextDrawSetString(playerid, NotifItems[playerid][5], str);
	SetTimerEx("notifitems", 5000, false, "i", playerid);
}
public OnPlayerEnterRaceCheckpoint(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
	if(vehicleid == Bus[playerid])
	{
		if(pData[playerid][pBus1] == 2)
		{
		    pData[playerid][pBus1] = 3;
		    SetPlayerRaceCheckpoint(playerid, 1, 1801.938720, -1887.305419, 13.405920, 0, 0, 0, 5.0);
		    ShowProgressbar(playerid, "Menunggu penumpang...", 5);
	    	TogglePlayerControllable(playerid, 0);
		    SetTimerEx("Cpbus", 5000, false, "i", playerid);
		}
		else if(pData[playerid][pBus1] == 3)
		{
		    pData[playerid][pBus1] = 4;
		    SetPlayerRaceCheckpoint(playerid, 1, 1527.137451, -1662.293090, 13.479454, 0, 0, 0, 5.0);
		    ShowProgressbar(playerid, "Menunggu penumpang...", 5);
	    	TogglePlayerControllable(playerid, 0);
		    SetTimerEx("Cpbus", 5000, false, "i", playerid);
		}
		else if(pData[playerid][pBus1] == 4)
		{
		    pData[playerid][pBus1] = 5;
		    SetPlayerRaceCheckpoint(playerid, 1, 353.746429, -1801.879394, 4.854662, 0, 0, 0, 5.0);
		    ShowProgressbar(playerid, "Menunggu penumpang...", 5);
	    	TogglePlayerControllable(playerid, 0);
		    SetTimerEx("Cpbus", 5000, false, "i", playerid);
		}
		else if(pData[playerid][pBus1] == 5)
		{
		    pData[playerid][pBus1] = 6;
		    SetPlayerRaceCheckpoint(playerid, 1, 1268.606445, -2038.017944, 59.881599, 0, 0, 0, 5.0);
		    ShowProgressbar(playerid, "Menunggu penumpang...", 5);
	    	TogglePlayerControllable(playerid, 0);
		    SetTimerEx("Cpbus", 5000, false, "i", playerid);
		}
		else if(pData[playerid][pBus1] == 6)
		{
		    pData[playerid][pBusTime] = 20;
		    SetTimerEx("Cpbus", 100, false, "i", playerid);
		    pData[playerid][pBus1] = 1;
		    RemovePlayerFromVehicle(playerid);
		    DestroyVehicle(Bus[playerid]);
		    DisablePlayerRaceCheckpoint(playerid);
		}
	}
    if(pData[playerid][pPaperduty] == 1)
		{
		    if(pData[playerid][pKoran] < 1)
		    {
		        new vehicleid = GetPlayerVehicleID(playerid);
		        pData[playerid][pPaperduty] = 0;
						pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pKoranTime] = 20;
						AddPlayerSalary(playerid, "Sidejob(Newspaper man)", 70);
						Info(playerid, "Sidejob(Newspaper man) telah masuk ke pending salary anda!");
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
		}
	switch(pData[playerid][pCheckPoint])
	{

		case CHECKPOINT_BAGGAGE:
		{
			if(pData[playerid][pBaggage] > 0)
			{
				if(pData[playerid][pBaggage] == 1)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 2;
					SetPlayerRaceCheckpoint(playerid, 1, 1524.4792, -2435.2844, 13.2118, 1524.4792, -2435.2844, 13.2118, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 2)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 3;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2087.7998, -2392.8328, 13.2083, 2087.7998, -2392.8328, 13.2083, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(606, 2087.7998, -2392.8328, 13.2083, 179.9115, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 3)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 4;
					SetPlayerRaceCheckpoint(playerid, 1, 1605.2043, -2435.4360, 13.2153, 1605.2043, -2435.4360, 13.2153, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 4)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 5;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2006.6425, -2340.5103, 13.2045, 2006.6425, -2340.5103, 13.2045, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 2006.6425, -2340.5103, 13.2045, 90.0068, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 5)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 6;
					SetPlayerRaceCheckpoint(playerid, 1, 1684.9463, -2435.2239, 13.2137, 1684.9463, -2435.2239, 13.2137, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 6)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 7;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2006.4136, -2273.7458, 13.2012, 2006.4136, -2273.7458, 13.2012, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 2006.4136, -2273.7458, 13.2012, 92.4049, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 7)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 8;
					SetPlayerRaceCheckpoint(playerid, 1, 1765.8700, -2435.1189, 13.2090, 1765.8700, -2435.1189, 13.2090, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 8)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 9;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2056.9043, -2392.0959, 13.2038, 2056.9043, -2392.0959, 13.2038, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(606, 2056.9043, -2392.0959, 13.2038, 179.4666, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 9)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 10;
					SetPlayerRaceCheckpoint(playerid, 1, 1524.1018, -2435.0664, 13.2139, 1524.1018, -2435.0664, 13.2139, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 10)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 11;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint terakhir di GPSmu, Untuk mendapatkan gajimu!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2099.8982, -2200.7234, 13.2042, 2099.8982, -2200.7234, 13.2042, 5.0);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 11)
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					DisablePlayerRaceCheckpoint(playerid);
					pData[playerid][pBaggage] = 0;
					pData[playerid][pJobTime] += 300;
					pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
					DialogBaggage[0] = false;
					MyBaggage[playerid][0] = false;
					AddPlayerSalary(playerid, "Job(Baggage)", 125);
					Info(playerid, "Job(Baggage) telah masuk ke pending salary anda!");
					RemovePlayerFromVehicle(playerid);
					SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
					return 1;
				}
				//RUTE BAGGGAGE 2
				else if(pData[playerid][pBaggage] == 12)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 13;
					SetPlayerRaceCheckpoint(playerid, 1, 1891.7626, -2638.8113, 13.2074, 1891.7626, -2638.8113, 13.2074, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 13)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 14;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2007.5886, -2406.7236, 13.2065, 2007.5886, -2406.7236, 13.2065, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(606, 2007.5886, -2406.7236, 13.2065, 85.9836, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 14)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 15;
					SetPlayerRaceCheckpoint(playerid, 1, 1822.6267, -2637.9224, 13.2049, 1822.6267, -2637.9224, 13.2049, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 15)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 16;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2007.2054, -2358.0920, 13.2030, 2007.2054, -2358.0920, 13.2030, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 2007.2054, -2358.0920, 13.2030, 89.7154, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 16)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 17;
					SetPlayerRaceCheckpoint(playerid, 1, 1617.9980, -2638.5725, 13.2034, 1617.9980, -2638.5725, 13.2034, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 17)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 18;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 1874.9221, -2348.8616, 13.2039, 1874.9221, -2348.8616, 13.2039, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 1874.9221, -2348.8616, 13.2039, 274.8172, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 18)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 19;
					SetPlayerRaceCheckpoint(playerid, 1, 1681.0703, -2638.5410, 13.2045, 1681.0703, -2638.5410, 13.2045, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 19)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 20;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 1424.8074, -2415.5378, 13.2094, 1424.8074, -2415.5378, 13.2094, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(606, 1424.8074, -2415.5378, 13.2094, 268.7459, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 20)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 21;
					SetPlayerRaceCheckpoint(playerid, 1, 1755.4872, -2639.1306, 13.2014, 1755.4872, -2639.1306, 13.2014, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 21)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 22;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint terakhir di GPSmu, Untuk mendapatkan gajimu!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2110.0212, -2211.1377, 13.2008, 2110.0212, -2211.1377, 13.2008, 5.0);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 22)
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					DisablePlayerRaceCheckpoint(playerid);
					pData[playerid][pBaggage] = 0;
					pData[playerid][pJobTime] += 300;
					pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
					DialogBaggage[1] = false;
					MyBaggage[playerid][1] = false;
					AddPlayerSalary(playerid, "Job(Baggage)", 150);
					Info(playerid, "Job(Baggage) telah masuk ke pending salary anda!");
					RemovePlayerFromVehicle(playerid);
					SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
					return 1;
				}
				//RUTE BAGGAGE 3
				else if(pData[playerid][pBaggage] == 23)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 24;
					SetPlayerRaceCheckpoint(playerid, 1, 1509.5022, -2431.4277, 13.2163, 1509.5022, -2431.4277, 13.2163, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 24)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 25;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 1913.4680, -2678.1877, 13.2135, 1913.4680, -2678.1877, 13.2135, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(606, 1913.4680, -2678.1877, 13.2135, 358.3546, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 25)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 26;
					SetPlayerRaceCheckpoint(playerid, 1, 1591.0934, -2432.3208, 13.2094, 1591.0934, -2432.3208, 13.2094, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 26)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 27;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 1593.1262, -2685.6423, 13.2016, 1593.1262, -2685.6423, 13.2016, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 1593.1262, -2685.6423, 13.2016, 359.1027, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 27)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 28;
					SetPlayerRaceCheckpoint(playerid, 1, 1751.1523, -2432.6274, 13.2132, 1751.1523, -2432.6274, 13.2132, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 28)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 29;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 1706.6799, -2686.6472, 13.2031, 1706.6799, -2686.6472, 13.2031, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(607, 1706.6799, -2686.6472, 13.2031, 358.5210, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 29)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 30;
					SetPlayerRaceCheckpoint(playerid, 1, 1892.2029, -2344.9568, 13.2069, 1892.2029, -2344.9568, 13.2069, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 30)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 31;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint selanjutnya di GPSmu, Untuk mengambil muatan!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2160.3184, -2390.0625, 13.2055, 2160.3184, -2390.0625, 13.2055, 5.0);
						pData[playerid][pTrailerBaggage] = CreateVehicle(606, 2160.3184, -2390.0625, 13.2055, 157.5291, 1, 1, -1);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 31)
				{
					DisablePlayerRaceCheckpoint(playerid);
					SendClientMessage(playerid, COLOR_LBLUE,"[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mengirim muatan!.");
					pData[playerid][pBaggage] = 32;
					SetPlayerRaceCheckpoint(playerid, 1, 1891.8900, -2261.1121, 13.2071, 1891.8900, -2261.1121, 13.2071, 5.0);
					return 1;
				}
				else if(pData[playerid][pBaggage] == 32)
				{
					if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBaggage] = 33;
						DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
						SendClientMessage(playerid, COLOR_LBLUE, "[BAGGAGE]: {FFFFFF}Pergi ke checkpoint di GPSmu, Untuk mendapatkan gajimu!.");
						SetPlayerRaceCheckpoint(playerid, 1, 2087.1458, -2192.2161, 13.2047, 2087.1458, -2192.2161, 13.2047, 5.0);
						return 1;
					}
				}
				else if(pData[playerid][pBaggage] == 33)
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					DisablePlayerRaceCheckpoint(playerid);
					pData[playerid][pBaggage] = 0;
					pData[playerid][pJobTime] += 300;
					pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
					DialogBaggage[2] = false;
					MyBaggage[playerid][2] = false;
					AddPlayerSalary(playerid, "Job(Baggage)", 175);
					Info(playerid, "Job(Baggage) telah masuk ke pending salary anda!");
					RemovePlayerFromVehicle(playerid);
					SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
					return 1;
				}	
			}
		}
		case CHECKPOINT_DRIVELIC:
		{
			if(pData[playerid][pDriveLicApp] > 0)
			{
				if(pData[playerid][pDriveLicApp] == 1)
				{
					pData[playerid][pDriveLicApp] = 2;
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint2, dmvpoint2, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 2)
				{
					pData[playerid][pDriveLicApp] = 3;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint3, dmvpoint3, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 3)
				{
					pData[playerid][pDriveLicApp] = 4;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint4, dmvpoint4, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 4)
				{
					pData[playerid][pDriveLicApp] = 5;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint5, dmvpoint5, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 5)
				{
					pData[playerid][pDriveLicApp] = 6;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint6, dmvpoint6, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 6)
				{
					pData[playerid][pDriveLicApp] = 7;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint7, dmvpoint7, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 7)
				{
					pData[playerid][pDriveLicApp] = 8;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint8, dmvpoint8, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 8)
				{
					pData[playerid][pDriveLicApp] = 9;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint9, dmvpoint9, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 9)
				{
					pData[playerid][pDriveLicApp] = 10;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint10, dmvpoint10, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 10)
				{
					pData[playerid][pDriveLicApp] = 11;
					DisablePlayerRaceCheckpoint(playerid);
					SetPlayerRaceCheckpoint(playerid, 1, dmvpoint11, dmvpoint11, 5.0);
					return 1;
				}
				else if(pData[playerid][pDriveLicApp] == 11)
				{
					new vehicleid = GetPlayerVehicleID(playerid);
					pData[playerid][pDriveLicApp] = 0;
					pData[playerid][pDriveLic] = 1;
					pData[playerid][pDriveLicTime] = gettime() + (30 * 86400);
					pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
					DisablePlayerRaceCheckpoint(playerid);
					GivePlayerMoneyEx(playerid, -700);
					Server_AddMoney(700);
					Info(playerid, "Selamat kamu telah berhasil membuat SIM");
					RemovePlayerFromVehicle(playerid);
					SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
					return 1;
				}
				
			}
		}
		/*case CHECKPOINT_BUS:
		{
			if(pData[playerid][pSideJob] == 2)
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				if(GetVehicleModel(vehicleid) == 431)
				{
					if(pData[playerid][pBus] == 1)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 2;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint2, buspoint2, 5.0);
					}
					else if(pData[playerid][pBus] == 2)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 3;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint3, buspoint3, 5.0);
					}
					else if(pData[playerid][pBus] == 3)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 4;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint4, buspoint4, 5.0);
					}
					else if(pData[playerid][pBus] == 4)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 5;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint5, buspoint5, 5.0);
					}
					else if(pData[playerid][pBus] == 5)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 6;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint6, buspoint6, 5.0);
					}
					else if(pData[playerid][pBus] == 6)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 7;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint7, buspoint7, 5.0);
					}
					else if(pData[playerid][pBus] == 7)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 8;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint8, buspoint8, 5.0);
					}
					else if(pData[playerid][pBus] == 8)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 9;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint9, buspoint9, 5.0);
					}
					else if(pData[playerid][pBus] == 9)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 10;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint10, buspoint10, 5.0);
					}
					else if(pData[playerid][pBus] == 10)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 11;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint11, buspoint11, 5.0);
					}
					else if(pData[playerid][pBus] == 11)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 12;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint12, buspoint12, 5.0);
					}
					else if(pData[playerid][pBus] == 12)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 13;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint13, buspoint13, 5.0);
					}
					else if(pData[playerid][pBus] == 13)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 14;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint14, buspoint14, 5.0);
					}
					else if(pData[playerid][pBus] == 14)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 15;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint15, buspoint15, 5.0);
					}
					else if(pData[playerid][pBus] == 15)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 16;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint16, buspoint16, 5.0);
					}
					else if(pData[playerid][pBus] == 16)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 17;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint17, buspoint17, 5.0);
					}
					else if(pData[playerid][pBus] == 17)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 18;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint18, buspoint18, 5.0);
					}
					else if(pData[playerid][pBus] == 18)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 19;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint19, buspoint19, 5.0);
					}
					else if(pData[playerid][pBus] == 19)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 20;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint20, buspoint20, 5.0);
					}
					else if(pData[playerid][pBus] == 20)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 21;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint21, buspoint21, 5.0);
					}
					else if(pData[playerid][pBus] == 21)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 22;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint22, buspoint22, 5.0);
					}
					else if(pData[playerid][pBus] == 22)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 23;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint23, buspoint23, 5.0);
					}
					else if(pData[playerid][pBus] == 23)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 24;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint24, buspoint24, 5.0);
					}
					else if(pData[playerid][pBus] == 24)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 25;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint25, buspoint25, 5.0);
					}
					else if(pData[playerid][pBus] == 25)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 26;
						SetPlayerRaceCheckpoint(playerid, 2, buspoint26, buspoint26, 5.0);
					}
					else if(pData[playerid][pBus] == 26)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 27;
						SetPlayerRaceCheckpoint(playerid, 1, buspoint27, buspoint27, 5.0);
					}
					else if(pData[playerid][pBus] == 27)
					{
						pData[playerid][pBus] = 0;
						pData[playerid][pSideJob] = 0;
						pData[playerid][pBusTime] = 360;
						pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
						DisablePlayerRaceCheckpoint(playerid);
						AddPlayerSalary(playerid, "Sidejob(Bus)", 125);
						Info(playerid, "Sidejob(Bus) telah masuk ke pending salary anda!");
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
					}
					else if(pData[playerid][pBus] == 28)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 29;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus3, cpbus3, 5.0);
					}
					else if(pData[playerid][pBus] == 29)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 30;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus4, cpbus4, 5.0);
					}
					else if(pData[playerid][pBus] == 30)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 31;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus5, cpbus5, 5.0);
					}
					else if(pData[playerid][pBus] == 31)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 32;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus6, cpbus6, 5.0);
					}
					else if(pData[playerid][pBus] == 32)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 33;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus7, cpbus7, 5.0);
					}
					else if(pData[playerid][pBus] == 33)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 34;
						SetPlayerRaceCheckpoint(playerid, 2, cpbus8, cpbus8, 5.0);
					}
					else if(pData[playerid][pBus] == 34)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pBus] = 35;
						SetPlayerRaceCheckpoint(playerid, 1, cpbus9, cpbus9, 5.0);
					}
					else if(pData[playerid][pBus] == 35)
					{
						pData[playerid][pBus] = 0;
						pData[playerid][pSideJob] = 0;
						pData[playerid][pBusTime] = 400;
						pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
						DisablePlayerRaceCheckpoint(playerid);
						AddPlayerSalary(playerid, "Sidejob(Bus)", 150);
						Info(playerid, "Sidejob(Bus) telah masuk ke pending salary anda!");
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
					}
				}
			}
		}
		*/
		case CHECKPOINT_SWEEPER:
		{
			if(pData[playerid][pSideJob] == 1)
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				if(GetVehicleModel(vehicleid) == 574)
				{
					if(pData[playerid][pSweeper] == 1)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 2;
						SetPlayerRaceCheckpoint(playerid, 2, sweperpoint2, sweperpoint2, 5.0);
					}
					else if(pData[playerid][pSweeper] == 2)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 3;
						SetPlayerRaceCheckpoint(playerid, 2, sweperpoint3, sweperpoint3, 5.0);
					}
					else if(pData[playerid][pSweeper] == 3)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 4;
						SetPlayerRaceCheckpoint(playerid, 2, sweperpoint4, sweperpoint4, 5.0);
					}
					else if(pData[playerid][pSweeper] == 4)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 5;
						SetPlayerRaceCheckpoint(playerid, 2, sweperpoint5, sweperpoint5, 5.0);
					}
					else if(pData[playerid][pSweeper] == 5)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 6;
						SetPlayerRaceCheckpoint(playerid, 2, sweperpoint6, sweperpoint6, 5.0);
					}
					else if(pData[playerid][pSweeper] == 6)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 7;
						SetPlayerRaceCheckpoint(playerid, 2, sweperpoint7, sweperpoint7, 5.0);
					}
					else if(pData[playerid][pSweeper] == 7)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 8;
						SetPlayerRaceCheckpoint(playerid, 2, sweperpoint8, sweperpoint8, 5.0);
					}
					else if(pData[playerid][pSweeper] == 8)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 9;
						SetPlayerRaceCheckpoint(playerid, 2, sweperpoint9, sweperpoint9, 5.0);
					}
					else if(pData[playerid][pSweeper] == 9)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 10;
						SetPlayerRaceCheckpoint(playerid, 2, sweperpoint10, sweperpoint10, 5.0);
					}
					else if(pData[playerid][pSweeper] == 10)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 11;
						SetPlayerRaceCheckpoint(playerid, 2, sweperpoint11, sweperpoint11, 5.0);
					}
					else if(pData[playerid][pSweeper] == 11)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 12;
						SetPlayerRaceCheckpoint(playerid, 1, sweperpoint12, sweperpoint12, 5.0);
					}
					else if(pData[playerid][pSweeper] == 12)
					{
						pData[playerid][pSweeper] = 0;
						pData[playerid][pSideJob] = 0;
						pData[playerid][pSweeperTime] = 120;
						pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
						DisablePlayerRaceCheckpoint(playerid);
						AddPlayerSalary(playerid, "Sidejob(Sweeper)", 175);
						Info(playerid, "Sidejob(Sweeper) telah masuk ke pending salary anda!");
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
					}
					else if(pData[playerid][pSweeper] == 13)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 14;
						SetPlayerRaceCheckpoint(playerid, 2, cpswep3, cpswep3, 5.0);
					}
					else if(pData[playerid][pSweeper] == 14)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 15;
						SetPlayerRaceCheckpoint(playerid, 2, cpswep4, cpswep4, 5.0);
					}
					else if(pData[playerid][pSweeper] == 15)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 16;
						SetPlayerRaceCheckpoint(playerid, 2, cpswep5, cpswep5, 5.0);
					}
					else if(pData[playerid][pSweeper] == 16)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 17;
						SetPlayerRaceCheckpoint(playerid, 2, cpswep6, cpswep6, 5.0);
					}
					else if(pData[playerid][pSweeper] == 17)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 18;
						SetPlayerRaceCheckpoint(playerid, 2, cpswep7, cpswep7, 5.0);
					}
					else if(pData[playerid][pSweeper] == 18)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 19;
						SetPlayerRaceCheckpoint(playerid, 2, cpswep8, cpswep8, 5.0);
					}
					else if(pData[playerid][pSweeper] == 19)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pSweeper] = 20;
						SetPlayerRaceCheckpoint(playerid, 1, cpswep9, cpswep9, 5.0);
					}
					else if(pData[playerid][pSweeper] == 20)
					{
						pData[playerid][pSweeper] = 0;
						pData[playerid][pSideJob] = 0;
						pData[playerid][pSweeperTime] = 150;
						pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
						DisablePlayerRaceCheckpoint(playerid);
						AddPlayerSalary(playerid, "Sidejob(Sweeper)", 200);
						Info(playerid, "Sidejob(Sweeper) telah masuk ke pending salary anda!");
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
					}
				}
			}
		}
		case CHECKPOINT_FORKLIFTER:
		{
			if(pData[playerid][pSideJob] == 3)
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				if(GetVehicleModel(vehicleid) == 530)
				{
					if(pData[playerid][pForklifter] == 1)
					{
						pData[playerid][pForklifter] = 2;
						TogglePlayerControllable(playerid, 0);
						pData[playerid][pForklifterLoadStatus] = 1;
						pData[playerid][pForklifterLoad] = SetTimerEx("ForklifterLoadBox", 1000, true, "i", playerid);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Loading...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else if(pData[playerid][pForklifter] == 2)
					{
						pData[playerid][pForklifter] = 3;
						TogglePlayerControllable(playerid, 0);
						pData[playerid][pForklifterUnLoadStatus] = 1;
						pData[playerid][pForklifterUnLoad] = SetTimerEx("ForklifterUnLoadBox", 1000, true, "i", playerid);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Unloaded...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else if(pData[playerid][pForklifter] == 3)
					{
						pData[playerid][pForklifter] = 4;
						TogglePlayerControllable(playerid, 0);
						pData[playerid][pForklifterLoadStatus] = 1;
						pData[playerid][pForklifterLoad] = SetTimerEx("ForklifterLoadBox", 1000, true, "i", playerid);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Loading...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else if(pData[playerid][pForklifter] == 4)
					{
						pData[playerid][pForklifter] = 5;
						TogglePlayerControllable(playerid, 0);
						pData[playerid][pForklifterUnLoadStatus] = 1;
						pData[playerid][pForklifterUnLoad] = SetTimerEx("ForklifterUnLoadBox", 1000, true, "i", playerid);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Unloaded...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else if(pData[playerid][pForklifter] == 5)
					{
						pData[playerid][pForklifter] = 6;
						TogglePlayerControllable(playerid, 0);
						pData[playerid][pForklifterLoadStatus] = 1;
						pData[playerid][pForklifterLoad] = SetTimerEx("ForklifterLoadBox", 1000, true, "i", playerid);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Loading...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else if(pData[playerid][pForklifter] == 6)
					{
						pData[playerid][pForklifter] = 7;
						TogglePlayerControllable(playerid, 0);
						pData[playerid][pForklifterUnLoadStatus] = 1;
						pData[playerid][pForklifterUnLoad] = SetTimerEx("ForklifterUnLoadBox", 1000, true, "i", playerid);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Unloaded...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else if(pData[playerid][pForklifter] == 7)
					{
						pData[playerid][pForklifter] = 8;
						TogglePlayerControllable(playerid, 0);
						pData[playerid][pForklifterLoadStatus] = 1;
						pData[playerid][pForklifterLoad] = SetTimerEx("ForklifterLoadBox", 1000, true, "i", playerid);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Loading...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else if(pData[playerid][pForklifter] == 8)
					{
						pData[playerid][pForklifter] = 9;
						TogglePlayerControllable(playerid, 0);
						pData[playerid][pForklifterUnLoadStatus] = 1;
						pData[playerid][pForklifterUnLoad] = SetTimerEx("ForklifterUnLoadBox", 1000, true, "i", playerid);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Unloaded...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else if(pData[playerid][pForklifter] == 9)
					{
						pData[playerid][pForklifter] = 10;
						TogglePlayerControllable(playerid, 0);
						pData[playerid][pForklifterLoadStatus] = 1;
						pData[playerid][pForklifterLoad] = SetTimerEx("ForklifterLoadBox", 1000, true, "i", playerid);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Loading...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else if(pData[playerid][pForklifter] == 10)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pForklifter] = 11;
						DestroyDynamicObject(VehicleObject[vehicleid]);
						VehicleObject[vehicleid] = INVALID_OBJECT_ID;
						SetPlayerRaceCheckpoint(playerid, 1, forpoint3, forpoint3, 4.0);
					}
					else if(pData[playerid][pForklifter] == 11)
					{
						pData[playerid][pSideJob] = 0;
						pData[playerid][pForklifterTime] = 20;
						DisablePlayerRaceCheckpoint(playerid);
						AddPlayerSalary(playerid, "Sidejob(Forklift)", 150);
						Info(playerid, "Sidejob(Forklift) telah masuk ke pending salary anda!");
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
						return 1;
					}
				}
			}
		}
		case CHECKPOINT_MOWER:
		{
			if(pData[playerid][pSideJob] == 4)
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				if(GetVehicleModel(vehicleid) == 572)
				{
					if(pData[playerid][pMower] == 1)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pMower] = 2;
						SetPlayerRaceCheckpoint(playerid, 2, mowerpoint2, mowerpoint2, 5.0);
					}
					else if(pData[playerid][pMower] == 2)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pMower] = 3;
						SetPlayerRaceCheckpoint(playerid, 2, mowerpoint3, mowerpoint3, 5.0);
					}
					else if(pData[playerid][pMower] == 3)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pMower] = 4;
						SetPlayerRaceCheckpoint(playerid, 2, mowerpoint4, mowerpoint4, 5.0);
					}
					else if(pData[playerid][pMower] == 4)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pMower] = 5;
						SetPlayerRaceCheckpoint(playerid, 2, mowerpoint5, mowerpoint5, 5.0);
					}
					else if(pData[playerid][pMower] == 5)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pMower] = 6;
						SetPlayerRaceCheckpoint(playerid, 2, mowerpoint6, mowerpoint6, 5.0);
					}
					else if(pData[playerid][pMower] == 6)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pMower] = 7;
						SetPlayerRaceCheckpoint(playerid, 2, mowerpoint7, mowerpoint7, 5.0);
					}
					else if(pData[playerid][pMower] == 7)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pMower] = 8;
						SetPlayerRaceCheckpoint(playerid, 2, mowerpoint8, mowerpoint8, 5.0);
					}
					else if(pData[playerid][pMower] == 8)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pMower] = 9;
						SetPlayerRaceCheckpoint(playerid, 2, mowerpoint9, mowerpoint9, 5.0);
					}
					else if(pData[playerid][pMower] == 9)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pMower] = 10;
						SetPlayerRaceCheckpoint(playerid, 2, mowerpoint10, mowerpoint10, 5.0);
					}
					else if(pData[playerid][pMower] == 10)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pMower] = 11;
						SetPlayerRaceCheckpoint(playerid, 2, mowerpoint11, mowerpoint11, 5.0);
					}
					else if(pData[playerid][pMower] == 11)
					{
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pMower] = 12;
						SetPlayerRaceCheckpoint(playerid, 2, mowerpoint12, mowerpoint12, 5.0);
					}
					else if(pData[playerid][pMower] == 12)
					{
						pData[playerid][pSideJob] = 0;
						pData[playerid][pMower] = 0;
						//pData[playerid][pMowerTime] += 120;
						pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
						DisablePlayerRaceCheckpoint(playerid);
						pData[playerid][pMowerTime] = 20;
						AddPlayerSalary(playerid, "Sidejob(Mower)", 100);
						Info(playerid, "Sidejob(Mower) telah masuk ke pending salary anda!");
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
					}
				}
			}
		}
		case CHECKPOINT_MISC:
		{
			pData[playerid][pCheckPoint] = CHECKPOINT_NONE;
			DisablePlayerRaceCheckpoint(playerid);
		}
	}
	if(pData[playerid][pGpsActive] == 1)
	{
		pData[playerid][pGpsActive] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackCar] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan kendaraan anda!");
		pData[playerid][pTrackCar] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackHouse] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan rumah anda!");
		pData[playerid][pTrackHouse] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackVending] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan mesin vending anda!");
		pData[playerid][pTrackVending] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackBisnis] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan bisnis!");
		pData[playerid][pTrackBisnis] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackDealer] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan dealer!");
		pData[playerid][pTrackDealer] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pMission] > -1)
	{
		DisablePlayerRaceCheckpoint(playerid);
		Info(playerid, "/buy , /gps(My Mission) , /storeproduct.");
	}
	if(pData[playerid][pHauling] > -1)
	{
		if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
		{
			DisablePlayerRaceCheckpoint(playerid);
			Info(playerid, "'/storegas' untuk menyetor GasOilnya!");
		}
		else
		{
			if(IsPlayerInRangeOfPoint(playerid, 10.0, 335.66, 861.02, 21.01))
			{
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerCheckpoint(playerid, 336.70, 895.54, 20.40, 5.5);
				Info(playerid, "Silahkan ambil trailer dan menuju ke checkpoint untuk membeli GasOil!");
			}
			else
			{
				Error(playerid, "Kamu tidak membawa Trailer Gasnya, Silahkan ambil kembali trailernnya!");
			}
		}
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	//tentara
	if(GetPlayerSkin(playerid) == 285)
    {
    
        ClearAnimations(playerid);
        TogglePlayerControllable(playerid,0);
        TogglePlayerControllable(playerid,1);
        DisablePlayerCheckpoint(playerid);
    
	}
	//
	if(pData[playerid][pHauling] > -1)
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.5, 336.70, 895.54, 20.40))
		{
			DisablePlayerCheckpoint(playerid);
			Info(playerid, "/buy, /gps(My Hauling), /storegas.");
		}
	}
	//race
    if(pData[playerid][pRaceIndex] != 0 && pData[playerid][pRaceWith] != INVALID_PLAYER_ID && !pData[playerid][pRaceFinish])
	{
		switch(pData[playerid][pRaceIndex])
		{
		    case 1:
		    {
			    SetRaceCP(playerid, 2, RaceData[pData[playerid][pRaceWith]][racePos2][0], RaceData[pData[playerid][pRaceWith]][racePos2][1], RaceData[pData[playerid][pRaceWith]][racePos2][2], 5.0);
				pData[playerid][pRaceIndex] = 2;
			}
			case 2:
			{
			    SetRaceCP(playerid, 2, RaceData[pData[playerid][pRaceWith]][racePos3][0], RaceData[pData[playerid][pRaceWith]][racePos3][1], RaceData[pData[playerid][pRaceWith]][racePos3][2], 5.0);
				pData[playerid][pRaceIndex] = 3;
			}
			case 3:
			{
			    SetRaceCP(playerid, 2, RaceData[pData[playerid][pRaceWith]][racePos4][0], RaceData[pData[playerid][pRaceWith]][racePos4][1], RaceData[pData[playerid][pRaceWith]][racePos4][2], 5.0);
				pData[playerid][pRaceIndex] = 4;
			}
			case 4:
			{
			    SetRaceCP(playerid, 2, RaceData[pData[playerid][pRaceWith]][racePos5][0], RaceData[pData[playerid][pRaceWith]][racePos5][1], RaceData[pData[playerid][pRaceWith]][racePos5][2], 5.0);
				pData[playerid][pRaceIndex] = 5;
			}
			case 5:
			{
			    SetRaceCP(playerid, 2, RaceData[pData[playerid][pRaceWith]][raceFinish][0], RaceData[pData[playerid][pRaceWith]][raceFinish][1], RaceData[pData[playerid][pRaceWith]][raceFinish][2], 5.0);
				pData[playerid][pRaceFinish] = 1;
			}
		}
	}
	//stealcar
	if(pData[playerid][pCarSteal] == 1)
	{
	    if(AtCarsRobs[playerid] == 1)
	    {
	        AtCarsRobs[playerid] = 0;
			new qr[128];
			format(qr, sizeof(qr), "[CAR STEALING] : %s "YELLOW_E"Telah berhasil mencuri mobil", pData[playerid][pName]);
			SendClientMessageToAll(COLOR_RED, qr);
			switch (random(4))
			{
				  case 0: pData[playerid][pRedMoney] += 1000, Info(playerid, "Uang Kamu Bertambah $5.00!");
				  case 1: pData[playerid][pRedMoney] += 1200, Info(playerid, "Uang Kamu Bertambah $1.200!");
				  case 2: pData[playerid][pRedMoney] += 2000, Info(playerid, "Uang Kamu Bertambah $2.000!");
				  case 3: pData[playerid][pRedMoney] += 3000, Info(playerid, "Uang Kamu Bertambah $3.000!");
			}
            DestroyVehicle(GetPlayerVehicleID(playerid));
            DisablePlayerCheckpoint(playerid);
	    }
	}
	if(pData[playerid][CarryingLog] != -1)
	{
		if(GetPVarInt(playerid, "LoadingCooldown") > gettime()) return 1;
		new vehicleid = GetPVarInt(playerid, "LastVehicleID"), type[64], carid = -1;
		if(pData[playerid][CarryingLog] == 0)
		{
			type = "Metal";
		}
		else if(pData[playerid][CarryingLog] == 1)
		{
			type = "Coal";
		}
		else
		{
			type = "Unknown";
		}
		if(Vehicle_LogCount(vehicleid) >= LOG_LIMIT) return ErrorMsg(playerid, "You can't load any more ores to this vehicle.");
		if((carid = Vehicle_Nearest2(playerid)) != -1)
		{
			if(pData[playerid][CarryingLog] == 0)
			{
				pvData[carid][cMetal] += 1;
			}
			else if(pData[playerid][CarryingLog] == 1)
			{
				pvData[carid][cCoal] += 1;
			}
		}
		LogStorage[vehicleid][ pData[playerid][CarryingLog] ]++;
		Info(playerid, "MINING: Loaded %s.", type);
		ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
		Player_RemoveLog(playerid);
		DisablePlayerCheckpoint(playerid);
		return 1;
	}
	if(pData[playerid][pFindEms] != INVALID_PLAYER_ID)
	{
		pData[playerid][pFindEms] = INVALID_PLAYER_ID;
		DisablePlayerCheckpoint(playerid);
	}
	if(pData[playerid][pSideJob] == 1)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 574)
		{
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint1))
			{
				SetPlayerCheckpoint(playerid, sweperpoint2, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint2))
			{
				SetPlayerCheckpoint(playerid, sweperpoint3, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint3))
			{
				SetPlayerCheckpoint(playerid, sweperpoint4, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint4))
			{
				SetPlayerCheckpoint(playerid, sweperpoint5, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint5))
			{
				SetPlayerCheckpoint(playerid, sweperpoint6, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint6))
			{
				SetPlayerCheckpoint(playerid, sweperpoint7, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint7))
			{
				SetPlayerCheckpoint(playerid, sweperpoint8, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint8))
			{
				SetPlayerCheckpoint(playerid, sweperpoint9, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint9))
			{
				SetPlayerCheckpoint(playerid, sweperpoint10, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint10))
			{
				SetPlayerCheckpoint(playerid, sweperpoint11, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint11))
			{
				SetPlayerCheckpoint(playerid, sweperpoint12, 7.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint12))
			{
				pData[playerid][pSideJob] = 0;
				pData[playerid][pSweeperTime] = 120;
				DisablePlayerCheckpoint(playerid);
				AddPlayerSalary(playerid, "Sidejob(Sweeper)", 150);
				Info(playerid, "Sidejob(Sweeper) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
		}
	}
	/*if(pData[playerid][pSideJob] == 2)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 431)
		{
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint1))
			{
				SetPlayerCheckpoint(playerid, buspoint2, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint2))
			{
				SetPlayerCheckpoint(playerid, buspoint3, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint3))
			{
				SetPlayerCheckpoint(playerid, buspoint4, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint4))
			{
				SetPlayerCheckpoint(playerid, buspoint5, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint5))
			{
				SetPlayerCheckpoint(playerid, buspoint6, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint6))
			{
				SetPlayerCheckpoint(playerid, buspoint7, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint7))
			{
				SetPlayerCheckpoint(playerid, buspoint8, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint8))
			{
				SetPlayerCheckpoint(playerid, buspoint9, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint9))
			{
				SetPlayerCheckpoint(playerid, buspoint10, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint10))
			{
				SetPlayerCheckpoint(playerid, buspoint11, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint11))
			{
				SetPlayerCheckpoint(playerid, buspoint12, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint12))
			{
				SetPlayerCheckpoint(playerid, buspoint13, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint13))
			{
				SetPlayerCheckpoint(playerid, buspoint14, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint14))
			{
				SetPlayerCheckpoint(playerid, buspoint15, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint15))
			{
				SetPlayerCheckpoint(playerid, buspoint16, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint16))
			{
				SetPlayerCheckpoint(playerid, buspoint17, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint17))
			{
				SetPlayerCheckpoint(playerid, buspoint18, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint18))
			{
				SetPlayerCheckpoint(playerid, buspoint19, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint19))
			{
				SetPlayerCheckpoint(playerid, buspoint20, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint20))
			{
				SetPlayerCheckpoint(playerid, buspoint21, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint21))
			{
				SetPlayerCheckpoint(playerid, buspoint22, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint22))
			{
				SetPlayerCheckpoint(playerid, buspoint23, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint23))
			{
				SetPlayerCheckpoint(playerid, buspoint24, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint24))
			{
				SetPlayerCheckpoint(playerid, buspoint25, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint25))
			{
				SetPlayerCheckpoint(playerid, buspoint26, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint26))
			{
				SetPlayerCheckpoint(playerid, buspoint27, 7.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 7.0,buspoint27))
			{
				pData[playerid][pSideJob] = 0;
				pData[playerid][pBusTime] = 360;
				DisablePlayerCheckpoint(playerid);
				AddPlayerSalary(playerid, "Sidejob(Bus)", 200);
				Info(playerid, "Sidejob(Bus) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
		}
	}*/
	//DisablePlayerCheckpoint(playerid);
	return 1;
}

forward JobForklift(playerid);
public JobForklift(playerid)
{
	TogglePlayerControllable(playerid, 1);
	GameTextForPlayer(playerid, "~w~SELESAI!", 5000, 3);
}

public OnPlayerRequestRobbery(playerid, Actorrob) {
	new exampleName[24];
	GetPlayerName(playerid, exampleName, 24);

	if(!strcmp(exampleName, "COP"))
	{
		SendClientMessage(playerid, -1, "COP no ROB.");
		return 0; // Must return 0 for the robbery to not commence.
	}
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	//pool
    if(newkeys & 128)
	{
	    if(Player[playerid][Sighting] == false && CheckAllBalls() == 1 && Game[Running] == true && Player[playerid][Turn] == true)
	    {
	        new Float:dist = GetVectorDistance_PL(playerid,Ball[WHITE][ObjID]);
	    	if(GetPlayerWeapon(playerid) == 7 && dist < 1.6)
	        {
	        	new Float:pos[7];
	        	GetObjectPos(Ball[WHITE][ObjID],pos[0],pos[1],pos[2]);
				GetPlayerPos(playerid,pos[3],pos[4],pos[5]);
				pos[6] = GetVectorAngle_XY(pos[3],pos[4],pos[0],pos[1]);
				Player[playerid][Sighting] = true;
				Player[playerid][AfterSighting] = true;
				Player[playerid][SelectLR] = 0;
				Player[playerid][SelectUD] = 5;

				TextDrawSetString(Player[playerid][T2],"Predkosc");
	    	    TextDrawShowForPlayer(playerid,Player[playerid][T2]);

	    	    TextDrawSetString(Player[playerid][T1],"60 cm~w~/s");
	    	    TextDrawShowForPlayer(playerid,Player[playerid][T1]);

				if(0.9 <= dist <= 1.2)
				{
				    pos[3] += floatsin(-pos[6] + 180,degrees) * 0.3;
				    pos[4] += floatcos(-pos[6] + 180,degrees) * 0.3;
				}
				else if(dist < 0.9)
				{
				    pos[3] += floatsin(-pos[6] + 180,degrees) * 0.6;
				    pos[4] += floatcos(-pos[6] + 180,degrees) * 0.6;
				}
				SetPlayerPos(playerid,pos[3],pos[4],pos[5]);
				SetPlayerFacingAngle(playerid,pos[6] - 2.2);
				Player[playerid][pa] = pos[6] - 2.2;

    			pos[3] += floatsin(-pos[6] - 10,degrees) * 0.2;
		  		pos[4] += floatcos(-pos[6] - 10,degrees) * 0.2;
		    	SetPlayerCameraPos(playerid,pos[3],pos[4],pos[2] + 0.5);
			    SetPlayerCameraLookAt(playerid,pos[0],pos[1],pos[2]);
			    ApplyAnimation(playerid,"POOL","POOL_Med_Start",1,0,0,0,1,0,1);
	    	}
   		}
	}
	else if(oldkeys & 128)
	{
	    if(Player[playerid][AfterSighting] == true)
	    {
	    	SetCameraBehindPlayer(playerid);
	    	ApplyAnimation(playerid,"POOL","POOL_Med_Shot_O",4.1,0,1,1,1,1,1);

     		TextDrawHideForPlayer(playerid,Player[playerid][T1]);
	   		TextDrawHideForPlayer(playerid,Player[playerid][T2]);
	   		Player[playerid][AfterSighting] = false;

	   		if(Player[playerid][Sighting] == true)
	   		    Player[playerid][Sighting] = false;
	   	}
	}

	//
	if(newkeys & KEY_FIRE)
	{
	    if(GetPlayerWeapon(playerid) == 24 && Inventory_Count(playerid, "44_Magnum") < 1)
	    {
	        SetPlayerArmedWeapon(playerid, 0);
		}
		if(GetPlayerWeapon(playerid) == 22 && Inventory_Count(playerid, "9mm") < 1)
	    {
	        SetPlayerArmedWeapon(playerid, 0);
		}
		if(pData[playerid][pGuntazer] != 1)
		{
			if(GetPlayerWeapon(playerid) == 23 && Inventory_Count(playerid, "9mm") < 1)
		    {
		        SetPlayerArmedWeapon(playerid, 0);
			}
		}
		if(GetPlayerWeapon(playerid) == 25 && Inventory_Count(playerid, "Buckshot") < 1)
	    {
	        SetPlayerArmedWeapon(playerid, 0);
		}
		if(GetPlayerWeapon(playerid) == 29 && Inventory_Count(playerid, "19mm") < 1)
	    {
	        SetPlayerArmedWeapon(playerid, 0);
		}
		if(GetPlayerWeapon(playerid) == 30 && Inventory_Count(playerid, "39mm") < 1)
	    {
	        SetPlayerArmedWeapon(playerid, 0);
		}
	    if(Player[playerid][Sighting] == true)
	    {
	        new Float:pos[7];
	    	GetObjectPos(Ball[WHITE][ObjID],pos[0],pos[1],pos[2]);

	    	Game[Timer] = SetTimer("OnTimer",10,1);
	    	Game[Timer2] = SetTimer("BallProperties",200,1);

	    	TextDrawHideForPlayer(playerid,Player[playerid][T1]);
	        TextDrawHideForPlayer(playerid,Player[playerid][T2]);
	        Player[playerid][Sighting] = false;

	    	if(Player[playerid][pa] > 360)
				Player[playerid][pa] = Player[playerid][pa] - 360;

			else if(Player[playerid][pa] < 0)
			    Player[playerid][pa] = 360 + Player[playerid][pa];

			Ball[WHITE][ba] = Player[playerid][pa];

	    	pos[0] += 5 * floatsin(-Ball[WHITE][ba],degrees);
	    	pos[1] += 5 * floatcos(-Ball[WHITE][ba],degrees);
			Ball[WHITE][bx] = pos[0];
			Ball[WHITE][by] = pos[1];
			Ball[WHITE][bz] = pos[2];
			Ball[WHITE][speed] = Player[playerid][SelectUD] / 1.5;

			new Float:pp[4];
			GetPlayerPos(playerid,pp[0],pp[1],pp[2]);
			GetPlayerFacingAngle(playerid,pp[3]);
			pp[0] += floatsin(-pp[3] - 90,degrees) * 0.3;
			pp[1] += floatcos(-pp[3] - 90,degrees) * 0.3;
			SetPlayerPos(playerid,pp[0],pp[1],pp[2]);

			SetPlayerCameraPos(playerid,2496.4970703125, -1671.1528320313, 12.275947036743 + 5);
			SetPlayerCameraLookAt(playerid,2496.4970703125, -1671.1528320313, 12.275947036743);
			ApplyAnimation(playerid,"POOL","POOL_Med_Shot",4.1,0,1,1,1,1,1);
	    }
	}
	//garkot
	if(newkeys & KEY_HANDBRAKE)
	{
	    if(!IsPlayerInAnyVehicle(playerid))
		{
		    if(GetPlayerWeapon(playerid) == 24 && Inventory_Count(playerid, "44_Magnum") < 1)
		    {
		        SetPlayerArmedWeapon(playerid, 0);
			}
		    if(GetPlayerWeapon(playerid) == 22 && Inventory_Count(playerid, "9mm") < 1)
		    {
		        SetPlayerArmedWeapon(playerid, 0);
			}
			if(pData[playerid][pGuntazer] != 1)
			{
				if(GetPlayerWeapon(playerid) == 23 && Inventory_Count(playerid, "9mm") < 1)
			    {
			        SetPlayerArmedWeapon(playerid, 0);
				}
			}
			if(GetPlayerWeapon(playerid) == 25 && Inventory_Count(playerid, "Buckshot") < 1)
		    {
		        SetPlayerArmedWeapon(playerid, 0);
			}
			if(GetPlayerWeapon(playerid) == 29 && Inventory_Count(playerid, "19mm") < 1)
		    {
		        SetPlayerArmedWeapon(playerid, 0);
			}
			if(GetPlayerWeapon(playerid) == 30 && Inventory_Count(playerid, "39mm") < 1)
		    {
		        SetPlayerArmedWeapon(playerid, 0);
			}
		}
	}
	if(newkeys & KEY_CROUCH)
	{
	   
	    if(IsPlayerInRangeOfPoint(playerid, 3, -56.043235, 57.363063, 3.110269))
		{
		    if(pData[playerid][pJob] != 7 && pData[playerid][pJob2] != 7) return ErrorMsg(playerid, "Bukan pekerja farrmer");
			if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Kamu harus login!");
			if(pData[playerid][pInjured] >= 1) return Error(playerid, "Kamu tidak bisa melakukan ini!");
			if(!IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You must be in Vehicle");

				new carid = -1,
					found = 0;

				if((carid = Vehicle_Nearest2(playerid)) != -1)
				{
				    if(pData[playerid][pAntarayamTime] > 0) return ErrorMsg(playerid, "Tunggu %d menit", pData[playerid][pAntarayamTime]);
				    if(pvData[carid][cKandang] != 1) return ErrorMsg(playerid, "Bukan mobil pengantar ayam");
				    if(pvData[carid][cTogkandang] != 1) return ErrorMsg(playerid, "Silahkan pasang kandang terlebih dahulu, cmd /kandang");
				    if(kandang1 < 10) return ErrorMsg(playerid, "Ayam di kandang kurg dari 10");
				    if(pvData[carid][cAyamhidup] > 9) return ErrorMsg(playerid, "Kamu sudah membawa 10 ayam");
				    pvData[carid][cAyamhidup] = 10;
				    kandang1 -= 10;
				    SuccesMsg(playerid, "Berhasil membawa 10 ayam");
				    SetPlayerRaceCheckpoint(playerid,1, -2112.106201, -2414.923583, 31.252927, 0.0,0.0,0.0, 3.5);
					Gps(playerid, "Active!");
				}
		}
		if(IsPlayerInRangeOfPoint(playerid, 3, -57.719161, 52.421863, 3.110269))
		{
		    if(pData[playerid][pJob] != 7 && pData[playerid][pJob2] != 7) return ErrorMsg(playerid, "Bukan pekerja farrmer");
			if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Kamu harus login!");
			if(pData[playerid][pInjured] >= 1) return Error(playerid, "Kamu tidak bisa melakukan ini!");
			if(!IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You must be in Vehicle");

				new carid = -1,
					found = 0;

				if((carid = Vehicle_Nearest2(playerid)) != -1)
				{
				    if(pData[playerid][pAntarayamTime] > 0) return ErrorMsg(playerid, "Tunggu %d menit", pData[playerid][pAntarayamTime]);
				    if(pvData[carid][cKandang] != 1) return ErrorMsg(playerid, "Bukan mobil pengantar ayam");
				    if(pvData[carid][cTogkandang] != 1) return ErrorMsg(playerid, "Silahkan pasang kandang terlebih dahulu, cmd /kandang");
				    if(kandang2 < 10) return ErrorMsg(playerid, "Ayam di kandang kurg dari 10");
				    if(pvData[carid][cAyamhidup] > 9) return ErrorMsg(playerid, "Kamu sudah membawa 10 ayam");
				    pvData[carid][cAyamhidup] = 10;
				    kandang2 -= 10;
				    SuccesMsg(playerid, "Berhasil membawa 10 ayam");
				    SetPlayerRaceCheckpoint(playerid,1, -2112.106201, -2414.923583, 31.252927, 0.0,0.0,0.0, 3.5);
					Gps(playerid, "Active!");
				}
		}
		if(IsPlayerInRangeOfPoint(playerid, 3, -59.442920, 47.451335, 3.11026))
		{
		    if(pData[playerid][pJob] != 7 && pData[playerid][pJob2] != 7) return ErrorMsg(playerid, "Bukan pekerja farrmer");
			if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Kamu harus login!");
			if(pData[playerid][pInjured] >= 1) return Error(playerid, "Kamu tidak bisa melakukan ini!");
			if(!IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You must be in Vehicle");

				new carid = -1,
					found = 0;

				if((carid = Vehicle_Nearest2(playerid)) != -1)
				{
				    if(pData[playerid][pAntarayamTime] > 0) return ErrorMsg(playerid, "Tunggu %d menit", pData[playerid][pAntarayamTime]);
				    if(pvData[carid][cKandang] != 1) return ErrorMsg(playerid, "Bukan mobil pengantar ayam");
				    if(pvData[carid][cTogkandang] != 1) return ErrorMsg(playerid, "Silahkan pasang kandang terlebih dahulu, cmd /kandang");
				    if(kandang3 < 10) return ErrorMsg(playerid, "Ayam di kandang kurg dari 10");
				    if(pvData[carid][cAyamhidup] > 9) return ErrorMsg(playerid, "Kamu sudah membawa 10 ayam");
				    pvData[carid][cAyamhidup] = 10;
				    kandang3 -= 10;
				    SuccesMsg(playerid, "Berhasil membawa 10 ayam");
				    SetPlayerRaceCheckpoint(playerid,1, -2112.106201, -2414.923583, 31.252927, 0.0,0.0,0.0, 3.5);
					Gps(playerid, "Active!");
				}
		}
		if(IsPlayerInRangeOfPoint(playerid, 3, -65.415077, 41.589778, 3.110269))
		{
		    if(pData[playerid][pJob] != 7 && pData[playerid][pJob2] != 7) return ErrorMsg(playerid, "Bukan pekerja farrmer");

			if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Kamu harus login!");
			if(pData[playerid][pInjured] >= 1) return Error(playerid, "Kamu tidak bisa melakukan ini!");
			if(!IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You must be in Vehicle");

				new carid = -1,
					found = 0;

				if((carid = Vehicle_Nearest2(playerid)) != -1)
				{
				    if(pData[playerid][pAntarayamTime] > 0) return ErrorMsg(playerid, "Tunggu %d menit", pData[playerid][pAntarayamTime]);
				    if(pvData[carid][cKandang] != 1) return ErrorMsg(playerid, "Bukan mobil pengantar ayam");
				    if(pvData[carid][cTogkandang] != 1) return ErrorMsg(playerid, "Silahkan pasang kandang terlebih dahulu, cmd /kandang");
				    if(kandang4 < 10) return ErrorMsg(playerid, "Ayam di kandang kurg dari 10");
				    if(pvData[carid][cAyamhidup] > 9) return ErrorMsg(playerid, "Kamu sudah membawa 10 ayam");
				    pvData[carid][cAyamhidup] = 10;
				    kandang4 -= 10;
				    SuccesMsg(playerid, "Berhasil membawa 10 ayam");
				    SetPlayerRaceCheckpoint(playerid,1, -2112.106201, -2414.923583, 31.252927, 0.0,0.0,0.0, 3.5);
					Gps(playerid, "Active!");
				}
		}
		if(IsPlayerInRangeOfPoint(playerid, 3, -67.112464, 36.589614, 3.110269))
		{
		    if(pData[playerid][pJob] != 7 && pData[playerid][pJob2] != 7) return ErrorMsg(playerid, "Bukan pekerja farrmer");
			if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Kamu harus login!");
			if(pData[playerid][pInjured] >= 1) return Error(playerid, "Kamu tidak bisa melakukan ini!");
			if(!IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You must be in Vehicle");

				new carid = -1,
					found = 0;

				if((carid = Vehicle_Nearest2(playerid)) != -1)
				{
				    if(pData[playerid][pAntarayamTime] > 0) return ErrorMsg(playerid, "Tunggu %d menit", pData[playerid][pAntarayamTime]);
				    if(pvData[carid][cKandang] != 1) return ErrorMsg(playerid, "Bukan mobil pengantar ayam");
				    if(pvData[carid][cTogkandang] != 1) return ErrorMsg(playerid, "Silahkan pasang kandang terlebih dahulu, cmd /kandang");
				    if(kandang5 < 10) return ErrorMsg(playerid, "Ayam di kandang kurg dari 10");
				    if(pvData[carid][cAyamhidup] > 9) return ErrorMsg(playerid, "Kamu sudah membawa 10 ayam");
				    pvData[carid][cAyamhidup] = 10;
				    kandang5 -= 10;
				    SuccesMsg(playerid, "Berhasil membawa 10 ayam");
				    SetPlayerRaceCheckpoint(playerid,1, -2112.106201, -2414.923583, 31.252927, 0.0,0.0,0.0, 3.5);
					Gps(playerid, "Active!");
				}
		}
	    if(IsPlayerInRangeOfPoint(playerid, 5, -2112.106201, -2414.923583, 31.252927))
		{
			if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Kamu harus login!");
			if(pData[playerid][pInjured] >= 1) return Error(playerid, "Kamu tidak bisa melakukan ini!");
			if(!IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You must be in Vehicle");

				new carid = -1,
					found = 0;

				if((carid = Vehicle_Nearest2(playerid)) != -1)
				{
				    if(pvData[carid][cKandang] != 1) return ErrorMsg(playerid, "Bukan mobil pengantar ayam");
				    if(pvData[carid][cTogkandang] != 1) return ErrorMsg(playerid, "Silahkan pasang kandang terlebih dahulu, cmd /kandang");
				    if(pvData[carid][cAyamhidup] < 10) return ErrorMsg(playerid, "Harus 10 ayam");
				    Ayammati += pvData[carid][cAyamhidup];
				    GivePlayerMoneyEx(playerid, 700);
				    pvData[carid][cAyamhidup] = 0;
				    pData[playerid][pAntarayamTime] = 20;
				    SuccesMsg(playerid, "Berhasil menukar 10 ayam, gaji 700");
				}
		}
	}
    if(newkeys & KEY_CROUCH)
	{
	    if(GetNearbyGarkott(playerid) >= 0)
		{
			if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Kamu harus login!");
			if(pData[playerid][pInjured] >= 1) return Error(playerid, "Kamu tidak bisa melakukan ini!");
			if(!IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You must be in Vehicle");
			new id = -1;
			id = GetClosestParks(playerid);

			if(id > -1)
			{
				if(CountParkedVeh(id) >= 40)
					return ErrorMsg(playerid, "Garasi Kota sudah memenuhi Kapasitas!");

				new carid = -1,
					found = 0;

				if((carid = Vehicle_Nearest2(playerid)) != -1)
				{
					GetVehiclePos(pvData[carid][cVeh], pvData[carid][cPosX], pvData[carid][cPosY], pvData[carid][cPosZ]);
					GetVehicleZAngle(pvData[carid][cVeh], pvData[carid][cPosA]);
					GetVehicleHealth(pvData[carid][cVeh], pvData[carid][cHealth]);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
					SuccesMsg(playerid, "Vehicle ~r~Despawned");
					RemovePlayerFromVehicle(playerid);
					pvData[carid][cPark] = id;
					SetPlayerArmedWeapon(playerid, 0);
					found++;
					if(IsValidVehicle(pvData[carid][cVeh]))
					{
						DestroyVehicle(pvData[carid][cVeh]);
						pvData[carid][cVeh] = INVALID_VEHICLE_ID;
					}
				}
				if(!found)
					return ErrorMsg(playerid, "Kendaraan ini tidak dapat di Park!");
			}
		}
	}
	if(newkeys & KEY_YES)
	{
	    
	    if(IsPlayerInRangeOfPoint(playerid, 3, 1268.606445, -2038.017944, 59.881599))
		{
		    if(pData[playerid][pBus1] < 1) return ErrorMsg(playerid, "Anda belum duty sidejob bus");
		    if(pData[playerid][pBusTime] > 0) return ErrorMsg(playerid, "Tunggu %d menit", pData[playerid][pBusTime]);
		    Bus[playerid] = CreateVehicle(431,1263.44, -2030.55, 59.32,205.427,0,0,-1,0);
	    //bus
	    new tmpobjid;

				    tmpobjid = CreateDynamicObject(7313,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 10837, "airroadsigns_sfse", "ws_airbigsign1", 0);
				    SetDynamicObjectMaterial(tmpobjid, 1, 16646, "a51_alpha", "des_rails1", 0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "BUS RUTE 1", 80, "Arial", 30, 0, -65536, -16777216, 1);
				    AttachDynamicObjectToVehicle(tmpobjid, Bus[playerid], 1.274, 0.464, -0.120, 0.000, 0.000, 89.899);
				    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
				    AttachDynamicObjectToVehicle(tmpobjid, Bus[playerid], 1.330, -2.455, 0.490, 0.000, 0.000, 90.099);
				    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
				    AttachDynamicObjectToVehicle(tmpobjid, Bus[playerid], 1.349, -4.018, 0.490, 0.000, 0.000, 90.999);
				    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "u", 90, "Webdings", 100, 0, -16777216, 0, 0);
				    AttachDynamicObjectToVehicle(tmpobjid, Bus[playerid], 1.411, -3.781, 0.550, 0.000, 0.000, 90.799);
				    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "Hoffentlich Travel", 90, "Times New Roman", 45, 0, -16777216, 0, 0);
				    AttachDynamicObjectToVehicle(tmpobjid, Bus[playerid], 1.427, -3.071, 0.480, 0.000, 0.000, 91.600);
				    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "BUS", 90, "Times New Roman", 65, 0, -16777216, 0, 0);
				    AttachDynamicObjectToVehicle(tmpobjid, Bus[playerid], 1.342, -2.997, 0.210, 0.000, 0.000, 91.299);
				    tmpobjid = CreateDynamicObject(7313,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 10837, "airroadsigns_sfse", "ws_airbigsign1", 0);
				    SetDynamicObjectMaterial(tmpobjid, 1, 16646, "a51_alpha", "des_rails1", 0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "BUS RUTE 1", 80, "Arial", 30, 0, -65536, -16777216, 1);
				    AttachDynamicObjectToVehicle(tmpobjid, Bus[playerid], -1.322, 0.442, -0.090, 0.000, 0.000, -90.900);
				    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
				    AttachDynamicObjectToVehicle(tmpobjid, Bus[playerid], -1.345, -1.662, 0.490, 0.000, 0.000, -90.000);
				    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
				    AttachDynamicObjectToVehicle(tmpobjid, Bus[playerid], -1.342, -3.243, 0.490, 0.000, 0.000, -90.299);
				    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "u", 90, "Webdings", 100, 0, -16777216, 0, 0);
				    AttachDynamicObjectToVehicle(tmpobjid, Bus[playerid], -1.400, -4.109, 0.550, 0.000, 0.000, -91.899);
				    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "Hoffentlich Travel", 90, "Times New Roman", 48, 0, -16777216, 0, 0);
				    AttachDynamicObjectToVehicle(tmpobjid, Bus[playerid], -1.448, -2.595, 0.440, 0.000, 0.000, -84.799);
				    tmpobjid = CreateDynamicObject(2722,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				    SetDynamicObjectMaterial(tmpobjid, 0, 10101, "2notherbuildsfe", "ferry_build14", 0);
				    SetDynamicObjectMaterialText(tmpobjid, 0, "BUS", 90, "Times New Roman", 65, 0, -16777216, 0, 0);
				    AttachDynamicObjectToVehicle(tmpobjid, Bus[playerid], -1.397, -3.351, 0.150, 0.000, 0.000, -89.399);
		PutPlayerInVehicle(playerid, Bus[playerid], 0);
	    SetPlayerRaceCheckpoint(playerid, 1, 1667.838867, -2256.697509, -2.887918, 0, 0, 0, 5.0);
	    pData[playerid][pBus1] = 2;
		}
	}
	if(newkeys & KEY_NO)
	{
	    
	    if(GetPVarInt(playerid, "Mejajahit"))
	    {
	        if(pData[playerid][pDutypenjahit] != 1) return ErrorMsg(playerid, "Anda belum duty penjahit");
	        if(Inventory_Count(playerid, "Wool") < 1) return ErrorMsg(playerid, "Anda gk punya wool");
		    ApplyAnimation(playerid,"GRAVEYARD","mrnM_loop",4.0, 1, 0, 0, 0, 0, 1);
    		SetPlayerAttachedObject(playerid, 9, 2894, 5, 0.100, -0.100, 0.000, 0.000, 230.000, 0.000, 0.400, 0.699, 0.100);
    		new waktuwool = Inventory_Count(playerid, "Wool");
    		SetTimerEx("Prosezkain", waktuwool / 2, false, "i", playerid);
		    ShowProgressbar(playerid, "BEKERJA", Inventory_Count(playerid, "Wool") / 2);
		    Mulaikain[playerid] = 1;
		    pData[playerid][pProseskain] = SetTimerEx("Buatkain", 4000, true, "i", playerid);
		}
		if(GetPVarInt(playerid, "Dutyjahit"))
	    {
	        if(pData[playerid][pDutypenjahit] == 1)
	        {
	            pData[playerid][pDutypenjahit] = 0;
	            SetPlayerSkin(playerid, pData[playerid][pSkin]);
			}
   			else
   			{
   			    pData[playerid][pDutypenjahit] = 1;
   			    SetPlayerSkin(playerid, 37);
			}
		}
	}
	if(newkeys & KEY_CTRL_BACK)
	{
		
        if(IsPlayerInRangeOfPoint(playerid, 2.0, -56.043235, 57.363063, 3.110269))
		{
		    if(kandang1 > 199) return ErrorMsg(playerid, "Kandang penuh, maksimal 200");
		    if(pData[playerid][pAyamhidup] < 1) return ErrorMsg(playerid, "Anda tidak membawa ayam");

			new str[128];
			format(str, sizeof(str), "Anda memasukan %d ayam ke kandang", pData[playerid][pAyamhidup]);
                SuccesMsg(playerid, str);
                GivePlayerMoneyEx(playerid, 30 * pData[playerid][pAyamhidup]);
		        kandang1 += pData[playerid][pAyamhidup];
		        pData[playerid][pAyamhidup] = 0;
		        RemovePlayerAttachedObject(playerid, 9);
		        
		}
		if(IsPlayerInRangeOfPoint(playerid, 2.0, -2115.072021, -2410.956787, 31.267492))
		{
		    if(pData[playerid][pFaction] != 5) return ErrorMsg(playerid, "Anda bukan pedagang");
		    Ayambiasa += Ayampaket;
		    Ayampaket = 0;
		    SuccesMsg(playerid, "Berhasil merestock");
		}
		if(IsPlayerInRangeOfPoint(playerid, 2.0, -57.719161, 52.421863, 3.110))
		{
		    if(kandang2 > 199) return ErrorMsg(playerid, "Kandang penuh, maksimal 200");
		    if(pData[playerid][pAyamhidup] < 1) return ErrorMsg(playerid, "Anda tidak membawa ayam");

			new str[128];
			format(str, sizeof(str), "Anda memasukan %d ayam ke kandang", pData[playerid][pAyamhidup]);
                SuccesMsg(playerid, str);
                GivePlayerMoneyEx(playerid, 30 * pData[playerid][pAyamhidup]);
		        kandang2 += pData[playerid][pAyamhidup];
		        pData[playerid][pAyamhidup] = 0;
		        RemovePlayerAttachedObject(playerid, 9);

		}
		if(IsPlayerInRangeOfPoint(playerid, 2.0, -59.442920, 47.451335, 3.11026))
		{
		    if(kandang3 > 199) return ErrorMsg(playerid, "Kandang penuh, maksimal 200");
		    if(pData[playerid][pAyamhidup] < 1) return ErrorMsg(playerid, "Anda tidak membawa ayam");

			new str[128];
			format(str, sizeof(str), "Anda memasukan %d ayam ke kandang", pData[playerid][pAyamhidup]);
                SuccesMsg(playerid, str);
                GivePlayerMoneyEx(playerid, 30 * pData[playerid][pAyamhidup]);
		        kandang3 += pData[playerid][pAyamhidup];
		        pData[playerid][pAyamhidup] = 0;
		        RemovePlayerAttachedObject(playerid, 9);

		}
		if(IsPlayerInRangeOfPoint(playerid, 2.0, -65.415077, 41.589778, 3.110269))
		{
		    if(kandang4 > 199) return ErrorMsg(playerid, "Kandang penuh, maksimal 200");
		    if(pData[playerid][pAyamhidup] < 1) return ErrorMsg(playerid, "Anda tidak membawa ayam");

			new str[128];
			format(str, sizeof(str), "Anda memasukan %d ayam ke kandang", pData[playerid][pAyamhidup]);
                SuccesMsg(playerid, str);
                GivePlayerMoneyEx(playerid, 30 * pData[playerid][pAyamhidup]);
		        kandang4 += pData[playerid][pAyamhidup];
		        pData[playerid][pAyamhidup] = 0;
		        RemovePlayerAttachedObject(playerid, 9);

		}
		if(IsPlayerInRangeOfPoint(playerid, 2.0, -67.112464, 36.589614, 3.110269))
		{
		    if(kandang5 > 199) return ErrorMsg(playerid, "Kandang penuh, maksimal 200");
		    if(pData[playerid][pAyamhidup] < 1) return ErrorMsg(playerid, "Anda tidak membawa ayam");

			new str[128];
			format(str, sizeof(str), "Anda memasukan %d ayam ke kandang", pData[playerid][pAyamhidup]);
                SuccesMsg(playerid, str);
                GivePlayerMoneyEx(playerid, 30 * pData[playerid][pAyamhidup]);
		        kandang5 += pData[playerid][pAyamhidup];
		        pData[playerid][pAyamhidup] = 0;
		        RemovePlayerAttachedObject(playerid, 9);

		}
	}
	if(PRESSED(KEY_YES) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
        if(IsPlayerInRangeOfPoint(playerid, 5, -2107.4541,-2400.1042,31.4123))
        {
        	return callcmd::ambilayam(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 5, -2110.3020,-2408.2725,31.3098))
        {
        	return callcmd::potongayam(playerid, "");
        }
        else if(IsPlayerInRangeOfPoint(playerid, 5, -2117.5095,-2414.5049,31.2266))
        {
        	return callcmd::packingayam(playerid, "");
        }
    }
	if(newkeys & KEY_FIRE)
	{
        if(IsPlayerInRangeOfPoint(playerid, 9.0, -49.4499, 77.5518, 3.1172))
		{
		    if(pData[playerid][pJob] != 7 && pData[playerid][pJob2] != 7) return ErrorMsg(playerid, "Anda bukan pekerja farmer");
		    
		    if(Ayamhidup < 1) return ErrorMsg(playerid, "Ayam di peternakan sudah habis, nanti respawn lagi");
		    if(Inventory_Count(playerid, "Karung") > 0)
		    {
		        if(pData[playerid][pAyamhidup] > 5) return ErrorMsg(playerid, "Kamu sudah membawa 6 ayam di karung");
		        switch(random(3))
				{
		        	case 0:
					{
						ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
						pData[playerid][pAyamhidup] += 1;
		        		Ayamhidup -= 1;
		        		SuccesMsg(playerid, "Anda berhasil menangkap ayam");
					}
					case 1:
					{
		        		ApplyAnimation(playerid, "PED","KO_skid_front", 4.1, 0, 0, 0, 0, 0, 1);
		        		ErrorMsg(playerid, "Ayam berhasil kabur, silahkan tangkap kembali");
					}
					case 2:
					{
		        		
		        		ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 0, 0, 0, 0, 1);
		        		ErrorMsg(playerid, "Ayam berhasil kabur dan berak di tangan lu dan tangan kamu terkena ee ayam wkkwkw");
					}
				}
		        
			}
			if(Inventory_Count(playerid, "Karung") < 1)
		    {
		        if(pData[playerid][pAyamhidup] > 1) return ErrorMsg(playerid, "Kamu sudah memegang 2 ayam");
		        
		        switch(random(3))
		        {
		        	case 0:
					{
						ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
				        if(pData[playerid][pAyamhidup] == 0)
				        {
				        	SetPlayerAttachedObject(playerid, 9, 16776, 6, 0.100, 0.000, 0.10, 80.3, 3.3, 28.7, 0.010, 0.010, 0.020);
						}
						if(pData[playerid][pAyamhidup] == 1)
				        {
				        	SetPlayerAttachedObject(playerid, 9, 16776, 6, 0.100, 0.000, 0.10, 80.3, 3.3, 28.7, 0.010, 0.010, 0.020);
						}
						pData[playerid][pAyamhidup] += 1;
						Ayamhidup -= 1;
		        		SuccesMsg(playerid, "Anda berhasil menangkap ayam");
					}
					case 1:
					{
		        		ApplyAnimation(playerid, "PED","KO_skid_front", 4.1, 0, 0, 0, 0, 0, 1);
		        		ErrorMsg(playerid, "Ayam berhasil kabur, silahkan tangkap kembali");
					}
					case 2:
					{

		        		ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.1, 0, 0, 0, 0, 0, 1);
		        		ErrorMsg(playerid, "Ayam berhasil kabur dan berak di tangan lu dan tangan kamu terkena ee ayam wkkwkw");
					}
				}
		        
			}
		}
	}
	if(newkeys & KEY_YES)
	{
	    if(GetNearbyGarkot(playerid) >= 0)
		{
			if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Kamu harus login!");
			if(pData[playerid][pInjured] >= 1) return Error(playerid, "Kamu tidak bisa melakukan ini!");
			if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You must be not in Vehicle");
			foreach(new i : Parks)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.3, ppData[i][parkX], ppData[i][parkY], ppData[i][parkZ]))
				{
					pData[playerid][pPark] = i;
					if(GetAnyVehiclePark(i) <= 0) return Error(playerid, "Tidak ada Kendaraan yang diparkirkan disini.");
					new id, count = GetAnyVehiclePark(i), location[4080], lstr[596];

					strcat(location,"No\tVehicle\tPlate\tOwner\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnAnyVehiclePark(itt, i);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", itt, GetVehicleModelName(pvData[id][cModel]), pvData[id][cPlate], GetVehicleOwnerName(id));
						}
						else format(lstr,sizeof(lstr), "%d\t%s\t%s\t%s\n", itt, GetVehicleModelName(pvData[id][cModel]), pvData[id][cPlate], GetVehicleOwnerName(id));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_PICKUPVEH, DIALOG_STYLE_TABLIST_HEADERS,"Parked Vehicle",location,"Pickup","Cancel");
				}
			}
		}
	}
	//
    if(newkeys & KEY_CROUCH)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			foreach(new idx : Gates)
			{
				if(gData[idx][gModel] && IsPlayerInRangeOfPoint(playerid, 8.0, gData[idx][gCX], gData[idx][gCY], gData[idx][gCZ]))
				{
					if(gData[idx][gFaction] > 0)
					{
						if(gData[idx][gFaction] != pData[playerid][pFaction])
							return ErrorMsg(playerid, "This gate only for faction.");
					}
					if(gData[idx][gFamily] > -1)
					{
						if(gData[idx][gFamily] != pData[playerid][pFamily])
							return ErrorMsg(playerid, "This gate only for family.");
					}

					if(gData[idx][gVip] > pData[playerid][pVip])
						return ErrorMsg(playerid, "Your VIP level not enough to enter this gate.");

					if(gData[idx][gAdmin] > pData[playerid][pAdmin])
						return ErrorMsg(playerid, "Your admin level not enough to enter this gate.");

					if(strlen(gData[idx][gPass]))
					{
						new params[256];
						if(sscanf(params, "s[36]", params)) return Usage(playerid, "/gate [password]");
						if(strcmp(params, gData[idx][gPass])) return ErrorMsg(playerid, "Invalid gate password.");
						if(!gData[idx][gStatus])
						{
							gData[idx][gStatus] = 1;
							MoveDynamicObject(gData[idx][gObjID], gData[idx][gOX], gData[idx][gOY], gData[idx][gOZ], gData[idx][gSpeed]);
							SetDynamicObjectRot(gData[idx][gObjID], gData[idx][gORX], gData[idx][gORY], gData[idx][gORZ]);
						}
						else
						{
							gData[idx][gStatus] = 0;
							MoveDynamicObject(gData[idx][gObjID], gData[idx][gCX], gData[idx][gCY], gData[idx][gCZ], gData[idx][gSpeed]);
							SetDynamicObjectRot(gData[idx][gObjID], gData[idx][gCRX], gData[idx][gCRY], gData[idx][gCRZ]);
						}
					}
					else
					{
						if(!gData[idx][gStatus])
						{
							gData[idx][gStatus] = 1;
							MoveDynamicObject(gData[idx][gObjID], gData[idx][gOX], gData[idx][gOY], gData[idx][gOZ], gData[idx][gSpeed]);
							SetDynamicObjectRot(gData[idx][gObjID], gData[idx][gORX], gData[idx][gORY], gData[idx][gORZ]);
						}
						else
						{
							gData[idx][gStatus] = 0;
							MoveDynamicObject(gData[idx][gObjID], gData[idx][gCX], gData[idx][gCY], gData[idx][gCZ], gData[idx][gSpeed]);
							SetDynamicObjectRot(gData[idx][gObjID], gData[idx][gCRX], gData[idx][gCRY], gData[idx][gCRZ]);
						}
					}
					return 1;
				}
			}
		}
	}
    
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_NO))
	{
	    if(pData[playerid][CarryingLumber])
		{
			Player_DropLumber(playerid);
		}
		else if(pData[playerid][CarryingBox])
		{
			Player_DropBox(playerid);
		}
		else if(pData[playerid][CarryingLog] == 0)
		{
			Player_DropLog(playerid, pData[playerid][CarryingLog]);
			Info(playerid, "You dropping metal ore.");
			DisablePlayerCheckpoint(playerid);
		}
		else if(pData[playerid][CarryingLog] == 1)
		{
			Player_DropLog(playerid, pData[playerid][CarryingLog]);
			Info(playerid, "You dropping coal ore.");
			DisablePlayerCheckpoint(playerid);
		}
	}
	if((newkeys & KEY_SECONDARY_ATTACK))
    {
        
		foreach(new did : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
			{
				if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
					return ErrorMsg(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

				if(dData[did][dLocked])
					return ErrorMsg(playerid, "This entrance is locked at the moment.");
					
				if(dData[did][dFaction] > 0)
				{
					if(dData[did][dFaction] != pData[playerid][pFaction])
						return ErrorMsg(playerid, "This door only for faction.");
				}
				if(dData[did][dFamily] > 0)
				{
					if(dData[did][dFamily] != pData[playerid][pFamily])
						return ErrorMsg(playerid, "This door only for family.");
				}
				
				if(dData[did][dVip] > pData[playerid][pVip])
					return ErrorMsg(playerid, "Your VIP level not enough to enter this door.");
				
				if(dData[did][dAdmin] > pData[playerid][pAdmin])
					return ErrorMsg(playerid, "Your admin level not enough to enter this door.");
					
                if(GetPlayerMoney(playerid) < dData[did][dDuit]) return ErrorMsg(playerid, "Uang mu tidak mencukupi untuk masuk/keluar!.");
				{
                    GivePlayerMoneyEx(playerid, -dData[did][dDuit]);
                    Info(playerid, "-%s", FormatMoney(dData[did][dDuit]));
				}
					
				if(strlen(dData[did][dPass]))
				{
					new params[256];
					if(sscanf(params, "s[256]", params)) return Usage(playerid, "/enter [password]");
					if(strcmp(params, dData[did][dPass])) return ErrorMsg(playerid, "Invalid door password.");
					
					if(dData[did][dCustom])
					{
						SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					else
					{
						SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					pData[playerid][pInDoor] = did;
					SetPlayerInterior(playerid, dData[did][dIntint]);
					SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, 0);
				}
				else
				{
					if(dData[did][dCustom])
					{
						SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]+0.1, dData[did][dIntposA]);
					}
					else
					{
						SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]+0.1, dData[did][dIntposA]);
					}
					TogglePlayerControllable(playerid, 0);
					SetTimerEx("Bekuplayer", 6000, false, "i", playerid);
					pData[playerid][pInDoor] = did;
					SetPlayerInterior(playerid, dData[did][dIntint]);
					SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, 0);
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]))
			{
				if(dData[did][dFaction] > 0)
				{
					if(dData[did][dFaction] != pData[playerid][pFaction])
						return ErrorMsg(playerid, "This door only for faction.");
				}
				
				if(dData[did][dCustom])
				{
					SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
				}
				else
				{
					SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
				}
				pData[playerid][pInDoor] = -1;
				SetPlayerInterior(playerid, dData[did][dExtint]);
				SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
			}
        }
		//Bisnis
		foreach(new bid : Bisnis)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
			{
				if(bData[bid][bIntposX] == 0.0 && bData[bid][bIntposY] == 0.0 && bData[bid][bIntposZ] == 0.0)
					return ErrorMsg(playerid, "Interior bisnis masih kosong, atau tidak memiliki interior.");

				if(bData[bid][bLocked])
					return ErrorMsg(playerid, "This bisnis is locked!");
					
				pData[playerid][pInBiz] = bid;
				SetPlayerPositionEx(playerid, bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ], bData[bid][bIntposA]);
				
				SetPlayerInterior(playerid, bData[bid][bInt]);
				SetPlayerVirtualWorld(playerid, bid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inbisnisid = pData[playerid][pInBiz];
		if(pData[playerid][pInBiz] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, bData[inbisnisid][bIntposX], bData[inbisnisid][bIntposY], bData[inbisnisid][bIntposZ]))
		{
			pData[playerid][pInBiz] = -1;
			SetPlayerPositionEx(playerid, bData[inbisnisid][bExtposX], bData[inbisnisid][bExtposY], bData[inbisnisid][bExtposZ], bData[inbisnisid][bExtposA]);
			
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Houses
		foreach(new hid : Houses)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
			{
				if(hData[hid][hIntposX] == 0.0 && hData[hid][hIntposY] == 0.0 && hData[hid][hIntposZ] == 0.0)
					return ErrorMsg(playerid, "Interior house masih kosong, atau tidak memiliki interior.");

				if(hData[hid][hLocked])
					return ErrorMsg(playerid, "This house is locked!");
				
				pData[playerid][pInHouse] = hid;
				SetPlayerPositionEx(playerid, hData[hid][hIntposX], hData[hid][hIntposY], hData[hid][hIntposZ], hData[hid][hIntposA]);

				SetPlayerInterior(playerid, hData[hid][hInt]);
				SetPlayerVirtualWorld(playerid, hid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inhouseid = pData[playerid][pInHouse];
		if(pData[playerid][pInHouse] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, hData[inhouseid][hIntposX], hData[inhouseid][hIntposY], hData[inhouseid][hIntposZ]))
		{
			pData[playerid][pInHouse] = -1;
			SetPlayerPositionEx(playerid, hData[inhouseid][hExtposX], hData[inhouseid][hExtposY], hData[inhouseid][hExtposZ], hData[inhouseid][hExtposA]);
			
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Family
		foreach(new fid : FAMILYS)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ]))
			{
				if(fData[fid][fIntposX] == 0.0 && fData[fid][fIntposY] == 0.0 && fData[fid][fIntposZ] == 0.0)
					return ErrorMsg(playerid, "Interior masih kosong, atau tidak memiliki interior.");

				if(pData[playerid][pFaction] == 0)
					if(pData[playerid][pFamily] == -1)
						return ErrorMsg(playerid, "You dont have registered for this door!");
					
				pData[playerid][pInFamily] = fid;	
				SetPlayerPositionEx(playerid, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ], fData[fid][fIntposA]);

				SetPlayerInterior(playerid, fData[fid][fInt]);
				SetPlayerVirtualWorld(playerid, fid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
			new difamily = pData[playerid][pInFamily];
			if(pData[playerid][pInFamily] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, fData[difamily][fIntposX], fData[difamily][fIntposY], fData[difamily][fIntposZ]))
			{
				pData[playerid][pInFamily] = -1;	
				SetPlayerPositionEx(playerid, fData[difamily][fExtposX], fData[difamily][fExtposY], fData[difamily][fExtposZ], fData[difamily][fExtposA]);

				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
			}
        }
		foreach(new vid : Vendings)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, VendingData[vid][vendingX], VendingData[vid][vendingY], VendingData[vid][vendingZ]) && strcmp(VendingData[vid][vendingOwner], "-"))
			{
				SetPlayerFacingAngle(playerid, VendingData[vid][vendingA]);
				ApplyAnimation(playerid, "VENDING", "VEND_USE", 10.0, 0, 0, 0, 0, 0, 1);
				SetTimerEx("VendingNgentot", 3000, false, "i", playerid);
			}
		}
	}
	//SAPD Taser/Tazer
	if(newkeys & KEY_FIRE && TaserData[playerid][TaserEnabled] && GetPlayerWeapon(playerid) == 0 && !IsPlayerInAnyVehicle(playerid) && TaserData[playerid][TaserCharged])
	{
  		TaserData[playerid][TaserCharged] = false;

	    new Float: x, Float: y, Float: z, Float: health;
     	GetPlayerPos(playerid, x, y, z);
	    PlayerPlaySound(playerid, 6003, 0.0, 0.0, 0.0);
	    ApplyAnimation(playerid, "KNIFE", "KNIFE_3", 4.1, 0, 1, 1, 0, 0, 1);
		pData[playerid][pActivityTime] = 0;
	    TaserData[playerid][ChargeTimer] = SetTimerEx("ChargeUp", 1000, true, "i", playerid);
		PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Recharge...");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);

	    for(new i, maxp = GetPlayerPoolSize(); i <= maxp; ++i)
		{
	        if(!IsPlayerConnected(i)) continue;
          	if(playerid == i) continue;
          	if(TaserData[i][TaserCountdown] != 0) continue;
          	if(IsPlayerInAnyVehicle(i)) continue;
			if(GetPlayerDistanceFromPoint(i, x, y, z) > 2.0) continue;
			ClearAnimations(i, 1);
			TogglePlayerControllable(i, false);
   			ApplyAnimation(i, "CRACK", "crckdeth2", 4.1, 0, 0, 0, 1, 0, 1);
			PlayerPlaySound(i, 6003, 0.0, 0.0, 0.0);

			GetPlayerHealth(i, health);
			TaserData[i][TaserCountdown] = TASER_BASETIME + floatround((100 - health) / 12);
   			Info(i, "You got tased for %d secounds!", TaserData[i][TaserCountdown]);
			TaserData[i][GetupTimer] = SetTimerEx("TaserGetUp", 1000, true, "i", i);
			break;
	    }
	}
	//-----[ Vehicle ]-----	
	//Vehicle
	if((newkeys & KEY_NO ))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			return callcmd::light(playerid, "");
		}
	}
	if(newkeys & KEY_HANDBRAKE && IsPlayerInRangeOfPoint(playerid, 5.0, 1283.24, -1370.01, 13.83))
	{
		switch(GetPlayerWeapon(playerid))
		{
			case 22 .. 33:
			{
				

			    if(Warung == true) return Error(playerid, "Anda harus menunggu untuk melakukan rob.");
				/*if(!OnPlayerRequestRobbery(playerid, Actorrob))
				{
					return 1;
				}

				if(gettime() - Testrob < 60 * ROBBERY_WAIT_TIME) {
					return CallLocalFunction("OnPlayerStartRobbery", "iii", playerid, Actorrob, true);
				}

				Testrob = gettime();*/
				
				RunActorAnimationSequence(playerid, Actorrob, 0);
				Tesaje = Create3DTextLabel("Penjaga : Aaaaa ampun jangan sakiti aku", COLOR_WHITE, 1285.86, -1368.83, 13.83 + 1.0, 5.0, -1);
			//	ApplyActorAnimation(Actorrob, "ROB_BANK","SHP_HandsUp_Scr", 4.1, 0, 1, 1, 1, 0);

				CallLocalFunction("OnPlayerStartRobbery", "iii", playerid, Actorrob, false);
			}
		}
	}

	
	if((newkeys & KEY_YES ))
 	{
		for(new i = 0; i < 17; i++)
		{
			TextDrawShowForPlayer(playerid, F1FIVEM[i]);
		}
		TextDrawShowForPlayer(playerid, PANELINVENTORY);
		TextDrawShowForPlayer(playerid, PANELHANDPHONE);
		TextDrawShowForPlayer(playerid, PANELPAKAIAN);
		TextDrawShowForPlayer(playerid, PANELDOKUMEN);
		TextDrawShowForPlayer(playerid, PANELEMOTE);
		TextDrawShowForPlayer(playerid, PANELKTP);
		TextDrawShowForPlayer(playerid, PANELTRUNK);
		TextDrawShowForPlayer(playerid, PANELKENDARAAN);
		SelectTextDraw(playerid, COLOR_LBLUE);
	}

	if(newkeys & KEY_CTRL_BACK)
	{
	    if(GetNearbyGarkot(playerid) >= 0)
		{
			ShowPlayerDialog(playerid, DIALOG_GARKOT, DIALOG_STYLE_MSGBOX, "Garasi Kota ", ">> {FFFF00}PARKVEH: {ffffff}untuk memasukan transportasi.\n>> {FFFF00}PICKUPVEH: {ffffff}untuk mengambil transportasi.","ParkVeh", "PickupVeh");
		}
	}
	if(newkeys & KEY_CROUCH)
	{
	    if(GetNearbyGarkot(playerid) >= 0)
		{
			ShowPlayerDialog(playerid, DIALOG_GARKOT, DIALOG_STYLE_MSGBOX, "Garasi Kota ", ">> {FFFF00}PARKVEH: {ffffff}untuk memasukan transportasi.\n>> {FFFF00}PICKUPVEH: {ffffff}untuk mengambil transportasi.","ParkVeh", "PickupVeh");
		}
	}
	if(PRESSED( KEY_CTRL_BACK ))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pCuffed] == 0 && pData[playerid][pKenatazer] == 0)
		{
			ClearAnimations(playerid);
			StopLoopingAnim(playerid);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
    }
	//-----[ Toll System ]-----	
	if(newkeys & KEY_CROUCH)
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
		{
			new forcount = MuchNumber(sizeof(BarrierInfo));
			for(new i;i < forcount;i ++)
			{
				if(i < sizeof(BarrierInfo))
				{
					if(IsPlayerInRangeOfPoint(playerid,8,BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]))
					{
						if(BarrierInfo[i][brOrg] == TEAM_NONE)
						{
							if(!BarrierInfo[i][brOpen])
							{
								if(pData[playerid][pMoney] < 5)
								{
									Toll(playerid, "Uangmu tidak cukup untuk membayar toll");
								}
								else
								{
									MoveDynamicObject(gBarrier[i],BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.7,BARRIER_SPEED,0.0,0.0,BarrierInfo[i][brPos_A]+180);
									SetTimerEx("BarrierClose",15000,0,"i",i);
									BarrierInfo[i][brOpen] = true;
									Toll(playerid, "Cepat!!! Toll akan menutup Kembali setelah 15 detik");
									GivePlayerMoneyEx(playerid, -5);
									if(BarrierInfo[i][brForBarrierID] != -1)
									{
										new barrierid = BarrierInfo[i][brForBarrierID];
										MoveDynamicObject(gBarrier[barrierid],BarrierInfo[barrierid][brPos_X],BarrierInfo[barrierid][brPos_Y],BarrierInfo[barrierid][brPos_Z]+0.7,BARRIER_SPEED,0.0,0.0,BarrierInfo[barrierid][brPos_A]+180);
										BarrierInfo[barrierid][brOpen] = true;

									}
								}
							}
						}
						else Toll(playerid, "Kamu tidak bisa membuka pintu Toll ini!");
						break;
					}
				}
			}
		}
		return true;		
	}
	if(GetPVarInt(playerid, "UsingSprunk"))
	{
		if(pData[playerid][pEnergy] >= 100 )
		{
  			Info(playerid, " Kamu terlalu banyak minum.");
	   	}
	   	else
	   	{
		    pData[playerid][pEnergy] += 5;
		}
	}
	//Vote System
	if(VoteOn && VoteVoted[playerid] == 0)
	{
	    if(newkeys == KEY_YES)
	    {
	        VoteY++;
	        VoteVoted[playerid] = 1;
	        SendClientMessage(playerid, COLOR_RIKO, "[VOTE]{FFFFFF} Anda memilih {33AA33}IYA{FFFFFF}.");
		}
	    if(newkeys == KEY_NO)
	    {
		    VoteN++;
		    VoteVoted[playerid] = 1;
		    SendClientMessage(playerid, COLOR_RIKO, "[VOTE]{FFFFFF} Anda memilih {FF0000}TIDAK{FFFFFF}.");
	    }
	}
	if(RELEASED(KEY_FIRE) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pBreaking] && pData[playerid][pTargetPv] != -1)
	{
	    new id = pData[playerid][pTargetPv];
	    if(IsValidVehicle(pvData[id][cVeh]))
	    {
			new Float:cX, Float:cY, Float:cZ;
			new Float:dX, Float:dY, Float:dZ;
			new rand = random(17);
			GetVehicleModelInfo(pvData[id][cModel], VEHICLE_MODEL_INFO_FRONTSEAT, cX, cY, cZ);
			GetVehicleRelativePos(pvData[id][cVeh], dX, dY, dZ, -cX - 0.5, cY, cZ);

			if(pvData[id][cBreaken] != playerid)
			    return ErrorMsg(playerid, "Kendaraan ini sudah rusak oleh seseorang!");

			if(IsPlayerInRangeOfPoint(playerid, 1.2, dX, dY, dZ))
			{
			    if(pvData[id][cCooldown] <= 0)
			    {
					if(pvData[id][cBreaking] < 100)
					{
					    pvData[id][cBreaking] += rand;
					    new str[64];
					    if(pvData[id][cBreaking] < 100)
					    {
					    	format(str, sizeof(str), "Progress: ~y~%d%", pvData[id][cBreaking]);
						}
						else
						{
						    format(str, sizeof(str), "Progress: ~y~100%");
						}
					    ShowMessage(playerid, str, 2);
					    pvData[id][cCooldown] = 1;
					}
					else
					{
					    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* CRASHH! Heard the window of vehicle was breaking (( %s ))", ReturnName(playerid));
					    ShowMessage(playerid, "Door's ~g~Unlocked!", 3);
					    SwitchVehicleLight(pvData[id][cVeh], true);
					    pvData[id][cBreaken] = INVALID_PLAYER_ID;
					    pvData[id][cBreaking] = 0;
					    pData[playerid][pBreaking] = false;
					    pvData[id][cLocked] = 0;
					    SwitchVehicleDoors(pvData[id][cVeh], false);
						SwitchVehicleAlarm(pvData[id][cVeh], true);
						FlashTime[pvData[id][cVeh]] = SetTimerEx("OnLightFlash", 115, true, "d", pvData[id][cVeh]);
						SetTimerEx("AlarmOff", 10000, false, "d", pvData[id][cVeh]);

						SendFactionMessage(1, COLOR_RADIO, "DISPATCH: an %s on %s has been breaken/stolen by someone!", GetVehicleName(pvData[id][cVeh]), GetPlayerLocation(playerid));
						foreach(new i : Player)if(pvData[id][cOwner] == pData[i][pID])
						{
						    SendClientMessageEx(i, COLOR_LIGHTRED, "NOTIFY: {FFFFFF}Someone just breaking your {FFFF00}%s {FFFFFF}at %s!", GetVehicleName(pvData[id][cVeh]), GetPlayerLocation(playerid));
						}
					}
				}
			}
		}
	}
	if(PRESSED(KEY_FIRE) && GetPVarInt(playerid, "GraffitiCreating") == 0  && GetPlayerWeapon(playerid) == 41 )
	{
		if(!IsValidDynamicObject(POBJECT[playerid]))
    	{
		    spraytimerch[playerid] = SetTimerEx( "sprayingch", 1000, true, "i", playerid );
		    SetPVarInt(playerid, "GraffitiMenu", 1);
	    	return 1;
	    }
	    return ShowPlayerDialog(playerid, DIALOG_GDOBJECT, DIALOG_STYLE_MSGBOX, "Graffiti", "Anda sudah membuat graffiti\n\nJika anda ingin melanjutkan, text sebelumnya akan terhapus.", "Oke", "Cancel");
	}
	if(RELEASED( KEY_FIRE ) && GetPVarInt(playerid, "GraffitiMenu") == 1 && GetPlayerWeapon(playerid) == 41)
	{
	    KillTimer( spraytimerch[playerid] );
	    graffmenup[playerid] = 0;
	    DeletePVar(playerid, "GraffitiMenu");
	    return 1;
	}
	if( RELEASED( KEY_FIRE ) && GetPVarInt(playerid, "GraffitiCreating") == 1 )
	{
		if(GetPlayerWeapon(playerid) == 41 )
		{
		    KillTimer( spraytimer[playerid] );
	    	sprayammount[playerid] --;
    	 	spraytimerx[playerid] = SetTimerEx( "killgr", 90000, true, "i", playerid );
		}
	}
	// STREAMER MASK SYSTEM
	if(PRESSED( KEY_WALK ))
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			if(pData[playerid][pAdmin] < 2)
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				if(GetEngineStatus(vehicleid))
				{
					if(GetVehicleSpeedKMH(vehicleid) <= 40)
					{
						new playerState = GetPlayerState(playerid);
						if(playerState == PLAYER_STATE_DRIVER)
						{
							SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: "GREY2_E"%s have been auto kicked for vehicle engine hack!", pData[playerid][pName]);
							KickEx(playerid);
						}
					}
				}
			}	
		}
	}
	if(PRESSED( KEY_CTRL_BACK ))
	{
	    if(IsPlayerInRangeOfPoint(playerid, 8.0, -814.395996, 2753.017333, 46.000000))
		{
		    if(pData[playerid][pRedMoney] < 1) return ErrorMsg(playerid, "Gk punya red money");
		    if(pData[playerid][pRedMoney] < 50000) return ErrorMsg(playerid, "Gak bisa kurang dari 50000");
			GivePlayerMoneyEx(playerid, pData[playerid][pRedMoney]/5);
			pData[playerid][pRedMoney] = 0;
			SuccesMsg(playerid, "Anda sukses menukar redmoney ke redmoney");
		}
	    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
		{
		    if(IsPlayerInRangeOfPoint(playerid, 8.0, 743.5262, -1332.2343, 13.8414))
			{
	  			callcmd::despawnsana(playerid, "");
			}
			if(IsPlayerInRangeOfPoint(playerid, 8.0, 1260.391601, -1661.296752, 13.576869))
			{
	  			callcmd::despawnpd(playerid, "");
			}
			if(IsPlayerInRangeOfPoint(playerid, 8.0, 1131.5339, -1332.3248, 13.5797))
			{
	  			callcmd::despawnmd(playerid, "");
			}
		}
		if(!IsPlayerInAnyVehicle(playerid))
		{
		    if(IsPlayerInRangeOfPoint(playerid, 8.0, 743.5262, -1332.2343, 13.8414))
			{
	  			callcmd::spawnsana(playerid, "");
			}
			if(IsPlayerInRangeOfPoint(playerid, 8.0, 1260.391601, -1661.296752, 13.576869))
			{
	  			callcmd::spawnpd(playerid, "");
			}
			if(IsPlayerInRangeOfPoint(playerid, 8.0, 1131.5339, -1332.3248, 13.5797))
			{
	  			callcmd::spawnmd(playerid, "");
			}
		}
	}
	if(PRESSED( KEY_YES ))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
		{
			foreach(new did : Doors)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
				{
					if(dData[did][dGarage] == 1)
					{
						if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
							return ErrorMsg(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

						if(dData[did][dLocked])
							return ErrorMsg(playerid, "This entrance is locked at the moment.");
							
						if(dData[did][dFaction] > 0)
						{
							if(dData[did][dFaction] != pData[playerid][pFaction])
								return ErrorMsg(playerid, "This door only for faction.");
						}
						if(dData[did][dFamily] > 0)
						{
							if(dData[did][dFamily] != pData[playerid][pFamily])
								return ErrorMsg(playerid, "This door only for family.");
						}
						
						if(dData[did][dVip] > pData[playerid][pVip])
							return ErrorMsg(playerid, "Your VIP level not enough to enter this door.");
						
						if(dData[did][dAdmin] > pData[playerid][pAdmin])
							return ErrorMsg(playerid, "Your admin level not enough to enter this door.");
							
						if(strlen(dData[did][dPass]))
						{
							new params[256];
							if(sscanf(params, "s[256]", params)) return Usage(playerid, "/enter [password]");
							if(strcmp(params, dData[did][dPass])) return ErrorMsg(playerid, "Invalid door password.");
							
							if(dData[did][dCustom])
							{
								SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							else
							{
								SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							pData[playerid][pInDoor] = did;
							SetPlayerInterior(playerid, dData[did][dIntint]);
							SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
							SetCameraBehindPlayer(playerid);
							SetPlayerWeather(playerid, 0);
						}
						else
						{
							if(dData[did][dCustom])
							{
								SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							else
							{
								SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							pData[playerid][pInDoor] = did;
							SetPlayerInterior(playerid, dData[did][dIntint]);
							SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
							SetCameraBehindPlayer(playerid);
							SetPlayerWeather(playerid, 0);
						}
					}
				}
				if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]))
				{
					if(dData[did][dGarage] == 1)
					{
						if(dData[did][dFaction] > 0)
						{
							if(dData[did][dFaction] != pData[playerid][pFaction])
								return ErrorMsg(playerid, "This door only for faction.");
						}
					
						if(dData[did][dCustom])
						{
							SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
						}
						else
						{
							SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
						}
						pData[playerid][pInDoor] = -1;
						SetPlayerInterior(playerid, dData[did][dExtint]);
						SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, WorldWeather);
					}
				}
			}
		}
	}
	if(IsKeyJustDown(KEY_SECONDARY_ATTACK, newkeys, oldkeys))
	{
		if(GetPVarInt(playerid, "UsingSprunk"))
		{
			DeletePVar(playerid, "UsingSprunk");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
	}
	if(takingselfie[playerid] == 1)
	{
		if(PRESSED(KEY_ANALOG_RIGHT))
		{
			GetPlayerPos(playerid,lX[playerid],lY[playerid],lZ[playerid]);
			static Float: n1X, Float: n1Y;
		    if(Degree[playerid] >= 360) Degree[playerid] = 0;
		    Degree[playerid] += Speed;
		    n1X = lX[playerid] + Radius * floatcos(Degree[playerid], degrees);
		    n1Y = lY[playerid] + Radius * floatsin(Degree[playerid], degrees);
		    SetPlayerCameraPos(playerid, n1X, n1Y, lZ[playerid] + Height);
		    SetPlayerCameraLookAt(playerid, lX[playerid], lY[playerid], lZ[playerid]+1);
		    SetPlayerFacingAngle(playerid, Degree[playerid] - 90.0);
		}
		if(PRESSED(KEY_ANALOG_LEFT))
		{
		    GetPlayerPos(playerid,lX[playerid],lY[playerid],lZ[playerid]);
			static Float: n1X, Float: n1Y;
		    if(Degree[playerid] >= 360) Degree[playerid] = 0;
		    Degree[playerid] -= Speed;
		    n1X = lX[playerid] + Radius * floatcos(Degree[playerid], degrees);
		    n1Y = lY[playerid] + Radius * floatsin(Degree[playerid], degrees);
		    SetPlayerCameraPos(playerid, n1X, n1Y, lZ[playerid] + Height);
		    SetPlayerCameraLookAt(playerid, lX[playerid], lY[playerid], lZ[playerid]+1);
		    SetPlayerFacingAngle(playerid, Degree[playerid] - 90.0);
		}
	}
	/*if(StatusCrateTerangkat == true)
    {
        if(PRESSED (KEY_JUMP))
        {
            ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
        }
    }*/
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	//JOB KURIR
	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
	{
		/*if(IsAKurirVeh(GetPlayerVehicleID(playerid)))
		{
			GameTextForPlayer(playerid, "~w~PENGANTARAN BARANG TERSEDIA /STARTKURIR", 5000, 3);
			SendClientMessage(playerid, 0x76EEC6FF, "* Tampaknya ada paket yang tidak terkirim di Burrito Anda.");
		}*/
		if(IsABaggageVeh(GetPlayerVehicleID(playerid)))
		{
			InfoTD_MSG(playerid, 8000, "/~g~startbg");
		}
	}
	if(newstate == PLAYER_STATE_WASTED && pData[playerid][pJail] < 1)
    {	
		if(pData[playerid][pInjured] == 0)
        {
            pData[playerid][pInjured] = 1;
            SetPlayerHealthEx(playerid, 99999);

            pData[playerid][pInt] = GetPlayerInterior(playerid);
            pData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);

            GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
            GetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
        }
        else
        {
            pData[playerid][pHospital] = 1;
        }
	}
	//Spec Player
	new vehicleid = GetPlayerVehicleID(playerid);
	if(newstate == PLAYER_STATE_ONFOOT)
	{
		if(pData[playerid][playerSpectated] != 0)
		{
			foreach(new ii : Player)
			{
				if(pData[ii][pSpec] == playerid)
				{
					PlayerSpectatePlayer(ii, playerid);
					Servers(ii, ,"%s(%i) is now on foot.", pData[playerid][pName], playerid);
				}
			}
		}
	}
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
		if(pData[playerid][pInjured] == 1)
        {
            //RemoveFromVehicle(playerid);
			RemovePlayerFromVehicle(playerid);
            SetPlayerHealthEx(playerid, 99999);
        }
		foreach (new ii : Player) if(pData[ii][pSpec] == playerid) 
		{
            PlayerSpectateVehicle(ii, GetPlayerVehicleID(playerid));
        }
	}
	if(oldstate == PLAYER_STATE_PASSENGER)
	{
		//TextDrawHideForPlayer(playerid, TDEditor_TD[11]);
		TextDrawHideForPlayer(playerid, DPvehfare[playerid]);
	}
	if(oldstate == PLAYER_STATE_DRIVER)
    {
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED)
            return RemovePlayerFromVehicle(playerid);

        for(new i = 0; i < 7; i++)
		{
		    PlayerTextDrawHide(playerid, VEHFIVEM[playerid][i]);
		}
		
		if(pData[playerid][pTaxiDuty] == 1)
		{
			pData[playerid][pTaxiDuty] = 0;
			SetPlayerColor(playerid, COLOR_WHITE);
			Servers(playerid, "You are no longer on taxi duty!");
		}
		if(pData[playerid][pFare] == 1)
		{
			KillTimer(pData[playerid][pFareTimer]);
			Info(playerid, "Anda telah menonaktifkan taxi fare pada total: {00FF00}%s", FormatMoney(pData[playerid][pTotalFare]));
			pData[playerid][pFare] = 0;
			pData[playerid][pTotalFare] = 0;
		}
		if(pData[playerid][pIsStealing] == 1)
		{
			pData[playerid][pIsStealing] = 0;
			pData[playerid][pLastChopTime] = 0;
			Info(playerid, "Kamu gagal mencuri kendaraan ini, di karenakan kamu keluar kendaraan saat proses pencurian!");
			KillTimer(MalingKendaraan);

		}
        
		HidePlayerProgressBar(playerid, pData[playerid][FUELBAR]);
	    HidePlayerProgressBar(playerid, pData[playerid][HEALTHBAR]);
	}
	else if(newstate == PLAYER_STATE_DRIVER)
    {
		/*if(IsSRV(vehicleid))
		{
			new tstr[128], price = GetVehicleCost(GetVehicleModel(vehicleid));
			format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleName(vehicleid), FormatMoney(price));
			ShowPlayerDialog(playerid, DIALOG_BUYPV, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
		}
		else if(IsVSRV(vehicleid))
		{
			new tstr[128], price = GetVipVehicleCost(GetVehicleModel(vehicleid));
			if(pData[playerid][pVip] == 0)
			{
				Error(playerid, "Kendaraan Khusus VIP Player.");
				RemovePlayerFromVehicle(playerid);
				//SetVehicleToRespawn(GetPlayerVehicleID(playerid));
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
			else
			{
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d Coin", GetVehicleName(vehicleid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYVIPPV, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
		}*/
		
		foreach(new pv : PVehicles)
		{
			if(vehicleid == pvData[pv][cVeh])
			{
				if(IsABike(vehicleid) || GetVehicleModel(vehicleid) == 424)
				{
					if(pvData[pv][cLocked] == 1)
					{
						RemovePlayerFromVehicle(playerid);
						//new Float:slx, Float:sly, Float:slz;
						//GetPlayerPos(playerid, slx, sly, slz);
						//SetPlayerPos(playerid, slx, sly, slz);
						Error(playerid, "This bike is locked by owner.");
						return 1;
					}
				}
			}
			
		}
		
		if(IsASweeperVeh(vehicleid))
		{
		    if(pData[playerid][pDutysweep] < 1) return ErrorMsg(playerid, "Kamu belum duty sweeper");
			ShowPlayerDialog(playerid, DIALOG_SWEEPER, DIALOG_STYLE_MSGBOX, "Side Job - Sweeper", "Anda akan bekerja sebagai pembersih jalan?", "Start Job", "Close");
		}
		if(IsAPaperVeh(vehicleid))
		{
			ShowPlayerDialog(playerid, DIALOG_PAPER, DIALOG_STYLE_MSGBOX, "Side Job - Paper", "Anda akan bekerja sebagai pengantar koran?", "Start Job", "Close");
		}
		/*if(IsABusVeh(vehicleid))
		{
			ShowPlayerDialog(playerid, DIALOG_BUS, DIALOG_STYLE_MSGBOX, "Side Job - Bus", "Anda akan bekerja sebagai pengangkut penumpang bus?", "Start Job", "Close");
		}*/
		/*if(IsABusVeh(vehicleid))
		{
			pData[playerid][pSideJob] = 2;
			pData[playerid][pBus] = 1;
			SetPlayerRaceCheckpoint(playerid, 2, buspoint1, buspoint1, 4.0);
			pData[playerid][pCheckPoint] = CHECKPOINT_BUS;
			InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
		}*/
		if(IsAForVeh(vehicleid))
		{
		    if(pData[playerid][pDutyfork] < 1) return ErrorMsg(playerid, "Kamu belum duty forklift");
			ShowPlayerDialog(playerid, DIALOG_FORKLIFT, DIALOG_STYLE_MSGBOX, "Side Job - Forklift", "Anda akan bekerja sebagai pemuat barang dengan Forklift?", "Start Job", "Close");
		}
		if(IsAMowerVeh(vehicleid))
		{
			ShowPlayerDialog(playerid, DIALOG_MOWER, DIALOG_STYLE_MSGBOX, "Side Job - Mower", "Anda akan bekerja sebagai Mower?", "Start Job", "Close");
		}
		if(IsABaggageVeh(vehicleid))
		{
			if(pData[playerid][pJob] != 10 && pData[playerid][pJob2] != 10)
			{
				RemovePlayerFromVehicle(playerid);
                Error(playerid, "Kamu tidak bekerja sebagai Baggage Airport");
			}
		}
		if(IsADmvVeh(vehicleid))
        {
            if(!pData[playerid][pDriveLicApp])
            {
                RemovePlayerFromVehicle(playerid);
                Error(playerid, "Kamu tidak sedang mengikuti Tes Mengemudi");
			}
			else 
			{
				Info(playerid, "Silahkan ikuti Checkpoint yang ada di GPS mobil ini.");
				SetPlayerRaceCheckpoint(playerid, 1, dmvpoint1, dmvpoint1, 5.0);
			}
		}
		/*if(IsAKurirVeh(vehicleid))
		{
			if(pData[playerid][pJob] != 8 && pData[playerid][pJob2] != 8)
			{
				RemovePlayerFromVehicle(playerid);
                Error(playerid, "Kamu tidak bekerja sebagai Courier");
			}
		}*/
		/*if(IsSAPDCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 1)
			{
			    RemovePlayerFromVehicle(playerid);
			    Error(playerid, "Anda bukan SAPD!");
			}
		}*/
		/*
		if(IsSAMDCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 3)
			{
			    RemovePlayerFromVehicle(playerid);
			    Error(playerid, "Anda bukan SAMD!");
			}
		}
		if(IsSANACar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 4)
			{
			    RemovePlayerFromVehicle(playerid);
			    Error(playerid, "Anda bukan SANEWS!");
			}
		}*/
		if(!IsEngineVehicle(vehicleid))
        {
            SwitchVehicleEngine(vehicleid, true);
        }
		if(IsEngineVehicle(vehicleid) && pData[playerid][pDriveLic] <= 0)
        {
            Info(playerid, "Anda tidak memiliki surat izin mengemudi, berhati-hatilah.");
        }
		if(pData[playerid][pHBEMode] == 1)
		{
            for(new i = 0; i < 7; i++)
			{
			    PlayerTextDrawShow(playerid, VEHFIVEM[playerid][i]);
			}
		}
		else
		{
		
		}
		new Float:health;
        GetVehicleHealth(GetPlayerVehicleID(playerid), health);
        VehicleHealthSecurityData[GetPlayerVehicleID(playerid)] = health;
        VehicleHealthSecurity[GetPlayerVehicleID(playerid)] = true;
		
		if(pData[playerid][playerSpectated] != 0)
  		{
			foreach(new ii : Player)
			{
    			if(pData[ii][pSpec] == playerid)
			    {
        			PlayerSpectateVehicle(ii, vehicleid);
				    Servers(ii, "%s(%i) is now driving a %s(%d).", pData[playerid][pName], playerid, GetVehicleModelName(GetVehicleModel(vehicleid)), vehicleid);
				}
			}
		}
		SetPVarInt(playerid, "LastVehicleID", vehicleid);
	}
	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    foreach(new i : Player)
	{
	    if(GetPVarType(i, "BBArea"))
	    {
	        if(areaid == GetPVarInt(i, "BBArea"))
	        {
	            new station[256];
	            GetPVarString(i, "BBStation", station, sizeof(station));
	            if(!isnull(station))
				{
					PlayStream(playerid, station, GetPVarFloat(i, "BBX"), GetPVarFloat(i, "BBY"), GetPVarFloat(i, "BBZ"), 30.0, 1);
				 	Servers(playerid, "You Enter The Boombox Area");
	            }
				return 1;
	        }
	    }
	}
	
	if(areaid == ZonaGYM)
	{
	    pData[playerid][pBladder] += 1;
	}
	if(areaid == Areaayam)
	{
	    InfoMsg(playerid, "Anda memasuki area peternakan ayam");
	}
	if(areaid == Segitigabermuda)
	{
	 	SendClientMessageEx(playerid, -1, "Anda masuk ke segi empat los santos");
	 	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehiclePos(GetPlayerVehicleID(playerid), 1212.5688,-1328.3711,13.5602);
		else SetPlayerPos(playerid, 1212.5688,-1328.3711,13.5602);
	}
	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
    if(areaid == Areaayam)
	{
	    InfoMsg(playerid, "Anda telah keluar dari area peternakan ayam");
	    pData[playerid][pAyamhidup] = 0;
	    RemovePlayerAttachedObject(playerid, 9);
	}
    foreach(new i : Player)
	{
	    if(GetPVarType(i, "BBArea"))
	    {
	        if(areaid == GetPVarInt(i, "BBArea"))
	        {
	            StopStream(playerid);
	            Servers(playerid, "You Has Been Leave Boombox Area");
				return 1;
	        }
	    }
	}
	return 1;
}

forward RemoveBullet(objectid);
public RemoveBullet(objectid)
{
	bullets_pending--;
	#if defined STREAMER_TYPE_OBJECT
		DestroyDynamicObject(objectid);
	#else
		DestroyObject(objectid);
	#endif
}


public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{

    if(GetPlayerWeapon(playerid) == 24 && Inventory_Count(playerid, "44_Magnum") < 1)
	    {
	        SetPlayerArmedWeapon(playerid, 0);
		}
    if(GetPlayerWeapon(playerid) == 24)
    {
  		Inventory_Remove(playerid, "44_Magnum", 1);
  		SetPlayerAmmo(playerid, 24, 99999);
	}
	if(GetPlayerWeapon(playerid) == 22 && Inventory_Count(playerid, "9mm") < 1)
	    {
	        SetPlayerArmedWeapon(playerid, 0);
		}
    if(GetPlayerWeapon(playerid) == 22)
    {
  		Inventory_Remove(playerid, "9mm", 2);
  		SetPlayerAmmo(playerid, 22, 99999);
	}
	if(pData[playerid][pGuntazer] != 1)
		{
			if(GetPlayerWeapon(playerid) == 23 && Inventory_Count(playerid, "9mm") < 1)
		    {
		        SetPlayerArmedWeapon(playerid, 0);
			}
		}
	if(pData[playerid][pGuntazer] != 1)
	{
	    if(GetPlayerWeapon(playerid) == 23)
	    {
	  		Inventory_Remove(playerid, "9mm", 1);
	  		SetPlayerAmmo(playerid, 23, 99999);
		}
	}
	if(GetPlayerWeapon(playerid) == 25 && Inventory_Count(playerid, "Buckshot") < 1)
	    {
	        SetPlayerArmedWeapon(playerid, 0);
		}
    if(GetPlayerWeapon(playerid) == 25)
    {
  		Inventory_Remove(playerid, "Buckshot", 1);
  		SetPlayerAmmo(playerid, 25, 99999);
	}
	if(GetPlayerWeapon(playerid) == 29 && Inventory_Count(playerid, "19mm") < 1)
	    {
	        SetPlayerArmedWeapon(playerid, 0);
		}
    if(GetPlayerWeapon(playerid) == 29)
    {
  		Inventory_Remove(playerid, "19mm", 1);
  		SetPlayerAmmo(playerid, 29, 99999);
	}
	if(GetPlayerWeapon(playerid) == 30 && Inventory_Count(playerid, "39mm") < 1)
	    {
	        SetPlayerArmedWeapon(playerid, 0);
		}
    if(GetPlayerWeapon(playerid) == 30)
    {
  		Inventory_Remove(playerid, "39mm", 1);
  		SetPlayerAmmo(playerid, 30, 99999);
	}
	switch(weaponid){ case 0..18, 39..54: return 1;} //invalid weapons
	if(1 <= weaponid <= 46 && pData[playerid][pGuns][g_aWeaponSlots[weaponid]] == weaponid)
	{
		pData[playerid][pAmmo][g_aWeaponSlots[weaponid]]--;
		if(pData[playerid][pGuns][g_aWeaponSlots[weaponid]] != 0 && !pData[playerid][pAmmo][g_aWeaponSlots[weaponid]])
		{
			pData[playerid][pGuns][g_aWeaponSlots[weaponid]] = 0;
		}
	}

	//hole
	if(floatround(fX) == 0 && floatround(fY) == 0) return 1;

	#if !defined STREAMER_TYPE_OBJECT
		if(bullets_pending > MAX_BULLETS) return SendClientMessage(playerid, -1, "Error! Too many bullets... or whatever.");
	#endif

	bullets_pending++;
	new bullet;

	#if defined STREAMER_TYPE_OBJECT
		bullet = CreateDynamicObject(OBJECT_BULLET, fX, fY, fZ, 0.0, 0.0, 0.0);
	#else
		bullet = CreateObject(OBJECT_BULLET, fX, fY, fZ, 0.0, 0.0, 0.0);
	#endif
	SetTimerEx("RemoveBullet", REMOVE_BULLET_TIME * 1000, false, "i", bullet);
	return 1;
}

stock GivePlayerHealth(playerid,Float:Health)
{
	new Float:health; GetPlayerHealth(playerid,health);
	SetPlayerHealth(playerid,health+Health);
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	new
        Float: vehicleHealth,
        playerVehicleId = GetPlayerVehicleID(playerid);

    new Float:health = GetPlayerHealth(playerid, health);
    GetVehicleHealth(playerVehicleId, vehicleHealth);
    if(pData[playerid][pSeatBelt] == 0)
    {
    	if(GetVehicleSpeed(vehicleid) > 130)
    	{
    	    new Float:POS[3];

			GetPlayerPos(playerid, POS[0], POS[1], POS[2]);
			SetPlayerPos(playerid, POS[0] + 4.0, POS[1], POS[2]);
			ApplyAnimation(playerid, "PED","FLOOR_hit_f", 4.0, 0, 0, 0, 0, 0, 1);
			GivePlayerHealth(playerid, -5);
		}
	}
    /*if(pData[playerid][pSeatBelt] == 0 || pData[playerid][pHelmetOn] == 0)
    {
    	if(GetVehicleSpeedKMH(vehicleid) <= 20)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -1);
    		return 1;
    	}
    	if(GetVehicleSpeedKMH(vehicleid) <= 50)
    	{
    		new asakit = RandomEx(0, 2);
    		new bsakit = RandomEx(0, 2);
    		new csakit = RandomEx(0, 2);
    		new dsakit = RandomEx(0, 2);
    		pData[playerid][pLFoot] -= dsakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= dsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -2);
    		return 1;
    	}
    	if(GetVehicleSpeedKMH(vehicleid) <= 90)
    	{
    		new asakit = RandomEx(0, 3);
    		new bsakit = RandomEx(0, 3);
    		new csakit = RandomEx(0, 3);
    		new dsakit = RandomEx(0, 3);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= csakit;
    		pData[playerid][pRFoot] -= dsakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -5);
    		return 1;
    	}
    	return 1;
    }
    if(pData[playerid][pSeatBelt] == 1 || pData[playerid][pHelmetOn] == 1)
    {
    	if(GetVehicleSpeedKMH(vehicleid) <= 20)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -1);
    		return 1;
    	}
    	if(GetVehicleSpeedKMH(vehicleid) <= 50)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		new dsakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= dsakit;
    		pData[playerid][pLHand] -= bsakit;
    		pData[playerid][pRFoot] -= csakit;
    		pData[playerid][pRHand] -= dsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -1);
    		return 1;
    	}
    	if(GetVehicleSpeedKMH(vehicleid) <= 90)
    	{
    		new asakit = RandomEx(0, 1);
    		new bsakit = RandomEx(0, 1);
    		new csakit = RandomEx(0, 1);
    		new dsakit = RandomEx(0, 1);
    		pData[playerid][pLFoot] -= csakit;
    		pData[playerid][pLHand] -= csakit;
    		pData[playerid][pRFoot] -= dsakit;
    		pData[playerid][pRHand] -= bsakit;
    		pData[playerid][pHead] -= asakit;
    		GivePlayerHealth(playerid, -3);
    		return 1;
    	}
    }*/
    return 1;
}

forward Kenatazer(playerid);
public Kenatazer(playerid)
{
	pData[playerid][pKenatazer] = 0;
	TogglePlayerControllable(playerid, 1);
	callcmd::astop(playerid, "");
	SetPlayerDrunkLevel(playerid, 0);
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    new Float:Armor, Float:Health;
	GetPlayerArmour(playerid, Armor);
	GetPlayerHealth(playerid, Health);
	
	
    if(pData[issuerid][pGuntazer] == 1)
	{
		if(weaponid == 23)
  		{
  		    pData[playerid][pKenatazer] = 1;
  		    TogglePlayerControllable(playerid, 0);
  		    SetPlayerDrunkLevel(playerid, 6000);
			callcmd::fallback(playerid, "");
			SetTimerEx("Kenatazer", 10000, false, "i", playerid);
		}
	}
/*	if(pData[playerid][pAdminDuty] == 1)
	{
	    SendClientMessageEx(issuerid, -1, "%s sedang duty admin", GetRPName(playerid));
	}*/
	/*if(bodypart == 6 && GetPlayerWeapon(playerid) == 22)
	{
	    if(Inventory_Count(playerid, "Colt45") > 1 && InventoryData[playerid][Inventory_GetItemID(playerid, "Colt45")][invJangka] < 2.0)
		{

		    Inventory_Remove(playerid, "Colt45", 1);
		    InventoryData[playerid][Inventory_GetItemID(playerid, "Colt45")][invJangka] = 100;
		}
		if(Inventory_Count(playerid, "Colt45") ==  1 && InventoryData[playerid][Inventory_GetItemID(playerid, "Colt45")][invJangka] < 2.0)
		{
		    //InventoryData[playerid][Inventory_GetItemID(playerid, "Colt45")][invJangka] = 100.0
		    Inventory_Remove(playerid, "Colt45", 1);
		}
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Colt45")][invJangka] -= 1.0;
	    
	}*/
	if(pData[playerid][pProsesbobol] == 1)
	{
		    pData[playerid][pCarbobol] = INVALID_VEHICLE_ID;
		    KillTimer(TimerLoading[playerid]);
			LoadingPlayerBar[playerid] = 0;
			HideProgressBar(playerid);
			SetTimerEx(ProgressTimer[playerid], 300, false, "d", playerid);
			TogglePlayerControllable(playerid, 1);
			pData[playerid][pProsesbobol] = 0;
			KillTimer(pData[playerid][pTimerbobol]);
	}
	if(IsAtEvent[playerid] == 0)
	{
		new sakit = RandomEx(1, 4);
		new asakit = RandomEx(1, 5);
		new bsakit = RandomEx(1, 7);
		new csakit = RandomEx(1, 4);
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 9)
		{
			pData[playerid][pHead] -= 20;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 3)
		{
			pData[playerid][pPerut] -= sakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 6)
		{
			pData[playerid][pRHand] -= bsakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 5)
		{
			pData[playerid][pLHand] -= asakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 8)
		{
			pData[playerid][pRFoot] -= csakit;
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 7)
		{
			pData[playerid][pLFoot] -= bsakit;
		}
	}
	else if(IsAtEvent[playerid] == 1)
	{
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 9)
		{
			GivePlayerHealth(playerid, -90);
			SendClientMessage(issuerid, -1,"{7fffd4}[ TDM ]{ffffff} Headshot!");
		}
	}
	if(weaponid == 0)
	{
		pData[playerid][pFistCount]++;
	}
	if(Armor > 0)
	{
		if(weaponid == 9)
		{
	    	SetPlayerArmour(playerid, Armor);
	    	SetPlayerHealth(playerid, Health);
		}
		else if(weaponid == 0 || weaponid == 5)
		{
		    SetPlayerArmour(playerid, Armor);
		    SetPlayerHealth(playerid, Health-amount);
		}
	}
	else
	{
	    if(weaponid == 9)
	    {
	        SetPlayerHealth(playerid, Health);
		}
	}
    return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
    new Float:health,
		Float:armour;

	GetPlayerHealth(damagedid, health);
	GetPlayerArmour(damagedid, armour);
    if(weaponid == 9 && pData[playerid][pAdmin] < 1)
    {
	    if(pData[playerid][pChainsaw] < 3)
	    {
		    pData[playerid][pChainsaw]++;
		    SetPlayerHealth(damagedid, health);
		}
		else
		{
		    SendClientMessageToAllEx(COLOR_LIGHTRED, "BotCmd: %s has been kicked from the server, reason: Abusing Chainsaw!", GetName(playerid));
			KickEx(playerid);
		}
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	//pool
	if(Player[playerid][Sighting] == true)
	{
	    if(GetVectorDistance_PL(playerid,Ball[WHITE][ObjID]) < 1.6)
	    {
	    	new key[3];
	    	new Float:pos[3];
	    	GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
    		GetPlayerKeys(playerid,key[0],key[1],key[2]);
	    	if(key[2] == KEY_LEFT && Player[playerid][SelectLR] < 10)
	    	{
	    	    new Float:angle;
	    	    new Float:angXY;
				GetPlayerFacingAngle(playerid,angle);

				Player[playerid][SelectLR]++;

				pos[0] += floatsin(-angle - 90,degrees) / 20;
				pos[1] += floatcos(-angle - 90,degrees) / 20;

				new Float:dist = GetVectorDistance_PL(playerid,Ball[WHITE][ObjID]);
				new Float:pp[3];
				GetObjectPos(Ball[WHITE][ObjID],pp[0],pp[1],pp[2]);
				angXY = GetVectorAngle_XY(pos[0],pos[1],pp[0],pp[1]);

				if(0.9 <= dist <= 1.2)
				{
					pos[0] += floatsin(-angXY + 180,degrees) * 0.3;
					pos[1] += floatcos(-angXY + 180,degrees) * 0.3;
				}
				else if(dist < 0.9)
				{
					pos[0] += floatsin(-angXY + 180,degrees) * 0.6;
					pos[1] += floatcos(-angXY + 180,degrees) * 0.6;
				}
				SetPlayerPos(playerid,pos[0],pos[1],pos[2]);
				SetPlayerFacingAngle(playerid,angXY - 2.2);
				Player[playerid][pa] = angXY - 2.2;

				pos[0] += floatsin(-angXY - 10,degrees) * 0.2;
 				pos[1] += floatcos(-angXY - 10,degrees) * 0.2;
		   	 	SetPlayerCameraPos(playerid,pos[0],pos[1],pp[2] + 0.5);
	       		SetPlayerCameraLookAt(playerid,pp[0],pp[1],pp[2]);
	        	ApplyAnimation(playerid,"POOL","POOL_Med_Start",1,0,0,0,1,0,1);
	    	}
	    	else if(key[2] == KEY_RIGHT && Player[playerid][SelectLR] > -10)
	    	{
	    	    new Float:angle;
	    	    new Float:angXY;
				GetPlayerFacingAngle(playerid,angle);

				pos[0] += floatsin(-angle + 90,degrees) / 20;
				pos[1] += floatcos(-angle + 90,degrees) / 20;

				Player[playerid][SelectLR]--;

				new Float:dist = GetVectorDistance_PL(playerid,Ball[WHITE][ObjID]);
				new Float:pp[3];
				GetObjectPos(Ball[WHITE][ObjID],pp[0],pp[1],pp[2]);
				angXY = GetVectorAngle_XY(pos[0],pos[1],pp[0],pp[1]);

				if(0.9 <= dist <= 1.2)
				{
					pos[0] += floatsin(-angXY + 180,degrees) * 0.3;
					pos[1] += floatcos(-angXY + 180,degrees) * 0.3;
				}
				else if(dist < 0.9)
				{
					pos[0] += floatsin(-angXY + 180,degrees) * 0.6;
					pos[1] += floatcos(-angXY + 180,degrees) * 0.6;
				}
				SetPlayerPos(playerid,pos[0],pos[1],pos[2]);
				SetPlayerFacingAngle(playerid,angXY - 2.2);
				Player[playerid][pa] = angXY - 2.2;

				pos[0] += floatsin(-angXY - 10,degrees) * 0.2;
 				pos[1] += floatcos(-angXY - 10,degrees) * 0.2;
		    	SetPlayerCameraPos(playerid,pos[0],pos[1],pp[2] + 0.5);
	        	SetPlayerCameraLookAt(playerid,pp[0],pp[1],pp[2]);
	        	ApplyAnimation(playerid,"POOL","POOL_Med_Start",1,0,0,0,1,0,1);
	    	}
	    	else if(key[1] == KEY_UP || key[1] == KEY_DOWN)
	    	{
	    	    if(key[1] == KEY_UP && 0 < Player[playerid][SelectUD] < 8)
	    	    {
					Player[playerid][SelectUD]++;

					if(Player[playerid][TDTimer] != 0)
	    	    	{
	    	        	KillTimer(Player[playerid][TDTimer]);
	    				Player[playerid][TDTimer] = 0;
	    	    	}

	    	    	TextDrawSetString(Player[playerid][T2],"Predkosc");
	    	    	TextDrawShowForPlayer(playerid,Player[playerid][T2]);

	    	    	new str[20];
	    	    	new length = (Player[playerid][SelectUD] / 2) * 30;

	    	    	if(length == 0)
						length = 15;

	    	   		format(str,sizeof(str),"%d cm~w~/s",length);
	    	    	TextDrawSetString(Player[playerid][T1],str);
	    	    	TextDrawShowForPlayer(playerid,Player[playerid][T1]);
				}
	    	    else if(key[1] == KEY_DOWN && 1 < Player[playerid][SelectUD] <= 8)
		  		{
	    	        Player[playerid][SelectUD]--;

	    	        if(Player[playerid][TDTimer] != 0)
	    	    	{
	    	        	KillTimer(Player[playerid][TDTimer]);
	    				Player[playerid][TDTimer] = 0;
	    	    	}

	    	    	TextDrawSetString(Player[playerid][T2],"Predkosc");
	    	    	TextDrawShowForPlayer(playerid,Player[playerid][T2]);

	    	    	new str[20];
					new length = (Player[playerid][SelectUD] / 2) * 30;

					if(length == 0)
						length = 15;

	    	   		format(str,sizeof(str),"%d cm~w~/s",length);
	    	    	TextDrawSetString(Player[playerid][T1],str);
	    	    	TextDrawShowForPlayer(playerid,Player[playerid][T1]);
      			}
	    	}
		}
    }
	//rob
	new playerTargetActor = GetPlayerTargetActor(playerid);

    // If they ARE looking at ANY actor
    if (playerTargetActor != INVALID_ACTOR_ID)
    {
        // Store the player's weapon so we can check if they are armed
        new playerWeapon = GetPlayerWeapon(playerid);

        // Get the player's keys so we can check if they are aiming
        new keys, updown, leftright;
        GetPlayerKeys(playerid, keys, updown, leftright);

        // If the actor hasn't put its hands up yet, AND the player is ARMED
        if (!ActorHandsup[playerTargetActor] && playerWeapon >= 22 && playerWeapon <= 42 && keys & KEY_AIM)
        {
            // Apply 'hands up' animatio
            ApplyActorAnimation(playerTargetActor, "SHOP", "SHP_HandsUp_Scr",4.1,0,0,0,1,0);

            // Set 'ActorHandsup' to true, so the animation won't keep being reapplied
            ActorHandsup[playerTargetActor] = true;
        }
    }
	//fly
    if(noclipdata[playerid][cameramode] == CAMERA_MODE_FLY)
	{
		new keys,ud,lr;
		GetPlayerKeys(playerid,keys,ud,lr);

		if(noclipdata[playerid][mode] && (GetTickCount() - noclipdata[playerid][lastmove] > 100))
		{
		    // If the last move was > 100ms ago, process moving the object the players camera is attached to
		    MoveCamera(playerid);
		}

		// Is the players current key state different than their last keystate?
		if(noclipdata[playerid][udold] != ud || noclipdata[playerid][lrold] != lr)
		{
			if((noclipdata[playerid][udold] != 0 || noclipdata[playerid][lrold] != 0) && ud == 0 && lr == 0)
			{   // All keys have been released, stop the object the camera is attached to and reset the acceleration multiplier
				StopPlayerObject(playerid, noclipdata[playerid][flyobject]);
				noclipdata[playerid][mode]      = 0;
				noclipdata[playerid][accelmul]  = 0.0;
			}
			else
			{   // Indicates a new key has been pressed

			    // Get the direction the player wants to move as indicated by the keys
				noclipdata[playerid][mode] = GetMoveDirectionFromKeys(ud, lr);

				// Process moving the object the players camera is attached to
				MoveCamera(playerid);
			}
		}
		noclipdata[playerid][udold] = ud; noclipdata[playerid][lrold] = lr; // Store current keys pressed for comparison next update
		return 0;
	}
	//SAPD Tazer/Taser
	UpdateTazer(playerid);
	
	//SAPD Road Spike
	CheckPlayerInSpike(playerid);

	//Report ask
	//GetPlayerName(playerid, g_player_name[playerid], MAX_PLAYER_NAME);

	//AntiCheat
	pData[playerid][pLastUpdate] = gettime();
	static id = -1;
	new vehicleid = GetPlayerVehicleID(playerid);
	foreach(new i : PVehicles)
	{
	    if(vehicleid == pvData[i][cVeh])
	    {
			if ((id = Speed_Nearest(playerid)) != -1 && GetVehicleSpeedKMH(vehicleid) > SpeedData[id][speedLimit] && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsEngineVehicle(vehicleid))
			{
			    if (!IsACruiser(vehicleid) && !IsABoat(vehicleid) && !IsAPlane(vehicleid) && !IsAHelicopter(vehicleid) && !pData[playerid][pSpeedTime])
			    {
				    new
						location[MAX_ZONE_NAME];

				    format(SpeedData[id][speedPlate], 32, pvData[i][cPlate]);
				    SpeedData[id][speedVehicle] = GetVehicleModel(vehicleid);
				    Speed_RefreshText(id);
		            GetPlayer2DZone(playerid, location, MAX_ZONE_NAME);
				    SendFactionMessage(1, COLOR_RADIO, "SPEEDTRAP: %s with Plate %s Speeding %i/%.0f KM/H at %s.", GetVehicleModelName(GetVehicleModel(vehicleid)), SpeedData[id][speedPlate], GetVehicleSpeedKMH(vehicleid), SpeedData[id][speedLimit], location);
				    pData[playerid][pSpeedTime] = 5;
				    PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
				    ShowMessage(playerid, "Caught on ~r~Speedcamera!", 3);
				}
			}
		}
	}
	return 1;
}

task VehicleUpdate[60000]()
{
	for (new i = 1; i != MAX_VEHICLES; i ++) if(IsEngineVehicle(i) && GetEngineStatus(i))
    {
        if(GetVehicleFuel(i) > 0)
        {
			new fuel = GetVehicleFuel(i);
            SetVehicleFuel(i, fuel - 1);

            if(GetVehicleFuel(i) >= 1 && GetVehicleFuel(i) <= 10)
            {
               Info(GetVehicleDriver(i), "This vehicle is low on fuel. You must visit a fuel station!");
            }
        }
        if(GetVehicleFuel(i) <= 0)
        {
            SetVehicleFuel(i, 0);
            SwitchVehicleEngine(i, false);
        }
    }
	foreach(new ii : PVehicles)
	{
		if(IsValidVehicle(pvData[ii][cVeh]))
		{
			if(pvData[ii][cPlateTime] != 0 && pvData[ii][cPlateTime] <= gettime())
			{
				format(pvData[ii][cPlate], 32, "NoHave");
				SetVehicleNumberPlate(pvData[ii][cVeh], pvData[ii][cPlate]);
				pvData[ii][cPlateTime] = 0;
			}
			if(pvData[ii][cRent] != 0 && pvData[ii][cRent] <= gettime())
			{
				pvData[ii][cRent] = 0;
				new query[12800], alok[12800];
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[ii][cID]);
				mysql_tquery(g_SQL, query);
				mysql_format(g_SQL, alok, sizeof(alok), "DELETE FROM trunk WHERE Owner = '%d'", pvData[ii][cID]);
				mysql_tquery(g_SQL, alok);
				if(IsValidVehicle(pvData[ii][cVeh])) DestroyVehicle(pvData[ii][cVeh]);
				Iter_SafeRemove(PVehicles, ii, ii);
			}
		}
		if(pvData[ii][cClaimTime] != 0 && pvData[ii][cClaimTime] <= gettime())
		{
			pvData[ii][cClaimTime] = 0;
		}
		foreach(new v : PVehicles)
		{
		    if(pvData[v][cCooldown] > 0)
		    {
		        pvData[v][cCooldown]--;
		        if(pvData[v][cCooldown] <= 0)
				{
				    pvData[v][cCooldown] = 0;
				}
			}
		}
	}
}

public OnVehicleDeath(vehicleid, killerid)
{
	foreach(new i : PVehicles)
	{
		if(pvData[i][cVeh] == vehicleid)
		{
			pvData[i][cDeath] = gettime() + 15;
		}
	}
	//tentara
	if(GetVehicleModel(vehicleid) == 497)
	{
	    for(new shg=0;shg<=MAX_PLAYERS;shg++)
	    {
	       
	            DisablePlayerCheckpoint(shg);
	           
	            DisablePlayerCheckpoint(shg);
	            ClearAnimations(shg);
	            TogglePlayerControllable(shg,1);
	            for(new destr3=0;destr3<=50;destr3++)
				{
				    DestroyObject(r0pes[shg][destr3]);
				}

		}
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	foreach(new ii : PVehicles)
	{
		if(vehicleid == pvData[ii][cVeh] && pvData[ii][cRent] == 0 && pvData[ii][cDeath] > gettime())
		{
			if(pvData[ii][cInsu] > 0)
    		{
				pvData[ii][cDeath] = 0;
				pvData[ii][cInsu]--;
				pvData[ii][cClaim] = 1;
				pvData[ii][cClaimTime] = gettime() + (1 * 60);
				foreach(new pid : Player) if (pvData[ii][cOwner] == pData[pid][pID])
        		{
            		Info(pid, "Kendaraan anda hancur dan anda masih memiliki insuransi, silahkan ambil di kantor SAGS setelah 1 menit.");
				}
				if(IsValidVehicle(vehicleid))
					DestroyVehicle(vehicleid);

				pvData[ii][cVeh] = INVALID_VEHICLE_ID;
			}
			else
			{
				foreach(new pid : Player) if (pvData[ii][cOwner] == pData[pid][pID])
        		{
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[pid][cID]);
					mysql_tquery(g_SQL, query);
					if(IsValidVehicle(pvData[ii][cVeh]))
						DestroyVehicle(pvData[ii][cVeh]);

					pvData[ii][cVeh] = INVALID_VEHICLE_ID;
            		Info(pid, "Kendaraan anda hancur dan tidak memiliki insuransi.");
					Iter_SafeRemove(PVehicles, ii, ii);
				}
				pvData[ii][cDeath] = 0;
			}
			return 1;
		}
	}
	//System Vehicle Admin
	if(AdminVehicle{vehicleid})
	{
	    DestroyVehicle(vehicleid);
	    AdminVehicle{vehicleid} = false;
	}
	return 1;
}

task Ayamspawn[600000]()
{
	if(Ayamhidup < 20)
	{
	    Ayamhidup = 100;
	}
}

ptask BrakeUpdate[250](playerid)
{
	
    new a, b, c;
	GetPlayerKeys(playerid, a, b ,c);
	new vehicleid = GetPlayerVehicleID(playerid);
	new Float:speed = GetVehicleSpeedKMH(vehicleid);

	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && !IsVehicleBackwordsDirection(vehicleid) && speed >= 30.0)
	{
	    foreach(new i : PVehicles)
	    {
	        if(vehicleid == pvData[i][cVeh] && pvData[i][cBrakeMode] != 0)
			{
				if(a == KEY_HANDBRAKE || a == KEY_JUMP)
				{
				    SetVehSpeed(vehicleid, speed - (10.0 * pvData[i][cBrakeMode]));
				}
			}
		}
	}
	return 1;
}
ptask TurboUpdate[5000](playerid)
{
    new a, b, c;
	GetPlayerKeys(playerid, a, b ,c);
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
	    foreach(new i : PVehicles)
	    {
	        if(vehicleid == pvData[i][cVeh] && pvData[i][cTurboMode] != 0 && !IsVehicleBackwordsDirection(pvData[i][cVeh]))
			{
				if(a == KEY_SPRINT && GetVehicleSpeedKMH(pvData[i][cVeh]) >= 50.0)
				{
					new Float:D[4], Float:dis;
					switch(pvData[i][cTurboMode])
					{
					    case 1: dis = 0.10;
					    case 2: dis = 0.20;
					    case 3: dis = 0.30;
					}
					GetVehicleVelocity(pvData[i][cVeh], D[0], D[1], D[2]);
					GetVehicleZAngle(pvData[i][cVeh], D[3]);
					SetVehicleVelocity(pvData[i][cVeh],floatadd(D[0],floatmul(dis,floatsin(-D[3],degrees))), floatadd(D[1],floatmul(dis,floatcos(-D[3],degrees))), D[2]);
				}
			}
		}
	}
	return 1;
}

stock BarPlayer(playerid)
{
    SetPlayerProgressBarValue(playerid, pData[playerid][FOODPROGRESS], pData[playerid][pHunger]);
    SetPlayerProgressBarColour(playerid, pData[playerid][FOODPROGRESS], ConvertHBEColor(pData[playerid][pHunger]));
	SetPlayerProgressBarValue(playerid, pData[playerid][DRINKPROGRESS], pData[playerid][pEnergy]);
	SetPlayerProgressBarColour(playerid, pData[playerid][DRINKPROGRESS], ConvertHBEColor(pData[playerid][pEnergy]));
	new strings[640], alok[800];
	format(strings, sizeof(strings), "%s", ReturnName(playerid));
	PlayerTextDrawSetString(playerid, NAME[playerid], strings);
	format(alok, sizeof alok, "%s", FormatMoney(pData[playerid][pMoney]));
	PlayerTextDrawSetString(playerid, MONEY[playerid], alok);
	return 1;
}

stock BarVehicle(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
         if(pData[playerid][pHBEMode] == 1)
         {
				new Float:fDamage, fFuel, color1, color2;
				new tstr[64];

				GetVehicleColor(vehicleid, color1, color2);

				GetVehicleHealth(vehicleid, fDamage);

				//fDamage = floatdiv(1000 - fDamage, 10) * 1.42999;

				if(fDamage <= 350.0) fDamage = 0.0;
				else if(fDamage > 8000.0) fDamage = 8000.0;

				fFuel = GetVehicleFuel(vehicleid);

				if(fFuel < 0) fFuel = 0;
				else if(fFuel > 3000) fFuel = 3000;


				format(tstr, sizeof(tstr), "%i", GetVehicleFuel(vehicleid));
				PlayerTextDrawSetString(playerid, VEHFIVEM[playerid][4], tstr);

				format(tstr, sizeof(tstr), "%i", GetVehicleSpeedKMH(vehicleid));
				PlayerTextDrawSetString(playerid, VEHFIVEM[playerid][2], tstr);
         }
   }
}

ptask Melacak[1000](playerid)
{
    if(pData[playerid][pMelacak] == 1)
	{
		new
		    Float:x,
		    Float:y,
		    Float:z;

		GetPlayerPos(pData[playerid][pIdlacak], x, y, z);
		SetPlayerCheckpoint(playerid, x, y, z, 1.0);
		
	}
}
ptask Komaygy[60000](playerid)
{
    if(pData[playerid][pRegen] > 0)
	{
	    pData[playerid][pRegen] -= 1;
	}
}

ptask Gakjadi[100](playerid)
{
	if(pData[playerid][pBusTime] > 0)
	{
	    pData[playerid][pBusTime] = 0;
	}
	if(pData[playerid][pForklifterTime] > 0)
	{
	    pData[playerid][pForklifterTime] = 0;
	}
	if(pData[playerid][pMowerTime] > 0)
	{
	    pData[playerid][pMowerTime] = 0;
	}
	if(pData[playerid][pKoranTime] > 0)
	{
	    pData[playerid][pKoranTime] = 0;
	}
	if(pData[playerid][pAntarayamTime] > 0)
	{
	    pData[playerid][pAntarayamTime] = 0;
	}
}
ptask PlayerVehicleUpdate[200](playerid)
{
    
	if(pData[playerid][pTiket] < 0)
	{
	    pData[playerid][pTiket] = 0;
	}
	new vehicleid = GetPlayerVehicleID(playerid);
	Vehicle_GetStatus(vehicleid);
	if(IsValidVehicle(vehicleid))
	{
		if(!GetEngineStatus(vehicleid) && IsEngineVehicle(vehicleid))
		{	
			SwitchVehicleEngine(vehicleid, false);
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new Float:fHealth;
			GetVehicleHealth(vehicleid, fHealth);
			if(IsValidVehicle(vehicleid) && fHealth <= 350.0)
			{
				SetValidVehicleHealth(vehicleid, 300.0);
				SwitchVehicleEngine(vehicleid, false);
				InfoTD_MSG(playerid, 2500, "~r~Totalled");
				new Float:x, Float:y, Float:z;
			    GetPlayerPos(playerid, x, y, z);
				foreach(new ii : Player)
				{
					if(IsPlayerInRangeOfPoint(ii, 5.0, x, y, z) && IsPlayerInAnyVehicle(ii))
					{
						StopAudioStreamForPlayer(ii);
					}
				}
			}
		}
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if(pData[playerid][pHBEMode] == 1)
			{
				new Float:fDamage, fFuel, color1, color2;
				new tstr[64];

				GetVehicleColor(vehicleid, color1, color2);

				GetVehicleHealth(vehicleid, fDamage);

				//fDamage = floatdiv(1000 - fDamage, 10) * 1.42999;

				if(fDamage <= 350.0) fDamage = 0.0;
				else if(fDamage > 8000.0) fDamage = 8000.0;

				fFuel = GetVehicleFuel(vehicleid);

				if(fFuel < 0) fFuel = 0;
				else if(fFuel > 3000) fFuel = 3000;

                format(tstr, sizeof(tstr), "%i", GetVehicleFuel(vehicleid));
				PlayerTextDrawSetString(playerid, VEHFIVEM[playerid][4], tstr);

				format(tstr, sizeof(tstr), "%i", GetVehicleSpeedKMH(vehicleid));
				PlayerTextDrawSetString(playerid, VEHFIVEM[playerid][2], tstr);
			}
			else
			{
			
			}
		}
	}
}

forward notifitems(playerid, otherid);
public notifitems(playerid, otherid)
{
	for(new idx; idx < 22; idx++)
	{
		PlayerTextDrawHide(playerid, KTPFIVEM[playerid][idx]);
	}
	for(new idx; idx < 7; idx++)
	{
		PlayerTextDrawHide(playerid, NotifItems[playerid][idx]);
		PlayerTextDrawHide(otherid, NotifItems[playerid][idx]);
	}
	for(new idx; idx < 7; idx++)
	{
		TextDrawHideForPlayer(playerid, NOTIFSUCCESS[idx]);
		PlayerTextDrawHide(playerid, TEXTSUCCESS[playerid][idx]);
	}
}

UpdatePlayerHBE(playerid)
{
	new Float:health, Float:armour, Float:hunger, Float:energy, Float:stress;
	health = pData[playerid][pHealth] * 0.32500000;
	PlayerTextDrawTextSize(playerid, BarDarah[playerid], health, 13.0);
 	PlayerTextDrawShow(playerid, BarDarah[playerid]);

 	armour = pData[playerid][pArmour] * 0.33500000;
	PlayerTextDrawTextSize(playerid, BarArmor[playerid], armour, 13.0);
 	PlayerTextDrawShow(playerid, BarArmor[playerid]);

  	hunger = pData[playerid][pHunger] * 12.0/100;
	PlayerTextDrawTextSize(playerid, BarMakan[playerid], 12.5, -hunger);
 	PlayerTextDrawShow(playerid, BarMakan[playerid]);


 	energy = pData[playerid][pEnergy] * 12.0/100;
	PlayerTextDrawTextSize(playerid, BarMinum[playerid], 12.5, -energy);
 	PlayerTextDrawShow(playerid, BarMinum[playerid]);

 	stress = pData[playerid][pBladder] * 12.0/100;
	PlayerTextDrawTextSize(playerid, BarPusing[playerid], 12.5, -stress);
 	PlayerTextDrawShow(playerid, BarPusing[playerid]);
}

//ptask Notifshow[100](playerid)
forward Notifshow(playerid);
public Notifshow(playerid)
{
	if(pData[playerid][pInfo] == 1)
	{
	    PlayerTextDrawShow(playerid, NotifTD[playerid][0]);
	 
	    PlayerTextDrawShow(playerid, NotifTD[playerid][9]);
		PlayerTextDrawShow(playerid, NotifTD[playerid][10]);
	    if(pData[playerid][pInfo1] == 1)
	    {
	        PlayerTextDrawShow(playerid, NotifTD[playerid][5]);
	        PlayerTextDrawColor(playerid, NotifTD[playerid][5], -2686721);
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][9], "Warning");
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][10], "Unknown_cmd_use_/help!");
		}
        if(pData[playerid][pInfo1] == 2)
	    {
	        PlayerTextDrawColor(playerid, NotifTD[playerid][5], 1687547391);
	        PlayerTextDrawShow(playerid, NotifTD[playerid][5]);
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][9], "Announcement");
	        //PlayerTextDrawSetString(playerid, NotifTD[playerid][10], "Unknown_cmd_use_/help!");
		}
		if(pData[playerid][pInfo1] == 3)
	    {
	        PlayerTextDrawColor(playerid, NotifTD[playerid][5], 16711935);
	        PlayerTextDrawShow(playerid, NotifTD[playerid][5]);
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][9], "Succes");
	        //PlayerTextDrawSetString(playerid, NotifTD[playerid][10], "Unknown_cmd_use_/help!");
		}
	}
	if(pData[playerid][pInfo] == 2)
	{
	    PlayerTextDrawShow(playerid, NotifTD[playerid][1]);
	    PlayerTextDrawShow(playerid, NotifTD[playerid][15]);
		PlayerTextDrawShow(playerid, NotifTD[playerid][16]);
	    if(pData[playerid][pInfo2] == 1)
	    {
	        PlayerTextDrawShow(playerid, NotifTD[playerid][11]);
	        PlayerTextDrawColor(playerid, NotifTD[playerid][11], -2686721);
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][15], "Warning");
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][16], "Unknown_cmd_use_/help!");
		}
		if(pData[playerid][pInfo2] == 2)
	    {
	        PlayerTextDrawColor(playerid, NotifTD[playerid][11], 1687547391);
	        PlayerTextDrawShow(playerid, NotifTD[playerid][11]);
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][15], "Announcement");
	        //PlayerTextDrawSetString(playerid, NotifTD[playerid][10], "Unknown_cmd_use_/help!");
		}
		if(pData[playerid][pInfo1] == 3)
	    {
	        PlayerTextDrawColor(playerid, NotifTD[playerid][11], 16711935);
	        PlayerTextDrawShow(playerid, NotifTD[playerid][11]);
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][15], "Succes");
	        //PlayerTextDrawSetString(playerid, NotifTD[playerid][10], "Unknown_cmd_use_/help!");
		}
	}
	if(pData[playerid][pInfo] == 3)
	{
	    PlayerTextDrawShow(playerid, NotifTD[playerid][2]);
	    PlayerTextDrawShow(playerid, NotifTD[playerid][21]);
		PlayerTextDrawShow(playerid, NotifTD[playerid][22]);
	    if(pData[playerid][pInfo3] == 1)
	    {
	        PlayerTextDrawShow(playerid, NotifTD[playerid][17]);
	        PlayerTextDrawColor(playerid, NotifTD[playerid][17], -2686721);
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][21], "Warning");
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][22], "Unknown_cmd_use_/help!");
		}
		if(pData[playerid][pInfo3] == 2)
	    {
	        PlayerTextDrawColor(playerid, NotifTD[playerid][17], 1687547391);
	        PlayerTextDrawShow(playerid, NotifTD[playerid][17]);
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][21], "Announcement");
	        //PlayerTextDrawSetString(playerid, NotifTD[playerid][10], "Unknown_cmd_use_/help!");
		}
		if(pData[playerid][pInfo1] == 3)
	    {
	        PlayerTextDrawColor(playerid, NotifTD[playerid][17], 16711935);
	        PlayerTextDrawShow(playerid, NotifTD[playerid][17]);
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][21], "Succes");
	        //PlayerTextDrawSetString(playerid, NotifTD[playerid][10], "Unknown_cmd_use_/help!");
		}
	}
	if(pData[playerid][pInfo] == 4)
	{
	    PlayerTextDrawShow(playerid, NotifTD[playerid][3]);
	    PlayerTextDrawShow(playerid, NotifTD[playerid][27]);
		PlayerTextDrawShow(playerid, NotifTD[playerid][28]);
	    if(pData[playerid][pInfo4] == 1)
	    {
	        PlayerTextDrawShow(playerid, NotifTD[playerid][23]);
	        PlayerTextDrawColor(playerid, NotifTD[playerid][23], -2686721);
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][27], "Warning");
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][28], "Unknown_cmd_use_/help!");
		}
		if(pData[playerid][pInfo4] == 2)
	    {
	        PlayerTextDrawColor(playerid, NotifTD[playerid][23], 1687547391);
	        PlayerTextDrawShow(playerid, NotifTD[playerid][23]);
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][27], "Announcement");
	        //PlayerTextDrawSetString(playerid, NotifTD[playerid][10], "Unknown_cmd_use_/help!");
		}
		if(pData[playerid][pInfo1] == 3)
	    {
	        PlayerTextDrawColor(playerid, NotifTD[playerid][23], 16711935);
	        PlayerTextDrawShow(playerid, NotifTD[playerid][23]);
	        PlayerTextDrawSetString(playerid, NotifTD[playerid][27], "Succes");
	        //PlayerTextDrawSetString(playerid, NotifTD[playerid][10], "Unknown_cmd_use_/help!");
		}
	}
}

ptask Notifhide[4000](playerid)
{
	if(pData[playerid][pInfo] == 1)
	{
	    pData[playerid][pInfo] = 0;
	    pData[playerid][pInfo1] = 0;
	    PlayerTextDrawHide(playerid, NotifTD[playerid][0]);
	    
	    PlayerTextDrawHide(playerid, NotifTD[playerid][5]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][6]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][7]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][8]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][9]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][10]);
	}
	if(pData[playerid][pInfo] == 2)
	{
	     pData[playerid][pInfo] = 1;
	    pData[playerid][pInfo2] = 0;
	    PlayerTextDrawHide(playerid, NotifTD[playerid][1]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][11]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][12]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][13]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][14]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][15]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][16]);
	}
	if(pData[playerid][pInfo] == 3)
	{
	     pData[playerid][pInfo] = 2;
	    pData[playerid][pInfo3] = 0;
	    PlayerTextDrawHide(playerid, NotifTD[playerid][2]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][17]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][18]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][19]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][20]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][21]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][22]);
	}
	if(pData[playerid][pInfo] == 4)
	{
	     pData[playerid][pInfo] = 3;
	    pData[playerid][pInfo4] = 0;
	    PlayerTextDrawHide(playerid, NotifTD[playerid][3]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][23]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][24]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][25]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][26]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][27]);
	    PlayerTextDrawHide(playerid, NotifTD[playerid][28]);
	}
}

stock GenerateInterface(playerid, bool:create = true)
{
	if (create) {
		/*Textdraw0[playerid] = CreatePlayerTextDraw(playerid,400.000000, 6.000000, "_");
		PlayerTextDrawBackgroundColor(playerid,Textdraw0[playerid], 255);
		PlayerTextDrawFont(playerid,Textdraw0[playerid], 1);
		PlayerTextDrawLetterSize(playerid,Textdraw0[playerid], 0.474999, 1.500000);
		PlayerTextDrawColor(playerid,Textdraw0[playerid], -1);
		PlayerTextDrawSetOutline(playerid,Textdraw0[playerid], 0);
		PlayerTextDrawSetProportional(playerid,Textdraw0[playerid], 1);
		PlayerTextDrawSetShadow(playerid,Textdraw0[playerid], 1);
		PlayerTextDrawUseBox(playerid,Textdraw0[playerid], 1);
		PlayerTextDrawBoxColor(playerid,Textdraw0[playerid], 255);
		PlayerTextDrawTextSize(playerid,Textdraw0[playerid], -10.000000, 0.000000);
		PlayerTextDrawSetSelectable(playerid,Textdraw0[playerid], 0);*/

		Textdraw1[playerid] = CreatePlayerTextDraw(playerid, 240.000000, 5.000000, "");
		PlayerTextDrawFont(playerid, Textdraw1[playerid], 1);
		PlayerTextDrawLetterSize(playerid, Textdraw1[playerid], 0.400000, 2.000000);
		PlayerTextDrawTextSize(playerid, Textdraw1[playerid], 300.000000, 17.000000);
		PlayerTextDrawSetOutline(playerid, Textdraw1[playerid], 0);
		PlayerTextDrawSetShadow(playerid, Textdraw1[playerid], 0);
		PlayerTextDrawAlignment(playerid, Textdraw1[playerid], 1);
		PlayerTextDrawColor(playerid, Textdraw1[playerid], -56);
		PlayerTextDrawBackgroundColor(playerid, Textdraw1[playerid], 255);
		PlayerTextDrawBoxColor(playerid, Textdraw1[playerid], 50);
		PlayerTextDrawUseBox(playerid, Textdraw1[playerid], 0);
		PlayerTextDrawSetProportional(playerid, Textdraw1[playerid], 1);
		PlayerTextDrawSetSelectable(playerid, Textdraw1[playerid], 0);
	} else {
		PlayerTextDrawDestroy(playerid, Textdraw0[playerid]);
		PlayerTextDrawDestroy(playerid, Textdraw1[playerid]);
	}
	return 1;
}
/*ptask Logoupdate[10000](playerid)
{
    CreateTextdrawAnimation(playerid, Textdraw1[playerid], 50, "HOFFENTLICH ROLEPLAY");
}*/
ptask PlayerUpdate[999](playerid)
{
    
	if(pData[playerid][pSedangrepair] == 1)
	{
	    if(GetNearestVehicleToPlayer(playerid, 3.5, false) != pData[playerid][pIdrepair])
		{
		    pData[playerid][pIdrepair] = -1;
		    KillTimer(pData[playerid][pTimerrepair]);
		    pData[playerid][pSedangrepair] = 0;
		    HideProgressBar(playerid);
		}
	}
	if(pData[playerid][pOranggeledah] > -1)
	{
	    if(!IsPlayerConnected(pData[playerid][pOranggeledah]) || !NearPlayer(playerid, pData[playerid][pOranggeledah], 2))
		{
		    pData[playerid][pOranggeledah] = -1;
		}
	}
/*	    if(GetPlayerWeapon(playerid) == 22 && GetPlayerAmmo(playerid) <= 2)
		{
		    SetPlayerAmmo(playerid, 22, 0);
	  		Inventory_Add(playerid, "Glock_17", 348, 1);
		}
    if(GetPlayerWeapon(playerid) == 24 && GetPlayerAmmo(playerid) < 2)
		{
		    SetPlayerAmmo(playerid, 24, 0);
	  		Inventory_Add(playerid, "Desert_Eagle", 348, 1);
		}*/
		//senjata
    if(Inventory_Count(playerid, "Colt45") > 0)
	{
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Colt45")][invSenjata] = 1;
	}
	if(Inventory_Count(playerid, "Silenced_Pistol") > 0)
	{
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Silenced_Pistol")][invSenjata] = 1;
	}
	if(Inventory_Count(playerid, "Desert_Eagle") > 0)
	{
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Desert_Eagle")][invSenjata] = 1;
	}
	if(Inventory_Count(playerid, "Shotgun") > 0)
	{
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Shotgun")][invSenjata] = 1;
	}
	if(Inventory_Count(playerid, "Desert_Eagle") > 0)
	{
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Desert_Eagle")][invSenjata] = 1;
	}
	if(Inventory_Count(playerid, "Ak47") > 0)
	{
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Ak47")][invSenjata] = 1;
	}
	if(Inventory_Count(playerid, "Mp5") > 0)
	{
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Mp5")][invSenjata] = 1;
	}
	if(Inventory_Count(playerid, "Shotgun") > 0)
	{
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Shotgun")][invSenjata] = 1;
	}
	if(Inventory_Count(playerid, "Ak47") > 0)
	{
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Ak47")][invSenjata] = 1;
	}
	if(Inventory_Count(playerid, "Mp5") > 0)
	{
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Mp5")][invSenjata] = 1;
	}
	
	
	//colt
	
	if(Inventory_Count(playerid, "Colt45") < 1)
	{
	    SetPlayerAmmo(playerid, 22, 0);
	}
	//silen
	if(Inventory_Count(playerid, "Silenced_Pistol") > 1 && InventoryData[playerid][Inventory_GetItemID(playerid, "Silenced_Pistol")][invJangka] < 1.0)
	{
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Silenced_Pistol")][invJangka] = 100.0;
	    Inventory_Remove(playerid, "Silenced_Pistol", 1);
	}
	if(Inventory_Count(playerid, "Silenced_Pistol") ==  1 && InventoryData[playerid][Inventory_GetItemID(playerid, "Silenced_Pistol")][invJangka] < 1.0)
	{
	    //InventoryData[playerid][Inventory_GetItemID(playerid, "Colt45")][invJangka] = 100.0
	    Inventory_Remove(playerid, "Silenced_Pistol", 1);
	}
	if(Inventory_Count(playerid, "Silenced_Pistol") < 1 && Inventory_Count(playerid, "Tazer") < 1)
	{
	    SetPlayerAmmo(playerid, 23, 0);
	}
	//desert
	if(Inventory_Count(playerid, "Desert_Eagle") > 1 && InventoryData[playerid][Inventory_GetItemID(playerid, "Desert_Eagle")][invJangka] < 1.0)
	{
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Desert_Eagle")][invJangka] = 100.0;
	    Inventory_Remove(playerid, "Desert_Eagle", 1);
	}
	if(Inventory_Count(playerid, "Desert_Eagle") ==  1 && InventoryData[playerid][Inventory_GetItemID(playerid, "Desert_Eagle")][invJangka] < 1.0)
	{
	    //InventoryData[playerid][Inventory_GetItemID(playerid, "Colt45")][invJangka] = 100.0
	    Inventory_Remove(playerid, "Desert_Eagle", 1);
	}
	if(Inventory_Count(playerid, "Desert_Eagle") < 1)
	{
	    SetPlayerAmmo(playerid, 24, 0);
	}
	//shotgun
	if(Inventory_Count(playerid, "Shotgun") > 1 && InventoryData[playerid][Inventory_GetItemID(playerid, "Shotgun")][invJangka] < 1.0)
	{
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Shotgun")][invJangka] = 100.0;
	    Inventory_Remove(playerid, "Shotgun", 1);
	}
	if(Inventory_Count(playerid, "Shotgun") ==  1 && InventoryData[playerid][Inventory_GetItemID(playerid, "Shotgun")][invJangka] < 1.0)
	{
	    //InventoryData[playerid][Inventory_GetItemID(playerid, "Colt45")][invJangka] = 100.0
	    Inventory_Remove(playerid, "Shotgun", 1);
	}
	if(Inventory_Count(playerid, "Shotgun") < 1)
	{
	    SetPlayerAmmo(playerid, 25, 0);
	}
	//ak47
	if(Inventory_Count(playerid, "Ak47") > 1 && InventoryData[playerid][Inventory_GetItemID(playerid, "Ak47")][invJangka] < 1.0)
	{
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Ak47")][invJangka] = 100.0;
	    Inventory_Remove(playerid, "Ak47", 1);
	}
	if(Inventory_Count(playerid, "Ak47") ==  1 && InventoryData[playerid][Inventory_GetItemID(playerid, "Ak47")][invJangka] < 1.0)
	{
	    //InventoryData[playerid][Inventory_GetItemID(playerid, "Colt45")][invJangka] = 100.0
	    Inventory_Remove(playerid, "Ak47", 1);
	}
	if(Inventory_Count(playerid, "Ak47") < 1)
	{
	    SetPlayerAmmo(playerid, 30, 0);
	}
	//mp5
	if(Inventory_Count(playerid, "Mp5") > 1 && InventoryData[playerid][Inventory_GetItemID(playerid, "Mp5")][invJangka] < 1.0)
	{
	    InventoryData[playerid][Inventory_GetItemID(playerid, "Mp5")][invJangka] = 100.0;
	    Inventory_Remove(playerid, "Mp5", 1);
	}
	if(Inventory_Count(playerid, "Mp5") ==  1 && InventoryData[playerid][Inventory_GetItemID(playerid, "Mp5")][invJangka] < 1.0)
	{
	    //InventoryData[playerid][Inventory_GetItemID(playerid, "Colt45")][invJangka] = 100.0
	    Inventory_Remove(playerid, "Mp5", 1);
	}
	if(Inventory_Count(playerid, "Mp5") < 1)
	{
	    SetPlayerAmmo(playerid, 29, 0);
	}
	
 //
	if(pData[playerid][pBusTime] > 20)
	{
	    pData[playerid][pBusTime] = 20;
	}
	if(pData[playerid][pBusTime] < 0)
	{
	    pData[playerid][pBusTime] = 0;
	}
	if(pData[playerid][pForklifterTime] > 20)
	{
	    pData[playerid][pForklifterTime] = 20;
	}
	if(pData[playerid][pForklifterTime] < 0)
	{
	    pData[playerid][pForklifterTime] = 0;
	}
	if(pData[playerid][pMowerTime] > 20)
	{
	    pData[playerid][pMowerTime] = 20;
	}
	if(pData[playerid][pMowerTime] < 0)
	{
	    pData[playerid][pMowerTime] = 0;
	}
	if(pData[playerid][pKoranTime] > 20)
	{
	    pData[playerid][pKoranTime] = 20;
	}
	if(pData[playerid][pKoranTime] < 0)
	{
	    pData[playerid][pKoranTime] = 0;
	}
	if(pData[playerid][pAntarayamTime] > 20)
	{
	    pData[playerid][pAntarayamTime] = 20;
	}
	if(pData[playerid][pAntarayamTime] < 0)
	{
	    pData[playerid][pAntarayamTime] = 0;
	}
	if(Dapatkain[playerid] == 1 || Mulaikain[playerid] == 1)
	{
	    if(Inventory_Count(playerid, "Wool") < 1)
	 	{
	 	    KillTimer(pData[playerid][pProseskain]);
	 	    KillTimer(TimerLoading[playerid]);
			LoadingPlayerBar[playerid] = 0;
			HideProgressBar(playerid);
			Dapatkain[playerid] = 0;
			SetTimerEx(ProgressTimer[playerid], 300, false, "d", playerid);
			TogglePlayerControllable(playerid, 1);
		}
	}
	if(Mulaikain[playerid] == 1)
	{
	    ApplyAnimation(playerid,"GRAVEYARD","mrnM_loop",4.0, 1, 0, 0, 0, 0, 1);
 }
	if(IsAtEvent[playerid] == 1)
	{
	    new senjataid = GetPlayerWeaponEx(playerid);
	    if(GetPlayerAmmoEx(playerid) > 1500)
	    {
	        SetPlayerAmmo(playerid, senjataid, 1500);
		}
	    new Float: PosX, Float: PosY, Float: PosZ;
	    GetPlayerPos(playerid, PosX, PosY, PosZ);
	    if(PosZ < 0.0)
		{
		    if(GetPlayerTeam(playerid) == 1)
		    {
		        SetPlayerPos(playerid, -1369.513793, 1486.296264, 11.039062);
			}
			if(GetPlayerTeam(playerid) == 2)
			{
			    SetPlayerPos(playerid, -1467.854980, 1495.103881, 8.25781);
			}
		}
	}
	if(pData[playerid][pProsesbobol] == 1)
	{
	    if(GetNearestVehicleToPlayer(playerid, 3.8, false) != pData[playerid][pCarbobol])
		{
		    pData[playerid][pCarbobol] = INVALID_VEHICLE_ID;
		    KillTimer(TimerLoading[playerid]);
			LoadingPlayerBar[playerid] = 0;
			HideProgressBar(playerid);
			SetTimerEx(ProgressTimer[playerid], 300, false, "d", playerid);
			TogglePlayerControllable(playerid, 1);
			pData[playerid][pProsesbobol] = 0;
			KillTimer(pData[playerid][pTimerbobol]);
		}
	}
	new Float:darah;
	GetPlayerHealth(playerid, darah);
	pData[playerid][pHealth] = darah;
	if(pData[playerid][pAdminDuty] == 1)
	{
	    SetPlayerHealth(playerid, 999999.0);
	}
	if(pData[playerid][pAdminDuty] == 0 && pData[playerid][pHealth] > 100.0)
	{
	    SetPlayerHealth(playerid, 100.0);
	}
	if(pData[playerid][pTali] < 0)
	{
	    pData[playerid][pTali] = 0;
	}
	if(pData[playerid][pIDCardTime] == 0)
	{
	    pData[playerid][pIDCard] = 0;
	}
	if(pData[playerid][pInfo] < 0)
	{
	    pData[playerid][pInfo] = 0;
	}
	if(pData[playerid][pInfo] > 4)
	{
	    pData[playerid][pInfo] = 4;
	}
	new string[128];
	
	 format(string, sizeof(string), "%d", playerid);
	UpdateDynamic3DTextLabelText(pData[playerid][pIdlabel], COLOR_WHITE, string);
    if(IsPlayerInDynamicArea(playerid, ZonaGYM)) pData[playerid][pBladder] += 1;
	//Anti-Cheat Vehicle health hack
	if(pData[playerid][pAdmin] < 2)
	{
		for(new v, j = GetVehiclePoolSize(); v <= j; v++) if(GetVehicleModel(v))
		{
			new Float:health;
			GetVehicleHealth(v, health);
			if( (health > VehicleHealthSecurityData[v]) && VehicleHealthSecurity[v] == false)
			{
				if(GetPlayerVehicleID(playerid) == v)
				{
					new playerState = GetPlayerState(playerid);
					if(playerState == PLAYER_STATE_DRIVER)
					{
						SetValidVehicleHealth(v, VehicleHealthSecurityData[v]);
						SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: "GREY2_E"%s have been auto kicked for vehicle health hack!", pData[playerid][pName]);
						KickEx(playerid);
					}
				}
			}
			if(VehicleHealthSecurity[v] == true)
			{
				VehicleHealthSecurity[v] = false;
			}
			VehicleHealthSecurityData[v] = health;
		}
	}	
	//Anti-Money Hack
	if(GetPlayerMoney(playerid) > pData[playerid][pMoney])
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, pData[playerid][pMoney]);
		//SendAdminMessage(COLOR_RED, "Possible money hacks detected on %s(%i). Check on this player. "LG_E"($%d).", pData[playerid][pName], playerid, GetPlayerMoney(playerid) - pData[playerid][pMoney]);
	}
	//Anti Armour Hacks
	new Float:A;
	GetPlayerArmour(playerid, A);
	if(A > 98)
	{
		if(pData[playerid][pAdmin] < 2)
		{
			if(pData[playerid][pLevel] < 3)
			{
				SetPlayerArmourEx(playerid, 0);
				SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: "GREY2_E"%s(%i) has been auto kicked for armour hacks!", pData[playerid][pName], playerid);
				KickEx(playerid);
			}
		}
	}
	//Weapon AC
	/*if(pData[playerid][pAdmin] < 2)
	{
		if(pData[playerid][pSpawned] == 1)
		{
		    if(pData[playerid][pLevel] < 3 && pData[playerid][pCs] == 0)
		    {
				if(GetPlayerWeapon(playerid) != pData[playerid][pWeapon])
				{
					pData[playerid][pWeapon] = GetPlayerWeapon(playerid);

					if(pData[playerid][pWeapon] >= 1 && pData[playerid][pWeapon] <= 45 && pData[playerid][pWeapon] != 40 && pData[playerid][pWeapon] != 2 && pData[playerid][pGuns][g_aWeaponSlots[pData[playerid][pWeapon]]] != GetPlayerWeapon(playerid))
					{
						pData[playerid][pACWarns]++;

						if(pData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
						{
							SendAnticheat(COLOR_RED, "%s(%d) has possibly used weapon hacks (%s), Please to check /spec this player first!", pData[playerid][pName], playerid, ReturnWeaponName(pData[playerid][pWeapon]));
							SetWeapons(playerid);
						}
						else
						{
							new PlayerIP[16];
							SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dibanned otomatis oleh %s, Alasan: Weapon hacks", pData[playerid][pName], SERVER_BOT);

							GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
							new query[300], tmp[40], ban_time = 0;
							format(tmp, sizeof (tmp), "Weapon Hack (%s)", ReturnWeaponName(pData[playerid][pWeapon]));
							mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', '%s', '%s', %i, %d)", pData[playerid][pUCP], PlayerIP, SERVER_BOT, tmp, gettime(), ban_time);
							mysql_tquery(g_SQL, query);
							KickEx(playerid);
						}
					}
				}
			}
		}
	}	*/
	if(pData[playerid][pAdmin] < 4)
	{
	    if(GetPlayerWeapon(playerid) == 35 || GetPlayerWeapon(playerid) == 36 || GetPlayerWeapon(playerid) == 37 || GetPlayerWeapon(playerid) == 38)
	    {
	        new PlayerIP[16];
								SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dibanned otomatis oleh %s, Alasan: Weapon hacks", pData[playerid][pName], SERVER_BOT);

								GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
								new query[300], tmp[40], ban_time = 0;
								format(tmp, sizeof (tmp), "Weapon Hack (%s)", ReturnWeaponName(pData[playerid][pWeapon]));
								mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', '%s', '%s', %i, %d)", pData[playerid][pUCP], PlayerIP, SERVER_BOT, tmp, gettime(), ban_time);
								mysql_tquery(g_SQL, query);
								KickEx(playerid);
		}
	}
	if(pData[playerid][pAdmin] < 2)
	{
		if(pData[playerid][pFaction] < 1)
		{
		    if(IsAtEvent[playerid] != 1)
		    {
			    if(pData[playerid][pCs] != 1 || pData[playerid][pLevel] < 4)
			    {
			       if(GetPlayerWeapon(playerid) == 16 || GetPlayerWeapon(playerid) == 17 || GetPlayerWeapon(playerid) == 18 || GetPlayerWeapon(playerid) == 19 || GetPlayerWeapon(playerid) == 22 || GetPlayerWeapon(playerid) == 23 || GetPlayerWeapon(playerid) == 24 || GetPlayerWeapon(playerid) == 25 || GetPlayerWeapon(playerid) == 26 || GetPlayerWeapon(playerid) == 27 || GetPlayerWeapon(playerid) ==  28 || GetPlayerWeapon(playerid) == 29 || GetPlayerWeapon(playerid) == 30 || GetPlayerWeapon(playerid) == 31 || GetPlayerWeapon(playerid) == 32 || GetPlayerWeapon(playerid) == 33 || GetPlayerWeapon(playerid) == 34 || GetPlayerWeapon(playerid) == 39)
			       {
			            pData[playerid][pACWarns]++;

								if(pData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
								{

									SendAnticheat(COLOR_RED, "%s(%d) has possibly used weapon hacks (%s), Please to check /spec this player first!", pData[playerid][pName], playerid, ReturnWeaponName(pData[playerid][pWeapon]));
									SetWeapons(playerid);
									ResetPlayerWeaponsEx(playerid);
								}
								else
								{
									new PlayerIP[16];
									SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dibanned otomatis oleh %s, Alasan: Weapon hacks", pData[playerid][pName], SERVER_BOT);

									GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
									new query[300], tmp[40], ban_time = 0;
									format(tmp, sizeof (tmp), "Weapon Hack (%s)", ReturnWeaponName(pData[playerid][pWeapon]));
									mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', '%s', '%s', %i, %d)", pData[playerid][pUCP], PlayerIP, SERVER_BOT, tmp, gettime(), ban_time);
									mysql_tquery(g_SQL, query);
									KickEx(playerid);
								}
					}
				}
			}
		}
	}
	//regen
	if(pData[playerid][pRegen] < 0)
	{
	    pData[playerid][pRegen] = 0;
	}
	if(pData[playerid][pRegen] > 5)
	{
	    pData[playerid][pRegen] = 5;
	}
	if(pData[playerid][pSpawned] == 1)
    {
        UpdatePlayerData(playerid);
	}
	if(pData[playerid][pSpawned] == 1)
    {
        if(GetPlayerWeapon(playerid) != pData[playerid][pWeapon])
        {
            pData[playerid][pWeapon] = GetPlayerWeapon(playerid);

            if(pData[playerid][pWeapon] >= 1 && pData[playerid][pWeapon] <= 45 && pData[playerid][pWeapon] != 42 && pData[playerid][pWeapon] != 2 && pData[playerid][pGuns][g_aWeaponSlots[pData[playerid][pWeapon]]] != GetPlayerWeapon(playerid))
			{
                SendAnticheat(COLOR_YELLOW, "%s (%d) has possibly used weapon hacks (%s), Please to check /spec this player first!", pData[playerid][pName], playerid, ReturnWeaponName(pData[playerid][pWeapon]));
                SetWeapons(playerid); //Reload old weapons
            }
        }
    }
	//Weapon Atth
	if(NetStats_GetConnectedTime(playerid) - WeaponTick[playerid] >= 250)
	{
		static weaponid, ammo, objectslot, count, index;
 
		for (new i = 2; i <= 7; i++) //Loop only through the slots that may contain the wearable weapons
		{
			GetPlayerWeaponData(playerid, i, weaponid, ammo);
			index = weaponid - 22;
		   
			if (weaponid && ammo && !WeaponSettings[playerid][index][Hidden] && IsWeaponWearable(weaponid) && EditingWeapon[playerid] != weaponid)
			{
				objectslot = GetWeaponObjectSlot(weaponid);
 
				if (GetPlayerWeapon(playerid) != weaponid)
					SetPlayerAttachedObject(playerid, objectslot, GetWeaponModel(weaponid), WeaponSettings[playerid][index][Bone], WeaponSettings[playerid][index][Position][0], WeaponSettings[playerid][index][Position][1], WeaponSettings[playerid][index][Position][2], WeaponSettings[playerid][index][Position][3], WeaponSettings[playerid][index][Position][4], WeaponSettings[playerid][index][Position][5], 1.0, 1.0, 1.0);
 
				else if (IsPlayerAttachedObjectSlotUsed(playerid, objectslot)) RemovePlayerAttachedObject(playerid, objectslot);
			}
		}
		for (new i = 4; i <= 8; i++) if (IsPlayerAttachedObjectSlotUsed(playerid, i))
		{
			count = 0;
 
			for (new j = 22; j <= 38; j++) if (PlayerHasWeapon(playerid, j) && GetWeaponObjectSlot(j) == i)
				count++;
 
			if(!count) RemovePlayerAttachedObject(playerid, i);
		}
		WeaponTick[playerid] = NetStats_GetConnectedTime(playerid);
	}
	
	//Player Update Online Data
	//GetPlayerHealth(playerid, pData[playerid][pHealth]);
    //GetPlayerArmour(playerid, pData[playerid][pArmour]);
	
	if(pData[playerid][pJail] <= 0)
	{
		if(pData[playerid][pHunger] > 100)
		{
			pData[playerid][pHunger] = 100;
		}
		if(pData[playerid][pHunger] < 0)
		{
			pData[playerid][pHunger] = 0;
		}
		if(pData[playerid][pEnergy] > 100)
		{
			pData[playerid][pEnergy] = 100;
		}
		if(pData[playerid][pEnergy] < 0)
		{
			pData[playerid][pEnergy] = 0;
		}
		if(pData[playerid][pBladder] > 100)
		{
			pData[playerid][pBladder] = 100;
		}
		if(pData[playerid][pBladder] < 0)
		{
			pData[playerid][pBladder] = 0;
		}
		/*if(pData[playerid][pHealth] > 100)
		{
			SetPlayerHealthEx(playerid, 100);
		}*/
	}
	
	if(pData[playerid][pHBEMode] == 1 && pData[playerid][IsLoggedIn] == true)
	{
		UpdatePlayerHBE(playerid);
        PlayerTextDrawShow(playerid, BarDarah[playerid]);
		PlayerTextDrawShow(playerid, BarArmor[playerid]);
		PlayerTextDrawShow(playerid, BarMakan[playerid]);
		PlayerTextDrawShow(playerid, BarMinum[playerid]);
		PlayerTextDrawShow(playerid, BarPusing[playerid]);
	}
	
	if(pData[playerid][pHospital] == 1)
    {
		if(pData[playerid][pInjured] == 1)
		{
			SetPlayerPosition(playerid, 1258.85, -1304.97, 1061.86, 261.95, 0);
		
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, playerid + 100);
			pData[playerid][pInjured] = 0;
			UpdateDynamic3DTextLabelText(pData[playerid][pInjuredLabel], COLOR_ORANGE, "");
			if(pData[playerid][pWeaponLic] != 1)
			{
				ResetPlayerWeaponsEx(playerid);
			}
			Inventory_Remove(playerid, "Borax", Inventory_Count(playerid, "Borax"));
			Inventory_Remove(playerid, "Paket_Borax", Inventory_Count(playerid, "Paket_Borax"));
			Inventory_Remove(playerid, "Marijuana", Inventory_Count(playerid, "Marijuana"));
			pData[playerid][pBorax] = 0;
			pData[playerid][pPaketBorax] = 0;
			pData[playerid][pMarijuana] = 0;
			pData[playerid][pRedMoney] = 0;
		}
		pData[playerid][pHospitalTime]++;
		new mstr[64];
		format(mstr, sizeof(mstr), "~n~~n~~n~~w~Recovering... %d", 15 - pData[playerid][pHospitalTime]);
		InfoTD_MSG(playerid, 1000, mstr);

		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
		if(pData[playerid][pRegen] > 0)
		{
		    if(!IsPlayerInRangeOfPoint(playerid, 3, 1258.85, -1304.97, 1061.86))
		    {
		        SetPlayerPosition(playerid, 1258.85, -1304.97, 1061.86, 261.95, 0);
			}
		    ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0, 1);
		}
		if(pData[playerid][pRegen] < 1)
		{
	        if(pData[playerid][pHospitalTime] >= 15)
	        {
	            pData[playerid][pHospitalTime] = 0;
	            pData[playerid][pHospital] = 0;
				pData[playerid][pHunger] = 50;
				pData[playerid][pEnergy] = 50;
				SetPlayerHealthEx(playerid, 100);
				pData[playerid][pSick] = 0;
				GivePlayerMoneyEx(playerid, -200);

	            for (new i; i < 20; i++)
	            {
	                SendClientMessage(playerid, -1, "");
	            }

				SendClientMessage(playerid, COLOR_GREY, "--------------------------------------------------------------------------------------------------------");
	            SendClientMessage(playerid, COLOR_WHITE, "Kamu telah keluar dari rumah sakit, kamu membayar $150 kerumah sakit.");
	            SendClientMessage(playerid, COLOR_GREY, "--------------------------------------------------------------------------------------------------------");

				//SetPlayerPosition(playerid, -2028.5463, -92.8601, 1067.4346, 352.2951);

	            TogglePlayerControllable(playerid, 1);
	            SetCameraBehindPlayer(playerid);

	            SetPlayerVirtualWorld(playerid, 0);
	            SetPlayerInterior(playerid, 0);
				ClearAnimations(playerid);
				pData[playerid][pSpawned] = 1;
				SetPVarInt(playerid, "GiveUptime", -1);
			}
		}
    }
	if(pData[playerid][pInjured] == 1 && pData[playerid][pHospital] != 1)
    {
        if(IsAtEvent[playerid] == 1)
    	{
            if(GetPlayerTeam(playerid) == 1)
    		{
    		    killblue += 1;
                SetPlayerPos(playerid, -1369.513793, 1486.296264, 11.039062);
                pData[playerid][pPosX] = -1369.513793;
                pData[playerid][pPosY] = 1486.296264;
                pData[playerid][pPosZ] = 11.039062;
				SetPlayerVirtualWorld(playerid, 100);
				SetPlayerInterior(playerid, 0);
				SetPlayerHealthEx(playerid, 100.0);
				SetPlayerArmourEx(playerid, 100.0);
				ResetPlayerWeapons(playerid);
				GivePlayerWeaponEx(playerid, 24, 500);
				GivePlayerWeaponEx(playerid, 25, 500);
				GivePlayerWeaponEx(playerid, 30, 500);
				foreach(new i : Player)
			    {
			        if(GetPlayerTeam(i) == 2)
			        {
			   			SendClientMessageEx(i, -1, "Total kill: %d", killblue);
					}
				}
				UpdateDynamic3DTextLabelText(pData[playerid][pInjuredLabel], COLOR_ORANGE, "");

			    ClearAnimations(playerid);
			    pData[playerid][pInjured] = 0;
       			
			}
			if(GetPlayerTeam(playerid) == 2)
    		{
    		    killred += 1;
    		    pData[playerid][pPosX] = -1467.854980;
                pData[playerid][pPosY] = 1495.103881;
                pData[playerid][pPosZ] = 8.25781;
                SetPlayerPos(playerid, -1467.854980, 1495.103881, 8.25781);
				SetPlayerVirtualWorld(playerid, 100);
				SetPlayerInterior(playerid, 0);
				SetPlayerHealthEx(playerid, 100.0);
				SetPlayerArmourEx(playerid, 100.0);
				ResetPlayerWeapons(playerid);
				GivePlayerWeaponEx(playerid, 24, 500);
				GivePlayerWeaponEx(playerid, 25, 500);
				GivePlayerWeaponEx(playerid, 30, 500);
				foreach(new i : Player)
			    {
			        if(GetPlayerTeam(i) == 1)
			        {
			   			SendClientMessageEx(i, -1, "Total kill: %d", killred);
					}
				}
				UpdateDynamic3DTextLabelText(pData[playerid][pInjuredLabel], COLOR_ORANGE, "");

			    ClearAnimations(playerid);
			    pData[playerid][pInjured] = 0;
			}
		}
		new mstr[64];
        format(mstr, sizeof(mstr), "/death for spawn to hospital /s for signal emergency");
		InfoTD_MSG(playerid, 1000, mstr);
		/*format(string, sizeof(string), "(( Pingsan ))");
		UpdateDynamic3DTextLabelText(pData[playerid][pInjuredLabel], COLOR_ORANGE, string);*/
		
		if(GetPVarInt(playerid, "GiveUptime") == -1)
		{
			SetPVarInt(playerid, "GiveUptime", gettime());
		}
		
		if(GetPVarInt(playerid,"GiveUptime"))
        {
            if((gettime()-GetPVarInt(playerid, "GiveUptime")) > 600)
            {
                Info(playerid, "Now you can spawn, type '/death' for spawn to hospital.");
                SetPVarInt(playerid, "GiveUptime", 0);
            }
        }
		
        ApplyAnimation(playerid, "CRACK", "null", 4.0, 0, 0, 0, 1, 0, 1);
        ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);
        SetPlayerHealthEx(playerid, 99999);
    }
	if(pData[playerid][pInjured] == 0 && pData[playerid][pGender] != 0) //Pengurangan Data
	{
		if(++ pData[playerid][pHungerTime] >= 150)
        {
            if(pData[playerid][pHunger] > 0)
            {
                pData[playerid][pHunger]--;
            }
            else if(pData[playerid][pHunger] <= 0)
            {
                //SetPlayerHealth(playerid, health - 10);
          		//SetPlayerDrunkLevel(playerid, 8000);
          		pData[playerid][pSick] = 1;
            }
            pData[playerid][pHungerTime] = 0;
        }
        if(++ pData[playerid][pEnergyTime] >= 120)
        {
            if(pData[playerid][pEnergy] > 0)
            {
                pData[playerid][pEnergy]--;
            }
            else if(pData[playerid][pEnergy] <= 0)
            {
                //SetPlayerHealth(playerid, health - 10);
          		//SetPlayerDrunkLevel(playerid, 8000);
          		pData[playerid][pSick] = 1;
            }
            pData[playerid][pEnergyTime] = 0;
        }
        if(++ pData[playerid][pBladderTime] >= 60)
        {
            if(pData[playerid][pBladder] > 0)
            {
                pData[playerid][pBladder]--;
                SetPlayerDrunkLevel(playerid, 0);
            }
            else if(pData[playerid][pBladder] <= 0)
            {
          	//	SetPlayerDrunkLevel(playerid, 8000);
            }
            pData[playerid][pBladderTime] = 0;
        }
		if(pData[playerid][pSick] == 1)
		{
			if(++ pData[playerid][pSickTime] >= 200)
			{
				if(pData[playerid][pSick] >= 1)
				{
					new Float:hp;
					GetPlayerHealth(playerid, hp);
				//	SetPlayerDrunkLevel(playerid, 8000);
					ApplyAnimation(playerid,"CRACK","crckdeth2",4.1,0,1,1,1,1,1);
					Info(playerid, "Sepertinya anda sakit, segeralah pergi ke dokter.");
					SetPlayerHealth(playerid, hp - 3);
					pData[playerid][pSickTime] = 0;
				}
			}
		}
	}
	if (pData[playerid][pSpeedTime] > 0)
	{
        pData[playerid][pSpeedTime]--;
	}
	if(pData[playerid][pLastChopTime] > 0)
    {
		pData[playerid][pLastChopTime]--;
		new mstr[64];
        format(mstr, sizeof(mstr), "Waktu Pencurian ~r~%d ~w~detik", pData[playerid][pLastChopTime]);
        InfoTD_MSG(playerid, 1000, mstr);
	}
	//Jail Player
	if(pData[playerid][pJail] > 0)
	{
		if(pData[playerid][pJailTime] > 0)
		{
			pData[playerid][pJailTime]--;
			new mstr[128];
			format(mstr, sizeof(mstr), "~b~~h~You will be unjail in ~w~%d ~b~~h~seconds.", pData[playerid][pJailTime]);
			InfoTD_MSG(playerid, 1000, mstr);
		}
		else
		{
			pData[playerid][pJail] = 0;
			pData[playerid][pJailTime] = 0;
			//SpawnPlayer(playerid);
			SetPlayerPositionEx(playerid, 1482.0356,-1724.5726,13.5469,750, 2000);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			SendClientMessageToAllEx(COLOR_RED, "Server: "GREY2_E" %s(%d) have been un-jailed by the server. (times up)", pData[playerid][pName], playerid);
		}
	}
	//Arreset Player
	if(pData[playerid][pArrest] > 0)
	{
		if(pData[playerid][pArrestTime] > 0)
		{
			pData[playerid][pArrestTime]--;
			new mstr[128];
			format(mstr, sizeof(mstr), "~b~~h~You will be released in ~w~%d ~b~~h~seconds.", pData[playerid][pArrestTime]);
			InfoTD_MSG(playerid, 1000, mstr);
		}
		else
		{
			pData[playerid][pArrest] = 0;
			pData[playerid][pArrestTime] = 0;
			//SpawnPlayer(playerid);
			SetPlayerPositionEx(playerid,  -721.921508, 2595.538085, 1001.91967, 267.76, 2000);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			Info(playerid, "You have been auto release. (times up)");
		}
	}
}


/*
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if (dialogid == 0) 
	{
        if (response) 
		{
            SetPlayerSkin(playerid, listitem);
            GameTextForPlayer(playerid, "~g~Skin Changed!", 3000, 3);
        }
    }
	if(dialogid == 1) 
	{
		if (response) 
		{
			if (GetPlayerMoney(playerid) < WEAPON_SHOP[listitem][WEAPON_PRICE]) 
			{
				SendClientMessage(playerid, 0xAA0000FF, "Not enough money to purchase this gun!");
				return callcmd::weapons(playerid);
			}
			
			GivePlayerMoney(playerid, -WEAPON_SHOP[listitem][WEAPON_PRICE]);
			GivePlayerWeapon(playerid, WEAPON_SHOP[listitem][WEAPON_ID], WEAPON_SHOP[listitem][WEAPON_AMMO]);
			
			GameTextForPlayer(playerid, "~g~Gun Purchased!", 3000, 3);
		}
	}
    return 1;
} */

public OnPlayerExitVehicle(playerid, vehicleid)
{
    StopAudioStreamForPlayer(playerid);
    if(pData[playerid][pDriveLicApp] > 0)
	{
		//new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 602)
		{
		    DisablePlayerCheckpoint(playerid);
			DisablePlayerRaceCheckpoint(playerid);
		    Info(playerid, "Anda Dengan Sengaja Keluar Dari Mobil Latihan, Anda Telah "RED_E"DIDISKUALIFIKASI.");
		    RemovePlayerFromVehicle(playerid);
		    pData[playerid][pDriveLicApp] = 0;
		    SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(IsAPesawat(vehicleid))
	{
	//	pData[playerid][pTiket] -= 1;
	    new Float:POS[3], otherid;

				GetPlayerPos(playerid, POS[0], POS[1], POS[2]);
				SetPlayerPos(playerid, POS[0] + 2.0, POS[1], POS[2]);
	}
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if (pData[playerid][pAdminDuty])
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid > 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
                SetVehiclePos(vehicleid, fX, fY, fZ+10);
        }
        else
        {
                SetPlayerPosFindZ(playerid, fX, fY, 999.0);
                SetPlayerVirtualWorld(playerid, 0);
                SetPlayerInterior(playerid, 0);
        }
        Info(playerid, "Kamu Telah Berhasil Teleport Ke Marker Di Peta di peta.");
    }
    return 1;
}

stock SendDiscordMessage(channel, message[]) {
	new DCC_Channel:ChannelId;
	switch(channel)
	{
		//==[ Log Join & Leave ]
		case 0:
		{
			ChannelId = DCC_FindChannelById("1077368936334635008");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Log Command ]
		case 1:
		{
			ChannelId = DCC_FindChannelById("1077368938536644618");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Log Chat IC ]
		case 2:
		{
			ChannelId = DCC_FindChannelById("1077368941422317690");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Warning & Banned ]
		case 3:
		{
			ChannelId = DCC_FindChannelById("1077368944811327559");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Log Death ]
		case 4:
		{
			ChannelId = DCC_FindChannelById("1077368946287722516");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		//==[ Ucp ]
		case 5:
		{
			ChannelId = DCC_FindChannelById("1077369031306248252"); //req ucp
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 6://Korup
		{
			ChannelId = DCC_FindChannelById("931204071526899772");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 7://Register
		{
			ChannelId = DCC_FindChannelById("1077369031306248252"); //req ucp
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 8://Bot Admin
		{
			ChannelId = DCC_FindChannelById("1077432499694735443");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 9://Command Admin
		{
			ChannelId = DCC_FindChannelById("1078288187727814717");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 10://Pay
		{
			ChannelId = DCC_FindChannelById("1054211160905351209");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 11://Sell
		{
			ChannelId = DCC_FindChannelById("1054211196598882365");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 12://reffucp
		{
			ChannelId = DCC_FindChannelById("1077229758066208850");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 13://ban
		{
			ChannelId = DCC_FindChannelById("1077368944811327559");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 14://cek pin
		{
			ChannelId = DCC_FindChannelById("1077369033818636389");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
		case 15://rampok
		{
			ChannelId = DCC_FindChannelById("1087930485646299296");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
	}
	return 1;
}

/*stock SendFraksiMessage(id, message[])
{
	switch(id)
	{
		//==[ Log Join & Leave ]
		case 0:
		{
			ChannelId = DCC_FindChannelById("918143752223219762");
			DCC_SendChannelMessage(ChannelId, message);
			return 1;
		}
	}
	return 1;
}*/

public ClickDynamicPlayerTextdraw(playerid, PlayerText:playertextid)
{

    new vehid = GetPlayerVehicleID(playerid);
	new idxs = pvData[vehid][vtoySelected];
	if(playertextid == klik_angkat[playerid])
	{
	    callcmd::p(playerid, "");
	}
	if(playertextid == klik_tutup[playerid])
	{
	    callcmd::hu(playerid, "");
	}
	if(playertextid == klik_tempatduduk1[playerid])
	{
	    new seatid = GetAvailableSeat(vehid, 0);

        
        
        if(seatid == -1)
            return Error(playerid, "Bangku ini telah di isi");

		PutPlayerInVehicle(playerid, vehid, seatid);
	}
	if(playertextid == klik_tempatduduk2[playerid])
	{
	    new seatid = GetAvailableSeat(vehid, 1);

        if(GetVehicleMaxSeats(vehid) < 2)
        return Error(playerid, "Max kursi kendaraan 1.");
        
        if(seatid == -1)
            return Error(playerid, "Bangku ini telah di isi");

		PutPlayerInVehicle(playerid, vehid, seatid);
	}
	if(playertextid == klik_tempatduduk3[playerid])
	{
	    new seatid = GetAvailableSeat(vehid, 2);

        if(GetVehicleMaxSeats(vehid) < 3)
        return Error(playerid, "Tidak bisa.");
        
        if(seatid == -1)
            return Error(playerid, "Bangku ini telah di isi");

		PutPlayerInVehicle(playerid, vehid, seatid);
	}
	if(playertextid == klik_tempatduduk4[playerid])
	{
	    new seatid = GetAvailableSeat(vehid, 3);

        if(GetVehicleMaxSeats(vehid) < 3)
        return Error(playerid, "Tidak bisa.");
        if(seatid == -1)
            return Error(playerid, "Bangku ini telah di isi");

		PutPlayerInVehicle(playerid, vehid, seatid);
	}
	if(playertextid == klik_startengine[playerid])
	{
	    callcmd::engine(playerid, "");
	}
	if(playertextid == klik_kapmesin[playerid])
	{
	    callcmd::hood(playerid, "");
	}
	if(playertextid == klik_bagasi[playerid])
	{
	    callcmd::trunk(playerid, "");
	}
	if(playertextid == klik_lampu[playerid])
	{
	    callcmd::light(playerid, "");
	}
	if(playertextid == klik_kacadepankiri[playerid])
	{
	        SetVehicleParamsCarWindows(vehid, 0, -1, -1, -1);
	}
	if(playertextid == klik_kacadepankanan[playerid])
	{
	        SetVehicleParamsCarWindows(vehid, -1, 0, -1, -1);
	}
    if(playertextid == klik_kacabelakangkanan[playerid])
	{
	        SetVehicleParamsCarWindows(vehid, -1, -1, -1, 0);
	}
	if(playertextid == klik_kacabelakangkiri[playerid])
	{
	        SetVehicleParamsCarWindows(vehid, -1, -1, 0, -1);
	}
		if(playertextid == klik_pintudepankiri[playerid])
		{
		    
			
			if(pData[playerid][pDoor1] == 0)
		    {
		        pData[playerid][pDoor1] = 1;
		    	SetVehicleDoorState(vehid,DOOR_DRIVER,DOOR_HEALTHY_OPENED);
			}
			else
			{
			    pData[playerid][pDoor1] = 0;
			    SetVehicleDoorState(vehid,DOOR_DRIVER,DOOR_HEALTHY_CLOSED);
			}
		}

	if(playertextid == klik_pintudepankanan[playerid])
	{
	    if(pData[playerid][pDoor2] == 0)
	    {
	        pData[playerid][pDoor2] = 1;
	    	SetVehicleDoorState(vehid,DOOR_PASSENGER,DOOR_HEALTHY_OPENED);
		}
		else
		{
		    pData[playerid][pDoor2] = 0;
		    SetVehicleDoorState(vehid,DOOR_PASSENGER,DOOR_HEALTHY_CLOSED);
		}
	}
	if(playertextid == klik_pintubelakangkiri[playerid])
	{

	    	if(pData[playerid][pDoor3] == 0)
		    {
		        pData[playerid][pDoor3] = 1;
		    	SetVehicleDoorState(vehid,DOOR_BACKLEFF,DOOR_HEALTHY_OPENED);
			}
			else
			{
			    pData[playerid][pDoor3] = 0;
			    SetVehicleDoorState(vehid,DOOR_BACKLEFF,DOOR_HEALTHY_CLOSED);
			}

	}
	if(playertextid == klik_pintubelakngkanan[playerid])
	{

		    if(pData[playerid][pDoor4] == 0)
		    {
		        pData[playerid][pDoor4] = 1;
		    	SetVehicleDoorState(vehid,DOOR_BACKRIGHT,DOOR_HEALTHY_OPENED);
			}
			else
			{
			    pData[playerid][pDoor4] = 0;
			    SetVehicleDoorState(vehid,DOOR_BACKRIGHT,DOOR_HEALTHY_CLOSED);
			}

	}
	if(playertextid == LiatTD[playerid][30])
	{
	    for(new i = 0; i < 31; i++)
		{
		    PlayerTextDrawHide(playerid, LiatTD[playerid][i]);
		    CancelSelectTextDraw(playerid);
		}
	}
	if(playertextid == gps[playerid])
	{
	    
		ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Select", "Close");
	}
	if(playertextid == bank[playerid])
	{
	    
		if(pData[playerid][pVip])
		{
			return ShowPlayerDialog(playerid, DIALOG_IBANK, DIALOG_STYLE_LIST, "{6688FF}I-Bank", "Check Balance\nTransfer Money\nSign Paycheck", "Select", "Cancel");
		}

		ShowPlayerDialog(playerid, DIALOG_IBANK, DIALOG_STYLE_LIST, "{6688FF}I-Bank", "Check Balance\nTransfer Money", "Select", "Cancel");
	}
	if(playertextid == Settings[playerid])
	{
		ShowPlayerDialog(playerid, DIALOG_TOGGLEPHONE, DIALOG_STYLE_LIST, "Setting", "Phone On\nPhone Off", "Select", "Back");
	}
	if(playertextid == kamera[playerid])
	{
		callcmd::selfie(playerid, "");
	}
	if(playertextid == Music[playerid])
	{
		ShowPlayerDialog(playerid,DIALOG_BOOMBOX1,DIALOG_STYLE_INPUT, "Boombox Input URL", "Please put a Music URL to play the Music", "Play", "Cancel");
	}
	if(playertextid == twitter[playerid])
	{
		new notif[20];
		if(pData[playerid][pTogTweet] == 1)
		{
			notif = "{ff0000}OFF";
		}
		else
		{
			notif = "{3BBD44}ON";
		}

		ShowPlayerDialog(playerid, PHONE_APP, DIALOG_STYLE_LIST, "Message", "Tweet\nNotification", "Select", "Close");
	}
	
	
	if(playertextid == kontak[playerid])
	{
		if(pData[playerid][pPhoneBook] == 0)
			return ErrorMsg(playerid, "You dont have a phone book.");

		ShowContacts(playerid);
	}
	if(playertextid == whatsapp[playerid])
	{

		ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "Send Text Message", "Please enter the number that you wish to send a text message to:", "Dial", "Back");
	}
	if(playertextid == call[playerid])
	{


		ShowPlayerDialog(playerid, DIALOG_PHONE_DIALUMBER, DIALOG_STYLE_INPUT, "Dial Number", "Please enter the number that you wish to dial below:", "Dial", "Back");
	}
	if(playertextid == TombolFingerPrint[playerid])
	{
	    for(new i = 0; i < 24; i++)
		{
			PlayerTextDrawHide(playerid, Lockhp[playerid][i]);
			PlayerTextDrawHide(playerid, TombolFingerPrint[playerid]);
		}
		for(new i = 0; i < 40; i++)
		{
			PlayerTextDrawShow(playerid, TDPhone[playerid][i]);
			PlayerTextDrawShow(playerid, Nelpon[playerid]);
			PlayerTextDrawShow(playerid, Contact[playerid]);
			PlayerTextDrawShow(playerid, SMS[playerid]);
			PlayerTextDrawShow(playerid, GPS[playerid]);
			PlayerTextDrawShow(playerid, Settings[playerid]);
			PlayerTextDrawShow(playerid, Twitter[playerid]);
			PlayerTextDrawShow(playerid, MBANK[playerid]);
			PlayerTextDrawShow(playerid, Music[playerid]);
			PlayerTextDrawShow(playerid, Camera[playerid]);
		}
		
		SelectTextDraw(playerid, 0xFFA500FF);
	}
	if(playertextid == Lockhp[playerid][19])
	{
	    for(new i = 0; i < 24; i++)
		{
			PlayerTextDrawHide(playerid, Lockhp[playerid][i]);
			PlayerTextDrawHide(playerid, TombolFingerPrint[playerid]);
		}
		for(new i = 0; i < 40; i++)
		{
			PlayerTextDrawShow(playerid, TDPhone[playerid][i]);
			PlayerTextDrawShow(playerid, Nelpon[playerid]);
			PlayerTextDrawShow(playerid, Contact[playerid]);
			PlayerTextDrawShow(playerid, SMS[playerid]);
			PlayerTextDrawShow(playerid, GPS[playerid]);
			PlayerTextDrawShow(playerid, Settings[playerid]);
			PlayerTextDrawShow(playerid, Twitter[playerid]);
			PlayerTextDrawShow(playerid, MBANK[playerid]);
			PlayerTextDrawShow(playerid, Music[playerid]);
			PlayerTextDrawShow(playerid, Camera[playerid]);
		}

		SelectTextDraw(playerid, 0xFFA500FF);
	}
	if(playertextid == klik_home[playerid])
	{
	    for(new i = 0; i < 134; i++)
		{
			PlayerTextDrawHide(playerid, HpHope[playerid][i]);
			PlayerTextDrawHide(playerid, klik_home[playerid]);
			PlayerTextDrawHide(playerid, layar[playerid]);
			PlayerTextDrawHide(playerid, whatsapp[playerid]);
			PlayerTextDrawHide(playerid, call[playerid]);
			PlayerTextDrawHide(playerid, news[playerid]);
			PlayerTextDrawHide(playerid, kontak[playerid]);
			PlayerTextDrawHide(playerid, kamera[playerid]);
			PlayerTextDrawHide(playerid, bank[playerid]);
			PlayerTextDrawHide(playerid, gojek[playerid]);
			PlayerTextDrawHide(playerid, gps[playerid]);
			PlayerTextDrawHide(playerid, twitter[playerid]);
			PlayerTextDrawHide(playerid, jam[playerid]);
		}


		CancelSelectTextDraw(playerid);
	}
    if(playertextid == TD_SAVEVeh[playerid])
	{
		if(IsPlayerInAnyVehicle(playerid))
    	{
    		HideEditVehicleTD(playerid);
    		new x = GetPlayerVehicleID(playerid);
    		foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
    				MySQL_SaveVehicleToys(i);
    			}
    		}
    	}
	}
	//job
	if(playertextid == JobTD[playerid][4])
	{
	
	    pData[playerid][pBus1] = 1;
	    pData[playerid][pDutysweep] = 0;
	    pData[playerid][pDutyfork] = 0;
	    pData[playerid][pDutymow] = 0;
	    SuccesMsg(playerid, "You have a new job");
	    SetPlayerRaceCheckpoint(playerid, 1, 1268.606445, -2038.017944, 59.881599, 0, 0, 0, 5.0);
	    for(new i = 0; i < 24; i++)
		{
		PlayerTextDrawHide(playerid, JobTD[playerid][i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(playertextid == JobTD[playerid][5])
	{

	    pData[playerid][pDutysweep] = 1;
	    pData[playerid][pBus1] = 0;
	    pData[playerid][pDutyfork] = 0;
	    pData[playerid][pDutymow] = 0;
	    SuccesMsg(playerid, "You have a new job");
	   // SetPlayerRaceCheckpoint(playerid, 1, 1268.606445, -2038.017944, 59.881599, 0, 0, 0, 5.0);
	    for(new i = 0; i < 24; i++)
		{
		PlayerTextDrawHide(playerid, JobTD[playerid][i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(playertextid == JobTD[playerid][6])
	{

	    pData[playerid][pBus1] = 0;
	    pData[playerid][pDutysweep] = 0;
	    pData[playerid][pDutyfork] = 1;
	    pData[playerid][pDutymow] = 0;
	    SuccesMsg(playerid, "You have a new job");
	  //  SetPlayerRaceCheckpoint(playerid, 1, 1268.606445, -2038.017944, 59.881599, 0, 0, 0, 5.0);
	    for(new i = 0; i < 24; i++)
		{
		PlayerTextDrawHide(playerid, JobTD[playerid][i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(playertextid == JobTD[playerid][7])
	{
		if(pData[playerid][pIDCardTime] < 1) return ErrorMsg(playerid, "Ktp anda sudah kadaluarsa");
	    pData[playerid][pBus1] = 0;
	    pData[playerid][pDutysweep] = 0;
	    pData[playerid][pDutyfork] = 0;
	    pData[playerid][pDutymow] = 0;
	    pData[playerid][pJob] = 3;
	    SuccesMsg(playerid, "You have a new job");
	 //   SetPlayerRaceCheckpoint(playerid, 1, 1268.606445, -2038.017944, 59.881599, 0, 0, 0, 5.0);
	    for(new i = 0; i < 24; i++)
		{
		PlayerTextDrawHide(playerid, JobTD[playerid][i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(playertextid == JobTD[playerid][8])
	{
		if(pData[playerid][pIDCardTime] < 1) return ErrorMsg(playerid, "Ktp anda sudah kadaluarsa");
	    pData[playerid][pBus1] = 0;
	    pData[playerid][pDutysweep] = 0;
	    pData[playerid][pDutyfork] = 0;
	    pData[playerid][pDutymow] = 0;
	    pData[playerid][pJob] = 1;
	    SuccesMsg(playerid, "You have a new job");
	  //  SetPlayerRaceCheckpoint(playerid, 1, 1268.606445, -2038.017944, 59.881599, 0, 0, 0, 5.0);
	    for(new i = 0; i < 24; i++)
		{
		PlayerTextDrawHide(playerid, JobTD[playerid][i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(playertextid == JobTD[playerid][9])
	{
        if(pData[playerid][pIDCardTime] < 1) return ErrorMsg(playerid, "Ktp anda sudah kadaluarsa");
	    pData[playerid][pBus1] = 0;
	    pData[playerid][pDutysweep] = 0;
	    pData[playerid][pDutyfork] = 1;
	    pData[playerid][pDutymow] = 0;
	    pData[playerid][pJob] = 7;
	    SuccesMsg(playerid, "You have a new job");
	  //  SetPlayerRaceCheckpoint(playerid, 1, 1268.606445, -2038.017944, 59.881599, 0, 0, 0, 5.0);
	    for(new i = 0; i < 24; i++)
		{
		PlayerTextDrawHide(playerid, JobTD[playerid][i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(playertextid == JobTD[playerid][10])
	{
        if(pData[playerid][pIDCardTime] < 1) return ErrorMsg(playerid, "Ktp anda sudah kadaluarsa");
	    pData[playerid][pBus1] = 0;
	    pData[playerid][pDutysweep] = 0;
	    pData[playerid][pDutyfork] = 1;
	    pData[playerid][pDutymow] = 0;
	    pData[playerid][pJob] = 6;
	    SuccesMsg(playerid, "You have a new job");
	  //  SetPlayerRaceCheckpoint(playerid, 1, 1268.606445, -2038.017944, 59.881599, 0, 0, 0, 5.0);
	    for(new i = 0; i < 24; i++)
		{
		PlayerTextDrawHide(playerid, JobTD[playerid][i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(playertextid == JobTD[playerid][11])
	{
        if(pData[playerid][pIDCardTime] < 1) return ErrorMsg(playerid, "Ktp anda sudah kadaluarsa");
	    pData[playerid][pBus1] = 0;
	    pData[playerid][pDutysweep] = 0;
	    pData[playerid][pDutyfork] = 1;
	    pData[playerid][pDutymow] = 0;
	    pData[playerid][pJob] = 5;
	    SuccesMsg(playerid, "You have a new job");
	  //  SetPlayerRaceCheckpoint(playerid, 1, 1268.606445, -2038.017944, 59.881599, 0, 0, 0, 5.0);
	    for(new i = 0; i < 24; i++)
		{
		PlayerTextDrawHide(playerid, JobTD[playerid][i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(playertextid == JobTD[playerid][12])
	{
        if(pData[playerid][pIDCardTime] < 1) return ErrorMsg(playerid, "Ktp anda sudah kadaluarsa");
	    pData[playerid][pBus1] = 0;
	    pData[playerid][pDutysweep] = 0;
	    pData[playerid][pDutyfork] = 1;
	    pData[playerid][pDutymow] = 0;
	    pData[playerid][pJob] = 4;
	    SuccesMsg(playerid, "You have a new job");
	   // SetPlayerRaceCheckpoint(playerid, 1, 1268.606445, -2038.017944, 59.881599, 0, 0, 0, 5.0);
	    for(new i = 0; i < 24; i++)
		{
		PlayerTextDrawHide(playerid, JobTD[playerid][i]);
		}
		CancelSelectTextDraw(playerid);
	}
	if(playertextid == JobTD[playerid][13])
	{
	    DisablePlayerRaceCheckpoint(playerid);
	    pData[playerid][pBus1] = 0;
	    pData[playerid][pDutysweep] = 0;
	    pData[playerid][pDutyfork] = 0;
	    pData[playerid][pDutymow] = 0;
	    pData[playerid][pJob] = 0;
	    SuccesMsg(playerid, "You have been out of job");
	    for(new i = 0; i < 24; i++)
		{
		PlayerTextDrawHide(playerid, JobTD[playerid][i]);
		}
		CancelSelectTextDraw(playerid);
	}
	//bank
	if(playertextid == Atmnew[playerid][12])
	{
	    ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan jumlah uang:", "Transfer", "Cancel");
	}
	if(playertextid == Atmnew[playerid][10])
	{
	    new mstr[128];
				format(mstr, sizeof(mstr), ""WHITE_E"My Balance: "LB_E"%s", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_ATMWITHDRAW, DIALOG_STYLE_LIST, mstr, "$50\n$200\n$500\n$1.000\n$5.000", "Withdraw", "Cancel");
	}
	if(playertextid == Atmnew[playerid][21])
	{
	    DisplayPaycheck(playerid);
	}
	if(playertextid == Atmnew[playerid][2])
	{
	    PlayerTextDrawHide(playerid, Atmnew[playerid][0]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][1]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][2]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][3]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][4]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][5]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][6]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][7]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][8]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][9]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][10]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][11]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][12]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][13]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][14]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][15]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][16]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][17]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][18]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][19]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][20]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][21]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][22]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][23]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][24]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][25]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][26]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][27]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][28]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][29]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][30]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][31]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][32]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][33]);
		PlayerTextDrawHide(playerid, Atmnew[playerid][34]);
		CancelSelectTextDraw(playerid);
	}
	if(playertextid == Atmnew[playerid][11])
	{
	    new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in bank account.\n\nType in the amount you want to deposit below:", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_BANKDEPOSIT, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Deposit", "Cancel");
	}
	if(playertextid == BeliTD[playerid][0])
	{
		SetPlayerSkin(playerid, 1);
		pData[playerid][pBeli] = 1;
		PlayerTextDrawHide(playerid, ToysTD[playerid][0]);

	}
	if(playertextid == BeliTD[playerid][1])
	{
		//SetPlayerSkin(playerid, 1);
		pData[playerid][pBeli] = 2;
  		PlayerTextDrawShow(playerid, ToysTD[playerid][0]);
	}
	if(playertextid == BeliTD[playerid][2])
	{
	//	SetPlayerSkin(playerid, 1);
		pData[playerid][pBeli] = 3;
	}
	if(playertextid == BeliTD[playerid][3])
	{
	//	SetPlayerSkin(playerid, 1);
		pData[playerid][pBeli] = 4;
	}
	if(playertextid == BeliTD[playerid][4])
	{
		SetPlayerSkin(playerid, pData[playerid][pSkin]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][0]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][1]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][2]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][3]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][4]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][5]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][6]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][7]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][8]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][9]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][10]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][11]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][12]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][13]);
		PlayerTextDrawHide(playerid, ToysTD[playerid][0]);
		CancelSelectTextDraw(playerid);
		pData[playerid][pBeli] = 0;
		SetCameraBehindPlayer(playerid);
		
			  SetPlayerVirtualWorld(playerid, 0);
	}
	if(playertextid == BeliTD[playerid][10])
	{
	    
	    if(pData[playerid][pBeli] == 1)
	    {
	        if(pData[playerid][pGender] == 1)
	        {
		        pData[playerid][pSkin] = Bajucowo[SelectCharPlace[playerid]][0];
				SetPlayerSkin(playerid, pData[playerid][pSkin]);
		        pData[playerid][pBeli] = 0;
			}
			if(pData[playerid][pGender] == 2)
	        {
		        pData[playerid][pSkin] = Bajucewe[SelectCharPlace[playerid]][0];
				SetPlayerSkin(playerid, pData[playerid][pSkin]);
		        pData[playerid][pBeli] = 0;
			}
	    }
	    if(pData[playerid][pBeli] == 2)
	    {
	        new bizid = pData[playerid][pInBiz], price;
				price = bData[bizid][bP][1];

				GivePlayerMoneyEx(playerid, -price);
				if(pData[playerid][PurchasedToy] == false) MySQL_CreatePlayerToy(playerid);
				pToys[playerid][pData[playerid][toySelected]][toy_model] = Toysbeli[SelectCharPlace[playerid]][0];
				pToys[playerid][pData[playerid][toySelected]][toy_status] = 1;
				new finstring[750];
				strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
				strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");
				ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""WHITE_E"Select Bone", finstring, "Select", "Cancel");

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli object ID %d seharga %s.", ReturnName(playerid), Toysbeli[SelectCharPlace[playerid]][0], FormatMoney(price));
				bData[bizid][bProd]--;
				bData[bizid][bMoney] += Server_Percent(price);
				Server_AddPercent(price);

				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
				mysql_tquery(g_SQL, query);
         PlayerTextDrawHide(playerid, BeliTD[playerid][0]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][1]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][2]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][3]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][4]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][5]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][6]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][7]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][8]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][9]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][10]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][11]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][12]);
		PlayerTextDrawHide(playerid, BeliTD[playerid][13]);
		PlayerTextDrawHide(playerid, ToysTD[playerid][0]);
		CancelSelectTextDraw(playerid);
		pData[playerid][pBeli] = 0;
		SetCameraBehindPlayer(playerid);

			  SetPlayerVirtualWorld(playerid, 0);
	    }
	    if(pData[playerid][pBeli] == 3)
	    {
         pData[playerid][pBeli] = 0;
	    }
	    if(pData[playerid][pBeli] == 4)
	    {
         pData[playerid][pBeli] = 0;
	    }
	}
	if(playertextid == BeliTD[playerid][13])
	{
	   
	    if(pData[playerid][pBeli] == 1)
	    {
			if(pData[playerid][pGender] == 1)
			{
			    if(SelectCharPlace[playerid] == sizeof(Bajucowo) - 1) SelectCharPlace[playerid] = 0;
				else SelectCharPlace[playerid] ++;
				
				SetPlayerSkin(playerid, Bajucowo[SelectCharPlace[playerid]][0]);
			}
			if(pData[playerid][pGender] == 2)
			{
			    if(SelectCharPlace[playerid] == sizeof(Bajucewe) - 1) SelectCharPlace[playerid] = 0;
				else SelectCharPlace[playerid] ++;
				
				SetPlayerSkin(playerid, Bajucewe[SelectCharPlace[playerid]][0]);
			}
	    }
	    if(pData[playerid][pBeli] == 2)
	    {
	        if(SelectCharPlace[playerid] == sizeof(Toysbeli) - 1) SelectCharPlace[playerid] = 0;
			else SelectCharPlace[playerid] ++;

	        //SetPlayerAttachedObject(playerid, 99, Toysbeli[SelectCharPlace[playerid]][0], 9);
	        PlayerTextDrawShow(playerid, ToysTD[playerid][0]);
			PlayerTextDrawSetPreviewModel(playerid, ToysTD[playerid][0], Toysbeli[SelectCharPlace[playerid]][0]);

	    }
	    if(pData[playerid][pBeli] == 3)
	    {
       
	    }
	    if(pData[playerid][pBeli] == 4)
	    {
       
	    }
	}
	if(playertextid == BeliTD[playerid][12])
	{
	 
	    if(pData[playerid][pBeli] == 1)
	    {
	        if(pData[playerid][pGender] == 1)
			{
		        if(SelectCharPlace[playerid] == sizeof(Bajucowo) - 1) SelectCharPlace[playerid] = 0;
				else SelectCharPlace[playerid] --;

				SetPlayerSkin(playerid, Bajucowo[SelectCharPlace[playerid]][0]);
			}
			if(pData[playerid][pGender] == 2)
			{
		        if(SelectCharPlace[playerid] == sizeof(Bajucewe) - 1) SelectCharPlace[playerid] = 0;
				else SelectCharPlace[playerid] --;

				SetPlayerSkin(playerid, Bajucewe[SelectCharPlace[playerid]][0]);
			}
	    }
	    if(pData[playerid][pBeli] == 2)
	    {
            if(SelectCharPlace[playerid] == sizeof(Toysbeli) - 1) SelectCharPlace[playerid] = 0;
			else SelectCharPlace[playerid] --;

	        //SetPlayerAttachedObject(playerid, 99, Toysbeli[SelectCharPlace[playerid]][0], 9);
			PlayerTextDrawSetPreviewModel(playerid, ToysTD[playerid][0], Toysbeli[SelectCharPlace[playerid]][0]);
			PlayerTextDrawShow(playerid, ToysTD[playerid][0]);

	    }
	    if(pData[playerid][pBeli] == 3)
	    {
       
	    }
	    if(pData[playerid][pBeli] == 4)
	    {
        
	    }
	}
	if(playertextid == TD_VALUEVeh[playerid])
	{
		new string[1024];
		format(string, sizeof(string), "Your Values %f\nInput new Values :", NudgeVal[playerid]);
		ShowPlayerDialog(playerid, DIALOG_ENTER_VALUE, DIALOG_STYLE_INPUT, "Input Value", string, "Okay", "Cancel");
	}
	if(playertextid == PlusPosXVeh[playerid])
	{
		vtData[vehid][idxs][vtoy_x] += NudgeVal[playerid];
		AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model], vehid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z], vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
	}
	if(playertextid == MinPosXVeh[playerid])
	{
		vtData[vehid][idxs][vtoy_x] -= NudgeVal[playerid];
		AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model], vehid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z], vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
	}
	if(playertextid == PlusPosYVeh[playerid])
	{
		vtData[vehid][idxs][vtoy_y] += NudgeVal[playerid];
		AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model], vehid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z], vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
		}
	if(playertextid == MinPosYVeh[playerid])
	{
		vtData[vehid][idxs][vtoy_y] -= NudgeVal[playerid];
		AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model], vehid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z], vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
	}
	if(playertextid == PlusPosZVeh[playerid])
	{
		vtData[vehid][idxs][vtoy_z] += NudgeVal[playerid];
		AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model], vehid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z], vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
	}
	if(playertextid == MinPosZVeh[playerid])
	{
		vtData[vehid][idxs][vtoy_z] -= NudgeVal[playerid];
		AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model], vehid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z], vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
	}
	if(playertextid == PlusRotXVeh[playerid])
	{
		vtData[vehid][idxs][vtoy_rx] += NudgeVal[playerid];
		AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model], vehid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z], vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
	}
	if(playertextid == MinRotXVeh[playerid])
	{
		vtData[vehid][idxs][vtoy_rx] -= NudgeVal[playerid];
		AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model], vehid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z], vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
	}
	if(playertextid == PlusRotYVeh[playerid])
	{
		vtData[vehid][idxs][vtoy_ry] += NudgeVal[playerid];
		AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model], vehid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z], vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
	}
	if(playertextid == MinRotYVeh[playerid])
	{
		vtData[vehid][idxs][vtoy_ry] -= NudgeVal[playerid];
		AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model], vehid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z], vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
	}
	if(playertextid == PlusRotZVeh[playerid])
	{
		vtData[vehid][idxs][vtoy_rz] += NudgeVal[playerid];
		AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model], vehid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z], vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
	}
	if(playertextid == MinRotZVeh[playerid])
	{
		vtData[vehid][idxs][vtoy_rz] -= NudgeVal[playerid];
		AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model], vehid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z], vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
	}
    //GOINGTO 2NDPAGE
    if (playertextid == BankTD23[playerid])
    {

		PlayerTextDrawHide(playerid, BankTD5[playerid]);
		PlayerTextDrawHide(playerid, BankTD6[playerid]);
		PlayerTextDrawHide(playerid, BankTD7[playerid]);
		PlayerTextDrawHide(playerid, BankTD8[playerid]);
		PlayerTextDrawHide(playerid, BankTD9[playerid]);
		PlayerTextDrawHide(playerid, BankTD10[playerid]);
		PlayerTextDrawHide(playerid, BankTD11[playerid]);
		PlayerTextDrawShow(playerid, BankTD12[playerid]);
		PlayerTextDrawShow(playerid, BankTD13[playerid]);
		PlayerTextDrawShow(playerid, BankTD14[playerid]);
		PlayerTextDrawShow(playerid, BankTD15[playerid]);
		PlayerTextDrawShow(playerid, BankTD16[playerid]);
		PlayerTextDrawShow(playerid, BankTD17[playerid]);
		PlayerTextDrawShow(playerid, BankTD18[playerid]);
		PlayerTextDrawShow(playerid, BankTD19[playerid]);
        PlayerTextDrawShow(playerid, BankTD20[playerid]);
        PlayerTextDrawShow(playerid, BankTD21[playerid]);
        PlayerTextDrawShow(playerid, BankTD22[playerid]);
        PlayerTextDrawShow(playerid, BankTD23[playerid]);
		pData[playerid][pToggleAtm] = 0;
        return 1;
    }
    //DEPOSIT
	if (playertextid == BankTD15[playerid])
    {
		pData[playerid][pToggleAtm] = 0;
		PlayerTextDrawHide(playerid, BankTD0[playerid]);
		PlayerTextDrawHide(playerid, BankTD1[playerid]);
		PlayerTextDrawHide(playerid, BankTD2[playerid]);
		PlayerTextDrawHide(playerid, BankTD3[playerid]);
		PlayerTextDrawHide(playerid, BankTD4[playerid]);
		PlayerTextDrawHide(playerid, BankTD5[playerid]);
		PlayerTextDrawHide(playerid, BankTD6[playerid]);
		PlayerTextDrawHide(playerid, BankTD7[playerid]);
		PlayerTextDrawHide(playerid, BankTD8[playerid]);
		PlayerTextDrawHide(playerid, BankTD9[playerid]);
		PlayerTextDrawHide(playerid, BankTD10[playerid]);
		PlayerTextDrawHide(playerid, BankTD11[playerid]);
		PlayerTextDrawHide(playerid, BankTD12[playerid]);
		PlayerTextDrawHide(playerid, BankTD13[playerid]);
		PlayerTextDrawHide(playerid, BankTD14[playerid]);
		PlayerTextDrawHide(playerid, BankTD15[playerid]);
		PlayerTextDrawHide(playerid, BankTD16[playerid]);
		PlayerTextDrawHide(playerid, BankTD17[playerid]);
		PlayerTextDrawHide(playerid, BankTD18[playerid]);
		PlayerTextDrawHide(playerid, BankTD19[playerid]);
		PlayerTextDrawHide(playerid, BankTD20[playerid]);
		PlayerTextDrawHide(playerid, BankTD21[playerid]);
		PlayerTextDrawHide(playerid, BankTD22[playerid]);
		PlayerTextDrawHide(playerid, BankTD23[playerid]);

		ShowDialogToPlayer(playerid, DIALOG_BANKDEPOSIT);
		CancelSelectTextDraw(playerid);
        return 1;
    }
	//WITHDRAW
	if (playertextid == BankTD16[playerid])
    {
		pData[playerid][pToggleAtm] = 0;
		PlayerTextDrawHide(playerid, BankTD0[playerid]);
		PlayerTextDrawHide(playerid, BankTD1[playerid]);
		PlayerTextDrawHide(playerid, BankTD2[playerid]);
		PlayerTextDrawHide(playerid, BankTD3[playerid]);
		PlayerTextDrawHide(playerid, BankTD4[playerid]);
		PlayerTextDrawHide(playerid, BankTD5[playerid]);
		PlayerTextDrawHide(playerid, BankTD6[playerid]);
		PlayerTextDrawHide(playerid, BankTD7[playerid]);
		PlayerTextDrawHide(playerid, BankTD8[playerid]);
		PlayerTextDrawHide(playerid, BankTD9[playerid]);
		PlayerTextDrawHide(playerid, BankTD10[playerid]);
		PlayerTextDrawHide(playerid, BankTD11[playerid]);
		PlayerTextDrawHide(playerid, BankTD12[playerid]);
		PlayerTextDrawHide(playerid, BankTD13[playerid]);
		PlayerTextDrawHide(playerid, BankTD14[playerid]);
		PlayerTextDrawHide(playerid, BankTD15[playerid]);
		PlayerTextDrawHide(playerid, BankTD16[playerid]);
		PlayerTextDrawHide(playerid, BankTD17[playerid]);
		PlayerTextDrawHide(playerid, BankTD18[playerid]);
		PlayerTextDrawHide(playerid, BankTD19[playerid]);
		PlayerTextDrawHide(playerid, BankTD20[playerid]);
		PlayerTextDrawHide(playerid, BankTD21[playerid]);
		PlayerTextDrawHide(playerid, BankTD22[playerid]);
		PlayerTextDrawHide(playerid, BankTD23[playerid]);

		ShowDialogToPlayer(playerid, DIALOG_BANKWITHDRAW);
		CancelSelectTextDraw(playerid);
        return 1;
    }
	//TRANSFER
	if (playertextid == BankTD17[playerid])
    {
		pData[playerid][pToggleAtm] = 0;
		PlayerTextDrawHide(playerid, BankTD0[playerid]);
		PlayerTextDrawHide(playerid, BankTD1[playerid]);
		PlayerTextDrawHide(playerid, BankTD2[playerid]);
		PlayerTextDrawHide(playerid, BankTD3[playerid]);
		PlayerTextDrawHide(playerid, BankTD4[playerid]);
		PlayerTextDrawHide(playerid, BankTD5[playerid]);
		PlayerTextDrawHide(playerid, BankTD6[playerid]);
		PlayerTextDrawHide(playerid, BankTD7[playerid]);
		PlayerTextDrawHide(playerid, BankTD8[playerid]);
		PlayerTextDrawHide(playerid, BankTD9[playerid]);
		PlayerTextDrawHide(playerid, BankTD10[playerid]);
		PlayerTextDrawHide(playerid, BankTD11[playerid]);
		PlayerTextDrawHide(playerid, BankTD12[playerid]);
		PlayerTextDrawHide(playerid, BankTD13[playerid]);
		PlayerTextDrawHide(playerid, BankTD14[playerid]);
		PlayerTextDrawHide(playerid, BankTD15[playerid]);
		PlayerTextDrawHide(playerid, BankTD16[playerid]);
		PlayerTextDrawHide(playerid, BankTD17[playerid]);
		PlayerTextDrawHide(playerid, BankTD18[playerid]);
		PlayerTextDrawHide(playerid, BankTD19[playerid]);
		PlayerTextDrawHide(playerid, BankTD20[playerid]);
		PlayerTextDrawHide(playerid, BankTD21[playerid]);
		PlayerTextDrawHide(playerid, BankTD22[playerid]);
		PlayerTextDrawHide(playerid, BankTD23[playerid]);

		ShowDialogToPlayer(playerid, DIALOG_BANKREKENING);
		CancelSelectTextDraw(playerid);
        return 1;
    }
    //IPHONE HOFFENTLICH
/*	if(playertextid == CLOSEHP2[playerid])
	{
		for(new i = 0; i < 47; i++) {
			PlayerTextDrawHide(playerid, IPHONE2[playerid][i]);
		}
		PlayerTextDrawHide(playerid, CLICKGPS[playerid]);
		PlayerTextDrawHide(playerid, CLICKEBANK[playerid]);
		PlayerTextDrawHide(playerid, CLICKAPPSTORE[playerid]);
		PlayerTextDrawHide(playerid, CLICKSETTING[playerid]);
		PlayerTextDrawHide(playerid, CLICKCAMERA[playerid]);
		PlayerTextDrawHide(playerid, CLICKMUSIC[playerid]);
		PlayerTextDrawHide(playerid, CLICKTWITTER[playerid]);
		PlayerTextDrawHide(playerid, CLICKKOJEK[playerid]);
		PlayerTextDrawHide(playerid, CLICKEWALLET[playerid]);
		PlayerTextDrawHide(playerid, CLICKCONTACT[playerid]);
		PlayerTextDrawHide(playerid, CLICKSMS[playerid]);
		PlayerTextDrawHide(playerid, CLICKCALL[playerid]);
		PlayerTextDrawHide(playerid, CLOSEHP2[playerid]);
		CancelSelectTextDraw(playerid);
	}
	if(playertextid == CLICKGPS[playerid])
	{
		if(pData[playerid][pPhoneStatus] == 0)
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}
		ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Select", "Close");
	}
	if(playertextid == CLICKEBANK[playerid])
	{
		if(pData[playerid][pPhoneStatus] == 0)
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}
		if(pData[playerid][pVip])
		{
			return ShowPlayerDialog(playerid, DIALOG_IBANK, DIALOG_STYLE_LIST, "{6688FF}I-Bank", "Check Balance\nTransfer Money\nSign Paycheck", "Select", "Cancel");
		}

		ShowPlayerDialog(playerid, DIALOG_IBANK, DIALOG_STYLE_LIST, "{6688FF}I-Bank", "Check Balance\nTransfer Money", "Select", "Cancel");
	}
	if(playertextid == CLICKAPPSTORE[playerid])
	{
		if(pData[playerid][pPhoneStatus] == 0)
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}

		new string[512];
		format(string, sizeof(string),"Twitter\nBinory\nIsi Kuota");
		ShowPlayerDialog(playerid, DIALOG_ISIKUOTA, DIALOG_STYLE_LIST,"Phone",string,"Pilih","Batal");
	}
	if(playertextid == CLICKSETTING[playerid])
	{
		ShowPlayerDialog(playerid, DIALOG_TOGGLEPHONE, DIALOG_STYLE_LIST, "Setting", "Phone On\nPhone Off", "Select", "Back");
	}
	if(playertextid == CLICKCAMERA[playerid])
	{
		callcmd::selfie(playerid, "");
	}
	if(playertextid == CLICKMUSIC[playerid])
	{
		ShowPlayerDialog(playerid,DIALOG_BOOMBOX1,DIALOG_STYLE_INPUT, "Boombox Input URL", "Please put a Music URL to play the Music", "Play", "Cancel");
	}
	if(playertextid == CLICKTWITTER[playerid])
	{
		new notif[20];
		if(pData[playerid][pTogTweet] == 1)
		{
			notif = "{ff0000}OFF";
		}
		else
		{
			notif = "{3BBD44}ON";
		}

		if(pData[playerid][pPhoneStatus] == 0)
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}
		if(pData[playerid][pTwitter] < 1)
		{
			return ErrorMsg(playerid, "Anda belum memiliki Twitter, harap download!");
		}
		ShowPlayerDialog(playerid, PHONE_APP, DIALOG_STYLE_LIST, "Message", "Tweet\nNotification", "Select", "Close");
	}
	if(playertextid == CLICKKOJEK[playerid])
	{

	}
	if(playertextid == CLICKEWALLET[playerid])
	{

	}
	if(playertextid == CLICKCONTACT[playerid])
	{
		if (pData[playerid][pPhoneStatus] == 0)
			return ErrorMsg(playerid, "Your phone must be powered on.");

		if(pData[playerid][pPhoneBook] == 0)
			return ErrorMsg(playerid, "You dont have a phone book.");

		ShowContacts(playerid);
	}
	if(playertextid == CLICKSMS[playerid])
	{
		if(pData[playerid][pPhoneStatus] == 0)
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}

		ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "Send Text Message", "Please enter the number that you wish to send a text message to:", "Dial", "Back");
	}
	if(playertextid == CLICKCALL[playerid])
	{
		if(pData[playerid][pPhoneStatus] == 0)
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}

		ShowPlayerDialog(playerid, DIALOG_PHONE_DIALUMBER, DIALOG_STYLE_INPUT, "Dial Number", "Please enter the number that you wish to dial below:", "Dial", "Back");
	}*/
    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	//sp
	
	//IPHONE CALL
	if(clickedid == ACCEPTCALL) // INVENTORY
	{
		callcmd::p(playerid, "");
	}
	if(clickedid == ENDCALL) // INVENTORY
	{
		callcmd::hu(playerid, "");
		
		for(new i = 0; i < 25; i++)
		{
  			TextDrawHideForPlayer(playerid, IPHONECALL[i]);
		}
		TextDrawHideForPlayer(playerid, ACCEPTCALL);
		TextDrawHideForPlayer(playerid, REJECTCALL);
		TextDrawHideForPlayer(playerid, ENDCALL);
		CancelSelectTextDraw(playerid);
				
	}
	if(clickedid == REJECTCALL) // INVENTORY
	{
		callcmd::hu(playerid, "");
		
		for(new i = 0; i < 25; i++)
		{
  			TextDrawHideForPlayer(playerid, IPHONECALL[i]);
		}
		TextDrawHideForPlayer(playerid, ACCEPTCALL);
		TextDrawHideForPlayer(playerid, REJECTCALL);
		TextDrawHideForPlayer(playerid, ENDCALL);
		CancelSelectTextDraw(playerid);
	}
	if(clickedid == PANELEMOTE) // INVENTORY
	{
	    PreloadPlayerAnims(playerid);
		ShowPlayerDialog(playerid, D_ANIM_LIBRARIES, DIALOG_STYLE_LIST, "Choose an animation library", gLibList, "Open...", "Cancel");
		for(new i = 0; i < 17; i++)
		{
			TextDrawHideForPlayer(playerid, F1FIVEM[i]);
		}
		TextDrawHideForPlayer(playerid, PANELINVENTORY);
		TextDrawHideForPlayer(playerid, PANELHANDPHONE);
		TextDrawHideForPlayer(playerid, PANELPAKAIAN);
		TextDrawHideForPlayer(playerid, PANELDOKUMEN);
		TextDrawHideForPlayer(playerid, PANELEMOTE);
		TextDrawHideForPlayer(playerid, PANELKTP);
		TextDrawHideForPlayer(playerid, PANELTRUNK);
		TextDrawHideForPlayer(playerid, PANELKENDARAAN);
		CancelSelectTextDraw(playerid);
	return 1;
	}
	if(clickedid == PANELTRUNK) // INVENTORY
	{
	    callcmd::vstorage(playerid, "");
		for(new i = 0; i < 17; i++)
		{
			TextDrawHideForPlayer(playerid, F1FIVEM[i]);
		}
		TextDrawHideForPlayer(playerid, PANELINVENTORY);
		TextDrawHideForPlayer(playerid, PANELHANDPHONE);
		TextDrawHideForPlayer(playerid, PANELPAKAIAN);
		TextDrawHideForPlayer(playerid, PANELDOKUMEN);
		TextDrawHideForPlayer(playerid, PANELEMOTE);
		TextDrawHideForPlayer(playerid, PANELKTP);
		TextDrawHideForPlayer(playerid, PANELTRUNK);
		TextDrawHideForPlayer(playerid, PANELKENDARAAN);
		CancelSelectTextDraw(playerid);
	return 1;
	}
	//PANEL PLAYERS
	if(clickedid == PANELINVENTORY) // INVENTORY
	{
	    for(new i = 0; i < 17; i++)
		{
			TextDrawHideForPlayer(playerid, F1FIVEM[i]);
		}
		TextDrawHideForPlayer(playerid, PANELINVENTORY);
		TextDrawHideForPlayer(playerid, PANELHANDPHONE);
		TextDrawHideForPlayer(playerid, PANELPAKAIAN);
		TextDrawHideForPlayer(playerid, PANELDOKUMEN);
		TextDrawHideForPlayer(playerid, PANELEMOTE);
		TextDrawHideForPlayer(playerid, PANELKTP);
		TextDrawHideForPlayer(playerid, PANELTRUNK);
		TextDrawHideForPlayer(playerid, PANELKENDARAAN);

		Inventory_Show(playerid);
	}
	if(clickedid == F1FIVEM[0]) // CLOSE PANEL
	{
	    for(new i = 0; i < 17; i++)
		{
			TextDrawHideForPlayer(playerid, F1FIVEM[i]);
		}
		TextDrawHideForPlayer(playerid, PANELINVENTORY);
		TextDrawHideForPlayer(playerid, PANELHANDPHONE);
		TextDrawHideForPlayer(playerid, PANELPAKAIAN);
		TextDrawHideForPlayer(playerid, PANELDOKUMEN);
		TextDrawHideForPlayer(playerid, PANELEMOTE);
		TextDrawHideForPlayer(playerid, PANELKTP);
		TextDrawHideForPlayer(playerid, PANELTRUNK);
		TextDrawHideForPlayer(playerid, PANELKENDARAAN);
		CancelSelectTextDraw(playerid);
	}
	if(clickedid == PANELKTP) // INVENTORY
	{
	    for(new i = 0; i < 17; i++)
		{
			TextDrawHideForPlayer(playerid, F1FIVEM[i]);
		}
		TextDrawHideForPlayer(playerid, PANELINVENTORY);
		TextDrawHideForPlayer(playerid, PANELHANDPHONE);
		TextDrawHideForPlayer(playerid, PANELPAKAIAN);
		TextDrawHideForPlayer(playerid, PANELDOKUMEN);
		TextDrawHideForPlayer(playerid, PANELEMOTE);
		TextDrawHideForPlayer(playerid, PANELKTP);
		TextDrawHideForPlayer(playerid, PANELTRUNK);
		TextDrawHideForPlayer(playerid, PANELKENDARAAN);
		CancelSelectTextDraw(playerid);
	
	    ShowPlayerDialog(playerid, DIALOG_KTPSIM, DIALOG_STYLE_LIST, "KTP & SIM", "LIHAT KTP\nKASIH KTP\nLIHAT SIM\nKASIH SIM", "Pilih", "Batal");
	} 
	if(clickedid == PANELDOKUMEN) // INVENTORY
	{
	    for(new i = 0; i < 17; i++)
		{
			TextDrawHideForPlayer(playerid, F1FIVEM[i]);
		}
		TextDrawHideForPlayer(playerid, PANELINVENTORY);
		TextDrawHideForPlayer(playerid, PANELHANDPHONE);
		TextDrawHideForPlayer(playerid, PANELPAKAIAN);
		TextDrawHideForPlayer(playerid, PANELDOKUMEN);
		TextDrawHideForPlayer(playerid, PANELEMOTE);
		TextDrawHideForPlayer(playerid, PANELKTP);
		TextDrawHideForPlayer(playerid, PANELTRUNK);
		TextDrawHideForPlayer(playerid, PANELKENDARAAN);
		CancelSelectTextDraw(playerid);

	    ShowPlayerDialog(playerid, DIALOG_DOKUMEN, DIALOG_STYLE_LIST, "DOKUMEN", "LIHAT SKKB\nKASIH SKKB", "Pilih", "Batal");
	}
	if(clickedid == PANELPAKAIAN) // PAKAIAN
	{
	    for(new i = 0; i < 17; i++)
		{
			TextDrawHideForPlayer(playerid, F1FIVEM[i]);
		}
		TextDrawHideForPlayer(playerid, PANELINVENTORY);
		TextDrawHideForPlayer(playerid, PANELHANDPHONE);
		TextDrawHideForPlayer(playerid, PANELPAKAIAN);
		TextDrawHideForPlayer(playerid, PANELDOKUMEN);
		TextDrawHideForPlayer(playerid, PANELEMOTE);
		TextDrawHideForPlayer(playerid, PANELKTP);
		TextDrawHideForPlayer(playerid, PANELTRUNK);
		TextDrawHideForPlayer(playerid, PANELKENDARAAN);
		CancelSelectTextDraw(playerid);
		
	    ShowPlayerDialog(playerid, DIALOG_PANELPAKAIAN, DIALOG_STYLE_LIST, "KTP & SIM", "BUKA PAKAIAN\nPAKAI PAKAIAN", "Pilih", "Batal");
	}
	if(clickedid == PANELHANDPHONE) // HANDPHONE
	{
	    for(new i = 0; i < 17; i++)
		{
			TextDrawHideForPlayer(playerid, F1FIVEM[i]);
		}
		TextDrawHideForPlayer(playerid, PANELINVENTORY);
		TextDrawHideForPlayer(playerid, PANELHANDPHONE);
		TextDrawHideForPlayer(playerid, PANELPAKAIAN);
		TextDrawHideForPlayer(playerid, PANELDOKUMEN);
		TextDrawHideForPlayer(playerid, PANELEMOTE);
		TextDrawHideForPlayer(playerid, PANELKTP);
		TextDrawHideForPlayer(playerid, PANELTRUNK);
		TextDrawHideForPlayer(playerid, PANELKENDARAAN);
		
	    for(new i = 0; i < 134; i++)
		{
			PlayerTextDrawShow(playerid, HpHope[playerid][i]);
			PlayerTextDrawShow(playerid, klik_home[playerid]);
			PlayerTextDrawShow(playerid, layar[playerid]);
			PlayerTextDrawShow(playerid, whatsapp[playerid]);
			PlayerTextDrawShow(playerid, call[playerid]);
			PlayerTextDrawShow(playerid, news[playerid]);
			PlayerTextDrawShow(playerid, kontak[playerid]);
			PlayerTextDrawShow(playerid, kamera[playerid]);
			PlayerTextDrawShow(playerid, bank[playerid]);
			PlayerTextDrawShow(playerid, gojek[playerid]);
			PlayerTextDrawShow(playerid, gps[playerid]);
			PlayerTextDrawShow(playerid, twitter[playerid]);
			PlayerTextDrawShow(playerid, jam[playerid]);
		}
		SelectTextDraw(playerid, 0xFFA500FF);
	}
	if(clickedid == PANELKENDARAAN) // HANDPHONE
	{
	    for(new i = 0; i < 17; i++)
		{
			TextDrawHideForPlayer(playerid, F1FIVEM[i]);
		}
		TextDrawHideForPlayer(playerid, PANELINVENTORY);
		TextDrawHideForPlayer(playerid, PANELHANDPHONE);
		TextDrawHideForPlayer(playerid, PANELPAKAIAN);
		TextDrawHideForPlayer(playerid, PANELDOKUMEN);
		TextDrawHideForPlayer(playerid, PANELEMOTE);
		TextDrawHideForPlayer(playerid, PANELKTP);
		TextDrawHideForPlayer(playerid, PANELTRUNK);
		TextDrawHideForPlayer(playerid, PANELKENDARAAN);
		CancelSelectTextDraw(playerid);
		
  		SendClientMessageEx(playerid, -1, "/cp Untuk menutup panel kendaraan");
		PlayerTextDrawShow(playerid, Panelcar[playerid][0]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][1]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][2]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][3]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][4]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][5]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][6]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][7]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][8]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][9]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][10]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][11]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][12]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][13]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][14]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][15]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][16]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][17]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][18]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][19]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][20]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][21]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][22]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][23]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][24]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][25]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][26]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][27]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][28]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][29]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][30]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][31]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][32]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][33]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][34]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][35]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][36]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][37]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][38]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][39]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][40]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][41]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][42]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][43]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][44]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][45]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][46]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][47]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][48]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][49]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][50]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][51]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][52]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][53]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][54]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][55]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][56]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][57]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][58]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][59]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][60]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][61]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][62]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][63]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][64]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][65]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][66]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][67]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][68]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][69]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][70]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][71]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][72]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][73]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][74]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][75]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][76]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][77]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][78]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][79]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][80]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][81]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][82]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][83]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][84]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][85]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][86]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][87]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][88]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][89]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][90]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][91]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][92]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][93]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][94]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][95]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][96]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][97]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][98]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][99]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][100]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][101]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][102]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][103]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][104]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][105]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][106]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][107]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][108]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][109]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][110]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][111]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][112]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][113]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][114]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][115]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][116]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][117]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][118]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][119]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][120]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][121]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][122]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][123]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][124]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][125]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][126]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][127]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][128]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][129]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][130]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][131]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][132]);
		PlayerTextDrawShow(playerid, Panelcar[playerid][133]);
		PlayerTextDrawShow(playerid, klik_kapmesin[playerid]);
		PlayerTextDrawShow(playerid, klik_bagasi[playerid]);
		PlayerTextDrawShow(playerid, klik_gatau[playerid]);
		PlayerTextDrawShow(playerid, klik_lampu[playerid]);
		PlayerTextDrawShow(playerid, klik_kacadepankiri[playerid]);
		PlayerTextDrawShow(playerid, klik_pintudepankiri[playerid]);
		PlayerTextDrawShow(playerid, klik_tempatduduk1[playerid]);
		PlayerTextDrawShow(playerid, klik_tempatduduk2[playerid]);
		PlayerTextDrawShow(playerid, klik_pintudepankanan[playerid]);
		PlayerTextDrawShow(playerid, klik_kacadepankanan[playerid]);
		PlayerTextDrawShow(playerid, klik_kacabelakangkiri[playerid]);
		PlayerTextDrawShow(playerid, klik_pintubelakangkiri[playerid]);
		PlayerTextDrawShow(playerid, klik_tempatduduk3[playerid]);
		PlayerTextDrawShow(playerid, klik_tempatduduk4[playerid]);
		PlayerTextDrawShow(playerid, klik_pintubelakngkanan[playerid]);
		PlayerTextDrawShow(playerid, klik_kacabelakangkanan[playerid]);
		PlayerTextDrawShow(playerid, klik_startengine[playerid]);
		SelectTextDraw(playerid, 0xFF0000FF);
		
	    //ShowPlayerDialog(playerid, DIALOG_PANELKENDARAAN, DIALOG_STYLE_LIST, "KENDARAAN", "NYALAKAN / MATIKAN\nKUNCI KENDARAAN", "Pilih", "Batal");
	}
	//IPHONE
	if(clickedid == CLOSEHP) 
	{
        for(new i = 0; i < 47; i++)
		{
			TextDrawHideForPlayer(playerid, IPHONE2[i]);
		}
  		TextDrawHideForPlayer(playerid, CLOSEHP);
  		TextDrawHideForPlayer(playerid, CLICKGPS);
		TextDrawHideForPlayer(playerid, CLICKEBANK);
		TextDrawHideForPlayer(playerid, CLICKAPPSTORE);
		TextDrawHideForPlayer(playerid, CLICKSETTING);
		TextDrawHideForPlayer(playerid, CLICKCAMERA);
		TextDrawHideForPlayer(playerid, CLICKMUSIC);
		TextDrawHideForPlayer(playerid, CLICKTWITTER);
		TextDrawHideForPlayer(playerid, CLICKKOJEK);
		TextDrawHideForPlayer(playerid, CLICKEWALLET);
		TextDrawHideForPlayer(playerid, CLICKCALL);
		TextDrawHideForPlayer(playerid, CLICKSMS);
		TextDrawHideForPlayer(playerid, CLICKCONTACT);
		CancelSelectTextDraw(playerid);
	}
	if(clickedid == CLICKGPS) 
	{
	    if(pData[playerid][pPhoneStatus] == 0)
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}
		ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nGeneral Location\nPublic Location\nJobs\nMy Proprties\nMy Mission", "Select", "Close");
	}
	if(clickedid == CLICKEBANK)
	{
	    if(pData[playerid][pPhoneStatus] == 0)
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}
		if(pData[playerid][pVip])
		{
			return ShowPlayerDialog(playerid, DIALOG_IBANK, DIALOG_STYLE_LIST, "{6688FF}I-Bank", "Check Balance\nTransfer Money\nSign Paycheck", "Select", "Cancel");
		}

		ShowPlayerDialog(playerid, DIALOG_IBANK, DIALOG_STYLE_LIST, "{6688FF}I-Bank", "Check Balance\nTransfer Money", "Select", "Cancel");
	}
	if(clickedid == CLICKAPPSTORE)
	{
		if(pData[playerid][pPhoneStatus] == 0)
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}

		new string[512];
		format(string, sizeof(string),"Twitter\nBinory\nIsi Kuota");
		ShowPlayerDialog(playerid, DIALOG_ISIKUOTA, DIALOG_STYLE_LIST,"Phone",string,"Pilih","Batal");
	}
	if(clickedid == CLICKSETTING)
	{
		ShowPlayerDialog(playerid, DIALOG_TOGGLEPHONE, DIALOG_STYLE_LIST, "Setting", "Phone On\nPhone Off", "Select", "Back");
	}
	if(clickedid == CLICKCAMERA)
	{
		callcmd::selfie(playerid, "");
	}
	if(clickedid == CLICKMUSIC)
	{
		ShowPlayerDialog(playerid,DIALOG_BOOMBOX1,DIALOG_STYLE_INPUT, "Boombox Input URL", "Please put a Music URL to play the Music", "Play", "Cancel");
	}
	if(clickedid == CLICKTWITTER)
	{
		new notif[20];
		if(pData[playerid][pTogTweet] == 1)
		{
			notif = "{ff0000}OFF";
		}
		else
		{
			notif = "{3BBD44}ON";
		}

		if(pData[playerid][pPhoneStatus] == 0)
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}
		if(pData[playerid][pTwitter] < 1)
		{
			return ErrorMsg(playerid, "Anda belum memiliki Twitter, harap download!");
		}
		ShowPlayerDialog(playerid, PHONE_APP, DIALOG_STYLE_LIST, "Message", "Tweet\nNotification", "Select", "Close");
	}
	if(clickedid == CLICKKOJEK)
	{

	}
	if(clickedid == CLICKEWALLET)
	{

	}
	if(clickedid == CLICKCONTACT)
	{
		if (pData[playerid][pPhoneStatus] == 0)
			return ErrorMsg(playerid, "Your phone must be powered on.");

		if(pData[playerid][pPhoneBook] == 0)
			return ErrorMsg(playerid, "You dont have a phone book.");

		ShowContacts(playerid);
	}
	if(clickedid == CLICKSMS)
	{
		if(pData[playerid][pPhoneStatus] == 0)
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}

		ShowPlayerDialog(playerid, DIALOG_PHONE_SENDSMS, DIALOG_STYLE_INPUT, "Send Text Message", "Please enter the number that you wish to send a text message to:", "Dial", "Back");
	}
	if(clickedid == CLICKCALL)
	{
		if(pData[playerid][pPhoneStatus] == 0)
		{
			return ErrorMsg(playerid, "Handphone anda sedang dimatikan");
		}

		ShowPlayerDialog(playerid, DIALOG_PHONE_DIALUMBER, DIALOG_STYLE_INPUT, "Dial Number", "Please enter the number that you wish to dial below:", "Dial", "Back");
	}
	//SPAWN FIVEM
	if(clickedid == SPAWNFIVEM[5]) // PELABUHAN
	{
		pData[playerid][SPAWNMENU] = 2;
      //  SetPlayerPos(playerid, 1642.21, -2334.82, 13.54);
      /*  SetPlayerCameraPos(playerid, 2576.7468, -2416.2759, 42.2331);
        SetPlayerCameraLookAt(playerid, 2576.7468, -2416.2759, 42.2331);*/
        SelectTextDraw(playerid, 0xFFA500FF);
		InterpolateCameraPos(playerid,2576.7468, -2416.2759, 200.2138, 2576.7468, -2416.2759, 150.2138, 10000, CAMERA_MOVE);
	     InterpolateCameraLookAt(playerid, 2576.7468, -2416.2759,-1.2138, 2576.7468, -2416.2759,-1.2138, 10000, CAMERA_MOVE);
	}
	if(clickedid == SPAWNFIVEM[6]) // BANDARA
	{
		pData[playerid][SPAWNMENU] = 1;

       // SetPlayerPos(playerid, -738.31, -2661.49, 84.62);
     InterpolateCameraPos(playerid,1647.7306, -2286.5720, 200.2138, 1647.7306,-2286.5720, 150.2138, 10000, CAMERA_MOVE);
     InterpolateCameraLookAt(playerid, 1647.7306,-2286.5720,-1.2138, 1647.7306,-2286.5720,-1.2138, 10000, CAMERA_MOVE);
	}
	if(clickedid == SPAWNFIVEM[7]) // LOKASI TERAKHIR
	{
		pData[playerid][SPAWNMENU] = 3;
        SelectTextDraw(playerid, 0xFFA500FF);
	}
	if(clickedid == SPAWNFIVEM[4]) // MENDARAT
	{
		if(pData[playerid][SPAWNMENU] == 0) // GAK MILIH
			return ErrorMsg(playerid, "Kamu belum memilih tempat mendarat");

   		if(pData[playerid][SPAWNMENU] == 1) // BANDARA
   		{
			pData[playerid][SPAWNMENU] = 0;
			SetPlayerInterior(playerid, 0);
			SetPlayerPos(playerid, 1642.21, -2334.82, 13.54);
			SetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 1);
		}
		else if(pData[playerid][SPAWNMENU] == 2) // PELABUHAN
		{
		    pData[playerid][SPAWNMENU] = 0;
		    SetPlayerInterior(playerid, 0);
		    SetPlayerPos(playerid, 2614.83, -2451.50, 13.62);
		    SetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 1);
		}
		else if(pData[playerid][SPAWNMENU] == 3) // LOKASI TERAKHIR
		{
		    pData[playerid][SPAWNMENU] = 0;
		    StopAudioStreamForPlayer(playerid);
			SetPlayerInterior(playerid, pData[playerid][pInt]);
			SetPlayerVirtualWorld(playerid, pData[playerid][pWorld]);
			SetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
			SetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 1);
			SetPlayerSpawn(playerid);
			LoadAnims(playerid);
		}
        //SelectTextDraw(playerid, 0xFFA500FF);
        for(new i = 0; i < 8; i++)
		{
			TextDrawHideForPlayer(playerid, SPAWNFIVEM[i]);
			CancelSelectTextDraw(playerid);
		}
	}
	return 1;
}

stock RefreshVModel(playerid)
{
	PlayerTextDrawSetPreviewModel(playerid, VModelTD[playerid], GetVehicleModel(GetPlayerVehicleID(playerid)));
	PlayerTextDrawShow(playerid, VModelTD[playerid]);
    return 1;
}

stock RefreshPSkin(playerid)
{
	PlayerTextDrawSetPreviewModel(playerid, PSkinStats[playerid], GetPlayerSkin(playerid));
	PlayerTextDrawShow(playerid, PSkinStats[playerid]);
    return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
    if(listid == vtoylist)
	{
		if(response)
		{
		    if(listid == vtoylist)
			{
				if(response)
				{
					new x = GetPlayerVehicleID(playerid);
					foreach(new i: PVehicles)
					if(x == pvData[i][cVeh])
					{
						new vehid = pvData[i][cVeh];
						vtData[vehid][pvData[vehid][vtoySelected]][vtoy_modelid] = modelid;
						if(pvData[vehid][PurchasedvToy] == false)
						{
							MySQL_CreateVehicleToy(i);
						}
						vtData[vehid][pvData[vehid][vtoySelected]][vtoy_model] = CreateDynamicObject(vtData[vehid][pvData[vehid][vtoySelected]][vtoy_modelid], 0.0, 0.0, -14.0, 0.0, 0.0, 0.0);
						AttachDynamicObjectToVehicle(vtData[vehid][pvData[vehid][vtoySelected]][vtoy_model], vehid, vtData[vehid][pvData[vehid][vtoySelected]][vtoy_x], vtData[vehid][pvData[vehid][vtoySelected]][vtoy_y], vtData[vehid][pvData[vehid][vtoySelected]][vtoy_z], vtData[vehid][pvData[vehid][vtoySelected]][vtoy_rx], vtData[vehid][pvData[vehid][vtoySelected]][vtoy_ry], vtData[vehid][pvData[vehid][vtoySelected]][vtoy_rz]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memasang toys untuk vehicleid(%d) object ID %d", ReturnName(playerid), vehid, modelid);
						ShowPlayerDialog(playerid, VTOY_ACCEPT, DIALOG_STYLE_MSGBOX, "Vehicle Toys", "Do You Want To Save it?", "Yes", "Cancel");
					}
				}
	      		else return Servers(playerid, "Canceled buy toys");
			}
		}
	}
	return 1;
}
public OnPlayerSelectionMenuResponse(playerid, extraid, response, listitem, modelid)
{
	switch(extraid)
	{
		case SPAWN_SKIN_MALE:
		{
			if(response)
			{
				pData[playerid][pSkin] = modelid;
				SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1744.3411, -1862.8655, 13.3983, 270.0000, 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
				UpdatePlayerData(playerid);
				RefreshPSkin(playerid);
			}
		}
		case SPAWN_SKIN_FEMALE:
		{
			if(response)
			{
				pData[playerid][pSkin] = modelid;
				SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1744.3411, -1862.8655, 13.3983, 270.0000, 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
				UpdatePlayerData(playerid);
				RefreshPSkin(playerid);
			}
		}
		case SHOP_SKIN_MALE:
	    {
	        if(response)
	        {
				new bizid = pData[playerid][pInBiz], price;
				price = bData[bizid][bP][0];
				pData[playerid][pSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				GivePlayerMoneyEx(playerid, -price);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
				bData[bizid][bProd]--;
				bData[bizid][bMoney] += Server_Percent(price);
				Server_AddPercent(price);
				
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
				mysql_tquery(g_SQL, query);

				Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}
			else 
				return Servers(playerid, "Canceled buy skin");	
		}	
		case SHOP_SKIN_FEMALE:
	    {
			if(response)
			{
				new bizid = pData[playerid][pInBiz], price;
				price = bData[bizid][bP][0];
				pData[playerid][pSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				GivePlayerMoneyEx(playerid, -price);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
				bData[bizid][bProd]--;
				bData[bizid][bMoney] += Server_Percent(price);
				Server_AddPercent(price);
				
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
				mysql_tquery(g_SQL, query);

				Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}
			else 
				return Servers(playerid, "Canceled buy skin");	
		}
		case VIP_SKIN_MALE:
		{
			if(response)
			{
				pData[playerid][pSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengganti skin ID %d.", ReturnName(playerid), modelid);
				Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}
			else 
				return Servers(playerid, "Canceled buy skin");
		}
		case VIP_SKIN_FEMALE:
		{
			if(response)
			{
				pData[playerid][pSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengganti skin ID %d.", ReturnName(playerid), modelid);
				Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}
			else 
				return Servers(playerid, "Canceled buy skin");
		}
		case SAPD_SKIN_MALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SAAG_SKIN_MALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}
		}
		case SAPD_SKIN_FEMALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SAPD_SKIN_WAR:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SAGS_SKIN_MALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SAGS_SKIN_FEMALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SAMD_SKIN_MALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SAMD_SKIN_FEMALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SANA_SKIN_MALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SANA_SKIN_FEMALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case TOYS_MODEL:
		{
			if(response)
			{
				new bizid = pData[playerid][pInBiz], price;
				price = bData[bizid][bP][1];
				
				GivePlayerMoneyEx(playerid, -price);
				if(pData[playerid][PurchasedToy] == false) MySQL_CreatePlayerToy(playerid);
				pToys[playerid][pData[playerid][toySelected]][toy_model] = modelid;
				pToys[playerid][pData[playerid][toySelected]][toy_status] = 1;
				new finstring[750];
				strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
				strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");
				ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""WHITE_E"Select Bone", finstring, "Select", "Cancel");
				
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli object ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
				bData[bizid][bProd]--;
				bData[bizid][bMoney] += Server_Percent(price);
				Server_AddPercent(price);

				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
				mysql_tquery(g_SQL, query);
			}
			else 
				return Servers(playerid, "Canceled buy toys");
		}
		case VIPTOYS_MODEL:
		{
			if(response)
			{
				if(pData[playerid][PurchasedToy] == false) MySQL_CreatePlayerToy(playerid);
				pToys[playerid][pData[playerid][toySelected]][toy_model] = modelid;
				pToys[playerid][pData[playerid][toySelected]][toy_status] = 1;
				new finstring[750];
				strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
				strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");
				ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""WHITE_E"Select Bone", finstring, "Select", "Cancel");
				
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil object ID %d dilocker.", ReturnName(playerid), modelid);
			}
			else
				return Servers(playerid, "Canceled toys");
		}
	}
	return 1;
}	

//fly





#define MAX_CAMP_CARP   (8000)
#define MAX_CAMP_OBJECT (20000)
enum    E_CAMP
{
	campX,
	campY,
	campZ,
	STREAMER_TAG_3D_TEXT_LABEL:campLabel
}
new Campamento[MAX_CAMP_CARP][MAX_CAMP_OBJECT],
Campdata[MAX_CAMP_CARP][E_CAMP],
ContarCampamento;


CMD:destroycamp(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);

	if(sscanf(params, "d", id))
		return Usage(playerid, "/gotoatm [id]");
	//if(!Iter_Contains(ATMS, id)) return ErrorMsg(playerid, "ATM ID tidak ada.");

	if(ContarCampamento<=0)return false;
//	new jumlah = pData[playerid][pCampid];
	for(new index=0; index<MAX_CAMP_OBJECT; index++) DestroyObject(Campamento[id][index]);
	DestroyDynamic3DTextLabel(Campdata[id][campLabel]);
//	ContarCampamento--;
	//pData[playerid][pCampid] = 0;
	return 1;
}


CMD:putcamp(playerid, params[]){
	if(pData[playerid][pCampid] > 0) return ErrorMsg(playerid, "Anda sudah memasang tenda, silahkan /unloadcamp untuk hapus tenda sebelumnya");
	if(pData[playerid][pCamping] < 1) return ErrorMsg(playerid, "Lu gk punya camp fire");
    new Float:pos[4];
    GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
    GetPlayerFacingAngle(playerid,pos[3]);
    pos[0] = pos[0] + (2.0 * floatsin(-pos[3], degrees));
    pos[1] = pos[1] + (2.0 * floatcos(-pos[3], degrees));

    if(ContarCampamento>=MAX_CAMP_CARP)return false;
    ContarCampamento++;
    pData[playerid][pCampid] = ContarCampamento;
    new jumlah = pData[playerid][pCampid];
    new str[128];
   	Campdata[jumlah][campX] = pos[0];
	Campdata[jumlah][campY] = pos[1];
	Campdata[jumlah][campZ] = pos[2];
	pData[playerid][pCamping] -= 1;
    format(str, sizeof(str), "[ID] %d, /unloadcamp", jumlah);
    Campdata[jumlah][campLabel] = CreateDynamic3DTextLabel(str, COLOR_LIGHTGREEN, pos[0], pos[1], pos[2] + 0.3, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 10.0);
    CreateObjectCamp(pos[0],pos[1],pos[2],pos[3]);
    
	return true;
}
CMD:unloadcamp(playerid, params[]){
    DestroyObjectCamp(playerid);
	return true;
}


stock CreateObjectCamp(Float:x,Float:y,Float:z,Float:a){
	
	//otros
	Campamento[ContarCampamento][0]=CreateObject(19300, 309.64999, 1827.71790, 16.63540,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][1]=CreateObject(841, 309.22369, 1831.88953, 16.69970,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][2]=CreateObject(841, 309.22369, 1831.88953, 16.69970,   0.00000, 0.00000, 76.00000);
	Campamento[ContarCampamento][3]=CreateObject(841, 309.22369, 1831.88953, 16.69970,   0.00000, 0.00000, 149.00000);
	Campamento[ContarCampamento][5]=CreateObject(18688, 309.12091, 1831.89697, 15.53580,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][6]=CreateObject(1281, 307.06400, 1825.51147, 17.43860,   0.00000, 0.00000, 90.00000);
	Campamento[ContarCampamento][7]=CreateObject(3119, 306.98322, 1825.67725, 17.72950,   0.00000, 0.00000, -55.00000);
	Campamento[ContarCampamento][8]=CreateObject(1370, 314.04535, 1824.03284, 17.20480,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][9]=CreateObject(1220, 313.99738, 1822.29041, 17.00860,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][10]=CreateObject(1220, 314.13629, 1823.18933, 17.00860,   0.00000, 0.00000, -11.00000);
	Campamento[ContarCampamento][11]=CreateObject(1220, 314.00919, 1827.55420, 17.00860,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][12]=CreateObject(1220, 310.41464, 1827.40930, 17.00860,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][13]=CreateObject(3119, 314.37982, 1830.49329, 16.94750,   0.00000, 0.00000, -156.00000);
	Campamento[ContarCampamento][14]=CreateObject(1220, 314.07486, 1828.73547, 17.00860,   0.00000, 0.00000, 40.00000);
	Campamento[ContarCampamento][15]=CreateObject(349, 312.55099, 1826.56604, 17.19990,   69.00000, -4.00000, 86.00000);
	Campamento[ContarCampamento][16]=CreateObject(347, 313.96811, 1827.36511, 17.34890,   69.00000, 33.00000, 86.00000);
	Campamento[ContarCampamento][17]=CreateObject(347, 314.11807, 1827.25049, 17.34890,   69.00000, 33.00000, 86.00000);
	Campamento[ContarCampamento][18]=CreateObject(1220, 309.07526, 1822.31531, 17.00860,   0.00000, 0.00000, 11.00000);
	Campamento[ContarCampamento][19]=CreateObject(1220, 309.11325, 1823.18738, 17.00860,   0.00000, 0.00000, -2.00000);
	Campamento[ContarCampamento][20]=CreateObject(2226, 307.81601, 1826.09961, 17.11780,   0.00000, 0.00000, 99.00000);
	Campamento[ContarCampamento][21]=CreateObject(1265, 309.27954, 1828.07727, 17.07260,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][22]=CreateObject(2674, 308.82733, 1828.01672, 16.67070,   0.00000, 0.00000, 280.00000);
	Campamento[ContarCampamento][23]=CreateObject(2674, 308.59909, 1822.75769, 16.67070,   0.00000, 0.00000, 280.00000);
	Campamento[ContarCampamento][24]=CreateObject(2675, 314.76166, 1826.96948, 16.71070,   0.00000, 0.00000, 215.00000);
	Campamento[ContarCampamento][25]=CreateObject(2674, 306.85934, 1831.50134, 16.67070,   0.00000, 0.00000, 280.00000);
	Campamento[ContarCampamento][26]=CreateObject(2674, 311.39514, 1832.03796, 16.67070,   0.00000, 0.00000, 280.00000);
	Campamento[ContarCampamento][27]=CreateObject(1544, 307.23172, 1830.62488, 17.20720,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][28]=CreateObject(1544, 311.27390, 1831.59717, 17.20720,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][29]=CreateObject(1544, 311.04810, 1832.66846, 16.64720,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][30]=CreateObject(1544, 311.44269, 1832.80554, 16.64720,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][31]=CreateObject(2114, 307.06149, 1826.76563, 16.75140,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][32]=CreateObject(2114, 306.64496, 1826.91589, 16.75140,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][33]=CreateObject(2805, 307.63596, 1833.62769, 17.18640,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][34]=CreateObject(2804, 309.65308, 1831.65540, 18.46040,   -90.00000, 0.00000, -32.00000);
	Campamento[ContarCampamento][35]=CreateObject(2804, 309.31732, 1831.97778, 18.46040,   -90.00000, 0.00000, -32.00000);
	Campamento[ContarCampamento][36]=CreateObject(2804, 308.98053, 1832.27246, 18.46040,   -90.00000, 0.00000, -32.00000);
	Campamento[ContarCampamento][37]=CreateObject(18632, 306.55414, 1830.47681, 16.74740,   180.00000, 26.00000, 207.00000);
	Campamento[ContarCampamento][38]=CreateObject(18632, 306.60620, 1830.36890, 16.74740,   180.00000, 26.00000, 207.00000);
	Campamento[ContarCampamento][39]=CreateObject(18632, 306.64035, 1830.25195, 16.74740,   180.00000, 26.00000, 207.00000);
	Campamento[ContarCampamento][40]=CreateObject(2864, 306.93115, 1825.70532, 17.45210,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][41]=CreateObject(2863, 306.76468, 1825.27625, 17.45210,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][42]=CreateObject(2852, 310.45197, 1827.41333, 17.35810,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][43]=CreateObject(2844, 312.00867, 1826.49011, 16.65310,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][44]=CreateObject(2843, 310.91702, 1826.76746, 16.65310,   0.00000, 0.00000, -178.00000);
	Campamento[ContarCampamento][45]=CreateObject(323, 310.27969, 1823.99805, 16.94830,   0.00000, 90.00000, 76.00000);
	Campamento[ContarCampamento][46]=CreateObject(321, 310.41483, 1824.22131, 16.94830,   0.00000, 90.00000, 76.00000);
	//bolsos carpa
	Campamento[ContarCampamento][47]=CreateObject(1550, 310.25449, 1826.72754, 17.03370,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][48]=CreateObject(1550, 310.16809, 1826.17139, 16.82970,   0.00000, 90.00000, 265.00000);
	//sillas
	Campamento[ContarCampamento][49]=CreateObject(2121, 310.02151, 1829.67651, 17.15670,   0.00000, 0.00000, 179.00000);
	Campamento[ContarCampamento][50]=CreateObject(2121, 309.18134, 1829.70996, 17.15670,   0.00000, 0.00000, 200.00000);
	Campamento[ContarCampamento][51]=CreateObject(2121, 311.36627, 1831.60779, 17.15670,   0.00000, 0.00000, -112.00000);
	Campamento[ContarCampamento][52]=CreateObject(2121, 311.33826, 1832.58765, 17.15670,   0.00000, 0.00000, -91.00000);
	Campamento[ContarCampamento][53]=CreateObject(2121, 307.19360, 1830.67285, 17.15670,   0.00000, 0.00000, 113.00000);
	Campamento[ContarCampamento][54]=CreateObject(2121, 307.08627, 1831.59216, 17.15670,   0.00000, 0.00000, 76.00000);
	Campamento[ContarCampamento][55]=CreateObject(2121, 312.73245, 1826.76624, 17.15670,   0.00000, 0.00000, -90.00000);
	for(new index=49; index<56; index++) SetObjectMaterial(Campamento[ContarCampamento][index], 0, 1281, "benches", "pierdoor02_law", -1);
	//cuerdas
	Campamento[ContarCampamento][56]=CreateObject(19087, 307.79419, 1833.44189, 18.78920,   0.00000, 90.00000, 135.00000);
	Campamento[ContarCampamento][57]=CreateObject(19087, 308.87219, 1832.36987, 18.78920,   0.00000, 90.00000, 135.00000);
	Campamento[ContarCampamento][58]=CreateObject(19089, 311.72137, 1828.64319, 19.62920,   0.00000, -42.00000, 90.00000);
	Campamento[ContarCampamento][59]=CreateObject(19089, 311.72141, 1822.50464, 19.62920,   0.00000, 42.00000, 90.00000);
	Campamento[ContarCampamento][60]=CreateObject(19089, 311.67493, 1823.13049, 19.86420,   0.00000, -53.00000, 0.00000);
	Campamento[ContarCampamento][61]=CreateObject(19089, 311.67303, 1827.79321, 19.86420,   0.00000, -53.00000, 0.00000);
	Campamento[ContarCampamento][62]=CreateObject(19089, 311.65009, 1827.76843, 19.86420,   0.00000, -53.00000, 180.00000);
	Campamento[ContarCampamento][63]=CreateObject(19089, 311.63867, 1823.11316, 19.86420,   0.00000, -53.00000, 180.00000);
	for(new index=56; index<64; index++) SetObjectMaterial(Campamento[ContarCampamento][index], 0, -1, "none", "none", 0xFF808484);
	//palos fogata
	Campamento[ContarCampamento][64]=CreateObject(1251, 310.61270, 1830.58606, 15.53550,   90.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][65]=CreateObject(1251, 307.87411, 1833.35156, 15.53550,   90.00000, 0.00000, 0.00000);
	for(new index=64; index<67; index++) SetObjectMaterial(Campamento[ContarCampamento][index], 0, 841, "gta_brokentrees", "CJ_bark", -1);
	//camas carpa
	Campamento[ContarCampamento][67]=CreateObject(1646, 310.20544, 1823.86487, 16.78320,   0.00000, 0.00000, 180.00000);
	Campamento[ContarCampamento][68]=CreateObject(1646, 312.31110, 1824.50134, 16.78320,   0.00000, 0.00000, -90.00000);
	Campamento[ContarCampamento][69]=CreateObject(1646, 312.31107, 1825.72351, 16.78320,   0.00000, 0.00000, -90.00000);
	Campamento[ContarCampamento][70]=CreateObject(1646, 314.25800, 1830.57471, 16.78320,   0.00000, 0.00000, -154.00000);
	for(new index=67; index<71; index++) SetObjectMaterial(Campamento[ContarCampamento][index], 25, -1, "none", "none", -1);
	for(new index=67; index<71; index++) SetObjectMaterial(Campamento[ContarCampamento][index], 26, -1, "none", "none", -1);
	//carpa
	Campamento[ContarCampamento][71]=CreateObject(19325, 312.76309, 1825.48145, 18.11690,   0.00000, -32.00000, 0.00000);
	Campamento[ContarCampamento][72]=CreateObject(19325, 310.53009, 1825.48145, 18.11690,   0.00000, 34.00000, 0.00000);
	Campamento[ContarCampamento][73]=CreateObject(19325, 311.59631, 1825.51514, 16.65890,   0.00000, 90.00000, 0.00000);
	for(new index=71; index<74; index++) SetObjectMaterial(Campamento[ContarCampamento][index], 0, 3066, "ammotrx", "ammotrn92tarp128", -1);
	//entrada carpa
	Campamento[ContarCampamento][74]=CreateObject(2068, 310.92621, 1829.37927, 14.26150,   138.00000, 105.00000, 78.00000);
	Campamento[ContarCampamento][75]=CreateObject(2068, 312.47238, 1821.60352, 14.26150,   138.00000, 105.00000, 260.00000);
	Campamento[ContarCampamento][76]=CreateObject(2068, 312.40381, 1828.17834, 14.26150,   138.00000, 105.00000, -99.00000);
	Campamento[ContarCampamento][77]=CreateObject(2068, 311.01590, 1822.85583, 14.26150,   138.00000, 105.00000, 79.00000);
	for(new index=74; index<78; index++) SetObjectMaterial(Campamento[ContarCampamento][index], 0, -1, "none", "none", 0xFF808484);
	//luces carpa
	Campamento[ContarCampamento][78]=CreateObject(2074, 311.69241, 1824.52930, 19.50400,   0.00000, 0.00000, 0.00000);
	Campamento[ContarCampamento][79]=CreateObject(2074, 311.71283, 1826.09229, 19.50400,   0.00000, 0.00000, 0.00000);

	for(new index=1; index<MAX_CAMP_OBJECT; index++){
		new Float:pos[2][6];
		GetObjectPos(Campamento[ContarCampamento][0],pos[0][0],pos[0][1],pos[0][2]);
		GetObjectPos(Campamento[ContarCampamento][index],pos[1][0],pos[1][1],pos[1][2]);
		GetObjectRot(Campamento[ContarCampamento][index],pos[1][3],pos[1][4],pos[1][5]);
		AttachObjectToObject(Campamento[ContarCampamento][index], Campamento[ContarCampamento][0], floatsub(pos[1][0], pos[0][0]),floatsub(pos[1][1], pos[0][1]),floatsub(pos[1][2], pos[0][2]), pos[1][3],pos[1][4],pos[1][5], 1);
	}
	SetObjectPos(Campamento[ContarCampamento][0],x,y,z-0.9);
	SetObjectRot(Campamento[ContarCampamento][0],0.00000, 0.00000, a-180);
	return true;
}
stock DestroyObjectCamp(playerid){
	if(ContarCampamento<=0)return false;
	new jumlah = pData[playerid][pCampid];
	for(new index=0; index<MAX_CAMP_OBJECT; index++) DestroyObject(Campamento[jumlah][index]);
	DestroyDynamic3DTextLabel(Campdata[jumlah][campLabel]);
//	ContarCampamento--;
	pData[playerid][pCampid] = 0;
	return true;
}

//tentara
CMD:turun(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(GetVehicleModel(vehicleid) == 497 && GetPlayerSkin(playerid) == 285 && IsPlayerInAnyVehicle(playerid))
 	{
	   if(pData[playerid][pFaction] != 1) return ErrorMsg(playerid, "Khusus polisi");
		GetPlayerPos(playerid,pl_pos[playerid][0],pl_pos[playerid][1],pl_pos[playerid][2]);
		GetPlayerPos(pl_pos[playerid][0],pl_pos[playerid][1],pl_pos[playerid][3]);
		pl_pos[playerid][4] = floatsub(pl_pos[playerid][2],pl_pos[playerid][3]);
		if(pl_pos[playerid][4] >= 50) return SendClientMessage(playerid,0xAA3333AA,"You are too scared to slide from this height");
		if(pl_pos[playerid][4] <= 2) return RemovePlayerFromVehicle(playerid);
		
		SetPlayerCheckpoint(playerid,pl_pos[playerid][0],pl_pos[playerid][1],floatsub(pl_pos[playerid][3],offsetz),20);
		SetPlayerPos(playerid,pl_pos[playerid][0],pl_pos[playerid][1],floatsub(pl_pos[playerid][2],2));
		SetPlayerVelocity(playerid,0,0,0);
		for(new rep=0;rep!=10;rep++) ApplyAnimation(playerid,"ped","abseil",4.0,0,0,0,1,0);
		for(new cre=0;cre<=pl_pos[playerid][4];cre++)
		{
		    r0pes[playerid][cre] = CreateObject(3004,pl_pos[playerid][0],pl_pos[playerid][1],floatadd(pl_pos[playerid][3],cre),87.640026855469,342.13500976563, 350.07507324219);
		}
		SetTimerEx("syncanim",dur,0,"i",playerid);
	}
}
//anim
FormatAnimSettingsMenu(playerid)
{
	new
	    list[128];

	format(list, 128,
	    "Speed:\t\t%f\n\
		Loop:\t\t%d\n\
		Lock X:\t\t%d\n\
		Lock Y:\t\t%d\n\
		Freeze:\t\t%d\n\
		Time:\t\t%d",
		gAnimSettings[playerid][anm_Speed],
		gAnimSettings[playerid][anm_Loop],
		gAnimSettings[playerid][anm_LockX],
		gAnimSettings[playerid][anm_LockY],
		gAnimSettings[playerid][anm_Freeze],
		gAnimSettings[playerid][anm_Time]);

	ShowPlayerDialog(playerid, D_ANIM_SETTINGS, DIALOG_STYLE_LIST, "Animation Settings", list, "Change", "Exit");
}

//fly
CMD:flymode(playerid, params[])
{
    if(GetPVarType(playerid, "FlyMode")) CancelFlyMode(playerid);
		else FlyMode(playerid);
		return 1;
}



CMD:testinfo(playerid, params[])
{

    ShowNotify(playerid, "Dahlah", 2);
    return 1;
}


//cctv
forward CheckKeyPress(playerid);
public CheckKeyPress(playerid)
{
    new keys, updown, leftright;
    GetPlayerKeys(playerid, keys, updown, leftright);
	if(CurrentCCTV[playerid] > -1 && PlayerMenu[playerid] == -1)
	{
	    if(leftright == KEY_RIGHT)
	  	{
	  	    if(keys == KEY_SPRINT)
			{
	 	    	CCTVDegree[playerid] = (CCTVDegree[playerid] - 2.0);
			}
			else
			{
			    CCTVDegree[playerid] = (CCTVDegree[playerid] - 0.5);
			}
	  	    if(CCTVDegree[playerid] < 0)
	  	    {
	  	        CCTVDegree[playerid] = 359;
			}
	  	    MovePlayerCCTV(playerid);

		}
	    if(leftright == KEY_LEFT)
	    {
	        if(keys == KEY_SPRINT)
			{
	 	    	CCTVDegree[playerid] = (CCTVDegree[playerid] + 2.0);
			}
			else
			{
			    CCTVDegree[playerid] = (CCTVDegree[playerid] + 0.5);
			}
			if(CCTVDegree[playerid] >= 360)
	  	    {
	  	        CCTVDegree[playerid] = 0;
			}
	        MovePlayerCCTV(playerid);

	    }
	    if(updown == KEY_UP)
	    {
	        if(CCTVRadius[playerid] < 25)
	        {
		        if(keys == KEY_SPRINT)
				{
				    CCTVRadius[playerid] =  (CCTVRadius[playerid] + 0.5);
		        	MovePlayerCCTV(playerid);
				}
				else
				{
				    CCTVRadius[playerid] =  (CCTVRadius[playerid] + 0.1);
		        	MovePlayerCCTV(playerid);
				}
			}
		}
		if(updown == KEY_DOWN)
	    {
			if(keys == KEY_SPRINT)
			{
			    if(CCTVRadius[playerid] >= 0.6)
	        	{
				    CCTVRadius[playerid] =  (CCTVRadius[playerid] - 0.5);
			       	MovePlayerCCTV(playerid);
				}
			}
			else
			{
			    if(CCTVRadius[playerid] >= 0.2)
	        	{
				    CCTVRadius[playerid] =  (CCTVRadius[playerid] - 0.1);
			       	MovePlayerCCTV(playerid);
				}
			}
		}
		if(keys == KEY_CROUCH)
		{
		    callcmd::exitcctv(playerid, "");
		}
	}
	MovePlayerCCTV(playerid);
}

stock MovePlayerCCTV(playerid)
{
	CCTVLA[playerid][0] = CCTVLAO[CurrentCCTV[playerid]][0] + (floatmul(CCTVRadius[playerid], floatsin(-CCTVDegree[playerid], degrees)));
	CCTVLA[playerid][1] = CCTVLAO[CurrentCCTV[playerid]][1] + (floatmul(CCTVRadius[playerid], floatcos(-CCTVDegree[playerid], degrees)));
	SetPlayerCameraLookAt(playerid, CCTVLA[playerid][0], CCTVLA[playerid][1], CCTVLA[playerid][2]);
}


stock AddCCTV(name[], Float:X, Float:Y, Float:Z, Float:Angle)
{
	if(TotalCCTVS >= MAX_CCTVS) return 0;
	format(CameraName[TotalCCTVS], 32, "%s", name);
	CCTVCP[TotalCCTVS][0] = X;
	CCTVCP[TotalCCTVS][1] = Y;
	CCTVCP[TotalCCTVS][2] = Z;
	CCTVCP[TotalCCTVS][3] = Angle;
	CCTVLAO[TotalCCTVS][0] = X;
	CCTVLAO[TotalCCTVS][1] = Y;
	CCTVLAO[TotalCCTVS][2] = Z-10;
	TotalCCTVS++;
	return TotalCCTVS-1;
}

SetPlayerToCCTVCamera(playerid, CCTV)
{
	if(CCTV >= TotalCCTVS)
	{
	    SendClientMessage(playerid, 0xFF0000AA, "Invald CCTV");
	    return 1;
	}
	if(CurrentCCTV[playerid] == -1)
    {
	    GetPlayerPos(playerid, LastPos[playerid][LX], LastPos[playerid][LY], LastPos[playerid][LZ]);
		GetPlayerFacingAngle(playerid, LastPos[playerid][LA]);
        LastPos[playerid][LInterior] = GetPlayerInterior(playerid);
	}
	else
	{
		KillTimer(KeyTimer[playerid]);
	}
	CurrentCCTV[playerid] = CCTV;
    TogglePlayerControllable(playerid, 0);
	//SetPlayerPos(playerid, CCTVCP[CCTV][0], CCTVCP[CCTV][1], (CCTVCP[CCTV][2]-50));
	SetPlayerPos(playerid, CCTVCP[CCTV][0], CCTVCP[CCTV][1], -100.0);
	SetPlayerCameraPos(playerid, CCTVCP[CCTV][0], CCTVCP[CCTV][1], CCTVCP[CCTV][2]);
	SetPlayerCameraLookAt(playerid, CCTVLAO[CCTV][0], (CCTVLAO[CCTV][1]+0.2), CCTVLAO[CCTV][2]);
	CCTVLA[playerid][0] = CCTVLAO[CCTV][0];
	CCTVLA[playerid][1] = CCTVLAO[CCTV][1]+0.2;
	CCTVLA[playerid][2] = CCTVLAO[CCTV][2];
	CCTVRadius[playerid] = 12.5;
	CCTVDegree[playerid] = CCTVCP[CCTV][3];
	MovePlayerCCTV(playerid);
    KeyTimer[playerid] = SetTimerEx("CheckKeyPress", 75, 1, "i", playerid);
    TextDrawShowForPlayer(playerid, TD);
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	new Menu:Current = GetPlayerMenu(playerid);
	for(new menu; menu<TotalMenus; menu++)
	{

		if(Current == CCTVMenu[menu])
		{
		    if(MenuType[PlayerMenu[playerid]] == 1)
		    {
		        if(row == 11)
		        {
		            ShowMenuForPlayer(CCTVMenu[menu+1], playerid);
		            TogglePlayerControllable(playerid, 0);
		            PlayerMenu[playerid] = (menu+1);
				}
				else
				{
				    if(PlayerMenu[playerid] == 0)
				    {
				    	SetPlayerToCCTVCamera(playerid, row);
				    	PlayerMenu[playerid] = -1;
					}
					else
					{
					    SetPlayerToCCTVCamera(playerid, ((PlayerMenu[playerid]*11)+row));
					    PlayerMenu[playerid] = -1;
					}
				}
			}
			else
			{
			    if(PlayerMenu[playerid] == 0)
			    {
			    	SetPlayerToCCTVCamera(playerid, row);
			    	PlayerMenu[playerid] = -1;
				}
				else
				{
				    SetPlayerToCCTVCamera(playerid, ((PlayerMenu[playerid]*11)+row));
				    PlayerMenu[playerid] = -1;
				}
			}
		}
	}

	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	TogglePlayerControllable(playerid, 1);
	PlayerMenu[playerid] = -1;
	return 1;
}

CMD:cctv(playerid ,params[])
{
    if(Spawned[playerid] == 1)
		{
		    PlayerMenu[playerid] = 0;
		    TogglePlayerControllable(playerid, 0);
			ShowMenuForPlayer(CCTVMenu[0], playerid);
		}
		else
		{
		    SendClientMessage(playerid, 0xFF0000AA, "Please spawn first!");
		}
}

CMD:berangkat(playerid, params[])
{
	PutPlayerInVehicle(playerid, pesawat[0], 4);
}
CMD:exitcctv(playerid, params[])
{
    if(CurrentCCTV[playerid] > -1)
	    {
		    SetPlayerPos(playerid, LastPos[playerid][LX], LastPos[playerid][LY], LastPos[playerid][LZ]);
			SetPlayerFacingAngle(playerid, LastPos[playerid][LA]);
	        SetPlayerInterior(playerid, LastPos[playerid][LInterior]);
		    TogglePlayerControllable(playerid, 1);
		    KillTimer(KeyTimer[playerid]);
		    SetCameraBehindPlayer(playerid);
		    TextDrawHideForPlayer(playerid, TD);
            CurrentCCTV[playerid] = -1;
            return 1;
		}
}

stock Jembut(playerid, string[], time)//Time in Sec.
{
	new validtime = time*1000;

	if (pData[playerid][Rudal])
	{
	    TextDrawHideForPlayer(playerid, Tutorbus[playerid]);
	    KillTimer(pData[playerid][Blackhole]);
	}
	TextDrawSetString(Tutorbus[2], string);
	TextDrawShowForPlayer(playerid, Tutorbus[2]);
	TextDrawShowForPlayer(playerid, Tutorbus[1]);
	TextDrawShowForPlayer(playerid, Tutorbus[0]);

	pData[playerid][Rudal] = true;
	pData[playerid][Blackhole] = SetTimerEx("HideMessageAje", validtime, false, "d", playerid);
	return 1;
}
function HideMessageAje(playerid)
{

	if (!pData[playerid][Rudal])
	    return 0;

	pData[playerid][Rudal] = false;
	return HideSemua(playerid);
}

stock HideSemua(playerid)
{
      TextDrawShowForPlayer(playerid, Tutorbus[2]);
      TextDrawShowForPlayer(playerid, Tutorbus[1]);
      TextDrawShowForPlayer(playerid, Tutorbus[0]);
      return 1;
}

CMD:testing(playerid, params[])
	{
		new string[1000];
	    format(string, sizeof(string), "Job\t\tSedang Bekerja\n{ffffff}Sopirbus\t\t{FFFF00}%d Orang",
		Sopirbus
	    );
	    	ShowPlayerDialog(playerid, DIALOG_DISNAKER, DIALOG_STYLE_TABLIST_HEADERS, "{FFB6C1}Hoffentlich {ffffff}- DISNAKER", string, "Buy", "Cancel");
			return 1;
	}
CMD:testbus(playerid, params[])
{
    Jembut(playerid, "Test", 10);
}

CMD:destroybus(playerid, params[])
{
	new otherid;
	if(pData[playerid][pAdmin] < 1) return ErrorMsg(playerid, "You No admins");
    if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/destroybus <ID/Name>");
	    return true;
	}
	DestroyVehicle(Bus[otherid]);
}
CMD:savepos(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1) return 1;
	if(!strlen(params))
		return SyntaxMsg(playerid, "Gunakan: /savepos [judul]");

    extract params -> new string:message[1000]; else return SyntaxMsg(playerid, "Gunakan: /savepos [judul]");

   	GetPlayerVehicleID(playerid);
	new msg[500];
    new
		Float:x,
		Float:y,
		Float:z,
		Float:r;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, r);
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, r);
	format(msg, sizeof(msg), "\nJudul : %s\nCreateDynamicPickup(1210, 23, %f, %f, %f, -1, -1, -1, 50);\nSetPlayerRaceCheckpoint(playerid, 1, %f, %f, %f, 0, 0, 0, 5.0);",message, x, y, z, x, y, z);
/*	DCC_SendChannelMessage(g_discord_savepos, msg);*/
    new File:fhandle;
    fhandle = fopen("coordinates.txt",io_append);
    fwrite(fhandle, msg);
    fclose(fhandle);
	SuccesMsg(playerid, "Coordinat Posisi Kamu Berhasil Di Save!");

    return 1;
}

CMD:setrobwarung(playerid, params[])
{
    Warung = false;
    return 1;
}

CMD:testlockpick(playerid)
{
	if(pData[playerid][pAdmin] < 10) return ErrorMsg(playerid, "Error");
	
	Inventory_Add(playerid, "Lockpick", 11746, 10);
}

CMD:testregen(playerid, params[])
{
	if(pData[playerid][pAdmin] < 10) return ErrorMsg(playerid, "Not admin high");
	
	pData[playerid][pRegen] = 100;
}

CMD:testgender(playerid, params[])
{
	if(pData[playerid][pAdmin] < 10) return ErrorMsg(playerid, "Not admin high");

	new gender, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, gender))
	{
	    Usage(playerid, "/testgender <ID/Name> <male - female>");
	    return true;
	}

	if(gender < 1 || gender > 2) return ErrorMsg(playerid, "Error");

	pData[otherid][pGender] = gender;
}
//pool
CMD:teleport(playerid)
{
    SetPlayerPos(playerid,2499.3174,-1683.8401,13.4014);
}

CMD:start(playerid, params[])
{
    if(Game[Waiting] == false && Game[Running] == false)
		{
			Game[Waiting] = true;
			Game[Player1] = playerid;
			Game[LastBall] = -1;
			Player[playerid][Points] = 7;

			TextDrawSetString(Player[playerid][T1],"na przeciwnika...");
	    	TextDrawShowForPlayer(playerid,Player[playerid][T1]);

	   		TextDrawSetString(Player[playerid][T2],"Oczekiwanie");
	    	TextDrawShowForPlayer(playerid,Player[playerid][T2]);

	    	new name[24];
	    	new str[100];
			name = GetName(playerid);
			format(str,sizeof(str),"%s oczekuje na przeciwnika. Wpisz /dolacz, aby rywalizowac z gospodarzem.",name);
	    	for(new i = 0; i < 20; i++)
	    	{
	    	    if(IsPlayerConnected(i) == 1 && playerid != i)
				{
	    	        TextDrawSetString(Player[i][T1],str);
					TextDrawShowForPlayer(i,Player[i][T1]);

					TextDrawSetString(Player[i][T2],"Bilard");
	    			TextDrawShowForPlayer(i,Player[i][T2]);
	    	    }
	    	    Player[i][BBall] = NO_BALL;
	    	}

		    Ball[0][ObjID] = CreateObject(3100, 2497.0749511719, -1670.9591064453, 13.199293525696, 0, 0, 0); //CALA
			Ball[1][ObjID] = CreateObject(3101, 2497.0034179688, -1671.01171875, 13.199293525696, 0, 0, 0); //CALA
			Ball[2][ObjID] = CreateObject(3102, 2497.0034179688, -1671.1900634766, 13.199293525696, 0, 0, 0); //CALA
			Ball[3][ObjID] = CreateObject(3103, 2496.8696289063, -1671.1865234375, 13.199293525696, 0, 0, 0); //CALA
			Ball[4][ObjID] = CreateObject(3104, 2496.9370117188, -1671.0673828125, 13.199293525696, 0, 0, 0); //CALA
			Ball[5][ObjID] = CreateObject(3105, 2497.072265625, -1671.2313232422, 13.199293525696, 0, 0, 0); //CALA
			Ball[6][ObjID] = CreateObject(3002, 2496.8068847656, -1671.1413574219, 13.199293525696, 0, 0, 0); //CALA

			Ball[7][ObjID] = CreateObject(2995, 2496.8703613281, -1671.0987548828, 13.199293525696, 0, 0, 0); //POLOWKA
			Ball[8][ObjID] = CreateObject(2996, 2497.0031738281, -1671.2750244141, 13.199293525696, 0, 0, 0); //POLOWKA
			Ball[9][ObjID] = CreateObject(2997, 2497.0705566406, -1671.3179931641, 13.199293525696, 0, 0, 0); //POLOWKA
			Ball[10][ObjID] = CreateObject(2998, 2497.0759277344, -1671.0457763672, 13.199293525696, 0, 0, 0); //POLOWKA
			Ball[11][ObjID] = CreateObject(2999, 2497.0063476563, -1671.1011962891, 13.199293525696, 0, 0, 0); //POLOWKA
			Ball[12][ObjID] = CreateObject(3000, 2497.0734863281, -1671.1456298828, 13.199293525696, 0, 0, 0); //POLOWKA
			Ball[13][ObjID] = CreateObject(3001, 2496.9333496094, -1671.2292480469, 13.199293525696, 0, 0, 0); //POLOWKA

			Ball[WHITE][ObjID] = CreateObject(3003, 2495.8618164063, -1671.1704101563, 13.209293525696, 0, 0, 0); //Biala
			Ball[BLACK][ObjID] = CreateObject(3106, 2496.9375, -1671.1451416016, 13.199293525696, 0, 0, 0); //Czarna
			Ball[TABLE][ObjID] = CreateObject(2964, 2496.4970703125, -1671.1528320313, 12.265947036743, 0, 0, 0); //Stol

			CreatePolygon(2495.6413,-1670.6297, 2496.4323,-1670.6297);
			CreatePolygon(2496.5825,-1670.6398, 2497.3632,-1670.6297);
			CreatePolygon(2497.4433,-1670.7299, 2497.4633,-1671.5506);
			CreatePolygon(2497.3732,-1671.6607, 2496.5725,-1671.6607);
			CreatePolygon(2496.4323,-1671.6607, 2495.6315,-1671.6607);
			CreatePolygon(2495.5415,-1671.5606, 2495.5415,-1670.7099);
		}
		return 1;
}

CMD:stoppool(playerid, params[])
{
    if(Game[Waiting] == true || Game[Running] == true)
	    {
			KillTimer(Game[Timer]);
			KillTimer(Game[Timer2]);
			for(new i = 0; i < 17; i++)
			{
	    		DestroyObject(Ball[i][ObjID]);
 	    	}

 	    	if(Game[Waiting] == true)
 	    	    Game[Waiting] = false;

 	    	if(Game[Running] == true)
 	    	    Game[Running] = false;

			Game[WhiteInHole] = false;
			Game[BlackInHole] = false;

 	    	Player[Game[Player1]][Sighting] = false;
 	    	TextDrawHideForPlayer(Game[Player1],Player[Game[Player1]][T1]);
 	    	TextDrawHideForPlayer(Game[Player1],Player[Game[Player1]][T2]);
 	    	TextDrawHideForPlayer(Game[Player1],Player[Game[Player1]][T3]);
 	    	TextDrawHideForPlayer(Game[Player1],Player[Game[Player1]][T4]);
 	    	TextDrawHideForPlayer(Game[Player1],Player[Game[Player1]][T5]);
 	    	TextDrawHideForPlayer(Game[Player1],Player[Game[Player1]][T6]);

 	    	Player[Game[Player2]][Sighting] = false;
 	    	TextDrawHideForPlayer(Game[Player2],Player[Game[Player2]][T1]);
 	    	TextDrawHideForPlayer(Game[Player2],Player[Game[Player2]][T2]);
 	    	TextDrawHideForPlayer(Game[Player2],Player[Game[Player2]][T3]);
 	    	TextDrawHideForPlayer(Game[Player2],Player[Game[Player2]][T4]);
 	    	TextDrawHideForPlayer(Game[Player2],Player[Game[Player2]][T5]);
 	    	TextDrawHideForPlayer(Game[Player2],Player[Game[Player2]][T6]);
	    }
	    return 1;
}

CMD:dolacz(playerid, params[])
{
    if(Game[Waiting] == true)
	    {
	        if(Game[Player1] != playerid)
	        {
	        	Game[Waiting] = false;
	        	Game[Running] = true;
	        	Game[Player2] = playerid;
	        	TextDrawHideForPlayer(playerid,Player[Game[Player1]][T1]);
	        	TextDrawHideForPlayer(playerid,Player[Game[Player1]][T2]);

	    		new str[50];
	    		new name[24];

	    		new rand = random(2);
				if(rand == 0)
				{
				    name = GetName(Game[Player1]);
				    Player[Game[Player1]][Turn] = true;
				    Player[Game[Player2]][Turn] = false;
				}
				else if(rand == 1)
				{
				    name = GetName(Game[Player2]);
				    Player[Game[Player1]][Turn] = false;
				    Player[Game[Player2]][Turn] = true;
    			}

    			for(new i = 0; i < 20; i++)
	    		{
	    		    if(IsPlayerConnected(i) == 1 && Game[Player1] != i && Game[Player2] != i)
					{
					    //Info(i,"Bilard","Nie zdazyles zapisac sie do rozgrywki. Mozesz zaczekac do nastepnej rundy.");
					}
	 			}

				Player[playerid][Points] = 7;
	

				new string[80];
				format(string,sizeof(string),"%s %d~n~%s %d",GetName(Game[Player1]),Player[Game[Player1]][Points],GetName(Game[Player2]),Player[Game[Player2]][Points]);
	    		TextDrawSetString(Player[Game[Player1]][T3],string);
	    		TextDrawSetString(Player[Game[Player1]][T4],"Bilard");
	    		TextDrawSetString(Player[Game[Player2]][T3],string);
	    		TextDrawSetString(Player[Game[Player2]][T4],"Bilard");

	    		TextDrawShowForPlayer(Game[Player1],Player[Game[Player1]][T3]);
	    		TextDrawShowForPlayer(Game[Player1],Player[Game[Player1]][T4]);

	    		TextDrawShowForPlayer(Game[Player2],Player[Game[Player2]][T3]);
	    		TextDrawShowForPlayer(Game[Player2],Player[Game[Player2]][T4]);

	        	for(new i = 0; i < 16; i++)
	        	{
					Ball[i][TouchID] = -1;
	        	}
	        }
	    }
	    return 1;
}

forward Buatkain(playerid);
public Buatkain(playerid)
{
	new str[128];
	if(Dapatkain[playerid] != 1 && Mulaikain[playerid] == 1)
	{
	    if(Inventory_Count(playerid, "Wool") > 0)
	    {
	    	PlayerTextDrawSetPreviewModel(playerid, NotifItems[playerid][6], 2384);
			format(str, sizeof(str), "Add");
			PlayerTextDrawSetString(playerid, NotifItems[playerid][4], str);
			format(str, sizeof(str), "Kain");
			PlayerTextDrawSetString(playerid, NotifItems[playerid][3], str);
			for(new i = 0; i < 7; i++)
			{
				PlayerTextDrawShow(playerid, NotifItems[playerid][i]);
			}
			format(str, sizeof(str), "2");
			PlayerTextDrawSetString(playerid, NotifItems[playerid][5], str);
			SetTimerEx("notifitems", 3000, false, "i", playerid);
			Inventory_Remove(playerid, "Wool", 1);
			Inventory_Add(playerid, "Kain", 2384, 2);
		}
	}
	if(Dapatkain[playerid] == 1)
	{
	    if(Inventory_Count(playerid, "Wool") > 0)
	    {
	    	PlayerTextDrawSetPreviewModel(playerid, NotifItems[playerid][6], 2384);
			format(str, sizeof(str), "Add");
			PlayerTextDrawSetString(playerid, NotifItems[playerid][4], str);
			format(str, sizeof(str), "Kain");
			PlayerTextDrawSetString(playerid, NotifItems[playerid][3], str);
			for(new i = 0; i < 7; i++)
			{
				PlayerTextDrawShow(playerid, NotifItems[playerid][i]);
			}
			format(str, sizeof(str), "2");
			PlayerTextDrawSetString(playerid, NotifItems[playerid][5], str);
			SetTimerEx("notifitems", 3000, false, "i", playerid);
			Inventory_Remove(playerid, "Wool", 1);
			Inventory_Add(playerid, "Kain", 2384, 2);
		}
	}
	if(Inventory_Count(playerid, "Wool") < 1)
 	{
 	    KillTimer(pData[playerid][pProseskain]);
 	    Dapatkain[playerid] = 0;
	}
	if(Dapatkain[playerid] != 1 && Mulaikain[playerid] != 1)
	{
	    KillTimer(pData[playerid][pProseskain]);
	}
}

forward Prosezkain(playerid);
public Prosezkain(playerid)
{

}

CMD:testwool(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5) return ErrorMsg(playerid, "Y");
	
 	Inventory_Add(playerid, "Wool", 11747, 40);
}

CMD:senjatacolt(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5) return ErrorMsg(playerid, "Y");

 	Inventory_Add(playerid, "Colt45", 346, 1, 100);
}

CMD:kurangdura(playerid, params[])
{
    InventoryData[playerid][Inventory_GetItemID(playerid, "Colt45")][invJangka] -= 10.0;
}

CMD:testlevel(playerid, params[])
{
    new scoremath = ((pData[playerid][pLevel])*8);
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

CMD:testbox(playerid, params[])
{
    ShowBoxTd(playerid, "Removed_1x", "Colt45", 346, 1);
}

CMD:testbox1(playerid, params[])
{
    ShowBoxTd(playerid, "Equiped", "Colt45", 346, 1);
}
function OnPlayerUseItem(playerid, name[])
{
    if(!strcmp(name,"Obat",true))
	{
        new Float:darah;
		GetPlayerHealth(playerid, darah);
		Inventory_Remove(playerid, "Obat", 1);
		SetPlayerHealthEx(playerid, darah+20);
		pData[playerid][pSick] = 0;
		pData[playerid][pSickTime] = 0;
		SetPlayerDrunkLevel(playerid, 0);
		ShowBoxTd(playerid, "Remove_1x", "Obat", 11736, 1);
		/*new str[128];
		PlayerTextDrawSetPreviewModel(playerid, NotifItems[playerid][6], 11736);
			format(str, sizeof(str), "Remove");
			PlayerTextDrawSetString(playerid, NotifItems[playerid][4], str);
			format(str, sizeof(str), "Obat");
			PlayerTextDrawSetString(playerid, NotifItems[playerid][3], str);
			for(new i = 0; i < 7; i++)
			{
				PlayerTextDrawShow(playerid, NotifItems[playerid][i]);
			}
			format(str, sizeof(str), "1x");
			PlayerTextDrawSetString(playerid, NotifItems[playerid][5], str);
			SetTimerEx("notifitems", 3000, false, "i", playerid);*/
	}
}
CMD:testgov(playerid, params[])
{
    foreach(new pid : Player)
			{
			    ClearChat(pid);

				ShowChatTd(pid, pData[playerid][pName], "Ytta", 3, 3, 1);
			}

}

CMD:testduduk(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    PutPlayerInVehicle(playerid, vehicleid, 0);
}

CMD:cekkoma(playerid, params[])
{
 SendClientMessageEx(playerid, -1, "%d menit lagi kamu akan sembuh", pData[playerid][pRegen]);
}

CMD:cp(playerid, params[])
{
    PlayerTextDrawHide(playerid, Panelcar[playerid][0]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][1]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][2]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][3]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][4]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][5]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][6]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][7]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][8]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][9]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][10]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][11]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][12]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][13]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][14]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][15]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][16]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][17]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][18]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][19]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][20]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][21]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][22]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][23]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][24]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][25]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][26]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][27]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][28]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][29]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][30]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][31]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][32]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][33]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][34]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][35]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][36]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][37]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][38]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][39]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][40]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][41]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][42]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][43]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][44]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][45]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][46]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][47]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][48]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][49]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][50]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][51]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][52]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][53]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][54]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][55]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][56]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][57]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][58]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][59]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][60]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][61]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][62]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][63]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][64]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][65]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][66]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][67]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][68]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][69]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][70]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][71]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][72]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][73]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][74]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][75]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][76]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][77]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][78]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][79]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][80]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][81]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][82]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][83]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][84]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][85]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][86]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][87]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][88]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][89]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][90]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][91]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][92]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][93]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][94]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][95]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][96]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][97]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][98]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][99]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][100]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][101]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][102]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][103]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][104]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][105]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][106]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][107]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][108]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][109]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][110]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][111]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][112]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][113]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][114]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][115]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][116]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][117]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][118]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][119]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][120]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][121]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][122]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][123]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][124]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][125]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][126]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][127]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][128]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][129]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][130]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][131]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][132]);
		PlayerTextDrawHide(playerid, Panelcar[playerid][133]);
		PlayerTextDrawHide(playerid, klik_kapmesin[playerid]);
		PlayerTextDrawHide(playerid, klik_bagasi[playerid]);
		PlayerTextDrawHide(playerid, klik_gatau[playerid]);
		PlayerTextDrawHide(playerid, klik_lampu[playerid]);
		PlayerTextDrawHide(playerid, klik_kacadepankiri[playerid]);
		PlayerTextDrawHide(playerid, klik_pintudepankiri[playerid]);
		PlayerTextDrawHide(playerid, klik_tempatduduk1[playerid]);
		PlayerTextDrawHide(playerid, klik_tempatduduk2[playerid]);
		PlayerTextDrawHide(playerid, klik_pintudepankanan[playerid]);
		PlayerTextDrawHide(playerid, klik_kacadepankanan[playerid]);
		PlayerTextDrawHide(playerid, klik_kacabelakangkiri[playerid]);
		PlayerTextDrawHide(playerid, klik_pintubelakangkiri[playerid]);
		PlayerTextDrawHide(playerid, klik_tempatduduk3[playerid]);
		PlayerTextDrawHide(playerid, klik_tempatduduk4[playerid]);
		PlayerTextDrawHide(playerid, klik_pintubelakngkanan[playerid]);
		PlayerTextDrawHide(playerid, klik_kacabelakangkanan[playerid]);
		PlayerTextDrawHide(playerid, klik_startengine[playerid]);
		CancelSelectTextDraw(playerid);
}

forward Repairkit(playerid);
public Repairkit(playerid)
{
    new old = GetVehicleFuel(pData[playerid][pIdrepair]);
    SetValidVehicleHealth(pData[playerid][pIdrepair], 10000);
        SetVehicleFuel(pData[playerid][pIdrepair], old+100);
		ValidRepairVehicle(pData[playerid][pIdrepair]);
        SuccesMsg(playerid, "Vehicle Fixed!");
	pData[playerid][pIdrepair] = -1;
	pData[playerid][pSedangrepair] = 0;
}

CMD:testkerja(playerid, params[])
{
    ApplyAnimation(playerid,"GRAVEYARD","mrnM_loop",4.0, 1, 0, 0, 0, 0, 1);
    SetPlayerAttachedObject(playerid, 9, 2894, 5, 0.100, -0.100, 0.000, 0.000, 230.000, 0.000, 0.400, 0.699, 0.100);
}
