local ESX = exports['es_extended']:getSharedObject()

local uiOpen = false

-- Wrapper de notificaciones:
-- 1) Intenta usar origin_notify (si existe en el servidor)
-- 2) Si no existe, usa la notificación nativa de ESX
local function Notify(message, nType)
    if GetResourceState('origin_notify') == 'started' then
        -- Ajusta este export si tu versión de origin_notify usa otra firma.
        exports.origin_notify:Notify({
            title = 'Lima York RP',
            description = message,
            type = nType or 'info'
        })
        return
    end

    ESX.ShowNotification(message)
end

local function SetNuiVisible(state)
    uiOpen = state
    SetNuiFocus(state, state)
    SendNUIMessage({
        action = state and 'open' or 'close'
    })
end

RegisterNetEvent('ly_welcome_system:client:openUI', function(payload)
    if uiOpen then return end

    SetNuiVisible(true)
    SendNUIMessage({
        action = 'hydrate',
        data = {
            title = 'Bienvenido a Lima York RP',
            description = payload and payload.description or 'Gracias por unirte. Reclama tu regalo inicial para comenzar tu aventura RP.'
        }
    })
end)

RegisterNetEvent('ly_welcome_system:client:notify', function(message, nType)
    Notify(message, nType)
end)

RegisterNetEvent('ly_welcome_system:client:playConfirm', function()
    -- Sonido simple de confirmación.
    PlaySoundFrontend(-1, 'ATM_WINDOW', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
end)

RegisterNetEvent('ly_welcome_system:client:closeUI', function()
    if uiOpen then
        SetNuiVisible(false)
    end
end)

RegisterNUICallback('close', function(_, cb)
    SetNuiVisible(false)
    cb({ ok = true })
end)

RegisterNUICallback('redeemCode', function(data, cb)
    if not uiOpen then
        cb({ ok = false, message = 'UI no disponible.' })
        return
    end

    local code = (data and data.code or ''):upper()
    TriggerServerEvent('ly_welcome_system:server:validateCode', code)
    cb({ ok = true })
end)

RegisterNUICallback('claimWelcome', function(data, cb)
    if not uiOpen then
        cb({ ok = false, message = 'UI no disponible.' })
        return
    end

    local vehicleType = data and data.vehicleType
    if vehicleType ~= 'moto' and vehicleType ~= 'auto' then
        cb({ ok = false, message = 'Tipo de vehículo inválido.' })
        return
    end

    TriggerServerEvent('ly_welcome_system:server:claim', vehicleType)
    cb({ ok = true })
end)

RegisterNetEvent('ly_welcome_system:client:codeResult', function(success, message, amount)
    SendNUIMessage({
        action = 'codeResult',
        data = {
            success = success,
            message = message,
            amount = amount or 0
        }
    })
end)

RegisterNetEvent('ly_welcome_system:client:claimResult', function(success, message)
    SendNUIMessage({
        action = 'claimResult',
        data = {
            success = success,
            message = message
        }
    })

    if success then
        SetNuiVisible(false)
    end
end)
