import { Injectable } from '@nestjs/common';

@Injectable()
export class GeoService {
  health() {
    return { module: 'geo', status: 'ok', phase: 'fase-1-base' };
  }
}
