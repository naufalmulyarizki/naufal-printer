-- ####################################################### 
-- ##███╗░░██╗░█████╗░██╗░░░██╗███████╗░█████╗░██╗░░░░░ ##
-- ##████╗░██║██╔══██╗██║░░░██║██╔════╝██╔══██╗██║░░░░░ ##
-- ##██╔██╗██║███████║██║░░░██║█████╗░░███████║██║░░░░░ ##
-- ##██║╚████║██╔══██║██║░░░██║██╔══╝░░██╔══██║██║░░░░░ ##
-- ##██║░╚███║██║░░██║╚██████╔╝██║░░░░░██║░░██║███████╗ ##
-- ##╚═╝░░╚══╝╚═╝░░╚═╝░╚═════╝░╚═╝░░░░░╚═╝░░╚═╝╚══════╝ ##
-- ####################################################### 

-- Owner                 : Naufal Mulyarizki 
-- Developer             : Naufal#8714
-- Nama Lengkap          : Naufal
-- Repositories Github   : 

--[[ FX Information ]]--
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

--[[ Resource Information ]]--
description 'Naufal Printer'
version '1.0.0'

--[[ UI Page ]]--
ui_page 'html/index.html'

--[[ Shared Script ]]--
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

--[[ client Script ]]--
client_script 'client/main.lua'

--[[ server Script ]]--
server_script 'server/main.lua'

--[[ Files Script ]]--
files {
    'locales/*.json',
    '*.lua',
    'html/*.html',
    'html/*.js',
    'html/*.css',
    'html/*.png',
}
