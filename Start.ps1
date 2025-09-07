using module ".\core\Autoloader.ps1"


function Main() {
    while ($true) {
        Clear-Host
        [Logo]::show()
        [Menu]::show()
        $choice = Read-Host "`n- Enter your choice"
        switch ($choice) {
            "1" { ProcessHosts -mode "Unblock" }
            "2" { ProcessHosts -mode "Block" }
            "3" { ProcessHosts -mode "Both" }
            "q" { ProcessExit }
            Default { break }
        }
    }
}

function ProcessHosts([String]$mode) {
    DownloadHosts
    ConvertHosts -mode $mode
    UnloadModules
    Done
    exit
}

function ProcessExit() {
    UnloadModules
    exit
}

function DownloadHosts() {
    Write-Host
    Write-Host "- Downloading hosts file..."
    try {
        [Downloader]::download($HOSTS_SRC, $HOSTS_DST)
    } catch {
        Write-Host "  Hosts file download failed!" -ForegroundColor Red
        Write-Host "  $( $_.Exception.Message )" -ForegroundColor Red
        Read-Host
        break
    }
    Write-Host "  Hosts file downloaded to `"$( $HOSTS_DST )`"" -ForegroundColor Green
}

function ConvertHosts([String]$mode) {
    Write-Host
    Write-Host "- Converting hosts file..."
    try {
        [Converter]::new($HOSTS_DST, $STATIC_DNS_DST, $mode).convert()
    } catch {
        Write-Host "  Hosts file conversion failed!" -ForegroundColor Red
        Write-Host "  $( $_.Exception.Message )" -ForegroundColor Red
        Read-Host
        break
    }
    Write-Host "  Hosts file converted to `"$( $STATIC_DNS_DST )`"" -ForegroundColor Green
}

function UnloadModules() {
    Write-Host
    try {
        Import-Module "$PSScriptRoot\core\Unloader.ps1" -Force -ErrorAction Stop -Scope Global
    } catch {
        Write-Host "  Unload modules failed!" -ForegroundColor Red
        Write-Host "  $( $_.Exception.Message )" -ForegroundColor Red
        Read-Host
        break
    }
}

function Done() {
    Write-Host
    Write-Host "  Done! Press Any key to exit..." -ForegroundColor Cyan
    Read-Host
}


Main
