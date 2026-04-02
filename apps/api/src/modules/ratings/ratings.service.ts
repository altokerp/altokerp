import { Injectable } from '@nestjs/common';

@Injectable()
export class RatingsService {
  health() {
    return { module: 'ratings', status: 'ok', phase: 'fase-1-base' };
  }
}
