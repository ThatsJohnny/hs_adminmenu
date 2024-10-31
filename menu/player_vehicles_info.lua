lib.locale()

RegisterNetEvent('adminmenu:showPlayerVehiclesInfo', function (data)
    local vehicle = data.vehicle
    
    -- Debugging: Show the selected vehicle's trunk, glovebox contents and other bullshit, you gotta start somewhere..
    --print(json.encode(vehicle))
    --print("Vehicle Selected: " .. vehicle.vehicle)
    --print("Trunk contents: " .. json.encode(vehicle.trunk or {}))
    --print("Glovebox contents: " .. json.encode(vehicle.glovebox or {}))
    
    -- Decode trunk and glovebox contents
    --local trunkContents = json.decode(vehicle.trunk or "[]")
    --local gloveboxContents = json.decode(vehicle.glovebox or "[]")

    local vehicleInfoOptions = {}
    local modsData = json.decode(vehicle.mods)

    table.insert(vehicleInfoOptions, { title = locale('pvi_model', vehicle.vehicle), icon = 'car-side' })
    table.insert(vehicleInfoOptions, { title = locale('pvi_plate', vehicle.plate), icon = 'eye' })
    table.insert(vehicleInfoOptions, { title = locale('pvi_fuel', vehicle.fuel), progress = vehicle.fuel, colorScheme = Config.ThemeColor, icon = 'gas-pump' })
    table.insert(vehicleInfoOptions, { title = locale('pvi_engine', vehicle.engine), progress = vehicle.engine, colorScheme = Config.ThemeColor, icon = 'car-battery' })
    table.insert(vehicleInfoOptions, { title = locale('pvi_body', vehicle.body), progress = vehicle.body, colorScheme = Config.ThemeColor, icon = 'car-burst' })
    table.insert(vehicleInfoOptions, { title = locale('pvi_brake') .. (modsData.modBrakes == -1 and locale('default') or modsData.modBrakes), colorScheme = Config.ThemeColor, icon = 'car' }) -- 1
    table.insert(vehicleInfoOptions, { title = locale('pvi_engine') .. (modsData.modEngine == -1 and locale('default') or modsData.modEngine), colorScheme = Config.ThemeColor, icon = 'car' }) -- 2
    table.insert(vehicleInfoOptions, { title = locale('pvi_suspension') .. (modsData.modSuspension == -1 and locale('default') or modsData.modSuspension), colorScheme = Config.ThemeColor, icon = 'car' }) -- 3
    table.insert(vehicleInfoOptions, { title = locale('pvi_transmission') .. (modsData.modTransmission == -1 and locale('default') or modsData.modTransmission), colorScheme = Config.ThemeColor, icon = 'car' }) -- 4
    table.insert(vehicleInfoOptions, { title = locale('pvi_turbo') .. (modsData.modTurbo == 1 and locale('yes') or locale('no')), icon = 'car' }) -- Turbo option if applicable
    -- [WIP] trunk items
    --[[if #trunkContents > 0 then
        table.insert(vehicleInfoOptions, { title = '--- Trunk Contents ---', disabled = true })
        for i, item in ipairs(trunkContents) do
            local itemTitle = string.format("Slot %d: %s x%d", item.slot, item.name, item.count)
            table.insert(vehicleInfoOptions, { title = itemTitle, icon = 'box' })
            if item.metadata then
                local metadataInfo = "Metadata: " .. json.encode(item.metadata)
                table.insert(vehicleInfoOptions, { title = metadataInfo, disabled = true })
            end
        end
    else
        table.insert(vehicleInfoOptions, { title = 'Trunk is empty', disabled = true })
    end

    -- [WIP] glovebox items
    if #gloveboxContents > 0 then
        table.insert(vehicleInfoOptions, { title = '--- Glovebox Contents ---', disabled = true })
        for i, item in ipairs(gloveboxContents) do
            local itemTitle = string.format("Slot %d: %s x%d", item.slot, item.name, item.count)
            table.insert(vehicleInfoOptions, { title = itemTitle, icon = 'box' })
            if item.metadata then
                local metadataInfo = "Metadata: " .. json.encode(item.metadata)
                table.insert(vehicleInfoOptions, { title = metadataInfo, disabled = true })
            end
        end
    else
        table.insert(vehicleInfoOptions, { title = 'Glovebox is empty', disabled = true })
    end]]

    lib.registerContext({
        id = 'player_vehicles_info_menu',
        title = locale('pvi_title'),
        menu = 'player_vehicles_menu',
        onBack = function()
            --print("Returning to player vehicles menu...")
        end,
        options = vehicleInfoOptions
    })
    lib.showContext('player_vehicles_info_menu')
end)