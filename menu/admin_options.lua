local QBCore = exports['qb-core']:GetCoreObject()
lib.locale()

RegisterNetEvent('adminmenu:AdminOptions', function(data)
    local details = data.details

     lib.registerContext({
        id = 'admin_options_menu',
        title = locale('ao_title', details.name, details.id),
        menu = 'player_details_menu',
        onBack = function()
            --print("Admin options menu closed, going back to player details menu...")
        end,
        options = {
            { 
                title = locale('ao_revive'), 
                icon = 'briefcase-medical', 
                arrow = false, 
                onSelect = function()
                    ExecuteCommand('revive ' .. details.id) -- Lazy
                end
            },
            { 
                title = locale('ao_kill'),
                icon = 'skull-crossbones', 
                arrow = false, 
                onSelect = function()
                    ExecuteCommand('kill ' .. details.id) -- Lazy
                end
            },
            { 
                title = locale('ao_bring'),
                icon = 'person-arrow-down-to-line', 
                arrow = false, 
                onSelect = function()
                    local adminSource = GetPlayerServerId(PlayerId())
                    TriggerServerEvent('adminmenu:bringPlayer', adminSource, details.id)
                end
            },
            { 
                title = locale('ao_goto'),
                icon = 'person-arrow-up-from-line', 
                arrow = false, 
                onSelect = function()
                    local adminSource = GetPlayerServerId(PlayerId())
                    TriggerServerEvent('adminmenu:goToPlayer', adminSource, details.id)
                end
            }
        },
    })
    lib.showContext('admin_options_menu')
end)