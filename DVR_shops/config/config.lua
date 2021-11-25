Config = {
    OnlyJob = true, -- [EN] If you want to put it in automatic // [IT] Se vuoi metterlo in automatico
    JobName = {'market', 'market2'}, -- [EN] Job name // [IT] Nome del lavoro
    MaxPrice = 20, -- [EN] Maximum price $ allowed // [IT] Prezzo massimo $ consentito
    Marker = true, -- [EN] If you want the marker on the ground // [IT] Se vuoi il pennarello a terra

    -- Log discord
    Discord_logo = ("https://cdn.discordapp.com/attachments/723512745638625332/807669046161965137/red.png"),
    Discord_webhook = ("https://discord.com/api/webhooks/913494180179886090/-O6XsXDBw5e2XthXC1maDCRjnHqA5hoFxjDvfwrr5SGUULp_obcCEY46xprolvFNJZLL"),

    --  Options for script syn (discord : https://discord.gg/A2AUmtpEga)
    --  [EN] If syn_society it is set to 'false' then it will withdraw the money directly from the players // [IT] Se è impostato su "false", ritirerà i soldi direttamente dai giocatori
    TaxeAmount = 2, -- [EN] Tax division example priceshops/2 // [IT] Esempio di divisione fiscale prezzi negozi/2
    Taxe = true, -- [EN] Implies a tax on the value of the prize for the government // [IT] Implica una tassa sul valore del premio per il governo
    syn_society = true, -- [EN] If you use syn_society credit directly to the company safe // [IT] Se usi syn_society accredito direttamente alla cassaforte aziendale
    [25] =  {text = "market"}, -- Warning !!!! ->  [EN] Name of the job to be credited if you use syn society // [IT] Nome del lavoro da accreditare se usi syn society
    [26] =  {text = "gouv"}, -- Warning !!!! ->  [EN] Name of the job to be credited if you use syn society for taxe // [IT] Nome del lavoro da accreditare se usi syn society per le tasse
    [27] =  {text = "market2"}, -- Warning !!!! ->  [EN] Name of the job2 to be credited if you use syn society for taxe // [IT] Nome del lavoro2 da accreditare se usi syn society per le tasse

    -- [EN] Language If you want to change the language I made the work for you in lang.txt // [IT] Lingua Se vuoi cambiare la lingua ho fatto il lavoro per te in lang.txt
    -- FR
    [1]  =  {text = "Accepter"},
    [2]  =  {text = "Combien"},
    [3]  =  {text = "Vous en prennez trop !"},
    [4]  =  {text = "Merci pour l'achat !"},
    [6]  =  {text = "Prix de l'item"},
    [7]  =  {text = "Mauvaise information"},
    [8]  =  {text = "Mauvais nom de l'item"},
    [9]  =  {text = "Vous en avez pas assez sur vous"},
    [10] =  {text = "Vous n'avez pas assez d'argent"},
    [12] =  {text = "Prix"},
    [13] =  {text = "$"},
    [14] =  {text = "Ville"},
    [15] =  {text = "Mauvaise ville"},
    [16] =  {text = "↓↓↓ Inventory ↓↓↓"},
    [17] =  {text = "Ajouter des items"},
    [18] =  {text = "Shops"},
    [19] =  {text = "Valider"},
    [20] =  {text = "Vous n'avez pas assez d'item sur vous!"},
    [21] =  {text = "Vous n'êtes pas autoriser a vendre au dessu de 20$!"},
    [22] =  {text = "Vous avez retirer du magasin"},
    [23] =  {text = "Ouvrir le magasin"},
    [24] =  {text = "Fermer"},
    [28] =  {text = "Fait une action"},

    -- [EN] item not for the job // [IT] articolo non adatto al lavoro
    -- [EN] Only for self-service // [IT] Solo per self-service
    items = {
        {item = 'eau',  label = 'Eau',  price = 0.50},
        {item = 'pain', label = 'Pain', price = 0.90},
        --{item = 'item', label = 'Name Item', price = 0.00}
    },

    -- Store locations // [IT] Punti vendita
    -- shops = "SaintDenis =  Warning !!!! [EN] Name that will be in bdd // [IT] Nome che sarà in bdd
    Shops = {
        {shops = "SaintDenis",  coords = vector3(2825.852, -1318.371, 46.75),     color = GetHashKey('BLIP_MODIFIER_MP_COLOR_14'), blips = 1475879922, blipsName = 'Shops'},
        {shops = "Valentine",   coords = vector3(-322.1894, 803.2299, 117.8817),  color = GetHashKey('BLIP_MODIFIER_MP_COLOR_14'), blips = 1475879922, blipsName = 'Shops'},
        {shops = "Strawberry",  coords = vector3(-1790.101, -386.8658, 160.3451), color = GetHashKey('BLIP_MODIFIER_MP_COLOR_14'), blips = 1475879922, blipsName = 'Shops'},
        {shops = "Blackwater",  coords = vector3(-785.4939, -1323.836, 43.89418), color = GetHashKey('BLIP_MODIFIER_MP_COLOR_14'), blips = 1475879922, blipsName = 'Shops'},
        {shops = "Armadillo",   coords = vector3(-3685.553, -2623.502, -13.42116),color = GetHashKey('BLIP_MODIFIER_MP_COLOR_14'), blips = 1475879922, blipsName = 'Shops'},
        {shops = "Tumbleweed",  coords = vector3(-5487.372, -2938.807, -0.37702), color = GetHashKey('BLIP_MODIFIER_MP_COLOR_14'), blips = 1475879922, blipsName = 'Shops'},
        {shops = "Rhodes",      coords = vector3(1328.736, -1292.252, 77.03336),  color = GetHashKey('BLIP_MODIFIER_MP_COLOR_14'), blips = 1475879922, blipsName = 'Shops'},
        {shops = "VanHorn",     coords = vector3(3027.18, 561.8342, 44.72365),    color = GetHashKey('BLIP_MODIFIER_MP_COLOR_14'), blips = 1475879922, blipsName = 'Shops'}
    }
}

-- Change "color = GetHashKey('BLIP_MODIFIER_MP_COLOR_14')" https://github.com/femga/rdr3_discoveries/tree/master/useful_info_from_rpfs/colours
-- Change "blips = 1475879922," https://github.com/femga/rdr3_discoveries/tree/master/useful_info_from_rpfs/textures/blips_mp