# Arquitectura General — GO Move (Fase 1)

## 1) Visión de producto (PM)

GO Move inicia en Lima Metropolitana con dos modalidades de viaje:

- **AUTO:** mayor confort.
- **MOTO:** menor costo y menor tiempo en tráfico.

### KPIs iniciales (MVP)

- Tiempo de asignación de conductor < 90 segundos.
- ETA inicial con error medio < 20%.
- Tasa de aceptación de viajes > 65%.
- Calificación promedio > 4.6/5.

## 2) Arquitectura de alto nivel (Arquitecto)

Modelo distribuido por dominios, orientado a evolución modular.

- **Clientes**
  - App Pasajero (Expo)
  - App Conductor (Expo)
  - Web Landing (Next.js)
  - Panel Admin (Next.js)
- **Backend API** (NestJS)
  - API REST para operaciones transaccionales
  - Gateway WebSocket para eventos en tiempo real
- **Persistencia**
  - PostgreSQL + Prisma
  - Redis (planificado Fase 2 para colas/caché)
- **Servicios externos**
  - Proveedor mapas (Google/Mapbox)
  - Proveedor push notifications
  - Pasarelas de pago (simulación en MVP)

## 3) Dominios y bounded contexts (Full Stack + DBA)

- `identity`: autenticación, sesión y roles
- `rider`: perfil pasajero
- `driver`: perfil conductor y verificación
- `fleet`: vehículos auto/moto
- `trip`: ciclo de vida del viaje
- `pricing`: tarifas, promociones, multiplicadores
- `payment`: métodos y transacciones
- `rating`: calificaciones bidireccionales
- `support`: incidentes y botón de emergencia
- `geo`: cobertura, tracking, ETA

## 4) Flujo principal de viaje (Geolocalización)

1. Pasajero ingresa origen/destino y selecciona `AUTO` o `MOTO`.
2. Sistema calcula tarifa estimada + ETA.
3. Se busca conductor online compatible por tipo de servicio y cercanía.
4. Conductor acepta/rechaza solicitud.
5. Se transmite tracking en tiempo real por WebSockets.
6. Viaje finaliza, se calcula tarifa final y se registra pago.
7. Se habilita calificación pasajero/conductor.

## 5) Seguridad y cumplimiento inicial

- JWT con refresh token (Fase 2)
- Hash de contraseñas con Argon2/Bcrypt (Fase 2)
- Roles estrictos: `ADMIN`, `PASSENGER`, `DRIVER`
- Registro de auditoría para acciones críticas en admin
- Encriptación de PII sensible en tránsito (HTTPS)

## 6) Decisiones de diseño UX/UI

- Identidad visual urbana limeña: verde oscuro + negro + blanco.
- Jerarquía de acciones: “Solicitar viaje” como CTA principal.
- Reducción de fricción en onboarding.
- Estados claros de seguridad: conductor verificado, botón SOS, compartir viaje.

## 7) Roadmap por fases

### Fase 1 (este entregable)

- Arquitectura y base técnica
- Esquema de datos integral
- Landing inicial
- Backend bootstrap con módulos base

### Fase 2

- Auth completa JWT + OAuth Google
- Matching en tiempo real
- Geolocalización activa con seguimiento en mapa
- Ciclo completo de viaje

### Fase 3

- Pagos expandidos (efectivo/Yape/Plin simulado + gateway)
- Historial, calificaciones, promociones
- Flujos de seguridad y soporte avanzados
