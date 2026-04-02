import { PrismaClient, ServiceType, UserRole } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  await prisma.user.upsert({
    where: { email: 'admin@gomove.pe' },
    update: {},
    create: {
      role: UserRole.ADMIN,
      email: 'admin@gomove.pe',
      firstName: 'GO',
      lastName: 'Admin',
      phone: '+51999999999',
    },
  });

  await prisma.coverageZone.create({
    data: {
      name: 'Lima Centro',
      city: 'Lima',
      polygonGeoJson: {
        type: 'Polygon',
        coordinates: [
          [
            [-77.06, -12.02],
            [-77.04, -12.02],
            [-77.04, -12.06],
            [-77.06, -12.06],
            [-77.06, -12.02],
          ],
        ],
      },
      baseFareAuto: 6.5,
      baseFareMoto: 4.0,
      pricePerKmAuto: 1.8,
      pricePerKmMoto: 1.1,
      pricePerMinAuto: 0.35,
      pricePerMinMoto: 0.2,
    },
  });

  console.log('Seed Fase 1 completado. Servicios: ', ServiceType.AUTO, ServiceType.MOTO);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
