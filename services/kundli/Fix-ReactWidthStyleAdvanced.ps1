<#
.SYNOPSIS
  Smarter fix for broken width style lines in .tsx files.
.DESCRIPTION
  Finds any 'style={{ width: ... }}' that doesn't use proper template string
  and rewrites it to: style={{ width: `${value}%` }}
.PARAMETER Path
  Root folder to search
.EXAMPLE
  .\Fix-ReactWidthStyleAdvanced.ps1 -Path "src"
#>
param(
    [string]$Path = "."
)
Write-Host "ðŸ” Advanced scan for .tsx files in: $Path"
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
        # Match any bad width style that is *not* already using `${}`
        if ($line -match 'style\s*=\s*{.*width.*%.*}') {
            if ($line -notmatch '`\$\{.*\}`') {
                Write-Host "âŒ Found invalid width style:"
                Write-Host $line -ForegroundColor Red
                # Replace it with correct style
                $fixedLine = $line -replace 'style\s*=\s*{.*}', 'style={{ width: `${value}%` }}'
                Write-Host "âœ… Fixed to:"
                Write-Host $fixedLine -ForegroundColor Green
                $newLines += $fixedLine
                $changed = $true
            }
            else {
                $newLines += $line
            }
        }
        else {
            $newLines += $line
        }
    }
    if ($changed) {
        $backupFile = $file.FullName + ".bak"
        Copy-Item $file.FullName $backupFile -Force
        Write-Host "ðŸ“¦ Backup saved to: $backupFile"
        $newLines | Set-Content $file.FullName -Encoding UTF8
        Write-Host "âœ… Updated file written: $($file.FullName)"
    }
    else {
        Write-Host "âœ… No issues found in this file."
    }
    Write-Host ""
}
Write-Host "ðŸŽ¯ Advanced scan and fix complete!"
