local QBCore = exports['qb-core']:GetCoreObject()
Config = Config or {}
lib.locale()

RegisterNetEvent('am:showPlayerMenu', function(playerDetails)
    --print("Received player details for menu.")

    -- Sort players by playerId
    table.sort(playerDetails, function(a, b)
        return a.playerId < b.playerId
    end)

    -- Create a list of menu options for each player
    local playerMenuItems = {}

    for _, player in pairs(playerDetails) do
        local playerName = player.details.name
        local playerId = player.playerId
        local citizenid = player.details.citizenid

        --print("Adding player to menu: " .. playerName .. " - ID: " .. playerId .. " Citizen: " .. citizenid .. ")")

        -- Access cash, bank, health, armor, hunger, thirst, and stress
        local cash = math.floor(player.details.cash)
        local bank = math.floor(player.details.bank)
        local health = math.floor(player.details.health)
        local armor = math.floor(player.details.armor)
        local hunger = math.floor(player.details.hunger)
        local thirst = math.floor(player.details.thirst)  
        local stress = math.floor(player.details.stress)

        -- Extreme buggy because it uses nativecode
        -- Example: If you are dead in laststand healthbar = 50% and if your dead dead it will show 100% red
        -- Easy solution for me is adding multiple support for hospitals like wasabi_ambulance, etc.
        local healthProgress
        local healthColor

        if health <= 0 then
            healthProgress = 100  -- Full progress bar if health is 0
            healthColor = 'red'    -- Color red if dead
        else
            healthProgress = health  -- Use actual health percentage if alive
            healthColor = 'green'     -- Color green if alive
        end

        local vehicleCount = player.details.vehicles and #player.details.vehicles or 0

        -- Add a button for each player with their name
        table.insert(playerMenuItems, {
            title = locale('mm_playername', player.details.name, player.playerId, player.details.citizenid),
            progress = healthProgress,
            colorScheme = healthColor,
            icon = 'user',
            arrow = true,
            metadata = { -- Hover over data
                { label = locale('mm_cash'), value = Config.Currency .. cash}, -- $1234
                { label = locale('mm_bank'), value = Config.Currency .. bank }, -- $5678
                { label = locale('mm_hunger'), value = hunger, progress = hunger, colorScheme = 'orange' },
                { label = locale('mm_thirst'), value = thirst, progress = thirst, colorScheme = 'blue' },
                { label = locale('mm_stress'), value = stress, progress = stress, colorScheme = 'red' },
                { label = locale('mm_armor'), value = armor, progress = armor, colorScheme = Config.ThemeColor },
                { label = locale('mm_owned_vehicles'), value = vehicleCount }
            },
            event = 'am:showPlayerDetails',
            args = { details = player.details }
        })
    end
    lib.registerContext({
        id = 'main_menu',
        title = locale('mm_title'),
        options = playerMenuItems
    })
    --print("Showing player menu...")
    lib.showContext('main_menu')
end)