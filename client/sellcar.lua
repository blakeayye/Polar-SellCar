local QBCore = exports['qb-core']:GetCoreObject()
CreateThread(function()
    --spawnpeds()
    
end)
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        spawnpeds()
    end
end)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(100)
    spawnpeds()
    
end)

function IsVehicleOwned(plate)
	local p = promise.new()
	QBCore.Functions.TriggerCallback('Polar-Sub:Server:GetCars', function(cb) p:resolve(cb) end, plate)
    return Citizen.Await(p)
end
function trim(value)
	if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

RegisterNetEvent('Polar-Sub:Client:SellCar', function()
   
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local pp = GetEntityModel(vehicle)
    local vehicleHash = GetHashKey(vehicle)
    --print(vehicleHash)
    if IsPedInAnyVehicle(playerPed, false) then
        
    if not IsVehicleOwned(trim(GetVehicleNumberPlateText(vehicle))) then
        QBCore.Functions.Notify('You do not own this Vehicle', 'error', 3500)
    else
    local plate = GetVehicleNumberPlateText(vehicle)
    local money = 'cash' 
    QBCore.Functions.DeleteVehicle(vehicle)
    TriggerServerEvent('Polar-Sub:Server:Sell', money, pp, plate)
    end
    else
        QBCore.Functions.Notify('Youre not in a car', 'error', 3500)
    end
end)




function spawnpeds()
 
    exports['qb-target']:SpawnPed({
        model = 'a_m_m_genfat_01',
        coords = vector4(133.52, -3007.35, 6.46, 176.18),
        minusOne = true,
        freeze = true,
        invincible = false,
        blockevents = true,
        scenario = 'PROP_HUMAN_SEAT_CHAIR',
        target = {
            options = {
            {
                type = "Client",
                icon = 'fa-solid fa-bolt',
                label = 'Open Menu',
                job = "cardealer",
               event = 'Polar-Sub:Client:OpenCarMenu',
            }
            },
            distance = 4.5,
        },
    })
    

end

RegisterNetEvent('Polar-Sub:Client:OpenCarMenu', function()


    exports['qb-menu']:openMenu({
        { 
            header = 'Import Management',
            icon = 'fa-solid fa-bolt',
            txt = "All your dealership Needs",
            isMenuHeader = true
        },
        {   
            icon = 'fa-solid fa-car"',
            header = "Sell Vehicle",
            txt = "Sell your import back to the dealership",
            params = { 
                event = "Polar-Sub:Client:SellCar",
               
            }
        },
          
    })


end)











