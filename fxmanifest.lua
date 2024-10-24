fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'Haze Studios Admin Menu'
author 'Haze Studios'
description 'Admin Menu using oxmysql and ox_lib'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
}

client_scripts {
    'menu/**',
    'client.lua'
}

files {
    'locales/*.json'
}

dependencies {
    'oxmysql',
    'ox_lib',
    'qb-core'
}
