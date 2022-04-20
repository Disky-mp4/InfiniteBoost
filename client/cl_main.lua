--[[--------------------------------------------------------------------
-- Name: InfiniteBoost
-- Description: Instant recharge for vehicles with boost in FiveM.
-- Author: Disky
--]]--------------------------------------------------------------------

local threadRunning = true;

local function notify(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    EndTextCommandThefeedPostTicker(true, true)
end

RegisterNetEvent("persistResetBoost")
AddEventHandler("persistResetBoost", function()
    Citizen.CreateThread(function()
        while threadRunning do
            Wait(200)
            local playerVeh = GetVehiclePedIsIn(PlayerPedId())
    
            if GetHasRocketBoost(playerVeh) and not IsVehicleRocketBoostActive(playerVeh) then
                SetVehicleRocketBoostPercentage(playerVeh, 1.0)
            end
        end
    end)
end)

TriggerEvent("persistResetBoost")

local function permsCheckFunc(attempted)
    if CONFIG["usePermissions"] and #CONFIG["permissionObject"] > 0 then
        TriggerServerEvent("permissionsCheck", CONFIG["permissionObject"], attempted)
    else
        commands[attempted].callback()
    end
end

local commands = {
    infiniteboost = {
        name = "infiniteboost",
        type = "defaultCommand",
        permsCheck = function()
            permsCheckFunc("infiniteboost")
        end,
        callback = function()
            threadRunning = true
            TriggerEvent("persistResetBoost")
            notify("Instant boost recharge enabled.")
        end
    },
    stopinfiniteboost = {
        name = "stopinfiniteboost",
        type = "defaultCommand",
        permsCheck = function()
            permsCheckFunc("stopinfiniteboost")
        end,
        callback = function()
            threadRunning = false
            notify("Instant boost recharge disabled.")
        end
    },
    spawnoppressor = {
        name = "spawnoppressor",
        type = "spawnCommand",
        permsCheck = function()
            permsCheckFunc("spawnoppressor")
        end,
        callback = function()
            local ped = PlayerPedId()
            local vehicle = GetHashKey("oppressor")
            RequestModel(vehicle)
            while not HasModelLoaded(vehicle) do
                Citizen.Wait(0)
            end
            local oppressor = CreateVehicle(vehicle, GetEntityCoords(ped), GetEntityHeading(ped), true, true)
            SetPedIntoVehicle(ped, oppressor, -1)
        end
    },
    spawnvoltic = {
        name = "spawnvoltic",
        type = "spawnCommand",
        permsCheck = function()
            permsCheckFunc("spawnvoltic")
        end,
        callback = function()
            local ped = PlayerPedId()
            local vehicle = GetHashKey("voltic2")
            RequestModel(vehicle)
            while not HasModelLoaded(vehicle) do
                Citizen.Wait(0)
            end
            local voltic = CreateVehicle(vehicle, GetEntityCoords(ped), GetEntityHeading(ped), true, true)
            SetPedIntoVehicle(ped, voltic, -1)
        end
    }
}

RegisterNetEvent("permissionsCheckPassed")
AddEventHandler("permissionsCheckPassed", function(attempted)
    commands[attempted].callback()
end)

for _, cmd in pairs(commands) do
    if CONFIG.spawnVehCommandsEnabled and cmd.type == "spawnCommand" then return end
    RegisterCommand(cmd.name, cmd.permsCheck)
end