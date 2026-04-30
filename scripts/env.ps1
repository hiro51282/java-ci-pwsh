param(
    [string]$define = "./define.json"
)

# --- load config ---
if (-not (Test-Path $define)) {
    Write-Host "define.json が存在しません"
    exit 1
}

$conf = Get-Content $define -Raw | ConvertFrom-Json

$workspace = $conf.env.workspace
$repo      = $conf.env.repo

# --- validate ---
if ([string]::IsNullOrEmpty($workspace)) {
    Write-Host "workspace 未定義"
    exit 1
}

if ([string]::IsNullOrEmpty($repo)) {
    Write-Host "repo 未定義"
    exit 1
}

# --- clean workspace ---
if (Test-Path $workspace) {
    Remove-Item $workspace -Recurse -Force
}

# --- clone ---
git clone $repo $workspace

if (-not (Test-Path $workspace)) {
    Write-Host "clone失敗"
    exit 1
}

Write-Host "env構築OK"
exit 0