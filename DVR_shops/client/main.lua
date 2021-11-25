local Pressed = GetRandomIntInRange(0, 0xffffff)
local PressedControl
local Panier = {}

local function PromtShops()
    Citizen.CreateThread(function()
        local str = Config[23].text
        local wait = 0
        PressedControl = Citizen.InvokeNative(0x04F97DE45A519419)
        PromptSetControlAction(PressedControl, 0x760A9C6F)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(PressedControl, str)
        PromptSetEnabled(PressedControl, true)
        PromptSetVisible(PressedControl, true)
        PromptSetHoldMode(PressedControl, true)
        PromptSetGroup(PressedControl, Pressed)
        PromptRegisterEnd(PressedControl)
    end)
end

CreateThread(function()
    PromtShops()
    for v = 1, #Config.Shops, 1 do
        Shops = N_0x554d9d53f696d002(1664425300, Config.Shops[v].coords.x, Config.Shops[v].coords.y, Config.Shops[v].coords.z)
        SetBlipSprite(Shops, Config.Shops[v].blips, 1)
        SetBlipScale(Shops , 0.1)
        Citizen.InvokeNative(0x9CB1A1623062F402, Shops, Config.Shops[v].blipsName)
        Citizen.InvokeNative(0x662D364ABF16DE2F, Shops, Config.Shops[v].color)
    end

    while true do
        local nearShops = false
        for u = 1, #Config.Shops, 1 do 
            if Distance(GetEntityCoords(PlayerPedId()), Config.Shops[u].coords) <= 1.0 then
                nearShops = true

                if Config.Marker then 
                    Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, Config.Shops[u].coords.x, Config.Shops[u].coords.y, Config.Shops[u].coords.z - 1.0, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.2, 255, 255, 255, 50, 0, 0, 1, 0, 0, 0, 0)
                end

                if Config.OnlyJob then 
                    local Shops = CreateVarString(10, 'LITERAL_STRING', Config[18].text)
                    PromptSetActiveGroupThisFrame(Pressed, Shops)
                    if PromptHasHoldModeCompleted(PressedControl) then
                        if not open then 
                            open = false
                            TriggerServerEvent('DVR_shops:resultItem', Config.Shops[u].shops)
                        end
                    end
                else
                    local Shops = CreateVarString(10, 'LITERAL_STRING', Config[18].text)
                    PromptSetActiveGroupThisFrame(Pressed, Shops)
                    if PromptHasHoldModeCompleted(PressedControl) then
                        if not open then 
                            open = false
                            WarMenu.OpenMenu('shopsmenu')
                        end
                    end
                end
            end
        end
        if nearShops then
            Wait(1.0)
        else
            Wait(100)
        end
    end
end)

CreateThread(function()
    WarMenu.CreateMenu('shopsmenujob', Config[18].text)
    WarMenu.CreateMenu('shopsmenu', Config[18].text)
 
    while true do
        if WarMenu.IsMenuOpened('shopsmenujob') and MarketPlace ~= nil then
            PromptSetVisible(PressedControl, false)
            for i = 1, #itemShops do
                if WarMenu.Button(tostring(itemShops[i].label) .. " " .. Config[12].text .. " " .. tonumber(itemShops[i].price) .. " " .. Config[13].text .. " x" .. tonumber(itemShops[i].qty)) then
                    Wait(80)
                    local quantity = TextEntry(Config[2].text)
                    Wait(80)
                    if quantity ~= nil then
                        if tonumber(quantity) <= 0 then
                            while true do end
                        else
                            if tonumber(quantity) <= tonumber(itemShops[i].qty) then
                                TriggerServerEvent('DVR_shops:removeprice:additem', MarketPlace, quantity, itemShops[i].item)
                                local raison = (Config[28].text.. ' (joueurs) Shops: ' ..MarketPlace.. ' Quantité: ' ..quantity.. ' items: ' ..itemShops[i].item)
                                TriggerServerEvent('DVR_shops:executelog', raison)
                                WarMenu.CloseMenu()
                            else
                                TriggerEvent("vorp:TipRight", Config[3].text, 4000)
                            end
                        end
                    end
                end
            end

            if user_job == Config.JobName[1] or user_job == Config.JobName[2] then 
                if WarMenu.Button("") then end
                if WarMenu.Button(Config[16].text) then end
                for k,v in pairs(inv) do
                    if WarMenu.Button(v.Label.. ' x' ..v.Quantity) then 
                        qty = TextEntry(Config[2].text)
                        Wait(50)
                        price = TextEntry(Config[6].text)

                        if tonumber(price) ~= nil or tonumber(price) ~= 0 then 
                            if tonumber(price) >= Config.MaxPrice then 
                                TriggerEvent("vorp:TipRight", Config[21].text, 4000)
                            else
                                table.insert(Panier, {qty = qty, price = price, item = v.Id, label = v.Label, shops = MarketPlace})
                                local raison = (Config[28].text.. ' (Job) Shops: ' ..MarketPlace.. ' Quantité: ' ..qty.. ' items: ' ..item.. ' Prix ' ..price)
                                TriggerServerEvent('DVR_shops:executelog', raison)
                            end
                        end
                    end
                end
                if WarMenu.Button("") then end
                if WarMenu.Button(Config[24].text) then 
                    WarMenu.CloseMenu()
                end
                if WarMenu.Button(Config[19].text) then 
                    if Panier ~= nil then 
                        if qty ~= nil or qty > 0 or qty ~= "" or price ~= nil or price > 0 or price ~= "" then 
                            TriggerServerEvent('DVR_shops:completeitem', Panier, MarketPlace)
                            Panier = {}
                            WarMenu.CloseMenu()
                        end
                    end
                end
            end
        elseif WarMenu.IsMenuOpened('shopsmenu') then
            PromptSetVisible(PressedControl, false)
            for i = 1, #Config.items, 1 do 
                if WarMenu.Button(tostring(Config.items[i].label).. ' ' ..Config[12].text.. ' ' ..tonumber(Config.items[i].price).. ' ' ..Config[13].text) then
                    TriggerEvent("vorpinputs:getInput", ""..Config[1].text.."", ""..Config[2].text.."", function(quantity)
                        WarMenu.CloseMenu()
                        TriggerServerEvent('DVR_shops:removeprice:additem', '', tonumber(quantity), Config.items[i].item)
                    end)
                end
            end
        elseif not WarMenu.IsMenuOpened('shopsmenujob') then
            PromptSetVisible(PressedControl, true)
            Panier = {}
        elseif not WarMenu.IsMenuOpened('shopsmenu') then
            PromptSetVisible(PressedControl, true)
        end
        WarMenu.Display()
        Wait(1.0)
    end
end)


RegisterNetEvent('DVR_shops:closemenuRefreshClient')
AddEventHandler('DVR_shops:closemenuRefreshClient', function(item, qty)
    TriggerServerEvent('DVR_shops:removeitem', item, qty)
end)

RegisterNetEvent('DVR_shops:addbill')
AddEventHandler('DVR_shops:addbill', function(price)
    if Config.Taxe then 
        local taxe = Config.TaxeAmount
        local Calcul = price/taxe

        TriggerServerEvent("syn_society:paymybill", PlayerId(), Calcul, Config[25].text)
        Wait(500)
        TriggerServerEvent("syn_society:paymybill", PlayerId(), Calcul, Config[26].text)
    else
        TriggerServerEvent("syn_society:paymybill", PlayerId(), price, Config[25].text)
    end
end)

RegisterNetEvent('DVR_shops:addbill2')
AddEventHandler('DVR_shops:addbill2', function(price)
    if Config.Taxe then 
        local taxe = Config.TaxeAmount
        local Calcul = price/taxe

        TriggerServerEvent("syn_society:paymybill", PlayerId(), Calcul, Config[27].text)
        Wait(500)
        TriggerServerEvent("syn_society:paymybill", PlayerId(), Calcul, Config[26].text)
    end
end)

RegisterNetEvent('DVR_shops:closemenu')
AddEventHandler('DVR_shops:closemenu', function()
    WarMenu.CloseMenu()
    Wait(800)
    WarMenu.CloseMenu()
end)

RegisterNetEvent('DVR_shops:openShop')
AddEventHandler('DVR_shops:openShop', function(Shops, job, tableInv, market)
    itemShops = Shops 
    user_job = job
    inv = tableInv
    MarketPlace = market
    WarMenu.OpenMenu('shopsmenujob')
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then   
        RemoveBlip(Shops)
    end
end)

