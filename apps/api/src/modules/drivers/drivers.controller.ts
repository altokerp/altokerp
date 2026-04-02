import { Controller, Get } from '@nestjs/common';
import { DriversService } from './drivers.service';

@Controller('drivers')
export class DriversController {
  constructor(private readonly service: DriversService) {}

  @Get('health')
  health() {
    return this.service.health();
  }
}
