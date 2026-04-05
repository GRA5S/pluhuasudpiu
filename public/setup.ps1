# Next.js / shadcn / Vercel - Windows Dev Setup
# Usage: Set-ExecutionPolicy Bypass -Scope Process -Force; irm https://yoururl.com/setup.ps1 | iex
 
$ErrorActionPreference = "Stop"
 
function Step($msg) { Write-Host "`n>> $msg..." -ForegroundColor Cyan }
function Ok($msg)   { Write-Host "   OK: $msg" -ForegroundColor Green }
function Skip($msg) { Write-Host "   SKIP: $msg already installed" -ForegroundColor Yellow }
 
function RefreshPath {
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("PATH","User")
}
 
# 1. Git
Step "Installing Git"
if (Get-Command git -ErrorAction SilentlyContinue) { Skip "Git" } else {
    winget install --id Git.Git -e --source winget --silent --accept-package-agreements --accept-source-agreements
    RefreshPath
    Ok "Git"
}
 
# 2. Node.js LTS (direct, not via nvm - simpler and doesn't hang)
Step "Installing Node.js LTS"
if (Get-Command node -ErrorAction SilentlyContinue) { Skip "Node.js" } else {
    winget install --id OpenJS.NodeJS.LTS -e --source winget --silent --accept-package-agreements --accept-source-agreements
    RefreshPath
    Ok "Node.js $(node --version)"
}
 
# 3. pnpm
Step "Installing pnpm"
if (Get-Command pnpm -ErrorAction SilentlyContinue) { Skip "pnpm" } else {
    npm install -g pnpm --silent
    RefreshPath
    Ok "pnpm"
}
 
# 4. Vercel CLI
Step "Installing Vercel CLI"
if (Get-Command vercel -ErrorAction SilentlyContinue) { Skip "Vercel CLI" } else {
    npm install -g vercel --silent
    Ok "Vercel CLI"
}
 
# 5. VS Code
Step "Installing VS Code"
if (Get-Command code -ErrorAction SilentlyContinue) { Skip "VS Code" } else {
    winget install --id Microsoft.VisualStudioCode -e --source winget --silent --accept-package-agreements --accept-source-agreements
    RefreshPath
    Ok "VS Code"
}
 
# 6. VS Code extensions
Step "Installing VS Code extensions"
$exts = @(
    "esbenp.prettier-vscode"
    "dbaeumer.vscode-eslint"
    "bradlc.vscode-tailwindcss"
    "dsznajder.es7-react-js-snippets"
    "formulahendry.auto-rename-tag"
)
foreach ($ext in $exts) {
    code --install-extension $ext --force 2>$null
    Ok $ext
}
 
# Done
Write-Host "`n============================================" -ForegroundColor Magenta
Write-Host "  All done! Restart your terminal." -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta
Write-Host @"
 
To start a new project:
  pnpm create next-app@latest my-app --typescript --tailwind --eslint --app
  cd my-app
  pnpm dlx shadcn@latest init
  vercel login
"@