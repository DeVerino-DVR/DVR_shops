Distance = function(coords, coords2)
	return #(coords-coords2)
end

DrawText3D = function(x, y, z, text)
        local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
        local px,py,pz=table.unpack(GetGameplayCamCoord())  
        local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
        local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    if onScreen then
        SetTextScale(0.30, 0.30)
        SetTextFontForCurrentCommand(1)
        SetTextColor(255, 255, 255, 215)
        SetTextCentre(1)
        DisplayText(str,_x,_y)
        local factor = (string.len(text)) / 225
        DrawSprite("feeds", "hud_menu_4a", _x, _y+0.0125,0.015+ factor, 0.03, 0.1, 35, 35, 35, 190, 0)
    end
end 

TextEntry = function(text)
   AddTextEntry("FMMC_KEY_TIP8", text)
   DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 30)

   while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Citizen.Wait(0);
   end

   if (GetOnscreenKeyboardResult()) then
      return GetOnscreenKeyboardResult()
   end
end