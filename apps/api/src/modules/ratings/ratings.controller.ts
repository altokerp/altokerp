import { Controller, Get } from '@nestjs/common';
import { RatingsService } from './ratings.service';

@Controller('ratings')
export class RatingsController {
  constructor(private readonly service: RatingsService) {}

  @Get('health')
  health() {
    return this.service.health();
  }
}
