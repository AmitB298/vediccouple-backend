<#
.SYNOPSIS
  Fix all occurrences of style={{ width: \\%\\ }} to valid JSX style
.DESCRIPTION
  Replaces invalid double-backslash percentage with template literal
.EXAMPLE
  .\Fix-AllPercentageBackslashes.ps1 -Path "src/components"
#>
param(
    [string]$Path = "."
)
Write-Host "ðŸ” Searching .tsx files in: $Path"
$tsxFiles = Get-ChildItem -Path $Path -Recurse -Include *.tsx
if (-not $tsxFiles) {
    Write-Host "âš ï¸ No .tsx files found."
    exit
}
foreach ($file in $tsxFiles) {
    Write-Host "ðŸ“ Checking: $($file.FullName)"
    $lines = Get-Content $file.FullName
    $changed = $false
    $newLines = @()
    foreach ($line in $lines) {
        if ($line -match 'style\s*=\s*{\s*\\\\%\\\\}') {
            Write-Host "âŒ Found invalid percentage style:"
            Write-Host $line -ForegroundColor Red
            $fixedLine = $line -replace 'style\s*=\s*{\s*\\\\%\\\\}', 'style={{ width: `${value}%` }}'
            Write-Host "âœ… Fixed to:"
            Write-Host $fixedLine -ForegroundColor Green
            $newLines += $fixedLine
            $changed = $true
        }
        else {
            $newLines += $line
        }
    }
    if ($changed) {
        $backupFile = $file.FullName + ".bak"
        Copy-Item $file.FullName $backupFile -Force
        Write-Host "ðŸ“¦ Backup saved: $backupFile"
        $newLines | Set-Content $file.FullName -Encoding UTF8
        Write-Host "âœ… Updated file written: $($file.FullName)"
    }
    else {
        Write-Host "âœ… No issues found in this file."
    }
    Write-Host ""
}
Write-Host "ðŸŽ¯ Scan and fix complete!"
