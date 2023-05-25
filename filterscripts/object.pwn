#include <a_samp>
#include <streamer>

new tmpobjid;
//-------[ Map Include ]--------
//Exterior
#include "./map/ext_sags.pwn"
#include "./map/ext_sapd.pwn"	//
#include "./map/ext_cityhall.pwn"
#include "./map/more_mapping.pwn"
#include "./map/ext_samd_asgh_back.pwn"
#include "./map/ext_sana.pwn"
#include "./map/ext_mcblueberry.pwn"
#include "./map/ext_gasstation.pwn"
#include "./map/ext_minernew.pwn"
#include "./map/ext_production.pwn"
#include "./map/ext_adminjail.pwn"
#include "./map/ext_taxi.pwn"
#include "./map/new_mapping.pwn"
#include "./map/int_housenew.pwn"

#include "./map/ext_bisnisrobert.pwn"

//Interior
#include "./map/int_bank.pwn"
#include "./map/int_sapd.pwn"
#include "./map/int_newasgh.pwn"
#include "./map/int_sana.pwn"
#include "./map/int_sana_studio.pwn"
#include "./map/int_sags.pwn"
#include "./map/int_samd.pwn"
#include "./map/int_vip.pwn"
#include "./map/int_pengadilan.pwn"

//Gangs/Fam
#include "./map/gangs/ext_gangsrobert.pwn"
#include "./map/gangs/ext_gangsganton.pwn"

#include "./map/gangs/int_gangsrobert.pwn"


#include "./map/gangs/int_gangs1.pwn"
#include "./map/gangs/int_gangs2.pwn"
#include "./map/gangs/int_gangs3.pwn"
#include "./map/gangs/int_gangs4.pwn"
#include "./map/gangs/int_gangs5.pwn"
#include "./map/gangs/int_gangs6.pwn"
#include "./map/gangs/int_gangs7.pwn"
#include "./map/gangs/int_gangs8.pwn"

//Large
#include "./map/large/int_large1.pwn"
#include "./map/large/int_large2.pwn"
#include "./map/large/int_large3.pwn"
#include "./map/large/int_large4.pwn"
#include "./map/large/int_large5.pwn"

//Medium
#include "./map/medium/int_medium1.pwn"
#include "./map/medium/int_medium2.pwn"
#include "./map/medium/int_medium3.pwn"
//#include "./map/medium/int_medium4.pwn"

//Small
#include "./map/small/int_small1.pwn"
#include "./map/small/int_small2.pwn"
#include "./map/small/int_small3.pwn"

RemoveVendingMachines(playerid)
{
	RemoveBuildingForPlayer(playerid, 956, 1634.1487,-2238.2810,13.5077, 20.0); //Snack vender @ LS Airport
	RemoveBuildingForPlayer(playerid, 956, 2480.9885,-1958.5117,13.5831, 20.0); //Snack vender @ Sushi Shop in Willowfield
	RemoveBuildingForPlayer(playerid, 955, 1729.7935,-1944.0087,13.5682, 20.0); //Sprunk machine @ Unity Station
	RemoveBuildingForPlayer(playerid, 955, 2060.1099,-1898.4543,13.5538, 20.0); //Sprunk machine opposite Tony's Liqour in Willowfield
	RemoveBuildingForPlayer(playerid, 955, 2325.8708,-1645.9584,14.8270, 20.0); //Sprunk machine @ Ten Green Bottles
	RemoveBuildingForPlayer(playerid, 955, 1153.9130,-1460.8893,15.7969, 20.0); //Sprunk machine @ Market
	RemoveBuildingForPlayer(playerid, 955,1788.3965,-1369.2336,15.7578, 20.0); //Sprunk machine in Downtown Los Santos
	RemoveBuildingForPlayer(playerid, 955, 2352.9939,-1357.1105,24.3984, 20.0); //Sprunk machine @ Liquour shop in East Los Santos
	RemoveBuildingForPlayer(playerid, 1775, 2224.3235,-1153.0692,1025.7969, 20.0); //Sprunk machine @ Jefferson Motel
	RemoveBuildingForPlayer(playerid, 956, 2140.2566,-1161.7568,23.9922, 20.0); //Snack machine @ pick'n'go market in Jefferson
	RemoveBuildingForPlayer(playerid, 956, 2154.1199,-1015.7635,62.8840, 20.0); //Snach machine @ Carniceria El Pueblo in Las Colinas
	RemoveBuildingForPlayer(playerid, 956, 662.5665,-551.4142,16.3359, 20.0); //Snack vender at Dillimore Gas Station
	RemoveBuildingForPlayer(playerid, 955, 200.2010,-107.6401,1.5513, 20.0); //Sprunk machine @ Blueberry Safe House
	RemoveBuildingForPlayer(playerid, 956, 2271.4666,-77.2104,26.5824, 20.0); //Snack machine @ Palomino Creek Library
	RemoveBuildingForPlayer(playerid, 955, 1278.5421,372.1057,19.5547, 20.0); //Sprunk machine @ Papercuts in Montgomery
	RemoveBuildingForPlayer(playerid, 955, 1929.5527,-1772.3136,13.5469, 20.0); //Sprunk machine @ Idlewood Gas Station
 
	//San Fierro
	RemoveBuildingForPlayer(playerid, 1302, -2419.5835,984.4185,45.2969, 20.0); //Soda machine 1 @ Juniper Hollow Gas Station
	RemoveBuildingForPlayer(playerid, 1209, -2419.5835,984.4185,45.2969, 20.0); //Soda machine 2 @ Juniper Hollow Gas Station
	RemoveBuildingForPlayer(playerid, 956, -2229.2075,287.2937,35.3203, 20.0); //Snack vender @ King's Car Park
	RemoveBuildingForPlayer(playerid, 955, -1349.3947,493.1277,11.1953, 20.0); //Sprunk machine @ SF Aircraft Carrier
	RemoveBuildingForPlayer(playerid, 956, -1349.3947,493.1277,11.1953, 20.0); //Snack vender @ SF Aircraft Carrier
	RemoveBuildingForPlayer(playerid, 955, -1981.6029,142.7232,27.6875, 20.0); //Sprunk machine @ Cranberry Station
	RemoveBuildingForPlayer(playerid, 955, -2119.6245,-422.9411,35.5313, 20.0); //Sprunk machine 1/2 @ SF Stadium
	RemoveBuildingForPlayer(playerid, 955, -2097.3696,-397.5220,35.5313, 20.0); //Sprunk machine 3 @ SF Stadium
	RemoveBuildingForPlayer(playerid, 955, -2068.5593,-397.5223,35.5313, 20.0); //Sprunk machine 3 @ SF Stadium
	RemoveBuildingForPlayer(playerid, 955, -2039.8802,-397.5214,35.5313, 20.0); //Sprunk machine 3 @ SF Stadium
	RemoveBuildingForPlayer(playerid, 955, -2011.1403,-397.5225,35.5313, 20.0); //Sprunk machine 3 @ SF Stadium
	RemoveBuildingForPlayer(playerid, 955, -2005.7861,-490.8688,35.5313, 20.0); //Sprunk machine 3 @ SF Stadium
	RemoveBuildingForPlayer(playerid, 955, -2034.5267,-490.8681,35.5313, 20.0); //Sprunk machine 3 @ SF Stadium
	RemoveBuildingForPlayer(playerid, 955, -2063.1875,-490.8687,35.5313, 20.0); //Sprunk machine 3 @ SF Stadium
	RemoveBuildingForPlayer(playerid, 955, -2091.9780,-490.8684,35.5313, 20.0); //Sprunk machine 3 @ SF Stadium
 
	//Las Venturas
	RemoveBuildingForPlayer(playerid, 956, -1455.1298,2592.4138,55.8359, 20.0); //Snack vender @ El Quebrados GONE
	RemoveBuildingForPlayer(playerid, 955, -252.9574,2598.9048,62.8582, 20.0); //Sprunk machine @ Las Payasadas GONE
	RemoveBuildingForPlayer(playerid, 956, -252.9574,2598.9048,62.8582, 20.0); //Snack vender @ Las Payasadas GONE
	RemoveBuildingForPlayer(playerid, 956, 1398.7617,2223.3606,11.0234, 20.0); //Snack vender @ Redsands West GONE
	RemoveBuildingForPlayer(playerid, 955, -862.9229,1537.4246,22.5870, 20.0); //Sprunk machine @ The Smokin' Beef Grill in Las Barrancas GONE
	RemoveBuildingForPlayer(playerid, 955, -14.6146,1176.1738,19.5634, 20.0); //Sprunk machine @ Fort Carson GONE
	RemoveBuildingForPlayer(playerid, 956, -75.2839,1227.5978,19.7360, 20.0); //Snack vender @ Fort Carson GONE
	RemoveBuildingForPlayer(playerid, 955, 1519.3328,1055.2075,10.8203, 20.0); //Sprunk machine @ LVA Freight Department GONE
	RemoveBuildingForPlayer(playerid, 956, 1659.5096,1722.1096,10.8281, 20.0); //Snack vender near Binco @ LV Airport GONE
	RemoveBuildingForPlayer(playerid, 955, 2086.5872,2071.4958,11.0579, 20.0); //Sprunk machine @ Sex Shop on The Strip
	RemoveBuildingForPlayer(playerid, 955, 2319.9001,2532.0376,10.8203, 20.0); //Sprunk machine @ Pizza co by Julius Thruway (North)
	RemoveBuildingForPlayer(playerid, 955, 2503.2061,1244.5095,10.8203, 20.0); //Sprunk machine @ Club in the Camels Toe
	RemoveBuildingForPlayer(playerid, 956, 2845.9919,1294.2975,11.3906, 20.0); //Snack vender @ Linden Station
 
	//Interiors: 24/7 and Clubs
	RemoveBuildingForPlayer(playerid, 1775, 496.0843,-23.5310,1000.6797, 20.0); //Sprunk machine 1 @ Club in Camels Toe
	RemoveBuildingForPlayer(playerid, 1775, 501.1219,-2.1968,1000.6797, 20.0); //Sprunk machine 2 @ Club in Camels Toe
	RemoveBuildingForPlayer(playerid, 1776, 501.1219,-2.1968,1000.6797, 20.0); //Snack vender @ Club in Camels Toe
	RemoveBuildingForPlayer(playerid, 1775, -19.2299,-57.0460,1003.5469, 20.0); //Sprunk machine @ Roboi's type 24/7 stores
	RemoveBuildingForPlayer(playerid, 1776, -35.9012,-57.1345,1003.5469, 20.0); //Snack vender @ Roboi's type 24/7 stores
	RemoveBuildingForPlayer(playerid, 1775, -17.0036,-90.9709,1003.5469, 20.0); //Sprunk machine @ Other 24/7 stores
	RemoveBuildingForPlayer(playerid, 1776, -17.0036,-90.9709,1003.5469, 20.0); //Snach vender @ Others 24/7 stores

	//----------------------[ Depan Balai Kota ]
	RemoveBuildingForPlayer(playerid, 1258, 1510.890625, -1607.312500, 13.695300, 0.250000);
	RemoveBuildingForPlayer(playerid, 4057, 1479.554688, -1693.140625, 19.578100, 0.250000);
	RemoveBuildingForPlayer(playerid, 4210, 1479.562500, -1631.453125, 12.078100, 0.250000);
	RemoveBuildingForPlayer(playerid, 713, 1457.937500, -1620.695313, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 713, 1496.867188, -1707.820313, 13.406300, 0.250000);
	RemoveBuildingForPlayer(playerid, 1226, 1451.625000, -1727.671875, 16.421900, 0.250000);
	RemoveBuildingForPlayer(playerid, 1226, 1467.984375, -1727.671875, 16.421900, 0.250000);
	RemoveBuildingForPlayer(playerid, 1226, 1485.171875, -1727.671875, 16.421900, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1468.984375, -1713.507813, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 1231, 1479.695313, -1716.703125, 15.625000, 0.250000);
	RemoveBuildingForPlayer(playerid, 1226, 1505.179688, -1727.671875, 16.421900, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1488.765625, -1713.703125, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 1289, 1504.750000, -1711.882813, 13.593800, 0.250000);
	RemoveBuildingForPlayer(playerid, 1258, 1445.007813, -1704.765625, 13.695300, 0.250000);
	RemoveBuildingForPlayer(playerid, 1258, 1445.007813, -1692.234375, 13.695300, 0.250000);
	RemoveBuildingForPlayer(playerid, 712, 1445.812500, -1650.023438, 22.257799, 0.250000);
	RemoveBuildingForPlayer(playerid, 673, 1457.726563, -1710.062500, 12.398400, 0.250000);
	RemoveBuildingForPlayer(playerid, 620, 1461.656250, -1707.687500, 11.835900, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1468.984375, -1704.640625, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 700, 1463.062500, -1701.570313, 13.726600, 0.250000);
	RemoveBuildingForPlayer(playerid, 1231, 1479.695313, -1702.531250, 15.625000, 0.250000);
	RemoveBuildingForPlayer(playerid, 673, 1457.554688, -1697.289063, 12.398400, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1468.984375, -1694.046875, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 1231, 1479.382813, -1692.390625, 15.632800, 0.250000);
	RemoveBuildingForPlayer(playerid, 4186, 1479.554688, -1693.140625, 19.578100, 0.250000);
	RemoveBuildingForPlayer(playerid, 620, 1461.125000, -1687.562500, 11.835900, 0.250000);
	RemoveBuildingForPlayer(playerid, 700, 1463.062500, -1690.648438, 13.726600, 0.250000);
	RemoveBuildingForPlayer(playerid, 641, 1458.617188, -1684.132813, 11.101600, 0.250000);
	RemoveBuildingForPlayer(playerid, 625, 1457.273438, -1666.296875, 13.695300, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1468.984375, -1682.718750, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 712, 1471.406250, -1666.179688, 22.257799, 0.250000);
	RemoveBuildingForPlayer(playerid, 1231, 1479.382813, -1682.312500, 15.632800, 0.250000);
	RemoveBuildingForPlayer(playerid, 625, 1458.257813, -1659.257813, 13.695300, 0.250000);
	RemoveBuildingForPlayer(playerid, 712, 1449.851563, -1655.937500, 22.257799, 0.250000);
	RemoveBuildingForPlayer(playerid, 1231, 1477.937500, -1652.726563, 15.632800, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1479.609375, -1653.250000, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 625, 1457.351563, -1650.570313, 13.695300, 0.250000);
	RemoveBuildingForPlayer(playerid, 625, 1454.421875, -1642.492188, 13.695300, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1467.851563, -1646.593750, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1472.898438, -1651.507813, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1465.937500, -1639.820313, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 1231, 1466.468750, -1637.960938, 15.632800, 0.250000);
	RemoveBuildingForPlayer(playerid, 625, 1449.593750, -1635.046875, 13.695300, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1467.710938, -1632.890625, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 1232, 1465.890625, -1629.976563, 15.531300, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1472.664063, -1627.882813, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1479.468750, -1626.023438, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 3985, 1479.562500, -1631.453125, 12.078100, 0.250000);
	RemoveBuildingForPlayer(playerid, 4206, 1479.554688, -1639.609375, 13.648400, 0.250000);
	RemoveBuildingForPlayer(playerid, 1232, 1465.835938, -1608.375000, 15.375000, 0.250000);
	RemoveBuildingForPlayer(playerid, 1229, 1466.484375, -1598.093750, 14.109400, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1488.765625, -1704.593750, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 700, 1494.210938, -1694.437500, 13.726600, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1488.765625, -1693.734375, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 620, 1496.976563, -1686.851563, 11.835900, 0.250000);
	RemoveBuildingForPlayer(playerid, 641, 1494.140625, -1689.234375, 11.101600, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1488.765625, -1682.671875, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 712, 1480.609375, -1666.179688, 22.257799, 0.250000);
	RemoveBuildingForPlayer(playerid, 712, 1488.226563, -1666.179688, 22.257799, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1486.406250, -1651.390625, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1491.367188, -1646.382813, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1493.132813, -1639.453125, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1486.179688, -1627.765625, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 1280, 1491.218750, -1632.679688, 13.453100, 0.250000);
	RemoveBuildingForPlayer(playerid, 1232, 1494.414063, -1629.976563, 15.531300, 0.250000);
	RemoveBuildingForPlayer(playerid, 1232, 1494.359375, -1608.375000, 15.375000, 0.250000);
	RemoveBuildingForPlayer(playerid, 1229, 1498.054688, -1598.093750, 14.109400, 0.250000);
	RemoveBuildingForPlayer(playerid, 1288, 1504.750000, -1705.406250, 13.593800, 0.250000);
	RemoveBuildingForPlayer(playerid, 1287, 1504.750000, -1704.468750, 13.593800, 0.250000);
	RemoveBuildingForPlayer(playerid, 1286, 1504.750000, -1695.054688, 13.593800, 0.250000);
	RemoveBuildingForPlayer(playerid, 1285, 1504.750000, -1694.039063, 13.593800, 0.250000);
	RemoveBuildingForPlayer(playerid, 673, 1498.960938, -1684.609375, 12.398400, 0.250000);
	RemoveBuildingForPlayer(playerid, 625, 1504.164063, -1662.015625, 13.695300, 0.250000);
	RemoveBuildingForPlayer(playerid, 625, 1504.718750, -1670.921875, 13.695300, 0.250000);
	RemoveBuildingForPlayer(playerid, 620, 1503.187500, -1621.125000, 11.835900, 0.250000);
	RemoveBuildingForPlayer(playerid, 673, 1501.281250, -1624.578125, 12.398400, 0.250000);
	RemoveBuildingForPlayer(playerid, 673, 1498.359375, -1616.968750, 12.398400, 0.250000);
	RemoveBuildingForPlayer(playerid, 712, 1508.445313, -1668.742188, 22.257799, 0.250000);
	RemoveBuildingForPlayer(playerid, 625, 1505.695313, -1654.835938, 13.695300, 0.250000);
	RemoveBuildingForPlayer(playerid, 625, 1508.515625, -1647.859375, 13.695300, 0.250000);
	RemoveBuildingForPlayer(playerid, 625, 1513.273438, -1642.492188, 13.695300, 0.250000);
	RemoveBuildingForPlayer(playerid, 1226, 1525.382813, -1611.156250, 16.421900, 0.250000);
	RemoveBuildingForPlayer(playerid, 4044, 1481.187012, -1785.069946, 22.382000, 0.250000);
	RemoveBuildingForPlayer(playerid, 3980, 1481.187012, -1785.069946, 22.382000, 0.250000);

	//--------[ Workshop El Corona ]
	RemoveBuildingForPlayer(playerid, 1297, 1292.1797, -1691.7578, 15.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 626, 1258.5781, -1675.5000, 14.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 626, 1267.6719, -1675.5000, 14.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 626, 1258.5781, -1659.8750, 14.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 626, 1267.6719, -1659.8750, 14.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1237.5000, -1643.4297, 14.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1233.4688, -1643.4297, 14.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1245.5625, -1643.4297, 14.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1241.5313, -1643.4297, 14.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 626, 1258.5781, -1643.3672, 14.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 626, 1267.6719, -1643.3672, 14.6016, 0.25);
}

public OnPlayerConnect(playerid)
{
	RemoveVendingMachines(playerid);
	
	RemoveExtSamdAsghBack(playerid);
	RemoveExtSapd(playerid);
	//RemoveExtShowroom(playerid);
	//RemoveExtNewDealer(playerid);
	//RemoveExtMc(playerid);
	//RemoveExtNewMC2(playerid);
	RemoveExtMCBlueberry(playerid);
	//RemoveExtWsVinewood(playerid);
	RemoveExtProduction(playerid);
	//RemoveExtNewCityHall(playerid);
	//RemoveExtSpawn(playerid);
	RemoveExtTaxi(playerid);
	RemoveMapping(playerid);
	
	RemoveExtBisnisRobert(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnFilterScriptExit()
{
	DestroyAllDynamicObjects();
}

public OnFilterScriptInit()
{
	// Config
	Streamer_MaxItems(STREAMER_TYPE_OBJECT, 990000);
	Streamer_MaxItems(STREAMER_TYPE_CP, 200);
	Streamer_MaxItems(STREAMER_TYPE_MAP_ICON, 2000);
	Streamer_MaxItems(STREAMER_TYPE_PICKUP, 2000);
	for(new playerid = (GetMaxPlayers() - 1); playerid != -1; playerid--)
	{
		Streamer_DestroyAllVisibleItems(playerid, 0);
	}
	Streamer_VisibleItems(STREAMER_TYPE_OBJECT, 1000);
	
	//Exterior
	CreateExtSags();
	CreateExtCityhall();
	CreateExtSapd();
	CreateExtSana();
	CreateIntNewASGH();
	CreateExtSamdAsghBack();
	//CreateExtShowroom();
	//CreateExtNewDealer();
	//CreateExtMc();
	CreateMapping();
	//CreateExtNewMC2();
	CreateExtMCBlueberry();
	CreateExtGasStation();
	//CreateExtWsVineWood();
	CreateExtMiner();
	CreateExtProduction();
	CreateExtAdminJail();
	//CreateExtParty();
	//CreateExtNewCityHall();
	//CreateExtSpawn();
	CreateExtTaxi();
	CreateMappingNew();
	//Interior House Baru
	CreateInteriorNew();
	
	//CreateExtDrag();
	CreateExtBisnisRobert();
	
	//Interior
	CreateIntSapd();
	CreateIntBank();
	CreateIntSamd();
	//CreateIntSamdAsgh();
	CreateIntSana();
	CreateIntSanaStudio();
	CreateIntSags();
	CreateIntVip();
	CreateIntPengadilan();
	
	//Gangs/Fams
	//CreateExtGangs1();
	//CreateExtGangs2();
	CreateExtGangsRobert();
	CreateExtGangsGanton();
	
	CreateIntGangsRobert();
	
	CreateIntGangs1();
	CreateIntGangs2();
	CreateIntGangs3();
	CreateIntGangs4();
	CreateIntGangs5();
	CreateIntGangs6();
	CreateIntGangs7();
	CreateIntGangs8();
	
	CreateIntLarge1();
	CreateIntLarge2();
	CreateIntLarge3();
	CreateIntLarge4();
	CreateIntLarge5();
	
	CreateIntMedium1();
	CreateIntMedium2();
	CreateIntMedium3();
	
	CreateIntSmall1();
	CreateIntSmall2();
	CreateIntSmall3();
	return 1;
}
