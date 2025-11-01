# Infrastructure Configuration

Docker Compose configurations and infrastructure-as-code for DispatchAI Platform environments.

## Overview

This directory contains Docker Compose configurations for different deployment environments:

- **Development** (`docker-compose.dev.yml`) - Local development environment
- **UAT** (`docker-compose.uat.yml`) - User acceptance testing environment  
- **Production** (`docker-compose.prod.yml`) - Production environment (not included yet)

## Quick Reference

| Environment | File | Services | Purpose |
|-------------|------|----------|---------|
| Development | `docker-compose.dev.yml` | All + DBs | Local development & testing |
| UAT | `docker-compose.uat.yml` | Frontend, API, AI | User acceptance testing |
| Production | `docker-compose.prod.yml` | Full stack | Live production |

## Development Environment

### Services

```yaml
services:
  frontend    # Next.js app on port 3000
  api         # NestJS app on port 4000
  ai          # FastAPI app on port 8000
  mongo       # MongoDB on port 27017
  redis       # Redis on port 6379
```

### Commands

```bash
# From project root
npm run dev:up          # Start all services
npm run dev:down        # Stop all services
npm run dev:logs        # View logs
npm run dev:ps          # Show containers

# Rebuild specific service
npm run dev:rebuild:api # Rebuild backend
npm run dev:rebuild:ai  # Rebuild AI service
```

### Environment Variables

Requires `.env.shared` and `.env.dev` at project root:

```bash
# .env.shared (common to all environments)
MONGODB_URI=mongodb://mongo:27017/dispatchai
REDIS_HOST=redis
REDIS_PORT=6379

# .env.dev (development only)
DEBUG=true
LOG_LEVEL=debug
NODE_ENV=development
```

## UAT Environment

### Services

```yaml
services:
  frontend    # From ECR: frontend:uat-latest
  api         # From ECR: backend:uat-latest
  ai          # From ECR: ai:uat-latest
```

### Deployment

UAT deployments are automated via GitHub Actions:

1. Push to `uat` branch triggers workflow
2. Builds Docker images
3. Pushes to AWS ECR
4. SSH to EC2 and runs `docker compose -f infra/docker-compose.uat.yml up -d`

### Environment Variables

```bash
# .env.shared
MONGODB_URI=mongodb://mongo:27017/dispatchai
REDIS_HOST=redis

# .env.uat
NODE_ENV=production
DEBUG=false
LOG_LEVEL=info
```

## Production Environment

Production configuration not yet available. Will follow same pattern as UAT.

## Health Checks

All services include health checks:

### API Health
```bash
curl http://localhost:4000/api/health
```

### AI Service Health  
```bash
curl http://localhost:8000/api/health
```

### Database Health
```bash
# MongoDB
docker exec dispatchai-mongodb mongosh --eval "db.runCommand({ ping: 1 })"

# Redis
docker exec dispatchai-redis redis-cli ping
```

## Networks

### Development Network

```yaml
networks:
  default:
    name: dispatchai-dev-network
```

All services communicate over bridge network. No external access required.

### UAT/Production Networks

Services communicate over isolated bridge network. External access only through:
- Frontend: Port 3000
- API: Port 4000  
- AI: Port 8000

## Volumes

### Development Volumes

```yaml
volumes:
  # Source code mounted for hot reload
  ../apps/frontend:/app
  ../apps/backend:/app
  ../apps/ai:/app
  
  # Persistent data
  mongo-data:/data/db
  redis-data:/data
```

### UAT/Production Volumes

No source code volumes - only data persistence:

```yaml
volumes:
  mongo-data:/data/db
  redis-data:/data
```

## Troubleshooting

### Services Not Starting

```bash
# Check logs
docker compose -f infra/docker-compose.dev.yml logs [service-name]

# Check container status
docker compose -f infra/docker-compose.dev.yml ps

# Rebuild from scratch
docker compose -f infra/docker-compose.dev.yml down -v
docker compose -f infra/docker-compose.dev.yml up --build
```

### Database Connection Issues

```bash
# Verify MongoDB is running
docker ps | grep mongo

# Check MongoDB logs
docker logs dispatchai-mongodb

# Test connection
docker exec dispatchai-mongodb mongosh dispatchai --eval "show collections"
```

### Port Conflicts

If ports are already in use:

1. Stop conflicting services
2. Or modify port mappings in compose file:
   ```yaml
   ports:
     - "3001:3000"  # Change from 3000 to 3001
   ```

### Clean Up

```bash
# Stop and remove containers
docker compose -f infra/docker-compose.dev.yml down

# Stop and remove containers + volumes
docker compose -f infra/docker-compose.dev.yml down -v

# Remove all images
docker compose -f infra/docker-compose.dev.yml down --rmi all
```

## Best Practices

### Development

1. **Use hot reload** - Source mounted for automatic reloading
2. **Separate env files** - Don't commit `.env` files
3. **Health checks** - Monitor service health regularly
4. **Clean volumes** - Start fresh if database issues occur

### UAT/Production

1. **Image versioning** - Use specific tags, not `latest`
2. **Separate networks** - Isolate production traffic
3. **Resource limits** - Set CPU/memory constraints
4. **Backup strategy** - Regular database backups
5. **Rollback plan** - Keep previous images for quick rollback

## Further Reading

- **Backend README**: `apps/backend/README.md`
- **Frontend README**: `apps/frontend/README.md`  
- **AI Service README**: `apps/ai/README.md`
- **Root README**: `README.md`
- **Docker Docs**: https://docs.docker.com/compose/
