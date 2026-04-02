# GO Move — MVP Fase 1

GO Move es una plataforma de movilidad urbana para Lima, Perú, que integra en una sola experiencia viajes en **AUTO** y **MOTO**.

## Entregables de Fase 1

- Arquitectura general del sistema (producto + técnica)
- Estructura de carpetas monorepo
- Modelo completo de base de datos con Prisma/PostgreSQL
- Base inicial del proyecto:
  - Backend NestJS (base de módulos)
  - Landing web en Next.js (inicial)
  - Scaffolds para apps móviles y panel admin
  - Documentación de wireframes y roadmap

## Stack

- Mobile: React Native + Expo
- Web: Next.js
- Backend: NestJS + Socket.io
- DB: PostgreSQL + Prisma
- Auth: JWT (implementación detallada en Fase 2)
- Mapas: Google Maps/Mapbox (integración detallada en Fase 2)

## Estructura

```text
apps/
  api/              # Backend NestJS
  web/              # Landing pública Next.js
  admin-web/        # Panel administrativo (base)
  mobile-passenger/ # App pasajero (base)
  mobile-driver/    # App conductor (base)
packages/
  config/
  types/
  ui/
prisma/
  schema.prisma
  seed.ts
docs/
  architecture.md
  wireframes.md
```

## Inicio rápido

1. Instalar dependencias por workspace.
2. Configurar variables de entorno en `apps/api/.env`.
3. Configurar PostgreSQL y aplicar migraciones Prisma.
4. Ejecutar backend y landing.

> Este repositorio entrega la base profesional de Fase 1 para evolucionar en Fase 2 y Fase 3.
