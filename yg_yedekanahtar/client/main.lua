ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function giveCarKeys()
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)

	if IsPedInAnyVehicle(playerPed,  false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)			
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 70)
    end

	local plate = GetVehicleNumberPlateText(vehicle)
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)


	ESX.TriggerServerCallback('yg_givecarkeys:requestPlayerCars', function(isOwnedVehicle)
		if isOwnedVehicle then
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

if closestPlayer == -1 or closestDistance > 3.0 then
    ESX.ShowNotification('Yakında kimse yok')
else
    ESX.ShowNotification('Aracının yedek anahtarın ıveriyorsun :~g~'..vehicleProps.plate..'!')
    TriggerServerEvent('yg_givecarkeys:setVehicleOwnedPlayerId', GetPlayerServerId(closestPlayer), vehicleProps)
end

		end
	end, GetVehicleNumberPlateText(vehicle))
end

RegisterNetEvent("yg_givecarkeys:deletekeys")
AddEventHandler("yg_givecarkeys:deletekeys", function()
	deleteCarKeys()
end)

RegisterNetEvent("yg_givecarkeys:keys")
AddEventHandler("yg_givecarkeys:keys", function()
	giveCarKeys()
end)

function deleteCarKeys()
	local playerPed = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)

	if IsPedInAnyVehicle(playerPed,  false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)			
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 70)
	end
	
	local plate = GetVehicleNumberPlateText(vehicle)
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
	ESX.TriggerServerCallback('yg_givecarkeys:requestPlayerCars', function(isOwnedVehicle)
		if isOwnedVehicle then
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		
			if closestPlayer == -1 or closestDistance > 3.0 then
    			ESX.ShowNotification('Yakında kimse yok')
			else
    			ESX.ShowNotification('Aracının yedek anahtarını geri alıyorsun :~g~'..vehicleProps.plate..'!')
    			TriggerServerEvent('yg_givecarkeys:DeleteOwnedPlayerVehicle', GetPlayerServerId(closestPlayer), vehicleProps)
			end
		end
	end, GetVehicleNumberPlateText(vehicle))
end