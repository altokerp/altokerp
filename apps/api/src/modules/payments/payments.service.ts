import { Injectable } from '@nestjs/common';

@Injectable()
export class PaymentsService {
  health() {
    return { module: 'payments', status: 'ok', phase: 'fase-1-base' };
  }
}
