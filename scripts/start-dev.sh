#!/bin/bash

# Development startup script for Wakoo
set -e

echo "🚀 Starting Wakoo in development mode..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

# Check if MongoDB is running
if ! pgrep -x "mongod" > /dev/null; then
    warning "MongoDB doesn't seem to be running. Please start MongoDB first."
    echo "On Windows: net start MongoDB"
    echo "On macOS: brew services start mongodb-community"
    echo "On Linux: sudo systemctl start mongod"
fi

# Backend setup
log "Setting up backend..."
cd backend

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    log "Installing backend dependencies..."
    npm install
fi

# Create .env if it doesn't exist
if [ ! -f .env ]; then
    log "Creating .env file from development template..."
    cp env.development .env
fi

# Create uploads directory
mkdir -p uploads

# Start backend
log "Starting backend server..."
npm run dev &
BACKEND_PID=$!

# Wait a moment for backend to start
sleep 3

# Check if backend is running
if curl -f http://localhost:3000/api/health > /dev/null 2>&1; then
    log "✅ Backend is running on http://localhost:3000"
else
    warning "Backend might not be running properly. Check the logs above."
fi

# Go back to root for Flutter
cd ..

# Flutter setup
log "Setting up Flutter..."
if [ ! -d "build" ]; then
    log "Getting Flutter dependencies..."
    flutter pub get
fi

# Start Flutter web
log "Starting Flutter web app..."
flutter run -d chrome --web-port 3000 &
FLUTTER_PID=$!

log "✅ Development environment started!"
echo ""
log "🌐 Backend API: http://localhost:3000/api/health"
log "🌐 Flutter Web: http://localhost:3000"
echo ""
log "To stop: Press Ctrl+C or run 'pkill -f \"node server.js\"' and 'pkill -f \"flutter run\"'"

# Wait for user to stop
wait

