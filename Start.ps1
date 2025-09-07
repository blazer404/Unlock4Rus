using module ".\core\Autoloader.ps1"


function Main() {
    while ($true) {
        Clear-Host
        [LogoRenderer]::show()
        [MenuRenderer]::show()
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
    exit 0
}

function ProcessExit() {
    UnloadModules
    exit 0
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
        exit(10)
    }
    Write-Host "  Hosts file downloaded to `"$( $HOSTS_DST )`"" -ForegroundColor Green
}

function ConvertHosts([String]$mode) {
    Write-Host
    Write-Host "- Converting hosts file..."
    try {
        [HostsConverter]::new($HOSTS_DST, $STATIC_DNS_DST, $mode).convert()
    } catch {
        Write-Host "  Hosts file conversion failed!" -ForegroundColor Red
        Write-Host "  $( $_.Exception.Message )" -ForegroundColor Red
        Read-Host
        exit(20)
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
        exit(30)
    }
}

function Done() {
    Write-Host
    Write-Host "  Done! Press Any key to exit..." -ForegroundColor Cyan
    Read-Host
}


Main
