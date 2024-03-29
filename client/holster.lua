local DATA_HOLSTERS <const> = lib.load("data.holster")

local function getGender(ped)
    local model = GetEntityModel(ped)
    if model == `mp_m_freemode_01` then
        return "male"
    elseif model == `mp_f_freemode_01` then
        return "female"
    end
end

local function holsterCheck(ped, playerWeapon, shouldUnholster)
    local gender = getGender(ped)
    if not gender then return end

    for i=1, #DATA_HOLSTERS do
        local holster = DATA_HOLSTERS[i]
        local holsterInfo = holster[gender]

        if not holsterInfo or not lib.table.contains(holster.weapons, playerWeapon) then goto next end

        local playerHolster = GetPedDrawableVariation(ped, holster.variation)

        if playerHolster == holsterInfo[1] and shouldUnholster then
            Wait(200)
            SetPedComponentVariation(ped, holster.variation, holsterInfo[2], 0, 0)
            return --print("Gun unholstered")
        elseif playerHolster == holsterInfo[2] then
            SetPedComponentVariation(ped, holster.variation, holsterInfo[1], 0, 0)
            return --print("Gun holstered")
        end

        ::next::
    end
end

AddEventHandler("ND_GunAnims:updateHolster", function(weapon, hide)
    holsterCheck(cache.ped, weapon, hide)
end)

if GetResourceState("ox_inventory"):find("start") and GetConvarInt("inventory:weaponanims", 1) == 1 then
    lib.onCache("weapon", function(value)
        local weapon = value or cache.weapon
        Wait(300)
        holsterCheck(cache.ped, weapon, value)
    end)
end
