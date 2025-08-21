Write-Host
Write-Host -ForegroundColor Blue "     __  __      __           __   __ __  ____"
Write-Host -ForegroundColor Blue "    / / / /___  / /___  _____/ /__/ // / / __ \__  _______"
Write-Host -ForegroundColor Blue "   / / / / __ \/ / __ \/ ___/ //_/ // /_/ /_/ / / / / ___/"
Write-Host -ForegroundColor Blue "  / /_/ / / / / / /_/ / /__/ ,< /__  __/ _, _/ /_/ (__  )"
Write-Host -ForegroundColor Blue "  \____/_/ /_/_/\____/\___/_/|_|  /_/ /_/ |_|\__,_/____/"
Write-Host
Write-Host -ForegroundColor Blue "                                          by blazer404"

# Загрузка модулей
Write-Host
try {
    Import-Module "$PSScriptRoot\core\Autoloader.ps1" -Force -ErrorAction Stop
} catch {
    Write-Host "  Load modules failed!" -ForegroundColor Red
    Write-Host "  $( $_.Exception.Message )" -ForegroundColor Red
    exit
}

# Скачивание блэклиста
Write-Host
Write-Host "- Downloading hosts file..."
try {
    [Downloader]::download($HOSTS_SOURCE, $HOSTS_DESTINATION)
} catch {
    Write-Host "  Hosts file download failed!" -ForegroundColor Red
    Write-Host "  $( $_.Exception.Message )" -ForegroundColor Red
    exit
}
Write-Host "  Hosts file downloaded to `"$( $HOSTS_DESTINATION )`"" -ForegroundColor Green

# Конвертация блэклиста в нужный формат
Write-Host
Write-Host "- Converting hosts file..."
try {
    [Converter]::new($HOSTS_DESTINATION, $MTK_HOSTS_DESTINATION).convert()
} catch {
    Write-Host "  Hosts file conversion failed!" -ForegroundColor Red
    Write-Host "  $( $_.Exception.Message )" -ForegroundColor Red
    exit
}
Write-Host "  Hosts file converted to `"$( $MTK_HOSTS_DESTINATION )`"" -ForegroundColor Green

# Jobs done!
Write-Host
Write-Host "Done! Press Any key to exit..." -ForegroundColor Cyan
Read-Host
