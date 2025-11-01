# DispatchAI Platform

**AI-Powered Service Dispatch Platform** - An intelligent customer service automation platform that handles phone calls, schedules appointments, and manages service bookings using AI agents.

## 🏗️ Architecture Overview

DispatchAI Platform is a **monorepo** consisting of three main services:

```
dispatchai-platform/
├── apps/
│   ├── frontend/      # Next.js 15 web application
│   ├── backend/       # NestJS REST API & business logic
│   └── ai/            # FastAPI AI agent service
├── infra/             # Docker Compose configurations
└── .github/           # CI/CD workflows
```

### Core Components

| Service | Tech Stack | Port | Purpose |
|---------|------------|------|---------|
| **Frontend** | Next.js 15, React 19, TypeScript, Material-UI | 3000 | User dashboard, service management UI |
| **Backend** | NestJS, TypeScript, MongoDB, Redis | 4000 | REST API, business logic, telephony webhooks |
| **AI Service** | FastAPI, Python 3.11, LangGraph, OpenAI | 8000 | AI conversation agent, call handling, dispatch |

### Infrastructure Stack

- **Databases**: MongoDB 7 (primary), Redis 7 (caching/sessions)
- **Telephony**: Twilio integration for voice calls and SMS
- **Payment**: Stripe integration
- **Calendar**: Google Calendar & Outlook integration
- **Deployment**: Docker Compose + AWS ECR + EC2
- **CI/CD**: GitHub Actions

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- Git
- AWS CLI (for deployments)
- SSH keys configured (for UAT deployment)

### Development Environment

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd dispatchai-platform
   ```

2. **Configure environment variables**
   ```bash
   # Create .env files at root
   touch .env.shared .env.dev
   
   # Configure backend
   cd apps/backend
   touch .env.local
   
   # Configure frontend
   cd ../frontend
   touch .env.local
   
   # Configure AI service
   cd ../ai
   touch .env.local
   ```

3. **Start all services**
   ```bash
   npm run dev:up
   ```

4. **Access services**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:4000
   - AI Service: http://localhost:8000
   - MongoDB: localhost:27017
   - Redis: localhost:6379

### Available Commands

```bash
# Development
npm run dev:up              # Start all services
npm run dev:down            # Stop all services
npm run dev:logs            # View logs (last 100 lines)
npm run dev:ps              # Show running containers

# Rebuild specific services
npm run dev:rebuild:api     # Rebuild backend only
npm run dev:rebuild:ai      # Rebuild AI service only

# UAT Deployment
npm run uat:up              # Deploy to UAT environment
npm run uat:down            # Stop UAT services
```

## 📁 Project Structure

### Frontend (`apps/frontend/`)
Next.js application for managing services, bookings, calendar, and dashboards.

**Key Features:**
- Service booking management
- Calendar integration (Google/Outlook)
- Real-time call management
- Analytics and reporting dashboards
- User authentication & authorization

**Key Directories:**
- `src/app/` - Next.js app router pages
- `src/components/` - Reusable React components
- `src/features/` - Feature-specific modules
- `src/redux/` - Global state management
- `src/services/` - API client services

### Backend (`apps/backend/`)
NestJS REST API handling all business logic and integrations.

**Key Features:**
- Authentication & authorization (JWT, Google OAuth)
- Telephony webhooks (Twilio)
- Payment processing (Stripe)
- Calendar token management
- User, company, service management
- Transcript & call log storage

**Key Modules:**
- `auth/` - Authentication & JWT strategies
- `telephony/` - Twilio integration & webhooks
- `stripe/` - Payment webhooks & subscription
- `google-calendar/` - Calendar OAuth & tokens
- `service-booking/` - Appointment management
- `transcript/` - Call transcripts & chunks
- `location/` - Service location mapping
- `availability/` - Business hours management

### AI Service (`apps/ai/`)
FastAPI service powered by LangGraph AI agents for intelligent call handling.

**Key Features:**
- Multi-step conversation workflow (8-step agent)
- Customer info extraction (name, phone, email, address)
- Service scheduling with calendar integration
- Natural language understanding
- Email sending with ICS attachments
- MCP (Model Context Protocol) integration

**Key Components:**
- `app/api/` - API endpoints (chat, call, summary, email, dispatch)
- `app/services/` - Core business logic
  - `call_handler.py` - Main conversation orchestrator
  - `dialog_manager.py` - Multi-turn conversation state
  - `llm_service.py` - LLM integration
  - `call_summary.py` - Post-call summaries
- `app/infrastructure/` - Redis client for caching
- `app/models/` - Data models (CallSkeleton, conversations)

## 🔄 Data Flow

```
Phone Call → Twilio Webhook → Backend API
                                        ↓
                              Store Call Skeleton in Redis
                                        ↓
                              Frontend fetches conversation
                                        ↓
                              User speaks → Frontend → AI Service
                                        ↓
                              AI processes with LangGraph agent
                                        ↓
                              Extract info → Schedule service
                                        ↓
                              Send email + calendar invite
                                        ↓
                              Update backend with booking
```

## 🌍 Environment Variables

### Root `.env.shared`
```bash
# MongoDB
MONGODB_URI=mongodb://mongo:27017/dispatchai

# Redis
REDIS_HOST=redis
REDIS_PORT=6379

# Twilio
TWILIO_ACCOUNT_SID=your_account_sid
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_PHONE_NUMBER=+1234567890

# OpenAI
OPENAI_API_KEY=your_openai_key
```

### Backend `.env.local`
```bash
# JWT
JWT_SECRET=your_jwt_secret
JWT_EXPIRES_IN=7d

# Google OAuth
GOOGLE_CLIENT_ID=your_client_id
GOOGLE_CLIENT_SECRET=your_client_secret

# Stripe
STRIPE_SECRET_KEY=your_stripe_key
STRIPE_WEBHOOK_SECRET=your_webhook_secret
```

### Frontend `.env.local`
```bash
NEXT_PUBLIC_API_URL=http://localhost:4000/api
NEXT_PUBLIC_AI_URL=http://localhost:8000/api

# Google
NEXT_PUBLIC_GOOGLE_CLIENT_ID=your_client_id
NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=your_maps_key
```

### AI Service `.env.local`
```bash
OPENAI_API_KEY=your_openai_key
OPENAI_MODEL=gpt-4o-mini

REDIS_HOST=redis
REDIS_PORT=6379
```

## 🧪 Testing

### Backend
```bash
cd apps/backend
npm run test              # Run all tests
npm run test:unit         # Unit tests only
npm run test:integration  # Integration tests only
npm run test:watch        # Watch mode
```

### AI Service
```bash
cd apps/ai
make test                 # Run pytest with coverage
make lint                 # Lint with Ruff
make typecheck            # Type check with MyPy
make check-all            # Run all checks
```

## 🚢 Deployment

### UAT Environment

UAT deployments are automated via GitHub Actions:

1. **Manual trigger** via GitHub Actions UI
2. **Automatic trigger** from sub-repository dispatch events

**Deployment process:**
1. SSH to UAT EC2 instance
2. Pull latest code
3. Login to AWS ECR
4. Pull latest container images
5. Restart services with docker-compose
6. Clean up old images

**UAT configuration:**
- EC2 region: `ap-southeast-2`
- Project directory: `/opt/dispatchai-platform`
- Compose file: `infra/docker-compose.uat.yml`
- ECR registry: `123456789012.dkr.ecr.ap-southeast-2.amazonaws.com`

### Secrets Required

```bash
# GitHub Secrets
UAT_SSH_KEY           # SSH private key
UAT_SSH_HOST          # EC2 host IP
UAT_SSH_USER          # SSH username
AWS_REGION            # AWS region
```

## 🔍 Common Tasks for AI Coding Tools

### Finding Code Quickly

**Authentication & Authorization**
- Backend: `apps/backend/src/modules/auth/`
- Frontend: `apps/frontend/src/app/auth/`

**Call Handling & Telephony**
- Twilio integration: `apps/backend/src/modules/telephony/`
- AI conversation: `apps/ai/app/services/call_handler.py`
- Frontend UI: `apps/frontend/src/app/dashboard/call/`

**Service Booking**
- API: `apps/backend/src/modules/service-booking/`
- Frontend: `apps/frontend/src/app/dashboard/service-booking/`
- AI scheduling: `apps/ai/app/api/dispatch.py`

**Calendar Integration**
- OAuth: `apps/backend/src/modules/google-calendar/`
- Email with ICS: `apps/ai/app/services/ses_email.py`
- Frontend: `apps/frontend/src/app/dashboard/calendar/`

**Transcripts & Summaries**
- Storage: `apps/backend/src/modules/transcript/`
- AI summary: `apps/ai/app/services/call_summary.py`
- Chunks: `apps/backend/src/modules/transcript-chunk/`

### Debugging Tips

1. **Check logs**:
   ```bash
   npm run dev:logs                 # All services
   docker logs dispatchai-api       # Backend only
   docker logs dispatchai-ai        # AI service only
   docker logs dispatchai-frontend  # Frontend only
   ```

2. **Redis inspection**:
   ```bash
   docker exec -it dispatchai-redis redis-cli
   KEYS *                           # List all keys
   GET <key>                        # Get value
   ```

3. **MongoDB inspection**:
   ```bash
   docker exec -it dispatchai-mongodb mongosh
   use dispatchai
   show collections
   db.<collection>.find().pretty()
   ```

4. **AI service testing**:
   ```bash
   cd apps/ai
   uv run pytest tests/ --verbose
   curl http://localhost:8000/api/health
   ```

## 📚 Additional Resources

- **Backend API Docs**: `http://localhost:4000/api` (Swagger UI)
- **AI Service Docs**: `http://localhost:8000/docs` (FastAPI OpenAPI)
- **Backend README**: See `apps/backend/README.md`
- **Frontend README**: See `apps/frontend/README.md`
- **AI Service README**: See `apps/ai/README.md`

## 🤝 Development Workflow

1. **Feature branch**: Create feature branch from `main`
2. **Development**: Make changes, test locally
3. **Commit**: Follow conventional commits
4. **Push**: Push to remote
5. **PR**: Create pull request
6. **Review**: Code review and approval
7. **Merge**: Merge to `main`
8. **Deploy**: Auto-deploy to UAT via GitHub Actions

## 📝 License

[Add your license information here]

## 👥 Contributors

[Add contributor information here]
