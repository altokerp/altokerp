import { Injectable } from '@nestjs/common';

@Injectable()
export class PromotionsService {
  health() {
    return { module: 'promotions', status: 'ok', phase: 'fase-1-base' };
  }
}
