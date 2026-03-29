fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'LY_welcome_system'
author 'Lima York RP'
description 'Sistema de bienvenida con NPC, NUI y recompensas para ESX Legacy'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

client_scripts {
    'client/main.lua',
    'client/npc.lua',
    'client/target.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/app.js'
}

dependencies {
    'es_extended',
    'oxmysql',
    'ox_target'
}
