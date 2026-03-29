local targetRegistered = false

CreateThread(function()
    while not targetRegistered do
        Wait(500)

        local ped = LocalPlayer.state.lyWelcomePed
        if ped and DoesEntityExist(ped) then
            exports.ox_target:addLocalEntity(ped, {
                {
                    name = 'ly_welcome_claim',
                    icon = 'fa-solid fa-gift',
                    label = 'Reclamar bienvenida',
                    distance = 2.0,
                    onSelect = function()
                        TriggerServerEvent('ly_welcome_system:server:requestOpen')
                    end
                }
            })

            targetRegistered = true
        end
    end
end)
