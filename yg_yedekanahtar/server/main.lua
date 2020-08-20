ESX = nil
local cars = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('yg_givecarkeys:requestPlayerCars', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @identifier',
		{
			['@identifier'] = xPlayer.identifier
		},
		function(result)
			local found = false
			for i=1, #result, 1 do
				local vehicleProps = json.decode(result[i].vehicle)
				if trim(vehicleProps.plate) == trim(plate) then
					found = true
					break
				end
			end
			if found then
				cb(true)
			else
				cb(false)
			end
		end
	)
end)

RegisterServerEvent('yg_givecarkeys:frommenu')
AddEventHandler('yg_givecarkeys:frommenu', function ()
	TriggerClientEvent('yg_givecarkeys:keys', source)
end)

function trim(s)
    if s ~= nil then
		return s:match("^%s*(.-)%s*$")
	else
		return nil
    end
end

RegisterServerEvent('yg_givecarkeys:setVehicleOwnedPlayerId')
AddEventHandler('yg_givecarkeys:setVehicleOwnedPlayerId', function (playerId, vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	MySQL.Async.execute('INSERT INTO `owned_vehicles`(`owner`, `plate`) VALUES (@owner,@plate)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate
	},
	function (rowsChanged)
		TriggerClientEvent('esx:showNotification', playerId, 'Yedek anahtarı aldın ~g~' ..vehicleProps.plate..'!', vehicleProps.plate)
	end)
end)

RegisterServerEvent('yg_givecarkeys:DeleteOwnedPlayerVehicle')
AddEventHandler('yg_givecarkeys:DeleteOwnedPlayerVehicle', function (playerId, vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	MySQL.Async.execute('DELETE FROM `owned_vehicles` WHERE owner = @owner AND plate = @plate',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate
	},

	function (rowsChanged)
		TriggerClientEvent('esx:showNotification', playerId, 'Yedek anahtarı geri alır aldın ~g~' ..vehicleProps.plate..'!', vehicleProps.plate)
	end)
end)

RegisterCommand('yedekanahtarver', function(source, args, user)
TriggerClientEvent('yg_givecarkeys:keys', source)
end)

RegisterCommand('yedekanahtaral', function(source, args, user)
	TriggerClientEvent('yg_givecarkeys:deletekeys', source)
end)
