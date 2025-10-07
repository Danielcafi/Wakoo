# Wakoo Project - Complete Installation Script
# This script installs everything needed for the Wakoo project

param(
    [switch]$SkipFlutter,
    [switch]$SkipNode,
    [switch]$SkipMongoDB,
    [switch]$Force
)

Write-Host "🚀 Wakoo Project - Complete Installation" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Host "⚠️  Some installations may require administrator privileges." -ForegroundColor Yellow
    Write-Host "   If you encounter permission errors, run PowerShell as Administrator." -ForegroundColor Yellow
    Write-Host ""
}

# 1. Install Node.js
if (-not $SkipNode) {
    Write-Host "📦 Installing Node.js..." -ForegroundColor Cyan
    
    if (Get-Command node -ErrorAction SilentlyContinue) {
        $nodeVersion = node --version
        Write-Host "✅ Node.js already installed: $nodeVersion" -ForegroundColor Green
    } else {
        Write-Host "Downloading Node.js installer..." -ForegroundColor Yellow
        $nodeUrl = "https://nodejs.org/dist/v18.19.0/node-v18.19.0-x64.msi"
        $nodeInstaller = "$env:TEMP\node-installer.msi"
        
        try {
            Invoke-WebRequest -Uri $nodeUrl -OutFile $nodeInstaller
            Write-Host "Installing Node.js..." -ForegroundColor Yellow
            Start-Process msiexec.exe -Wait -ArgumentList "/i $nodeInstaller /quiet"
            Remove-Item $nodeInstaller
            Write-Host "✅ Node.js installed successfully" -ForegroundColor Green
        } catch {
            Write-Host "❌ Failed to install Node.js automatically" -ForegroundColor Red
            Write-Host "   Please download and install from: https://nodejs.org/" -ForegroundColor Yellow
        }
    }
}

# 2. Install Flutter
if (-not $SkipFlutter) {
    Write-Host "📱 Installing Flutter..." -ForegroundColor Cyan
    
    if (Get-Command flutter -ErrorAction SilentlyContinue) {
        $flutterVersion = flutter --version
        Write-Host "✅ Flutter already installed: $flutterVersion" -ForegroundColor Green
    } else {
        Write-Host "Setting up Flutter..." -ForegroundColor Yellow
        
        # Create Flutter directory
        $flutterPath = "$env:USERPROFILE\flutter"
        if (-not (Test-Path $flutterPath)) {
            New-Item -ItemType Directory -Path $flutterPath -Force
        }
        
        # Download Flutter
        $flutterZip = "$env:TEMP\flutter_windows.zip"
        $flutterUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.13.0-stable.zip"
        
        try {
            Write-Host "Downloading Flutter..." -ForegroundColor Yellow
            Invoke-WebRequest -Uri $flutterUrl -OutFile $flutterZip
            
            Write-Host "Extracting Flutter..." -ForegroundColor Yellow
            Expand-Archive -Path $flutterZip -DestinationPath $flutterPath -Force
            Remove-Item $flutterZip
            
            # Add Flutter to PATH
            $flutterBin = "$flutterPath\flutter\bin"
            $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
            if ($currentPath -notlike "*$flutterBin*") {
                [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$flutterBin", "User")
                Write-Host "✅ Flutter added to PATH" -ForegroundColor Green
            }
            
            Write-Host "✅ Flutter installed successfully" -ForegroundColor Green
            Write-Host "   Please restart your terminal for PATH changes to take effect" -ForegroundColor Yellow
        } catch {
            Write-Host "❌ Failed to install Flutter automatically" -ForegroundColor Red
            Write-Host "   Please download from: https://flutter.dev/docs/get-started/install/windows" -ForegroundColor Yellow
        }
    }
}

# 3. Install MongoDB
if (-not $SkipMongoDB) {
    Write-Host "🗄️  Installing MongoDB..." -ForegroundColor Cyan
    
    if (Get-Command mongod -ErrorAction SilentlyContinue) {
        Write-Host "✅ MongoDB already installed" -ForegroundColor Green
    } else {
        Write-Host "MongoDB installation options:" -ForegroundColor Yellow
        Write-Host "1. MongoDB Community Server (Recommended)" -ForegroundColor White
        Write-Host "2. MongoDB Atlas (Cloud - No local installation)" -ForegroundColor White
        Write-Host "3. Skip MongoDB installation" -ForegroundColor White
        
        $choice = Read-Host "Choose option (1-3)"
        
        switch ($choice) {
            "1" {
                Write-Host "Downloading MongoDB Community Server..." -ForegroundColor Yellow
                $mongoUrl = "https://fastdl.mongodb.org/windows/mongodb-windows-x86_64-7.0.4-signed.msi"
                $mongoInstaller = "$env:TEMP\mongodb-installer.msi"
                
                try {
                    Invoke-WebRequest -Uri $mongoUrl -OutFile $mongoInstaller
                    Write-Host "Installing MongoDB..." -ForegroundColor Yellow
                    Start-Process msiexec.exe -Wait -ArgumentList "/i $mongoInstaller /quiet"
                    Remove-Item $mongoInstaller
                    Write-Host "✅ MongoDB installed successfully" -ForegroundColor Green
                } catch {
                    Write-Host "❌ Failed to install MongoDB automatically" -ForegroundColor Red
                    Write-Host "   Please download from: https://www.mongodb.com/try/download/community" -ForegroundColor Yellow
                }
            }
            "2" {
                Write-Host "🌐 For MongoDB Atlas (cloud):" -ForegroundColor Cyan
                Write-Host "   1. Go to: https://www.mongodb.com/atlas" -ForegroundColor White
                Write-Host "   2. Create a free account" -ForegroundColor White
                Write-Host "   3. Create a free cluster" -ForegroundColor White
                Write-Host "   4. Get your connection string" -ForegroundColor White
                Write-Host "   5. Update backend/.env with your MongoDB URI" -ForegroundColor White
            }
            "3" {
                Write-Host "⏭️  Skipping MongoDB installation" -ForegroundColor Yellow
            }
        }
    }
}

# 4. Install project dependencies
Write-Host "📦 Installing project dependencies..." -ForegroundColor Cyan

# Backend dependencies
Write-Host "Installing backend dependencies..." -ForegroundColor Yellow
Set-Location backend
if (Test-Path "package.json") {
    npm install
    Write-Host "✅ Backend dependencies installed" -ForegroundColor Green
} else {
    Write-Host "❌ package.json not found in backend folder" -ForegroundColor Red
}

# Flutter dependencies
Set-Location ..
Write-Host "Installing Flutter dependencies..." -ForegroundColor Yellow
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    flutter pub get
    Write-Host "✅ Flutter dependencies installed" -ForegroundColor Green
} else {
    Write-Host "❌ Flutter not found. Please install Flutter first." -ForegroundColor Red
}

# 5. Create environment files
Write-Host "📝 Setting up environment files..." -ForegroundColor Cyan

# Backend .env
if (-not (Test-Path "backend\.env")) {
    if (Test-Path "backend\env.development") {
        Copy-Item "backend\env.development" "backend\.env"
        Write-Host "✅ Created backend/.env from development template" -ForegroundColor Green
    }
}

# Create uploads directory
if (-not (Test-Path "backend\uploads")) {
    New-Item -ItemType Directory -Path "backend\uploads" -Force
    Write-Host "✅ Created backend/uploads directory" -ForegroundColor Green
}

# 6. Final instructions
Write-Host ""
Write-Host "🎉 Installation Complete!" -ForegroundColor Green
Write-Host "========================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Start MongoDB (if installed locally):" -ForegroundColor White
Write-Host "   net start MongoDB" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Start the backend:" -ForegroundColor White
Write-Host "   cd backend" -ForegroundColor Gray
Write-Host "   npm run dev" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Start Flutter (in a new terminal):" -ForegroundColor White
Write-Host "   flutter run -d chrome" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Or use the helper script:" -ForegroundColor White
Write-Host "   pwsh -File scripts/start-dev.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "🌐 URLs:" -ForegroundColor Cyan
Write-Host "   Backend API: http://localhost:3000/api/health" -ForegroundColor White
Write-Host "   Flutter Web: http://localhost:3000 (or port shown by Flutter)" -ForegroundColor White

