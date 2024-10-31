local QBCore = exports['qb-core']:GetCoreObject()
lib.locale()

RegisterNetEvent('adminmenu:showPlayerDetailsInfo', function(data)
    local details = data.details
    --print("Showing details for: " .. details.name)

    local genderDisplay
    if details.gender == 0 then
        genderDisplay = locale('man')
    elseif details.gender == 1 then
        genderDisplay = locale('woman')
    else
        genderDisplay = 'N/A'  -- In case of an unexpected value
    end

    lib.registerContext({
        id = 'player_details_info_menu',
        title = locale('pdi_title', details.name, details.id),
        menu = 'player_details_menu',
        onBack = function()
            --print("Player details info menu closed, going back to player details menu...")
        end,
        options = {
            --{ title = 'Garage', icon = 'car', arrow = true, event = 'adminmenu:showPlayerVehicles', args = { vehicles = details.vehicles } },
            { title = locale('pdi_citizenid', details.citizenid), icon = 'user-tag' },
            { title = locale('pdi_name', details.name), icon = 'id-card' },
            { title = locale('pdi_birthdate', details.birthdate), icon = 'cake' },
            { title = locale('pdi_gender', genderDisplay), icon = 'venus-mars' },
            { title = locale('pdi_nationality', details.nationality), icon = 'passport' },
            { title = locale('pdi_job', details.job), icon = 'briefcase', 
                metadata = { 
                    locale('pdi_boss', details.isboss and locale('yes') or locale('no')),
                    locale('pdi_payment', details.jobpayment, Config.Currency),
                    locale('pdi_grade', details.jobgrade)
                } 
            },
            { title = locale('pdi_gang', details.gang), icon = 'droplet' },
            { title = locale('pdi_phone', details.phone), icon = 'phone' },
            --{ title = 'Contant: $' .. details.cash, icon = 'wallet' },
            --{ title = 'Bank: $' .. details.bank, icon = 'piggy-bank' },
            --{ title = 'Hunger: ' .. details.hunger .. '%', icon = 'burger' },
            --{ title = 'Thirst: ' .. details.thirst .. '%', icon = 'bottle-water' },
            --{ title = 'Stress: ' .. details.stress .. '%', icon = 'brain' }
        },
    })
    lib.showContext('player_details_info_menu')
end)