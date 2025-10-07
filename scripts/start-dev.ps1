Param(
  [int]$WebPort = 3000
)

Write-Host "🚀 Starting Wakoo (backend + Flutter web) ..." -ForegroundColor Green

$root = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
Set-Location $root

# --- Backend ---
if (!(Test-Path -Path "backend/package.json")) {
  Write-Error "backend/package.json not found. Run this script from the project root (BENSPEEKS)."
  exit 1
}

Write-Host "📦 Installing backend deps if needed..." -ForegroundColor Yellow
Set-Location backend
if (!(Test-Path -Path "node_modules")) {
  npm install
}

if (!(Test-Path -Path ".env")) {
  if (Test-Path -Path "env.development") {
    Copy-Item env.development .env
    Write-Host "📝 Created backend/.env from env.development" -ForegroundColor Yellow
  }
}

Write-Host "🟢 Starting backend on http://localhost:3000 ..." -ForegroundColor Green
Start-Process -WindowStyle Minimized pwsh -ArgumentList "-NoExit","-Command","Set-Location $PWD; npm run dev"

# Give backend a moment to start
Start-Sleep -Seconds 3

try {
  $health = Invoke-WebRequest -UseBasicParsing http://localhost:3000/api/health -TimeoutSec 5
  if ($health.StatusCode -eq 200) {
    Write-Host "✅ Backend is up: http://localhost:3000/api/health" -ForegroundColor Green
  }
} catch {
  Write-Host "⚠️ Backend health check failed. Check the backend window logs." -ForegroundColor Yellow
}

# --- Flutter ---
Set-Location $root
Write-Host "📦 Getting Flutter dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host "🌐 Starting Flutter Web on http://localhost:$WebPort ..." -ForegroundColor Green
flutter run -d chrome --web-port $WebPort



