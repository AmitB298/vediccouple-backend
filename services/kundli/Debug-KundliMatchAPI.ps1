# Debug-KundliMatchAPI.ps1
$pythonPath = ".\venv\Scripts\python.exe"
$scriptPath = "kundli_api.py"
$logFile = "api_debug.log"
$uri = "http://127.0.0.1:5055/api/kundli/match"
# ðŸ›‘ Kill old Python servers
Write-Host "ðŸ”ª Killing old Python/Flask processes..."
Get-Process python -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
# ðŸ§¹ Unlock and delete log file
if (Test-Path $logFile) {
    try {
        Remove-Item $logFile -Force -ErrorAction Stop
    } catch {
        Write-Host "âš ï¸  Log file in use. Retrying..."
        Start-Sleep -Seconds 2
        Stop-Process -Name "python" -Force -ErrorAction SilentlyContinue
        Remove-Item $logFile -Force -ErrorAction SilentlyContinue
    }
}
# ðŸ§¼ Sanitize kundli_api.py (remove emoji/unicode)
$content = Get-Content $scriptPath
$cleaned = $content | Where-Object { $_ -cmatch '^[\x00-\x7F]*$' }
$cleaned | Set-Content $scriptPath -Encoding utf8
# âœ… Ensure __main__ block exists
if ($cleaned -join "`n" -notmatch "if\s+__name__\s*==\s*['""]__main__['""]") {
    Write-Host "âš ï¸  Adding '__main__' block..."
    Add-Content -Path $scriptPath -Value @"
if __name__ == '__main__':
    print("Starting Kundli Match API...")
    app.run(debug=True, host='0.0.0.0', port=5055)
"@
}
# ðŸš€ Start Flask server in background
Write-Host "`nðŸš€ Launching Flask API in background..."
Start-Job -ScriptBlock {
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$using:pythonPath $using:scriptPath > $using:logFile 2>&1`"" -NoNewWindow
} | Out-Null
Start-Sleep -Seconds 5
# ðŸŒ Ping API up to 6 times
$pingSuccess = $false
for ($i = 0; $i -lt 6; $i++) {
    try {
        $null = Invoke-RestMethod -Uri $uri -Method Options -TimeoutSec 3
        $pingSuccess = $true
        break
    } catch {
        Start-Sleep -Seconds 2
    }
}
if (-not $pingSuccess) {
    Write-Host "âŒ API did not start after 12 seconds. Check $logFile for issues." -ForegroundColor Red
    if (Test-Path $logFile) { Get-Content $logFile -Tail 40 }
    exit
}
# ðŸ“¡ Send test request
$payload = @{
    person1 = @{
        name = "Amit"
        birth_date = "1990-01-01"
        birth_time = "12:00:00"
        latitude = 28.6139
        longitude = 77.2090
    }
    person2 = @{
        name = "Anita"
        birth_date = "1992-05-10"
        birth_time = "15:30:00"
        latitude = 19.0760
        longitude = 72.8777
    }
} | ConvertTo-Json -Depth 4
Write-Host "`nðŸ“¡ Sending test request to $uri ..."
try {
    $response = Invoke-RestMethod -Uri $uri -Method POST -Body $payload -ContentType "application/json"
    Write-Host "âœ… Response received!"
    Write-Host "ðŸ”® Guna Score: $($response.guna_score)"
    Write-Host "âœ… Verdict: $($response.verdict)"
} catch {
    Write-Host "âŒ Request failed: $($_.Exception.Message)" -ForegroundColor Red
    if (Test-Path $logFile) {
        Write-Host "`nðŸ“„ Log output:"
        Get-Content $logFile -Tail 40
    } else {
        Write-Host "âš ï¸  Log file not found."
    }
}
Write-Host "`nðŸ“„ Full log at: $logFile"
