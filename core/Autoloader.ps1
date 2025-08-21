$modules = Get-ChildItem -Path "$PSScriptRoot\classes" -Filter *.ps1 -ErrorAction Stop

$modules | ForEach-Object {
    Get-Module | Where-Object { $_.Name -like "*$( $_.Name )*" } | Remove-Module -Force -ErrorAction Stop
    Import-Module $_.FullName -Force -ErrorAction Stop
    Write-Host "- Loading module `"$( $_.Name )`"" -ForegroundColor Gray
}
