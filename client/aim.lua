local DATA_AIM <const> = lib.load("data.aim")

local animations = {
    default = `Default`,
    gang = `Gang1H`,
    hillbilly = `Hillbilly`
}

local function setAimAnim(anim)
    anim = anim and animations[anim:lower()]
    if not anim then return end
    
    local state = LocalPlayer.state
    state:set("weaponAnimOverride", anim, true)
end

AddStateBagChangeHandler("weaponAnimOverride", nil, function(bagName, key, value, reserved, replicated)
    local ply = GetPlayerFromStateBagName(bagName)
    if ply == 0 or replicated or not value then return end
    SetWeaponAnimationOverride(GetPlayerPed(ply), value or `Default`)
end)

lib.onCache("ped", function(value)
    setAimAnim(LocalPlayer.state.weaponAnimOverride)
end)

if DATA_AIM.command then
    RegisterCommand(DATA_AIM.command, function(source, args, rawCommand)
        setAimAnim(args[1])
    end, false)

    TriggerEvent("chat:addSuggestion", ("/%s"):format(DATA_AIM.command), "Weapon aim animation", {
        { name = "animation", help = "gang | hillbilly | default" }
    })
end

if DATA_AIM.default then
    setAimAnim(DATA_AIM.default)
end

exports("setAimAnim", setAimAnim)

exports("getAimAnim", function()
    return LocalPlayer.state.weaponAnimOverride or animations["default"]
end)
