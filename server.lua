local QBCore = exports['qb-core']:GetCoreObject()
lib.locale()

lib.addCommand(Config.Command, {
    help = 'Open the admin player menu',
    restricted = Config.Restricted
}, function(source)
    local players = QBCore.Functions.GetPlayers()
    local playerDetails = {}

    -- Fetch details for each player
    -- Because of this it will only refresh menu (health, armor, etc) when opening it.
    for _, playerId in pairs(players) do
        local player = QBCore.Functions.GetPlayer(playerId)

        if player then
            local details = GetPlayerDetails(player)
            table.insert(playerDetails, {
                playerId = playerId,
                details = details
            })
            --print("Player: " .. details.name .. ", Cash: €" .. details.cash .. ", Bank: €" .. details.bank)
        end
    end
    --print("Sending player details to client...")
    TriggerClientEvent('adminmenu:showPlayerMenu', source, playerDetails)
end)

-- If admin get Keybind
RegisterServerEvent('adminlookup:server:checkkAdminPermissions')
AddEventHandler('adminlookup:server:checkkAdminPermissions', function()
    local playerId = source
    if IsPlayerAceAllowed(playerId, 'command.adminlookup') then
        TriggerClientEvent('adminlookup:client:setupKeybind', playerId)  -- Notify the client to add the keybind
    end
end)

-- TODO: Add multiple phone support like lb-phone with a option in config.lua: Config.Phone = "lb-phone" -- "qb-phone", "lb-phone", "otherphone"
function GetPhoneNumber(citizenid)
    local result = MySQL.query.await('SELECT charinfo FROM players WHERE citizenid = ?', { citizenid })

    if result and result[1] then
        local charinfo = json.decode(result[1].charinfo)
        if charinfo and charinfo.phone then
            return charinfo.phone
        end
    end

    return nil  -- Return nil if no phone number is found
end

-- Fetch specific vehicle fields (vehicle, mods, plate, fuel, engine, body, garage)
function GetVehicles(citizenid)
    local vehicles = MySQL.query.await('SELECT vehicle, mods, plate, fuel, engine, body, garage FROM player_vehicles WHERE citizenid = ?', { citizenid })
    return vehicles or {}
end

-- Fetch player details
function GetPlayerDetails(player)
    local playerData = player.PlayerData
    local playerMeta = player.PlayerData.metadata
    local playerInfo = player.PlayerData.charinfo
    local citizenid = playerData.citizenid
    local phoneNumber = GetPhoneNumber(citizenid) or "N/A" -- Fetching phoneNumber with oxmysql, why? If you use lb-phone for example, you gotta use exports or oxmysql easy to change that in server.lua ;-)

    -- Get player ped to fetch health and armor
    local playerPed = GetPlayerPed(playerData.source)
    local health = GetEntityHealth(playerPed) - 100 -- Health returns 0-200, subtract 100 for a range of 0-100
    local armor = GetPedArmour(playerPed) -- Armor returns 0-100

    return {
        citizenid = citizenid,  -- Include citizenid for future use
        id = playerData.source,
        name = string.format("%s %s", playerInfo.firstname, playerInfo.lastname),
        nationality = playerInfo.nationality,
        birthdate = playerInfo.birthdate,
        gender = playerInfo.gender,
        job = string.format("%s - %s", playerData.job.label, playerData.job.grade.name),
        isboss = playerData.job.isboss or false,
        jobpayment = playerData.job.payment or "0",
        jobgrade = playerData.job.grade.level or "N/A",
        gang = string.format("%s - %s", playerData.gang.label, playerData.gang.grade.name),
        cash = playerData.money["cash"] or 0,
        bank = playerData.money["bank"] or 0,
        phone = phoneNumber or "N/A",
        health = health,
        armor = armor,
        hunger = playerMeta['hunger'] or "N/A",
        thirst = playerMeta['thirst'] or "N/A",
        stress = playerMeta['stress'] or "N/A",
        vehicles = GetVehicles(citizenid)
    }
end


RegisterNetEvent('adminmenu:bringPlayer', function(adminSource, targetSource)
    local adminPed = GetPlayerPed(adminSource)
    local targetPed = GetPlayerPed(targetSource)

    if DoesEntityExist(targetPed) then
        local targetCoords = GetEntityCoords(adminPed)  -- Get admin's current position
        SetEntityCoords(targetPed, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, true)
        TriggerClientEvent('QBCore:Notify', adminSource, "Player brought to your location.", 'success')
    else
        TriggerClientEvent('QBCore:Notify', adminSource, "Player not found.", 'error')
    end
end)

RegisterNetEvent('adminmenu:goToPlayer', function(adminSource, targetSource)
    local targetPed = GetPlayerPed(targetSource)

    if DoesEntityExist(targetPed) then
        local targetCoords = GetEntityCoords(targetPed)  -- Get player's current position
        local adminPed = GetPlayerPed(adminSource)
        SetEntityCoords(adminPed, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, true)
        TriggerClientEvent('QBCore:Notify', adminSource, "You have teleported to the player.", 'success')
    else
        TriggerClientEvent('QBCore:Notify', adminSource, "Player not found.", 'error')
    end
end)