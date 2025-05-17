local spawnedPeds = {}
lib.locale()

local function NearNPC(npcmodel, npccoords, id)
    RequestModel(npcmodel)
    while not HasModelLoaded(npcmodel) do
        Wait(50)
    end
    local spawnedPed = CreatePed(npcmodel, npccoords.x, npccoords.y, npccoords.z - 1.0, npccoords.w, false, false, 0, 0)
    SetEntityAlpha(spawnedPed, 0, false)
    SetRandomOutfitVariation(spawnedPed, true)
    SetEntityCanBeDamaged(spawnedPed, false)
    SetEntityInvincible(spawnedPed, true)
    FreezeEntityPosition(spawnedPed, true)
    SetBlockingOfNonTemporaryEvents(spawnedPed, true)
    SetPedCanBeTargetted(spawnedPed, false)

    if Config.FadeIn then
        for i = 0, 255, 51 do
            Wait(50)
            SetEntityAlpha(spawnedPed, i, false)
        end
    end

    if Config.EnableTarget then
        local options = {}
        options[#options+1] = {
            name = 'npc_barberloc',
            icon = 'far fa-eye',
            label = locale('cl_open_barber'),
            onSelect = function()
                TriggerEvent('rsg-barber:client:menu', id)
            end,
            distance = 2.0
        }

        exports.ox_target:addLocalEntity(spawnedPed, options)
    end
    return spawnedPed
end

CreateThread(function()
    while true do
        Wait(500)
        for k,v in pairs(Config.barberlocations) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - v.npccoords.xyz)

            if distance < Config.DistanceSpawn and not spawnedPeds[k] then
                local spawnedPed = NearNPC(v.npcmodel, v.npccoords, v.id )
                spawnedPeds[k] = { spawnedPed = spawnedPed }

            end
            if distance >= Config.DistanceSpawn and spawnedPeds[k] then
                if Config.FadeIn then
                    for i = 255, 0, -51 do
                        Wait(50)
                        SetEntityAlpha(spawnedPeds[k].spawnedPed, i, false)
                    end
                end
                DeletePed(spawnedPeds[k].spawnedPed)
                spawnedPeds[k] = nil
            end
        end
    end
end)

-- cleanup
AddEventHandler("onResourceStop", function(resourceName)
local resource = GetCurrentResourceName()
    if resource ~= resourceName then return end
    for k, v in pairs(spawnedPeds) do
        exports['rsg-target']:RemoveTargetEntity(v.ped, locale('cl_open_barber'))
        if v.ped and DoesEntityExist(v.ped) then
            DeleteEntity(v.ped)
        end
        spawnedPeds[k] = nil
    end
end)
