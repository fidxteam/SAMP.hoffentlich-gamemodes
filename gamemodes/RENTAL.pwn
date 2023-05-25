#define MAX_RENTVEH 20

new Float:rentVehicle[][3] =
{
    {1775.9016, -1885.0438, 13.3863},
    {805.3231, -1354.3579, 13.5469}
    //{1693.9724, -2312.2305, 13.5469}
};

new Float:unrentVehicle[][3] =
{
    {1778.9250, -1885.2721, 13.3885},
    {805.4545, -1350.5482, 13.5469}
    //{335.998474, -1787.913330, 4.932786}
};

new Float:rentBoat[][3] =
{
    {213.6747, -1986.3925, 1.4154}
};

CMD:rentbike(playerid)
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1775.9016, -1885.0438, 13.3863) && !IsPlayerInRangeOfPoint(playerid, 3.0, 805.3231, -1354.3579, 13.5469))
        return Error(playerid, "Kamu tidak berada di dekat penyewaan sepeda!");
        
    new str[1024];
    format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t"LG_E"$50 / one days\n%s\t"LG_E"$200 / one days",
    GetVehicleModelName(481), 
    GetVehicleModelName(462));
                
    ShowPlayerDialog(playerid, DIALOG_RENT_BIKE, DIALOG_STYLE_TABLIST_HEADERS, "Rent Bike", str, "Rent", "Close");
    return 1;
}    

CMD:rentboat(playerid, params)
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 213.6747, -1986.3925, 1.4154)) return Error(playerid, "Kamu tidak berada di dekat penyewaan Kapal!");

    new str[1024];
    format(str, sizeof(str), "Kendaraan\tHarga\n"WHITE_E"%s\t"LG_E"$750 / one days\n%s\t"LG_E"$1.250 / one days\n%s\t"LG_E"$1.500 / one days",
    GetVehicleModelName(473), 
    GetVehicleModelName(453),
    GetVehicleModelName(452));
           
    ShowPlayerDialog(playerid, DIALOG_RENT_BOAT, DIALOG_STYLE_TABLIST_HEADERS, "Rent Boat", str, "Rent", "Close");
    return 1;
}
