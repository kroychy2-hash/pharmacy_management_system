import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from './roles.decorator';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<string[]>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!requiredRoles) {
      return true;
    }
    const { user } = context.switchToHttp().getRequest();
    // Assuming the user object is attached by JwtAuthGuard and roles fetched there or via another service
    if (!user || !user.roles) {
      throw new ForbiddenException('User has no roles assigned or roles not fetched');
    }
    
    return requiredRoles.some((role) => user.roles?.includes(role));
  }
}
