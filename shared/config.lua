Config = {}

-- Coordenadas del NPC de bienvenida.
-- Aquí puedes cambiar la posición y rotación.
Config.NPC = {
    coords = vec4(-268.34, -955.71, 31.22, 204.35),
    model = 'a_m_m_business_01'
}

-- Punto de spawn temporal para crear el vehículo y guardarlo en garaje.
Config.VehicleSpawn = vec4(-265.33, -962.45, 31.22, 247.65)

-- Dinero base otorgado al reclamar la bienvenida.
-- Aquí puedes modificar la recompensa principal.
Config.BaseMoney = 25000

-- Códigos de bienvenida válidos y su recompensa adicional.
-- Aquí puedes agregar/quitar códigos.
Config.Codes = {
    ['ANGEL2026'] = 50000,
    ['LIMAYORK'] = 35000,
    ['BIENVENIDO'] = 20000
}

-- Listado de motos para sorteo aleatorio.
-- Aquí puedes modificar el pool de motos.
Config.MotoVehicles = {
    'bati',
    'faggio',
    'nemesis',
    'pcj',
    'daemon'
}

-- Listado de autos para sorteo aleatorio.
-- Aquí puedes modificar el pool de autos.
Config.AutoVehicles = {
    'sultan',
    'blista',
    'asbo',
    'prairie',
    'asea'
}

-- Texto 3D sobre el NPC
Config.NPCLabel = 'RECLAMA TU REGALO DE BIENVENIDA AQUÍ'

-- Distancia máxima para dibujar el texto 3D.
Config.DrawTextDistance = 12.0
