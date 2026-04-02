import { Injectable } from '@nestjs/common';

@Injectable()
export class DriversService {
  health() {
    return { module: 'drivers', status: 'ok', phase: 'fase-1-base' };
  }
}
