author "Andyyy7666"
description "Weapon animation system"
version "1.0.0"

fx_version "cerulean"
game "gta5"
lua54 "yes"

files {
    "data/*.lua",
    "client/weaponanimations.meta"
}

data_file "WEAPON_ANIMATIONS_FILE" "client/weaponanimations.meta"

client_scripts {
    "@ox_lib/init.lua",
    "client/*.lua"
}
