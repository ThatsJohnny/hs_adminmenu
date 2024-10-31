lib.locale()

-- Function to convert a Unix timestamp to a formatted date (without os library)
local function convertTimestampToDate(timestamp)
    if not timestamp or timestamp < 0 then return "Invalid Date" end

    -- Define the number of seconds in a year, month, day, etc.
    local secondsInYear = 31536000
    local secondsInMonth = 2592000 -- Roughly 30 days
    local secondsInDay = 86400
    local secondsInHour = 3600
    local secondsInMinute = 60

    -- Calculate the components of the date
    local years = math.floor(timestamp / secondsInYear)
    timestamp = timestamp % secondsInYear

    local months = math.floor(timestamp / secondsInMonth)
    timestamp = timestamp % secondsInMonth

    local days = math.floor(timestamp / secondsInDay)
    timestamp = timestamp % secondsInDay

    local hours = math.floor(timestamp / secondsInHour)
    timestamp = timestamp % secondsInHour

    local minutes = math.floor(timestamp / secondsInMinute)
    local seconds = timestamp % secondsInMinute

    -- Calculate the actual date
    local currentYear = 1970 + years
    local currentMonth = months + 1 -- Adjusting for 0-indexed months
    local currentDay = days + 1      -- Adjusting for 0-indexed days

    -- Format the date as a string (YYYY-MM-DD HH:MM:SS)
    return string.format('%04d-%02d-%02d %02d:%02d:%02d',
        currentYear, currentMonth, currentDay,
        hours, minutes, seconds
    )
end

RegisterNetEvent('adminmenu:showPlayerVehicles', function(data)
    local vehicles = data.vehicles
    local vehicleOptions = {}


    for _, vehicle in pairs(vehicles) do

        local metadata = {}
        local modsData = json.decode(vehicle.mods)
        --local loanperiode = tonumber(vehicle.loanperiode)
        

        table.insert(metadata, { label = locale('pv_model'), value = vehicle.vehicle })
        table.insert(metadata, { label = locale('pv_fuel'), value = vehicle.fuel, progress = vehicle.fuel, colorScheme = Config.ThemeColor })
        table.insert(metadata, { label = locale('pv_engine'), value = vehicle.engine, progress = vehicle.engine, colorScheme = Config.ThemeColor })
        table.insert(metadata, { label = locale('pv_body'), value = vehicle.body, progress = vehicle.body, colorScheme = Config.ThemeColor })
        -- Add conditions for modsData with default handling
        table.insert(metadata, { label = locale('pv_brake'), value = (modsData.modBrakes == -1 and locale('default') or modsData.modBrakes) })
        table.insert(metadata, { label = locale('pv_engine'), value = (modsData.modEngine == -1 and locale('default') or modsData.modEngine) })
        table.insert(metadata, { label = locale('pv_suspension'), value = (modsData.modSuspension == -1 and locale('default') or modsData.modSuspension) }) 
        table.insert(metadata, { label = locale('pv_transmission'), value = (modsData.modTransmission == -1 and locale('default') or modsData.modTransmission) })
        table.insert(metadata, { label = locale('pv_turbo'), value = (modsData.modTurbo == 1 and locale('yes') or locale('no')) })

        --Debugging output to see the trunk and glovebox
        --print("Trunk contents: " .. json.encode(vehicle.trunk))
        --print("Glovebox contents: " .. json.encode(vehicle.glovebox))
        --print(json.encode(vehicle.mods))

        table.insert(vehicleOptions, {
            title = vehicle.name or vehicle.vehicle,  -- Show vehicle name or fallback to vehicle model
            icon = 'car',
            description = locale('pv_plate', vehicle.plate),
            arrow = true,
            metadata = metadata,
            event = 'adminmenu:showPlayerVehiclesInfo',
            args = { vehicle = vehicle }     
        })
    end

    lib.registerContext({
        id = 'player_vehicles_menu',
        title = locale('pv_title'),
        menu = 'player_details_menu',
        options = vehicleOptions,
        onBack = function()
            --print("Returning to player details menu...")
        end,
    })
    lib.showContext('player_vehicles_menu')
end)