local DATA_ANIMATIONS <const> = lib.load("data.animations")
local USING_INVENTORY <const> = GetResourceState("ox_inventory"):find("start") and GetConvarInt("inventory:weaponanims", 1) ~= 1
local complete = true

local function isVehicleBlocked(vehicle)
    if not vehicle then return end

    local class = GetVehicleClass(vehicle)
    return class == 8 or class == 13
end

local function isBlocked(ped)
    return isVehicleBlocked(cache.vehicle) or GetPedParachuteState(ped) > 0
end

local function getGender(ped)
    local model = GetEntityModel(ped)
    if model == `mp_m_freemode_01` then
        return "male"
    elseif model == `mp_f_freemode_01` then
        return "female"
    end
end

local function getWeaponAnim(ped, weapon, variant)
    local animations = DATA_ANIMATIONS.animations
    local weaponGroups = DATA_ANIMATIONS?.weaponGroups
    local weaponAnims = DATA_ANIMATIONS?.weapons
    local clothingInfo = DATA_ANIMATIONS?.clothing?[variant]
    local anim = nil
    local currentWeaponGroup = GetWeapontypeGroup(weapon)
    local gender = getGender(ped)

    local animByGroup = weaponGroups?[currentWeaponGroup]
    if animByGroup or animByGroup == false then
        anim = animByGroup
    end

    local animByWeapon = weaponAnims?[weapon]
    if animByWeapon or animByWeapon == false then
        anim = animByWeapon
    end

    if not clothingInfo then goto skip end

    for i=1, #clothingInfo do
        local info = clothingInfo[i]
        if not lib.table.contains(info.weapons, weapon) then goto next end

        
        local components = info[gender]
        if not components then goto next end

        local holster = GetPedDrawableVariation(ped, info.variation)
        if lib.table.contains(components, holster) then
            anim = info.anim
        end

        ::next::
    end

    ::skip::

    if anim == nil then
        anim = DATA_ANIMATIONS.default
    end

    return animations[anim]
end

local function startWaponAnim(ped, info, weapon, hideWeapon)
    local coords = GetEntityCoords(ped)
    lib.requestAnimDict(info.dict)
    TaskPlayAnimAdvanced(ped, info.dict, info.clip, coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(ped), 8.0, 3.0, info.duration*2, 50, 0.1)
    RemoveAnimDict(info.dict)

    SetTimeout(info.clothing or info.duration/2, function()
        TriggerEvent("ND_GunAnims:updateHolster", weapon, hideWeapon)
    end)

    Wait(info.duration)
    
    if info.cancel then
        StopAnimTask(ped, info.dict, info.clip, 2.0)
    end
end

local function playWeaponAnim(weapon, variant)
    local ped = cache.ped
    local info = getWeaponAnim(ped, weapon, variant)

    if not info or isBlocked(ped) then
        return
    end

    info = info[variant]
    if not info then return end

    if info.dict then
        startWaponAnim(ped, info, weapon, variant == "unholster")
    else
        local anims = info
        for i=1, #anims do
            local info = anims[i]
            startWaponAnim(ped, info, weapon, variant == "unholster")
        end
    end
end

function thread(variant, ped, hash)
    LocalPlayer.state.invBusy = true

    if variant == "holster" then
        CreateThread(function()
            SetPedCurrentWeaponVisible(ped, false, false)
            DisablePlayerFiring(cache.playerId, true)

            while not complete do
                DisableControlAction(1, 25, true)
                DisableControlAction(1, 68, true)
                DisableControlAction(1, 70, true)
                DisableControlAction(1, 91, true)
                Wait(0)
            end

            DisablePlayerFiring(cache.playerId, false)
            SetPedCurrentWeaponVisible(ped, true, false)
        end)
    else
        CreateThread(function()
            DisablePlayerFiring(cache.playerId, true)
            while not complete do
                if USING_INVENTORY then                 
                    GiveWeaponToPed(ped, hash, 0, false, true)
                    SetCurrentPedWeapon(ped, hash, true)
                end
                DisableControlAction(1, 25, true)
                DisableControlAction(1, 68, true)
                DisableControlAction(1, 70, true)
                DisableControlAction(1, 91, true)
                Wait(0)
            end
            DisablePlayerFiring(cache.playerId, false)
        end)
    end

    LocalPlayer.state.invBusy = false
end

if USING_INVENTORY then
    local items = exports.ox_inventory:Items()

    AddEventHandler("ox_inventory:usedItem", function(name, slotId, metadata)
        local data = items[name]
        if not data or not data.weapon or data.ammo then return end

        complete = false
        local ped = cache.ped
        
        thread("holster", ped, data.hash)
        playWeaponAnim(data.hash, "unholster")
        complete = true
    end)

    AddEventHandler("ox_inventory:currentWeapon", function(weapon)
        local hash = cache.weapon
        local ped = cache.ped
        if not hash or weapon then return end

        complete = false

        thread("unholster", ped, hash)
        playWeaponAnim(hash, "holster")
        complete = true
    end)
end

if not USING_INVENTORY then
    local _, weapon = GetCurrentPedWeapon(cache.ped, true)
    local weaponInHand = nil

    local function weaponChanged(value)
        local ped = cache.ped
        local hash = value or weapon
        complete = false

        if value then
            thread("holster", ped, hash)
            playWeaponAnim(hash, "unholster")
        else
            thread("unholster", ped, hash)
            playWeaponAnim(hash, "holster")
        end
        
        complete = true
    end

    CreateThread(function()
        while true do
            local _, currentWeapon = GetCurrentPedWeapon(cache.ped, true)
            if currentWeapon ~= weapon then
                local new = currentWeapon ~= `WEAPON_UNARMED` and currentWeapon
                weaponChanged(new)
                weaponInHand = new
                weapon = currentWeapon
            end
            Wait(0)
        end
    end)
end
