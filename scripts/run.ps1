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
$successRel = $conf.run.success
$failRel    = $conf.run.fail
$logDir     = $conf.run.logDir

# --- validate ---
if ([string]::IsNullOrEmpty($workspace)) {
    Write-Host "workspace 未定義"
    exit 1
}

if ([string]::IsNullOrEmpty($successRel)) {
    Write-Host "success 未定義"
    exit 1
}

if ([string]::IsNullOrEmpty($failRel)) {
    Write-Host "fail 未定義"
    exit 1
}

if ([string]::IsNullOrEmpty($logDir)) {
    Write-Host "logDir 未定義"
    exit 1
}

# --- prepare ---
New-Item $logDir -ItemType Directory -Force | Out-Null

$successFile = Join-Path $workspace $successRel
$failFile    = Join-Path $workspace $failRel

$result = $true

# --- Success ---
javac $successFile 2> (Join-Path $logDir "success.err")
if ($LASTEXITCODE -ne 0) {
    Write-Host "Success が失敗（NG）"
    $result = $false
}

# --- Fail ---
javac $failFile 2> (Join-Path $logDir "fail.err")
if ($LASTEXITCODE -eq 0) {
    Write-Host "Fail が成功してしまった（NG）"
    $result = $false
}

# --- output ---
Write-Host "=== Fail Error Log ==="
$failLog = Join-Path $logDir "fail.err"
if (Test-Path $failLog) {
    Get-Content $failLog
}

if ($result) {
    Write-Host "CI OK"
    exit 0
} else {
    Write-Host "CI NG"
    exit 1
}
