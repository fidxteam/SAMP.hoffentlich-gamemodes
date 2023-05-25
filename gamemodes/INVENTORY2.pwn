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
new PlayerText:DropTD[MAX_PLAYERS][22];
new PlayerText:DropName[MAX_PLAYERS][20];
new PlayerText:DropValue[MAX_PLAYERS][20];
new PlayerText:InvenTD[MAX_PLAYERS][26];
new PlayerText:ClickAmmount[MAX_PLAYERS];
new PlayerText:ClickUse[MAX_PLAYERS];
new PlayerText:ClickGive[MAX_PLAYERS];
new PlayerText:ClickDrop[MAX_PLAYERS];
new PlayerText:ClickClose[MAX_PLAYERS];
new PlayerText:Ammount[MAX_PLAYERS];
new PlayerText:Latar[MAX_PLAYERS];
new PlayerText:Hiasan[MAX_PLAYERS][4];
new PlayerText:DropModel[MAX_PLAYERS][20];
new PlayerText:InvModel[MAX_PLAYERS][20];
new PlayerText:InvBox[MAX_PLAYERS][20];
new PlayerText:InvLine[MAX_PLAYERS][20];
new PlayerText:InvName[MAX_PLAYERS][20];
new PlayerText:InvDura[MAX_PLAYERS][20];
new PlayerText:InvNama[MAX_PLAYERS];
new PlayerText:InvValue[MAX_PLAYERS][20];
new PlayerText:BarWeight[MAX_PLAYERS];
new PlayerText:BarWeight1[MAX_PLAYERS];
new PlayerText:BarBerat[MAX_PLAYERS];
new PlayerText:BarBerat1[MAX_PLAYERS];
new PlayerText:InvWeight[MAX_PLAYERS];
new PlayerText:InvBerat[MAX_PLAYERS];
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
	Float:invJangka,
	invWeapon,
	invAmmo,
	invSlot
};
new InventoryData[MAX_PLAYERS][MAX_INVENTORY][inventoryData];
new bool:InventoryOpen[MAX_PLAYERS], bool:GeledahOpen[MAX_PLAYERS], SelectInventory[MAX_PLAYERS], AmmountInventory[MAX_PLAYERS], Playergive[MAX_PLAYERS];
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
    {"Repair_Kit", 1010, 1.000, 50, true},
    {"Glock_17", 348, 0.150, 5, true},
    {"9mm", 2061, 0.050, 500, true},
    {"39mm", 2061, 0.050, 500, true},
    {"19mm", 2061, 0.050, 500, true},
    {"Buckshot", 2061, 0.050, 500, true},
    {"Silenced_Pistol", 347, 0.150, 5, true},
    {"Tazer", 347, 0.150, 5, true},
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
        cache_get_value_name_float(i, "invJangka", InventoryData[playerid][i][invJangka]);
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
			if(strcmp(item,"Colt45",true) == 0 || strcmp(item,"Desert_Eagle",true) == 0 || strcmp(item,"Silenced_Pistol",true) == 0 || strcmp(item,"Shotgun",true) == 0 || strcmp(item,"Ak47",true) == 0 || strcmp(item,"Mp5",true) == 0)
			{
                InventoryData[playerid][itemid][invSenjata] = 1;
			}
			InventoryData[playerid][itemid][invQuantity] = quantity;
			InventoryData[playerid][itemid][invWeapon] = weapon;
			InventoryData[playerid][itemid][invAmmo] = ammo;
			InventoryData[playerid][itemid][invSlot] = itemid;
            InventoryData[playerid][itemid][invJangka] = jangka;

			format(InventoryData[playerid][itemid][invItem], 64, "%s", item);
			format(string, sizeof(string), "INSERT INTO `inventory` (`ID`, `invItem`, `invModel`, `invQuantity`, `invSlot`) VALUES('%d', '%s', '%d', '%d', '%d')", pData[playerid][pID], item, model, quantity, itemid);
			mysql_tquery(g_SQL, string, "OnInventoryAdd", "dd", playerid, itemid);


			format(value_str, sizeof(value_str), "%dx", InventoryData[playerid][itemid][invQuantity]);
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
			    PlayerTextDrawShow(playerid, InvLine[playerid][itemid]);
				PlayerTextDrawShow(playerid, InvModel[playerid][itemid]);
				UpdateInventoryTD(playerid, itemid);
				Inventory_BarUpdate(playerid);
				
			}
			if(GeledahOpen[playerid])
			{
			    Geledah_BarUpdate(playerid, pData[playerid][pOranggeledah]);
				new orglain = pData[playerid][pOranggeledah];
				if(pData[playerid][pOranggeledah] != -1)
				{
				    format(string, sizeof(string), "%.3f/100KG", pData[orglain][pWeight]);
				    PlayerTextDrawSetString(playerid, InvBerat[playerid], string);
				    PlayerTextDrawShow(playerid, InvBerat[playerid]);
				}
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
		format(value_str, sizeof(value_str), "%dx", InventoryData[playerid][itemid][invQuantity]);
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
		if(GeledahOpen[playerid])
			{
			    Geledah_BarUpdate(playerid, pData[playerid][pOranggeledah]);
				new orglain = pData[playerid][pOranggeledah];
				if(pData[playerid][pOranggeledah] != -1)
				{
				    format(string, sizeof(string), "%.3f/100KG", pData[orglain][pWeight]);
				    PlayerTextDrawSetString(playerid, InvBerat[playerid], string);
				    PlayerTextDrawShow(playerid, InvBerat[playerid]);
				}
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
			    
			    PlayerTextDrawHide(playerid, InvDura[playerid][itemid]);
				PlayerTextDrawHide(playerid, InvName[playerid][itemid]);
    	        PlayerTextDrawHide(playerid, InvValue[playerid][itemid]);
				UpdateInventoryTD(playerid, itemid);
				Inventory_BarUpdate(playerid);
				
			}
			if(GeledahOpen[playerid])
			{
			    Geledah_BarUpdate(playerid, pData[playerid][pOranggeledah]);
				new orglain = pData[playerid][pOranggeledah];
				if(pData[playerid][pOranggeledah] != -1)
				{
				    format(string, sizeof(string), "%.3f/100KG", pData[orglain][pWeight]);
				    PlayerTextDrawSetString(playerid, InvBerat[playerid], string);
				    PlayerTextDrawShow(playerid, InvBerat[playerid]);
				}
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
			if(GeledahOpen[playerid])
			{
			    Geledah_BarUpdate(playerid, pData[playerid][pOranggeledah]);
				new orglain = pData[playerid][pOranggeledah];
				if(pData[playerid][pOranggeledah] != -1)
				{
				    format(string, sizeof(string), "%.3f/100KG", pData[orglain][pWeight]);
				    PlayerTextDrawSetString(playerid, InvBerat[playerid], string);
				    PlayerTextDrawShow(playerid, InvBerat[playerid]);
				}
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
    for(new inv = 0; inv<20; inv++) PlayerTextDrawShow(playerid, InvBox[playerid][inv]);
    //
    for(new inv = 0; inv<4; inv++) PlayerTextDrawShow(playerid, Hiasan[playerid][inv]);
    //Show Text
    for(new inv = 0; inv<26; inv++) PlayerTextDrawShow(playerid, InvenTD[playerid][inv]);
    for(new inv = 0; inv<22; inv++) PlayerTextDrawShow(playerid, DropTD[playerid][inv]);
    //Set UI Color
    //PlayerTextDrawColor(playerid, BarWeight[playerid], 1687547311);
	new nama[128];
	format(nama, sizeof nama, "%s", pData[playerid][pName]);
	PlayerTextDrawSetString(playerid, InvNama[playerid], nama);
	PlayerTextDrawShow(playerid, InvNama[playerid]);
    //Show Ammount, Use, Give, Drop, Close
    PlayerTextDrawShow(playerid, Latar[playerid]);
    PlayerTextDrawShow(playerid, ClickAmmount[playerid]);
	PlayerTextDrawShow(playerid, ClickUse[playerid]);
	PlayerTextDrawShow(playerid, ClickGive[playerid]);
	PlayerTextDrawShow(playerid, ClickDrop[playerid]);
	PlayerTextDrawShow(playerid, ClickClose[playerid]);
	PlayerTextDrawSetString(playerid, Ammount[playerid], "Ammount");
	PlayerTextDrawShow(playerid, Ammount[playerid]);
	//Show Weight
	AmmountInventory[playerid] = 1;
	SelectTextDraw(playerid, 0xFF0000FF);
	InventoryOpen[playerid] = true;

    new
        count = 0,
        id = Item_Nearest(playerid),
        otherid[1080];

    if (id != -1)
    {
        for (new i = 0; i < MAX_DROPPED_ITEMS; i ++) if (count < MAX_LISTED_ITEMS && DroppedItems[i][droppedModel] && IsPlayerInRangeOfPoint(playerid, 1.5, DroppedItems[i][droppedPos][0], DroppedItems[i][droppedPos][1], DroppedItems[i][droppedPos][2]) && GetPlayerInterior(playerid) == DroppedItems[i][droppedInt] && GetPlayerVirtualWorld(playerid) == DroppedItems[i][droppedWorld]) {
            NearestItems[playerid][count++] = i;
            PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][i], DroppedItems[i][droppedModel]);
            PlayerTextDrawSetString(playerid, DropName[playerid][i], DroppedItems[i][droppedItem]);
            new valuedrop[128];
            format(valuedrop, sizeof valuedrop, "%dx", DroppedItems[i][droppedQuantity]);
            PlayerTextDrawSetString(playerid, DropValue[playerid][i], valuedrop);
            PlayerTextDrawShow(playerid, DropModel[playerid][i]);
            PlayerTextDrawShow(playerid, DropName[playerid][i]);
            PlayerTextDrawShow(playerid, DropValue[playerid][i]);
        }

    }
    
    for (new i = 0; i < MAX_INVENTORY; i ++)
    {
        if(InventoryData[playerid][i][invSenjata] != 0)
        {
        	format(value_str, sizeof(value_str), "%dx", InventoryData[playerid][i][invQuantity]);
        	new Float:dura;
		
		    /*dura = InventoryData[playerid][i][invJangka] * 37.0/100;
			PlayerTextDrawTextSize(playerid,InvDura[playerid][i], dura, 2.0); *///Seusain in aja size nya sama di textdraw nya
			
		}
		else
        {
        	format(value_str, sizeof(value_str), "%dx", InventoryData[playerid][i][invQuantity]);
		}
        if(InventoryData[playerid][i][invWeapon] != 0) format(value_str, sizeof(value_str), "%d", InventoryData[playerid][i][invAmmo]);
		PlayerTextDrawSetString(playerid, InvName[playerid][i], InventoryData[playerid][i][invItem]);
		PlayerTextDrawSetString(playerid, InvValue[playerid][i], value_str);
        if (!InventoryData[playerid][i][invExists]) PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][i], 19300);
        else
        {
        	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][i], InventoryData[playerid][i][invModel]);
        	PlayerTextDrawShow(playerid, InvName[playerid][i]);
        	PlayerTextDrawShow(playerid, InvBox[playerid][i]);
        	PlayerTextDrawShow(playerid, InvLine[playerid][i]);
	    	PlayerTextDrawShow(playerid, InvValue[playerid][i]);
        }
        if(InventoryData[playerid][i][invSenjata] != 0)
        {
            //PlayerTextDrawShow(playerid, InvDura[playerid][i]);
		}
		new nama[128];
			format(nama, sizeof nama, "Drop");
			PlayerTextDrawSetString(playerid, DropTD[playerid][1], nama);
        PlayerTextDrawShow(playerid, InvModel[playerid][i]);
    }
    format(string, sizeof(string), "%.3f/100KG", pData[playerid][pWeight]);
    PlayerTextDrawSetString(playerid, InvWeight[playerid], string);
    PlayerTextDrawShow(playerid, InvWeight[playerid]);
    Inventory_BarUpdate(playerid);
	return 1;
}

function Geledah_Show(playerid)
{
	if (!IsPlayerConnected(playerid))
        return 0;

    static
        str[1080],
        string[128],
        value_str[128];

    format(str, sizeof(str), "Item Name\tItem Quantity\n");
    //Show Background
    for(new inv = 0; inv<20; inv++) PlayerTextDrawShow(playerid, InvBox[playerid][inv]);
    //
    for(new inv = 0; inv<4; inv++) PlayerTextDrawShow(playerid, Hiasan[playerid][inv]);
    //Show Text
    for(new inv = 0; inv<26; inv++) PlayerTextDrawShow(playerid, InvenTD[playerid][inv]);
    for(new inv = 0; inv<22; inv++) PlayerTextDrawShow(playerid, DropTD[playerid][inv]);
    //Set UI Color
    //PlayerTextDrawColor(playerid, BarWeight[playerid], 1687547311);
	new nama[128];
	format(nama, sizeof nama, "%s", pData[playerid][pName]);
	PlayerTextDrawSetString(playerid, InvNama[playerid], nama);
	PlayerTextDrawShow(playerid, InvNama[playerid]);
    //Show Ammount, Use, Give, Drop, Close
    PlayerTextDrawShow(playerid, Latar[playerid]);
    PlayerTextDrawShow(playerid, ClickAmmount[playerid]);
	PlayerTextDrawShow(playerid, ClickUse[playerid]);
	PlayerTextDrawShow(playerid, ClickGive[playerid]);
	PlayerTextDrawShow(playerid, ClickDrop[playerid]);
	PlayerTextDrawShow(playerid, ClickClose[playerid]);
	PlayerTextDrawSetString(playerid, Ammount[playerid], "Ammount");
	PlayerTextDrawShow(playerid, Ammount[playerid]);
	//Show Weight
	AmmountInventory[playerid] = 1;
	SelectTextDraw(playerid, 0xFF0000FF);
	InventoryOpen[playerid] = true;
	GeledahOpen[playerid] = true;

    new
        count = 0,
        id = Item_Nearest(playerid),
        otherid[1080];

    for (new i = 0; i < MAX_INVENTORY; i ++)
    {
        if(InventoryData[playerid][i][invSenjata] != 0)
        {
        	format(value_str, sizeof(value_str), "%dx", InventoryData[playerid][i][invQuantity]);
        	new Float:dura;

		    /*dura = InventoryData[playerid][i][invJangka] * 37.0/100;
			PlayerTextDrawTextSize(playerid,InvDura[playerid][i], dura, 2.0); *///Seusain in aja size nya sama di textdraw nya

		}
		else
        {
        	format(value_str, sizeof(value_str), "%dx", InventoryData[playerid][i][invQuantity]);
		}
        if(InventoryData[playerid][i][invWeapon] != 0) format(value_str, sizeof(value_str), "%d", InventoryData[playerid][i][invAmmo]);
		PlayerTextDrawSetString(playerid, InvName[playerid][i], InventoryData[playerid][i][invItem]);
		PlayerTextDrawSetString(playerid, InvValue[playerid][i], value_str);
        if (!InventoryData[playerid][i][invExists]) PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][i], 19300);
        else
        {
        	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][i], InventoryData[playerid][i][invModel]);
        	PlayerTextDrawShow(playerid, InvName[playerid][i]);
        	PlayerTextDrawShow(playerid, InvBox[playerid][i]);
        	PlayerTextDrawShow(playerid, InvLine[playerid][i]);
	    	PlayerTextDrawShow(playerid, InvValue[playerid][i]);
        }
        if(InventoryData[playerid][i][invSenjata] != 0)
        {
            //PlayerTextDrawShow(playerid, InvDura[playerid][i]);
		}
        PlayerTextDrawShow(playerid, InvModel[playerid][i]);
        //geledah
        //geledah
        foreach(new otherid : Player) if(IsPlayerConnected(otherid) && NearPlayer(playerid, otherid, 2) && otherid != playerid)
		{
		    pData[playerid][pOranggeledah] = otherid;
		    new string[128];
		    format(string, sizeof(string), "Menggeledah %s", pData[otherid][pName]);
			UpdateDynamic3DTextLabelText(pData[playerid][pGeledahLabel], COLOR_WHITE, string);
	    	if(InventoryData[otherid][i][invSenjata] != 0)
	        {
	        	format(value_str, sizeof(value_str), "%dx", InventoryData[otherid][i][invQuantity]);
	        	new Float:dura;

			    /*dura = InventoryData[playerid][i][invJangka] * 37.0/100;
				PlayerTextDrawTextSize(playerid,InvDura[playerid][i], dura, 2.0); *///Seusain in aja size nya sama di textdraw nya

			}
			else
	        {
	        	format(value_str, sizeof(value_str), "%dx", InventoryData[otherid][i][invQuantity]);
			}
	        if(InventoryData[otherid][i][invWeapon] != 0) format(value_str, sizeof(value_str), "%d", InventoryData[otherid][i][invAmmo]);
			PlayerTextDrawSetString(playerid, DropName[playerid][i], InventoryData[otherid][i][invItem]);
			PlayerTextDrawSetString(playerid, DropValue[playerid][i], value_str);
	        if (!InventoryData[otherid][i][invExists]) PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][i], 19300);
	        else
	        {
	        	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][i], InventoryData[otherid][i][invModel]);
	        	PlayerTextDrawShow(playerid, DropName[playerid][i]);
		    	PlayerTextDrawShow(playerid, DropValue[playerid][i]);
	        }
	        if(InventoryData[otherid][i][invSenjata] != 0)
	        {
	            //PlayerTextDrawShow(playerid, InvDura[playerid][i]);
			}
			new nama[128];
			format(nama, sizeof nama, "%s", pData[otherid][pName]);
			PlayerTextDrawSetString(playerid, DropTD[playerid][1], nama);
	        PlayerTextDrawShow(playerid, DropModel[playerid][i]);
		}
    }
    format(string, sizeof(string), "%.3f/100KG", pData[playerid][pWeight]);
    PlayerTextDrawSetString(playerid, InvWeight[playerid], string);
    PlayerTextDrawShow(playerid, InvWeight[playerid]);
	new orglain = pData[playerid][pOranggeledah];
    format(string, sizeof(string), "%.3f/100KG", pData[orglain][pWeight]);
    PlayerTextDrawSetString(playerid, InvBerat[playerid], string);
    PlayerTextDrawShow(playerid, InvBerat[playerid]);
    Inventory_BarUpdate(playerid);
   	Geledah_BarUpdate(playerid, pData[playerid][pOranggeledah]);
	return 1;
}
function HideBackPackDialog(playerid)
{
    new nama[128];
			format(nama, sizeof nama, "Drop");
			PlayerTextDrawSetString(playerid, DropTD[playerid][1], nama);
    //Hide Background
    for(new inv = 0; inv<20; inv++) PlayerTextDrawHide(playerid, InvBox[playerid][inv]);
    for(new inv = 0; inv<20; inv++) PlayerTextDrawHide(playerid, InvLine[playerid][inv]);
    //hide
    for(new inv = 0; inv<4; inv++) PlayerTextDrawHide(playerid, Hiasan[playerid][inv]);
    //Hide Text
    for(new inv = 0; inv<26; inv++) PlayerTextDrawHide(playerid, InvenTD[playerid][inv]);
    for(new inv = 0; inv<22; inv++) PlayerTextDrawHide(playerid, DropTD[playerid][inv]);
    for(new inv = 0; inv<20; inv++) PlayerTextDrawHide(playerid, DropModel[playerid][inv]);
    for(new inv = 0; inv<20; inv++) PlayerTextDrawHide(playerid, DropName[playerid][inv]);
    for(new inv = 0; inv<20; inv++) PlayerTextDrawHide(playerid, DropValue[playerid][inv]);
    //Hide Ammount, Use, Give, Drop, Close
    PlayerTextDrawHide(playerid, Latar[playerid]);
    PlayerTextDrawHide(playerid, Ammount[playerid]);
	PlayerTextDrawHide(playerid, ClickAmmount[playerid]);
	PlayerTextDrawHide(playerid, ClickUse[playerid]);
	PlayerTextDrawHide(playerid, ClickGive[playerid]);
	PlayerTextDrawHide(playerid, ClickDrop[playerid]);
	PlayerTextDrawHide(playerid, ClickClose[playerid]);
	//Hide Weight
	PlayerTextDrawHide(playerid, InvNama[playerid]);
	PlayerTextDrawHide(playerid, InvWeight[playerid]);
	PlayerTextDrawHide(playerid, BarWeight[playerid]);
	PlayerTextDrawHide(playerid, BarWeight1[playerid]);
	PlayerTextDrawHide(playerid, InvBerat[playerid]);
	PlayerTextDrawHide(playerid, BarBerat[playerid]);
	PlayerTextDrawHide(playerid, BarBerat1[playerid]);
	for (new i = 0; i < MAX_INVENTORY; i ++)
    {
    	PlayerTextDrawHide(playerid, InvName[playerid][i]);
    	PlayerTextDrawHide(playerid, InvValue[playerid][i]);
        PlayerTextDrawHide(playerid, InvModel[playerid][i]);
    }
    SelectInventory[playerid] = -1;
    pData[playerid][pItemid] = -1;
	AmmountInventory[playerid] = -1;
	pData[playerid][pOranggeledah] = -1;
	InventoryOpen[playerid] = false;
	GeledahOpen[playerid] = false;
    CancelSelectTextDraw(playerid);
    return 1;
}
stock Inventory_BarUpdate(playerid)
{
	new value = floatround(pData[playerid][pWeight]);
	if(value < 0) value = 0, pData[playerid][pWeight] = 0;
	PlayerTextDrawTextSize(playerid, BarWeight[playerid], value * 192 / 50, 5.000000);
	PlayerTextDrawShow(playerid, BarWeight1[playerid]);
	PlayerTextDrawShow(playerid, BarWeight[playerid]);
}

stock Geledah_BarUpdate(playerid, otherid)
{
	new value = floatround(pData[otherid][pWeight]);
	if(value < 0) value = 0, pData[otherid][pWeight] = 0;
	PlayerTextDrawTextSize(playerid, BarBerat[playerid], value * 192 / 50, 5.000000);
	PlayerTextDrawShow(playerid, BarBerat1[playerid]);
	PlayerTextDrawShow(playerid, BarBerat[playerid]);
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
		PlayerTextDrawHide(playerid, DropModel[playerid][itemid]);
		PlayerTextDrawHide(playerid, DropName[playerid][itemid]);
		PlayerTextDrawHide(playerid, DropValue[playerid][itemid]);
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

CMD:geledah(playerid, params[])
{

	Geledah_Show(playerid);
	return 1;
}
//Inventory Items
CMD:tdinven(playerid)
{
	Inventory_Show(playerid);
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
	format(value_str, sizeof(value_str), "%dx", InventoryData[playerid][itemid][invQuantity]);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][itemid], InventoryData[playerid][itemid][invModel]);
	
	if(InventoryData[playerid][itemid][invSenjata] != 0)
        {
        	new Float:dura;
		
		    /*dura = InventoryData[playerid][itemid][invJangka] * 37.0/100;
			PlayerTextDrawTextSize(playerid,InvDura[playerid][itemid], dura, 2.0); //Seusain in aja size nya sama di textdraw nya
			PlayerTextDrawShow(playerid, InvDura[playerid][itemid]);*/
		}

	if(InventoryData[playerid][itemid][invModel] == 19300)
	{
    	PlayerTextDrawHide(playerid, InvName[playerid][itemid]);
    	PlayerTextDrawHide(playerid, InvLine[playerid][itemid]);
		PlayerTextDrawHide(playerid, InvValue[playerid][itemid]);
	}
	else
	{
		PlayerTextDrawShow(playerid, InvName[playerid][itemid]);
		PlayerTextDrawShow(playerid, InvLine[playerid][itemid]);
	    PlayerTextDrawShow(playerid, InvValue[playerid][itemid]);
	}
	PlayerTextDrawSetString(playerid, InvName[playerid][itemid], InventoryData[playerid][itemid][invItem]);
	PlayerTextDrawSetString(playerid, InvValue[playerid][itemid], value_str);
	PlayerTextDrawSetString(playerid, InvWeight[playerid], string);

	PlayerTextDrawShow(playerid, InvModel[playerid][itemid]);
    PlayerTextDrawShow(playerid, InvWeight[playerid]);

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
	if(!strcmp(name,"Repair_Kit",true))
	{
	    if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		return Error(playerid, "You must not driver a vehicle engine.");

		new Mobilrepair = GetNearestVehicleToPlayer(playerid);
		
		if(Mobilrepair == INVALID_VEHICLE_ID)
   		return Error(playerid, "Kamu tidak berada didekat Kendaraan apapun.");
   		
		if(!IsEngineVehicle(Mobilrepair))
	            return Error(playerid, "You are not in engine vehicle.");

		if(GetEngineStatus(Mobilrepair))
						return Error(playerid, "Turn off vehicle engine.");

		if(pData[playerid][pSedangrepair] > 0)
			return Error(playerid, "You already repair vehicle. please wait!");
			
		pData[playerid][pSedangrepair] = 1;
		pData[playerid][pIdrepair] = Mobilrepair;
		ShowProgressbar(playerid, "Repair...", 30);
		pData[playerid][pTimerrepair] = SetTimerEx("Repairkit", 30000, false, "i", playerid);
  		Inventory_Remove(playerid, "Repair_Kit", 1);
	}
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
			ShowBoxTd(playerid, "Equiped", "Colt45", 346, 1);
		}
		if(!strcmp(name,"Silenced_Pistol",true))
		{
			//Inventory_Remove(playerid, "Silenced_Pistol", 1);
            pData[playerid][pGuntazer] = 0;
            ShowBoxTd(playerid, "Equiped", "Silenced", 347, 1);
			GivePlayerWeaponEx(playerid, 23, 99999);
		}
		if(!strcmp(name,"Tazer",true))
		{
			//Inventory_Remove(playerid, "Silenced_Pistol", 1);
			pData[playerid][pGuntazer] = 1;
			ShowBoxTd(playerid, "Equiped", "Tazer", 347, 1);
			GivePlayerWeaponEx(playerid, 23, 99999);
		}
		if(!strcmp(name,"Desert_Eagle",true))
		{
			//Inventory_Remove(playerid, "Desert_Eagle", 1);
            ShowBoxTd(playerid, "Equiped", "Deagle", 348, 1);
			GivePlayerWeaponEx(playerid, 24, 99999);
		}
		if(!strcmp(name,"Shotgun",true))
		{
			//Inventory_Remove(playerid, "Shotgun", 1);
			ShowBoxTd(playerid, "Equiped", "Shotgun", 349, 1);

			GivePlayerWeaponEx(playerid, 25, 99999);
		}
		if(!strcmp(name,"Ak47",true))
		{
			//Inventory_Remove(playerid, "Ak47", 1);
			ShowBoxTd(playerid, "Equiped", "Ak47", 355, 1);

			GivePlayerWeaponEx(playerid, 30, 99999);
		}
		if(!strcmp(name,"Mp5",true))
		{
			//Inventory_Remove(playerid, "Mp5", 1);
			ShowBoxTd(playerid, "Equiped", "Mp5", 353, 1);

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
			//Inventory_Remove(playerid, InventoryData[playerid][itemid][invItem], 1);

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
			ShowProgressbar(playerid, "Using Obat...", 8);
			SetTimerEx("OnPlayerUseItem", 8000, false, "ds", playerid, "Obat");

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
	if(InventoryOpen[playerid])
	{
	    new
        count = 0,
        id = Item_Nearest(playerid),
        otherid[1080];

	    if (id != -1)
	    {
			for(new i = 0; i<20; i++) if(playertextid == DropModel[playerid][i])
			{
	            new itemid = NearestItems[playerid][i];
				PickupItem(playerid, itemid);
			}
		}
	}
	if(GeledahOpen[playerid])
	{
	    new
        count = 0,
        id = pData[playerid][pOranggeledah];
        new value = AmmountInventory[playerid];
	    if (id != -1)
	    {
			for(new i = 0; i<20; i++) if(playertextid == DropModel[playerid][i])
			{
			    new value_str[128];
			    if(InventoryData[id][i][invSenjata] != 0)
		        {
		        	format(value_str, sizeof(value_str), "%dx", InventoryData[id][i][invQuantity]);
		        	new Float:dura;

				    /*dura = InventoryData[playerid][i][invJangka] * 37.0/100;
					PlayerTextDrawTextSize(playerid,InvDura[playerid][i], dura, 2.0); *///Seusain in aja size nya sama di textdraw nya

				}
				else
		        {
		        	format(value_str, sizeof(value_str), "%dx", InventoryData[id][i][invQuantity]);
				}
				PlayerTextDrawSetString(playerid, DropValue[playerid][i], value_str);
			    if(InventoryData[id][i][invQuantity] <= 1)
			    {
			        PlayerTextDrawHide(playerid, DropModel[playerid][i]);
					PlayerTextDrawHide(playerid, DropName[playerid][i]);
					PlayerTextDrawHide(playerid, DropValue[playerid][i]);
				}
			    Inventory_Add(playerid, InventoryData[id][i][invItem], InventoryData[id][i][invModel], value);
	            Inventory_Remove(id, InventoryData[id][i][invItem], value);
			}
		}
	}
	if(InventoryOpen[playerid])
	{
		if(playertextid == ClickUse[playerid])
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
		if(playertextid == ClickGive[playerid])
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
		if(playertextid == ClickAmmount[playerid])
		{
			if(SelectInventory[playerid] == -1) return Error(playerid, "Silahkan pilih item yang ingin digunakan!");
			ShowPlayerDialog(playerid, INVENTORY_AMOUNT, DIALOG_STYLE_INPUT, "Ammount:", "Silahkan Masukkan Jumlah Yang Ingin Anda\nBerikan, Gunakan Atau Drop:", "Input", "Close");
			return 1;
		}
		if(playertextid == ClickClose[playerid])
		{
			HideBackPackDialog(playerid);
			SelectInventory[playerid] = -1;
			AmmountInventory[playerid] = -1;
			InventoryOpen[playerid] = false;
			UpdateDynamic3DTextLabelText(pData[playerid][pGeledahLabel], COLOR_ORANGE, "");
		}
		if(playertextid == ClickDrop[playerid])
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
			Inventory_Add(p2, InventoryData[playerid][itemid][invItem], InventoryData[playerid][itemid][invModel], value);
            Inventory_Remove(playerid, InventoryData[playerid][itemid][invItem], value);
			//Inventory_Set(p2, InventoryData[playerid][itemid][invItem], InventoryData[playerid][itemid][invModel], value);
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
	//iven
	

   //Inventory
    DropValue[playerid][0] = CreatePlayerTextDraw(playerid, 411.000000, 100.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][0], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][0], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][0], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][0], 0);

	DropValue[playerid][1] = CreatePlayerTextDraw(playerid, 451.000000, 100.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][1], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][1], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][1], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][1], 0);

	DropValue[playerid][2] = CreatePlayerTextDraw(playerid, 491.000000, 100.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][2], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][2], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][2], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][2], 0);

	DropValue[playerid][3] = CreatePlayerTextDraw(playerid, 531.000000, 100.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][3], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][3], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][3], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][3], 0);

	DropValue[playerid][4] = CreatePlayerTextDraw(playerid, 566.000000, 100.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][4], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][4], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][4], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][4], 0);

	DropValue[playerid][5] = CreatePlayerTextDraw(playerid, 411.000000, 163.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][5], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][5], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][5], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][5], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][5], 0);

	DropValue[playerid][6] = CreatePlayerTextDraw(playerid, 451.000000, 163.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][6], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][6], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][6], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][6], 0);

	DropValue[playerid][7] = CreatePlayerTextDraw(playerid, 491.000000, 163.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][7], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][7], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][7], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][7], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][7], 0);

	DropValue[playerid][8] = CreatePlayerTextDraw(playerid, 531.000000, 163.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][8], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][8], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][8], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][8], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][8], 0);

	DropValue[playerid][9] = CreatePlayerTextDraw(playerid, 566.000000, 163.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][9], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][9], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][9], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][9], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][9], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][9], 0);

	DropValue[playerid][10] = CreatePlayerTextDraw(playerid, 411.000000, 226.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][10], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][10], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][10], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][10], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][10], 0);

	DropValue[playerid][11] = CreatePlayerTextDraw(playerid, 451.000000, 226.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][11], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][11], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][11], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][11], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][11], 0);

	DropValue[playerid][12] = CreatePlayerTextDraw(playerid, 491.000000, 226.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][12], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][12], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][12], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][12], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][12], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][12], 0);

	DropValue[playerid][13] = CreatePlayerTextDraw(playerid, 531.000000, 226.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][13], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][13], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][13], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][13], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][13], 0);

	DropValue[playerid][14] = CreatePlayerTextDraw(playerid, 566.000000, 226.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][14], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][14], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][14], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][14], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][14], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][14], 0);

	DropValue[playerid][15] = CreatePlayerTextDraw(playerid, 411.000000, 289.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][15], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][15], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][15], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][15], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][15], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][15], 0);

	DropValue[playerid][16] = CreatePlayerTextDraw(playerid, 451.000000, 289.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][16], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][16], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][16], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][16], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][16], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][16], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][16], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][16], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][16], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][16], 0);

	DropValue[playerid][17] = CreatePlayerTextDraw(playerid, 491.000000, 289.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][17], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][17], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][17], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][17], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][17], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][17], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][17], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][17], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][17], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][17], 0);

	DropValue[playerid][18] = CreatePlayerTextDraw(playerid, 531.000000, 289.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][18], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][18], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][18], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][18], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][18], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][18], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][18], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][18], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][18], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][18], 0);

	DropValue[playerid][19] = CreatePlayerTextDraw(playerid, 566.000000, 289.000000, "111x");
	PlayerTextDrawFont(playerid, DropValue[playerid][19], 1);
	PlayerTextDrawLetterSize(playerid, DropValue[playerid][19], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropValue[playerid][19], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropValue[playerid][19], 0);
	PlayerTextDrawSetShadow(playerid, DropValue[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, DropValue[playerid][19], 3);
	PlayerTextDrawColor(playerid, DropValue[playerid][19], -1);
	PlayerTextDrawBackgroundColor(playerid, DropValue[playerid][19], 255);
	PlayerTextDrawBoxColor(playerid, DropValue[playerid][19], 50);
	PlayerTextDrawUseBox(playerid, DropValue[playerid][19], 0);
	PlayerTextDrawSetProportional(playerid, DropValue[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, DropValue[playerid][19], 0);
	
    DropName[playerid][0] = CreatePlayerTextDraw(playerid, 377.000000, 152.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][0], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][0], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][0], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][0], 0);

	DropName[playerid][1] = CreatePlayerTextDraw(playerid, 416.000000, 152.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][1], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][1], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][1], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][1], 0);

	DropName[playerid][2] = CreatePlayerTextDraw(playerid, 455.000000, 152.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][2], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][2], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][2], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][2], 0);

	DropName[playerid][3] = CreatePlayerTextDraw(playerid, 494.000000, 152.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][3], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][3], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][3], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][3], 0);

	DropName[playerid][4] = CreatePlayerTextDraw(playerid, 533.000000, 152.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][4], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][4], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][4], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][4], 0);

	DropName[playerid][5] = CreatePlayerTextDraw(playerid, 377.000000, 213.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][5], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][5], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][5], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][5], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][5], 0);

	DropName[playerid][6] = CreatePlayerTextDraw(playerid, 416.000000, 213.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][6], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][6], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][6], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][6], 0);

	DropName[playerid][7] = CreatePlayerTextDraw(playerid, 455.000000, 213.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][7], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][7], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][7], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][7], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][7], 0);

	DropName[playerid][8] = CreatePlayerTextDraw(playerid, 494.000000, 213.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][8], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][8], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][8], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][8], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][8], 0);

	DropName[playerid][9] = CreatePlayerTextDraw(playerid, 533.000000, 213.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][9], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][9], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][9], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][9], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][9], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][9], 0);

	DropName[playerid][10] = CreatePlayerTextDraw(playerid, 377.000000, 274.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][10], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][10], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][10], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][10], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][10], 0);

	DropName[playerid][11] = CreatePlayerTextDraw(playerid, 416.000000, 274.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][11], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][11], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][11], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][11], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][11], 0);

	DropName[playerid][12] = CreatePlayerTextDraw(playerid, 455.000000, 274.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][12], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][12], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][12], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][12], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][12], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][12], 0);

	DropName[playerid][13] = CreatePlayerTextDraw(playerid, 494.000000, 274.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][13], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][13], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][13], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][13], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][13], 0);

	DropName[playerid][14] = CreatePlayerTextDraw(playerid, 533.000000, 274.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][14], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][14], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][14], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][14], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][14], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][14], 0);

	DropName[playerid][15] = CreatePlayerTextDraw(playerid, 377.000000, 335.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][15], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][15], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][15], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][15], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][15], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][15], 0);

	DropName[playerid][16] = CreatePlayerTextDraw(playerid, 416.000000, 335.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][16], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][16], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][16], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][16], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][16], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][16], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][16], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][16], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][16], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][16], 0);

	DropName[playerid][17] = CreatePlayerTextDraw(playerid, 455.000000, 335.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][17], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][17], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][17], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][17], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][17], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][17], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][17], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][17], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][17], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][17], 0);

	DropName[playerid][18] = CreatePlayerTextDraw(playerid, 494.000000, 335.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][18], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][18], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][18], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][18], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][18], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][18], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][18], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][18], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][18], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][18], 0);

	DropName[playerid][19] = CreatePlayerTextDraw(playerid, 533.000000, 335.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, DropName[playerid][19], 1);
	PlayerTextDrawLetterSize(playerid, DropName[playerid][19], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, DropName[playerid][19], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, DropName[playerid][19], 0);
	PlayerTextDrawSetShadow(playerid, DropName[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, DropName[playerid][19], 1);
	PlayerTextDrawColor(playerid, DropName[playerid][19], -1);
	PlayerTextDrawBackgroundColor(playerid, DropName[playerid][19], 255);
	PlayerTextDrawBoxColor(playerid, DropName[playerid][19], 50);
	PlayerTextDrawUseBox(playerid, DropName[playerid][19], 0);
	PlayerTextDrawSetProportional(playerid, DropName[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, DropName[playerid][19], 0);
	
    DropTD[playerid][0] = CreatePlayerTextDraw(playerid, 370.000000, 75.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][0], 202.000000, 350.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][0], 522268415);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][0], 0);

	DropTD[playerid][1] = CreatePlayerTextDraw(playerid, 375.000000, 81.000000, "Drop");
	PlayerTextDrawFont(playerid, DropTD[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][1], 0.170000, 1.299998);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][1], 30.000000, 7.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][1], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][1], 0);

	DropTD[playerid][2] = CreatePlayerTextDraw(playerid, 375.000000, 103.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][2], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][2], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][2], 0);

	DropTD[playerid][3] = CreatePlayerTextDraw(playerid, 413.500000, 103.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][3], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][3], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][3], 0);

	DropTD[playerid][4] = CreatePlayerTextDraw(playerid, 452.000000, 103.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][4], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][4], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][4], 0);

	DropTD[playerid][5] = CreatePlayerTextDraw(playerid, 491.000000, 103.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][5], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][5], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][5], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][5], 0);

	DropTD[playerid][6] = CreatePlayerTextDraw(playerid, 529.500000, 103.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][6], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][6], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][6], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][6], 0);

	DropTD[playerid][7] = CreatePlayerTextDraw(playerid, 375.000000, 164.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][7], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][7], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][7], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][7], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][7], 0);

	DropTD[playerid][8] = CreatePlayerTextDraw(playerid, 413.500000, 164.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][8], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][8], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][8], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][8], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][8], 0);

	DropTD[playerid][9] = CreatePlayerTextDraw(playerid, 452.000000, 164.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][9], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][9], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][9], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][9], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][9], 0);

	DropTD[playerid][10] = CreatePlayerTextDraw(playerid, 491.000000, 164.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][10], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][10], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][10], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][10], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][10], 0);

	DropTD[playerid][11] = CreatePlayerTextDraw(playerid, 529.500000, 164.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][11], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][11], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][11], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][11], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][11], 0);

	DropTD[playerid][12] = CreatePlayerTextDraw(playerid, 375.000000, 225.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][12], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][12], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][12], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][12], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][12], 0);

	DropTD[playerid][13] = CreatePlayerTextDraw(playerid, 413.500000, 225.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][13], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][13], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][13], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][13], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][13], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][13], 0);

	DropTD[playerid][14] = CreatePlayerTextDraw(playerid, 452.000000, 225.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][14], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][14], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][14], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][14], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][14], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][14], 0);

	DropTD[playerid][15] = CreatePlayerTextDraw(playerid, 491.000000, 225.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][15], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][15], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][15], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][15], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][15], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][15], 0);

	DropTD[playerid][16] = CreatePlayerTextDraw(playerid, 529.500000, 225.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][16], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][16], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][16], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][16], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][16], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][16], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][16], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][16], 0);

	DropTD[playerid][17] = CreatePlayerTextDraw(playerid, 375.000000, 286.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][17], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][17], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][17], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][17], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][17], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][17], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][17], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][17], 0);

	DropTD[playerid][18] = CreatePlayerTextDraw(playerid, 413.500000, 286.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][18], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][18], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][18], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][18], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][18], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][18], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][18], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][18], 0);

	DropTD[playerid][19] = CreatePlayerTextDraw(playerid, 452.000000, 286.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][19], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][19], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][19], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][19], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][19], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][19], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][19], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][19], 0);

	DropTD[playerid][20] = CreatePlayerTextDraw(playerid, 491.000000, 286.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][20], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][20], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][20], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][20], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][20], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][20], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][20], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][20], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][20], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][20], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][20], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][20], 0);

	DropTD[playerid][21] = CreatePlayerTextDraw(playerid, 529.500000, 286.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropTD[playerid][21], 4);
	PlayerTextDrawLetterSize(playerid, DropTD[playerid][21], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropTD[playerid][21], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, DropTD[playerid][21], 1);
	PlayerTextDrawSetShadow(playerid, DropTD[playerid][21], 0);
	PlayerTextDrawAlignment(playerid, DropTD[playerid][21], 1);
	PlayerTextDrawColor(playerid, DropTD[playerid][21], 859129087);
	PlayerTextDrawBackgroundColor(playerid, DropTD[playerid][21], 255);
	PlayerTextDrawBoxColor(playerid, DropTD[playerid][21], 50);
	PlayerTextDrawUseBox(playerid, DropTD[playerid][21], 1);
	PlayerTextDrawSetProportional(playerid, DropTD[playerid][21], 1);
	PlayerTextDrawSetSelectable(playerid, DropTD[playerid][21], 0);
	
	DropModel[playerid][0] = CreatePlayerTextDraw(playerid, 382.000000, 105.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][0], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][0], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][0], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][0], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][0], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][0], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][0], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][0], 1, 1);

	DropModel[playerid][1] = CreatePlayerTextDraw(playerid, 420.500000, 105.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][1], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][1], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][1], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][1], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][1], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][1], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][1], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][1], 1, 1);

	DropModel[playerid][2] = CreatePlayerTextDraw(playerid, 459.000000, 105.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][2], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][2], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][2], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][2], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][2], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][2], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][2], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][2], 1, 1);

	DropModel[playerid][3] = CreatePlayerTextDraw(playerid, 497.500000, 105.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][3], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][3], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][3], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][3], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][3], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][3], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][3], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][3], 1, 1);

	DropModel[playerid][4] = CreatePlayerTextDraw(playerid, 536.000000, 105.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][4], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][4], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][4], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][4], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][4], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][4], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][4], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][4], 1, 1);

	DropModel[playerid][5] = CreatePlayerTextDraw(playerid, 382.000000, 166.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][5], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][5], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][5], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][5], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][5], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][5], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][5], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][5], 1, 1);

	DropModel[playerid][6] = CreatePlayerTextDraw(playerid, 420.500000, 166.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][6], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][6], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][6], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][6], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][6], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][6], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][6], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][6], 1, 1);

	DropModel[playerid][7] = CreatePlayerTextDraw(playerid, 459.000000, 166.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][7], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][7], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][7], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][7], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][7], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][7], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][7], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][7], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][7], 1, 1);

	DropModel[playerid][8] = CreatePlayerTextDraw(playerid, 497.500000, 166.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][8], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][8], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][8], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][8], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][8], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][8], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][8], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][8], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][8], 1, 1);

	DropModel[playerid][9] = CreatePlayerTextDraw(playerid, 536.000000, 166.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][9], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][9], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][9], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][9], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][9], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][9], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][9], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][9], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][9], 1, 1);

	DropModel[playerid][10] = CreatePlayerTextDraw(playerid, 382.000000, 227.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][10], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][10], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][10], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][10], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][10], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][10], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][10], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][10], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][10], 1, 1);

	DropModel[playerid][11] = CreatePlayerTextDraw(playerid, 420.500000, 227.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][11], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][11], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][11], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][11], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][11], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][11], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][11], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][11], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][11], 1, 1);

	DropModel[playerid][12] = CreatePlayerTextDraw(playerid, 459.000000, 227.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][12], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][12], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][12], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][12], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][12], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][12], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][12], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][12], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][12], 1, 1);

	DropModel[playerid][13] = CreatePlayerTextDraw(playerid, 497.500000, 227.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][13], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][13], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][13], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][13], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][13], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][13], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][13], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][13], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][13], 1, 1);

	DropModel[playerid][14] = CreatePlayerTextDraw(playerid, 536.000000, 227.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][14], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][14], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][14], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][14], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][14], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][14], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][14], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][14], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][14], 1, 1);

	DropModel[playerid][15] = CreatePlayerTextDraw(playerid, 382.000000, 288.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][15], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][15], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][15], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][15], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][15], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][15], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][15], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][15], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][15], 1, 1);

	DropModel[playerid][16] = CreatePlayerTextDraw(playerid, 420.500000, 288.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][16], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][16], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][16], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][16], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][16], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][16], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][16], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][16], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][16], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][16], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][16], 1, 1);

	DropModel[playerid][17] = CreatePlayerTextDraw(playerid, 459.000000, 288.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][17], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][17], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][17], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][17], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][17], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][17], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][17], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][17], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][17], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][17], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][17], 1, 1);

	DropModel[playerid][18] = CreatePlayerTextDraw(playerid, 497.500000, 288.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][18], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][18], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][18], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][18], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][18], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][18], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][18], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][18], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][18], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][18], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][18], 1, 1);

	DropModel[playerid][19] = CreatePlayerTextDraw(playerid, 536.000000, 288.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, DropModel[playerid][19], 5);
	PlayerTextDrawLetterSize(playerid, DropModel[playerid][19], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, DropModel[playerid][19], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, DropModel[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, DropModel[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, DropModel[playerid][19], 1);
	PlayerTextDrawColor(playerid, DropModel[playerid][19], -1);
	PlayerTextDrawBackgroundColor(playerid, DropModel[playerid][19], 0);
	PlayerTextDrawBoxColor(playerid, DropModel[playerid][19], 50);
	PlayerTextDrawUseBox(playerid, DropModel[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, DropModel[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, DropModel[playerid][19], 1);
	PlayerTextDrawSetPreviewModel(playerid, DropModel[playerid][19], 2880);
	PlayerTextDrawSetPreviewRot(playerid, DropModel[playerid][19], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, DropModel[playerid][19], 1, 1);
	/*InvDura[playerid][10] = CreatePlayerTextDraw(playerid, 85.000000, 271.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][10], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][10], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][10], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][10], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][10], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][10], 0);

	InvDura[playerid][11] = CreatePlayerTextDraw(playerid, 124.000000, 271.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][11], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][11], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][11], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][11], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][11], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][11], 0);

	InvDura[playerid][12] = CreatePlayerTextDraw(playerid, 163.000000, 271.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][12], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][12], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][12], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][12], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][12], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][12], 0);

	InvDura[playerid][13] = CreatePlayerTextDraw(playerid, 202.000000, 271.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][13], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][13], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][13], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][13], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][13], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][13], 0);

	InvDura[playerid][14] = CreatePlayerTextDraw(playerid, 241.000000, 271.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][14], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][14], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][14], 36.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][14], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][14], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][14], 0);

	InvDura[playerid][15] = CreatePlayerTextDraw(playerid, 85.000000, 330.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][15], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][15], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][15], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][15], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][15], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][15], 0);

	InvDura[playerid][16] = CreatePlayerTextDraw(playerid, 124.000000, 330.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][16], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][16], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][16], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][16], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][16], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][16], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][16], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][16], 0);

	InvDura[playerid][17] = CreatePlayerTextDraw(playerid, 163.000000, 330.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][17], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][17], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][17], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][17], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][17], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][17], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][17], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][17], 0);

	InvDura[playerid][18] = CreatePlayerTextDraw(playerid, 202.000000, 330.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][18], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][18], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][18], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][18], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][18], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][18], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][18], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][18], 0);

	InvDura[playerid][19] = CreatePlayerTextDraw(playerid, 241.000000, 330.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][19], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][19], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][19], 36.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][19], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][19], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][19], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][19], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][19], 0);*/
	
	InvModel[playerid][0] = CreatePlayerTextDraw(playerid, 92.000000, 105.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][0], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][0], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][0], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][0], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][0], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][0], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][0], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][0], 1, 1);

	InvModel[playerid][1] = CreatePlayerTextDraw(playerid, 130.500000, 105.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][1], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][1], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][1], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][1], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][1], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][1], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][1], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][1], 1, 1);

	InvModel[playerid][2] = CreatePlayerTextDraw(playerid, 169.000000, 105.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][2], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][2], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][2], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][2], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][2], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][2], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][2], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][2], 1, 1);

	InvModel[playerid][3] = CreatePlayerTextDraw(playerid, 207.500000, 105.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][3], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][3], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][3], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][3], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][3], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][3], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][3], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][3], 1, 1);

	InvModel[playerid][4] = CreatePlayerTextDraw(playerid, 246.000000, 105.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][4], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][4], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][4], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][4], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][4], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][4], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][4], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][4], 1, 1);

	InvModel[playerid][5] = CreatePlayerTextDraw(playerid, 92.000000, 165.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][5], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][5], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][5], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][5], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][5], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][5], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][5], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][5], 1, 1);

	InvModel[playerid][6] = CreatePlayerTextDraw(playerid, 130.500000, 165.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][6], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][6], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][6], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][6], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][6], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][6], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][6], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][6], 1, 1);

	InvModel[playerid][7] = CreatePlayerTextDraw(playerid, 169.000000, 165.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][7], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][7], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][7], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][7], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][7], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][7], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][7], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][7], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][7], 1, 1);

	InvModel[playerid][8] = CreatePlayerTextDraw(playerid, 207.500000, 165.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][8], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][8], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][8], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][8], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][8], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][8], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][8], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][8], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][8], 1, 1);

	InvModel[playerid][9] = CreatePlayerTextDraw(playerid, 246.000000, 165.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][9], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][9], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][9], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][9], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][9], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][9], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][9], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][9], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][9], 1, 1);

	InvModel[playerid][10] = CreatePlayerTextDraw(playerid, 92.000000, 225.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][10], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][10], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][10], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][10], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][10], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][10], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][10], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][10], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][10], 1, 1);

	InvModel[playerid][11] = CreatePlayerTextDraw(playerid, 130.500000, 225.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][11], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][11], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][11], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][11], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][11], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][11], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][11], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][11], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][11], 1, 1);

	InvModel[playerid][12] = CreatePlayerTextDraw(playerid, 169.000000, 225.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][12], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][12], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][12], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][12], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][12], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][12], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][12], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][12], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][12], 1, 1);

	InvModel[playerid][13] = CreatePlayerTextDraw(playerid, 207.500000, 225.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][13], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][13], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][13], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][13], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][13], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][13], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][13], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][13], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][13], 1, 1);

	InvModel[playerid][14] = CreatePlayerTextDraw(playerid, 246.000000, 225.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][14], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][14], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][14], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][14], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][14], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][14], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][14], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][14], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][14], 1, 1);

	InvModel[playerid][15] = CreatePlayerTextDraw(playerid, 92.000000, 285.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][15], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][15], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][15], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][15], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][15], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][15], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][15], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][15], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][15], 1, 1);

	InvModel[playerid][16] = CreatePlayerTextDraw(playerid, 130.500000, 285.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][16], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][16], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][16], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][16], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][16], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][16], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][16], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][16], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][16], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][16], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][16], 1, 1);

	InvModel[playerid][17] = CreatePlayerTextDraw(playerid, 169.000000, 285.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][17], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][17], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][17], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][17], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][17], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][17], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][17], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][17], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][17], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][17], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][17], 1, 1);

	InvModel[playerid][18] = CreatePlayerTextDraw(playerid, 207.500000, 285.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][18], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][18], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][18], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][18], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][18], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][18], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][18], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][18], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][18], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][18], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][18], 1, 1);

	InvModel[playerid][19] = CreatePlayerTextDraw(playerid, 246.000000, 285.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvModel[playerid][19], 5);
	PlayerTextDrawLetterSize(playerid, InvModel[playerid][19], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvModel[playerid][19], 30.000000, 45.000000);
	PlayerTextDrawSetOutline(playerid, InvModel[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, InvModel[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, InvModel[playerid][19], 1);
	PlayerTextDrawColor(playerid, InvModel[playerid][19], -1);
	PlayerTextDrawBackgroundColor(playerid, InvModel[playerid][19], 0);
	PlayerTextDrawBoxColor(playerid, InvModel[playerid][19], 50);
	PlayerTextDrawUseBox(playerid, InvModel[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, InvModel[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, InvModel[playerid][19], 1);
	PlayerTextDrawSetPreviewModel(playerid, InvModel[playerid][19], 2880);
	PlayerTextDrawSetPreviewRot(playerid, InvModel[playerid][19], -10.000000, 0.000000, -20.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, InvModel[playerid][19], 1, 1);

	InvLine[playerid][0] = CreatePlayerTextDraw(playerid, 85.000000, 153.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][0], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][0], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][0], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][0], 0);

	InvLine[playerid][1] = CreatePlayerTextDraw(playerid, 124.000000, 153.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][1], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][1], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][1], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][1], 0);

	InvLine[playerid][2] = CreatePlayerTextDraw(playerid, 163.000000, 153.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][2], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][2], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][2], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][2], 0);

	InvLine[playerid][3] = CreatePlayerTextDraw(playerid, 202.000000, 153.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][3], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][3], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][3], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][3], 0);

	InvLine[playerid][4] = CreatePlayerTextDraw(playerid, 241.000000, 153.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][4], 36.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][4], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][4], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][4], 0);

	InvLine[playerid][5] = CreatePlayerTextDraw(playerid, 85.000000, 214.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][5], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][5], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][5], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][5], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][5], 0);

	InvLine[playerid][6] = CreatePlayerTextDraw(playerid, 124.000000, 214.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][6], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][6], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][6], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][6], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][6], 0);

	InvLine[playerid][7] = CreatePlayerTextDraw(playerid, 163.000000, 214.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][7], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][7], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][7], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][7], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][7], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][7], 0);

	InvLine[playerid][8] = CreatePlayerTextDraw(playerid, 202.000000, 214.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][8], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][8], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][8], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][8], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][8], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][8], 0);

	InvLine[playerid][9] = CreatePlayerTextDraw(playerid, 241.000000, 214.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][9], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][9], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][9], 36.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][9], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][9], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][9], 0);

	InvLine[playerid][10] = CreatePlayerTextDraw(playerid, 85.000000, 275.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][10], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][10], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][10], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][10], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][10], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][10], 0);

	InvLine[playerid][11] = CreatePlayerTextDraw(playerid, 124.000000, 275.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][11], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][11], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][11], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][11], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][11], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][11], 0);

	InvLine[playerid][12] = CreatePlayerTextDraw(playerid, 163.000000, 275.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][12], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][12], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][12], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][12], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][12], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][12], 0);

	InvLine[playerid][13] = CreatePlayerTextDraw(playerid, 202.000000, 275.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][13], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][13], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][13], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][13], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][13], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][13], 0);

	InvLine[playerid][14] = CreatePlayerTextDraw(playerid, 241.000000, 275.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][14], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][14], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][14], 36.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][14], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][14], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][14], 0);

	InvLine[playerid][15] = CreatePlayerTextDraw(playerid, 85.000000, 336.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][15], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][15], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][15], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][15], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][15], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][15], 0);

	InvLine[playerid][16] = CreatePlayerTextDraw(playerid, 124.000000, 336.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][16], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][16], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][16], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][16], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][16], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][16], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][16], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][16], 0);

	InvLine[playerid][17] = CreatePlayerTextDraw(playerid, 163.000000, 336.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][17], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][17], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][17], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][17], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][17], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][17], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][17], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][17], 0);

	InvLine[playerid][18] = CreatePlayerTextDraw(playerid, 202.000000, 336.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][18], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][18], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][18], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][18], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][18], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][18], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][18], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][18], 0);

	InvLine[playerid][19] = CreatePlayerTextDraw(playerid, 241.000000, 336.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvLine[playerid][19], 4);
	PlayerTextDrawLetterSize(playerid, InvLine[playerid][19], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvLine[playerid][19], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvLine[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, InvLine[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, InvLine[playerid][19], 1);
	PlayerTextDrawColor(playerid, InvLine[playerid][19], 1296911871);
	PlayerTextDrawBackgroundColor(playerid, InvLine[playerid][19], 255);
	PlayerTextDrawBoxColor(playerid, InvLine[playerid][19], 50);
	PlayerTextDrawUseBox(playerid, InvLine[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, InvLine[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, InvLine[playerid][19], 0);


 	InvName[playerid][0] = CreatePlayerTextDraw(playerid, 86.000000, 152.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][0], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][0], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][0], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][0], 0);

	InvName[playerid][1] = CreatePlayerTextDraw(playerid, 125.000000, 152.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][1], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][1], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][1], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][1], 0);

	InvName[playerid][2] = CreatePlayerTextDraw(playerid, 164.000000, 152.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][2], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][2], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][2], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][2], 0);

	InvName[playerid][3] = CreatePlayerTextDraw(playerid, 203.000000, 152.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][3], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][3], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][3], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][3], 0);

	InvName[playerid][4] = CreatePlayerTextDraw(playerid, 242.000000, 152.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][4], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][4], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][4], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][4], 0);

	InvName[playerid][5] = CreatePlayerTextDraw(playerid, 86.000000, 213.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][5], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][5], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][5], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][5], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][5], 0);

	InvName[playerid][6] = CreatePlayerTextDraw(playerid, 125.000000, 213.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][6], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][6], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][6], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][6], 0);

	InvName[playerid][7] = CreatePlayerTextDraw(playerid, 164.000000, 213.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][7], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][7], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][7], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][7], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][7], 0);

	InvName[playerid][8] = CreatePlayerTextDraw(playerid, 203.000000, 213.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][8], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][8], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][8], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][8], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][8], 0);

	InvName[playerid][9] = CreatePlayerTextDraw(playerid, 242.000000, 213.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][9], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][9], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][9], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][9], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][9], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][9], 0);

	InvName[playerid][10] = CreatePlayerTextDraw(playerid, 86.000000, 274.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][10], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][10], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][10], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][10], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][10], 0);

	InvName[playerid][11] = CreatePlayerTextDraw(playerid, 125.000000, 274.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][11], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][11], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][11], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][11], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][11], 0);

	InvName[playerid][12] = CreatePlayerTextDraw(playerid, 164.000000, 274.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][12], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][12], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][12], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][12], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][12], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][12], 0);

	InvName[playerid][13] = CreatePlayerTextDraw(playerid, 203.000000, 274.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][13], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][13], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][13], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][13], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][13], 0);

	InvName[playerid][14] = CreatePlayerTextDraw(playerid, 242.000000, 274.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][14], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][14], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][14], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][14], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][14], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][14], 0);

	InvName[playerid][15] = CreatePlayerTextDraw(playerid, 86.000000, 335.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][15], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][15], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][15], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][15], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][15], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][15], 0);

	InvName[playerid][16] = CreatePlayerTextDraw(playerid, 125.000000, 335.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][16], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][16], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][16], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][16], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][16], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][16], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][16], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][16], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][16], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][16], 0);

	InvName[playerid][17] = CreatePlayerTextDraw(playerid, 164.000000, 335.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][17], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][17], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][17], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][17], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][17], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][17], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][17], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][17], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][17], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][17], 0);

	InvName[playerid][18] = CreatePlayerTextDraw(playerid, 203.000000, 335.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][18], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][18], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][18], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][18], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][18], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][18], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][18], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][18], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][18], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][18], 0);

	InvName[playerid][19] = CreatePlayerTextDraw(playerid, 242.000000, 335.000000, "Desert_Eagle");
	PlayerTextDrawFont(playerid, InvName[playerid][19], 1);
	PlayerTextDrawLetterSize(playerid, InvName[playerid][19], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvName[playerid][19], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvName[playerid][19], 0);
	PlayerTextDrawSetShadow(playerid, InvName[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, InvName[playerid][19], 1);
	PlayerTextDrawColor(playerid, InvName[playerid][19], -1);
	PlayerTextDrawBackgroundColor(playerid, InvName[playerid][19], 255);
	PlayerTextDrawBoxColor(playerid, InvName[playerid][19], 50);
	PlayerTextDrawUseBox(playerid, InvName[playerid][19], 0);
	PlayerTextDrawSetProportional(playerid, InvName[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, InvName[playerid][19], 0);

	InvNama[playerid] = CreatePlayerTextDraw(playerid, 85.000000, 81.000000, "Oggi_Hernanda");
	PlayerTextDrawFont(playerid, InvNama[playerid], 1);
	PlayerTextDrawLetterSize(playerid, InvNama[playerid], 0.170000, 1.299998);
	PlayerTextDrawTextSize(playerid, InvNama[playerid], 30.000000, 7.000000);
	PlayerTextDrawSetOutline(playerid, InvNama[playerid], 0);
	PlayerTextDrawSetShadow(playerid, InvNama[playerid], 0);
	PlayerTextDrawAlignment(playerid, InvNama[playerid], 1);
	PlayerTextDrawColor(playerid, InvNama[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, InvNama[playerid], 255);
	PlayerTextDrawBoxColor(playerid, InvNama[playerid], 50);
	PlayerTextDrawUseBox(playerid, InvNama[playerid], 0);
	PlayerTextDrawSetProportional(playerid, InvNama[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, InvNama[playerid], 0);

    BarWeight1[playerid] = CreatePlayerTextDraw(playerid, 85.000000, 95.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, BarWeight1[playerid], 4);
	PlayerTextDrawLetterSize(playerid, BarWeight1[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarWeight1[playerid], 192.000000, 6.000000);
	PlayerTextDrawSetOutline(playerid, BarWeight1[playerid], 1);
	PlayerTextDrawSetShadow(playerid, BarWeight1[playerid], 0);
	PlayerTextDrawAlignment(playerid, BarWeight1[playerid], 1);
	PlayerTextDrawColor(playerid, BarWeight1[playerid], 255);
	PlayerTextDrawBackgroundColor(playerid, BarWeight1[playerid], 255);
	PlayerTextDrawBoxColor(playerid, BarWeight1[playerid], 50);
	PlayerTextDrawUseBox(playerid, BarWeight1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, BarWeight1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, BarWeight1[playerid], 0);
	
	BarWeight[playerid] = CreatePlayerTextDraw(playerid, 85.000000, 95.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, BarWeight[playerid], 4);
	PlayerTextDrawLetterSize(playerid, BarWeight[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarWeight[playerid], 192.000000, 5.000000);
	PlayerTextDrawSetOutline(playerid, BarWeight[playerid], 1);
	PlayerTextDrawSetShadow(playerid, BarWeight[playerid], 0);
	PlayerTextDrawAlignment(playerid, BarWeight[playerid], 1);
	PlayerTextDrawColor(playerid, BarWeight[playerid], 201063167);
	PlayerTextDrawBackgroundColor(playerid, BarWeight[playerid], 255);
	PlayerTextDrawBoxColor(playerid, BarWeight[playerid], 50);
	PlayerTextDrawUseBox(playerid, BarWeight[playerid], 1);
	PlayerTextDrawSetProportional(playerid, BarWeight[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, BarWeight[playerid], 0);

	InvWeight[playerid] = CreatePlayerTextDraw(playerid, 245.000000, 81.000000, "100.0/100.0KG");
	PlayerTextDrawFont(playerid, InvWeight[playerid], 1);
	PlayerTextDrawLetterSize(playerid, InvWeight[playerid], 0.170000, 1.299998);
	PlayerTextDrawTextSize(playerid, InvWeight[playerid], 30.000000, 7.000000);
	PlayerTextDrawSetOutline(playerid, InvWeight[playerid], 0);
	PlayerTextDrawSetShadow(playerid, InvWeight[playerid], 0);
	PlayerTextDrawAlignment(playerid, InvWeight[playerid], 1);
	PlayerTextDrawColor(playerid, InvWeight[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, InvWeight[playerid], 255);
	PlayerTextDrawBoxColor(playerid, InvWeight[playerid], 50);
	PlayerTextDrawUseBox(playerid, InvWeight[playerid], 0);
	PlayerTextDrawSetProportional(playerid, InvWeight[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, InvWeight[playerid], 0);
	
	BarBerat1[playerid] = CreatePlayerTextDraw(playerid, 375.000000, 95.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, BarBerat1[playerid], 4);
	PlayerTextDrawLetterSize(playerid, BarBerat1[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarBerat1[playerid], 192.000000, 6.000000);
	PlayerTextDrawSetOutline(playerid, BarBerat1[playerid], 1);
	PlayerTextDrawSetShadow(playerid, BarBerat1[playerid], 0);
	PlayerTextDrawAlignment(playerid, BarBerat1[playerid], 1);
	PlayerTextDrawColor(playerid, BarBerat1[playerid], 255);
	PlayerTextDrawBackgroundColor(playerid, BarBerat1[playerid], 255);
	PlayerTextDrawBoxColor(playerid, BarBerat1[playerid], 50);
	PlayerTextDrawUseBox(playerid, BarBerat1[playerid], 1);
	PlayerTextDrawSetProportional(playerid, BarBerat1[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, BarBerat1[playerid], 0);

	BarBerat[playerid] = CreatePlayerTextDraw(playerid, 375.000000, 95.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, BarBerat[playerid], 4);
	PlayerTextDrawLetterSize(playerid, BarBerat[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, BarBerat[playerid], 192.000000, 5.000000);
	PlayerTextDrawSetOutline(playerid, BarBerat[playerid], 1);
	PlayerTextDrawSetShadow(playerid, BarBerat[playerid], 0);
	PlayerTextDrawAlignment(playerid, BarBerat[playerid], 1);
	PlayerTextDrawColor(playerid, BarBerat[playerid], 201063167);
	PlayerTextDrawBackgroundColor(playerid, BarBerat[playerid], 255);
	PlayerTextDrawBoxColor(playerid, BarBerat[playerid], 50);
	PlayerTextDrawUseBox(playerid, BarBerat[playerid], 1);
	PlayerTextDrawSetProportional(playerid, BarBerat[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, BarBerat[playerid], 0);
	
	InvBerat[playerid] = CreatePlayerTextDraw(playerid, 567.000000, 81.000000, "100.0/20000KG");
	PlayerTextDrawFont(playerid, InvBerat[playerid], 1);
	PlayerTextDrawLetterSize(playerid, InvBerat[playerid], 0.170000, 1.299998);
	PlayerTextDrawTextSize(playerid, InvBerat[playerid], 30.000000, 7.000000);
	PlayerTextDrawSetOutline(playerid, InvBerat[playerid], 0);
	PlayerTextDrawSetShadow(playerid, InvBerat[playerid], 0);
	PlayerTextDrawAlignment(playerid, InvBerat[playerid], 3);
	PlayerTextDrawColor(playerid, InvBerat[playerid], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, InvBerat[playerid], 255);
	PlayerTextDrawBoxColor(playerid, InvBerat[playerid], 50);
	PlayerTextDrawUseBox(playerid, InvBerat[playerid], 0);
	PlayerTextDrawSetProportional(playerid, InvBerat[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, InvBerat[playerid], 0);

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
	
	InvDura[playerid][0] = CreatePlayerTextDraw(playerid, 85.000000, 153.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][0], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][0], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][0], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][0], 0);

	InvDura[playerid][1] = CreatePlayerTextDraw(playerid, 124.000000, 153.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][1], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][1], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][1], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][1], 0);

	InvDura[playerid][2] = CreatePlayerTextDraw(playerid, 163.000000, 153.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][2], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][2], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][2], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][2], 0);

	InvDura[playerid][3] = CreatePlayerTextDraw(playerid, 202.000000, 153.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][3], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][3], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][3], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][3], 0);

	InvDura[playerid][4] = CreatePlayerTextDraw(playerid, 241.000000, 153.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][4], 36.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][4], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][4], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][4], 0);

	InvDura[playerid][5] = CreatePlayerTextDraw(playerid, 85.000000, 212.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][5], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][5], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][5], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][5], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][5], 0);

	InvDura[playerid][6] = CreatePlayerTextDraw(playerid, 124.000000, 212.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][6], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][6], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][6], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][6], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][6], 0);

	InvDura[playerid][7] = CreatePlayerTextDraw(playerid, 163.000000, 212.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][7], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][7], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][7], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][7], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][7], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][7], 0);

	InvDura[playerid][8] = CreatePlayerTextDraw(playerid, 202.000000, 212.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][8], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][8], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][8], 37.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][8], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][8], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][8], 0);

	InvDura[playerid][9] = CreatePlayerTextDraw(playerid, 241.000000, 212.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvDura[playerid][9], 4);
	PlayerTextDrawLetterSize(playerid, InvDura[playerid][9], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvDura[playerid][9], 36.000000, 2.000000);
	PlayerTextDrawSetOutline(playerid, InvDura[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, InvDura[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, InvDura[playerid][9], 1);
	PlayerTextDrawColor(playerid, InvDura[playerid][9], 16711935);
	PlayerTextDrawBackgroundColor(playerid, InvDura[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, InvDura[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, InvDura[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, InvDura[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, InvDura[playerid][9], 0);
	
	InvValue[playerid][0] = CreatePlayerTextDraw(playerid, 121.000000, 100.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][0], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][0], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][0], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][0], 0);

	InvValue[playerid][1] = CreatePlayerTextDraw(playerid, 161.000000, 100.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][1], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][1], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][1], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][1], 0);

	InvValue[playerid][2] = CreatePlayerTextDraw(playerid, 200.000000, 100.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][2], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][2], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][2], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][2], 0);

	InvValue[playerid][3] = CreatePlayerTextDraw(playerid, 239.000000, 100.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][3], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][3], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][3], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][3], 0);

	InvValue[playerid][4] = CreatePlayerTextDraw(playerid, 275.000000, 100.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][4], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][4], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][4], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][4], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][4], 0);

	InvValue[playerid][5] = CreatePlayerTextDraw(playerid, 121.000000, 165.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][5], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][5], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][5], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][5], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][5], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][5], 0);

	InvValue[playerid][6] = CreatePlayerTextDraw(playerid, 161.000000, 165.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][6], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][6], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][6], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][6], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][6], 0);

	InvValue[playerid][7] = CreatePlayerTextDraw(playerid, 200.000000, 165.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][7], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][7], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][7], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][7], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][7], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][7], 0);

	InvValue[playerid][8] = CreatePlayerTextDraw(playerid, 239.000000, 165.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][8], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][8], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][8], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][8], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][8], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][8], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][8], 0);

	InvValue[playerid][9] = CreatePlayerTextDraw(playerid, 275.000000, 165.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][9], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][9], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][9], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][9], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][9], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][9], 0);

	InvValue[playerid][10] = CreatePlayerTextDraw(playerid, 121.000000, 225.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][10], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][10], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][10], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][10], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][10], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][10], 0);

	InvValue[playerid][11] = CreatePlayerTextDraw(playerid, 161.000000, 225.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][11], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][11], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][11], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][11], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][11], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][11], 0);

	InvValue[playerid][12] = CreatePlayerTextDraw(playerid, 200.000000, 225.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][12], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][12], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][12], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][12], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][12], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][12], 0);

	InvValue[playerid][13] = CreatePlayerTextDraw(playerid, 239.000000, 225.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][13], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][13], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][13], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][13], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][13], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][13], 0);

	InvValue[playerid][14] = CreatePlayerTextDraw(playerid, 275.000000, 225.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][14], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][14], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][14], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][14], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][14], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][14], 0);

	InvValue[playerid][15] = CreatePlayerTextDraw(playerid, 121.000000, 285.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][15], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][15], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][15], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][15], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][15], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][15], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][15], 0);

	InvValue[playerid][16] = CreatePlayerTextDraw(playerid, 161.000000, 285.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][16], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][16], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][16], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][16], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][16], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][16], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][16], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][16], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][16], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][16], 0);

	InvValue[playerid][17] = CreatePlayerTextDraw(playerid, 200.000000, 285.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][17], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][17], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][17], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][17], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][17], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][17], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][17], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][17], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][17], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][17], 0);

	InvValue[playerid][18] = CreatePlayerTextDraw(playerid, 239.000000, 285.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][18], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][18], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][18], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][18], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][18], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][18], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][18], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][18], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][18], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][18], 0);

	InvValue[playerid][19] = CreatePlayerTextDraw(playerid, 275.000000, 285.000000, "111x");
	PlayerTextDrawFont(playerid, InvValue[playerid][19], 1);
	PlayerTextDrawLetterSize(playerid, InvValue[playerid][19], 0.170000, 1.000000);
	PlayerTextDrawTextSize(playerid, InvValue[playerid][19], 37.000000, 8.000000);
	PlayerTextDrawSetOutline(playerid, InvValue[playerid][19], 0);
	PlayerTextDrawSetShadow(playerid, InvValue[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, InvValue[playerid][19], 3);
	PlayerTextDrawColor(playerid, InvValue[playerid][19], -1);
	PlayerTextDrawBackgroundColor(playerid, InvValue[playerid][19], 255);
	PlayerTextDrawBoxColor(playerid, InvValue[playerid][19], 50);
	PlayerTextDrawUseBox(playerid, InvValue[playerid][19], 0);
	PlayerTextDrawSetProportional(playerid, InvValue[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, InvValue[playerid][19], 0);
	
	Latar[playerid] = CreatePlayerTextDraw(playerid, 285.000000, 150.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, Latar[playerid], 4);
	PlayerTextDrawLetterSize(playerid, Latar[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, Latar[playerid], 80.000000, 170.000000);
	PlayerTextDrawSetOutline(playerid, Latar[playerid], 1);
	PlayerTextDrawSetShadow(playerid, Latar[playerid], 0);
	PlayerTextDrawAlignment(playerid, Latar[playerid], 1);
	PlayerTextDrawColor(playerid, Latar[playerid], 522268360);
	PlayerTextDrawBackgroundColor(playerid, Latar[playerid], 255);
	PlayerTextDrawBoxColor(playerid, Latar[playerid], 50);
	PlayerTextDrawUseBox(playerid, Latar[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Latar[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Latar[playerid], 0);

	ClickAmmount[playerid] = CreatePlayerTextDraw(playerid, 290.000000, 160.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, ClickAmmount[playerid], 4);
	PlayerTextDrawLetterSize(playerid, ClickAmmount[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ClickAmmount[playerid], 70.000000, 25.000000);
	PlayerTextDrawSetOutline(playerid, ClickAmmount[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ClickAmmount[playerid], 0);
	PlayerTextDrawAlignment(playerid, ClickAmmount[playerid], 1);
	PlayerTextDrawColor(playerid, ClickAmmount[playerid], 859129087);
	PlayerTextDrawBackgroundColor(playerid, ClickAmmount[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ClickAmmount[playerid], 50);
	PlayerTextDrawUseBox(playerid, ClickAmmount[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ClickAmmount[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ClickAmmount[playerid], 1);

	ClickUse[playerid] = CreatePlayerTextDraw(playerid, 290.000000, 220.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, ClickUse[playerid], 4);
	PlayerTextDrawLetterSize(playerid, ClickUse[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ClickUse[playerid], 70.000000, 25.000000);
	PlayerTextDrawSetOutline(playerid, ClickUse[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ClickUse[playerid], 0);
	PlayerTextDrawAlignment(playerid, ClickUse[playerid], 1);
	PlayerTextDrawColor(playerid, ClickUse[playerid], 859129087);
	PlayerTextDrawBackgroundColor(playerid, ClickUse[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ClickUse[playerid], 50);
	PlayerTextDrawUseBox(playerid, ClickUse[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ClickUse[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ClickUse[playerid], 1);

	ClickGive[playerid] = CreatePlayerTextDraw(playerid, 290.000000, 250.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, ClickGive[playerid], 4);
	PlayerTextDrawLetterSize(playerid, ClickGive[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ClickGive[playerid], 70.000000, 25.000000);
	PlayerTextDrawSetOutline(playerid, ClickGive[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ClickGive[playerid], 0);
	PlayerTextDrawAlignment(playerid, ClickGive[playerid], 1);
	PlayerTextDrawColor(playerid, ClickGive[playerid], 859129087);
	PlayerTextDrawBackgroundColor(playerid, ClickGive[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ClickGive[playerid], 50);
	PlayerTextDrawUseBox(playerid, ClickGive[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ClickGive[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ClickGive[playerid], 1);

	ClickDrop[playerid] = CreatePlayerTextDraw(playerid, 290.000000, 280.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, ClickDrop[playerid], 4);
	PlayerTextDrawLetterSize(playerid, ClickDrop[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ClickDrop[playerid], 70.000000, 25.000000);
	PlayerTextDrawSetOutline(playerid, ClickDrop[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ClickDrop[playerid], 0);
	PlayerTextDrawAlignment(playerid, ClickDrop[playerid], 1);
	PlayerTextDrawColor(playerid, ClickDrop[playerid], 859129087);
	PlayerTextDrawBackgroundColor(playerid, ClickDrop[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ClickDrop[playerid], 50);
	PlayerTextDrawUseBox(playerid, ClickDrop[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ClickDrop[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ClickDrop[playerid], 1);
	
	Ammount[playerid] = CreatePlayerTextDraw(playerid, 326.000000, 163.000000, "1");
	PlayerTextDrawFont(playerid, Ammount[playerid], 1);
	PlayerTextDrawLetterSize(playerid, Ammount[playerid], 0.300000, 2.000000);
	PlayerTextDrawTextSize(playerid, Ammount[playerid], 70.000000, 25.000000);
	PlayerTextDrawSetOutline(playerid, Ammount[playerid], 0);
	PlayerTextDrawSetShadow(playerid, Ammount[playerid], 0);
	PlayerTextDrawAlignment(playerid, Ammount[playerid], 2);
	PlayerTextDrawColor(playerid, Ammount[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, Ammount[playerid], 255);
	PlayerTextDrawBoxColor(playerid, Ammount[playerid], 50);
	PlayerTextDrawUseBox(playerid, Ammount[playerid], 0);
	PlayerTextDrawSetProportional(playerid, Ammount[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, Ammount[playerid], 0);

	Hiasan[playerid][0] = CreatePlayerTextDraw(playerid, 326.000000, 222.000000, "Use");
	PlayerTextDrawFont(playerid, Hiasan[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, Hiasan[playerid][0], 0.300000, 2.000000);
	PlayerTextDrawTextSize(playerid, Hiasan[playerid][0], 70.000000, 25.000000);
	PlayerTextDrawSetOutline(playerid, Hiasan[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, Hiasan[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, Hiasan[playerid][0], 2);
	PlayerTextDrawColor(playerid, Hiasan[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, Hiasan[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, Hiasan[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, Hiasan[playerid][0], 0);
	PlayerTextDrawSetProportional(playerid, Hiasan[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, Hiasan[playerid][0], 0);

	Hiasan[playerid][1] = CreatePlayerTextDraw(playerid, 326.000000, 253.000000, "Give");
	PlayerTextDrawFont(playerid, Hiasan[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, Hiasan[playerid][1], 0.300000, 2.000000);
	PlayerTextDrawTextSize(playerid, Hiasan[playerid][1], 70.000000, 25.000000);
	PlayerTextDrawSetOutline(playerid, Hiasan[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, Hiasan[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, Hiasan[playerid][1], 2);
	PlayerTextDrawColor(playerid, Hiasan[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, Hiasan[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, Hiasan[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, Hiasan[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, Hiasan[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, Hiasan[playerid][1], 0);

	Hiasan[playerid][2] = CreatePlayerTextDraw(playerid, 326.000000, 282.000000, "Drop");
	PlayerTextDrawFont(playerid, Hiasan[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, Hiasan[playerid][2], 0.300000, 2.000000);
	PlayerTextDrawTextSize(playerid, Hiasan[playerid][2], 70.000000, 25.000000);
	PlayerTextDrawSetOutline(playerid, Hiasan[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, Hiasan[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, Hiasan[playerid][2], 2);
	PlayerTextDrawColor(playerid, Hiasan[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, Hiasan[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, Hiasan[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, Hiasan[playerid][2], 0);
	PlayerTextDrawSetProportional(playerid, Hiasan[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, Hiasan[playerid][2], 0);

	ClickClose[playerid] = CreatePlayerTextDraw(playerid, 319.000000, 320.000000, "ld_beat:chit");
	PlayerTextDrawFont(playerid, ClickClose[playerid], 4);
	PlayerTextDrawLetterSize(playerid, ClickClose[playerid], 0.300000, 2.000000);
	PlayerTextDrawTextSize(playerid, ClickClose[playerid], 15.000000, 20.000000);
	PlayerTextDrawSetOutline(playerid, ClickClose[playerid], 0);
	PlayerTextDrawSetShadow(playerid, ClickClose[playerid], 0);
	PlayerTextDrawAlignment(playerid, ClickClose[playerid], 2);
	PlayerTextDrawColor(playerid, ClickClose[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ClickClose[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ClickClose[playerid], 50);
	PlayerTextDrawUseBox(playerid, ClickClose[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ClickClose[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ClickClose[playerid], 1);

	Hiasan[playerid][3] = CreatePlayerTextDraw(playerid, 326.500000, 321.000000, "X");
	PlayerTextDrawFont(playerid, Hiasan[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, Hiasan[playerid][3], 0.250000, 1.799999);
	PlayerTextDrawTextSize(playerid, Hiasan[playerid][3], 15.000000, 20.000000);
	PlayerTextDrawSetOutline(playerid, Hiasan[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, Hiasan[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, Hiasan[playerid][3], 2);
	PlayerTextDrawColor(playerid, Hiasan[playerid][3], 255);
	PlayerTextDrawBackgroundColor(playerid, Hiasan[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, Hiasan[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, Hiasan[playerid][3], 0);
	PlayerTextDrawSetProportional(playerid, Hiasan[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, Hiasan[playerid][3], 0);
    return 1;
}

CreateInventoryTD(playerid)
{
    InvenTD[playerid][0] = CreatePlayerTextDraw(playerid, 80.000000, 75.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][0], 202.000000, 350.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][0], 522268415);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][0], 0);

	InvenTD[playerid][1] = CreatePlayerTextDraw(playerid, 85.000000, 103.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][1], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][1], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][1], 0);

	InvenTD[playerid][2] = CreatePlayerTextDraw(playerid, 123.500000, 103.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][2], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][2], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][2], 0);

	InvenTD[playerid][3] = CreatePlayerTextDraw(playerid, 162.000000, 103.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][3], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][3], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][3], 0);

	InvenTD[playerid][4] = CreatePlayerTextDraw(playerid, 201.000000, 103.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][4], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][4], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][4], 0);

	InvenTD[playerid][5] = CreatePlayerTextDraw(playerid, 239.500000, 103.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][5], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][5], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][5], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][5], 0);

	InvenTD[playerid][6] = CreatePlayerTextDraw(playerid, 85.000000, 164.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][6], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][6], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][6], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][6], 0);

	InvenTD[playerid][7] = CreatePlayerTextDraw(playerid, 123.500000, 164.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][7], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][7], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][7], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][7], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][7], 0);

	InvenTD[playerid][8] = CreatePlayerTextDraw(playerid, 162.000000, 164.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][8], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][8], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][8], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][8], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][8], 0);

	InvenTD[playerid][9] = CreatePlayerTextDraw(playerid, 201.000000, 164.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][9], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][9], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][9], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][9], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][9], 0);

	InvenTD[playerid][10] = CreatePlayerTextDraw(playerid, 239.500000, 164.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][10], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][10], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][10], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][10], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][10], 0);

	InvenTD[playerid][11] = CreatePlayerTextDraw(playerid, 85.000000, 225.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][11], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][11], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][11], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][11], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][11], 0);

	InvenTD[playerid][12] = CreatePlayerTextDraw(playerid, 123.500000, 225.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][12], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][12], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][12], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][12], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][12], 0);

	InvenTD[playerid][13] = CreatePlayerTextDraw(playerid, 162.000000, 225.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][13], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][13], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][13], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][13], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][13], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][13], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][13], 0);

	InvenTD[playerid][14] = CreatePlayerTextDraw(playerid, 201.000000, 225.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][14], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][14], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][14], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][14], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][14], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][14], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][14], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][14], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][14], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][14], 0);

	InvenTD[playerid][15] = CreatePlayerTextDraw(playerid, 239.500000, 225.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][15], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][15], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][15], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][15], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][15], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][15], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][15], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][15], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][15], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][15], 0);

	InvenTD[playerid][16] = CreatePlayerTextDraw(playerid, 85.000000, 286.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][16], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][16], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][16], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][16], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][16], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][16], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][16], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][16], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][16], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][16], 0);

	InvenTD[playerid][17] = CreatePlayerTextDraw(playerid, 123.500000, 286.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][17], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][17], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][17], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][17], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][17], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][17], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][17], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][17], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][17], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][17], 0);

	InvenTD[playerid][18] = CreatePlayerTextDraw(playerid, 162.000000, 286.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][18], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][18], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][18], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][18], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][18], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][18], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][18], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][18], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][18], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][18], 0);

	InvenTD[playerid][19] = CreatePlayerTextDraw(playerid, 201.000000, 286.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][19], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][19], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][19], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][19], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][19], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][19], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][19], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][19], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][19], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][19], 0);

	InvenTD[playerid][20] = CreatePlayerTextDraw(playerid, 239.500000, 286.500000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][20], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][20], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][20], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][20], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][20], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][20], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][20], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][20], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][20], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][20], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][20], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][20], 0);

	InvenTD[playerid][21] = CreatePlayerTextDraw(playerid, 85.000000, 348.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][21], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][21], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][21], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][21], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][21], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][21], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][21], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][21], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][21], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][21], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][21], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][21], 0);

	InvenTD[playerid][22] = CreatePlayerTextDraw(playerid, 123.500000, 348.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][22], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][22], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][22], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][22], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][22], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][22], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][22], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][22], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][22], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][22], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][22], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][22], 0);

	InvenTD[playerid][23] = CreatePlayerTextDraw(playerid, 162.000000, 348.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][23], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][23], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][23], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][23], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][23], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][23], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][23], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][23], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][23], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][23], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][23], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][23], 0);

	InvenTD[playerid][24] = CreatePlayerTextDraw(playerid, 201.000000, 348.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][24], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][24], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][24], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][24], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][24], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][24], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][24], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][24], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][24], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][24], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][24], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][24], 0);

	InvenTD[playerid][25] = CreatePlayerTextDraw(playerid, 239.500000, 348.000000, "ld_dual:white");
	PlayerTextDrawFont(playerid, InvenTD[playerid][25], 4);
	PlayerTextDrawLetterSize(playerid, InvenTD[playerid][25], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, InvenTD[playerid][25], 37.000000, 58.000000);
	PlayerTextDrawSetOutline(playerid, InvenTD[playerid][25], 1);
	PlayerTextDrawSetShadow(playerid, InvenTD[playerid][25], 0);
	PlayerTextDrawAlignment(playerid, InvenTD[playerid][25], 1);
	PlayerTextDrawColor(playerid, InvenTD[playerid][25], 859129087);
	PlayerTextDrawBackgroundColor(playerid, InvenTD[playerid][25], 255);
	PlayerTextDrawBoxColor(playerid, InvenTD[playerid][25], 50);
	PlayerTextDrawUseBox(playerid, InvenTD[playerid][25], 1);
	PlayerTextDrawSetProportional(playerid, InvenTD[playerid][25], 1);
	PlayerTextDrawSetSelectable(playerid, InvenTD[playerid][25], 0);
}
