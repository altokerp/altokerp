import { Injectable } from '@nestjs/common';

@Injectable()
export class TripsService {
  health() {
    return { module: 'trips', status: 'ok', phase: 'fase-1-base' };
  }
}
