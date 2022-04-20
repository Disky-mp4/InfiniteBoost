--[[--------------------------------------------------------------------
-- Name: InfiniteBoost
-- Description: Instant recharge for vehicles with boost in FiveM.
-- Author: Disky
--]]--------------------------------------------------------------------

RegisterNetEvent("permissionsCheck")
AddEventHandler("permissionsCheck", function(permissionObject, attempted)
    local src = source
    if IsPlayerAceAllowed(src, permissionObject) then
        TriggerClientEvent("permissionsCheckPassed", src, attempted)
    end
end)