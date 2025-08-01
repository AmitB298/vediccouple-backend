# Run-KundliHybridTest.ps1
$pythonPath = ".\venv\Scripts\python.exe"
$scriptPath = "kundli_hybrid_matcher.py"
Write-Host "ðŸ§ª Testing Hybrid Kundli Matcher..."
if (!(Test-Path $scriptPath)) {
    Write-Host "âŒ Script not found: $scriptPath" -ForegroundColor Red
    exit 1
}
# Run it
try {
    & $pythonPath $scriptPath
} catch {
    Write-Host "âŒ Error running hybrid matcher: $_" -ForegroundColor Red
}
