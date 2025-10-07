# 🚀 Wakoo Project - Complete Installation Guide

## Quick Start (Windows)

### Option 1: Automated Installation
```powershell
# Run the complete installation script
pwsh -File scripts/install-all.ps1
```

### Option 2: Manual Installation

## 📋 Prerequisites

### 1. Node.js (v18+)
- **Download**: https://nodejs.org/
- **Verify**: `node --version`
- **Package Manager**: npm (included with Node.js)

### 2. Flutter SDK
- **Download**: https://flutter.dev/docs/get-started/install/windows
- **Verify**: `flutter doctor`
- **Required**: Chrome browser for web development

### 3. MongoDB (Choose One)
- **Option A**: MongoDB Community Server (Local)
  - Download: https://www.mongodb.com/try/download/community
  - Start: `net start MongoDB`
- **Option B**: MongoDB Atlas (Cloud - Recommended)
  - Sign up: https://www.mongodb.com/atlas
  - Create free cluster
  - Get connection string

## 🛠️ Installation Steps

### Step 1: Clone and Setup
```bash
# Navigate to your project
cd C:\Users\laptop\xprojects\BENSPEEKS

# Install backend dependencies
cd backend
npm install

# Install Flutter dependencies
cd ..
flutter pub get
```

### Step 2: Environment Setup
```bash
# Create backend environment file
cd backend
copy env.development .env
# Edit .env with your settings

# Create uploads directory
mkdir uploads
```

### Step 3: Database Setup
**Option A: Local MongoDB**
```bash
# Start MongoDB service
net start MongoDB

# Test connection
mongosh
```

**Option B: MongoDB Atlas**
1. Create account at https://www.mongodb.com/atlas
2. Create free cluster
3. Get connection string
4. Update `backend/.env`:
```
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/wakoo
```

## 🚀 Running the Application

### Development Mode
```bash
# Terminal 1: Backend
cd backend
npm run dev

# Terminal 2: Flutter Web
flutter run -d chrome
```

### Using Helper Script
```powershell
# One command to start everything
pwsh -File scripts/start-dev.ps1
```

## 🌐 Access URLs
- **Backend API**: http://localhost:3000/api/health
- **Flutter Web**: http://localhost:3000 (or port shown by Flutter)

## 🔧 Troubleshooting

### Common Issues

#### 1. "npm: command not found"
- Install Node.js from https://nodejs.org/
- Restart terminal after installation

#### 2. "flutter: command not found"
- Install Flutter from https://flutter.dev/
- Add Flutter to PATH
- Run `flutter doctor`

#### 3. "Cannot find module" errors
```bash
cd backend
npm install
```

#### 4. MongoDB connection issues
- Check if MongoDB is running: `net start MongoDB`
- Verify connection string in `.env`
- For Atlas: check network access settings

#### 5. CORS errors
- Backend automatically handles localhost CORS
- If issues persist, check `backend/.env` FRONTEND_URL

### Verification Commands
```bash
# Check Node.js
node --version

# Check Flutter
flutter --version
flutter doctor

# Check MongoDB
mongosh --version

# Test backend
curl http://localhost:3000/api/health
```

## 📱 Building for Production

### Web Build
```bash
flutter build web
```

### Android Build
```bash
flutter build apk --release
```

### iOS Build (Mac only)
```bash
flutter build ios --release
```

## 🐳 Docker Alternative
```bash
# If you prefer Docker
docker-compose up -d
```

## 📞 Support
If you encounter issues:
1. Check the troubleshooting section above
2. Verify all prerequisites are installed
3. Check the console logs for specific errors
4. Ensure all services are running on correct ports

## 🎯 Next Steps
1. ✅ Install all prerequisites
2. ✅ Run the application
3. ✅ Test the API endpoints
4. ✅ Customize the application
5. ✅ Deploy to production

