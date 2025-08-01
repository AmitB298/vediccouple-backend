<#
.SYNOPSIS
  Automatically fix invalid style={{ width: \\%\ }} in React .tsx files.
.DESCRIPTION
  Replaces invalid backslash-escaped width style with valid CSS.
.PARAMETER Path
  Root folder to search for .tsx files.
.EXAMPLE
  .\Fix-ProgressBarWidthEscape.ps1 -Path "src"
#>
param(
    [string]$Path = "."
)
Write-Host "ðŸ”Ž Scanning for .tsx files in: $Path"
# Find all .tsx files
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
        # This regex detects the broken style with \\%\\ or similar backslash mess
        if ($line -match 'style\s*=\s*{\s*.*?\\+%\\+.*?}') {
            Write-Host "âŒ Found invalid style in:"
            Write-Host $line -ForegroundColor Red
            # Replace with static 100% width
            $fixedLine = $line -replace 'style\s*=\s*{\s*.*?\\+%\\+.*?}', 'style={{ width: ''100%'' }}'
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
        # Backup before overwrite
        $backupFile = $file.FullName + ".bak"
        Copy-Item $file.FullName $backupFile -Force
        Write-Host "ðŸ“¦ Backup saved to: $backupFile"
        # Write fixed file
        $newLines | Set-Content $file.FullName -Encoding UTF8
        Write-Host "âœ… Updated file written: $($file.FullName)"
    }
    else {
        Write-Host "âœ… No issues found in this file."
    }
    Write-Host ""
}
Write-Host "ðŸŽ¯ Scan and fix complete!"
