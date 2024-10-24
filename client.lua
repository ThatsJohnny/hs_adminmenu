Config = Config or {}
lib.locale()

local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        TriggerServerEvent('adminlookup:server:checkkAdminPermissions')
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        lib.hideContext('main_menu')
        lib.hideContext('player_details_menu')
        lib.hideContext('player_details_info_menu')
        lib.hideContext('player_vehicles_menu')
        lib.hideContext('player_vehicles_info_menu')
        lib.hideContext('admin_options_menu')
        print("All active menus closed.")
    end
end)

-- Event to setup keybind for admins
if Config.EnableMenuKey then
    RegisterNetEvent('adminlookup:client:setupKeybind')
    AddEventHandler('adminlookup:client:setupKeybind', function()
        lib.addKeybind({
            name = 'setup_keybind',
            description = 'Admin Menu',
            defaultKey = Config.MenuKey,
            onPressed = function()
                --TriggerEvent('adminlookup:client:mainmenu')
                ExecuteCommand(Config.Command) -- Im just lazy.
            end
        })
    end)
end