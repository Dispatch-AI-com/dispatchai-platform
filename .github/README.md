# GitHub Actions & CI/CD

Automated deployment workflows for DispatchAI Platform.

## Overview

This directory contains GitHub Actions workflows for automated testing, building, and deployment.

## Available Workflows

| Workflow | File | Trigger | Purpose |
|----------|------|---------|---------|
| **UAT Deployment** | `workflows/deploy-uat.yml` | Manual/Submodule dispatch | Deploy to UAT environment |

## UAT Deployment Workflow

### Trigger

**Two ways to trigger:**

1. **Manual trigger** (from GitHub Actions UI)
   - Go to Actions → "Deploy UAT"
   - Click "Run workflow"
   - Add optional reason

2. **Submodule dispatch** (from sub-repo)
   - When sub-repo pushes to `main`, it can trigger parent repo
   - Event type: `deploy_uat`

### Workflow Steps

1. **Checkout** - Clone main repository
2. **SSH Setup** - Configure SSH agent with private key
3. **Deploy** - SSH to EC2 and run:
   - Pull latest code
   - Login to AWS ECR
   - Pull latest images
   - Restart containers
   - Clean up old images

### Required Secrets

Configure these in GitHub repository settings:

```bash
UAT_SSH_KEY          # SSH private key for EC2 access
UAT_SSH_HOST         # EC2 instance hostname/IP
UAT_SSH_USER         # SSH username (usually 'ubuntu' or 'ec2-user')
```

### Environment Variables

```yaml
AWS_REGION: ap-southeast-2
REMOTE_PROJECT_DIR: /opt/dispatchai-platform
REMOTE_COMPOSE_FILE: infra/docker-compose.uat.yml
```

## AWS ECR Authentication

The workflow automatically authenticates with AWS ECR:

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
aws ecr get-login-password --region ${AWS_REGION} \
  | docker login --username AWS --password-stdin \
  ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
```

**Required permissions** on EC2:
- `ecr:GetAuthorizationToken`
- `ecr:BatchCheckLayerAvailability`
- `ecr:BatchGetImage`
- `ecr:GetDownloadUrlForLayer`

## Deployment Process

### On UAT EC2

```bash
# 1. Navigate to project
cd /opt/dispatchai-platform

# 2. Update code (optional)
git fetch --all --prune
git pull --rebase

# 3. Login to ECR
ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
aws ecr get-login-password --region ap-southeast-2 \
  | docker login --username AWS --password-stdin \
  ${ACCOUNT_ID}.dkr.ecr.ap-southeast-2.amazonaws.com

# 4. Pull latest images
docker compose -f infra/docker-compose.uat.yml pull

# 5. Restart services (zero-downtime if using rolling updates)
docker compose -f infra/docker-compose.uat.yml up -d

# 6. Verify
docker compose -f infra/docker-compose.uat.yml ps

# 7. Clean up
docker image prune -f
```

### Zero-Downtime Deployment

**Current approach:**
- Stops old containers
- Starts new containers
- Brief downtime (~10-30 seconds)

**Future improvement:**
- Use blue-green deployment
- Or rolling updates with multiple replicas

## Monitoring

### GitHub Actions

View deployment status:
1. Go to **Actions** tab
2. Select **Deploy UAT** workflow
3. Click on run to see logs

### EC2 Monitoring

```bash
# SSH to EC2
ssh ${UAT_SSH_USER}@${UAT_SSH_HOST}

# Check container logs
docker compose -f infra/docker-compose.uat.yml logs -f

# Check resource usage
docker stats

# Check container health
docker compose -f infra/docker-compose.uat.yml ps
```

## Rollback

### Quick Rollback

```bash
# SSH to UAT EC2
ssh ${UAT_SSH_USER}@${UAT_SSH_HOST}

# Navigate to project
cd /opt/dispatchai-platform

# Check available images
docker images | grep dispatchai

# Use previous image tag
docker compose -f infra/docker-compose.uat.yml down
docker tag registry/image:previous-tag registry/image:uat-latest
docker compose -f infra/docker-compose.uat.yml up -d
```

## Troubleshooting

### Deployment Fails

**Check logs:**
1. GitHub Actions → Workflow run → Failed step
2. EC2 logs: `docker compose -f infra/docker-compose.uat.yml logs [service]`

**Common issues:**
- SSH key expired → Regenerate and update secret
- ECR access denied → Check IAM permissions
- Port conflicts → Stop conflicting services
- Image not found → Check ECR repository and tags

### SSH Connection Issues

```bash
# Test SSH manually
ssh -i ~/.ssh/key ${UAT_SSH_USER}@${UAT_SSH_HOST}

# Check SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/key

# Verify GitHub secret format
# Ensure private key includes header/footer
# -----BEGIN RSA PRIVATE KEY-----
# ...
# -----END RSA PRIVATE KEY-----
```

### ECR Login Issues

```bash
# Verify AWS credentials
aws sts get-caller-identity

# Manual ECR login
aws ecr get-login-password --region ap-southeast-2 \
  | docker login --username AWS --password-stdin \
  <account-id>.dkr.ecr.ap-southeast-2.amazonaws.com

# List images
aws ecr list-images --repository-name frontend --region ap-southeast-2
```

## Future Workflows

### Development CI/CD

**Planned:**
- `build.yml` - Build and test on PR
- `deploy-dev.yml` - Auto-deploy to dev environment
- `security-scan.yml` - Vulnerability scanning
- `notify.yml` - Slack/Discord notifications

### Production Deployment

**Planned:**
- `deploy-prod.yml` - Production deployment
- `blue-green-deploy.yml` - Zero-downtime production
- `rollback-prod.yml` - Emergency rollback

## Best Practices

### Security

1. **Never commit secrets** - Use GitHub Secrets
2. **Rotate SSH keys** - Every 90 days
3. **Limit permissions** - Least privilege IAM roles
4. **Audit logs** - Monitor all deployments

### Reliability

1. **Test first** - Run tests before deploy
2. **Monitor health** - Check service health after deploy
3. **Have rollback plan** - Know how to revert
4. **Use tags** - Specific versions, not `latest`

### Documentation

1. **Update readme** - Document workflow changes
2. **Add comments** - Explain complex steps
3. **Version workflows** - Tag major changes
4. **Keep logs** - Retain deployment history

## Further Reading

- **Infrastructure README**: `infra/README.md`
- **Root README**: `README.md`
- **GitHub Actions Docs**: https://docs.github.com/en/actions
- **AWS ECR Docs**: https://docs.aws.amazon.com/ecr/
