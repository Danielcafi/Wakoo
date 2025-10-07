#!/bin/bash

# Production setup script for Wakoo
set -e

echo "🚀 Setting up Wakoo for production..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   error "This script should not be run as root"
fi

# Install PM2 globally if not installed
if ! command -v pm2 &> /dev/null; then
    log "Installing PM2..."
    npm install -g pm2
fi

# Install dependencies
log "Installing backend dependencies..."
cd backend
npm install --production

# Create logs directory
mkdir -p logs

# Create uploads directory
mkdir -p uploads

# Copy environment file
if [ ! -f .env ]; then
    log "Creating .env file from production template..."
    cp env.production .env
    warning "Please edit backend/.env with your production values!"
fi

# Start with PM2
log "Starting application with PM2..."
pm2 start ecosystem.config.js --env production

# Save PM2 configuration
pm2 save
pm2 startup

log "✅ Production setup complete!"
log "📊 Monitor with: pm2 monit"
log "📋 Status with: pm2 status"
log "🔄 Restart with: pm2 restart wakoo-backend"
log "📝 Logs with: pm2 logs wakoo-backend"

echo ""
log "Next steps:"
echo "1. Configure nginx with your domain"
echo "2. Set up SSL certificates"
echo "3. Configure MongoDB Atlas or your production database"
echo "4. Update FRONTEND_URL in backend/.env"

