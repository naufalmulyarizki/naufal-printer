local ESX = exports['es_extended']:getSharedObject()
local ValidExtensionsText = '.png, .gif, .jpg, .jpeg'
local ValidExtensions = {
    [".png"] = true,
    [".gif"] = true,
    [".jpg"] = true,
    ["jpeg"] = true
}

RegisterNetEvent('naufal-printer:server:SaveDocument', function(url, total, label, hitamputih)
    local src = source
    local extension = string.sub(url, -4)
    local validexts = ValidExtensions
    if url ~= nil then
        if validexts[extension] then
            local info = {
				label = label,
                url = url,
				imageurl = url,
				inihitamputih = hitamputih
            }
			local xPlayer = ESX.GetPlayerFromId(src)
			local time = os.date('*t')
            info.description = 'Dibuat : '..xPlayer.getName()..'  \n   Date and Time: ' .. time.day .. '/'  .. time.month .. '/' .. time.year .. ' - ' .. time.hour .. ':' .. time.min .. ' \n Hitam Putih : '..tostring(hitamputih)..' '

			exports.ox_inventory:RemoveItem(source, 'kertashvs', total)
            exports.ox_inventory:AddItem(source, 'printerdocument', total, info)
        end
    end
end)

RegisterServerEvent('naufal-printer:server:showdocumets')
AddEventHandler('naufal-printer:server:showdocumets', function(types, item, players, hitamputih)
	if types == 'player' then
		TriggerClientEvent('naufal-printer:client:UseDocument', tonumber(players), item, hitamputih)
	else
		for k,v in pairs(players) do
			TriggerClientEvent('naufal-printer:client:UseDocument', v, item, hitamputih)
		end
	end
end)

-- Command Spawn printer
lib.addCommand('spawnprinter', {
    help = 'Spawn Printer',
    restricted = 'group.admin'
}, function(source, args, raw)
	local src = source
    TriggerClientEvent('naufal-printer:client:SpawnPrinter', src)
end)