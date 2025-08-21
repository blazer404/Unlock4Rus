Write-Host "- Unloading modules..."

$modules = Get-ChildItem -Path "$PSScriptRoot\" -Recurse -Filter *.ps1 -ErrorAction Stop

$modules | ForEach-Object {
    Get-Module | Where-Object { $_.Name -like "*$( $_.Name )*" } | Remove-Module -Force -ErrorAction Stop
    Write-Host "  $( $_.Name )" -ForegroundColor Gray
}

