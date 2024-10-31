local QBCore = exports['qb-core']:GetCoreObject()
lib.locale()

RegisterNetEvent('adminmenu:showPlayerInventory', function(data)
    local details = data.details
    local playerId = details.id
    local playerItems = exports.ox_inventory:GetPlayerItems(playerId) or {}
    local inventoryOptions = {}
    --print(json.encode(playerItems)) 

    if #playerItems > 0 then
        for i, item in ipairs(playerItems) do
            local itemCount = item.count or 0
            local itemTitle = string.format("Slot %d: %s x%d", item.slot, item.name, itemCount)
    
            local option = {
                title = itemTitle,
                icon = 'box'
            }

        --[[ Debugging metadata
        if item.metadata then
            print(string.format("%s metadata: %s", item.name, json.encode(item.metadata)))  -- Print the item name with the entire metadata
            for key, value in pairs(item.metadata) do
                print(string.format("%s: %s", key, tostring(value)))  -- Print each key-value pair
            end
        else
            print(string.format("No metadata for %s.", item.name))  -- Indicate no metadata for this item
        end]]

            if item.metadata and (item.metadata.durability or item.metadata.serial) then
                option.metadata = {}
    
                if item.metadata.durability then
                    table.insert(option.metadata, {
                        label = "Durability",
                        value = tostring(item.metadata.durability)
                    })
                end
                if item.metadata.ammo then 
                    table.insert(option.metadata, {
                        label = "Ammo",
                        value = tostring(item.metadata.ammo)
                    })
                end
                if item.metadata.serial then
                    table.insert(option.metadata, {
                        label = "Serial Number",
                        value = item.metadata.serial
                    })
                end
            end
    
            if option.metadata and #option.metadata > 0 then
                table.insert(inventoryOptions, option)
            else
                table.insert(inventoryOptions, {
                    title = itemTitle,
                    icon = 'box'
                })
            end
        end
    else
        table.insert(inventoryOptions, { title = 'Inventory is empty', disabled = true })
    end    

    lib.registerContext({
        id = 'player_inventory_menu',
        title = locale('pdi_title', details.name, details.id),
        menu = 'player_details_menu',
        onBack = function() end,
        options = inventoryOptions,
    })
    lib.showContext('player_inventory_menu')
end)
