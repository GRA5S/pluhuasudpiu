# Next.js / shadcn / Vercel - Windows Dev Uninstall
# Usage: Set-ExecutionPolicy Bypass -Scope Process -Force; irm https://yoururl.com/uninstall.ps1 | iex
 
$ErrorActionPreference = "SilentlyContinue"
 
function Step($msg) { Write-Host "`n>> $msg..." -ForegroundColor Cyan }
function Ok($msg)   { Write-Host "   OK: $msg removed" -ForegroundColor Green }
function Skip($msg) { Write-Host "   SKIP: $msg not found" -ForegroundColor Yellow }
 
# 1. VS Code extensions
Step "Removing VS Code extensions"
if (Get-Command code -ErrorAction SilentlyContinue) {
    $exts = @(
        "esbenp.prettier-vscode"
        "dbaeumer.vscode-eslint"
        "bradlc.vscode-tailwindcss"
        "dsznajder.es7-react-js-snippets"
        "formulahendry.auto-rename-tag"
    )
    foreach ($ext in $exts) {
        code --uninstall-extension $ext 2>$null
        Ok $ext
    }
} else { Skip "VS Code (skipping extensions)" }
 
# 2. Global npm packages
Step "Removing global npm packages"
if (Get-Command npm -ErrorAction SilentlyContinue) {
    npm uninstall -g vercel pnpm --silent
    Ok "vercel, pnpm"
} else { Skip "npm globals" }
 
# 3. VS Code
Step "Removing VS Code"
if (Get-Command code -ErrorAction SilentlyContinue) {
    winget uninstall --id Microsoft.VisualStudioCode -e --silent
    Ok "VS Code"
} else { Skip "VS Code" }
 
# 4. Node.js
Step "Removing Node.js"
if (Get-Command node -ErrorAction SilentlyContinue) {
    winget uninstall --id OpenJS.NodeJS.LTS -e --silent
    Ok "Node.js"
} else { Skip "Node.js" }
 
# 5. Git
Step "Removing Git"
if (Get-Command git -ErrorAction SilentlyContinue) {
    winget uninstall --id Git.Git -e --silent
    Ok "Git"
} else { Skip "Git" }
 
Write-Host "`n============================================" -ForegroundColor Magenta
Write-Host "  Uninstall complete!" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Magenta
Write-Host "  Note: project folders and pnpm cache" -ForegroundColor DarkGray
Write-Host "  were NOT deleted - remove those manually." -ForegroundColor DarkGray