import { Injectable } from '@nestjs/common';

@Injectable()
export class AdminService {
  health() {
    return { module: 'admin', status: 'ok', phase: 'fase-1-base' };
  }
}
