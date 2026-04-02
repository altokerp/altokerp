import { Controller, Get } from '@nestjs/common';
import { GeoService } from './geo.service';

@Controller('geo')
export class GeoController {
  constructor(private readonly service: GeoService) {}

  @Get('health')
  health() {
    return this.service.health();
  }
}
