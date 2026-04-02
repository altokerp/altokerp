import { Injectable } from '@nestjs/common';

@Injectable()
export class AuthService {
  health() {
    return { module: 'auth', status: 'ok', phase: 'fase-1-base' };
  }
}
