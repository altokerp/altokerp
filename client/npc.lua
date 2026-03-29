local npcPed

local function DrawText3D(coords, text)
    local camCoords = GetGameplayCamCoord()
    local distance = #(camCoords - coords)

    if distance > Config.DrawTextDistance then
        return
    end

    local scale = 200 / (GetGameplayCamFov() * distance)

    SetTextScale(0.0, 0.35 * scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local function LoadModel(model)
    local hash = joaat(model)
    if not IsModelInCdimage(hash) then return false end

    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end

    return hash
end

CreateThread(function()
    local hash = LoadModel(Config.NPC.model)
    if not hash then
        print(('[LY_welcome_system] Modelo de NPC inválido: %s'):format(Config.NPC.model))
        return
    end

    local c = Config.NPC.coords
    npcPed = CreatePed(4, hash, c.x, c.y, c.z - 1.0, c.w, false, true)

    SetEntityAsMissionEntity(npcPed, true, true)
    FreezeEntityPosition(npcPed, true)
    SetEntityInvincible(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)

    TaskStartScenarioInPlace(npcPed, 'WORLD_HUMAN_CLIPBOARD', 0, true)
    SetModelAsNoLongerNeeded(hash)

    -- Espera a que target.lua consuma esta entidad.
    while not DoesEntityExist(npcPed) do
        Wait(100)
    end

    LocalPlayer.state:set('lyWelcomePed', npcPed, true)
end)

CreateThread(function()
    while true do
        Wait(0)
        if npcPed and DoesEntityExist(npcPed) then
            local pos = GetEntityCoords(npcPed)
            DrawText3D(vec3(pos.x, pos.y, pos.z + 1.35), Config.NPCLabel)
        else
            Wait(500)
        end
    end
end)
