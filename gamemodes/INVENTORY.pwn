/*
    Script Inventory.

    Module name: inventory.pwn
    Made by: Keizi.
    Date: 1/2/23 - 19:20 WIB

   Cara penggunaan:
   1) Inventory_Count(playerid, item[]) Digunakan untuk deteksi jumlah item
   2) Inventory_HasItem(playerid, item[]) Digunakan Untuk deteksi player memiliki item tersebut atau tidak
   3) Inventory_Set(playerid, item[], model, amount) Digunakan untuk menambah atau mengurangi item (tidak rekomen jika tidak mengerti)
   4) Inventory_SetQuantity(playerid, item[], quantity) Digunakan untuk set jumlah item (ini set langsung bukan nambah bukan ngurang)
   5) Inventory_Add(playerid, item[], model, quantity = 1, weapon = 0, ammo = 0) Digunakan untuk menambah item baru ataupun jumlah item yg sudah ada
   6) Inventory_Remove(playerid, item[], quantity = 1) Digunakan untuk mengurangi jumlah item
   
   Contoh:
   1) if(Inventory_Count(playerid, "Batu")) atau if(Inventory_Count(playerid, "Batu") > 1)
   2) Inventory_HasItem(playerid, "Batu")
   3) ada di cmd setitem
   4) ada di cmd setquantity
   5) Inventory_Add(playerid, "Batu", 3930, 1);
   6) Inventory_Remove(playerid, "Batu", 1);
*/
//Keizi

new Text:InvenTD[8];
new Text:ClickAmmount;
new Text:ClickUse;
new Text:ClickGive;
new Text:ClickDrop;
new Text:ClickClose;
new PlayerText:Ammount[MAX_PLAYERS];
new PlayerText:InvModel[MAX_PLAYERS][20];
new PlayerText:InvBox[MAX_PLAYERS][20];
new PlayerText:InvName[MAX_PLAYERS][20];
new PlayerText:InvValue[MAX_PLAYERS][20];
new PlayerText:BarWeight[MAX_PLAYERS];
new PlayerText:InvWeight[MAX_PLAYERS];
//3017 Schematic
#define MAX_DROPPED_ITEMS 5000
#define MAX_INVENTORY 20
#define MAX_LISTED_ITEMS 10



//Inventory
enum inventoryData {
	bool:invExists,
	invID,
	invItem[32],
	invModelColor,
	invModel,
	invQuantity,
	invSenjata,
	invJangka,
	invWeapon,
	invAmmo,
	invSlot
};
new InventoryData[MAX_PLAYERS][MAX_INVENTORY][inventoryData];
new bool:InventoryOpen[MAX_PLAYERS], SelectInventory[MAX_PLAYERS], AmmountInventory[MAX_PLAYERS], Playergive[MAX_PLAYERS];
new NearestItems[MAX_PLAYERS][MAX_LISTED_ITEMS];
enum e_InventoryItems {
    e_InventoryItem[32],
    e_InventoryModel,
    Float: e_InventoryWeight,
    e_InventoryMax,
    bool:e_InventoryDrop
};

new const g_aInventoryItems[][e_InventoryItems] = {
    {"Marijuana", 1578, 1.000, 10, true},
    {"Ecstasy", 1578, 1.000, 10, true},
    {"LSD", 1578, 1.000, 10, true},
    {"Cocaine", 1575, 1.000, 10, true},
    {"Heroin", 1577, 1.000, 10, true},
    {"Steroids", 1241, 1.000, 10, true},
    {"Marijuana Seeds", 1578, 0.500, 250, false},
    {"Kanabis", 19473, 0.100, 100, true},
    {"Borax", 19473, 0.100, 100, true},
    {"Paket_Borax", 1578, 0.300, 100, true},
    {"Cocaine Seeds", 1575, 0.500, 250, false},
	//MAKANAN MINUMAN
    {"Burger", 2703, 0.130, 5, true},
	{"Sprunk", 1546, 0.500, 5, true},
    {"Ayam", 2804, 0.300, 5, true},
    {"Nasi", 2663, 0.300, 5, true},
    {"Mineral", 19835, 0.100, 5, true},
    {"Cellphone", 330, 0.350, 1, false},
    {"Batu", 3930, 10.000, 10, true},
    {"Ruby", 19177, 0.500, 10, true},
    {"Diamond", 19177, 0.500, 10, true},
    {"Emerald", 19177, 0.500, 10, true},
    {"Emas", 19177, 0.500, 10, true},
    {"Milk", 19569, 0.500, 5, true},
    {"Botol", 19570, 0.250, 100, true},
    {"GPS_System", 18875, 0.400, 1, false},
    {"Spray_Can", 365, 0.235, 3, false},
    {"Fuel_Can", 1650, 1.000, 3, true},
    {"Crowbar", 18634, 5.500, 1, true},
    {"Mask", 19036, 0.100, 1, false},
    {"First_Aid", 1580, 2.000, 3, true},
    {"Frozen_Pizza", 2814, 0.300, 5, true},
    {"Frozen_Burger", 2768, 0.130, 5, true},
    {"Armored_Vest", 19142, 3.644, 1, false},
    {"Chicken", 2663, 0.200, 5, true},
    {"Radio", 18868, 0.300, 1, false},
    {"Component", 18633, 0.100, 2000, false},
    {"Fish_Rod", 18632, 0.500, 1, true},
    {"Bait", 18852, 0.100, 100, false},
    {"Snack", 2856, 0.150, 5, true},
    {"Boombox", 2102, 0.300, 5, true},
    {"Karung", 2060, 0.300, 5, true},
    {"Camping", 19632, 0.150, 5, true},
    {"Bandage", 11747, 0.150, 50, true},
    {"Glock_17", 348, 0.150, 5, true},
    {"9mm", 2061, 0.050, 500, true},
    {"39mm", 2061, 0.050, 500, true},
    {"19mm", 2061, 0.050, 500, true},
    {"Buckshot", 2061, 0.050, 500, true},
    {"Silenced_Pistol", 347, 0.150, 5, true},
    {"Colt45", 346, 0.150, 5, true},
    {"Shotgun", 349, 0.150, 5, true},
    {"Ak47", 355, 0.150, 5, true},
    {"Mp5", 353, 0.150, 5, true},
    {"Desert_Eagle", 348, 0.150, 5, true},
    {"44_Magnum", 2061, 0.050, 500, true},
    {"Wool", 11747, 0.150, 5, true},
    {"Kain", 2384, 0.400, 5, true},
    {"Lockpick", 11746, 0.150, 5, true},
    {"Red_Money", 1212, 0.100, 5, true},
    {"Medkit", 11736, 0.150, 5, true},
    {"Medicine", 11736, 0.150, 5, true},
    {"Obat", 11736, 0.150, 5, true},
    {"Garam", 19177, 0.100, 100, true},
    {"Apel", 19575, 0.250, 100, true},
    {"Kunci_Gubuk", 11746, 0.050, 1, true},
    {"Materials", 11746, 0.100, 50000, false},
    {"Water", 1484, 0.500, 5, true},
    {"Laptop", 19893, 1.350, 1, true},
    {"Stamps", 2059, 0.100, 50000, false},
    {"Campfire", 19632, 1.000, 1, true},
    {"Cow_Meat", 2804, 1.000, 15, true},
    {"Deer_Meat", 2804, 1.000, 15, true},
    {"MP3_Player", 18875, 0.100, 1, false},
    {"Bobby_Pin", 11746, 0.100, 20, false},
    {"Cigarettes", 19896, 0.200,  20, false},
    {"Kevlar_Vest", 373, 3.644, 10, false},
    {"Wheat_Plant", 743, 1.000, 30, false},
    {"AK47", 355, 5.00, 1, true},
    {"M4", 356, 4.00, 1, true},
    //{"Desert_Eagle", 348, 1.36, 1, true},
    {"Shotgun", 349, 2.850, 1, true},
    {"MP5", 353, 2.540, 1, true},
    {"Knife", 335, 0.150, 1, true},
    {"AR_Ammo", 19995, 1.000, 50, false}
};

//function
/*function OnPlayerGiveInvItem(p1, p2, itemid, name[], value)
{
    if(strcmp(name,"bandage",true) == 0)
		{
			if(pData[playerid][pBandage] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");

			pData[playerid][pBandage] -= ammount;
			Inventory_Set(playerid, "Bandage", 11747, ammount);
			Info(playerid, "Anda telah berhasil memindahkan barang kedalam inventory");
		}
		else if(strcmp(name,"medicine",true) == 0)
		{
			if(pData[playerid][pMedicine] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");

			pData[playerid][pMedicine] -= ammount;
			Inventory_Set(playerid, "Medicine", 11736, ammount);
			Info(playerid, "Anda telah berhasil memindahkan barang kedalam inventory");
		}
		else if(strcmp(name,"snack",true) == 0)
		{
			if(pData[playerid][pSnack] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");

			pData[playerid][pSnack] -= ammount;
			Inventory_Set(playerid, "Snack", 2856, ammount);
			Info(playerid, "Anda telah berhasil memindahkan barang kedalam inventory");
		}
		else if(strcmp(name,"redmoney",true) == 0)
		{
			if(pData[playerid][pRedMoney] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");

			pData[playerid][pRedMoney] -= ammount;
   			Inventory_Set(playerid, "Red_Money", 1212, ammount);
			Info(playerid, "Anda telah berhasil memindahkan barang kedalam inventory");
		}
		else if(strcmp(name,"sprunk",true) == 0)
		{
			if(pData[playerid][pSprunk] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

            //if(pData[otherid][pSprunk] >= 50) return ErrorMsg(playerid, "Inventory is full.");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");

			pData[playerid][pSprunk] -= ammount;
			Inventory_Set(playerid, "Sprunk", 1546, ammount);
			Info(playerid, "Anda telah berhasil memindahkan barang kedalam inventory");
		}
		else if(strcmp(name,"mineral",true) == 0)
		{
			if(pData[playerid][pMineral] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");


            if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");

			pData[playerid][pMineral] -= ammount;
			Inventory_Set(playerid, "Mineral", 19835, ammount);
			Info(playerid, "Anda telah berhasil memindahkan barang kedalam inventory");
		}
		else if(strcmp(name,"ayam",true) == 0)
		{
			if(pData[playerid][pAyam] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

            if(pData[otherid][pAyam] >= 50) return ErrorMsg(playerid, "Inventory is full.");

            if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");

   			pData[playerid][pAyam] -= ammount;
			Inventory_Set(playerid, "Ayam", 2804, ammount);
			Info(playerid, "Anda telah berhasil memindahkan barang kedalam inventory");

			PlayerTextDrawSetPreviewModel(playerid, NotifItems[playerid][6], 18866);
			format(str, sizeof(str), "REMOVE");
			PlayerTextDrawSetString(playerid, NotifItems[playerid][4], str);
			format(str, sizeof(str), "AYAM GORENG");
			PlayerTextDrawSetString(playerid, NotifItems[playerid][3], str);
			for(new i = 0; i < 7; i++)
			{
				PlayerTextDrawShow(playerid, NotifItems[playerid][i]);
			}
			format(str, sizeof(str), "%s", ammount);
			PlayerTextDrawSetString(playerid, NotifItems[playerid][5], str);
			SetTimerEx("notifitems", 5000, false, "i", playerid);

			PlayerTextDrawSetPreviewModel(otherid, NotifItems[otherid][6], 18866);
			format(str, sizeof(str), "RECEIVED");
			PlayerTextDrawSetString(otherid, NotifItems[otherid][4], str);
			format(str, sizeof(str), "AYAM GORENG");
			PlayerTextDrawSetString(otherid, NotifItems[otherid][3], str);
			for(new i = 0; i < 7; i++)
			{
				PlayerTextDrawShow(otherid, NotifItems[otherid][i]);
			}
			format(str, sizeof(str), "%s", ammount);
			PlayerTextDrawSetString(otherid, NotifItems[otherid][5], str);
			SetTimerEx("notifitems", 5000, false, "i", otherid);


		}
		else if(strcmp(name,"burger",true) == 0)
		{
			if(pData[playerid][pBurger] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

            if(pData[otherid][pBurger] >= 50) return ErrorMsg(playerid, "Inventory is full.");

            if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");

			pData[playerid][pBurger] -= ammount;
			Inventory_Set(playerid, "Burger", 2703, ammount);
			Info(playerid, "Anda telah berhasil memindahkan barang kedalam inventory");
		}
		else if(strcmp(name,"nasbung",true) == 0)
		{
			if(pData[playerid][pNasi] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

            if(pData[otherid][pNasi] >= 50) return ErrorMsg(playerid, "Inventory is full.");

            if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");

			pData[playerid][pNasi] -= ammount;
			Inventory_Set(playerid, "Nasi", 2663, ammount);
			Info(playerid, "Anda telah berhasil memindahkan barang kedalam inventory");
		}
		else if(strcmp(name,"material",true) == 0)
		{
			if(pData[playerid][pMaterial] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

			if(ammount > 1000)
				return ErrorMsg(playerid, "Invalid ammount 1 - 1000");

			new maxmat = pData[otherid][pMaterial] + ammount;

			if(maxmat > 500)
				return ErrorMsg(playerid, "That player already have maximum material!");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");

			pData[playerid][pMaterial] -= ammount;
			Inventory_Set(playerid, "Materials", 11746, ammount);
			Info(playerid, "Anda telah berhasil memindahkan barang kedalam inventory");
		}
		else if(strcmp(name,"component",true) == 0)
		{
			if(pData[playerid][pComponent] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

			if(ammount > 20000)
				return ErrorMsg(playerid, "Invalid ammount 1 - 20000");

			new maxcomp = pData[otherid][pComponent] + ammount;

			if(maxcomp > 20000)
				return ErrorMsg(playerid, "That player already have maximum component!");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");

			pData[playerid][pComponent] -= ammount;
			Inventory_Set(playerid, "Component", 18633, ammount);
			Info(playerid, "Anda telah berhasil memindahkan barang kedalam inventory");
		}
		else if(strcmp(name,"marijuana",true) == 0)
		{
			if(pData[playerid][pMarijuana] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");

			pData[playerid][pMarijuana] -= ammount;
			Inventory_Set(playerid, "Marijuana", 1578, ammount);
			Info(playerid, "Anda telah berhasil memindahkan barang kedalam inventory");
		}
		else if(strcmp(name,"obat",true) == 0)
		{
			if(pData[playerid][pObat] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

			if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");

			pData[playerid][pObat] -= ammount;
			Inventory_Set(playerid, "Obat", 11736, ammount);
			Info(playerid, "Anda telah berhasil memindahkan barang kedalam inventory");
		}
		else if(strcmp(name,"PaketBorax",true) == 0)
		{
			if(pData[playerid][pPaketBorax] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

            if(ammount > 50)
				return ErrorMsg(playerid, "Invalid ammount 1 - 50");

            if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");

			pData[playerid][pPaketBorax] -= ammount;
			Inventory_Set(playerid, "Paket_Borax", 1578, ammount);
			Info(playerid, "Anda telah berhasil memindahkan barang kedalam inventory");
		}
		else if(strcmp(name,"borax",true) == 0)
		{
			if(pData[playerid][pBorax] < ammount)
				return ErrorMsg(playerid, "Item anda tidak cukup.");

            if(ammount > 50)
				return ErrorMsg(playerid, "Invalid ammount 1 - 50");

            if(ammount < 1) return ErrorMsg(playerid, "Can't Give below 1");

			pData[playerid][pBorax] -= ammount;
			Inventory_Set(playerid, "Borax", 19473, ammount);
			Info(playerid, "Anda telah berhasil memindahkan barang kedalam inventory");
		}
		else if(strcmp(name,"GPS_System",true) == 0)
		{
			Inventory_Remove(p1, "GPS_System", value);
			Inventory_Set(p2, "GPS_System", 18875, value);
		}
new PlayerText:NotifItems[MAX_PLAYERS][7];*/

/*
	if(!strcmp(name, "Snack", true))
	{
			
		Inventory_Remove(p1, "Snack", value);
			Inventory_Add(p2, "Snack", 2856, value);
		
    }
    if(!strcmp(name, "Sprunk", true))
	{
	
			Inventory_Remove(p1, "Sprunk", value);
			Inventory_Add(p2, "Sprunk", 1546, value);
		
    }
    if(!strcmp(name, "Bandage", true))
	{
			
			Inventory_Remove(p1, "Bandage", value);
			Inventory_Add(p2, "Bandage", 11747, value);
		
	}
		if(!strcmp(name,"medicine",true))
		{
			Inventory_Remove(p1, "Medicine", value);
			Inventory_Add(p2, "Medicine", 2856, value);
		}
	  if(!strcmp(name,"Red_Money",true))
		{
			Inventory_Remove(p1, "Red_Money", value);
   			Inventory_Add(p2, "Red_Money", 1212, value);
		
		}

		 if(!strcmp(name,"mineral",true))
		{
			Inventory_Remove(p1, "Mineral", value);
			Inventory_Set(p2, "Mineral", 19835, value);
		//	
		}
		 if(!strcmp(name,"ayam",true))
		{
			Inventory_Remove(p1, "Ayam", value);
			Inventory_Set(p2, "Ayam", 2804, value);
			//
			new str[128];
			PlayerTextDrawSetPreviewModel(p1, NotifItems[p1][6], 18866);
			format(str, sizeof(str), "REMOVE");
			PlayerTextDrawSetString(p1, NotifItems[p1][4], str);
			format(str, sizeof(str), "AYAM GORENG");
			PlayerTextDrawSetString(p1, NotifItems[p1][3], str);
			for(new i = 0; i < 7; i++)
			{
				PlayerTextDrawShow(p1, NotifItems[p1][i]);
			}
			format(str, sizeof(str), "%s", value);
			PlayerTextDrawSetString(p1, NotifItems[p1][5], str);
			SetTimerEx("notifitems", 5000, false, "i", p1);

			PlayerTextDrawSetPreviewModel(p2, NotifItems[p2][6], 18866);
			format(str, sizeof(str), "RECEIVED");
			PlayerTextDrawSetString(p2, NotifItems[2][4], str);
			format(str, sizeof(str), "AYAM GORENG");
			PlayerTextDrawSetString(2, NotifItems[p2][3], str);
			for(new i = 0; i < 7; i++)
			{
				PlayerTextDrawShow(p2, NotifItems[p2][i]);
			}
			format(str, sizeof(str), "%s", value);
			PlayerTextDrawSetString(p2, NotifItems[p2][5], str);
			SetTimerEx("notifitems", 5000, false, "i", p2);


		}
		 if(!strcmp(name,"burger",true))
		{
		Inventory_Remove(p1, "Burger", value);
			Inventory_Set(p2, "Burger", 2703, value);
		//	
		}
		 if(!strcmp(name,"Nasi",true))
		{
			Inventory_Remove(p1, "Nasi", value);
			Inventory_Set(p2, "Nasi", 2663, value);
		//	
		}
		 if(!strcmp(name,"materials",true))
		{
			Inventory_Remove(p1, "Materials", value);
			Inventory_Set(p2, "Materials", 11746, value);
		
		}
		 if(!strcmp(name,"component",true))
		{
			Inventory_Remove(p1, "Component", value);
			Inventory_Set(p2, "Component", 18633, value);
			
		}
		 if(!strcmp(name,"marijuana",true))
		{
			Inventory_Remove(p1, "Marijuana", value);
			Inventory_Set(p2, "Marijuana", 1578, value);
			
		}
		 if(!strcmp(name,"obat",true))
		{
			Inventory_Remove(p1, "Obat", value);
			Inventory_Set(p2, "Obat", 11736, value);
			
		}
		 if(!strcmp(name,"Paket_Borax",true))
		{
			Inventory_Remove(p1, "Paket_Borax", value);
			Inventory_Set(p2, "Paket_Borax", 1578, value);
			
		}
		 if(!strcmp(name,"borax",true))
		{
			Inventory_Remove(p1, "Borax", value);
			Inventory_Set(p2, "Borax", 19473, value);
			
		}
		 if(!strcmp(name,"Gps_System",true))
		{
			Inventory_Remove(p1, "Gps_System", value);
			Inventory_Set(p2, "GPS_System", 18875, value);
			
		}*/
	/*return 1;
}*/
function OnInventoryAdd(playerid, itemid)
{
    InventoryData[playerid][itemid][invID] = cache_insert_id();
    return 1;
}

//Drop Items
enum droppedItems {
	droppedID,
	droppedItem[32],
	droppedPlayer[24],
	droppedModel,
	droppedQuantity,
	Float:droppedPos[3],
	droppedWeapon,
	droppedAmmo,
	droppedInt,
	droppedWorld,
	droppedObject,
	droppedTime,
	Text3D:droppedText3D
};
new DroppedItems[MAX_DROPPED_ITEMS][droppedItems];
function OnDroppedItem(itemid)
{
    if(itemid == -1 || !DroppedItems[itemid][droppedModel])
        return 0;

    DroppedItems[itemid][droppedID] = cache_insert_id();
    return 1;
}

//Inventory Callback
function LoadInventory(playerid)
{
	new rows = cache_num_rows();

    for (new i = 0; i < rows && i < MAX_INVENTORY; i ++) {
        InventoryData[playerid][i][invExists] = true;
        cache_get_value_name_int(i, "invID", InventoryData[playerid][i][invID]);
        cache_get_value_name_int(i, "invModel", InventoryData[playerid][i][invModel]);
        cache_get_value_name_int(i, "invSlot", InventoryData[playerid][i][invSlot]);
        cache_get_value_name_int(i, "invQuantity", InventoryData[playerid][i][invQuantity]);
        cache_get_value_name_int(i, "invJangka", InventoryData[playerid][i][invJangka]);
        cache_get_value_name_int(i, "invSenjata", InventoryData[playerid][i][invSenjata]);
        cache_get_value_name(i, "invItem", InventoryData[playerid][i][invItem], 64);
        for (new id = 0; id < sizeof(g_aInventoryItems); id ++) if(!strcmp(g_aInventoryItems[id][e_InventoryItem], InventoryData[playerid][i][invItem], true))
		{
			pData[playerid][pWeight] += float(InventoryData[playerid][i][invQuantity])*g_aInventoryItems[id][e_InventoryWeight];
		}
    }
    return 1;
}
stock Inventory_GetInventoryID(playerid ,item[])
{
	for (new i = 0; i < MAX_INVENTORY; i ++)
	{
		if (!InventoryData[playerid][i][invExists])
			continue;

		if (!strcmp(InventoryData[playerid][i][invItem], item)) return InventoryData[playerid][i][invID];
	}
	return -1;
}
stock Inventory_GetItemID(playerid, item[])
{
	for (new i = 0; i < MAX_INVENTORY; i ++)
	{
		if (!InventoryData[playerid][i][invExists])
			continue;

		if (!strcmp(InventoryData[playerid][i][invItem], item)) return i;
	}
	return -1;
}

stock Inventory_GetFreeID(playerid)
{
	for (new i = 0; i < MAX_INVENTORY; i ++)
	{
		if (!InventoryData[playerid][i][invExists])
			return i;
	}
	return -1;
}

stock Inventory_Items(playerid)
{
	new count;

	for (new i = 0; i != MAX_INVENTORY; i ++) if (InventoryData[playerid][i][invExists]) {
		count++;
	}
	return count;
}

stock Inventory_Count(playerid, item[])
{
	new itemid = Inventory_GetItemID(playerid, item);

	if (itemid != -1)
		return InventoryData[playerid][itemid][invQuantity];

	return 0;
}

stock Inventory_HasItem(playerid, item[])
{
	return (Inventory_GetItemID(playerid, item) != -1);
}

stock Inventory_Set(playerid, item[], model, amount)
{
    new itemid = Inventory_GetItemID(playerid, item);

    if(amount > 0)
        Inventory_Add(playerid, item, model, amount);

    else if(amount < 1 && itemid != -1)
        Inventory_Remove(playerid, item, InventoryData[playerid][itemid][invQuantity]);

    return 1;
}

stock Inventory_SetQuantity(playerid, item[], quantity)
{
	new
		itemid = Inventory_GetItemID(playerid, item),
		string[128];

	if (itemid != -1)
	{
		format(string, sizeof(string), "UPDATE `inventory` SET `invQuantity` = %d WHERE `ID` = '%d' AND `invID` = '%d'", quantity, pData[playerid][pID], InventoryData[playerid][itemid][invID]);
		mysql_tquery(g_SQL, string);

		InventoryData[playerid][itemid][invQuantity] = quantity;
		for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if(!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
		{
			new Float:Weight = float(quantity)*g_aInventoryItems[i][e_InventoryWeight];
			pData[playerid][pWeight] += Weight;
		}
		if(InventoryOpen[playerid])
		{
			UpdateInventoryTD(playerid, itemid);
			Inventory_BarUpdate(playerid);
		}
	}
	return 1;
}

stock Inventory_Add(playerid, item[], model, quantity = 1, jangka = 100, senjata = 0, color = 0,weapon = 0, ammo = 0)
{
	new
		itemid = Inventory_GetItemID(playerid, item),
		string[318],
		value_str[218];

	if(pData[playerid][pWeight] >= 100.00) {Error(playerid, "Tas kamu tidak kuat menampung lebih banyak item lagi."); return -2;}
	if (itemid == -1)
	{
		itemid = Inventory_GetFreeID(playerid);

		if (itemid != -1)
		{
			new Float:Weights;
			for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if(!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
			{
				Weights = float(quantity)*g_aInventoryItems[i][e_InventoryWeight];
			}
			if(pData[playerid][pWeight]+Weights >= 100.00) {Error(playerid, "Tas kamu tidak kuat menampung lebih banyak item lagi."); return 1;}
			pData[playerid][pWeight] += Weights;
			InventoryData[playerid][itemid][invExists] = true;
			InventoryData[playerid][itemid][invModel] = model;
			InventoryData[playerid][itemid][invQuantity] = quantity;
			InventoryData[playerid][itemid][invWeapon] = weapon;
			InventoryData[playerid][itemid][invAmmo] = ammo;
			InventoryData[playerid][itemid][invSlot] = itemid;
            InventoryData[playerid][itemid][invJangka] = jangka;

			format(InventoryData[playerid][itemid][invItem], 64, "%s", item);
			format(string, sizeof(string), "INSERT INTO `inventory` (`ID`, `invItem`, `invModel`, `invQuantity`, `invSlot`) VALUES('%d', '%s', '%d', '%d', '%d')", pData[playerid][pID], item, model, quantity, itemid);
			mysql_tquery(g_SQL, string, "OnInventoryAdd", "dd", playerid, itemid);


			format(value_str, sizeof(value_str), "%d", InventoryData[playerid][itemid][invQuantity]);
			PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][itemid], model);
			PlayerTextDrawSetString(playerid, InvName[playerid][itemid], InventoryData[playerid][itemid][invItem]);
			if(color != 0)
			{
				InventoryData[playerid][itemid][invModelColor] = color;
				PlayerTextDrawColor(playerid, InvModel[playerid][itemid], color);
			}
			else PlayerTextDrawColor(playerid, InvModel[playerid][itemid], -1);
			if(InventoryData[playerid][itemid][invWeapon] != 0) format(value_str, sizeof(value_str), "%d", InventoryData[playerid][itemid][invAmmo]);
			PlayerTextDrawSetString(playerid, InvValue[playerid][itemid], value_str);
			if(InventoryOpen[playerid])
			{
				PlayerTextDrawShow(playerid, InvModel[playerid][itemid]);
				UpdateInventoryTD(playerid, itemid);
				Inventory_BarUpdate(playerid);
			}
			return itemid;
		}
		return -1;
	}
	else
	{
		format(string, sizeof(string), "UPDATE `inventory` SET `invQuantity` = `invQuantity` + %d WHERE `ID` = '%d' AND `invID` = '%d'", quantity, pData[playerid][pID], InventoryData[playerid][itemid][invID]);
		mysql_tquery(g_SQL, string);

		InventoryData[playerid][itemid][invQuantity] += quantity;
		format(value_str, sizeof(value_str), "%d", InventoryData[playerid][itemid][invQuantity]);
		PlayerTextDrawSetString(playerid, InvValue[playerid][itemid], value_str);
		PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][itemid], model);
		for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if(!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
		{
			pData[playerid][pWeight] += quantity*g_aInventoryItems[i][e_InventoryWeight];
		}
		if(InventoryOpen[playerid])
		{
			UpdateInventoryTD(playerid, itemid);
			Inventory_BarUpdate(playerid);
		}
	}
	return itemid;
}

stock Inventory_Remove(playerid, item[], quantity = 1)
{
	new
		itemid = Inventory_GetItemID(playerid, item),
		invid = Inventory_GetInventoryID(playerid, item),
		string[128];

	if (itemid != -1)
	{
		for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if(!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
		{
			pData[playerid][pWeight] -= quantity*g_aInventoryItems[i][e_InventoryWeight];
			if(pData[playerid][pWeight] <= 0.0) pData[playerid][pWeight] = 0.0;
		}
		if (InventoryData[playerid][itemid][invQuantity] > 0)
		{
			InventoryData[playerid][itemid][invQuantity] -= quantity;
		}
		if (quantity == -1 || InventoryData[playerid][itemid][invQuantity] < 1 || InventoryData[playerid][itemid][invSenjata] != 0)
		{
			InventoryData[playerid][itemid][invExists] = false;
			InventoryData[playerid][itemid][invModel] = 19300;
			InventoryData[playerid][itemid][invQuantity] = 0;
			InventoryData[playerid][itemid][invSenjata] = 0;
			InventoryData[playerid][itemid][invAmmo] = 0;
			InventoryData[playerid][itemid][invSlot] = -1;

			format(string, sizeof(string), "DELETE FROM `inventory` WHERE `ID` = '%d' AND `invID` = '%d'", pData[playerid][pID], invid);
			mysql_tquery(g_SQL, string);
			if(InventoryOpen[playerid])
			{
				PlayerTextDrawHide(playerid, InvName[playerid][itemid]);
    	        PlayerTextDrawHide(playerid, InvValue[playerid][itemid]);
				UpdateInventoryTD(playerid, itemid);
				Inventory_BarUpdate(playerid);
			}
		}
		else if (quantity != -1 && InventoryData[playerid][itemid][invQuantity] > 0)
		{
			format(string, sizeof(string), "UPDATE `inventory` SET `invQuantity` = `invQuantity` - %d WHERE `ID` = '%d' AND `invID` = '%d'", quantity, pData[playerid][pID], InventoryData[playerid][itemid][invID]);
			mysql_tquery(g_SQL, string);
			if(InventoryOpen[playerid])
			{
				UpdateInventoryTD(playerid, itemid);
				Inventory_BarUpdate(playerid);
			}
		}
		return 1;
	}
	return 0;
}
function Inventory_Show(playerid)
{
	if (!IsPlayerConnected(playerid))
        return 0;

    static
        str[1080],
        string[128],
        value_str[128];

    format(str, sizeof(str), "Item Name\tItem Quantity\n");
    //Show Background
    for(new inv = 0; inv<20; inv++) PlayerTextDrawColor(playerid, InvBox[playerid][inv], 1687547311), PlayerTextDrawShow(playerid, InvBox[playerid][inv]);
    //Show Text
    for(new inv = 0; inv<8; inv++) TextDrawShowForPlayer(playerid, InvenTD[inv]);
    //Set UI Color
    TextDrawColor(ClickAmmount, 1687547311);
    TextDrawColor(ClickUse, 1687547311);
    TextDrawColor(ClickGive, 1687547311);
    TextDrawColor(ClickDrop, 1687547311);
    TextDrawColor(ClickClose, 1687547311);
    PlayerTextDrawColor(playerid, BarWeight[playerid], 1687547311);
    //Show Ammount, Use, Give, Drop, Close
	TextDrawShowForPlayer(playerid, ClickAmmount);
	TextDrawShowForPlayer(playerid, ClickUse);
	TextDrawShowForPlayer(playerid, ClickGive);
	TextDrawShowForPlayer(playerid, ClickDrop);
	TextDrawShowForPlayer(playerid, ClickClose);
	PlayerTextDrawSetString(playerid, Ammount[playerid], "Ammount");
	PlayerTextDrawShow(playerid, Ammount[playerid]);
	//Show Weight
	AmmountInventory[playerid] = 1;
	SelectTextDraw(playerid, 0xFF0000FF);
	InventoryOpen[playerid] = true;

    for (new i = 0; i < MAX_INVENTORY; i ++)
    {
        if(InventoryData[playerid][i][invSenjata] != 0)
        {
        	format(value_str, sizeof(value_str), "%d(%d)", InventoryData[playerid][i][invQuantity], InventoryData[playerid][i][invJangka]);
		}
		else
        {
        	format(value_str, sizeof(value_str), "%d", InventoryData[playerid][i][invQuantity]);
		}
        if(InventoryData[playerid][i][invWeapon] != 0) format(value_str, sizeof(value_str), "%d", InventoryData[playerid][i][invAmmo]);
		PlayerTextDrawSetString(playerid, InvName[playerid][i], InventoryData[playerid][i][invItem]);
		PlayerTextDrawSetString(playerid, InvValue[playerid][i], value_str);
        if (!InventoryData[playerid][i][invExists]) PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][i], 19300);
        else
        {
        	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][i], InventoryData[playerid][i][invModel]);
        	PlayerTextDrawShow(playerid, InvName[playerid][i]);
	    	PlayerTextDrawShow(playerid, InvValue[playerid][i]);
        }
        PlayerTextDrawShow(playerid, InvModel[playerid][i]);
    }
    format(string, sizeof(string), "%.3f/100KG", pData[playerid][pWeight]);
    PlayerTextDrawSetString(playerid, InvWeight[playerid], string);
    PlayerTextDrawShow(playerid, InvWeight[playerid]);
    Inventory_BarUpdate(playerid);
	return 1;
}

function HideBackPackDialog(playerid)
{
    //Hide Background
    for(new inv = 0; inv<20; inv++) PlayerTextDrawHide(playerid, InvBox[playerid][inv]);
    //Hide Text
    for(new inv = 0; inv<8; inv++) TextDrawHideForPlayer(playerid, InvenTD[inv]);
    //Hide Ammount, Use, Give, Drop, Close
    PlayerTextDrawHide(playerid, Ammount[playerid]);
	TextDrawHideForPlayer(playerid, ClickAmmount);
	TextDrawHideForPlayer(playerid, ClickUse);
	TextDrawHideForPlayer(playerid, ClickGive);
	TextDrawHideForPlayer(playerid, ClickDrop);
	TextDrawHideForPlayer(playerid, ClickClose);
	//Hide Weight
	PlayerTextDrawHide(playerid, InvWeight[playerid]);
	PlayerTextDrawHide(playerid, BarWeight[playerid]);
	for (new i = 0; i < MAX_INVENTORY; i ++)
    {
    	PlayerTextDrawHide(playerid, InvName[playerid][i]);
    	PlayerTextDrawHide(playerid, InvValue[playerid][i]);
        PlayerTextDrawHide(playerid, InvModel[playerid][i]);
    }

    SelectInventory[playerid] = -1;
    pData[playerid][pItemid] = -1;
	AmmountInventory[playerid] = -1;
	InventoryOpen[playerid] = false;
    CancelSelectTextDraw(playerid);
    return 1;
}
stock Inventory_BarUpdate(playerid)
{
	new value = floatround(pData[playerid][pWeight]);
	if(value < 0) value = 0, pData[playerid][pWeight] = 0;
	PlayerTextDrawTextSize(playerid, BarWeight[playerid], value * 90 / 50, 13.000000);
	PlayerTextDrawShow(playerid, BarWeight[playerid]);
}
//DropItem Calback


DropItem(item[], playerid, model, quantity, Float:x, Float:y, Float:z, interior, world, weaponid = 0, ammo = 0)
{
	new
		query[300];
	for (new i = 0; i != MAX_DROPPED_ITEMS; i ++) if (!DroppedItems[i][droppedModel])
	{
		format(DroppedItems[i][droppedItem], 32, item);
		if(playerid == INVALID_PLAYER_ID) format(DroppedItems[i][droppedPlayer], 24, "Admin");
		else format(DroppedItems[i][droppedPlayer], 24, pData[playerid][pName]);

		DroppedItems[i][droppedModel] = model;
		DroppedItems[i][droppedQuantity] = quantity;
		DroppedItems[i][droppedWeapon] = weaponid;
		DroppedItems[i][droppedAmmo] = ammo;
		DroppedItems[i][droppedPos][0] = x;
		DroppedItems[i][droppedPos][1] = y;
		DroppedItems[i][droppedPos][2] = z;
		DroppedItems[i][droppedTime] = gettime();

		DroppedItems[i][droppedInt] = interior;
		DroppedItems[i][droppedWorld] = world;
		Inventory_Remove(playerid, item, quantity);

		if (IsWeaponModel(model)) {
			DroppedItems[i][droppedObject] = CreateDynamicObject(model, x, y, z, 93.7, 120.0, 120.0, world, interior);
		} else {
			DroppedItems[i][droppedObject] = CreateDynamicObject(model, x, y, z, 0.0, 0.0, 0.0, world, interior);
		}
		DroppedItems[i][droppedText3D] = CreateDynamic3DTextLabel(item, 0xB0E2FFAA, x, y, z, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, world, interior);

		/*if (strcmp(item, "Demo Soda") != 0)
		{
			format(query, sizeof(query), "INSERT INTO `dropped` (`itemName`, `itemPlayer`, `itemModel`, `itemQuantity`, `itemWeapon`, `itemAmmo`, `itemX`, `itemY`, `itemZ`, `itemInt`, `itemWorld`, `itemTime`) VALUES('%s', '%s', '%d', '%d', '%d', '%d', '%.4f', '%.4f', '%.4f', '%d', '%d', '%d')", item, DroppedItems[i][droppedPlayer], model, quantity, weaponid, ammo, x, y, z, interior, world, gettime());
			mysql_tquery(g_SQL, query, "OnDroppedItem", "d", i);
		}*/
		return i;
	}
	return -1;
}

Item_Nearest(playerid)
{
	for (new i = 0; i != MAX_DROPPED_ITEMS; i ++) if (DroppedItems[i][droppedModel] && IsPlayerInRangeOfPoint(playerid, 1.5, DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2]))
	{
		if (GetPlayerInterior(playerid) == DroppedItems[i][droppedInt] && GetPlayerVirtualWorld(playerid) == DroppedItems[i][droppedWorld])
			return i;
	}
	return -1;
}

Item_SetQuantity(itemid, amount)
{
	new
		string[64];

	if (itemid != -1 && DroppedItems[itemid][droppedModel])
	{
		DroppedItems[itemid][droppedQuantity] = amount;

		format(string, sizeof(string), "UPDATE `dropped` SET `itemQuantity` = %d WHERE `ID` = '%d'", amount, DroppedItems[itemid][droppedID]);
		mysql_tquery(g_SQL, string);
	}
	return 1;
}

Item_Delete(itemid)
{
	static
		query[64];

	if (itemid != -1 && DroppedItems[itemid][droppedModel])
	{
		DroppedItems[itemid][droppedModel] = 0;
		DroppedItems[itemid][droppedQuantity] = 0;
		DroppedItems[itemid][droppedPos][0] = 0.0;
		DroppedItems[itemid][droppedPos][1] = 0.0;
		DroppedItems[itemid][droppedPos][2] = 0.0;
		DroppedItems[itemid][droppedInt] = 0;
		DroppedItems[itemid][droppedWorld] = 0;
		DroppedItems[itemid][droppedTime] = 0;

		DestroyDynamicObject(DroppedItems[itemid][droppedObject]);
		DestroyDynamic3DTextLabel(DroppedItems[itemid][droppedText3D]);

		format(query, sizeof(query), "DELETE FROM `dropped` WHERE `ID` = '%d'", DroppedItems[itemid][droppedID]);
		mysql_tquery(g_SQL, query);
	}
	return 1;
}

PickupItem(playerid, itemid)
{
	if (itemid != -1 && DroppedItems[itemid][droppedModel])
	{
		new Float:Weight;
		for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if(!strcmp(g_aInventoryItems[i][e_InventoryItem], DroppedItems[itemid][droppedItem], true))
		{
			Weight = float(DroppedItems[itemid][droppedQuantity])*g_aInventoryItems[i][e_InventoryWeight];
		}
		if(pData[playerid][pWeight]+Weight >= 100.00) return Error(playerid, "Tas kamu tidak kuat menampung lebih banyak item lagi.");
		if(DroppedItems[itemid][droppedWeapon] != 0)
		{
			new id = Inventory_Add(playerid, DroppedItems[itemid][droppedItem], DroppedItems[itemid][droppedModel], DroppedItems[itemid][droppedQuantity], DroppedItems[itemid][droppedWeapon], DroppedItems[itemid][droppedAmmo]);

			if (id == -1)
				return Error(playerid, "You don't have any inventory slots left.");

			if(id == -2)
			    return 1;
			GivePlayerWeapon(playerid, DroppedItems[itemid][droppedWeapon], DroppedItems[itemid][droppedAmmo]);
			Item_Delete(itemid);
			return 1;
		}
		new id = Inventory_Add(playerid, DroppedItems[itemid][droppedItem], DroppedItems[itemid][droppedModel], DroppedItems[itemid][droppedQuantity]);

		if (id == -1)
			return Error(playerid, "You don't have any inventory slots left.");

		if(id == -2)
			return 1;
		Item_Delete(itemid);
	}
	return 1;
}

CMD:testid(playerid, params[])
{
    new itemid = SelectInventory[playerid];

 SendClientMessageEx(playerid, -1, "%d dan %d", itemid, pData[playerid][pItemid]);
}
CMD:kantong(playerid, params[])
{
	new kantong;
    if(sscanf(params, "d", kantong))
        return Usage(playerid, "/kantong [id player]");
        
	pData[playerid][pKantong] = kantong;
	return 1;
}

//Inventory Items
CMD:tdinven(playerid)
{
	Inventory_Show(playerid);
	return 1;
}

CMD:cekinven(playerid ,params[])
{
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/cekinven [playerid/PartOfName]");
    if (!IsPlayerConnected(otherid))
        return 0;

    static
        str[1080],
        string[128],
        value_str[128];

    format(str, sizeof(str), "Item Name\tItem Quantity\n");
    //Show Background
    for(new inv = 0; inv<20; inv++) PlayerTextDrawColor(playerid, InvBox[otherid][inv], 1687547311), PlayerTextDrawShow(playerid, InvBox[otherid][inv]);
    //Show Text
    for(new inv = 0; inv<8; inv++) TextDrawShowForPlayer(playerid, InvenTD[inv]);
    TextDrawHideForPlayer(playerid, InvenTD[4]);
    //Set UI Color
    TextDrawColor(ClickAmmount, 1687547311);
//    TextDrawColor(ClickUse, 1687547311);
    TextDrawColor(ClickGive, 1687547311);
    TextDrawColor(ClickDrop, 1687547311);
    TextDrawColor(ClickClose, 1687547311);
    PlayerTextDrawColor(playerid, BarWeight[otherid], 1687547311);
    //Show Ammount, Use, Give, Drop, Close
	TextDrawShowForPlayer(playerid, ClickAmmount);
//	TextDrawShowForPlayer(playerid, ClickUse);
	TextDrawShowForPlayer(playerid, ClickGive);
	TextDrawShowForPlayer(playerid, ClickDrop);
	TextDrawShowForPlayer(playerid, ClickClose);
	PlayerTextDrawSetString(playerid, Ammount[otherid], "Ammount");
	PlayerTextDrawShow(playerid, Ammount[otherid]);
	//Show Weight
	AmmountInventory[otherid] = 1;
	SelectTextDraw(playerid, 0xFF0000FF);
	InventoryOpen[otherid] = true;

    for (new i = 0; i < MAX_INVENTORY; i ++)
    {
        format(value_str, sizeof(value_str), "%d", InventoryData[otherid][i][invQuantity]);
        if(InventoryData[otherid][i][invWeapon] != 0) format(value_str, sizeof(value_str), "%d", InventoryData[otherid][i][invAmmo]);
		PlayerTextDrawSetString(playerid, InvName[otherid][i], InventoryData[otherid][i][invItem]);
		PlayerTextDrawSetString(playerid, InvValue[otherid][i], value_str);
        if (!InventoryData[otherid][i][invExists]) PlayerTextDrawSetPreviewModel(playerid, InvModel[otherid][i], 19300);
        else
        {
        	PlayerTextDrawSetPreviewModel(playerid, InvModel[otherid][i], InventoryData[otherid][i][invModel]);
        	PlayerTextDrawShow(playerid, InvName[otherid][i]);
	    	PlayerTextDrawShow(playerid, InvValue[otherid][i]);
        }
        PlayerTextDrawShow(playerid, InvModel[otherid][i]);
    }
    format(string, sizeof(string), "%.3f/100KG", pData[otherid][pWeight]);
    PlayerTextDrawSetString(playerid, InvWeight[otherid], string);
    PlayerTextDrawShow(playerid, InvWeight[otherid]);
    Inventory_BarUpdate(playerid);
	return 1;
}
CMD:setitem(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6) return PermissionError(playerid);
	static
        userid,
        item[32],
        amount;
    if(sscanf(params, "uds[32]", userid, amount, item))
        return Usage(playerid, "/setitem [playerid/PartOfName] [amount] [item name]");
    for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if(!strcmp(g_aInventoryItems[i][e_InventoryItem], item, true))
    {
        if(amount > g_aInventoryItems[i][e_InventoryMax]) return Error(playerid, "Maximmum ammount for this item is %d.", g_aInventoryItems[i][e_InventoryMax]);

        new id = Inventory_Set(userid, g_aInventoryItems[i][e_InventoryItem], g_aInventoryItems[i][e_InventoryModel], amount);
        if(id == -1) return Error(playerid, "You don't have any inventory slots left.");
        else return Servers(playerid, "You have set %s's \"%s\" to %d.", GetName(playerid), item, amount);
    }
    Error(playerid, "Invalid item name (use /itemlist for a list).");
    return 1;
}


//Drop Item
CMD:pickup(playerid)
{
	new
        count = 0,
        id = Item_Nearest(playerid),
        string[1080];

    if (id != -1)
    {
        string = "";
        format(string, sizeof(string), "Item Name\tQuantity\n");
        for (new i = 0; i < MAX_DROPPED_ITEMS; i ++) if (count < MAX_LISTED_ITEMS && DroppedItems[i][droppedModel] && IsPlayerInRangeOfPoint(playerid, 1.5, DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2]) && GetPlayerInterior(playerid) == DroppedItems[i][droppedInt] && GetPlayerVirtualWorld(playerid) == DroppedItems[i][droppedWorld]) {
            NearestItems[playerid][count++] = i;
            format(string, sizeof(string), "%s%s\t%d\n", string, DroppedItems[i][droppedItem], DroppedItems[i][droppedQuantity]);
        }
        if (count == 1)
        {
            if (DroppedItems[id][droppedWeapon] != 0)
            {
                GivePlayerWeapon(playerid, DroppedItems[id][droppedWeapon], DroppedItems[id][droppedAmmo]);

                Item_Delete(id);
                //SendNearbyMessage(playerid, 30.0, X11_PURPLE, "** %s has picked up a %s.", GetName(playerid), GetWeaponName(DroppedItems[id][droppedWeapon]));
                return 1;
            }
            else if (PickupItem(playerid, id))
            {
                //SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has picked up a \"%s\".", GetPlayerNameEx(playerid), DroppedItems[id][droppedItem]);
            }
            //else Error(playerid, "You don't have any room in your inventory.");
        }
        else ShowPlayerDialog(playerid, INVENTORY_PICKUP, DIALOG_STYLE_TABLIST_HEADERS, "Pickup Items", string, "Pickup", "Cancel");
    }
	return 1;
}

CMD:spawnitem(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5) return PermissionError(playerid);

    if(isnull(params))
        return Usage(playerid, "/spawnitem [item name] (/itemlist for a list)");

    static
        Float:x,
        Float:y,
        Float:z;

    GetPlayerPos(playerid, x, y, z);

    for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if(!strcmp(g_aInventoryItems[i][e_InventoryItem], params, true))
    {
        new id = DropItem(g_aInventoryItems[i][e_InventoryItem], INVALID_PLAYER_ID, g_aInventoryItems[i][e_InventoryModel], 1, x, y, z - 0.9, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));

        if(id == -1)
            return Error(playerid, "The server has reached a limit for spawned items.");

        Servers(playerid, "You have spawned a \"%s\" (type /setquantity to set the quantity).", g_aInventoryItems[i][e_InventoryItem]);
        return 1;
    }
    Error(playerid, "Invalid item name (use /itemlist for a list).");
    return 1;
}

CMD:setquantity(playerid, params[])
{
    static
        id = -1,
        amount;

    if(pData[playerid][pAdmin] < 5) return PermissionError(playerid);

    if((id = Item_Nearest(playerid)) == -1)
        return Error(playerid, "You are not in range of any spawned items.");

    if(sscanf(params, "d", amount))
        return Usage(playerid, "/setquantity [amount]");

    if(amount < 1)
        return Error(playerid, "The specified amount can't be below 1");

    Item_SetQuantity(id, amount);
    Servers(playerid, "You have set the quantity of \"%s\" to %d.", DroppedItems[id][droppedItem], amount);
    return 1;
}

CMD:destroyitem(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4) return PermissionError(playerid);

    static
        id = -1;

    if((id = Item_Nearest(playerid)) == -1)
        return Error(playerid, "You are not in range of any spawned items.");

    Servers(playerid, "You have deleted a \"%s\".", DroppedItems[id][droppedItem]);
    Item_Delete(id);
    return 1;
}

stock UpdateInventoryTD(playerid, itemid)
{
	new value_str[128], string[128];

	format(string, sizeof(string), "%.3f/100KG", pData[playerid][pWeight]);
	format(value_str, sizeof(value_str), "%d", InventoryData[playerid][itemid][invQuantity]);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][itemid], InventoryData[playerid][itemid][invModel]);

	if(InventoryData[playerid][itemid][invModel] == 19300)
	{
    	PlayerTextDrawHide(playerid, InvName[playerid][itemid]);
		PlayerTextDrawHide(playerid, InvValue[playerid][itemid]);
	}
	else
	{
		PlayerTextDrawShow(playerid, InvName[playerid][itemid]);
	    PlayerTextDrawShow(playerid, InvValue[playerid][itemid]);
	}
	PlayerTextDrawSetString(playerid, InvName[playerid][itemid], InventoryData[playerid][itemid][invItem]);
	PlayerTextDrawSetString(playerid, InvValue[playerid][itemid], value_str);
	PlayerTextDrawSetString(playerid, InvWeight[playerid], string);

	PlayerTextDrawShow(playerid, InvModel[playerid][itemid]);
    PlayerTextDrawShow(playerid, InvWeight[playerid]);

	return 1;
}

hook ClickDynamicPlayerTextdraw(playerid, PlayerText:playertextid)
{
	if(InventoryOpen[playerid])
	{
		for(new i = 0; i<20; i++) if(playertextid == InvModel[playerid][i])
		{
            SelectInventory[playerid] = i;
            pData[playerid][pItemid] = i;
		}
	}
	return 1;
}
function OnPlayerBeriInvItem(playerid, itemid, name[])
{
    if(!strcmp(name, "Snack", true))
	{
			new orang = pData[playerid][pKantong];
			new value = AmmountInventory[playerid];
			Inventory_Remove(playerid, "Snack", value);
			Inventory_Add(orang, "Snack", 2856, value);
			pData[playerid][pKantong] = -1;
    }
}
function OnPlayerUseInvItem(playerid, itemid, name[])
{

    if(!strcmp(name,"bandage",true))
		{
			ShowPlayerDialog(playerid, DIALOG_TULANG, DIALOG_STYLE_LIST, "Health Menu", "Kepala\nPerut\nTangan kanan\nTangan kiri\nKaki kanan\nKaki kiri", "Select", "Close");
		}
		if(!strcmp(name,"ayam",true))
		{
		
			pData[playerid][pAyam]--;
		//	Inventory_Remove(playerid, "Ayam", 1);
			pData[playerid][pHunger] += 20;
			Inventory_Remove(playerid, InventoryData[playerid][itemid][invItem], 1);
			Info(playerid, "Anda telah berhasil memakan ayam goyeng.");
			InfoTD_MSG(playerid, 3000, "Restore +30 Hunger");
			ApplyAnimation(playerid,"FOOD", "EAT_Burger", 4.0, 1, 0, 0, 0, 0, 1);
		}
	 	if(!strcmp(name,"burger",true))
		{
		
			pData[playerid][pBurger]--;
			Inventory_Remove(playerid, "Burger", 1);
			//Inventory_Remove(playerid, InventoryData[playerid][itemid][invItem], 1);

			pData[playerid][pHunger] += 25;
			Info(playerid, "Anda telah berhasil memakan burger.");
			InfoTD_MSG(playerid, 3000, "Restore +25 Hunger");
			ApplyAnimation(playerid,"FOOD", "EAT_Burger", 4.0, 1, 0, 0, 0, 0, 1);
		}
		if(!strcmp(name,"Colt45",true))
		{
			//Inventory_Remove(playerid, "Colt45", 1);

			GivePlayerWeaponEx(playerid, 22, 99999);
		}
		if(!strcmp(name,"Silenced_Pistol",true))
		{
			//Inventory_Remove(playerid, "Silenced_Pistol", 1);

			GivePlayerWeaponEx(playerid, 23, 99999);
		}
		if(!strcmp(name,"Desert_Eagle",true))
		{
			//Inventory_Remove(playerid, "Desert_Eagle", 1);

			GivePlayerWeaponEx(playerid, 24, 99999);
		}
		if(!strcmp(name,"Shotgun",true))
		{
			//Inventory_Remove(playerid, "Shotgun", 1);

			GivePlayerWeaponEx(playerid, 25, 99999);
		}
		if(!strcmp(name,"Ak47",true))
		{
			//Inventory_Remove(playerid, "Ak47", 1);

			GivePlayerWeaponEx(playerid, 30, 99999);
		}
		if(!strcmp(name,"Mp5",true))
		{
			//Inventory_Remove(playerid, "Mp5", 1);

			GivePlayerWeaponEx(playerid, 29, 99999);
		}
		if(!strcmp(name,"nasbung",true))
		{
			pData[playerid][pNasi]--;
			pData[playerid][pHunger] += 35;
			Inventory_Remove(playerid, InventoryData[playerid][itemid][invItem], 1);

			Info(playerid, "Anda telah berhasil memakan nasi bungkus.");
			InfoTD_MSG(playerid, 3000, "Restore +35 Hunger");
			ApplyAnimation(playerid,"FOOD", "EAT_Burger", 4.0, 1, 0, 0, 0, 0, 1);
		}
		if(!strcmp(name,"boombox",true))
		{
			new string[128], Float:BBCoord[4], pNames[MAX_PLAYER_NAME];
		    GetPlayerPos(playerid, BBCoord[0], BBCoord[1], BBCoord[2]);
		    GetPlayerFacingAngle(playerid, BBCoord[3]);
		    SetPVarFloat(playerid, "BBX", BBCoord[0]);
		    SetPVarFloat(playerid, "BBY", BBCoord[1]);
		    SetPVarFloat(playerid, "BBZ", BBCoord[2]);
		    GetPlayerName(playerid, pNames, sizeof(pNames));
		    BBCoord[0] += (2 * floatsin(-BBCoord[3], degrees));
		   	BBCoord[1] += (2 * floatcos(-BBCoord[3], degrees));
		   	BBCoord[2] -= 1.0;
			if(GetPVarInt(playerid, "PlacedBB")) return SCM(playerid, -1, "Kamu Sudah Memasang Boombox");
			foreach(new i : Player)
			{
		 		if(GetPVarType(i, "PlacedBB"))
		   		{
		  			if(IsPlayerInRangeOfPoint(playerid, 30.0, GetPVarFloat(i, "BBX"), GetPVarFloat(i, "BBY"), GetPVarFloat(i, "BBZ")))
					{
		   				SendClientMessage(playerid, COLOR_WHITE, "Kamu Tidak Dapat Memasang Boombox Disini, Karena Orang Sudah Lain Sudah Memasang Boombox Disini");
					    return 1;
					}
				}
			}
			new string2[128];
			format(string2, sizeof(string2), "%s Telah Memasang Boombox!", pNames);
			Inventory_Remove(playerid, InventoryData[playerid][itemid][invItem], 1);

			SendNearbyMessage(playerid, 15, COLOR_PURPLE, string2);
			SetPVarInt(playerid, "PlacedBB", CreateDynamicObject(2102, BBCoord[0], BBCoord[1], BBCoord[2], 0.0, 0.0, 0.0, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid)));
			format(string, sizeof(string), "Creator "WHITE_E"%s\n["LBLUE"/bbhelp for info"WHITE_E"]", pNames);
			SetPVarInt(playerid, "BBLabel", _:CreateDynamic3DTextLabel(string, COLOR_YELLOW, BBCoord[0], BBCoord[1], BBCoord[2]+0.6, 5, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid)));
			SetPVarInt(playerid, "BBArea", CreateDynamicSphere(BBCoord[0], BBCoord[1], BBCoord[2], 30.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)));
			SetPVarInt(playerid, "BBInt", GetPlayerInterior(playerid));
			SetPVarInt(playerid, "BBVW", GetPlayerVirtualWorld(playerid));
			ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
		    ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
		}
		if(!strcmp(name,"snack",true))
		{
		
			pData[playerid][pSnack]--;
			pData[playerid][pHunger] += 10;
			Info(playerid, "Anda telah berhasil menggunakan snack.");
			Inventory_Remove(playerid, InventoryData[playerid][itemid][invItem], 1);

			InfoTD_MSG(playerid, 3000, "Restore +15 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		if(!strcmp(name,"Nasi",true))
		{
		    Inventory_Remove(playerid, "Nasi", 1);
		    pData[playerid][pHunger] += 35;
			Info(playerid, "Anda telah berhasil memakan nasi bungkus.");
			InfoTD_MSG(playerid, 3000, "Restore +35 Hunger");
			ApplyAnimation(playerid,"FOOD", "EAT_Burger", 4.0, 1, 0, 0, 0, 0, 1);
		}
		if(!strcmp(name,"sprunk",true))
		{
			
			pData[playerid][pSprunk]--;
			Inventory_Remove(playerid, "Sprunk", 1);
			pData[playerid][pEnergy] += 20;
			Inventory_Remove(playerid, InventoryData[playerid][itemid][invItem], 1);

			Info(playerid, "Anda telah berhasil meminum sprunk.");
			InfoTD_MSG(playerid, 3000, "Restore +15 Energy");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		if(!strcmp(name,"mineral",true))
		{
			
			pData[playerid][pMineral]--;
			Inventory_Remove(playerid, InventoryData[playerid][itemid][invItem], 1);

			pData[playerid][pEnergy] += 20;
			Info(playerid, "Anda telah berhasil meminum mineral.");
			InfoTD_MSG(playerid, 3000, "Restore +20 Energy");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		/*else if(strcmp(params,"sprunk",true) == 0)
		{
			if(pData[playerid][pSprunk] < 1)
				return Error(playerid, "Anda tidak memiliki snack.");

			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_SPRUNK);
			//SendNearbyMessage(playerid, 10.0, COLOR_PURPLE,"* %s opens a can of sprunk.", ReturnName(playerid));
			SetPVarInt(playerid, "UsingSprunk", 1);
			pData[playerid][pSprunk]--;
		}*/
		if(!strcmp(name,"Fuel_Can",true))
		{
		
			if(IsPlayerInAnyVehicle(playerid))
				return Error(playerid, "Anda harus berada diluar kendaraan!");

			if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

			new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			if(IsValidVehicle(vehicleid))
			{
				new fuel = GetVehicleFuel(vehicleid);

				if(GetEngineStatus(vehicleid))
					return Error(playerid, "Turn off vehicle engine.");

				if(fuel >= 999.0)
					return Error(playerid, "This vehicle gas is full.");

				if(!IsEngineVehicle(vehicleid))
					return Error(playerid, "This vehicle can't be refull.");

				if(!GetHoodStatus(vehicleid))
					return Error(playerid, "The hood must be opened before refull the vehicle.");

				pData[playerid][pGas]--;
				new PlayerText:ActiveTD[MAX_PLAYERS];

				Info(playerid, "Don't move from your position or you will failed to refulling this vehicle.");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pActivityStatus] = 1;
				Inventory_Remove(playerid, InventoryData[playerid][itemid][invItem], 1);

				pData[playerid][pActivity] = SetTimerEx("RefullCar", 1000, true, "id", playerid, vehicleid);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Refulling...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				/*InfoTD_MSG(playerid, 10000, "Refulling...");
				//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s starts to refulling the vehicle.", ReturnName(playerid));*/
				return 1;
			}
		}
		if(!strcmp(name,"medicine",true))
		{
		
			pData[playerid][pMedicine]--;
			pData[playerid][pSick] = 0;
			pData[playerid][pSickTime] = 0;
			SetPlayerDrunkLevel(playerid, 0);
			Info(playerid, "Anda menggunakan medicine.");
			Inventory_Remove(playerid, InventoryData[playerid][itemid][invItem], 1);


			//InfoTD_MSG(playerid, 3000, "Restore +15 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		if(!strcmp(name,"obat",true))
		{
	
			if(Inventory_Count(playerid, "Obat") < 1)
				return ErrorMsg(playerid, "Anda tidak memiliki Obat Myricous.");

            new Float:darah;
			GetPlayerHealth(playerid, darah);
			if(darah+20 > 100) return ErrorMsg(playerid, "Your Health Fuel!");
			Inventory_Remove(playerid, "Obat", 1);
			SetPlayerHealthEx(playerid, darah+20);
			pData[playerid][pSick] = 0;
			pData[playerid][pSickTime] = 0;
			SetPlayerDrunkLevel(playerid, 0);
			Info(playerid, "Anda menggunakan Obat +20 health.");

			//InfoTD_MSG(playerid, 3000, "Restore +15 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		if(!strcmp(name,"marijuana",true))
		{
			
			new Float:armor;
			GetPlayerArmour(playerid, armor);
			if(armor+10 > 90) return Error(playerid, "Over dosis!");

			pData[playerid][pMarijuana]--;
			Inventory_Remove(playerid, InventoryData[playerid][itemid][invItem], 1);

			SetPlayerArmourEx(playerid, armor+10);
			SetPlayerDrunkLevel(playerid, 4000);
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		if(!strcmp(name,"camping",true))
		{
	      
		}
    Inventory_Show(playerid);
	return 1;
}
hook OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(InventoryOpen[playerid])
	{
		if(clickedid == ClickUse)
		{
			new itemid = SelectInventory[playerid];

			if(itemid == -1) return Error(playerid, "Silahkan pilih item yang ingin digunakan!");
			
			/*new string[128];
			if( InventoryData[playerid][itemid][invQuantity] == 1)
			{
			    format(string, sizeof(string), "DELETE FROM `inventory` WHERE `ID` = '%d' AND `invID` = '%d'", pData[playerid][pID], InventoryData[playerid][itemid][invID]);
				mysql_tquery(g_SQL, string);
			}
			
            InventoryData[playerid][itemid][invQuantity] -= 1;*/
            //Inventory_Remove(playerid, InventoryData[playerid][itemid][invItem], 1);

			//CallLocalFunction("OnPlayerUseInvItem", "dds", playerid, itemid, InventoryData[playerid][itemid][invItem]);
			SetTimerEx("OnPlayerUseInvItem", 100, false, "dds", playerid, itemid, InventoryData[playerid][itemid][invItem]);
	//	callcmd::use(playerid, "%s", InventoryData[playerid][itemid][invItem]);
			return 1;
		}
		if(clickedid == ClickGive)
		{
			new  itemid = SelectInventory[playerid],  count = 0, str[1080];
			new orang = pData[playerid][pKantong];
			new value = AmmountInventory[playerid];
			if(itemid == -1) return Error(playerid, "Silahkan pilih item yang ingin digunakan!");
			if(AmmountInventory[playerid] == 0) return Error(playerid, "Anda belum menset jumlah");
			//if(pData[playerid][pKantong] == -1) return Error(playerid, "Kamu belum mengset kantong, ketik /kantong id player");
			
			/*Inventory_Remove(playerid, InventoryData[playerid][itemid][invItem], value);
			Inventory_Add(orang, InventoryData[playerid][itemid][invItem], InventoryData[playerid][itemid][invModel], value);*/
			//CallLocalFunction("OnPlayerBeriInvItem", "dds", playerid, itemid, InventoryData[playerid][itemid][invItem]);
			//SetTimerEx("OnPlayerBeriInvItem", 100, false, "dds", playerid, itemid, InventoryData[playerid][itemid][invItem]);
			/*foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) && i != playerid)
			{
				format(str, sizeof(str), "%d\n", i);
				SetPlayerListitemValue(playerid, count++, i);
			}
			if(!count) Error(playerid, "Tidak ada player lain didekat mu!");
			else ShowPlayerDialog(playerid, INVENoVE, DIALOG_STYLE_LIST, "Give Items To:", str, "Give", "Close");*/
			//ShowPlayerDialog(playerid, INVENTORY_GIVE, DIALOG_STYLE_INPUT, "Player:", "Silahkan Masukkan id player", "Input", "Close");
			foreach(new i : Player) if(IsPlayerConnected(i) && NearPlayer(playerid, i, 5) && i != playerid)
			{
				
				SetPlayerListitemValue(playerid, count++, i);
				new itemid = SelectInventory[playerid];
				new value = AmmountInventory[playerid];
				format(str, sizeof(str), "%d\n", i);

				if(!count)
				{
					 Error(playerid, "Tidak ada player lain didekat mu!");
				}
				else
				{
				    ShowPlayerDialog(playerid, INVENTORY_GIVE, DIALOG_STYLE_LIST, "Give Items To:", str, "Give", "Close");
					/*SendClientMessageEx(playerid, -1, "Kamu ngasih %s Ke player id:%d", InventoryData[playerid][itemid][invItem], i);
				 	SetTimerEx("OnPlayerGiveInvItem", 100, false, "dddsd", playerid, i, itemid, InventoryData[playerid][itemid][invItem], value);*/
				}
			}
			//else ShowPlayerDialog(playerid, INVENTORY_GIVE, DIALOG_STYLE_LIST, "Give Items To:", str, "Give", "Close");
			return 1;
		}
		if(clickedid == ClickAmmount)
		{
			if(SelectInventory[playerid] == -1) return Error(playerid, "Silahkan pilih item yang ingin digunakan!");
			ShowPlayerDialog(playerid, INVENTORY_AMOUNT, DIALOG_STYLE_INPUT, "Ammount:", "Silahkan Masukkan Jumlah Yang Ingin Anda\nBerikan, Gunakan Atau Drop:", "Input", "Close");
			return 1;
		}
		if(clickedid == ClickClose)
		{
			HideBackPackDialog(playerid);
			SelectInventory[playerid] = -1;
			AmmountInventory[playerid] = -1;
			InventoryOpen[playerid] = false;
		}
		if(clickedid == ClickDrop)
		{
			new id = SelectInventory[playerid];
			if(InventoryData[playerid][id][invModel] == 19300) return 1;
			for (new i = 0; i < sizeof(g_aInventoryItems); i ++) if(!strcmp(g_aInventoryItems[i][e_InventoryItem], InventoryData[playerid][id][invItem], true)) {
                if(g_aInventoryItems[i][e_InventoryDrop] == false) return Error(playerid, "You can't drop this item (%s).", InventoryData[playerid][id][invItem]);
            }
			//Drop Item
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			if(IsWeaponModel(InventoryData[playerid][id][invModel]))
			{
				DropItem(InventoryData[playerid][id][invItem], playerid, InventoryData[playerid][id][invModel], InventoryData[playerid][id][invQuantity], x, y, z-1, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), InventoryData[playerid][id][invWeapon], InventoryData[playerid][id][invAmmo]);
				ResetWeapon(playerid, InventoryData[playerid][id][invWeapon]);
			}
			else DropItem(InventoryData[playerid][id][invItem], playerid, InventoryData[playerid][id][invModel], AmmountInventory[playerid], x, y, z-1, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
			ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
			HideBackPackDialog(playerid);
		}
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == INVENTORY_AMOUNT)
	{
		if(response)
		{
			new value = strval(inputtext);
			if(InventoryData[playerid][SelectInventory[playerid]][invQuantity] < value) return Error(playerid, "Kamu tidak memiliki %s sebanyak %d", InventoryData[playerid][SelectInventory[playerid]][invItem],value);
			AmmountInventory[playerid] = value;
			PlayerTextDrawSetString(playerid, Ammount[playerid], inputtext);
			PlayerTextDrawShow(playerid, Ammount[playerid]);
		}
	}
	if(dialogid == INVENTORY_GIVE)
	{
		if(response)
		{
			new p2 = GetPlayerListitemValue(playerid, listitem);
			new itemid = SelectInventory[playerid];
			new value = AmmountInventory[playerid];

			new str[128];
			format(str, sizeof(str), "Berhasil memberikan %d %s kepada %s", value, InventoryData[playerid][itemid][invItem], ReturnName(p2));
            SuccesMsg(playerid, str);
            new ytta[128];
			format(ytta, sizeof(ytta), "%s Memberikan %d %s", ReturnName(playerid), value, InventoryData[playerid][itemid][invItem]);
            SuccesMsg(p2, ytta);
            Inventory_Remove(playerid, InventoryData[playerid][itemid][invItem], value);
			Inventory_Set(p2, InventoryData[playerid][itemid][invItem], InventoryData[playerid][itemid][invModel], value);
            //SetTimerEx("OnPlayerGiveInvItem", 100, false, "dddsd", playerid, p2, itemid, InventoryData[playerid][itemid][invItem], value);
			//CallLocalFunction("OnPlayerGiveInvItem", "ddds[128]d", playerid, p2, itemid, InventoryData[playerid][itemid][invItem], value);
		}
	}
	if(dialogid == INVENTORY_PICKUP)
	{
		if(response)
		{
			new itemid = NearestItems[playerid][listitem];
			PickupItem(playerid, itemid);
		}
	}
	return 1;
}

CreatePlayerInventoryTD(playerid)
{
   //Inventory
	InvModel[playerid][0] = CreatePlayerTextDraw(playerid, 155.000000, 174.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][0], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][0], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][0], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][0], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][0], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][0], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][0], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][0], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][0], 1, 1);

	InvModel[playerid][1] = CreatePlayerTextDraw(playerid, 200.000000, 174.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][1], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][1], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][1], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][1], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][1], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][1], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][1], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][1], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][1], 1, 1);

	InvModel[playerid][2] = CreatePlayerTextDraw(playerid, 245.000000, 174.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][2], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][2], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][2], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][2], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][2], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][2], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][2], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][2], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][2], 1, 1);

	InvModel[playerid][3] = CreatePlayerTextDraw(playerid, 290.000000, 174.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][3], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][3], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][3], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][3], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][3], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][3], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][3], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][3], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][3], 1, 1);

	InvModel[playerid][4] = CreatePlayerTextDraw(playerid, 335.000000, 174.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][4], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][4], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][4], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][4], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][4], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][4], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][4], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][4], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][4], 1, 1);

	InvModel[playerid][5] = CreatePlayerTextDraw(playerid, 155.000000, 231.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][5], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][5], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][5], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][5], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][5], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][5], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][5], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][5], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][5], 1, 1);

	InvModel[playerid][6] = CreatePlayerTextDraw(playerid, 200.000000, 231.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][6], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][6], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][6], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][6], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][6], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][6], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][6], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][6], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][6], 1, 1);

	InvModel[playerid][7] = CreatePlayerTextDraw(playerid, 245.000000, 231.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][7], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][7], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][7], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][7], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][7], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][7], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][7], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][7], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][7], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][7], 1, 1);

	InvModel[playerid][8] = CreatePlayerTextDraw(playerid, 290.000000, 231.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][8], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][8], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][8], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][8], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][8], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][8], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][8], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][8], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][8], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][8], 1, 1);

	InvModel[playerid][9] = CreatePlayerTextDraw(playerid, 335.000000, 231.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][9], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][9], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][9], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][9], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][9], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][9], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][9], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][9], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][9], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][9], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][9], 1, 1);

	InvModel[playerid][10] = CreatePlayerTextDraw(playerid, 155.000000, 288.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][10], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][10], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][10], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][10], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][10], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][10], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][00], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][10], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][10], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][10], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][10], 1, 1);

	InvModel[playerid][11] = CreatePlayerTextDraw(playerid, 200.000000, 288.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][11], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][11], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][11], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][11], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][11], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][11], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][01], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][11], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][11], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][11], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][11], 1, 1);

	InvModel[playerid][12] = CreatePlayerTextDraw(playerid, 245.000000, 288.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][12], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][12], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][12], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][12], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][12], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][12], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][12], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][02], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][12], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][12], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][12], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][12], 1, 1);

	InvModel[playerid][13] = CreatePlayerTextDraw(playerid, 290.000000, 288.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][13], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][13], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][13], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][13], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][13], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][13], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][03], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][13], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][13], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][13], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][13], 1, 1);

	InvModel[playerid][14] = CreatePlayerTextDraw(playerid, 335.000000, 288.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][14], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][14], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][14], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][14], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][14], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][14], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][14], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][04], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][14], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][14], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][14], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][14], 1, 1);

	InvModel[playerid][15] = CreatePlayerTextDraw(playerid, 155.000000, 345.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][15], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][15], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][15], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][15], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][15], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][15], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][15], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][05], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][15], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][15], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][15], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][15], 1, 1);

	InvModel[playerid][16] = CreatePlayerTextDraw(playerid, 200.000000, 346.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][16], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][16], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][16], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][16], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][16], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][16], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][16], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][16], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][16], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][06], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][16], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][16], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][16], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][16], 1, 1);

	InvModel[playerid][17] = CreatePlayerTextDraw(playerid, 245.000000, 346.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][17], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][17], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][17], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][17], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][17], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][17], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][17], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][17], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][17], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][07], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][17], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][17], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][17], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][17], 1, 1);

	InvModel[playerid][18] = CreatePlayerTextDraw(playerid, 290.000000, 346.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][18], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][18], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][18], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][18], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][18], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][18], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][18], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][18], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][18], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][08], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][18], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][18], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][18], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][18], 1, 1);

	InvModel[playerid][19] = CreatePlayerTextDraw(playerid, 335.000000, 346.000000, "Preview_Model");
	PlayerTextDrawFont(playerid, InvModel[playerid][19], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][19], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][19], 41.500000, 52.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][19], 0);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][19], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][19], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][19], 125);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][19], 255);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][19], 0);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][09], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][19], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][19], 1212);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][19], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][19], 1, 1);

	InvBox[playerid][0] = CreatePlayerTextDraw(playerid, 155.000000, 215.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][0], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][0], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][0], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][0], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][0], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][0], 0);

	InvBox[playerid][1] = CreatePlayerTextDraw(playerid, 200.000000, 215.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][1], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][1], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][1], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][1], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][1], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][1], 0);

	InvBox[playerid][2] = CreatePlayerTextDraw(playerid, 245.000000, 215.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][2], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][2], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][2], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][2], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][2], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][2], 0);

	InvBox[playerid][3] = CreatePlayerTextDraw(playerid, 290.000000, 215.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][3], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][3], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][3], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][3], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][3], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][3], 0);

	InvBox[playerid][4] = CreatePlayerTextDraw(playerid, 335.000000, 215.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][4], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][4], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][4], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][4], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][4], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][4], 0);

	InvBox[playerid][5] = CreatePlayerTextDraw(playerid, 155.000000, 271.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][5], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][5], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][5], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][5], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][5], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][5], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][5], 0);

	InvBox[playerid][6] = CreatePlayerTextDraw(playerid, 200.000000, 271.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][6], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][6], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][6], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][6], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][6], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][6], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][6], 0);

	InvBox[playerid][7] = CreatePlayerTextDraw(playerid, 245.000000, 271.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][7], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][7], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][7], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][7], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][7], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][7], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][7], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][7], 0);

	InvBox[playerid][8] = CreatePlayerTextDraw(playerid, 290.000000, 271.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][8], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][8], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][8], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][8], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][8], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][8], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][8], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][8], 0);

	InvBox[playerid][9] = CreatePlayerTextDraw(playerid, 335.000000, 271.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][9], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][9], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][9], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][9], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][9], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][9], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][9], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][9], 0);

	InvBox[playerid][10] = CreatePlayerTextDraw(playerid, 155.000000, 328.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][10], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][10], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][10], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][10], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][10], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][10], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][10], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][10], 0);

	InvBox[playerid][11] = CreatePlayerTextDraw(playerid, 200.000000, 328.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][11], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][11], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][11], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][11], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][11], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][11], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][11], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][11], 0);

	InvBox[playerid][12] = CreatePlayerTextDraw(playerid, 245.000000, 328.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][12], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][12], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][12], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][12], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][12], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][12], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][12], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][12], 0);

	InvBox[playerid][13] = CreatePlayerTextDraw(playerid, 290.000000, 328.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][13], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][13], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][13], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][13], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][13], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][13], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][13], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][13], 0);

	InvBox[playerid][14] = CreatePlayerTextDraw(playerid, 335.000000, 328.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][14], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][14], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][14], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][14], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][14], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][14], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][14], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][14], 0);

	InvBox[playerid][15] = CreatePlayerTextDraw(playerid, 155.000000, 385.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][15], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][15], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][15], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][15], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][15], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][15], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][15], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][15], 0);

	InvBox[playerid][16] = CreatePlayerTextDraw(playerid, 200.000000, 386.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][16], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][16], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][16], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][16], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][16], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][16], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][16], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][16], 0);

	InvBox[playerid][17] = CreatePlayerTextDraw(playerid, 245.000000, 386.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][17], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][17], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][17], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][17], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][17], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][17], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][17], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][17], 0);

	InvBox[playerid][18] = CreatePlayerTextDraw(playerid, 290.000000, 386.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][18], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][18], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][18], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][18], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][18], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][18], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][18], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][18], 0);

	InvBox[playerid][19] = CreatePlayerTextDraw(playerid, 335.000000, 386.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvBox[playerid][19], 4);
	PlayerTextDrawLetterSize(playerid, InvBox[playerid][19], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvBox[playerid][19], 41.500000, 12.000000);
	PlayerTextDrawSetOutline(playerid, InvBox[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, InvBox[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, InvBox[playerid][19], 1);
	PlayerTextDrawColor(playerid, InvBox[playerid][19], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, InvBox[playerid][19], -1962934017);
	PlayerTextDrawBoxColor(playerid, InvBox[playerid][19], 1687547186);
	PlayerTextDrawUseBox(playerid, InvBox[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, InvBox[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, InvBox[playerid][19], 0);

	InvName[playerid][0] = CreatePlayerTextDraw(playerid, 176.000000, 216.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][0], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][0], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][0], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][0], 0);
	PlayerTextDrawUseBox(playerid, InvName[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][0], 0);

	InvName[playerid][1] = CreatePlayerTextDraw(playerid, 221.000000, 216.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][1], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][1], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][1], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][1], 0);
	PlayerTextDrawUseBox(playerid, InvName[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][1], 0);

	InvName[playerid][2] = CreatePlayerTextDraw(playerid, 266.000000, 216.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][2], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][2], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][2], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][2], 0);
	PlayerTextDrawUseBox(playerid, InvName[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][2], 0);

	InvName[playerid][3] = CreatePlayerTextDraw(playerid, 311.000000, 216.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][3], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][3], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][3], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][3], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][3], 0);

	InvName[playerid][4] = CreatePlayerTextDraw(playerid, 356.000000, 216.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][4], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][4], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][4], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][4], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][4], 0);

	InvName[playerid][5] = CreatePlayerTextDraw(playerid, 176.000000, 271.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][5], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][5], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][5], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][5], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][5], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][5], 0);

	InvName[playerid][6] = CreatePlayerTextDraw(playerid, 221.000000, 271.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][6], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][6], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][6], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][6], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][6], 0);

	InvName[playerid][7] = CreatePlayerTextDraw(playerid, 266.000000, 271.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][7], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][7], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][7], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][7], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][7], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][7], 0);

	InvName[playerid][8] = CreatePlayerTextDraw(playerid, 311.000000, 271.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][8], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][8], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][8], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][8], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][8], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][8], 0);

	InvName[playerid][9] = CreatePlayerTextDraw(playerid, 356.000000, 271.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][9], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][9], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][9], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][9], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][9], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][9], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][9], 0);

	InvName[playerid][10] = CreatePlayerTextDraw(playerid, 176.000000, 328.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][10], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][10], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][10], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][10], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][10], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][10], 0);

	InvName[playerid][11] = CreatePlayerTextDraw(playerid, 221.000000, 328.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][11], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][11], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][11], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][11], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][11], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][11], 0);

	InvName[playerid][12] = CreatePlayerTextDraw(playerid, 266.000000, 328.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][12], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][12], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][12], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][12], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][12], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][12], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][12], 0);

	InvName[playerid][13] = CreatePlayerTextDraw(playerid, 311.000000, 328.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][13], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][13], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][13], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][13], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][13], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][13], 0);

	InvName[playerid][14] = CreatePlayerTextDraw(playerid, 356.000000, 328.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][14], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][14], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][14], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][14], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][14], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][14], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][14], 0);

	InvName[playerid][15] = CreatePlayerTextDraw(playerid, 176.000000, 386.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][15], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][15], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][15], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][15], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][15], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][15], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][15], 0);

	InvName[playerid][16] = CreatePlayerTextDraw(playerid, 221.000000, 386.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][16], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][16], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][16], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][16], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][16], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][16], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][16], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][16], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][16], 0);

	InvName[playerid][17] = CreatePlayerTextDraw(playerid, 266.000000, 386.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][17], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][17], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][17], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][17], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][17], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][17], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][17], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][17], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][17], 0);

	InvName[playerid][18] = CreatePlayerTextDraw(playerid, 311.000000, 386.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][18], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][18], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][18], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][18], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][18], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][18], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][18], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][18], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][18], 0);

	InvName[playerid][19] = CreatePlayerTextDraw(playerid, 355.500000, 386.000000, "Uang");
	PlayerTextDrawFont(playerid, InvName[playerid][19], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][19], 0.145833, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][19], 401.500000, 34.500000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][19], 2);
	PlayerTextDrawColor(playerid, InvName[playerid][19], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][19], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][19], 149);
	PlayerTextDrawUseBox(playerid, InvName[playerid][19], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][19], 0);

	InvValue[playerid][0] = CreatePlayerTextDraw(playerid, 158.000000, 176.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][0], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][0], 193.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][0], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][0], 0);

	InvValue[playerid][1] = CreatePlayerTextDraw(playerid, 204.000000, 176.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][1], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][1], 237.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][1], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][1], 0);

	InvValue[playerid][2] = CreatePlayerTextDraw(playerid, 248.000000, 176.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][2], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][2], 282.500000, 0.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][2], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][2], 0);

	InvValue[playerid][3] = CreatePlayerTextDraw(playerid, 293.000000, 176.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][3], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][3], 327.000000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][3], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][3], 0);

	InvValue[playerid][4] = CreatePlayerTextDraw(playerid, 339.000000, 176.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][4], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][4], 373.500000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][4], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][4], 0);

	InvValue[playerid][5] = CreatePlayerTextDraw(playerid, 158.000000, 235.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][5], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][5], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][5], 193.000000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][5], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][5], 0);

	InvValue[playerid][6] = CreatePlayerTextDraw(playerid, 203.000000, 235.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][6], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][6], 237.500000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][6], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][6], 0);

	InvValue[playerid][7] = CreatePlayerTextDraw(playerid, 249.000000, 235.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][7], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][7], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][7], 282.500000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][7], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][7], 0);

	InvValue[playerid][8] = CreatePlayerTextDraw(playerid, 292.000000, 235.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][8], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][8], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][8], 328.000000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][8], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][8], 0);

	InvValue[playerid][9] = CreatePlayerTextDraw(playerid, 338.000000, 235.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][9], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][9], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][9], 373.000000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][9], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][9], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][9], 0);

	InvValue[playerid][10] = CreatePlayerTextDraw(playerid, 158.000000, 293.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][10], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][10], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][10], 192.000000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][10], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][10], 0);

	InvValue[playerid][11] = CreatePlayerTextDraw(playerid, 204.000000, 293.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][11], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][11], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][11], 237.500000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][11], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][11], 0);

	InvValue[playerid][12] = CreatePlayerTextDraw(playerid, 249.000000, 293.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][12], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][12], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][12], 282.500000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][12], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][12], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][12], 0);

	InvValue[playerid][13] = CreatePlayerTextDraw(playerid, 293.000000, 293.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][13], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][13], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][13], 327.500000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][13], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][13], 0);

	InvValue[playerid][14] = CreatePlayerTextDraw(playerid, 338.000000, 293.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][14], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][14], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][14], 373.500000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][14], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][14], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][14], 0);

	InvValue[playerid][15] = CreatePlayerTextDraw(playerid, 158.000000, 349.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][15], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][15], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][15], 193.500000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][15], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][15], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][15], 0);

	InvValue[playerid][16] = CreatePlayerTextDraw(playerid, 203.000000, 349.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][16], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][16], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][16], 238.000000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][16], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][16], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][16], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][16], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][16], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][16], 0);

	InvValue[playerid][17] = CreatePlayerTextDraw(playerid, 249.000000, 349.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][17], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][17], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][17], 283.000000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][17], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][17], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][17], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][17], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][17], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][17], 0);

	InvValue[playerid][18] = CreatePlayerTextDraw(playerid, 293.000000, 349.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][18], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][18], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][18], 327.500000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][18], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][18], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][18], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][18], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][18], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][18], 0);

	InvValue[playerid][19] = CreatePlayerTextDraw(playerid, 338.000000, 349.000000, "10");
	PlayerTextDrawFont(playerid, InvValue[playerid][19], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][19], 0.183333, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][19], 373.000000, 5.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][19], 1);
	PlayerTextDrawColor(playerid, InvValue[playerid][19], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][19], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][19], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][19], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][19], 0);

	BarWeight[playerid] = CreatePlayerTextDraw(playerid, 181.000000, 153.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, BarWeight[playerid], 4);
	PlayerTextDrawLetterSize(playerid, BarWeight[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarWeight[playerid], 90.000000, 13.000000);
	PlayerTextDrawSetOutline(playerid, BarWeight[playerid], 1);
	PlayerTextDrawSetShadow(playerid, BarWeight[playerid], 0);
	PlayerTextDrawAlignment(playerid, BarWeight[playerid], 1);
	PlayerTextDrawColor(playerid, BarWeight[playerid], 1687547391);
	PlayerTextDrawBackgroundColor(playerid, BarWeight[playerid], 255);
	PlayerTextDrawBoxColor(playerid, BarWeight[playerid], 1687547186);
	PlayerTextDrawUseBox(playerid, BarWeight[playerid], 0);
	PlayerTextDrawSetProportional(playerid, BarWeight[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, BarWeight[playerid], 0);

	InvWeight[playerid] = CreatePlayerTextDraw(playerid, 330.000000, 155.000000, "9.0/50.0KG");
	PlayerTextDrawFont(playerid, InvWeight[playerid], 1);
	PlayerTextDrawLetterSize(playerid, InvWeight[playerid], 0.200000, 0.800000);
	PlayerTextDrawTextSize(playerid, InvWeight[playerid], 403.500000, 46.000000);
	PlayerTextDrawSetOutline(playerid, InvWeight[playerid], 1);
	PlayerTextDrawSetShadow(playerid, InvWeight[playerid], 0);
	PlayerTextDrawAlignment(playerid, InvWeight[playerid], 2);
	PlayerTextDrawColor(playerid, InvWeight[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, InvWeight[playerid], 255);
	PlayerTextDrawBoxColor(playerid, InvWeight[playerid], 0);
	PlayerTextDrawUseBox(playerid, InvWeight[playerid], 0);
	PlayerTextDrawSetProportional(playerid, InvWeight[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, InvWeight[playerid], 0);

	Ammount[playerid] = CreatePlayerTextDraw(playerid, 431.000000, 239.000000, "Ammount");
	PlayerTextDrawFont(playerid, Ammount[playerid], 1);
	PlayerTextDrawLetterSize(playerid, Ammount[playerid], 0.233333, 1.100000);
	PlayerTextDrawTextSize(playerid, Ammount[playerid], 409.500000, 60.500000);
	PlayerTextDrawSetOutline(playerid, Ammount[playerid], 1);
	PlayerTextDrawSetShadow(playerid, Ammount[playerid], 0);
	PlayerTextDrawAlignment(playerid, Ammount[playerid], 2);
	PlayerTextDrawColor(playerid, Ammount[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, Ammount[playerid], 255);
	PlayerTextDrawBoxColor(playerid, Ammount[playerid], 0);
	PlayerTextDrawUseBox(playerid, Ammount[playerid], 0);
	PlayerTextDrawSetProportional(playerid, Ammount[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Ammount[playerid], 0);
    return 1;
}

CreateInventoryTD()
{
    InvenTD[0] = TextDrawCreate(158.000000, 156.000000, "ld_dual:white");
	TextDrawFont(InvenTD[0], 4);
	TextDrawLetterSize(InvenTD[0], 0.600000, 2.000000);
	TextDrawTextSize(InvenTD[0], 15.500000, 10.500000);
	TextDrawSetOutline(InvenTD[0], 1);
	TextDrawSetShadow(InvenTD[0], 0);
	TextDrawAlignment(InvenTD[0], 1);
	TextDrawColor(InvenTD[0], -1);
	TextDrawBackgroundColor(InvenTD[0], 255);
	TextDrawBoxColor(InvenTD[0], 50);
	TextDrawUseBox(InvenTD[0], 1);
	TextDrawSetProportional(InvenTD[0], 1);
	TextDrawSetSelectable(InvenTD[0], 0);

	InvenTD[1] = TextDrawCreate(159.000000, 162.000000, "U");
	TextDrawFont(InvenTD[1], 1);
	TextDrawLetterSize(InvenTD[1], 0.629166, -1.749998);
	TextDrawTextSize(InvenTD[1], 400.000000, 17.000000);
	TextDrawSetOutline(InvenTD[1], 1);
	TextDrawSetShadow(InvenTD[1], 0);
	TextDrawAlignment(InvenTD[1], 1);
	TextDrawColor(InvenTD[1], -1);
	TextDrawBackgroundColor(InvenTD[1], 0);
	TextDrawBoxColor(InvenTD[1], 0);
	TextDrawUseBox(InvenTD[1], 1);
	TextDrawSetProportional(InvenTD[1], 1);
	TextDrawSetSelectable(InvenTD[1], 0);

	InvenTD[2] = TextDrawCreate(181.000000, 153.000000, "ld_dual:white");
	TextDrawFont(InvenTD[2], 4);
	TextDrawLetterSize(InvenTD[2], 0.600000, 2.000000);
	TextDrawTextSize(InvenTD[2], 180.000000, 13.000000);
	TextDrawSetOutline(InvenTD[2], 1);
	TextDrawSetShadow(InvenTD[2], 0);
	TextDrawAlignment(InvenTD[2], 1);
	TextDrawColor(InvenTD[2], 1296911741);
	TextDrawBackgroundColor(InvenTD[2], 255);
	TextDrawBoxColor(InvenTD[2], 1687547136);
	TextDrawUseBox(InvenTD[2], 1);
	TextDrawSetProportional(InvenTD[2], 1);
	TextDrawSetSelectable(InvenTD[2], 0);

	InvenTD[3] = TextDrawCreate(432.000000, 228.000000, "_");
	TextDrawFont(InvenTD[3], 1);
	TextDrawLetterSize(InvenTD[3], 0.600000, 14.650008);
	TextDrawTextSize(InvenTD[3], 298.500000, 75.000000);
	TextDrawSetOutline(InvenTD[3], 1);
	TextDrawSetShadow(InvenTD[3], 0);
	TextDrawAlignment(InvenTD[3], 2);
	TextDrawColor(InvenTD[3], -1);
	TextDrawBackgroundColor(InvenTD[3], 255);
	TextDrawBoxColor(InvenTD[3], 135);
	TextDrawUseBox(InvenTD[3], 1);
	TextDrawSetProportional(InvenTD[3], 1);
	TextDrawSetSelectable(InvenTD[3], 0);

	ClickAmmount = TextDrawCreate(398.000000, 235.000000, "ld_dual:white");
	TextDrawFont(ClickAmmount, 4);
	TextDrawLetterSize(ClickAmmount, 0.600000, 2.000000);
	TextDrawTextSize(ClickAmmount, 67.000000, 18.000000);
	TextDrawSetOutline(ClickAmmount, 1);
	TextDrawSetShadow(ClickAmmount, 0);
	TextDrawAlignment(ClickAmmount, 1);
	TextDrawColor(ClickAmmount, 1687547391);
	TextDrawBackgroundColor(ClickAmmount, 255);
	TextDrawBoxColor(ClickAmmount, 50);
	TextDrawUseBox(ClickAmmount, 1);
	TextDrawSetProportional(ClickAmmount, 1);
	TextDrawSetSelectable(ClickAmmount, 1);

	ClickUse = TextDrawCreate(398.000000, 261.000000, "ld_dual:white");
	TextDrawFont(ClickUse, 4);
	TextDrawLetterSize(ClickUse, 0.600000, 2.000000);
	TextDrawTextSize(ClickUse, 67.000000, 18.000000);
	TextDrawSetOutline(ClickUse, 1);
	TextDrawSetShadow(ClickUse, 0);
	TextDrawAlignment(ClickUse, 1);
	TextDrawColor(ClickUse, 1687547391);
	TextDrawBackgroundColor(ClickUse, 255);
	TextDrawBoxColor(ClickUse, 50);
	TextDrawUseBox(ClickUse, 1);
	TextDrawSetProportional(ClickUse, 1);
	TextDrawSetSelectable(ClickUse, 1);

	ClickGive = TextDrawCreate(398.000000, 287.000000, "ld_dual:white");
	TextDrawFont(ClickGive, 4);
	TextDrawLetterSize(ClickGive, 0.600000, 2.000000);
	TextDrawTextSize(ClickGive, 67.000000, 18.000000);
	TextDrawSetOutline(ClickGive, 1);
	TextDrawSetShadow(ClickGive, 0);
	TextDrawAlignment(ClickGive, 1);
	TextDrawColor(ClickGive, 1687547391);
	TextDrawBackgroundColor(ClickGive, 255);
	TextDrawBoxColor(ClickGive, 50);
	TextDrawUseBox(ClickGive, 1);
	TextDrawSetProportional(ClickGive, 1);
	TextDrawSetSelectable(ClickGive, 1);

	ClickDrop = TextDrawCreate(398.000000, 312.000000, "ld_dual:white");
	TextDrawFont(ClickDrop, 4);
	TextDrawLetterSize(ClickDrop, 0.600000, 2.000000);
	TextDrawTextSize(ClickDrop, 67.000000, 18.000000);
	TextDrawSetOutline(ClickDrop, 1);
	TextDrawSetShadow(ClickDrop, 0);
	TextDrawAlignment(ClickDrop, 1);
	TextDrawColor(ClickDrop, 1687547391);
	TextDrawBackgroundColor(ClickDrop, 255);
	TextDrawBoxColor(ClickDrop, 50);
	TextDrawUseBox(ClickDrop, 1);
	TextDrawSetProportional(ClickDrop, 1);
	TextDrawSetSelectable(ClickDrop, 1);

	ClickClose = TextDrawCreate(398.000000, 337.000000, "ld_dual:white");
	TextDrawFont(ClickClose, 4);
	TextDrawLetterSize(ClickClose, 0.600000, 2.000000);
	TextDrawTextSize(ClickClose, 67.000000, 18.000000);
	TextDrawSetOutline(ClickClose, 1);
	TextDrawSetShadow(ClickClose, 0);
	TextDrawAlignment(ClickClose, 1);
	TextDrawColor(ClickClose, 1687547391);
	TextDrawBackgroundColor(ClickClose, 255);
	TextDrawBoxColor(ClickClose, 50);
	TextDrawUseBox(ClickClose, 1);
	TextDrawSetProportional(ClickClose, 1);
	TextDrawSetSelectable(ClickClose, 1);

	InvenTD[4] = TextDrawCreate(431.000000, 265.000000, "Use");
	TextDrawFont(InvenTD[4], 1);
	TextDrawLetterSize(InvenTD[4], 0.233333, 1.100000);
	TextDrawTextSize(InvenTD[4], 409.500000, 60.500000);
	TextDrawSetOutline(InvenTD[4], 1);
	TextDrawSetShadow(InvenTD[4], 0);
	TextDrawAlignment(InvenTD[4], 2);
	TextDrawColor(InvenTD[4], -1);
	TextDrawBackgroundColor(InvenTD[4], 255);
	TextDrawBoxColor(InvenTD[4], 0);
	TextDrawUseBox(InvenTD[4], 1);
	TextDrawSetProportional(InvenTD[4], 1);
	TextDrawSetSelectable(InvenTD[4], 0);

	InvenTD[5] = TextDrawCreate(431.000000, 290.000000, "Give");
	TextDrawFont(InvenTD[5], 1);
	TextDrawLetterSize(InvenTD[5], 0.233333, 1.100000);
	TextDrawTextSize(InvenTD[5], 409.500000, 60.500000);
	TextDrawSetOutline(InvenTD[5], 1);
	TextDrawSetShadow(InvenTD[5], 0);
	TextDrawAlignment(InvenTD[5], 2);
	TextDrawColor(InvenTD[5], -1);
	TextDrawBackgroundColor(InvenTD[5], 255);
	TextDrawBoxColor(InvenTD[5], 0);
	TextDrawUseBox(InvenTD[5], 1);
	TextDrawSetProportional(InvenTD[5], 1);
	TextDrawSetSelectable(InvenTD[5], 0);

	InvenTD[6] = TextDrawCreate(431.000000, 316.000000, "Drop");
	TextDrawFont(InvenTD[6], 1);
	TextDrawLetterSize(InvenTD[6], 0.233333, 1.100000);
	TextDrawTextSize(InvenTD[6], 409.500000, 60.500000);
	TextDrawSetOutline(InvenTD[6], 1);
	TextDrawSetShadow(InvenTD[6], 0);
	TextDrawAlignment(InvenTD[6], 2);
	TextDrawColor(InvenTD[6], -1);
	TextDrawBackgroundColor(InvenTD[6], 255);
	TextDrawBoxColor(InvenTD[6], 0);
	TextDrawUseBox(InvenTD[6], 1);
	TextDrawSetProportional(InvenTD[6], 1);
	TextDrawSetSelectable(InvenTD[6], 0);

	InvenTD[7] = TextDrawCreate(431.000000, 341.000000, "Close");
	TextDrawFont(InvenTD[7], 1);
	TextDrawLetterSize(InvenTD[7], 0.233333, 1.100000);
	TextDrawTextSize(InvenTD[7], 409.500000, 60.500000);
	TextDrawSetOutline(InvenTD[7], 1);
	TextDrawSetShadow(InvenTD[7], 0);
	TextDrawAlignment(InvenTD[7], 2);
	TextDrawColor(InvenTD[7], -1);
	TextDrawBackgroundColor(InvenTD[7], 255);
	TextDrawBoxColor(InvenTD[7], 0);
	TextDrawUseBox(InvenTD[7], 1);
	TextDrawSetProportional(InvenTD[7], 1);
	TextDrawSetSelectable(InvenTD[7], 0);
	return 1;
}
