VorpInv = exports.vorp_inventory:vorp_inventoryApi()
local VorpCore = {}
local shopsData = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

CreateThread(function()
    exports.ghmattimysql:execute("SELECT * FROM shops", {}, function(result)
        if result[1] ~= nil then 
            for i = 1, #result, 1 do 
                shopsData[result[i].MarketPlace] = {
                    MarketPlace = result[i].MarketPlace,
                    MarketTable = json.decode(result[i].MarketTable)
                }
            end
        end
    end)
end)

RegisterNetEvent('DVR_shops:resultItem')
AddEventHandler('DVR_shops:resultItem', function(MarketPlace)
    local _source = source
    local User = VorpCore.getUser(_source) 
    local Character = User.getUsedCharacter 
    local job = Character.job
    local shopData = shopsData[MarketPlace] and shopsData[MarketPlace].MarketTable or {}
   
  
    exports.ghmattimysql:execute('SELECT inventory FROM characters WHERE identifier = @identifier', { ['@identifier'] = {Character.identifier} }, function(result)
        if result[1] ~= nil and result[1].inventory ~= nil then
            
            local playerInventory = {}
            for k,v in pairs(json.decode(result[1].inventory)) do
                table.insert(playerInventory, {
                    Id       = k,
                    Label    = k,
                    Quantity = v
                })
            end

            TriggerClientEvent("DVR_shops:openShop", _source, shopData, job, playerInventory, MarketPlace)
        end
    end)
end)

RegisterNetEvent('DVR_shops:removeprice:additem')
AddEventHandler('DVR_shops:removeprice:additem', function(shopName, quantity, item)
    local _source = source
    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    local job = Character.job
    local money = Character.money
    local shopData = shopsData[shopName] and shopsData[shopName].MarketTable or {}

    local itemIndex = nil

    for i = 1, #shopData do
        if shopData[i].item == item then
            itemIndex = i
        end
    end

    local price
    local itemLabel

    if itemIndex ~= nil then
        price = shopData[itemIndex].price * quantity
        itemLabel = shopData[itemIndex].label
    else
        for i = 1, #Config.items do
            if Config.items[i].item == item then
                price = Config.items[i].price
                itemLabel = Config.items[i].label
            end
        end
    end

    if job == Config.JobName[1] or job == Config.JobName[2] then 
        TriggerClientEvent("vorp:TipRight", _source, Config[22].text.. ' [' .. itemLabel .. '] ', 4000)
        if Config.OnlyJob then
            shopData[itemIndex].qty = shopData[itemIndex].qty - quantity
            VorpInv.addItem(_source, item, quantity)

            if shopData[itemIndex].qty <= 0 then
                table.remove(shopData, itemIndex)
            end

            exports.ghmattimysql:execute("UPDATE shops SET MarketTable = @MarketTable WHERE MarketPlace = @MarketPlace", {['@MarketPlace'] = shopName, ['@MarketTable'] = json.encode(shopData)})
        end
    else
        if money >= tonumber(price) then
            if Config.OnlyJob then
                
                shopData[itemIndex].qty = shopData[itemIndex].qty - quantity
                VorpInv.addItem(_source, item, quantity)

                if job ~= Config.JobName[1] or job ~= Config.JobName[2] then 
                    if Config.syn_society then 
                        if shopName == "Strawberry" or shopName == "Blackwater" or shopName == "Armadillo" or shopName == "Tumbleweed" then
                            TriggerClientEvent('DVR_shops:addbill2', _source, price)
                            TriggerClientEvent("vorp:TipRight", _source, Config[4].text.. ' [' .. itemLabel .. '] ', 4000)
                        else
                            TriggerClientEvent('DVR_shops:addbill', _source, price)
                            TriggerClientEvent("vorp:TipRight", _source, Config[4].text.. ' [' .. itemLabel .. '] ', 4000)
                        end
                    else
                        TriggerEvent("vorp:removeMoney", _source, 0, price)
                        TriggerClientEvent("vorp:TipRight", _source, Config[4].text.. ' [' .. itemLabel .. '] ', 4000)
                    end
                end

                if shopData[itemIndex].qty <= 0 then
                    table.remove(shopData, itemIndex)
                end

                exports.ghmattimysql:execute("UPDATE shops SET MarketTable = @MarketTable WHERE MarketPlace = @MarketPlace", {['@MarketPlace'] = shopName, ['@MarketTable'] = json.encode(shopData)})
            else
                VorpInv.addItem(_source, item, quantity)
                TriggerEvent("vorp:removeMoney", _source, 0, price)
                TriggerClientEvent("vorp:TipRight", _source, Config[4].text.. ' [' ..itemLabel.. '] ', 4000)
            end
        else
            TriggerClientEvent("vorp:TipRight", _source, Config[10].text, 4000)
        end
    end
end)

RegisterNetEvent('DVR_shops:completeitem')
AddEventHandler('DVR_shops:completeitem', function(Items, MarketPlace)
    local _source = source
    local User = VorpCore.getUser(_source)
    local Character = User.getUsedCharacter
    local shopData = shopsData[MarketPlace] and shopsData[MarketPlace].MarketTable or {}
    local shopExist = shopsData[MarketPlace]
    local typeRequest

    if shopExist then
        typeRequest = "update"
    else
        shopsData[MarketPlace] = {
            MarketPlace = MarketPlace,
            MarketTable =  {}
        }

        shopData  = shopsData[MarketPlace].MarketTable
        typeRequest = "insert"
    end

    for i = 1, #Items do
        local itemIndex = nil

        for i2 = 1, #shopData do
            if shopData[i2].item == Items[i].item then
                itemIndex = i2
            end
        end

        if itemIndex then
            shopData[itemIndex].qty = shopData[itemIndex].qty + Items[i].qty
            TriggerClientEvent('DVR_shops:closemenuRefreshClient', _source,  Items[i].item, Items[i].qty)
        else
            TriggerClientEvent('DVR_shops:closemenuRefreshClient', _source,  Items[i].item, Items[i].qty)
            table.insert(shopData, {
                item  = Items[i].item,
                qty   = Items[i].qty,
                price = Items[i].price,
                label = Items[i].label,
                shop  = Items[i].shops
            })
        end
    end

    if typeRequest == "update" then
        exports.ghmattimysql:execute("UPDATE shops SET MarketTable = @MarketTable WHERE MarketPlace = @MarketPlace", {['@MarketPlace'] = MarketPlace, ['@MarketTable'] = json.encode(shopData)})
    else
        exports.ghmattimysql:execute("INSERT INTO shops (MarketTable, MarketPlace) VALUES (@MarketTable, @MarketPlace) ", {['MarketTable'] = json.encode(shopData), ['@MarketPlace'] = MarketPlace})
    end
end)

RegisterNetEvent('DVR_shops:executelog')
AddEventHandler('DVR_shops:executelog', function(raison)
    local playerName = GetPlayerName(source)
    local playerHex = GetPlayerIdentifier(source)
    local connecting = {
        {
            ["color"] = "15844367",
            ["title"] = "Log Shops",
            ["description"] = "Le joueurs: *"..playerName.."*\n\nPlayer Steam Hex: *"..playerHex,
	        ["footer"] = {
                ["text"] = raison,
                ["icon_url"] = Config.Discord_logo,
            },
        }
    }
    PerformHttpRequest(Config.Discord_webhook, function (err, text, headers) end, 'POST', json.encode({username = raison, embeds = connecting}), { ['Content-Type'] = 'application/json' })
end)

RegisterNetEvent('DVR_shops:removeitem')
AddEventHandler('DVR_shops:removeitem', function(item, qty)
    local _source = source
    local count = VorpInv.getItemCount(_source, item)
    if count >= tonumber(qty) then 
        VorpInv.subItem(_source, item, qty)
        TriggerClientEvent('DVR_shops:closemenu', _source)
    else
        TriggerClientEvent("vorp:TipRight", _source, Config[20].text, 4000)
    end
end)


