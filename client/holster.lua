local DATA_HOLSTERS <const> = lib.load("data.holster")

local function getGender(ped)
    local model = GetEntityModel(ped)
    if model == `mp_m_freemode_01` then
        return "male"
    elseif model == `mp_f_freemode_01` then
        return "female"
    end
end

local function holsterCheck(ped, playerWeapon, playerHolster, shouldUnholster)
    local gender = getGender(ped)
    if not gender then return end

    for i=1, #DATA_HOLSTERS do
        local holster = DATA_HOLSTERS[i]
        local holsterInfo = holster[gender]

        if not holsterInfo or not lib.table.contains(holster.weapons, playerWeapon) then goto next end

        if playerHolster == holsterInfo[1] and shouldUnholster then
            Wait(200)
            SetPedComponentVariation(ped, 7, holsterInfo[2], 0, 0)
            return --print("Gun unholstered")
        elseif playerHolster == holsterInfo[2] then
            SetPedComponentVariation(ped, 7, holsterInfo[1], 0, 0)
            return --print("Gun holstered")
        end

        ::next::
    end
end

lib.onCache("weapon", function(value)
    local ped = cache.ped
    local playerHolster = GetPedDrawableVariation(ped, 7)

    if not value then
        return holsterCheck(ped, cache.weapon, playerHolster, false)
    end

    holsterCheck(ped, value, playerHolster, true)
end)
