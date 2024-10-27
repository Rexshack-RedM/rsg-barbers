fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'rsg-barbers'
version '1.0.9'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'hairs.lua',
    'overlays.lua',
}

client_scripts {
    'client/client.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua',
    'server/versionchecker.lua'
}

files {
    'locales/*.json',
}

dependencies {
    'rsg-core',
    'rsg-menubase',
    'rsg-npcs'
}

lua54 'yes'