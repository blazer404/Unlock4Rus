$logo = @"

     __  __      __           __   __ __  ____
    / / / /___  / /___  _____/ /__/ // / / __ \__  _______
   / / / / __ \/ / __ \/ ___/ //_/ // /_/ /_/ / / / / ___/
  / /_/ / / / / / /_/ / /__/ ,< /__  __/ _, _/ /_/ (__  )
  \____/_/ /_/_/\____/\___/_/|_|  /_/ /_/ |_|\__,_/____/

                                          by blazer404
"@
Write-Host $logo -ForegroundColor DarkCyan


# Загрузка модулей
Write-Host
try {
    Import-Module "$PSScriptRoot\core\Autoloader.ps1" -Force -ErrorAction Stop
} catch {
    Write-Host "  Load modules failed!" -ForegroundColor Red
    Write-Host "  $( $_.Exception.Message )" -ForegroundColor Red
    Read-Host
    exit
}

# Скачивание блэклиста
Write-Host
Write-Host "- Downloading hosts file..."
try {
    [Downloader]::download($HOSTS_SRC, $HOSTS_DST)
} catch {
    Write-Host "  Hosts file download failed!" -ForegroundColor Red
    Write-Host "  $( $_.Exception.Message )" -ForegroundColor Red
    Read-Host
    exit
}
Write-Host "  Hosts file downloaded to `"$( $HOSTS_DST )`"" -ForegroundColor Green

# Конвертация блэклиста в нужный формат
Write-Host
Write-Host "- Converting hosts file..."
try {
    [Converter]::new($HOSTS_DST, $STATIC_DNS_DST).convert()
} catch {
    Write-Host "  Hosts file conversion failed!" -ForegroundColor Red
    Write-Host "  $( $_.Exception.Message )" -ForegroundColor Red
    Read-Host
    exit
}
Write-Host "  Hosts file converted to `"$( $STATIC_DNS_DST )`"" -ForegroundColor Green

# Выгрузка модулей
Write-Host
try {
    Import-Module "$PSScriptRoot\core\Unloader.ps1" -Force -ErrorAction Stop
} catch {
    Write-Host "  Unload modules failed!" -ForegroundColor Red
    Write-Host "  $( $_.Exception.Message )" -ForegroundColor Red
    Read-Host
    exit
}

# Jobs done!
Write-Host
Write-Host "  Done! Press Any key to exit..." -ForegroundColor Cyan
Read-Host
