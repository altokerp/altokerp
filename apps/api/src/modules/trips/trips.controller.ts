import { Controller, Get } from '@nestjs/common';
import { TripsService } from './trips.service';

@Controller('trips')
export class TripsController {
  constructor(private readonly service: TripsService) {}

  @Get('health')
  health() {
    return this.service.health();
  }
}
