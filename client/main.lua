local ESX = exports['es_extended']:getSharedObject()

-- Function
-- Fungsi untuk membuat request animasi, biar animasi bisa digunakan butuh di request dlu
local function SharedRequestAnimDict(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Wait(1)
		end
	end
	if cb ~= nil then
		cb()
	end
end

-- Fungsi untuk membuat prop dict
local function LoadPropDict(model)
    while not HasModelLoaded(GetHashKey(model)) do
        RequestModel(GetHashKey(model))
        Wait(10)
    end
end

-- Fungsi untuk mendapatkan player di sekitar client
local function GetPlayersFromCoords(coords, distance)
    local players = GetActivePlayers()
    local ped = PlayerPedId()
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    distance = distance or 5
    local closePlayers = {}
    for _, player in pairs(players) do
        local target = GetPlayerPed(player)
        local targetCoords = GetEntityCoords(target)
        local targetdistance = #(targetCoords - coords)
        if targetdistance <= distance then
            closePlayers[#closePlayers + 1] = GetPlayerServerId(player)
        end
    end
    return closePlayers
end

-- exports
-- exports untuk show item dari client item ox inventory
exports('printer:useitem', function(data, slot)
    TriggerEvent('naufal-printer:showAroundClientPhoto', slot.metadata.url, slot.metadata.inihitamputih)
    exports.ox_inventory:closeInventory()
end)

-- Events
-- event untuk opsi mau ditunjukan ke semua player, diri sendiri atau ke orang yang dipilih aja
RegisterNetEvent("naufal-printer:showAroundClientPhoto")
AddEventHandler("naufal-printer:showAroundClientPhoto",function(photo, hitamputih)
    lib.registerContext({
        id = 'naufal-printer:showtoplayer',
        title = 'Kertas Dokumen',
        options = {
            {
                title = locale('title_show_self_id_card'),
                description = locale('description_show_self_id_card'),
                icon = 'file',
                onSelect = function()
                    TriggerEvent('naufal-printer:client:UseDocument', photo, hitamputih)
                end
            },
            {
                title = locale('title_show_around_id_card'),
                description = locale('description_show_around_id_card'),
                icon = 'file',
                arrow = true,
                onSelect = function()
                    TriggerServerEvent("naufal-printer:server:showdocumets", 'allplayer', photo, GetPlayersFromCoords(GetEntityCoords(PlayerPedId())), hitamputih)
                end
            },
            {
                title = locale('title_show_target_id_card'),
                description = locale('description_show_target_id_card'),
                icon = 'file',
                arrow = true,
                onSelect = function()
                    local playerPed = PlayerPedId()
                    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
                    local foundPlayers = false
                    local GiveMenu = {}
                
                    for i = 1, #players, 1 do
                        if players[i] ~= PlayerId() then
                            foundPlayers = true
                            table.insert(GiveMenu,  {
                                title = 'ID : '.. GetPlayerServerId(players[i]),
                                description = locale('description_context_target_id_card'),
                                icon = 'person',
                                onSelect = function()
                                    TriggerServerEvent('naufal-printer:server:showdocumets', 'player', item, GetPlayerServerId(players[i]), hitamputih)
                                end,
                            })
                        end
                    end
                    
                    if not foundPlayers then
                        ESX.ShowNotification(locale('notify_error_target_id_card'), 2)
                    else
                        if #players == 1 then
                            -- 
                        else
                            lib.registerContext({
                                id = 'showdocument',
                                title = locale('title_showcontext_target_id_card'),
                                menu = 'naufal-printer:showtoplayer',
                                options = GiveMenu
                            })
                    
                            lib.showContext('showdocument')
                        end
                    end
                end
            },
        }
    })
    lib.showContext('naufal-printer:showtoplayer')
end)

RegisterNetEvent("naufal-printer:client:UseDocument", function(DocumentUrl, hitamputih)
    if not photoactive then
        photoactive = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "open",
            url = DocumentUrl,
            hitamputih = hitamputih
        })
        local ped = PlayerPedId()
        SharedRequestAnimDict("amb@world_human_tourist_map@male@base", function()
            TaskPlayAnim(ped, "amb@world_human_tourist_map@male@base", "base", 2.0, 2.0, -1, 1, 0, false, false, false)
        end)
        local x,y,z = table.unpack(GetEntityCoords(ped))
        if not HasModelLoaded("p_amb_clipboard_01") then
            LoadPropDict("p_amb_clipboard_01")
        end
        photoprop = CreateObject(GetHashKey("p_amb_clipboard_01"), x, y, z+0.2,  true,  true, true)
        AttachEntityToEntity(photoprop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        SetModelAsNoLongerNeeded("p_amb_clipboard_01")
    end
end)

RegisterNetEvent('naufal-printer:client:SpawnPrinter', function()
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    local forward   = GetEntityForwardVector(playerPed)
    local x, y, z   = table.unpack(coords + forward * 1.0)

    local model = `prop_printer_01`
    RequestModel(model)
    while (not HasModelLoaded(model)) do
        Wait(1)
    end
    local obj = CreateObject(model, x, y, z, true, false, true)
    PlaceObjectOnGroundProperly(obj)
    SetModelAsNoLongerNeeded(model)
    SetEntityAsMissionEntity(obj)
end)

RegisterNetEvent('naufal-printer:printer',function(data)
    if Config.NUI then
        local ox_inventory = exports.ox_inventory
        local kertas = ox_inventory:Search(2, 'kertashvs')
        if kertas >= 1 then
            SendNUIMessage({
                action = "start"
            })
            SetNuiFocus(true, true)
        else
            ESX.ShowNotification(locale('notify_error_enough_item'), 'error')
        end
    else
        local ox_inventory = exports.ox_inventory
        local kertas = ox_inventory:Search(2, 'kertashvs')
        local input = lib.inputDialog('Printer Kertas', {
            {type = 'input', label = locale('title_input_label_dialog_menu_printer'), description = locale('description_input_label_dialog_menu_printer'), required = true, icon = 'clipboard', placeholder = ''},
            {type = 'input', label = locale('title_input_label_dialog_menu_printer'), description = 'Masukkan link image untuk diprint', required = true, icon = 'clipboard', placeholder = 'https://cdn.discordapp.com/attachments/1067547448333049916/1228043190255222815/IMG-20230227-WA0005.jpg?ex=66332d18&is=6631db98&hm=61247548d47168892bbf8f30ae1d3d0d1ed8580350c95255877ed3f075e3ee70&.png'},
            {type = 'number', label = locale('title_input_number_amount_printer_dialog_menu_printer'), description = locale('description_input_number_amount_printer_dialog_menu_printer'), icon = 'hashtag', required = true, default = 1},
            {type = 'checkbox', label = locale('title_input_black_and_white_dialog_menu_printer')},
        })

        if not input or not input[1] or not input[2] or not tonumber(input[3]) then return end

        if kertas >= tonumber(input[3]) then
            TriggerServerEvent('naufal-printer:server:SaveDocument', input[2], tonumber(input[3]), input[1], input[4])
        else
            ESX.ShowNotification(locale('notify_error_enough_item'), 'error')
        end 
    end
end)

-- NUI
RegisterNUICallback('SaveDocument', function(data, cb)
    if data.url then
        TriggerServerEvent('naufal-printer:server:SaveDocument', data.url, 1, 'Dokumen', true)
    end
    cb('ok')
end)

RegisterNUICallback("CloseDocument", function(data, cb)
    SetNuiFocus(false, false)
    photoactive = false
    if photoprop then DeleteEntity(photoprop) end
    ExecuteCommand('propfix')
    ClearPedTasks(PlayerPedId())
    cb('ok')
end)

-- Threads
if Config.Target == "qtarget" then
    CreateThread(function()
        exports.qtarget:AddTargetModel(Config.printers, {
            options = {
                {
                    event = 'naufal-printer:printer',
                    icon = "fas fa-print",
                    label = locale('title_target_printer'),
                    dokumen = true,
                },
            },
            distance = 1.5,
        })

        for k,v in ipairs(Config.Location['printer']) do
            exports['qtarget']:AddBoxZone("printer" .. k, v.coords, 2, 2, {
                name = "printer" .. k,
                heading = 0,
                -- debugPoly = true,
                minZ = v.coords.z - 1,
                maxZ = v.coords.z + 1,
            }, {
                options = {
                    {
                        event = "naufal-printer:printer",
                        icon = "fas fa-print",
                        label = locale('title_target_printer'),
                        job = v.groups
                    },
                },
                distance = 2.5
            })
        end
    end)
elseif Config.Target == "qb-target" then
    CreateThread(function()
        exports['qb-target']:AddTargetModel(Config.printers, {
            options = {
                {
                    event = 'naufal-printer:printer',
                    icon = "fas fa-print",
                    label = locale('title_target_printer'),
                    dokumen = true,
                },
            },
            distance = 1.5,
        })

        for k,v in ipairs(Config.Location['printer']) do
            exports['qb-target']:AddBoxZone("printer" .. k, v.coords, 2, 2, {
                name = "printer" .. k,
                heading = 0,
                -- debugPoly = true,
                minZ = v.coords.z - 1,
                maxZ = v.coords.z + 1,
            }, {
                options = {
                    {
                        event = "naufal-printer:printer",
                        icon = "fas fa-print",
                        label = locale('title_target_printer'),
                        job = v.groups
                    },
                },
                distance = 2.5
            })
        end
    end)
elseif Config.Target == "bttarget" then
    CreateThread(function()
        exports['bt-target']:AddTargetModel(Config.printers, {
            options = {
                {
                    event = 'naufal-printer:print1er',
                    icon = "fas fa-print",
                    label = locale('title_target_printer'),
                    dokumen = true,
                },
            },
            distance = 1.5,
        })

        exports['bt-target']:AddBoxZone("printer" .. k, v.coords, 2, 2, {
            name = "printer" .. k,
            heading = 0,
            -- debugPoly = true,
            minZ = v.coords.z - 1,
            maxZ = v.coords.z + 1,
        }, {
            options = {
                {
                    event = "naufal-printer:printer",
                    icon = "fas fa-print",
                    label = locale('title_target_printer'),
                    job = v.groups
                },
            },
            distance = 2.5
        })
    end)
elseif Config.Target == "ox_target" then
    CreateThread(function()
        exports.ox_target:addModel(Config.printers, {
            {
                event = "naufal-printer:printer",
                icon = "fas fa-print",
                label = locale('title_target_printer'),
            },
        })

        for k,v in ipairs(Config.Location['printer']) do
            exports.ox_target:addBoxZone({
                name = "printer" .. k,
                radius = v.radius,
                coords = v.coords,
                size = v.size,
                debug = v.debug,
                rotation = v.rotation,
                options = {
                    {
                        event = "naufal-printer:printer",
                        icon = "fas fa-print",
                        label = locale('title_target_printer'),
                        groups = v.groups
                    },
                },
            })
        end
    end)
end
