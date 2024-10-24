local QBCore = exports['qb-core']:GetCoreObject()
Config = Config or {}
lib.locale()

RegisterNetEvent('am:showPlayerDetails', function(data)
    local details = data.details
    --print("Showing details for: " .. details.name)

    lib.registerContext({
        id = 'player_details_menu',
        --title = details.name .. ' [' .. details.id .. ']',
        title = locale('pd_title', details.name, details.id),
        menu = 'main_menu',
        onBack = function()
            --print("Player details menu closed, going back to player list...")
        end,
        options = {
            { title = locale('pd_admin_options'), icon = 'screwdriver-wrench', arrow = true, event = 'am:AdminOptions', args = { details = details }},
            { title = locale('pd_char_info'), icon = 'info', arrow = true, event = 'am:showPlayerDetailsInfo', args = { details = details }},
            { title = locale('pd_garage'), icon = 'car-side', arrow = true, event = 'am:showPlayerVehicles', args = { vehicles = details.vehicles }},  -- Option to show vehicles
            --{ title = locale('pd_inventory'), icon = 'toolbox', arrow = false },
            --{ title = locale('pd_houses'), icon = 'house', arrow = false },

            { title = '', disabled = true }, -- divider

            { title = locale('pd_cash', math.floor(details.cash)), icon = 'wallet' },
            { title = locale('pd_bank', math.floor(details.bank)), icon = 'piggy-bank' },
            { title = locale('pd_hunger', details.hunger), icon = 'burger', progress = details.hunger, colorScheme = 'orange' },
            { title = locale('pd_thirst', details.thirst), icon = 'bottle-water', progress = details.thirst, colorScheme = 'blue' },
            { title = locale('pd_stress', details.stress), icon = 'brain', progress = details.stress, colorScheme = 'red' },
            { title = locale('pd_armor', details.armor), icon = 'shield', progress = details.armor, colorScheme = Config.ThemeColor },
        
            --{ title = 'Hunger: ' .. details.hunger .. '%', icon = 'burger', progress = details.hunger, colorScheme = 'orange' },
            --{ title = 'Thirst: ' .. details.thirst .. '%', icon = 'bottle-water', progress = details.thirst, colorScheme = 'blue' },
            --{ title = 'Stress: ' .. details.stress .. '%', icon = 'brain', progress = details.stress, colorScheme = 'red' },
            --{ title = 'Armor: ' .. details.armor, icon = '', progress = details.armor, colorScheme = Config.ThemeColor },
        },
    })
    lib.showContext('player_details_menu')
end)