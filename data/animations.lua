-- animatios when weapon is unholstered and holstered.
local info = {}

info.animations = {
    mele = {
        holster = { dict = "melee@holster", clip = "holster", duration = 200 },
        unholster = { dict = "melee@holster", clip = "unholster", duration = 200 }
    },
    gang = {
        holster = { dict = "reaction@intimidation@1h", clip = "outro", duration = 800 },
        unholster = { dict = "reaction@intimidation@1h", clip = "intro", duration = 900 }
    },
    police = {
        holster = { dict = "reaction@intimidation@cop@unarmed", clip = "intro", duration = 400, clothing = 300 },
        unholster = { dict = "rcmjosh4", clip = "josh_leadout_cop2", duration = 300, clothing = 0, cancel = true }
    }
}

-- default anim for weapons not found in groups, weapons, or clothing.
info.default = "gang"

-- weapon groups can be found here: https://docs.fivem.net/natives/?_0xC3287EE3050FB74C
info.weaponGroups = {
    [`GROUP_MELEE`] = "mele",
    [`GROUP_PISTOL`] = "gang",
}

-- If you add a weapon here it will ignore the animation on it's group and instead play a specific animation set here.
info.weapons = {
    [`WEAPON_STUNGUN`] = "police",
    [`WEAPON_SWITCHBLADE`] = false -- setting to false will not play any anim and instead use the in game default.
}

-- if wearing specific clothing such as a holster then everything else ignored and that anim is used.
info.clothing = {
    holster = {
        {
            anim = "police",
            weapons = {`WEAPON_COMBATPISTOL`},
            variation = 7,
            male = {186, 183, 188},
            female = {149}
        }
    },
    unholster = {
        {
            anim = "police",
            weapons = {`WEAPON_COMBATPISTOL`},
            variation = 7,
            male = {182, 179, 187},
            female = {148}
        }
    }
}

return info
