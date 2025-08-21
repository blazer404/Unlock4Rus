Write-Host "- Loading modules..."

$modules = Get-ChildItem -Path "$PSScriptRoot\classes" -Recurse -Filter *.ps1 -ErrorAction Stop

$modules | ForEach-Object {
    $exists = Get-Module -Name $_.BaseName -ErrorAction SilentlyContinue
    if ($exists) {
        Remove-Module -Name $_.BaseName -Force -ErrorAction Stop
    }
    Import-Module $_.FullName -Force -ErrorAction Stop
    # Write-Host "  $( $_.Name )" -ForegroundColor Gray
}
