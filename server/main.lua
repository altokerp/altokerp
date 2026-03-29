local ESX = exports['es_extended']:getSharedObject()

-- Cache simple por sesión para evitar spam/race de eventos.
local claimLocks = {}

local function getIdentifier(xPlayer)
    if not xPlayer then return nil end

    -- En ESX Legacy normalmente xPlayer.identifier ya contiene license:
    if xPlayer.identifier and xPlayer.identifier ~= '' then
        return xPlayer.identifier
    end

    -- Fallback defensivo en caso de setups personalizados.
    local identifiers = GetPlayerIdentifiers(xPlayer.source)
    for _, id in ipairs(identifiers) do
        if id:find('license:') == 1 then
            return id
        end
    end

    return identifiers[1]
end

local function randomFromList(list)
    if type(list) ~= 'table' or #list == 0 then
        return nil
    end

    return list[math.random(1, #list)]
end

local function generatePlate()
    local charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local function rndChar()
        local idx = math.random(1, #charset)
        return charset:sub(idx, idx)
    end

    local plate = ('LY%s%s%s%s%s%s'):format(
        rndChar(), rndChar(), rndChar(), rndChar(), rndChar(), rndChar()
    )

    return plate:upper()
end

local function generateUniquePlate()
    for _ = 1, 40 do
        local plate = generatePlate()
        local exists = MySQL.scalar.await('SELECT 1 FROM owned_vehicles WHERE plate = ? LIMIT 1', { plate })
        if not exists then
            return plate
        end
    end

    return ('LY%06d'):format(math.random(111111, 999999))
end

local function ensureWelcomeRow(identifier)
    local row = MySQL.single.await('SELECT identifier, claimed, code_used FROM ly_welcome WHERE identifier = ? LIMIT 1', { identifier })
    if row then
        return row
    end

    MySQL.insert.await('INSERT INTO ly_welcome (identifier, claimed, code_used) VALUES (?, 0, NULL)', { identifier })
    return {
        identifier = identifier,
        claimed = 0,
        code_used = nil
    }
end

local function notify(src, message, nType)
    TriggerClientEvent('ly_welcome_system:client:notify', src, message, nType)
end

local function spawnAndStoreVehicle(identifier, vehicleModelName, setterType, dbType)
    local spawn = Config.VehicleSpawn
    local modelHash = joaat(vehicleModelName)

    local veh = CreateVehicleServerSetter(modelHash, setterType, spawn.x, spawn.y, spawn.z, spawn.w)
    if veh == 0 then
        return false, 'No se pudo crear el vehículo de bienvenida.'
    end

    local plate = generateUniquePlate()
    SetVehicleNumberPlateText(veh, plate)

    Wait(300)

    local props = {
        model = modelHash,
        plate = plate
    }

    -- Se elimina tras capturar su info para enviarlo al garaje como guardado.
    DeleteEntity(veh)

    MySQL.insert.await(
        'INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) VALUES (?, ?, ?, ?, 1)',
        { identifier, plate, json.encode(props), dbType }
    )

    return true, plate
end

MySQL.ready(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS ly_welcome (
            identifier VARCHAR(80) NOT NULL,
            claimed TINYINT(1) NOT NULL DEFAULT 0,
            code_used VARCHAR(80) DEFAULT NULL,
            PRIMARY KEY (identifier)
        )
    ]])

    print('[LY_welcome_system] Tabla ly_welcome verificada.')
end)

RegisterNetEvent('ly_welcome_system:server:requestOpen', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = getIdentifier(xPlayer)
    if not identifier then
        notify(src, 'No se pudo validar tu identificador.', 'error')
        return
    end

    local row = ensureWelcomeRow(identifier)
    if row.claimed == 1 then
        notify(src, 'Ya reclamaste tu bienvenida anteriormente.', 'error')
        return
    end

    TriggerClientEvent('ly_welcome_system:client:openUI', src, {
        description = 'Estamos felices de tenerte aquí. Elige tu vehículo inicial y reclama tu bono de bienvenida.'
    })
end)

RegisterNetEvent('ly_welcome_system:server:validateCode', function(rawCode)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local identifier = getIdentifier(xPlayer)
    if not identifier then
        notify(src, 'No se pudo validar tu identificador.', 'error')
        return
    end

    local code = tostring(rawCode or ''):upper():gsub('%s+', '')
    if code == '' then
        TriggerClientEvent('ly_welcome_system:client:codeResult', src, false, 'Debes escribir un código.', 0)
        return
    end

    local row = ensureWelcomeRow(identifier)
    if row.claimed == 1 then
        TriggerClientEvent('ly_welcome_system:client:codeResult', src, false, 'Ya reclamaste tu bienvenida.', 0)
        return
    end

    if row.code_used and row.code_used ~= '' then
        TriggerClientEvent('ly_welcome_system:client:codeResult', src, false, 'Ya usaste un código de bienvenida.', 0)
        return
    end

    local reward = Config.Codes[code]
    if not reward then
        TriggerClientEvent('ly_welcome_system:client:codeResult', src, false, 'Código inválido.', 0)
        return
    end

    xPlayer.addAccountMoney('bank', reward, 'welcome-code')
    MySQL.update.await('UPDATE ly_welcome SET code_used = ? WHERE identifier = ?', { code, identifier })

    TriggerClientEvent('ly_welcome_system:client:codeResult', src, true, ('Código aplicado. +$%s en banco.'):format(reward), reward)
    TriggerClientEvent('ly_welcome_system:client:playConfirm', src)
end)

RegisterNetEvent('ly_welcome_system:server:claim', function(vehicleChoice)
    local src = source
    if claimLocks[src] then
        notify(src, 'Procesando tu solicitud, espera un momento...', 'warning')
        return
    end

    claimLocks[src] = true

    local ok, err = pcall(function()
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return end

        local identifier = getIdentifier(xPlayer)
        if not identifier then
            notify(src, 'No se pudo validar tu identificador.', 'error')
            return
        end

        local choice = tostring(vehicleChoice or ''):lower()
        if choice ~= 'moto' and choice ~= 'auto' then
            TriggerClientEvent('ly_welcome_system:client:claimResult', src, false, 'Selección de vehículo inválida.')
            return
        end

        local row = ensureWelcomeRow(identifier)
        if row.claimed == 1 then
            TriggerClientEvent('ly_welcome_system:client:claimResult', src, false, 'Ya reclamaste este beneficio.')
            return
        end

        local pool = (choice == 'moto') and Config.MotoVehicles or Config.AutoVehicles
        local model = randomFromList(pool)
        if not model then
            TriggerClientEvent('ly_welcome_system:client:claimResult', src, false, 'No hay vehículos configurados para ese tipo.')
            return
        end

        local dbType = (choice == 'moto') and 'bike' or 'car'
        local setterType = (choice == 'moto') and 'bike' or 'automobile'

        local saved, plateOrError = spawnAndStoreVehicle(identifier, model, setterType, dbType)
        if not saved then
            TriggerClientEvent('ly_welcome_system:client:claimResult', src, false, plateOrError)
            return
        end

        xPlayer.addAccountMoney('bank', Config.BaseMoney, 'welcome-base')
        MySQL.update.await('UPDATE ly_welcome SET claimed = 1 WHERE identifier = ?', { identifier })

        TriggerClientEvent('ly_welcome_system:client:playConfirm', src)
        TriggerClientEvent(
            'ly_welcome_system:client:claimResult',
            src,
            true,
            ('¡Bienvenida reclamada! Vehículo (%s) guardado con placa %s y +$%s en banco.'):format(model, plateOrError, Config.BaseMoney)
        )

        notify(src, 'Tu recompensa de bienvenida se guardó correctamente en garaje.', 'success')
    end)

    claimLocks[src] = nil

    if not ok then
        print(('[LY_welcome_system] Error en claim: %s'):format(err))
        TriggerClientEvent('ly_welcome_system:client:claimResult', src, false, 'Ocurrió un error interno al reclamar.')
    end
end)

AddEventHandler('playerDropped', function()
    claimLocks[source] = nil
end)
