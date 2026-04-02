import { Module } from '@nestjs/common';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { DriversModule } from './modules/drivers/drivers.module';
import { TripsModule } from './modules/trips/trips.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { RatingsModule } from './modules/ratings/ratings.module';
import { PromotionsModule } from './modules/promotions/promotions.module';
import { SupportModule } from './modules/support/support.module';
import { GeoModule } from './modules/geo/geo.module';
import { AdminModule } from './modules/admin/admin.module';

@Module({
  imports: [
    AuthModule,
    UsersModule,
    DriversModule,
    TripsModule,
    PaymentsModule,
    RatingsModule,
    PromotionsModule,
    SupportModule,
    GeoModule,
    AdminModule,
  ],
})
export class AppModule {}
